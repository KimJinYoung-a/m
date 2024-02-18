<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/chaipay/incchaipayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%

Dim vRdsite, vQuery, vAppLink
Dim return_paymentId, return_idempotencyKey, return_status
Dim chaiTokenId, chaiTempIdx

'// 차이에서 결제 생성 후 값이 넘어 오면 처리해야 되는 순서
' 1. queryparameter 유효성 체크
' 2. status에 따른 처리
'   - approved로 넘어올 경우 승인 api 호출하여 결제 처리
'   - confirmed로 넘어올 경우 승인 api 호출이 되서 결제 처리가 되었다는 소리 이므로 
'     우리쪽에서 실 DB에 저장이 되어 있는지 확인하고 이상없으면 결제 완료페이지로 넘김
'   - user_canceled로 넘어올 경우 사용자가 취소했다는 것이기 때문에 취소 처리(차이는 toss나 기타 다른 pay류 처럼 fail 전용 페이지 안만들고 여기서 처리)
'   - failed로 넘어올 경우 이유를 알 수 없는 실패인 경우이니 결제 실패 alert 띄우고 userinfo.asp로 넘김
' 3. 유효성 검사(order_temp)
' 4. 임시 장바구니 값 업데이트
' 5. 결제 승인 API 호출 후 승인 성공, 실패에 따른 분기 처리
' 6. 실패하면 다시 userinfo로 보내고 성공이면 실 DB에 저장
'   - 여기서 고민.. 실 DB에 저장할때 다시 차이 주문 조회를 통해 한번 더 체크 할 것인가??
'   - 고민2.. queryparameter로 status값이 confirm으로 갑자기 넘어오면?? 어떻게 처리 할 것인가??
' 7. 결제 완료 페이지로 이동시킴


'차이에서 결제 처리후 Query Parameter로 3가지의 값이 넘어온다.(paymentId, idempotencyKey, status)
return_paymentId        = Request("paymentId")      '// 차이에서 보내준 결제 고유 번호
return_idempotencyKey   = Request("idempotencyKey") '// 텐바이텐에서 보낸 주문번호(텐바이텐 임시 주문번호)
return_status           = Request("status")         '// 결제 상태 값

'///////////////// 차이에서 넘겨주는 결제 상태값 정의/////////////////////////////////////////////////////
'approved - 사용자가 결제를 승인한 상태, 텐바이텐에서 결제 승인 API를 호출하기 전(즉, 결제 승인 되기 전)
'confirmed - 이미 결제가 완료된 상태, 즉 텐바이텐에서 결제 승인 API를 호출 후 승인이 난 상태
'user_canceled - 결제 진행 중 사용자가 결제를 취소한 상태.
'failed - 결제 진행 중 여러가지 이유로 결제에 실패한 상태.
'/////////////////////////////////////////////////////////////////////////////////////////////////////////

'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localm.10x10.co.kr"
End If

'차이에 있는 주문접수 정보를 확인하기 위해 TID값을 가져온다.
'임시주문 정보 접수 rdsite 별로 분기.=======================================
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & return_idempotencyKey & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
    chaiTokenId     = rsget("P_TID")
    chaiTempIdx     = rsget("temp_idx")
END IF
rsget.close

SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
    Case Else : vAppLink = ""
End SELECT

'// QueryParameter 유효성 체크 : payment가 생성되지 않으면 paymentId, idempotencyKey가 넘어오지 않는다. 튕겨냄
If trim(return_paymentId)="" Or trim(return_idempotencyKey)="" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If

'// chaiStatus체크(사용자가 결제 진행 중 취소 하였을 시)
If trim(return_status)="user_canceled" Then
    '// 임시 주문쪽에 사용자 취소 상태값을 업데이트 한다.
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    vQuery = vQuery & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (취소 등)
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'결제 중 사용자 취소') " & VbCRLF		'실패사유
    vQuery = vQuery & " WHERE temp_idx = '" & chaiTempIdx & "'"                                  '' P_NOTI is temp_idx
    dbget.execute vQuery

    response.write "<script>alert('결제가 취소되었습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
End If

'// chaiStatus체크(사용자 취소 이외의 결제에 실패한 경우)
'// 사용자 취소 이외의 order_temp에 failed로 값이 들어가 있을 경우엔 실패 사유를 차이 대시보드에서 임시 주문 번호로 검색하여 알 수 있다.
If trim(return_status)="failed" Then
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    vQuery = vQuery & " SET P_STATUS = 'F01' " & VbCRLF		'결제 실패
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & return_status & "') " & VbCRLF		'실패사유
    vQuery = vQuery & " WHERE temp_idx = '" & chaiTempIdx & "'"                                  '' P_NOTI is temp_idx
    dbget.execute vQuery

    response.write "<script>alert('결제에 실패하였습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
End If

'' 0. 동일한 차이 결제번호가 있는지 확인
vQuery = "Select top 1 P_STATUS From [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & chaiTempIdx & "' and P_TID='" & chaiTokenId & "' order by temp_idx desc"
rsget.Open vQuery,dbget,1
IF Not rsget.EOF THEN
	if rsget("P_STATUS")<>"S01" then
		response.write "<script>alert('중복된 주문입니다. 확인해 주세요.[EC02] ')</script>"
		response.write "<script>location.replace('" & M_SSLUrl&vAppLink & "/inipay/userinfo.asp')</script>"
		response.end
	end if
else
	response.write "<script>alert('주문 또는 결제정보가 잘못되었습니다. 다시 시도해 주세요.[EC01]')</script>"
	response.write "<script>location.replace('" & M_SSLUrl&vAppLink & "/inipay/userinfo.asp')</script>"
	response.end
end if
rsget.Close

'// chaiStatus체크
If trim(return_status) <> "approved" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If

'' 유효성 검사
Dim retChkOK, oshoppingbag, iErrStr, ireserveParam 
iErrStr = ""
retChkOK = fnCheckOrderTemp(chaiTempIdx, oshoppingbag,iErrStr, ireserveParam, "CH")

if NOT(retChkOK) then
    response.write "<script>alert('처리중 오류가 발생하였습니다.\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>location.replace('" & M_SSLUrl&vAppLink & "/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
end if

if (oshoppingbag is Nothing) then
    response.write "<script>alert('처리중 오류가 발생하였습니다..\r\n- "&replace(iErrStr,"'","")&"');</script>"
    response.write "<script>location.replace('" & M_SSLUrl&vAppLink & "/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
end if


''201712 임시장바구니 변경. :: 결제수단 저장 필요..
dim iorderserial
iErrStr = ""
iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(chaiTempIdx, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"

    ''2015/08/16 수정
	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','주문저장중오류(승인이전_moCH) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
	'dbget.Execute vQuery

	response.end
end if

'-----------------------------------------------------------------------------
' 처리 결과가 정상이면 차이에 인증 받았던 정보로 결제 승인을 요청
'-----------------------------------------------------------------------------
Dim orderConfirmData, orderTotalAmount, paySucess, rstJson, ConResult, payMethod, QueryW
Dim return_message, return_errorCode, return_errorType


orderTotalAmount = "" '// 차이 결제예약시 넘겨준 현 주문의 총 주문금액값(필수값 아님)
QueryW = "" '// TempOrder 테이블에 업데이트 할 쿼리값
paySucess = False

'---------------------------------------------------------------------------------
' 결제 전 차이에 결제 대기로 들어가 있는 상태 확인
'---------------------------------------------------------------------------------
'conResult = chaiapi_ordercheck("", chaiTokenId, chaiTempIdx)
'response.write conResult
'response.end

'---------------------------------------------------------------------------------
' 차이로 결제 승인 내역을 전송(json)
'---------------------------------------------------------------------------------
orderConfirmData = ""
conResult = chaiapi_order_confirm(orderConfirmData, chaiTokenId, chaiTempIdx)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if CStr(rstJson.data("status")) = "confirmed" then
    '// 결제상태 값 변경
    paySucess = True

    '// 승인성공
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'S02' " & VbCRLF		'승인성공
	vQuery = vQuery & " , PayResultCode = 'ok' " & VbCRLF
	vQuery = vQuery & " WHERE temp_idx = '" & chaiTempIdx & "'"
	dbget.execute vQuery    

    '// 차이는 2020-04-22 현재 차이에 충전된 금액으로만 결제시키므로 실시간 계좌이체로만 설정함.
    payMethod = "20"

    '결제형태 구분값 저장
	QueryW = QueryW & " , Tn_paymethod = '"&payMethod&"'" & VbCRLF

    '할인금액이 있으면 할인금액값 저장
    If CStr(rstJson.data("discountAmount")) <> "" Then
	    QueryW = QueryW & " , pDiscount="& CLng(rstJson.data("discountAmount")) &"" &VBCRLF ''차이 할인금액
    End If

    '차이 충전 금액(잔여 포인트 부족시)이 있으면 충전 금액값 저장
    If CStr(rstJson.data("chargingAmount")) <> "" Then
	    QueryW = QueryW & " , pDiscount2="& CLng(rstJson.data("chargingAmount")) &"" &VBCRLF ''차이 충전 금액
    End If

    '카드결제시에만 넘어오는값(2020-04-22 기준 카드 결제는 사용안함)
    'If trim(CStr(rstJson.data("payMethod"))) = "CARD" Then
        '카드승인번호가 있을시에만 입력
    '    If CStr(rstJson.data("cardAuthorizationNo")) <> "" Then
    '        QueryW = QueryW & " , P_AUTH_NO = convert(varchar(50),'" & CStr(rstJson.data("cardAuthorizationNo")) & "')" &VBCRLF
    '    End If

        '할부개월수가 있을시에만 입력
    '    If CStr(rstJson.data("spreadOut")) <> "" Then
    '        QueryW = QueryW & " , P_RMESG2 = convert(varchar(500),'" & CStr(rstJson.data("spreadOut")) & "')" &VBCRLF			''할부개월수로사용.        
    '    End If
    'End If

    '// 추가 데이터를 넣는 공간인데 차이는 딱히 넣을게 없음
    'QueryW = QueryW & " , pAddParam = '" & CStr(rstJson.data("transactionId")) & "' " &VBCRLF
  
	'// 결제 확인 성공 저장
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = '00'" &VBCRLF					'무조건 성공은 "00"!!
	vQuery = vQuery & QueryW
    vQuery = vQuery & " WHERE temp_idx = '" & chaiTempIdx & "'"
	dbget.execute vQuery
Else
    return_message      = rstJson.data("message") '// 응답이 성공이 아닐경우 보내주는 설명 메시지
    return_errorCode    = rstJson.data("error_code") '// 응답이 실패할경우 보내주는 에러코드
    return_errorType    = rstJson.data("error_type") '// 응답이 실패할경우 보내주는 에러타입

    '// 승인실패
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'F02' " & VbCRLF		'승인 실패
	vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & replace(return_errorType&"-"&return_errorCode &":"&return_message,"'","") & "') " & VbCRLF		'실패사유
	vQuery = vQuery & " , Tn_paymethod = '100'"  ''결제방식 실패시 카드로 넣음 
	vQuery = vQuery & " WHERE temp_idx = '" & chaiTempIdx & "'"
	dbget.execute vQuery

    'Response.write "<script type='text/javascript'>alert('"&rstJson.data("msg")&"');</script>"
    'response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/userinfo.asp');</script>"
	'dbget.close()
    'response.end    
End If
Set rstJson = Nothing

'' 3. 실 주문정보 저장 
Dim vResult, vIsSuccess
iErrStr = ""

'// 실 DB 저장
Call oshoppingbag.SaveOrderResultDB_TmpBaguni(chaiTempIdx, payMethod, iErrStr, vResult, vIsSuccess)

if (iErrStr<>"") then
    response.write iErrStr
    Response.write "<script type='text/javascript'>alert('04. 주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/userinfo.asp');</script>"
	dbget.close()
    response.end
end if


On Error resume Next
dim osms, helpmail
helpmail = oshoppingbag.GetHelpMailURL

IF (vIsSuccess) THEN
    call sendmailorder(iorderserial,helpmail)

    set osms = new CSMSClass
	osms.SendJumunOkMsg ireserveParam.FBuyhp, iorderserial
    set osms = Nothing

end if
on Error Goto 0

response.Cookies("shoppingbag").domain = "10x10.co.kr"
response.Cookies("shoppingbag")("before_orderserial") = iorderserial


if (vIsSuccess) then
	response.Cookies("shoppingbag")("before_issuccess") = "true"
else
	response.Cookies("shoppingbag")("before_issuccess") = "false"
end if

dim dumi : dumi=TenOrderSerialHash(iorderserial)

''비회원인 경우 orderserial-uk 값 저장. 2017/10/23 require commlib

IF (vResult = "ok") and (ireserveParam.FUserID="") then
    Call fnUserLogCheck_AddGuestOrderserial_UK(iorderserial,request.Cookies("shoppingbag")("GSSN")) 
end if

'' 4. 현금 영수증 대상 금액 확인(차이는 무조건 현금영수증 대상금액이라 해당 코드는 사용안함)
''    - 실시간계좌 이체이면서 현금영수증 발급 신청을 한경우에 한함
'if paySuccess and vCashreceiptreq="Y" then				'and payMethod="BANK"
'end if

SET ireserveParam = Nothing
SET oshoppingbag  = Nothing
%>
<script type="text/javascript">
    setTimeout(function(){
        try{
            window.location.replace("<%=M_SSLUrl&vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>");
        }catch(ss){
            location.href="<%=vAppLink%>/inipay/DisplayOrder.asp?dumi=<%=dumi%>";
        }
    },200);
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
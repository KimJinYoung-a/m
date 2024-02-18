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
<!-- #include virtual="/inipay/tosspay/inctosspayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%

'토스에서 결제 처리후 던져주는 값을 받는다.
Dim temp_idx, vIdx, tossStatus, tossPayMethod, tossTokenId, vRdsite, vQuery

temp_idx = Request("orderNo") '// 텐바이텐에서 order_temp에 저장한 temp_idx값
tossPayMethod = Request("payMethod") '// 토스에서 사용자가 결제할때 사용한 결제타입(토스머니 or 카드)
tossStatus = Request("status") '// 토스에서 결제 상태에 대한 status값
vIdx = Replace(temp_idx, "temp","")

'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localm.10x10.co.kr"
End If

'토스에 있는 주문접수 정보를 확인하기 위해 TID값을 가져온다.
'임시주문 정보 접수 rdsite 별로 분기.=======================================
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
    tossTokenId        = rsget("P_TID")
END IF
rsget.close

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
    Case Else : vAppLink = ""
End SELECT

'// tossStatus체크
If trim(tossStatus) <> "PAY_APPROVED" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If

'// tossTokenId값 체크
If trim(tossTokenId) = "" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink &"/inipay/userinfo.asp');</script>"
    response.end
End If

'' 0. 동일한 토스 결제번호가 있는지 확인
vQuery = "Select top 1 P_STATUS From [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & vIdx & "' and P_TID='" & tossTokenId & "' order by temp_idx desc"
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

'' 유효성 검사
Dim retChkOK, oshoppingbag, iErrStr, ireserveParam 
iErrStr = ""
retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "TS")

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
iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(vIdx, iErrStr)

if (iErrStr<>"") then
    response.write iErrStr
    response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"

    ''2015/08/16 수정
	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','주문저장중오류(승인이전_moTS) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
	'dbget.Execute vQuery

	response.end
end if

'-----------------------------------------------------------------------------
' 처리 결과가 정상이면 토스에 인증 받았던 정보로 결제 승인을 요청
'-----------------------------------------------------------------------------
Dim orderConfirmData, orderTotalAmount, paySucess, rstJson, ConResult, payMethod, QueryW

orderTotalAmount = "" '// 토스 결제예약시 넘겨준 현 주문의 총 주문금액값(필수값 아님)
QueryW = "" '// TempOrder 테이블에 업데이트 할 쿼리값
paySucess = False

'---------------------------------------------------------------------------------
' 결제 전 토스에 결제 대기로 들어가 있는 상태 확인
'---------------------------------------------------------------------------------
'conResult = tossapi_ordercheck("{""apiKey"":"""&CStr(TossPay_RestApi_Key)&""",""payToken"":"""&CStr(tossTokenId)&""}")
'response.write conResult
'response.end

'---------------------------------------------------------------------------------
' 구매 상품을 변수에 셋팅 ( json으로 전송 )
'---------------------------------------------------------------------------------
'orderConfirmData = "apiKey="&CStr(TossPay_RestApi_Key) '// 가맹점코드
'orderConfirmData = orderConfirmData &"&payToken="&CStr(tossTokenId) '// 주문예약시 토스에서 받은 payToken값
'orderConfirmData = orderConfirmData &"&orderNo="&Server.URLEncode(CStr("temp"&vIdx)) '// 주문번호(여기선 실제 주문번호가 아닌 임시 주문번호를 던져줌)
orderConfirmData = "{"
orderConfirmData = orderConfirmData &"""apiKey"":"""&CStr(TossPay_RestApi_Key)&""""
orderConfirmData = orderConfirmData &",""payToken"":"""&CStr(tossTokenId)&""""
orderConfirmData = orderConfirmData &",""orderNo"":"""&CStr("temp"&vIdx)&""""
orderConfirmData = orderConfirmData &"}"

'// 토스로 결제승인 내역을 전송
conResult = tossapi_order_confirm(orderConfirmData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if CStr(rstJson.data("code")) = "0" then
    '// 결제상태 값 변경
    paySucess = True

    '// 승인성공
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'S02' " & VbCRLF		'승인성공
	vQuery = vQuery & " , PayResultCode = 'ok' " & VbCRLF
	vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery    

    '결제형태가 Card면 카드(100), TOSS_MONEY면 실시간계좌이체(20)으로 설정
    If trim(CStr(rstJson.data("payMethod"))) = "CARD" Then
        payMethod = "100"
    ElseIf trim(CStr(rstJson.data("payMethod"))) = "TOSS_MONEY" Then
        payMethod = "20"
    Else
        payMethod = ""
    End If

    '결제형태 구분값 저장
	QueryW = QueryW & " , Tn_paymethod = '"&payMethod&"'" & VbCRLF ''카드결제

    '할인금액이 있으면 할인금액값 저장
    If CStr(rstJson.data("discountedAmount")) <> "" Then
	    QueryW = QueryW & " , pDiscount="& CLng(rstJson.data("discountedAmount")) &"" &VBCRLF ''토스 할인금액
    End If

    '포인트사용 금액이 있으면 포인트 사용 금액값 저장
    If CStr(rstJson.data("paidPoint")) <> "" Then
	    QueryW = QueryW & " , pDiscount2="& CLng(rstJson.data("paidPoint")) &"" &VBCRLF ''토스 포인트 사용금액
    End If

    '카드결제시에만 넘어오는값
    If trim(CStr(rstJson.data("payMethod"))) = "CARD" Then
        '카드승인번호가 있을시에만 입력
        If CStr(rstJson.data("cardAuthorizationNo")) <> "" Then
            QueryW = QueryW & " , P_AUTH_NO = convert(varchar(50),'" & CStr(rstJson.data("cardAuthorizationNo")) & "')" &VBCRLF
        End If

        '할부개월수가 있을시에만 입력
        If CStr(rstJson.data("spreadOut")) <> "" Then
            QueryW = QueryW & " , P_RMESG2 = convert(varchar(500),'" & CStr(rstJson.data("spreadOut")) & "')" &VBCRLF			''할부개월수로사용.        
        End If
    End If

    QueryW = QueryW & " , pAddParam = '" & CStr(rstJson.data("transactionId")) & "' " &VBCRLF ''토스 결제 트랜젝션 코드(매출전표 호출용 또는 환불 진행 시 구분 값)
  
	'// 결제 확인 성공 저장
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] " &VBCRLF
    vQuery = vQuery & " SET P_STATUS = '00'" &VBCRLF					'무조건 성공은 "00"!!
	vQuery = vQuery & QueryW
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery
Else
    '// 승인실패
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'F02' " & VbCRLF		'승인 실패
	vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & replace(rstJson.data("errorCode")&"-"&rstJson.data("msg"),"'","") & "') " & VbCRLF		'실패사유
	vQuery = vQuery & " , Tn_paymethod = '100'"  ''결제방식 실패시 카드로 넣음 
	vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
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
Call oshoppingbag.SaveOrderResultDB_TmpBaguni(vIdx, payMethod, iErrStr, vResult, vIsSuccess)

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

'' 4. 현금 영수증 대상 금액 확인(페이코는 현금 영수증 대상 금액이 아님 하지만 일단 모르니 남겨둠)
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
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
<!-- #include virtual="/inipay/kakaoapi/incKakaopayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%

'카카오에서 결제 처리후 던져주는 temp_idx값과 pg_token값을 받는다.
Dim temp_idx, kakao_PgToken, vRdsite, vQuery, kakaoTid, vIdx

temp_idx = Request("tempidx") '// 텐바이텐에서 order_temp에 저장한 temp_idx값
kakao_PgToken = Request("pg_token") '// 카카오에서 결제처리후 던져주는 token값

vIdx = Replace(temp_idx, "temp","")

'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localhost:11117"
End If

'// temp_idx체크
If trim(temp_idx) = "" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If

'카카오에 있는 주문접수 정보를 확인하기 위해 TID값을 가져온다.
'임시주문 정보 접수 rdsite 별로 분기.=======================================
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
    kakaoTid        = rsget("P_TID")
END IF
rsget.close

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
    Case Else : vAppLink = ""
End SELECT

'// kakaoTid값 체크
If trim(kakaoTid) = "" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink &"/inipay/userinfo.asp');</script>"
    response.end
End If

'' 0. 동일한 카카오 결제번호가 있는지 확인
vQuery = "Select top 1 P_STATUS From [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & vIdx & "' and P_TID='" & kakaoTid & "' order by temp_idx desc"
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
retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "KK")

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
	'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','주문저장중오류(승인이전_moKK) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
	'dbget.Execute vQuery

	response.end
end if

'-----------------------------------------------------------------------------
' 처리 결과가 정상이면 카카오페이에 인증 받았던 정보로 결제 승인을 요청
'-----------------------------------------------------------------------------
Dim orderConfirmData, kakaoPayLoad, orderTotalAmount, paySucess, rstJson, ConResult, payMethod, QueryW

kakaoPayLoad = "" '// 카카오페이 승인 요청 시 우리쪽에서 저장하고 싶은 값(필수값 아님)
orderTotalAmount = "" '// 카카오페이 결제예약시 넘겨준 현 주문의 총 주문금액값(필수값 아님)
QueryW = "" '// TempOrder 테이블에 업데이트 할 쿼리값
paySucess = False
'---------------------------------------------------------------------------------
' 구매 상품을 변수에 셋팅 ( x-www-form-urlencoded 으로 전송 )
'---------------------------------------------------------------------------------
orderConfirmData = "cid="&Server.URLEncode(CStr(KakaoPay_Cid)) '// 가맹점코드
If trim(KakaoPay_Cid_Secret) <> "" Then
    orderConfirmData = orderConfirmData &"&cid_secret="&Server.URLEncode(CStr(KakaoPay_Cid_Secret)) '// 가맹점 코드 인증키, 24자 숫자+영문 소문자(필수값 아님)
End If
orderConfirmData = orderConfirmData &"&tid="&Server.URLEncode(CStr(kakaoTid)) '// Tid 주문예약시 카카오페이로부터 발급받은 TID값
orderConfirmData = orderConfirmData &"&partner_order_id="&Server.URLEncode(CStr("temp"&vIdx)) '// 주문번호(여기선 실제 주문번호가 아닌 임시 주문번호를 던져줌)
If Trim(GetLoginUserID)="" Then
    orderConfirmData = orderConfirmData &"&partner_user_id="&Server.URLEncode(CStr(GetGuestSessionKey)) '// 사용자 아이디(비회원)
Else
    orderConfirmData = orderConfirmData &"&partner_user_id="&Server.URLEncode(CStr(GetLoginUserID)) '// 사용자 아이디(회원)
End If
orderConfirmData = orderConfirmData &"&pg_token="&Server.URLEncode(CStr(kakao_PgToken)) '// 카카오톡에서 결제 처리 후 전송해준 token값
If Trim(kakaoPayLoad)<>"" Then
    orderConfirmData = orderConfirmData &"&payload="&Server.URLEncode(CStr(kakaoPayLoad)) '// 카카오페이 승인 요청 시 우리쪽에서 저장하고 싶은 값(필수값 아님)
End If
If Trim(orderTotalAmount)<>"" Then
    orderConfirmData = orderConfirmData &"&payload="&Server.URLEncode(kakaoPayLoad) '// 카카오페이 결제예약시 넘겨준 현 주문의 총 주문금액값(필수값 아님)
End If

'// 카카오톡으로 결제승인 내역을 전송
conResult = kakaoapi_order_confirm(orderConfirmData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if rstJson.data("tid") <> "" then

    '// 결제상태 값 변경
    paySucess = True

    '// 승인성공
	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
	vQuery = vQuery & " SET P_STATUS = 'S02' " & VbCRLF		'승인성공
	vQuery = vQuery & " , PayResultCode = 'ok' " & VbCRLF
	vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery    

    '결제형태가 Card면 카드(100), Money면 실시간계좌이체(20)으로 설정
    If trim(CStr(rstJson.data("payment_method_type"))) = "CARD" Then
        payMethod = "100"
    ElseIf trim(CStr(rstJson.data("payment_method_type"))) = "MONEY" Then
        payMethod = "20"
    Else
        payMethod = ""
    End If

    '결제형태 구분값 저장
	QueryW = QueryW & " , Tn_paymethod = '"&payMethod&"'" & VbCRLF ''카드결제

    '할인금액이 있으면 할인금액값 저장
    If CStr(rstJson.data("amount").item("discount")) <> "" Then
	    QueryW = QueryW & " , pDiscount="& CLng(rstJson.data("amount").item("discount")) &"" &VBCRLF ''카카오페이 할인금액
    End If

    '포인트사용 금액이 있으면 포인트 사용 금액값 저장
    If CStr(rstJson.data("amount").item("point")) <> "" Then
	    QueryW = QueryW & " , pDiscount2="& CLng(rstJson.data("amount").item("point")) &"" &VBCRLF ''카카오페이 포인트 사용금액
    End If

    '카드결제시에만 넘어오는값
    If trim(CStr(rstJson.data("payment_method_type"))) = "CARD" Then
        '카드승인번호가 있을시에만 입력
        If CStr(rstJson.data("card_info").item("approved_id")) <> "" Then
            QueryW = QueryW & " , P_AUTH_NO = convert(varchar(50),'" & CStr(rstJson.data("card_info").item("approved_id")) & "')" &VBCRLF
        End If

        '할부개월수가 있을시에만 입력
        If CStr(rstJson.data("card_info").item("install_month")) <> "" Then
            QueryW = QueryW & " , P_RMESG2 = convert(varchar(500),'" & CStr(rstJson.data("card_info").item("install_month")) & "')" &VBCRLF			''할부개월수로사용.        
        End If
    End If

    QueryW = QueryW & " , pAddParam = '" & CStr(rstJson.data("aid")) & "' " &VBCRLF ''카카오페이 Request 고유번호
  
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
	vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & replace(rstJson.data("message"),"'","") & "') " & VbCRLF		'실패사유
	vQuery = vQuery & " , Tn_paymethod = '100'"  ''결제방식 실패시 카드로 넣음 
	vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery

'    Response.write "<script type='text/javascript'>alert('04. 주문 처리 과정중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');</script>"
'    response.write "<script>location.replace('"&M_SSLUrl&vAppLink&"/inipay/userinfo.asp');</script>"
'	dbget.close()
'    response.end    
End If
Set rstJson = Nothing

'' 3. 실 주문정보 저장 
Dim vResult, vIsSuccess
iErrStr = ""

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
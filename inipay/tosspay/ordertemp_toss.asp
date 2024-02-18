<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
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
'response.write "<script>alert('죄송합니다. 토스 결제 잠시 점검중입니다.');history.back();</script>"
'response.end

Dim vQuery, vQuery1
Dim sqlStr

'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localm.10x10.co.kr"
End If

'// 앱일경우엔 앱경로 넣어준다.
Dim vAppLink : vAppLink =""
If isApp="1" Then
	vAppLink = "/apps/appCom/wish/web2014"
End If

Dim vIDx, iErrMsg, ipgGubun, tempIdxVal
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = "TS" '' 토스 구분값
vIdx 	= ""

vIDx = fnSaveOrderTemp(TossPay_RestApi_Key, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

if (vIDx<1) then
    response.write "ERR2:처리중 오류가 발생하였습니다.- "&iErrMsg&""
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & replace(iErrMsg,"'","") & ")')</script>"
	response.write "<script>location.replace('" & M_SSLUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

if (irefPgParam is Nothing) then
    response.write "ERR2:처리중 오류가 발생하였습니다"
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(ERR2)')</script>"
	response.write "<script>location.replace('" & M_SSLUrl & vAppLink & "/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

''======================================================================================================================
'' 토스 전송 처리
''======================================================================================================================
Dim returnUrlParam, extraData, orderData, tossSendGoodCnt, tempProductDesc

If irefPgParam.Fgoodcnt > 1 Then
    tossSendGoodCnt = irefPgParam.Fgoodcnt - 1 '// 상품 주문 갯수
End If

'// 토스의 경우 상품 설명(상품명)을 넘길 수 있는데 백슬래시(\)와 따옴표(", '), 탭문자를 넣을 수 없으며 총 255자 이내여야 함.
tempProductDesc = replace(irefPgParam.Fgoodname, "\","")
tempProductDesc = replace(tempProductDesc, """","")
tempProductDesc = replace(tempProductDesc, "'","")
tempProductDesc = replace(tempProductDesc, chr(9),"")

'---------------------------------------------------------------------------------
' 구매 상품을 변수에 셋팅 ( json 으로 전송 )
'---------------------------------------------------------------------------------
orderData = "{"
orderData = orderData &"""apiKey"":"""&CStr(TossPay_RestApi_Key)&"""" '// 가맹점코드
orderData = orderData &",""orderNo"":"""&CStr("temp"&vIdx)&"""" '// 주문번호(여기선 실제 주문번호가 아닌 임시 주문번호를 던져줌)
If irefPgParam.Fgoodcnt > 1 Then
    orderData = orderData &",""productDesc"":"""&CStr(tempProductDesc&" 외 "&tossSendGoodCnt&"건")&"""" '// 상품명(해당 주문에 여러개의 상품일 경우)
Else
    orderData = orderData &",""productDesc"":"""&CStr(tempProductDesc)&"""" '// 상품명(주문에 상품이 1건일 경우)
End If
orderData = orderData &",""retUrl"":"""&CStr(TossPay_OrderSuccess_Url)&"""" '// 결제준비 완료 후 이동할 URL
orderData = orderData &",""retCancelUrl"":"""&CStr(TossPay_OrderCancel_Url)&"?tempidx="&"temp"&vIdx&"""" '// 사용자가 결제 취소시 이동할 URL
If (isApp="1") then
    orderData = orderData &",""retAppScheme"":"""&CStr("tenwishapp://")&"""" '// IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL (app일 경우 deep link 입력. ex) tenwishapp://url)
End If
orderData = orderData &",""autoExecute"":false" '// 자동 승인 여부 설정(텐바이텐은 자동승인 false로 설정)
orderData = orderData &",""resultCallback"":""""" '// 토스에서 결제 승인이 된 후 처리하는 callback(텐바이텐은 자동 승인 여부가 false라 사용하지 않음)
orderData = orderData &",""amount"":"&irefPgParam.FPrice '// 총 금액
orderData = orderData &",""amountTaxFree"":0" '// 상품 비과세 금액(면세 금액은 0원으로 설정)
'orderData = orderData &",""amountTaxable"":" '// 상품 과세 금액(값 안던지면 자동으로 계산해줌)
'orderData = orderData &",""amountVat"":" '// 부가세(값 안던지면 자동으로 계산해줌)
'orderData = orderData &",""amountServiceFee"":" '// 결제 금액중 봉사료(사용안함)
'orderData = orderData &",""expiredTime"":""""" '// 결제 만료 기한(기본값 15분, 최대 1시간 설정 가능)YYYY-MM-DD HH:MM:SS
If Trim(TossPay_Payment_Method_Type) <> "" Then
    orderData = orderData &",""enablePayMethods"":"""&CStr(TossPay_Payment_Method_Type)&"""" '// 결제수단 구분변수
End If
If Trim(TossPay_CashReceipt) <> "" Then
    orderData = orderData &",""cashReceipt"":"&CStr(TossPay_CashReceipt)&"" '// 현금영수증 발급 가능 여부
End If
If Trim(TossPay_CashReceiptOption) <> "" Then
    orderData = orderData &",""cashReceiptTradeOption"":" '// 현금영수증 발급타입(사용안함)
End If
orderData = orderData &",""metadata"":"""&CStr("temp"&vIdx)&"""" '// 메타데이터(필요한값을 보냄 여기선 일단 tempidx값을 보내봄)
If Trim(TossPay_Available_Cards) <> "" Then
    orderData = orderData &",""cardOptions"":"""&CStr("{""options"":"""&TossPay_Available_Cards&"""}")&"""" '// 결제창에 특정카드 노출 여부
End If
orderData = orderData &"}"

'---------------------------------------------------------------------------------
' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
'---------------------------------------------------------------------------------
Dim rstJson, ConResult, return_code, return_checkoutPage, return_payToken, return_msg, return_errorCode

'// 토스로 구매상품 내역을 전송
conResult = tossapi_reserve(orderData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if CStr(rstJson.data("code")) = "0" Then
    return_code         = rstJson.data("code") '// 토스에서 리턴해준 응답코드(0 : 성공, -1 : 실패)
    return_checkoutPage = rstJson.data("checkoutPage") '// 토스에서 리턴해준 결제를 진행하는 웹페이지(이 페이지로 보내야함)
    return_payToken     = rstJson.data("payToken") '// 토스에서 리턴해준 결제토큰
    return_msg          = rstJson.data("msg") '// 응답이 성공이 아닐경우 보내주는 설명 메시지
    return_errorCode    = rstJson.data("errorCode") '// 응답이 실패할경우 보내주는 에러코드

    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_TID = '" & return_payToken & "'" & VbCRLF
    sqlStr = sqlStr & " , P_STATUS = 'S01' " & VbCRLF		'인증 성공(승인 전단계)    
    sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
    dbget.execute sqlStr
Else
    return_msg          = rstJson.data("msg") '// 응답이 성공이 아닐경우 보내주는 설명 메시지
    return_errorCode    = rstJson.data("errorCode") '// 응답이 실패할경우 보내주는 에러코드

    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (여기선 오류 등)
    sqlStr = sqlStr & " , P_RMESG1 = convert(varchar(500),'" & return_errorCode&"-"&return_msg & "') " & VbCRLF		'실패사유
    sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
    dbget.execute sqlStr

    response.write "<script>alert('처리중 오류가 발생했습니다.\n("&rstJson.data("code")&")');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
End if

Set rstJson = Nothing
Set irefPgParam = Nothing

'---------------------------------------------------------------------------------
' 토스 결제화면으로 이동 (리턴받은 각 플랫폼별 url로 리다이렉트)
'---------------------------------------------------------------------------------
If isapp="1" Then
    Response.Redirect return_checkoutPage
Else
    Response.Redirect return_checkoutPage
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
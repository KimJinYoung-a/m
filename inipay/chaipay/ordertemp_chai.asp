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
<!-- #include virtual="/inipay/chaipay/incchaipayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. 차이 결제 잠시 점검중입니다.');history.back();</script>"
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
ipgGubun = "CH" '' 차이 구분값
vIdx 	= ""

vIDx = fnSaveOrderTemp(ChaiPay_Mid, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

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
'' 차이 전송 처리
''======================================================================================================================
Dim returnUrlParam, extraData, orderData, chaiSendGoodCnt, tempProductDesc

If irefPgParam.Fgoodcnt > 1 Then
    chaiSendGoodCnt = irefPgParam.Fgoodcnt - 1 '// 상품 주문 갯수
End If

'// 차이의 경우 상품 설명(상품명)을 넘길 수 있는데 백슬래시(\)와 따옴표(", '), 탭문자를 넣을 수 없으며 urlencoding을 해야하고, 총 500자 이내여야 함.
tempProductDesc = replace(irefPgParam.Fgoodname, "\","")
tempProductDesc = replace(tempProductDesc, """","")
tempProductDesc = replace(tempProductDesc, "'","")
tempProductDesc = replace(tempProductDesc, chr(9),"")

'---------------------------------------------------------------------------------
' 구매 상품을 변수에 셋팅 ( x-www-form-urlencoded 으로 전송 )
'---------------------------------------------------------------------------------
If irefPgParam.Fgoodcnt > 1 Then
    orderData = "description="&Server.URLEncode(CStr(irefPgParam.Fgoodname&" 외 "&chaiSendGoodCnt&"건")) '// 상품명(해당 주문에 여러개의 상품일 경우)
Else
    orderData = "description="&Server.URLEncode(CStr(irefPgParam.Fgoodname)) '// 상품명(주문에 상품이 1건일 경우)
End If
orderData = orderData &"&checkoutAmount="&irefPgParam.FPrice '// 결제 금액
orderData = orderData &"&returnUrl="&Server.URLEncode(CStr(ChaiPay_OrderSuccess_Url)) '// 결제준비 완료 후 이동할 URL
orderData = orderData &"&merchantUserId="&Server.URLEncode(CStr(ChaiPay_Merchant_User_Id))
orderData = orderData &"&currency=KRW" '// 사용할 화폐(2020.04.16 기준 KRW만 지원)
orderData = orderData &"&locale=auto" '// 사용할 언어(auto(default),en,ko,zh)
If (isApp="1") then
    orderData = orderData &"&appScheme="&Server.URLEncode(CStr("tenwishapp://native")) '// 차이 결제 후 앱복귀를 위한 URL scheme
End If
'orderData = orderData &"&cashReceipt=true" '// 현금영수증 발급 가능 여부(기본값 true)
'orderData = orderData &"&taxFreeAmount=0" '// 복합과세 : 결제 금액 중 비과세 금액
'orderData = orderData &"&serviceFeeAmount=0" '// 복합과세 : 결제 금액 중 봉사료
'orderData = orderData &"&bookShowAmount=0" '// 복합과세 : 결제 금액 중 도서공연비
'orderData = orderData &"metadata="&ChaiPay_Custom_Json '// 기타 메타 데이터

'---------------------------------------------------------------------------------
' 주문 예약 함수 호출 ( QueryParameter 데이터를 String 형태로 전달 )
'---------------------------------------------------------------------------------
Dim rstJson, ConResult
Dim return_paymentId, return_type, return_status, return_displayStatus, return_idempotencyKey
Dim return_currency, return_checkoutAmount, return_discountAmount, return_billingAmount, return_chargingAmount
Dim return_cashbackAmount, return_merchantDiscountAmount, return_canceledAmount, return_canceledBillingAmount
Dim return_canceledDiscountAmount, return_canceledCashbackAmount, return_returnUrl, return_description, return_createdAt, return_updatedAt
Dim return_message, return_errorCode, return_errorType

'// 차이로 구매상품 내역을 전송
conResult = chaiapi_reserve(orderData, vIDx)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if Trim(CStr(rstJson.data("error_code"))) = "" Then
    return_paymentId                = rstJson.data("paymentId")                 '// 차이에서 보내준 결제 고유 번호
    return_type                     = rstJson.data("type")                      '// 결제 타입(payment, charge) 여기서 charge는 차이 계좌에 충전한걸 의미하는듯.
    return_status                   = rstJson.data("status")                    '// 결제 상태(여기서는 결제 생성을 했기때문에 waiting 즉 대기 상태로 리턴됨)
    return_displayStatus            = rstJson.data("displayStatus")             '// 결제 상태 상세값
    return_idempotencyKey           = rstJson.data("idempotencyKey")            '// 텐바이텐에서 보낸 주문번호(여기선 결제 생성 단계이기 때문에 임시주문번호임)
    return_currency                 = rstJson.data("currency")                  '// 사용할 화폐(일단 차이도 KRW만 받고 우리도 KRW만 넘기고 있음 그래서 당연히 KRW)
    return_checkoutAmount           = rstJson.data("checkoutAmount")            '// 결제 요청 금액
    return_discountAmount           = rstJson.data("discountAmount")            '// 할인 금액(차이에서 할인해준 금액, 텐바이텐에서 보낸 값은 아님)
    return_billingAmount            = rstJson.data("billingAmount")             '// 실결제 금액(결제 요청 금액 - 할인 금액)
    return_chargingAmount           = rstJson.data("chargingAmount")            '// 사용자가 차이에서 충전한 금액? 인거 같은데 우리가 받아도 딱히 쓸일은..
    return_cashbackAmount           = rstJson.data("cashbackAmount")            '// 사용자가 차이에서 캐쉬백 받을 금액? 인거 같은데 이것도 우리가 딱히 쓸일은..
    return_merchantDiscountAmount   = rstJson.data("merchantDiscountAmount")    '// 우리가 할인해준 금액 아니면 이벤트 등으로 우리쪽에서 부담할 할인금액?
    return_canceledAmount           = rstJson.data("canceledAmount")            '// 취소 요청 금액(여기서 쓸일은 없을거 같은데..)
    return_canceledBillingAmount    = rstJson.data("canceledBillingAmount")     '// 실제 취소 금액
    return_canceledDiscountAmount   = rstJson.data("canceledDiscountAmount")    '// 취소 금액 중 할인된 금액
    return_canceledCashbackAmount   = rstJson.data("canceledCashbackAmount")    '// 취소 금액 중 캐시백 된 금액
    return_returnUrl                = rstJson.data("returnUrl")                 '// 우리가 보낸 결제 완료 페이지 url(즉, ChaiPay_OrderSuccess_Url임)
    return_description              = rstJson.data("description")               '// 우리가 보낸 상품명
    return_createdAt                = rstJson.data("createdAt")                 '// 결제 생성일(UTC 기준)
    return_updatedAt                = rstJson.data("updatedAt")                 '// 결제 최종 갱신일(UTC 기준)

    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_TID = '" & return_paymentId & "'" & VbCRLF
    sqlStr = sqlStr & " , P_STATUS = 'S01' " & VbCRLF		'인증 성공(승인 전단계)    
    sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
    dbget.execute sqlStr
Else
    return_message      = rstJson.data("message") '// 응답이 성공이 아닐경우 보내주는 설명 메시지
    return_errorCode    = rstJson.data("error_code") '// 응답이 실패할경우 보내주는 에러코드
    return_errorType    = rstJson.data("error_type") '// 응답이 실패할경우 보내주는 에러타입

    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (여기선 오류 등)
    sqlStr = sqlStr & " , P_RMESG1 = convert(varchar(500),'" & return_errorType&"-"&return_errorCode &":"&return_message&"') " & VbCRLF		'실패사유
    sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
    dbget.execute sqlStr

    response.write "<script>alert('처리중 오류가 발생했습니다.\n("&return_message&")');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
End if

Set rstJson = Nothing
Set irefPgParam = Nothing

'---------------------------------------------------------------------------------
' 차이 결제화면으로 이동
'---------------------------------------------------------------------------------
%>
<%'결제 페이지 호출용 차이 스크립트%>
<script type="text/javascript" src="https://chai.finance/js/v1/payment.min.js"></script>

<script type="text/javascript">
  ChaiPayment.checkout({
    <%'// mode: 'production' // default: staging%>
    publicAPIKey: '<%=ChaiPay_Public_Api_Key%>',
    paymentId: '<%=return_paymentId%>',
    returnUrl: '<%=return_returnUrl%>',
    idempotencyKey: '<%=return_idempotencyKey%>',
    mode: '<%=ChaiPay_ModeType%>',    
  });
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
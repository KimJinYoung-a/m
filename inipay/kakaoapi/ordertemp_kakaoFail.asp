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
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'카카오에서 결제 중 취소나 실패가 될 경우 이 페이지로 들어온다.
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

''======================================================================================================================
'' KAKAO에 주문 접수된 주문건을 가져온다.
''======================================================================================================================
Dim orderReserveData, conResult, rstJson

orderReserveData = "cid="&Server.URLEncode(CStr(KakaoPay_Cid)) '// 가맹점코드
If trim(KakaoPay_Cid_Secret) <> "" Then
    orderReserveData = orderReserveData &"&cid_secret="&Server.URLEncode(CStr(KakaoPay_Cid_Secret)) '// 가맹점 코드 인증키, 24자 숫자+영문 소문자(필수값 아님)
End If
orderReserveData = orderReserveData &"&tid="&Server.URLEncode(CStr(kakaoTid)) '// 주문접수시 카카오에서 리턴해준 tid값

'// 카카오톡으로 전송한 구매내역 가져옴.
conResult = kakaoapi_ordercheck(orderReserveData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

'// 카카오 주문내역확인 값
Dim kakao_ordercheck_tid                        '// 카카오톡에서 받아온 TID값(이값은 주문예약할때 받아온 kakaoTid 값과 동일해야됨)
Dim kakao_ordercheck_cid                        '// 카카오톡에서 받아온 가맹점코드(이값은 inckakaopaycommon.asp에 있는 KakaoPay_Cid값과 동일해야됨)
Dim kakao_ordercheck_status                     '// 카카오톡에서 받아온 상태값
Dim kakao_ordercheck_partner_order_id           '// 카카오톡에서 받아온 가맹점주문번호(tempidx값과 일치해야됨)
Dim kakao_ordercheck_partner_user_id            '// 가맹점회원아이디(주문예약 요청한 아이디와 동일해야됨)
Dim kakao_ordercheck_payment_method_type        '// 결제수단(card or money중 하나)
Dim kakao_ordercheck_amount                     '// 결제 금액 정보(json object)
Dim kakao_ordercheck_canceled_amount            '// 취소된 금액 정보(json object)
Dim kakao_ordercheck_cancel_available_amount    '// 해당 결제에 대해 취소 가능 금액(json object)
Dim kakao_ordercheck_item_name                  '// 상품이름
Dim kakao_ordercheck_item_code                  '// 상품코드
Dim kakao_ordercheck_quantity                   '// 상품수량
Dim kakao_ordercheck_created_at                 '// 결제준비 요청 시각
Dim kakao_ordercheck_approved_at                '// 결제 승인 시각
Dim kakao_ordercheck_canceled_at                '// 결제 취소 시각
Dim kakao_ordercheck_selected_card_info         '// 사용자가 선택한 카드 정보(json object)
Dim kakao_ordercheck_payment_action_details     '// 결제/취소 상세(json obejct list)

if rstJson.data("tid") <> "" Then
    kakao_ordercheck_tid                        = rstJson.data("tid")
    kakao_ordercheck_cid                        = rstJson.data("cid")
    kakao_ordercheck_status                     = rstJson.data("status")
    kakao_ordercheck_partner_order_id           = rstJson.data("partner_order_id")
    kakao_ordercheck_partner_user_id            = rstJson.data("partner_user_id")
    kakao_ordercheck_payment_method_type        = rstJson.data("payment_method_type")
    'kakao_ordercheck_amount                     = rstJson.data("amount").item() // JsonObject로 가져올려면 따로 loop 돌리면됨
    'kakao_ordercheck_canceled_amount            = rstJson.data("canceled_amount").item() // JsonObject로 가져올려면 따로 loop 돌리면됨
    'kakao_ordercheck_cancel_available_amount    = rstJson.data("cancel_available_amount").item() // JsonObject로 가져올려면 따로 loop 돌리면됨
    kakao_ordercheck_item_name                  = rstJson.data("item_name")
    kakao_ordercheck_item_code                  = rstJson.data("item_code")
    kakao_ordercheck_quantity                   = rstJson.data("quantity")
    kakao_ordercheck_created_at                 = rstJson.data("created_at")
    kakao_ordercheck_approved_at                = rstJson.data("approved_at")
    kakao_ordercheck_canceled_at                = rstJson.data("canceled_at")
    'kakao_ordercheck_selected_card_info         = rstJson.data("selected_card_info").item() // JsonObject로 가져올려면 따로 loop 돌리면됨
    'kakao_ordercheck_payment_action_details     = rstJson.data("payment_action_details").item() // JsonObject로 가져올려면 따로 loop 돌리면됨
Else
    response.write "<script>alert('처리중 오류가 발생했습니다.\n("&rstJson.data("code")&")');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
End if

'카카오에서 받아온 Tid와 DB에서 불러온 Tid가 같은지 체크
If trim(kakaoTid) <> trim(kakao_ordercheck_tid) Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    dbget.close()
    response.end
End If

'오류내용에 대해 저장을 한다.
vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
vQuery = vQuery & " SET P_TID = convert(varchar(50),'" & kakao_ordercheck_tid & "')" & VbCRLF
vQuery = vQuery & " , P_STATUS = 'F01' " & VbCRLF		'인증 실패 (취소 등)
vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & kakaoapi_return_order_status_value(kakao_ordercheck_status) & "') " & VbCRLF		'실패사유
vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
dbget.execute vQuery

If Trim(kakao_ordercheck_status) = "QUIT_PAYMENT" Then
    response.write "<script>alert('결제를 취소하셨습니다.');</script>"
End If
If Trim(kakao_ordercheck_status) = "FAIL_PAYMENT" Then
    response.write "<script>alert('결제 승인이 실패되었습니다.');</script>"
End If
response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
dbget.close()
response.end
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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
<!-- #include virtual="/inipay/kakaoapi/incKakaopayCommon.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. 카카오페이 결제 잠시 점검중입니다.');history.back();</script>"
'response.end

Dim vQuery, vQuery1
Dim sqlStr

'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localhost:11117"
End If

'// 앱일경우엔 앱경로 넣어준다.
Dim vAppLink : vAppLink =""
If isApp="1" Then
	vAppLink = "/apps/appCom/wish/web2014"
End If

Dim vIDx, iErrMsg, ipgGubun, tempIdxVal
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = "KK" '' 카카오 신규API 구분값
vIdx 	= ""

vIDx = fnSaveOrderTemp(KakaoPay_Cid, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

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
'' KAKAO 전송 처리
''======================================================================================================================
Dim OrderNumber, returnUrlParam, extraData, orderData, kakaoSendGoodCnt
OrderNumber = 1			'상품 일련 번호

If irefPgParam.Fgoodcnt > 1 Then
    kakaoSendGoodCnt = irefPgParam.Fgoodcnt - 1
End If
'---------------------------------------------------------------------------------
' 구매 상품을 변수에 셋팅 ( x-www-form-urlencoded 으로 전송 )
'---------------------------------------------------------------------------------
orderData = "cid="&Server.URLEncode(CStr(KakaoPay_Cid)) '// 가맹점코드
If trim(KakaoPay_Cid_Secret) <> "" Then
    orderData = orderData &"&cid_secret="&Server.URLEncode(CStr(KakaoPay_Cid_Secret)) '// 가맹점 코드 인증키, 24자 숫자+영문 소문자(필수값 아님)
End If
orderData = orderData &"&partner_order_id="&Server.URLEncode(CStr("temp"&vIdx)) '// 주문번호(여기선 실제 주문번호가 아닌 임시 주문번호를 던져줌)
If Trim(GetLoginUserID)="" Then
    orderData = orderData &"&partner_user_id="&Server.URLEncode(CStr(GetGuestSessionKey)) '// 사용자 아이디(비회원)
Else
    orderData = orderData &"&partner_user_id="&Server.URLEncode(CStr(GetLoginUserID)) '// 사용자 아이디(회원)
End If
If irefPgParam.Fgoodcnt > 1 Then
    orderData = orderData &"&item_name="&Server.URLEncode(CStr(irefPgParam.Fgoodname&" 외 "&kakaoSendGoodCnt&"건")) '// 상품명(해당 주문에 여러개의 상품일 경우)
Else
    orderData = orderData &"&item_name="&Server.URLEncode(CStr(irefPgParam.Fgoodname)) '// 상품명(주문에 상품이 1건일 경우)
End If
'orderData = orderData &"&item_code=" '// 상품코드(필수값 아님)
orderData = orderData &"&quantity="&irefPgParam.Fgoodcnt '// 상품갯수(해당 주문에 들어 있는 상품갯수)
orderData = orderData &"&total_amount="&irefPgParam.FPrice '// 총 금액
orderData = orderData &"&tax_free_amount=0" '// 상품 비과세 금액(면세 금액은 0원으로 설정)
orderData = orderData &"&vat_amount=" '// 상품 부가세 금액(값 안던지면 자동으로 계산해줌)
orderData = orderData &"&approval_url="&Server.URLEncode(CStr(KakaoPay_OrderSuccess_Url)&"?tempidx="&"temp"&vIdx) '// 결제준비 완료 후 이동할 URL
orderData = orderData &"&cancel_url="&Server.URLEncode(CStr(KakaoPay_OrderCancel_Url)&"?tempidx="&"temp"&vIdx) '// 사용자가 결제 취소시 이동할 URL
orderData = orderData &"&fail_url="&Server.URLEncode(CStr(KakaoPay_OrderFail_Url)&"?tempidx="&"temp"&vIdx) '// 특정 조건에 의해 결제 실패시 이동할 URL
If trim(KakaoPay_Available_Cards)<>"" Then
    orderData = orderData &"&available_cards="&Server.URLEncode(KakaoPay_Available_Cards) '// 카드사 제한목록(필요한 경우 incKakaoPayCommon.asp에 있는 목록 수정하여 전송)
End If
If Trim(KakaoPay_Payment_Method_Type)<>"" Then
    orderData = orderData &"&payment_method_type="&Server.URLEncode(CStr(KakaoPay_Payment_Method_Type)) '//결제 수단 제한
End If
If Trim(KakaoPay_Install_Month)<>"" Then
    orderData = orderData &"&install_month="&Server.URLEncode(KakaoPay_Install_Month) '// 카드할부개월수
End If
If Trim(KakaoPay_Custom_Json)<>"" Then
    orderData = orderData &"&custom_json="&Server.URLEncode(KakaoPay_Custom_Json) '// 결제화면에 보여주고 싶은 메시지(적용하기위해선 카카오페이측과 사전협의 필요)
End If

'---------------------------------------------------------------------------------
' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
'---------------------------------------------------------------------------------
Dim rstJson, ConResult, return_Tid, return_Next_Redirect_App_Url, return_Next_Redirect_Mobile_Url, return_Next_Redirect_Pc_Url, return_Android_App_Scheme, return_Ios_App_Scheme

'// 카카오톡으로 구매상품 내역을 전송
conResult = kakaoapi_reserve(orderData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if rstJson.data("tid") <> "" Then
    return_Tid                          = rstJson.data("tid") '// 카카오페이에서 리턴해준 tid 값
    return_Next_Redirect_App_Url        = rstJson.data("next_redirect_app_url") '// 카카오페이에서 리턴해준 appurl
    return_Next_Redirect_Mobile_Url     = rstJson.data("next_redirect_mobile_url") '// 카카오페이에서 리턴해준 mobileurl
    return_Next_Redirect_Pc_Url         = rstJson.data("next_redirect_pc_url") '// 카카오페이에서 리턴해준 pcurl
    return_Android_App_Scheme           = rstJson.data("android_app_scheme") '// 카카오페이에서 리턴해준 android app scheme
    return_Ios_App_Scheme               = rstJson.data("ios_app_scheme") '// 카카오페이에서 리턴해준 ios app scheme
    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_TID = '" & return_Tid & "'" & VbCRLF
    sqlStr = sqlStr & " , P_STATUS = 'S01' " & VbCRLF		'인증 성공(승인 전단계)    
    sqlStr = sqlStr & " WHERE temp_idx = '" & vIdx & "'"
    dbget.execute sqlStr
Else
    '예약 번호 저장
    sqlStr = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    sqlStr = sqlStr & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (여기선 오류 등)
    sqlStr = sqlStr & " , P_RMESG1 = convert(varchar(500),'" & rstJson.data("code") & "') " & VbCRLF		'실패사유
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
' 카카오 페이 결제화면으로 이동 (리턴받은 각 플랫폼별 url로 리다이렉트)
'---------------------------------------------------------------------------------
If isapp="1" Then
    Response.Redirect return_Next_Redirect_App_Url
Else
    Response.Redirect return_Next_Redirect_Mobile_Url
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
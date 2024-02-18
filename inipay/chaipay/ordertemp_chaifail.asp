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
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'토스에서 결제 중 취소나 실패가 될 경우 이 페이지로 들어온다.
Dim temp_idx, tossTokenId, vRdsite, vQuery, vIdx

temp_idx = Request("tempidx") '// 텐바이텐에서 order_temp에 저장한 temp_idx값

vIdx = Replace(temp_idx, "temp","")


'// 로컬 개발환경일 경우 wwwUrl 값을 넣어준다.
If G_IsLocalDev Then
    M_SSLUrl = "http://localm.10x10.co.kr"
End If

'토스에 있는 주문접수 정보를 확인하기 위해 토스 토큰값을 가져온다.
'임시주문 정보 접수 rdsite 별로 분기.=======================================
vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.EOF THEN
	vRdsite			= rsget("rdsite")
    tossTokenId    = rsget("P_TID")
END IF
rsget.close

Dim vAppLink
SELECT CASE vRdsite
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"
    Case Else : vAppLink = ""
End SELECT

'// temp_idx체크
If trim(temp_idx) = "" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If


If Trim(tossTokenId) = "" Then
    response.write "<script>alert('처리중 오류가 발생했습니다.');</script>"
    response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
    response.end
End If

''======================================================================================================================
'' 해당 페이지는 사용자가 취소를 할경우 사용되므로 토스 결제 취소를 호출한다.
''======================================================================================================================
Dim orderCancelData, conResult, rstJson

orderCancelData = "{"
orderCancelData = orderCancelData &"""apiKey"":"""&CStr(TossPay_RestApi_Key)&"""" '// 가맹점코드
orderCancelData = orderCancelData &",""payToken"":"""&CStr(tossTokenId)&"""" '// 주문예약시 토스에서 받은 payToken값
orderCancelData = orderCancelData &",""reason"":"""&CStr("사용자 취소")&"""" '// 취소 사유
orderCancelData = orderCancelData &"}"

'// 토스로 결제 취소 호출
conResult = tossapi_ordercancel(orderCancelData)

'// 결과 파징
Set rstJson = new aspJson
rstJson.loadJson(conResult)

if CStr(rstJson.data("code")) = "0" then
    '오류내용에 대해 저장을 한다.
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    vQuery = vQuery & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (취소 등)
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'결제 중 사용자 취소') " & VbCRLF		'실패사유
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
    dbget.execute vQuery
Else
    '오류내용에 대해 저장을 한다.
    '일단 사용자가 취소를 하게 되면 토스쪽에서 자동으로 취소를 해주는거 같은데.. api 명세서에는 가맹점에서 취소하라고 해서
    '취소 프로세스를 추가 해서 여기에 이미 취소한 주문이라는 메시지가 저장되면 토스에서 자동으로 취소한걸로 보면 됨.
    vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] "
    vQuery = vQuery & " SET P_STATUS = 'F01' " & VbCRLF		'인증 실패 (취소 등)
    vQuery = vQuery & " , P_RMESG1 = convert(varchar(500),'" & rstJson.data("errorCode")&"-"&rstJson.data("msg") & "') " & VbCRLF		'실패사유
    vQuery = vQuery & " WHERE temp_idx = '" & vIdx & "'"                                  '' P_NOTI is temp_idx
    dbget.execute vQuery
End if

response.write "<script>alert('결제가 취소되었습니다.');</script>"
response.write "<script>location.replace('"&M_SSLUrl & vAppLink&"/inipay/userinfo.asp');</script>"
dbget.close()
response.end
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
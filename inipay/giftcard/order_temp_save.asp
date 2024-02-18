<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardinfoCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardPrdCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/GiftCardOptionCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
'response.write "<script>alert('죄송합니다. 모바일 신용카드 결제 잠시 점검중입니다.');history.back();</script>"
'response.end
if GetLoginUserID="" then
	Call Alert_return("로그인이 필요합니다. 로그인해주세요.")
	dbget.close: Response.End
end if

'// 임시 주문정보 저장 //
dim temp_idx,cardItemid,cardOption,userid,buyname,buyemail,buyhp,buyPhone,sendHP,sendemail,reqhp,accountdiv,accountname,accountno
dim price,referip,userlevel,designId,MMSTitle,MMSContent,userImage,rdsite,vMid,userDevice
dim i

cardItemid		= requestCheckVar(request.Form("cardid"),3)
cardOption		= requestCheckVar(request.Form("cardopt"),4)
userid			= GetLoginUserID
buyname			= requestCheckVar(request.Form("buyname"),16)
buyemail		= requestCheckVar(request.Form("buyemail"),120)
buyhp			= requestCheckVar(request.Form("buyhp"),16)
buyPhone		= requestCheckVar(request.Form("buyphone"),16)
sendHP			= requestCheckVar(request.Form("sendhp"),16)
sendemail		= requestCheckVar(request.Form("sendemail"),120)
reqhp			= requestCheckVar(request.Form("reqhp"),16)
accountdiv		= requestCheckVar(request.Form("Tn_paymethod"),3)
accountname		= requestCheckVar(request.Form("acctname"),16)
accountno		= requestCheckVar(request.Form("acctno"),32)
price			= getNumeric(requestCheckVar(request.Form("cardPrice"),18))
referip			= Left(request.ServerVariables("REMOTE_ADDR"),32)
userlevel		= GetLoginUserLevel
designId		= requestCheckVar(request.Form("designid"),3)
MMSTitle		= requestCheckVar(request.Form("MMSTitle"),64)
MMSContent		= html2db(request.Form("MMSContent"))
userImage		= requestCheckVar(request.Form("userImg"),128)
rdsite			= requestCheckVar(request.Form("rdsite"),32)
vMid			= chkIIF(application("Svr_Info")="Dev","INIpayTest","teenxteen8")
userDevice		= Replace(chrbyte(Request.ServerVariables("HTTP_USER_AGENT"),300,"Y"),"'","")

if designId="900" then
	if userImage<>"" then
		userImage = "/giftcard/temp/" & userImage
	else
		designId = "605"		'기본 디자인
	end if
elseif designId="" then
	designId = "605"
end if

'### order_real_save_function.asp 에서 다시 지정해 넣습니다.
Dim vAppName, vAppLink, device
	vAppName = Request("appname")

SELECT CASE vAppName
	Case "app_wish2"
		vAppLink = "/apps/appCom/wish/web2014"
		rdsite = "app_wish2"
	Case "app_wish"
		vAppLink = "/apps/appCom/wish/webview"
		rdsite = "app_wish"
	Case "app_cal" 
		vAppLink = "/apps/appCom/wish/webview"   ''같이사용
		rdsite = "app_cal"
	Case Else
		rdsite = "mobile"
End SELECT
if instr(vAppName,"app") > 0 then
	device="A"
else
	device="M"
end if


'// 카드-옵션 정보 접수
dim oCardItem, strSql
Set oCardItem = new CItemOption
oCardItem.FRectItemID = cardItemid
oCardItem.FRectItemOption = cardOption
oCardItem.GetItemOneOptionInfo

if oCardItem.FResultCount<=0 then
    Call Alert_return("판매중인 Gift카드가 아니거나 없는 Gift카드번호 입니다.")
	dbget.close: response.End
elseif oCardItem.FOneItem.FoptSellYn="N" then
    Call Alert_return("판매중인 Gift카드가 아니거나 품절된 Gift카드 옵션입니다.")
	dbget.close: response.End
end if

if CLNG(oCardItem.FOneItem.FcardSellCash)<>CLNG(price) then
    Call Alert_return("금액이 잘못되었습니다.")

    ''관리자 오류 통보
	'strSql = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','gift카드 금액오류-"&referip&":" & oCardItem.FOneItem.FcardSellCash &":"&price&"'"
	'dbget.Execute strSql
	response.end
end if

set oCardItem=Nothing


''##############################################################################
''디비작업
''##############################################################################
strSql = "INSERT INTO [db_order].[dbo].[tbl_giftcard_order_temp] (" &_
	"cardItemid,cardOption,userid,buyname,buyemail,buyhp,buyPhone,sendHP,sendemail,reqhp,accountdiv,accountname,accountno" &_
	",price,referip,userlevel,designId,MMSTitle,MMSContent,userImage,rdsite,mid,userDevice" &_
	",P_STATUS,P_TID,P_AUTH_NO,P_RMESG1,P_RMESG2,P_FN_CD1,P_CARD_ISSUER_CODE,P_CARD_PRTC_CODE,PayResultCode,IsSuccess" &_
	") VALUES (" &_
	"'" & cardItemid & "','" & cardOption & "','" & userid & "','" & buyname & "','" & buyemail & "','" & buyhp & "','" & buyPhone & "','" & sendHP & "'" &_
	",'" & sendemail & "','" & reqhp & "','" & accountdiv & "','" & accountname & "','" & accountno & "','" & price & "','" & referip & "','" & userlevel &"'" &_
	",'" & designId & "',N'" & MMSTitle & "',N'" & MMSContent & "','" & userImage & "','" & rdsite & "','" & vMid & "','" & userDevice & "'" &_
	",'','','','','','','','','','')"
	''Response.WRite "ERR." &strSql: dbget.close: Response.End
dbget.execute strSql

strSql = " SELECT SCOPE_IDENTITY() "
rsget.Open strSql,dbget
IF Not rsget.EOF THEN
	temp_idx = rsget(0)
END IF
rsget.close

IF temp_idx = "" Then
	Call Alert_return("처리 중 오류가 발생하였습니다. 잠시후 다시 해주세요.")
	dbget.close: Response.End
End IF

'// 결제 방법 선택
Dim paymethod
Select Case accountdiv
	Case "100"
		paymethod = "wcard"		'신용카드
	Case "20"
		paymethod = "bank"		'실시간계좌이체
	Case "7"
		paymethod = "vbank"		'가상계좌 발급
	Case Else
		paymethod = "wcard"		'기본값:신용카드
End Select

''======================================================================================================================
IF temp_idx  <> "" Then
%>
	<form name="ini" method="post" accept-charset="euc-kr">
	<!-- 카드결제용 이니시스 전송 Form //-->
    <input type="hidden" name="paymethod" value="<%=paymethod%>">

	<input type="hidden" name="P_MID" value="<%=chkIIF(application("Svr_Info")="Dev","INIpayTest","teenxteen8")%>">
	<input type="hidden" name="P_OID" value="<%= temp_idx %>">
	<input type="hidden" name="P_AMT" value="<%= price %>">
	<input type="hidden" name="P_UNAME" value="<%= buyname %>">
	<input type="hidden" name="P_MNAME" value="(주)텐바이텐">
	<input type="hidden" name="P_NOTI" value="<%= temp_idx %>">
	<input type="hidden" name="P_GOODS" value="텐바이텐 기프트카드">
	<input type="hidden" name="P_MOBILE" value="<%= buyhp %>">
	<input type="hidden" name="P_EMAIL" value="<%= buyemail %>">

	<input type="hidden" name="P_NEXT_URL" value="<%=wwwURL%>/inipay/giftcard/mx_rnext.asp">							<!-- 인증결과URL -->
	<input type="hidden" name="P_NOTI_URL" value="<%=wwwURL%>/inipay/giftcard/mx_rnoti.asp">							<!-- 승인결과통보URL (실시간이체, 가상계좌 비동기) -->
	<input type="hidden" name="P_RETURN_URL" value="<%=wwwURL%>/inipay/giftcard/mx_rreturn.asp?idx=<%=temp_idx%>">		<!-- 결제결과URL (실시간이체 비동기) -->
	<INPUT TYPE="hidden" name="P_TAXFREE" value="<%= price %>">															<!-- 비과세금액 -->
	<input type="hidden" name="P_QUOTABASE" value="01:02:03:04:05:06:07:08:09:10:11:12">
	<INPUT TYPE="hidden" name="P_CHARSET" value="utf8">
	<% if device="A" then 'APP에서 결제라면 APP내용 추가 %>
	<INPUT TYPE="hidden" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=N&apprun_check=Y&bank_receipt=N&ismart_use_sign=Y&app_scheme=tenwishapp://">
	<!--&app_scheme=tenwishapp://m.10x10.co.kr/inipay/card/mx_rreturn.asp?idx=<%=temp_idx%>-->
	<% else %>
	<INPUT TYPE="hidden" name="P_RESERVED" value="twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=N&apprun_check=Y&bank_receipt=N&ismart_use_sign=Y&extension_enable=Y">
	<% end if %>
	</form>

	<script type="text/javascript">
		var order_form = document.ini;
		order_form.action = "https://mobile.inicis.com/smart/"+order_form.paymethod.value+"/";

		if(window.navigator.appVersion.indexOf("MSIE") >=0) {
			document.charset = "euc-kr";
		}

		order_form.submit();
	</script>
<% End If %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
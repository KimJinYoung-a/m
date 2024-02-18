<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
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
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<%
'response.write "<script>alert('죄송합니다. 모바일 신용카드 결제 잠시 점검중입니다.');history.back();</script>"
'response.end

' If session("ssnuserid") = "dlwjseh" Then
' 	Dim Item
' 	For Each Item In Request.Form 'Form 형태로 넘어오는 값
' 		Response.Write Item & ": " & Request.Form(Item) & "<br>"
' 	Next
' 	Response.End
' End If

Dim vQuery, vQuery1
Dim sqlStr

'// 앱일경우엔 앱경로 넣어준다.

Dim vAppName, vAppLink, device
vAppName = Request("appname")

SELECT CASE vAppName
	Case "app_wish2" : vAppLink = "/apps/appCom/wish/web2014"
	Case "app_wish" : vAppLink = "/apps/appCom/wish/webview"
	Case "app_cal" : vAppLink = "/apps/appCom/wish/webview"   ''같이사용
End SELECT

if instr(vAppName,"app") > 0 then
	device="A"
else
	device="M"
end if
if device="" then device="M"



Dim vIDx, iErrMsg, ipgGubun
Dim irefPgParam   '' 결제 예약시 필요한 값들.
ipgGubun = ""
vIdx 	= ""

dim vPostNum : vPostNum = Request("postNum") '// 수령자 기준 우편번호
dim vAddress : vAddress = Request("address") '// 수령자 기준 주소
dim vAddressDtl : vAddressDtl = Request("addressDtl") '// 수령자 기준 상세주소
dim vRentalRecipientNm : vRentalRecipientNm = Request("rentalRecipientNm") '// 수령자 이름
dim vRentalRecipientPhone : vRentalRecipientPhone = Request("rentalRecipientPhone") '// 수령자 전화번호
dim vRentalPeriod : vRentalPeriod = Request("rentalPeriod") '// 렌탈 기간
dim vRentalPrice : vRentalPrice = Request("rentalPrice") '// 월 렌탈료
dim vRentalCompNm : vRentalCompNm = Request("rentalCompNm") '// 사업자명(셀러기준)
dim vRentalCompNo : vRentalCompNo = Request("rentalCompNo") '// 사업자번호(셀러기준)
dim vRentalCompPhone : vRentalCompPhone = Request("rentalCompPhone") '// 사업자휴대폰번호(셀러기준)
dim vRentalAdditionalData : vRentalAdditionalData = Request("rentalAdditionalData") '// 이니렌탈 보험용 데이터
dim vRentalBuyerHP

dim vPGoods : vPGoods = Request("P_GOODS")
dim vTn_paymethod : vTn_paymethod = requestCheckVar(Request("Tn_paymethod"),8)
dim IniMid : IniMid = "teenxteen9"
if (vTn_paymethod="400") then IniMid="teenteen10"

'' 하나10x10 Card
if (vTn_paymethod="190") then IniMid="teenxteeha"
if (application("Svr_Info")="Dev") then IniMid="INIpayTest"

'' 이니렌탈
If (vTn_paymethod="150") Then
	if (application("Svr_Info")="Dev") then 
		IniMid="teenxtest1"
	Else
		IniMid="teenxteenr"
	End If
End If

vIDx = fnSaveOrderTemp(IniMid, iErrMsg, ipgGubun, irefPgParam)  '' order_temp 임시저장

if (vIDx<1) then
    response.write "ERR2:처리중 오류가 발생하였습니다.- "&iErrMsg&""
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & replace(iErrMsg,"'","") & ")')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink &"/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if

if (irefPgParam is Nothing) then
    response.write "ERR2:처리중 오류가 발생하였습니다"
    response.write "<script>alert('처리중 오류가 발생했습니다.\n(ERR2)')</script>"
	response.write "<script>location.replace('" & wwwUrl & vAppLink &"/inipay/shoppingbag.asp');</script>"
    dbget.close()
    response.end
end if
''======================================================================================================================
If Trim(irefPgParam.FBuyhp) <> "" Then
	If instr(lcase(irefPgParam.FBuyhp),"-") > 0 Then
		vRentalBuyerHP = replace(irefPgParam.FBuyhp,"-","")
	End If
End If

IF cStr(vIdx) <> "" Then
%>
	<form name="ini" method="post" accept-charset="euc-kr"> <% '' utf-8로 하믄 ISP 앱이 죽더라. %>
	<!-- 카드결제용 이니시스 전송 Form //-->

	<% if (vTn_paymethod="400") then %>
    	<input type=hidden name="P_MID" value="<%=IniMid%>">
	    <input type="hidden" name="paymethod" value="mobile"><!-- 2015/04/21-->
	    <input type="hidden" name="P_GOPAYMETHOD" value="HPP">
	    <input type="hidden" name="P_HPP_METHOD" value="2"><!-- 2 실물 -->
	<% elseif (vTn_paymethod="150") Then %>
		<% '// 이니렌탈 파라미터 추가 %>
		<input type=hidden name="P_INI_PAYMENT" value="RTPAY">
    	<input type=hidden name="P_MID" value="<%=IniMid%>">
	    <input type=hidden name="paymethod" value="payment">		
		<input type=hidden name="P_MOBILE" value="<%=vRentalBuyerHP%>">
		<input type=hidden name="P_RECV_POSTNUM" value="<%=vPostNum%>">
		<input type=hidden name="P_RECV_ADDR" value="<%=vAddress%>">
		<input type=hidden name="P_RECV_ADDR_DETAIL" value="<%=vAddressDtl%>">
	<% else %>
    	<input type=hidden name="P_MID" value="<%=IniMid%>">
	    <input type="hidden" name="paymethod" value="wcard">
	    <input type="hidden" name="P_GOPAYMETHOD" value="CARD">
    <% end if %>

    <% if (vTn_paymethod="190") then %>
        <input type="hidden" name="P_ONLY_CARDCODE" value="34">
    <% end if %>
	<input type="hidden" name="P_OID" value="<%= vIdx %>">
	<input type="hidden" name="P_AMT" value="<%= irefPgParam.FPrice %>">
	<input type="hidden" name="P_UNAME" value="<%= irefPgParam.FBuyname %>">
	<input type="hidden" name="P_GOODS" value="<%= vPGoods %>">
	<input type="hidden" name="inipaymobile_type" value="web">
	<input type="hidden" name="P_NOTI" value="<%= vIdx %>">
	<input type="hidden" name="P_EMAIL" value="<%= irefPgParam.FBuyemail %>">

	<input type="hidden" name="P_NOTI_URL" value="<%=wwwURL%>/inipay/card/ordertemp_rnoti.asp">
	<input type="hidden" name="P_RETURN_URL" value="<%=wwwURL%>/inipay/card/mx_rreturn.asp?idx=<%=vIdx%>">

	<input type="hidden" name="P_CHARSET" value="utf8">
	<%
	'' 아이폰 사파리 결제 체크.
	Dim ispASyncCase : ispASyncCase=false
	if (flgDevice="I") then  ''아이폰이고.
	    if (InStr(LCASE(uAgent),"safari")>0) then ispASyncCase=true  ''사파리인경우만,  네이버앱은 Sync 방식.방식.
		''if (getLoginUserLevel()="7") then ispASyncCase=false ''2019/05/15 테스트 // 잘안됨 원복
	end if
	%>
	<% If vTn_paymethod="150" Then %>
		<% '이니렌탈 결제값 %>
		<INPUT TYPE="hidden" name="P_RESERVED" value="d_rtpay=Y&rentalPeriod=<%=vRentalPeriod%>&rentalPrice=<%=vRentalPrice%>&rentalCompNm=<%=vRentalCompNm%>&rentalCompNo=<%=vRentalCompNo%>&rentalCompPhone=<%=vRentalCompPhone%>&rentalRecipientNm=<%=vRentalRecipientNm%>&rentalRecipientPhone=<%=vRentalRecipientPhone%>">
		<% If Trim(vRentalAdditionalData) <> "" Then %>
			<INPUT TYPE="hidden" name="additionalData" value="<%=vRentalAdditionalData%>">
		<% End If %>
	<% Else %>
		<% if device="A" then 'APP에서 결제라면 APP내용 추가 %>
			<INPUT TYPE="hidden" name="P_RESERVED" value="below1000=Y&global_visa3d=Y&twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=N&apprun_check=Y&bank_receipt=N&ismart_use_sign=Y&app_scheme=tenwishapp://<%=chkIIF(irefPgParam.FDlvPrice>0,"&cd_ps=14-10","")%>">
		<% else %>
			<% if (ispASyncCase) then '' 아이폰 웹이면 isp 어씽크 결제. %>
				<INPUT TYPE="hidden" name="P_RESERVED" value="below1000=Y&global_visa3d=Y<%=chkIIF(irefPgParam.FDlvPrice>0,"&cd_ps=14-10","")%>">
			<% else %>
				<% if (InStr(LCASE(uAgent),"daumapps")>0) then ''다음앱 이면.스키마를 넣어줌 2018/03/15 %>
				<INPUT TYPE="hidden" name="P_RESERVED" value="below1000=Y&global_visa3d=Y&twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=N&apprun_check=Y&bank_receipt=N&ismart_use_sign=Y&app_scheme=daumapps://open<%=chkIIF(irefPgParam.FDlvPrice>0,"&cd_ps=14-10","")%>">
				<% else %>
				<INPUT TYPE="hidden" name="P_RESERVED" value="below1000=Y&global_visa3d=Y&twotrs_isp=Y&block_isp=Y&twotrs_isp_noti=N&cp_yn=N&apprun_check=Y&bank_receipt=N&ismart_use_sign=Y&extension_enable=Y<%=chkIIF(irefPgParam.FDlvPrice>0,"&cd_ps=14-10","")%>">
				<% end if %>
			<% end if %>
		<% end if %>
	<% End If %>

	<!--************************************************************************************
		안심클릭, 가상계좌, 휴대폰, 문화상품권, 해피머니 사용시 필수 항목 - 인증결과를 해당 url로 post함, 즉 이 URL이 화면상에 보여지게 됨
		************************************************************************************-->
	<% IF application("Svr_Info")="Dev" THEN %>
		<input type="hidden" name="P_NEXT_URL" value="http://testm.10x10.co.kr/inipay/card/ordertemp_iniResult.asp">
    <% ELSE %>
		<input type="hidden" name="P_NEXT_URL" value="https://m.10x10.co.kr/inipay/card/ordertemp_iniResult.asp">
	<% END IF %>
	</form>

	<script language="javascript">
		var width = 330;
		var height = 480;
		var xpos = (screen.width - width) / 2;
		var ypos = (screen.width - height) / 2;
		var position = "top=" + ypos + ",left=" + xpos;
		var features = position + ", width=320, height=440";
		var order_form = document.ini;

		order_form.action = "https://mobile.inicis.com/smart/"+order_form.paymethod.value+"/";

		if(window.navigator.appVersion.indexOf("MSIE") >=0)
		{
			document.charset = "euc-kr";
		}

		order_form.submit();
	</script>
<% End If %>
<%
SET irefPgParam = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

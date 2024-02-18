<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'#######################################################
'	Description : 아이디/비밀번호 찾기
'	History	:  2013.02.12 허진원 - 실명인증 없는 방법
'              2013.07.30 허진원 - 2013리뉴얼
'              2016.06.27 허진원 - pingInfo 사용할때만 ajax로 가져오도록 수정
'#######################################################
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/member/iPin/nice.nuguya.oivs.asp" -->


<%
	Response.Charset = "utf-8"
	Dim C_dumiKey : 
	Dim retUrl
	
	
	
	'///이미 본인 인증된 상태라면 리턴시킨다.
	retUrl = request("returnUrl")
	response.write session("isAdult") & " , " & retUrl
	if session("isAdult") = True and retUrl <> "" then 
		Response.redirect retUrl
	end if


	'#######################################################################################
	'#####	개인인증키(대체인증키;아이핀) 서비스				한국신용정보(주)
	'#######################################################################################
	Dim NiceId, SIKey, ReturnURL, pingInfo, strOrderNo
	'// 텐바이텐
	NiceId = "Ntenxten4"		'// 회원사 ID
	SIKey = "N0001N013276"		'// 사이트식별번호 12자리

	'randomize(time())
	strOrderNo = Replace(date, "-", "")  & round(rnd*(999999999999-100000000000)+100000000000)

	'// 해킹방지를 위해 요청정보를 세션에 저장
	session("niceOrderNo") = strOrderNo
%>
<form name="reqMobiForm" method="post" action=""></form>
<script>		
// 패스워드 찾기(모바일본인인증)
	function jsOpenCert() {
		var popupWindow = window.open( "", "KMCISWindow", "width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250" );
		document.reqMobiForm.action = 'popCheckWhoAmI.asp';
		document.reqMobiForm.target = "KMCISWindow";
		document.reqMobiForm.submit();
		popupWindow.focus();
	}
</script>
<%=application("Svr_Info")%>	
<Input Type="button" value="확인" onclick=jsOpenCert() />
<!-- #include virtual="/lib/db/dbclose.asp" -->
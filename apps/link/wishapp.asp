<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 위시APP 기기별 다운로드 링크 전환 (이미 설치된경우 APP 오픈)
'	History	:  2014.06.16 허진원 생성
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim appLink
	if flgDevice="I" then
		'IOS
		appLink = "https://itunes.apple.com/kr/app/id864817011"
	elseif flgDevice="A" then
		'Android
		appLink = "market://details?id=kr.tenbyten.shopping"
	else
		'기타접속은 PC웹의 이벤트 페이지로 이동
		Response.Redirect "http://www.10x10.co.kr/event/eventmain.asp?eventid=50277"
	end if
%>
<!doctype html>
<html lang="ko">
<head>
	<title>10x10</title>
	<script>
	window.onload = function() {
		document.getElementById('loader').src = "tenwishapp://";
		window.setTimeout(function (){ window.location.replace('<%=appLink%>'); }, 50);
	}
	</script>
</head>
<body>
<iframe style="display:none" height="0" width="0" id="loader"></iframe>
</body>
</html>
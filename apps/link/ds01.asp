<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 디즈니 홈페어 가구전 이벤트로 전환 (이미 설치된경우 APP 오픈)
'	History	:  2018.02.23 허진원 생성
'#######################################################
%>
<%
	dim appLink, webLink
	appLink = "http//m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=84856&rdsite=2018DS01"
	webLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid=84856&rdsite=2018DS01"
%>
<!doctype html>
<html lang="ko">
<head>
	<title>10x10</title>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script>
	window.onload = function() {
		var uagentLow = navigator.userAgent.toLocaleLowerCase();
		
		$("body").append("<iframe id='wishapplink'></iframe>");
		$("#wishapplink").hide();

		if(uagentLow.search("android") > -1){
			$("#wishapplink").attr("src", 'tenwishapp://<%=Server.UrlEncode(appLink)%>');
		}
		else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
			//$("#wishapplink").attr("src", 'tenwishapp://<%=appLink%>');
			location.replace("tenwishapp://<%=appLink%>");
		}

		window.setTimeout(function (){ window.location.replace('<%=webLink%>'); }, 1000);
	}
	</script>
</head>
<body>
</body>
</html>
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 앱 오픈
'	History : 2017-01-20 네이버 라인 공유 (앱 없을 경우 스토어로 보냄)
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
Dim strLink , strTitle
strLink = Server.URLEncode(Request("link"))
strTitle = Server.URLEncode(Request("tit"))

'//한줄 내리기
strTitle = strTitle & "%0D%0A"
%>
<!doctype html>
<html lang="ko">
<head>
	<title>10x10</title>
	<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
	<script>
	window.onload = function() {
		var openAt = new Date,
				uagentLow = navigator.userAgent.toLocaleLowerCase(),
				chrome25,
				kitkatWebview;

			$("body").append("<iframe id='wishapplink'></iframe>");

			$("#wishapplink").hide();

			setTimeout( function() {
				if (new Date - openAt < 4000) {
					if (uagentLow.search("android") > -1) {
						$("#wishapplink").attr("src","market://details?id=jp.naver.line.android&hl=ko");
					} else if (uagentLow.search("iphone") > -1) {
						location.replace("https://itunes.apple.com/kr/app/id443904275");
					}
				}
			}, 1000);
			 
			if(uagentLow.search("android") > -1){
				chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
				kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;

				if (chrome25 && !kitkatWebview){
					document.location.href = "intent://line://msg/text/<%=strTitle%><%=strLink %>;scheme=line;package=jp.naver.line.android;end";
				} else{
					$("#wishapplink").attr("src", 'line://msg/text/<%=strTitle%><%=strLink %>');
				}
			}

			else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
				document.location.href = "line://msg/text/<%=strTitle%><%=strLink %>";
			} else {
				alert("안드로이드 또는 IOS 기기만 지원합니다.");
			}
	}
	</script>
</head>
<body>
</body>
</html>
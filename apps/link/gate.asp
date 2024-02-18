<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 앱이 있으면 앱을 호출, 없으면 모바일 사이트 오픈
'	History : 2017.01.04 허진원 생성
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appURLCls.asp"-->

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
				location.replace("http://m.10x10.co.kr/");
			}, 1000);
			 
			if(uagentLow.search("android") > -1){
				chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
				kitkatWebview = uagentLow.indexOf("naver") != -1 || uagentLow.indexOf("daum") != -1;

				if (chrome25 && !kitkatWebview){
					document.location.href = "intent://#Intent;scheme=tenwishapp;package=kr.tenbyten.shopping;end";
				} else{
					$("#wishapplink").attr("src", 'tenwishapp://');
				}
			}
			else if(uagentLow.search("iphone") > -1 || uagentLow.search("ipad") > -1){
				//$("#wishapplink").attr("src", 'tenwishapp://');
				location.replace("tenwishapp://");
			} else {
				alert("안드로이드 또는 IOS 기기만 지원합니다.");
			}
	}
	</script>
</head>
<body>
</body>
</html>
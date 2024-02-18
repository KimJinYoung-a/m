<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<%
	dim strEBUrl:		strEBUrl = "http://fiximage.10x10.co.kr/m/event/wish/event/"
	dim strAppWVUrl:	strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/webview"

	dim arrEvtUrl, arrEvtImg, arrEvtName, lp
	arrEvtUrl = split("/event/eventmain.asp?eventid=50386,/event/eventmain.asp?eventid=50553,/event/eventmain.asp?eventid=50289,/event/eventmain.asp?eventid=50159,/event/eventmain.asp?eventid=50318,/event/eventmain.asp?eventid=50499",",")
	arrEvtImg = split("android_03_50386.jpg,android_00.jpg,android_01_50289.jpg,android_02_50159.jpg,android_04_50318.jpg,android_05_50499.jpg",",")
	arrEvtName = split("리빙페어,회원가입혜택,All-Natural,Dogeared,Early bird,Really Useful Box",",")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10</title>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/style.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/jquery.bxslider.css">
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery-latest.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/common.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/tencommon.js"></script>
</head>
<body class="event-pop">
	<ul class="event-banners bxslider">
	<%
		for lp=0 to ubound(arrEvtUrl)
	%>
		<li>
            <a href="#" onclick="openevent('<%=b64encode(strAppWVUrl & arrEvtUrl(lp))%>');return false;"><img src="<%=strEBUrl & arrEvtImg(lp)%>" alt="<%=arrEvtName(lp)%>"></a>
        </li>
	<%
		next
	%>
    </ul>
    <script>

    $('.bxslider').bxSlider({
        minSlides: 1,
        maxSlides: 1,
        moveSlides: 1,
        slideMargin: 10,
        controls: false,
        infiniteLoop: false
    });

    </script>
</body>
</html>
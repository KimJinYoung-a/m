<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/base64New.asp" -->
<%
function replace64(org)
    replace64 = replace(replace(Base64encode(org),"+","-"),"/","_")
end function
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10</title>
<link rel="stylesheet" type="text/css" href="../css/style.css">
<link rel="stylesheet" type="text/css" href="../css/jquery.bxslider.css">
<script type="text/javascript" src="../js/jquery-latest.js"></script>
<script type="text/javascript" src="../js/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/tencommon.js"></script>
</head>
<body class="event-pop">

    <ul class="event-banners bxslider">
        <li>
            <a href="#" onclick="openevent('<%=replace64("http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=50270")%>');return false;"><img src="../img/_dummy-event-banner.jpg" alt="이벤트명"></a>
        </li>
        <li>
            <a href="#" onclick="openevent('<%=replace64("http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=998755")%>');return false;"><img src="../img/_dummy-event-banner.jpg" alt="이벤트명"></a>
        </li>
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
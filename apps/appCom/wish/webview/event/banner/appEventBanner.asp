<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<%
	dim strSql, lp
	dim strAppWVUrl
	IF application("Svr_Info")="Dev" THEN
		strAppWVUrl = "http://testm.10x10.co.kr/apps/appCom/wish/webview"
	else
		strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/webview"
	end if

	'// 진행중인 이벤트 접수
	strSql = "select top 5 eventname, bannerImg, bannerLink, bannerType "
	strSql = strSql & "from db_contents.dbo.tbl_app_eventBanner "
	strSql = strSql & "where isUsing='Y' "
	strSql = strSql & "	and getdate() between startdate and enddate "
	strSql = strSql & "	and appname='wishapp' "
	strSql = strSql & "order by bannerType asc, sortNo asc, idx desc"
	rsget.Open strSql, dbget, 1

	if Not(rsget.EOF or rsget.BOF) then
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
<%
	if rsget("bannerType")="F" then
		'## 풀배너는 1개만 출력
%>
	<a href="#" onclick="openevent('<%=b64encode(strAppWVUrl & rsget("bannerLink"))%>');return false;"><img src="<%=rsget("bannerImg")%>" alt="<%=Replace(rsget("eventname"),"""","")%>"></a>
<%
	else
		'## 하프배너는 5개까지 출력 후 롤링
%>
	<ul class="event-banners bxslider">
		<%
			For lp=0 to rsget.RecordCount-1
		%>
		<li>
            <a href="#" onclick="openevent('<%=b64encode(strAppWVUrl & rsget("bannerLink"))%>');return false;"><img src="<%=rsget("bannerImg")%>" alt="<%=Replace(rsget("eventname"),"""","")%>"></a>
        </li>
        <%
        		rsget.MoveNext
        	Next
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
<%	end if %>
</body>
</html>
<%
	end if

	rsget.Close
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
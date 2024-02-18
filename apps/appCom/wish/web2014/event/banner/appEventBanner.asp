<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	dim strSql, lp
	dim strAppWVUrl
	IF application("Svr_Info")="Dev" THEN
		strAppWVUrl = "http://testm.10x10.co.kr/apps/appCom/wish/web2014"
	else
		strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/web2014"
	end if

	'// 진행중인 이벤트 접수
	strSql = "select top 1 eventname, bannerImg, bannerLink, bannerType "
	strSql = strSql & "from db_contents.dbo.tbl_app_eventBanner "
	strSql = strSql & "where isUsing='Y' "
	'strSql = strSql & "	and getdate() between startdate and enddate "
	strSql = strSql & "	and appname='wishapp' "
	'strSql = strSql & "	and bannertype='F'"
	strSql = strSql & "order by bannerType asc, sortNo asc, idx desc"
	rsget.Open strSql, dbget, 1

    if Not(rsget.EOF or rsget.BOF) then
%>
<script>
$(function() {
	/*
	mySwiper = new Swiper('.coverFullBnr .swiper-container',{
		pagination:'.pagination',
		paginationClickable: true,
		calculateHeight:true
	})
	*/
});
</script>
</head>
<body>
<div class="coverFullBnr">
	<div class="swiper-container">
		<div class="swiper-wrapper">
		<% for lp=0 to rsget.RecordCount-1 %>
			<p class="swiper-slide"><a href="#" onclick="fnAPPpopupEvent_URL('<%=(strAppWVUrl & rsget("bannerLink"))%>');return false;"><img src="<%=rsget("bannerImg")%>" alt="<%=Replace(rsget("eventname"),"""","")%>" /></a></p>
		<%
			rsget.MoveNext
			Next
		%>
		</div>
		<div class="pagination"></div>
	</div>
</div>
</body>
</html>
<%
	end if
	rsget.Close
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
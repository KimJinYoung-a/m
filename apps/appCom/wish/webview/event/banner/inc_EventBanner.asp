<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
	dim strSql, lp
	dim strAppWVUrl, vBnrImg
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
	strSql = strSql & "	and idx not in (24,36) "
	strSql = strSql & "order by bannerType asc, sortNo asc, idx desc"
	rsget.Open strSql, dbget, 1

	if Not(rsget.EOF or rsget.BOF) then
%>
	<script type="text/javascript" src="/apps/appCom/wish/webview/js/swiper-2.1.min.js"></script>
	<style type="text/css">
	.EvtBnr {position:relative; margin:0 auto; padding:0 0 20px 0; overflow:hidden;}
	.EvtBnr .swiper-container {width:100%; overflow:hidden; margin:0 auto;}
	.EvtBnr .swiper-wrapper {overflow:hidden;}
	.EvtBnr .swiper-slide {float:left;}
	.EvtBnr .swiper-slide img {width:100%; vertical-align:top;}
	
	.slidePage {position:absolute; left:0; width:100%; bottom:0; text-align:center; margin:5px 0;}
	.slidePage span {width:7px; height:7px; display:inline-block; text-align:center; text-indent:-9999px; background-image:url(http://fiximage.10x10.co.kr/m/2013/common/element_dotpage.png); background-size:17px 7px; background-position:-10px top; background-repeat:no-repeat; margin:0 2px;}
	.slidePage span.swiper-active-switch {background-position:left top;}
	</style>
<%
	if rsget("bannerType")<>"F" then
		'## 하프배너는 5개까지 출력 후 롤링
%>
	<div class="EvtBnr">
        <div class="swiper-container swiper1">
            <div class="swiper-wrapper">
		<%
			For lp=0 to rsget.RecordCount-1
				vBnrImg = rsget("bannerImg")
				''vBnrImg = "http://webimage.10x10.co.kr/appmanage/eventBanner/2014/bannerImg20140417174818.JPEG"	'테스트 이미지
		%>
		<div class="swiper-slide"><a href="<%=strAppWVUrl & rsget("bannerLink")%>"><img src="<%=vBnrImg%>" alt="<%=Replace(rsget("eventname"),"""","")%>" /></a></div>
        <%
        		rsget.MoveNext
        	Next
        %>
            </div>
        </div>
        <div class="slidePage pagination"></div>
    </div>
    <script>
	$(function(){
		swiper = new Swiper('.swiper1', {
			pagination:'.pagination',
			paginationClickable:true,
			resizeReInit:true,
			calculateHeight:true,
			loop:false
		});
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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  크리스마스 기획전
' History : 2018-11-12 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
    dim link_option 
    dim updateDate, testDate, currentDate, updatePage, originPage

    currentDate = date()
    'feed 페이지 설정부분
    updateDate = cdate("2018-12-14")
    updatePage = "xmas_main_exec_1214.asp"
    originPage = "xmas_main_exec_1213.asp"

    testDate = request("testdate")

    if testDate <> "" then
        currentDate = cdate(testDate)
    end if

    link_option = request("link")
    if link_option = "" then link_option = 1    
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/xmas2018.css?v=1.2" />
<script type="text/javascript">

$(function() {
    fnAmplitudeEventMultiPropertiesAction('view_2018christmas_main','','');
	/* tag */
	var tagSwiper = new Swiper (".xmas-insta .tag .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});
});
</script>
</head>
<body class="default-font body-main">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->	
<%
    if link_option = 1 then
        if currentDate >= updateDate   then
            server.Execute("/christmas/2018/"&updatePage)
        else
            server.Execute("/christmas/2018/"&originPage)
        end if        
    else 
        server.Execute("/christmas/2018/xmas_pick_exec.asp")
    end if
%>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
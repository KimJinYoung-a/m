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
<!-- #include virtual="/lib/inc_const.asp" -->
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=75258",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=chkIIF(application("Svr_Info")="Dev","66261","75258")%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<!-- 해피뉴이어 전면 배너 -->
	<div class="appFrontBanner">
		<a href="" onclick="app_mainchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75258/m/bnr_front_a.png" alt="해피뉴이어쿠폰 이벤트 참여하기" /></a>
	</div>
	<!--// 해피뉴이어 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
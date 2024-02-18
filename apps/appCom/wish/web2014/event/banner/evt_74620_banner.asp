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
		data: "mode=app_main&ecode=74620",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=chkIIF(application("Svr_Info")="Dev","66245","74620")%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<!-- Evnt74620 전면 배너 -->
<div class="appFrontBanner">
	<a href="" onclick="app_mainchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74620/m/txt_front_banner.jpg" alt="해피두개더 12월 텐바이텐에 가입하는 모든 분들께 드립니다.! 6만원 이상 구매시 10,000원 10만원 이상 구매시 15,000원 사용기간: 발급 후 24시간 쿠폰 다운받기" /></a>
</div>
<!--// Evnt74620 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
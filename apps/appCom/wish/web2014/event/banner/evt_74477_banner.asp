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
<style type="text/css">
img {vertical-align:top;}

.happiness4000 {position:relative;}
.happiness4000 .btnGo {position:absolute; bottom:3.31%; left:50%; width:78.125%; margin-left:-39.0625%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=74477",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=chkIIF(application("Svr_Info")="Dev","66240","74477")%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<div class="mEvt74249 happiness4000">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/img_bnr_full.jpg" alt="사천원으로 행복한 시간 앱에서 첫 로그인하고 사천원으로 구매하세요!" /></p>
		<a href="#" onclick="app_mainchk(); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74249/m/btn_go_event.png" alt="이벤트 보러가기" /></a>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
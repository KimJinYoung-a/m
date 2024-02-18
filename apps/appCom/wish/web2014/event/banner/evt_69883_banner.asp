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

.tenwon {position:relative;}
.tenwon .btnEnter {position:absolute; bottom:5%; left:50%; width:86.25%; margin-left:-43.125%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=69883",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=69883');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<%' [A] 69883 10원의 마술상 전면배너 %>
	<div class="mEvt69883 tenwon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_tenwon_front_banner.jpg" alt="텐바이텐과 처음처럼이 함께하는 10원의 마술상 지금 단돈 10원으로 구매할 수 있는 이 놀라운 마술상을 직접 확인 해 보세요!" /></p>
		<%' 69883 10원의 마술상 이벤트로 링크 걸어주세요 %>
		<a href="" class="btnEnter" onclick="app_mainchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/btn_event.png" alt="이벤트 참여하기" /></a>
	</div>
	<!--// 10원의 마술상 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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

.chamberOfSecret {position:relative;}
.chamberOfSecret .btnGo {display:block; position:absolute; bottom:3%; left:50%; width:65.46%; margin-left:-32.73%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=70715",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=70715');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<div class="mEvt70714 chamberOfSecret">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70714/txt_chamber_of_secret.jpg" alt="불이 켜진 비밀의 방으로 당신을 초대합니다. 초대장을 받으신 분들에게만 선물이 찾아갑니다! " /></p>
		<a href="" onclick="app_mainchk(); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_go_event.png" alt="이벤트 참여하기" /></a>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
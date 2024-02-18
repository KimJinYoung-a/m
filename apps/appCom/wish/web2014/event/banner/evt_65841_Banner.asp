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
.mEvt65803 {position:relative;}
.mEvt65803 .btnevent {position:absolute; bottom:5%; left:50%; width:75.625%; margin-left:-37.8125%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=65841",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=65803');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<div class="mEvt65803">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/img_front_banner.png" alt="정해진 답은 아무것도 없다! 동승동 제목학원 당신이 바로 우등생! 매일 10명에게 GIFT CARD 5만원권 증정" /></p>
	<a href="" onclick="app_mainchk(); return false;" class="btnevent"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_event.png" alt="이벤트 참여하기" /></a>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
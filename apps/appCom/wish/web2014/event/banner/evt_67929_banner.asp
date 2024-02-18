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

.mEvt67929 {position:relative;}
.mEvt67929 .hidden {visibility:hidden; width:0; height:0;}
.mEvt67929 .btngo {position:absolute; bottom:3.5%; left:50%; width:79.68%; margin-left:-39.84%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=67929",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=67929');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<div class="mEvt67929">
		<article>
			<h2 class="hidden">돌아온 크리스박스</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/02/img_bnr_front_v1.jpg" alt="매일 오전 10시 배송비 2천원만 결제하면 크리스박스가 갑니다" /></a></p>
			<a href="" onclick="app_mainchk(); return false;" class="btngo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/02/btn_go.png" alt="이벤트 참여하기" /></a>
		</article>
	</div>
</body>
</html>
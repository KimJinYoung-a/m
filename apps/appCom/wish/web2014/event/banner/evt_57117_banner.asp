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
<%
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21387
	Else
		evt_code   =  57117
	End If
%>
<style type="text/css">
.lucky-box-banner {position:relative;}
.lucky-box-banner img {vertical-align:top;}
.lucky-box-banner .btn-go {position:absolute; bottom:23%; left:50%; width:64%; margin-left:-32%;;}
</style>
<script>
function c3countchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript57117.asp",
		data: "mode=c3countchk",
		dataType: "text",
		async: false
	}).responseText;
	fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=evt_code%>');
}

</script>
</head>
<body>
	<!-- [럭키백]크리스박스의 기적 전면 배너-->
	<div class="lucky-box-banner">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/tit_christmas_miracle.gif" alt="산타도 모르는 텐바이텐 럭키박스 이벤트 크리스박스의 기적" /></h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/txt_event.gif" alt="배송비만 내고, 크리스박스의 주인공이 되세요! 산타도 모르는 기적의 상품이 여러분을 찾아갑니다. 이벤트 기간은 2014년 12월 3일부터 12월 12일까지며, 매일 오후 3시에 새로운 크리스박스가 오픈됩니다." /></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/img_christbox_gift.jpg" alt="" /></div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/txt_hurry_up.gif" alt="배송비 이천원만 결제하면, 크리스박스가 갑니다! 한정수량! 서두르세요" /></p>
		<div class="btn-go">
			<a href="" onclick="c3countchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57117/btn_go_event.gif" alt="이벤트 바로가기" /></a>
		</div>
	</div>
	<!--// [럭키백]크리스박스의 기적 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
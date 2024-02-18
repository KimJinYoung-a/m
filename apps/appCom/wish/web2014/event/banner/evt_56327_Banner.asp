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
	
%>
<script>
$(function() {
	/*
	mySwiper = new Swiper('.coverFullBnr .swiper-container',{
		pagination:'.pagination',
		paginationClickable: true,
		calculateHeight:true
	})
	*/

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
			}, 500);
	});
});

function countchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript56327.asp",
		data: "mode=countchk",
		dataType: "text",
		async: false
	}).responseText;
	fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=56327');
}

</script>
<style type="text/css">
.mEvt56327Bnr img {vertical-align:top;}
.mEvt56327Bnr .banner {position:relative; width:100%;}
.mEvt56327Bnr .goEvt {display:block; position:absolute; left:10%; bottom:4%; width:80%;}
.mEvt56327Bnr .close {display:block; position:absolute; right:3%; top:2%; width:6%; cursor:pointer;}
.mEvt56327Bnr .hiddenToday {padding:12px 14px; background:#e9fcff;}
.mEvt56327Bnr .hiddenToday label {vertical-align:middle; font-size:12px; color:#616161; padding-left:8px;}
@media all and (min-width:480px){
	.mEvt56327Bnr .hiddenToday {padding:18px 21px;}
	.mEvt56327Bnr .hiddenToday label {font-size:18px; padding-left:12px;}
}
</style>
</head>
<body>
<div class="coverFullBnr">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="mEvt56327Bnr">
				<div class="banner">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/bnr_head.png" alt="" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/bnr_event_cont.png" alt="" /></p>
					<a href="" onclick="countchk(); return false;" class="goEvt"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/bnr_btn_go.png" alt="" /></a>
				</div>
			</div>
		</div>
		<div class="pagination"></div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
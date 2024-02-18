<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' PLAY #19 세상에 하나뿐인 스티커
' 2015-04-24 유태욱 작성
'########################################################
Dim eCode, userid, vQuery, vIDX, vContentsIDX
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "62772"
	vIDX	= "20"
	vContentsIDX	= "1077"
Else
	eCode   =  "62783"
	vIDX	= "20"
	vContentsIDX	= "85"
End If

userid = getloginuserid()

Dim strSql, enterCnt, sakuraCnt, overseasCnt

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		enterCnt = rsget(0)
	End IF
	rsget.close

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/preVst/section.css" />
<link rel="stylesheet" type="text/css" href="/lib/css/sectionV15.css" />
<style type="text/css">
img {vertical-align:top;}
.app {display:none;}

.menupan {padding:10% 0; background:#f6f6f6 url(http://webimage.10x10.co.kr/playmo/ground/20150525/bg_pattern_dot.png) repeat-y 50% 0; background-size:100% auto;}
.menupan ul {overflow:hidden; padding:0 5%}
.menupan ul li {float:left; width:50%; margin-top:10%;}
.menupan ul li a {display:block; margin:0 5%;}

.rollingwrap {padding:10% 0 24%; background-color:#fff;}
.rolling {width:280px; margin:0 auto;}
.swiper {position:relative;}
.swiper .swiper-wrapper {overflow:hidden;}
.swiper button {position:absolute; bottom:-14%; z-index:150; width:18px; background:transparent;}
.swiper .pagination {position:absolute; bottom:-12%; left:0; width:100%; height:10px !important; padding-top:0 !important;}
.pagination .swiper-pagination-switch {width:10px; height:10px; margin:0 5px; border:1px solid #777; border-radius:50%; background:transparent;}
.pagination .swiper-active-switch {background-color:#777;}
.swiper .prev {left:25%;}
.swiper .next {right:25%;}

.myorder {background:#f6c9ce url(http://webimage.10x10.co.kr/playmo/ground/20150525/bg_pattern_paper.png) repeat-y 50% 0; background-size:100% auto;}
.myorder .btnorder {display:block; width:66%; margin:0 auto; background-color:transparent;}
.myorder .counting {margin:7% 3% 5%; padding:5% 0 4.6%; border-top:1px solid #dda5ac; border-bottom:1px solid #dda5ac; color:#6c222a; font-size:15px; font-weight:bold; text-align:center;}
.myorder .counting strong {color:#000;}
.myorder .brand {padding-top:5%;}

@media all and (min-width:360px){
	.rolling {width:300px;}
}

@media all and (min-width:480px){
	.rolling {width:360px;}
	.swiper .pagination {height:15px !important;}
}

@media all and (min-width:600px){
	.rolling {width:520px;}
	.swiper button {width:24px;}
	.swiper .pagination {padding-top:0;}
	.pagination .swiper-pagination-switch {width:15px; height:15px; margin:0 7px;}
	.myorder .counting {font-size:22px;}
}

@media all and (min-width:766px){
	.rolling {width:600px;}
	.swiper button {width:24px}
}
</style>
<script type="text/javascript">
function jsSubmit(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/play/playGround_review.asp?idx="&vIDX&"&contentsidx="&vContentsIDX&"")%>');
			return false;
		<% end if %>
	<% end if %>
	var rstStr = $.ajax({
		type: "POST",
		url: "/play/groundcnt/doEventSubscript62783.asp",
//		data: "",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr.substring(0,2) == "01"){
		var enterCnt;
		enterCnt = rstStr.substring(5,10);
		$("#entercnt").empty().append("<strong>"+enterCnt+"</strong>");
		alert('응모 완료!');
		return false;

	}else if (rstStr == "02"){
		alert('5회 까지만 참여 가능 합니다.');
		return false;
	}else{
		alert('관리자에게 문의');
		return false;
	}
}
</script>
</head>
<body>
<div class="mPlay20150525">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/tit_flower_cafe.png" alt="으랏차차! 차 꽃 다방" /></h1>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_welcome.png" alt="으랏차차! 꽃다방에 오신 것을 환영합니다. 저희 다방에는 당신을 위한 여러 가지 꽃차가 준비되어 있습니다. 당신에게 필요한 차가 우러나는 시간 동안 따뜻한 대화를 나눠보기도 하고, 풍미를 맡기도 하며 차분한 마음을 가져보세요. 말하는 대로 이루어지게 해 줄 꽃차! 자 이제부터 우리 꽃다방 대표 꽃차들을 소개합니다." /></p>
	</div>

	<div class="menupan">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/tit_menu.png" alt="메뉴" /></h2>
		<ul>
			<li class="tea1"><a href="#cont1"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_menu_01.png" alt="기운차 맛보기" /></a></li>
			<li class="tea2"><a href="#cont2"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_menu_02.png" alt="그만차 맛보기" /></a></li>
			<li class="tea3"><a href="#cont3"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_menu_03.png" alt="장차 맛보기" /></a></li>
			<li class="tea4"><a href="#cont4"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_menu_04.png" alt="미차 맛보기" /></a></li>
		</ul>
	</div>

	<div class="rollingwrap">
		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/img_slide_04.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/btn_next.png" alt="다음" /></button>
			</div>
		</div>
	</div>

	<!-- tea -->
	<div class="tea">
		<div id="cont1" class="article">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_tea_01.jpg" alt="원기회복을 도와주는 기운차 자스민 꽃은 심신 안정에 효과적입니다. 기운차는 자스민꽃을 베이스로 만들어진 차입니다. 따뜻한 차로 몸을 다스리고, 기운차게 다시 일어나보세요! 아자 아자!" /></p>
		</div>
		<div id="cont2" class="article">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_tea_02.jpg" alt="화가 많은 당신에게 그만차 우롱차는 몸속의 독소를 해독하는 데 효과적입니다. 그만차는 우롱차를 베이스로 만들어진 차입니다. 차를 우리고 호호 불어 마시는 시간 동안만이라도 그만 걷어차고, 화를 다스려보세요!" /></p>
		</div>
		<div id="cont3" class="article">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_tea_03.jpg" alt="취업이 걱정인 당신에게 장차 라벤더차는 불안감과 두통을 없애는 데 효과적입니다. 장차는 라벤더꽃을 베이스로 만들어진 차입니다. 취업에 실패한다고 자신을 탓하지 마세요. 왜냐하면, 당신은 장차 큰 인물이 될테니까요." /></p>
		</div>
		<div id="cont4" class="article">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_tea_04.jpg" alt="예뻐지고 싶은 당신에게 미차 히비스커스차는 피부노화방지에 효과적입니다. 미차는 히비스커스꽃을 베이스로 만들어진 차입니다. 고혹적인 꽃향기를 맡으며 우아하게 차를 마시고, 미모를 되찾아보세요!" /></p>
		</div>
	</div>

	<!-- order -->
	<div class="myorder">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_order.png" alt="당신을 위해 준비된 꽃차를 주문하시겠습니까? 추첨을 통해 총 10분에게 으랏차차 꽃다방세트를 선물로 드립니다! 이벤트 기간은 2015년 5월 25일부터 6월 3일까지며, 당첨자 발표는 2015년 6월 4일입니다. 당첨되신 분께 개인정보 제공을 요청할 수 있으며, 사은품 정보 입력 목적 외에는 사용하지 않습니다." /></p>
		<!-- for dev msg : 꽃차 주문하기 .버튼 -->
		<button type="button" class="btnorder" onclick="jsSubmit();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/btn_order.png" alt="꽃차 주문하기" /></button>
		<!-- for dev msg : 꽃차 주문 카운팅 -->
		<p class="counting">지금까지 <span id="entercnt"><strong><%= enterCnt %></strong></span> 명이 꽃차를 주문하셨습니다.</p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_note.png" alt="개인정보 제공을 요청할 수 있으며, 사은품 정보 입력 목적 외에는 사용하지 않습니다." /></p>
		<p class="brand">
			<a href="/street/street_brand.asp?makerid=teagarden" target="_top" title="브랜드 바로 가기 새창" class="mo"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_brand.png" alt="꽃다방의 모든 꽃차는 브랜드 ROYAL ORCHARD / Revolution 제품으로 안전하게 유통 판매되고 있는 식품입니다." /></a>
			<a href="" onclick="parent.fnAPPpopupBrand('teagarden'); return false;" title="브랜드 바로 가기 새창" class="app"><img src="http://webimage.10x10.co.kr/playmo/ground/20150525/txt_brand.png" alt="꽃다방의 모든 꽃차는 브랜드 ROYAL ORCHARD / Revolution 제품으로 안전하게 유통 판매되고 있는 식품입니다." /></a>
		</p>
	</div>

</div>
<form name="frmcom" method="post" action="doEventSubscript62783.asp" style="margin:0px;">
	<input type="hidden" name="votetour">
</form>
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		pagination:false,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3500,
		speed:1000,
		pagination:'.pagination',
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$(".menupan ul li a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
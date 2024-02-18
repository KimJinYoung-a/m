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
Dim eCode, userid, vQuery
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61763
Else
	eCode   =  61954
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
.mPlay20150427 {}
.mPlay20150427 img {width:100%; vertical-align:top;}
.swiperWrap {position:relative; background:url(http://webimage.10x10.co.kr/playmo/ground/20150427/bg_slide.gif) left top no-repeat; background-size:100% 100%;}
.swiper {overflow:hidden; width:320px; margin:0 auto;}
.swiper .swiper-container {width:100%;}
.swiper button {position:absolute; top:40%; width:10.5%; background:transparent; z-index:30;}
.swiper .arrowLeft {left:0;}
.swiper .arrowRight {right:0;}
.swiper .sPaging {position:absolute; left:0; bottom:0; width:100%; z-index:30; text-align:center;}
.swiper .sPaging span {display:inline-block; width:8px; height:8px; margin:0 5px; border-radius:50%; background:#fff;}
.swiper .sPaging span.swiper-active-switch {background:#000;}
.process {background:#ffeeda;}
.process a {display:block; width:66.5%; margin:0 auto;}
.brandStory {position:relative;}
.brandStory a {display:none; position:absolute; left:16.5%; bottom:11.5%; width:67%; height:7.5%; color:transparent;}
.applySticker {padding-bottom:15%; background:#ff6969;}
.applySticker .btnApply {display:block; width:85%; margin:0 auto;}
.applySticker .total {width:75%; margin:0 auto; padding:3.5% 0; text-align:center; background:#fff;}
.applySticker .total span {font-size:18px; line-height:1.1; letter-spacing:-1px; margin:0 -3px 0 -2px; font-weight:bold; color:#000;}
.applySticker .total .t01 {width:69px;}
.applySticker .total .t02 {width:23px;}
.applySticker .total .t03 {width:197px;}
@media all and (min-width:360px){
	.swiper {width:360px;}
}
@media all and (min-width:480px){
	.swiper {width:480px;}
	.swiper .sPaging span {width:12px; height:12px; margin:0 7px;}
	.applySticker .total span {font-size:27px;}
	.applySticker .total .t01 {width:104px;}
	.applySticker .total .t02 {width:35px;}
	.applySticker .total .t03 {width:296px;}
}
@media all and (min-width:568px){
	.swiper {width:568px;}
}
@media all and (min-width:640px){
	.swiper {width:640px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.sPaging',
		speed:600,
		autoplay:false,
		autoplayDisableOnInteraction: true
	});
	$('.arrowLeft').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.arrowRight').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$(".goMake").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
	}else{
		$(".mw").show();
	}
});

function jsSubmit(){
	<% if Not(IsUserLoginOK) then %>
	    jsChklogin('<%=IsUserLoginOK%>');
	    return false;
	<% end if %>
	var rstStr = $.ajax({
		type: "POST",
		url: "/play/groundcnt/doEventSubscript61954.asp",
//		data: "",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr.substring(0,2) == "01"){
		var enterCnt;
		enterCnt = rstStr.substring(5,10);
		$("#entercnt").html(enterCnt);
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
	<!-- GROUND#4 세상에 하나뿐인 스티커 -->
	<div class="mPlay20150427">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/tit_only_sticker.jpg" alt="세상에 하나뿐인 스티커" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_make_sticker.gif" alt="세상에 하나뿐인 스티커를 만들어 드립니다." /></p>
		<div class="swiperWrap">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_slide01.png" alt="스티커 이미지1" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_slide02.png" alt="스티커 이미지2" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_slide03.png" alt="스티커 이미지3" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_slide04.png" alt="스티커 이미지3" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_slide05.png" alt="스티커 이미지3" /></div>
					</div>
					<div class="sPaging"></div>
				</div>
				<button type="button" class="arrowLeft"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/btn_prev.png" alt="이전" /></button>
				<button type="button" class="arrowRight"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/btn_next.png" alt="다음" /></button>
			</div>
		</div>
		<div class="process">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_process.gif" alt="스티커 제작과정" /></p>
			<a href="#applySticker" class="goMake"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/btn_go_make.gif" alt="스티커 만들러 가기" /></a>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/img_sample.jpg" alt="스티커 활용컷" /></div>
		<div class="brandStory">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_brand_story.jpg" alt="BRAND STORY" /></p>
			<a href="/street/street_brand.asp?makerid=limpalimpa" target="_top"class="goBrand mw">브랜드 바로가기</a>
			<a href="#" onclick="parent.fnAPPpopupBrand('limpalimpa'); return false;" class="goBrand ma">브랜드 바로가기</a>
		</div>
		<!-- 스티커 신청하기 -->
		<div id="applySticker" class="applySticker">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/tit_apply_sticker.gif" alt="세상에 하나뿐인 스티커를 만들어 드립니다." /></h3>
			<div class="total">
				<p>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_count01.gif" alt="지금까지 총" class="t01" />
					<span id="entercnt"><%= enterCnt %></span>
					<img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_count02.gif" alt="명이" class="t02" />
				</p>
				<p class="tPad05"><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_count03.gif" alt="하나뿐인 스티커를 신청하셨습니다." class="t03" /></p>
			</div>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150427/txt_period.gif" alt="당첨되신 분에 한해 스티커로 제작하실 사진을 요청 드릴 예정입니다." /></p>
			<input type="image" onclick="jsSubmit();return false;" src="http://webimage.10x10.co.kr/playmo/ground/20150427/btn_apply.gif" alt="스티커 신청하기" class="btnApply" />
		</div>
		<!--// 스티커 신청하기 -->
	<form name="frmcom" method="post" action="doEventSubscript61954.asp" style="margin:0px;">
		<input type="hidden" name="votetour">
	</form>
	</div>
	<!--// GROUND#4 세상에 하나뿐인 스티커 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
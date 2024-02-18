<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : 텐바이텐 x 왓챠 - 링크페이지
' History : 2014.06.25 이종화
'###########################################################
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐x왓챠</title>
<style type="text/css">
.mEvt52831 {position:relative;}
.mEvt52831 img {vertical-align:top; width:100%;}
.mEvt52831 p {max-width:100%;}
.mEvt52831 .giftSlide {background:#ef6257;}
.mEvt52831 .swiper {position:relative; width:463px; height:284px; margin:0 auto; padding:13px 0 33px;}
.mEvt52831 .swiper .swiper-container {overflow:hidden; height:284px;}
.mEvt52831 .swiper .swiper-slide {float:left;}
.mEvt52831 .swiper .swiper-slide a {display:block; width:100%;}
.mEvt52831 .swiper .swiper-slide img {width:100%; vertical-align:top;}
.mEvt52831 .swiper .btnArrow {display:block; position:absolute; top:50%; margin-top:-22px; z-index:10; width:37px; height:44px; text-indent:-9999px; background-repeat:no-repeat; background-position:left top; background-size:100% auto;}
.mEvt52831 .swiper .arrow-left {left:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52831/btn_prev.png);}
.mEvt52831 .swiper .arrow-right {right:0; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/52831/btn_next.png);}
.mEvt52831 .swiper .pagination {position:absolute; left:0; bottom:0; width:100%; text-align:center;}
.mEvt52831 .swiper .pagination span {position:relative; display:inline-block; width:17px; height:17px; margin:0 10px; border-radius:12px; background:#fff;}
.mEvt52831 .swiper .pagination .swiper-active-switch {background:#cb2013;}
.mEvt52831 .appDownload {padding:30px 20px; background:#faeccb;}
.mEvt52831 .evtNoti {padding:24px 10px; text-align:left; background:#fff3d7;}
.mEvt52831 .evtNoti dt {padding:0 0 12px 12px}
.mEvt52831 .evtNoti dt img {width:108px;}
.mEvt52831 .evtNoti li {position:relative; padding:0 0 5px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt52831 .evtNoti li:after {content:''; display:block; position:absolute; top:2px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width: 4px 0 4px 6px;}
@media all and (max-width:480px){
	.mEvt52831 .swiper {width:302px; height:183px; padding:9px 0 23px;}
	.mEvt52831 .swiper .swiper-container {height:183px;}
	.mEvt52831 .swiper .pagination span {width:12px; height:12px; margin:0 7px;}
	.mEvt52831 .evtNoti dt img {width:75px;}
	.mEvt52831 .evtNoti li {padding:0 0 3px 12px; font-size:11px; line-height:12px; letter-spacing:-0.055em;}
	.mEvt52831 .evtNoti li:after {top:1px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
	var mySwiper = new Swiper('.swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.pagination',
		paginationClickable:true,
		speed:180
	})
	$('.swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
	var oTm = setInterval(function () {
		mySwiper.reInit();
			clearInterval(oTm);
		}, 1);
	});
});
</script>
</head>
<body>
	<div class="mEvt52831">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/tit_flutter_word.png" alt="나를 설레게 했던 그 한마디 - 여러분이 기억하는 영화 속 명대사는 무엇인가요? 영화 필수 앱 왓챠에서 드리는 특별한 선물! 명대사가 담긴 마이보틀 or 텐바이텐 기프트카드를 선물로 드립니다." /></h3>
		<div class="giftSlide">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_slide_gift01.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_slide_gift02.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_slide_gift03.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_slide_gift04.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_slide_gift05.png" alt="" /></div>
					</div>
					<div class="pagination"></div>
				</div>
				<a class="btnArrow arrow-left" href="">Previous</a>
				<a class="btnArrow arrow-right" href="">Next</a>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_gift.png" alt="이벤트 사은품 - 월머그 리유즈 보틀 명대사 6종 중 택1/텐바이텐 기프트카드 5,000원" /></p>
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/tit_event_info.png" alt="이벤트 참여방법" /></dt>
			<dd>
				<ol>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_event_process01.png" alt="1. 구글 플레이 or 앱스토어에서 영화 필수 앱 왓챠를 설치" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_event_process02.png" alt="2. 내가 본 영화에 별점을 매겨 취향을 알려준 뒤, 페북이나 이메일로 1초만에 가입" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/img_event_process03.png" alt="3. 왓챠X텐바이텐 여름 맞이 이벤트 배너를 찾아, 텐바이텐 ID를 입력하면 끝~!" /></li>
				</ol>
			</dd>
		</dl>
		<div class="appDownload"><a href="http://watcha.net/download/app?ref=tenbyten
	" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/btn_watcha_download.png" alt="왓챠 앱 다운로드" /></a></div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/txt_watcha_info.png" alt="영화 필수앱 왓챠! - 주변 여러 극장의 시간표를 한 눈에 비교, 연인과의 영화 궁흡 알아 보고 취향에 맞는 영화 추천, 영화 평론가 이동진의 별점과 한줄평" /></p>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52831/tit_noti.png" alt="이벤트 유의사항" /></dt>
			<dd>
				<ul>
					<li>왓챠 APP을 설치 후 로그인하여 응모하실 수 있습니다.</li>
					<li>당첨자 발표 및 사은품 증정은 왓챠 APP을 통해서 확인해주세요.</li>
					<li>왓챠 APP은 구글 플레이스토어 및 IOS 앱스토어에서 설치 가능 합니다.</li>
					<li>당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청 할 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
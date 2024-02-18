<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 플레이 굿즈 돼지봉투
' History : 2019-01-18 최종원
'####################################################
dim mainRollingParm
mainRollingParm = request("gaparam")
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.goods-697 .topic {position: relative; background-color: #ffe86d;}
.goods-697 .topic:before {content: ''; display: block; width: 1000rem; height: 66.56rem; background-image: url(http://webimage.10x10.co.kr/fixevent/play/goods/697/bg_topic.png); background-size: auto 100%; animation: emoticon 140s infinite linear;}
.goods-697 .topic div {position: absolute; top: 0}
.goods-697 .img-wrap {background-color: #f46635;}
.goods-697 .img-wrap dl {position: relative; }
.goods-697 .img-wrap dl dd {position: absolute; bottom: 3rem; opacity:0}
.goods-697 .img-wrap dl dd.visible {animation:show_talk .5s forwards cubic-bezier(0.68, -0.55, 0.27, 1.55);}
.goods-697 .slide-area {background-color: #505976;}
.goods-697 .slide-area .rolling {margin: 3.4rem 0 2.34rem;}
.goods-697 .slide-area .rolling .pagination .swiper-pagination-switch {background-color: #fff; opacity: .3;}
.goods-697 .slide-area .rolling .pagination .swiper-active-switch {opacity: 1;;}
@keyframes emoticon {
	from {transform: translateX(0);}
	to {transform: translateX(-50%);}
}
@keyframes show_talk {
	0% {opacity:0;transform:scale(0);}
	100% {opacity:1;transform:scale(1);}
}
</style>
<script type="text/javascript">
$(function(){
	$(window).scroll(function(){
        var wHeight = $(window).height();
        var nowSt = $(this).scrollTop()
        if ( $('.ani1').offset().top-wHeight < nowSt) {$('.ani1').addClass('visible')}
        else {$('.ani1').removeClass('visible')}
        if ( $('.ani2').offset().top-wHeight < nowSt) {$('.ani2').addClass('visible')}
        else {$('.ani2').removeClass('visible')}
        if ( $('.ani3').offset().top-wHeight < nowSt) {$('.ani3').addClass('visible')}
        else {$('.ani3').removeClass('visible')}
    })
    mySwiper = new Swiper('.rolling .swiper-container',{
        effect:'fade',
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".rolling .pagination",
		paginationClickable:true
	});
});
</script>
</head>
<body class="default-font body-main playV18 detail-play" <% if mainRollingParm <> "" then response.write "style=""padding-top:0;"""%>>	
	<!-- 컨텐츠 영역 -->
	<!-- PLAY.GOODS 697 세뱃돈 받고 기분 업 돼지 -->
	<div class="goods-697">
		<div class="topic">
			<div>
				<h2><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/tit.png?v=1.01" alt="세뱃돈 받고 기분 업 돼지!" /></h2>
				<p><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_topic.png?v=1.01" alt="세뱃돈 받고 기분 업 돼지!" /></p>
			</div>
		</div>
		<div class="img-wrap">
			<h3><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/txt_img.png" alt="이런 상황일 땐 이러면 돼-지 봉투"></h3>
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_01.png" alt="취업, 이직, 결혼 이야기로  안부인사를 시작하면?"></dt>
				<dd class="ani1"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_01_bag.png" alt="꿀돈"></dd>
			</dl>
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_02.png" alt="올해 시험 등 중요한 결정이 있는 가족들이 있다면?"></dt>
				<dd class="ani2"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_02_bag.png" alt="꿈꾸면"></dd>
			</dl>
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_03.png" alt="2019년 기대가 가득한 가족들에게는? "></dt>
				<dd class="ani3"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_03_bag.png" alt="2019"></dd>
			</dl>
		</div>
		<div class="slide-area">
			<h3><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/txt_slide.png?v=1.01" alt="2019년 황금 돼지해 좋은 기운 가득 담은 복 돼지 봉투로 마음을 전하세요! "></h3>
			<div class="rolling">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_01.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_02.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_03.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_04.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_05.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/img_slide_06.png" alt="" /></div>						
					</div>
					<div class="pagination"></div>
				</div>
			</div>
			<a href="/category/category_itemPrd.asp?itemid=2218101&pEtr=91912" onclick="TnGotoProduct('2218101');return false;"><img src="http://webimage.10x10.co.kr/fixevent/play/goods/697/btn.png" alt="구매하러 가기" /></a>
		</div>
	</div>
	<!-- // PLAY.GOODS 697 세뱃돈 받고 기분 업 돼지 -->
	<!--// 컨텐츠 영역 -->		
	<!-- //contents -->	
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->

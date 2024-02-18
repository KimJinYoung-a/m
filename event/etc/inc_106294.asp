<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<style type="text/css">
.mEvt106294 .slide {padding:0 1.28rem 4.78rem; background-color:#fff7f1;}
.mEvt106294 .slide .swiper-slide {width:74.67%; padding:0 .85rem;}
.mEvt106294 .slide .pagination {width:100%; padding-left:33.3%; height:.5rem; padding-top:.85rem;}
.mEvt106294 .slide .pagination .swiper-pagination-switch {width:.5rem; height:.5rem; margin:0 0.21rem; background-color:#d8d3cf;}
.mEvt106294 .slide .pagination .swiper-active-switch {background-color:#ac9d92;}
</style>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.1"></script>
<script type="text/javascript">
$(function () {
	swiper1 = new Swiper('.mEvt106294 .slide',{
		autoplay:2000,
		speed:800,
		pagination:".slide .pagination",
		paginationClickable:true,
		slidesPerView:'auto'
	});
});
</script>

			<% '<!-- 106294 --> %>
			<div class="mEvt106294">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/img_top.jpg" alt="Stay at home"></h2>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/txt_coming.jpg" alt="COMING SOON"></div>
				<div class="slide swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/img_slide1.jpg" alt=""></div>
						<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/img_slide2.jpg" alt=""></div>
						<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/img_slide3.jpg" alt=""></div>
						<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/img_slide4.jpg" alt=""></div>
					</div>
					<div class="pagination"></div>
				</div>
				<button onclick="regAlram(); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/btn_push.png" alt="오픈알림받기"></button>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/106294/m/txt_way.jpg" alt="푸시 설정 방법"></div>
			</div>
			<% '<!--// 106294 --> %>
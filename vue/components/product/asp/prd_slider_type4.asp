<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/html/lib/inc/head.asp" -->
<style>
/* 페이지 확인용 CSS */
.ref {text-align:center; padding:1.5rem 0 .5rem; line-height:1.6;}
.ref strong {font-size:1.2em; font-weight:bold}
.swiper-container {padding-top:2rem; padding-bottom:2rem;}
</style>
<script>
$(function() {
	var prdSwiper4 = new Swiper('.prd_slider_type4 .swiper-container', {
		speed: 500,
		slidesPerView: 'auto'
	});
});
</script>
</head>
<body>
	<p class="ref"><strong>type4</strong>
		<br>750 기준 280
		<br>e.g. NEW 메인 - 신상품 더보기 팝업
		<br>상품명 2줄 ( prd_name 에 추가 클래스 ellipsis2 )
	</p>
	<div class="prd_slider_type4">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<article class="swiper-slide prd_item">
					<figure class="prd_img">
						<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
						<span class="mask"></span>
					</figure>
					<div class="prd_info">
						<div class="prd_price">
							<span class="set_price"><dfn>판매가</dfn>3,000</span>
							<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>67%</span>
						</div>
						<div class="prd_name ellipsis2">코드나인 무선 미니가습기 무선 미니가습기 제제</div>
					</div>
					<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
					<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
					<button type="button" class="btn_wish_on">위시 해제</button>
				</article>
				<article class="swiper-slide prd_item">
					<figure class="prd_img">
						<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
						<span class="mask"></span>
					</figure>
					<div class="prd_info">
						<div class="prd_price">
							<span class="set_price"><dfn>판매가</dfn>3,000</span>
							<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>67%</span>
						</div>
						<div class="prd_name ellipsis2">코드나인 무선 미니</div>
					</div>
					<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
					<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
					<button type="button" class="btn_wish_off">위시 담기</button>
				</article>
				<article class="swiper-slide prd_item">
					<figure class="prd_img">
						<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
						<span class="mask"></span>
					</figure>
					<div class="prd_info">
						<div class="prd_price">
							<span class="set_price"><dfn>판매가</dfn>3,000</span>
							<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>67%</span>
						</div>
						<div class="prd_name ellipsis2">코드나인 무선 미니가습기 제제</div>
					</div>
					<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
					<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
					<button type="button" class="btn_wish_off">위시 담기</button>
				</article>
				<article class="swiper-slide prd_item">
					<figure class="prd_img">
						<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
						<span class="mask"></span>
					</figure>
					<div class="prd_info">
						<div class="prd_price">
							<span class="set_price"><dfn>판매가</dfn>3,000</span>
							<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>67%</span>
						</div>
						<div class="prd_name ellipsis2">코드나인 무선 미니가습기 제제</div>
					</div>
					<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
					<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
					<button type="button" class="btn_wish_off">위시 담기</button>
				</article>
			</div>
		</div>
	</div>
</body>
</html>
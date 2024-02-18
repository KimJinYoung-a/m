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
	var prdSwiper1 = new Swiper('.prd_slider_type1 .swiper-container', {
		speed: 500,
		slidesPerView: 'auto',
		centeredSlides: true
	});
});
</script>
</head>
<body>
	<p class="ref"><strong>type1</strong>
		<br>750 기준 440
		<br>e.g. BEST 메인 - 스테디 셀러, 베스트 위시
		<br>상품명 1줄
        <br>type1~3의 경우 그림자 때문에 swiper-container에 임의 패딩값 필요
	</p>
	<div class="prd_slider_type1">
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
						<div class="prd_name">코드나인 무선 미니가습기 제제</div>
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
						<div class="prd_name">코드나인 무선 미니가습기 제제</div>
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
						<div class="prd_name">코드나인 무선 미니가습기 제제</div>
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
						<div class="prd_name">코드나인 무선 미니가습기 제제</div>
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
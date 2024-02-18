<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/head.asp" -->
<script>
$(function() {
	// 같은 상품의 후기 이미지 슬라이더
	$('.rv_img_slider').each(function(i, el) {
		var slider = $(el).find('.swiper-container'),
			lth = slider.find('.swiper-slide').length;
		if (lth > 1) {
			slider.addClass('on'+i);
			var rvImgSlider = new Swiper('.swiper-container.on'+i, {
				speed: 500,
				slidesPerView: 'auto',
				pagination: {
					el: '.swiper-pagination',
					type: 'progressbar'
				}
			});			
		}
	});
});
</script>
</head>
<body>
	<!-- for dev msg : 같은 상품의 후기 리스트
		- 기본 (세로형/자세히) ( rv_list_type2 : section or div )
		- 후기 이미지 여러 장일 경우 ( rv_img_slider )
		- 사진만 보기 추가 클래스 type_photo
		- 사진만 보기 5n번째(5의 배수) 100% 사이즈 : CSS 처리
	-->
	<section class="rv_list_type2">
		<!-- 상품후기 1개 컴포넌트 (article) -->
		<article class="rv_item">
			<!-- for dev msg : 후기 이미지 여러 장일 경우 -->
			<div class="rv_img_slider">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<figure class="swiper-slide rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
						<figure class="swiper-slide rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
						<figure class="swiper-slide rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
					</div>
					<div class="swiper-pagination"></div>
				</div>
			</div>
			<div class="rv_info">
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 에어팬 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<div class="rv_info">
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 에어팬 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<div class="rv_info">
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 에어팬 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<!-- for dev msg : 후기 이미지 1장일 경우 -->
			<figure class="rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
			<div class="rv_info">
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 에어팬 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<div class="rv_img_slider">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<figure class="swiper-slide rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
						<figure class="swiper-slide rv_img"><img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt=""></figure>
					</div>
					<div class="swiper-pagination"></div>
				</div>
			</div>
			<div class="rv_info">
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 에어팬 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>
	</section>
</body>
</html>
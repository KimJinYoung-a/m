<!-- #include virtual="/html/lib/inc/head.asp" -->
</head>
<body>
	<!-- for dev msg : 상품 리스트 ( prd_list : section or div )
		- 자세히/사진만 클래스 전환 ( type_basic / type_photo )
		- 사진만 보기 5n번째(5의 배수) 100% 사이즈 : CSS 처리
		- 마스크 처리 : 일시품절 / 성인용품 ( prd_item 에 클래스 soldout / adult )
	-->
	<section class="prd_list type_photo">
		<!-- 상품 1개 컴포넌트 (article) -->
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
			<button type="button" class="btn_wish_on">위시 해제</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<!-- 일시품절 : 클래스 soldout 추가 -->
		<article class="prd_item soldout">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<!-- 성인용품 : 클래스 adult 추가 -->
		<article class="prd_item adult">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<!-- 이미지 없을시 (no img) -->
		<article class="prd_item">
			<figure class="prd_img">
				<img src="" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
		<article class="prd_item">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
	</section>
</body>
</html>
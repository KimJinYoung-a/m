<!-- #include virtual="/html/lib/inc/head.asp" -->
</head>
<body>
	<!-- for dev msg : 상품 리스트 ( prd_list : section or div )
		- 자세히/사진만 클래스 전환 ( type_basic / type_photo )
		- 사진만 보기 5n번째(5의 배수) 100% 사이즈 : CSS 처리
		- 마스크 처리 : 일시품절 / 성인용품 ( prd_item 에 클래스 soldout / adult )
	-->
	<section class="prd_list type_basic">
		<!-- 상품 1개 컴포넌트 (article) -->
		<article class="prd_item">
			<!-- 베스트 상품 : 순위 표시 (label_rank) -->
			<div class="label_rank"><span class="num">1</span><span class="blind">위</span></div>
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>3,000</span>
					<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>15%</span>
				</div>
				<div class="prd_name">코드나인 무선 미니가습기 제제</div>
				<div class="prd_brand">romane</div>
				<!-- 앞뱃지/뒷뱃지 중 1개 이상 있을 경우 노출 -->
				<div class="prd_badge">
					<span class="badge_type1">클래스</span>
					<span class="badge_type2">MD추천</span>
				</div>
				<!-- 평점 : 4점(80%) 이상일 경우 노출-->
				<!-- 상품평 : 평점 있을 경우 && 상품평 5개 이상일 경우 노출 -->
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_comment"><dfn>상품평</dfn>171</span>
				</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<!-- 위시 담기/해제 - 클래스 btn_wish_off / btn_wish_on -->
			<button type="button" class="btn_wish_on">위시 해제</button>
			<!-- 신규 상품 상세 : 신상품 더보기 버튼 (1,000개 이상은 999+) -->
			<button type="button" class="btn_more">999+개의 신상품 더보기</button>
		</article>

		<article class="prd_item">
			<!-- 베스트 상품 : 순위 표시 (label_rank) -->
			<div class="label_rank"><span class="num">100</span><span class="blind">위</span></div>
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>7,900</span>
				</div>
				<div class="prd_name">메모리즈 레cksckln5257463터링이니셜 젤리케이스</div>
				<div class="prd_brand">데일리라이크데일리라이크데일리라이크</div>
				<div class="prd_badge">
					<span class="badge_type1">소량입고</span>
					<span class="badge_type2">신상</span>
				</div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:100%">100점</i></span>
				</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>

		<!-- 일시품절 : 클래스 soldout 추가 -->
		<article class="prd_item soldout">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>255,000</span>
					<!-- 할인율 있을 경우 노출 --> <span class="discount"><dfn>할인율</dfn>5%<em>쿠폰</em></span>
				</div>
				<div class="prd_name">깊은 시간 다이어리</div>
				<div class="prd_brand">프릳츠2020</div>
				<div class="prd_badge">
					<span class="badge_type2">텐텐쇼퍼추천</span>
				</div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:90%">90점</i></span>
					<span class="user_comment"><dfn>상품평</dfn>3</span>
				</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>

		<!-- 성인용품 : 클래스 adult 추가 -->
		<article class="prd_item adult">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>255,000</span>
					<!-- 할인율 있을 경우 노출 --> <span class="discount"><em>더블할인</em></span>
				</div>
				<div class="prd_name">허니콤 멀티홀더 다용도정리함</div>
				<div class="prd_brand">Disney Edition DisneyEdition</div>
				<div class="prd_badge">
					<span class="badge_type1">클래스</span>
				</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
			<!-- 신규 상품 상세 : 신상품 더보기 버튼 (1,000개 이상은 999+) -->
			<button type="button" class="btn_more">100개의 신상품 더보기</button>
		</article>

		<!-- 일시품절 + 성인용품 -->
		<article class="prd_item soldout adult">
			<figure class="prd_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/210/B002105986.jpg" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>255,000</span>
				</div>
				<div class="prd_name">허니콤 멀티홀더 다용도정리함허니콤 멀티홀더 다용도정리함허니콤 멀티홀더 다용도정리함</div>
				<div class="prd_brand">Disney Edition</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>

		<!-- 이미지 없을시 (no img) -->
		<article class="prd_item">
			<figure class="prd_img">
				<img src="" alt="상품명">
				<span class="mask"></span>
			</figure>
			<div class="prd_info">
				<div class="prd_price">
					<span class="set_price"><dfn>판매가</dfn>255,000</span>
				</div>
				<div class="prd_name">허니콤 멀티홀더 다용도정리함</div>
				<div class="prd_brand">Disney Edition</div>
				<div class="prd_badge">
					<span class="badge_type1">클래스</span>
				</div>
			</div>
			<a href="" class="prd_link"><span class="blind">상품 바로가기</span></a>
			<button type="button" class="btn_wish_off">위시 담기</button>
		</article>
	</section>
</body>
</html>
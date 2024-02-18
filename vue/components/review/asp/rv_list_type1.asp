<!-- #include virtual="/html/lib/inc/head.asp" -->
</head>
<body>
	<!-- for dev msg : 서로 다른 상품의 후기 리스트
		- 기본 (세로형/자세히) ( rv_list_type1 : section or div )
		- 포토 후기일 경우 이미지 스위치 ( tgl_item )
		- 사진만 보기 추가 클래스 type_photo
		- 사진만 보기 5n번째(5의 배수) 100% 사이즈 : CSS 처리
		- 기본사진 마스크 처리 : 일시품절 ( rv_item 에 클래스 soldout )
	-->
	<section class="rv_list_type1">
		<!-- 상품후기 1개 컴포넌트 (article) -->
		<article class="rv_item soldout">
			<!-- 포토 후기 (tgl_type1 + rv_img + prd_img) -->
			<!-- 토글 컴포넌트 (tgl_type1) -->
			<!-- #include virtual="/html/components/tgl_type1.asp" -->
			<figure class="rv_img">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt="상품명">
			</figure>
			<figure class="prd_img" style="display:none;">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt="상품명">
				<span class="prd_mask"></span>
			</figure>
			<div class="rv_info">
				<div class="rv_name">진짜같은 카라멜 캔들<i class="i_arw_r2"></i></div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 <mark class="match">에어팬</mark> 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
				<button type="button" class="btn_more">이 상품의 후기 더보기</button>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<!-- 일반 후기 (기본사진 prd_img) -->
		<article class="rv_item soldout">
			<figure class="prd_img">
				<img src="//webimage.10x10.co.kr/image/basic/299/B002994832.jpg" alt="상품명">
				<span class="prd_mask"></span>
			</figure>
			<div class="rv_info">
				<div class="rv_name">진짜같은 카라멜 캔들<i class="i_arw_r2"></i></div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 <mark class="match">에어팬</mark> 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
				<button type="button" class="btn_more">이 상품의 후기 더보기</button>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<!-- 토글 컴포넌트 (tgl_type1) -->
			<!-- #include virtual="/html/components/tgl_type1.asp" -->
			<figure class="rv_img">
				<img src="//webimage.10x10.co.kr/eventIMG/2020/104764/banMoList20200728104421.JPEG" alt="상품명">
			</figure>
			<figure class="prd_img" style="display:none;">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt="상품명">
				<span class="prd_mask"></span>
			</figure>
			<div class="rv_info">
				<div class="rv_name">비스킷&버터 커널로그 무선 스위치 <mark class="match">에어팬</mark> 카라멜 캔들<i class="i_arw_r2"></i></div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 <mark class="match">에어팬test1234</mark> 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
				<a href="" class="btn_more">이 상품의 후기 더보기</a>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>

		<article class="rv_item">
			<!-- 토글 컴포넌트 (tgl_type1) -->
			<!-- #include virtual="/html/components/tgl_type1.asp" -->
			<figure class="rv_img">
				<img src="" alt="상품명">
			</figure>
			<figure class="prd_img" style="display:none;">
				<img src="//thumbnail.10x10.co.kr/webimage/image/basic600/276/B002766821.jpg" alt="상품명">
				<span class="prd_mask"></span>
			</figure>
			<div class="rv_info">
				<div class="rv_name">진짜같은 카라멜 캔들dadafa325235262<i class="i_arw_r2"></i></div>
				<div class="user_side">
					<span class="user_eval"><dfn>평점</dfn><i style="width:87%">87점</i></span>
					<span class="user_id"><dfn>작성자</dfn>tentenkim1010**</span>
				</div>
				<div class="rv_desc">
					<p>친구가 이사간지 얼마 안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 쌩뚱맞지만 <mark class="match">에어팬</mark> 굉장히 좋아해서 만족해요.친구가 이사간지 얼마안되어서 집들이 선물로 준비했는데, 굉장히 좋아해서 만족스러웠어요. 화이트와 우드의 조합이 깔끔하고 예쁘더라구요. 집들이 선물로 좋아요, 굉장히 좋아해서 만족해요.</p>
				</div>
				<button type="button" class="btn_more">이 상품의 후기 더보기</button>
			</div>
			<a href="" class="rv_link"><span class="blind">상품 바로가기</span></a>
		</article>
	</section>
</body>
</html>
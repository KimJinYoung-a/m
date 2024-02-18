<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
$(function(){
	//Swiper Content
	var contentSwiper = $('.swiper-content').swiper({
		onImagesReady:function(){
			setContentSize(0);
		},
		onSlideChangeStart:function(){
			updateNavPosition();
		},
		onSlideChangeEnd:function(){
			setContentSize(contentSwiper.activeIndex);
		}
	});
	//Nav
	var navSwiper = $('.swiper-nav').swiper({
		visibilityFullFit:true,
		slidesPerView:'auto',
		onSlideClick:function(){
			contentSwiper.swipeTo(navSwiper.clickedSlideIndex);
		}
	});

	//Update Nav Position
	function updateNavPosition(){
		$('.swiper-nav .active-nav').removeClass('active-nav');
		var activeNav = $('.swiper-nav .swiper-slide').eq(contentSwiper.activeIndex).addClass('active-nav');
		if (!activeNav.hasClass('swiper-slide-visible')) {
			if (activeNav.index()>navSwiper.activeIndex) {
				var thumbsPerNav = Math.floor(navSwiper.width/activeNav.width())-1;
				navSwiper.swipeTo(activeNav.index()-thumbsPerNav);
			}
			else {
				navSwiper.swipeTo(activeNav.index());
			}
		}
	}
});

function setContentSize(sIdx) {
	$('.swiper-content').css({
		height: $('.swiper-content .swiper-slide ul').eq(sIdx).outerHeight() + $('.swiper-content .swiper-slide .listAddBtn').eq(sIdx).outerHeight()
	})
}
</script>
</head>
<body>
<div class="wrapper" id="btwCtgy"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<h1 class="noView">카테고리</h1>
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="subNaviWrap swiper-container swiper-nav">
				<ul class="subNavi swiper-wrapper">
					<li class="swiper-slide active-nav"><span>커플</span></li><!-- for dev msg : 선택시 active-nav 클래스 추가 -->
					<li class="swiper-slide "><span>소품/취미</span></li>
					<li class="swiper-slide"><span>디지털</span></li>
					<li class="swiper-slide"><span>푸드</span></li>
					<li class="swiper-slide"><span>패션</span></li>
					<li class="swiper-slide"><span>뷰티</span></li>
					<li class="swiper-slide"><span>SALE</span></li>
				</ul>
			</div>
			<!-- Product List -->
			<div class="pdtListWrap swiper-container swiper-content boxMdl">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="soldout">
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="soldout">
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="soldout">
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="soldout">
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
					<div class="swiper-slide">
						<ul class="pdtList list03">
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
										<p class="pdtName">상품명</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
										<p class="pdtName">상품명상품명상품명상품명상품명상품명</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div class="soldout"><!-- for dev msg : 세일 상품일때 클래스 soldout 추가됨 -->
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절 상품일때 추가됨 -->
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
							<li>
								<div class="soldout">
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">듀얼 하트 케익</p>
										<p class="price">1,000,000원</p>
										<p class="pdtTag soldOut">품절</p>
									</a>
								</div>
							</li>
							<li>
								<div>
									<a href="">
										<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="Blue Paisley Sabados (M)" /></p>
										<p class="pdtName">POSTER BAG</p>
										<p class="price">1,000,000원</p>
									</a>
								</div>
							</li>
						</ul>
						<div class="listAddBtn">
							<a href="">상품 더 보기</a>
						</div>
					</div>
				</div>
			</div>
			<!-- // Product List -->
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
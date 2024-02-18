<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	function thumbSize() {
		var thumbH = $('.brPdtList li:nth-child(2)').outerHeight();
		var thumbBigW = $('.brPdtList li:first-child').outerWidth();
		var thumbBigH = $('.brPdtList li:first-child').outerHeight();
		var thumbW = $('.brPdtList li:nth-child(2)').outerWidth();

		$('.brPdtList ul').css('height', thumbH*3+'px');
		$('.brPdtList li:nth-child(3)').css('top', thumbH+'px');
		$('.brPdtList li:nth-child(4)').css('top', thumbBigH+'px');
		$('.brPdtList li:nth-child(4) > div').css('height', (thumbH*3-thumbBigH-8)+'px');
		$('.brPdtList li:nth-child(5)').css('top', thumbH*2+'px');
	}

	thumbSize();
	$('img').load(function(){
		thumbSize();
	});

	mySwiper1 = new Swiper('.swiper1',{
		pagination:'.bnrPaging',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:false,
		speed:500
	});

	$('.bnrPaging span:eq(0)').text('01');
	$('.bnrPaging span:eq(1)').text('02');
	$('.bnrPaging span:eq(2)').text('03');
	$('.bnrPaging span:eq(3)').text('04');
	$('.bnrPaging span:eq(4)').text('05');
	$('.bnrPaging span:eq(5)').text('06');

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			thumbSize();
			mySwiper1.reInit();
			clearInterval(oTm);
		}, 200);
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="brandMain inner5">
				<div class="btnWrap"><span class="zzimBrView myZzimBr"><a href=""><em>MY 찜브랜드</em></a></span></div>
				<section class="brandStreet">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="brPdtList">
									<ul>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
										<li>
											<div class="info">
												<a href="">
													<em class="brandEng">AGUARD</em>
													<strong class="brandKor">아가드</strong>
												</a>
												<button type="button" class="like on"><span>3571</span></button>
												<p class="pFlag">
													<span class="fgSale">SALE</span>
												</p>
											</div>
										</li>
										<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="상품명" /></a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="bnrPaging"></div>
					</div>
				</section>

				<section class="brandWordList inner5">
					<h2 class="tit02"><span>가나다순</span></h2>
					<ul>
						<li onclick=""><span>가</span></li>
						<li onclick=""><span>나</span></li>
						<li onclick=""><span>다</span></li>
						<li onclick=""><span>라</span></li>
						<li onclick=""><span>마</span></li>
						<li onclick=""><span>바</span></li>
						<li onclick=""><span>사</span></li>
						<li onclick=""><span>아</span></li>
						<li onclick=""><span>자</span></li>
						<li onclick=""><span>차</span></li>
						<li onclick=""><span>카</span></li>
						<li onclick=""><span>타</span></li>
						<li onclick=""><span>파</span></li>
						<li onclick=""><span>하</span></li>
					</ul>

					<h2 class="tit02"><span>ABC순</span></h2>
					<ul>
						<li onclick=""><span>A</span></li>
						<li onclick=""><span>B</span></li>
						<li onclick=""><span>C</span></li>
						<li onclick=""><span>D</span></li>
						<li onclick=""><span>E</span></li>
						<li onclick=""><span>F</span></li>
						<li onclick=""><span>G</span></li>
						<li onclick=""><span>H</span></li>
						<li onclick=""><span>I</span></li>
						<li onclick=""><span>J</span></li>
						<li onclick=""><span>K</span></li>
						<li onclick=""><span>L</span></li>
						<li onclick=""><span>M</span></li>
						<li onclick=""><span>N</span></li>
						<li onclick=""><span>O</span></li>
						<li onclick=""><span>P</span></li>
						<li onclick=""><span>Q</span></li>
						<li onclick=""><span>R</span></li>
						<li onclick=""><span>S</span></li>
						<li onclick=""><span>T</span></li>
						<li onclick=""><span>U</span></li>
						<li onclick=""><span>V</span></li>
						<li onclick=""><span>W</span></li>
						<li onclick=""><span>X</span></li>
						<li onclick=""><span>Y</span></li>
						<li onclick=""><span>Z</span></li>
						<li onclick=""><span>etc.</span></li>
					</ul>
				</section>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
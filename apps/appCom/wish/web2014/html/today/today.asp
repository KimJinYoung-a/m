<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	mySwiper1 = new Swiper('.swiper1',{
		pagination:'.bnrPaging',
		paginationClickable:true,
		autoplay:4000,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplayDisableOnInteraction:false,
		speed :1000,
		followFinger:false
	});
	$('.bnrPaging span:eq(0)').text('01');
	$('.bnrPaging span:eq(1)').text('02');
	$('.bnrPaging span:eq(2)').text('03');
	$('.bnrPaging span:eq(3)').text('04');
	$('.bnrPaging span:eq(4)').text('05');
	$('.bnrPaging span:eq(5)').text('06');

});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content todayMain" id="contentArea">
			<!-- MAIN BANNER -->
			<section class="todayMainBnr inner5">
				<!-- for dev msg : 마케팅 이슈 상품이 있을 경우 클래스 issue 넣어주세요(이슈상품은 마지막 슬라이드에 들어갑니다.) -->
				<div class="swiper-container swiper1 issue">
					<div class="swiper-wrapper">
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr01.jpg" alt="" /></a><!-- for dev msg : 배너 내용(event 제목/상품명) alt값 속성에 넣어주세요 -->
						</div>
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr02.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr03.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr04.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr05.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide swiper-no-swiping">
							<a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_main_bnr06.jpg" alt="" /></a>
						</div>
					</div>
					<div class="bnrPaging"></div>
				</div>
			</section>
			<!--// MAIN BANNER -->

			<!-- JUST 1DAY -->
			<section class="just1Day">
				<a href="">
					<h2>JUST <span class="cRd1">1 DAY</span></h2>
					<div class="justPdtInfo">
						<p>Blooming&me 플라워 프레그런스</p>
						<p class="cBk1"><strong>15,400원</strong></p>
					</div>
					<div class="justPdt">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_240x240.jpg" alt="" /><!-- for dev msg : alt값에 상품명 넣어주세요 --></div>
						<span class="discount"><strong>99</strong>%</span>
					</div>
				</a>
			</section>
			<!--// JUST 1DAY -->

			<!-- HOT KEYWORD -->
			<section class="hotKwd">
				<div class="inner5"><h2 class="tit01"><span>HOT KEYWORD</span></h2></div>
				<ul>
					<li>
						<div class="kwdWrap">
							<a href="">
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_360x360.jpg" alt="" />
								<dl>
									<dt>WISH</dt>
									<dd>
										<p class="Kwd">소니엔젤</p>
										<p class="KwdCont"><span>진실한 사랑의 마가렛 꽃으로 찾아온 아티스트 컬렉션</span></p>
									</dd>
								</dl>
							</a>
						</div>
					</li>
					<li>
						<div class="kwdWrap">
							<a href="">
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.jpg" alt="" />
								<dl>
									<dt>ISSUE</dt>
									<dd>
										<p class="Kwd">장마</p>
										<p class="KwdCont"><span>오락가락 비소식! 빠르고 똑똑하게 대처하자!</span></p>
									</dd>
								</dl>
							</a>
						</div>
					</li>
					<li>
						<div class="kwdWrap">
							<a href="">
								<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_234x234.jpg" alt="" />
								<dl>
									<dt>ISSUE</dt>
									<dd>
										<p class="Kwd">황금연휴</p>
										<p class="KwdCont"><span>황금연휴 준비! 나만의 완벽한 플랜! 완벽한 여행도구!</span></p>
									</dd>
								</dl>
							</a>
						</div>
					</li>
				</ul>
			</section>
			<!--// HOT KEYWORD -->

			<div class="inner5 appBtn"><span class="button btM1 btBckBdr cRd1 w100p"><a href="#">APP에서 첫 구매하면, 할인 쿠폰 증정!<em class="rdArr"></em></a></span></div>

			<!-- TODAY DEAL -->
			<section class="todayDeal">
				<span class="icoTime"></span>
				<h2>TIME SALE</h2>
				<p class="fs12">무엇이든 담을 수 있는 귀여운 스낵팩</p>
				<a href="">
					<div class="dealPdt">
						<div class="pic">
							<img src="http://fiximage.10x10.co.kr/m/2014/temp/today_time_pdt.jpg" alt="" /><!-- for dev msg : alt값에 상품명 넣어주세요 -->
						</div>
						<span class="limit">한정<br />재입고</span>
						<!--
						<span class="limit">HOT<br />SALE</span>
						<span class="limit">SPECIAL<br />EDITION</span>
						<span class="limit">10X10<br />ONLY</span>
						<span class="limit">12시간<br />남음</span>
						-->
					</div>
					<div class="pdtCont">
						<p class="pName">[아이띵소] SNACK PACK(M)_BASIC</p>
						<p class="pPrice">19,000원 <span class="cRd1">[20%]</span></p>
					</div>
				</a>
			</section>
			<!--// TODAY DEAL -->

			<!-- CATEGORY KILLER -->
			<section class="cateKiller">
				<h2 class="tit01"><span>CATEGORY KILLER</span></h2>
				<ul>
					<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr04.jpg" alt="DESIGN FINGERS" /></a></li>
					<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr05.jpg" alt="" /></a></li>
					<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr06.jpg" alt="" /></a></li>
				</ul>
			</section>
			<!--// CATEGORY KILLER -->

			<!-- ENJOY EVENT -->
			<section class="inner5 enjoyEvent">
				<h2 class="tit01"><span>ENJOY EVENT</span></h2>
				<span class="moreBtn"><a href="">이벤트 리스트로 이동</a></span>
				<ul class="todayEvtList">
					<li>
						<a href="">
							<img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="이토록 따뜻했던 사소한 하루" /><!-- for dev msg: alt값에 이벤트 명 넣어주세요 -->
							<p class="evtTit">이토록 따뜻했던 사소한 하루</p>
						</a>
					</li>
					<li>
						<a href="">
							<img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr02.png" alt="수능 D-100 공신비법" />
							<p class="evtTit">꿈꾸는 쥬얼리, 젠틀우먼</p>
						</a>
					</li>
					<li>
						<a href="">
							<img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="이토록 따뜻했던 사소한 하루" />
							<p class="evtTit">책가방 속 동화 이야기 <span class="cRd1">30%~</span></p>
						</a>
					</li>
				</ul>
			</section>
			<!--// ENJOY EVENT -->

			<!-- MD'S PICK -->
			<section class="inner10 mdPick">
				<h2 class="tit01"><span>MD'S PICK</span></h2>
				<ul class="pdtList">
					<!-- for dev msg : 리스트는 10개씩 노출됩니다. -->
					<li onclick="" class="soldOut">
						<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div><!-- for dev msg : 상품명 alt값 속성에 넣어주세요 -->
						<div class="pdtCont">
							<p class="pBrand">MINI BUS</p>
							<p class="pName">소니엔젤 아티스트 컬렉션</p>
							<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
						</div>
					</li>
					<li onclick="" class="hurryUp">
						<div class="pPhoto"><p><span><em>HURRY UP!</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
						<div class="pdtCont">
							<p class="pBrand">PLAN D</p>
							<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbitg</p>
							<p class="pPrice">8,000원 <span class="cGr1">[20%]</span></p>
						</div>
					</li>
					<li onclick="">
						<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
						<div class="pdtCont">
							<p class="pBrand">MINI BUS</p>
							<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
							<p class="pPrice">8,000원</p>
						</div>
					</li>
					<li onclick="">
						<div class="pPhoto"><p><span><em>품절</em></span></p><img src="http://fiximage.10x10.co.kr/m/2014/temp/pdt01_286x286.jpg" alt="" /></div>
						<div class="pdtCont">
							<p class="pBrand">MINI BUS</p>
							<p class="pName">소니엔젤 아티스트 컬렉션-마가렛-Rabbit</p>
							<p class="pPrice">8,000원 <span class="cRd1">[20%]</span></p>
						</div>
					</li>
				</ul>
			</section>
			<!--// MD'S PICK -->

			<!-- BANNER -->
			<section>
				<div class="inner5"><a href="#"><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr01.jpg" alt="" /></a></div>
				<div class="inner5"><a href="#"><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr02.jpg" alt="" /></a></div>
				<div class="inner5"><a href="#"><img src="http://fiximage.10x10.co.kr/m/2014/temp/today_bnr03.jpg" alt="" /></a></div>
			</section>
			<!--// BANNER -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
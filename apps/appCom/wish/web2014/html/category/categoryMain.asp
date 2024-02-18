<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$(".categoryListup li:has(em)").addClass("hotCtgy");
	$(".tabList li").append('<span></span>');

	var tabsSwiper = new Swiper('.tabArea .swiper-container',{
		speed:500,
		onSlideChangeStart: function(){
			$(".tabArea .swiper-nav .active-nav").removeClass('active-nav')
			$(".tabArea .swiper-nav li").eq(tabsSwiper.activeIndex).addClass('active-nav')
		}
	})
	$(".tabArea .swiper-nav li").on('touchstart mousedown',function(e){
		e.preventDefault()
		$(".tabArea .swiper-nav .active-nav").removeClass('active-nav')
		$(this).addClass('active-nav')
		tabsSwiper.swipeTo( $(this).index() )
	})
	$(".tabArea .swiper-nav li").click(function(e){
		e.preventDefault()
	})
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content ctgyMain" id="contentArea">
			<div class="inner5">
				<h1 class="hide">디자인 문구</h1>
				<div class="tMar05 box1 w100">
					<ul class="categoryListup">
						<li class="allView"><a href=""><span class="cRd1">전체상품 (2,500)</span></a></li>
						<li><a href=""><span>데스크 정리/보관</span><em class="icoHot">HOT</em></a></li>
						<li><a href=""><span>노트/메모지</span></a></li>
						<li><a href=""><span>포토앨범/레코드북캘린더캘린더</span></a></li>
						<li><a href=""><span>포토앨범/레코드북캘린더</span></a></li>
						<li><a href=""><span>포토앨범/레코드북캘린더</span><em class="icoHot">HOT</em></a></li>
						<li><a href=""><span>카드/편지/봉투</span></a></li>
						<li><a href=""><span>필기류/펜 케이스</span></a></li>
						<li><a href=""><span>포토앨범/레코드북캘린더</span></a></li>
						<li><a href=""><span>오피스 용품</span></a></li>
						<li><a href=""><span>파일링/바인더</span></a></li>
						<li><a href=""><span>미술도구</span><em class="icoHot">HOT</em></a></li>
						<li><a href=""><span>캐릭터 문구</span></a></li>
						<li><a href=""><span>BOOK</span></a></li>
					</ul>
				</div>
			</div>

			<div class="inner10">
				<h2 class="tit02 tMar30"><span>인기태그</span></h2>
				<ul class="tagList">
					<li><a href="">귀요미 메모지</a></li>
					<li><a href="">나의 첫 만년필</a></li>
					<li><a href="">디자인 펜케이스</a></li>
					<li><a href="">카드</a></li>
					<li><a href="">마우스 패드</a></li>
					<li><a href="">사이보그</a></li>
					<li><a href="">괜찮아 사랑이야</a></li>
				</ul>
			</div>

			<div class="inner5 tabArea tMar20">
				<div class="subNaviWrap swiper-nav">
					<ul class="tabList">
						<li class="active-nav" name="tab01">MD'S PICK</li>
						<li name="tab02">SALE</li>
						<li name="tab03">BEST</li>
					</ul>
				</div>
				<div class="pdtListWrap box1 swiper-container">
					<div class="tabCont swiper-wrapper">
						<ul class="tabMds swiper-slide" id="tab01">
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p><!-- for dev msg : 상품이미지 200사이즈 호출해주세요 / alt 값 속성에 상품명 넣어주세요 -->
									<span>줌리드 헤드폰 줌리드 헤드폰 줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰 줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_200x200.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
						</ul>
						<ul class="tabSale swiper-slide" id="tab02">
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_280x190.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_130x152.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_300x300.png" alt="" /></p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
						</ul>
						<ul class="tabBest swiper-slide" id="tab03">
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>1</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" /><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>2</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" />
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>3</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" />
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>4</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" />
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>5</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" />
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
							<li>
								<a href="">
									<p>
										<span class="bestFlag"><em>6</em></span>
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_290x290.png" alt="원터치 스마트 장갑" />
									</p>
									<span>줌리드 헤드폰 줌리드 헤드폰</span>
									<span class="price">5,800원 <em class="cRd1">[10%]</em></span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="inner10 eventListWrap">
				<h2 class="tit02 tMar30"><span>ENJOY EVENT</span></h2>
				<span class="moreBtn"><a href="">이벤트 리스트로 이동</a></span><!-- for dev msg:해당 카테고리 이벤트 리스트로 이동됩니다. -->
				<ul class="evtList">
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cRd1">30%~</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr02.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr1">99%~</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr01.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr2">1+1</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
					<li onclick="">
						<div class="pic"><img src="http://fiximage.10x10.co.kr/m/2014/temp/evt_bnr02.png" alt="" /></div>
						<dl>
							<dt>책가방 속 동화 이야기 <span class="cGr2">GIFT</span></dt>
							<dd>텐바이텐에서만 만날 수 있는 월간 오롯이</dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
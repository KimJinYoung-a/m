<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appcom/wish/webview/css/diary2015.css">
<script type="text/javascript" src="/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript">
$(function() {
	mySwiper1 = new Swiper('.gift-swipe-1 .swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		speed:180
	});
	mySwiper2 = new Swiper('.gift-swipe-2 .swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		speed:180
	});
	mySwiper3 = new Swiper('.gift-swipe-3 .swiper-container',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		speed:180
	});

	$('.gift-swipe-1 .swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipePrev()
	});
	$('.gift-swipe-1 .swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper1.swipeNext()
	});
	$('.gift-swipe-2 .swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipePrev()
	});
	$('.gift-swipe-2 .swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper2.swipeNext()
	});
	$('.gift-swipe-3 .swiper .arrow-left').on('click', function(e){
		e.preventDefault()
		mySwiper3.swipePrev()
	});
	$('.gift-swipe-3 .swiper .arrow-right').on('click', function(e){
		e.preventDefault()
		mySwiper3.swipeNext()
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
			mySwiper3.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
</head>
<body class="diarystory2015">
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content">

				<div class="diary-gift">
					<h1><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/tit_diary_gift.gif" alt="새로운 당신의 이야기에 특별함을 더하는 2015 다이어리 스토리 기프트" /></h1>
					<p><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/txt_diary_gift.gif" alt="사은품 증정기간은 2014년 10월 15일부터 12월 31일까지며, 한정수량으로 조기 품절될 수 있습니다. 2015 다이어리스토리 다이어리 전 상품을 무료로 배송해 드립니다." /></p>
				</div>

				<div class="gift-intro inner5">
					<h2><strong>1만원 이상 구매시</strong> DIARY STORY 다이어리 포함 텐바이텐 배송상품</h2>
					<div class="gift-swipe gift-swipe-1">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_hitchhiker_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_hitchhiker_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_hitchhiker_03.jpg" alt="" /></div>
								</div>
							</div>
							<button type="button" class="arrow-left">이전</button>
							<button type="button" class="arrow-right">다음</button>
						</div>
					</div>
					<div class="desc">
						<p>히치하이커 스티커북 [24장 1세트]</p>
						<span class="button btS2"><a href="" onclick="FnGotoBrand('hitchhiker');return false;"><em>브랜드보기</em></a></span>
					</div>
				</div>

				<div class="gift-intro inner5">
					<h2><strong>2만원 이상 구매시</strong> DIARY STORY 다이어리 포함 텐바이텐 배송상품</h2>
					<div class="gift-swipe gift-swipe-2">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_decorush_01.gif" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_decorush_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_decorush_03.jpg" alt="" /></div>
								</div>
							</div>
							<button type="button" class="arrow-left">이전</button>
							<button type="button" class="arrow-right">다음</button>
						</div>
					</div>
					<div class="desc">
						<p>데코러쉬 + 리필세트 [디자인 랜덤 증정]</p>
						<span class="button btS2"><a href="" onclick="FnGotoBrand('PLUS01');return false;"><em>브랜드보기</em></a></span>
					</div>
				</div>

				<div class="gift-intro inner5">
					<h2><strong>3만 5천원 이상 구매시</strong> DIARY STORY 다이어리 포함 텐바이텐 배송상품</h2>
					<div class="gift-swipe gift-swipe-3">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_sircusboyband_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_sircusboyband_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_slide_sircusboyband_03.jpg" alt="" /></div>
								</div>
							</div>
							<button type="button" class="arrow-left">이전</button>
							<button type="button" class="arrow-right">다음</button>
						</div>
					</div>
					<div class="desc">
						<p>서커스보이밴드 자수파우치</p>
						<span class="button btS2"><a href="" onclick="FnGotoBrand('circusboyband');return false;"><em>브랜드보기</em></a></span>
					</div>
				</div>

				<div class="gift-condition inner5">
					<h2><strong>저기요!</strong> 다이어리 스토리 사은품 저도 받을 수 있나요?</h2>
					<p>2015 DIARY STORY 다이어리를 포함한 텐바이텐 배송 상품으로 구매시, 사은품 증정 조건에 해당됩니다. 상품 상세 페이지에서 2015 DIARY STORY 배너를 확인하세요.</p>
					<div class="example"><img src="http://fiximage.10x10.co.kr/m/2014/diarystory2015/img_example.gif" alt="" /></div>
					<h3>[구매금액별 사은품 증정 예시]</h3>
					<ul>
						<li>- DIARY STORY 다이어리 (9,000원) + 텐바이텐 배송상품<br />(1,000원) 구매 시 히치하이커 스티커북 증정</li>
						<li>- DIARY STORY 다이어리 (10,000원) +  DIARY STORY 다이어리<br />(10,000원) 구매 시 :  데코러쉬 2종 세트 증정</li>
					</ul>
				</div>

				<div class="noti inner5">
					<h2>사은품 유의사항</h2>
					<ul>
						<li>사은품 증정기간은 2014.10.15 ~ 2014.12.31입니다 . (한정수량으로 조기품절 될 수 있습니다.)</li>
						<li>2015 DIARY STORY 다이어리 포함 텐바이텐 배송상품 1/2/3만5천원 이상 구매 시 증정 됩니다. (쿠폰, 할인카드 등 사용 후 구매확정금액 기준)</li>
						<li>환불 및 교환으로 기준 금액 미만이 될 경우 사은품은 반품해 주셔야 합니다.</li>
						<li>데코러쉬 사은품의 경우 옵션은 랜덤 증정 됩니다.</li>
						<li>다이어리 구매 개수에 관계없이 총 구매금액이 조건 충족 시 사은품이 증정됩니다.</li>
					</ul>
				</div>

			</div>
			<!-- //content area -->

		</div>
	</div>

</div>
</body>
</html>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function() {
	$(".goTop").addClass("topHigh");

	mySwiper0 = new Swiper('.location .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		initialSlide:3, //for dev msg : location 슬라이드 갯수(-1)만큼 적용되도록 처리해주세요
		slidesPerView: 'auto'
	})

	mySwiper1 = new Swiper('.swiper', {
		pagination : '.productImg .pagination',
		loop:true
	});

	mySwiper3 = new Swiper('.swiper3',{
		pagination:'.relationWishFolder .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});

	mySwiper4 = new Swiper('.swiper4',{
		pagination:'.ctgyPopularList .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});

	$(".tabList li").append('<span></span>');

/*
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
		//tabsSwiper.swipeTo( $(this).index() )
	})
	$(".tabArea .swiper-nav li").click(function(e){
		e.preventDefault()
	})
*/

	$(".tabArea .tabCont > div:first").show();
	$('.tabArea .tabList li').click(function(){
		$(".tabArea .tabCont > div").hide();
		$('.tabArea .tabList li').removeClass('active-nav');
		$(this).addClass('active-nav');
		var tabView = $(this).attr('name');
		$(".tabArea .tabCont div[id|='"+ tabView +"']").show();
	});

	$(".cmtListWrap > div:first").show();
	$('.cmtTab li').click(function(){
		$(".cmtListWrap > div").hide();
		$('.cmtTab li').removeClass('selected');
		$(this).addClass('selected');
		var cmtTabView = $(this).attr('name');
		$(".cmtListWrap div[id|='"+ cmtTabView +"']").show();
	});

	$(".qnaList li .a").hide();
	$(".qnaList li").each(function(){
		if ($(this).children(".a").length > 0) {
			$(this).children('.q').addClass("isA");
		}
	});

	$(".qnaList li .q").click(function(){
		$(".qnaList li .a").hide();
		if($(this).next().is(":hidden")){
			$(this).parent().children('.a').show();
		}else{
			$(this).parent().children('.a').hide();
		};
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper3.reInit();
			mySwiper4.reInit();
				clearInterval(oTm);
			}, 500);
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="location">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<em class="swiper-slide"><a href="">HOME</a></em>
						<em class="swiper-slide"><a href="">디자인문구 (2,500)</a></em>
						<em class="swiper-slide"><a href="">포토앨범 / 레코드북</a></em>
						<em class="swiper-slide"><a href="" class="cBk1">기타 레코드 북 </a></em>
					</div>
				</div>
			</div>
			<div class="itemPrd inner5">
				<div class="box1">
					<div class="pdtCont">
						<p class="pBrand">MINI BUS</p>
						<p class="pName">소니엔젤 아티스트 컬렉션 M-POCKET TINY 모노폴리 포켓소니엔젤 아티스트 컬렉션 M-POCKET TINY 모노폴리 포켓</p>
						<p class="pFlag">
							<span class="fgOnly">ONLY</span>
							<span class="fgNew">NEW</span>
							<span class="fgSale">SALE</span>
							<span class="fgCoupon">쿠폰</span>
							<span class="fgLimit">한정</span>
							<span class="fgGift">GIFT</span>
							<span class="fgPlus">1+1</span>
							<span class="fgSoldout">품절</span>
							<span class="fgFree">무료배송</span>
							<span class="fgJoin">참여</span>
							<span class="fgReserv">예약판매</span>
							<span class="fgHot">HOT</span>
						</p>
						<p class="giftFlag giftFlagOn" onclick=""><!-- 선택 시 클래스 giftFlagOn 붙여주세요 -->
							GIFT<br />TALK<em>+</em>
						</p>
					</div>

					<div class="productImg">
						<div class="swiper-container swiper">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div><!-- for dev msg : 해당 등록된 배너 제목 alt속성에 넣어주세요(이하동일) -->
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div>
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div>
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div>
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div>
								<div class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="와이드 토끼 5단 서랍장" style="width:100%;" /></a></div>
							</div>
						</div>
						<div class="pagination"></div>
						<p class="pLimit">한정수량 <strong class="cBk1">87개</strong> 남았습니다.</p><!-- for dev msg : 한정상품 아니면 그냥 노출 안됩니다.-->
					</div>

					<dl class="pPrice tMar10">
						<dt>판매가</dt>
						<dd>9,000원</dd>
					</dl>
					<dl class="pPrice">
						<dt>할인판매가</dt>
						<dd><span class="cRd1">[20%] 7,200원</span></dd>
					</dl>
					<dl class="pPrice">
						<dt>
							우수회원가
							<span class="icoHot"><a href=""><em class="rdBtn2">우수회원샵</em></a></span>
						</dt>
						<dd><span class="cRd1">[20%] 7,200원</span></dd>
					</dl>
					<dl class="pPrice">
						<dt>쿠폰적용가</dt>
						<dd><span class="cGr1">[20%] 7,200원</span></dd>
					</dl>
					<dl class="pPrice">
						<dt>배송구분</dt>
						<dd>업체조건배송</dd>
					</dl>
					<dl class="pPrice">
						<dt>마일리지</dt>
						<dd>72 Point</dd>
					</dl>

					<div class="btnWrap downBtn">
						<span class="button btB2 btGrn cWh1"><a href="#"><em>5,000원 할인쿠폰 받기</em></a></span>
					</div>
				</div>

				<h2 class="tit02 tMar25"><span>옵션</span></h2>
				<p class="tPad15">
					<select title="색상 선택" style="width:100%;">
						<option value="red">Red</option>
					</select>
				</p>
				<p class="tPad05">
					<select title="색상 선택" style="width:100%;">
						<option value="red">Red</option>
					</select>
				</p>
				<p class="tPad05">
					<select title="색상 선택" style="width:100%;">
						<option value="red">Red</option>
					</select>
				</p>
				<p class="tPad05">
					<textarea style="width:100%;" rows="4">[문구입력란] 문구를 입력해 주세요.</textarea>
				</p>
				<div class="prdNum">
					<span class="numMn"><a href="">갯수 감소</a></span>
					<p><input type="text" value="1" style="width:100%;" /></p>
					<span class="numPl"><a href="">갯수 증가</a></span>
				</div>

				<div class="tabArea tMar25">
					<div class="prdDetailTab swiper-nav">
						<ul class="tabList">
							<li class="active-nav" name="tab01">설명</li>
							<li name="tab02">후기(15)</li>
							<li name="tab03">Q&amp;A(8)</li>
						</ul>
					</div>
					<div class="prdDetailCont box1 swiper-container">
						<div class="tabCont swiper-wrapper">
							<div class="swiper-slide" id="tab01">
								<div class="inner10">
									<p class="fs11 lPad05"><strong>상품코드 : 1110436</strong></p>
									<ul class="prdBasicInfo">
										<li><strong>품명 및 모델명 :</strong> M-POCKET TINY</li>
										<li><strong>법의 의한 인증, 허가 확인사항 :</strong> 해당없음</li>
										<li><strong>제조국 또는 원산지 :</strong> 한국</li>
										<li><strong>제조자 :</strong> (주)모노폴리</li>
										<li><strong>재질 :</strong> SL, PVC, NYLON</li>
										<li><strong>사이즈 :</strong> 115 x 80(mm)</li>
										<li><strong>제조자 :</strong> (주)모노폴리</li>
										<li><strong>A/S 책임자/전화번호 :</strong> 텐바이텐 고객행복센터 1644-6030</li>
										<li><strong>해외배송 기준 중량 :</strong> 33g (1차 포장을 포함한 중량)</li>
									</ul>
									<dl class="prdDesp">
										<dt>주문 주의사항</dt>
										<dd>MONOPOLY(모노폴리) 제품으로만 50,000원 이상 구매 시 <br />무료배송 됩니다. 배송비(2,500원)</dd>
									</dl>
									<div class="btnWrap detailBtn">
										<span class="button btM1 btRed cWh1"><a href="#">상품상세 보기</a></span>
									</div>
								</div>
							</div>

							<div class="swiper-slide" id="tab02" style="display:none;">
								<div class="inner10">
									<!-- for dev msg : 데이터 없는 경우 노출됩니다. 
									<div class="noDataBox">
										<p class="noDataMark"><span>!</span></p>
										<p class="tPad05">등록된 상품후기가 없습니다.</p>
									</div>
									<div class="btnWrap writeBtn">
										<span class="button btM1 btRed cWh1"><a href="#">상품후기 쓰기</a></span>
										<p class="ct">첫 상품후기 작성시에는 200Point가 적립됩니다.</p>
									</div>
									 //for dev msg : 데이터 없는 경우 노출됩니다. -->

									<div class="btnWrap writeBtn">
										<span class="button btM1 btRed cWh1"><a href="#">상품후기 쓰기</a></span>
										<p class="ct">첫 상품후기 작성시에는 200Point가 적립됩니다.</p>
									</div>
									<ul class="cmtTab">
										<li class="selected" name="cmtTab01">상품후기(15)</li>
										<li name="cmtTab02">포토후기(15)</li>
									</ul>
									<div class="cmtListWrap">
										<div class="cmtBasic" id="cmtTab01">
											<ul class="cmtList">
												<li>
													<p class="star"><span class="starView1"></span></p><!-- for dev msg : 별 갯수에 따라 span 클래스 변경(starView1~starView4) 해주세요 -->
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
												</li>
												<li>
													<p class="star"><span class="starView2"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
												</li>
												<li>
													<p class="star"><span class="starView2"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
													<span class="photo">
														<img src="http://fiximage.10x10.co.kr/m/2013/@temp/photo.png" alt="" />
													</span>
												</li>
											</ul>
											<div class="paging">
												<span class="arrow prevBtn"><a href="">prev</a></span>
												<span class="current"><a href="">1</a></span>
												<span><a href="">2</a></span>
												<span><a href="">3</a></span>
												<span><a href="">4</a></span>
												<span class="arrow nextBtn"><a href="">next</a></span>
											</div>
										</div>
										<div class="cmtPhoto" id="cmtTab02" style="display:none;">
											<ul class="cmtList">
												<li>
													<p class="star"><span class="starView1"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
													<span class="photo">
														<img src="http://fiximage.10x10.co.kr/m/2013/@temp/photo.png" alt="" />
													</span>
												</li>
												<li>
													<p class="star"><span class="starView2"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
													<span class="photo">
														<img src="http://fiximage.10x10.co.kr/m/2013/@temp/photo.png" alt="" />
													</span>
												</li>
												<li>
													<p class="star"><span class="starView3"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
													<span class="photo">
														<img src="http://fiximage.10x10.co.kr/m/2013/@temp/photo.png" alt="" />
													</span>
												</li>
												<li>
													<p class="star"><span class="starView4"></span></p>
													<div>진짜 이뻐요!!! 질리지도 않을것 같고 싸보이지도 않고 유니크..?해보여요ㅋㅋ</div>
													<p class="writer">hakuna312 / 2014.08.11</p>
													<span class="photo">
														<img src="http://fiximage.10x10.co.kr/m/2013/@temp/photo.png" alt="" />
													</span>
												</li>
											</ul>
											<div class="paging">
												<span class="arrow prevBtn"><a href="">prev</a></span>
												<span class="current"><a href="">1</a></span>
												<span><a href="">2</a></span>
												<span><a href="">3</a></span>
												<span><a href="">4</a></span>
												<span class="arrow nextBtn"><a href="">next</a></span>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="swiper-slide" id="tab03" style="display:none;">
								<div class="inner10">
									<!-- for dev msg : 데이터 없는 경우 노출됩니다. 
									<div class="noDataBox">
										<p class="noDataMark"><span>!</span></p>
										<p class="tPad05">등록된 상품문의가 없습니다.</p>
									</div>
									<div class="btnWrap writeBtn">
										<span class="button btM1 btRed cWh1"><a href="#">상품문의 하기</a></span>
										<p class="ct">상품에 대한 궁금한점을 문의해주세요.</p>
									</div>
									 //for dev msg : 데이터 없는 경우 노출됩니다. -->

									<div class="btnWrap writeBtn">
										<span class="button btM1 btRed cWh1"><a href="#">상품문의 하기</a></span>
										<p class="ct">상품에 대한 궁금한점을 문의해주세요.</p>
									</div>
									<ul class="qnaList">
										<li>
											<div class="q">
												<div>오늘 주문하면 언제쯤 발송 돼나요? 금요일엔 꼭 좀 받고 싶은데, 가능할까요?</div>
												<p class="writer">hakuna312 / 2014.08.11</p>
												<!-- for dev msg : 내가 쓴글일경우 노출됩니다. -->
												<p class="btnWrap">
													<span class="button btS2 btWht cBk1"><a href="">수정</a></span>
													<span class="button btS2 btWht cBk1"><a href="">삭제</a></span>
												</p>
												<!-- //for dev msg : 내가 쓴글일경우 노출됩니다. -->
											</div>
											<div class="a">
												<div>금일 주문하시면 익일 발송 가능하지만 택배사의 사정에따라 1~3일 소요 됩니다. 감사합니다. ^^</div>
											</div>
										</li>
										<li>
											<div class="q">
												<div>오늘 주문하면 언제쯤 발송 돼나요? 금요일엔 꼭 좀 받고 싶은데, 가능할까요?</div>
												<p class="writer">hakuna312 / 2014.08.11</p>
											</div>
											<div class="a">
												<div>금일 주문하시면 익일 발송 가능하지만 택배사의 사정에따라 1~3일 소요 됩니다. 감사합니다. ^^</div>
											</div>
										</li>
										<li>
											<div class="q">
												<div>오늘 주문하면 언제쯤 발송 돼나요? 금요일엔 꼭 좀 받고 싶은데, 가능할까요?</div>
												<p class="writer">hakuna312 / 2014.08.11</p>
											</div>
										</li>
										<li>
											<div class="q">
												<div>오늘 주문하면 언제쯤 발송 돼나요? 금요일엔 꼭 좀 받고 싶은데, 가능할까요?</div>
												<p class="writer">hakuna312 / 2014.08.11</p>
												<!-- for dev msg : 내가 쓴글일경우 노출됩니다. -->
												<p class="btnWrap">
													<span class="button btS2 btWht cBk1"><a href="">수정</a></span>
													<span class="button btS2 btWht cBk1"><a href="">삭제</a></span>
												</p>
												<!-- //for dev msg : 내가 쓴글일경우 노출됩니다. -->
											</div>
										</li>
									</ul>
									<div class="paging">
										<span class="arrow prevBtn"><a href="">prev</a></span>
										<span class="current"><a href="">1</a></span>
										<span><a href="">2</a></span>
										<span><a href="">3</a></span>
										<span><a href="">4</a></span>
										<span class="arrow nextBtn"><a href="">next</a></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<h2 class="tit02 tMar30"><span>관련 위시폴더</span></h2>
				<div class="relationWishFolder">
					<div class="swiper-container swiper3">
						<div class="swiper-wrapper">
							<ul class="relationWish swiper-slide">
								<li class="folderTit">
									<a href="">
										<p>litastrawber**</p>
										<p class="tPad05 fs11">팔로잉 30</p>
									</a>
								</li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
							</ul>
							<ul class="relationWish swiper-slide">
								<li class="folderTit">
									<a href="">
										<p>strawber**</p>
										<p class="tPad05 fs11">팔로잉 30</p>
									</a>
								</li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
							</ul>
							<ul class="relationWish swiper-slide">
								<li class="folderTit">
									<a href="">
										<p>strawber**</p>
										<p class="tPad05 fs11">팔로잉 30</p>
									</a>
								</li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
								<li><a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_110x110.png" alt="" /></a></li>
							</ul>
						</div>
					</div>
					<div class="pagination"></div>
				</div>

				<div class="ctgyPopularList">
					<h2 class="tit02 tMar30"><span>카테고리 인기상품</span></h2>
					<span class="moreBtn"><a href="">카테고리 리스트로 이동</a></span>
					<div class="swiper-container swiper4">
						<div class="swiper-wrapper">
							<ul class="simpleList swiper-slide">
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
							</ul>
							<ul class="simpleList swiper-slide">
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
							</ul>
							<ul class="simpleList swiper-slide">
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
							</ul>
						</div>
					</div>
					<div class="pagination"></div>
				</div>

				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span></h2>
					<ul class="list01">
						<li><a href="">모노폴리 포켓 시리즈 출시! <span class="cRd1">20%</span></a></li>
						<li><a href="">아는 여자들은 다 아는 스타일 업 아이템!</a></li>
						<li><a href="">포켓의 발견, 미니멀 모음전! <span class="cRd1">62%</span></a></li>
					</ul>
				</div>
			</div>
		</div>

		<div class="floatingBar">
			<div class="btnWrap cartBtnWrap">
				<div><span class="button btB1 btRed cWh1"><a href="">바로구매</a></span></div>
				<div><span class="button btB1 btRedBdr cRd1"><a href="">장바구니</a></span></div>
				<!-- 품절일때
				<div><span class="button btB1 btGry2 cWh1"><a href="">품절</a></span></div>
				-->
				<div class="wishBtn "style="width:30%;"><span class="button btB1 btGryBdr cGy1"><a href=""><em>75</em></a></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
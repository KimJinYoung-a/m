<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	$(function() {
		var mySwiper = new Swiper('.bnrExhibit .swiper-container',{
			pagination:'.pagination',
			paginationClickable:true,
			loop:true,
			resizeReInit:true,
			calculateHeight:true
		});

		$('.listWrap .pdtList').hide();
		$('.listWrap .pdtList:first').show();
		$('.tab h2').click(function() {
			$('.tab h2').removeClass('current');
			$(this).addClass('current');
			var tabView = $(this).attr('name');
			$(".listWrap .pdtList").hide();
			$(".listWrap div[id|='"+ tabView +"']").show();
		});
	});
</script>
</head>
<body>
<div class="wrapper" id="btwRcmd"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<h1 class="noView">비트윈추천</h1>
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="targetM typeA"><!-- for dev msg : 타겟별 다른 클래스 추가(남:targetM/여:targetF, 생일:typeA/100일:typeB/1주년:typeC/결혼기념일:typeD/발렌타인데이:typeE/화이트데이:typeF/빼빼로데이:typeG/크리스마스:typeH) -->
				<div class="bnrForUser boxMdl" style="background-color:#fff6c7; background-image:url(http://fiximage.10x10.co.kr/m/webview/between/main/bnr_user01.png);"><!-- for dev msg : 관리자에서 등록하는 이미지 와 컬러배경으로 등록 -->
					<a href="">
						<p style="color:#211818;">
							<em style="color:#ed4346;"><span>아메리카노조아...</span>님과의 100일</em><!-- for dev msg: 아이디는 한글기준으로 7자까지 보여주고 ... 줄임처리해주세요. -->
							<strong>선물이 고민이세요?</strong>
						</p>
					</a>
				</div>
				<div class="bnrForUser boxMdl" style="background-color:#fff6c7; background-image:url(http://fiximage.10x10.co.kr/m/webview/between/main/bnr_user01.png);"><!-- for dev msg : 관리자에서 등록하는 이미지 와 컬러배경으로 등록 -->
					<a href="">
						<p style="color:#211818;">
							<em><span style="color:#ed4346;">아메리카노조아...</span>님과의 결혼기념일</em>
							<strong>두분께 꼭 맞는 선물은?</strong>
						</p>
					</a>
				</div>
				<div class="bnrExhibit">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/main/@temp_bnr_exhibit.png" alt="달콤한 발렌타인데이를 완성하는 법" /></a></p><!-- for dev msg : 기획전(이벤트)명 alt값에 넣어주세요(이하동일) -->
							<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/main/@temp_bnr_exhibit.png" alt="달콤한 발렌타인데이를 완성하는 법" /></a></p>
							<p class="swiper-slide"><a href=""><img src="http://fiximage.10x10.co.kr/m/webview/between/main/@temp_bnr_exhibit.png" alt="달콤한 발렌타인데이를 완성하는 법" /></a></p>
						</div>
						<div class="pagination"></div>
					</div>
				</div>
				<div class="mdPick">
					<h2><strong>남자마음</strong>을 잘 아는 <strong>MD’s Pick!</strong></h2><!-- for dev msg : 타겟이 여자일때 예시문구 -->
					<!-- for dev msg : 타겟이 남자일때 예시문구 <h2><strong>여자마음</strong>을 잘 아는 <strong>MD’s Pick!</strong></h2> -->
					<ul class="pdtList list01 boxMdl">
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
								</a>
							</div>
						</li>
						<li>
							<div class="sale"><!-- for dev msg : 세일 상품일때 클래스 sale 추가됨 -->
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">카라 웨딩 테이블 세트</p>
									<p class="price">1,000,000원</p>
									<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018329.jpg" alt="Blue Paisley Sabados (M)" /></p>
									<p class="pdtName">매스큘린 프라이드 서스펜더 [3color] aa767</p>
									<p class="price">1,000,000원</p>
								</a>
							</div>
						</li>
					</ul>
					<span class="moreBtn"><a href="">더보기</a></span>
				</div>
			</div>
			<div class="listWrap boxMdl">
				<div class="tab">
					<h2 class="col2 current" name="newList">NEW</h2>
					<h2 class="col2" name="bestList">BEST</h2>
				</div>
				<!-- NEW List -->
				<div class="pdtList" id="newList">
					<ul class="list02 newList"><!-- for dev msg : 리스트 기본 상품 10개 노출, 더보기 클릭시 10개씩 추가 (최대 30개까지만 노출) -->
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
									<p class="pdtTag soldOut">품절</p><!-- for dev msg : 품절일때 추가됨 -->
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="NCK-5PM 향균 컬러 마스크" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p>
								</a>
							</div>
						</li>
					</ul>
					<div class="listAddBtn">
						<a href="">상품 더 보기</a>
					</div>
				</div>
				<!-- //NEW List -->
				<!-- BEST List -->
				<div class="pdtList" id="bestList">
					<ul class="list02 bestList">
						<li>
							<div>
								<a href="">
									<strong class="rank">1</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
									<p class="pdtName">NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<strong class="rank">2</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p><!-- for dev msg : 세일 상품일때 추가됨 -->
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">3</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">4</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">5</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<strong class="rank">6</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">7</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">8</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div>
								<a href="">
									<strong class="rank">9</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">스타벅스</span>
								</a>
							</div>
						</li>
						<li>
							<div class="sale">
								<a href="">
									<strong class="rank">10</strong>
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/101/B001018326.jpg" alt="카라 웨딩 테이블 세트" /></p>
									<p class="pdtName">NCK-5PM 향균 컬러 마스크</p>
									<p class="price">1,000,000원</p>
									<span class="seller">까페베네</span>
									<p class="pdtTag saleRed">30%</p>
								</a>
							</div>
						</li>
					</ul>
					<div class="listAddBtn">
						<a href="">상품 더 보기</a>
					</div>
				</div>
				<!-- //BEST List -->
			</div>
			<p class="svcNoti">비트윈의 기프트샵(이하 기프트샵)은 "텐바이텐"의 상품 판매를 중개하는 서비스 입니다. 기프트샵을 통한 "텐바이텐"의 상품판매와 관련하여 비트윈은 통신판매 중개자로서 통신판매의 당사자가 아니며, 상품주문, 배송 및 환불의 의무와 책임은 "텐바이텐"에게 있습니다.</p><!-- for dev msg : 비트윈추천 메인과 결제페이지에서만 노출 -->
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
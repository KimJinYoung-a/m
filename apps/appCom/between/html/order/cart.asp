<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	$(function() {
		var vSpos, vChk;
		$(window).on({
			'touchstart': function(e) {
				vSpos = $(window).scrollTop()
				vChk = false;
			}, 'touchmove': function(e) {
				if(vSpos!=$(window).scrollTop()) {
					$('.floatingBar').css('display','none');
					vChk = true;
				}
			}, 'touchend': function(e) {
				if(vChk) $('.floatingBar').fadeIn("fast");
			}
		});
	});
</script>
</head>
<body>
<div class="wrapper cartWrap" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">장바구니</h1>
			</div>

			<div class="section">
				<p>장바구니에 담으신 상품은 30일 동안 보관됩니다.</p>
			</div>

			<form action="">
				<!-- 텐바이텐 배송 상품 -->
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">텐바이텐 배송 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
						<div class="cart pdtList list02 boxMdl">
							<input type="checkbox" title="주문상품 선택" />
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
									<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
									<p class="pdtEtc"><strong class="txtSaleRed">[무료배송상품]</strong> <strong>[주문제작상품]</strong></p>
									<p class="pdtOption">네이비 / L / 기본패키지(2,500원)</p>
									<p class="pdtWord">문구 : 문구문구문구</p>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<span><em class="txtSaleRed">[50%] 15,000 원</em></span>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" title="수량 입력" />
										<button type="button" class="btn02 btw"><em>변경</em></button>
									</span>
								</li>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk">30,000 원</strong></span>
								</li>
							</ul>
							<button type="button" class="btnDel"><span>삭제</span></button>
						</div>

						<div class="cart pdtList list02 boxMdl">
							<input type="checkbox" title="주문상품 선택" />
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
									<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
									<p class="pdtEtc"><strong class="txtSaleRed">[무료배송상품]</strong></p>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<span><em class="txtSaleRed">[50%] 15,000 원</em></span>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" title="수량 입력" />
										<button type="button" class="btn02 btw"><em>변경</em></button>
									</span>
								</li>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk">30,000 원</strong></span>
								</li>
							</ul>
							<button type="button" class="btnDel">삭제</button>
						</div>

						<div class="total">
							<em>[총 1종/2개] 상품합계 30,000원 + 배송비 2,500원 = <strong class="txtBtwDk">32,500원</strong></em>
						</div>
					</div>
				</fieldset>
				<!-- //텐바이텐 배송 상품 -->

				<!-- 업체 무료 배송 상품 -->
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">업체 무료 배송 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
						<div class="cart pdtList list02 boxMdl">
							<input type="checkbox" title="주문상품 선택" />
							<div>
								<a href="">
									<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
									<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
									<p class="pdtEtc"><strong class="txtSaleRed">[무료배송상품]</strong></p>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<span><em class="txtSaleRed">[50%] 15,000 원</em></span>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" title="수량 입력" />
										<button type="button" class="btn02 btw"><em>변경</em></button>
									</span>
								</li>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk">30,000 원</strong></span>
								</li>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li><!-- for dev msg : 상품이 품절될 경우입니다. 소계는 미노출-->
							</ul>
							<button type="button" class="btnDel">삭제</button>
						</div>

						<div class="total">
							<em>[총 1종/2개] 상품합계 30,000원 + 배송비 2,500원 = <strong class="txtBtwDk">32,500원</strong></em>
						</div>
					</div>
				</fieldset>
				<!-- //업체 무료 배송 상품 -->

				<!-- 총 결제금액 -->
				<div class="hWrap hrBtw">
					<h2 class="headingB">총 결제금액 (2종 / 3개)</h2>
				</div>
				<div class="cart totalPrice">
					<ul class="priceCount">
						<li>
							<span>상품 총 금액</span>
							<span><em class="txtBlk">221,900 원</em></span>
						</li>
						<li>
							<span>배송비</span>
							<span><em class="txtBlk">5,000 원</em></span>
						</li>
						<li>
							<span><strong>결제 예정 금액</strong></span>
							<span><strong class="txtBtwDk">226,900 원</strong></span>
						</li>
					</ul>
				</div>
				<!-- //총 결제금액 -->

				<div class="floatingBar boxMdl cartIn cartOrder">
					<div class="btnWrap">
						<div class="btn01 btnDel"><a href="" class="cnclGry">선택상품 삭제</a></div>
						<div class="btn01 btnOrderSelect"><a href="" class="wht">선택상품 주문</a></div>
						<div class="btn01 btnOrderAll"><a href="" class="edwPk">전체상품 주문</a></div>
					</div>
				</div>
			</form>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
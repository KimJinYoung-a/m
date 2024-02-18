<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content shop" id="contentArea">

<!------- 2014 frame ------------->

			<!-- wrapper -->
			<div class="wrapper cart">
				<!-- #header -->
				<header id="header">
						<h1 class="page-title">장바구니</h1>
						<ul class="txt-list">
								<li>장바구니는 접속 종료 후 14일동안 보관됩니다.</li>
								<li>장기간 상품을 보관하시려면 위시에 넣어주세요.</li>
						</ul>
				</header><!-- #header -->
				<!-- #content -->
				<div id="content">

						<!-- 상품이 없는 경우 -->
						<div class="no-item-message t-c" style="display:none">
								<p class="diff-10"></p>
								<img src="../../img/img-sad.png" alt="" style="width:50px;">
								<p class="diff-10"></p>
								<p class="x-large quotation" style="width:164px;">
										<strong>장바구니에 담긴<br><span class="red">상품이 없습니다.</span></strong>
								</p>
						</div>
						<!-- //상품이 없는 경우 -->

						<!-- 상품이 있는 경우 -->
						<div class="cart-box by-10x10">
								<h1 class="cart-title"><span>텐바이텐 배송상품  (총 <strong class="red">2</strong>개)</span></h1>
								<label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
								<div class="product-in-cart">
										<ul>
												<li>
													 <input type="checkbox" class="form checker">
														<img src="../../img/_dummy-200x200.png" alt="" class="product-img" width="200" height="200">
														<div class="product-spec">
																<h2 class="product-name">처칠머그컵(런던트레블, 크라운 실루엣 중 택1) 처칠..</h2>
																<div>
																		<span class="red">[무료배송상품]</span>
																		<span class="blue">[%보너스쿠폰제외 상품]</span>
																</div>
																<div class="option">
																		<span class="">화이트</span>
																</div>
														</div>
														<hr class="clear">
														<table>
																<tr>
																		<th>판매가</th>
																		<td>129,000<span class="unit">원</span></td>
																</tr>
																<tr>
																		<th>할인판매가</th>
																		<td>
																				<strong class="red">320,000<span class="uint">원</span></strong>   <span class="discount red">20%↓</span>
																		</td>
																</tr>
																<tr>
																		<th>수량</th>
																		<td>
																				<div class="input-with-btn">
																						<input type="text" value="1" class="form">
																						<button class="btn type-d">변경</button>
																				</div>
																		</td>
																</tr>
																<tr>
																		<th>총금액</th>
																		<td><strong>129,000<span class="unit">원</span></strong></td>
																</tr>
														</table>
														<hr class="clear">
														<div class="three-btns">
																<div class="col">
																		<button class="btn type-e small"><i class="icon-trash"></i>삭제</button>
																</div>
																<div class="col">
																		<button class="btn type-f small"><i class="icon-love"></i>위시</button>
																</div>
																<div class="col">
																		<button class="btn type-b small"><i class="icon-check"></i>바로주문</button>
																</div>
														</div>
														<div class="clear"></div>
												</li>
												<li>
													 <input type="checkbox" class="form checker">
														<img src="../../img/_dummy-200x200.png" alt="" class="product-img" width="200" height="200">
														<div class="product-spec">
																<h2 class="product-name">처칠머그컵(런던트레블, 크라운 실루엣 중 택1) 처칠..</h2>
																<div>
																		<span class="red">[무료배송상품]</span>
																		<span class="blue">[%보너스쿠폰제외 상품]</span>
																</div>
																<div class="option">
																		<span class="">화이트</span>
																</div>
														</div>
														<hr class="clear">
														<table>
																<tr>
																		<th>판매가</th>
																		<td>129,000<span class="unit">원</span></td>
																</tr>
																<tr>
																		<th>할인판매가</th>
																		<td>
																				<strong class="red">320,000<span class="uint">원</span></strong>   <span class="discount red">20%↓</span>
																		</td>
																</tr>
																<tr>
																		<th>수량</th>
																		<td>
																				<div class="input-with-btn">
																						<input type="text" value="1" class="form">
																						<button class="btn type-d">변경</button>
																				</div>
																		</td>
																</tr>
																<tr>
																		<th>총금액</th>
																		<td><strong>129,000<span class="unit">원</span></strong></td>
																</tr>
														</table>
														<hr class="clear">
														<div class="three-btns">
																<div class="col">
																		<button class="btn type-e small"><i class="icon-trash"></i>삭제</button>
																</div>
																<div class="col">
																		<button class="btn type-f small red"><i class="icon-love"></i>위시</button>
																</div>
																<div class="col">
																		<button class="btn type-b small"><i class="icon-check"></i>바로주문</button>
																</div>
														</div>
														<div class="clear"></div>
												</li>
										</ul>
										
								</div>

								<div class="cart-sum">
										<strong class="red">총 1개 / 129,000<span class="unit">원</span></strong>
										상품합계 129,000<span class="unit">원</span> + 배송비 0<span class="unit">원</span> = 129,000<span class="unit">원</span>
								</div>
						</div>

						<div class="cart-box by-indie">
								<h1 class="cart-title"><span>업체 조건 배송상품  (총 <strong class="red">1</strong>개)</span></h1>
								<label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
								<div class="product-in-cart">
										<ul>
												<li>
													 <input type="checkbox" class="form checker">
														<img src="../../img/_dummy-200x200.png" alt="" class="product-img" width="200" height="200">
														<div class="product-spec">
																<h2 class="product-name">처칠머그컵(런던트레블, 크라운 실루엣 중 택1) 처칠..</h2>
																<div>
																		<span class="red">[무료배송상품]</span>
																		<span class="blue">[%보너스쿠폰제외 상품]</span>
																</div>
																<div class="option">
																		<span class="">화이트</span>
																</div>
														</div>
														<hr class="clear">
														<table>
																<tr>
																		<th>판매가</th>
																		<td>129,000<span class="unit">원</span></td>
																</tr>
																<tr>
																		<th>할인판매가</th>
																		<td>
																				<strong class="red">320,000<span class="uint">원</span></strong>   <span class="discount red">20%↓</span>
																		</td>
																</tr>
																<tr>
																		<th>수량</th>
																		<td>
																				<div class="input-with-btn">
																						<input type="text" value="1" class="form">
																						<button class="btn type-d">변경</button>
																				</div>
																		</td>
																</tr>
																<tr>
																		<th>총금액</th>
																		<td><strong>129,000<span class="unit">원</span></strong></td>
																</tr>
														</table>
														<hr class="clear">
														<table>
																<colgroup>
																		<col width="110"/>
																		<col/>
																</colgroup>
																<tr>
																		<th class="v-t">주문제작문구</th>
																		<td class="t-l">
																				안녕하세요? 안녕하세요? 안녕하세요? 안녕하세요?  안녕<br>
																				<button class="btn type-e small full-size" style="margin-top:5px;">내용수정</button>
																		</td>
																</tr>
														</table>
														<hr class="clear">
														<div class="three-btns">
																<div class="col">
																		<button class="btn type-e small"><i class="icon-trash"></i>삭제</button>
																</div>
																<div class="col">
																		<button class="btn type-f small"><i class="icon-love"></i>위시</button>
																</div>
																<div class="col">
																		<button class="btn type-b small"><i class="icon-check"></i>바로주문</button>
																</div>
														</div>
														<div class="clear"></div>
												</li>
										</ul>
										
								</div>

								<div class="cart-sum">
										<strong class="red">총 1개 / 129,000<span class="unit">원</span></strong>
										상품합계 129,000<span class="unit">원</span> + 배송비 0<span class="unit">원</span> = 129,000<span class="unit">원</span>
								</div>
						</div>

						<div class="inner">
								<table class="cart-total plain">
										<tr>
												<th>총 주문상품 수</th>
												<td>4종(4개)</td>
										</tr>
										<tr>
												<th>적립마일리지</th>
												<td>8,590 Point</td>
										</tr>
										<tr>
												<th>총 상품주문 합계</th>
												<td>859,050 <span class="unit">원</span></td>
										</tr>
										<tr>
												<th>총 배송비 합계</th>
												<td>0 <span class="unit">원</span></td>
										</tr>
										<tr class="highlight">
												<th>총 합계</th>
												<td><strong>859,050 <span class="unit">원</span></strong></td>
										</tr>
								</table>
								<div class="three-btns">
										<div class="col">
												<button class="btn type-a">선택상품 삭제</button>
										</div>
										<div class="col">
												<button class="btn type-f">선택상품 주문</button>
										</div>
										<div class="col">
												<button class="btn type-f">해외배송 주문</button>
										</div>
								</div>
								<div class="clear"></div>
								<div class="diff-10"></div>
								<button class="btn type-b full-size"> <i class="icon-check"></i>전체상품 주문하기</button>
						</div>
						<div class="diff"></div>
						<div class="well type-b">
								<h2>유의사항</h2>
								<ul class="txt-list">
										<li>장바구니는 접속 종료 후 7일 동안 보관 됩니다.</li>
										<li>그 이상 기간 동안 상품을 보관하시려면 위시리스트 (wish list)에 넣어주세요.</li>
										<li>상품배송비는 텐바이텐배송/업체배송/업체조건배송/업체착불배송 4가지 기준으로 나누어 적용됩니다.</li>
										<li>업체배송 및 업체조건배송, 업체착불배송 상품은 해당 업체에서 별도로 배송되오니 참고하여 주시기 바랍니다.</li>
								</ul>
						</div>

						<div class="diff"></div>
						<div class="inner">
								<div class="mileage-shop">
										<dl class="mileage-header">
												<dt>마일지리샵</dt>
												<dd>현재 마일리지 <strong class="red">1,200 point</strong></dd>
										</dl>
										<ul class="mileage-shop-product-list">
												<li class="bordered-box">
														<div class="product-info gutter">
																<div class="product-img">
																		<img src="../../img/_dummy-200x200.png" alt="">
																</div>
																<div class="product-spec">
																		<p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
																		<p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
																</div>
																<div class="point">
																		<strong>1,500 Point</strong>
																</div>
																<button class="btn type-b small btn-cart">장바구니 담기</button>
														</div>
												</li>
												<li class="bordered-box">
														<div class="product-info gutter">
																<div class="product-img">
																		<img src="../../img/_dummy-200x200.png" alt="">
																</div>
																<div class="product-spec">
																		<p class="product-brand">[A.MONO FURNITURE STUDIO STUDIO] </p>
																		<p class="product-name">처칠머그컵(런던트레블, 크라운실루엣 중 택1) 처칠..</p>
																</div>
																<div class="point">
																		<strong>1,500 Point</strong>
																</div>
																<button class="btn type-b small btn-cart">장바구니 담기</button>
														</div>
												</li>
										</ul>
								</div>
						</div>
						<div class="well type-b">
								<ul class="txt-list">
										<li>마일리지는 구매 또는 상품후기 작성으로 쌓을 수 있습니다.</li>
										<li>마일리지샵 상품은 텐바이텐 배송 상품과 함께 한 상품당 하나씩만 구매하실 수 있습니다.</li>
								</ul>
						</div>
						<!-- //상품이 있는 경우 -->

				</div><!-- #content -->
				
				<!-- #footer -->
				<footer id="footer">
				</footer><!-- #footer -->
			</div>
			<!-- wrapper -->


<!------- 2014 frame ------------->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
<script>
$('.cart-box').each(function(){
		var box = $(this);
		$('.check-all input[type="checkbox"]', box).on('click', function(){
				if ( $(this).is(":checked") == true) {
						$('.product-in-cart .checker', box).attr('checked', true);
				} else {
						$('.product-in-cart .checker', box).attr('checked', false);
				}
		});
});

</script>
</body>
</html>
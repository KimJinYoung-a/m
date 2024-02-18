<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap">
				<h1 class="headingA">반품/환불</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 00000000000]</strong>
				</div>
			</div>

			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>반품배송비는 브랜드별로 다를 수 있습니다.</li>
					<li><strong class="txtBtwDk">주문제작 상품 등 일부 상품은 반품이 불가</strong>합니다.</li>
					<li>새상품 교환은 반드시 텐바이텐 고객행복센터(1644-6030)로 문의해주시기 바랍니다.</li>
					<li>금액할인쿠폰을 사용하여 여러 개의 상품을 구매하시는 경우, 상품별 판매가에 따라 할인금액이 각각 분할되어 적용됩니다</li>
				</ul>
			</div>

			<form action="">
			<!-- 주문 상품 정보 -->
			<fieldset>
				<div class="hWrap">
					<h2 class="headingB">주문 상품 정보</h2>
				</div>
				<div class="shoppingCart addSelection">
					<div class="cart pdtList list02 boxMdl">
						<input type="checkbox" title="주문상품 선택" />
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
								<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
								<p class="pdtOption">네이비 / L / 기본패키지</p>
								<p class="pdtWord">문구 : 문구문구문구</p>
							</a>
						</div>

						<ul class="priceCount">
							<li>
								<span>상품코드/배송</span>
								<span>00000000 / 텐바이텐배송</span>
							</li>
							<li>
								<span>판매가</span>
								<span>5,000,000 원</span>
							</li>
							<li>
								<span>소계금액 <strong class="txtTopGry">(2개)</strong></span>
								<span>
									<del class="txtBtwDk">10,000,000 원</del>
									<strong class="txtSaleRed">9,000,000 원 <em class="txtSaleRed">[보너스쿠폰 적용]</em></strong><!-- for dev msg :  보너스쿠폰 적용될 경우 class="txtSaleRed" 넣어주세요 -->
								</span>
							</li>
							<li>
								<span>주문상태</span>
								<span><strong class="txtSaleRed">출고완료</strong></span>
							</li>
						</ul>
					</div>
					<div class="cart pdtList list02 boxMdl">
						<input type="checkbox" title="주문상품 선택" />
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
								<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
								<p class="pdtOption">네이비 / L / 기본패키지</p>
							</a>
						</div>

						<ul class="priceCount">
							<li>
								<span>상품코드/배송</span>
								<span>00000000 / 텐바이텐배송</span>
							</li>
							<li>
								<span>판매가</span>
								<span>5,000,000 원</span>
							</li>
							<li>
								<span>소계금액 <strong class="txtTopGry">(2개)</strong></span>
								<span>
									<del class="txtBtwDk">10,000,000 원</del>
									<strong class="txtCpGreen">9,000,000 원 <em>[보너스쿠폰 적용]</em></strong><!-- for dev msg :상품쿠폰 적용일 경우 class="txtCpGreen" 입니다. -->
								</span>
							</li>
							<li>
								<span>주문상태</span>
								<span><strong class="txtSaleRed">출고완료</strong></span>
							</li>
						</ul>
					</div>
				</div>
			</fieldset>
			<!-- //주문 상품 정보 -->

			<!-- 결제금액 -->
			<fieldset>
				<div class="hWrap">
					<h2 class="headingB">결제 금액 <em>(2종/3개)</em></h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeB">
					<caption>결제금액 정보</caption>
					<tbody>
					<tr>
						<th scope="row">상품 총 금액</th>
						<td>
							<del class="txtBtwDk">182,900 원</del> <em class="txtSaleRed">182,900 원</em>
						</td>
					</tr>
					<tr>
						<th scope="row">배송비</th>
						<td>5,000 원</td>
					</tr>
					<tr class="hr">
						<th scope="row">보너스쿠폰 사용</th>
						<td><em class="txtSaleRed">-200 원</em></td>
					</tr>
					<tr>
						<th scope="row">상품쿠폰 사용</th>
						<td><em class="txtCpGreen">- 17,400 원</em></td>
					</tr>
					<tr>
						<th scope="row">마일리지 사용</th>
						<td><em class="txtSaleRed">-120 P</em></td>
					</tr>
					<tr>
						<th scope="row">예치금 사용</th>
						<td><em class="txtSaleRed">-100 원</em></td>
					</tr>
					<tr>
						<th scope="row">Gift카드 사용</th>
						<td><em class="txtSaleRed">-100 원</em></td>
					</tr>
					<tr class="sum">
						<th scope="row"><strong class="txtBlk">최종결제액</strong></th>
						<td>
							<div>
								<strong class="txtBtwDk">151,000 원</strong>
								<p class="txtBlk">(총 25,000원 할인되었습니다.)</p>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<!-- //결제금액 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="">선택상품 반품신청</a></span>
			</div>
			</form>

			<!-- 반품 가이드 -->
			<div class="hWrap">
				<h2 class="headingB">반품 가이드</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>불량 및 파손에 의한 반품을 제외한, 고객변심에 의한 반품은 출고일로부터 7일 이후(평일기준)에는 불가합니다.</li>
					<li>상품의 배송구분에 따라 반품방식이 다르니, 이점 유의하시기 바랍니다.</li>
				</ul>
			</div>
			<!-- //반품 가이드 -->

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
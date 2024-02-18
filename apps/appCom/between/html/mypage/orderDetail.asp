<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문/배송 상세내역</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 000000000000]</strong>
				</div>
			</div>

			<ul class="orderTab">
				<li class="order01 current"><a href="">주문상품</a></li>
				<li class="order02"><a href="">구매자</a></li>
				<li class="order03"><a href="">결제</a></li>
				<li class="order04"><a href="">배송지</a></li>
			</ul>

			<div class="shoppingCart">
				<div class="cart pdtList list02 boxMdl">
					<div>
						<a href="">
							<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
							<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
							<p class="pdtOption">네이비 / L / 기본패키지(2,500원)</p>
							<p class="pdtWord">문구 : 문구문구문구</p>
						</a>
					</div>

					<ul class="priceCount">
						<li>
							<span>판매가</span>
							<span><del class="txtBtwDk">6,000,000 원</del> <em class="txtSaleRed">5,000,000 원</em></span>
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
							<span><strong class="txtSaleRed">상품준비중</strong></span>
						</li>
					</ul>
				</div>

				<div class="cart pdtList list02 boxMdl">
					<div>
						<a href="">
							<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
							<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
							<p class="pdtOption">네이비 / L / 기본패키지(2,500원)</p>
							<p class="pdtWord">문구 : 문구문구문구</p>
						</a>
					</div>

					<ul class="priceCount">
						<li>
							<span>판매가</span>
							<span><del class="txtBtwDk">6,000,000 원</del> <em class="txtSaleRed">5,000,000 원</em></span>
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
							<span><strong class="txtBlk">출고완료</strong></span>
						</li>
						<li>
							<span>택배정보</span>
							<span><em class="txtTopGry">CJ대한통운 | <a href="">000000000000</a></em></span>
						</li>
					</ul>
				</div>

				<div class="cart pdtList list02 boxMdl">
					<div>
						<a href="">
							<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
							<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
							<p class="pdtOption">네이비 / L / 기본패키지(2,500원)</p>
							<p class="pdtWord">문구 : 문구문구문구</p>
						</a>
					</div>

					<ul class="priceCount">
						<li>
							<span>판매가</span>
							<span><del class="txtBtwDk">6,000,000 원</del> <em class="txtSaleRed">5,000,000 원</em></span>
						</li>
						<li>
							<span>소계금액 <strong class="txtTopGry">(2개)</strong></span>
							<span>
								<strong class="txtBtwDk">9,000,000 원</strong><!-- for dev msg :상품쿠폰 적용일 경우 class="txtCpGreen" 입니다. -->
							</span>
						</li>
						<li>
							<span>주문상태</span>
							<span><strong class="txtBlk">출고완료</strong></span>
						</li>
						<li>
							<span>택배정보</span>
							<span><em class="txtTopGry">CJ대한통운 | <a href="">000000000000</a></em></span>
						</li>
					</ul>
				</div>
			</div>

			<!-- 결제금액 -->
			<div class="hWrap hrBtw">
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
			<!-- //결제금액 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="">주문취소 신청</a></span>
				<span class="btn02 cnclGry btnBig full"><a href="">목록으로 돌아가기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
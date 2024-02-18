<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap">
				<h1 class="headingA">반품/환불 접수</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 00000000000]</strong>
				</div>
			</div>

			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품의 반품을 신속하고 빠르게 처리해 드릴 수 있도록 노력하겠습니다.<br /> <strong class="txtBtwDk">교환 및 맞교환을 원하시는 경우는 텐바이텐 고객행복센터(1644-6030) 로 문의 부탁 드립니다.</strong></li>
				</ul>
			</div>

			<form action="">
			<!-- 반품 상품 정보 -->
			<fieldset>
				<div class="hWrap">
					<h2 class="headingB">반품 상품 정보</h2>
				</div>
				<div class="shoppingCart">
					<div class="cart pdtList list02 boxMdl">
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
								<span>수량</span>
								<span>
									<input type="text" title="수량 입력" />
									<button type="button" class="btn02 btw"><em>변경</em></button>
								</span>
							</li>
							<li>
								<span>소계금액</span>
								<span>
									<del class="txtBtwDk">10,000,000 원</del>
									<strong class="txtSaleRed">9,000,000 원 <em class="txtSaleRed">[보너스쿠폰 적용]</em></strong><!-- for dev msg :  보너스쿠폰 적용될 경우 class="txtSaleRed" 넣어주세요 -->
								</span>
							</li>
						</ul>
					</div>
					<div class="cart pdtList list02 boxMdl">
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
								<span>수량</span>
								<span>
									<input type="text" title="수량 입력" />
									<button type="button" class="btn02 btw"><em>변경</em></button>
								</span>
							</li>
							<li>
								<span>소계금액</span>
								<span>
									<del class="txtBtwDk">10,000,000 원</del>
									<strong class="txtCpGreen">9,000,000 원 <em>[보너스쿠폰 적용]</em></strong><!-- for dev msg :상품쿠폰 적용일 경우 class="txtCpGreen" 입니다. -->
								</span>
							</li>
						</ul>
					</div>

					<div class="total">
						<em>반품상품 총 금액 <strong class="txtBtwDk">18,000,000</strong>원</em>
					</div>
				</div>
			</fieldset>
			<!-- //반품 상품 정보 -->

			<!-- 반품 상세 정보 -->
			<fieldset>
				<div class="hWrap">
					<h2 class="headingB">반품 상세 정보</h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>주문고객 정보</caption>
					<tbody>
					<tr>
						<th scope="row">반품 사유</th>
						<td></td>
					</tr>
					<tr>
						<th scope="row">결제정보</th>
						<td></td>
					</tr>
					<tr>
						<th scope="row">환불방법</th>
						<td></td>
					</tr>
					<tr>
						<th scope="row">환불예정금액</th>
						<td></td>
					</tr>
					<tr>
						<th scope="row"><label for="requestedTerm">기타 요청사항</label></th>
						<td>
							<input type="text" id="requestedTerm" name="" />
						</td>
					</tr>
					</tbody>
					</table>
				</div>
			</fieldset>
			<!-- //반품 상세 정보 -->
			</form>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
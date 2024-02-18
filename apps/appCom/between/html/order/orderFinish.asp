<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
	$(function() {
		// 주문리스트 상세 보기 버튼 컨트롤
		$('.orderList .extendBtn').click(function(){
			$('.orderList .pdtList').toggleClass('extend');
			$(this).toggleClass('cut');
			if ($(this).hasClass('cut')) {
				$(this).html('주문리스트 상세 닫기');
			} else {
				$(this).html('주문리스트 상세 보기');
			};
		});
	});
</script>
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문완료</h1>
				<div class="option">
					<span class="afterLogin"><strong>ajung611ajung611</strong>님 <a href="">[텐바이텐 로그아웃]</a></span><!-- for dev msg : 회원 -->
				</div>
			</div>

			<div class="msgBox">
				<p>주문이 정상적으로 완료 되었습니다.<br /> 이용해 주셔서 감사합니다.</p>
				<p><strong class="txtBtwDk">주문번호 : 000000000000</strong></p>
			</div>

			<!-- 결제정보 확인 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">결제정보 확인</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeA">
				<caption>결제정보 확인</caption>
				<tbody>
				<tr>
					<th scope="row">결제방법</th>
					<td>무통장</td>
				</tr>
				<tr>
					<th scope="row">입금가상계좌</th>
					<td>
						<div class="bankAccount"><strong>국민 68249011744963</strong> <strong>(주)텐바이텐</strong></div>
					</td>
				</tr>
				<tr>
					<th scope="row">주문일시</th>
					<td>2014-02-04 19:24:59</td>
				</tr>
				<tr>
					<th scope="row">최종결제액</th>
					<td>
						<div class="finalPayment">
							<strong class="txtBtwDk">131,099원</strong>
							<ul>
								<li>마일리지 사용 : <em class="txtSaleRed">3,000P</em></li>
								<li>예치금 사용 : <em class="txtSaleRed">3,000원</em></li>
								<li>Gift 카드 사용 : <em class="txtSaleRed">3,000원</em></li>
								<li>보너스쿠폰 사용 : <em class="txtSaleRed">10,000원</em></li>
							</ul>
						</div>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //결제정보 확인 -->

			<!-- 주문리스트 확인 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문리스트 확인 (2종 / 3개)</h2>
			</div>
			<div class="orderList orderListMore">
				<div class="extendBtn">주문리스트 상세 보기</div>

				<ul class="pdtList list02 boxMdl">
					<li>
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
								<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명명상품명상품상품명상품상</p>
								<p class="subtotal">소계금액 : <strong class="txtBtwDk">69,000원</strong> (4개)</p>
								<p class="delivery">[텐바이텐배송]</p>
							</a>
						</div>
					</li>
					<li>
						<div>
							<a href="">
								<p class="pdtPic"><img src="http://webimage.10x10.co.kr/image/basic/90/B000904599.jpg" alt="상품명" /></p>
								<p class="pdtName">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>
								<p class="subtotal">소계금액 : <strong class="txtBtwDk">69,000원</strong> (4개)</p>
								<p class="delivery">[텐바이텐배송]</p>
							</a>
						</div>
					</li>
				</ul>
			</div>
			<!-- //주문리스트 확인 -->

			<!-- 주문고객정보 확인 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문고객정보 확인</h2>
			</div>

			<div class="section">
				<table class="tableType tableTypeA">
				<caption>주문고객 정보</caption>
				<tbody>
				<tr>
					<th scope="row">보내시는 분</th>
					<td>정텐텐</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>ajung611@10x10.co.kr</td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td>010-0000-1010</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td>02-1010-1010</td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //주문고객정보 확인 -->

			<!-- 배송지정보 확인 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">배송지정보 확인</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeA">
				<caption>배송지 정보</caption>
				<tbody>
				<tr>
					<th scope="row">받으시는 분</th>
					<td>정텐텐</td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td>010-0000-1010</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td>02-1010-1010</td>
				</tr>
				<tr class="deliveryAddress">
					<th scope="row">주소</th>
					<td>
						<span>[135-521]</span>
						<p>서울시 강남구 수서동 광평로31길 27 삼성아파트</p>
					</td>
				</tr>
				<tr>
					<th scope="row">배송유의사항</th>
					<td>부재 시 경비실에 부탁 드립니다.</td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //배송지정보 확인 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="">쇼핑 계속하기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
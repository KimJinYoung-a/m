<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문취소
					<!-- for dev msg : 무통장 결제 후 주문취소일 경우에 보여주세요 -->
					<span>(무통장 결제 후 주문취소)</span>
					<!-- //for dev msg : 무통장 결제 후 주문취소일 경우 -->
				</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 000000000000]</strong>
				</div>
			</div>

			<div class="section">
				<ul class="txtList01 txtBlk">
					<li><strong class="txtBtwDk">상품 일부만 취소</strong>하고자 하시는 경우, 텐바이텐 고객행복센터(<a href="tel:1644-6030">1644-6030</a>)로 문의 주시기 바랍니다.</li>
					<li><strong class="txtBtwDk">이미 출고된 상품</strong>이 있는 경우 주문을 취소할 수 없습니다.</li>
					<li><strong class="txtBtwDk">주문제작상품의 특성상 제작이 들어간 경우, 취소가 불가능 할 수 있습니다.</strong></li>
				</ul>
			</div>

			<!-- 주문 상품 정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문 상품 정보</h2>
			</div>
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
							<span><strong class="txtBlk">주문접수</strong></span>
						</li>
					</ul>
				</div>
			</div>
			<!-- //주문 상품 정보 -->

			<!-- 결제정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">결제정보</h2>
			</div>
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>결제정보</caption>
				<tbody>
				<tr>
					<th scope="row">결제방법</th>
					<td><strong>무통장</strong></td>
				</tr>
				<tr>
					<th scope="row">입금가상계좌</th>
					<td>
						<div class="bankAccount"><strong>국민 68249011744963</strong> <strong>(주)텐바이텐</strong></div>
					</td>
				</tr>
				<tr>
					<th scope="row">입금예정자명</th>
					<td><strong>정텐텐</strong></td>
				</tr>
				<tr>
					<th scope="row">결제확인일시</th>
					<td></td>
				</tr>
				<tr>
					<th scope="row">마일리지 사용</th>
					<td><em class="txtSaleRed">0 P</em></td>
				</tr>
				<tr>
					<th scope="row">쿠폰 사용</th>
					<td><em class="txtSaleRed">0 원</em></td>
				</tr>
				<tr>
					<th scope="row">기타 할인</th>
					<td><em class="txtSaleRed">0 원</em></td>
				</tr>
				<tr>
					<th scope="row">최종 결제액</th>
					<td><strong class="txtBtwDk">151,000 원</strong></td>
				</tr>
				<tr>
					<th scope="row">적립 마일리지</th>
					<td><strong>결제 후 적립</strong></td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //결제정보 -->

			<!-- 무통장 결제 후 주문취소 -->
			<fieldset>
				<div class="hWrap hrBtw">
					<h2 class="headingB">무통장 결제 후 주문취소</h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>무통장 결제 후 주문취소</caption>
					<tbody>
					<tr class="fix">
						<th scope="row">환불금액</th>
						<td><em class="txtSaleRed">17,800원</em></td>
					</tr>
					<tr class="fix">
						<th scope="row">환불방법</th>
						<td>
							<input type="radio" id="refundWay1" name="" checked="checked"> <label for="refundWay1">계좌환불</label>
							<input type="radio" id="refundWay2" name="" style="margin-left:10px;"> <label for="refundWay2">예치금전환</label>
						</td>
					</tr>
					</tbody>
					<!-- for dev msg: 예치금전환 시 숨겨주세요 -->
					<tbody class="balance">
					<tr>
						<th scope="row"><label for="accountBank">환불계좌은행</label></th>
						<td>
							<select id="accountBank">
								<option>환불계좌은행</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="accountNumber">환불계좌번호</label></th>
						<td>
							<input type="text" id="accountNumber" name="" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="accountHolder">환불계좌 예금주</label></th>
						<td>
							<input type="text" id="accountHolder" name="" />
						</td>
					</tr>
					</tbody>
					<!-- //for dev msg: 예치금전환 시 숨겨주세요 -->
					</table>
				</div>

				<div class="section">
					<ul class="txtList03 txtBlk">
						<li><strong class="txtBtwDk">계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력</strong></li>
						<li>계좌번호 및 예금주명이 정화하지 않으면 입금이 지연될 수 있음</li>
						<li>접수 후 1,2일 이내(영업일 기준) 등록하신 계좌(마일리지)로 환불되며, 문자메시지로 안내</li>
					</ul>
				</div>
			</fieldset>
			<!-- //무통장 결제 후 주문취소 -->

			<!-- 총 결제금액 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">총 결제 금액 <em>(2종/3개)</em></h2>
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
			<!-- //총 결제금액 -->

			<!-- for dev msg : 회원일때만 보임 -->
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>사용하신 예치금, 마일리지 및 쿠폰은 취소 즉시 복원 됩니다.</li>
					<li>금액할인쿠폰을 사용하여 여러 개의 상품을 구매하시는 경우, 상품별 판매가에 따라 할인금액이 각각 분할되어 적용됩니다.</li>
				</ul>
			</div>
			<!-- //for dev msg : 회원일때만 보임 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="">주문 전체 취소</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
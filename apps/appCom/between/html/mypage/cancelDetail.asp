<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">취소/교환/반품 상세</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 000000000000]</strong>
				</div>
			</div>

			<div class="section">
				<p>고객님이 신청하신 서비스 상세내역입니다.</p>
			</div>

			<!-- 서비스 구분명 -->
			<div class="cancelInformation">
				<div class="hWrap hrBtw">
					<h2 class="headingB">서비스 구분명</h2><!-- for dev msg : 내역에 따라 다름 타이틀이 다름 -->
				</div>

				<div class="sectionLine">
					<table class="tableType tableTypeA">
					<caption>서비스 구분명</caption><!-- for dev msg : 내역에 따라 caption명 변경해주세요. -->
					<tbody>
					<tr>
						<th scope="row">서비스코드</th>
						<td><strong>000000 <span class="txtSaleRed">[완료]</span></strong></td>
					</tr>
					<tr>
						<th scope="row">접수일시</th>
						<td>YYYY.MM.DD 오전 0:00:00</td>
					</tr>
					<tr>
						<th scope="row">접수사유</th>
						<td>고객변심</td>
					</tr>
					<tr>
						<th scope="row">접수내용</th>
						<td>교환출고(상품변경)</td>
					</tr>
					<tr>
						<th scope="row">고객추가배송비</th>
						<td><em class="txtSaleRed">00 원</em></td>
					</tr>
					<tr>
						<th scope="row">부담방법</th>
						<td>박스동봉</td>
					</tr>
					<tr>
						<th scope="row">관련운송장번호</th>
						<td>
							<div class="invoiceNo">
								<span>CJ택배 <a href="">0000000000</a></span>
								<div class="btnArea">
									<span class="btn02 cnclGry"><a href="">조회</a></span>
									<span class="btn02 cnclGry"><a href="">반품운송장등록</a></span>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">처리일시</th>
						<td>YYYY.MM.DD 오전 0:00:00</td>
					</tr>
					<tr>
						<th scope="row">처리내용</th>
						<td>
							<p>주문취소 후 신용카드취소 요청 접수</p>
							<strong>[주문취소완료]</strong>
						</td>
					</tr>
					</tbody>
					</table>
				</div>

				<!-- for dev msg : 반품 건에만에서 노출  -->
				<div class="btnArea">
					<span class="btn02 btw btnBig full"><a href="">반품 철회</a></span>
				</div>
			</div>
			<!-- //서비스 구분명 -->

			<!-- 접수상품 정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">접수상품 정보</h2>
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
							<span>상품코드/배송</span>
							<span><em class="txtBlk">00000000 / 텐바이텐배송</em></span>
						</li>
						<li>
							<span>판매가</span>
							<span><strong class="txtBtwDk">5,000,000 원</strong></span>
						</li>
						<li>
							<span>소계금액 <em class="txtTopGry">(2개)</em></span>
							<span><strong class="txtSaleRed">10,000,000 원</strong></span>
						</li>
					</ul>
				</div>

				<div class="total">
					<em>[총 1종/2개] 상품합계 30,000원 + 배송비 2,500원 = <strong class="txtBtwDk">32,500원</strong></em>
				</div>
			</div>
			<!-- //접수상품 정보 -->

			<!-- 환불정보 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">환불정보</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeB">
				<caption>환불정보</caption>
				<tbody>
				<tr>
					<th scope="row">환불예정액</th>
					<td><strong class="txtBtwDk">177,520 원</strong> <em class="txtSaleRed">(사용예치금환급액 : 200 원)</em></td>
				</tr>
				<tr>
					<th scope="row">환불방법</th>
					<td>신용카드 취소</td>
				</tr>
				</tbody>
				</table>
			</div>
			<!-- //환불정보 -->

			<!-- 회수안내 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">회수안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 신청 후 2-3일 내에 택배기사님이 방문하시어, 반품상품을 회수할 예정입니다.<br /> 배송박스에 상품이 파손되지 않도록 재포장 하신 후, 택배기사님께 전달 부탁 드립니다.<br /> <strong class="txtBtwDk">고객변심</strong>에 의한 상품 교환인 경우 반품입고가 확인된 이후에, 불량상품 교환의 경우 즉시 출고상품이 배송됩니다.<br /> 접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.</li>
					<li><strong class="txtBlk">추가택배비 안내 (착불반송시)</strong><br /> 고객변심 교환 : 왕복배송비 / 상품불량 교환 : 추가배송비 없음</li>
				</ul>
			</div>
			<!-- //회수안내 -->

			<!-- 반품안내 -->
			<div class="hWrap hrBtw">
				<h2 class="headingB">반품안내</h2>
			</div>
			<div class="section">
				<ul class="txtList01 txtBlk">
					<li>신청하신 상품은 교환접수 후, 해당 업체에 직접 반품해주셔야 교환상품을 받으실 수 있습니다.<br /> 배송박스에 상품이 파손되지 않도록 재포장 하신 후, 아래주소로 발송 부탁드립니다.<br /> 해당 택배사의 대표번호로 전화하신 후, 처음 받으신 택배상자에 붙어있던 운송장번호를 알려주시면 빠른 택배 반품접수가 가능합니다.<br /> 택배접수 시 <strong class="txtBtwDk">착불반송</strong>으로 접수하시면 되며, 접수사유에 따라 추가 배송비를 박스에 넣어서 보내셔야 합니다.</li>
					<li><strong class="txtBlk">추가택배비 안내 (착불반송시)</strong><br /> 고객변심 교환 : 왕복배송비 / 상품불량 교환 : 추가배송비 없음</li>
				</ul>
			</div>
			<!-- //반품안내 -->

			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>택배사 및 판매업체 정보</caption>
				<tbody>
				<tr>
					<th scope="row">배송상품 택배정보</th>
					<td>CJ택배 319930978945</td>
				</tr>
				<tr>
					<th scope="row">택배사 대표번호</th>
					<td>111-1111</td>
				</tr>
				<tr>
					<th scope="row">판매업체명</th>
					<td>㈜텐바이텐</td>
				</tr>
				<tr>
					<th scope="row">판매업체 연락처</th>
					<td>1111-1111</td>
				</tr>
				<tr>
					<th scope="row">반품주소지</th>
					<td>[462-122] 서울 종로구 동숭동 000번지 자유빌딩 6층</td>
				</tr>
				</tbody>
				</table>
			</div>

			<div class="btnArea">
				<span class="btn02 cnclGry btnBig full"><a href="">목록으로 돌아가기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
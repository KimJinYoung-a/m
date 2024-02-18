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
				<li class="order01"><a href="">주문상품</a></li>
				<li class="order02"><a href="">구매자</a></li>
				<li class="order03 current"><a href="">결제</a></li>
				<li class="order04"><a href="">배송지</a></li>
			</ul>

			<!-- 결제 -->
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
			<!-- //결제 -->

			<div class="btnArea">
				<span class="btn02 cnclGry btnBig full"><a href="">목록으로 돌아가기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
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
				<li class="order03"><a href="">결제</a></li>
				<li class="order04 current"><a href="">배송지</a></li>
			</ul>

			<!-- 배송지 -->
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>배송지 정보</caption>
				<tbody>
				<tr>
					<th scope="row">받으시는 분</th>
					<td><strong>정텐텐</strong></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><strong>010-0000-1010</strong></td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td><strong>02-1010-1010</strong></td>
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
			<!-- //배송지 -->

			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="">배송지 변경 신청</a></span>
				<span class="btn02 cnclGry btnBig full"><a href="">목록으로 돌아가기</a></span>
			</div>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
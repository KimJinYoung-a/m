<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- 주문/배송조회 -->
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문/배송조회</h1>
			</div>

			<div class="orderDelivery">
				<!-- for dev msg : 주문내역이 없을 경우 -->
				<!--div class="noData orderNoData">
					<p>
						<strong>주문내역이 없습니다.</strong>
						더 다양한 상품을 만나보세요 :)
					</p>

					<div class="btnArea">
						<span class="btn02 btw btnBig"><a href="#">비트윈 추천 보러가기</a></span>
					</div>
				</div-->
				<!-- //for dev msg : 주문내역이 없을 경우 -->

				<ul class="refundGuide">
					<li><strong class="txtBtwDk">상품교환 및 반품/환불</strong>을 하고자 하시는 경우, 텐바이텐 고객행복센터(<a href="tel:16446030" class="txtBlk">1644-6030</a>)로 문의 주시기 바랍니다.</li>
					<li><strong class="txtBtwDk">주문제작상품의 특성상 제작이 들어간 경우, 주문 취소 및 반품/환불이 불가능 할 수 있습니다.</strong></li>
				</ul>

				<ul class="myOdrList">
					<li>
						<div class="odrInfo">
							<a href="">
								<p class="date">2014-02-02</p>
								<p>
									주문번호 <strong class="odrNum">000000</strong>
									<span class="bar">|</span>
									<strong class="txtBlk">주문접수</strong><!-- for dev msg : 주문접수,결제완료의 경우 클래스 txtBlk / 주문통보,상품준비중,일부출고,출고완료의 경우 클래스 txtSaleRed -->
								</p>
								<p class="pdtName">상품명 상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명... 외 <strong class="txtBlk">2</strong>건</p>
								<p class="price">131,900원</p>
							</a>
						</div>
						<div class="btnCont">
							<span class="btn02 cnclGry"><a href="">주문취소</a></span>
							<span class="btn02 cnclGry"><a href="">배송지변경</a></span>
						</div>
					</li>
					<li>
						<div class="odrInfo">
							<a href="">
								<p class="date">2014-02-02</p>
								<p>
									주문번호 <strong class="odrNum">000000</strong>
									<span class="bar">|</span>
									<strong class="txtBlk">결제완료</strong>
								</p>
								<p class="pdtName">상품명 상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명... 외 <strong class="txtBlk">2</strong>건</p>
								<p class="price">131,900원</p>
							</a>
						</div>
						<div class="btnCont">
							<span class="btn02 cnclGry"><a href="">주문취소</a></span>
							<span class="btn02 cnclGry"><a href="">배송지변경</a></span>
						</div>
					</li>
					<li>
						<div class="odrInfo">
							<a href="">
								<p class="date">2014-02-02</p>
								<p>
									주문번호 <strong class="odrNum">000000</strong>
									<span class="bar">|</span>
									<strong class="txtSaleRed">주문통보</strong>
								</p>
								<p class="pdtName">상품명 상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명... 외 <strong class="txtBlk">2</strong>건</p>
								<p class="price">131,900원</p>
							</a>
						</div>
						<div class="btnCont">
							<span class="btn02 cnclGry"><a href="">주문취소</a></span>
							<span class="btn02 cnclGry"><a href="">배송지변경</a></span>
						</div>
					</li>
					<li>
						<div class="odrInfo">
							<a href="">
								<p class="date">2014-02-02</p>
								<p>
									주문번호 <strong class="odrNum">000000</strong>
									<span class="bar">|</span>
									<strong class="txtSaleRed">상품준비중</strong>
								</p>
								<p class="pdtName">상품명 상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명... 외 <strong class="txtBlk">2</strong>건</p>
								<p class="price">131,900원</p>
							</a>
						</div>
						<div class="btnCont">
							<span class="btn02 cnclGry"><a href="">주문취소</a></span>
							<span class="btn02 cnclGry"><a href="">배송지변경</a></span>
						</div>
					</li>
					<li>
						<div class="odrInfo">
							<a href="">
								<p class="date">2014-02-02</p>
								<p>
									주문번호 <strong class="odrNum">000000</strong>
									<span class="bar">|</span>
									<strong class="txtSaleRed">출고완료</strong>
								</p>
								<p class="pdtName">상품명 상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명... 외 <strong class="txtBlk">2</strong>건</p>
								<p class="price">131,900원</p>
							</a>
						</div>
						<div class="btnCont">
							<span class="btn02 cnclGry"><a href="">주문취소</a></span>
							<span class="btn02 cnclGry"><a href="">배송지변경</a></span>
						</div>
					</li>
				</ul>

				<div class="listAddBtn">
					<a href="">더 보기</a>
				</div>
			</div>
			<!--// 주문/배송조회 -->
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
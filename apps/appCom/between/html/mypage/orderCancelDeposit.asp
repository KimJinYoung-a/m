<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">주문취소 <span>(무통장 결제  후 주문취소)</span></h1>
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

			<form action="">
			<fieldset>
				<div class="section">
					<table class="tableType tableTypeC" style="margin-top:20px;">
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
					</table>
				</div>

				<div class="section">
					<ul class="txtList03 txtBlk">
						<li><strong class="txtBtwDk">계좌번호 등록 시에는 대시(-)를 제외한 숫자만 입력</strong></li>
						<li>계좌번호 및 예금주명이 정화하지 않으면 입금이 지연될 수 있음</li>
						<li>접수 후 1,2일 이내(영업일 기준) 등록하신 계좌(마일리지)로 환불되며, 문자메시지로 안내</li>
					</ul>
				</div>

				<div class="btnArea">
					<span class="btn02 btw btnBig full"><a href="">주문 전체 취소</a></span>
				</div>
			</fieldset>
			</form>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
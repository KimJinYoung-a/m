<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">운송장 등록</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 000000000000]</strong>
				</div>
			</div>

			<div class="section">
				<p>반품하신 택배의 운송장 번호를 등록해 주세요.</p>
			</div>

			<form action="">
			<fieldset>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>운송장 등록</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="deliveryCompany">택배사</label></th>
						<td>
							<select id="deliveryCompany">
								<option>CJ택배</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="invoiceNumber">운송장번호</label></th>
						<td>
							<input type="text" id="invoiceNumber" name="" />
						</td>
					</tr>
					</tbody>
					</table>
				</div>

				<div class="btnArea">
					<div class="half"><button type="button" class="btn02 cnclGry btnBig"><span>취소</span></button></div>
					<div class="half"><input type="submit" value="등록" class="btn02 btw btnBig" /></div>
				</div>
			</fieldset>
			</form>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
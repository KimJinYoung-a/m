<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
</head>
<body>
<div class="wrapper" id="btwMypage"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">배송지정보 변경</h1>
				<div class="option">
					<strong class="orderNo">[주문번호 000000000000]</strong>
				</div>
			</div>

			<form action="">
			<fieldset>
				<div class="section">
					<table class="tableType tableTypeC">
					<caption>배송지 정보입력</caption>
					<tbody>
					<tr>
						<th scope="row"><label for="recipient">받으시는 분</label></th>
						<td>
							<input type="text" id="recipient" name="" />
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td>
							<div class="address">
								<div class="row zipcodeField">
									<div class="cell">
										<span class="zipcodeFront"><input type="text" title="우편번호 앞자리" name="" /></span>
										<span class="symbol">-</span>
										<span class="zipcodeBack"><input type="text" title="우편번호 뒷자리" name="" /></span>
									</div>
									<div class="optional">
										<span class="btn02 btw"><a href="">우편번호 찾기</a></span>
									</div>
								</div>
								<div class="basics"><input type="text" title="기본주소" name="" /></div>
								<div class="detailed"><input type="text" title="상세주소" name="" /></div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
							<input type="text" title="휴대전화 앞자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 가운데자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="휴대전화 뒷자리" name="" style="width:23%;" />
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td>
							<input type="text" title="전화번호 앞자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="전화번호 가운데자리" name="" style="width:23%;" />
							<span class="symbol">-</span>
							<input type="text" title="전화번호 뒷자리" name="" style="width:23%;" />
						</td>
					</tr>
					<tr>
						<th scope="row">배송시 유의사항</th>
						<td>
							<div class="row deliveryField">
								<div class="cell">
									<select title="배송시 유의사항 메시지 선택">
										<option>선택</option>
										<option>부재 시 경비실에 맡겨주세요</option>
										<option>핸드폰으로 연락바랍니다</option>
										<option>배송 전 연락바랍니다</option>
										<option>직접입력</option>
									</select>
								</div>
								<div class="optional">
									<input type="text" title="배송시 유의사항" name="" />
								</div>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>

				<div class="btnArea">
					<input type="submit" value="수정" class="btn02 btw btnBig full" />
			</fieldset>
			</form>

		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
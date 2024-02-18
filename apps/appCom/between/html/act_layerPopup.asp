<%
	Select Case Request("div")
		Case "p1"
%>
	<!-- 최초방문시 약관 미동의시 팝업 -->

		<div class="lyrPop clauseAgree">
			<div class="lyrPopCont">
				<h1>주의</h1>
				<div>
					<p>약관 및 주의사항에 동의해주세요.<br />동의에 체크하지 않으면 결제할수 없습니다.</p>
				</div>
			</div>
			<div class="btnWrap">
				<p class="btn01 btnOk"><a href="" onclick="jsClosePopup();return false;" class="btw">확인</a></p>
			</div>
			<span class="lyrClose">&times;</span>
		</div>
		<div class="dimmed"></div>

	<!-- //최초방문시 약관 미동의시 팝업 -->
<%
		Case "p2"
%>
	<!-- 주문 확인 -->
		<div class="lyrPop orderCheck">
			<div class="lyrPopCont">
				<h1>제목</h1>
				<div>
					<p>선택된 상품이 없습니다.<br />품절상품을 제외한 전상품을 주문하시겠습니까?</p>
				</div>
			</div>
			<div class="btnWrap">
				<p class="btn01 btnCancel"><a href="" onclick="jsClosePopup();return false;" class="cnclGry">취소</a></p>
				<p class="btn01 btnOk"><a href="" class="btw" onclick="jsClosePopup();return false;">확인</a></p>
			</div>
			<span class="lyrClose">&times;</span>
		</div>
		<div class="dimmed"></div>
	<!-- //주문 확인 -->
<%
		Case "p3"
%>
	<!-- 우편번호 찾기 -->
		<div class="lyrPop">
			<div class="lyrPopCont zipCode" dd="a">
				<h1>우편번호 찾기</h1>
				<ul class="tabZipcode">
					<li><a href="" class="current">도로명 검색</a></li>
					<li><a href="">지번 검색</a></li>
				</ul>
					<form action="">
					<fieldset>
						<div class="finderZipcode">
							<p>
								찾고자 하는 주소의 도로명을 입력하세요.<br />
								<span class="txtCnclGry">(예: 동숭1길, 세종대로)</span>
							</p>
							<!-- for dev msg : 지번 검색일 경우 메시지 -->
							<!--p>
								찾고자 하는 주소의 동/읍/면 이름을 입력하세요.<br />
								<span class="txtCnclGry">(예: 대치동, 곡성읍, 오곡면)</span>
							</p-->
							<!-- //for dev msg : 지번 검색일 경우 메시지 -->
							<div class="field">
								<input type="text" title="" /><input type="submit" value="검색" class="btn02 btw" />
							</div>
						</div>
					</fieldset>

					<!-- 우편번호 검색 결과 목록 -->
					<div class="zipecodeList">
						<p>아래 검색결과 중 해당하는 주소를 선택하세요.</p>

						<div class="thead">
							<strong>우편번호</strong> <strong>도로명주소</strong>
						</div>
						<div class="scrollerWrap">
							<div id="scroller">
								<div class="scroll">
									<ul>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 일원동 광평로</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 일원동 1</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 270</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 수서동 광평로 로즈데일오피스텔 280</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 111</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 22</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 수서동 광평로 270</span></a></li>
									</ul>
								</div>
							</div>
							<!-- for dev msg : 검색 결과가 없을 경우 <div id="scrollerWrap" style="height:auto;">...</div> 추가해주세요. <div id="scroller">...</div> 마크업은 제거 되어야합니다.  -->
							<!--p class="noResult">검색 결과가 없습니다.</p-->
							<!-- //for dev msg : 검색 결과가 없을 경우 -->
						</div>
					</div>
					<!-- //우편번호 검색 결과 목록 -->

					<!-- 상세 주소 -->
					<!--fieldset>
						<div class="detailedAddress">
							<p>상세 주소를 정확히 입력해 주세요!</p>
							<table class="tableType tableTypeC">
							<caption>상세 주소 입력</caption>
							<tbody>
							<tr>
								<th scope="row">상세주소</th>
								<td>
									<div class="address">
										<div class="row zipcodeField">
											<div class="cell">
												<span class="zipcodeFront"><input type="text" title="우편번호 앞자리" name="" /></span>
												<span class="symbol">-</span>
												<span class="zipcodeBack"><input type="text" title="우편번호 뒷자리" name="" /></span>
											</div>
										</div>
										<div class="basics"><input type="text" title="기본주소" name="" /></div>
										<div class="detailed"><input type="text" title="상세주소" name="" /></div>
									</div>
								</td>
							</tr>
							</tbody>
							</table>
							<div class="btnWrap">
								<button type="button" class="btn02 cnclGry btnBig" onclick="jsClosePopup();return false;"><span>취소</span></button>
								<input type="submit" value="확인" class="btn02 btw btnBig" />
							</div>
						</div>
				</fieldset-->
				<!-- //상세 주소 -->
				</form>
			</div>
			<span class="lyrClose">&times;</span>
		</div>
		<div class="dimmed"></div>
	<!-- //우편번호 찾기 -->
<%
	End Select
%>
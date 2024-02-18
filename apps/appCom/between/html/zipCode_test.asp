<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript">
var myScroll;
function loaded() {
	myScroll = new iScroll('zipecodeList');
}
document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);
</script>
</head>
<body>
<div class="wrapper" id="btwCtgy"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<p>컨텐츠 영역</p>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->

	<!-- 최초방문시 약관 미동의시 팝업 -->
	<div class="lyrPopWrap boxMdl midLyr">
		<div class="lyrPop">
			<div class="lyrPopCont zipCode">
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
						<table class="scroll">
						<caption>우편번호 목록</caption>
						<thead>
						<tr>
							<th scope="col">우편번호</th>
							<th scope="col">도로명주소</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td colspan="2" id="zipecodeList">
								<div>
									<ul>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 일원동 광평로</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 일원동 광평로</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 수서동 광평로 270</span></a></li>
										<li><a href=""><span>135-230</span> <span>서울특별시 강남구 수서동 광평로 로즈데일오피스텔 280</span></a></li>
									</ul>
								</div>
							</td>
						</tr>
						</tbody>
						</table>
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
								<button type="button" class="btn02 cnclGry btnBig"><span>취소</span></button>
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
	</div>
	<!-- //최초방문시 약관 미동의시 팝업 -->
</div>
</body>
</html>
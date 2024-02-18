<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>우편번호 찾기</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 우편번호 찾기 -->
			<div class="inner5 tMar15 bMar20">
				<div class="tab01">
					<ul class="tabNav tNum2">
						<li class="current"><a href="#zipcode01">지번검색<span></span></a></li>
						<li><a href="#zipcode02">도로명검색<span></span></a></li>
					</ul>
					<div class="tabContainer box1">
						<!-- 지번검색 -->
						<div id="zipcode01" class="tabContent">
							<div class="zipcodeFind">
								<p class="lpad05"><strong>찾고 싶은 동(읍,리,면,가)를 입력해주세요.</strong></p>
								<div class="overHidden tMar15">
									<p class="ftLt w70p"><input type="text" class="w100p" placeholder="예) 대치동, 곡성읍, 오곡면" /></p>
									<p class="ftLt w30p lPad05"><span class="button btB2 btRed cWh1 w100p"><input type="submit" value="검색" /></span></p>
								</div>
							</div>
							<ul class="zipcodeList">
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로</p></li>
								<li class="on">
									<p class="addr"><span>150-050</span>서울 영등포구 목감로 1길</p>
									<!-- 상세주소입력 -->
									<div class="box2">
										<p class="ftLt w80p"><input type="text" class="w100p" placeholder="상세주소를 입력해주세요" /></p>
										<p class="ftLt w20p lPad05"><span class="button btM1 btGry3 cWh1 w100p"><input type="submit" value="입력" /></span></p>
									</div>
								</li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 2길 서울 영등포구 목감로 2길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 3길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 4길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 5길</p></li>
							</ul>
						</div>
						<!--// 지번검색 -->

						<!-- 도로명검색 -->
						<div id="zipcode02" class="tabContent">
							<div class="zipcodeFind">
								<p class="lpad05"><strong>찾고 싶은 주소의 도로명을 입력하세요.</strong></p>
								<div class="overHidden tMar15">
									<p class="ftLt w70p"><input type="text" class="w100p " placeholder="예) 동숭1길, 세종대로" /></p>
									<p class="ftLt w30p lPad05"><span class="button btB2 btRed cWh1 w100p"><a href="#">검색</a></span></p>
								</div>
							</div>
							<ul class="zipcodeList">
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로</p></li>
								<li class="on">
									<p class="addr"><span>150-050</span>서울 영등포구 목감로 1길</p>
									<!-- 상세주소입력 -->
									<div class="box2">
										<p class="ftLt w80p"><input type="text" class="w100p" placeholder="상세주소를 입력해주세요" /></p>
										<p class="ftLt w20p lPad05"><span class="button btM1 btGry3 cWh1 w100p"><input type="submit" value="입력" /></span></p>
									</div>
								</li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 2길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 3길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 4길</p></li>
								<li><p class="addr"><span>150-050</span>서울 영등포구 목감로 5길</p></li>
							</ul>
						</div>
						<!--// 도로명검색 -->
					</div>
				</div>
			</div>
			<!--// 우편번호 찾기 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
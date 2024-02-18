<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>아이디 / 비밀번호 찾기</h1>
			<p class="btnPopPrev"><a href="#" class="pButton">이전으로</a></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 아이디/비밀번호찾기 -->
			<div class="login inner5">
				<div class="tab01 tMar15">
					<ul class="tabNav tNum2 noMove">
						<li class="current"><a href="#findId">아이디 찾기<span></span></a></li>
						<li><a href="#findPw">비밀번호 찾기<span></span></a></li>
					</ul>
					<div class="tabContainer">
						<!-- 아이디 찾기 -->
						<div id="findId">
							<div class="box1">
								<div class="findType">
									<span><input type="radio" id="fMail" /> <label for="fMail">이메일</label></span>
									<span><input type="radio" id="fPhone" /> <label for="fPhone">휴대폰</label></span>
								</div>
								<div class="loginForm">
									<input type="text" title="이름 입력" placeholder="이름" />
									<input type="email" title="이메일 입력" placeholder="이메일" />
									<!--  휴대폰 선택했을 경우
									<div class="overHidden">
										<p class="ftLt w30p">
											<select title="휴대전화 앞자리 선택">
												<option value="010">010</option>
											</select>
										</p>
										<p class="ftLt w35p lPad05"><input type="tel" class="" /></p>
										<p class="ftLt w35p lPad05"><input type="tel" class="" /></p>
									</div>
									-->
								</div>
								<div class="btnWrap">
									<p class="ftRt"><span class="button btB1 btRed cWh1"><input type="submit" value="확인" /></span></p>
								</div>
							</div>
							<div class="findResult">
								<p class="tip">아이디 조회 결과 입력하신 정보와 일치하는 아이디는 아래와 같습니다. 가입정책 변경으로 신규고객과 인증절차가 이루어지지 않은 기존 고객 아이디가 함께 검색 될 수 있습니다.</p>
								<dl>
									<dt>아이디 확인 (가입일자)</dt>
									<dd>
										<ul>
											<li>77** (2013년 2월 15일)</li>
											<li>Hotbb** (2013년 2월 15일)</li>
											<li>Ideamanl** (2013년 2월 15일)</li>
										</ul>
									</dd>
								</dl>
								<span class="button btB1 btRed w100p"><a href="#">로그인</a></span>
							</div>
						</div>
						<!--// 아이디 찾기 -->

						<!-- 비밀번호 찾기 -->
						<div id="findPw">
							<div class="box1">
								<div class="findType">
									<span><input type="radio" id="fMail2" /> <label for="fMail2">이메일</label></span>
									<span><input type="radio" id="fPhone2" /> <label for="fPhone2">휴대폰</label></span>
								</div>
								<div class="loginForm">
									<input type="text" title="아이디 입력" placeholder="아이디" />
									<input type="text" title="이름 입력" placeholder="이름" />
									<input type="email" title="이메일 입력" placeholder="이메일" />
									<!--  휴대폰 선택했을 경우 -->
									<div class="overHidden">
										<p class="ftLt w30p">
											<select title="휴대전화 앞자리 선택">
												<option value="010">010</option>
											</select>
										</p>
										<p class="ftLt w35p lPad05"><input type="tel" class="" /></p>
										<p class="ftLt w35p lPad05"><input type="tel" class="" /></p>
									</div>
								</div>
								<div class="btnWrap">
									<p class="ftRt"><span class="button btB1 btRed cWh1"><input type="submit" value="확인" /></span></p>
								</div>
							</div>
						</div>
						<!--// 비밀번호 찾기 -->
					</div>
				</div>
			</div>
			<!--// 아이디/비밀번호찾기 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
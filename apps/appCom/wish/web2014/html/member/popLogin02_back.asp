<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>로그인</h1>
			<p class="btnPopClose"><button class="pButton" onclick="window.close();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 로그인 -->
			<div class="login innerH20W5">
				<div class="box1">
					<div class="loginForm">
						<input type="text" title="아이디 입력" placeholder="아이디" />
						<input type="password" title="비밀번호 입력" placeholder="비밀번호" />
					</div>
					<div class="btnWrap">
						<p class="ftLt"><input type="checkbox" id="autoLogin" /> <label for="autoLogin">자동 로그인</label></p>
						<p class="ftRt"><span class="button btB1 btRed w145"><input type="submit" value="로그인" /></span></p>
					</div>
					<div class="joinHelp">
						<a href="">아이디 찾기</a>
						<a href="">비밀번호 찾기</a>
						<a href="">회원가입</a>
					</div>
				</div>
				<div class="nonMemCart">
					<span class="button btB1 btRedBdr w210"><a href="">비회원 장바구니 사용하기</a></span>
					<p>비회원 주문 시 장바구니 저장, 마일리지 적립 등의<br />혜택을 받으실 수 없습니다.</p>
				</div>
			</div>
			<!--// 로그인 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>회원가입</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 회원가입 - 3.본인인증 -->
			<div class="join inner5">
				<div class="joinStep">
					<ol>
						<li class="on"><span>1</span>약관동의</li>
						<li class="on"><span>2</span>정보입력</li>
						<li class="on"><span>3</span>본인인증</li>
						<li><span>4</span>약관동의</li>
					</ol>
				</div>
				<div class="joinCert box1">
					<div class="sendNum">
						<p><strong>인증번호를 발송하였습니다. <span class="cRd1">확인해주세요!</span></strong></p>
						<p class="tMar10">(인증번호 6자리를 입력해주세요)</p> 
					</div>
					<p class="tMar20"><input type="tel" class="ct w50p" value="인증번호 입력" title="인증번호 입력" /> <span class="button btB2 btRed cWh1"><input type="submit" value="확인" /></p>
					<div class="joinHelp">
						<a href="">인증번호 재발송</a>
						<a href="">메일 인증받기</a>
						<a href="">회원가입</a>
					</div>
					<p class="tMar10 fs11 lh12">문자가 스팸으로 분류되어 인증번호가 전달이 안될 경우<br />메일로 인증이 가능합니다.</p>
				</div>
			</div>
			<!--// 회원가입 - 3.본인인증 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
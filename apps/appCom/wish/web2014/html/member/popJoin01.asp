<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<!--
		<div class="header">
			<h1>회원가입</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		-->
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 회원가입 - 1.약관동의 -->
			<div class="inner5">
				<div class="joinStep">
					<ol>
						<li class="on"><span>1</span>약관동의</li>
						<li><span>2</span>정보입력</li>
						<li><span>3</span>본인인증</li>
						<li><span>4</span>약관동의</li>
					</ol>
				</div>
				<div class="chkPolicy box1">
					<p><input type="checkbox" id="agr01" /><label for="agr01"><strong>약관 전체동의</strong></label></p>
					<p><input type="checkbox" id="agr02" /><label for="agr02">본인은 만14세 이상 고객입니다.</label></p>
					<p><input type="checkbox" id="agr03" /><label for="agr03">텐바이텐 이용약관</label> <span class="button btWht btS2 w50"><a href="">약관보기</a></span></p>
					<p><input type="checkbox" id="agr04" /><label for="agr04">개인정보 취급방침</label> <span class="button btWht btS2 w50"><a href="">약관보기</a></span></p>
				</div>
				<p><span class="button btB1 btRed cWh1 w100p"><a href="">다음</a></span></p>
				<div class="joinGuide">
					<p>텐바이텐에서는 현재 2개의 사이트를 운영하고 있습니다.</p>
					<ul>
						<li>회원가입 시 텐바이텐과 핑거스 아카테미 사이트를 동시에 이용하실 수 있습니다.</li>
						<li>회원가입 후 <em class="cRd1">마이텐바이텐 &gt; 개인정보수정</em>을 통해 사이트 사용 여부를 수정하실 수 있습니다.</li>
					</ul>
				</div>
			</div>
			<!--// 회원가입 - 1.약관동의 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
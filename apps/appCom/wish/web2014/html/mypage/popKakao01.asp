<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="mypage">
	<!-- modal#modalKakaoAuth -->
	<div class="modal" id="modalKakaoAuth">
		<div class="box">
			<header class="modal-header">
				<h1 class="modal-title">카카오톡 맞춤 정보 서비스 신청</h1>
				<a href="#modalKakaoAuth" class="btn-close">&times;</a>
			</header>
			<div class="modal-body">
				<div class="red-box">
					<ul class="process kakao clear">
						<li class="active"><span class="label">10X10 회원인증</span></li>
						<li><span class="label">카카오톡 회원인증</span></li>
						<li><span class="label">신청완료</span></li>
					</ul>
				</div>
				<div class="kakao-friend">
					<i class="icon-lock"></i>사용자 인증
				</div>
				<div class="diff"></div>
				<div class="inner">
					<div class="input-block">
						<label for="phone" class="input-label">휴대폰</label>
						<div class="input-controls phone">
							<div><input type="tel" id="phone1" class="form" maxlength="3"></div>
							<div><input type="tel" id="phone2" class="form" maxlength="4"></div>
							<div><input type="tel" id="phone3" class="form" maxlength="4"></div>
						</div>
					</div>
					<em class="em">* 휴대폰 번호를 수정하시면, 개인정보의 휴대폰 번호도 수정됩니다. </em>
				</div>
				<div class="diff"></div>
				<div class="well type-b">
					<h3>
						<label for="agree">
							<input type="checkbox" id="agree" class="form" style="margin-right:10px;">
							개인정보 취급 위탁동의 
						</label>
					</h3>
					<ul class="txt-list" style="margin-left:34px;">
						<li>취급업체 : ㈜ 카카오</li>
						<li>위탁업무 내용 : 사용자 인증 </li>
						<li>공유정보 : 휴대전화번호</li>
						<li>개인정보의 보유 및 이용 기간 : 회원탈퇴 혹은 서비스 해제시까지 </li>
					</ul>
				</div>
			</div>
			<footer class="modal-footer">
				<button class="btn type-a full-size">인증번호 받기</button>
			</footer>
		</div>
	</div>
	<!-- modal#modalKakaoAuth -->
</body>
</html>
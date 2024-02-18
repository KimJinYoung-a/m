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
						<li><span class="label">10X10 회원인증</span></li>
						<li class="active"><span class="label">카카오톡 회원인증</span></li>
						<li><span class="label">신청완료</span></li>
					</ul>
				</div>
				<div class="kakao-friend">
					<i class="icon-lock"></i>사용자 인증
				</div>
				<div class="diff"></div>
				<div class="inner">
					<p>카카오톡으로 받으신 인증번호를 입력하신 후, 인증번호 확인을 눌러주세요. </p>
					<div class="diff-10"></div>
					<div class="input-block">
						<label for="authCode" class="input-label">인증번호 입력</label>
						<div class="input-controls">
							<input type="tel" id="authCode" class="form full-size">
						</div>
					</div>
					<em class="em">* 인증을 완료하시면, 카카오톡 플러스 친구에 텐바이텐이 자동 추가됩니다. </em>
				
				</div>
				<div class="diff"></div>
				<div class="well type-b">
					<h3>
						<label for="agree">
							<input type="checkbox" id="agree" class="form" style="margin-right:10px;">
							맞춤정보 수신동의
						</label>
					</h3>
					<p class="x-small" style="margin-left:34px;">
						카카오톡으로 텐바이텐의 맞춤정보를 수신하겠습니다.<br>본 서비스를 신청하시면 텐바이텐 주문 및 배송관련 메시지와 다양한 혜택/이벤트 정보가 카카오톡으로 발송됩니다.
					</p>
				</div>
			</div>
			<footer class="modal-footer">
				<div class="two-btns">
					<div class="col"><button class="btn type-b full-size">인증번호 확인</button></div>
					<div class="col"><button class="btn type-a full-size">인증번호 재전송</button></div>
				</div>
			</footer>
		</div>
	</div>
	<!-- modal#modalKakaoAuth -->
</body>
</html>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="mypage">
	<!-- modal#modalKakaoCancel -->
	<div class="modal" id="modalKakaoCancel">
		<div class="box">
			<header class="modal-header">
				<h1 class="modal-title">카카오톡 서비스 해제</h1>
				<a href="#modalKakaoCancel" class="btn-close">&times;</a>
			</header>
			<div class="modal-body">
				<div class="kakao-friend">
					<i class="icon-lock"></i>사용자 인증
				</div>
				<div class="diff"></div>
				<div class="inner">
					<p class="t-c">
						카카오톡 맞춤정보 서비스를 해제합니다.<br>서비스를 해제하시면, <br>카카오톡 맞춤정보 서비스를 받을 수 없게 됩니다.<br> 단, 서비스 해제시에도 상품 주문 및 배송 관련 정보는 <br>정보수신 동의와 별도로 SMS 로 자동 발송됩니다. 
						<br><br>
						* 서비스 해제할 휴대폰 번호는 아래와 같습니다. <br>
						<strong class="red" style="font-size:12px;margin-top:5px; display:block;">010 - 1111 - 2345</strong>
					</p>
				</div>
			</div>
			<footer class="modal-footer">
				<button class="btn type-b full-size">서비스 해제</button>
			</footer>
		</div>
	</div>
	<!-- modal#modalKakaoCancel -->
</body>
</html>
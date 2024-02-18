<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="mypage">
	<!-- modal#resendAuthcode  -->
	<div class="modal popup" id="resendAuthcode">
		<div class="box" style="top:50%;margin-top:-160px;">
			<header class="modal-header">
				<h1 class="modal-title">인증번호 재발송</h1>
				<a href="#resendAuthcode" class="btn-close">&times;</a>
			</header>
			<div class="modal-body">
				<div class="inner">
					<div class="t-c inner">
						<div class="number bordered-title inline">010-1111-2222</div>
						<p>위 번호로 SMS를 이용해 인증번호를  재발송 하였습니다.<br>꼭 확인해 주세요. </p>
					</div>
					<form action="">
						<div class="input-block no-label">
							<label class="input-label" for="authCode">인증번호</label>
							<div class="input-controls">
								<input type="text" class="form full-size" id="authCode">
								<button class="btn type-b side-btn">인증번호확인</button>
							</div>
						</div>
						<em class="em red">* 인증번호 6자리를 입력해주세요.</em>
					</form>
				</div>
			</div>
			<footer class="modal-footer">
				<small>
					* 인증번호가 계속 도착하지 않는다면 스팸문자함 또는 차단 설정을 확인하여 주세요. 
				</small>
			</footer>
		</div>
	</div>
	<!-- modal#resendAuthcode  -->
</body>
</html>
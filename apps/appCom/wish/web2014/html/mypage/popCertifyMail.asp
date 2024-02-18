<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="mypage">
	<!-- modal#authByEmail  -->
	<div class="modal popup" id="authByEmail">
		<div class="box" style="top:50%;margin-top:-160px;">
			<header class="modal-header">
				<h1 class="modal-title">인증번호 재발송</h1>
				<a href="#authByEmail" class="btn-close">&times;</a>
			</header>
			<div class="modal-body">
				<div class="inner">
					<div class="t-c inner">
						<div class="number bordered-title inline">tenbyten@naver.com</div>
						<p>위 메일로 인증 메일을 발송 하였습니다. <br>12시간 안에 꼭 확인해 주세요.<br>가입승인 시간 내에 승인을 하지 않으면, 인증이 취소됩니다.</p>
					</div>
				</div>
			</div>
			<footer class="modal-footer">
				<button onclick="resendEmail();" class="btn type-a full-size">가입승인 메일 재발송</button>
				<p class="t-c">
					<small>
						인증메일이 도착하지 않았을 경우 <strong>“가입승인 메일 재발송“</strong> 버튼을 클릭하시면 다시 메일을 받으실 수 있습니다. 
					</small>
				</p>
			</footer>
		</div>
	</div>
	<!-- modal#authByEmail  -->
</body>
</html>
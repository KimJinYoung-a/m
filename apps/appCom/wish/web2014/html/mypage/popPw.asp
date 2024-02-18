<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body class="mypage">

	<!-- modal#modalReaffirmationPassword  -->
	<div class="modal popup" id="modalReaffirmationPassword">
		<div class="box" style="top:50%;margin-top:-120px;">
			<header class="modal-header">
				<h1 class="modal-title">비밀번호 재확인</h1>
				<a href="#modalReaffirmationPassword" class="btn-close">&times;</a>
			</header>
			<div class="modal-body">
				<div class="inner">
					<p class="t-c">정보를 수정하시려면 <strong>현재 비밀번호</strong>를<br>다시 한번 입력하시기 바랍니다. </p>
					<div class="diff-10"></div>
					<div class="input-block">
						<label for="pwd" class="input-label">비밀번호</label>
						<div class="input-controls">
							<input type="password" name="pwd" id="pwd" class="form full-size">
						</div>
					</div>
					<div class="diff-10"></div>
				</div>
			</div>
			<footer class="modal-footer t-c">
				<button class="btn type-a full-size">확인</button>
			</footer>
		</div>
	</div><!-- modal#modalReaffirmationPassword  -->

</body>
</html>
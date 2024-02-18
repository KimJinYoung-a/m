<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- wrapper -->
			<div class="wrapper myinfo">
					<!-- #header -->
					<header id="header">
							<div class="tabs type-c">
									<a href="" class="active">나의 정보 관리</a>
									<a href="">비밀번호 변경</a>
							</div>
					</header><!-- #header -->
					<!-- #content -->
					<div id="content">
						<div class="inner">
							<div class="well">회원님의 정보를 안전하게 보호하기 위해 비밀번호를 다시한번 확인합니다.</div>
							<div class="input-block">
								<label for="userid" class="input-label">아이디</label>
								<div class="input-controls">
									<input type="text" name="userid" id="userid" value="" class="form full-size" />
								</div>
							</div>
							<div class="input-block">
								<label for="pwd" class="input-label">비밀번호</label>
								<div class="input-controls">
									<input type="password"class="form full-size" />
								</div>
							</div>
							<em id="lyrFailPass" class="em red">*비밀번호 오류입니다. 비밀번호를 다시 입력해주세요</em>
						</div>
						<div class="form-actions">
							<button onclick="#" class="btn type-b full-size">LOGIN</button>
						</div>
					</div><!-- #content -->

					<!-- #footer -->
					<footer id="footer">

					</footer><!-- #footer -->
			</div>
			<!-- wrapper -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
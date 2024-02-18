<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!-- wrapper -->
			<div class="wrapper myinfo">
					<!-- #header -->
					<header id="header">
							<div class="tabs type-c">
									<a href="">나의 정보 관리</a>
									<a href="" class="active">비밀번호 변경</a>
							</div>
					</header><!-- #header -->
					<!-- #content -->
					<div id="content">
						<form action="">
						<div class="inner">
							
							<div class="main-title">
								<h1 class="title"><span class="label">비밀번호 수정</span></h1>
							</div>
							<div class="input-block">
								<label for="pwd" class="input-label">현재 비밀번호</label>
								<div class="input-controls">
									<input type="password" id="pwd" value="" class="form full-size">
								</div>
							</div>
							<div class="input-block">
								<label for="newPwd" class="input-label">신규 비밀번호</label>
								<div class="input-controls">
									<input type="password" id="newPwd" value="" class="form full-size">
								</div>
							</div>
							<div class="input-block">
								<label for="rePwd" class="input-label">비밀번호 재확인</label>
								<div class="input-controls">
									<input type="password" id="rePwd" value="" class="form full-size">
								</div>
							</div>
							<em class="em red">* 영문/숫자 조합 6~16자 이내 가능합니다.</em>
						</div>
						<div class="form-actions highlight">
							<button class="btn type-a full-size">비밀번호 변경</button>
						</div>
						</form>
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
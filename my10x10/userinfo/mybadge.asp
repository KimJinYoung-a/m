<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="/my10x10/userinfo/mygrade.asp">나의 등급</a></li>
				<li><a href="/my10x10/userinfo/mybadge.asp" class="on">나의 뱃지</a></li>
			</ul>
		</div>
		<%' 뱃지 가저오기 %>
		<!-- #include virtual="/my10x10/userinfo/inc_mybadge.asp" -->
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
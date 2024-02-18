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
	<!-- contents -->
	<div id="content" class="content">
		<div class="about-badge">
			<h2>뱃지란 무엇인가요?</h2>
			<p>쇼핑 활동 중 특정 조건에 도달할 경우, 뱃지를 획득하실 수 있습니다. 획득한 뱃지는 상품후기, 기프트톡과 같은 사용자가 작성한 게시물에 부착되어 타인에게 신뢰를 주는 역할을 하게 됩니다.</p>
		</div>
		<%' 뱃지 리스트 %>
		<!-- #include virtual="/my10x10/userinfo/inc_badgelist.asp" -->
	</div>
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
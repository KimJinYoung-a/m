<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
function jsChgurl(v){
	location.replace(v);
}
</script>
</head>
<body class="default-font body-sub">
	<div id="content" class="content">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="" onclick="jsChgurl('/apps/appcom/wish/web2014/my10x10/userinfo/mygrade.asp');return false;">나의 등급</a></li>
				<li><a href="" onclick="jsChgurl('/apps/appcom/wish/web2014/my10x10/userinfo/mybadge.asp');return false;" class="on">나의 뱃지</a></li>
			</ul>
		</div>
		<%' 뱃지 가저오기 %>
		<!-- #include virtual="/my10x10/userinfo/inc_mybadge.asp" -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
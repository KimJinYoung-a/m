<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : app 다운로드(쿠폰이벤트)
' History : 2014.07.01 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 텐바이텐 모바일앱 출시!</title>
<script>
	function jsevtlogin(){
		if(confirm("로그인 후에 응모하실 수 있습니다.")) {
			self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		}
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<iframe id="evt_50401" src="/event/etc/iframe_50401.asp?ref=<%=request("ref")%>" width="100%" height="1000" frameborder="0" scrolling="no" class="autoheight"></iframe>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
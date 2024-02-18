<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
	alert("탈퇴가 완료되었습니다.");
	setTimeout(function(){
		fnAPPLogout();
		//fnAPPopenerJsCallClose('jsGoHome()');
	}, 1500);
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="withdrawDone">
				<p><strong><span class="cRd1">탈퇴</span>가 완료되었습니다.</strong></p>
				<p>하지만 언젠가는 꼭 다시 만나고 싶습니다.</p>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
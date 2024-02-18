<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 개인정보처리방침
' History : 2021.03.03 임보라 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
strHeadTitleName = "개인정보처리방침"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>텐바이텐 개인정보처리방침</title>
<style>
.tenten-footer {display:block; padding-bottom:4.6rem;}
</style>
<script>
$(function() {
	$('.policyList li a').on('click', function(e) {
		e.preventDefault();
		$('html, body').animate({scrollTop: $(this.hash).offset().top - $("#header").outerHeight()}, 0);
	});
});
</script>
</head>
<body class="default-font">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="inner5">
			<h2 class="tit01 tMar20">개인정보처리방침</h2>
			<!-- #include virtual="/common/private_external.asp" -->
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 2019 다꾸페이지
' History : 2018-10-23 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2019.css?v=1.04" />
<script type="text/javascript">
$(function() {
	var daccuRolling = new Swiper(".daccu-rolling .swiper-container", {
		slidesPerView:'auto',
		speed:600
	});

    fnAmplitudeEventMultiPropertiesAction('view_diary_daccu','','');		
});
</script>
</head>
<body class="default-font body-sub diary2019">
	<div id="content" class="content daccu">
		<%'다꾸컨텐츠%>
		<!-- #include virtual="/diarystory2019/sub/daccu.asp" -->
	</div>
	<!-- #include virtual="/apps/appcom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
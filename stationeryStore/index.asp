<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐텐문방구
' History : 2019.06.12 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/moonbanggu.css?v=1.02" />
<script type="text/javascript">
$(function() {
	//map move
	$(".items-wrap .nav a").click(function(e){
		$('html,body').animate({'scrollTop': $(this.hash).offset().top-75});
			e.preventDefault();
	});
});
</script>
</head>

<body class="default-font body-main moonbanggu">
<!-- #include virtual="/lib/inc/incHeader.asp" -->	 
<%
    server.Execute("/stationeryStore/main_exec.asp")
%>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'####################################################
' Description : tenfluencer / MW
' History : 2019-02-21 이종화
'####################################################
dim gnbflag 
gnbflag = RequestCheckVar(request("gnbflag"),1)
%>
<title>10x10 : tenfluencer</title>
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<script>
	var isapp = "<%=isapp%>"
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag = "1","main","sub")%> plfV19">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div id="app" v-cloak></div>
	</div>
<!-- #include virtual="/lib/inc/incFooter.asp" -->
<div id="userid" rel="<%=getloginuserid%>" style="display:none;"></div>	
<%' vue.js %>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="/vue/media/tenfluencer/common/clap/clap-icon.js?v=1.00"></script>		
<script src="/vue/media/tenfluencer/list/swipe-list.js?v=1.00"></script>
<script src="/vue/media/tenfluencer/list/swipe.js?v=1.00"></script>
<script src="/vue/media/tenfluencer/list/non-swipe.js?v=1.00"></script>
<script src="/vue/media/tenfluencer/list/video-list.js?v=1.00"></script>
<script src="/vue/media/tenfluencer/list/clap.js?v=1.00"></script>
<script src="/vue/media/tenfluencer/list/index.js?v=1.00"></script>
<%' vue.js %>
</body>
</html>
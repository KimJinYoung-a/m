<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<%
'####################################################
' Description : 다이어리 스토리 다꾸 티비 / MW
' History : 2019-08-22 이종화
'####################################################
dim gnbflag 
gnbflag = RequestCheckVar(request("gnbflag"),1)
strHeadTitleName = "다이어리 스토리"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.05" />
<script>
var isapp = "<%=isapp%>"

$(function() {
	fnAmplitudeEventMultiPropertiesAction('view_diary_daccutv_list','','');
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag = "1","main","sub")%> diary2020">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content diary-sub">
		<div id="app" v-cloak></div>
        <span id="timer" style="display:hidden"></span>
	</div>
<div id="userid" rel="<%=getloginuserid%>" style="display:none;"></div>	
<%' vue.js %>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="/vue/media/daccutv/common/clap/clap-icon.js?v=1.01"></script>
<script src="/vue/media/daccutv/list/video-list.js?v=1.01"></script>
<script src="/vue/media/daccutv/list/index.js?v=1.01"></script>
<%' vue.js %>
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
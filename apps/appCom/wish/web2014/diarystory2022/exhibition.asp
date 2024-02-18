<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다이어리스토리 2022 기획전 리스트
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
$(function(){
    setTimeout(function(){
        fnAmplitudeEventMultiPropertiesAction('view_diarystory_eventlist','','');
    },2050);
});
</script>
</head>
<body class="default-font body-sub diary2020">
    <% server.Execute("/diarystory2022/inc/event/exec_event.asp") %>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
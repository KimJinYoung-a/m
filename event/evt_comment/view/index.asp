<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  이벤트 코멘트 더보기
' History : 2019-06-07 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->

<body class="default-font">
<!--<body class="default-font body-main">-->   
<!-- #include virtual="/lib/inc/incHeader.asp" -->	 
<%
    server.Execute("/event/evt_comment/view/comment_exec.asp")                   
%>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
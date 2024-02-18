<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  다이어리스토리 2021
' History : 2020-08-19 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
    strHeadTitleName = "다이어리 스토리"
%>
</head>
<body class="default-font body-sub">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->	
    <% server.Execute("/diarystory2021/inc/search/exec_search.asp") %>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
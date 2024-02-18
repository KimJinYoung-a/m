<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  MOWEB 텐플루언서 상세페이지
' History : 2019-05-17 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-sub plfV19">
<!--<body class="default-font body-main">-->
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
<%
    server.Execute("/tenfluencer/detail_exec.asp")
%>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
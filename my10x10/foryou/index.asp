<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  for you
' History : 2019-05-28 최종원 생성
'####################################################
    strHeadTitleName="FOR YOU"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
</head>

<body class="default-font body-sub bg-grey">
<!--<body class="default-font body-main">-->   
<!-- #include virtual="/lib/inc/incHeader.asp" -->	 
<%
    server.Execute("/my10x10/foryou/foryou_exec.asp")    
%>	
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
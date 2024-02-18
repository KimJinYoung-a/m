<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>

</script>
</head>
<body >
    <br>
    2
    <br>
    <br>
    <li align="right"><input type="button" value="Reload" onClick="document.location.reload();"></li>
    <br>
    <br>
    <br>
    <li align="right"><input type="button" value="gogo" onClick="location.href='contest.asp'";></li>
    <br>
    <br>
    <br>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
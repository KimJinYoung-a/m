<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->    
    <%
        server.Execute("/my10x10/giftcard/exec/usageHistory_exec.asp")    
    %>		
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

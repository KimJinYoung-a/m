<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	dim strSql, lp
	dim strAppWVUrl
	IF application("Svr_Info")="Dev" THEN
		strAppWVUrl = "http://testm.10x10.co.kr/apps/appCom/wish/web2014"
	else
		strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/web2014"
	end if

	Dim key
%>
<script>
$(function() {
	
});
</script>
</head>
<body>
<body style="font-size:12px;">
    <div style="padding:20px;">
		<table width="100%" border="1">
		<% For Each key in Request.ServerVariables %>
        <TR>
            <TD><%=key %></TD>
            <TD>
            <% 
                if Request.ServerVariables(key) = "" Then
                    Response.Write " " 
                else 
                    Response.Write Request.ServerVariables(key)
                end if
            %>
            </TD>
        </TR>
        <% Next %>
        </table>
	</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
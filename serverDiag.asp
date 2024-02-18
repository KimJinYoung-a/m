<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%

response.write Request.ServerVariables("LOCAL_ADDR")
response.write Request.ServerVariables("REMOTE_ADDR")


%>

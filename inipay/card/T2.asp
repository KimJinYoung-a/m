
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Response.CharSet="euc-kr"
%>

<%
Dim aaa : aaa=request.Form("aaa")
Dim bbb : bbb=request.Form("bbb")
Dim ccc : ccc=request.Form("ccc")


%>
aaa:<br>
<%= aaa %>
<br>
bbb:<br>
<%= bbb %>
<br>
ccc:<br>
<%= ccc %>


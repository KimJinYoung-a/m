<%@ language="VBScript" %>
<%
  Option Explicit
	
	If Response.Buffer Then
		Response.Clear
		Response.Status = "503 Server Busi"
		Response.ContentType = "text/html"
		
		Response.Expires = 0
	End If
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>텐바이텐 10X10 = 감성채널 감성에너지</title>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="center" valign="middle"><img src="http://fiximage.10x10.co.kr/web2008/main/main_error.jpg" width="696" height="328" /></td>
</tr>
</table>
</body>
</html>
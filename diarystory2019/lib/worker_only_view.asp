<%
	Dim g_LoginUserIP, g_LoginUserID, g_HomeFolder
	g_LoginUserIP = Request.ServerVariables("REMOTE_ADDR")
	g_LoginUserID = Request.Cookies("uinfo")("userid")
	g_HomeFolder  = GetPolderName(1)

	'### 2009년 10월 14일 00시 오픈.
'	'If Now() < #11/16/2009 00:00:00# Then
		If GetLoginUserLevel = "7" Then
		Else
			'If Now() < #10/23/2012 00:30:00# Then
			'	Response.Redirect "/"
			'End IF
		End If
'	'End If 

%>
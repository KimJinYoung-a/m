<%
	Dim g_LoginUserIP, g_LoginUserID, g_HomeFolder
	g_LoginUserIP = Request.ServerVariables("REMOTE_ADDR")
	g_LoginUserID = Request.Cookies("uinfo")("userid")
	g_HomeFolder  = GetPolderName(1)

IF application("Svr_Info") <> "Dev" THEN
	'### 2020년 09월 1일 00시 오픈.
    If GetLoginUserLevel <> "7" Then
        If Now() < #09/01/2020 00:00:00# Then
        	Response.Redirect "/"
        End IF
    End If
end if
%>
<%
	Dim g_LoginUserIP, g_LoginUserID
	g_LoginUserIP = Request.ServerVariables("REMOTE_ADDR")
	g_LoginUserID = Request.Cookies("uinfo")("userid")

	'### 2009�� 10�� 14�� 00�� ����.
'	'If Now() < #11/16/2009 00:00:00# Then
		If GetLoginUserLevel = "7" Then
		Else
			'If Now() < #10/23/2012 00:30:00# Then
			'	Response.Redirect "/"
			'End IF
		End If
'	'End If 

	'# ���� �������� ����
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
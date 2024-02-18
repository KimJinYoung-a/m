<%
    Dim sslCheckUrl : sslCheckUrl = LCase(Request.ServerVariables("URL"))

	If Request.ServerVariables("SERVER_PORT")=80 and (application("Svr_Info")<>"Dev" and application("Svr_Info")<>"staging") And (InStr(sslCheckUrl, "/category/category_itemprd.asp") = 0 AND InStr(sslCheckUrl, "/category/category_itemprd_iframe.asp") = 0) Then
	'If Request.ServerVariables("SERVER_PORT")=80 and (application("Svr_Info")<>"Dev") And (InStr(sslCheckUrl, "/category/category_itemprd.asp") = 0 AND InStr(sslCheckUrl, "/category/category_itemprd_iframe.asp") = 0) Then
		Dim sslCheckStrSecureURL
		sslCheckStrSecureURL = "https://"
		sslCheckStrSecureURL = sslCheckStrSecureURL & Request.ServerVariables("SERVER_NAME")
		sslCheckStrSecureURL = sslCheckStrSecureURL & Request.ServerVariables("URL")
		if Request.ServerVariables("QUERY_STRING")<>"" then
			sslCheckStrSecureURL = sslCheckStrSecureURL & "?" & Request.ServerVariables("QUERY_STRING")
		end if
%>
		<script>
			document.location.replace("<%=sslCheckStrSecureURL%>");
		</script>
<%
		response.End
		'Response.Redirect sslCheckStrSecureURL
	End If
%>
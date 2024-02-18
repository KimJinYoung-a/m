
<%
if (Not IsUserLoginOK) then
	response.write "<script>alert('로그인 후 사용하세요.');</script>"
	response.write "<script>history.back();</script>"
	response.end
end if
%>
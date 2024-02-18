<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, userid , mode , refer
Dim vQuery

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	userid = "guest" '// 비로그인 방식

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  20911
	Else
		eCode   =  59411
	End If

	'// 카운트용 응모
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid ,device) VALUES('" & eCode & "', '" & userid & "' , 'M')"
	dbget.Execute vQuery
	dbget.close() : Response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
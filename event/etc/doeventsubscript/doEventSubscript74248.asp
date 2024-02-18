<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 모바일 -> 앱링크 카운트 
'### 2016-11-09 김진영
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<%
dim sqlstr, refer
Dim ecode
	
	ecode = requestCheckVar(Request("ecode"),10) 

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	sqlstr = "IF EXISTS(SELECT top 1 * FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '"& ecode &"') " & vbCrLf & _
			 "BEGIN " & vbCrLf & _
			 "	update [db_event].[dbo].[tbl_event_subscript] set sub_opt2 = sub_opt2 + 1 where evt_code = '"& ecode &"' " & vbCrLf & _
			 "END " & vbCrLf & _
			 "ELSE " & vbCrLf & _
			 "BEGIN " & vbCrLf & _
			 "	insert into [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2) values ('"& ecode &"' , 'guest' , 1 )  " & vbCrLf & _
			 "END "
	dbget.execute sqlstr
	response.write "OK"
	response.End
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
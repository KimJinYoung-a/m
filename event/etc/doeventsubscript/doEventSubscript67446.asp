<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 가을을 준비하는 올바른 자세
' History : 2015-08-19 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid , refer , addurl
Dim vQuery, vTotalCount , sub_opt2 , device

	sub_opt2 = requestCheckVar(Request("opt"),1)
	userid = GetEncLoginUserID()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  65949
	Else
		eCode   =  67446
	End If

	If isapp = "1" Then
		addurl = "/apps/appcom/wish/web2014"
		device = "A"
	Else 
		device = "M"
	End If 

	If userid = "" Then
		response.write "<script>alert('잘못된 접근입니다.'); parent.location.href='"&addurl&"/event/eventmain.asp?eventid="& eCode &"';</script>"
		dbget.close() : Response.End
	End If
	
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and sub_opt2 = '"& sub_opt2 &"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close

	If vTotalCount > 0 Then
		vQuery = "delete from [db_event].[dbo].[tbl_event_subscript]  WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and sub_opt2 = '"& sub_opt2 &"' "
		dbget.Execute vQuery

		response.write "<script>parent.location.href='"&addurl&"/event/eventmain.asp?eventid="& eCode &"';</script>"
		dbget.close()
		response.end
	Else
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid , sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "' ,'"& sub_opt2 &"' , '"&device&"')"
		dbget.Execute vQuery
		
		response.write "<script>parent.location.href='"&addurl&"/event/eventmain.asp?eventid="& eCode &"';</script>"
		dbget.close()
		response.end
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
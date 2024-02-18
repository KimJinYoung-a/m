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
dim eCode, userid, sqlstr, mode, vLinkECode
mode = requestcheckvar(request("mode"),32)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21272"
		vLinkECode = "21273"
	Else
		eCode = "54424"
		vLinkECode = "54425"
	End If

userid = GetLoginUserID

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim smssubscriptcount
	smssubscriptcount=0
	
	

	Dim vQuery, vTotalCount

	If Now() > #08/31/2014 23:59:59# Then
		response.write "<script language='javascript'>alert('이벤트가 종료되었습니다.'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	End IF

		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close
		If vTotalCount > 0 Then
			response.write "<script language='javascript'>alert('이미 이벤트 응모가 완료되었습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		Else

			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, device) VALUES('" & eCode & "', '" & userid & "', 'm')"
			dbget.Execute vQuery
			
			response.write "<script language='javascript'>alert('응모 완료 되셨습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
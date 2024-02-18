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
dim eCode, com_egCode, bidx,Cidx
dim userid, txtcomm, txtcommURL, mode, spoint, sub_opt3, vEnterOX
vEnterOX = "x"
mode=requestCheckVar(request.Form("mode"),4)
eCode =requestCheckVar(request.Form("eventid"),10)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21068"
	Else
		eCode = "48870"
	End If
	
com_egCode=requestCheckVar(request.Form("com_egC"),10)
bidx = requestCheckVar(request.Form("bidx"),10)
Cidx = requestCheckVar(request.Form("Cidx"),10)
userid = GetLoginUserID
spoint = requestCheckVar(request.Form("spoint"),1)

If isNumeric(request.Form("uphone1")) = False Then
	response.write "<script language='javascript'>alert('폰번호는 숫자로만 입력하세요.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If isNumeric(request.Form("uphone2")) = False Then
	response.write "<script language='javascript'>alert('폰번호는 숫자로만 입력하세요.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

If isNumeric(request.Form("uphone3")) = False Then
	response.write "<script language='javascript'>alert('폰번호는 숫자로만 입력하세요.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

sub_opt3 = requestCheckVar(request.Form("uname"),30) & "||" & requestCheckVar(request.Form("uphone1"),3) & requestCheckVar(request.Form("uphone2"),4) & requestCheckVar(request.Form("uphone3"),4)

IF spoint = "" THEN spoint = 0
IF bidx = "" THEN bidx = 0
IF com_egCode = "" THEN com_egCode = 0
	
If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim referer,refip, returnurl
referer = request.ServerVariables("HTTP_REFERER")
refip = request.ServerVariables("REMOTE_ADDR")
returnurl = requestCheckVar(request.Form("returnurl"),100)

Dim vGubun, vQuery, vCount, vTotalCount
vGubun = requestCheckVar(request.Form("gubun"),1)
vCount = 1

dim sqlStr, returnValue


	vQuery = "SELECT count(sub_idx) From [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' AND Convert(varchar(10),regdate,120) = '" & date() & "'"
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		vEnterOX = "o"
	End IF
	rsget.close
	
	If vEnterOX = "o" Then
		response.write "<script language='javascript'>alert('하루에 1회만 응모 가능합니다.\n내일 다시 응모해 주세요!'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	Else
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3) VALUES('" & eCode & "', '" & userid & "', '" & sub_opt3 & "')"
			dbget.Execute vQuery
			
			response.write "<script language='javascript'>alert('응모 완료하셨습니다.\n당첨자는 2월10일에 발표합니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
	End IF

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
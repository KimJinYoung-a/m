<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, sqlstr, vGubun, refip, refer, vResult, vCount
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	vGubun = requestcheckvar(request("g"),1)
	userid = GetEncLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66123"
	Else
		eCode 		= "70687"
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If
	
	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다.11"
		Response.End
	end If
	
	If vGubun <> "1" AND vGubun <> "2" AND vGubun <> "3" AND vGubun <> "4" AND vGubun <> "5" AND vGubun <> "6" Then
		Response.Write "Err|잘못된 접속입니다.22"
		Response.End
	End If

	vResult = "X"

	'// 응모내역 검색
	sqlstr = ""
	sqlstr = sqlstr & "IF EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = '" & eCode & "' and userid = '" & userid & "' and sub_opt2 = '" & vGubun & "') " & vbCrLf
	sqlstr = sqlstr & "BEGIN " & vbCrLf
	sqlstr = sqlstr & "		SELECT 'D' " & vbCrLf
	sqlstr = sqlstr & "END " & vbCrLf
	sqlstr = sqlstr & "ELSE " & vbCrLf
	sqlstr = sqlstr & "BEGIN " & vbCrLf
	sqlstr = sqlstr & "		SELECT 'I' " & vbCrLf
	sqlstr = sqlstr & "END " & vbCrLf
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

	If Not rsget.Eof Then
		vResult = rsget(0)
	End IF
	rsget.close
	
	If vResult = "D" Then
		sqlstr = "DELETE [db_event].[dbo].[tbl_event_subscript] where evt_code = '" & eCode & "' and userid = '" & userid & "' and sub_opt2 = '" & vGubun & "'"
		dbget.execute sqlstr
	ElseIf vResult = "I" Then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, device) VALUES('" & eCode & "','" & userid & "','" & vGubun & "','M')"
		dbget.execute sqlstr
	End IF
	
	sqlstr = "SELECT COUNT(sub_idx) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and sub_opt2 = '" & vGubun & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	If Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	Response.write "OK|" & vResult & vCount
	dbget.close()	:	response.End

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 듣기 능력 평가
' History : 2015-09-30 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid , mode , refer , snsnum , device , vCount , result1 , snschk
Dim vQuery, vTotalCount , vTotalSum , sub_opt1

	'//device
	If isapp = "1" Then device = "A" Else device = "M" End If 

	sub_opt1 = requestCheckVar(Request("hiddentext"),100)
	snsnum = requestcheckvar(request("snsnum"),10)

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	userid = GetEncLoginUserID()
	mode = requestcheckvar(request("mode"),32)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64902"
	Else
		eCode = "66480"
	End If

	If Now() > #10/10/2015 00:00:00# Then
		response.write "<script>alert('이벤트가 종료되었습니다.'); parent.location.reload();</script>"
		dbget.close()	:	Response.End
	End If

	If userid = "" Then
		response.write "<script>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
		dbget.close()	:	Response.End
	End If
	
	if mode="add" then
		'//응모
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close

		If vTotalCount = 0 Then 
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1 , sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '"& sub_opt1 &"' ,'1' , '"& device &"')"
			dbget.Execute vQuery
			Response.Write "<script>parent.returnlayer();</script>"
			dbget.close()	:	response.end
		ElseIf vTotalCount = 1 Then 
			'//응모내역
			vQuery = "select top 1 sub_opt1 , sub_opt3 "
			vQuery = vQuery & " from db_event.dbo.tbl_event_subscript "
			vQuery = vQuery & " where evt_code='"& eCode &"'"
			vQuery = vQuery & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			If Not rsget.Eof Then
				'//최초 응모
				result1 = rsget(0) '//응모1차 or 2차 응모여부
				snschk = rsget(1) '//2차 응모 확인용 null , ka , fb , tw , ln
			Else
				'//최초응모
				result1 = ""
				snschk = ""
			End IF
			rsget.close

			If result1 = "" and snschk = "" Then '//참여 이력이 없음 - 응모후 이용 하시오
				Response.Write "<script>alert('참여 이력이 없습니다.\n응모후 이용 하세요'); parent.location.reload();</script>"
				dbget.close()	:	response.End
			ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb" or snschk = "ln") Then	'//1회 참여시 
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1 , sub_opt2 , sub_opt3 , device) VALUES('" & eCode & "', '" & userid & "', '"& sub_opt1 &"' , '2' , '"& snschk &"' , '"& device &"')"
				dbget.execute vQuery '// 응모 기회 한번 더줌
				Response.Write "<script>parent.returnlayer();</script>"
				dbget.close()	:	response.End
			ElseIf CStr(result1) <> "" And (snschk = "" Or isnull(snschk) or snschk = "NULL") Then	'//1회 참여시 
				Response.Write "<script>alert('친구에게 이벤트를 알려주고 응모기회 한 번더 받기!\n당첨확률도 2배로 올라갑니다.');parent.location.reload();</script>"
				dbget.close()	:	response.End
			End If
		ElseIf vTotalCount >= 2 Then 
			response.write "<script>alert('오늘은 모든 응모가 완료되었습니다.'); parent.location.reload();</script>"
			dbget.close()	:	response.end
		End If
	ElseIf mode = "snschk" Then
		'//응모내역
		vQuery = "select top 1 sub_opt1 , sub_opt3 "
		vQuery = vQuery & " from db_event.dbo.tbl_event_subscript "
		vQuery = vQuery & " where evt_code='"& eCode &"'"
		vQuery = vQuery & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		If Not rsget.Eof Then
			'//최초 응모
			result1 = rsget(0) '//응모1차 or 2차 응모여부
			snschk = rsget(1) '//2차 응모 확인용 null , ka , fb , tw , ln
		Else
			'//최초응모
			result1 = ""
			snschk = ""
		End IF
		rsget.close

		If result1 = "" and snschk = "" Then '//참여 이력이 없음 - 응모후 이용 하시오
			Response.Write "none"
			dbget.close()	:	response.End
		ElseIf CStr(result1) <> "" And (snschk = "" Or isnull(snschk) or snschk = "NULL") Then	'//1회 참여시 
			vQuery = " update db_event.dbo.tbl_event_subscript set sub_opt3 = '"& snsnum &"'" + vbcrlf
			vQuery = vQuery & " where evt_code="& eCode &" and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 " + vbcrlf
			dbget.execute vQuery '// 응모 기회 한번 더줌

			if snsnum = "tw" then
				Response.write "tw"
			ElseIf snsnum = "fb" Then
				Response.write "fb"
			ElseIf snsnum = "ka" Then
				Response.write "ka"
			ElseIf snsnum = "ln" Then
				Response.write "ln"
			Else
				Response.write "error"
			end if
			dbget.close()	:	response.End
		ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb" or snschk = "ln") Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
			Response.Write "end"
			dbget.close()	:	response.End
		End If
	else
		Response.Write "<script>alert('정상적인 경로가 아닙니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
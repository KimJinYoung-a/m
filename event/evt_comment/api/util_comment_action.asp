<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description : 이벤트 코멘트 액션 페이지
' History : 2019-06-04 최종원
'###########################################################
public function getColName(colParam)
	dim tmpColname
	dim EVTCOM1 : EVTCOM1 = "evtcom_txt"
	dim EVTCOM2 : EVTCOM2 = "evtcom_txt2"
	dim EVTCOM3 : EVTCOM3 = "evtcom_txt3"

	select case colParam
		case "txtcomm" tmpColname = EVTCOM1
		case "txtcomm2" tmpColname = EVTCOM2
		case "txtcomm3" tmpColname = EVTCOM3
		case else tmpColname = ""
	end select	

	getColName = tmpColname
end function

public function chkDuplication(evtCode, colName, val)
	dim result, sqlstr, icnt, tmpColname
	result = false

	tmpColname = getColName(colName)
	if tmpColname = "" then 
		chkDuplication = true
		exit function
	end if

	sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_util_comment] with(nolock) WHERE evt_code="& evtCode &" and evtcom_using = 'Y' and convert(varchar(max), "& tmpColname &") = '"& val &"' "	 

	rsget.Open sqlstr, dbget, 1
	IF Not rsget.EOF THEN
		icnt = rsget("icnt")
	end if
	rsget.close

If icnt >= 1 Then 		
	result = true
Else		
	result = false
End If 
	chkDuplication = result
end function
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
Response.ContentType = "application/json"
dim LoginUserid, refer
dim oJson
'object 초기화
Set oJson = jsObject()

refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

dim eCode, refip, device
dim userid, commidx, txtcomm, txtcomm2, txtcomm3, option1, option2, option3, mode, strSql, commentNum, likeCnt, chkColName

mode=request("mode")
eCode =requestCheckVar(request("eventCode"),10)
txtcomm = request("txtcomm")
txtcomm2 = request("txtcomm2")
txtcomm3 = request("txtcomm3")
option1 = request("option1")
option2 = request("option2")
option3 = request("option3")
commentNum = request("commentNum")
refip = request.ServerVariables("REMOTE_ADDR")
userid = GetLoginUserID
commidx = request("commidx")
likeCnt = request("likeCnt")

'중복체크 관련 데이터
chkColName = request("chkColName")

if isapp > 0 then
	device = "A"
else
	device = "M"
end if
if commentNum = "" then commentNum = 1
'if userid = "cjw0515" then commentNum = 1000

If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
	oJson("response") = "err"
	oJson("message") = "잘못된 접속입니다."
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
End If
if Not(IsUserLoginOK) Then
	oJson("response") = "err"
	oJson("message") = "로그인을 해주세요."
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

dim sqlStr, returnValue
Dim objCmd
Set objCmd = Server.CreateObject("ADODB.COMMAND")

if checkNotValidTxt(txtcomm) then
	oJson("response") = "err"
	oJson("message") = "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End	
end if

'	txtcomm	= html2db(CheckCurse(request("inputCommentData")))
	txtcomm = html2db(txtcomm)
	txtcomm2 = html2db(txtcomm2)
	txtcomm3 = html2db(txtcomm3)

if mode="add" Then '// 1개 등록
	strSql = "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_util_comment with(nolock) " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= Cint(commentNum) Then
		oJson("response") = "err"
		oJson("message") = "이미 등록하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If
	rsget.Close

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_util_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, evtcom_txt2, evtcom_txt3, option1, option2, option3, refip, device) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&txtcomm&"','"&txtcomm2&"','"&txtcomm3&"','"&option1&"','"&option2&"','"&option3&"', '"&refip&"', '"&device&"') "

	dbget.execute strSql

	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="addpday" Then '// 하루 n개 등록
	if chkColName <> "" then
		if chkDuplication(eCode, chkColName, txtcomm) then 
			oJson("response") = "err"
			oJson("message") = "dup"
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End		
		end if
	end if

	strSql = "select count(*) as cnt from " & vbcrlf
	strSql = strSql & "db_event.dbo.tbl_event_util_comment with(nolock) " & vbcrlf
	strSql = strSql & "where evt_code='"&eCode&"' " & vbcrlf
	strSql = strSql & "and userid = '"&userid&"' and evtcom_using = 'Y' " & vbcrlf
	strSql = strSql & "and convert(varchar, evtcom_regdate,23) = convert(varchar, getdate(),23) " & vbcrlf
	rsget.Open strSql, dbget, 1
	If rsget("cnt") >= Cint(commentNum) Then
		oJson("response") = "err"
		oJson("message") = "하루 "& commentNum &"개만 등록 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End	
	End If
	rsget.Close

	'입력 프로세스
	strSql = ""
	strSql = strSql & "Insert into db_event.dbo.tbl_event_util_comment " & vbcrlf
	strSql = strSql & "(evt_code, userid, evtcom_txt, evtcom_txt2, evtcom_txt3, option1, option2, option3, refip, device) " & vbcrlf
	strSql = strSql & "VALUES " & vbcrlf
	strSql = strSql & "('"&eCode&"','"&userid&"','"&txtcomm&"','"&txtcomm2&"','"&txtcomm3&"','"&option1&"','"&option2&"','"&option3&"', '"&refip&"', '"&device&"') "

	dbget.execute strSql
	
	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="mod" then
	strSql = strSql & " UPDATE  [db_event].[dbo].[tbl_event_util_comment] " 
	strSql = strSql & " SET evtcom_txt ='" & txtcomm & "'"	
	strSql = strSql & "   , evtcom_txt2 ='" & txtcomm2 & "'"	
	strSql = strSql & "   , evtcom_txt3 ='" & txtcomm3 & "'"	
	strSql = strSql & "   , option1 ='" & option1 & "'"	
	strSql = strSql & "   , option2 ='" & option2 & "'"	
	strSql = strSql & "   , option3 ='" & option3 & "'"	
	strSql = strSql & " WHERE evtcom_idx = '" & commidx & "'"

	dbget.execute strSql

	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="del" then
	strSql = strSql & " UPDATE  [db_event].[dbo].[tbl_event_util_comment] " 
	strSql = strSql & " SET evtcom_using = 'N'"
	strSql = strSql & " WHERE evtcom_idx = '" & commidx & "'"

	dbget.execute strSql

	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="like" then
	strSql = strSql & " UPDATE  [db_event].[dbo].[tbl_event_util_comment] " 
	strSql = strSql & " SET like_cnt = like_cnt + " & likeCnt
	strSql = strSql & " WHERE evtcom_idx = '" & commidx & "'"

	dbget.execute strSql
	
	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="chkdup" then
	dim tmpChkval
	select case chkColName
		case "txtcomm" tmpChkval = txtcomm
		case "txtcomm2" tmpChkval = txtcomm2
		case "txtcomm3" tmpChkval = txtcomm3
		case else 
			oJson("response") = "err"
			oJson("message") = "체크할 텍스트가 없습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End		
	end select	

	if chkDuplication(eCode, chkColName, tmpChkval) then 
		oJson("response") = "err"
		oJson("message") = "dup"
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End		
	end if

	oJson("response") = "ok"
	oJson("message") = ""
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
else
	oJson("response") = "err"
	oJson("message") = "시스템 오류입니다."
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End	
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
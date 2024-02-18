<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 2021 스누피 찐덕후 능력고사
' History : 2021-07-06 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, mode
dim oJson, refer, score
dim qnum, qa, q1, q2, q3, q4, q5
dim cnt, sqlstr, answer, share
'object 초기화
Set oJson = jsObject()

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "108377"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111684"
    mktTest = True
Else
	eCode = "111684"
    mktTest = False
End If

eventStartDate  = cdate("2021-07-12")		'이벤트 시작일
eventEndDate 	= cdate("2021-07-31")		'이벤트 종료일
mode = request("mode")
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")
if mktTest then
    currentDate = cdate("2021-07-12")
else
    currentDate = date()
end if

if application("Svr_Info") <> "Dev" then 
    If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
        oJson("response") = "err"
        oJson("message") = "잘못된 접속입니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then
    oJson("response") = "err"
    oJson("message") = "이벤트 참여기간이 아닙니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
End If

'점수 계산
q1 = request("q1")
q2 = request("q2")
q3 = request("q3")
q4 = request("q4")
q5 = request("q5")
if q5 ="" then
	q5 = request("qa")
end if

if q1 ="" then q1=0
if q2 ="" then q2=0
if q3 ="" then q3=0
if q4 ="" then q4=0
if q5 ="" then q5=0

score = 0
if q5<> "" then
	if q1="2" then
		score = score + 1
	end if
	if q2="2" then
		score = score + 1
	end if
	if q3="3" then
		score = score + 1
	end if
	if q4="3" then
		score = score + 1
	end if
	if q5="4" then
		score = score + 1
	end if
end if

if mode = "add" Then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인을 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    answer = Cstr(q1) & Cstr(q2) & Cstr(q3) & Cstr(q4) & Cstr(q5) 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1, sub_opt2, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'A', '0'," & score & ",'" & answer & "')"
		dbget.execute sqlstr

		oJson("response") = "ok"
		oJson("message") = ""
		oJson("score") = score
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	Else				
		oJson("response") = "err"
		oJson("message") = "이미 참여하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

elseif mode = "share" then

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인을 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	share = request("share")
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='share'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1, sub_opt2, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'A', '" & share & "',0,'share')"
		dbget.execute sqlstr

		oJson("response") = "ok"
		oJson("message") = ""
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	Else				
		oJson("response") = "err"
		oJson("message") = "이미 참여하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

elseif mode = "quiz" then
	qnum = request("qnum")
	qa = request("qa")
	if qnum="1" and qa="2" then
		oJson("response") = "ok"
		oJson("anum") = 2
	elseif qnum="1" and qa<>"2" then
		oJson("response") = "no"
		oJson("anum") = 2
	elseif qnum="2" and qa="2" then
		oJson("response") = "ok"
		oJson("anum") = 2
	elseif qnum="2" and qa<>"2" then
		oJson("response") = "no"
		oJson("anum") = 2
	elseif qnum="3" and qa="3" then
		oJson("response") = "ok"
		oJson("anum") = 3
	elseif qnum="3" and qa<>"3" then
		oJson("response") = "no"
		oJson("anum") = 3
	elseif qnum="4" and qa="3" then
		oJson("response") = "ok"
		oJson("anum") = 3
	elseif qnum="4" and qa<>"3" then
		oJson("response") = "no"
		oJson("anum") = 3
	elseif qnum="5" and qa="4" then
		oJson("response") = "ok"
		oJson("anum") = 4
	elseif qnum="5" and qa<>"4" then
		oJson("response") = "no"
		oJson("anum") = 4
	end if
	oJson("score") = score

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 호텔에서 신년 계획짜기
' History : 2022.01.03 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, eventStartDate, eventEndDate, i, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj
	dim result, oJson, mktTest, answer, answer1, answer2, answer3, cnt
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
    answer1 = request("answer1")
    answer2 = request("answer2")
    answer3 = request("answer3")
    answer = answer1 & "|" & answer2 & "|" & answer3
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

	mktTest = False

    IF application("Svr_Info") = "Dev" THEN
        eCode = "109439"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "116317"
        mktTest = True
    Else
        eCode = "116317"
        mktTest = False
    End If


    eventStartDate  = cdate("2022-01-06")		'이벤트 시작일
    eventEndDate 	= cdate("2022-01-23")		'이벤트 종료일

    LoginUserid		= getencLoginUserid()

    if mktTest then
        currentDate = cdate("2022-01-06")
    else
        currentDate = date()
    end if

    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

if mode = "add" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '" & LoginUserid & "' and evt_code=" & eCode & " and sub_opt3='try'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then

        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, device, sub_opt1, sub_opt3)" & vbCrlf
        sqlstr = sqlstr & " VALUES (" & eCode & ", '" & LoginUserid & "', '" & device & "', '" & answer & "','try')"
        dbget.execute sqlstr

        sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_116317] (userid, a1, a2, a3)" & vbCrlf
        sqlstr = sqlstr & " VALUES ('"& LoginUserid &"'," & answer1 & "," & answer2 & "," & answer3 & ")"
        dbget.execute sqlstr

        oJson("response") = "ok"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청하셨습니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="check" then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '" & LoginUserid & "' and evt_code=" & eCode & " and sub_opt3='try'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close
    If cnt < 1 Then
        oJson("response") = "ok"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 참여하셨습니다. 1월 26일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="alarm" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='alarm'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', 'alarm')"
        dbget.execute sqlstr

        oJson("response") = "ok"
        oJson("message") = "알림 신청이 완료되었습니다. 1월 26일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청이 완료되었습니다. 1월 26일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
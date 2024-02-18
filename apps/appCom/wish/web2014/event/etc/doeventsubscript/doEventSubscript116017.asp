<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 연말 선물 100원 이벤트
' History : 2021.12.13 정태훈 생성
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
	dim result, oJson, mktTest, orderserial, cnt
    dim NowJoinPoint, TotalJoinPoint, ticket1, ticket2, ticket3, ticket4
    dim item1, item2, item3, item4, item5, item6, item7, item8, item9
    dim itemnum, itemjoincnt, ticketidx, prd_name
    refer = request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
    itemnum = request("item")
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
        eCode = "109433"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "116017"
        mktTest = True
    Else
        eCode = "116017"
        mktTest = False
    End If

    item1=0
    item2=0
    item3=0
    item4=0
    item5=0
    item6=0
    item7=0
    item8=0
    item9=0

    eventStartDate  = cdate("2021-12-15")		'이벤트 시작일
    eventEndDate 	= cdate("2021-12-28")		'이벤트 종료일

    LoginUserid		= getencLoginUserid()

    if mktTest then
        currentDate = cdate("2021-12-15")
    else
        currentDate = date()
    end if

    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

if mode = "set" then

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_YearEndPresent_Get] '" & LoginUserid & "'"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
        If Not(rsget.bof or rsget.eof) Then
            NowJoinPoint = rsget("NowJoinPoint")
            TotalJoinPoint = rsget("TotalJoinPoint")
            ticket1 = rsget("ticket1")
            ticket2 = rsget("ticket2")
            ticket3 = rsget("ticket3")
            ticket4 = rsget("ticket4")
        End If
    rsget.Close

    oJson("response") = "ok"
    oJson("NowTicket") = NowJoinPoint
    oJson("TotalPoint") = TotalJoinPoint
    oJson("ticket1") = ticket1
    oJson("ticket2") = ticket2
    oJson("ticket3") = ticket3
    oJson("ticket4") = ticket4
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="item" then
    sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_YearEndPresent_ItemJoin_Get]"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
        If Not(rsget.bof or rsget.eof) Then
            item1 = rsget("item1")
            item2 = rsget("item2")
            item3 = rsget("item3")
            item4 = rsget("item4")
            item5 = rsget("item5")
            item6 = rsget("item6")
            item7 = rsget("item7")
            item8 = rsget("item8")
            item9 = rsget("item9")
        End If
    rsget.Close

    oJson("response") = "ok"
    oJson("item1") = item1
    oJson("item2") = item2
    oJson("item3") = item3
    oJson("item4") = item4
    oJson("item5") = item5
    oJson("item6") = item6
    oJson("item7") = item7
    oJson("item8") = item8
    oJson("item9") = item9
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]"
    sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt2=" & itemnum & " and sub_opt3='try'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    sqlstr = "SELECT top 1 idx FROM [db_temp].[dbo].[tbl_event_116017]"
    sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' and usingYN='N' ORDER BY idx ASC"
    rsget.Open sqlstr, dbget, 1
    IF Not rsget.Eof Then
        ticketidx = rsget("idx")
    end if
    rsget.close

    if ticketidx > 0 then
        If cnt < 1 Then
            if itemnum=1 then
                prd_name = "에어팟 3세대"
            elseif itemnum=2 then
                prd_name = "아이폰12 블랙"
            elseif itemnum=3 then
                prd_name = "21SS 톰브라운 맨투맨(w)"
            elseif itemnum=4 then
                prd_name = "비비안웨스트우드 엠마백"
            elseif itemnum=5 then
                prd_name = "구찌 하트 목걸이"
            elseif itemnum=6 then
                prd_name = "오디오테크니카 턴테이블"
            elseif itemnum=7 then
                prd_name = "마샬 ACTON2 스피커"
            elseif itemnum=8 then
                prd_name = "플레이모빌 대형 산타"
            elseif itemnum=9 then
                prd_name = "메종키츠네 비니"
            end if

            sqlStr = ""
            sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
            sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', '" & itemnum & "','try')"
            dbget.execute sqlstr

            sqlstr = "UPDATE [db_temp].[dbo].[tbl_event_116017]" & vbCrlf
            sqlstr = sqlstr & " SET usingYN='Y', usingDate=GETDATE()"
            sqlstr = sqlstr & " WHERE idx=" & ticketidx
            dbget.execute sqlstr

            sqlstr = "UPDATE [db_temp].[dbo].[tbl_event_116017_item]" & vbCrlf
            sqlstr = sqlstr & " SET item" & itemnum & "=item" & itemnum & "+1"
            sqlstr = sqlstr & " WHERE idx=1"
            dbget.execute sqlstr

            sqlstr = "SELECT item"&itemnum&" FROM [db_temp].[dbo].[tbl_event_116017_item]"
            sqlstr = sqlstr & " WHERE idx=1"
            rsget.Open sqlstr, dbget, 1
            IF Not rsget.Eof Then
                itemjoincnt = rsget(0)
            end if
            rsget.close

            oJson("response") = "ok"
            oJson("itemjoincnt") = itemjoincnt
            oJson("prd_name") = prd_name
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
    else
        oJson("response") = "noticket"
        oJson("message") = "응모권을 모두 소진 했습니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="myjoin" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
    sqlstr = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript]"
    sqlstr = sqlstr & " WHERE userid= '"&LoginUserid&"' AND evt_code="& eCode & " AND sub_opt3='try' ORDER BY sub_opt2 ASC"
    rsget.Open sqlstr, dbget, 1
    If Not rsget.EOF Then 
        Do Until rsget.EOF
            if rsget("sub_opt2") = 1 then
                item1=1
            elseif rsget("sub_opt2") = 2 then
                item2=1
            elseif rsget("sub_opt2") = 3 then
                item3=1
            elseif rsget("sub_opt2") = 4 then
                item4=1
            elseif rsget("sub_opt2") = 5 then
                item5=1
            elseif rsget("sub_opt2") = 6 then
                item6=1
            elseif rsget("sub_opt2") = 7 then
                item7=1
            elseif rsget("sub_opt2") = 8 then
                item8=1
            elseif rsget("sub_opt2") = 9 then
                item9=1
            end if
            rsget.MoveNext
        Loop
    end if
    rsget.close
    oJson("response") = "ok"
    oJson("item1") = item1
    oJson("item2") = item2
    oJson("item3") = item3
    oJson("item4") = item4
    oJson("item5") = item5
    oJson("item6") = item6
    oJson("item7") = item7
    oJson("item8") = item8
    oJson("item9") = item9
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="alarm" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
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
        oJson("message") = "알림 신청이 완료되었습니다. 12월 27일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청이 완료되었습니다. 12월 27일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 내 맘 속 1등 시그는?
' History : 2021.12.23 정태훈 생성
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
	dim result, oJson, mktTest, itemcode, cnt
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
    itemcode = request("itemcode")
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
        eCode = "109438"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "116196"
        mktTest = True
    Else
        eCode = "116196"
        mktTest = False
    End If


    eventStartDate  = cdate("2021-12-27")		'이벤트 시작일
    eventEndDate 	= cdate("2022-01-09")		'이벤트 종료일

    LoginUserid		= getencLoginUserid()

    if mktTest then
        currentDate = cdate("2021-12-27")
    else
        currentDate = date()
    end if

    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

    function fnAlbumDivName(divnum)
    if divnum="1" then
        fnAlbumDivName = "aespa"
    elseif divnum="2" then
        fnAlbumDivName = "exo"
    elseif divnum="3" then
        fnAlbumDivName = "itzy"
    elseif divnum="4" then
        fnAlbumDivName = "monstax"
    elseif divnum="5" then
        fnAlbumDivName = "nct127"
    elseif divnum="6" then
        fnAlbumDivName = "nctdream"
    elseif divnum="7" then
        fnAlbumDivName = "shinee"
    elseif divnum="8" then
        fnAlbumDivName = "straykids"
    elseif divnum="9" then
        fnAlbumDivName = "twice"
    end if
    end function

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='try'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', '" & itemcode & "','try')"
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
        oJson("message") = "알림 신청이 완료되었습니다. 1월 11일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청이 완료되었습니다. 1월 11일 당첨일을 기다려주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="rank" then
    oJson("response") = "ok"
    sqlstr = "select sub_opt2, count(sub_opt2) as cnt"
    sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
    sqlstr = sqlstr & " where evt_code="& eCode &""
    sqlstr = sqlstr & " and sub_opt3='try'"
    sqlstr = sqlstr & " group by sub_opt2"
    sqlstr = sqlstr & " order by count(sub_opt2) desc"
    rsget.Open sqlstr, dbget, 1
    IF Not (rsget.EOF OR rsget.BOF) THEN
        Set oJson("items") = jsArray()
        Do Until rsget.EOF
            Set oJson("items")(null) = jsObject()
            oJson("items")(null)("gdiv") = rsget("sub_opt2")
            oJson("items")(null)("cnt") = rsget("cnt")
            oJson("items")(null)("divname") = fnAlbumDivName(rsget("sub_opt2"))
            rsget.MoveNext
        Loop
    END IF
    rsget.close
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 골든 티켓 이벤트
' History : 2021.10.21 정태훈 생성
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
	dim result, oJson, mktTest, tcode, cnt, resultcode, suserid, ticketCode, regdate, listTxt
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
    tcode = Trim(request("tcode"))
    suserid = Trim(request("userid"))
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
        eCode = "109404"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "114637"
        mktTest = True
    Else
        eCode = "114637"
        mktTest = False
    End If

    eventStartDate  = cdate("2021-10-25")		'이벤트 시작일
    eventEndDate 	= cdate("2021-11-30")		'이벤트 종료일

    LoginUserid		= getencLoginUserid()

    if mktTest then
        currentDate = cdate("2021-10-25")
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
    sqlStr = "EXEC [db_temp].[dbo].[usp_WWW_Event_GoldenTicket_CodeSearch_Get] '" & LoginUserid & "','" & tcode & "'"
    'response.write sqlStr & "<br>"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
        If Not(rsget.bof or rsget.eof) Then
            resultcode = rsget(0)
        End If
    rsget.Close

    If resultcode = "0" Then
        oJson("response") = "ok"
        oJson("resultcode") = resultcode
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    elseIf resultcode = "1" Then
        oJson("response") = "ok"
        oJson("resultcode") = resultcode
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    elseIf resultcode = "2" Then
        oJson("response") = "fail"
        oJson("message") = "이미 등록된 코드입니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    elseIf resultcode = "3" Then
        oJson("response") = "fail"
        oJson("message") = "코드가 일치하지 않습니다. 다시 입력해주세요."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    elseIf resultcode = "4" Then
        oJson("response") = "fail"
        oJson("message") = "20회 이상 오류가 발생하여 차단되었습니다. 고객센터에 문의 바랍니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
elseif mode="search" then
    listTxt = ""
    sqlStr = "select top 20 * from db_temp.dbo.tbl_event_114637_log with(nolock) where userid='" & suserid & "' order by idx asc"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
		if not rsget.EOF then
			do until rsget.eof
                listTxt = listTxt & "<li>" & rsget("ticketCode") & " / " & FormatDate(rsget("regdate"),"0000.00.00 00:00:00") & "</li>"
				rsget.moveNext
			loop
		end if
    rsget.Close

    oJson("response") = "ok"
    oJson("message") = listTxt
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="del" then

    sqlStr = "delete from db_temp.dbo.tbl_event_114637_log where userid='" & suserid & "'"
    dbget.execute sqlStr

    oJson("response") = "ok"
    oJson("message") = "로그를 삭제했습니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
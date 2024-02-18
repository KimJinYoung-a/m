<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 서촌도감04 - 텐바이텐X커피한잔
' History : 2021.04.22 정태훈 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
dim currentDate, refer, cnt
Dim eCode, LoginUserid, mode, sqlStr, device
dim oJson, mktTest, placeNum, eventStartDate, eventEndDate
'object 초기화
Set oJson = jsObject()

IF application("Svr_Info") = "Dev" THEN
    eCode = "108387"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
    eCode = "113347"
    mktTest = true    
Else
    eCode = "113347"
    mktTest = false
End If

mode = request("mode")
placeNum = request("placeNum")

if mktTest then
    currentDate = #08/16/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-08-16")		'이벤트 시작일
eventEndDate = cdate("2021-08-29")		'이벤트 종료일

LoginUserid = getencLoginUserid()
refer = request.ServerVariables("HTTP_REFERER")

if isapp then 
    device = "A"
else
    device = "M"
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

if mode = "add" Then

    if Not(IsUserLoginOK) Then
        oJson("response") = "err"
        oJson("message") = "로그인을 해주세요."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    end if

    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt1 = '" & left(currentDate,10) & "' and sub_opt2=4"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1, sub_opt2)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '" & left(currentDate,10) & "', '" & placeNum & "')"
        dbget.execute sqlstr

        if placeNum=4 then
            oJson("response") = "ok"
            oJson("message") = "정답입니다."
            oJson.flush
        else
            oJson("response") = "err"
            oJson("message") = "오답입니다."
            oJson.flush
        end if
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson("message") = "이미 신청하셨습니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 오늘도 달콤한 텐몽카페!
' History : 2021.04.23 정태훈 생성
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
dim oJson, mktTest, teaTimeNum, eventStartDate, eventEndDate
'object 초기화
Set oJson = jsObject()

IF application("Svr_Info") = "Dev" THEN
    eCode = "105351"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
    eCode = "110793"
    mktTest = true    
Else
    eCode = "110793"
    mktTest = false
End If

mode = request("mode")
teaTimeNum = request("teaTimeNum")

if mktTest then
    currentDate = #04/28/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-04-28")		'이벤트 시작일
eventEndDate = cdate("2021-05-11")		'이벤트 종료일

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

    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt1 = '" & left(currentDate,10) & "'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1, sub_opt2)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '" & left(currentDate,10) & "', '" & teaTimeNum & "')"
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
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
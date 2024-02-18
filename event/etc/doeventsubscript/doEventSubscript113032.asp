<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 이왕 이렇게 된 거! 코멘트 이벤트
' History : 2021.07.22 정태훈 생성
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
Dim eCode, LoginUserid, mode, sqlStr, device, idx
dim oJson, mktTest, txt1, txt2, txt3, eventStartDate, eventEndDate
'object 초기화
Set oJson = jsObject()

IF application("Svr_Info") = "Dev" THEN
    eCode = "108379"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
    eCode = "113032"
    mktTest = true    
Else
    eCode = "113032"
    mktTest = false
End If

mode = request("mode")
txt1 = request("txt1")
txt2 = request("txt2")
txt3 = request("txt3")

if mktTest then
    currentDate = cdate("2021-07-26")
else
    currentDate = date()
end if

eventStartDate = cdate("2021-07-26")		'이벤트 시작일
eventEndDate = cdate("2021-08-08")		'이벤트 종료일

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

if Not(IsUserLoginOK) Then
    oJson("response") = "err"
    oJson("message") = "로그인을 해주세요."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if
 
if mode = "add" Then
    sqlStr = ""
    sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_113032] (userid , txt1, txt2, txt3)" & vbCrlf
    sqlstr = sqlstr & " VALUES ('"& LoginUserid &"', '"&txt1&"', '" & txt2 & "', '" & txt3 & "')"
    dbget.execute sqlstr

    oJson("response") = "ok"
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
elseif mode="del" then
    idx = request("idx")
    sqlStr = ""
    sqlstr = "UPDATE [db_temp].[dbo].[tbl_event_113032] SET isusing='N' WHERE userid='"& LoginUserid &"' AND idx="& idx
    dbget.execute sqlstr

    oJson("response") = "ok"
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
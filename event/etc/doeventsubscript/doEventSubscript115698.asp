<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 2022 페이퍼즈
' History : 2021.11.18 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
dim currentDate, refer
Dim LoginUserid, mode, sqlStr, device, eventStartDate, eventEndDate
dim oJson, mktTest, orderSerial, eCode, testDate, vQuery, mileageReqCNT

'object 초기화
Set oJson = jsObject()

IF application("Svr_Info") = "Dev" THEN
	eCode = "109424"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "115698"
    mktTest = True
Else
	eCode = "115698"
    mktTest = False
End If

mode = request("mode")
eventStartDate  = cdate("2021-11-30")       '이벤트 시작일
eventEndDate 	= cdate("2022-01-01")       '이벤트 종료일+1

if mktTest then
    currentDate = cdate("2021-11-30")
else
    currentDate = date()
end if

LoginUserid = getencLoginUserid()
refer = request.ServerVariables("HTTP_REFERER")

if isapp then
    device = "A"
else
    device = "M"
end if

if application("Svr_Info") <> "Dev" then
    If InStr(refer, "10x10.co.kr") < 1 Then
        oJson("response") = "err"
        oJson("message") = "잘못된 접속입니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

if not (currentDate >= eventStartDate and currentDate <eventEndDate) then
    oJson("response") = "err"
    oJson("message") = "이벤트 참여기간이 아닙니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
End If

if mode = "down" Then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인 후 이용 가능한 이벤트입니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
    '// 이벤트 응모내역을 남긴다.
    vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device)"
    vQuery = vQuery & " VALUES('" & eCode & "', '" & LoginUserid & "', 'down', '" & device & "')"
    dbget.Execute vQuery

    oJson("response") = "ok"
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
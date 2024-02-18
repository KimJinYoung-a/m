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
	eCode = "109421"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "115414"
    mktTest = True
Else
	eCode = "115414"
    mktTest = False
End If

mode = request("mode")
eventStartDate  = cdate("2021-11-22")       '이벤트 시작일
eventEndDate 	= cdate("2021-12-20")       '이벤트 종료일+1
testDate = cdate(request("testDate"))
if testDate="" then testDate="2021-11-22"

if mktTest then
    currentDate = testDate
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

if mode = "add" Then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인 후 이용 가능한 이벤트입니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    ' 마일리지 신청 내역 확인
    vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK)"
    vQuery = vQuery & " WHERE evt_code = '" & eCode & "' And userid='" & LoginUserid & "'"
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    If rsget(0) > 0 Then
		oJson("response") = "err"
		oJson("message") = "이미 신청 완료되었어요. 페이백 마일리지는 ID 당 1회 제공됩니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    End IF
    rsget.close

    sqlstr = "select count(sub_opt1)"
    sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
    sqlstr = sqlstr & " where evt_code="& eCode
    sqlstr = sqlstr & " and sub_opt3='try'"
    rsget.Open sqlstr,dbget
    IF not rsget.EOF THEN
        mileageReqCNT = rsget(0)
    END IF
    rsget.close

    if mileageReqCNT >= 10000 then
		oJson("response") = "err"
		oJson("message") = "마일리지가 모두 소진 되었습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
    end if

    sqlStr = "EXEC [db_order].[dbo].[usp_WWW_Event_Papers2022_OrderDetail_Get] '" & LoginUserid & "','2021-11-22','2021-12-20'"
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1
        If not rsget.EOF Then
            orderSerial = rsget(0)
        End If
    rsget.Close

    if orderSerial <> "" then
        '// 이벤트 응모내역을 남긴다.
        vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device)"
        vQuery = vQuery & " VALUES('" & eCode & "', '" & LoginUserid & "', '" & orderSerial & "', 'try', '" & device & "')"
        dbget.Execute vQuery

        oJson("response") = "ok"
        oJson("message") = "신청이 완료되었습니다."
        oJson("mpoint") = FormatNumber(50000000-(mileageReqCNT*5000)-5000,0) & "p"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    else
        oJson("response") = "err"
        oJson("message") = "디자인 문구 3만 원 이상 구매 후 신청해주세요!"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    end if
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
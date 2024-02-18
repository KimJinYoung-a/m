<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 카카오 브랜드위크
' History : 2021-08-02 정태훈
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
Dim LoginUserid, mode, sqlStr, device, idx, pushdiv
dim oJson, mktTest, txt1, txt2, txt3

DIM evt_code, pushTime

'object 초기화
Set oJson = jsObject()

IF application("Svr_Info") = "Dev" THEN
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
    mktTest = True
Else
    mktTest = False
End If

mode = request("mode")
evt_code = request("evt_code")
pushTime = request("pushTime")

if mktTest then
    currentDate = cdate("2021-08-02")
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
    If InStr(refer, "10x10.co.kr") < 1 or evt_code = "" Then
        oJson("response") = "err"
        oJson("message") = "잘못된 접속입니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

if mode = "pushadd" Then
	dim vQuery, pushDate
	''푸시 신청
    pushdiv = request("pushdiv")
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 알림 신청이 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

    pushDate = cdate(pushTime)

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push6] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			oJson("response") = "err"
			oJson("faildesc") = "이미 신청되었습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End IF
	rsget.close

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push6](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End

end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
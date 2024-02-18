<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 2021 이상형 월드꽃
' History : 2021-04-08 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, mode
dim oJson, refer
'object 초기화
Set oJson = jsObject()

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104346"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "110645"
    mktTest = True
Else
	eCode = "110645"
    mktTest = False
End If

if LoginUserid <> "" then cartTotalAmount = getCartTotalAmount(LoginUserid)

eventStartDate  = cdate("2021-04-12")		'이벤트 시작일
eventEndDate 	= cdate("2021-04-21")		'이벤트 종료일
mode = request("mode")
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")
if mktTest then
    currentDate = cdate("2021-04-12")
else
    currentDate = date()
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

if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then
    oJson("response") = "err"
    oJson("message") = "이벤트 참여기간이 아닙니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
End If

if mode = "add" Then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인을 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
    dim cnt, sqlstr, flowernum
    flowernum = request("flowernum")
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1, sub_opt2, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', 'A', '0'," + flowernum + ",'try')"
		dbget.execute sqlstr

		oJson("response") = "ok"
		oJson("message") = ""
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	Else				
		oJson("response") = "err"
		oJson("message") = "이미 신청하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

elseif mode = "pushadd" then
	dim vQuery, pushDate
	''푸시 신청
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 알림 신청이 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	pushDate = dateadd("d", 1, currentDate)

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push7] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
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

	vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push7](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute vQuery

	oJson("response") = "ok"
	oJson("sendCount") = 0
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
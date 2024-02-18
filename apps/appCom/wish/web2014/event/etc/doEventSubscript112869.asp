<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 앱 푸시 마일리지 (앱 최초설치 푸시동의 1회 발급)
' History : 2021.07.15 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim i, refer
	Dim eCode, LoginUserid, mode, sqlStr, device
	dim result, oJson, mktTest
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
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
		eCode = "108378"
		mktTest = True
	ElseIf application("Svr_Info")="staging" Then
		eCode = "112869"
		mktTest = True
	Else
		eCode = "112869"
		mktTest = False
	End If

    LoginUserid		= getencLoginUserid()

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
'	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) then	'이벤트 참여기간
'		oJson("response") = "err"
'		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
'		oJson.flush
'		Set oJson = Nothing
'		dbget.close() : Response.End
'	end if

if mode = "add" then
	dim CheckCNT
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_temp].[dbo].[tbl_app_push_mileage] with(nolock)"
	sqlStr = sqlStr & " WHERE userid= '"&LoginUserid&"' and mileageGive='N'"
    rsget.Open sqlstr, dbget, 1
        CheckCNT = rsget("cnt")
    rsget.close

	'// 2021-07-15 정태훈 APP 푸시 동의 마일리지 1000포인트 지급

	if CheckCNT > 0 then
		sqlStr = "UPDATE [db_temp].[dbo].[tbl_app_push_mileage]" & vbCrlf
		sqlStr = sqlStr & "	SET mileageGive='Y'" & vbCrlf
		sqlStr = sqlStr & "	,mileageGiveDate=GETDATE()" & vbCrlf
		sqlStr = sqlStr & "	WHERE userid='" & LoginUserid & "'" & vbCrlf
		dbget.execute(sqlStr)

		sqlStr = "INSERT INTO [db_user].[dbo].[tbl_mileagelog](userid , mileage , jukyocd , jukyo , deleteyn)" & vbCrlf
		sqlStr = sqlStr & "	VALUES ('" & LoginUserid & "',1000,112869,'APP 푸시 알림 혜택','N')" & vbCrlf
		dbget.execute(sqlStr)

		sqlStr = "UPDATE [db_user].[dbo].[tbl_user_current_mileage]" & vbCrlf
		sqlStr = sqlStr & "	SET bonusmileage = bonusmileage + 1000" & vbCrlf
		sqlStr = sqlStr & "	WHERE userid='" & LoginUserid & "'" & vbCrlf
		dbget.execute(sqlStr)
	else
		oJson("response") = "err"
		oJson("faildesc") = "이미 지급 받았거나 지급대상이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	oJson("response") = "ok"
	oJson("returnCode") = "응모완료"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
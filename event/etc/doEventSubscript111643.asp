<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2021 캠핑 마일리지 혜택 이벤트
' History : 2021-05-21 정태훈
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
        eCode = "106359"
        mktTest = True
    ElseIf application("Svr_Info")="staging" Then
        eCode = "111643"
        mktTest = True
    Else
        eCode = "111643"
        mktTest = False
    End If

	eventStartDate  = cdate("2021-05-24")		'이벤트 시작일
	eventEndDate 	= cdate("2021-06-03")		'이벤트 종료일 + 1

	LoginUserid		= getencLoginUserid()

	if mktTest then
		currentDate = cdate("2021-05-24")
	else
		currentDate = date()
	end if
    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	if getevent_subscriptexistscount(eCode, LoginUserid, "", "", "try") < 1 then
		sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt3, device)" & vbcrlf
		sqlStr = sqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '0', 'try','"& device &"')"
		dbget.execute sqlStr
    else
		oJson("response") = "err"
		oJson("faildesc") = "고객님은 이미 응모되었습니다. ID당 1회만 응모 가능합니다."
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
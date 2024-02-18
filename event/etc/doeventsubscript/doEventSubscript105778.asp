<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
Response.ContentType = "application/json"
response.charset = "utf-8"

dim eCode, userid, mode, sqlstr, refer, txtcomm, sub_idx, subscriptcount, ccomment, currentdate, device, oJson
    refer = request.ServerVariables("HTTP_REFERER")

	Set oJson = jsObject()
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

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "102223"
	Else
		eCode   =  "105778"
	End If

	currentdate = date()

	If isapp="1" Then
		device = "A"
	else
		device = "M"
	end if
	
	userid = GetEncLoginUserID()
	mode = requestcheckvar(trim(request("mode")),32)
	sub_idx = requestcheckvar(getNumeric(trim(request("sub_idx"))),10)
	txtcomm = requestcheckvar(trim(request("txtcomm")),6)


if Not(IsUserLoginOK) Then
    oJson("response") = "err"
    oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if

if Not(currentDate >= eventStartDate And currentDate < eventEndDate) and not mktTest then	'이벤트 참여기간
    oJson("response") = "err"
    oJson("faildesc") = "이벤트 참여기간이 아닙니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if


if mode="addcomment" then
    subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")

	if subscriptcount > 1 then
		oJson("response") = "err"
		oJson("faildesc") = "참여는 한번만 가능 합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if txtcomm="" then
		oJson("response") = "err"
		oJson("faildesc") = "6글자로 채워주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if	
	if checkNotValidTxt(txtcomm) then
		oJson("response") = "err"
		oJson("faildesc") = "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& html2db(txtcomm) &"', 1)" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

    sqlstr = "insert into db_user.dbo.tbl_mileagelog (userid , mileage , jukyocd , jukyo , deleteyn)" + vbcrlf
	sqlstr = sqlstr & "     select distinct userid, '+100', '"& eCode &"', '6글자로 말해요! 이벤트 참여','N'" + vbcrlf
	sqlstr = sqlstr & "     from db_user.dbo.tbl_user_n with (nolock)" + vbcrlf
	sqlstr = sqlstr & "     where userid='"& userid &"'" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

    sqlstr = "update db_user.dbo.tbl_user_current_mileage" + vbcrlf
	sqlstr = sqlstr & " set bonusmileage = bonusmileage+100 where" + vbcrlf
	sqlstr = sqlstr & " userid='"& userid &"'" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	oJson("response") = "ok"
	oJson("returnCode") = "100"
    oJson("returnstr") = "축하합니다. 마일리지 100P가 지급되었습니다."

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End

elseif mode="editcomment" then

elseif mode="delcomment" then

else
    oJson("response") = "err"
    oJson("faildesc") = "정상적인 경로가 아닙니다."
    oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
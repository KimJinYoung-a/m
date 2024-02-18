<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 타임제 다이어트 MA
' History : 2016.01.29 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim subscriptcount
dim mode, sqlstr, timegubun, daygubun, device
dim cnt0209, submitgubun

	mode = requestcheckvar(request("mode"),32)

dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66018"
	Else
		eCode = "68982"
	End If

	if isapp then
		device = "A"
	else
		device = "M"
	end if

currenttime = now()
'																		currenttime = #02/10/2016 15:05:00#
userid = GetEncLoginUserID()
subscriptcount=0
cnt0209 = ""

if hour(currenttime) >= 0 and hour(currenttime) < 12 then
	timegubun = 1	'오전
else
	timegubun = 2	'오후
end if

if left(currenttime,10) = "2016-02-09" then
	daygubun = "1"		'첫날
elseif left(currenttime,10) = "2016-02-10" then
	daygubun = "2"		'둘쨋날
end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "{ "
	response.write """ytcode"":""01"""	''||올바른 접속이 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
end If

If not( left(currenttime,10)>="2016-02-09" and left(currenttime,10)<"2016-02-11" ) Then
	Response.Write "{ "
	response.write """ytcode"":""03"""	''||이벤트 기간이 아닙니다.
	response.write "}"
	dbget.close()	:	response.End
End IF

If userid = "" Then
	Response.Write "{ "
	response.write """ytcode"":""02"""	''||로그인을 해주세요
	response.write "}"
	dbget.close()	:	response.End
End IF

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

if subscriptcount>1  then
	Response.Write "{ "
	response.write """ytcode"":""11e"""	''||이미 다이어트에 성공하셨습니다.당첨자 발표를 기다려 주세요!
	response.write "}"
	dbget.close()	:	response.End
end if

if mode="time" then
	if left(currenttime,10) = "2016-02-09" and timegubun="1" then
		submitgubun = "2016-02-09-01"

	elseif left(currenttime,10) = "2016-02-09" and timegubun="2" then
		submitgubun = "2016-02-09-02"

	elseif left(currenttime,10) = "2016-02-10" and timegubun="1" then
		submitgubun = "2016-02-10-01"

	elseif left(currenttime,10) = "2016-02-10" and timegubun="2" then
		submitgubun = "2016-02-10-02"
	end if

	if subscriptcount > 0 then
		sqlstr = "Select top 1 sub_opt3" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & userid & "' " &_
				" order by sub_idx desc "
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			cnt0209 = rsget(0)
		rsget.Close
	end if

	if left(currenttime,10) = "2016-02-09" then		''첫날 응모
		if timegubun = "1" then	''오전응모
			if subscriptcount = "0" then	''첫날 오전은 무조건 응모여부가 0건임
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11a"""	''||으쌰으쌰!꼭 한번 더 운동하러 와요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" then		''첫날 오전에 응모완료했는데 또 하면
				Response.Write "{ "
				response.write """ytcode"":""11b"""	''||이미 오늘 오전에 운동 하셨습니다!
				response.write "}"
				dbget.close()	:	response.End
			else
				Response.Write "{ "
				response.write """ytcode"":""00"""	''||잘못된 접속입니다.
				response.write "}"
				dbget.close()	:	response.End
			end if
		elseif timegubun = "2" then		''첫날 오후 응모
			if subscriptcount = "0" then	''첫날 오전에 응모 안하고 오후에만 응모시
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr
				
				Response.Write "{ "
				response.write """ytcode"":""11c"""	''||으쌰으쌰!내일 오전에도 운동하러 오세요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 <> "2016-02-09-02" then		''첫날 오전에 응모하고 오후에 응모할때
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11d"""	''||야호!당첨자 발표를 기다려주세요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 = "2016-02-09-02" then		''첫날 오후에 하고 또 오후에 할때
				Response.Write "{ "
				response.write """ytcode"":""11h"""	''||이미 오늘 오후에 운동 하셨습니다!
				response.write "}"
				dbget.close()	:	response.End
			else
				Response.Write "{ "
				response.write """ytcode"":""11e"""	''||이미 다이어트에 성공하셨습니다.당첨자 발표를 기다려 주세요!
				response.write "}"
				dbget.close()	:	response.End
			end if
		else
			Response.Write "{ "
			response.write """ytcode"":""00"""	''||잘못된 접속입니다.
			response.write "}"
			dbget.close()	:	response.End
		end if
	elseif left(currenttime,10) = "2016-02-10" then		''둘쨋날 응모
		if timegubun = "1" then	''둘쨋날 오전응모
			if subscriptcount = "0" then	''첫날 응모 안하고 둘쨋날 처음 응모시(총 1번 응모)
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11f"""	''||으쌰으쌰!잊지 않고 오후에도 꼭 오세요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 <> "2016-02-10-01" then	''첫날 한번 하고 오늘 오전에 응모시(총 2번 응모)
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11d"""	''||야호!당첨자 발표를 기다려주세요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 = "2016-02-10-01" then	''오늘 오전에 한번하고 오늘 오전에 또응모시
				Response.Write "{ "
				response.write """ytcode"":""11b"""	''||이미 오늘 오전에 운동 하셨습니다!
				response.write "}"
				dbget.close()	:	response.End
			else
				Response.Write "{ "
				response.write """ytcode"":""11e"""	''||이미 다이어트에 성공하셨습니다.당첨자 발표를 기다려 주세요!
				response.write "}"
				dbget.close()	:	response.End
			end if
		elseif timegubun = "2" then		''둘쨋날 오후 응모
			if subscriptcount = "0" then	''첫날 안하고 둘쨋날 오전도 안하고 둘쨋날 오후에만 응모시(총 1번 응모)
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11g"""	''||으쌰으쌰!늦었지만 고마워요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 <> "2016-02-10-02" then	''한번하고 오늘 오후에 응모시(총 2번 응모)
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& daygubun &"', " & timegubun & ", '" & submitgubun & "', '" & device & "')" + vbcrlf
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "{ "
				response.write """ytcode"":""11d"""	''||야호!당첨자 발표를 기다려주세요!
				response.write "}"
				dbget.close()	:	response.End
			elseif subscriptcount = "1" and cnt0209 = "2016-02-10-02" then	''한번하고 오늘 오후에 응모시(총 2번 응모)
				Response.Write "{ "
				response.write """ytcode"":""11h"""	''||이미 오늘 오후에 운동 하셨습니다!
				response.write "}"
				dbget.close()	:	response.End
			else
				Response.Write "{ "
				response.write """ytcode"":""11e"""	''||이미 다이어트에 성공하셨습니다.당첨자 발표를 기다려 주세요!
				response.write "}"
				dbget.close()	:	response.End
			end if
		else
			Response.Write "{ "
			response.write """ytcode"":""00"""	''||잘못된 접속입니다.
			response.write "}"
			dbget.close()	:	response.End
		end if
	else
		Response.Write "{ "
		response.write """ytcode"":""03"""	''||이벤트 기간이 아닙니다.
		response.write "}"
		dbget.close()	:	response.End
	end if
Else
	Response.Write "{ "
	response.write """ytcode"":""00"""	''||잘못된 접속입니다.
	response.write "}"
	dbget.close()	:	response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

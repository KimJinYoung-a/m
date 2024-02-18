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
' Description : 고객님, 질문 있어요
' History : 2015.12.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, sqlstr, cntval, selval, comment
	mode = requestcheckvar(request("mode"),32)
	cntval = getNumeric(requestcheckvar(request("cntval"),1))
	comment = requestcheckvar(request("comment"),100)
	isapp = requestcheckvar(request("isapp"),1)

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end If

dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65997"
	Else
		eCode = "68354"
	End If

	currenttime = now()
	'currenttime = #01/08/2016 10:05:00#

	userid = GetEncLoginUserID()

dim subscriptcount, subscriptcountcurrentdate, subscriptcountend
subscriptcount=0
subscriptcountcurrentdate=0
subscriptcountend=0

dim datelimit
if left(currenttime,10) < "2016-01-05" then
	datelimit = 1
elseif left(currenttime,10) = "2016-01-05" then
	datelimit = 2
elseif left(currenttime,10) = "2016-01-06" then
	datelimit = 3
elseif left(currenttime,10) = "2016-01-07" then
	datelimit = 4
elseif left(currenttime,10) = "2016-01-08" then
	datelimit = 5		
end if

if mode="cnt" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2016-01-04" and left(currenttime,10)<"2016-01-09" ) Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If cntval = "" Then
		Response.Write "<script type='text/javascript'>alert('구분자가 지정되지 않았습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if checkNotValidHTML(comment) or comment = "" then
		Response.Write "<script type='text/javascript'>alert('내용이 없거나 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
		subscriptcountcurrentdate = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
		subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	end if

	'/응모 완료
	if subscriptcountend>0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	if cntval="1" then
		'/응모횟수
		if subscriptcount>0 then
			Response.Write "<script type='text/javascript'>alert('첫번째 답변은 이미 해주셨어요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp="1" then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'M')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
		Response.Write "<script type='text/javascript'>alert('답변해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	elseif cntval="2" then
		'/응모횟수
		if subscriptcount>1 then
			Response.Write "<script type='text/javascript'>alert('두번째 답변은 이미 해주셨어요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'/오늘응모여부
		if subscriptcount >= datelimit then
			if subscriptcountcurrentdate>0 then
				Response.Write "<script type='text/javascript'>alert('오늘은 이미 답변해 주셨네요! 다음날 참여해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp="1" then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'M')" + vbcrlf
		end if


		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('답변해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	elseif cntval="3" then
		'/응모횟수
		if subscriptcount>2 then
			Response.Write "<script type='text/javascript'>alert('세번째 답변은 이미 해주셨어요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'/오늘응모여부
		if subscriptcount >= datelimit then
			if subscriptcountcurrentdate>0 then
				Response.Write "<script type='text/javascript'>alert('오늘은 이미 답변해 주셨네요! 다음날 참여해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp="1" then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'M')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('답변해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	elseif cntval="4" then
		'/응모횟수
		if subscriptcount>3 then
			Response.Write "<script type='text/javascript'>alert('네번째 답변은 이미 해주셨어요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'/오늘응모여부
		if subscriptcount >= datelimit then
			if subscriptcountcurrentdate>0 then
				Response.Write "<script type='text/javascript'>alert('오늘은 이미 답변해 주셨네요! 다음날 참여해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp="1" then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'M')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('답변해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	elseif cntval="5" then
		'/응모횟수
		if subscriptcount>4 then
			Response.Write "<script type='text/javascript'>alert('다섯번째 답변까지 모두 하셨네요! 하단에 응모하기 버튼을 클릭해 주세요:)'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'/오늘응모여부
		if subscriptcount >= datelimit then
			if subscriptcountcurrentdate>0 then
				Response.Write "<script type='text/javascript'>alert('오늘은 이미 답변해 주셨네요! 다음날 참여해 주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

		if isApp="1" then
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'A')" + vbcrlf
		else
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 1, '"& db2html(comment) &"', 'M')" + vbcrlf
		end if

		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('답변해 주셔서 감사합니다!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	
elseif mode="end" then
	If userid = "" Then
		Response.Write "01||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2016-01-04" and left(currenttime,10)<"2016-01-09" ) Then
		Response.Write "02||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
		subscriptcountcurrentdate = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
		subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	end if

	'/응모 완료
	if subscriptcountend>0 then
		Response.Write "03||이미 응모 하셨습니다."
		dbget.close() : Response.End
	end if
	'/응모횟수
	if subscriptcount<5 then
		Response.Write "04||다섯가지 답변을 모두해주셔야 응모가 가능 합니다."
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf

	if isApp="1" then
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 2, '', 'A')" + vbcrlf
	else
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 2, '', 'M')" + vbcrlf
	end if

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "05||응모가 완료되었습니다! 감사합니다."
	dbget.close() : Response.End
else
	Response.Write "정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
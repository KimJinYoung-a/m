<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<%
'####################################################
' Description :  웬만하면 참석해라, 송년회
' History : 2013.12.20 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event47896Cls.asp" -->

<%
dim eCode, userid, dategubun, mode, sqlstr, k, winox, arrwinox, comment
dim tmpcount, tmpmileagecount, tmpcouponcount, day25wincount, day25wincommentcount,day25giftconcount
dim day25giftconmax, day31giftcount, day31giftmax
	eCode   =  getevt_code
	mode = requestcheckvar(request("mode"),32)
	dategubun = requestcheckvar(request("dategubun"),10)
	comment = requestcheckvar(request("comment"),16)

userid = GetLoginUserID()
day31giftmax=0
day31giftcount=0
day25giftconcount=0
day25wincount=0
day25wincommentcount=0
tmpcount=0
tmpmileagecount=0
tmpcouponcount=0
day25giftconmax=0
arrwinox=""
winox=""

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate="2013-12-25" or getnowdate="2013-12-28" or getnowdate="2013-12-31") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If dategubun = "" Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 구분이 없습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If existsday(dategubun) = "" Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 구분이 정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="dateinsert" then

	'/2013-12-25일
	if dategubun="day25" then

		If getnowdate<>"2013-12-25" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다. 응모기간 : 2013년 12월 25일'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF

		'//참여여부체크
		tmpcount = getexistscount(eCode, userid, dategubun, "","")
		'//참여후
		if tmpcount>0 then
			'//참여후 당첨여부 체크
			day25wincount = getexistscount(eCode, userid, dategubun, "1", "")
			'//당첨
			if day25wincount>0 then
				'//당첨일경우 기프트콘 전화번호를 입력 했는지 확인
				day25wincommentcount = getexistscount(eCode, userid, dategubun, "1", "Y")
				'//전화번호까지 입력완료시
				if day25wincommentcount=0 then
					Response.Write "<script type='text/javascript'>alert('2013년 12월 25일 이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End

				'//전화번호 미입력시
				else
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript]" + vbcrlf
					sqlstr = sqlstr & " set sub_opt3='"& html2db(comment) &"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code = "& eCode &"" + vbcrlf
					sqlstr = sqlstr & " and userid = '" & userid & "'" + vbcrlf
					sqlstr = sqlstr & " and sub_opt1 = '" & dategubun & "'" + vbcrlf
					sqlstr = sqlstr & " and sub_opt2 = 1"
					'response.write sqlstr & "<Br>"
					dbget.execute sqlstr

					Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다. 기프티콘은 일괄지급 됩니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
					dbget.close() : Response.End
				end if
			'//꽝
			else
				Response.Write "<script type='text/javascript'>alert('2013년 12월 25일 이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if

		'/처음참여
		else

			'//현재 당첨자 수량
			day25giftconcount=gettotalcount(eCode, "day25")
			'//최대 수량 50개
			day25giftconmax=getday25giftconmax
			if day25giftconcount>=day25giftconmax then
				Response.Write "<script type='text/javascript'>alert('당첨자 50명 마감되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if

			arrwinox  = Array("x","x","x","x","x","x","x","x","x","o")		'10% 확률
			Randomize
			k = Int(10 * Rnd)
			winox = arrwinox(k)

			'//당첨
			if winox="o" then
				sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') "
				sqlstr = sqlstr & " BEGIN"
				sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
				sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 1, 'Mgiftcon')"
				sqlstr = sqlstr & " END"
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				'//당첨을 시킨후 레이어를 띠워서 키프티콘 전화번호를 입력 받는다.
				Response.Write "<script type='text/javascript'>parent.$('.resultLyr').show();</script>"
				dbget.close() : Response.End

			'//꽝
			elseif winox="x" then
				sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') "
				sqlstr = sqlstr & " BEGIN"
				sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
				sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 2, 'M꽝')"
				sqlstr = sqlstr & " END"
				'response.write sqlstr & "<Br>"
				dbget.execute sqlstr

				Response.Write "<script type='text/javascript'>alert('꽝! 다음 기회에'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
				dbget.close() : Response.End
			end if
		end if

	'/2013-12-28일
	elseif dategubun="day28" then
		If getnowdate<>"2013-12-28" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다. 응모기간 : 2013년 12월 28일'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF

		'//참여여부체크
		tmpcount = getexistscount(eCode, userid, dategubun, "", "")
		if tmpcount>0 then
			Response.Write "<script type='text/javascript'>alert('2013년 12월 28일 이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		'//마일리지 발급되었는지 체크
		tmpmileagecount = getmileagecount(userid, "1000", "200")
		if tmpmileagecount>0 then
			Response.Write "<script type='text/javascript'>alert('2013년 12월 28일 마일리지가 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') "
		sqlstr = sqlstr & " BEGIN"
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 1, '200')"
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		sqlstr = "update db_user.dbo.tbl_user_current_mileage" + vbcrlf
		sqlstr = sqlstr & " set bonusmileage = bonusmileage+200" + vbcrlf
		sqlstr = sqlstr & " where userid = '" & userid & "'" + vbcrlf
		sqlstr = sqlstr & " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn)" + vbcrlf
		sqlstr = sqlstr & " values('" & userid & "', '+200', 1000, '2013 송년회 웬만하면 참석해라 200 마일리지 적립','N')"
		'response.write sqlstr & "<Br>"
		dbget.execute(sqlstr)

		Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다. 마일리지가 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	'/2013-12-31일
	elseif dategubun="day31" then
		If getnowdate<>"2013-12-31" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다. 응모기간 : 2013년 12월 31일'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF

		tmpcount = getexistscount(eCode, userid, dategubun, "","")
		if tmpcount>0 then
			Response.Write "<script type='text/javascript'>alert('2013년 12월 27일 이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		'//현재 당첨자 수량
		day31giftcount=gettotalcount(eCode, "day31")
		'//최대 수량 50개
		day31giftmax=getday31giftmax
		if day31giftcount>=day31giftmax then
			Response.Write "<script type='text/javascript'>alert('당첨자 90명 마감되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		arrwinox  = Array("x","x","x","x","x","x","x","x","x","o")		'10% 확률
		Randomize
		k = Int(10 * Rnd)
		winox = arrwinox(k)

		'//당첨
		if winox="o" then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 1, 'Mgift')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다. 선물은 일괄지급 됩니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End

		'//꽝
		elseif winox="x" then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 2, 'M꽝')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>alert('꽝! 다음 기회에'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
	end if
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
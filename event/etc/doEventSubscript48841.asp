<%@ language=vbscript %>
<% option Explicit %>
<%
'####################################################
' Description :  세뱃돈, 뺏기기 전에 쇼핑합시다
' History : 2014.01.27 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event48841Cls.asp" -->
<%
dim eCode, mode, dategubun, userid, sqlstr
dim day29count, day30count, day31count, day01count, day02count
dim day29couponcount, day30couponcount, day31couponcount, day01couponcount, day02couponcount
	eCode   =  getevt_code
	mode = requestcheckvar(request("mode"),32)
	dategubun = requestcheckvar(request("dategubun"),10)

userid = getloginuserid()
day29count=0
day30count=0
day31count=0
day01count=0
day02count=0
day29couponcount=0
day30couponcount=0
day31couponcount=0
day01couponcount=0
day02couponcount=0

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate="2014-01-29" or getnowdate="2014-01-30" or getnowdate="2014-01-31" or getnowdate="2014-02-01" or getnowdate="2014-02-02") Then
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
	if dategubun="day29" then
		If getnowdate<>"2014-01-29" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF
		
		'//참여여부체크
		day29count = getevent_subscriptexistscount(eCode, userid, "day29", "", "")
		if day29count>0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'//쿠폰이 발급되었는지 체크
		day29couponcount = getbonuscouponexistscount(userid, get29couponid, "", "", "")
		if day29couponcount>0 then
			Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 0, 'M3000')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get29couponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get29couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

	elseif dategubun="day30" then
		If getnowdate<>"2014-01-30" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF
		
		'//참여여부체크
		day30count = getevent_subscriptexistscount(eCode, userid, "day30", "", "")
		if day30count>0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'//쿠폰이 발급되었는지 체크
		day30couponcount = getbonuscouponexistscount(userid, get30couponid, "", "", "")
		if day30couponcount>0 then
			Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 0, 'M5000')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get30couponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get30couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
	elseif dategubun="day31" then
		If getnowdate<>"2014-01-31" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF
		
		'//참여여부체크
		day31count = getevent_subscriptexistscount(eCode, userid, "day31", "", "")
		if day31count>0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'//쿠폰이 발급되었는지 체크
		day31couponcount = getbonuscouponexistscount(userid, get31couponid, "", "", "")
		if day31couponcount>0 then
			Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 0, 'M7000')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get31couponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get31couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
	elseif dategubun="day01" then
		If getnowdate<>"2014-02-01" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF
		
		'//참여여부체크
		day01count = getevent_subscriptexistscount(eCode, userid, "day01", "", "")
		if day01count>0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'//쿠폰이 발급되었는지 체크
		day01couponcount = getbonuscouponexistscount(userid, get01couponid, "", "", "")
		if day01couponcount>0 then
			Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 0, 'M10000')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get01couponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get01couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
	elseif dategubun="day02" then
		If getnowdate<>"2014-02-02" Then
			Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End IF
		
		'//참여여부체크
		day02count = getevent_subscriptexistscount(eCode, userid, "day02", "", "")
		if day02count>0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		'//쿠폰이 발급되었는지 체크
		day02couponcount = getbonuscouponexistscount(userid, get02couponid, "", "", "")		
		if day02couponcount>0 then
			Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '" & dategubun & "') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '" & dategubun & "', 0, 'M15000')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get02couponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get02couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		
	end if

	Response.Write "<script type='text/javascript'>alert('새뱃돈을 지키셨군요!\n쿠폰 다운로드 완료'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
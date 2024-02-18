<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  [설 명절엔 쇼핑] 쿠폰도 넣어둬 넣어둬 
' History : 2015.02.16 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event59606Cls.asp" -->

<%
dim eCode, eCodelink, userid, eventnewexists, mode, sqlstr, refer, coupongubun
dim subscriptcount, couponnewcount
	eCode=getevt_code
	eCodelink=getevt_codelink
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	coupongubun = requestcheckvar(request("coupongubun"),3)
	
couponnewcount=0
subscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요');</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2015-02-19" and getnowdate<"2015-02-23") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF

if mode="couponinsert" then
	if coupongubun="1" or coupongubun="all" then
		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '1' and sub_opt2 = '1') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', 1, 'M1')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get1couponid &", '"&userid&"',m.coupontype,m.couponvalue,m.couponname,m.minbuyprice,m.targetitemlist,m.startdate,m.expiredate,m.couponmeaipprice,m.validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	left join [db_user].[dbo].tbl_user_coupon uc" + vbcrlf
		sqlstr = sqlstr & " 		on m.idx=uc.masteridx" + vbcrlf
		sqlstr = sqlstr & " 		and uc.deleteyn='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.isusing='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.userid='"&userid&"'" + vbcrlf		
		sqlstr = sqlstr & " 	where m.idx="& get1couponid &" and uc.masteridx is null"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	end if
	
	if coupongubun="3" or coupongubun="all" then
		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '1' and sub_opt2 = '3') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', 3, 'M3')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr		
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get3couponid &", '"&userid&"',m.coupontype,m.couponvalue,m.couponname,m.minbuyprice,m.targetitemlist,m.startdate,m.expiredate,m.couponmeaipprice,m.validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	left join [db_user].[dbo].tbl_user_coupon uc" + vbcrlf
		sqlstr = sqlstr & " 		on m.idx=uc.masteridx" + vbcrlf
		sqlstr = sqlstr & " 		and uc.deleteyn='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.isusing='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.userid='"&userid&"'" + vbcrlf		
		sqlstr = sqlstr & " 	where m.idx="& get3couponid &" and uc.masteridx is null"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	end if
	
	if coupongubun="7" or coupongubun="all" then
		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '1' and sub_opt2 = '7') " + vbcrlf
		sqlstr = sqlstr & " BEGIN" + vbcrlf
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', 7, 'M7')" + vbcrlf
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr		
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT "& get7couponid &", '"&userid&"',m.coupontype,m.couponvalue,m.couponname,m.minbuyprice,m.targetitemlist,m.startdate,m.expiredate,m.couponmeaipprice,m.validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	left join [db_user].[dbo].tbl_user_coupon uc" + vbcrlf
		sqlstr = sqlstr & " 		on m.idx=uc.masteridx" + vbcrlf
		sqlstr = sqlstr & " 		and uc.deleteyn='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.isusing='N'" + vbcrlf
		sqlstr = sqlstr & " 		and uc.userid='"&userid&"'" + vbcrlf		
		sqlstr = sqlstr & " 	where m.idx="& get7couponid &" and uc.masteridx is null"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
	end if

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCodelink&"'</script>"
	dbget.close() : Response.End
	
'elseif mode="couponnewinsert" then
'	'//참여여부체크
'	subscriptcount = getevent_subscriptexistscount(eCode, userid, "2", "", "")
'	if subscriptcount>0 then
'		Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
'	eventnewexists=getnewuser(userid)
'	if not(eventnewexists) then
'		Response.Write "<script type='text/javascript'>alert('쿠폰 다운로드 대상자가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if	
'	'//쿠폰이 발급되었는지 체크
'	couponnewcount = getbonuscouponexistscount(userid, getnewcouponid, "", "", "")
'	if couponnewcount>0 then
'		Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
'
'	sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "' and sub_opt1 = '2') " + vbcrlf
'	sqlstr = sqlstr & " BEGIN" + vbcrlf
'	sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
'	sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', 0, 'M4000')" + vbcrlf
'	sqlstr = sqlstr & " END"
'	'response.write sqlstr & "<Br>"
'	dbget.execute sqlstr
'	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
'	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
'	sqlstr = sqlstr & " 	SELECT "& getnewcouponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
'	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
'	sqlstr = sqlstr & " 	where idx="& getnewcouponid &""
'	'response.write sqlstr & "<Br>"
'	dbget.execute sqlstr
'
'	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCodelink&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
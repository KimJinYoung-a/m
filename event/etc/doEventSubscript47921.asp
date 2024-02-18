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
' Description :  QR 코드 찍고 응답하라1994 공식MD받자 
' History : 2013.12.24 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event47921Cls.asp" -->

<%
dim eCode, userid, mode, arrwinox, k, tmpcount, tmpcouponcount, winox, sqlstr, giftcount
dim giftmax, couponcount, couponmax, bonuscouponcount
	eCode   =  getevt_code
	mode = requestcheckvar(request("mode"),32)

arrwinox=""
winox=""
bonuscouponcount=0
couponmax=0
couponcount=0
tmpcount=0
tmpcouponcount=0
giftcount=0
giftmax=0
userid = GetLoginUserID()

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2013-12-26" and getnowdate<"2014-02-01") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="evtinsert" then

	'//참여여부체크
	tmpcount = getexistscount(eCode, GetLoginUserID(), "")
	if tmpcount>0 then
		Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'//쿠폰이 발급되었는지 체크
	tmpcouponcount = getbonuscouponcount(userid)
	if tmpcouponcount>0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	arrwinox  = Array("1","2","2","3","3","3","3","3","3","3")		'사은품10% / 쿠폰1만원 20% / 쿠폰4천원 꽝일경우 전원다
	Randomize
	k = Int(10 * Rnd)
	winox = arrwinox(k)

	'//사은품 당첨 200명
	if winox="1" then
		'//현재 당첨자 수량
		giftcount=gettotalcount(eCode, "1")
		'//최대 수량 200개
		giftmax=getgiftmax
		'//당첨자 200명 마감. 쿠폰4천원 짜리로 발행
		if giftcount>=giftmax then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '3', '', '4000')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
					
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& get4000couponid &""
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
	
			Response.Write "<script type='text/javascript'>parent.$('.winCheck').hide(); parent.$('.winResult4000coupon').show();</script>"
			dbget.close() : Response.End
		
		'/사은품 당첨
		else
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', '', 'gift')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr

			Response.Write "<script type='text/javascript'>parent.$('.winCheck').hide(); parent.$('.winResult').show();</script>"
			dbget.close() : Response.End
		end if

	'/쿠폰1만원 당첨 10명
	elseif winox="2" then
		'//현재 당첨자 수량
		couponcount=gettotalcount(eCode, "2")
		bonuscouponcount=getbonuscoupontotalcount(get10000couponid)
		'//최대 수량 10개
		couponmax=getcouponmax

		'//당첨자 10명 마감. 쿠폰4천원 짜리로 발행
		if couponcount>=couponmax or bonuscouponcount>=couponmax then
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '3', '', '4000')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
					
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& get4000couponid &""
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
	
			Response.Write "<script type='text/javascript'>parent.$('.winCheck').hide(); parent.$('.winResult4000coupon').show();</script>"
			dbget.close() : Response.End
		
		'//쿠폰 1만원권 발행
		else
			sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "') "
			sqlstr = sqlstr & " BEGIN"
			sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
			sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', '', '10000')"
			sqlstr = sqlstr & " END"
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
					
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& get10000couponid &""
			'response.write sqlstr & "<Br>"
			dbget.execute sqlstr
	
			Response.Write "<script type='text/javascript'>parent.$('.winCheck').hide(); parent.$('.winResult10000coupon').show();</script>"
			dbget.close() : Response.End
		
		end if			

	'//꽝 쿠폰4천원
	else
		sqlstr = "IF NOT EXISTS(select sub_idx from [db_event].[dbo].[tbl_event_subscript] where evt_code = "& eCode &" and userid = '" & userid & "') "
		sqlstr = sqlstr & " BEGIN"
		sqlstr = sqlstr & " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)"
		sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '3', '', '4000')"
		sqlstr = sqlstr & " END"
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr
				
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx="& get4000couponid &""
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>parent.$('.winCheck').hide(); parent.$('.winResult4000coupon').show();</script>"
		dbget.close() : Response.End
	end if
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
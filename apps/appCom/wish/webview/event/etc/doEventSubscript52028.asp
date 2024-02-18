<%@ language=vbscript %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  5월, MAY I HELP YOU
' History : 2014.05.22 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event52028Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, userid, sqlstr, mode
dim couponcount4000, couponcountfree, couponcount10000
	eCode   =  getevt_code
	mode = requestcheckvar(request("mode"),32)
	
Couponcount4000 = 0
couponcountfree = 0
couponcount10000 = 0
userid = getloginuserid()

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-05-26" and getnowdate<"2014-06-02") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
End IF

if mode="coupon4000" then
	'//쿠폰이 발급되었는지 체크
	Couponcount4000 = getbonuscouponexistscount(userid, getcouponid4000, "", "", "")
	if Couponcount4000>0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
		dbget.close() : Response.End
	end if

	sqlstr = " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '1', 0, '4000', 'A')" + vbcrlf
	dbget.execute sqlstr
	
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
	sqlstr = sqlstr & " 	SELECT "& getcouponid4000 &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& getcouponid4000 &""
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End

elseif mode="couponfree" then
	'//쿠폰이 발급되었는지 체크
	couponcountfree = getbonuscouponexistscount(userid, getcouponidfree, "", "", "")
	if couponcountfree>0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
		dbget.close() : Response.End
	end if

	sqlstr = " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '2', 0, 'free', 'A')" + vbcrlf
	dbget.execute sqlstr
	
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
	sqlstr = sqlstr & " 	SELECT "& getcouponidfree &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& getcouponidfree &""
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
	
elseif mode="coupon10000" then
	'//쿠폰이 발급되었는지 체크
	couponcount10000 = getbonuscouponexistscount(userid, getcouponid10000, "", "", "")
	if couponcount10000>0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰이 이미 발급되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
		dbget.close() : Response.End
	end if

	sqlstr = " 	INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " 	VALUES("& eCode &", '" & userid & "', '3', 0, '10000', 'A')" + vbcrlf
	dbget.execute sqlstr
	
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename) " + vbcrlf
	sqlstr = sqlstr & " 	SELECT "& getcouponid10000 &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename " + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& getcouponid10000 &""
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다! \n발급된 쿠폰은 마이텐바이텐 에서\n확인 가능합니다!'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"';</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
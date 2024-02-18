<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 0원의 기적
' History : 2015.02.09 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event59405Cls.asp" -->

<%
dim eCode, userid, subscriptcount, totalsubscriptcount, bonuscouponcount, totalbonuscouponcount, limitbounscoupon, sqlstr, mode
	mode = requestcheckvar(request("mode"),32)
	eCode   = getevt_code
	userid = getloginuserid()

subscriptcount = 0
bonuscouponcount = 0
totalsubscriptcount = 0
totalbonuscouponcount = 0
limitbounscoupon = 0

limitbounscoupon=datecouponlimit(left(currenttime,10))

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
	dbget.close() : Response.End
End IF

If not( left(currenttime,10)>="2015-02-10" and left(currenttime,10)<"2015-02-18" ) Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
	dbget.close() : Response.End
End IF

if mode="iteminsert" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, datecouponval(), "", "", "")
	if subscriptcount>0 or bonuscouponcount>0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 한 번만 응모하실 수 있습니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	end if

	'//전체 참여수
	totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "", "")
	totalbonuscouponcount = getbonuscoupontotalcount(datecouponval(), "", "", left(currenttime,10))
	if totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then
		Response.Write "<script type='text/javascript'>alert('앗, 오늘의 쿠폰이 모두 소진되었어요!'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	end if

	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	end if

	if dateopenyn(currenttime)<>"Y" then
		Response.Write "<script type='text/javascript'>alert('오늘의 0원의 기적은 아직 오픈전입니다!'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 		SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,'"& left(currenttime,10) &" 23:59:59',couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 		from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 		where idx="& datecouponval() &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급되었습니다!');</script>"
	Response.Write "<script type='text/javaScript'>parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'; location.href ='about:blank';</script>"
	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&getevt_codeprint&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
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
' Description : 결정해줘 app쿠폰
' History : 2014.11.03 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event56092Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

	bonuscouponcount=0
	subscriptcount=0
	totalsubscriptcount=0
	totalbonuscouponcount=0
	smssubscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(left(currenttime,10)>="2014-11-04" and left(currenttime,10)<"2014-11-06") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="couponreg" then
	if not(geteventisusingyn) then
		Response.Write "<script type='text/javascript'>alert('종료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if		

	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "2", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")

	'//전체 참여수
	totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "2", "")
	'//전체 쿠폰 발행수량
	totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", left(currenttime,10))

	'//본인 참여 여부
	if subscriptcount <> 0 or bonuscouponcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'/쿠폰 제한수량
	if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then
		Response.Write "<script type='text/javascript'>alert('종료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	if Hour(currenttime) < 09 then
		Response.Write "<script type='text/javascript'>alert('쿠폰은 오전 9시부터 다운 받으실수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if	
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(currenttime,10) &"', 2, '', 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& getbonuscoupon &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다. 오늘하루 app에서 사용하세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
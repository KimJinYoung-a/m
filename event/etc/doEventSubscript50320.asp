<%@ language=vbscript %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [무임승차이벤트]텐바이텐 배송 트럭을 잡아라! 
' History : 2014.03.20 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event50320Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)

dim totalsubscriptcount, totalcouponcount, subscriptcount, couponcount
	totalsubscriptcount=0
	totalcouponcount=0
	subscriptcount = 0
	couponcount = 0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

'Response.Write "<script type='text/javascript'>alert('오늘의 무임 승차권이 모두 발급 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'dbget.close() : Response.End

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-03-24" and getnowdate<"2014-03-27") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="couponinsert" then
	
	'//총참여여부 체크
	totalsubscriptcount = getevent_subscripttotalcount(eCode, getnowdate(), "", "")
	if totalsubscriptcount>maxcouponcount then
		Response.Write "<script type='text/javascript'>alert('오늘의 무임 승차권이 모두 발급 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	totalcouponcount = getbonuscoupontotalcount(getcouponid, "", "", getnowdate())
	if totalcouponcount>maxcouponcount then
		Response.Write "<script type='text/javascript'>alert('오늘의 무임 승차권이 모두 발급 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'//쿠폰이 발급되었는지 체크
	subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate(), "", "")
	if subscriptcount>0 then
		Response.Write "<script type='text/javascript'>alert('이미 다운 받으셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	'//쿠폰이 발급되었는지 체크
	couponcount = getevent_subscriptexistscount(eCode, userid, getnowdate(), "", "")
	if couponcount>0 then
		Response.Write "<script type='text/javascript'>alert('이미 다운 받으셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate() &"', 0, 'M')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename,reguserid) " + vbcrlf
	sqlstr = sqlstr & " 	SELECT "& getcouponid &", '"&userid&"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename,'SYSTEM' " + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& getcouponid &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('승차권이 발급되었습니다.\n상품 구매시 배송비가 무료 입니다.\n(텐바이텐 배송 상품만 적용)'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ language=vbscript %>
<% Option Explicit %>
<%
'####################################################
' Description : 기승전쇼핑_빼주세요, APP 쿠폰
' History : 2014.09.02 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event54762Cls.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
dim currentcouponid, eCodepage
	eCode	=	getevt_code
	eCodepage = getevt_codepage
	userid	=	getloginuserid()
	mode	=	requestcheckvar(request("mode"),32)

	subscriptcount=0
	bonuscouponcount=0
	smssubscriptcount=0
	totalsubscriptcount=0
	totalbonuscouponcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-09-10" and getnowdate<"2014-09-13") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
	dbget.close() : Response.End
End IF

if mode="addsms" then
	smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")

	if smssubscriptcount > 3 then
		Response.Write "<script type='text/javascript'>alert('메세지는 3회까지 발송 가능 합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_sms].[ismsuser].em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg)" & vbcrlf
	sqlstr = sqlstr & " 	select top 1 n.usercell, '1644-6030', '1', getdate(), '[텐바이텐]기승전쇼핑_앱쿠폰 '" & vbcrlf
	sqlstr = sqlstr & " 	from db_user.dbo.tbl_user_n n" & vbcrlf
	sqlstr = sqlstr & " 	where userid='"& userid &"'"
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
			
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 1, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('메세지가 발송 되었습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
	dbget.close() : Response.End

elseif mode="couponreg" then
	if not(geteventisusingyn) then
		Response.Write "<script type='text/javascript'>alert('이벤트가 종료 되었습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
		dbget.close() : Response.End
	end if
	
	if getnowdate="2014-09-10" then
		currentcouponid=getbonuscoupon15pro
	elseif getnowdate="2014-09-11" then
		currentcouponid=getbonuscoupon5000
	elseif getnowdate="2014-09-12" then
		currentcouponid=getbonuscoupon10000
	end if
	
	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, currentcouponid, "", "", "")

	'//본인 참여 여부
	if subscriptcount <> 0 or bonuscouponcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('쿠폰은 한 개의 아이디당 하루 한 번만 다운 받으실 수 있습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& getnowdate &"', '', '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,getdate(),dateadd(hh,+24,getdate()),couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx="& currentcouponid &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	if getnowdate="2014-09-10" then
		response.write "01"
	elseif getnowdate="2014-09-11" then
		response.write "02"
	elseif getnowdate="2014-09-12" then
		response.write "03"
	else
		response.write ""	
	end if		
	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&eCodepage&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
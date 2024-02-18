<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : [13주년] 즐겨라,텐바이텐_ 게릴라! 앱 쇼 
' History : 2014.10.02 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/13th/03/event55082Cls.asp" -->

<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.23"></script>

<%
dim userid, subscriptcount, totalsubscriptcount, bonuscouponcount, totalbonuscouponcount, sqlstr, mode, eCode
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	eCode   = getevt_code

subscriptcount = 0
totalsubscriptcount = 0
bonuscouponcount = 0
totalbonuscouponcount = 0

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
	dbget.close() : Response.End
End IF

If not( left(currenttime,10)>="2014-10-06" and left(currenttime,10)<"2014-10-21" ) Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
	dbget.close() : Response.End
End IF

if mode="iteminsert" then
	If left(currenttime,10)="2014-10-11" or left(currenttime,10)="2014-10-12" or left(currenttime,10)="2014-10-18" or left(currenttime,10)="2014-10-19" Then
		Response.Write "<script type='text/javascript'>alert('주말에는 참여 하실수 없습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
		dbget.close() : Response.End
	End IF

	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, datecouponval(left(currenttime,10)), "", "", left(currenttime,10))	
	if subscriptcount>0 or bonuscouponcount>0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 하루 한 번만 응모하실 수 있습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
		dbget.close() : Response.End
	end if

	totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "", "")
	totalbonuscouponcount = getbonuscoupontotalcount(datecouponval(left(currenttime,10)), "", "", left(currenttime,10))
	if totalsubscriptcount>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then
		Response.Write "<script type='text/javascript'>alert('오늘의 상품이 전부 소진되었습니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
		dbget.close() : Response.End
	end if

	if dateopenyn(currenttime)<>"Y" then
		Response.Write "<script type='text/javascript'>alert('오늘의 앱쇼는 아직 오픈 전입니다.\n9시~12시 사이에 랜덤으로 오픈됩니다.\n앱쇼를 기다려주세요!'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
		dbget.close() : Response.End
	end if

	if staffconfirm and GetLoginUserLevel()=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 		SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 		from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 		where idx="& datecouponval(left(currenttime,10)) &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급되었습니다!\n바로 상품 페이지로 이동합니다.\n결제시 꼭 게릴라 쿠폰을 사용하세요!');</script>"
	'Response.Write "<script type='text/javaScript'>parent.location.href='/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid="&dateitemval(left(currenttime,10)) &"'</script>"
	Response.Write "<script type='text/javaScript'>parent.pagereload('"& dateitemval(left(currenttime,10)) &"'); location.href ='about:blank';</script>"
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/web2014/event/13th/03/'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
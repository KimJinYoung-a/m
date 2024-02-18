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
' Description : 정말 빼빼로가 좋아요
' History : 2014.10.30 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56037Cls.asp" -->

<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/jquery.swiper-2.1.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.25"></script>

<%
dim eCode, userid, mode, sqlstr, refer, winox, rvalue, k
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

dim subscriptcount, totalsubscriptcountmacbook, totalsubscriptcountgiftcard, totalsubscriptcountbonuscoupon, totalbonuscouponcount
	subscriptcount=0
	totalsubscriptcountmacbook=0
	totalsubscriptcountgiftcard=0
	totalsubscriptcountbonuscoupon=0
	totalbonuscouponcount=0

'//당첨 플래그 winox 1:맥북 / 2:기프트카드 / 3:보너스쿠폰 / 5:꽝
totalsubscriptcountmacbook = getevent_subscripttotalcount(eCode, "", "1", "")
totalsubscriptcountgiftcard = getevent_subscripttotalcount(eCode, "", "2", "")
totalsubscriptcountbonuscoupon = getevent_subscripttotalcount(eCode, "", "3", "")
totalbonuscouponcount = getbonuscoupontotalcount(datecouponval, "", "", "")

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
end if

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요');</script>"
	dbget.close() : Response.End
End IF
If not(left(currenttime,10)>="2014-11-03" and left(currenttime,10)<"2014-11-10") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.');</script>"
	dbget.close() : Response.End
End IF

if mode="iteminsert" then
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End
	end if

	if subscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 하루 한 번만 응모하실 수 있습니다..');</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End
	end if

	winox=""
	'//1부터 100 까지 난수 생성
	Randomize
	k = Int(100 * Rnd)

	'//맥북 당첨
	if k >= 1 and k <= 1 then
		'//맥북 전체 참여수
		if totalsubscriptcountmacbook>=limitmacbook then
			winox=5		'//제한수량을 넘을경우 다 꽝으로 팅겨냄
		else
			winox=1
		end if
		
		'//11월 7일만 당첨되게 셋팅
		if left(currenttime,10)<>"2014-11-07" then
			winox=5
		end if
		winox=5
	'//기프트카드 당첨
	elseif k >= 31 and k <= 31 then
		'//기프트 카드 전체 참여수
		if totalsubscriptcountgiftcard>=limitgiftcard then
			winox=5		'//제한수량을 넘을경우 다 꽝으로 팅겨냄
		else
			winox=2
		end if
		winox=5
	'//보너스쿠폰 당첨
	elseif k >= 61 and k <= 90 then
		'//쿠폰 전체 참여수
		if totalsubscriptcountbonuscoupon>=limitbounscoupon or totalbonuscouponcount>=limitbounscoupon then
			winox=5		'//제한수량을 넘을경우 다 꽝으로 팅겨냄
		else
			winox=3
		end if
		'winox=5
	'//꽝
	else
		winox=5
	end if

	'//맥북 입력
	if winox="1" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 1, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('당신의 연인은 이런걸 원한다. 패키지 당첨!\n진심으로 축하드려요!\n텐바이텐 cs안내 전화를 기다려 주세요!');</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div1').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "1", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div2').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "2", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div3').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "3", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End

	'//기프트카드 입력
	elseif winox="2" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 2, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('기프트카드 3만원권 당첨!\n 기프트카드는 일괄 지급 됩니다!');</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div1').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "1", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div2').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "2", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div3').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "3", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End

	'//보너스쿠폰 발급
	elseif winox="3" then
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 3, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 		SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & " 		from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 		where idx="& datecouponval &""
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('5000원 할인! 쿠폰 당첨!\n마이텐바이텐에서 쿠폰을 확인해 주세요!\n사용기간은 11월 16일까지 입니다!');</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div1').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "1", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div2').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "2", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div3').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "3", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End

	'//꽝 입력
	else
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&left(currenttime,10)&"', 5, '', 'A')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('꽝! 이런 이런 ! 너무 속상해 마세요!\n아직 기회는 남아 있어요!\n내일 다시 도전 하세요!');</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div1').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "1", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div2').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "2", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>parent.$('#div3').html(""당첨자수 : "& getevent_subscripttotalcount(eCode, "", "3", "") &"명"")</script>"
		Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
		dbget.close() : Response.End
	end if

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.');</script>"
	Response.Write "<script type='text/javascript'>location.replace('about:blank');</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
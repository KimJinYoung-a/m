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
' Description : GS 핫딜 2차
' History : 2014.12.03 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event56701Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, rvalue, k
dim kakaotalksubscriptcount, gsshopsubscriptcount, subscriptcount, couponexistscount, totalcouponexistscount, dateitemlimitcnt, totalsubscriptcount
	mode = requestcheckvar(request("mode"),32)
	eCode=getevt_code
	userid = getloginuserid()

kakaotalksubscriptcount=0
gsshopsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0
totalcouponexistscount=0
totalsubscriptcount=0
couponexistscount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval() )

if mode="couponinsert" then
	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	If not(left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	if staffconfirm and request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
		Response.Write "<script type='text/javascript'>alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	if not (Hour(currenttime) > 11) then
		Response.Write "<script type='text/javascript'>alert('앗! 오후 12시부터 쿠폰 다운이 가능합니다. 조금만 기다려주세요.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	'//본인 참여 여부
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "coupon", "", "")
	if subscriptcount <> 0 then
		Response.Write "<script type='text/javascript'>alert('한 개의 아이디당 한 번만 다운로드 하실 수 있습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
	couponexistscount = getbonuscouponexistscount(userid, datecouponval(), "", "", "")
	if couponexistscount <> 0 then
		Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

'	'//전체 응모수
'	totalsubscriptcount=getevent_subscripttotalcount(eCode, "coupon", "", "")
'	if totalsubscriptcount>=dateitemlimitcnt then
'		Response.Write "<script type='text/javascript'>alert('죄송합니다. 핫딜 상품 쿠폰이 모두 소진되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
'
'	'//전체 상품 쿠폰 발행수량
'	totalcouponexistscount=getbonuscoupontotalcount(datecouponval(),"", "", "")
'	if totalcouponexistscount>=dateitemlimitcnt then
'		Response.Write "<script type='text/javascript'>alert('죄송합니다. 핫딜 상품 쿠폰이 모두 소진되었습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'coupon', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
			
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & "		SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & "		from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & "		where idx="& datecouponval() &""

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>alert('고객님! 쿠폰이 발급 되었습니다. 구매하러 가기를 눌러 주세요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
	
elseif mode="invitereg" then
	'If userid = "" Then
	'	Response.Write "99"
	'	dbget.close() : Response.End
	'End IF
	If not(left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05") Then
		Response.Write "02"
		dbget.close() : Response.End
	End IF

	'//카카오톡 본인 응모수
	'kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	'kakaotalksubscriptcount=0
	'if kakaotalksubscriptcount>=5 then
	'	Response.Write "03"
	'	dbget.close() : Response.End
	'end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", 'kakaotalkcounttemp', 'kakaotalk', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	response.write "01"
	dbget.close() : Response.End
	
elseif mode="gsshopreg" then
	'If userid = "" Then
	'	Response.Write "99"
	'	dbget.close() : Response.End
	'End IF
	If not(left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05") Then
		Response.Write "02"
		dbget.close() : Response.End
	End IF

	'//gsshop 본인 이동수
	'gsshopsubscriptcount = getevent_subscriptexistscount(eCode, userid, "gsshop", "", "")
	'if gsshopsubscriptcount>=10 then
	'	Response.Write "03"
	'	dbget.close() : Response.End
	'end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", 'gsshopcounttemp', 'gsshop', 0, '', 'A')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	response.write "01"
	dbget.close() : Response.End

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
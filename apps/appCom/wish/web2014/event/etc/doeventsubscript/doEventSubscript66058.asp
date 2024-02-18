<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 오! 나의 삼세판
' History : 2015-09-07 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%	
dim eCode, userid, coupon1 ,  coupon2 , strSql , sqlstr , refer , totcnt , couponnum , cnum
	cnum = requestcheckvar(request("cnum"),1)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64879"
	Else
		eCode = "66058"
	End If

	IF application("Svr_Info") = "Dev" THEN
		coupon1 = "2738"
		coupon2 = "2739"
	Else
		coupon1 = "776"
		coupon2 = "777"
	End If

	userid = getEncLoginUserID

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	'//응모 카운트 체크
	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		totcnt = rsget(0) '// 0 1 2 3
	End IF
	rsget.close
	
	Sub fnGetCoupon(v)
		If v = 1 Or v = 2 Then

			If v = 1 Then couponnum = coupon1
			If v = 2 Then couponnum = coupon2

			'// 1번쿠폰 등록 쿠폰 발행
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"', "& v &", 'A')" 
			dbget.execute sqlstr

			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'"& date() &" 00:00:00','"& date() &" 23:59:59',couponmeaipprice,validsitename" + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& couponnum &""
			dbget.execute sqlstr
		
			Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다.\n오늘 하루 텐바이텐에서 사용하세요!'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End

		ElseIf v = 3 Then

			'// 3번등록 마일리지 적립
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"', "& v &", 'A')" 
			dbget.execute sqlstr

			'// 마일리지 테이블에 넣는다.
			sqlstr = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 3000, lastupdate=getdate() Where userid='"&userid&"' "
			dbget.Execute sqlstr

			'// 마일리지 로그 테이블에 넣는다.
			sqlstr = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+3000','"&eCode&"', '오! 나의 삼세판 3000 마일리지','N') "
			dbget.Execute sqlstr
			
			response.write "<script language='javascript'>alert('마일리지가 지급되었습니다.\n마이텐바이텐에서 확인해주세요!');top.location.reload();</script>"
			dbget.close() : Response.End
		
		End If 
	End Sub
	

	If totcnt = 0 And datediff("D","2015-09-09",date()) = 0 Then '// 초기 푸시대상자
		If Cint(cnum-1) = Cint(totcnt) then
			Call fnGetCoupon(1)
		Else
			Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End If 
	ElseIf totcnt = 1 And datediff("D","2015-09-10",date()) = 0 Then '// 1개 쿠폰 받고 지정일
		If Cint(cnum-1) = Cint(totcnt) then
			Call fnGetCoupon(2)
		Else
			Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End If 
	ElseIf totcnt = 2 And datediff("D","2015-09-16",date()) = 0 Then '// 2개 쿠폰 받고 지정일
		If Cint(cnum-1) = Cint(totcnt) then
			Call fnGetCoupon(3)
		Else
			Response.Write "<script type='text/javascript'>alert('이미 쿠폰을 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End If 
	Else '// 대상자 아님
		If  totcnt = 3  then
			Response.Write "<script type='text/javascript'>alert('이미 모든 쿠폰을 받으셨습니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		Else
			Response.Write "<script type='text/javascript'>alert('이벤트 기간이 아니거나 이벤트 대상자가 아닙니다.'); parent.top.location.href='"&appUrlPath&"/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		End If 
	End If 
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 발렌타임 - 쿠폰
' History : 2016-01-27 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%	
dim eCode, userid , couponnum , fullcount
Dim coupon1 , coupon2 , sltime , eltime
dim mode, sqlstr, refer , strSql , totcnt , vDevice , todaytotcnt
Dim currenttime : currenttime = now()

	mode = requestcheckvar(request("mode"),10)

	If isapp = "1" Then 
		vDevice = "A"
	Else 
		vDevice = "M"
	End If 

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66016"
	Else
		eCode = "68749"
	End If

	IF application("Svr_Info") = "Dev" THEN
		coupon1 = "2763"
		coupon2 = "2764"
	Else
		coupon1 = "818" '오전
		coupon2 = "819" '오후
	End If

	userid = getEncLoginUserID()

	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		'Response.Write "잘못된 접속입니다."
		Response.Write "{"
		Response.write """rtcode"":""01"""
		Response.write "}"
		dbget.close() : Response.End
	end if

	If userid = "" Then
		'Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		Response.Write "{"
		Response.write """rtcode"":""02"""
		Response.write "}"
		dbget.close() : Response.End
	End If

	If not( Now() > #02/01/2016 00:00:00# and Now() < #02/03/2016 23:59:59# ) Then
		'Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		Response.Write "{"
		Response.write """rtcode"":""03"""
		Response.write "}"
		dbget.close() : Response.End
	End If

	'//응모 카운트 체크
	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		totcnt = rsget(0) '// 0 1
	End IF
	rsget.close


Sub fnGetCoupon()
	If hour(now()) < 13 Then
		couponnum = coupon1
		sltime = " 09:00:00"
		eltime = " 11:59:59"
	Else
		couponnum = coupon2
		sltime = " 21:00:00"
		eltime = " 23:59:59"
	End If
	
	'//쿠폰다운 응모 카운트
	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and datediff(day,regdate,getdate()) = 0 and sub_opt2 = '"&couponnum&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		todaytotcnt = rsget(0) '// 0 1
	End IF
	rsget.close

	If hour(now()) >= 21 Then
		fullcount = 6000
	Else
		fullcount = 3000
	End If

	If todaytotcnt < fullcount then
		'//등록 쿠폰 발행
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"', "&couponnum&" , '"&vDevice&"')" 
		dbget.execute sqlstr

		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'"&Date()&sltime&"','"&Date()&eltime&"',couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx in ("& couponnum &")"
		dbget.execute sqlstr

		'Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다 MY10x10에서 확인 해주세요.');</script>"
		Response.Write "{"
		Response.write """rtcode"":""11"""
		Response.write "}"
		dbget.close() : Response.End
	Else
		Response.Write "{"
		Response.write """rtcode"":""07"""
		Response.write "}"
		dbget.close() : Response.End
	End If 
End Sub

if mode="coupon" then
	
	If totcnt = 0 Then
		If (hour(now()) >= 9 And hour(now()) <= 11) Or (hour(now()) >= 21 And hour(now()) <= 23) Then
			Call fnGetCoupon()
		Else
			Response.Write "{"
			Response.write """rtcode"":""06"""
			Response.write "}"
			dbget.close() : Response.End
		End If 
	Else
		'Response.Write "<script type='text/javascript'>alert('ID 당 1회만 다운받을 수 있습니다.');</script>"
		Response.Write "{"
		Response.write """rtcode"":""04"""
		Response.write "}"
		dbget.close() : Response.End
	End If 
else
	'Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	Response.Write "{"
	Response.write """rtcode"":""01"""
	Response.write "}"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
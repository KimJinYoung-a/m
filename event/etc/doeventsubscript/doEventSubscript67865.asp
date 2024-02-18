<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 해피 두개다 (쿠폰 이벤트)
' History : 2015-12-02 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%	
dim eCode, userid , couponnum
Dim coupon1 , coupon2
dim mode, sqlstr, refer , strSql , totcnt , vDevice
Dim currenttime : currenttime = now()

	mode = requestcheckvar(request("mode"),10)

	If isapp = "1" Then 
		vDevice = "A"
	Else 
		vDevice = "M"
	End If 

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65966"
	Else
		eCode = "67865"
	End If

	IF application("Svr_Info") = "Dev" THEN
		coupon1 = "2752"
		coupon2 = "2753"
	Else
		coupon1 = "801"
		coupon2 = "802"
	End If

	userid = getEncLoginUserID()

	refer = request.ServerVariables("HTTP_REFERER")

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If userid = "" Then
		Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	If not( left(currenttime,10) >= "2015-12-07" and left(currenttime,10) <= "2015-12-08" ) Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	'//응모 카운트 체크
	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		totcnt = rsget(0) '// 0 1
	End IF
	rsget.close


Sub fnGetCoupon()

	couponnum = coupon1 &","& coupon2

	'// 1번쿠폰 등록 쿠폰 발행
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"', '"&vDevice&"')" 
	dbget.execute sqlstr

	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
	sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'2015-12-07 00:00:00','2015-12-08 23:59:59',couponmeaipprice,validsitename" + vbcrlf
	sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
	sqlstr = sqlstr & " 	where idx in ("& couponnum &")"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('쿠폰이 발급 되었습니다 MY10x10에서 확인 해주세요.');</script>"
	dbget.close() : Response.End
End Sub

if mode="coupon" then
	
	If totcnt = 0 Then
		Call fnGetCoupon()
	Else
		Response.Write "<script type='text/javascript'>alert('ID 당 1회만 다운받을 수 있습니다.');</script>"
		dbget.close() : Response.End
	End If 
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
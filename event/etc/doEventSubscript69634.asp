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
' Description : 깨긋한 산소방
' History : 2016.03.11 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim mode, referer,refip, apgubun
	mode = requestcheckvar(request("mode"),32)
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66063"
	Else
		eCode = "69634"
	End If

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "830"
	Else
		couponidx = "830"
	End If

'// 모바일웹&앱전용
If isApp="1" Then
	apgubun = "A"
Else
	apgubun = "M"
End If

'apgubun = "W"

Dim vPrvOrderCnt, vPrvOrderSumPrice, vEvtOrderCnt, vEvtOrderSumPrice, vMyThisEvtCnt, vMyThisCouponCnt, sqlstr, vQuery
'//이전 구매 내역 체킹 (1월 1일부터 3월 13일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-01-01', '2016-03-14', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vPrvOrderCnt = rsget("cnt")
	vPrvOrderSumPrice   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
'	vPrvOrderCnt = 0
'	vPrvOrderSumPrice   = 0
rsget.Close


'// 이벤트 기간 구매 내역 체킹(3월 14일부터 3월 20일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-03-14', '2016-03-21', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vEvtOrderCnt = rsget("cnt")
	vEvtOrderSumPrice   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
'	vEvtOrderCnt = 1
'	vEvtOrderSumPrice   = 1000
rsget.Close

' 현재 이벤트 본인 참여수
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt3='event' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vMyThisEvtCnt = rsget(0)
End IF
rsget.close

' 현재 이벤트 본인 쿠폰발급여부
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt3='coupon' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vMyThisCouponCnt = rsget(0)
End IF
rsget.close



if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
end If

If not( left(now(),10)>="2016-03-14" and left(now(),10)<"2016-03-21" ) Then
	Response.Write "Err|이벤트 응모기간이 아닙니다."
	dbget.close() : Response.End
End IF

'// 3월 11일만 오전 10시부터 응모 가능함 그다음은 0시부터 응모가능
If Left(now(), 10) = "2016-03-14" Then
	If Not(TimeSerial(Hour(now()), minute(now()), second(now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(now()), minute(now()), second(now())) < TimeSerial(23, 59, 59)) Then
		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
		dbget.close() : Response.End
	End If
End If

if mode="coupon" then
	If userid = "" Then
		Response.Write "Err|로그인을 해야>?n쿠폰을 발급받으실 수 있습니다."
		dbget.close() : Response.End
	End If

	'// 쿠폰 발급
	If vMyThisCouponCnt > 0 Then
		'// 쿠폰을 발급받았으면..
		Response.Write "Err|쿠폰을 이미 다운받으셨습니다."
		dbget.close() : Response.End
	Else
		'// 이벤트 내역을 남긴다.
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(now(),10) &"', 1, 'coupon', '"&apgubun&"')" + vbcrlf
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '깨끗한 산소방 쿠폰발급', '"&apgubun&"')"
		dbget.execute sqlstr

		'// 쿠폰을 발급한다.
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
		sqlstr = sqlstr & " values('" &couponidx &"','"& userid &"','2','5000','깨끗한산소방(5천원)','30000','"& Left(now(), 10) &"','2016-03-20 23:59:59','',0,'system')"
		dbget.execute sqlstr

		Response.Write "OK|쿠폰이 발급되었습니다."
		dbget.close() : Response.End
	End If

ElseIf mode="ins" Then
	If userid = "" Then
		Response.Write "Err|로그인을 해야>?n이벤트에 응모하실 수 있습니다."
		dbget.close() : Response.End
	End If


	If vMyThisEvtCnt > 0 Then
		Response.Write "Err|이미 응모가 완료되었습니다."
		dbget.close() : Response.End	
	End If


	'// 두개다 구매내역이 있을경우엔 응모시킴	
	If vPrvOrderCnt > 0 And vEvtOrderCnt > 0 Then
		'// 이벤트 내역을 남긴다.
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(now(),10) &"', 1, 'event', '"&apgubun&"')" + vbcrlf
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '깨끗한 산소방 이벤트응모', '"&apgubun&"')"
		dbget.execute sqlstr

		Response.Write "OK|응모가 완료되었습니다.>?n당첨자 발표는 3월28일 입니다!"
		dbget.close() : Response.End
	Else
		Response.Write "Err|이전 구매내역과 이벤트 기간동안에 구매내역이>?n있어야지만 응모가 가능합니다."
		dbget.close() : Response.End
	End If

ElseIf mode="orderchk" Then
	If userid = "" Then
		Response.Write "Err|로그인을 해야>?n확인하실 수 있습니다."
		dbget.close() : Response.End
	End If

	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2016-01-01', '2016-03-14', '10x10', '', 'issue' "
	'response.write sqlStr & "<br>"
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		If rsget("cnt") > 0 Then
			Response.Write "OK|"&rsget("cnt")&"|"&FormatNumber(CHKIIF(isNull(rsget("tsum")),0,rsget("tsum")), 0)
			dbget.close() : Response.End
		Else
			Response.Write "OK|0|0"
			dbget.close() : Response.End
		End If
	rsget.Close

Else
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
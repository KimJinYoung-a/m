<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 텐바이텐과 함께하는 <직접 골라방>(쿠폰)
' History : 2015-12-04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid, deviceGubun, snsGubun
Dim vQuery, strsql
Dim result1, result2, result3
Dim evtUserCell, refer, refip
Dim vHiter, vGlassBottle, vTumblr1, vTumblr2, couponCode
Dim vHiterSt, vHiterEd, vGlassBottleSt, vGlassBottleEd, vTumblr1St, vTumblr1Ed, vTumblr2St, vTumblr2Ed, vQueryCheck, imgLoop, imgLoopVal
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	snsGubun = requestcheckvar(request("snsGubun"),32)
	userid = GetEncLoginUserID

	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65975"
	Else
		eCode = "67773"
	End If

	IF application("Svr_Info") = "Dev" THEN
		couponCode = "799"
	Else
		couponCode = "799"
	End If



	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(Now(),10)>="2015-12-07" and left(Now(),10)<"2015-12-14") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// 응모내역 검색
	sqlstr = "select count(userid) "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

	If rsget(0) > 0 Then
		Response.Write "Err|이미 쿠폰을 발급받으셨습니다."
		response.End
	End If
	rsget.close

	'// 등록 쿠폰 발행
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"', '"&deviceGubun&"')" 
	dbget.execute sqlstr

	'// 쿠폰 넣어준다.
	sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid) " & _
			 "values('"& couponCode &"', '" & userid & "', '2','5000','직방쿠폰 5,000원-3만원이상','30000','2015-12-07 00:00:00','2015-12-13 23:59:59','',0,'system')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '직방경유쿠폰발급', '"&deviceGubun&"')"
	dbget.execute sqlstr

	Response.Write "OK|쿠폰이 발급되었습니다.>?n12월 13일 까지 사용해주세요!"
	response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
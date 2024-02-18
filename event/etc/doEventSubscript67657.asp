<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 주말데이트(앨리스:원더랜드에서 온 소녀)
' History : 2015.11.26 원승현
'###########################################################
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
Dim vHiter, vGlassBottle, vTumblr1, vTumblr2
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
		eCode 		= "65962"
	Else
		eCode 		= "67657"
	End If



	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(Now(),10)>="2015-11-26" and left(Now(),10)<"2015-11-30") Then
	'If not(left(Now(),10)>="2015-11-19" and left(Now(),10)<"2015-11-28") Then
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
		Response.Write "Err|이미 응모 되었습니다.>?n11월 30일 당첨자 발표를 기다려주세요!"
		response.End
	End If
	rsget.close


	'// 응모 저장
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , regdate, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', getdate(), '"&deviceGubun&"')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '주말데이트(앨리스)응모', '"&deviceGubun&"')"
	dbget.execute sqlstr

	Response.Write "OK|응모 되었습니다.>?n11월 30일 당첨자 발표를 기다려주세요!"
	response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 선물포장 이벤트 i 선물 u
' History : 2015.12.10 원승현
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
		eCode 		= "65980"
	Else
		eCode 		= "68034"
	End If



	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(Now(),10)>="2015-12-10" and left(Now(),10)<"2016-01-01") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// 선물포장 신청 총 카운트
	sqlstr = "Select count(sub_idx) as cnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' "
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
	If rsget(0) >= 100 Then
		Response.Write "Err|마일리지 페이백이 종료되었습니다."
		response.End
	End If
	rsget.Close	


	'// 응모내역 검색
	sqlstr = "select count(userid) "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

	If rsget(0) > 0 Then
		Response.Write "Err|마일리지 페이백 신청은 1회만 가능합니다."
		response.End
	End If
	rsget.close

	'// 선물포장 서비스 신청자만 응모가능함.
	sqlstr = " select count(distinct m.userid) "
	sqlstr = sqlstr & " from db_order.dbo.tbl_order_master as m "
	sqlstr = sqlstr & " inner join db_order.dbo.tbl_order_detail as d "
	sqlstr = sqlstr & " on m.orderserial=d.orderserial "
	sqlstr = sqlstr & " where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' "
	sqlstr = sqlstr & " and d.cancelyn<>'Y' and d.itemid<>'0' "
	sqlstr = sqlstr & " and m.regdate >= '2015-12-14' And ordersheetyn='P' And m.userid='"&userid&"' "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	If rsget(0) < 1 Then
		Response.Write "Err|선물포장 서비스를 이용하셔야 신청하실 수 있습니다."
		response.End
	End If
	rsget.close


	'// 응모 저장
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , regdate, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', getdate(), '"&deviceGubun&"')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '선물포장마일리지페이백신청', '"&deviceGubun&"')"
	dbget.execute sqlstr

	Response.Write "OK|2,000 마일리지 페이백이 신청되었습니다."
	response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
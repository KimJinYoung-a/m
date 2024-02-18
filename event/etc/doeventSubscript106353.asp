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
' Description : 19주년 구매사은품
' History : 2020-10-16 원승현
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
Dim vEvtOrderCnt, vEvtOrderSumPrice, vMyThisEvtCnt, vMyThisCouponCnt, sqlstr, vQuery
IF application("Svr_Info") = "Dev" THEN
	eCode   =  103242
Else
	eCode   =  106353
End If

userid = GetEncLoginUserID()

'// 모바일웹&앱전용
If isApp="1" Then
	apgubun = "A"
Else
	apgubun = "M"
End If

'apgubun = "W"

'// 이벤트 기간 구매 내역 체킹(10월 5일부터 10월 29일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM_19THEVENT] '" & userid & "', '', '', '2020-10-05', '2020-10-30', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
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

if InStr(referer,"10x10.co.kr")<1 then
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
end If

If not( left(now(),10)>="2020-10-19" and left(now(),10)<"2020-10-30" ) Then
	Response.Write "Err|이벤트 신청기간이 아닙니다."
	dbget.close() : Response.End
End IF

'// 3월 11일만 오전 10시부터 응모 가능함 그다음은 0시부터 응모가능
'If Left(now(), 10) = "2016-03-14" Then
'	If Not(TimeSerial(Hour(now()), minute(now()), second(now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(now()), minute(now()), second(now())) < TimeSerial(23, 59, 59)) Then
'		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
'		dbget.close() : Response.End
'	End If
'End If

If mode="ins" Then
	If userid = "" Then
		Response.Write "Err|로그인을 해야>?n신청 하실 수 있습니다."
		dbget.close() : Response.End
	End If

	If vMyThisEvtCnt > 0 Then
		Response.Write "Err|이미 응모가 완료되었습니다."
		dbget.close() : Response.End	
	End If

	'// 기간내 구매횟수 3회 이상, 구매금액 15만원 이상일 경우만 응모가능
	If vEvtOrderCnt >= 3 And vEvtOrderSumPrice >= 150000 Then
		'// 이벤트 내역을 남긴다.
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& left(now(),10) &"', 1, 'event', '"&apgubun&"')" + vbcrlf
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '19주년 구매사은 이벤트', '"&apgubun&"')"
		dbget.execute sqlstr

		Response.Write "OK|신청이 완료 되었습니다.>?n마일리지는 11월 9일에 지급 될 예정입니다."
		dbget.close() : Response.End
	Else
		Response.Write "Err|신청조건에 맞지 않습니다."
		dbget.close() : Response.End
	End If
Else
	Response.Write "Err|잘못된 접속입니다."
	dbget.close() : Response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
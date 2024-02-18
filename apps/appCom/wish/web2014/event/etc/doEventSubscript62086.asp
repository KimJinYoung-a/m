<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 디스카운트 전(메인)
' History : 2015.05.11 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim eCode, vDisp, sqlstr
	Dim nowdate, refip, refer, renloop
	Dim LoginUserid
	Dim DayRightNumber, vEuserInputCode, result1, result2, result3, mode, md5userid, evtUserCell, vQuery, j, proCode,  inviteChk, vSub_opt2, vSub_opt3

	nowDate = Left(Now(), 10)
'	nowDate = "2015-05-13"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	inviteChk = False


	IF application("Svr_Info") = "Dev" THEN
		eCode = "61785"
	Else
		eCode = "62086"
	End If


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(nowdate,10)>="2015-05-13" and left(nowdate,10)<"2015-05-30") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 주말에는 응모 안됨
	If Left(nowdate, 10)="2015-05-16" Or Left(nowdate, 10)="2015-05-17" Then
		Response.Write "Err|주말에는 이벤트가 진행되지 않습니다."
		Response.End
	End If


	'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
	If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// STAFF 여부 체크
'	if request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
'		Response.write "Err|스태프는 참여하실 수 없습니다."
'		dbget.close() : Response.End
'	end If

'// 초대내역 확인
sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " where evt_code="& eCode &""
sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
rsget.Open sqlstr, dbget, 1
If Not rsget.Eof Then
	inviteChk = True
	vSub_opt2 = rsget("sub_opt2")
	vSub_opt3 = rsget("sub_opt3")
Else
	inviteChk = False
End If
rsget.close

If Trim(mode) = "inviteFriend" Then
	If inviteChk Then
		'// 로그 넣음
		vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
		vQuery = vQuery & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '카카오 초대 "&vSub_opt2+1&"회 클릭', 'A')"
		dbget.execute vQuery

		'// 만약 기존에 이미 친구초대한 내역이 있다면 sub_opt2 count만 늘려준다.(횟수개념)
		vQuery = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt2 = sub_opt2 + 1 " + vbcrlf
		vQuery = vQuery & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
		dbget.execute vQuery


		Response.write "OK|[텐바이텐] 디스카운트 전qq""친구야! 우리 같이q디스전 할인받자!""q친구인증번호 : "&Trim(vSub_opt3)&"qq이제 친구와 함께 같이 디스전 할인받아 보세요!qq지금 친구가 보낸 인증번호를 입력하면,q오늘의 상품을 디스전 특가로q구매할 수 있어요!qq국내! 역대! 최저가로 구매할 수 있는 유일한 찬스!!q인증번호를 입력한 여러분도 함께 혜택을 받을 수 있어요!qq지금 도전하세요!!"
	Else
		'// 로그 넣음
		vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
		vQuery = vQuery & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '카카오 초대 최초 클릭', 'A')"
		dbget.execute vQuery

		'// 최초로 친구초대 클릭시엔 insert 단 인증코드가 중복 될 수 있으니 검사해서 집어넣음
		For j=0 To 15
			proCode = random_str()
			sqlstr = "select count(*) "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &" And sub_opt3 = '"&proCode&"' "
			rsget.Open sqlstr, dbget, 1
			If rsget(0) = 0 Then
				'// 최초로 친구초대 클릭시엔 insert
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				vQuery = vQuery & " VALUES("& eCode &", '"& LoginUserid &"', 1, '"&proCode&"', getdate(), 'A')"
				dbget.execute vQuery
				rsget.close
				Exit For
			Else
				rsget.close
			End If
		Next
		Response.write "OK|[텐바이텐] 디스카운트 전qq""친구야! 우리 같이q디스전 할인받자!""q친구인증번호 : "&Trim(proCode)&"qq이제 친구와 함께 같이 디스전 할인받아 보세요!qq지금 친구가 보낸 인증번호를 입력하면,q오늘의 상품을 디스전 특가로q구매할 수 있어요!qq국내! 역대! 최저가로 구매할 수 있는 유일한 찬스!!q인증번호를 입력한 여러분도 함께 혜택을 받을 수 있어요!qq지금 도전하세요!!"
	End If
Else
	If inviteChk Then
		sqlstr = "select count(*) "
		sqlstr = sqlstr & " from [db_temp].[dbo].[tbl_disEvent]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and sendid='"& LoginUserid &"' and convert(varchar(10),receivedate,120) = '"& Left(nowdate, 10) &"' And confirmcode='"&Trim(vSub_opt3)&"' "
		rsget.Open sqlstr, dbget, 1
			If rsget(0) > 0 Then
				Response.write "OK|1"
			Else
				Response.write "OK|0"
			End If

		rsget.close
	Else
		Response.Write "Err|친구초대를 먼저 해 주세요."
		response.End
	End If

End If



Function random_str()
	Dim str, strlen, r, i, ds, serialCode '사용되는 변수를 선언

	str = "123456789" '랜덤으로 사용될 문자 또는 숫자
	strlen = 7 '랜덤으로 출력될 값의 자릿수

	Randomize '랜덤 초기화
	For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
	r = Int((9 - 1 + 1) * Rnd + 1)  ' 9은 str의 문자갯수
	serialCode = serialCode + Mid(str,r,1)
	Next
	random_str = serialCode
 End Function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
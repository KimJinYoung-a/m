<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016.09.12 김진영 생성
'	Description : [추석이벤트] 신데렐라
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim nowdate, daynum
Dim eCode, userid, sqlstr, vQuery, vTotalCount, k, EventTotalChk, vDevice, eventPossibleDate, TodayMaxCnt, vLogCount
userid	= GetEncLoginUserID()
nowdate	= now()
TodayMaxCnt = 5000		'하루 5천명 선착순 지급

If isApp = 1 Then
	vDevice = "A"
Else
	vDevice = "M"
End If

IF application("Svr_Info") = "Dev" THEN
	eCode = "66202"
	If Left(nowdate, 10)>="2016-09-13" and Left(nowdate, 10)<="2016-09-16" Then
		eventPossibleDate = "Y"
	Else
		eventPossibleDate = "N"
	End If
Else
	eCode = "73145"
	If Left(nowdate, 10)>="2016-09-14" and Left(nowdate, 10)<="2016-09-16" Then
		eventPossibleDate = "Y"
	Else
		eventPossibleDate = "N"
	End If
End If

'// 텐바이텐 페이지를 통해 들어왔는지 확인
If InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr") < 1 Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
	response.end
End If

'// 로그인 확인
If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End If

'// expiredate
If eventPossibleDate = "N" Then
	response.write "<script language='javascript'>alert('이벤트 기간이 아닙니다.'); top.location.reload();</script>"
	Response.End
End If

'// 해당일자 12시부터 응모 가능함, 그 이전에는 응모불가
If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(12, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
	Response.Write "<script language='javascript'>alert('낮 12시에 다운이 가능합니다.'); top.location.reload();</script>"
	Response.End
End If

Select Case Left(nowdate, 10)
	Case "2016-09-14"		daynum = 1
	Case "2016-09-15"		daynum = 2
	Case "2016-09-16"		daynum = 3
	Case Else				daynum = 0
End Select

'// 해당 당일 이벤트 토탈 참여수
sqlStr = "SELECT COUNT(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
rsget.Open sqlStr, dbget, 1
	EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여수
rsget.Close
If EventTotalChk >= TodayMaxCnt Then 
	response.write "<script language='javascript'>alert('오늘 마일리지가 모두 소진되었습니다.');</script>"
	dbget.close()
    response.end
End If

'// 해당 이벤트에 참여했는지 확인(아이디당 1회만 참여할 수 있음)
vQuery = "SELECT COUNT(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close

If vTotalCount > 0 Then
	response.write "<script language='javascript'>alert('이미 마일리지를 받으셨습니다.');top.location.reload();</script>"
	dbget.close()
	response.end
End If

'마일리지로그 테이블에서 한번 더 검사
vQuery = "SELECT COUNT(*) FROM db_user.dbo.tbl_mileagelog WHERE userid = '"&userid&"' and jukyocd = '"&eCode&"' and jukyo = '신데렐라 추석 3000마일리지 지급' "
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vLogCount = rsget(0)
End IF
rsget.close

If vLogCount > 0 Then
	response.write "<script language='javascript'>alert('이미 마일리지를 받으셨습니다.');top.location.reload();</script>"
	dbget.close()
	response.end
End If

'해당 당일 이벤트 토탈 참여갯수가 5000 미만일 때 실행
If (EventTotalChk < TodayMaxCnt) AND (vLogCount < 1) AND (vTotalCount < 1) Then
	'// 마일리지 테이블에 넣는다.
	vQuery = " UPDATE [db_user].[dbo].[tbl_user_current_mileage] SET bonusmileage = bonusmileage + 3000, lastupdate = getdate() WHERE userid='"&userid&"' "
	dbget.Execute vQuery
	
	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " INSERT INTO db_user.dbo.tbl_mileagelog (userid, mileage, jukyocd, jukyo, deleteyn) VALUES ('"&userid&"', '+3000','"&eCode&"', '신데렐라 추석 3000마일리지 지급', 'N') "
	dbget.Execute vQuery
	
	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, device) VALUES ('" & eCode & "', '" & userid & "', 'x', '" & daynum & "', '" & vDevice & "')"
	dbget.Execute vQuery
	
	response.write "<script language='javascript'>alert('마일리지 지급 완료\n현금처럼 사용 가능한 마일리지!\n다음주 월요일 낮 12시전에 사용하세요!');top.location.reload();</script>"
	dbget.close()
	response.end
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
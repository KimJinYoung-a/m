<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016-11-29 이종화 생성
'	Description : [★★2016 크리스마스] 산타의 선물 
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim nowdate
Dim eCode, userid, sqlstr, vQuery, vTotalCount, k, EventTotalChk, vDevice, TodayMaxCnt, vLogCount
userid	= GetEncLoginUserID()
nowdate	= now()
TodayMaxCnt = 500		'하루 5백명 선착순 지급

Dim mode
mode = requestcheckvar(request("mode"),5)


If isApp = 1 Then
	vDevice = "A"
Else
	vDevice = "M"
End If

IF application("Svr_Info") = "Dev" THEN
	eCode = "66247"
Else
	eCode = "74320"
End If

'// 텐바이텐 페이지를 통해 들어왔는지 확인
If InStr(request.ServerVariables("HTTP_REFERER"),"10x10.co.kr") < 1 Then
	Response.Write "01||잘못된 접속입니다."
	dbget.close: Response.End
	response.end
End If

if mode="evtgo" then
	'// 로그인 확인
	If Not(IsUserLoginOK) Then
		Response.Write "02||로그인을 해주세요."
		dbget.close: response.End
	End If

	'// expiredate
	If Not(date()>="2016-12-19" and date()<"2016-12-24") Then
		Response.Write "03||이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 해당일자 12시부터 응모 가능함, 그 이전에는 응모불가
	If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(12, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
		Response.Write "05||낮 12시부터 다운이 가능합니다."
		Response.End
	End If

	'// 해당 당일 이벤트 토탈 참여수
	sqlStr = "SELECT COUNT(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여수
	rsget.Close
	If EventTotalChk >= TodayMaxCnt Then 
		response.write "06||오늘 마일리지가 모두 소진되었습니다."
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
		response.write "04||이미 마일리지를 받으셨습니다."
		dbget.close()
		response.end
	End If

	'마일리지로그 테이블에서 한번 더 검사
	vQuery = "SELECT COUNT(*) FROM db_user.dbo.tbl_mileagelog WHERE userid = '"&userid&"' and jukyocd = '"&eCode&"' and jukyo = '산타의 Gift 3000마일리지 지급' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vLogCount = rsget(0)
	End IF
	rsget.close

	If vLogCount > 0 Then
		response.write "07||이미 마일리지를 받으셨습니다."
		dbget.close()
		response.end
	End If

	'해당 당일 이벤트 토탈 참여갯수가 500 미만일 때 실행
	If (EventTotalChk < TodayMaxCnt) AND (vLogCount < 1) Then
		'// 마일리지 테이블에 넣는다.
		vQuery = " UPDATE [db_user].[dbo].[tbl_user_current_mileage] SET bonusmileage = bonusmileage + 3000, lastupdate = getdate() WHERE userid='"&userid&"' "
		dbget.Execute vQuery
		
		'// 마일리지 로그 테이블에 넣는다.
		vQuery = " INSERT INTO db_user.dbo.tbl_mileagelog (userid, mileage, jukyocd, jukyo, deleteyn) VALUES ('"&userid&"', '+3000','"&eCode&"', '산타의 Gift 3000마일리지 지급', 'N') "
		dbget.Execute vQuery
		
		'// 이벤트 테이블에 내역을 남긴다.
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt2, device) VALUES ('" & eCode & "', '" & userid & "', 'x', '', '" & vDevice & "')"
		dbget.Execute vQuery
		
		response.write "11||응모 완료"
		dbget.close()
		response.end
	End If
Else
	Response.Write "00||정상적인 경로가 아닙니다."
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
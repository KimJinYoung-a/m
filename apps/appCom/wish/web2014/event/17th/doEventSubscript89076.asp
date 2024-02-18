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
' Description : 2018 17주년 텐텐절 매일리지 2차
' History : 2018-09-13 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-10-24 ~ 2018-10-31
'   - 오픈시간 : 24시간
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
	Dim mode, referer,refip, apgubun, currenttime, vQuery, vBoolUserCheck, vTotalCount, vNowEntryCount, vMaxEntryCount, vEventStartDate, vEventEndDate
	Dim TodayCount, numTimes, sumMileage, i, TotalMileage, pushDate, CurrentMileage, TomorrowMileage
	Dim eCode, userid

	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),10)

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  89171
	Else
		eCode   =  89076
	End If

	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-10-24 오전 10:03:35"  '// 테스트 코드 변경해야됨

	'// 이벤트시작시간
	vEventStartDate = "2018-10-24"

	'// 이벤트종료시간
	vEventEndDate = "2018-10-31"

	'// 모바일웹&앱전용
	apgubun = "A"

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not(Left(Trim(currenttime),10) >= Trim(vEventStartDate) and Left(Trim(currenttime),10) < Trim(DateAdd("d", 1, Trim(vEventEndDate)))) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End If
	
	Select Case Trim(mode)
		Case "add"
			'// 로그인시에만 응모가능
			If not(IsUserLoginOK()) Then
				Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
				Response.End
			End If

			'// 해당 이벤트를 오늘날짜 기준으로 참여했는지 확인한다.
			vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(currenttime, 10)&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			IF Not rsget.Eof Then
				If rsget(0) > 0 Then
					Response.Write "Err|이미 참여하셨습니다.."
					response.End
				End If
			End IF
			rsget.close

			TodayCount = 0
			numTimes = datediff("d", vEventStartDate, currenttime)

			' 현재날짜를 기준으로 이벤트 시작일로 부터 몇일째인지 가져온 후 루프돈다.
			For i=1 To numTimes
				'Response.write Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"<br>"
				vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And CONVERT(VARCHAR(10), regdate, 120) = '"&Left(dateadd("d", ((numTimes+1)-i)*-1, currenttime), 10)&"' ORDER BY sub_idx ASC "
				rsget.CursorLocation = adUseClient
				rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
				IF Not(rsget.Bof Or rsget.Eof) Then
					TodayCount = TodayCount + 1
				Else
					TodayCount = 0
				End If
				'Response.write TodayCount&"<br>"
				rsget.close
			Next

			sumMileage = (TodayCount+1)*100

			' 현재까지 발급받은 총 마일리지값을 가져온다.
			vQuery = "SELECT isnull(sum(sub_opt2), 0) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			TotalMileage = rsget(0)
			rsget.close

			'// 이벤트 테이블에 내역을 남긴다.
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&sumMileage&"', '"&TodayCount+1&"', '"&apgubun&"')"
			dbget.Execute vQuery

			'// 마일리지 로그 테이블에 넣는다.
			vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+"&sumMileage&"','"&eCode&"', '매일매일 매일리지 이벤트 마일리지 지급','N') "
			dbget.Execute vQuery

			'// 마일리지 테이블에 넣는다.
			vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + "&sumMileage&", lastupdate=getdate() Where userid='"&userid&"' "
			dbget.Execute vQuery

			TotalMileage = CInt(TotalMileage) + CInt(sumMileage)
			TomorrowMileage = FormatNumber(CInt(sumMileage) + 100, 0)
			CurrentMileage = FormatNumber(sumMileage, 0)

			Response.Write "OK|"&TomorrowMileage&"|"&TodayCount+1&"|"&FormatNumber(TotalMileage, 0)&"|"&CurrentMileage
			Response.End

		Case "pushadd"
			If not(IsUserLoginOK()) Then
				Response.Write "Err|로그인을 해야>?n알림 신청이 가능합니다."
				Response.End
			End If

			If Left(currenttime, 10)>=vEventEndDate Then
				Response.Write "Err|알림 신청이 불가합니다."
				Response.End
			End If

			pushDate = dateadd("d", 1, currenttime)

			'// 다음날 푸쉬 신청을 했는지 확인한다.
			vQuery = "SELECT count(*) FROM db_temp.[dbo].[tbl_maeliagePush17th] WITH (NOLOCK) WHERE userid='"&userid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
			IF Not rsget.Eof Then
				If rsget(0) > 0 Then
					Response.Write "Err|이미 신청되었습니다."
					response.End
				End If
			End IF
			rsget.close

			vQuery = " INSERT INTO db_temp.[dbo].[tbl_maeliagePush17th](userid, SendDate, Sendstatus, RegDate) VALUES('" & userid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
			dbget.Execute vQuery

			Response.Write "OK|신청되었습니다."
			Response.End

		Case Else
			Response.Write "Err|잘못된 접근 입니다."
			response.End
	End Select
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



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
' Description : 2018 Playing TenQuizCheck
' History : 2018-05-02 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-05-08 ~ 2018-05-10
'   - 오픈시간 : 오전10시~오후10시
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim mode, referer,refip, apgubun, currenttime, vQuery, vBoolUserCheck, vTotalCount, vNowEntryCount, vMaxEntryCount, vEventStartDate, vEventEndDate
	Dim TodayCount, numTimes, sumMileage, i, TotalMileage, pushDate, CurrentMileage, TomorrowMileage
	Dim eCode, userid, vChasu, vTestCheck, masterIdx

	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")
	mode = requestcheckvar(request("mode"),10)
	masterIdx = requestcheckvar(request("masteridx"),20)

	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()
'	currenttime = "2018-05-08 오전 10:03:35"

	vEventStartDate = "2018-05-08"
	vEventEndDate = "2018-05-10"

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?nTenQuiz에 참여할 수 있습니다."
		Response.End
	End If

	If not(Left(Trim(currenttime),10) >= Trim(vEventStartDate) and Left(Trim(currenttime),10) < Trim(DateAdd("d", 1, Trim(vEventEndDate)))) Then
		Response.Write "Err|TenQuiz 참여기간이 아닙니다."
		Response.End
	End If

	'// TenQuiz 참여가능시간인지 확인한다.
	If Not(TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) < TimeSerial(21, 59, 59)) Then
		Response.Write "Err|TenQuiz는 오전 10시부터 오후 10시까지만\n참여가능합니다."
		Response.End
	End If

	If mode="sns" Then
		If masterIdx <> "" Then
			vQuery = "UPDATE [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] SET snscheck='Y' WHERE userid='"&userid&"' And idx='"&masterIdx&"' "
			dbget.Execute vQuery
		End If
	Else
		vChasu = Replace(Left(Trim(currenttime), 10), "-", "")
		vTestCheck = False

		If IsUserLoginOK() Then
			'// 해당차수 문제풀었는지 확인
			vQuery = "SELECT * FROM [db_temp].[dbo].[tbl_PlayingTenQuizUserMasterData] WITH (NOLOCK) WHERE userid='"&userid&"' And chasu='"&vChasu&"' "
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
				If Not(rsget.bof Or rsget.eof) Then
					vTestCheck = True
				End If
			rsget.close
		End If

		If vTestCheck Then
			Response.Write "Err|해당일자 퀴즈는 이미 참여하셨습니다."
			response.End
		End If

		Response.write "OK|확인"
		Response.End
	End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



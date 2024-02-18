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
' Description : 마일리지 2018
' History : 2017-12-27 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-01-02 ~ 2018-01-07
'   - 오픈시간 : 매일오전 10시
'   - 일별한정갯수 : 2018개
'   - 지급마일리지 : 5,000마일리지
'   - 마일리지소멸일자 : 2018년 1월 22일 오전내 소멸
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
	dim mode, referer,refip, apgubun, currenttime, vQuery, vBoolUserCheck, vTotalCount, vNowEntryCount, vMaxEntryCount, vEventStartDate, vEventEndDate
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67497
	Else
		eCode   =  83302
	End If

	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-01-07 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-01-02"

	'// 이벤트종료시간
	vEventEndDate = "2018-01-07"

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	If not(Left(Trim(currenttime),10) >= Trim(vEventStartDate) and Left(Trim(currenttime),10) < Trim(DateAdd("d", 1, Trim(vEventEndDate)))) Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있습니다."
		Response.End
	End If

	'// 해당 이벤트는 매일 오전 10시부터 밤12시까지만 진행함.
	If Not(TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(currenttime), minute(currenttime), second(currenttime)) < TimeSerial(23, 59, 59)) Then
		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
		Response.End
	End If

	'해당 일자의 마일리지 응모수량
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE convert(varchar(10), regdate, 120) = '" & Left(Trim(currenttime), 10) & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End IF
	rsget.close

	'// 해당 이벤트를 참여했는지 확인한다.
	If IsUserLoginOK() Then
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			If rsget(0) > 0 Then
				Response.Write "Err|이미 마일리지를 발급받으셨습니다."
				response.End
			End If
		End IF
		rsget.close
	End If

	'// 최대 응모수량 1월 2일부터 7일까지 매일 2,018명
	vMaxEntryCount = 2018

	'// 현재 응모 가능수량
	vNowEntryCount = vMaxEntryCount - vTotalCount
	'vNowEntryCount = 0

	If vNowEntryCount < 1 Then
		If Left(Trim(currenttime),10) >= Trim(vEventStartDate) And Left(Trim(currenttime),10) < Trim(vEventEndDate) Then
			Response.Write "Err|오늘의 마일리지가 모두 소진되었습니다!>?n내일 아침 10시를 기다려주세요~!"
			response.End
		Else
			Response.Write "Err|오늘의 마일리지가 모두 소진되었습니다!>?n감사합니다 :)"
			response.End
		End If
	End If

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '마일리지2018 5,000 마일리지 지급', '"&apgubun&"')"
	dbget.Execute vQuery	

	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+5000','"&eCode&"', '마일리지2018 이벤트 5,000마일리지 지급','N') "
	dbget.Execute vQuery

	'// 마일리지 테이블에 넣는다.
	vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 5000, lastupdate=getdate() Where userid='"&userid&"' "
	dbget.Execute vQuery

	Response.Write "OK|마일리지2018 5,000 마일리지 지급"
	Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



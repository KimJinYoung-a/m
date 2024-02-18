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
' Description : 새해복 마일리지
' History : 2018-02-14 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-02-14 ~ 2018-02-18
'   - 오픈시간 : 24시간
'   - 일별한정갯수 : 무제한
'   - 지급마일리지 : 5,000 마일리지
'   - 마일리지소멸일자 : 2018년 2월 28일 오전내 소멸
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
		eCode   =  67509
	Else
		eCode   =  84659
	End If

	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-02-15 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-02-14"

	'// 이벤트종료시간
	vEventEndDate = "2018-02-18"

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

	'// 해당 이벤트를 참여했는지 확인한다.
	If IsUserLoginOK() Then
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			If rsget(0) > 0 Then
				Response.Write "Err|이미 마일리지를 발급받으셨습니다.>?n마일리지는 ID당 1회만 발급 받을 수 있습니다."
				response.End
			End If
		End IF
		rsget.close
	End If

	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', '새해복마일리지 5,000 마일리지 지급', '"&apgubun&"')"
	dbget.Execute vQuery	

	'// 마일리지 로그 테이블에 넣는다.
	vQuery = " insert into db_user.dbo.tbl_mileagelog(userid , mileage , jukyocd , jukyo , deleteyn) values ('"&userid&"', '+5000','"&eCode&"', '새해복마일리지 이벤트 5,000마일리지 지급','N') "
	dbget.Execute vQuery

	'// 마일리지 테이블에 넣는다.
	vQuery = " update [db_user].[dbo].[tbl_user_current_mileage] set bonusmileage = bonusmileage + 5000, lastupdate=getdate() Where userid='"&userid&"' "
	dbget.Execute vQuery

	Response.Write "OK|새해 복 마일리지 5,000 마일리지 지급"
	Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



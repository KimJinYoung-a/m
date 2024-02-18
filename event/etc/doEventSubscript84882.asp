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
' Description : 2018 박스테이프 공모전
' History : 2018-03-05 원승현 생성
' 주의사항
'   - 이벤트 기간 : 2018-03-07 ~ 2018-03-13
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
	Dim vSelectVoteVal1, vSelectVoteVal2, vSelectVoteVal3, vSelectVoteVal4
	Dim vSelectVoteVal1Txt, vSelectVoteVal2Txt, vSelectVoteVal3Txt, vSelectVoteVal4Txt

	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  67513
	Else
		eCode   =  84882
	End If

	'// 아이디
	userid = getEncLoginUserid()

	'// 현재시간
	currenttime = now()
	'currenttime = "2018-02-15 오전 10:03:35"

	'// 이벤트시작시간
	vEventStartDate = "2018-03-05"

	'// 이벤트종료시간
	vEventEndDate = "2018-03-13"

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	vSelectVoteVal1 = requestcheckvar(request("selectVoteVal1"),10)
	vSelectVoteVal2 = requestcheckvar(request("selectVoteVal2"),10)
	vSelectVoteVal3 = requestcheckvar(request("selectVoteVal3"),10)
	vSelectVoteVal4 = requestcheckvar(request("selectVoteVal4"),10)

	vSelectVoteVal1Txt = requestcheckvar(request("selectVoteVal1Txt"),100)
	vSelectVoteVal2Txt = requestcheckvar(request("selectVoteVal2Txt"),100)
	vSelectVoteVal3Txt = requestcheckvar(request("selectVoteVal3Txt"),100)
	vSelectVoteVal4Txt = requestcheckvar(request("selectVoteVal4Txt"),100)

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
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WITH (NOLOCK) WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			Response.Write "Err|이미 참여하신 이벤트 입니다."
			response.End
		End If
	End IF
	rsget.close

	If vSelectVoteVal1="" Or vSelectVoteVal2="" Or vSelectVoteVal3="" Or vSelectVoteVal4="" Then
		Response.Write "Err|투표가 완료되지 않았습니다. PART별로 1개씩>?n하트를 클릭해주세요."
		response.End
	End If



	'// 이벤트 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&vSelectVoteVal1&"', '"&vSelectVoteVal1Txt&"', '"&apgubun&"')"
	dbget.Execute vQuery	

	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&vSelectVoteVal2&"', '"&vSelectVoteVal2Txt&"', '"&apgubun&"')"
	dbget.Execute vQuery	

	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&vSelectVoteVal3&"', '"&vSelectVoteVal3Txt&"', '"&apgubun&"')"
	dbget.Execute vQuery	

	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&vSelectVoteVal4&"', '"&vSelectVoteVal4Txt&"', '"&apgubun&"')"
	dbget.Execute vQuery	

	Response.Write "OK|투표가 완료되었습니다.>?n당첨자 발표일을 기다려주세요!"
	Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



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
' Description : 내 친구를 소개합니다.
' History : 2017-03-30 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim mode, referer,refip, apgubun, nowDate, nowpos, act, sqlstr, md5userid, eCouponID, vQuery, friendItemId, dateCode
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	'// 모드값(ins)
	mode = requestcheckvar(request("mode"),32)

	Dim eCode, vUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66296
	Else
		eCode   =  77061 
	End If

	'// 아이디
	vUserID = GetEncLoginUserID()
	'// 오늘날짜
	nowDate = Left(Now(), 10)
	'nowDate = "2017-04-05"

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If
	'apgubun = "W"

	'// 일자별 상품코드값 셋팅
	Select Case Trim(nowDate)
		Case "2017-04-03"
			friendItemId = 1652083
			dateCode = "chr0403"
		Case "2017-04-04"
			friendItemId = 1654443
			dateCode = "chr0404"
		Case "2017-04-05"
			friendItemId = 1647131
			dateCode = "chr0405"
		Case "2017-04-06"
			friendItemId = 1473814
			dateCode = "chr0406"
		Case "2017-04-07"
			friendItemId = 1357041
			dateCode = "chr0407"
		Case "2017-04-08"
			friendItemId = 1441800
			dateCode = "chr0408"
		Case "2017-04-09"
			friendItemId = 1494886
			dateCode = "chr0409"
		Case "2017-04-10"
			friendItemId = 1574596
			dateCode = "chr0410"
		Case "2017-04-11"
			friendItemId = 1581032
			dateCode = "chr0411"
		Case "2017-04-12"
			friendItemId = 1494882
			dateCode = "chr0412"
		Case "2017-04-13"
			friendItemId = 1668464
			dateCode = "chr0413"
		Case "2017-04-14"
			friendItemId = 1231255
			dateCode = "chr0414"
		Case "2017-04-15"
			friendItemId = 1624145
			dateCode = "chr0415"
		Case "2017-04-16"
			friendItemId = 1473815
			dateCode = "chr0416"
		Case "2017-04-17"
			friendItemId = 1209251
			dateCode = "chr0417"
		Case Else
			friendItemId = ""
			dateCode = ""
	End Select


	if InStr(referer,"10x10.co.kr")<1 Then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowDate >= "2017-04-03" and nowDate < "2017-04-18") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인 후 참여가 가능합니다."
		dbget.close() : Response.End
	End If

	'// 하루에 한번만 참여가능함.
	If UserAppearChk(nowDate) > 0 Then
		If nowDate = "2017-04-17" Then
			Response.Write "Err|이미 응모하셨습니다."
		Else
			Response.Write "Err|이미 응모하셨습니다.>?n내일 또 응모해 주세요!"
		End If
		dbget.close() : Response.End
	End If

	'// 혹시 오전 10시부터 응모여부 할 수도 있으니 남겨둠
	'If Left(now(), 10) = "2016-10-10" Then
	'	If Not(TimeSerial(Hour(now()), minute(now()), second(now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(now()), minute(now()), second(now())) < TimeSerial(23, 59, 59)) Then
	'		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
	'		dbget.close() : Response.End
	'	End If
	'End If


	'// 이벤트 참여
	if mode="ins" Then
		'// 등록전 오늘 참여를 했는지 확인한다.
		If UserAppearChk(nowDate) > 0 Then
			If nowDate = "2017-04-17" Then
				Response.Write "Err|이미 응모하셨습니다."
			Else
				Response.Write "Err|이미 응모하셨습니다.>?n내일 또 응모해 주세요!"
			End If
			dbget.close() : Response.End
		Else
			'// 참여 데이터를 넣는다.
			Call InsAppearData(eCode, vUserId, apgubun, "ins", nowDate, friendItemId)
			Response.Write "OK|"&dateCode
			dbget.close() : Response.End
		End If
	Else
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	End If


	'// 해당일자 참여했는지 확인
	Function UserAppearChk(Dt)
		Dim vQuery
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&vUserID&"' And convert(varchar(10), regdate, 120)='"&Dt&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			UserAppearChk = rsget(0)
		End IF
		rsget.close
	End Function

	'// 참여 데이터 ins
	Function InsAppearData(evt_code, uid, device, sub_opt1, regdate, fitemid)
		Dim vQuery
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, sub_opt2, regdate)" & vbCrlf
		vQuery = vQuery & " VALUES ("& evt_code &", '"& uid &"', '"&apgubun&"','"&sub_opt1&"', "&fitemid&", '"&regdate&" "&Hour(now())&":"&minute(now())&":"&second(now())&"')"
		dbget.execute vQuery
	End Function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->



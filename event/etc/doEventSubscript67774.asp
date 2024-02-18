<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 텐바이텐과 함께하는 <직접 골라방>(이벤트참여)
' History : 2015-12-04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid, deviceGubun, snsGubun
Dim vQuery, strsql
Dim result1, result2, result3
Dim evtUserCell, refer, refip
Dim vHiter, vGlassBottle, vTumblr1, vTumblr2, couponCode
Dim vHiterSt, vHiterEd, vGlassBottleSt, vGlassBottleEd, vTumblr1St, vTumblr1Ed, vTumblr2St, vTumblr2Ed, vQueryCheck, imgLoop, imgLoopVal, jigTxt
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	jigTxt = requestcheckvar(request("jigTxt"),32)
	userid = GetEncLoginUserID

	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65976"
	Else
		eCode = "67774"
	End If


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	Select Case Trim(mode)

		Case "ins"

			'// expiredate
			If not(left(Now(),10)>="2015-12-07" and left(Now(),10)<"2015-12-14") Then
				Response.Write "Err|이벤트 응모 기간이 아닙니다."
				Response.End
			End If

			'// 로그인 여부 체크
			If Not(IsUserLoginOK) Then
				Response.Write "Err|로그인 후 참여하실 수 있습니다."
				response.End
			End If

			If Not(Trim(jigTxt)="직접골라방") Then 
				Response.Write "Err|문구를 다시한번 확인해주세요."
				response.End
			End If


			'// 응모내역 검색
			sqlstr = "select count(userid) "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& userid &"' And convert(varchar(10), regdate, 120)='"&Left(now(), 10)&"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

			If rsget(0) > 0 Then
				If Left(now(),10) < "2015-12-13" Then
					Response.Write "Err|이미 응모하셨습니다.>?n내일 다시 응모해 주세요."
				Else
					Response.Write "Err|이미 응모하셨습니다."
				End If
				response.End
			End If
			rsget.close

			'// 응모시킴
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& Date() &"','"&jigTxt&"', '"&deviceGubun&"')" 
			dbget.execute sqlstr


			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '직방이벤트응모', '"&deviceGubun&"')"
			dbget.execute sqlstr

			Response.Write "OK|응모가 완료되었습니다.>?n당첨자 발표일을 기다려주세요!"
			response.End

		Case "jigbangApp"

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '호우호우앱다운로드클릭', '"&deviceGubun&"')"
			dbget.execute sqlstr

			Response.write "OK|1"
			Response.End

		Case Else
			Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
			Response.End
	End Select
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
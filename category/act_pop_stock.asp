<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	:  2018-01-05 원승현
'	Description : 품절상품입고알림 입력
'#######################################################
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim refer
	Dim selectOptCode, stockItemid, alarmType, pushPeriod
	Dim sqlStr, alarmTerm, alarmValue, platForm, i, tmpSelectOptCode, vQuery
	refer  = request.ServerVariables("HTTP_REFERER")
	selectOptCode = requestCheckVar(request("selectOptCode"),8000)
	stockItemid = requestCheckVar(request("stockItemid"),30)
	alarmType = requestCheckVar(request("alarmType"),30)
	pushPeriod = requestCheckVar(request("pushPeriod"),30)

	'// 바로 접속시엔 오류 표시
	If InStr(refer, "10x10.co.kr") < 1 Then
		Response.Write "Err||유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
		Response.End
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err||입고 알림 신청은 로그인 후 사용하실 수 있습니다."
		Response.End
	End If

	If Trim(stockItemid)="" Then
		Response.Write "Err||정상적인 경로로 접근해 주세요."
		Response.End
	End If

	If Trim(alarmType)="" Then
		Response.Write "Err||정상적인 경로로 접근해 주세요."
		Response.End
	End If

	If Trim(pushPeriod)="" Then
		Response.Write "Err||정상적인 경로로 접근해 주세요."
		Response.End
	End If

	If isApp="1" Then
		platForm = "APP"
	Else
		platForm = "MOBILE"
	End If

	If Trim(pushPeriod)<>"" Then
		Select Case Trim(Left(pushPeriod, 1))
			Case "d"
				alarmTerm = "DAY"
			Case "m"
				alarmTerm = "MONTH"
			Case Else
				alarmTerm = "DAY"
		End Select
		alarmValue = Trim(Right(pushPeriod, 1))
	End If

	If Trim(selectOptCode) <> "" Then
		tmpSelectOptCode = Split(selectOptCode, ",")
		For i = 0 To UBound(tmpSelectOptCode)
			sqlStr = " Select Idx From db_my10x10.[dbo].[tbl_SoldOutProductAlarm] WITH (NOLOCK) Where itemid='"&stockItemid&"' And ItemOptionCode='"&tmpSelectOptCode(i)&"' "
			sqlStr = sqlStr & " And userid='"&getEncLoginUserId&"' And SendPushDate is null And SendStatus = 'N' And UserCheckStatus='Y' "
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
			IF Not rsget.Eof Then
				vQuery = " UPDATE db_my10x10.[dbo].[tbl_SoldOutProductAlarm] SET AlarmType='"&alarmType&"', PlatForm='"&platForm&"', AlarmTerm='"&alarmTerm&"', AlarmValue='"&alarmValue&"', LastUpdate=getdate() "
				vQuery = vQuery & " , LimitPushDate=DATEADD ("&Trim(Left(pushPeriod, 1))&" , "&Trim(Right(pushPeriod, 1))&" , getdate() ) "
				vQuery = vQuery & " Where userid is not null And idx='"&rsget("idx")&"' "
				dbget.Execute vQuery
			Else
				vQuery = " INSERT INTO db_my10x10.[dbo].[tbl_SoldOutProductAlarm] (ItemId, ItemOptionCode, UserId, External_Id, AlarmType, PlatForm, AlarmTerm, AlarmValue, RegDate, LimitPushDate) "
				vQuery = vQuery & " Select '"&stockItemid&"', '"&tmpSelectOptCode(i)&"', '"&getEncLoginUserId&"', useq*3 as external_id, '"&alarmType&"', '"&platForm&"', '"&alarmTerm&"', '"&alarmValue&"' "
				vQuery = vQuery & " , GETDATE(), DATEADD ("&Trim(Left(pushPeriod, 1))&" , "&Trim(Right(pushPeriod, 1))&" , getdate() )  From db_user.dbo.tbl_logindata WITH (NOLOCK) "
				vQuery = vQuery & " Where userid is not null "
				vQuery = vQuery & " And userid='"&getEncLoginUserId&"' "
				dbget.Execute vQuery
			End IF
			rsget.close
		Next
	Else
		sqlStr = " Select Idx From db_my10x10.[dbo].[tbl_SoldOutProductAlarm] WITH (NOLOCK) Where itemid='"&stockItemid&"' And ItemOptionCode='0000' "
		sqlStr = sqlStr & " And userid='"&getEncLoginUserId&"' And SendPushDate is null And SendStatus = 'N' And UserCheckStatus='Y' "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			vQuery = " UPDATE db_my10x10.[dbo].[tbl_SoldOutProductAlarm] SET AlarmType='"&alarmType&"', PlatForm='"&platForm&"', AlarmTerm='"&alarmTerm&"', AlarmValue='"&alarmValue&"', LastUpdate=getdate() "
			vQuery = vQuery & " , LimitPushDate=DATEADD ("&Trim(Left(pushPeriod, 1))&" , "&Trim(Right(pushPeriod, 1))&" , getdate() ) "
			vQuery = vQuery & " Where userid is not null And idx='"&rsget("idx")&"' "
			dbget.Execute vQuery
		Else
			vQuery = " INSERT INTO db_my10x10.[dbo].[tbl_SoldOutProductAlarm] (ItemId, ItemOptionCode, UserId, External_Id, AlarmType, PlatForm, AlarmTerm, AlarmValue, RegDate, LimitPushDate) "
			vQuery = vQuery & " Select '"&stockItemid&"', '0000', '"&getEncLoginUserId&"', useq*3 as external_id, '"&alarmType&"', '"&platForm&"', '"&alarmTerm&"', '"&alarmValue&"' "
			vQuery = vQuery & " , GETDATE(), DATEADD ("&Trim(Left(pushPeriod, 1))&" , "&Trim(Right(pushPeriod, 1))&" , getdate() )  From db_user.dbo.tbl_logindata WITH (NOLOCK) "
			vQuery = vQuery & " Where userid is not null "
			vQuery = vQuery & " And userid='"&getEncLoginUserId&"' "
			dbget.Execute vQuery
		End If
		rsget.close

	End If

	If Trim(pushPeriod)<>"" Then
		Select Case Trim(Left(pushPeriod, 1))
			Case "d"
				Response.Write "OK||입고 알림이 신청되었습니다.>?n오늘부터 "&Trim(Right(pushPeriod, 1))&"일간 재입고 소식을 알려드립니다."
			Case "m"
				Response.Write "OK||입고 알림이 신청되었습니다.>?n오늘부터 "&Trim(Right(pushPeriod, 1))&"개월간 재입고 소식을 알려드립니다."
			Case Else
				Response.Write "OK||입고 알림이 신청되었습니다.>?n오늘부터 "&Trim(Right(pushPeriod, 1))&"일간 재입고 소식을 알려드립니다."
		End Select
	Else
		Response.Write "OK||신청하신 알림 방법으로>?n입고 알림이 신청되었습니다."
	End If
	Response.End


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

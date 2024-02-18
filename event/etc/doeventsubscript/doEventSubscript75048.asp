<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 지구를 멈춰라 처리 APP전용
' History : 2016.12.15 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim sortno, currenttime
Dim eCode, LoginUserid, mode, sqlStr, result1, result2, result3, device, snsnum, snschk, refip, refer, cnt
		
IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66252"
Else
	eCode 		= "75048"
End If

currenttime = date()
'					currenttime = "2016-12-22"

mode			= requestcheckvar(request("mode"),32)
snsnum 		= requestcheckvar(request("snsnum"),10)
LoginUserid	= getLoginUserid()
refip 			= Request.ServerVariables("REMOTE_ADDR")
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(currenttime >= "2016-12-19" and currenttime < "2016-12-26") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If isapp = "1" Then device = "A" Else device = "M" End If 
if currenttime < "2016-12-22" then
	sortno = "01"	'1차
else
	sortno = "02"	'2차
end if
	
If mode = "add" Then 		'//응모버튼 클릭
	'// 응모내역 검색
	sqlstr = ""
	sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " WHERE evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0"
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//01:1차, 02:2차
		result3 = rsget(2) '//SNS 2차 응모 확인용
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	'// 최초 응모자면
	If result1 = "" Then
		'// 최초응모자
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&sortno&"', '"&device&"')"
		dbget.execute sqlstr
		Response.write "OK|응모가 완료됬습니다."
		dbget.close()	:	response.End
	ElseIf Trim(result1) = "1" Then
		If (Trim(result3)="ka") OR (Trim(result3)="fb") Then
			'// SNS 공유자
			sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' " + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			dbget.execute sqlstr
			Response.write "OK|응모가 완료됬습니다."
			dbget.close()	:	response.End
		Else
			Response.Write "Err|친구초대 후 다시 한번 응모하세요!"
			response.End
		End If
	Else
		Response.Write "Err|오늘은 모두 응모하셨습니다. 내일 다시 도전해 주세요!"
		response.End
	End If
ElseIf mode = "snschk" Then '//SNS 클릭
	'//응모내역
	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 1 sub_opt1, isnull(sub_opt3, '') as sub_opt3 "
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript "
	sqlStr = sqlStr & " WHERE evt_code='"& eCode &"'"
	sqlStr = sqlStr & " and userid='"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 "
	rsget.Open sqlStr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1	= rsget(0) '//응모1차 or 2차 응모여부
		snschk	= rsget(1) '//2차 응모 확인용 null , ka , fb , tw
	Else
		'//최초응모
		result1 = ""
		snschk = ""
	End IF
	rsget.close

	If result1 = "" and snschk = "" Then	'참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "Err|none"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "") Then	'1회 참여시 
		sqlStr = ""
		sqlStr = sqlStr & " UPDATE db_event.dbo.tbl_event_subscript SET " & vbcrlf
		sqlStr = sqlStr & " sub_opt3 = '"& snsnum &"'" & vbcrlf
		sqlStr = sqlStr & " WHERE evt_code = "& eCode &" and userid = '"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 " & vbcrlf
		dbget.execute sqlStr 
		If snsnum = "tw" Then
			Response.write "OK|tw|tw"
		ElseIf snsnum = "fb" Then
			Response.write "OK|fb|fb"
		ElseIf snsnum = "ka" Then
			Response.write "OK|ka|ka"
		Else
			Response.write "error"
		End If
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb") Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "Err|end|"
		dbget.close()	:	response.End
	Else
		Response.write "error"
	End If
Else
	Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 모기잡이 이벤트 MA
' History : 2016-08-05 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<%
Dim eCode, vUserId, mode, vTotalCount , myCount , catches, device, eventPossibleDate
Dim vQuery
Dim prize1, prize2, prize3
Dim currenttime
currenttime	=  now()
mode		= requestcheckvar(request("mode"),32)
catches		= requestcheckvar(request("catches"),10) '응모할 상품 번호
vUserId		= GetEncLoginUserID

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66179"
	If not( left(currenttime,10) >= "2016-08-04" and left(currenttime,10) <= "2016-08-14" ) Then 
		eventPossibleDate = False
	Else
		eventPossibleDate = True
	End If
Else
	eCode 		= "72249"
	If not( left(currenttime,10) >= "2016-08-08" and left(currenttime,10) <= "2016-08-14" ) Then 
		eventPossibleDate = False
	Else
		eventPossibleDate = True
	End If
End If

'' M,A 에서사용
IF isapp THEN
	device   =  "A"
Else
	device   =  "M"
End If

''// 로그인 체크
If vUserId = "" Then
	Response.Write "{ "
	response.write """resultcode"":""44"""
	response.write "}"
	dbget.close()
	response.end
End If

''//이벤트 기간 체크
If eventPossibleDate = False Then
	Response.Write "{ "
	response.write """resultcode"":""88"""
	response.write "}"
	dbget.close()
	response.end
End If 
'---------------------------------------------------------------------------------------------------------
'//출석체크 응모
If mode = "daily" Then 
	'// 당일 이벤트 출석 응모 내역
	vQuery = "SELECT count(*) FROM db_temp.[dbo].[tbl_event_attendance] WHERE userid = '" & vUserId & "' And evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	''//오늘 출첵 했으면 종료
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""22"""
		response.write "}"
		dbget.close()
		response.end
	End If

	'//오늘 출첵 안했으면 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO db_temp.[dbo].[tbl_event_attendance](evt_code, userid, device) VALUES('" & eCode & "', '" & vUserId & "', '"&device&"')"
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	dbget.close()
	response.End
End If
'---------------------------------------------------------------------------------------------------------
''//총 출첵 갯수 체크, 상품 응모 현황
If mode = "mogis" Then
	vQuery = "select "
	vQuery = vQuery & " count(*) as totcnt "
	vQuery = vQuery & " from db_temp.[dbo].[tbl_event_attendance] as t "
	vQuery = vQuery & " inner join db_event.dbo.tbl_event as e "
	vQuery = vQuery & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
	vQuery = vQuery & "	where t.userid = '"& vUserId &"' and t.evt_code = '"& eCode &"' " 
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		myCount = rsget("totcnt")
	End IF
	rsget.close()

	vQuery = "select "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 2 and userid = '"& vUserId &"' then 1 else 0 end),0) as prize1 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 4 and userid = '"& vUserId &"' then 1 else 0 end),0) as prize2 , "
	vQuery = vQuery & "	isnull(sum(case when sub_opt1 = 7 and userid = '"& vUserId &"' then 1 else 0 end),0) as prize3  "
	vQuery = vQuery & "	from db_event.dbo.tbl_event_subscript "
	vQuery = vQuery & "	where evt_code = '"& eCode &"'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 2일차 응모
		prize2	= rsget("prize2")	'//	5일차 응모
		prize3	= rsget("prize3")	'//	7일차 응모
	End IF
	rsget.close()
End If

'//상품 응모
If mode = "mogis" Then
	If catches = "2" Then
		If myCount < 2 Then			'출첵 2번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	'모기를 더 잡아주세요.
			response.write "}"
			dbget.close()
			response.end
		Else
			If prize1 = 1 Then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			Else
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & vUserId & "', '"& catches &"', '2', '"&device&"')"
				dbget.Execute vQuery
				Response.Write "{ "
				response.write """resultcode"":""77"""		''마일리지 응모 완료
				Response.write "}"
				dbget.close()
				Response.end
			End If
		End If
	ElseIf catches = "5" Then
		If myCount < 5 Then	''출첵 4번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	'모기를 더 잡아주세요.
			response.write "}"
			dbget.close()
			response.end
		Else
			If prize2 = 1 Then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			Else
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & vUserId & "', '"& catches &"', '5', '"&device&"')"
				dbget.Execute vQuery

				Response.Write "{ "
				response.write """resultcode"":""11"""		'모기 기피제 응모 완료
				Response.write "}"
				dbget.close()
				Response.end
			End If
		End If
	ElseIf catches = "7" Then
		If myCount < 7 Then	''출첵 7번이하면 응모 안됨
			Response.Write "{ "
			response.write """resultcode"":""33"""	'모기를 더 잡아주세요.
			response.write "}"
			dbget.close()
			response.end
		Else
			If prize3 = 1 then
				Response.Write "{ "
				response.write """resultcode"":""99"""	''이미 응모 하셨습니다.
				response.write "}"
				dbget.close()
				response.end
			Else
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2 , device) VALUES('" & eCode & "', '" & vUserId & "', '"& catches &"', '7', '"&device&"')"
				dbget.Execute vQuery
				Response.Write "{ "
				response.write """resultcode"":""77"""		''마일리지 응모 완료
				Response.write "}"
				dbget.close()
				Response.end
			End If
		End If
	Else
		Response.Write "{ "
		response.write """resultcode"":""66"""	''잘못된 접속 입니다.
		response.write "}"
		dbget.close()
		response.end
	End If
Else
	Response.Write "{ "
	response.write """resultcode"":""66"""	''잘못된 접속 입니다.
	response.write "}"
	dbget.close()
	response.end
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 모여라 꿈동산
' History : 2015-10-02 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, vTotalCount
Dim vQuery
Dim winnerchk , tempwin , totcnt
Dim renloop '//확률
Dim device

randomize
renloop=int(Rnd*1000)+1 '100%

mode = requestcheckvar(request("mode"),32)

userid = GetEncLoginUserID()

If isapp = "1" Then device = "A" Else device = "M" End if

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64941
	Else
		eCode   =  67097
	End If

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

'//출석체크 응모
If mode = "daily" Then 
	'//어뷰징 아웃!
	if userBlackListCheck(userid) Then
		'Response.write "이색히야 넌 영원히 꽝이야"
		renloop = "999"
	End If 

	if date() < "2015-11-02" or date() > "2015-11-06" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'===================================================================================================================================================================================================
	Sub fnGetPrize() '응모
		'//오늘 당첨자
		vQuery = "SELECT count(*) as totcnt , isnull(sum(case when sub_opt2 = 1 then 1 else 0 end),0) as winnerchk FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			totcnt = rsget("totcnt")
			winnerchk = rsget("winnerchk")
		End If
		rsget.close()
		
		tempwin = 100	'//즉석당첨 5%

		If winnerchk < tempwin Then '// 상품 수량 있음
			If renloop < 101 Then '5%
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '2', '"& device &"')"
				dbget.Execute vQuery
				Response.Write "{ "
				Response.write """resultcode"":""11"""
				Response.write ", ""totcnt"":"""& totcnt+1 &""""
				Response.write "}"
				dbget.close()
				Response.end
			Else '//확률 꽝
				'//이벤트 테이블에 등록
				vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '2', '"& device &"')"
				dbget.Execute vQuery
				Response.Write "{ "
				Response.write """resultcode"":""22"""
				Response.write ", ""totcnt"":"""& totcnt+1 &""""
				Response.write "}"
				dbget.close()
				Response.end
			End If 
		Else '// 상품수량 오링 -> 꽝처리
			'//이벤트 테이블에 등록
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "', '2', '"& device &"')"
			dbget.Execute vQuery
			Response.Write "{ "
			Response.write """resultcode"":""22"""
			Response.write ", ""totcnt"":"""& totcnt+1 &""""
			Response.write "}"
			dbget.close()
			Response.end
		End If
	End Sub
'===================================================================================================================================================================================================
	'// 이벤트 출석 내역 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' And evt_code='"&eCode&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()
	
	'// 오늘 출석 완료
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.End
	Else 	
		Call fnGetPrize() '//응모
	End If 

ElseIf mode="kakao" Then

	if date() < "2015-11-02" or date() > "2015-11-06" Then
		Response.Write "{ "
		response.write """stcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 

	Dim result1 , kakaochk
	'// 응모내역 검색 
	vQuery = "select top 1 sub_opt2 , sub_opt3 "
	vQuery = vQuery & " from db_event.dbo.tbl_event_subscript "
	vQuery = vQuery & " where evt_code='"& eCode &"'"
	vQuery = vQuery & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모1차 or 2차 응모여부
		kakaochk = rsget(1) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		kakaochk = ""
	End IF
	rsget.close

	If result1 = "" and kakaochk = "" Then '//참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "{ "
		response.write """stcode"":""11""" 
		response.write "}"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (kakaochk = "" Or isnull(kakaochk) Or kakaochk <> "kakao" or kakaochk = "NULL") Then	'//1회 참여시 
		vQuery = " update db_event.dbo.tbl_event_subscript set sub_opt3 = 'kakao'" + vbcrlf
		vQuery = vQuery & " where evt_code="& eCode &" and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 " + vbcrlf
		dbget.execute vQuery '// 카카오체크
		Response.Write "{ "
		response.write """stcode"":""22"""
		response.write "}"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And kakaochk = "kakao" Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "{ "
		response.write """stcode"":""33"""
		response.write "}"
		dbget.close()	:	response.End
	End If
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
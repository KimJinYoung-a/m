<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  현상금을 노려라
' History : 2015-08-03 이종화
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim sqlStr, userid , itemid , vTotcnt2
Dim eCode , vDevice , mode , vTotcnt , result1 , result2 ,kakaochk
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64843
Else
	eCode   =  65229
End If

If isapp = "1" Then 
	vDevice = "A"
Else
	vDevice = "M"
End If 

userid = GetLoginUserID()
itemid = getNumeric(requestCheckVar(Request("itemid"),18)) '응모코드
mode = requestCheckVar(Request("mode"),6)

'#################################################################################################
'기본 체크 영역
'#################################################################################################
'// 로그인 여부 확인 //
if userid="" or isNull(userid) then
	Response.Write "{ "
	response.write """stcode"":""77"""
	response.write "}"
	response.End
end If

'// 이벤트 기간 확인 //
sqlStr = "Select evt_startdate, evt_enddate " &_
		" From db_event.dbo.tbl_event " &_
		" WHERE evt_code='" & eCode & "'"

rsget.Open sqlStr,dbget,1
if rsget.EOF or rsget.BOF Then
	Response.Write "{ "
	response.write """stcode"":""99"""
	response.write "}"
	dbget.close()	:	response.End
elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") Then
	Response.Write "{ "
	response.write """stcode"":""88"""
	response.write "}"
	dbget.close()	:	response.End
end if
rsget.Close

'//10시 이전 응모시 팅
If hour(now()) <= 9 Then
	Response.Write "{ "
	response.write """stcode"":""888"""
	response.write "}"
	response.End
End If

'// 기타 잘못된 접근(itemid값 없음, mode값 없음)
If mode = "" Or IsNull(mode) Then
	Response.Write "{ "
	response.write """stcode"":""55"""
	response.write "}"
	response.End
End If

'#################################################################################################
'#####  kakao 
'#################################################################################################

If mode="kakao" then
	'//카카오초대 체크 여부 및 update

	If hour(now()) < 10 Then
		Response.Write "{ "
		response.write """stcode"":""99""" '//아직 응모 시간 아니야~ 친구 초대 못보내~
		response.write "}"
		response.End
	End If
	
	'//카카오 로그 심기(클릭수 -_-;)
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& eCode &"', 'kakao')"
	dbget.execute(sqlstr)
	
	'// 응모내역 검색 , 이벤트코드 , 회차수 , 상품코드 , 일자 체크
	sqlstr = "select top 1 sub_opt1 , sub_opt3 "
	sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript "
	sqlstr = sqlstr & " where evt_code='"& eCode &"'"
	sqlstr = sqlstr & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
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
		sqlstr = " update db_event.dbo.tbl_event_subscript set sub_opt3 = 'kakao'" + vbcrlf
		sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 " + vbcrlf
		dbget.execute sqlstr '// 응모 기회 한번 더줌
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

'#################################################################################################
'#####  insert
'#################################################################################################

If mode="insert" Then

	'// 상품코드 유무
	If itemid = "" Or IsNull(itemid) Then
		Response.Write "{ "
		response.write """stcode"":""55"""
		response.write "}"
		response.End
	End If

	'// 2회 초과 입력했는지 확인
	sqlstr = " Select isnull(sum(case when sub_opt1 <> '' then 1 else 0 end),0) , isnull(sum(case when sub_opt2 <> '' and sub_opt2 > 0 then 1 else 0 end ),0) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" Where evt_code='"&eCode&"' And userid='"&userid&"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.BOF or rsget.EOF) Then
		vTotcnt = rsget(0) '// 1차 입력
		vTotcnt2 = rsget(1) '// 2차입력 유무 있으면 오늘 기회끝
		If vTotcnt2 > 0 Then
			Response.Write "{ "
			response.write """stcode"":""22"""
			response.write "}"
			dbget.close()
			response.End	
		End If
	End If
	rsget.Close

	Sub fnGetInsert(v) '//
		'// 값을 입력한다.
		If v = 1 Then '//1회차 입력
			sqlStr = " insert into db_event.dbo.tbl_event_subscript (evt_code , userid , sub_opt1 , device) " &_
					" values ("& eCode &" , '"& userid &"' , "& itemid &" , '"& vDevice &"') "
			dbget.execute(sqlStr)	
		Else '//2회차 업데이트
			sqlStr = " update db_event.dbo.tbl_event_subscript set sub_opt2= "& itemid &"" &_
					 " where evt_code="& eCode &" and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
			dbget.execute(sqlStr)
		End If 

		'// 결과 값 리턴
			Response.Write "{ "
			response.write """stcode"":""00"""
			response.write ",""rcode"":"""& v &""""
			response.write "}"
			response.End
	End Sub


	'// 입력 프로세스
	If hour(now()) > 9 Then '//10시 부터 가능
		If vTotcnt = 0 Then '//1번 참여 유무
			Call fnGetInsert(1)
		ElseIf vTotcnt = 1 Then '//1번 참여가 확인 된다면 
			'// 카카오 체크
			sqlstr = "select top 1 sub_opt3 "
			sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript "
			sqlstr = sqlstr & " where evt_code='"& eCode &"'"
			sqlstr = sqlstr & " and userid='"& userid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not rsget.Eof Then
				If rsget(0) = "" Or isnull(rsget(0)) Or rsget(0) <> "kakao" or rsget(0) = "NULL" Then
					Response.Write "{ "
					response.write """stcode"":""999""" '//카카오 없다 다단계 하고 와라
					response.write "}"
					dbget.close()
					response.End
				Else
					rsget.close
					Call fnGetInsert(2) '2번째 응모 프로세스
				End If 
			End IF
			rsget.close
		End If 
	Else
		Response.Write "{ "
		response.write """stcode"":""99""" '//아직 응모 시간 아니야~
		response.write "}"
		response.End
	End if
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
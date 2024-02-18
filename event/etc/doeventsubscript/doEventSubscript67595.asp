<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 11월 신규고객 대상 [택배가 온다!]
' History : 2015-11-19 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim sqlStr, userid , myregcnt , mycellcnt
Dim eCode , vDevice , mode
Dim snsgubun , prizecnt
Dim tmpcnt : tmpcnt = 2109 '' 총응모 2109 재고

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65956
Else
	eCode   =  67595
End If

If isapp = "1" Then 
	vDevice = "A"
Else
	vDevice = "M"
End If 

userid = GetEncLoginUserID()
snsgubun = requestCheckVar(Request("snsgubun"),2) '응모코드
mode = requestCheckVar(Request("mode"),6)
'#################################################################################################
'##### 기본 체크 영역
'#################################################################################################
'// 로그인 여부 확인 //
if userid="" or isNull(userid) then
	Response.Write "{ "
	response.write """stcode"":""77"""
	response.write "}"
	response.End
end If

'// 이벤트 일자 확인 //
if Date() < "2015-11-23" or Date() > "2015-12-06" Then
	Response.Write "{ "
	response.write """stcode"":""88"""
	response.write "}"
	dbget.close()	:	response.End
End If 
'#################################################################################################
'#####  SNS gubun 
'#################################################################################################
If mode="sns" Then

	'//sns 로그 심기(클릭수 -_-;)
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& eCode &"', '"&snsgubun&"')"
	dbget.execute(sqlstr)
	
	if snsgubun = "ka" then
		Response.Write "{ "
		response.write """stcode"":""ka"""
		response.write "}"
	elseif snsgubun = "fb" then
		Response.Write "{ "
		response.write """stcode"":""fb"""
		response.write "}"
	elseif snsgubun = "ln" then
		Response.Write "{ "
		response.write """stcode"":""ln"""
		response.write "}"
	Else
		Response.Write "{ "
		response.write """stcode"":""99"""
		response.write "}"
	end if
	Response.End
End If
'#################################################################################################
'#####  insert
'#################################################################################################
If mode="insert" Then
	
	'이벤트 카운팅
	sqlStr = " select count(*) from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		prizecnt = rsget(0)
	End IF
	rsget.close()

	'이벤트 마감 - 사은품 소진
	If prizecnt >= tmpcnt Then
		Response.Write "{ "
		Response.write """stcode"":""999""" 
		Response.write "}"
		dbget.close()	:	response.End
	End If 
	
	'//어뷰징 아웃! 블랙리스트 등록된 ID일경우
	if userBlackListCheck(userid) Then
		Response.Write "{ "
		response.write """stcode"":""99"""
		response.write "}"
		dbget.close()	:	response.End
	End If 

	'// 실제 체크
	sqlStr = " IF EXISTS(select top 1 userid from db_user.dbo.tbl_user_n where convert(varchar(10),regdate,120) >= '2015-11-01' "
	sqlStr = sqlStr & "and userid = '"&userid&"') "
	sqlStr = sqlStr & "	begin "
	sqlStr = sqlStr & "		IF not EXISTS(select userid from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' and userid = '"&userid&"') "
	sqlStr = sqlStr & "			select 1 "
	sqlStr = sqlStr & "		else "
	sqlStr = sqlStr & "			select 2 "
	sqlStr = sqlStr & "	end "
	sqlStr = sqlStr & "else "
	sqlStr = sqlStr & "	begin "
	sqlStr = sqlStr & "		select 3 "
	sqlStr = sqlStr & "	end "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		myregcnt = rsget(0)
	End IF
	rsget.close()
	
	'//프로세스
	If myregcnt = "1" Then '// 이벤트 참여 가능
		'// 전화번호 or 이메일 중복 체크
		sqlStr = " select count(*) from "
		sqlStr = sqlStr & "	db_user.dbo.tbl_user_n as n "
		sqlStr = sqlStr & "where usercell in ( "
		sqlStr = sqlStr & "select usercell from "
		sqlStr = sqlStr & "db_user.dbo.tbl_user_n where userid = '"&userid&"') "
		sqlStr = sqlStr & " or "
		sqlStr = sqlStr & "usermail in ( "
		sqlStr = sqlStr & "	select usermail from "
		sqlStr = sqlStr & "	db_user.dbo.tbl_user_n where userid = '"&userid&"' and usermail <> '') "
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			mycellcnt = rsget(0)
		End If

		'// 1 ID만 참여 가능 (어뷰징 방지) 기존ID 있고 이벤트를 위해 신규 생성을 하여도 기존에 가입된 동일 전화번호 및 이메일 주소가 있을 경우 참여 대상 제외
		If mycellcnt > 1 Then
			Response.Write "{ "
			response.write """stcode"":""33"""
			response.write "}"
			dbget.close()	:	response.End
		Else 
			sqlstr = "INSERT INTO db_event.dbo.tbl_event_subscript (evt_code , userid , device) " + vbcrlf
			sqlstr = sqlstr & " VALUES('"& eCode &"', '"&userid&"' , '"&vDevice&"')"
			dbget.execute(sqlstr)

			Response.Write "{ "
			response.write """stcode"":""11"""
			response.write "}"
			dbget.close()	:	response.End
		End If 
	ElseIf myregcnt = "2" Then '// 이미 이벤트 참여함
		Response.Write "{ "
		response.write """stcode"":""22"""
		response.write "}"
		dbget.close()	:	response.End
	ElseIf myregcnt = "3" Then '// 이벤트 응모 대상자가 아님 (11월 이전에 가입한 양반들)
		Response.Write "{ "
		response.write """stcode"":""99"""
		response.write "}"
		dbget.close()	:	response.End
	End If 	
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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
' Description : 설문조사
' History : 2017-01-20 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim sqlstr 
Dim ex1 , ex1text , ex2 , ex3 , ex4 , ex5 , ex6 , ex7 , ex8 , ex9 , ex10 , etctext
	ex1 = requestcheckvar(request("ex1"),20)
	ex1text = requestcheckvar(request("ex1text"),60)
	ex2 = requestcheckvar(request("ex2"),20)
	ex3 = requestcheckvar(request("ex3"),200)
	ex4 = requestcheckvar(request("ex4"),200)
	ex5 = requestcheckvar(request("ex5"),200)
	ex6 = requestcheckvar(request("ex6"),200)
	ex7 = requestcheckvar(request("ex7"),200)
	ex8 = requestcheckvar(request("ex8"),200)
	ex9 = requestcheckvar(request("ex9"),200)
	ex10 = requestcheckvar(request("ex10"),200)
	etctext = requestcheckvar(request("etc"),500)

	If ex1 = "99" Then '//기타 일경우 기타 텍스트로 치환
		ex1 = ex1text
	End If 

'dim refer
'	refer = request.ServerVariables("HTTP_REFERER")
'if InStr(refer,"10x10.co.kr")<1 then
'	Response.Write "잘못된 접속입니다."
'	dbget.close() : Response.End
'end If

dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66267"
	Else
		eCode = "75840"
	End If

	currenttime = now()
	userid = GetEncLoginUserID()

	dim subscriptcountcurrentdate, subscriptcountend
	subscriptcountcurrentdate=0
	subscriptcountend=0

	If userid = "" Then
		Response.Write "01||로그인을 해주세요."
		dbget.close() : Response.End
	End IF
	If not( left(currenttime,10)>="2017-01-24" and left(currenttime,10)<"2017-02-01" ) Then
		Response.Write "02||이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'//본인 참여 여부
	if userid<>"" then
		subscriptcountcurrentdate = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
		subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	end if

	'/응모 완료
	if subscriptcountend>0 then
		Response.Write "03||이미 응모 하셨습니다."
		dbget.close() : Response.End
	end If
	
	'//temp 저장
	sqlstr = "INSERT INTO db_temp.[dbo].[tbl_event_75840](userid , ex1 , ex2 , ex3 , ex4 , ex5 , ex6 , ex7 ,ex8 , ex9 , ex10 , etc)" & vbcrlf
	sqlstr = sqlstr & " VALUES('" & userid & "', '"& html2db(ex1) &"' , '"& ex2 &"' , '"& ex3 &"' , '"& ex4 &"' , '"& html2db(ex5) &"' , '"& html2db(ex6) &"' , '"& html2db(ex7) &"' , '"& html2db(ex8) &"' , '"& html2db(ex9) &"' , '"& ex10 &"' , '"& html2db(etctext) &"')"
	'response.write sqlstr & "<Br>"
	dbget.execute(sqlStr)

	'//이벤트 저장
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbcrlf
	if isApp="1" then
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 2, '', 'A')"
	else
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 2, '', 'M')"
	end If
	'response.write sqlstr & "<Br>"
	dbget.execute(sqlStr)

	Response.Write "05||응모가 완료되었습니다! 감사합니다."
	dbget.close() : Response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
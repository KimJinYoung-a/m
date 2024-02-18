<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### PLAY #25.TOY_KIDULT 
'### 2015-10-02 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, mode, sqlstr, refer, myscent, mycomcnt, vQuery, enterCnt, vQanswer, vYCnt, vResultScore, apgubun
Dim refip


	userid = GetEncLoginUserID
	refer = request.ServerVariables("HTTP_REFERER")
	refip = Request.ServerVariables("REMOTE_ADDR")
	vQanswer = requestcheckvar(request("qAnswer"),128)
	mode = requestcheckvar(request("mode"),128)

	If isApp="1" Then
		apgubun = "A"
	Else
		apgubun = "M"
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64903
	Else
		eCode   =  66569
	End If

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If not( left(now(),10)>="2015-10-02" and left(now(),10)<"2015-10-15" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If

	If mode = "add" Then '//응모하기 버튼 클릭
		''응모 이력 있는지 체크
		sqlstr = "select count(userid) as cnt "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' "
		rsget.Open sqlstr, dbget, 1
	
		If Not rsget.Eof Then
			mycomcnt = rsget(0)
		End IF
		rsget.close

		If mycomcnt < 1 Then '//응모 내역이 없음

			'// 들어온값중 Y가 얼마나 되는지 체크
			vYCnt = UBound(Split(Trim(vQanswer), "Y"))

			If vYCnt >= 9 And vYCnt < 11 Then
				vResultScore = 100
			ElseIf vYCnt >= 8 And vYCnt < 10 Then
				vResultScore = 80
			ElseIf vYCnt >= 4 And vYCnt < 8 Then
				vResultScore = 40
			ElseIf vYCnt >= 0 And vYCnt < 4 Then
				vResultScore = 20
			Else
				vResultScore = 20
			End If

			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, device, regdate)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '', '"&vResultScore&"','"&Trim(vQanswer)&"', '"&apgubun&"',getdate() )" + vbcrlf
			dbget.execute sqlstr

			Response.Write "OK|"&vResultScore
			dbget.close() : Response.End

		Else '//이미 이벤트에 참여했음
			Response.Write "Err|이미 응모하셨습니다."
			dbget.close() : Response.End
		End if
	Else
		Response.Write "Err|정상적인 경로가 아닙니다."
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
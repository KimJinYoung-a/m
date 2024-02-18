<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	: 2015.05.20 유태욱 생성
'	Description : 푸드파이터
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim mode, gubun, selectvalue, nowdate, devicename
dim eCode, userid , refer , sqlStr
Dim vQuery, vTotalCount , vTotalSum

	if isApp then
		devicename	="A"
	else
		devicename	="M"
	end if

	nowdate = date()
'	nowdate = "2015-05-21"

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	userid = GetLoginUserID
	mode = requestcheckvar(request("mode"),32)
	gubun = requestcheckvar(request("gubun"),1)
	selectvalue = requestcheckvar(request("selectvalue"),1)

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "62771"
	Else
		eCode 		= "62786"
	End If

	If not( left(nowdate,10)>="2015-05-21" and left(nowdate,10)<"2015-05-30") Then''''''''''''''''''''''''''''''''''''''''
		Response.Write "02"	''이벤트 응모 기간이 아닙니다.
		dbget.close() : Response.End
	End IF

	If Now() > #05/30/2015 00:00:00# Then
		Response.Write "03"	''이벤트가 종료되었습니다.
		dbget.close() : Response.End
	End If

	If userid = "" Then
		Response.Write "04"	''로그인을 해주세요.
		dbget.close() : Response.End
	End If
	
	if mode="add" then
		'//응모
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' AND convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			vTotalCount = rsget(0)
		End IF
		rsget.close

		If vTotalCount > 0 Then
			Response.Write "05"	''오늘은 이미 응모하셨습니다.
			dbget.close() : Response.End
		Else
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '1', '" & gubun & "', '" & selectvalue & "', '" & devicename & "')"
			dbget.Execute vQuery
			
			Response.Write "01"	''응모가 완료되었습니다.
			dbget.close() : Response.End
		End If
	else
		Response.Write "99"	''정상적인 경로가 아닙니다.
		dbget.close() : Response.End
	end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
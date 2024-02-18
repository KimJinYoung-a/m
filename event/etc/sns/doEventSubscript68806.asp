<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description : 설날맞이 손금보기
' History : 2016.01.20 한용민 생성
'####################################################
%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim userid , mode , refer, vQuery
	isapp = requestcheckvar(request("isapp"),1)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

userid = "guest" '// 비로그인 방식

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66006
Else
	eCode   =  68806
End If

dim currenttime
currenttime = now()
'currenttime = #01/18/2016 10:05:00#

'// 카운트용 응모
if isApp="1" then
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid ,device) VALUES('" & eCode & "', '" & userid & "' , 'A')"
else
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid ,device) VALUES('" & eCode & "', '" & userid & "' , 'M')"
end if

'response.write vQuery & "<Br>"
dbget.Execute vQuery

dbget.close() : Response.End
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
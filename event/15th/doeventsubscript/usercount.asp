<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"

%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
	Dim vQuery, vDate, vTime, vDevice
	vDate = FormatDate(now(),"0000-00-00")
	vTime = TwoNumber(hour(now))
	If isapp = "1" Then '¾ÛÀÏ°æ¿ì
		vDevice = "A"
	Else '¾ÛÀÌ ¾Æ´Ò°æ¿ì
		vDevice = "M"
	End If
		vQuery = "IF EXISTS(select time from [db_temp].[dbo].[tbl_event_73053] where date = '" & vDate & "' and time = '" & vTime & "' and device = '" & vDevice & "') "
		vQuery = vQuery & "BEGIN "
		vQuery = vQuery & "	UPDATE [db_temp].[dbo].[tbl_event_73053] SET count = count + 1 where date = '" & vDate & "' and time = '" & vTime & "' and device = '" & vDevice & "'"
		vQuery = vQuery & "END "
		vQuery = vQuery & "ELSE "
		vQuery = vQuery & "BEGIN "
		vQuery = vQuery & "	INSERT INTO [db_temp].[dbo].[tbl_event_73053](date, time, count, device) VALUES('" & vDate & "', '" & vTime & "', '1', '" & vDevice & "')"
		vQuery = vQuery & "END "
		dbget.Execute vQuery
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
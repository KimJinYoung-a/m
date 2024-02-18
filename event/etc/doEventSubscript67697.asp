<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 중국 사이트 오픈 이벤트
' History : 2015-11-25 원승현
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

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65961
Else
	eCode   =  67697
End If

If isapp = "1" Then 
	vDevice = "A"
Else
	vDevice = "M"
End If 

userid = GetEncLoginUserID()
snsgubun = requestCheckVar(Request("snsgubun"),2) '응모코드

'#################################################################################################
'#####  SNS gubun 
'#################################################################################################
'//sns 로그 심기(클릭수 -_-;)
sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
sqlstr = sqlstr & " VALUES('"& eCode &"', '"&snsgubun&"')"
dbget.execute(sqlstr)

if snsgubun = "ka" then
	Response.Write "{ "
	response.write """stcode"":""ka"""
	response.write "}"
	response.End
elseif snsgubun = "fb" then
	Response.Write "{ "
	response.write """stcode"":""fb"""
	response.write "}"
	response.End
elseif snsgubun = "ln" then
	Response.Write "{ "
	response.write """stcode"":""ln"""
	response.write "}"
	response.End
Else
	Response.Write "{ "
	response.write """stcode"":""99"""
	response.write "}"
	response.End
end if


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
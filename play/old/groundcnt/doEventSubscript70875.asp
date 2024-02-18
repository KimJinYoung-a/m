<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : PLAY 30-4 M/A
' History : 2016-05-19 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, mode, snsgubun , sqlstr, referer

userid = GetEncLoginUserID()
snsgubun = requestCheckVar(Request("snsgubun"),2) '응모코드
mode = requestCheckVar(Request("mode"),6)

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66134
Else
	eCode   =  70875
End If

If userid = "" Then
	Response.Write "<script>alert('로그인후 이용 가능 합니다.');parent.top.location.href='"&referer&"&pagereload="&pagereload&"';</script>"
	dbget.close()
	response.end
End If

If mode="sns" Then
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_70875](userid, gubun)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& userid &"', '"&snsgubun&"')"
	dbget.execute(sqlstr)
	
	if snsgubun = "tw" then
		Response.Write "{ "
		response.write """stcode"":""tw"""
		response.write "}"
		response.End
	elseif snsgubun = "fb" then
		Response.Write "{ "
		response.write """stcode"":""fb"""
		response.write "}"
		response.End
	end if
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
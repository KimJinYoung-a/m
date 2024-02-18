<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 달님 소원을 들어주세요!
' History : 2019-09-05 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim currenttime, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, chasu
	dim vIsApp

	IF application("Svr_Info") = "Dev" THEN
        eCode = "90381"
    Else
        eCode = "97105"
    End If

	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
	refer 			= request.ServerVariables("HTTP_REFERER")

	device = "M"

	'알림 응모 여부 체크 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt1 = '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1')"
		dbget.execute sqlstr

		Response.write "OK|참여완료."
		dbget.close()	:	response.End
	Else				
		Response.write "ERR|이미 신청하셨습니다."
		dbget.close()	:	response.End
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
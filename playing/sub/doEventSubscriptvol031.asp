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
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim resultcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, num, sel, resultvalue
dim myresultCnt, cLayerValue
Dim idea, badge, cart, ex5, username, vYear, vMonth, vDay, vType, yyyymmdd

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67495
Else
	eCode   =  82743
End If

currenttime = Date()
LoginUserid	= getencLoginUserid()



refer 		= request.ServerVariables("HTTP_REFERER")
mode			= requestcheckvar(request("mode"),3)
idea			= requestcheckvar(request("ideavalue"),2)
badge			= requestcheckvar(request("badgevalue"),2)
cart			= requestcheckvar(request("cartvalue"),2)

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

If mode <> "add" and mode <> "result" and mode <> "snsresult" Then		
	Response.Write "Err|잘못된 접속입니다."
	dbget.close: Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

device = "M"

If mode = "add" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE  evt_code = '"& eCode &"' and userid= '"&LoginUserid&"'"
	rsget.Open sqlstr, dbget, 1
		resultcnt = rsget("cnt")
	rsget.close

	If resultcnt > 0 Then
		Response.Write "03|이미 응모 하였습니다."
		dbget.close()	:	response.End
	Else
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, sub_opt1, sub_opt2, sub_opt3, device)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & idea  &"', '" & badge  &"', '" & cart & "', '"&device&"')"
		dbget.execute sqlstr
		Response.Write "05|end"
		dbget.close()	:	response.End
	End If
Else
		Response.Write "02|정상적인 경로로 참여해주시기 바랍니다."
		dbget.close()	:	response.End
End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
﻿<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"

%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, vBookNo
Dim eCode, LoginUserid, mode, sqlStr, device, cnt
		
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66178"
	Else
		eCode 		= "72271"
	End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
vBookNo = requestcheckvar(request("bookno"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

if mode<>"G" then
	Response.Write "Err|잘못된 접속입니다.E04"
	dbget.close: Response.End
end If

'// expiredate
If Now() > #08/11/2016 00:00:00# Then
	Response.Write "Err|이벤트가 종료되었습니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If isapp Then
	device = "A"
Else
	device = "M"
End If


sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE sub_opt1 = convert(varchar(10),getdate(),120) and evt_code = '"& eCode &"' and userid= '"&LoginUserid&"' "
rsget.Open sqlstr, dbget, 1
	mysubsctiptcnt = rsget("cnt")
rsget.close

If mysubsctiptcnt > 2 Then
	Response.Write "Err|하루 3번 응모가 가능합니다."
	dbget.close()	:	response.End
Else
	sqlStr = ""
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1, sub_opt2, device)" & vbCrlf
	sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', convert(varchar(10),getdate(),120), '" & vBookNo & "', '"&device&"')"
	dbget.execute sqlstr

	Response.write "OK|응모가 완료되었습니다."
	dbget.close()	:	response.End
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
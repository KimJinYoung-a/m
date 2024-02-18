<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : [텐바이텐 X 월드비전] Waterful Christimas, 그 세번째 이야기.
' History : 2016.07.25 유태욱
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
dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer
Dim eCode, LoginUserid, mode, sqlStr, device, snsnum, snschk, cnt
		
IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66174"
Else
	eCode 		= "71569"
End If

currenttime = date()
'															currenttime = "2016-06-20"
mode			= requestcheckvar(request("mode"),32)
snsnum 		= requestcheckvar(request("snsnum"),10)
LoginUserid	= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(currenttime >= "2016-07-25" and currenttime < "2016-08-16") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If isapp = "1" Then device = "A" Else device = "M" End If 

if mode = "snschk" Then '//SNS 클릭

	'ID당 2회 응모가능
	sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid='"&LoginUserid&"'"
	rsget.Open sqlstr, dbget, 1
		mysubsctiptcnt = rsget("cnt")
	rsget.close

	If mysubsctiptcnt < 1 Then	'1ID 1응모
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&snsnum&"', '"&device&"')"
		dbget.execute sqlstr

		sqlStr = ""
		sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" "
		rsget.Open sqlstr, dbget, 1
			totalsubsctiptcnt = rsget("cnt")
		rsget.close

		If snsnum = "tw" Then
			Response.write "OK|tw|"&totalsubsctiptcnt
		ElseIf snsnum = "fb" Then
			Response.write "OK|fb|"&totalsubsctiptcnt
		ElseIf snsnum = "ka" Then
			Response.write "OK|ka|"&totalsubsctiptcnt
		Else
			Response.write "error"
		End If

		dbget.close()	:	response.End
	ElseIf mysubsctiptcnt > 0 Then
		Response.Write "OK|end|"
		dbget.close()	:	response.End
	Else
		Response.write "Err|정상적인 경로로 참여해주시기 바랍니다."
	End If
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
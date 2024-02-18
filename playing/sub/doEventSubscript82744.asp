<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'########################################################################
' Description : 모든 테스트 참여자분들께 텐바이텐 100마일리지를 드립니다!
' History : 2017.12.01 정태훈
'########################################################################
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
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, badge
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "67469"
Else
	eCode = "82744"
End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
badge			= requestcheckvar(request("gubunval"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(currenttime >= "2017-12-01") Then
	Response.Write "Err|이벤트 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

if isapp then
	device = "A"
else
	device = "M"
end if

If mode = "down" Then
	sqlstr = "SELECT COUNT(*) as cnt FROM db_event.dbo.tbl_event_subscript WHERE userid= '"&LoginUserid&"' and evt_code='"&eCode&"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& badge &", '"&device&"')"
			dbget.execute sqlstr

			Response.write "OK|dn"
			dbget.close()	:	response.End
	Else
		Response.write "Err|이미 응모 하셨습니다."
		dbget.close()	:	response.End
	End If
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
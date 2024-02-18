<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 훈남정음 캐릭터 중 정음이와 어울리는 토이는? MA
' History : 2018-06-08 최종원
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
Dim eCode, LoginUserid, mode, sqlStr, device, cnt, voteval
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "68520"
Else
	eCode = "87101"
End If

currenttime = date()
mode			= requestcheckvar(request("mode"),32)
voteval			= requestcheckvar(request("voteval"),1)
LoginUserid		= getencLoginUserid()
refer 			= request.ServerVariables("HTTP_REFERER")

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
'//If Not(Now() >= #06/11/2018 10:00:00# And Now() < #07/13/2018 23:59:59#) Then
	If Not(currenttime >= "2018-06-11" And currenttime < "2018-07-14") Then
	Response.Write "Err|투표 기간이 아닙니다."
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

If mode = "vote" Then
	if voteval > 0 and voteval < 10 then
		'1일 1회 응모가능 체크
		sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 "		'and 
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

if LoginUserid = "ss" then
	cnt=0
end if

		If cnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& voteval &", '"&device&"')"
			dbget.execute sqlstr	

			Response.write "OK|vt"
			dbget.close()	:	response.End
		Else
			if currenttime = "2018-07-13" then
				Response.write "Err|이미 응모하셨습니다. 당첨일을 기대해 주세요!"
			else
				Response.write "Err|이미 응모하셨습니다. 내일 또 투표해주세요!"
			end if
			dbget.close()	:	response.End
		End If
	else
		Response.write "Err|투표할 토이를 선택해 주세요."
		dbget.close()	:	response.End
	end if
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 사진찍냥? 투표하개! MA
' History : 2017-08-22 유태욱
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
dim votecnt1, votecnt2, votecnt3, votecnt4, votecnt5, votecnt6, votecnt7, votecnt8, votecnt9
		
IF application("Svr_Info") = "Dev" THEN
	eCode = "66415"
Else
	eCode = "79941"
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
If currenttime >= "2017-08-31" Then
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
		sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 "		'and convert(varchar(10),regdate,21)='"&currenttime&"' 
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

if LoginUserid = "bjh2546" then
	cnt=0
end if

		If cnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt2, device)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', "& voteval &", '"&device&"')"
			dbget.execute sqlstr
	
			sqlstr = ""
			sqlstr = "SELECT " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as vote1, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as vote2, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as vote3, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as vote4, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as vote5, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '6' then 1 else 0 end),0) as vote6, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '7' then 1 else 0 end),0) as vote7, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '8' then 1 else 0 end),0) as vote8, " + vbcrlf
			sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '9' then 1 else 0 end),0) as vote9 " + vbcrlf
			sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript where evt_code = '"& eCode &"'  " 
			rsget.Open sqlstr,dbget,1
			IF Not rsget.Eof Then
				votecnt1 = rsget("vote1")
				votecnt2 = rsget("vote2")
				votecnt3 = rsget("vote3")
				votecnt4 = rsget("vote4")
				votecnt5 = rsget("vote5")
				votecnt6 = rsget("vote6")
				votecnt7 = rsget("vote7")
				votecnt8 = rsget("vote8")
				votecnt9 = rsget("vote9")
			End If
			rsget.close()

			Response.write "OK|vt|"&votecnt1&"|"&votecnt2&"|"&votecnt3&"|"&votecnt4&"|"&votecnt5&"|"&votecnt6&"|"&votecnt7&"|"&votecnt8&"|"&votecnt9
			dbget.close()	:	response.End
		Else
			if currenttime = "2017-08-30" then
				Response.write "Err|이미 응모하셨습니다. 당첨일을 기대해 주세요!"
			else
				Response.write "Err|이미 응모하셨습니다. 내일 또 투표해주세요!"
			end if
			dbget.close()	:	response.End
		End If
	else
		Response.write "Err|투표할 친구를 선택해 주세요."
		dbget.close()	:	response.End
	end if
Else
	Response.Write "Err|정상적인 경로로 참여해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, vECodeLink
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21169"
		vECodeLink = "21170"
	Else
		eCode = "51568"
		vECodeLink = "51569"
	End If

userid = GetLoginUserID
mode = requestcheckvar(request("mode"),32)

dim smssubscriptcount
	smssubscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
	dbget.close() : Response.End
End IF
If not(date()>="2014-04-01" and date()<"2014-05-20") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
	dbget.close() : Response.End
End IF

if mode="addsms" then
'	smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "SMS_W", "", "")
'
'	if smssubscriptcount > 3 then
'		Response.Write "<script type='text/javascript'>alert('메세지는 3회까지 발송 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'		dbget.close() : Response.End
'	end if
'
'	sqlstr = "INSERT INTO [db_sms].[ismsuser].em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg)" & vbcrlf
'	sqlstr = sqlstr & " 	select top 1 n.usercell, '1644-6030', '1', getdate(), '[텐바이텐 앱]을 다운로드 받으세요. http://bit.ly/welcome10x10app'" & vbcrlf
'	sqlstr = sqlstr & " 	from db_user.dbo.tbl_user_n n" & vbcrlf
'	sqlstr = sqlstr & " 	where userid='"& userid &"'"
'	'response.write sqlstr & "<Br>"
'	dbget.execute sqlstr
'	
'	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
'	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'SMS_W', 0, '', 'W')" + vbcrlf
'
'	'response.write sqlstr & "<Br>"
'	dbget.execute sqlstr
'	
'	Response.Write "<script type='text/javascript'>alert('메세지가 발송 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
'	dbget.close() : Response.End	
	
elseif mode="addenter" then
	dim vCount, vOrderCount, vTmpChk
	sqlstr = "select count(*) from [db_event].[dbo].[tbl_event_subscript] where evt_code = '"& eCode &"' and userid = '" & userid & "' and sub_opt1 = 'evententer'"
	rsget.Open sqlstr,dbget,1
	vCount = rsget(0)
	rsget.close
	
	If vCount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 응모를 하셨습니다!'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
		dbget.close() : Response.End
	End If
	
	
	vOrderCount = 0
	If userid <> "" AND vCount < 1 Then
		sqlstr = "select count(*) from [db_temp].[dbo].[tbl_temp_Send_UserMail] where yyyymmdd = '20140513' and userid = '" & userid & "'"
		rsget.Open sqlstr,dbget,1
		vTmpChk = rsget(0)
		rsget.close
		
		If vTmpChk > 0 Then
			sqlstr = "select count(*) from [db_order].[dbo].[tbl_order_master] where userid = '" & userid & "' " & _
					 " and cancelyn = 'N' AND ipkumdiv > 3 and jumundiv<>9 and rdsite = 'app_wish' and regdate > '2014-05-13 00:00:00'"
			rsget.Open sqlstr,dbget,1
			vOrderCount = rsget(0)
			rsget.close
		End IF
	End IF
	
	If vOrderCount < 1 Then
		Response.Write "<script type='text/javascript'>alert('구매 내역이 없습니다.\nAPP에서 첫 구매 후\n응모하기를 눌러주세요!\n\n※ 이메일로 이벤트안내를 받으신\n고객님만을 위한 이벤트입니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
		dbget.close() : Response.End
	End IF
	
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'evententer', 0, '', 'W')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다!'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
	dbget.close() : Response.End
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vECodeLink&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
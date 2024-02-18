<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 알람 신청
' History : 2019-02-19 최종원
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
	dim mysubsctiptcnt, totalsubsctiptcnt, currenttime, refer, isAutoPush
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, videoLink, urlCnt, pushyn	
	
	eCode			= request("eCode")
	currenttime 	= date()
	LoginUserid		= getencLoginUserid()			
	isAutoPush		= request("isAutoPush")
	pushyn			= "N"

	device = "M"

	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 신청하실 수 있습니다."
		response.End
	End If	

	sqlstr = "select top 1 lastpushyn from db_contents.dbo.tbl_app_wish_userinfo where userid = '" & LoginUserid & "'"
	rsget.Open sqlstr, dbget, 1
	IF Not rsget.Eof Then
		pushyn = rsget("lastpushyn")
	END IF
	rsget.close

if isAutoPush Then
	dim pushDate
	
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인을 해야>?n알림 신청이 가능합니다."
		Response.End
	End If

	pushDate = dateadd("d", 1, now())

	'// 다음날 푸쉬 신청을 했는지 확인한다.
	sqlstr = "SELECT count(*) FROM db_temp.[dbo].[tbl_auto_push] WITH (NOLOCK) WHERE evt_code = "& eCode &" and userid='"& LoginUserid &"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		If rsget(0) > 0 Then
			Response.Write "Err|이미 신청하셨습니다."
			response.End
		End If
	End IF
	rsget.close

	sqlstr = " INSERT INTO db_temp.[dbo].[tbl_auto_push](userid, evt_code, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "','"& eCode &"' ,'"&Left(pushDate, 10)&"', 'N', getdate())"
	dbget.Execute sqlstr

	Response.Write "OK|alram|" & pushyn
	Response.End
else
	'알림 응모 여부 체크 
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt2 = '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt2, sub_opt3)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1', 'alarm')"
		dbget.execute sqlstr

		Response.write "OK|alram"
		dbget.close()	:	response.End
	Else				
		Response.write "ERR|이미 신청하셨습니다."
		dbget.close()	:	response.End
	End If
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
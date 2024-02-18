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
dim eCode, userid, sqlstr, mode, vLinkCode
mode = requestcheckvar(request("mode"),32)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21254"			'PC웹
		vLinkCode = "21255"		'모바일
	Else
		eCode = "53921"
		vLinkCode = "53922"
	End If

userid = GetLoginUserID

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); history.go(-1);</script>"
	dbget.close()
    response.end
End IF

dim smssubscriptcount
	smssubscriptcount=0
	
	
if mode="addsms" then
	smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "SMS_W", "", "")

	if smssubscriptcount > 3 then
		Response.Write "<script type='text/javascript'>alert('메세지는 3회까지 발송 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkCode&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_sms].[ismsuser].em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg)" & vbcrlf
	sqlstr = sqlstr & " 	select top 1 n.usercell, '1644-6030', '1', getdate(), '[텐바이텐]APP 다운로드 링크 http://bit.ly/1m1OOyE'" & vbcrlf
	sqlstr = sqlstr & " 	from db_user.dbo.tbl_user_n n" & vbcrlf
	sqlstr = sqlstr & " 	where userid='"& userid &"'"
	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'SMS_W', 0, '', 'W')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr
	
	Response.Write "<script type='text/javascript'>alert('메세지가 발송 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkCode&"'</script>"
	dbget.close() : Response.End	

elseif mode="coupon" then
	Dim vQuery
	
	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '621' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		response.write "<script language='javascript'>alert('이미 다운받으셨습니다.'); parent.location.reload();</script>"
		rsget.close()
		dbget.close()
	    response.end
	End IF
	rsget.close()

	vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
			 "values('621', '" & userid & "', '2','5000','[app전용] Let''s go 8월','20000','2014-08-05 00:00:00','2014-08-07 23:59:59','',0,'system','app')"
	dbget.execute vQuery

		response.write "<script language='javascript'>alert('발급완료!\n8월 7일까지 APP에서 사용하세요!'); parent.location.reload();</script>"
		dbget.close()
	    response.end
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
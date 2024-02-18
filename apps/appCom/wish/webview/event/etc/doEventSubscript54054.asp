<% option Explicit %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
	IF Len(Request.ServerVariables("HTTP_REFERER")) = 0 Then
	   response.write "<script>alert('access is incorrect');history.back();</script>"
	   response.End
	END IF
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%

dim eCode, userid, sqlstr, mode, vLinkECode
mode = requestcheckvar(request("mode"),32)
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21258"
		vLinkECode = "21260"
	Else
		eCode = "54054"
		vLinkECode = "54056"
	End If
		response.write "<script language='javascript'>alert('이벤트가 종료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkECode&"';</script>"
		dbget.close()
	    response.end
	    
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
		Response.Write "<script type='text/javascript'>alert('메세지는 3회까지 발송 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
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
	
	Response.Write "<script type='text/javascript'>alert('메세지가 발송 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
	dbget.close() : Response.End	

elseif mode="coupon" then
	Dim vQuery

	If Now() < #08/11/2014 08:59:59# Then
		Response.Write "<script type='text/javascript'>alert('아직 이벤트 시간이 되지 않았습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
		dbget.close()
	    response.end
	End IF

	vQuery = "select count(*) from [db_user].dbo.tbl_user_coupon where masteridx = '623' and userid = '" & userid & "'"
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 다운받으셨습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
		rsget.close()
		dbget.close()
	    response.end
	End IF
	rsget.close()

	vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
			 "values('623', '" & userid & "', '2','5000','오천원의행복(APP전용 5천원)','0',getdate(),dateadd(d,1,getdate()),'',0,'system','app')"
	dbget.execute vQuery

		Response.Write "<script type='text/javascript'>alert('발급완료!\n지금부터 24시간 이내에\nAPP에서 사용하세요!'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
		dbget.close()
	    response.end
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
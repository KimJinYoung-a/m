<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 여름엔 1인 빙수
' History : 2014.07.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event53459Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, bingsugubun, onlineordercount, onlineemailyn, subscriptcount1, subscriptcount2, subscriptcount3
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	bingsugubun = requestcheckvar(request("bingsugubun"),1)

onlineordercount=0
onlineemailyn="N"
subscriptcount1=0
subscriptcount2=0
subscriptcount3=0

dim smssubscriptcount
	smssubscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-07-14" and getnowdate<"2014-07-21") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="bingsureg" then
	If bingsugubun = "" Then
		Response.Write "<script type='text/javascript'>alert('미션을 선택해 주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End IF
	
	if bingsugubun="1" then
		subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "BINGSU", "1", "")
		if subscriptcount1 > 0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if
		
		onlineordercount = get10x10onlineordercount(userid, "2014-07-10", "2014-07-21", "10x10", "app_wish", "", "N")
		if onlineordercount < 1 then
			Response.Write "<script type='text/javascript'>alert('텐바이텐APP 쇼핑 후, 응모하실 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'BINGSU', 1, '', 'M')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End

	elseif bingsugubun="2" then
		subscriptcount2 = getevent_subscriptexistscount(eCode, userid, "BINGSU", "2", "")
		if subscriptcount2 > 0 then
			Response.Write "<script type='text/javascript'>alert('이미 참여 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		onlineemailyn = get10x10onlinemailyn(userid, "Y", "Y", "")
		if onlineemailyn ="N" then
			Response.Write "<script type='text/javascript'>alert('텐바이텐 E-mail 수신동의후, 응모하실 수 있습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
			dbget.close() : Response.End
		end if

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', 'BINGSU', 2, '', 'M')" + vbcrlf
	
		'response.write sqlstr & "<Br>"
		dbget.execute sqlstr

		Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
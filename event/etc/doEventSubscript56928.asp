<%@ language=vbscript %>
<% option Explicit %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  [2014 크리스마스] NORDIC CHRISTMAS [혜택] 
' History : 2014.11.27 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event56928Cls.asp" -->

<%
dim eCode, ecodelink, userid, mode, sqlstr, refer, subscriptcount
	eCode=getevt_code
	ecodelink=getevt_codelink
	userid = getloginuserid()
	mode=requestcheckvar(request("mode"),32)

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&ecodelink&"'</script>"
	dbget.close() : Response.End
End IF

If not(getnowdate>="2014-12-01" and getnowdate<"2014-12-24") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&ecodelink&"'</script>"
	dbget.close() : Response.End
End IF	

if mode="ordereg" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	if subscriptcount > 0 then
		Response.Write "<script type='text/javascript'>alert('응모는 한번만 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&ecodelink&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 1, '', 'M')" + vbcrlf
	response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('응모완료!'); parent.top.location.href='/event/eventmain.asp?eventid="&ecodelink&"'</script>"
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&ecodelink&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
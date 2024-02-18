<%@ language=vbscript %>
<% option Explicit %>
<%
'####################################################
' Description : only for you
' History : 2014.09.05 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event54791Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer
	eCode=getevt_code
	userid = getloginuserid()
	mode=requestcheckvar(request("mode"),32)

dim onlineordercount, subscriptcount
	onlineordercount=0
	subscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-09-10" and getnowdate<"2014-10-01") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF

if mode="ordereg" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	if subscriptcount > 0 then
		Response.Write "<script type='text/javascript'>alert('이미 응모 하셨습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	
	onlineordercount = getorderdetailcount(userid, "2014-09-10", "2014-10-06", "N", "Y")
	if onlineordercount < 1 then
		Response.Write "<script type='text/javascript'>alert('웨딩기획전 둘러 보셨나요?\n기획전 상품 구매후 다시 응모하러 와주세요.!'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '', 0, '', 'W')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('응모가 완료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End

else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
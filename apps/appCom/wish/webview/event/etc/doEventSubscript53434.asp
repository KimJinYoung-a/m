<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐텐 앱으로 떠나는 나만의 여름휴가
' History : 2014.07.10 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event53434Cls.asp" -->

<%
dim eCode, userid, mode, sqlstr, refer, vacationgubun, subscriptcount, osubscriptgubun, subscriptgubun, subscriptconfirmyn
	eCode=getevt_code
	userid = getloginuserid()
	mode = requestcheckvar(request("mode"),32)
	vacationgubun = requestcheckvar(request("vacationgubun"),1)

subscriptcount=0

dim smssubscriptcount
	smssubscriptcount=0

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF
If not(getnowdate>="2014-07-14" and getnowdate<"2014-07-21") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
End IF

if mode="vacationreg" then
	set osubscriptgubun = new Cevent_etc_common_list
		osubscriptgubun.frectevt_code=eCode
		osubscriptgubun.frectuserid=userid
		osubscriptgubun.frectsub_opt1=getnowdate
		osubscriptgubun.event_subscript_one
		
		subscriptcount = osubscriptgubun.ftotalcount

		if osubscriptgubun.ftotalcount>0 then
			subscriptgubun = osubscriptgubun.FOneItem.fsub_opt2
			subscriptconfirmyn = osubscriptgubun.FOneItem.fsub_opt3
		end if
	set osubscriptgubun=nothing
	
	if subscriptcount < 1 then
		Response.Write "<script type='text/javascript'>alert('웹이나 모바일웹에서 먼저 참여 하세요.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	end if
	
	If subscriptconfirmyn = "Y" Then
		Response.Write "<script type='text/javascript'>alert('이미 앱에서 참여 하셨습니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "update [db_event].[dbo].[tbl_event_subscript]" + vbcrlf
	sqlstr = sqlstr & " set sub_opt3='Y' where" + vbcrlf
	sqlstr = sqlstr & " evt_code='"& eCode &"' and userid='"& userid &"' and sub_opt1='"& getnowdate &"'"

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr

	Response.Write "<script type='text/javascript'>alert('참여해 주셔서 감사합니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid="&getevt_codepage&"'</script>"
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  우수고객이벤트 우수한 고객님께 우수수 드립니다!
' History : 2014.04.11 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->

<%
dim eCode, userid, sqlstr, subscriptcount, evtOpt, i, intLoop, QuizGubun, ePageSt, refer, mode, murl
	mode = requestcheckvar(request("mode"),32)
	QuizGubun = requestcheckvar(request("QuizGubun"),32)
	murl = requestcheckvar(request("murl"),10)
	ePageSt = requestcheckvar(request("ePageSt"),32)
	userid = getloginuserid()

	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21142
	Else
		eCode   =  51126
	End If

subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

'//response.write mode&"<br>"&QuizGubun&"<br>"&ePageSt&"<br>"&userid&"<br>"&subscriptcount
'//response.End

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
	dbget.close() : Response.End
End IF

if mode="ususuevent" then
	if QuizGubun="" then
		Response.Write "<script type='text/javascript'>alert('수수께끼를 풀어주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
		dbget.close() : Response.End
	end If
	
	if ePageSt="" then
		Response.Write "<script type='text/javascript'>alert('맘에 드는 리뉴얼 이벤트 페이지를 골라주세요.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
		dbget.close() : Response.End
	end if

	
	if subscriptcount > 1 then
		Response.Write "<script type='text/javascript'>alert('1회만 응모가 가능 합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
		dbget.close() : Response.End
	end if

	dim tmpSelIid, vFidx, myfavorite

	If Not(getnowdate>="2014-04-14" and getnowdate<"2014-04-22") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
		dbget.close() : Response.End
	End IF

	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&QuizGubun&"', 0, '"&ePageSt&"')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr


	Response.Write "<script type='text/javascript'>alert('응모가 완료 되었습니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&murl&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
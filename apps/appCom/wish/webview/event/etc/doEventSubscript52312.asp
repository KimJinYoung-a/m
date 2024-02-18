<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  선택 10x10, 투표를 합시다
' History : 2014.05.30 원승현 생성
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
dim eCode, userid, sqlstr, subscriptcount, evtOpt, i, intLoop, QuizGubun, ePageSt, refer, mode, murl, productName, votevalue, vVotechk, vsql, voteContent
	mode = requestcheckvar(request("mode"),32)
	votevalue = requestcheckvar(request("votevalue"),32)
	userid = getloginuserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21190
	Else
		eCode   =  52312
	End If

	vsql = " Select top 1 sub_opt1, sub_opt3, userid From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&Left(Now(), 10)&"' "
	rsget.Open vsql,dbget
	IF not rsget.EOF THEN
		vVotechk = True
	else
		vVotechk = False
	END IF
	rsget.close


'//response.write mode&"<br>"&QuizGubun&"<br>"&ePageSt&"<br>"&userid&"<br>"&subscriptcount
'//response.End

refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="vote" then
	if votevalue="" then
		Response.Write "<script type='text/javascript'>alert('투표를 해주세요.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end If
	
	if vVotechk then
		Response.Write "<script type='text/javascript'>alert('1일 1회만 투표가능합니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	dim tmpSelIid, vFidx, myfavorite

	If Not(getnowdate>="2014-05-30" and getnowdate<"2014-06-04") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If


	Select Case Trim(votevalue)

		Case "1"
			voteContent = "기호1번 소니엔젤"

		Case "2"
			voteContent = "기호2번 심슨"

		Case "3"
			voteContent = "기호3번 아이언맨"

	End Select
	
	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&votevalue&"', 0, '"&voteContent&"')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr


	Response.Write "<script type='text/javascript'>alert('투표가 완료 되었습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
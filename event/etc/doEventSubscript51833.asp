<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  구매금액별 사은 이벤트(어른들은 갖고 싶다!)
' History : 2014.05.15 원승현 생성
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
dim eCode, userid, sqlstr, subscriptcount, evtOpt, i, intLoop, QuizGubun, ePageSt, refer, mode, murl, productName, votecode
	mode = requestcheckvar(request("mode"),32)
	votecode = requestcheckvar(request("votecode"),32)
	userid = getloginuserid()

	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21172
	Else
		eCode   =  51833
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
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

if mode="vote" then
	if votecode="" then
		Response.Write "<script type='text/javascript'>alert('소유하고픈 에디션을 선택 해주세요!'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end If
	
	if subscriptcount > 1 then
		Response.Write "<script type='text/javascript'>alert('투표는 1회만 가능합니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if

	dim tmpSelIid, vFidx, myfavorite

	If Not(getnowdate>="2014-05-15" and getnowdate<"2014-05-24") Then
		Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If
	
	Select Case Trim(votecode)
		Case "1023970"
			productName = "블록&레고"
			murl = "/event/eventmain.asp?eventid=51947"
		
		Case "971073"
			productName = "귀여운미니어쳐"
			murl = "/event/eventmain.asp?eventid=51948"

		Case "635571"
			productName = "생생한R/C토이"
			murl = "/event/eventmain.asp?eventid=51949"

		Case Else
			productName = ""
			murl = ""
	End Select


	sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, sub_opt3)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"&votecode&"', 0, '"&productName&"')" + vbcrlf

	'response.write sqlstr & "<Br>"
	dbget.execute sqlstr


	Response.Write "<script type='text/javascript'>alert('투표가 완료 되었습니다.'); parent.top.location.href='"&murl&"'</script>"
	dbget.close() : Response.End	
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
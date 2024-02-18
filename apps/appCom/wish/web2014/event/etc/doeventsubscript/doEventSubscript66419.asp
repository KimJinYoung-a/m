<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  order 참 잘했어요
' History : 2015.09.24 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode="64897"
Else
	eCode="66419"
End If

dim currenttime
	currenttime =  now()
	'currenttime = #09/25/2015 09:00:00#

dim userid
	userid = GetEncLoginUserID()

dim mode , sqlStr
Dim vQuery, vTotalCount , vTotalSum , sub_opt2
	sub_opt2 = requestCheckVar(Request("spoint"),1)
	mode = requestcheckvar(request("mode"),32)

dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "<script type='text/javascript'>alert('잘못된 접속입니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

If not( left(currenttime,10)>="2015-09-25" and left(currenttime,10)<"2015-10-01" ) Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End If
If userid="" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End If

if mode="myorder" then
	'//9월 구매 내역 체킹 (응모는 9월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-09-01', '2015-10-01', '10x10', '', 'issue' "

	'response.write sqlStr & "<br>"
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		vTotalCount = rsget("cnt")
		vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
	rsget.Close
	'vTotalCount=1
	'vTotalSum=1000

	Response.write "<div id='tcnt'>"& vTotalCount &"</div><div id='tsum'>"& FormatNumber(vTotalSum,0) &"</div>"
	dbget.close()	:	response.End

elseif mode="add" then
	If sub_opt2="" Then
		Response.Write "<script type='text/javascript'>alert('사은품을 선택해 주세요.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	'//9월 구매 내역 체킹 (응모는 9월 구매고객만 가능)
	vQuery = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-09-01', '2015-10-01', '10x10', '', 'issue'"

	'response.write vQuery & "<br>"
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open vQuery,dbget,1
		vTotalCount = rsget("cnt")
	rsget.Close

	'vTotalCount=1

	If vTotalCount < 1 Then
		Response.Write "<script type='text/javascript'>alert('9월 구매이력이 있는 고객만 참여 하실 수 있습니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

	'나의 참여수
	vTotalCount = getevent_subscriptexistscount(eCode, userid, "", "", "")

	If vTotalCount > 0 Then
		Response.Write "<script type='text/javascript'>alert('이미 이벤트 응모가 완료되었습니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	Else
		vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2 , device) VALUES('" & eCode & "', '" & userid & "','"& sub_opt2 &"' , 'A')"

		'response.write vQuery & "<br>"
		dbget.Execute vQuery

		Response.Write "<script type='text/javascript'>alert('응모가 완료되었습니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If
else
	Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='"& appUrlPath &"/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
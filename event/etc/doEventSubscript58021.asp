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
' Description : 별에서 온 운세 (mobile)
' History : 2014.12.26 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%


dim eCode, userid, mode, sqlstr, refer, vLinkECode, userBirth
	userid = getloginuserid()

	IF application("Svr_Info") = "Dev" Then
		eCode = "21421"
		vLinkECode = "21422"
	Else
		eCode = "58020"
		vLinkECode = "58021"
	End If

refer = request.ServerVariables("HTTP_REFERER")
userBirth = requestCheckvar(request("userBirth"),20)



if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "99"
	dbget.close() : Response.End
end if


If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&vLinkECode&"'</script>"
	dbget.close() : Response.End
End If

If not(left(Now(),10)>="2014-12-26" and left(Now(),10)<"2015-01-12") Then
	Response.Write "88"
	dbget.close() : Response.End
End IF

Dim vQuery, vTotalCount, vItemID, vtemp, k, itemcnt, acGubun

vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close
If vTotalCount > 0 Then
	response.write "66"
	dbget.close()
	response.end
Else
	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "', '"&userBirth&"','M')"
	dbget.Execute vQuery
	response.write "22"
	dbget.close()
	response.end
End IF

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
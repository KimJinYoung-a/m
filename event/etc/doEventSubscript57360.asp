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
' Description : 너의 목소리가 들려2
' History : 2014.12.04 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%
dim eCode, userid, mode, sqlstr, refer, smssubscriptcount, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount, preveCode
	userid = getloginuserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21389"
		preveCode = "21367"
	Else
		eCode = "57360"
		preveCode = "56870"
	End If



refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End If

If not(left(Now(),10)>="2014-12-04" and left(Now(),10)<"2014-12-08") Then
	Response.Write "<script type='text/javascript'>alert('이벤트 응모 기간이 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

Dim vQuery, vTotalCount, vItemID, vtemp, k, itemcnt
vItemID = requestCheckvar(request("SelChkUsrValue"),400)

If vItemID ="" Then
	vItemID=""
	itemcnt=0
End If


vtemp = Split(vItemID,",")
itemcnt = UBound(vtemp)+1


vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close
If vTotalCount > 0 Then
	response.write "<script language='javascript'>alert('이미 이벤트 응모가 완료되었습니다.'); parent.location.reload();</script>"
	dbget.close()
	response.end
Else

	vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt2, sub_opt3, device) VALUES('" & eCode & "', '" & userid & "','"&itemcnt&"','"&vItemID&"', 'M')"
	dbget.Execute vQuery
	
	response.write "<script language='javascript'>alert('마일리지 받기 응모가 완료되었습니다.'); parent.location.reload();</script>"
	dbget.close()
	response.end
End IF

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
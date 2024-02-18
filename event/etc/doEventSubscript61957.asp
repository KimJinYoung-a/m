<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : [연속구매] 꽃을 드립니다
' History : 2015-04-28 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim eCode, userid , mode , refer , sqlStr
Dim vQuery, vTotalCount , vTotalSum

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	userid = GetLoginUserID
	mode = requestcheckvar(request("mode"),32)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "61767"
	Else
		eCode = "61957"
	End If

	If Now() > #05/01/2015 00:00:00# Then
		response.write "<script language='javascript'>alert('이벤트가 종료되었습니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	End If

	If userid = "" Then
		response.write "<script language='javascript'>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
		dbget.close() : Response.End
	End If
	
	if mode="myorder" then
		'내 주문건 조회
		sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-04-01', '2015-05-01', '10x10', '', 'issue' "
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			vTotalCount = rsget("cnt")
			vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
		rsget.Close

		Response.write "<div id='tcnt'>"& vTotalCount &"</div><div id='tsum'>"& FormatNumber(vTotalSum,0) &"</div>"
		dbget.close()	:	response.End
	elseif mode="add" then
		'//응모
		vQuery = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-04-01', '2015-05-01', '10x10', '', 'issue' "
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open vQuery,dbget,1
			vTotalCount = rsget("cnt")
		rsget.Close

		If vTotalCount < 1 Then
			response.write "<script language='javascript'>alert('4월 구매내역이 없습니다.\n구매 후, 다시 응모하러 와주세요!'); parent.location.reload();</script>"
			dbget.close()
			response.end
		End If

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
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid) VALUES('" & eCode & "', '" & userid & "')"
			dbget.Execute vQuery
			
			response.write "<script language='javascript'>alert('응모가 완료되었습니다.'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End If
	else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
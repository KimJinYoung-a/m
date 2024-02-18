<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
%>
<%
'####################################################
' Description :  어느 가을날로부터의 선물 ver.2 
' History : 2014.12.18 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21413"
	Else
		eCode = "57876"
	End If

If Now() > #01/01/2015 00:00:00# Then
	response.write "<script language='javascript'>alert('이벤트가 종료되었습니다.'); parent.location.reload();</script>"
	dbget.close()
    response.end
End If

userid = GetLoginUserID

If userid = "" Then
	response.write "<script language='javascript'>alert('잘못된 접근입니다.'); parent.location.reload();</script>"
	dbget.close()
    response.end
End IF

Dim vQuery, vTotalCount, vItemID
vItemID = requestCheckvar(request("itemid"),7)


	vQuery = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2014-12-01', '2015-01-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open vQuery,dbget,1
		vTotalCount = rsget("cnt")
	rsget.Close
	
	If vTotalCount < 1 Then
		response.write "<script language='javascript'>alert('12월 구매내역이 없습니다.\n구매 후, 다시 응모하러 와주세요!'); parent.location.reload();</script>"
		dbget.close()
	    response.end
	End IF

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

			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, device) VALUES('" & eCode & "', '" & userid & "', 'M')"
			dbget.Execute vQuery
			
			response.write "<script language='javascript'>alert('응모가 완료되었습니다.\n추첨을 통해\n200분께 선물을 드립니다!'); parent.location.reload();</script>"
			dbget.close()
		    response.end
		End IF
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
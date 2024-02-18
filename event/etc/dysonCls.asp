<%
Class CDyson
	Public FRectUserID
	Public FTotalCount
	Public FECode

	'/디비캐쉬		'/2015.12.28 한용민 생성
	Public Sub GetDysonCount
		Dim strSQL, i
        Dim rsMem

		strSQL = ""
		strSQL = strSQL & " select count(*) as cnt" & VBCRLF
		strSQL = strSQL & " 	FROM [db_event].[dbo].[tbl_event_subscript]" & VBCRLF
		strSQL = strSQL & " 	WHERE evt_code = '"&FECode&"'" & VBCRLF
		strSQL = strSQL & " 	and userid = '"&FRectUserID&"'"
		rsget.Open strSQL,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
	End Sub

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
End Class
%>
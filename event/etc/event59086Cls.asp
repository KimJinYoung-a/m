<%	'모바일
Class evt_59086
	Public FList()
	Public FTotalCount
	Public FPageSize
	Public FCurrPage
	Public FResultCount
	Public FTotalPage
	Public FPageCount
	Public FScrollCount
	Public FeCode

	Public FRectUserid
	Public FRectOrderBy
	Public FRectEventID
	

	Public Function fnEvent_59086_Best
		Dim strSQL, i

		strSQL = "SELECT * FROM " & VBCRLF
		strSQL = strSQL & "( " & VBCRLF
		strSQL = strSQL & "	SELECT Top 1 idx, userid, question, comment, likeCnt, regdate, device FROM [db_temp].[dbo].[tbl_event_59086] " & VBCRLF
		strSQL = strSQL & "	WHERE question = '1' ORDER BY likeCnt DESC, idx DESC " & VBCRLF
		strSQL = strSQL & ") AS q1 " & VBCRLF
		strSQL = strSQL & "UNION ALL " & VBCRLF
		strSQL = strSQL & "SELECT * FROM " & VBCRLF
		strSQL = strSQL & "( " & VBCRLF
		strSQL = strSQL & "	SELECT Top 1 idx, userid, question, comment, likeCnt, regdate, device FROM [db_temp].[dbo].[tbl_event_59086] " & VBCRLF
		strSQL = strSQL & "	WHERE question = '2' ORDER BY likeCnt DESC, idx DESC " & VBCRLF
		strSQL = strSQL & ") AS q2 " & VBCRLF
		strSQL = strSQL & "UNION ALL " & VBCRLF
		strSQL = strSQL & "SELECT * FROM " & VBCRLF
		strSQL = strSQL & "( " & VBCRLF
		strSQL = strSQL & "	SELECT Top 1 idx, userid, question, comment, likeCnt, regdate, device FROM [db_temp].[dbo].[tbl_event_59086] " & VBCRLF
		strSQL = strSQL & "	WHERE question = '3' ORDER BY likeCnt DESC, idx DESC " & VBCRLF
		strSQL = strSQL & ") AS q3"

		'response.write strSQL
		rsget.open strSQL, dbget, 1
		If Not rsget.Eof Then
			fnEvent_59086_Best = rsget.getRows()
		End If
		rsget.close

	End Function
	
	
	Public Function fnEvent_59086_List
		Dim strSQL, i, vOrderBy
		
		strSQL = "SELECT COUNT(A.idx), CEILING(CAST(Count(A.idx) AS FLOAT)/" & FPageSize & ") FROM [db_temp].[dbo].[tbl_event_59086] AS A"
		rsget.open strSQL, dbget, 1
		If Not rsget.Eof Then
			FTotalCount = rsget(0)
			FTotalPage = rsget(1)
		End If
		rsget.close

		If FRectOrderBy = "1" Then
			vOrderBy = "A.likeCnt DESC, A.idx DESC"
		Else
			vOrderBy = "A.idx DESC, A.likeCnt DESC"
		End If

		strSQL = "SELECT Top " & FPageSize & " A.idx, A.userid, A.question, A.comment, A.likeCnt, A.regdate, A.device, " & VBCRLF
		strSQL = strSQL & "case when C.idx is not null then 'o' else 'x' end as ismine " & VBCRLF
		strSQL = strSQL & "FROM [db_temp].[dbo].[tbl_event_59086] AS A " & VBCRLF
		strSQL = strSQL & "LEFT JOIN [db_temp].[dbo].[tbl_event_click_log] AS C ON C.eventid = '" & FRectEventID & "' AND C.chkid = '" & FRectUserid & "' AND C.temp1 = A.idx " & VBCRLF
		strSQL = strSQL & "WHERE A.idx Not IN( " & VBCRLF
		strSQL = strSQL & "		select top " & FPageSize*(FCurrPage-1) & " B.idx FROM [db_temp].[dbo].[tbl_event_59086] AS B " & VBCRLF
		strSQL = strSQL & "		order by " & Replace(vOrderBy,"A.","B.") & " " & VBCRLF
		strSQL = strSQL & ") " & VBCRLF
		strSQL = strSQL & "ORDER BY " & vOrderBy & ""

		'response.write strSQL
		rsget.open strSQL, dbget, 1
		If Not rsget.Eof Then
			fnEvent_59086_List = rsget.getRows()
		End If
		rsget.close

	End Function
End Class

%>
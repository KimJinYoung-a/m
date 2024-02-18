<%
'----------------------------------------------------
' ClsEvtCont : 이벤트 내용
'----------------------------------------------------
Class ClsRenewal
   	public FRectUserID

	'##### 이벤트 내용 ######
	public Function fnGetRenewal
		Dim strSql
		IF 	FECode = "" THEN Exit Function
		FGimg = ""
		strSql ="[db_event].[dbo].sp_Ten_event_content ("&FECode&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
			END IF
		rsget.close
	END Function

	public Function fnRenewVote(obj)
		Dim sqlStr
        sqlStr = "select count(idx) as cnt "
        sqlStr = sqlStr + " from [db_temp].[dbo].[tbl_renewal_vote]"
        sqlStr = sqlStr + " where vote=" & obj
		rsget.Open sqlStr, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnRenewVote = rsget("cnt")
		END IF
		rsget.close
	End Function

    public Function fnRenewMyVote()
		Dim sqlStr
        sqlStr = "select top 1 vote"
        sqlStr = sqlStr + " from [db_temp].[dbo].[tbl_renewal_vote]"
        sqlStr = sqlStr + " where userid='" & FRectUserID & "'"
		rsget.Open sqlStr, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnRenewMyVote = rsget("vote")
		END IF
		rsget.close
	End Function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

    End Sub
END Class
%>
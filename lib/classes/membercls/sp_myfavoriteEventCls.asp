<%  
Class CMyFavoriteEvent 
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FSPageNo
	public FEPageNo
	public FselOp

	public FUserId
	public FevtCode
	public FevtCategory
	public FevtDispCate
	public FevtKind
	public FevtStat

	'//관심이벤트 리스트  
	public Function fnGetMyFavoriteEventList
  		Dim strSql
		strSql ="[db_my10x10].[dbo].[sp_Ten_myfavorite_event_getListCnt]('"&Fuserid&"','"&FevtCategory&"'," & FevtKind & ",'" & FevtStat & "','" & FevtDispCate & "')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
		END IF
		rsget.close
		 
		IF FTotalCount > 0 THEN
		FSPageNo = (FPageSize*(FCurrPage-1)) + 1
		FEPageNo = FPageSize*FCurrPage		
		
		strSql ="[db_my10x10].[dbo].[sp_Ten_myfavorite_event_getList]('"&Fuserid&"','"&FevtCategory&"',"&FSPageNo&","&FEPageNo&",'"&FselOp&"'," & FevtKind & ",'" & FevtStat & "','" & FevtDispCate & "')"	 
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMyFavoriteEventList = rsget.getRows()
		END IF
		rsget.close
		END IF
	End Function  

	'//관심이벤트 리스트 (2013용) 
	public Function fnGetMyFavoriteEventList2013
  		Dim strSql
		strSql ="[db_my10x10].[dbo].[sp_Ten_myfavorite_event_getListCnt_2013]('"&Fuserid&"','"&FevtCategory&"'," & FevtKind & ",'" & FevtStat & "','" & FevtDispCate & "')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
		END IF
		rsget.close
		 
		IF FTotalCount > 0 THEN
		FSPageNo = (FPageSize*(FCurrPage-1)) + 1
		FEPageNo = FPageSize*FCurrPage		
		
		strSql ="[db_my10x10].[dbo].[sp_Ten_myfavorite_event_getList_2013]('"&Fuserid&"','"&FevtCategory&"',"&FSPageNo&","&FEPageNo&",'"&FselOp&"'," & FevtKind & ",'" & FevtStat & "','" & FevtDispCate & "')"	 
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetMyFavoriteEventList2013 = rsget.getRows()
		END IF
		rsget.close
		END IF
	End Function

	'// 내 관심 이벤트 확인
	public function fnIsMyFavEvent()
		Dim strSql
		strSql ="[db_my10x10].[dbo].[sp_Ten_myfavorite_event_check]('" & Fuserid & "'," & FevtCode & ")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			if rsget(0) then
				fnIsMyFavEvent = true
			else
				fnIsMyFavEvent = false
			end if
		else
			fnIsMyFavEvent = false
		END IF
		rsget.close
	end Function
End Class

Class CProcMyFavoriteEvent
public FUserID
public FEvtCode
	
	'//관심이벤트 등록
	 public Function fnSetMyFavoriteEvent 
	 Dim objCmd,returnValue
  	Set objCmd = Server.CreateObject("ADODB.COMMAND")  					
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText  		
			.CommandText = "{?= call db_my10x10.[dbo].[sp_Ten_myfavorite_event_insert]('"&FUserID&"',"&FEvtCode&")}"							 
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With	
		    returnValue = objCmd(0).Value	
		Set objCmd = nothing 
		fnSetMyFavoriteEvent = returnValue 
	End Function
	
	'//관심이벤트 삭제
	public Function fnDelMyFavoriteEvent 
	 Dim objCmd,returnValue, arrevtcode, i
	 Dim iRValue
	 iRValue = 1
	 
	 arrevtcode = split(FEvtCode,",")
	 
	 For i = 0 To UBound(arrevtcode)
  	Set objCmd = Server.CreateObject("ADODB.COMMAND")  					
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText  		
			.CommandText = "{?= call db_my10x10.[dbo].[sp_Ten_myfavorite_event_Delete]('"&FUserID&"',"&Trim(arrevtcode(i))&")}"							 
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With	
		    returnValue = objCmd(0).Value	
		Set objCmd = nothing 
		IF returnValue = 0 THEN
			iRValue = 0
		END IF
		Next 
		fnDelMyFavoriteEvent = iRValue 
	End Function
 
End Class 

%>
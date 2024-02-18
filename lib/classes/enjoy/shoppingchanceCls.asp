<%
Class ClsShoppingChance

 public FCPage	'Set 현재 페이지
 public FPSize	'Set 페이지 사이즈
 public FTotCnt	'Get 전체 레코드 갯수

 public FSCType		'전체/세일/사은/상품후기/신규/마감임박/랜덤 구분
 public FSCategory 	'카테고리 대분류
 public FSCateMid 	'카테고리 중분류
 public FEScope		'이벤트 범위
 public FselOp		'이벤트 정렬
 public FUserID		'나의 이벤트
 public Fis2014renew	'2014리뉴얼구분

	'###fnGetBannerList : 배너리스트  ###
	public Function fnGetBannerList
	Dim  strSql, strSqlCnt

		strSqlCnt ="EXEC [db_event].[dbo].sp_Ten_event_shoppingchance_listCnt_Mobile '"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ""
		rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotCnt = rsget(0)
		END IF
		rsget.close
		'response.write strSqlCnt
		IF FTotCnt > 0 THEN
			strSql = "EXEC [db_event].[dbo].sp_Ten_event_shoppingchance_list_Mobile "&FCPage&","&FPSize&",'"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FselOp&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ""
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc	
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetBannerList = rsget.GetRows()
			END IF
			rsget.close
		END If
		'response.write strSql

	End Function

	'###fnGetAppBannerList : APP용 배너리스트(모바일:19,앱이벤트:25 병합)  ###
	public Function fnGetAppBannerList
	Dim  strSql, strSqlCnt

		strSqlCnt ="EXEC [db_event].[dbo].sp_Ten_event_shoppingchance_listCnt_App '"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ""
		rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotCnt = rsget(0)
		END IF
		rsget.close

		IF FTotCnt > 0 THEN
			strSql = "EXEC [db_event].[dbo].sp_Ten_event_shoppingchance_list_App "&FCPage&","&FPSize&",'"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FselOp&"'" & CHKIIF(FUserID<>"",",'"&FUserID&"'",",''") & "" & CHKIIF(Fis2014renew="o",",'o'","") & ""
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetAppBannerList = rsget.GetRows()
			END IF
			rsget.close
		END IF
	End Function

End Class
%>
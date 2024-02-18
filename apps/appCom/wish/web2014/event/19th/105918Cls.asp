<%

'----------------------------------------------------
' ClsEvtBBS : 이벤트 게시판
'----------------------------------------------------
Class ClsEvtBBS
	
	public FECode   '이벤트 코드 
	public FCPage	'Set 현재 페이지
 	public FPSize	'Set 페이지 사이즈 	
 	public FTotCnt	'Get 전체 레코드 갯수
    
    public Fuserid
    public Fsubject
    public Fcontent
    public FuserName
    public Fweather
    public Fpicture
    public Fscore
    public Fegdate
    public FPreviousIDX
    public FNextIDX

    public FEBidx
    public FsortDiv
    public FsearchTxt
    public FgoodCNT

	'##### 리스트 ######
	public Function fnGetBBSList
		Dim strSqlcnt,strSql
		IF FTotCnt = -1 THEN
			strSqlcnt ="[db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryListCOUNT_Get] " & FECode & ",'" & FsearchTxt & "'"
			rsget.Open strSqlcnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FTotCnt = rsget(0)			
			END IF	
			rsget.close
		END IF
		IF FTotCnt > 0 THEN
			strSql ="[db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryList_Get] " & FECode & "," & FCPage & "," & FPSize & "," & FsortDiv & ",'" & FsearchTxt & "'"
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetBBSList = rsget.GetRows()		
			END IF	
			rsget.close	
		END IF	
	End Function

	'##### TOP 3 리스트 ######
	public Function fnGetBBSTOP3List
		Dim strSqlcnt,strSql
        strSql ="[db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryTOP3_Get] " & FECode & ""
        rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
        IF Not (rsget.EOF OR rsget.BOF) THEN
            fnGetBBSTOP3List = rsget.GetRows()		
        END IF	
        rsget.close	
	End Function
			
	'##### 내용 ######			
	public Function fnGetBBSContent
		Dim strSql
		IF 	FEBidx = "" THEN Exit Function	
		strSql ="[db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryView_Get] " & FEBidx			
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				Fuserid      = rsget("userid")
				Fsubject   = rsget("evtbbs_subject")
				Fcontent   = rsget("evtbbs_content")
				FuserName	 = rsget("evtbbs_img1")
				Fweather	 = rsget("evtbbs_img2")
				Fpicture 	 = rsget("evtbbs_icon")
				Fscore   = rsget("evtcomment_cnt")	
				Fegdate   = rsget("evtbbs_regdate")
			END IF	
		rsget.close	
	END Function

	'##### 이전글, 다음글 ######
	public Function fnGetBestDiaryNext
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="EXEC [db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryBestNext_Get] " & FECode & ", " & FgoodCNT			
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FNextIDX = rsget("evtbbs_idx")
			ELSE
				FNextIDX = 0
			END IF
		rsget.close	
	END Function

	public Function fnGetBestDiaryPrevious
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="EXEC [db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryBestPrevious_Get] " & FECode & ", " & FgoodCNT			
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FPreviousIDX = rsget("evtbbs_idx")
			ELSE
				FPreviousIDX = 0
			END IF
		rsget.close	
	END Function

	public Function fnGetDiaryPrevious
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="EXEC [db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryListPrevious_Get] " & FECode & ", " & FEBidx & "," & FgoodCNT & "," & FsortDiv & ",'" & FsearchTxt & "'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FPreviousIDX = rsget("evtbbs_idx")
			ELSE
				FPreviousIDX = 0
			END IF
		rsget.close	
	END Function

	public Function fnGetDiaryNext
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="EXEC [db_event].[dbo].[usp_WWW_19THEvent_PictureDiaryListNext_Get] " & FECode & ", " & FEBidx & "," & FgoodCNT & "," & FsortDiv & ",'" & FsearchTxt & "'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FNextIDX = rsget("evtbbs_idx")
			ELSE
				FNextIDX = 0
			END IF
		rsget.close	
	END Function

End Class
%>
<%

'----------------------------------------------------
' ClsEvtBBS : 이벤트 게시판
'----------------------------------------------------
Class ClsEvtBBS
	
	public FECode   '이벤트 코드 
	public FCPage	'Set 현재 페이지
 	public FPSize	'Set 페이지 사이즈 	
 	public FTotCnt	'Get 전체 레코드 갯수
    
    public FEBidx
    public Fuserid
    public FEBsubject
    public FEBcontent
    public FEBimg1
    public FEBimg2
    public FEBicon
    public FEBOimg1
    public FEBOimg2
    public FEBOicon
    public FEBhit
    public FEBcommcnt
    public FEBregdate
    public FESidx

	'##### 리스트 ######
	public Function fnGetBBSList
		Dim strSqlcnt,strSql
		IF FTotCnt = -1 THEN
			strSqlcnt ="[db_event].[dbo].sp_Ten_event_bbs_listcnt ("&FECode&")"		
			rsget.Open strSqlcnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FTotCnt = rsget(0)			
			END IF	
			rsget.close			
		END IF
		IF FTotCnt > 0 THEN
			strSql ="[db_event].[dbo].sp_Ten_event_bbs_list ("&FECode&","&FCPage&","&FPSize&")"			
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetBBSList = rsget.GetRows()		
			END IF	
			rsget.close	
		END IF	
	End Function
		
			
	'##### 내용 ######			
	public Function fnGetBBSContent
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="[db_event].[dbo].sp_Ten_event_bbs_content ("&FEBidx&")"			
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FEBidx     	 = rsget("evtbbs_idx")
				Fuserid      = rsget("userid")
				FEBsubject   = rsget("evtbbs_subject")
				FEBcontent   = rsget("evtbbs_content")
				FEBOimg1	 = rsget("evtbbs_img1")
				FEBOimg2	 = rsget("evtbbs_img2")
				FEBOicon 	 = rsget("evtbbs_icon")
				FEBimg1      = staticImgUrl&"/contents/photo_event/"&FECode&"/"&rsget("evtbbs_img1")
				FEBimg2      = staticImgUrl&"/contents/photo_event/"&FECode&"/"&rsget("evtbbs_img2")
				FEBicon      = staticImgUrl&"/contents/photo_event/"&FECode&"/"&rsget("evtbbs_icon")
				FEBhit       = rsget("evtbbs_hit")
				FEBcommcnt   = rsget("evtcomment_cnt")	
				FEBregdate   = rsget("evtbbs_regdate")
			END IF	
		rsget.close	
	END Function

	'##### 이전글, 다음글 ######
	public Function fnGetBBSPreNextList(pnMode)
		Dim strSql
		IF 	FECode = "" THEN Exit Function	
		strSql ="[db_event].[dbo].sp_Ten_event_bbs_PreNext ("&FECode&","&FEBidx&",'"&pnMode&"')"			
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FESidx     	 = rsget("evtbbs_idx")
				Fuserid      = rsget("userid")
				FEBsubject   = rsget("evtbbs_subject")
				FEBhit       = rsget("evtbbs_hit")
				FEBregdate   = rsget("evtbbs_regdate")
			ELSE
				FESidx = null
			END IF
		rsget.close	
	END Function

End Class

'----------------------------------------------------
' ClsEvtBBS : 이벤트 코멘트
'----------------------------------------------------
Class ClsEvtComment
	
	public FECode   '이벤트 코드 
	public FEBidx   '이벤트 게시판 코드
	public FCPage	'Set 현재 페이지
 	public FPSize	'Set 페이지 사이즈 	
 	public FTotCnt	'Get 전체 레코드 갯수 
 	public FComGroupCode	'이벤트구분 그룹코드(소풍가는 길 회차)
 	
 	public FGubun
 	public FUserID
 	public FCommentTxt
 	public FResult
 	 	
	public Function fnGetComment
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0	
		strSql ="[db_event].[dbo].sp_Ten_event_comment ("&FECode&","&FComGroupCode&","&FEBidx&","&FCPage&","&FPSize&","&FTotCnt&")"		
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN			
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN 
				FTotCnt = 0 
				rsget.close	
				Exit Function
			END IF	
			FTotCnt = arrList(5,0)			
			fnGetComment = arrList	
		END IF	
		rsget.close			
	End Function

	public Function fnGetCommentASC
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0	
		strSql ="[db_event].[dbo].sp_Ten_event_commentASC ("&FECode&","&FComGroupCode&","&FEBidx&","&FCPage&","&FPSize&","&FTotCnt&")"		
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN			
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN 
				FTotCnt = 0 
				rsget.close	
				Exit Function
			END IF	
			FTotCnt = arrList(5,0)			
			fnGetCommentASC = arrList	
		END IF	
		rsget.close			
	End Function
	
	public Function fnGetMyComment
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0	
		strSql ="[db_event].[dbo].sp_Ten_event_comment_2010openevent ("&FECode&","&FComGroupCode&","&FEBidx&","&FCPage&","&FPSize&","&FTotCnt&",'"&FUserID&"')"		
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN			
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN 
				FTotCnt = 0 
				rsget.close	
				Exit Function
			END IF	
			FTotCnt = arrList(5,0)			
			fnGetMyComment = arrList	
		END IF	
		rsget.close			
	End Function
	
	public Function fnGetCommentUpdate
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_comment_update ('"&FGubun&"','"&FUserID&"','"&FEBidx&"','"&FCommentTxt&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FResult = rsget(0)
			ELSE
				FResult = null
			END IF
		rsget.close	
	End Function

	public Function fnGetCommentWithItem
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0	
		strSql ="[db_event].[dbo].sp_Ten_event_commentWithItem ("&FECode&","&FComGroupCode&","&FEBidx&","&FCPage&","&FPSize&","&FTotCnt&")"		
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN			
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN 
				FTotCnt = 0 
				rsget.close	
				Exit Function
			END IF	
			FTotCnt = arrList(5,0)			
			fnGetCommentWithItem = arrList	
		END IF	
		rsget.close			
	End Function

	public Function fnGetSubScriptComment
		Dim strSql, arrList
		IF FEBidx = "" THEN FEBidx =0
		IF FComGroupCode = "" THEN FComGroupCode = 0	
		strSql ="[db_event].[dbo].sp_Ten_event_subscript_comment ("&FECode&","&FCPage&","&FPSize&","&FTotCnt&",'"&FUserID&"')"		
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN			
			arrList = rsget.GetRows()
			IF isNull(arrList(0,0)) THEN 
				FTotCnt = 0 
				rsget.close	
				Exit Function
			END IF	
			FTotCnt = arrList(5,0)			
			fnGetSubScriptComment = arrList	
		END IF	
		rsget.close			
	End Function

End Class
%>
<%
Class CHSPItem
	public Fevt_code			'이벤트코드
	public Fevt_Name			'이벤트명

	private sub Class_initialize()
	End Sub

	private Sub Class_terminate()
	End Sub
End Class

Class ClsHSP
	public FECode
	public FIdx
	
	public FEName
	public Fevt_template
	public Fevt_mainimg
	Public Fevt_img_mo
	Public Fevt_img_list_mo
	public Fevt_html
	public Fevt_html_mo
	public Fbrand
	public Fevt_startdate
	public Fevt_enddate
	public Fevt_prizedate
	public Fiscomment
	public Fisbbs
	public Fevt_linkcode
	public Fevt_firstCd
	public Fevt_lastCd
	public Fevt_preCd
	public Fevt_NextCd
	public FfavCnt
	Public FevtExeFile
	Public FevtExeFileMobile
	Public FevtSubCopyPc
	Public FevtSubCopyM
	Public FevtFileyn
	Public FevtFileyn_mo
	
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 5
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()
	End Sub

	'//헤이썸띵 내용 가져오기
	public Function fnGetEventCont
		Dim strSql
		IF FECode = "" THEN FECode = 0
		strSql =" [db_event].[dbo].[sp_Ten_event_HeySomeThing_GetContents] ("&FECode&")"
		rsget.Open strSql, dbget,  adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FECode 			= rsget("evt_code")
			FEName		 	= rsget("evt_name")
			Fevt_template 	= rsget("evt_template")
			Fevt_mainimg 	= rsget("evt_mainimg")
			Fevt_html 		= db2html(rsget("evt_html"))
			Fbrand			= rsget("brand")
			Fevt_startdate	= rsget("evt_startdate")
			Fevt_enddate 	= rsget("evt_enddate")
			Fevt_prizedate	= rsget("evt_prizedate")
			Fiscomment		= rsget("iscomment")
			Fisbbs			= rsget("isbbs")
			Fevt_linkcode	= rsget("link_evtcode")

			Fevt_firstCd	= rsget("firstCd")
			Fevt_lastCd		= rsget("lastCd")
			Fevt_preCd		= rsget("preCd")
			Fevt_NextCd		= rsget("NextCd")
			FfavCnt			= rsget("favCnt")
			FevtExeFile		= rsget("evt_execFile")
			FevtExeFileMobile		= rsget("evt_execFile_mo")
			FevtSubCopyPc	= rsget("evt_subcopyK")
			FevtSubCopyM	= rsget("evt_subname")
			FevtFileyn		= rsget("evt_isExec")
			FevtFileyn_mo	= rsget("evt_isExec_mo")
			Fevt_img_mo		= rsget("evt_bannerimg_mo")
			Fevt_img_list_mo= rsget("evt_mo_listbanner")
			Fevt_html_mo	= rsget("evt_html_mo")

		END IF	
		rsget.close
	End Function

	'//헤이썸띵 목록 접수
	public FSPageNo
	public FEPageNo
	public FTotCnt 
	
	public Function fnGetHSPList()
			FSPageNo = (FPageSize*(FCurrPage-1)) + 1
			FEPageNo = FPageSize*FCurrPage	
		dim sqlStr, i

		'#목록 총개수 접수
		sqlStr = "db_event.dbo.[sp_Ten_event_HeySomeThing_GetListCnt] " 
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotCnt = rsget(0)
		END IF
		rsget.close

		FTotalPage = (FTotCnt\FPageSize)
		If (FTotalPage<>FTotCnt/FPageSize) Then FTotalPage = FTotalPage +1

		'#목록 접수
 		sqlStr = "db_event.dbo.[sp_Ten_event_HeySomeThing_GetList] (" & FSPageNo & "," & FEPageNo&")"
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetHSPList = rsget.getRows()
		END IF
		rsget.close 
	End Function

	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function
	
	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function
	
	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1 
	end Function

End Class


'//가장 최근 등록된 헤이썸띵 데이터 가져옴
Function fngetNewHeySomeThingEvtCode
	Dim vName, vQuery
	vQuery = "select top 1 evt_code From db_event.dbo.tbl_event Where evt_kind='29' And getdate() >= evt_startdate order by evt_startdate desc "
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	If Not rsget.Eof Then
		vName = rsget(0)
	End IF
	rsget.close
	if isNull(vName) then vName=""
	fngetNewHeySomeThingEvtCode = vName
End Function

%>

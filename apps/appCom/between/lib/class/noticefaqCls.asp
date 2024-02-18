<%
Class CNoticeFaqItem
	public Fidx
	public Fgubun
	public Fsubject
	public Fcontents
	public Fregdate
	public Fisusing

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
End Class

Class CNoticeFaq
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FTotCnt
	
    public FRectGubun
    public Fisusing

	
    Public Function getNoticeFaqList()
        Dim sqlStr, i
		sqlStr = "EXECUTE [db_outmall].[dbo].[sp_Between_NoticeFaq_Count] '" & FPageSize & "', '" & FRectGubun & "'"
		'response.write sqlStr
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open sqlStr,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit Function
		end if
		
		sqlStr = "EXECUTE [db_outmall].[dbo].[sp_Between_NoticeFaq] '" & FPageSize*FCurrPage & "', '" & FRectGubun & "'"
		'response.write sqlStr
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr,dbCTget,1
		
		FResultCount = rsCTget.RecordCount-((FCurrPage-1)*FPageSize)
		redim FItemList(FResultCount)
		
		i=0
		if  not rsCTget.EOF  then
			rsCTget.absolutePage=FCurrPage
			do until rsCTget.eof
				set FItemList(i) = new CNoticeFaqItem
					FItemList(i).Fidx		= rsCTget("idx")
					FItemList(i).Fgubun		= rsCTget("gubun")
					FItemList(i).Fsubject	= rsCTget("subject")
					FItemList(i).Fcontents	= rsCTget("contents")
					FItemList(i).Fregdate	= rsCTget("regdate")
					FItemList(i).Fisusing	= rsCTget("isusing")

				i=i+1
				rsCTget.moveNext
			loop
		end if

		rsCTget.Close
    End Function
    
	Public Function getNoticeCnt()
		Dim sqlStr
		sqlStr = ""
		sqlStr = sqlStr & "EXECUTE [db_outmall].[dbo].[sp_Between_Notice_WeekCount] "
		'response.write sqlStr
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open sqlStr,dbCTget,1
			getNoticeCnt = rsCTget("cnt")
		rsCTget.close
	End Function

    Private Sub Class_Initialize()
		Redim  FItemList(0)
		FCurrPage         = 1
		FPageSize         = 30
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0

	End Sub

	Private Sub Class_Terminate()

    End Sub

    public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class

%>
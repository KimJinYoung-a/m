<%
'####################################################
' Description :  공지사항 & 당첨자발표 클래스
' History : 2013.12.13 한용민 생성
'####################################################

Class CBoardNoticeItem
	public Fid
	public Ftitle
	public Fcontents
	public Fregdate
	public Fyuhyostart
	public Fyuhyoend
	public Fisusing
	public FCateName
	public FFixYn
	public Fnoticetype

    public function IsNewNotics()
        IsNewNotics = (datediff("d",Fregdate,Now()) < 3)
    end function

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CBoardNotice
    public FItemList()
    public FOneItem

	public FCurrPage
	public FTotalPage
	public FTotalCount
	public FPageSize
	public FResultCount
	public FScrollCount

	public FIDBefore
	public FIDAfter
	public FRectFixonly
    public FRectid
	public FRectmalltype
	public FRectNoticetype
	public FRectNoticeOrder
	
	'//common/news.asp
	Public Function getNoticsList()
        dim strSQL, i

        'FRectFixonly="Y" - 고정글 만'
        'FRectFixonly="N" - 고정 아닌글만''
        'FRectFixonly="" - 고정 여부 상관없이''
        'FRectNoticeOrder=7 - 고정글->일반글 순서

		strSQL = "EXECUTE [db_cs].[dbo].sp_Ten_NoticsCount "&_
        	" @onlyValid = " & CStr(1) & ","&_
			" @fixyn='" & FRectFixonly & "',"&_
			" @noticetype='"&FRectNoticetype&"'" &_
			" , @mallType='"&FRectMallType&"'"

		rsget.Open strSQL, dbget
            FTotalCount = rsget("cnt")
        rsget.Close
		
		if FTotalCount < 1 then exit Function
		
        strSQL =" EXECUTE [db_cs].[dbo].sp_Ten_NoticsList "&_
        	" @iTopCnt = "& CStr(FPageSize*FCurrPage) &_
			" ,@onlyValid = " & CStr(1) &_
			" ,@fixyn='" & FRectFixonly &"'"&_
			" ,@noticetype='"&FRectNoticetype&"'"&_
			" ,@orderType = '"&FRectNoticeOrder&"'"  &_
			" , @mallType='"&FRectMallType&"'"

		'response.write strSQL
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSQL, dbget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new CBoardNoticeItem

                FItemList(i).Fid           	= rsget("id")
                FItemList(i).Ftitle        	= db2html(rsget("title"))
                FItemList(i).Fregdate      	= rsget("regdate")
                FItemList(i).Fyuhyostart   	= rsget("yuhyostart")
                FItemList(i).Fyuhyoend     	= rsget("yuhyoend")
    			FItemList(i).FCateName	   	= rsget("code_nm")
    			FItemList(i).FFixYn			= rsget("fixyn")
    			FItemList(i).Fnoticetype	= rsget("noticetype")

        		rsget.MoveNext
        		i = i + 1
            loop
        end if
        rsget.close
	end Function

	Public Function getOneNotics()
        dim strSQL, i

		strSQL = "exec [db_cs].[dbo].sp_Ten_NoticsOne " & CStr(FRectid)
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSQL, dbget, 1

        FResultCount = rsget.RecordCount

        if not rsget.EOF then
            set FOneItem = new CBoardNoticeItem

            FOneItem.Fid         = rsget("id")
            FOneItem.Ftitle      = db2html(rsget("title"))
            FOneItem.Fcontents   = db2html(rsget("contents"))
            FOneItem.Fregdate    = rsget("regdate")
            FOneItem.Fyuhyostart = rsget("yuhyostart")
            FOneItem.Fyuhyoend   = rsget("yuhyoend")
            FOneItem.FCateName	   = rsget("code_nm")
			FOneItem.Fnoticetype = rsget("noticetype")
        end if
        rsget.close
	end Function
	
    public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function
	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function
	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FResultCount  = 0
		FTotalCount = 0
		FPageSize = 12
		FCurrpage = 1
		FScrollCount = 10
	End Sub
	Private Sub Class_Terminate()
    End Sub
end Class
%>
<%
'======================================
' show banner : 2014-03-17 : 이종화
'======================================
Class ShowBannerCls
	public Fshowidx
	Public Fshowitemidx

	Public FStitle
	Public Fsimg1
	Public Fsimg2
	Public Fsimg3
	Public Fsimg4
	Public Fsimg5
	Public Fsurl1
	Public Fsurl2
	Public Fsurl3
	Public Fsurl4
	Public Fsurl5
	Public Fsalt1
	Public Fsalt2	
	Public Fsalt3
	Public Fsalt4
	Public Fsalt5	
	Public Fcolorcode   

	Public Fitemid
	Public FImageIcon1
	Public FImageBasic
	Public FItemName
	Public Fsubtitle

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

Class ShowBannerCntCls
    public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FShowidx

	public function GetShowBannerList()
        dim sqlStr, i

		sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_ShowBannerList_Cnt '" & FpageSize & "', '" & FShowidx & "'"
		'response.write sqlStr &"<br>"

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close

		If FTotalCount > 0 Then
			sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_ShowBannerList '" & (FpageSize*FCurrPage) & "', '" & FShowidx & "'"
			'response.write sqlStr &"<br>"

			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open sqlStr,dbget,1

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0

			redim preserve FItemList(FResultCount)
			i=0
			if  not rsget.EOF  Then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new ShowBannerCls
					FItemList(i).Fshowidx	= rsget("showidx")
					FItemList(i).FStitle	= rsget("stitle")
					FItemList(i).Fsimg1		= rsget("simg1")
					FItemList(i).Fsimg2		= rsget("simg2")
					FItemList(i).Fsimg3		= rsget("simg3")
					FItemList(i).Fsimg4		= rsget("simg4")
					FItemList(i).Fsimg5		= rsget("simg5")
					FItemList(i).Fsurl1		= rsget("surl1")
					FItemList(i).Fsurl2		= rsget("surl2")
					FItemList(i).Fsurl3		= rsget("surl3")
					FItemList(i).Fsurl4		= rsget("surl4")
					FItemList(i).Fsurl5		= rsget("surl5")
					FItemList(i).Fsalt1		= rsget("salt1")
					FItemList(i).Fsalt2		= rsget("salt2")
					FItemList(i).Fsalt3		= rsget("salt3")
					FItemList(i).Fsalt4		= rsget("salt4")
					FItemList(i).Fsalt5		= rsget("salt5")
					FItemList(i).Fcolorcode = rsget("colorcode")
					FItemList(i).Fsubtitle  = rsget("subtitle")
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.Close
		End If
    end Function
    
	public function GetShowBannerItemList()
        dim sqlStr, i

        sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_ShowBannerItem_List " & FShowidx

		'Response.write sqlStr
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new ShowBannerCls
    			FItemList(i).Fitemid		= rsget("itemid")
    			FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
    			FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
    			FItemList(i).FItemName		= db2html(rsget("itemname"))
    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

    Private Sub Class_Initialize()
        redim  FItemList(0)
		FCurrPage       = 1
		FPageSize       = 100
		FResultCount    = 0
		FScrollCount    = 10
		FTotalCount     = 0

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class
%>
<%
Class CCateClassItem
	Public Fidx
	Public Fitemid
	Public Fisusing
	Public Fitemname
	Public FImageBasic
	Public FsellCash
	Public ForgPrice
	Public FsailYN
	Public FitemcouponYn
	Public Fitemcouponvalue
	Public FLimitYn
	Public Fitemcoupontype
End Class 

Class CCateClass
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	Public Fdisp1

	public FRectUserLevelUnder

	public Sub GetCateMdPick()
		dim sqlStr, i

		sqlStr = "exec [db_sitemaster].[dbo].[sp_Ten_Mobile_Category_Mdpick_Tab] '"& Fdisp1 &"' " + vbcrlf
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then

			do until rsget.eof
				set FItemList(i) = new CCateClassItem
				FItemList(i).FItemId		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
    			FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("basicimage")

				FItemList(i).FsellCash			= rsget("sellCash")
				FItemList(i).ForgPrice			= rsget("orgPrice")
				FItemList(i).FsailYN			= rsget("sailYN")
				FItemList(i).FitemcouponYn		= rsget("itemcouponYn")
				FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
				FItemList(i).FLimitYn			= rsget("LimitYn")
				FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
				
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end sub

	Private Sub Class_Initialize()
		redim FItemList(0)
		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class
%>

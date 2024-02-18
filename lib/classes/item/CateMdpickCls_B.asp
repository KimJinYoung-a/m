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

	'//cache
	public Sub GetCateMdPick()
		dim sqlStr, i

		sqlStr = "exec [db_sitemaster].[dbo].[sp_Ten_Mobile_Category_Mdpick_Tab] '"& Fdisp1 &"' " + vbcrlf
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"TABS",sqlStr,180)
		if (rsMem is Nothing) then Exit sub 
		FResultCount = rsMem.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		IF Not (rsMem.EOF OR rsMem.BOF) Then

			do until rsMem.eof
				set FItemList(i) = new CCateClassItem
				FItemList(i).FItemId		= rsMem("itemid")
				FItemList(i).FItemName		= db2html(rsMem("itemname"))
    			FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsMem("basicimage")

				FItemList(i).FsellCash			= rsMem("sellCash")
				FItemList(i).ForgPrice			= rsMem("orgPrice")
				FItemList(i).FsailYN			= rsMem("sailYN")
				FItemList(i).FitemcouponYn		= rsMem("itemcouponYn")
				FItemList(i).Fitemcouponvalue	= rsMem("itemcouponvalue")
				FItemList(i).FLimitYn			= rsMem("LimitYn")
				FItemList(i).Fitemcoupontype	= rsMem("itemcoupontype")
				
				i=i+1
				rsMem.moveNext
			loop
		END If
		
		rsMem.close

	end Sub
	

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

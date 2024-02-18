<%
Class CPickItem

	public Fidx
	public Ftextname
	Public FsortNo
	public Fregdate
	Public Ftitle
	Public Flinkinfo
	Public FisUsing
	Public Fis1day

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CPick
	public FItemList()
	public FItemOne

	public FTotalCount
	public FResultCount

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount

	public FRectIdx
	public FRectUsing
	public FRectSearch
	public FRectSort
	public FCategoryPrdList()

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 15
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		redim preserve FCategoryPrdList(0)
	End Sub

	Private Sub Class_Terminate()

	End Sub


	public Sub GetPickOne()
		dim sqlStr, addSql, i
		sqlStr = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_GetOne]"
		rsget.Open sqlStr,dbget,1
		if not rsget.EOF then
			FTotalCount = 1
			set FItemOne = new CPickItem
			FItemOne.Fidx = rsget("idx")
			FItemOne.Ftitle = db2html(rsget("title"))
			FItemOne.Fis1day = rsget("is1day")
		end if
		rsget.Close
	End Sub
	

	public Function GetPickItemList()
		dim strSql, addSql, i, arrItem, intI

		strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList] '1', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', ''"
		rsget.Open strSql,dbget,1
		FTotalCount = rsget(0)
		FTotalPage = rsget(1)
		rsget.Close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList] '2', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', '" & FRectSort & "'"
			rsget.Open strSql,dbget,1
			IF Not (rsget.EOF OR rsget.BOF) THEN
				arrItem = rsget.GetRows()
			END IF
			rsget.close
	
			IF isArray(arrItem) THEN
				FResultCount = Ubound(arrItem,2)
				redim preserve FCategoryPrdList(FResultCount)

				For intI = 0 To FResultCount
				set FCategoryPrdList(intI) = new CCategoryPrdItem
					FCategoryPrdList(intI).FItemID       = arrItem(0,intI)
					FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))
	
					FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
					FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
					FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
					FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))
	
					FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
					FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
					FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
					FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
					FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)
	
					FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
					FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)
	
	                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
					FCategoryPrdList(intI).FItemCouponValue	= arrItem(17,intI)
					FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)
	
					FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
					FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)
	
					FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
					FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
					FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
					FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
					FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
					FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
					FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
					FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
					FCategoryPrdList(intI).Fldv			= arrItem(29,intI)
					FCategoryPrdList(intI).Flabel		= arrItem(30,intI)
	
				Next
			END IF
		ELSE
			FTotalCount = -1
		END IF
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
end Class
%>

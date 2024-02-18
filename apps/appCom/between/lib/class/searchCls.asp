<%
Class CSearchItem




    Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
End Class

Class CSearchItemCls
    Public FOneItem
    Public FItemList()
	Public FTotalCount
	Public FCurrPage
	Public FTotalPage
	Public FPageSize
	Public FResultCount
	Public FScrollCount

	Public FRectSearchTxt
	Public FRectSortMethod
	Public FRectCateCode

	Public Sub getSearchList
		Dim sqlStr , i
		sqlStr = "EXECUTE [db_outMall].[dbo].[sp_Between_SearchList_Cnt] '" & FPageSize & "', '"& FRectCateCode &"', '"& FRectSearchTxt &"' "
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open sqlStr, dbCTget, 1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close

		sqlStr = "EXECUTE [db_outMall].[dbo].[sp_Between_SearchList] '" & FPageSize & "', '"& FCurrPage &"', '"& FRectCateCode &"', '"& FRectSortMethod &"', '"& FRectSearchTxt &"' "
		'response.write sqlStr
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FResultCount = rsCTget.RecordCount - (FPageSize * (FCurrPage - 1))
        If (FResultCount < 1) Then FResultCount = 0
		Redim preserve FItemList(FResultCount)

		i = 0
		IF Not (rsCTget.EOF OR rsCTget.BOF) THEN
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CCategoryPrdItem
					FItemList(i).FItemID       = rsCTget("itemid")
					If Trim(db2html(rsCTget("chgItemname")))="" Then
						FItemList(i).FItemName     = db2html(rsCTget("itemname"))
					Else
						FItemList(i).FItemName     = db2html(rsCTget("chgItemname"))
					End If

					FItemList(i).FSellcash     = rsCTget("sellcash")
					FItemList(i).FSellYn       = rsCTget("sellyn")
					FItemList(i).FLimitYn      = rsCTget("limityn")
					FItemList(i).FLimitNo      = rsCTget("limitno")
					FItemList(i).FLimitSold    = rsCTget("limitsold")
					FItemList(i).Fitemgubun    = rsCTget("itemgubun")
					FItemList(i).FDeliverytype = rsCTget("deliverytype")
					FItemList(i).Fitemcoupontype	= rsCTget("itemcoupontype")
					FItemList(i).FItemCouponValue	= rsCTget("ItemCouponValue")

					FItemList(i).Fevalcnt = rsCTget("evalcnt")
					FItemList(i).Fitemcouponyn = rsCTget("itemcouponyn")

					FItemList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("smallimage")
					FItemList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsCTget("BasicImage"),"200","200","true","false")
					FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsCTget("listimage120")
					FItemList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsCTget("icon1image")
					FItemList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsCTget("icon2image")
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsCTget("BasicImage")

					FItemList(i).FMakerID = rsCTget("makerid")
					FItemList(i).fbrandname = db2html(rsCTget("brandname"))
					FItemList(i).FRegdate = rsCTget("regdate")

					FItemList(i).FSaleYn    = rsCTget("sailyn")
					FItemList(i).FOrgPrice   = rsCTget("orgprice")
					FItemList(i).FSpecialuseritem = rsCTget("specialuseritem")
					FItemList(i).Fevalcnt = rsCTget("evalcnt")
					FItemList(i).FbetCateCd = rsCTget("CateCode")
					FItemList(i).FbetCateNm = rsCTget("catename")
				i = i + 1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.Close
	End Sub

    Private Sub Class_Initialize()
		Redim  FItemList(0)
		FCurrPage         = 1
		FPageSize         = 10
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

End Class

Sub procMySearchKeyword(kwd)
	Dim arrCKwd, rstKwd, i, excKwd
	arrCKwd = session("mySearchKey")
	arrCKwd = split(arrCKwd,",")

	rstKwd = Trim(kwd)
	if Ubound(arrCKwd) > -1 Then
		For i=0 to ubound(arrCKwd)
			If not(chkArrValue(excKwd,lcase(arrCKwd(i)))) Then
				If arrCKwd(i) <> trim(kwd) Then rstKwd = rstKwd & "," & arrCKwd(i)
			End If
			if i > 9 Then Exit For
		Next
	End If
	session("mySearchKey") = rstKwd
End Sub

Function fnBetweenSelectBox(depth, catecode, selname, selectedcode, onchange)
	Dim i, cDCS, vBody, vTempDepth
	Dim sqlStr
	sqlStr = ""
	sqlStr = sqlStr & " SELECT catecode, depth, catename, useyn, sortNo "
	sqlStr = sqlStr & " FROM [db_outmall].[dbo].[tbl_between_cate] "
	sqlStr = sqlStr & " WHERE depth = '1' and catecode <> '107' and useyn = 'Y' "
	sqlStr = sqlStr & " ORDER BY sortNo ASC, catecode ASC "


'	sqlStr = sqlStr & " select top 100 C.catecode, C.catename, C.sortNo, C.catecode "
'	sqlStr = sqlStr & " From [db_outmall].[dbo].tbl_between_cate_item A "
'	sqlStr = sqlStr & " inner join [db_Appwish].[dbo].tbl_item B on A.itemid = B.itemid "
'	sqlStr = sqlStr & " inner join db_AppWish.dbo.tbl_item_SearchBase S on S.itemid = A.itemid "
'	sqlStr = sqlStr & " inner join [db_outmall].[dbo].tbl_between_cate as C on A.catecode = C.catecode "
'	sqlStr = sqlStr & " where contains(S.searchkey,'인형') "
'	sqlStr = sqlStr & " and A.isdisplay='Y' And B.IsUsing='Y' and B.Sellyn in ('Y') "
'	sqlStr = sqlStr & " and C.useyn = 'Y' "
'	sqlStr = sqlStr & " GROUP BY C.catecode, C.catename,C.sortNo, C.catecode "
'	sqlStr = sqlStr & " ORDER BY C.sortNo, C.catecode ASC "

	rsCTget.Open sqlStr, dbCTget, 1
	For i=0 To rsCTget.RecordCount -1
		If i = 0 Then
			vBody = vBody & "<select name="""&selname&""" class=""select"" "&onchange&">" & vbCrLf
			vBody = vBody & "	<option value=''>전체 카테고리</option>" & vbCrLf
		End If
		vBody = vBody & "	<option value="""&rsCTget("catecode")&""""
		If CStr(rsCTget("catecode")) = (selectedcode) Then
			vBody = vBody & " selected"
		End If
		vBody = vBody & ">"&rsCTget("catename")&"</option>" & vbCrLf
		rsCTget.moveNext
	Next
	vBody = vBody & "</select>" & vbCrLf
	rsCTget.Close
	fnBetweenSelectBox = vBody
End Function
%>
<%
class CCardDiscount
	public FItemList()
    public FOneItem
    
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FcardCode
	public FsalePrice
	public FbannerTitle
	public FminPrice
	public FcardName

	public Sub CardDiscountInfo()
		dim i,sqlStr
		sqlStr = "EXEC [db_item].[dbo].[usp_WWW_Order_CardDiscountInfo_Get]"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
        set FOneItem = new CCardDiscount
        if  not rsget.EOF  then
            FOneItem.FcardCode = rsget("cardCode")
            FOneItem.FsalePrice = rsget("salePrice")
            FOneItem.FbannerTitle = rsget("bannerTitle")
        End If
		rsget.close
	end Sub

	public Sub ItemCardDiscountInfo()
		dim i,sqlStr
		sqlStr = "EXEC [db_item].[dbo].[usp_WWW_Item_CardDiscountInfo_Get]"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
        set FOneItem = new CCardDiscount
        if  not rsget.EOF  then
            FOneItem.FcardName = rsget("cardName")
            FOneItem.FsalePrice = rsget("salePrice")
			FOneItem.FminPrice = rsget("minPrice")
        End If
		rsget.close
	end Sub
    
	Private Sub Class_Initialize()
		redim preserve FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0

	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class
%>
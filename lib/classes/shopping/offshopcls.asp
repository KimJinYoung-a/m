<%
'####################################################
' Description :  오프샵
' History : 2009.04.07 서동석 생성
'			2010.08.04 한용민 수정
'####################################################

class COffShopItem

	public FShopID
    public FShopName
    public FShopPhone
    public FShopAddr1
    public FShopAddr2
    public FMobileWorkHour
    public FMobileLatitude
    public FMobileLongitude

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

class COffShop
    public FOneItem
	public FItemList()
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FPageCount
	public FRectShopID
	public FRectDesigner
	public FRectChargeType
    public FRectComm_cd
    public FRectShopusing
    public FRectPartnerusing
    public FRectBrandusing
    public FRectcurrencyUnit
    public FRectbasedate
    public frectidx
    public FRectOffUpBea
	public FRectHasContOnly
    public FRectShopDiv2
    public FRectIsUsing
    public frectshopname
    public FRectNotProtoTypeShop
    public frectcodegroup
    public frectshopdiv
	public frectsitename
	public FRectmaeipdiv
	public FRectBrandPurchaseType
	public FRectisoffusing
	public FRectadminopen
	public FRectloginsite
	public FRectcountrylangcd

    '//admin/lib/popoffshopinfo.asp		'//common/offshop/pop_shopselect_pos.asp
	public Sub GetOffShopList()
		Dim strSQL,ArrRows,i
		strSQL = "EXEC [db_shop].[dbo].[usp_WWW_OffShop_ShopList_Get]"
'			response.write strSQL
		Dim rsMem : Set rsMem = getDBCacheSQL(dbget,rsget,"OffShopList",strSQL,180)
		If (rsMem Is Nothing) Then Exit Sub
		If Not rsMem.EOF  Then
			ArrRows 	= rsMem.GetRows
		End If
		rsMem.Close

		If isArray(ArrRows) Then
			FResultCount = Ubound(ArrRows,2) + 1
			ReDim FItemList(FResultCount)
			For i=0 To FResultCount-1
				Set FItemList(i) = New COffShopItem
				FItemList(i).FShopID = ArrRows(0,i)
				FItemList(i).FShopName = ArrRows(1,i)
				FItemList(i).FShopPhone = ArrRows(2,i)
				FItemList(i).FShopAddr1 = ArrRows(3,i)
				FItemList(i).FShopAddr2 = ArrRows(4,i)
				FItemList(i).FMobileWorkHour = ArrRows(5,i)
				FItemList(i).FMobileLatitude = ArrRows(6,i)
				FItemList(i).FMobileLongitude = ArrRows(7,i)
			Next
		Else
			FResultCount = 0
			Exit Sub
		End If
	End Sub

	Private Sub Class_Initialize()
		redim  FItemList(0)
		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
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

<%
Class CItemOptionItem
    public Fcardid
    public Fcardoption
    public Fisusing
    public Foptsellyn
    public FoptionTypeName
    public Foptionname
    public Foptsellcash
    public Foptsaleprice
    public Foptorgprice
    public Foptsaleyn

    public function IsOptionSoldOut()
        IsOptionSoldOut = (Fisusing="N") or (Foptsellyn="N")
    end function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class

Class CItemOption
    public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectItemID
	public FRectItemOption
	public FRectIsUsing

    public function GetOptionList()
        dim sqlStr, i
        dim dumiKey, PreKey

        sqlStr = "exec [db_item].[dbo].[sp_Ten_GiftCardOptionList] " & FRectItemID & ",'" & FRectIsUsing & "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FTotalCount  = rsget.RecordCount
        FResultCount = FTotalCount

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            do until rsget.eof
    			set FItemList(i) = new CItemOptionItem
    			FItemList(i).Fcardid         = rsget("cardItemid")
                FItemList(i).Fcardoption     = rsget("cardOption")
                FItemList(i).Fisusing        = rsget("optIsUsing")
                FItemList(i).Foptsellyn      = rsget("optSellYn")
                FItemList(i).Foptionname     = db2Html(rsget("cardOptionName"))
                FItemList(i).Foptsellcash	 = rsget("cardSellCash")
				FItemList(i).Foptsaleprice	 = rsget("cardSalePrice")
				FItemList(i).Foptorgprice	 = rsget("cardOrgPrice")
				FItemList(i).Foptsaleyn		 = rsget("cardSaleYn")

    			i=i+1
    			rsget.moveNext
    		loop
    	end if
        rsget.Close
    end function

	'// 상품-옵션정보 접수
	Public Sub GetItemOneOptionInfo()
		dim sqlStr

		if FRectItemID="" or FRectItemOption="" then
			FResultCount = 0
			Exit Sub
		end if

        sqlStr = "exec [db_item].[dbo].[sp_Ten_GiftCardItemOptionInfo] " & FRectItemID & ",'" & FRectItemOption & "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FResultCount = rsget.RecordCount

        if  not rsget.EOF  then
			set FOneItem = new CGiftCardPrdItem

            FOneItem.FCardItemID		= rsget("CardItemID")
            FOneItem.FCardItemName		= db2Html(rsget("CardItemName"))
            FOneItem.FImageList			= webImgUrl & "/giftcard/list/" & GetImageSubFolderByItemid(rsget("cardItemid")) & "/" & rsget("listImage")
            FOneItem.FImageSmall		= webImgUrl & "/giftcard/small/" & GetImageSubFolderByItemid(rsget("cardItemid")) & "/" & rsget("smallImage")
            FOneItem.FcardOption		= rsget("cardOption")
            FOneItem.FcardOptionName	= db2Html(rsget("cardOptionName"))
            FOneItem.FcardSellCash		= rsget("cardSellCash")
            FOneItem.FcardOrgPrice		= rsget("cardOrgPrice")
            FOneItem.FcardSaleYn		= rsget("cardSaleYn")
            FOneItem.FoptSellYn			= rsget("optSellYn")

    	end if
        rsget.Close

	End Sub

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

'' 상품 페이지 에서 사용
function GetOptionBoxHTML(byVal iItemID, byVal isItemSoldOut)
    GetOptionBoxHTML = ""

    dim oItemOption, oItemOptionMultiple, oItemOptionMultipleType
    dim IsMultipleOption
    dim i, j, MultipleOptionCount
    dim optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionBoxStyle, ScriptHtml

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionHtml = ""


    ''단일 옵션.
    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if

    optionHtml = optionHtml + "<select name='cardopt' class='optSelect2' title='기프트카드 금액을 선택해주세요'>"
    optionHtml = optionHtml + "<option value='' selected>" + optionTypeStr + "</option>"

    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""
	    optionBoxStyle      = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionBoxStyle = "style='color:#DD8888'"
    	else
    	    optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptsellcash,0)  + "원)"
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionBoxStyle + " value='" + oItemOption.FItemList(i).Fcardoption + "'>" + optionKindStr + "</option>"
	next

    optionHtml = optionHtml + "</select>"

    GetOptionBoxHTML = ScriptHtml + optionHtml

    set oItemOption = Nothing

end function


'' 상품 페이지 에서 사용(2016리뉴얼)
function GetOptionBoxHTML2016(byVal iItemID)
    GetOptionBoxHTML2016 = ""

    dim oItemOption, optionHtml, optionKindStr, i

    set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionHtml = ""
    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = "￦" & FormatNumber(oitemoption.FItemList(i).Foptsellcash,0)
        optionHtml = optionHtml & "<div class=""swiper-slide""><button type=""button"" cardOpt='" & oItemOption.FItemList(i).Fcardoption & "' price='" & oitemoption.FItemList(i).Foptsellcash & "'" & chkIIF(oItemOption.FItemList(i).Fcardoption="0004"," class=""on""","") & ">" & optionKindStr & "</button></div>"
	next
    GetOptionBoxHTML2016 = optionHtml

    set oItemOption = Nothing
end function
%>

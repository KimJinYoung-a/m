<%
'// 상품
dim vIsTest
IF application("Svr_Info") = "Dev" THEN
	vIsTest = "test"
Else
	vIsTest = ""
End If

Class sale2020Object
    Public Fitemid
    Public Fitemname
    Public Fsellcash
    Public Forgprice
    Public FMakerid
    Public FbrandName
    Public FsellYn
    Public Fsailyn
    Public Flimityn
    Public Flimitno
    Public Flimitsold
    Public Fitemcouponyn
    Public Fitemcoupontype
    Public Fitemcouponvalue
    Public FEvalcnt
    Public Fdispcate
    Public FImageList
    Public FBasicimage
    Public FPrdImage
    Public FTentenImg200
    Public FTentenImg400
    Public FSellDate
    Public FDeliverytype
    Public FDefaultFreeBeasongLimit
    Public FFavCount
    Public Fpoints

    '// 쿠폰 할인 가격
	Public Function fnCouponDiscountPrice()
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				fnCouponDiscountPrice = CLng(Fitemcouponvalue*Fsellcash/100)
			case "2" ''원 쿠폰
				fnCouponDiscountPrice = Fitemcouponvalue
			case "3" ''무료배송 쿠폰
				fnCouponDiscountPrice = 0
			case else
				fnCouponDiscountPrice = 0
		end Select
	End Function

	'// 쿠폰 할인 문구
	Public Function fnCouponDiscountString()
		Select Case Fitemcoupontype
			Case "1"
				fnCouponDiscountString = CStr(Fitemcouponvalue)
			Case "2"
				fnCouponDiscountString = CStr(Fitemcouponvalue)
			Case "3"
			 	fnCouponDiscountString = 0
			Case Else
				fnCouponDiscountString = Fitemcouponvalue
		End Select
	End Function

	'// 세일 쿠폰 통합 할인 
	Public Function fnSaleAndCouponDiscountString()
		Select Case Fitemcoupontype
			Case "1" '//할인 + %쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-(Fsellcash - CLng(Fitemcouponvalue*Fsellcash/100)))/Forgprice*100) & ""
			Case "2" '//할인 + 원쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-(Fsellcash - Fitemcouponvalue))/Forgprice*100) & ""
			Case "3" '//할인 + 무배쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-Fsellcash)/Forgprice*100) & ""
			Case Else
				fnSaleAndCouponDiscountString = ""
		End Select		
	End Function

	'// 최종가격 및 세일퍼센트 , 쿠폰퍼센트 , 합산퍼센트
	Public Function fnItemPriceInfos(byRef totalPrice , byRef salePercentString , byRef couponPercentString , byRef totalSalePercent)
		'// totalPrice
		totalPrice = formatNumber(Fsellcash - fnCouponDiscountPrice(),0)

		'// salePercentString
		salePercentString = CLng((Forgprice-Fsellcash)/FOrgPrice*100) & chkiif(CLng((Forgprice-Fsellcash)/FOrgPrice*100) > 0 , "%" , "")

		'// couponPercentString
		couponPercentString = fnCouponDiscountString() & chkiif(fnCouponDiscountString() > 0 , chkiif(Fitemcoupontype = 2 , "원" , "%") ,"")

		'// totalSalePercent
		totalSalePercent = fnSaleAndCouponDiscountString() & chkiif(fnSaleAndCouponDiscountString() > 0 , "%" , "")
	End Function

    '// 무료 배송 여부
	public Function IsFreeBeasong()
        if (cLng(FSellCash)>=cLng(getFreeBeasongLimitByUserLevel())) then
			IsFreeBeasong = true
		else
			IsFreeBeasong = false
		end if

		if (FDeliverytype="2") or (FDeliverytype="4") or (FDeliverytype="5") or (FDeliverytype="6") then
			IsFreeBeasong = true
		end if
		
		''//착불 배송은 무료배송이 아님
		if (FDeliverytype="7") then
		    IsFreeBeasong = false
		end if
	end Function

    ' 사용자 등급별 무료 배송 가격  '?
	public Function getFreeBeasongLimitByUserLevel()
		''쇼핑에서는 사용자레벨에 상관없이 3만 / 업체 개별배송 5만 장바구니에서만 체크
		if (FDeliverytype="9") then
		    If (IsNumeric(FDefaultFreeBeasongLimit)) and (FDefaultFreeBeasongLimit<>0) then
		        getFreeBeasongLimitByUserLevel = FDefaultFreeBeasongLimit
		    else
		        getFreeBeasongLimitByUserLevel = 50000
		    end if
		else
		    getFreeBeasongLimitByUserLevel = 30000
		end if
		
	end Function
End Class

Class sale2020Cls
    Public FItemList()
	Public FItem	
	public FResultCount
	public FPageSize
	public FCurrPage
	public Ftotalcount
	public FScrollCount
	public FTotalpage
	public FPageCount
	public FOneItem
	public Frectidx
	public FrectIsusing
	public FrectGcode
	public FrectCate
	public FrectMakerid
	public FrectArrItemid
	public Frectpick
	public FrectSortMet
	public FrectListType
    public FrectCategory
	public FrectFlagDate
	public FrectEvt_Code
	public FrectMasterCode
	public FrectDetailCode	
	public FRectValiddate
	public FRectSelDate
	
	Private Sub Class_Initialize()
		FCurrPage = 1
		FPageSize = 20
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub

    '// 명품 List
    Public Function getLuxuryProductsLists(pageno , pagesize)
        dim strSql,i, itemList()

        IF pageno > 10 THEN exit function '// 200개 리미트

        strSql ="EXEC db_temp.dbo.usp_WWW_customgroup_branditemlists "& pageno &", "& pagesize &""
        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open strSql, dbget, 1

        redim preserve itemList(rsget.recordcount)

        If Not rsget.EOF Then
            do until rsget.EOF
                set itemList(i) = new sale2020Object

                itemList(i).Fitemid 		= rsget("itemid")
                itemList(i).FTentenImg200  = rsget("tentenimage200")	
                itemList(i).FTentenImg400  = rsget("tentenimage400")	
                itemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			

                If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then
                    itemList(i).FTentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage200")
                    itemList(i).FTentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage400")
                End If

                if ImageExists(itemList(i).FTentenImg400) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg400
                ElseIf ImageExists(itemList(i).FTentenImg200) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg200
                else					
                    itemList(i).FPrdImage		= itemList(i).FBasicimage
                End If								
                itemList(i).FImageList 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			
                
                itemList(i).Fitemname 		= db2html(rsget("itemname"))
                itemList(i).FMakerid 		= db2html(rsget("makerid"))
                itemList(i).Forgprice 		= rsget("orgprice")
                itemList(i).Fsailyn 		= rsget("sailyn")
                itemList(i).Fitemcouponyn   = rsget("itemcouponyn")
                itemList(i).Fitemcoupontype = rsget("itemcoupontype")
                itemList(i).Fsellcash 		= rsget("sellcash")
                ItemList(i).Fitemcouponvalue = rsget("itemcouponvalue")
                ItemList(i).FsellYn         = rsget("sellyn")
                ItemList(i).FbrandName      = rsget("brandName")
                ItemList(i).FevalCnt        =  rsget("evalCnt")
                ItemList(i).FDeliverytype   = rsget("deliverytype")
                ItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")
                ItemList(i).Fpoints         = rsget("totalpoint")
                ItemList(i).FFavCount       = rsget("favcount")

                rsget.movenext
                i=i+1
            loop
            getLuxuryProductsLists = itemList
        ELSE		
            getLuxuryProductsLists = itemList
        End if
        rsget.close
    End Function

    '// 방금 판매된 상품
    Public Function getItemsJustSoldLists( catecode , pageno , pagesize)

        IF pageno > 50 THEN exit function '// 200개 리미트

        dim strSql,i, itemList()
        strSql ="EXEC db_temp.dbo.usp_WWW_ItemsJustSold '"& catecode &"', "& pageno &", "& pagesize &""

        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open strSql, dbget, 1

        redim preserve itemList(rsget.recordcount)
        If Not rsget.EOF Then
            do until rsget.EOF
                set itemList(i) = new sale2020Object

                itemList(i).Fitemid 		= rsget("itemid")
                itemList(i).FTentenImg200  = rsget("tentenimage200")	
                itemList(i).FTentenImg400  = rsget("tentenimage400")	
                itemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			

                If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then
                    itemList(i).FTentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage200")
                    itemList(i).FTentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage400")
                End If

                if ImageExists(itemList(i).FTentenImg400) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg400
                ElseIf ImageExists(itemList(i).FTentenImg200) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg200
                else					
                    itemList(i).FPrdImage		= itemList(i).FBasicimage
                End If								
                itemList(i).FImageList 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			
                
                itemList(i).Fitemname 		= db2html(rsget("itemname"))
                itemList(i).FMakerid 		= db2html(rsget("makerid"))
                itemList(i).Forgprice 		= rsget("orgprice")
                itemList(i).Fsailyn 		= rsget("sailyn")
                itemList(i).Fitemcouponyn   = rsget("itemcouponyn")
                itemList(i).Fitemcoupontype = rsget("itemcoupontype")
                itemList(i).Fsellcash 		= rsget("sellcash")
                ItemList(i).Fitemcouponvalue= rsget("itemcouponvalue")
                ItemList(i).FsellYn         = rsget("sellyn")
                ItemList(i).FbrandName      = rsget("brandName")
                ItemList(i).FevalCnt        = rsget("evalcnt")
                ItemList(i).FSellDate       = rsget("selldate")
                ItemList(i).FDeliverytype   = rsget("deliverytype")
                ItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")
                ItemList(i).Fpoints         = rsget("totalpoint")
                ItemList(i).FFavCount       = rsget("favcount")

                rsget.movenext
                i=i+1
            loop
            getItemsJustSoldLists = itemList
        ELSE		
            getItemsJustSoldLists = itemList
        End if
        rsget.close
    End Function

    '// 방금 판매된 상품 문구페어 용
    Public Function getItemsStationeryFairJustSoldLists()

        'IF pageno > 50 THEN exit function '// 200개 리미트

        dim strSql,i, itemList()
        strSql ="EXEC db_temp.dbo.usp_WWW_Brand_JustSold_Get"

        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open strSql, dbget, 1

        redim preserve itemList(rsget.recordcount)
        If Not rsget.EOF Then
            do until rsget.EOF
                set itemList(i) = new sale2020Object

                itemList(i).Fitemid 		= rsget("itemid")
                itemList(i).FTentenImg200  = rsget("tentenimage200")
                itemList(i).FTentenImg400  = rsget("tentenimage400")
                itemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")

                If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then
                    itemList(i).FTentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage200")
                    itemList(i).FTentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage400")
                End If

                if ImageExists(itemList(i).FTentenImg400) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg400
                ElseIf ImageExists(itemList(i).FTentenImg200) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg200
                else
                    itemList(i).FPrdImage		= itemList(i).FBasicimage
                End If
                itemList(i).FImageList 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")

                itemList(i).Fitemname 		= db2html(rsget("itemname"))
                itemList(i).FMakerid 		= db2html(rsget("makerid"))
                itemList(i).Forgprice 		= rsget("orgprice")
                itemList(i).Fsailyn 		= rsget("sailyn")
                itemList(i).Fitemcouponyn   = rsget("itemcouponyn")
                itemList(i).Fitemcoupontype = rsget("itemcoupontype")
                itemList(i).Fsellcash 		= rsget("sellcash")
                ItemList(i).Fitemcouponvalue= rsget("itemcouponvalue")
                ItemList(i).FsellYn         = rsget("sellyn")
                ItemList(i).FbrandName      = rsget("brandName")
                ItemList(i).FevalCnt        = rsget("evalcnt")
                ItemList(i).FSellDate       = rsget("selldate")
                ItemList(i).FDeliverytype   = rsget("deliverytype")
                ItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")
                ItemList(i).Fpoints         = rsget("totalpoint")
                ItemList(i).FFavCount       = rsget("favcount")

                rsget.movenext
                i=i+1
            loop
            getItemsStationeryFairJustSoldLists = itemList
        ELSE
            getItemsStationeryFairJustSoldLists = itemList
        End if
        rsget.close
    End Function

    '// 방금 판매된 상품 특정 카테고리 버전
    Public Function getCategoryItemsJustSoldLists(pageno , pagesize)

        IF pageno > 50 THEN exit function '// 200개 리미트

        dim strSql,i, itemList()
        strSql ="EXEC db_temp.dbo.usp_WWW_category_ItemsJustSold "& pageno &", "& pagesize &""

        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open strSql, dbget, 1

        redim preserve itemList(rsget.recordcount)
        If Not rsget.EOF Then
            do until rsget.EOF
                set itemList(i) = new sale2020Object

                itemList(i).Fitemid 		= rsget("itemid")
                itemList(i).FTentenImg200  = rsget("tentenimage200")	
                itemList(i).FTentenImg400  = rsget("tentenimage400")	
                itemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			

                If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then
                    itemList(i).FTentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage200")
                    itemList(i).FTentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("tentenimage400")
                End If

                if ImageExists(itemList(i).FTentenImg400) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg400
                ElseIf ImageExists(itemList(i).FTentenImg200) Then
                    itemList(i).FPrdImage		= itemList(i).FTentenImg200
                else					
                    itemList(i).FPrdImage		= itemList(i).FBasicimage
                End If								
                itemList(i).FImageList 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			
                
                itemList(i).Fitemname 		= db2html(rsget("itemname"))
                itemList(i).FMakerid 		= db2html(rsget("makerid"))
                itemList(i).Forgprice 		= rsget("orgprice")
                itemList(i).Fsailyn 		= rsget("sailyn")
                itemList(i).Fitemcouponyn   = rsget("itemcouponyn")
                itemList(i).Fitemcoupontype = rsget("itemcoupontype")
                itemList(i).Fsellcash 		= rsget("sellcash")
                ItemList(i).Fitemcouponvalue= rsget("itemcouponvalue")
                ItemList(i).FsellYn         = rsget("sellyn")
                ItemList(i).FbrandName      = rsget("brandName")
                ItemList(i).FevalCnt        = rsget("evalcnt")
                ItemList(i).FSellDate       = rsget("selldate")
                ItemList(i).FDeliverytype   = rsget("deliverytype")
                ItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")
                ItemList(i).Fpoints         = rsget("totalpoint")
                ItemList(i).FFavCount       = rsget("favcount")

                rsget.movenext
                i=i+1
            loop
            getCategoryItemsJustSoldLists = itemList
        ELSE		
            getCategoryItemsJustSoldLists = itemList
        End if
        rsget.close
    End Function

    '// 정기 세일 기획전 리스트 -- MOBILE WEB
    Public Function getMainExhibitionListsForMobile()
        dim sqlStr

        sqlStr = "EXEC db_temp.dbo.usp_WWW_SaleExhibition_List_ForMobile"
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
        IF Not (rsget.EOF OR rsget.BOF) THEN
            getMainExhibitionListsForMobile = rsget.GetRows()
        END IF
        rsget.close
    End Function

    '// 정기 세일 기획전 리스트 - PC WEB
    Public Function getMainExhibitionListsForPC()
        dim sqlStr

        sqlStr = "EXEC db_temp.dbo.usp_WWW_SaleExhibition_List_ForPC"
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
        IF Not (rsget.EOF OR rsget.BOF) THEN
            getMainExhibitionListsForPC = rsget.GetRows()
        END IF
        rsget.close
    End Function

    function ImageExists(byval iimg)
        if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
            ImageExists = false
        else
            ImageExists = true
        end if
    end function

End Class

Public Function Gettimeset(v)
    if v < 60 then
        Gettimeset = "1분 전"
    elseif(v < 3600) then
        Gettimeset = int(v/60)&"분 전"
    elseif(v < 86400) then
        Gettimeset = int(v/3600)&"시간 전"
    else 
        Gettimeset = "오래 전"
    end if
End Function

'//상품후기 총점수 %로 환산
Public function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function
%>

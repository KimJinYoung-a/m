<%
'#######################################################
'	History	:  2015.11.05 한용민 생성
'	Description : 포장 서비스 클래스
'/배송비 상품코드:100 , 옵션코드:1000
'#######################################################

'/선물포장서비스 사용가능여부
dim G_IsPojangok
	'G_IsPojangok = FALSE
	G_IsPojangok = TRUE

'/실서버 태스트용
'if GetLoginUserID="motions" or GetLoginUserID="sunna0822" or GetLoginUserID="dadalast" or GetLoginUserID="jjh" or GetLoginUserID="josin222" or GetLoginUserID="ilovecozie" or GetLoginUserID="hrkang97" or GetLoginUserID="sss162000" or GetLoginUserID="cogusdk" or GetLoginUserID="bborami" or GetLoginUserID="tozzinet" or GetLoginUserID="icommang" or GetLoginUserID="okkang77" or GetLoginUserID="winnie" or GetLoginUserID="ideamanlee" or GetLoginUserID="ajung611" or GetLoginUserID="happyngirl" or GetLoginUserID="kobula" or GetLoginUserID="skyer9" or GetLoginUserID="coolhas" or GetLoginUserID="okkang7" or GetLoginUserID="phsman1" then
'	G_IsPojangok = TRUE
'end if

class Cpack_item

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class Cpack
	public FItemList()
	public FOneItem
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FShoppingBagItemCount

	public FRectUserID
	public FRectSessionID
	public FcountryCode
	public frectmidx
	public frectchkpojang
	public frectpojangok
	public FRectOrderSerial
	public FRectSort
	public FRectCancelyn

	'/inipay/pack/pack_step1.asp
	public function GetShoppingBag_pojangtemp_Checked(byval isOnlyChecked)
		dim sqlStr, userKey, isLoginUser, i, dlvType

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    Exit function
		end if
        if (FcountryCode="AA") then
            dlvType = "f"
        elseif (FcountryCode="ZZ") then
            dlvType = "a"
        elseif (FcountryCode="TT") then
            dlvType = "t"
        elseif (FcountryCode="TA") then
            dlvType = "b"
        end if

        'if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_pack_temp_list '" & userKey & "', '" & isLoginUser & "', 'Y', '"& dlvType &"', '"& frectpojangok &"'"
        'else
    	'    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_pack_temp_list '" & userKey & "','" & isLoginUser & "','','"& dlvType &"', '"& frectpojangok &"'"
        'end if
		
		'response.write sqlStr & "<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FShoppingBagItemCount = rsget.RecordCount
    	if (FShoppingBagItemCount<1) then FShoppingBagItemCount=0

    	redim FItemList(FShoppingBagItemCount)
    	i=0

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem

			FItemList(i).fpojangitemno	    = rsget("pojangitemno")
			FItemList(i).FItemID	    = rsget("itemid")
			FItemList(i).FItemoption    = rsget("itemoption")
			FItemList(i).FPojangOk = rsget("pojangok")
			FItemList(i).FItemName      = db2html(rsget("itemname"))
			FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
			If IsNULL(FItemList(i).FImageSmall) then FItemList(i).FImageSmall=""
			FItemList(i).FImageList    = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
			If IsNULL(FItemList(i).FImageList) then FItemList(i).FImageList=""

			FItemList(i).FSellcash      = rsget("sellcash")
			FItemList(i).FBrandName     = rsget("brandname")
			FItemList(i).FMakerID       = rsget("makerid")
			FItemList(i).Fdeliverytype  = rsget("deliverytype")

			FItemList(i).FLimitYn       = rsget("limityn")
			FItemList(i).FLimitNo       = rsget("limitno")
			FItemList(i).FLimitSold     = rsget("limitsold")

			FItemList(i).FSellyn        = rsget("sellyn")
			FItemList(i).FVatInclude    = rsget("vatinclude")
			FItemList(i).FBuycash       = rsget("buycash")
			FItemList(i).FMileage       = rsget("mileage")

			''감성마니아 3배마일리지
			if CStr(GetLoginUserLevel())="9" then
				FItemList(i).FMileage   = CLng(FItemList(i).FMileage) * 3
			end if

			'' VIp GOLD & VVIP 1.3
			if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 1.3)
			end if


			FItemList(i).FItemDiv       = rsget("itemdiv")
            FItemList(i).FMwdiv         = rsget("mwdiv")

			FItemList(i).Fdeliverarea   = rsget("deliverarea")
			FItemList(i).Fdeliverfixday = rsget("deliverfixday")
            IF IsNULL(FItemList(i).Fdeliverfixday) then FItemList(i).Fdeliverfixday=""

			FItemList(i).FSailYN        = rsget("sailyn")
			FItemList(i).FSailPrice     = rsget("sailprice")
			FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
			FItemList(i).FOrgPrice          = rsget("orgprice")

			FItemList(i).Fitemcouponyn		= rsget("itemcouponyn")
			FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
			FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
			FItemList(i).Fcurritemcouponidx	= rsget("curritemcouponidx")

			FItemList(i).Foptioncnt         = rsget("optioncnt")
			FItemList(i).FItemEa            = rsget("itemea")
			FItemList(i).FrequireDetail     = db2Html(rsget("requireDetail"))

			''마일리지샾상품일경우 1개로 Fix
			if (FItemList(i).IsMileShopSangpum) and (FItemList(i).FItemEa>1) then
				FItemList(i).FItemEa = 1
			end if

            FItemList(i).Foptsellyn     = rsget("optsellyn")
			FItemList(i).Foptlimityn    = rsget("optlimityn")
			FItemList(i).Foptlimitno    = rsget("optlimitno")
			FItemList(i).Foptlimitsold  = rsget("optlimitsold")
            FItemList(i).Foptaddprice   = rsget("optaddprice")
            FItemList(i).Foptaddbuyprice= rsget("optaddbuyprice")

			FItemList(i).FItemOptionName  = db2html(rsget("optionname"))

    	    ''201005 추가 : 옵션이 없어졌을경우 대비.
    	    if (FItemList(i).FItemoption<>"0000") and (FItemList(i).FItemOptionName="") then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if
            ''201401 추가 : 옵션이 추가되는경우 대비
            if (FItemList(i).FItemoption="0000") and (CLNG(FItemList(i).Foptioncnt)>0) then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if

		    FItemList(i).FdefaultFreeBeasongLimit   = rsget("defaultFreeBeasongLimit")
            FItemList(i).FdefaultDeliverPay         = rsget("defaultDeliverPay")

            FItemList(i).FavailPayType              = rsget("availPayType")

            ''상품 쿠폰 관련 : 중복주의;;
            FItemList(i).FUserVaildCoupon = rsget("itemcouponidx")
			FItemList(i).FCouponBuyPrice  = rsget("couponbuyprice")

		    if IsNULL(FItemList(i).FUserVaildCoupon) then
		        FItemList(i).FUserVaildCoupon = False
		    else
		        FItemList(i).FUserVaildCoupon = True
		    end if

		    FItemList(i).FdeliverOverseas   = rsget("deliverOverseas")
            FItemList(i).FitemWeight        = rsget("itemWeight")
		    FItemList(i).FreserveItemTp     = rsget("reserveItemTp")

            ''2013/09
		    FItemList(i).ForderMaxNum    = rsget("orderMaxNum")
		    FItemList(i).ForderMinNum    = rsget("orderMinNum")

            i=i+1
    		rsget.movenext
    	loop
    	rsget.Close

		dim tmpitemid
		'' 플러스 할인 상품
        if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "','Y'"
        else
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "',''"
        end if

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

        do until rsget.Eof
			tmpitemid = rsget("itemid")
			for i=0 to FShoppingBagItemCount -1
				if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) then
				    if (rsget("plusSalePro")>FItemList(i).FPLusSalePro) then
					    FItemList(i).FPLusSalePro       = rsget("plusSalePro")
					    FItemList(i).FPLusSaleMargin    = rsget("PLusSaleMargin")
					    FItemList(i).FPLusSaleMaginFlag    = rsget("PLusSaleMaginFlag")
					end if
				end if
			next
			rsget.movenext
		loop

		rsget.Close
	end function

	'/inipay/pack/pack_step1.asp
	public function Getpojangtemp_master()
		dim sqlStr, userKey, isLoginUser, i, dlvType

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    Exit function
		end if

        sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_pack_temp_master '" & userKey & "','" & isLoginUser & "', 'Y', '', '"& frectmidx &"', '"& frectchkpojang &"', ''"

		'response.write sqlStr & "<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FResultCount = rsget.RecordCount
    	if (FResultCount<1) then FResultCount=0

    	redim FItemList(FResultCount)
    	i=0

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem
			FItemList(i).fmidx	    = rsget("midx")
			FItemList(i).Fuserid	    = rsget("userid")
			FItemList(i).Ftitle    = db2html(rsget("title"))
			FItemList(i).Fmessage = db2html(rsget("message"))
			FItemList(i).Fpackitemcnt      = rsget("packitemcnt")
			FItemList(i).Fregdate      = rsget("regdate")
            i=i+1
    		rsget.movenext
    	loop
    	rsget.Close
	end function

	'/inipay/pack/pack_step2.asp
	public function Getpojangtemp_detail(byval isOnlyChecked)
		dim sqlStr, userKey, isLoginUser, i, dlvType

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    Exit function
		end if
        if (FcountryCode="AA") then
            dlvType = "f"
        elseif (FcountryCode="ZZ") then
            dlvType = "a"
        elseif (FcountryCode="TT") then
            dlvType = "t"
        elseif (FcountryCode="TA") then
            dlvType = "b"
        end if

        'if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_pack_temp_detail '" & userKey & "','" & isLoginUser & "','Y','"& dlvType &"', '"& frectmidx &"', '"& frectchkpojang &"', '"& frectpojangok &"'"
        'else
    	'    sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBag_pack_temp_detail '" & userKey & "','" & isLoginUser & "','','"& dlvType &"', '"& frectmidx &"', '"& frectchkpojang &"', '"& frectpojangok &"'"
        'end if
		
		'response.write sqlStr & "<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

    	FShoppingBagItemCount = rsget.RecordCount
    	if (FShoppingBagItemCount<1) then FShoppingBagItemCount=0

    	redim FItemList(FShoppingBagItemCount)
    	i=0

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem

			FItemList(i).fpojangitemno	    = rsget("itemno")
			FItemList(i).fpackitemcnt	    = rsget("packitemcnt")

			FItemList(i).FItemID	    = rsget("itemid")
			FItemList(i).FItemoption    = rsget("itemoption")
			FItemList(i).FPojangOk = rsget("pojangok")
			FItemList(i).FItemName      = db2html(rsget("itemname"))
			FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
			If IsNULL(FItemList(i).FImageSmall) then FItemList(i).FImageSmall=""
			FItemList(i).FImageList    = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
			If IsNULL(FItemList(i).FImageList) then FItemList(i).FImageList=""

			FItemList(i).FSellcash      = rsget("sellcash")
			FItemList(i).FBrandName     = rsget("brandname")
			FItemList(i).FMakerID       = rsget("makerid")
			FItemList(i).Fdeliverytype  = rsget("deliverytype")

			FItemList(i).FLimitYn       = rsget("limityn")
			FItemList(i).FLimitNo       = rsget("limitno")
			FItemList(i).FLimitSold     = rsget("limitsold")

			FItemList(i).FSellyn        = rsget("sellyn")
			FItemList(i).FVatInclude    = rsget("vatinclude")
			FItemList(i).FBuycash       = rsget("buycash")
			FItemList(i).FMileage       = rsget("mileage")

			''감성마니아 3배마일리지
			if CStr(GetLoginUserLevel())="9" then
				FItemList(i).FMileage   = CLng(FItemList(i).FMileage) * 3
			end if

			'' VIp GOLD & VVIP 1.3
			if CStr(GetLoginUserLevel())="4" or CStr(GetLoginUserLevel())="6" then
				FItemList(i).FMileage   = CLng(CLng(FItemList(i).FMileage) * 1.3)
			end if

			FItemList(i).FItemDiv       = rsget("itemdiv")
            FItemList(i).FMwdiv         = rsget("mwdiv")

			FItemList(i).Fdeliverarea   = rsget("deliverarea")
			FItemList(i).Fdeliverfixday = rsget("deliverfixday")
            IF IsNULL(FItemList(i).Fdeliverfixday) then FItemList(i).Fdeliverfixday=""

			FItemList(i).FSailYN        = rsget("sailyn")
			FItemList(i).FSailPrice     = rsget("sailprice")
			FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
			FItemList(i).FOrgPrice          = rsget("orgprice")

			FItemList(i).Fitemcouponyn		= rsget("itemcouponyn")
			FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
			FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
			FItemList(i).Fcurritemcouponidx	= rsget("curritemcouponidx")

			FItemList(i).Foptioncnt         = rsget("optioncnt")
			FItemList(i).FItemEa            = rsget("itemea")
			FItemList(i).FrequireDetail     = db2Html(rsget("requireDetail"))

			''마일리지샾상품일경우 1개로 Fix
			if (FItemList(i).IsMileShopSangpum) and (FItemList(i).FItemEa>1) then
				FItemList(i).FItemEa = 1
			end if

            FItemList(i).Foptsellyn     = rsget("optsellyn")
			FItemList(i).Foptlimityn    = rsget("optlimityn")
			FItemList(i).Foptlimitno    = rsget("optlimitno")
			FItemList(i).Foptlimitsold  = rsget("optlimitsold")
            FItemList(i).Foptaddprice   = rsget("optaddprice")
            FItemList(i).Foptaddbuyprice= rsget("optaddbuyprice")

			FItemList(i).FItemOptionName  = db2html(rsget("optionname"))

    	    ''201005 추가 : 옵션이 없어졌을경우 대비.
    	    if (FItemList(i).FItemoption<>"0000") and (FItemList(i).FItemOptionName="") then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if
            ''201401 추가 : 옵션이 추가되는경우 대비
            if (FItemList(i).FItemoption="0000") and (CLNG(FItemList(i).Foptioncnt)>0) then
    	        FItemList(i).FItemOptionName = "옵션확인요망"
    	        FItemList(i).FSellyn = "N"
    	    end if

		    FItemList(i).FdefaultFreeBeasongLimit   = rsget("defaultFreeBeasongLimit")
            FItemList(i).FdefaultDeliverPay         = rsget("defaultDeliverPay")

            FItemList(i).FavailPayType              = rsget("availPayType")

            ''상품 쿠폰 관련 : 중복주의;;
            FItemList(i).FUserVaildCoupon = rsget("itemcouponidx")
			FItemList(i).FCouponBuyPrice  = rsget("couponbuyprice")

		    if IsNULL(FItemList(i).FUserVaildCoupon) then
		        FItemList(i).FUserVaildCoupon = False
		    else
		        FItemList(i).FUserVaildCoupon = True
		    end if

		    FItemList(i).FdeliverOverseas   = rsget("deliverOverseas")
            FItemList(i).FitemWeight        = rsget("itemWeight")
		    FItemList(i).FreserveItemTp     = rsget("reserveItemTp")

            ''2013/09
		    FItemList(i).ForderMaxNum    = rsget("orderMaxNum")
		    FItemList(i).ForderMinNum    = rsget("orderMinNum")

            i=i+1
    		rsget.movenext
    	loop
    	rsget.Close

		dim tmpitemid
		'' 플러스 할인 상품
        if (isOnlyChecked) then
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "','Y'"
        else
            sqlStr = " exec [db_my10x10].[dbo].sp_Ten_ShoppingBagPLusSaleItem  '" + userKey + "','" + isLoginUser + "',''"
        end if

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget

        do until rsget.Eof
			tmpitemid = rsget("itemid")
			for i=0 to FShoppingBagItemCount -1
				if (CStr(FItemList(i).FItemID)=CStr(tmpitemid)) then
				    if (rsget("plusSalePro")>FItemList(i).FPLusSalePro) then
					    FItemList(i).FPLusSalePro       = rsget("plusSalePro")
					    FItemList(i).FPLusSaleMargin    = rsget("PLusSaleMargin")
					    FItemList(i).FPLusSaleMaginFlag    = rsget("PLusSaleMaginFlag")
					end if
				end if
			next
			rsget.movenext
		loop

		rsget.Close
	end function
	
	public function Getpojang_master()
		dim sqlStr, userKey, isLoginUser, i, dlvType

		if (FRectUserID<>"") then
		    userKey = FRectUserID
		    isLoginUser="Y"
		elseif (FRectSessionID<>"") then
		    userKey = FRectSessionID
		    isLoginUser="N"
		else
		    Exit function
		end if

        sqlStr = " exec [db_my10x10].[dbo].[sp_Ten_ShoppingBag_pack_master] '" & chkIIF(isLoginUser="Y",userKey,"") & "','" & isLoginUser & "', '" & FRectOrderSerial & "', '" & frectmidx & "', '" & FRectCancelyn & "', '" & FRectSort & "'"

        rsget.CursorLocation = adUseClient
    	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

    	FResultCount = rsget.RecordCount
    	if (FResultCount<1) then FResultCount=0

    	redim FItemList(FResultCount)
    	i=0

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem
			FItemList(i).fmidx	    = rsget("midx")
			FItemList(i).Fuserid	    = rsget("userid")
			FItemList(i).Ftitle    = db2html(rsget("title"))
			FItemList(i).Fmessage = db2html(rsget("message"))
			FItemList(i).Fpackitemcnt      = rsget("packitemcnt")
			FItemList(i).Fregdate      = rsget("regdate")
            i=i+1
    		rsget.movenext
    	loop
    	rsget.Close
	end function
	
	public function Getpojang_itemlist()
		dim sqlStr
        sqlStr = " exec [db_my10x10].[dbo].[sp_Ten_ShoppingBag_pack_itemlist] '" & frectmidx & "', '" & FRectOrderSerial & "'"

        rsget.CursorLocation = adUseClient
    	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

    	FResultCount = rsget.RecordCount
    	if (FResultCount<1) then FResultCount=0

    	redim FItemList(FResultCount)
    	i=0

    	do Until rsget.Eof
			set FItemList(i) = new CShoppingBagItem
			FItemList(i).FItemID	    = rsget("itemid")
			FItemList(i).FItemOption    = rsget("itemoption")
			FItemList(i).FItemEa		= rsget("itemno")
			FItemList(i).FItemOptionName = db2html(rsget("itemoptionname"))
			FItemList(i).FItemName	    = db2html(rsget("itemname"))
			'FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/small/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("smallimage")
			'FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/List120/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("listimage120")
			FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("icon1image")
			FItemList(i).FBrandName		= db2html(rsget("brandname"))
			FItemList(i).FMakerId		= rsget("makerid")
            i=i+1
    		rsget.movenext
    	loop
    	rsget.Close
	end function

	public function GetImageFolerName(byval i)
	    GetImageFolerName = GetImageSubFolderByItemid(FItemList(i).FItemID)
	end function

    '' 현장수령 상품 존재 여부
    public function IsRsvSiteSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsReceiveSite) then
					IsRsvSiteSangpumExists = true
					Exit function
				end if
			end if
		next
		IsRsvSiteSangpumExists = false
	end function

    '' Present 상품 존재 여부
    public function IsPresentSangpumExists()
		dim i
		for i=0 to FShoppingBagItemCount -1
			if Not (FItemList(i) is Nothing) then
				if (FItemList(i).IsPresentItem) then
					IsPresentSangpumExists = true
					Exit function
				end if
			end if
		next
		IsPresentSangpumExists = false
	end function

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FShoppingBagItemCount = 0
		FScrollCount = 10
		FTotalCount = 0
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
end Class

'//선뭎포장 임시 테이블 비움	'/2015.11.06 한용민 생성
function getpojangtemptabledel(midx)
	dim sqlStr, userKey, isLoginUser

    if IsUserLoginOK() then
	    userKey = getEncLoginUserID
	    isLoginUser="Y"
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	    isLoginUser="N"
	end if

	sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp_del '" & userKey & "','" & isLoginUser & "', '', '', '"& midx &"'"

	'Response.write sqlStr &"<br>"
	dbget.Execute sqlStr
end function

'/선물포장 임시 상품이 장바구니 담은 상품과 같은지 체크		'/2015.11.06 한용민 생성
'(0:정상, 1:선물포장 상품이 장바구니 상품과 일치하지 않음)
function getShoppingBag_temppojang_CheckNotexistsitem(countryCode, pojangok)
	dim sqlStr, userKey, isLoginUser, i, dlvType, tmpcnt, tmpval
	tmpcnt=0
	tmpval=0

    if IsUserLoginOK() then
	    userKey = getEncLoginUserID
	    isLoginUser="Y"
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	    isLoginUser="N"
	end if
    if (countryCode="AA") then
        dlvType = "f"
    elseif (countryCode="ZZ") then
        dlvType = "a"
    elseif (countryCode="TT") then
        dlvType = "t"
    elseif (countryCode="TA") then
        dlvType = "b"
    end if

	sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp_CheckNotexistsitem '" & userKey & "','" & isLoginUser & "','Y','"& dlvType &"', '"& pojangok &"'"

    'response.write strSql & "<br>"
	rsget.Open sqlStr,dbget,1
	IF Not rsget.EOF THEN
		tmpcnt = rsget("cnt")
	END IF
	rsget.Close

	'/선물포장 상품이 장바구니 상품과 일치하지 않는 상품
	if tmpcnt > 0 then tmpval=1

	getShoppingBag_temppojang_CheckNotexistsitem = tmpval
end function

'/장바구니 상품과 선물포장 임시 상품이 유효한 상품인지 체크		'/2015.11.06 한용민 생성
'(0:정상, 1:장바구니 상품보다 더포장된 상품이 있음, 2:장바구니에 상품없음, 3:더이상포장할상품이 없음)
function getShoppingBag_temppojang_checkValidItem(countryCode, pojangok)
	dim sqlStr, userKey, isLoginUser, tmparr, tmpval, i, dlvType, tmpcnt
	tmpval=0
	tmpcnt=0

    if IsUserLoginOK() then
	    userKey = getEncLoginUserID
	    isLoginUser="Y"
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	    isLoginUser="N"
	end if
    if (countryCode="AA") then
        dlvType = "f"
    elseif (countryCode="ZZ") then
        dlvType = "a"
    elseif (countryCode="TT") then
        dlvType = "t"
    elseif (countryCode="TA") then
        dlvType = "b"
    end if

	sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_pack_temp_CheckVailditem '" & userKey & "','" & isLoginUser & "','Y','"& dlvType &"', '"& pojangok &"'"

    'response.write strSql & "<br>"
	rsget.Open sqlStr,dbget,1
	IF Not rsget.EOF THEN
		tmparr = rsget.getRows()
	END IF
	rsget.Close

	If isArray(tmparr) THEN
		For i =0 To UBOund(tmparr,2)
			'/장바구니 상품 수량 보다 선물포장 임시 상품 수량이 크다면
			if tmparr(2,i) < tmparr(3,i) THEN
				tmpval=1
				exit For
			end if
			
			'/포장가능한 상품의 갯수
			if tmparr(2,i) > tmparr(3,i) THEN
				tmpcnt = tmpcnt + 1
			end if
		Next
		
		'//포장가능한 상품이 없다면
		if tmpcnt<1 then
			tmpval=3
		end if
	else
		tmpval=2
	END If

	getShoppingBag_temppojang_checkValidItem = tmpval
end function

'/장바구니 상품 단품인지 체크	'/2015.11.06 한용민 생성
'(0:단품, 1:복합, 2:장바구니에 상품없음)
function getShoppingBag_checkset(countryCode)
	dim sqlStr, tmpval, tmparr, userKey, isLoginUser, dlvType, totalcount
	tmpval=0
	totalcount=0

	if IsUserLoginOK() then
	    userKey = getEncLoginUserID
	    isLoginUser="Y"
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	    isLoginUser="N"
	end if
    if (countryCode="AA") then
        dlvType = "f"
    elseif (countryCode="ZZ") then
        dlvType = "a"
    elseif (countryCode="TT") then
        dlvType = "t"
    elseif (countryCode="TA") then
        dlvType = "b"
    end if

	sqlStr = " exec db_my10x10.dbo.sp_Ten_ShoppingBag_cnt '" & userKey & "','" & isLoginUser & "', 'Y', '"& dlvType &"'"

	'Response.write sqlStr &"<br>"
    rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr, dbget

	'response.write SqlStr&"<br>"
	if not rsget.EOF then
        tmparr = rsget.getRows()
	end if
	rsget.close

	If isArray(tmparr) THEN
		totalcount = ubound(tmparr,2)

		'/상품항목 자체가 여래개 복합
		if totalcount>0 then
			tmpval=1
		else
			'/상품항목은 단품이나 수량이 많아서 복합
			if tmparr(1,0) > 1 then
				tmpval=1

			'/단품
			else
				tmpval=0
			end if
		end if

	'/장바구니 상품 존재안함
	else
		tmpval=2
	END If

	getShoppingBag_checkset=tmpval
end function
%>
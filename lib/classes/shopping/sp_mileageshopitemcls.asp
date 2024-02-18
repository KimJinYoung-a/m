<%
Class CMileageShopItem
	public FItemId
	public FItemName
	public Fmakerid
	public FSellCash
	public FOrgPrice
	public FEventPrice

	public FImageSmall
	public FImageList
	public FIcon1Image
    public Flistimage120
    
	public FDispyn
	public FSellyn
	public FLimitYn
	public FLimitNo
	public FLimitSold

	public FSpecialuseritem

	public FSailYN
	public NowEventDoing

	public FItemContent
	public FDesignercomment
    
    public FEvalcnt
    public FFavcnt
    public FOptionCnt
    
	public function getMileageCash()
		if NowEventDoing then
			if FEventPrice=0 then
				getMileageCash = FSellCash
			else
				getMileageCash = FEventPrice
			end if
		else
			getMileageCash = FSellCash
		end if
	end function

	public function getRealPrice()
		if NowEventDoing then
			if FEventPrice=0 then
				getRealPrice = FSellCash
			else
				getRealPrice = FEventPrice
			end if
		else
			getRealPrice = FSellCash
		end if

		'if CStr(getUserLevel())="1" then
		'	getRealPrice = CLng(getRealPrice*0.9)
		'elseif CStr(getUserLevel())="2" then
		'	getRealPrice = CLng(getRealPrice*0.85)
		'elseif CStr(getUserLevel())="3" then
		'	getRealPrice = CLng(getRealPrice*0.8)
		'end if
	end function

	public function Is20proEventItem()
		if NowEventDoing then
			if (FSellCash>FEventPrice) and  (FEventPrice<>0) then
				Is20proEventItem = true
			else
				Is20proEventItem = false
			end if
		else
			Is20proEventItem = false
		end if
	end function

	public function IsSailItem()
		if NowEventDoing then
			IsSailItem = (((FEventPrice<>0) and (FSellCash>FEventPrice)) or ((FSailYN="Y") and (FOrgPrice>FSellCash))) or (FSpecialuseritem>0)
		else
			IsSailItem = ((FSailYN="Y") and (FOrgPrice>FSellCash)) or (FSpecialuseritem>0)
		end if
	end function

	public function getSailPro()
		if FOrgPrice=0 then
			getSailPro = 0
		else
			getSailPro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100)
		end if
	end function

    '// 옵션 존재여부 옵션 갯수로 체크
    public function IsItemOptionExists()
        IsItemOptionExists = (FOptioncnt>0)
    end function

	public function IsFreeBeasong()
		if FItemGubun="04" then
			if FSellCash>=getFreeBeasongLimitByUserLevel() then
				IsFreeBeasong = true
			else
				IsFreeBeasong = false
			end if
		else
			if FSellCash>=getFreeBeasongLimitByUserLevel() then
				IsFreeBeasong = true
			else
				IsFreeBeasong = false
			end if
		end if

		if (FDeliverytype="4") or (FDeliverytype="5") then
			IsFreeBeasong = true
		end if
	end function

	public function getFreeBeasongLimitByUserLevel()
		dim ulevel
		ulevel = getUserLevel()
		if ulevel>3 then
			getFreeBeasongLimitByUserLevel = 0
		elseif ulevel>2 then
			if date<="2010-07-01" then
				getFreeBeasongLimitByUserLevel = 10000
			else
				getFreeBeasongLimitByUserLevel = 0
			end if
		elseif ulevel>1 then
			getFreeBeasongLimitByUserLevel = 30000
		elseif ulevel>0 then
			getFreeBeasongLimitByUserLevel = 40000
		else
			getFreeBeasongLimitByUserLevel = 50000
		end if
	end function

	public function getUserLevel()
		getUserLevel = GetLoginUserLevel()
	end function

	public function IsSoldOut()
		IsSoldOut = (FDispyn="N") or (FSellyn="N") or ((FLimityn="Y") and (FLimitno-FLimitsold<1))
	end function

	public function getRemainNo()
		getRemainNo = FLimitno-FLimitsold
		if getRemainNo<1 then getRemainNo=0
		if IsSoldOut then getRemainNo=0
	end function

	Private Sub Class_Initialize()
        FEvalcnt = 0
        FFavcnt = 0
        FOptionCnt = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class CMileageShop
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
    
    public Sub GetMileageShopItemList()
		dim sqlStr, i
		
		sqlStr = "exec db_item.dbo.sp_Ten_MileageShopItemListTop100"
		
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget
		
		FTotalCount   = rsget.RecordCount
		FResultCount = FTotalCount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			
			do until rsget.eof
				set FItemList(i) = new CMileageShopItem
				FItemList(i).FItemId       = rsget("itemid")
				FItemList(i).FItemName     = db2html(rsget("itemname"))
				FItemList(i).Fmakerid      = rsget("makerid")
				FItemList(i).FSellCash     = rsget("sellcash")
				FItemList(i).FOrgPrice     = rsget("orgprice")

				FItemList(i).FSellyn       = rsget("sellyn")
				FItemList(i).FLimitYn      = rsget("limityn")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")

				FItemList(i).FSailYN		= rsget("sailyn")
				FItemList(i).FSpecialuseritem = rsget("specialuseritem")

				FItemList(i).FImageSmall   = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("smallimage")
				FItemList(i).FImageList   = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FIcon1Image  = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("icon1image")
                FItemList(i).Flistimage120  = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage120")
                
                FItemList(i).FEvalcnt   = rsget("evalcnt")
                FItemList(i).FFavcnt   = rsget("favcount")
                FItemList(i).FOptionCnt = rsget("optioncnt")
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

    end sub

	public Sub GetMileageShopItemList_OLD()
		dim sqlStr, i
		sqlStr = "select count(itemid) as cnt"
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item i"
		sqlStr = sqlStr + " where i.itemdiv='82'"
		sqlStr = sqlStr + " and i.sellyn='Y'"
        ''sqlStr = sqlStr + " and ((i.limityn='N') or (i.limityn='Y' and (i.limitno-i.limitsold>0)))"
        
		rsget.Open sqlStr,dbget,1
		FTotalCount = rsget("cnt")
		rsget.Close


		sqlStr = "select top " + CStr(FPageSize*FCurrPage)
		sqlStr = sqlStr + " i.itemid, i.itemname, i.makerid,i.sellcash,i.sailyn,i.orgprice,"
		sqlStr = sqlStr + " i.sellyn,i.limityn,i.limitno,i.limitsold,i.sailyn,i.specialuseritem,"
		sqlStr = sqlStr + " i.smallimage, i.listimage, i.icon1image, i.evalcnt"
		''sqlStr = sqlStr + " ,c.itemcontent, c.designercomment"
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item i"
		sqlStr = sqlStr + " where i.itemdiv='82'"
		sqlStr = sqlStr + " and i.sellyn='Y'"
		''sqlStr = sqlStr + " and ((i.limityn='N') or (i.limityn='Y' and (i.limitno-i.limitsold>0)))"

		sqlStr = sqlStr + " order by i.itemid desc"

		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMileageShopItem
				FItemList(i).FItemId       = rsget("itemid")
				FItemList(i).FItemName     = db2html(rsget("itemname"))
				FItemList(i).Fmakerid      = rsget("makerid")
				FItemList(i).FSellCash     = rsget("sellcash")
				FItemList(i).FOrgPrice     = rsget("orgprice")

				FItemList(i).FSellyn       = rsget("sellyn")
				FItemList(i).FLimitYn      = rsget("limityn")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")

				FItemList(i).FSailYN		= rsget("sailyn")
				FItemList(i).FSpecialuseritem = rsget("specialuseritem")
				''FItemList(i).FItemContent = db2html(rsget("itemcontent"))
				''FItemList(i).FDesignercomment = db2html(rsget("designercomment"))

				FItemList(i).FImageSmall   = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("smallimage")
				FItemList(i).FImageList   = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FIcon1Image  = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("icon1image")
                
                FItemList(i).FEvalcnt   = rsget("evalcnt")
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
<%
Class CUserItemCouponItem
	public Fcouponidx
	public Fuserid
	public Fitemcouponidx
	public Fissuedno
	public Fitemcoupontype
	public Fitemcouponvalue
	public Fitemcouponstartdate
	public Fitemcouponexpiredate
	public Fitemcouponname
	public Fitemcouponimage
	public FitemidList

	public Fregdate
	public Fusedyn
	public Forderserial
    
    public function IsFreeBeasongCoupon()
        IsFreeBeasongCoupon = Fitemcoupontype="3"
    end function
    
	public function GetDiscountStr()
	    if (IsFreeBeasongCoupon) then
    	    GetDiscountStr = "무료배송 쿠폰"
	    else
		    GetDiscountStr = CStr(Fitemcouponvalue) + GetItemCouponTypeName + " 할인"
	    end if
	end function

	public function GetItemCouponTypeName
		Select Case Fitemcoupontype
			Case "1"
				GetItemCouponTypeName = "%"
			Case "2"
				GetItemCouponTypeName = "원"
			Case "3"
				GetItemCouponTypeName = "무료배송"
			Case Else
				GetItemCouponTypeName = Fitemcoupontype
		end Select
	end function
    
    public function getAvailDateStr()
		getAvailDateStr = FormatDate(Fitemcouponstartdate,"0000/00/00") & "~" & FormatDate(Fitemcouponexpiredate,"0000/00/00")&" "&FormatDate(Fitemcouponexpiredate,"00:00")&" 까지"
	end function
	
	public function getAvailDateStrFinish()
		getAvailDateStrFinish = Left(Fitemcouponexpiredate,10)
	end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class


Class CItemCouponDetailItem
	public Fitemcouponidx
	public Fitemid
	public Fcouponbuyprice

	public Fitemcoupontype
	public Fitemcouponvalue

	public FMakerid
	public FSellcash
	public FBuycash
	public FItemName
	public FSmallImage
	public FImageList
	public FImageIcon1
	public FMwDiv
	Public FEvalCnt
	Public FFavCount


	public function GetCouponSellcash()
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				GetCouponSellcash = FSellcash - CLng(Fitemcouponvalue*FSellcash/100)
			case "2" ''원 쿠폰
				GetCouponSellcash = FSellcash - Fitemcouponvalue
			case "3" ''무료배송 쿠폰
			    GetCouponSellcash = FSellcash
			case else
				GetCouponSellcash = 0
		end Select

		if GetCouponSellcash<1 then GetCouponSellcash=0
	end function

	public function GetMwDivName()
		select Case FMwDiv
			case "M"
				GetMwDivName = "매입"
			case "W"
				GetMwDivName = "위탁"
			case "U"
				GetMwDivName = "업체"
			case else
				GetMwDivName = FMwDiv
		end Select
	end function

	public function GetMwDivColor()
		select Case FMwDiv
			case "M"
				GetMwDivColor = "#0000FF"
			case "W"
				GetMwDivColor = "위탁"
			case "U"
				GetMwDivColor = "#FF0000"
			case else
				GetMwDivColor = "#000000"
		end Select
	end function

	public function GetCurrentMargin()
		if FSellcash<>0 then
			GetCurrentMargin = CLng((FSellcash-FBuycash)/FSellcash*100)
		else
			GetCurrentMargin = 0
		end if
	end function

	public function GetCouponMargin()
		dim tmpbuyprice

		if Fcouponbuyprice=0 then
			tmpbuyprice = FBuycash
		else
			tmpbuyprice = Fcouponbuyprice
		end if

		if GetCouponSellcash<>0 then
			GetCouponMargin = CLng((GetCouponSellcash-tmpbuyprice)/GetCouponSellcash*100)
		else
			GetCouponMargin = 0
		end if
	end function

	public function GetCouponMarginColor()
		if GetCouponMargin<5 then
			GetCouponMarginColor = "#FF0000"
		else
			GetCouponMarginColor = "#000000"
		end if
	end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CItemCouponMasterItem
	public Fitemcouponidx
	public Fitemcoupontype
	public Fitemcouponvalue
	public Fitemcouponstartdate
	public Fitemcouponexpiredate
	public Fitemcouponname
	public Fitemcouponimage
	public Fitemcouponexplain
	public Fapplyitemcount
	public Fopenstate
	public Fmargintype
	public Fregdate
	public FRegUserid

	public Fcurrdate

	public function IsOpenAvailCoupon
		IsOpenAvailCoupon = (Fitemcouponstartdate<=Fcurrdate) and (Fitemcouponexpiredate>=Fcurrdate) and (Fopenstate="7")
	end function
    
    public function IsFreeBeasongCoupon()
        IsFreeBeasongCoupon = Fitemcoupontype="3"
    end function

	public function GetDiscountStr()
	    if (IsFreeBeasongCoupon) then
	        GetDiscountStr = "무료배송 쿠폰"
	    else
		    GetDiscountStr = CStr(Fitemcouponvalue) + GetItemCouponTypeName + " 할인"
		end if
	end function

	public function GetItemCouponTypeName
		Select Case Fitemcoupontype
			Case "1"
				GetItemCouponTypeName = "%"
			Case "2"
				GetItemCouponTypeName = "원"
			Case "3"    
			    GetItemCouponTypeName = "무료배송"
			Case Else
				GetItemCouponTypeName = Fitemcoupontype
		end Select
	end function

	public function GetMargintypeName()
		Select Case Fmargintype
			Case "00"
				GetMargintypeName = "일반"
			Case "10"
				GetMargintypeName = "텐바이텐부담"
			Case "50"
				GetMargintypeName = "반반부담"
			Case "60"
				GetMargintypeName = "업체부담"
			Case "80"
				GetMargintypeName = "무료배송"
			Case "90"
				GetMargintypeName = "20%전체행사"
			Case Else
				GetMargintypeName =	Fmargintype
		end Select
	end function

	public function GetOpenStateName()
		Select Case Fopenstate
			case "0"
				GetOpenStateName = "발급대기"
			case "6"
				GetOpenStateName = "발급예약"
			case "7"
				GetOpenStateName = "오픈"
			case "9"
				GetOpenStateName = "발급강제종료"
			case else
				GetOpenStateName = Fopenstate
		end Select

	end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CUserItemCoupon
	public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectItemCouponIdx
	public FRectUserID
	public FRectItemID

	public function getValidItemCouponListInBaguni()
		dim sqlStr,i
		sqlStr = "EXEC db_item.dbo.[usp_Ten_getValidItemCouponListInBaguni] '" & FRectUserID & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount
		FTotalCount  = FResultCount

		redim preserve FItemList(FResultCount)

		if not rsget.Eof then
			do until rsget.eof
				set FItemList(i) = new CUserItemCouponItem
				FItemList(i).Fcouponidx           = rsget("couponidx")
				FItemList(i).Fuserid              = rsget("userid")
				FItemList(i).Fitemcouponidx       = rsget("itemcouponidx")
				FItemList(i).Fissuedno            = rsget("issuedno")
				FItemList(i).Fitemcoupontype      = rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue     = rsget("itemcouponvalue")
				FItemList(i).Fitemcouponstartdate = rsget("itemcouponstartdate")
				FItemList(i).Fitemcouponexpiredate= rsget("itemcouponexpiredate")
				FItemList(i).Fitemcouponname      = db2html(rsget("itemcouponname"))
				FItemList(i).Fitemcouponimage     = rsget("itemcouponimage")
				FItemList(i).Fregdate             = rsget("regdate")
				FItemList(i).Fusedyn              = rsget("usedyn")
				FItemList(i).Forderserial         = rsget("orderserial")


				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end function
	
	public function getValidCouponList()
		dim sqlStr,i
		sqlStr = "EXEC db_user.dbo.sp_Ten_UserSaleCouponList '" & FRectUserID & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount
		FTotalCount  = FResultCount
		
		redim preserve FItemList(FResultCount)

		if not rsget.Eof then
			do until rsget.eof
				set FItemList(i) = new CUserItemCouponItem
				FItemList(i).Fcouponidx           = rsget("couponidx")
				FItemList(i).Fuserid              = rsget("userid")
				FItemList(i).Fitemcouponidx       = rsget("itemcouponidx")
				FItemList(i).Fissuedno            = rsget("issuedno")
				FItemList(i).Fitemcoupontype      = rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue     = rsget("itemcouponvalue")
				FItemList(i).Fitemcouponstartdate = rsget("itemcouponstartdate")
				FItemList(i).Fitemcouponexpiredate= rsget("itemcouponexpiredate")
				FItemList(i).Fitemcouponname      = db2html(rsget("itemcouponname"))
				FItemList(i).Fitemcouponimage     = rsget("itemcouponimage")
				FItemList(i).Fregdate             = rsget("regdate")
				FItemList(i).Fusedyn              = rsget("usedyn")
				FItemList(i).Forderserial         = rsget("orderserial")


				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end function

	public function IsCouponAlreadyReceived()
		'' 사용안한 쿠폰 이미 받았는지
		dim sqlStr,i
		sqlStr = "select Count(*) as cnt from [db_item].[dbo].tbl_user_item_coupon"
		sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
		sqlStr = sqlStr + " and itemcouponidx=" + CStr(FRectItemCouponIdx)
		sqlStr = sqlStr + " and usedyn='N'"

		rsget.Open sqlStr, dbget, 1
			IsCouponAlreadyReceived = rsget("cnt")>0
		rsget.close

	end function

	public function IsItemCouponDownCheck()
		'' 사용안한 쿠폰 이미 받았는지
		dim sqlStr,i
		sqlStr = "EXEC db_item.dbo.usp_Ten_Chk_ItemCouponDown_New " & FRectItemID & ",'" & FRectUserID & "'," & FRectItemCouponIdx
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		if not rsget.Eof then
			IsItemCouponDownCheck = rsget(0)
		end if
		rsget.close

	end function

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)
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
end Class

Class CItemCouponMaster
	public FOneItem
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectItemCouponIdx
	public FRectMakerid
	public FRectCateCode
    
	''//2018/10/17 수정
	public Sub GetItemCouponItemListCaChe
		dim sqlStr,i
		Dim rsMem

		if (FRectCateCode<>"") then
			sqlStr = "exec db_item.[dbo].[usp_Ten_ItemCouponItemListByCate_Mob_CNT] "&CStr(FRectItemCouponIdx)&",'"&FRectCateCode&"'"
		else
			sqlStr = "exec db_item.[dbo].[usp_Ten_ItemCouponItemList_Mob_CNT] "&CStr(FRectItemCouponIdx)
		end if

		' rsget.CursorLocation = adUseClient
		' rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
		' 	FTotalCount = rsget("cnt")
		' rsget.close

		set rsMem = getDBCacheSQL(dbget,rsget,"CPNLISTCNT_M",sqlStr,60*10)
		if (rsMem is Nothing) then Exit sub ''추가
		FTotalCount = rsMem("cnt")
		rsMem.close

		if (FTotalCount<1) then Exit Sub

		if (FRectCateCode<>"") then
			sqlStr = "exec db_item.[dbo].[usp_Ten_ItemCouponItemListByCate_Mob] "&CStr(FRectItemCouponIdx)&",'"&FRectCateCode&"',"&FPageSize&","&FCurrPage
		else
			sqlStr = "exec db_item.[dbo].[usp_Ten_ItemCouponItemList_Mob] "&CStr(FRectItemCouponIdx)&","&FPageSize&","&FCurrPage
		end if

		' rsget.CursorLocation = adUseClient
		' rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		set rsMem = getDBCacheSQL(dbget,rsget,"CPNLIST_M",sqlStr,60*10)
		if (rsMem is Nothing) then Exit sub

		FtotalPage =  CLng(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsMem.RecordCount 
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		if  not rsMem.EOF  then
			i = 0
			do until rsMem.eof
				set FItemList(i) = new CItemCouponDetailItem

				FItemList(i).Fitemcouponidx = rsMem("itemcouponidx")
				FItemList(i).Fitemid        = rsMem("itemid")
				FItemList(i).Fcouponbuyprice= rsMem("couponbuyprice")

				FItemList(i).FMakerid    = rsMem("makerid")
				FItemList(i).FSellcash   = rsMem("sellcash")
				FItemList(i).FBuycash    = rsMem("buycash")
				FItemList(i).FItemName   = Db2html(rsMem("itemname"))
				FItemList(i).FSmallImage = rsMem("smallimage")
				FItemList(i).FMwDiv		= rsMem("mwdiv")

				FItemList(i).FSmallImage	= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + FItemList(i).FSmallImage
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsMem("listimage")
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsMem("icon1image")

				FItemList(i).Fitemcoupontype		= rsMem("itemcoupontype")
				FItemList(i).Fitemcouponvalue		= rsMem("itemcouponvalue")

				FItemList(i).FEvalCnt	= rsMem("EvalCnt")
				FItemList(i).FFavCount	= rsMem("favcount")

				rsMem.MoveNext
				i = i + 1
			loop
		end if
		rsMem.close
	end Sub

    '' 페이징이 많아지면 느려짐.. 2016/04/18 수정
    public Sub GetItemCouponItemList
		FScrollCount = 3
		dim sqlStr,i
		if FRectCateCode <> "" then
			FRectCateCode = "and i.dispcate1 = " & FRectCateCode
		end if
'		sqlStr = " select count(*) as cnt "
'		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item_coupon_detail"
'		sqlStr = sqlStr + " where itemcouponidx=" + CStr(FRectItemCouponIdx)' + FRectCateCode

		sqlStr = "select count(*) as cnt"
        sqlStr = sqlStr + " from ("
        sqlStr = sqlStr + " 	select ROW_NUMBER() over (order by d.itemid desc) as rownum,"
        sqlStr = sqlStr + " 	 d.itemid, d.couponbuyprice,d.itemcouponidx"
        sqlStr = sqlStr + " 	from [db_item].[dbo].tbl_item_coupon_detail d "
        sqlStr = sqlStr + " 		Join [db_item].[dbo].tbl_item i  "
        sqlStr = sqlStr + " 			on d.itemid=i.itemid  "
        sqlStr = sqlStr + " 	where d.itemcouponidx="+ CStr(FRectItemCouponIdx) & FRectCateCode & VbCRLF
        sqlStr = sqlStr + " ) d "
        sqlStr = sqlStr + " join [db_item].[dbo].tbl_item_coupon_master m "
        sqlStr = sqlStr + " on m.itemcouponidx=d.itemcouponidx and m.itemcouponidx="+ CStr(FRectItemCouponIdx)  &VbCRLF
        sqlStr = sqlStr + " Join [db_item].[dbo].tbl_item i "
        sqlStr = sqlStr + " on d.itemid=i.itemid"
        sqlStr = sqlStr + " Join [db_item].[dbo].tbl_item_contents c"
        sqlStr = sqlStr + " on d.itemid=c.itemid"
'        sqlStr = sqlStr + " where 1=1 "& FRectCateCode &vbCRLF

		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
			FTotalCount = rsget("cnt")
		rsget.close

        Dim FSPageNo, FEPageNo
        FSPageNo = (FPageSize*(FCurrPage-1)) + 1
		FEPageNo = FPageSize*FCurrPage
		
		sqlStr = "select m.itemcouponidx, m.itemcoupontype, m.itemcouponvalue,"
		sqlStr = sqlStr + " d.itemid, d.couponbuyprice,"
		sqlStr = sqlStr + " i.makerid, i.smallimage, i.listimage, i.icon1image, i.itemname,i.sellcash,i.buycash,i.mwdiv, i.evalCnt, c.favcount, i.dispcate1"
        sqlStr = sqlStr + " from ("
        sqlStr = sqlStr + " 	select ROW_NUMBER() over (order by d.itemid desc) as rownum,"
        sqlStr = sqlStr + " 	 d.itemid, d.couponbuyprice,d.itemcouponidx"
        sqlStr = sqlStr + " 	from [db_item].[dbo].tbl_item_coupon_detail d "
        sqlStr = sqlStr + " 		Join [db_item].[dbo].tbl_item i  "
        sqlStr = sqlStr + " 			on d.itemid=i.itemid  "
        sqlStr = sqlStr + " 	where d.itemcouponidx="+ CStr(FRectItemCouponIdx) & FRectCateCode & VbCRLF
        sqlStr = sqlStr + " ) d "
        sqlStr = sqlStr + " join [db_item].[dbo].tbl_item_coupon_master m "
        sqlStr = sqlStr + " on m.itemcouponidx=d.itemcouponidx and m.itemcouponidx="+ CStr(FRectItemCouponIdx)  &VbCRLF
        sqlStr = sqlStr + " Join [db_item].[dbo].tbl_item i "
        sqlStr = sqlStr + " on d.itemid=i.itemid"
        sqlStr = sqlStr + " Join [db_item].[dbo].tbl_item_contents c"
        sqlStr = sqlStr + " on d.itemid=c.itemid"
        sqlStr = sqlStr + " where d.rownum BetWeen "&FSPageNo&" and "&FEPageNo &vbCRLF
        sqlStr = sqlStr + " order by d.rownum"

		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FtotalPage =  CLng(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount ''-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			i = 0
			do until rsget.eof
				set FItemList(i) = new CItemCouponDetailItem

				FItemList(i).Fitemcouponidx = rsget("itemcouponidx")
				FItemList(i).Fitemid        = rsget("itemid")
				FItemList(i).Fcouponbuyprice= rsget("couponbuyprice")

				FItemList(i).FMakerid    = rsget("makerid")
				FItemList(i).FSellcash   = rsget("sellcash")
				FItemList(i).FBuycash    = rsget("buycash")
				FItemList(i).FItemName   = Db2html(rsget("itemname"))
				FItemList(i).FSmallImage = rsget("smallimage")
				FItemList(i).FMwDiv		= rsget("mwdiv")

				FItemList(i).FSmallImage	= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + FItemList(i).FSmallImage
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("icon1image")

				FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")

				FItemList(i).FEvalCnt	= rsget("EvalCnt")
				FItemList(i).FFavCount	= rsget("favcount")

				rsget.MoveNext
				i = i + 1
			loop
		end if
		rsget.close

	end sub
	
	public Sub GetItemCouponItemList_OLD
		FScrollCount = 3
		dim sqlStr,i
		sqlStr = " select count(*) as cnt "
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item_coupon_detail"
		sqlStr = sqlStr + " where itemcouponidx=" + CStr(FRectItemCouponIdx)

		rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close


		sqlStr = "select top " + CStr(FPageSize*FCurrPage)
		sqlStr = sqlStr + " m.itemcouponidx, m.itemcoupontype, m.itemcouponvalue,"
		sqlStr = sqlStr + " d.itemid, d.couponbuyprice,"
		sqlStr = sqlStr + " i.makerid, i.smallimage, i.listimage, i.icon1image, i.itemname,i.sellcash,i.buycash,i.mwdiv, i.evalCnt, c.favcount"
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item_coupon_master m"
		sqlStr = sqlStr + " , [db_item].[dbo].tbl_item_coupon_detail d"
		sqlStr = sqlStr + " , [db_item].[dbo].tbl_item i"
		sqlStr = sqlStr + " , [db_item].[dbo].tbl_item_contents c"
		sqlStr = sqlStr + " where m.itemcouponidx=d.itemcouponidx"
		sqlStr = sqlStr + " and d.itemcouponidx=" + CStr(FRectItemCouponIdx)
		sqlStr = sqlStr + " and d.itemid=i.itemid"
		sqlStr = sqlStr + " and d.itemid=c.itemid"
'		if FRectMakerid<>"" then
'			sqlStr = sqlStr + " and i.makerid='" +FRectMakerid + "'"
'		end if
		sqlStr = sqlStr + " order by d.itemid desc"

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CLng(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CItemCouponDetailItem

				FItemList(i).Fitemcouponidx = rsget("itemcouponidx")
				FItemList(i).Fitemid        = rsget("itemid")
				FItemList(i).Fcouponbuyprice= rsget("couponbuyprice")

				FItemList(i).FMakerid    = rsget("makerid")
				FItemList(i).FSellcash   = rsget("sellcash")
				FItemList(i).FBuycash    = rsget("buycash")
				FItemList(i).FItemName   = Db2html(rsget("itemname"))
				FItemList(i).FSmallImage = rsget("smallimage")
				FItemList(i).FMwDiv		= rsget("mwdiv")

				FItemList(i).FSmallImage	= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + FItemList(i).FSmallImage
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("listimage")
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemId) + "/" + rsget("icon1image")

				FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")

				FItemList(i).FEvalCnt	= rsget("EvalCnt")
				FItemList(i).FFavCount	= rsget("favcount")

				rsget.MoveNext
				i = i + 1
			loop
		end if
		rsget.close

	end sub

	public Sub GetOneItemCouponMaster
		dim sqlStr,i

		sqlStr = "select top 1 itemcouponidx, itemcoupontype,"
		sqlStr = sqlStr + " itemcouponvalue, convert(varchar(19),itemcouponstartdate,21) as itemcouponstartdate,"
		sqlStr = sqlStr + " convert(varchar(19),itemcouponexpiredate,21) as itemcouponexpiredate,"
		sqlStr = sqlStr + " itemcouponname, itemcouponimage, applyitemcount, openstate, itemcouponexplain,"
		sqlStr = sqlStr + " margintype, regdate, reguserid,"
		sqlStr = sqlStr + " convert(varchar(19),getdate(),21) as currdate"
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item_coupon_master"
		sqlStr = sqlStr + " where itemcouponidx=" + CStr(FRectItemCouponIdx)

		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		set FOneItem = new CItemCouponMasterItem

		If not Rsget.Eof then

			FOneItem.Fitemcouponidx        = rsget("itemcouponidx")
			FOneItem.Fitemcoupontype       = rsget("itemcoupontype")
			FOneItem.Fitemcouponvalue      = rsget("itemcouponvalue")
			FOneItem.Fitemcouponstartdate  = rsget("itemcouponstartdate")
			FOneItem.Fitemcouponexpiredate = rsget("itemcouponexpiredate")
			FOneItem.Fitemcouponname       = db2html(rsget("itemcouponname"))
			FOneItem.Fitemcouponimage      = db2html(rsget("itemcouponimage"))
			FOneItem.Fitemcouponexplain		= db2html(rsget("itemcouponexplain"))
			FOneItem.Fapplyitemcount	   = rsget("applyitemcount")
			FOneItem.Fopenstate          = rsget("openstate")
			FOneItem.Fmargintype           = rsget("margintype")
			FOneItem.Fregdate              = rsget("regdate")
			FOneItem.FRegUserid			= rsget("reguserid")

			FOneItem.Fitemcouponimage	= "http://imgstatic.10x10.co.kr/couponimg/" + FOneItem.Fitemcouponimage

			FOneItem.Fcurrdate			= rsget("currdate")
		end if
		rsget.close
	end sub

	public Sub GetItemCouponMasterList
		dim sqlStr,i
		sqlStr = " select count(*) as cnt "
		sqlStr = sqlStr + " from [db_item].[dbo].tbl_item_coupon_master"

		rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close


		sqlStr = "select top " + CStr(FPageSize*FCurrPage)
		sqlStr = sqlStr + " * from [db_item].[dbo].tbl_item_coupon_master"
		sqlStr = sqlStr + " order by itemcouponidx desc"

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CItemCouponMasterItem

				FItemList(i).Fitemcouponidx        = rsget("itemcouponidx")
				FItemList(i).Fitemcoupontype       = rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue      = rsget("itemcouponvalue")
				FItemList(i).Fitemcouponstartdate  = rsget("itemcouponstartdate")
				FItemList(i).Fitemcouponexpiredate = rsget("itemcouponexpiredate")
				FItemList(i).Fitemcouponname       = db2html(rsget("itemcouponname"))
				FItemList(i).Fitemcouponimage      = db2html(rsget("itemcouponimage"))
				FItemList(i).Fapplyitemcount	   = rsget("applyitemcount")
				FItemList(i).Fopenstate          = rsget("openstate")
				FItemList(i).Fmargintype           = rsget("margintype")
				FItemList(i).Fregdate              = rsget("regdate")
				FItemList(i).FRegUserid			= rsget("reguserid")

				FItemList(i).Fitemcouponimage	= "http://imgstatic.10x10.co.kr/couponimg/" + FItemList(i).Fitemcouponimage

				rsget.MoveNext
				i = i + 1
			loop
		end if
		rsget.close
	end Sub

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)
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
end Class



Sub fnPrntDispCateNaviV17CouponListCaChe(sDisp,sType,sCallback, ItemCouponIdx)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql
	Dim rsMem

	'// 카테고리 명 접수
	sName = "전체 카테고리"

	'// 카테고리 조회 범위 설정
	sDepth = 1

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	sType="F" ''고정

	'// 결과 출력
	sResult = 	"	<select class=""select"" title=""카테고리 선택옵션"" onchange=""" & sCallback & "(this.value);"">" & vbCrLf

		Select Case sType
			Case "F"
				'/// DB에서 전시카테고리 접수

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<option " & chkIIF(sDisp="","class=""selected""","") & " value="""">전체 카테고리</option>" & vbCrLf
				end if
		
				'전시카테고리 접수
				strSql = " exec db_item.[dbo].[usp_Ten_ItemCouponItem_CATE_List] "&CStr(ItemCouponIdx)&","&sDepth
				set rsMem = getDBCacheSQL(dbget,rsget,"CPNCATE",strSql,60*30)
				if  not rsMem.EOF  then
					do until rsMem.EOF
						if Left(Cstr(sDisp),3*sDepth) = Cstr(rsMem("catecode")) then
							sTmp = "selected=""selected"""
						end if
						sResult = sResult & "<option "&sTmp&" value=""" &rsMem("catecode") &""">"& db2html(rsMem("catename")) &"</option>"
						sTmp = ""
					rsMem.MoveNext
					loop
				end if
				rsMem.close
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</select>"' & vbCrLf &_	
'		"</div>"
	Response.Write sResult
End Sub

'// 2017 카테고리 선택 상자 _ BEST (sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명)
Sub fnPrntDispCateNaviV17CouponList(sDisp,sType,sCallback, ItemCouponIdx)
	Dim sName, sDepth, sResult, sTmp
	Dim strSql

	'// 카테고리 명 접수
	If sDisp = "" Then
		sName = "전체 카테고리"
	Else
		sName = getDisplayCateNameDB(sDisp)
	End If

	'// 카테고리 조회 범위 설정
	if sDisp="" then
		sDepth = 1
	else
		sDepth = cInt(len(sDisp)/3)
	end if

	'// 표시 형태 (F: 1뎁스 고정, E: 하위분류 확장, S:검색엔진)
	if sType="" then sType="F"
	if sType="E" and sDisp<>"" then sDepth = sDepth +1
	if sType="S" and sDisp<>"" then
		sDepth = sDepth +1
		if sDepth>3 then sDepth=3
	End if

	'// 결과 출력
	sResult = 	"	<select class=""select"" title=""카테고리 선택옵션"" onchange=""" & sCallback & "(this.value);"">" & vbCrLf

		Select Case sType
			Case "F","E"
				'/// DB에서 전시카테고리 접수

				'1Depth는 전체 항목 추가
				if sDepth=1 then
					sResult = sResult & "<option " & chkIIF(sDisp="","class=""selected""","") & " value="""">전체 카테고리</option>" & vbCrLf
				end if

				'최종뎁스 확인
				If sDepth > 1 Then
					strSql = " select count(catecode) as cnt from [db_item].[dbo].tbl_display_cate "
					strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
					rsget.Open strSql,dbget,1
					if rsget("cnt")=0 then
						sDepth = sDepth -1
					end if
					rsget.Close
				end if
		
				'전시카테고리 접수
				strSql = " select c.catecode, c.catename	"  & VbCRLF
				strSql = strSql & " 	from [db_item].[dbo].tbl_item_coupon_master as m	"  & VbCRLF
				strSql = strSql & " 	join [db_item].[dbo].tbl_item_coupon_detail as d	"  & VbCRLF
				strSql = strSql & " 		on m.itemcouponidx=d.itemcouponidx and m.itemcouponidx="+ CStr(ItemCouponIdx)  & VbCRLF
				strSql = strSql & " 	Join [db_item].[dbo].tbl_item i 	"  & VbCRLF
				strSql = strSql & " 		on d.itemid=i.itemid 	"  & VbCRLF
				strSql = strSql & " 	join [db_item].[dbo].tbl_display_cate as c	"  & VbCRLF
				strSql = strSql & " 		on c.catecode=i.dispcate1 	"  & VbCRLF
				strSql = strSql & " 	 where c.depth = 1 and c.useyn = 'Y' and  c.catecode<>123 	"  & VbCRLF
				If sDepth > 1 Then
					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "  & VbCRLF
				End If
				strSql = strSql & " 	 group by c.catecode, c.catename, c.sortno	"
'				strSql = strSql & " 	 order by c.sortno Asc	"

'				strSql = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
'				strSql = strSql & " where depth = '" & sDepth & "' and useyn = 'Y' and  catecode<>123 "
'				If sDepth > 1 Then
'					strSql = strSql & " and Left(catecode,"&(sDepth-1)*3&") = '" & Left(sDisp,(sDepth-1)*3) & "' "
'				End If
'				strSql = strSql & " order by sortno Asc"

				rsget.Open strSql,dbget,1
				if  not rsget.EOF  then
					do until rsget.EOF
						if Left(Cstr(sDisp),3*sDepth) = Cstr(rsget("catecode")) then
							sTmp = "selected=""selected"""
						end if
						sResult = sResult & "<option "&sTmp&" value=""" &rsget("catecode") &""">"& db2html(rsget("catename")) &"</option>"
						sTmp = ""
					rsget.MoveNext
					loop
				end if
				rsget.close
			Case "S"
				'/// Ajax 사용 (호출 페이지에서 처리: 여기선 내용없음)
		End Select
		sResult = sResult & "	</select>"' & vbCrLf &_	
'		"</div>"
	Response.Write sResult
End Sub

Function fnGetBigSaleItemCheck(itemid)
	Dim strSql
	strSql ="EXEC [db_item].[dbo].[usp_WWW_Event_BigSaleItemCouponCheck_Get] " & itemid & ""
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
	IF Not (rsget.EOF OR rsget.BOF) THEN
		fnGetBigSaleItemCheck = true
	else
		fnGetBigSaleItemCheck = false
	END IF
	rsget.close
End Function
%>
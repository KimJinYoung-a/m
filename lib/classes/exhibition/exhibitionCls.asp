<%
'// 상품
dim vIsTest
IF application("Svr_Info") = "Dev" THEN
	vIsTest = "test"
Else
	vIsTest = ""
End If		
Class ExhibitionItemsCls
    '// items
    public Fidx
    public Fgubun
    public Fcategory
    public Fitemid
    public Fpickitem
    public Fpicksorting
    public Fcategorysorting
	public Fitemname
	public FMakerid
	public Forgprice
	public Fsailprice
	public Fsailyn
	public Fitemcouponyn
	public Fitemcoupontype
	public Fsailsuplycash
	public Forgsuplycash
	public Fcouponbuyprice
	public FmwDiv
	public Fdeliverytype
	public Fsellcash
	public Fbuycash
    public Fitemcouponvalue
	public FsellYn
	public FbrandName
	public FtotalPoint
	public FevalCnt
	public FfavCnt
	public FTentenImg200
	public FTentenImg400
	public FAddtext1
	public FAddtext2
	public FSellDate
	public Foptioncode
	public Foptioncnt
	public FgiftCount

    '// groupcode
    public Fgidx
    public Fgubuncode
    public Fmastercode
    public Fdetailcode
    public Ftitle
    public Fisusing
	public Fcnt	

    '// common
    public Fregdate
    public Flastupdate
    public Fadminid
    public Flastadminid
	public FImageList
	public FPrdImage
	public FBasicimage
	public Fsorting

	public FLimitYn
	public FLimitNo
	public FLimitSold
	public FdefaultFreeBeasongLimit

	'// 쿠폰 할인 가격
	public function fnCouponDiscountPrice()
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
	end function

	'// 쿠폰 할인 문구
	public function fnCouponDiscountString()
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
	end function

	'// 세일 쿠폰 통합 할인 
	public function fnSaleAndCouponDiscountString()
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
	end function

	'// 최종가격 및 세일퍼센트 , 쿠폰퍼센트 , 합산퍼센트
	public function fnItemPriceInfos(byRef totalPrice , byRef salePercentString , byRef couponPercentString , byRef totalSalePercent)
		'// totalPrice
		totalPrice = formatNumber(Fsellcash - fnCouponDiscountPrice(),0)

		'// salePercentString
		salePercentString = CLng((Forgprice-Fsellcash)/FOrgPrice*100) & chkiif(CLng((Forgprice-Fsellcash)/FOrgPrice*100) > 0 , "%" , "")

		'// couponPercentString
		couponPercentString = fnCouponDiscountString() & chkiif(fnCouponDiscountString() > 0 , chkiif(Fitemcoupontype = 2 , "원" , "%") ,"")

		'// totalSalePercent
		totalSalePercent = fnSaleAndCouponDiscountString() & chkiif(fnSaleAndCouponDiscountString() > 0 , "%" , "")
	end function

	public Function IsSoldOut()
		'isSoldOut = (FSellYn="N")
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

End Class

'// 이벤트
Class ExhibitionEventsCls
	public Fidx
	public Fevt_name
	public Fevt_code
	public Fmastercode
	public Fdetailcode
	public Fisusing
	public Fevtsorting
	public Fevt_subcopy
	public Fsquareimage '// PC 정사각 이미지
	public Frectangleimage '// mobile 직사각 이미지
	public Fsaleper '// 할인가
	public Fsalecper '// 쿠폰 할인가
	public Fstartdate '// 시작일
	public Fenddate '// 종료일
	public Fevt_startdate '// 이벤트 시작일
	public Fevt_enddate '// 이벤트 종료일
	public Fregdate
	public Flastupdate
	public Fadminid
	public Flastadminid
	public Fisgift
	public Fissale
	public Fisoneplusone
	public Fitemname
	public Fetc_itemid
	public Fiscoupon

	public function IsEndDateExpired()
        IsEndDateExpired = Cdate(Left(now(),10))>Cdate(Left(Fenddate,10))
    end function
End Class

Class ExhibitionCls

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
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub
    
'페이징
public sub getItemsPageListProc()
	Dim sqlStr ,i , vari , vartmp, vOrderBy, tempDetailCode			

	if FrectDetailCode = "-1" then FrectDetailCode = ""

	sqlStr = " EXECUTE [db_event].[dbo].[usp_cm_exhibition_item_list_cnt_get] '"&FrectListType&"','"&FPageSize&"','"&FrectMasterCode&"','"&FrectDetailCode&"','"&Frectpick&"', '"&FrectSortMet&"' "		 		

	'response.write sqlStr & "<br>"
	'Response.end

	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,180)
	if (rsMem is Nothing) then Exit Sub ''추가
	
		FTotalCount = rsMem("Totalcnt")
		FTotalPage = rsMem("totPg")
	rsMem.Close

	'지정페이지가 전체 페이지보다 클 때 함수종료
	if Cint(FCurrPage)>Cint(FTotalPage) then
		FResultCount = 0
		exit sub
	end if

	If FTotalCount > 0 Then			

		sqlStr = " EXECUTE [db_event].[dbo].[usp_cm_exhibition_item_list_get] '"&FrectListType&"','"&Cstr(FPageSize * FCurrpage)&"','"&FrectMasterCode&"','"&FrectDetailCode&"','"&Frectpick&"', '"&FrectSortMet&"' "	 
		
		set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,180)
		if (rsMem is Nothing) then Exit Sub ''추가
		
		rsMem.pagesize = FPageSize

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1
		if  not rsMem.EOF  then
			rsMem.absolutePage=FCurrPage
			do until rsMem.eof
				set FItemList(i) = new ExhibitionItemsCls

				FItemList(i).Fidx 			= rsMem("idx")
				FItemList(i).Fgubun 		= rsMem("mastercode")
				FItemList(i).Fcategory 		= rsMem("detailcode")
				FItemList(i).Fitemid 		= rsMem("itemid")
				FItemList(i).FRegDate 		= rsMem("regdate")
				FItemList(i).FTentenImg200  = rsMem("tentenimage200")	
				FItemList(i).FTentenImg400  = rsMem("tentenimage400")	
				FItemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsMem("basicimage")			

				If Not(isNull(rsMem("tentenimage")) Or rsMem("tentenimage") = "") Then
					FItemList(i).FTentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsMem("tentenimage200")
					FItemList(i).FTentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsMem("tentenimage400")
				End If

				if ImageExists(FItemList(i).FTentenImg400) Then
					FItemList(i).FPrdImage		= FItemList(i).FTentenImg400
				ElseIf ImageExists(FItemList(i).FTentenImg200) Then
					FItemList(i).FPrdImage		= FItemList(i).FTentenImg200
				else					
					FItemList(i).FPrdImage		= FItemList(i).FBasicimage
				End If					
				FItemList(i).FImageList 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsMem("basicimage")													

				FItemList(i).Fitemname 		= db2html(rsMem("itemname"))
				FItemList(i).FMakerid 		= db2html(rsMem("makerid"))
				FItemList(i).Fpickitem 		= rsMem("pickitem")

				FItemList(i).Forgprice 		= rsMem("orgprice")
				FItemList(i).Fsailprice 	= rsMem("sailprice")
				FItemList(i).Fsailyn 		= rsMem("sailyn")
				FItemList(i).Fitemcouponyn  = rsMem("itemcouponyn")
				FItemList(i).Fitemcoupontype= rsMem("itemcoupontype")
				FItemList(i).Fsailsuplycash = rsMem("sailsuplycash")
				FItemList(i).Forgsuplycash 	= rsMem("orgsuplycash")
				FItemList(i).Fcouponbuyprice= rsMem("couponbuyprice")
				FItemList(i).FmwDiv 		= rsMem("mwDiv")
				FItemList(i).Fdeliverytype 	= rsMem("deliverytype")
				FItemList(i).Fsellcash 		= rsMem("sellcash")
				FItemList(i).Fbuycash 		= rsMem("buycash")
				FItemList(i).Fmastercode 	= rsMem("mastercode")
				FItemList(i).Fdetailcode 	= rsMem("detailcode")
				FItemList(i).Fitemcouponvalue = rsMem("itemcouponvalue")
				FItemList(i).FsellYn 		= rsMem("sellyn")
				FItemList(i).FbrandName 	= rsMem("brandname")					
				FItemList(i).FtotalPoint 	= rsMem("TotalPoint")					
				FItemList(i).FevalCnt 		= rsMem("evalcnt")					
				FItemList(i).FfavCnt 		= rsMem("favcount")	
				FItemList(i).FAddtext1 		= rsMem("addtext1")	
				FItemList(i).FAddtext2 		= rsMem("addtext2")									
				FItemList(i).Foptioncode 	= rsMem("optioncode")			
				FItemList(i).Foptioncnt 	= rsMem("optioncnt")

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close
	End If
end Sub

Public Function getItemsListProc(listtype, numOfItems, masterCode, DetailCode, isPickItem, categorySort)
	dim tmpSQL,i, itemList()

	tmpSQL = " exec [db_event].[dbo].[usp_cm_exhibition_item_list_get] '"&listtype&"', '"&numOfItems&"', '"&masterCode&"', '"&DetailCode&"', '"&isPickItem&"', '"&categorySort&"' "
		
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open tmpSQL, dbget,2

	redim preserve itemList(rsget.recordcount)

	If Not rsget.EOF Then
		do until rsget.EOF
			set itemList(i) = new ExhibitionItemsCls

			itemList(i).Fidx 			= rsget("idx")
			itemList(i).Fgubun 			= rsget("mastercode")
			itemList(i).Fcategory 		= rsget("detailcode")
			itemList(i).Fitemid 		= rsget("itemid")
			itemList(i).FRegDate 		= rsget("regdate")
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
			itemList(i).Fpickitem 		= rsget("pickitem")

			itemList(i).Forgprice 		= rsget("orgprice")
			itemList(i).Fsailprice 	= rsget("sailprice")
			itemList(i).Fsailyn 		= rsget("sailyn")
			itemList(i).Fitemcouponyn  = rsget("itemcouponyn")
			itemList(i).Fitemcoupontype= rsget("itemcoupontype")
			itemList(i).Fsailsuplycash = rsget("sailsuplycash")
			itemList(i).Forgsuplycash 	= rsget("orgsuplycash")
			itemList(i).Fcouponbuyprice= rsget("couponbuyprice")
			itemList(i).FmwDiv 		= rsget("mwDiv")
			itemList(i).Fdeliverytype 	= rsget("deliverytype")
			itemList(i).Fsellcash 		= rsget("sellcash")
			itemList(i).Fbuycash 		= rsget("buycash")
			itemList(i).Fmastercode 	= rsget("mastercode")
			ItemLIst(i).Fdetailcode 	= rsget("detailcode")
			ItemLIst(i).Fitemcouponvalue = rsget("itemcouponvalue")
			ItemLIst(i).Fpicksorting	= rsget("picksorting")
			ItemLIst(i).FsellYn = rsget("sellyn")
			ItemLIst(i).FbrandName = rsget("brandName")
			ItemLIst(i).FevalCnt = rsget("EVALCNT")
			ItemLIst(i).FfavCnt = rsget("favcount")	
			ItemLIst(i).FAddtext1 = rsget("addtext1")	
			ItemLIst(i).FAddtext2 = rsget("addtext2")
			if listtype = "C" then
				ItemLIst(i).FSellDate = rsget("selldate")
			end if

			ItemLIst(i).FtotalPoint = rsget("totalpoint")
			rsget.movenext
			i=i+1
		loop
		getItemsListProc = itemList
	ELSE		
		getItemsListProc = itemList
	End if
	rsget.close
End Function

Public Function getItemsNewListProc(listtype, numOfItems, masterCode, DetailCode, isPickItem, categorySort)
	dim tmpSQL,i, itemList()

	tmpSQL = " exec [db_event].[dbo].[usp_cm_exhibition_item_newlist_get] '"&listtype&"', '"&numOfItems&"', '"&masterCode&"', '"&DetailCode&"', '"&isPickItem&"', '"&categorySort&"' "
		
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open tmpSQL, dbget,2

	redim preserve itemList(rsget.recordcount)

	If Not rsget.EOF Then
		do until rsget.EOF
			set itemList(i) = new ExhibitionItemsCls

			itemList(i).Fidx 			= rsget("idx")
			itemList(i).Fgubun 			= rsget("mastercode")
			itemList(i).Fcategory 		= rsget("detailcode")
			itemList(i).Fitemid 		= rsget("itemid")
			itemList(i).FRegDate 		= rsget("regdate")
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
			itemList(i).Fpickitem 		= rsget("pickitem")

			itemList(i).Forgprice 		= rsget("orgprice")
			itemList(i).Fsailprice 	= rsget("sailprice")
			itemList(i).Fsailyn 		= rsget("sailyn")
			itemList(i).Fitemcouponyn  = rsget("itemcouponyn")
			itemList(i).Fitemcoupontype= rsget("itemcoupontype")
			itemList(i).Fsailsuplycash = rsget("sailsuplycash")
			itemList(i).Forgsuplycash 	= rsget("orgsuplycash")
			itemList(i).Fcouponbuyprice= rsget("couponbuyprice")
			itemList(i).FmwDiv 		= rsget("mwDiv")
			itemList(i).Fdeliverytype 	= rsget("deliverytype")
			itemList(i).Fsellcash 		= rsget("sellcash")
			itemList(i).Fbuycash 		= rsget("buycash")
			itemList(i).Fmastercode 	= rsget("mastercode")
			ItemLIst(i).Fdetailcode 	= rsget("detailcode")
			ItemLIst(i).Fitemcouponvalue = rsget("itemcouponvalue")
			ItemLIst(i).Fpicksorting	= rsget("picksorting")
			ItemLIst(i).FsellYn = rsget("sellyn")
			ItemLIst(i).FbrandName = rsget("brandName")
			ItemLIst(i).FevalCnt = rsget("EVALCNT")
			ItemLIst(i).FfavCnt = rsget("favcount")	
			ItemLIst(i).FAddtext1 = rsget("addtext1")	
			ItemLIst(i).FAddtext2 = rsget("addtext2")
			if listtype = "C" then
				ItemLIst(i).FSellDate = rsget("selldate")
			end if

			ItemLIst(i).FtotalPoint = rsget("totalpoint")
			ItemLIst(i).FLimitYn = rsget("limityn")
			ItemLIst(i).FLimitNo = rsget("limitno")
			ItemLIst(i).FLimitSold = rsget("limitsold")
			ItemLIst(i).FdefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")

			rsget.movenext
			i=i+1
		loop
		getItemsNewListProc = itemList
	ELSE		
		getItemsNewListProc = itemList
	End if
	rsget.close
End Function

Public Function getEventListProc(listtype, numOfItems, masterCode, DetailCode)
	dim tmpSQL,i, eventList()

	tmpSQL = " exec [db_event].[dbo].[usp_cm_exhibition_event_list_get] '"&listtype&"', '"&numOfItems&"', '"&masterCode&"', '"&DetailCode&"' "
		
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open tmpSQL, dbget,2

	redim preserve eventList(rsget.recordcount)

	If Not rsget.EOF Then
		do until rsget.EOF
			set eventList(i) = new ExhibitionEventsCls

			eventList(i).Fidx			= rsget("idx")
			eventList(i).Fevt_code		= rsget("evt_code")
			eventList(i).Fevt_name		= db2html(rsget("evt_name"))
			eventList(i).Fevt_subcopy	= db2html(rsget("evt_subcopyk")) 
			eventList(i).Fsquareimage	= rsget("squareimage")
			eventList(i).Frectangleimage= rsget("rectangleimage")
			eventList(i).Fsaleper		= rsget("saleper")
			eventList(i).Fsalecper		= rsget("salecper")
			eventList(i).Fstartdate		= rsget("startdate")
			eventList(i).Fenddate		= rsget("enddate")
			eventList(i).Fevt_startdate	= rsget("evt_startdate")
			eventList(i).Fevt_enddate	= rsget("evt_enddate")
			eventList(i).Fevtsorting 	= rsget("evtsorting")
			eventList(i).Fisusing	 	= rsget("isusing")
			eventList(i).Fisgift	 	= rsget("isgift")
			eventList(i).Fissale	 	= rsget("issale")
			eventList(i).Fisoneplusone 	= rsget("isoneplusone")
			eventList(i).Fiscoupon 		= rsget("iscoupon")

			if listtype = "B" then
				eventList(i).Fetc_itemid	= rsget("etc_itemid")
				eventList(i).Fitemname	 	= rsget("itemname")
			else
				eventList(i).Fetc_itemid	 	= ""
				eventList(i).Fitemname	 	= ""
			end if

			rsget.movenext
			i=i+1
		loop
		getEventListProc = eventList
	ELSE
		getEventListProc = ""
	End if
	rsget.close
End Function

'// 스와이퍼 리스트 
public function getSwiperListProc(masterCode , channel , usetype)
	dim sqlStr , i , swiperList()

	sqlStr = "EXEC [db_event].[dbo].[usp_cm_exhibition_swiper_list_get] "& masterCode &" , '"& channel &"' , '"& usetype &"'"
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
	IF Not (rsget.EOF OR rsget.BOF) THEN
		getSwiperListProc = rsget.GetRows()
	END IF
	rsget.close
end function 

'// 스와이퍼 리스트2 (다이어리)
public function getSwiperListProc2(masterCode , channel , usetype)
	dim sqlStr , i , swiperList()

	sqlStr = "EXEC [db_event].[dbo].[usp_cm_exhibition_swiper_list_get2] "& masterCode &" , '"& channel &"' , '"& usetype &"'"
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
	IF Not (rsget.EOF OR rsget.BOF) THEN
		getSwiperListProc2 = rsget.GetRows()
	END IF
	rsget.close
end function 

'// 스와이퍼 리스트2021 (다이어리)
public function getSwiperListProc3(masterCode , channel , usetype)
	dim sqlStr , i , swiperList()

	sqlStr = "EXEC [db_event].[dbo].[usp_cm_exhibition_swiper_list_get2021] "& masterCode &" , '"& channel &"' , '"& usetype &"'"
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
	IF Not (rsget.EOF OR rsget.BOF) THEN
		getSwiperListProc3 = rsget.GetRows()
	END IF
	rsget.close
end function 

Public Function getDetailGroupList(masterCode)
	dim tmpSQL,i, detailGroupList()	

	tmpSQL = " SELECT DETAILCODE	"
	tmpSQL = tmpSQL & "     , TITLE	"
	tmpSQL = tmpSQL & "  FROM db_event.dbo.tbl_exhibition_groupcode	"
	tmpSQL = tmpSQL & " WHERE detailcode IN (	"
	tmpSQL = tmpSQL & "	select a.detailcode	 	"
	tmpSQL = tmpSQL & "	  from db_event.dbo.tbl_exhibition_items as a	"
	tmpSQL = tmpSQL & "	 where mastercode = '" & mastercode& "'	"
	tmpSQL = tmpSQL & "	 group by detailcode 	"
	tmpSQL = tmpSQL & " )	"
	tmpSQL = tmpSQL & "   AND mastercode = '"& mastercode &"'	"
	tmpSQL = tmpSQL & "   AND gubuncode = 2	"
	tmpSQL = tmpSQL & "   AND ISUSING = 1	"
	tmpSQL = tmpSQL & "   ORDER BY DETAILCODE ASC	"
	
	
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open tmpSQL, dbget,2

	redim preserve detailGroupList(rsget.recordcount)

	If Not rsget.EOF Then
		do until rsget.EOF
			set detailGroupList(i) = new ExhibitionItemsCls

			detailGroupList(i).Fdetailcode	= rsget("detailcode")			
			detailGroupList(i).Ftitle		= rsget("title")

			rsget.movenext
			i=i+1
		loop
		getDetailGroupList = detailGroupList
	ELSE
		getDetailGroupList = detailGroupList
	End if
	rsget.close
End Function

public Function GetCouponDiscountPrice(couponType, itemcouponvalue, price) '?
	Select case couponType
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(itemcouponvalue*price/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = itemcouponvalue
		case "3" ''무료배송 쿠폰
			GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
end Function

public function GetCouponDiscountStr(couponType, itemcouponvalue) '!
	Select Case couponType
		Case "1"
			GetCouponDiscountStr =CStr(itemcouponvalue) + "%"
		Case "2"
			GetCouponDiscountStr =CStr(itemcouponvalue) + "원"
		Case "3"
			GetCouponDiscountStr ="무료배송"
		Case Else
			GetCouponDiscountStr = couponType
	End Select
end function

End Class

function fnEvalTotalPointAVG(t,g)
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

function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function

function getEvaluations(pItemId, numOfEval)

	if pItemId = "" or numOfEval = "" then
		exit function
	end if

	dim SqlStr 

	sqlStr = ""
	sqlStr = sqlStr & "SELECT TOP "& numOfEval &" userid, contents		"
	sqlStr = sqlStr & "  FROM [db_board].DBO.tbl_Item_Evaluate		"
	sqlStr = sqlStr & " WHERE 1 = 1		"
	sqlStr = sqlStr & "   AND ISUSING = 'Y'		"
	sqlStr = sqlStr & "   AND ITEMID = '"& pItemId &"'		"
	SqlStr = sqlStr & " ORDER BY IDX DESC		"

'       response.write sqlStr &"<br>"
'       response.end
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getEvaluations = rsget.getRows()    
	end if
	rsget.close         
End function


public function getExistsGiftItems(arrItemIds)
	dim itemList()
	if arrItemIds = "" then
		exit function
	end if 

	dim srt, lp , strSort
	for each srt in split(arrItemIds,",")
		lp = lp +1
		strSort = strSort & "WHEN I.ITEMID = " & srt & " THEN " & lp & " "
	next

	dim sqlStr
	sqlStr = "SELECT I.ITEMID , (G.GIFTKIND_LIMIT - G.GIFTKIND_GIVECNT) AS GIFTCOUNT " & vbCrLf
	sqlStr = sqlStr & "FROM DB_EVENT.DBO.TBL_GIFT AS G WITH(NOLOCK) " & vbCrLf
	sqlStr = sqlStr & "INNER JOIN DB_EVENT.DBO.TBL_EVENTITEM AS I WITH(NOLOCK) " & vbCrLf
	sqlStr = sqlStr & "ON G.EVT_CODE = I.EVT_CODE " & vbCrLf
	sqlStr = sqlStr & "WHERE CONVERT(VARCHAR(10),GETDATE(),121) BETWEEN G.GIFT_STARTDATE AND G.GIFT_ENDDATE " & vbCrLf
	sqlStr = sqlStr & "AND G.GIFTKIND_LIMIT <> '0' " & vbCrLf
	sqlStr = sqlStr & "AND G.GIFTKIND_LIMIT <> G.GIFTKIND_GIVECNT " & vbCrLf
	sqlStr = sqlStr & "AND G.GIFT_USING = 'Y' " & vbCrLf
	sqlStr = sqlStr & "AND G.GIFT_STATUS = 7 " & vbCrLf
	sqlStr = sqlStr & "AND I.ITEMID IN (" & arrItemIds & ") " & vbCrLf
	sqlStr = sqlStr & "ORDER BY CASE " & strSort & " END " 

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

	redim preserve itemList(rsget.recordcount)

	if not rsget.EOF then
		do until rsget.EOF
			set itemList(i) = new ExhibitionItemsCls
				itemList(i).Fitemid 	= rsget("ITEMID")
				itemList(i).FgiftCount	= rsget("GIFTCOUNT")
			rsget.movenext
			i=i+1
		loop
		getExistsGiftItems = itemList
	else 
		getExistsGiftItems = null
	end if
	rsget.close
end function


function getGiftBedge(arrlist , itemid)
	dim i

	if isarray(arrlist) then
		for i = 0 to Ubound(arrlist)
			if arrlist(0,i) = itemid then
				response.write "<i class=""badge_gift"">선물</i>"
			end if 
		next
	end if 
end function
%>
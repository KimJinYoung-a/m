<%
'####################################################
' Description : 다이어리스토리 클래스
' History : 2014-10-13 한용민 www 이전/생성
'####################################################
%>
<%
Class CstationeryStoreitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	public fplustype
	public fbasicimage
	public fevt_mo_listbanner
	public fevent_start
	public fevent_end
	public fevent_link
	public fidx
	public fimagepath
	public flinkpath
	public fevt_code
	public fregdate
	public fimagecount
	public fimage_order
	public Fposcode
	public fposname
	public fimagewidth
	public fimageheight
	public fitemid
	public fitemname
	public fOrgPrice
	public fsellcash
	public fcdl
	public fcdm
	public fcds
	public FMakerId
	public FBrandName
	public FImageList
	public FImageList120
	public FImageSmall
	public FImageicon1
	public FImageicon2
	public FListImage
	public FImageBasic
	public FevalImg1
	public FSellyn
	public FLimityn
	public FSaleyn
	public FReipgodate
	public FItemcouponyn
	public FItemcouponvalue
	public FItemcoupontype
	public FEvalcnt
	public Ffavcount
	public FItemScore
	public FSpecialUserItem
	public fitemid_count
	public fisusing
	public finfo_idx
	public finfo_gubun
	public finfo_img
	public finfo_PageCnt
	public ftype
	public finfo_name
	public foption_value
	public FDeliverytype
	public fdiaryid
	public fevt_enddate
	public fevt_kind
	public fbrand
	public fevt_startdate
	public fevt_bannerimg
	public FEvt_subcopyK
	public FEvt_subname
	public fidx_order
	public fevent_type
	public FEvt_name
	public FCurrRank
	public FLastRank
	public forganizerID
	public FCurrPos
	public fitemtype
	public fuserid
	public fcontents
	public fregdate_eval
	public fbasicimg
	public fevt_linkType
	public fevt_bannerlink
	public FCateName
	public FEventOX
	public FCate
	public FEvttype
	public fissale
	public fisgift
	public fiscoupon
	public fiscomment
	public fisbbs
	public fisitemps
	public fisapply
	public fisOnlyTen
	public fisoneplusone
	public fisfreedelivery
	public fisbookingsell
	public fusedate
	public fetc
	public fcolor
	public FDiaryBasicImg
	public FDiaryBasicImg2
	public FDiaryBasicImg3
	public FLimitNo
	public FLimitSold
	public Fsolar_date
	public FMomentDate
	public Fholiday
	public Fweek
	public Fbirth
	public Flove
	public Fcong
	public Fthanks
	public Fmemory
	public Ffighting
	public Fsomeday
	public FMomentType
	public FItemDiv
	public FNanumImg
	public FTotal
	public FNewitem
	public FGiftSu
	public FImage1
	public FImage2
	Public Fsailyn
	Public Fsailprice
	Public Fimageend
	Public Fendlink
	Public Fexplain
	Public Fdiarytotcnt
	Public FdiaryCount1
	Public FdiaryCount2
	Public FdiaryCount3
	Public FdiaryCount4
	Public FdiaryCount5
	Public FStoryImg
	Public Fsocname
	Public Fsocname_kor
	Public Flist_mainimg
	Public Flist_titleimg
	Public Flist_text
	Public Flist_spareimg
	Public Fcontent_title
	Public Fcontent_html
	Public Fsorting
	Public Ffavsum
	Public Fhitrank
	public fimagetype
	public fimage3
	public fimage2_path
	public fimage3_path
	public fimage2_link
	public fimage3_link
	Public FpreviewImg
	Public FKeyword_Form
	Public FKeyword_Color
	
	public FPojangOk
	public FPoints

	Public Ficon1image
	Public Ficon2image
	Public FSalePrice
	Public Freviewcnt
	Public FCurrItemCouponIdx
	Public FOptionCount	
	
	''150924 모바일메인배너이미지,리미티드 유태욱
	public Fmimage1
	public Flimited

	'2017 다이어리스페셜
	Public Fpcmainimage
	Public Fpcoverimage
	Public Fpctext
	Public Fmomileimage
	Public Fmobiletext
	Public Flinkgubun
	Public Flinkcode
	Public Fsortnum
	Public Fdetailidx
	Public Fitemordernum
	Public Fdetailitemimage

	'2019 다이어리 추가
	public FItemSize
	public Fselldate
	public FmdpickYN
	public FNewYN
	public Feventid

	'// 어워드 랭크 처리 /organizer/organzier_award.asp
	public function GetLevelUpCount()
		if (FCurrRank<FLastRank) then
			GetLevelUpCount = CStr(FLastRank-FCurrRank)
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpCount = ""
		elseif (FCurrRank=FLastRank) then
			GetLevelUpCount = ""
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpCount = ""
		else
			GetLevelUpCount = CStr(FCurrRank-FLastRank)
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpCount = ""
			end if
		end if
	end function

	'// 어워드 랭크 이미지 처리 /organizer/organzier_award.asp
	public function GetLevelUpArrow()
		if (FCurrRank<FLastRank) then
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_up.gif' width=7 height=4>"
		elseif (FCurrRank=FLastRank) then
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_none.gif' width=6 height=2>"
		else
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_down.gif' width='7' height='4'>"
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_none.gif' width=6 height=2>"
			end if
		end if
	end function

	'// 할인율 '!
	public Function getSalePro()
		if FOrgprice=0 then
			getSalePro = 0 & "%"
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"
		end if
	end Function

	'// 무료 배송 여부 '?
	public Function IsFreeBeasong()
		if (getRealPrice()>=getFreeBeasongLimitByUserLevel()) then
			IsFreeBeasong = true
		else
			IsFreeBeasong = false
		end if

		if (FDeliverytype="2") or (FDeliverytype="4") or (FDeliverytype="5") then
			IsFreeBeasong = true
		end if

		''//착불 배송은 무료배송이 아님
		if (FDeliverytype="7") then
		    IsFreeBeasong = false
		end if
	end Function

	'// 무료 배송 쿠폰 여부 '?
	public function IsFreeBeasongCoupon()
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function

	' 사용자 등급별 무료 배송 가격  '?
	public Function getFreeBeasongLimitByUserLevel()
		dim ulevel

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

	'// 상품 쿠폰 내용
	public function GetCouponDiscountStr() '!
		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
			Case "2"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "원"
			Case "3"
				GetCouponDiscountStr ="무료배송"
			Case Else
				GetCouponDiscountStr = Fitemcoupontype
		End Select
	end function

	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (IsCouponItem) then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function

	'// 쿠폰 할인가
	public Function GetCouponDiscountPrice() '?
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				GetCouponDiscountPrice = CLng(Fitemcouponvalue*getRealPrice/100)
			case "2" ''원 쿠폰
				GetCouponDiscountPrice = Fitemcouponvalue
			case "3" ''무료배송 쿠폰
			    GetCouponDiscountPrice = 0
			case else
				GetCouponDiscountPrice = 0
		end Select
	end Function

	'// 원 판매 가격
	public Function getOrgPrice() '!
		if FOrgPrice=0 then
			getOrgPrice = FSellCash
		else
			getOrgPrice = FOrgPrice
		end if
	end Function

	'// 세일포함 실제가격
	public Function getRealPrice() '!
		getRealPrice = FSellCash

		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function

	'// 우수회원샵 상품 여부
	public Function IsSpecialUserItem() '!
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

 	public Function IsSaleItem() '!
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

 	'// 상품 쿠폰 여부
	public Function IsCouponItem() '!
			IsCouponItem = (FItemCouponYN = "Y")
	end Function

    public function GetImageUrl()
        if (IsNULL(fimagepath) or (fimagepath = "")) then
            GetImageUrl = ""
        else
			IF application("Svr_Info") = "Dev" THEN
				GetImageUrl = "http://testimgstatic.10x10.co.kr/diary/main/" & fimagepath
			Else
				GetImageUrl = "http://imgstatic.10x10.co.kr/diary/main/" & fimagepath
			End If
        end if
    end function

	public Function IsSoldOut()
		'isSoldOut = (FSellYn="N")
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

	'//	한정 여부 '!
	public Function IsLimitItem()
			IsLimitItem= (FLimitYn="Y")
	end Function

	'// 신상품 여부 '!
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 재입고 상품 여부
	public Function isReipgoItem()
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function

	'//일시품절 여부 '2008/07/07 추가 '!
	public Function isTempSoldOut()
		isTempSoldOut = (FSellYn="S")
	end Function

	'// 마일리지샵 아이템 여부 '!
	public Function IsMileShopitem()
		IsMileShopitem = (FItemDiv="82")
	end Function

	'// 텐바이텐 포장가능 상품 여부
	public Function IsPojangitem()
		IsPojangitem = (FPojangOk="Y")
	end Function

	'// 판매완료상품 시간
	public function Gettimeset()
		dim MyDate, dtDiff
			MyDate = now()
			dtDiff = DateDiff("s", Fselldate, MyDate)
			if dtDiff < 60 then
				response.write "조금전"
			elseif(dtDiff < 3600) then
				dtDiff= dtDiff/60
				response.write int(dtDiff)&"분전"
			elseif(dtDiff < 86400)  then
				dtDiff= dtDiff/3600
				response.write int(dtDiff)&"시간전"
			elseif(dtDiff < 2419200)  then
				dtDiff= dtDiff/86400
				response.write int(dtDiff)&"일전"
			else
				response.write "오래전"
			end if
	end function
end class

class CstationeryStore
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FOneItem
	public FRectOnlySellY
	public FRectCD1
	public FRectCD2
	public FRectCD3
	public FRectMakerid
	public FRectIdx
	public frecttop
	public fSellScope
	public frectcate
	public frectSortMtd
	public frecttype
	public frectkeyword
	public frectcontents
	public frectdesign
	public ftectSortMet
	public frectatype
	public frecttoplimit
	public FRectPoscode
	public frectitemid
	public FWhereMtd
	public FResultCountTop3
	public FCate
	public FGroupCode
	public FGubun
	public fcolor
	public fmdpick
	public FEvttype
	public FSCateMid
	public FSCategory
	public FSCType
	public FEScope
	public FselOp
	public FItemID
	public FStoryImage
	public FSoonSeo
	public FDiaryID
	public FRectDate
	public Fmomentdate
	public Fmomenttype
	public FUserID
	public FGiftSu
	public Fbestgubun
	Public FKeyword_Form
	Public FKeyword_Color
	Public FInfo_name
	public FMakerId
	Public Fbrandview
	Public Fidx
	Public frectlimited

	Public Fisweb
	Public Fismobile
	Public Fisapp
	public Ftopcount
	Public FRectRankingDate

	Private Sub Class_Initialize()
		FCurrPage = 1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'// 방금 판매된 문방구 상품 top 12
	public function getNowSellingItems()
		dim sqlStr , i, sellItemList()
		sqlStr = "exec [db_sitemaster].[dbo].[usp_WWW_sell_StationeryStoreitems_count]"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not (rsget.EOF OR rsget.BOF) THEN
			FResultCount = rsget("cnt")
		END IF
		rsget.close

		IF FResultCount > 0 Then
			if FResultCount > 12 then FResultCount = 12 
			
			sqlStr = "exec [db_sitemaster].[dbo].[usp_WWW_sell_StationeryStoreitems_List]"
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

			i=0

			redim preserve sellItemList(FResultCount)
			if  not rsget.EOF  then
				do until rsget.eof
					set sellItemList(i) = new CstationeryStoreitem
						sellItemList(i).Fitemid			= rsget("itemid")
						sellItemList(i).FSellYn			= rsget("sellyn")
						sellItemList(i).FSaleYn     		= rsget("sailyn")
						sellItemList(i).FRegdate 			= rsget("regdate")
						sellItemList(i).Fevalcnt 			= rsget("evalCnt")
						sellItemList(i).Fitemdiv			= rsget("itemdiv")
						sellItemList(i).FLimitYn			= rsget("limityn")
						sellItemList(i).FLimitNo			= rsget("limitno")
						sellItemList(i).Fmakerid			= rsget("makerid")
						sellItemList(i).FSellcash			= rsget("sellcash")
						sellItemList(i).FOrgPrice			= rsget("orgprice")
						sellItemList(i).FitemScore 		= rsget("itemScore")
						sellItemList(i).FLimitSold			= rsget("limitsold")
						sellItemList(i).Fitemcouponyn 		= rsget("itemcouponYn")
						sellItemList(i).Fitemcoupontype	= rsget("itemCouponType")
						sellItemList(i).Fselldate			= rsget("selldate")
						sellItemList(i).FItemCouponValue	= rsget("itemCouponValue")
						sellItemList(i).FItemName			= db2html(rsget("itemname"))
						sellItemList(i).FBrandName  		= db2html(rsget("brandname"))
						sellItemList(i).FImageList			= "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage")
						sellItemList(i).FImageList120		= "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage120")
						sellItemList(i).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("smallImage")
						sellItemList(i).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon1image")
						sellItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
						sellItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
					i=i+1
					rsget.moveNext
				loop
                getNowSellingItems = sellItemList
            else
                getNowSellingItems = sellItemList
			end if
			rsget.Close
		end if 
	End function

	public Sub getAwardBest()
		Dim sqlStr ,i , vari , vartmp, vOrderBy

		If ftectSortMet = "newitem" Then
			vOrderBy = " ORDER BY d.idx DESC"
		ElseIf ftectSortMet = "best" Then
			vOrderBy = " ORDER BY i.itemScore DESC"
		ElseIf ftectSortMet = "min" Then
			vOrderBy = " ORDER BY i.sellcash ASC"
		ElseIf ftectSortMet = "hi" Then
			vOrderBy = " ORDER BY i.sellcash DESC"
		ElseIf ftectSortMet = "hs" Then
			vOrderBy = " ORDER BY i.orgprice-i.sellcash DESC"
		ElseIf ftectSortMet = "eval" Then
			vOrderBy = " ORDER BY i.evalcnt DESC"
		ElseIf ftectSortMet = "dbest" Then
			vOrderBy = " ORDER BY b.currrank asc, i.itemid DESC"			
		Else
			vOrderBy = " ORDER BY d.picksorting asc"
		End If

		sqlStr = " EXECUTE [db_sitemaster].[dbo].[usp_WWW_StationeryStore_Award_List] '" & Cstr(FPageSize * FCurrPage) & "', '" & vOrderBy & "', '"& fuserid &"', '"& Fbestgubun &"'"

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"SSAW",sqlStr,30)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		rsMem.pagesize = FPageSize
		
		FTotalCount = rsMem.recordcount
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
				set FItemList(i) = new CstationeryStoreitem

					FItemList(i).FItemid			= rsMem("Itemid")
					FItemList(i).FDiaryBasicImg2	= getThumbImgFromURL(webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("itembasicimg"),"270","270","true","false")
					FItemList(i).FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("icon1image")
					FItemList(i).FItemName			= db2html(rsMem("ItemName"))
					FItemList(i).FSellCash			= rsMem("SellCash")
					FItemList(i).FOrgPrice			= rsMem("OrgPrice")
					FItemList(i).FMakerId			= rsMem("MakerId")
					FItemList(i).FBrandName			= db2html(rsMem("BrandName"))
					FItemList(i).FSellyn			= rsMem("sellYn")
					FItemList(i).FSaleyn			= rsMem("SaleYn")
					FItemList(i).FLimityn			= rsMem("LimitYn")
					FItemList(i).FLimitNo			= rsMem("LimitNo")
					FItemList(i).FLimitSold			= rsMem("LimitSold")
					FItemList(i).FDeliverytype		= rsMem("deliveryType")
					FItemList(i).FItemcouponyn		= rsMem("itemcouponYn")
					FItemList(i).FItemcouponvalue	= rsMem("itemCouponValue")
					FItemList(i).FItemcoupontype	= rsMem("itemCouponType")
					FItemList(i).FEvalcnt			= rsMem("evalCnt")
					FItemList(i).Ffavcount			= rsMem("favcount")
					FItemList(i).FItemDiv			= rsMem("itemdiv")
					FItemList(i).FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("icon2image")
					FItemList(i).Fsocname		= rsMem("socname")
					If fuserid <> "" then
						FItemList(i).Fuserid			= rsMem("userid")
					End If
				i=i+1
				rsMem.moveNext
			loop
		end if
		rsMem.Close
	end Sub

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
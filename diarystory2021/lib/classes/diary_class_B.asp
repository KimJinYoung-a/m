<%
'####################################################
' Description : 다이어리스토리 클래스
' History : 2014-10-13 한용민 www 이전/생성
'####################################################
%>
<%
Class cdiary_oneitem
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

	'2020 다이어리 추가
	public FSalePer
	public FSaleCPer

    '2021 다이어리 추가
    public FGiftCnt

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

	'///////////////////////////////////////////////////////////////////////////////////////////////
	' 할인 모듈 
	'///////////////////////////////////////////////////////////////////////////////////////////////
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
	'///////////////////////////////////////////////////////////////////////////////////////////////
	' 할인 모듈 
	'///////////////////////////////////////////////////////////////////////////////////////////////
end class

class cdiary_list
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
	Public FExcCode

	Private Sub Class_Initialize()
		FCurrPage = 1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'### 2015 다이어리 Diary award best, wish (2014-10-10 유태욱)
	'//diarystory2015/inc/inc_best.asp
	public Sub getDiaryAwardBest()
		Dim sqlStr ,i , vari , vartmp, vOrderBy

		If ftectSortMet = "newitem" Then
			vOrderBy = " ORDER BY d.diaryID DESC"
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
			If fmdpick = "o" Then
				vOrderBy = " ORDER BY d.mdpicksort asc, d.diaryID DESC"
			Else
				vOrderBy = " ORDER BY d.diaryID DESC"
			End IF
		End If

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_award_list_2015] '" & Cstr(FPageSize * FCurrPage) & "', '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', '" & vOrderBy & "', '"& fuserid &"', '"& Fbestgubun &"'   "

		'response.write sqlStr &"<br/>"

		'rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic		
		'rsget.Open sqlStr, dbget

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIAW",sqlStr,30)
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
				set FItemList(i) = new cdiary_oneitem

					FItemList(i).fdiaryid			= rsMem("diaryid")
					FItemList(i).FCateName 			= rsMem("Cate")
					FItemList(i).FItemid			= rsMem("Itemid")
					FItemList(i).FDiaryBasicImg		= webImgUrl & "/diary_collection/2012/basic/" & rsMem("BasicImg")
					FItemList(i).FDiaryBasicImg2	= rsMem("BasicImg2")
					if FItemList(i).FDiaryBasicImg2="" or isNull(FItemList(i).FDiaryBasicImg2) then
						FItemList(i).FDiaryBasicImg2	= getThumbImgFromURL(webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("itembasicimg"),"270","270","true","false")
					else
						FItemList(i).FDiaryBasicImg2	= getThumbImgFromURL(webImgUrl & "/diary_collection/2012/basic2/" & rsMem("BasicImg2"),"270","270","true","false")
					end if
					FItemList(i).FDiaryBasicImg3	= webImgUrl & "/diary_collection/2012/basic3/" & rsMem("BasicImg3")
					FItemList(i).FStoryImg		= webImgUrl & "/diary_collection/2012/story/" & rsMem("StoryImg")
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

	'//엠디픽
    public Sub getDiaryMdpick()
        dim sqlStr, i

        sqlStr = "SELECT TOP 6 " +vbcrlf
        sqlStr = sqlStr & " 	d.itemid, i.itemname, i.listImage, i.listImage120, i.icon1Image, i.sellcash, d.BasicImg, d.BasicImg2, d.BasicImg3, " +vbcrlf
        sqlStr = sqlStr & " 	i.orgprice, i.sailyn, i.regdate, i.itemcouponyn, i.limityn, i.itemcouponvalue, i.itemcoupontype " +vbcrlf
		sqlStr = sqlStr & " FROM [db_diary2010].[dbo].[tbl_DiaryMaster] AS d " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_item].[dbo].[tbl_item] AS i ON d.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & " WHERE d.mdpick = 'o' AND d.isUsing = 'Y' ORDER BY d.mdpicksort asc, d.diaryID DESC " +vbcrlf

		'response.write sqlStr
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIAMD",sqlStr,30)
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
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).Fitemid       = rsMem("itemid")
				FItemList(i).FitemName   = db2html(rsMem("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listImage")
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listImage120")
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("icon1Image")
				FItemList(i).FDiaryBasicImg		= webImgUrl & "/diary_collection/2012/basic/" & rsMem("BasicImg")
				FItemList(i).FDiaryBasicImg2	= webImgUrl & "/diary_collection/2012/basic2/" & rsMem("BasicImg2")
				FItemList(i).FDiaryBasicImg3	= webImgUrl & "/diary_collection/2012/basic3/" & rsMem("BasicImg3")
				FItemList(i).FOrgprice = rsMem("orgprice")
				FItemList(i).FSaleyn = rsMem("sailyn")
				FItemList(i).FSellCash = rsMem("sellcash")

				FItemList(i).Fitemcouponyn = rsMem("itemcouponyn")
				FItemList(i).Fitemcouponvalue = rsMem("itemcouponvalue")
				FItemList(i).Fitemcoupontype = rsMem("itemcoupontype")
				FItemList(i).Flimityn = rsMem("limityn")

				if datediff("d",rsMem("regdate"),Now()) < 14 then
					FItemList(i).FNewitem = "Y"
				else
					FItemList(i).FNewitem = "N"
				end if

				if IsNULL(FItemList(i).FImageList120) then  FItemList(i).FImageList120 = ""

				i=i+1
				rsMem.moveNext
			loop
		end if
		rsMem.Close
    end Sub



 	'//사은품 증정 여부		'/diarystory2015/index.asp
	Public Function getGiftDiaryExists(itemid)
		dim tmpSQL,i, blnTF

		tmpSQL = "Execute [db_item].[dbo].[sp_Ten_GiftDiaryExists] @vItemid = " & itemid

		'response.write tmpSQL & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open tmpSQL, dbget,2

		If Not rsget.EOF Then
			blnTF 	= true
			FGiftSu = rsget("giftsu")
			getGiftDiaryExists = FGiftSu
		ELSE
			blnTF 	= false
			getGiftDiaryExists = blnTF
		End if
		rsget.close
	End Function

	'/diarystory2015/index.asp	'평일,주말 일반 배너
	Public Sub getOneDailynot()
		dim sqlStr,i

		sqlStr = "SELECT top "& Ftopcount & +vbcrlf
		sqlStr = sqlStr & " t.itemid, t.linkpath, t.imagepath"
		sqlStr = sqlStr & " ,i.itemdiv, i.evalCnt, i.itemscore, i.LimitYn, i.DeliveryType, i.brandName, i.makerid, i.limitno"
		sqlStr = sqlStr & " , i.limitsold, i.itemname, i.SailYn as SaleYn, i.orgprice, i.sailprice,i.basicimage, i.icon1image"
		sqlStr = sqlStr & " , i.icon2image, i.sellcash, i.itemcouponyn ,i.sellyn , i.itemCouponValue , i.itemCouponType"
		sqlStr = sqlStr & " , c.socname " +vbcrlf
		sqlStr = sqlStr & " from ("
		sqlStr = sqlStr & " 	select top 4 pi.evt_code as itemid, pi.linkpath, pi.imagepath"
		sqlStr = sqlStr & " 	from db_diary2010.dbo.tbl_diary_poscode_image pi"
		sqlStr = sqlStr & " 	where pi.isusing='Y' and pi.poscode = 18"
		sqlStr = sqlStr & " 	and convert(varchar(10), getdate(), 120) >= convert(varchar(10), pi.event_start, 120) and convert(varchar(10), getdate(), 120) <= convert(varchar(10), pi.event_end, 120)"
		sqlStr = sqlStr & " 	and pi.imagepath <> '' and pi.imagepath is not null "
		sqlStr = sqlStr & " 	order by pi.image_order asc, pi.idx desc"
		sqlStr = sqlStr & "	) as t"
		sqlStr = sqlStr & " join db_item.dbo.tbl_item as i"
		sqlStr = sqlStr & " 	on t.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & " join db_user.dbo.tbl_user_c as c"
		sqlStr = sqlStr & " 	on i.makerid = c.userid and c.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & " where i.isusing='Y' and i.sellyn in ('Y','S')"

		'response.write sqlStr & "<br>"

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIAE",sqlStr,30)
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
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).fimagepath			= rsMem("imagepath")

				
				FItemList(i).flinkpath			= rsMem("linkpath")
				FItemList(i).FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("icon2image")
				FItemList(i).FItemDiv			= rsMem("itemdiv")
				FItemList(i).FEvalcnt			= rsMem("evalCnt")
				FItemList(i).FDeliverytype		= rsMem("deliveryType")
				FItemList(i).FBrandName			= db2html(rsMem("BrandName"))
				'FItemList(i).FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("icon1image")
				FItemList(i).Fmakerid		= rsMem("makerid")
				FItemList(i).Flimitno		= rsMem("limitno")
				FItemList(i).FLimityn			= rsMem("LimitYn")
				FItemList(i).Flimitsold		= rsMem("limitsold")
				FItemList(i).Fitemname	= rsMem("itemname")
				FItemList(i).Fsailyn			= rsMem("SaleYn")
				FItemList(i).Forgprice		= rsMem("orgprice")
				FItemList(i).Fsailprice		= rsMem("sailprice")
				FItemList(i).Fsellcash		= rsMem("sellcash")
				FItemList(i).Fitemid			= rsMem("itemid")
				FItemList(i).fbasicimage			= rsMem("basicimage")
				FItemList(i).Fitemcouponyn		= rsMem("itemcouponyn")
				FItemList(i).Fsellyn			= rsMem("sellyn")
				FItemList(i).FSaleyn			= rsMem("SaleYn")
				FItemList(i).FItemcouponvalue	= rsMem("itemCouponValue")
				FItemList(i).FItemcoupontype	= rsMem("itemCouponType")
				FItemList(i).Fsocname		= rsMem("socname")

				i=i+1
				rsMem.moveNext
			loop
		end if
		rsMem.Close

	End Sub

	'/diarystory2015/index.asp
	Public Sub getOneplusOneDaily()
		dim sqlStr,i

		sqlStr = "SELECT top 1"
		sqlStr = sqlStr & "  i.itemdiv, i.evalCnt, i.itemscore, i.LimitYn, i.DeliveryType, i.brandName, i.makerid, i.limitno"
		sqlStr = sqlStr & " , i.limitsold, i.itemname, i.SailYn as SaleYn, i.orgprice, i.sailprice,i.basicimage, i.icon1image"
		sqlStr = sqlStr & " , i.icon2image, i.sellcash, i.itemcouponyn ,i.sellyn , i.itemCouponValue , i.itemCouponType"
		sqlStr = sqlStr & " , o.itemid, o.image1, o.image2, o.imageend, o.endlink, o.explain, o.plustype, c.socname, o.mimage1 , o.eventid " 
		sqlStr = sqlStr & " FROM db_item.dbo.tbl_item as i"
		sqlStr = sqlStr & " inner join db_diary2010.dbo.tbl_OneplusOne as o"
		sqlStr = sqlStr & " 	on i.itemid = o.itemid " 
		sqlStr = sqlStr & " inner join db_user.dbo.tbl_user_c as c"
		sqlStr = sqlStr & " 	on i.makerid = c.userid and c.isusing = 'Y' "
		sqlStr = sqlStr & " where DATEDIFF(day , o.startdate , getdate()) = 0 "
		sqlStr = sqlStr & " and o.isusing = 'Y' "
		sqlStr = sqlStr & " order by o.startdate desc "

		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget, 1

		Ftotalcount = rsget.recordcount
		Fresultcount = rsget.recordcount

		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then
				
				FOneItem.fplustype		= rsget("plustype")
				FOneItem.FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")
				FOneItem.FItemDiv			= rsget("itemdiv")
				FOneItem.FEvalcnt			= rsget("evalCnt")
				FOneItem.FDeliverytype		= rsget("deliveryType")
				FOneItem.FBrandName			= db2html(rsget("BrandName"))
				'FOneItem.FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
				FOneItem.Fmakerid		= rsget("makerid")
				FOneItem.Flimitno		= rsget("limitno")
				FOneItem.FLimityn			= rsget("LimitYn")
				FOneItem.Flimitsold		= rsget("limitsold")
				FOneItem.Fitemname	= rsget("itemname")
				FOneItem.Fsailyn			= rsget("SaleYn")
				FOneItem.Forgprice		= rsget("orgprice")
				FOneItem.Fsailprice		= rsget("sailprice")
				FOneItem.Fsellcash		= rsget("sellcash")
				FOneItem.Fitemid			= rsget("itemid")
				FOneItem.fbasicimage			= rsget("basicimage")

				IF application("Svr_Info") = "Dev" THEN
					FOneItem.FImage1 = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image1")
					FOneItem.FImage2 = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image2")
					FOneItem.Fimageend = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("imageend")
				Else
					FOneItem.FImage1 = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image1")
					FOneItem.FImage2 = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image2")
					FOneItem.Fimageend = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("imageend")
				End If

				FOneItem.Fendlink		= rsget("endlink")
				FOneItem.Fexplain		= rsget("explain")
				FOneItem.Fitemcouponyn		= rsget("itemcouponyn")
				FOneItem.Fsellyn			= rsget("sellyn")
				FOneItem.FSaleyn			= rsget("SaleYn")
				FOneItem.FItemcouponvalue	= rsget("itemCouponValue")
				FOneItem.FItemcoupontype	= rsget("itemCouponType")
				FOneItem.Fsocname		= rsget("socname")
				
				''150924 모바일메인배너이미지추가 유태욱
				FOneItem.Fmimage1		= rsget("mimage1")

				FOneItem.Feventid		= rsget("eventid")
			End if
			rsget.close
	End Sub

	'/diarystory2015/index.asp
	Public Sub getDiaryCateCnt()
		dim sqlStr, i

		sqlStr = "SELECT " +vbcrlf
		sqlStr = sqlStr & " 	 count(*) as totcnt " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 10 then d.cate end) as num1 " +vbcrlf '이벤트 합
		sqlStr = sqlStr & " 	,count(case when d.cate = 20 then d.cate end) as num2 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 30 then d.cate end) as num3 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 40 then d.cate end) as num4 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 50 then d.cate end) as num5 " +vbcrlf
		sqlStr = sqlStr & " FROM [db_diary2010].[dbo].[tbl_event] AS d  " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_event].[dbo].[tbl_event] AS e ON d.evt_code = e.evt_code  " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_event].[dbo].[tbl_event_display] AS p ON d.evt_code = p.evt_code  " +vbcrlf
		sqlStr = sqlStr & " WHERE p.evt_bannerimg <> '' AND e.evt_state = '7' AND d.isusing = 'Y'  " +vbcrlf
		sqlStr = sqlStr & " and datediff(day,getdate(),e.evt_startdate) <=0  " +vbcrlf
		sqlStr = sqlStr & " and datediff(day,getdate(),e.evt_enddate)>=0  " +vbcrlf
		sqlStr = sqlStr & "		union all " +vbcrlf
		sqlStr = sqlStr & " select " +vbcrlf
		sqlStr = sqlStr & " 	 count(*) as totcnt " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 10 then cate end) as num1 " +vbcrlf '브랜드 합
		sqlStr = sqlStr & " 	,count(case when m.cate = 20 then cate end) as num2 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 30 then cate end) as num3 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 40 then cate end) as num4 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 50 then cate end) as num5 " +vbcrlf
		sqlStr = sqlStr & " from db_diary2010.dbo.tbl_diary_brandstory_2012 as M inner join [db_user].[dbo].tbl_user_c as C on M.makerid = C.userid where M.isusing = 'Y' and C.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "		union all " +vbcrlf
		sqlStr = sqlStr & " select  " +vbcrlf
		sqlStr = sqlStr & " 	 count(*) as totcnt " +vbcrlf
		sqlStr = sqlStr & " 	 ,count(case when m.cate = 10 then m.cate end) as num1 " +vbcrlf '상품 합
		sqlStr = sqlStr & " 	,count(case when m.cate = 20 then m.cate end) as num2 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 30 then m.cate end) as num3 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 40 then m.cate end) as num4 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 50 then m.cate end) as num5 " +vbcrlf
		sqlStr = sqlStr & " from [db_diary2010].dbo.tbl_DiaryMaster AS M  " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_item].[dbo].[tbl_item] AS i   " +vbcrlf
		sqlStr = sqlStr & " ON m.itemid = i.itemid AND m.mdpicksort > 0 " +vbcrlf
		sqlStr = sqlStr & " where m.isusing = 'Y' and i.Sellyn in ('Y','S') " +vbcrlf

    	'rsget.Open sqlStr,dbget,1
    	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DICN",sqlStr,30)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		Ftotalcount = rsMem.recordcount
		Fresultcount = rsMem.recordcount

		redim preserve FItemList(ftotalcount)
		IF  not rsMem.EOF  Then
			Do Until rsMem.eof
				set FItemList(i) = new cdiary_oneitem
				FItemList(i).Fdiarytotcnt   = rsMem("totcnt")
				FItemList(i).FdiaryCount1 = rsMem("num1") '심플
				FItemList(i).FdiaryCount2 = rsMem("num2") '일러스트
				FItemList(i).FdiaryCount3 = rsMem("num3") '패턴
				FItemList(i).FdiaryCount4 = rsMem("num4") '포토
				FItemList(i).FdiaryCount5 = rsMem("num5") '리미티드

				i=i+1
				rsMem.Movenext
			Loop
		End If
		rsMem.close
	End Sub

	'다이어리 아이템 리스트
	public Sub getDiaryItemLIst()
		Dim sqlStr ,i , vari , vartmp, vOrderBy

		If frectcontents <> "" Then
			frectcontents = Replace(frectcontents,"'","|")
			'frectcontents = Left(frectcontents,Len(frectcontents)-1)
		End IF

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_Cnt] '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', " & FPageSize & ", '"& frectlimited &"'"

		'response.write sqlStr & "<br>"
		'response.end
		'rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open sqlStr, dbget
		
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
			If ftectSortMet = "newitem" Then
'				vOrderBy = " ORDER BY d.mdpicksort DESC, d.diaryID DESC"
				vOrderBy = " ORDER BY sellSTDate desc, d.mdpicksort DESC "
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
			ElseIf ftectSortMet = "awardbest" Then
				vOrderBy = " ORDER BY i.itemScore DESC"
			ElseIf ftectSortMet = "awardwish" Then
				vOrderBy = " ORDER BY i.sellcash ASC"
			Else
				If fmdpick = "o" Then
					vOrderBy = " ORDER BY d.mdpicksort DESC, d.diaryID DESC"
				Else
					vOrderBy = " ORDER BY d.diaryID DESC"
				End IF
			End If

			sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_List_2012] '" & Cstr(FPageSize * FCurrPage) & "', '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', '" & vOrderBy & "', '"& fuserid &"', '"& frectlimited &"' "

			'response.write sqlStr & "<br>"
			'response.end
			'rsget.CursorLocation = adUseClient
			'rsget.CursorType = adOpenStatic
			'rsget.LockType = adLockOptimistic
			'rsget.Open sqlStr, dbget
			
			set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,30)
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
					set FItemList(i) = new cdiary_oneitem

						FItemList(i).fdiaryid			= rsMem("diaryid")
						FItemList(i).FCateName 			= rsMem("Cate")
						FItemList(i).FItemid			= rsMem("Itemid")
						'FItemList(i).FDiaryBasicImg		= webImgUrl & "/diary_collection/2012/basic/" & rsMem("BasicImg")
						'2019 버전 변경 
						FItemList(i).FDiaryBasicImg		= getThumbImgFromURL(webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(rsMem("Itemid")) & "/" & rsMem("basicimage"),"240","240","true","false")
						FItemList(i).FDiaryBasicImg2	= webImgUrl & "/diary_collection/2012/basic2/" & rsMem("BasicImg2")
						FItemList(i).FDiaryBasicImg3	= webImgUrl & "/diary_collection/2012/basic3/" & rsMem("BasicImg3")
						FItemList(i).FStoryImg			= webImgUrl & "/diary_collection/2012/story/" & rsMem("StoryImg")
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
						FItemList(i).FpreviewImg = rsMem("diary_idx")
						
						FItemList(i).FPojangOk = rsMem("pojangok")
						
						FItemList(i).Flimited = rsMem("limited")
						If fuserid <> "" then
							FItemList(i).Fuserid			= rsMem("userid")
						End If

						FItemList(i).FPoints			= rsMem("totalpoint")
						FItemList(i).FmdpickYN = rsMem("mdpick")
						FItemList(i).FNewYN = rsMem("newyn")
					i=i+1
					rsMem.moveNext
				loop
			end if

			rsMem.Close
		End If
	end Sub

	'### 2015 다이어리 이벤트(2014-10-07 유태욱)
	public Function fnGetdievent()
       Dim sqlStr ,i

		sqlStr = "exec [db_diary2010].[dbo].[sp_Ten_Diary_event_list_cnt_2021] "&FPageSize&",'"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FEvttype&"','"&Fisweb&"','"&Fismobile&"','"&Fisapp&"','"&FExcCode&"'"

		'rsget.CursorLocation = adUseClient
		'rsget.CursorType = adOpenStatic
		'rsget.LockType = adLockOptimistic
		'rsget.Open sqlStr, dbget
		
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIEV",sqlStr,30)
        if (rsMem is Nothing) then Exit Function ''추가
		
			FTotalCount = rsMem("cnt")
			FTotalPage = rsMem("totPg")
		rsMem.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit Function
		end if

		If FTotalCount > 0 Then
			sqlStr = "exec [db_diary2010].[dbo].[sp_Ten_Diary_event_list_2021] "&FCurrPage&","&FPageSize&",'"&FSCType&"','"&FSCategory&"','"&FSCateMid&"','"&FEScope&"','"&FselOp&"','"&FEvttype&"','"&Fisweb&"','"&Fismobile&"','"&Fisapp&"','"&FExcCode&"'"

			'rsget.CursorLocation = adUseClient
			'rsget.CursorType = adOpenStatic
			'rsget.LockType = adLockOptimistic
			'rsget.Open sqlStr, dbget
			
			set rsMem = getDBCacheSQL(dbget,rsget,"DIEV",sqlStr,30)
            if (rsMem is Nothing) then Exit Function ''추가
            
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
					set FItemList(i) = new cdiary_oneitem

					FItemList(i).fissale		= rsMem("issale")
					FItemList(i).fisgift		= rsMem("isgift")
					FItemList(i).fiscoupon		= rsMem("iscoupon")										
					FItemList(i).fiscomment		= rsMem("iscomment")					
					FItemList(i).fisbbs		= rsMem("isbbs")					
					FItemList(i).fisapply		= rsMem("isapply")
					FItemList(i).fisOnlyTen		= rsMem("isOnlyTen")
					FItemList(i).fisoneplusone		= rsMem("isoneplusone")
					FItemList(i).fisfreedelivery		= rsMem("isfreedelivery")
					FItemList(i).fisbookingsell		= rsMem("isbookingsell")
					FItemList(i).FEvt_name  	  = db2html(rsMem("evt_name"))
					FItemList(i).FEvt_subcopyK    = db2html(rsMem("evt_subcopyK")) 'pc용 이벤트 서브카피
					FItemList(i).FEvt_subname    = db2html(rsMem("evt_subname")) 'm,app용 이벤트 서브카피
					FItemList(i).FEvt_bannerimg   = db2html(rsMem("evt_bannerimg"))
					FItemList(i).fevt_mo_listbanner   = db2html(rsMem("evt_mo_listbanner"))
					
					FItemList(i).FEvt_code		= rsMem("evt_code")
					FItemList(i).FEvt_kind 		= rsMem("evt_kind")
					FItemList(i).FEvt_startdate	= rsMem("evt_startdate")
					FItemList(i).FEvt_enddate	= rsMem("evt_enddate")
					FItemList(i).FIsusing 		= rsMem("evt_using")
					FItemList(i).FSalePer   = rsMem("saleper")
					FItemList(i).FSaleCPer   = rsMem("salecper")
                    FItemList(i).FGiftCnt   = rsMem("giftcnt")

					i=i+1
					rsMem.moveNext
				loop
			end if

			rsMem.Close
		End If
	End Function

	'// 프리뷰 이미지 가져옴.
	public Function getPreviewImgLoad()
		dim strSQL,i

		strSQL ="SELECT count(idx) FROM [db_diary2010].[dbo].[tbl_diary_previewImg] "
		strSQL = strSQL & "WHERE isusing='Y' And diary_idx='"&Fidx&"' "
		rsget.Open strSQL, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
		END IF
		rsget.close

		IF FTotalCount > 0 Then
		
				strSQL = " SELECT a.idx, a.diary_idx, a.previewImg, a.isusing, c.itemname, c.orgprice, b.cate, c.sellcash,C.makerid, c.brandname, c.sellyn, c.itemid, c.sailyn , c.limityn, c.limitno, c.limitsold, c.deliveryType, c.itemcouponYn, c.itemcouponYn, c.itemCouponValue, d.favcount, c.itemdiv "
				strSQL = strSQL & " , c.itemCouponType, c.evalCnt "
				strSQL = strSQL & " FROM [db_diary2010].[dbo].[tbl_diary_previewImg] A "
				strSQL = strSQL & " inner join db_diary2010.dbo.tbl_DiaryMaster B on a.diary_idx = B.diaryid "
				strSQL = strSQL & " inner join db_item.dbo.tbl_item C on B.itemid = C.itemid "
				strSQL = strSQL & " inner join db_item.dbo.tbl_item_contents D on B.itemid = D.itemid "
				strSQL = strSQL & " Where	A.isusing='Y' And A.diary_idx='"&Fidx&"' "
				strSQL = strSQL & "ORDER BY A.sortnum asc "
				
				rsget.Open strSQL, dbget, 1
				redim preserve FItemList(FTotalCount)
				if  not rsget.EOF  then
					do until rsget.eof
						set FItemList(i) = new cdiary_oneitem
							FItemList(i).fidx		= rsget("idx")
							FItemList(i).FItemid			= rsget("Itemid")
							FItemList(i).fdiaryid			= rsget("diary_idx")
							FItemList(i).FpreviewImg		= rsget("previewImg")
							FItemList(i).Fisusing			= rsget("isusing")
							FItemList(i).FCateName 			= rsget("Cate")
							FItemList(i).FItemName			= db2html(rsget("ItemName"))
							FItemList(i).FSellCash			= rsget("SellCash")
							FItemList(i).FOrgPrice			= rsget("OrgPrice")
							FItemList(i).FMakerId			= rsget("MakerId")
							FItemList(i).FBrandName			= db2html(rsget("BrandName"))
							FItemList(i).FSellyn			= rsget("sellYn")
							FItemList(i).FSaleyn			= rsget("sailyn")
							FItemList(i).FLimityn			= rsget("LimitYn")
							FItemList(i).FLimitNo			= rsget("LimitNo")
							FItemList(i).FLimitSold			= rsget("LimitSold")
							FItemList(i).FDeliverytype		= rsget("deliveryType")
							FItemList(i).FItemcouponyn		= rsget("itemcouponYn")
							FItemList(i).FItemcouponvalue	= rsget("itemCouponValue")
							FItemList(i).FItemcoupontype	= rsget("itemCouponType")
							FItemList(i).FEvalcnt			= rsget("evalCnt")
							FItemList(i).Ffavcount			= rsget("favcount")
							FItemList(i).FItemDiv			= rsget("itemdiv")
						i=i+1
						rsget.moveNext
					loop
				end if
				rsget.Close
		END IF

	End Function


	'// 검색어값 가져옴.
	Public Function getSearchValueSet()
		dim strSQL,i

		strSQL = "		Select diaryid, cate, "
		strSQL = strSQL & "		stuff(( "
		strSQL = strSQL & "			Select ','+a1.keyword_option "
		strSQL = strSQL & "			From [db_diary2010].[dbo].[tbl_keyword_master] a1 "
		strSQL = strSQL & "			inner join [db_diary2010].[dbo].[tbl_keyword_option] b1 on a1.keyword_option = b1.idx "
		strSQL = strSQL & "			Where (a1.diaryid = A.diaryid And b1.type='material') "
		strSQL = strSQL & "			for xml path ('')), 1, 1, '') as keyword_form, "
		strSQL = strSQL & "		stuff(( "
		strSQL = strSQL & "			Select ','+a2.keyword_option "
		strSQL = strSQL & "			From [db_diary2010].[dbo].[tbl_keyword_master] a2 "
		strSQL = strSQL & "			inner join [db_diary2010].[dbo].[tbl_keyword_option] b2 on a2.keyword_option = b2.idx "
		strSQL = strSQL & "			Where (a2.diaryid = A.diaryid And b2.type='color') "
		strSQL = strSQL & "			for xml path ('')), 1, 1, '') as keyword_color,			 "
		strSQL = strSQL & "		stuff(( "
		strSQL = strSQL & "			Select ','''+a3.info_name+'''' "
		strSQL = strSQL & "			From [db_diary2010].[dbo].[tbl_diary_info] a3 "
		strSQL = strSQL & "			Where (a3.idx = a.diaryid And info_pageCnt<>0 ) "
		strSQL = strSQL & "			for xml path ('')), 1, 1, '') as info_name "
		strSQL = strSQL & "	From [db_diary2010].[dbo].[tbl_DiaryMaster] A "
		strSQL = strSQL & "	Where A.diaryid='"&Fidx&"' "
		rsget.Open strSQL, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) Then
			fdiaryid = rsget("diaryid")
			FCate = rsget("cate")
			FKeyword_Form = rsget("keyword_form")
			FKeyword_Color = rsget("keyword_color")
			finfo_name = rsget("info_name")
		END IF
		rsget.close
	End Function

	'// 2018-08-23 추천다이어리 (방금 판매된 다이어리 top 12)
	public Sub getNowSellingItems()
		dim sqlStr , i
		sqlStr = "exec [db_diary2010].[dbo].[usp_WWW_sell_diaryitems_count]"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not (rsget.EOF OR rsget.BOF) THEN
			FResultCount = rsget("cnt")
		END IF
		rsget.close

		IF FResultCount > 0 Then
			if FResultCount > 12 then FResultCount = 12 
			
			sqlStr = "exec [db_diary2010].[dbo].[usp_WWW_sell_diaryitems_List]"
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

			i=0

			redim preserve FItemList(FResultCount)
			if  not rsget.EOF  then
				do until rsget.eof
					set FItemList(i) = new cdiary_oneitem
						FItemList(i).Fitemid			= rsget("itemid")
						FItemList(i).FSellYn			= rsget("sellyn")
						FItemList(i).FSaleYn     		= rsget("sailyn")
						FItemList(i).FRegdate 			= rsget("regdate")
						FItemList(i).Fevalcnt 			= rsget("evalCnt")
						FItemList(i).Fitemdiv			= rsget("itemdiv")
						FItemList(i).FLimitYn			= rsget("limityn")
						FItemList(i).FLimitNo			= rsget("limitno")
						FItemList(i).Fmakerid			= rsget("makerid")
						FItemList(i).FSellcash			= rsget("sellcash")
						FItemList(i).FOrgPrice			= rsget("orgprice")
						FItemList(i).FitemScore 		= rsget("itemScore")
						FItemList(i).FLimitSold			= rsget("limitsold")
						FItemList(i).Fitemcouponyn 		= rsget("itemcouponYn")
						FItemList(i).Fitemcoupontype	= rsget("itemCouponType")
						FItemList(i).Fselldate			= rsget("selldate")
						FItemList(i).FItemCouponValue	= rsget("itemCouponValue")
						FItemList(i).FItemName			= db2html(rsget("itemname"))
						FItemList(i).FBrandName  		= db2html(rsget("brandname"))
						FItemList(i).FImageList			= "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage")
						FItemList(i).FImageList120		= "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage120")
						FItemList(i).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("smallImage")
						FItemList(i).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon1image")
						FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
						FItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.Close
		end if 
	End Sub

	'// 다이어리 다꾸랭킹 상품 리스트
	public Sub GetDiaryDaccuItemRanking()
		dim sqlStr,i
		Dim rsMem

		sqlStr = "exec db_temp.dbo.usp_TEN_GetDiaryDecoItemRankingList " & frecttoplimit & ",'" & frectcate & "','" & FRectRankingDate & "'"
'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
'		FResultCount = rsget.Recordcount

		set rsMem = getDBCacheSQL(dbget,rsget,"DACCURANKING",sqlStr,60*60)
		'set rsMem = getDBCacheSQL(dbget,rsget,"DACCURANKING",sqlStr,1*1)
		if (rsMem is Nothing) then Exit sub ''추가

		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).FItemDiv    = rsMem("itemdiv")
				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")

                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")


				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + FItemList(i).FImageBasic
				end if

                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + FItemList(i).Ficon1image
				end if

				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + FItemList(i).Ficon2image
				end if


				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FSaleYN    = rsMem("sailyn")
				FItemList(i).FSalePrice = rsMem("sailprice")
				FItemList(i).FOrgPrice   = rsMem("orgprice")

				FItemList(i).FSpecialUserItem   = rsMem("specialuseritem")
				FItemList(i).Freviewcnt         = rsMem("evalcnt")
				FItemList(i).FRegdate           = rsMem("regdate")

				FItemList(i).FItemCouponYN      = rsMem("itemcouponyn")
                FItemList(i).FItemCouponType    = rsMem("itemcoupontype")
                FItemList(i).FItemCouponValue   = rsMem("itemcouponvalue")
                FItemList(i).FCurrItemCouponIdx = rsMem("curritemcouponidx")

                FItemList(i).FEvalcnt           = rsMem("Evalcnt")
                FItemList(i).FReIpgoDate        = rsMem("reipgodate")

                FItemList(i).FSellYn            = rsMem("sellyn")
                FItemList(i).FLimitYn           = rsMem("limityn")
                FItemList(i).FLimitNo           = rsMem("limitno")
                FItemList(i).FLimitSold         = rsMem("limitsold")
                FItemList(i).FFavCount         = rsMem("favcount")
				FItemList(i).FOptionCount		= rsMem("optioncnt")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close
	end Sub

	'### 2021 다이어리 이벤트(2020-08-17 정태훈)
	public Function fnGetDiaryMKTEvent()
       Dim sqlStr ,i
		sqlStr = "exec [db_diary2010].[dbo].[sp_Ten_diaryMKTEvent_list]"
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIMKTEV",sqlStr,60*60)
        if (rsMem is Nothing) then Exit Function ''추가
        set FOneItem = new cdiary_oneitem
        if  not rsMem.EOF  then
			FOneItem.FEvt_name  	  = db2html(rsMem("evt_name"))
			FOneItem.FEvt_subcopyK    = db2html(rsMem("evt_subcopyK")) 'pc용 이벤트 서브카피
			FOneItem.FEvt_subname    = db2html(rsMem("evt_subname")) 'm,app용 이벤트 서브카피
			FOneItem.FEvt_bannerimg   = db2html(rsMem("etc_itemimg"))
			FOneItem.FEvt_code		= rsMem("evt_code")
        end if
		rsMem.Close
	End Function

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

'// 다이어리스토리 검색페이지 체크박스 체크
function getchecked(Byval totaltext , Byval selecttext)
	dim totaltext_var , totaltext_temp , arr_i
	dim TotText , SelText

	TotText = totaltext
	SelText = selecttext
	'//배열선언

	totaltext_var = split(TotText,",")
	for arr_i = 0 to ubound(totaltext_var)-1
		if CStr(totaltext_var(arr_i)) = CStr(SelText) then
			getchecked =  " checked"
			Exit Function
		end if

	next

end Function

'// 다이어리스토리 검색페이지 컬러코드 체크 2012-10-19
function getcheckediccd(Byval totaltext , Byval selecttext)
	dim totaltext_var , totaltext_temp , arr_i
	dim TotText , SelText

	TotText = totaltext
	SelText = selecttext
	'//배열선언

	totaltext_var = split(TotText,",")
	for arr_i = 0 to ubound(totaltext_var)-1
		if CStr(totaltext_var(arr_i)) = CStr(SelText) then
			getcheckediccd =  "Y"
			Exit Function
		Else
			getcheckediccd =  "N"
		end if

	Next

end Function

'// 다이어리스토리 검색페이지 체크박스 체크 2012-10-19
function getcheckedcolorclass(Byval totaltext , Byval selecttext)
	dim totaltext_var , totaltext_temp , arr_i
	dim TotText , SelText

	TotText = totaltext
	SelText = selecttext
	'//배열선언

	totaltext_var = split(TotText,",")
	for arr_i = 0 to ubound(totaltext_var)-1
		if CStr(totaltext_var(arr_i)) = CStr(SelText) then
			getcheckedcolorclass =  "style='display:inline;'"
			Exit Function
		end if

	next

end Function

'//브랜드 스페셜 배너 최근 이미지 주소 가져오기
public Function fnGetBrandSpecialimg()
	dim sqlStr, bannerimg

	sqlStr = "SELECT top 1 momainbrandimg FROM [db_diary2010].[dbo].[tbl_diaryspecial_brand] WHERE isusing='Y' and momainbrandimg<>''  order by sortnum asc, idx desc"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	If not rsget.eof Then
		bannerimg = rsget(0)
	End IF
	rsget.close

	fnGetBrandSpecialimg = bannerimg
End Function

Function GetDiaryDaccuBestDate(nowDate)
	Dim strsql, tempDateTagValue, tempDateValue

	tempDateTagValue = ""
	tempDateValue = ""

	strSQL = " SELECT DISTINCT CONVERT(VARCHAR(10), rankdate, 120) as rankDate "
	strSQL = strSQL & " FROM db_temp.dbo.tbl_DiaryDecoItemRanking "
	strSQL = strSQL & " WHERE CONVERT(VARCHAR(10), rankdate, 120) <> '"&nowDate&"' "
	strSQL = strSQL & " ORDER BY rankdate DESC "
	rsget.Open strSQL, dbget, 1
	If Not rsget.EOF Then
		Do Until rsget.EOF
			tempDateValue = Left(rsget("rankDate"), 4)&"년 "&Mid(rsget("rankDate"), 6, 2)&"월 "&Right(rsget("rankDate"), 2)&"일"
			tempDateTagValue = tempDateTagValue & "<option value='"&rsget("rankDate")&"'>"&tempDateValue&"</option>"
		rsget.movenext
		Loop
		GetDiaryDaccuBestDate = tempDateTagValue
	Else
		GetDiaryDaccuBestDate = "<li>일자가 없습니다.</li>"
	End If
	rsget.close
End Function

'// 사은품 아이콘 적용
Public Function fnGetGiftiCon(Deliverytype , OrgPrice, ItemID)
	If (Deliverytype = "1" Or Deliverytype = "4") And OrgPrice >= 8800 Then
		if isDiaryStoryItemCheck(ItemID) then
			fnGetGiftiCon = True
		else
			fnGetGiftiCon = False
		end if
	Else
		fnGetGiftiCon = False
	End If
End Function

'// 무료배송 아이콘 적용
Public Function fnGetDeliveryFreeiCon(Deliverytype,SellCash,DefaultFreeBeasongLimit)
	if cLng(SellCash)>=cLng(getFreeBeasongLimit(Deliverytype,DefaultFreeBeasongLimit)) then
		fnGetDeliveryFreeiCon= True
	Else
		fnGetDeliveryFreeiCon = False
	End If
	If Deliverytype = "2" Or Deliverytype = "4" Or Deliverytype = "5" Or Deliverytype = "6" Then
		fnGetDeliveryFreeiCon = True
	End If
	if (Deliverytype="7") then
		fnGetDeliveryFreeiCon = False
	end if
End Function

public Function getFreeBeasongLimit(Deliverytype, DefaultFreeBeasongLimit)
	if (Deliverytype="9") then
		If (IsNumeric(DefaultFreeBeasongLimit)) and (DefaultFreeBeasongLimit<>0) then
			getFreeBeasongLimit = DefaultFreeBeasongLimit
		else
			getFreeBeasongLimit = 50000
		end if
	else
		getFreeBeasongLimit = 30000
	end if
end Function

'### 2020 다이어리 스토리 전시카테고리 포함 유무
'### 상품상세 표기 조건 수정 - 8800원 이상, 전시(기본)카테고리 조건, 텐배조건=deliverytype in (1,4)
'### 101102101101	심플
'### 101102101102	일러스트
'### 101102101103	포토
'### 101102101104	패턴
'### 101102103106	스터디플래너
'### 101102103107	가계부
public function isDiaryStoryItemCheck(ItemID)
	dim sqlStr , isItem , objCmd

	sqlStr = " SELECT 1 FROM db_item.dbo.tbl_display_cate_item c WITH(NOLOCK) "
	sqlStr = sqlStr & " WHERE c.catecode IN (101102101101, 101102101102, 101102101103, 101102101104, 101102103106, 101102103107) "
	sqlStr = sqlStr & " AND c.itemid= ? "
	sqlStr = sqlStr & " AND c.isDefault='y' "

	Set objCmd = Server.CreateObject("ADODB.COMMAND")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = sqlStr
		.Prepared = true
		.Parameters.Append .CreateParameter("c.itemid", adVarChar, adParamInput, Len(ItemID), ItemID)
		rsget.Open objCmd
		if not rsget.eof then
			if rsget(0) > 0 then
				isDiaryStoryItemCheck = True
			else
				isDiaryStoryItemCheck = false
			end if
		else
			isDiaryStoryItemCheck = false
		end if
		rsget.Close
	End With
end function
%>
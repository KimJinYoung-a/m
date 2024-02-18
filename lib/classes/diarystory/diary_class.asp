<%

Class cdiary_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
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
	public fidx_order
	public fevent_type
	public fevt_name
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
	
	public fusedate
	public fetc
	public fcolor
	public FDiaryBasicImg
	public FDiaryBasicImg2
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
	Public Mimage1
	Public Mimage2
	Public Mimage1Link
	Public Mimage2Link
	'2012 다이어리 추가 - 이종화
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
	
	public FSCType
	public FEScope
	public FItemID
	public FStoryImage
	public FSoonSeo
	public FDiaryID
	public FRectDate
	public Fmomentdate
	public Fmomenttype
	public FUserID
	public FGiftSu

	'2012-10-21 이종화 추가
	public FMakerId
	Public Fbrandview
	Public Fidx

	Private Sub Class_Initialize()
		FCurrPage = 1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
	End Sub
	Private Sub Class_Terminate()

	End Sub


	'### 2011 /diarystory/event/diary_event.asp 사용
	public Function geteventList()
		dim strSQL,i

		strSQL ="SELECT count(d.evt_code) FROM [db_diary2010].[dbo].[tbl_event] AS d "
		strSQL = strSQL & "INNER JOIN [db_event].[dbo].[tbl_event] AS e ON d.evt_code = e.evt_code "
		strSQL = strSQL & "INNER JOIN [db_event].[dbo].[tbl_event_display] AS p ON d.evt_code = p.evt_code "
		strSQL = strSQL & "WHERE "
		strSQL = strSQL & "	p.evt_bannerimg <> '' AND e.evt_state = '7' AND d.isusing = 'Y' and  datediff(day, getdate(),e.evt_startdate) <=0 and datediff(day,getdate(),e.evt_enddate)>=0 "
		rsget.Open strSQL, dbget, 1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FTotalCount = rsget(0)
		END IF
		rsget.close


		IF FTotalCount > 0 THEN
				strSQL ="SELECT Top " & (FCurrPage*FPageSize) & " e.evt_code, p.evt_bannerimg, e.evt_startdate, e.evt_enddate, e.evt_kind, p.brand ,p.evt_LinkType ,p.evt_bannerlink, "
				strSQL = strSQL & " (Case When e.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=d.evt_code order by itemid desc) else 0 end) as itemid, p.evt_bannerimg2010 "
				strSQL = strSQL & " FROM [db_diary2010].[dbo].[tbl_event] AS d "
				strSQL = strSQL & "INNER JOIN [db_event].[dbo].[tbl_event] AS e ON d.evt_code = e.evt_code "
				strSQL = strSQL & "INNER JOIN [db_event].[dbo].[tbl_event_display] AS p ON d.evt_code = p.evt_code "
				strSQL = strSQL & "WHERE "
				strSQL = strSQL & "	p.evt_bannerimg <> '' AND e.evt_state = '7' AND d.isusing = 'Y' and  datediff(day, getdate(),e.evt_startdate) <=0 and datediff(day,getdate(),e.evt_enddate)>=0 "
				strSQL = strSQL & "ORDER BY d.idx_order DESC, e.evt_startdate DESC "
				rsget.Open strSQL, dbget, 1
				
				If FGubun = "list" Then
					IF Not (rsget.EOF OR rsget.BOF) THEN
						geteventList = rsget.GetRows()
					END IF
					rsget.close
				Else
					rsget.pagesize = FPageSize
		
					if (FCurrPage * FPageSize < FTotalCount) then
						FResultCount = FPageSize
					else
						FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
					end if
			
					FTotalPage = (FTotalCount\FPageSize)
			
					if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
			
					redim preserve FItemList(FResultCount)
			
					FPageCount = FCurrPage - 1
					if  not rsget.EOF  then
						rsget.absolutePage=FCurrPage
						do until rsget.eof
							set FItemList(i) = new cdiary_oneitem
			
								FItemList(i).fevt_code			= rsget("evt_code")
								FItemList(i).fevt_bannerimg		= rsget("evt_bannerimg")
								FItemList(i).fevt_startdate		= rsget("evt_startdate")
								FItemList(i).fevt_enddate		= rsget("evt_enddate")
								FItemList(i).fitemid			= rsget("itemid")
								
								FItemList(i).fevt_kind			= rsget("evt_kind")
								FItemList(i).fbrand				= rsget("brand")
								FItemList(i).fevt_linkType		= rsget("evt_LinkType")
								FItemList(i).fevt_bannerlink	= rsget("evt_bannerlink")
			
							i=i+1
							rsget.moveNext
						loop
					end if
			
					rsget.Close
				END IF
		END IF

	End Function


	'### 2011 index 안에 /diarystory/search/iframe_list.asp 사용
    public Sub GetBrandsearchList()
        Dim sqlStr ,i , vari , vartmp, vOrderBy

		If frectcontents <> "" Then
			frectcontents = Replace(frectcontents,"'","|")
			frectcontents = Left(frectcontents,Len(frectcontents)-1)
		End IF

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_Cnt] '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', " & FPageSize & " "

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
			FTotalCount = rsget("Totalcnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		If FTotalCount > 0 Then
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
			Else
				If fmdpick = "o" Then
					vOrderBy = " ORDER BY d.mdpicksort DESC, d.diaryID DESC"
				Else
					vOrderBy = " ORDER BY d.diaryID DESC"
				End IF
			End If
	
	
			sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_List] '" & Cstr(FPageSize * FCurrPage) & "', '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', '" & vOrderBy & "' "
	
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			'response.write sqlStr & "<br>"
			rsget.Open sqlStr, dbget
			rsget.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			FTotalPage = (FTotalCount\FPageSize)
	
			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
	
			redim preserve FItemList(FResultCount)
	
			FPageCount = FCurrPage - 1
			if  not rsget.EOF  then
				rsget.absolutePage=FCurrPage
				do until rsget.eof
					set FItemList(i) = new cdiary_oneitem
	
						FItemList(i).fdiaryid			= rsget("diaryid")
						FItemList(i).FCateName 			= rsget("Cate")
						FItemList(i).FItemid			= rsget("Itemid")
						FItemList(i).FDiaryBasicImg		= "http://webimage.10x10.co.kr/diary_collection/2011/basic/" & rsget("BasicImg")
						FItemList(i).FDiaryBasicImg2	= "http://webimage.10x10.co.kr/diary_collection/2011/basic2/" & rsget("BasicImg2")
						FItemList(i).FImageicon1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
						FItemList(i).FItemName			= db2html(rsget("ItemName"))
						FItemList(i).FSellCash			= rsget("SellCash")
						FItemList(i).FOrgPrice			= rsget("OrgPrice")
						FItemList(i).FMakerId			= rsget("MakerId")
						FItemList(i).FBrandName			= db2html(rsget("BrandName"))
						FItemList(i).FSellyn			= rsget("sellYn")
						FItemList(i).FSaleyn			= rsget("SaleYn")
						FItemList(i).FLimityn			= rsget("LimitYn")
						FItemList(i).FLimitNo			= rsget("LimitNo")
						FItemList(i).FLimitSold			= rsget("LimitSold")
						FItemList(i).FDeliverytype		= rsget("deliveryType")
						FItemList(i).FItemcouponyn		= rsget("itemcouponYn")
						FItemList(i).FItemcouponvalue	= rsget("itemCouponValue")
						FItemList(i).FItemcoupontype	= rsget("itemCouponType")
						FItemList(i).FEvalcnt			= rsget("evalCnt")
						FItemList(i).FItemDiv			= rsget("itemdiv")
						FItemList(i).FImageicon2		= "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")	
					i=i+1
					rsget.moveNext
				loop
			end if
	
			rsget.Close
		End If

    end Sub


	'### 2011 index 안에 /diarystory/search/iframe_list.asp 사용
    public Sub GetBrandsearchList_bottom()
        Dim sqlStr ,i , vari , vartmp, vOrderBy

		If frectcontents <> "" Then
			frectcontents = Replace(frectcontents,"'","|")
			frectcontents = Left(frectcontents,Len(frectcontents)-1)
		End IF

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_Cnt_bottom] '" & frectdesign & "' , " & FPageSize & ""

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
			FTotalCount = rsget("Totalcnt")
			FTotalPage = rsget("totPg")
		rsget.Close
		
		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if		
		
		If FTotalCount > 0 Then
			If ftectSortMet = "newitem" Then
				vOrderBy = " ORDER BY d.idx desc"
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
			Else
				If fmdpick = "o" Then
					vOrderBy = " ORDER BY d.mdpicksort DESC, d.idx DESC"
				Else
					vOrderBy = " ORDER BY d.idx desc"
				End IF
			End If
	
			sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_List_bottom] '" & Cstr(FPageSize * FCurrPage) & "', '" & frectdesign & "', '" & vOrderBy & "' "
	
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			'response.write sqlStr & "<br>"
			rsget.Open sqlStr, dbget
			rsget.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			FTotalPage = (FTotalCount\FPageSize)
	
			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
	
			redim preserve FItemList(FResultCount)
	
			FPageCount = FCurrPage - 1
			if  not rsget.EOF  then
				rsget.absolutePage=FCurrPage
				do until rsget.eof
					set FItemList(i) = new cdiary_oneitem
	
						FItemList(i).fdiaryid			= rsget("idx")
						FItemList(i).FCateName 			= rsget("Cate")
						FItemList(i).FItemid			= rsget("Itemid")
						FItemList(i).FImageicon1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
						FItemList(i).FItemName			= db2html(rsget("ItemName"))
						FItemList(i).FSellCash			= rsget("SellCash")
						FItemList(i).FOrgPrice			= rsget("OrgPrice")
						FItemList(i).FMakerId			= rsget("MakerId")
						FItemList(i).FBrandName			= db2html(rsget("BrandName"))
						FItemList(i).FSellyn			= rsget("sellYn")
						FItemList(i).FSaleyn			= rsget("SaleYn")
						FItemList(i).FLimityn			= rsget("LimitYn")
						FItemList(i).FLimitNo			= rsget("LimitNo")
						FItemList(i).FLimitSold			= rsget("LimitSold")
						FItemList(i).FDeliverytype		= rsget("deliveryType")
						FItemList(i).FItemcouponyn		= rsget("itemcouponYn")
						FItemList(i).FItemcouponvalue	= rsget("itemCouponValue")
						FItemList(i).FItemcoupontype	= rsget("itemCouponType")
						FItemList(i).FEvalcnt			= rsget("evalCnt")
						FItemList(i).FItemDiv			= rsget("itemdiv")
						FItemList(i).FImageicon2		= "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")	
						FItemList(i).FListImage			= "http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("listimage")	
					i=i+1
					rsget.moveNext
				loop
			end if
	
			rsget.Close
		End If

    end Sub





	'### 2011 /diarystory/diary_prd.asp 사용
    public Sub DiaryStoryProdCheck()
        Dim sqlStr, i

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_PrdPage_Check] '" & FItemID & "' "
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
		IF Not (rsget.EOF OR rsget.BOF) THEN
			FStoryImage		= rsget(0)
			FSoonSeo		= rsget(1)
			FDiaryID		= rsget(2)
			FCate			= rsget(3)
			FResultCount	= "1"
		End If
		rsget.Close
	end Sub

	'### 2020 다이어리 스토리 전시카테고리 포함 유무
	'### 상품상세 표기 조건 수정 - 8800원 이상, 전시(기본)카테고리 조건, 텐배조건=deliverytype in (1,4)
	'### 101102101101	심플
	'### 101102101102	일러스트
	'### 101102101103	포토
	'### 101102101104	패턴
	'### 101102103106	스터디플래너
	'### 101102103107	가계부
	'### 101102101109	3공/6공
	public function isDiaryStoryItem()
		dim sqlStr , isItem , objCmd

		sqlStr = " SELECT 1 FROM db_item.dbo.tbl_display_cate_item c WITH(NOLOCK) "
		sqlStr = sqlStr & " WHERE c.catecode IN (101102101101, 101102101102, 101102101103, 101102101104, 101102103106, 101102103107, 101102101109) "
		sqlStr = sqlStr & " AND c.itemid= ? "
		sqlStr = sqlStr & " AND c.isDefault='y' "

		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("c.itemid", adVarChar, adParamInput, Len(FItemID), FItemID)
			rsget.Open objCmd
			if not rsget.eof then
				if rsget(0) > 0 then
					isDiaryStoryItem = True
				else
					isDiaryStoryItem = false
				end if
			else
				isDiaryStoryItem = false
			end if
			rsget.Close
		End With
	end function 	
	
	'// 다이어리 내지구성추가내지
	Function FGetDiaryInfo_add()
		dim strSQL

		strSQL = "select a.idx,a.info_gubun,a.info_name,a.info_img,a.info_pageCnt,a.search_View,a.Info_idx,b.search_order" + vbcrlf
		strSQL = strSQL & " FROM [db_diary2010].[dbo].tbl_diary_info a" +vbcrlf
		strSQL = strSQL & " left join [db_diary2010].[dbo].tbl_diary_info_search b" +vbcrlf
		strSQL = strSQL & " on a.info_name= b.info_name" +vbcrlf
		strSQL = strSQL & " WHERE a.idx='"& FDiaryID &"'" +vbcrlf
		strSQL = strSQL & " ORDER BY b.search_order desc" +vbcrlf

		'response.write strSQL
		rsget.Open strSQL, dbget ,1
		if not rsget.eof then
			FGetDiaryInfo_add = rsget.GetRows()
		end if
		rsget.Close
	End Function


	'//검색항목 컨텐츠 종류 다 가져오기
    public Sub fcontents_count()
        dim sqlStr

        sqlStr = "select info_name" +vbcrlf
		sqlStr = sqlStr & " from db_diary2010.dbo.tbl_diary_info_search" +vbcrlf
		sqlStr = sqlStr & " order by search_order desc" +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		rsget.pagesize = FPageSize
		ftotalcount = rsget.recordcount
		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		'FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(ftotalcount)

		FPageCount = FCurrPage - 1
		i = 0
		if  not rsget.EOF  then
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).finfo_name	= rsget("info_name")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
    end Sub

	'//키워드 종류 뿌리기
	public Sub fkeyword_type()
		dim strSQL,i


		'데이터 리스트
		strSQL ="select idx , option_value from db_diary2010.dbo.tbl_keyword_option where isusing = 'Y' "

		if frecttype <> "" then
		strSQL = strSQL & " and type = '"& frecttype &"'"
		end if

		if frecttype = "color" then
			strSQL = strSQL & " group by idx ,option_value, option_order ORDER BY option_order ASC"
		else
			strSQL = strSQL & " group by idx ,option_value"
		end if

		'response.write strSQL & "<br>"
		rsget.pagesize = FPageSize
		rsget.open strSQL,dbget,1

		FTotalCount = rsget.recordcount
		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		IF  not rsget.EOF  Then

			i=0

			Do Until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).foption_value = rsget("option_value")
				FItemList(i).fidx = rsget("idx")

				i=i+1
				rsget.Movenext

			Loop

		End IF

		rsget.close
	End Sub



	'//다이어리스크립트생성
    public Sub ftoday_diary()
        dim sqlStr
        sqlStr = "select top "& frecttop &"" +vbcrlf
		sqlStr = sqlStr & " a.idx,a.imagepath,a.linkpath,a.evt_code,a.regdate,a.poscode,a.isusing,a.image_order" + vbcrlf
		sqlStr = sqlStr & " ,b.imagecount,b.posname,b.imagewidth,b.imageheight, a.viewdate" + vbcrlf
		sqlStr = sqlStr & " from db_diary2010.dbo.tbl_diary_poscode_image a" + vbcrlf
		sqlStr = sqlStr & " left join db_diary2010.dbo.tbl_diary_poscode b" + vbcrlf
        sqlStr = sqlStr & " on a.poscode = b.poscode"   + vbcrlf
        sqlStr = sqlStr & " where a.idx = "& FRectIdx&"" + vbcrlf

        'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new cdiary_oneitem

        if Not rsget.Eof then

			FOneItem.fidx = rsget("idx")
			FOneItem.fimagepath = db2html(rsget("imagepath"))
			FOneItem.flinkpath = db2html(rsget("linkpath"))
			FOneItem.fevt_code = rsget("evt_code")
			FOneItem.fregdate = rsget("regdate")
			FOneItem.fimagecount = rsget("imagecount")
			FOneItem.fimage_order = rsget("image_order")
			FOneItem.fposcode = rsget("poscode")
			FOneItem.fposname = rsget("posname")
			FOneItem.fimagewidth = rsget("imagewidth")
			FOneItem.fimageheight = rsget("imageheight")
			FOneItem.fusedate = rsget("viewdate")

        end if
        rsget.Close
    end Sub
    
    
    
	'//ver.2 index 엠디픽 xml 생성
    public Sub ftoday_diary_xml()
        dim sqlStr
        sqlStr = "select top 5 " +vbcrlf
		sqlStr = sqlStr & " a.idx,a.imagepath,a.linkpath,a.evt_code,a.regdate,a.poscode,a.isusing,a.image_order" + vbcrlf
		sqlStr = sqlStr & " ,b.imagecount,b.posname,b.imagewidth,b.imageheight, a.viewdate" + vbcrlf
		sqlStr = sqlStr & " from db_diary2010.dbo.tbl_diary_poscode_image a" + vbcrlf
		sqlStr = sqlStr & " left join db_diary2010.dbo.tbl_diary_poscode b" + vbcrlf
        sqlStr = sqlStr & " on a.poscode = b.poscode"   + vbcrlf
        sqlStr = sqlStr & " where a.poscode = '" & FRectPoscode & "' and a.isusing = 'Y' "   + vbcrlf
        sqlStr = sqlStr & " order by a.image_order desc, a.idx asc " + vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		rsget.pagesize = FPageSize
		ftotalcount = rsget.recordcount
		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		'FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(ftotalcount)

		FPageCount = FCurrPage - 1
		i = 0
		if  not rsget.EOF  then
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).fidx = rsget("idx")
				FItemList(i).fimagepath = db2html(rsget("imagepath"))
				FItemList(i).flinkpath = db2html(rsget("linkpath"))
				FItemList(i).fevt_code = rsget("evt_code")
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fimagecount = rsget("imagecount")
				FItemList(i).fimage_order = rsget("image_order")
				FItemList(i).fposcode = rsget("poscode")
				FItemList(i).fposname = rsget("posname")
				FItemList(i).fimagewidth = rsget("imagewidth")
				FItemList(i).fimageheight = rsget("imageheight")
				FItemList(i).fusedate = rsget("viewdate")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
    end Sub
    
    
    
	'//ver.2 index 엠디픽 xml 생성
    public Sub fmakemdpickxml()
        dim sqlStr

        sqlStr = "SELECT TOP 18 " +vbcrlf
        sqlStr = sqlStr & " 	d.itemid, i.itemname, i.listImage, i.listImage120, i.icon1Image, i.sellcash, " +vbcrlf
        sqlStr = sqlStr & " 	i.orgprice, i.sailyn, i.regdate, i.itemcouponyn, i.limityn, i.itemcouponvalue, i.itemcoupontype " +vbcrlf
		sqlStr = sqlStr & " FROM [db_diary2010].[dbo].[tbl_DiaryMaster] AS d " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_item].[dbo].[tbl_item] AS i ON d.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & " WHERE d.mdpick = 'o' AND d.isUsing = 'Y' ORDER BY d.mdpicksort DESC, d.diaryID DESC " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		rsget.pagesize = FPageSize
		ftotalcount = rsget.recordcount
		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		'FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(ftotalcount)

		FPageCount = FCurrPage - 1
		i = 0
		if  not rsget.EOF  then
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).Fitemid       = rsget("itemid")
				FItemList(i).FitemName   = db2html(rsget("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
				FItemList(i).FOrgprice = rsget("orgprice")
				FItemList(i).FSaleyn = rsget("sailyn")
				FItemList(i).FSellCash = rsget("sellcash")

				FItemList(i).Fitemcouponyn = rsget("itemcouponyn")
				FItemList(i).Fitemcouponvalue = rsget("itemcouponvalue")
				FItemList(i).Fitemcoupontype = rsget("itemcoupontype")
				FItemList(i).Flimityn = rsget("limityn")

				if datediff("d",rsget("regdate"),Now()) < 14 then
					FItemList(i).FNewitem = "Y"
				else
					FItemList(i).FNewitem = "N"
				end if

				if IsNULL(FItemList(i).FImageList120) then  FItemList(i).FImageList120 = ""

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
    end Sub
    

 	'//사은품 증정 여부
	Public Function getGiftDiaryExists(itemid)

		dim tmpSQL,i
		dim blnTF

		tmpSQL = "Execute [db_item].[dbo].[sp_Ten_GiftDiaryExists] @vItemid = " & itemid

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

	Public Sub getOneplusOneDiaryExists()

		dim sqlStr,i

        sqlStr = "SELECT top 1 (A.giftkind_limit - A.giftkind_givecnt) as giftsu, B.image1, B.image2, B.itemid " +vbcrlf
        sqlStr = sqlStr & " FROM db_event.dbo.tbl_gift A " +vbcrlf
        sqlStr = sqlStr & " 	JOIN db_event.dbo.tbl_eventitem C on A.evt_code = C.evt_code " +vbcrlf
		sqlStr = sqlStr & " 	JOIN db_diary2010.dbo.tbl_OneplusOne B on B.itemid = C.itemid " +vbcrlf
		sqlStr = sqlStr & " 		where getdate() >  B.startdate " +vbcrlf
'		sqlStr = sqlStr & " 			and A.giftkind_limit <> '0' " +vbcrlf
'		sqlStr = sqlStr & " 			and A.giftkind_limit <> A.giftkind_givecnt " +vbcrlf
'		sqlStr = sqlStr & " 			and A.gift_Using='Y' " +vbcrlf
'		sqlStr = sqlStr & " 			and A.gift_status=7 " +vbcrlf
		sqlStr = sqlStr & " 			and A.giftkind_type = '2' " +vbcrlf
		sqlStr = sqlStr & " 			and A.giftkind_limit='100' " +vbcrlf
		sqlStr = sqlStr & " 			and B.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & " 			order by B.startdate desc " +vbcrlf

		rsget.Open sqlStr, dbget, 1
		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then
				FOneItem.FGiftSu = rsget("giftsu")
				FOneItem.FImage1 = rsget("image1")
				FOneItem.FImage2 = rsget("image2")
				FOneItem.FItemid = rsget("itemid")
			End if
			rsget.close
	End Sub

	Public Sub getHotDiaryExists()

		dim sqlStr,i

        sqlStr = "SELECT top 1 image1, image2, itemid, startdate " +vbcrlf
        sqlStr = sqlStr & " FROM db_diary2010.dbo.tbl_OneplusOne " +vbcrlf
		sqlStr = sqlStr & " where getdate() > startdate " +vbcrlf
		sqlStr = sqlStr & " 	and isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & " order by startdate desc " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then
				FOneItem.FImage1 = rsget("image1")
				FOneItem.FImage2 = rsget("image2")
				FOneItem.FItemid = rsget("itemid")
			End if
			rsget.close
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

	'2012 다이어리 - 이종화
	'1+1
	Public Sub getOneplusOneDaily()

		dim sqlStr,i

		sqlStr = "SELECT top 1 i.makerid 	,i.limitno	,i.limitsold	,i.itemname	,i.sailyn	,i.orgprice	,i.sailprice	,i.sellcash	,o.itemid	,o.image1	,o.image2	,o.imageend	,o.endlink	,o.explain , i.itemcouponyn ,i.sellyn , i.itemCouponValue , i.itemCouponType , c.socname " +vbcrlf
		sqlStr = sqlStr & " , o.Mimage1 , o. Mimage2 , o.Mimage1Link , o.Mimage2Link " +vbcrlf '모바일용 추가
		sqlStr = sqlStr & " FROM db_item.dbo.tbl_item as i  inner join db_diary2010.dbo.tbl_OneplusOne as o  on i.itemid = o.itemid " +vbcrlf
		sqlStr = sqlStr & " inner join db_user.dbo.tbl_user_c as c  on i.makerid = c.userid and c.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & " where convert(varchar(10),o.startdate ,120) <= convert(varchar(10),getdate(),120) " +vbcrlf
		sqlStr = sqlStr & " and o.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & " order by o.startdate desc " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then
				FOneItem.Fmakerid		= rsget("makerid")
				FOneItem.Flimitno		= rsget("limitno")
				FOneItem.Flimitsold		= rsget("limitsold")
				FOneItem.Fitemname	= rsget("itemname")
				FOneItem.Fsailyn			= rsget("sailyn")
				FOneItem.Forgprice		= rsget("orgprice")
				FOneItem.Fsailprice		= rsget("sailprice")
				FOneItem.Fsellcash		= rsget("sellcash")
				FOneItem.Fitemid			= rsget("itemid")

				IF application("Svr_Info") = "Dev" THEN
					FOneItem.FImage1 = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image1")
					FOneItem.FImage2 = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image2")
					FOneItem.Fimageend = "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("imageend")
					FOneItem.Mimage1			= "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("Mimage1")
					FOneItem.Mimage2			= "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("Mimage2")
				Else
					FOneItem.FImage1 = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image1")
					FOneItem.FImage2 = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("image2")
					FOneItem.Fimageend = "http://imgstatic.10x10.co.kr/diary/oneplusone/" & rsget("imageend")
					FOneItem.Mimage1			= "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("Mimage1")
					FOneItem.Mimage2			= "http://testimgstatic.10x10.co.kr/diary/oneplusone/" & rsget("Mimage2")
				End If

				FOneItem.Fendlink		= rsget("endlink")
				FOneItem.Fexplain		= rsget("explain")
				FOneItem.Fitemcouponyn		= rsget("itemcouponyn")
				FOneItem.Fsellyn			= rsget("sellyn")
				FOneItem.FItemcouponvalue	= rsget("itemCouponValue")
				FOneItem.FItemcoupontype	= rsget("itemCouponType")
				FOneItem.Fsocname		= rsget("socname")

				FOneItem.Mimage1Link	= rsget("Mimage1Link")
				FOneItem.Mimage2Link	= rsget("Mimage2Link")
			End if
			rsget.close
	End Sub
	'다이어리 카운트 -_-;;
	Public Sub getDiaryCateCnt()

		dim sqlStr

		sqlStr = "SELECT " +vbcrlf
		sqlStr = sqlStr & " 	 count(*) as totcnt " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 10 then d.cate end) as num1 " +vbcrlf '이벤트 합
		sqlStr = sqlStr & " 	,count(case when d.cate = 20 then d.cate end) as num2 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 30 then d.cate end) as num3 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when d.cate = 40 then d.cate end) as num4 " +vbcrlf
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
		sqlStr = sqlStr & " from db_diary2010.dbo.tbl_diary_brandstory_2012 as M inner join [db_user].[dbo].tbl_user_c as C on M.makerid = C.userid where M.isusing = 'Y' and C.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "		union all " +vbcrlf
		sqlStr = sqlStr & " select  " +vbcrlf
		sqlStr = sqlStr & " 	 count(*) as totcnt " +vbcrlf
		sqlStr = sqlStr & " 	 ,count(case when m.cate = 10 then m.cate end) as num1 " +vbcrlf '상품 합
		sqlStr = sqlStr & " 	,count(case when m.cate = 20 then m.cate end) as num2 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 30 then m.cate end) as num3 " +vbcrlf
		sqlStr = sqlStr & " 	,count(case when m.cate = 40 then m.cate end) as num4 " +vbcrlf
		sqlStr = sqlStr & " from [db_diary2010].dbo.tbl_DiaryMaster AS M  " +vbcrlf
		sqlStr = sqlStr & " INNER JOIN [db_item].[dbo].[tbl_item] AS i   " +vbcrlf
		sqlStr = sqlStr & " ON m.itemid = i.itemid  " +vbcrlf
		sqlStr = sqlStr & " where m.isusing = 'Y' and i.Sellyn in ('Y') " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
		Ftotalcount = rsget.recordcount

		redim preserve FItemList(ftotalcount)
		IF  not rsget.EOF  Then
			
			Do Until rsget.eof
				set FItemList(i) = new cdiary_oneitem
				FItemList(i).Fdiarytotcnt   = rsget("totcnt")
				FItemList(i).FdiaryCount1 = rsget("num1") '심플
				FItemList(i).FdiaryCount2 = rsget("num2") '일러스트
				FItemList(i).FdiaryCount3 = rsget("num3") '패턴
				FItemList(i).FdiaryCount4 = rsget("num4") '포토

				i=i+1
				rsget.Movenext
			Loop
		End If
		rsget.close
	End Sub

	'다이어리 아이템 리스트
	public Sub getDiaryItemLIst()
		Dim sqlStr ,i , vari , vartmp, vOrderBy

		If frectcontents <> "" Then
			frectcontents = Replace(frectcontents,"'","|")
			frectcontents = Left(frectcontents,Len(frectcontents)-1)
		End IF

		sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_Cnt] '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', " & FPageSize & " "

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
			FTotalCount = rsget("Totalcnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		If FTotalCount > 0 Then
			If ftectSortMet = "newitem" Then
				vOrderBy = " ORDER BY d.mdpicksort DESC, d.diaryID DESC"
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
			Else
				If fmdpick = "o" Then
					vOrderBy = " ORDER BY d.mdpicksort DESC, d.diaryID DESC"
				Else
					vOrderBy = " ORDER BY d.diaryID DESC"
				End IF
			End If
	
	
			sqlStr = " EXECUTE [db_diary2010].[dbo].[sp_Ten_Diary_Search_List_2012] '" & Cstr(FPageSize * FCurrPage) & "', '" & frectdesign & "', '" & frectcontents & "', '" & frectkeyword & "', '" & fmdpick & "', '" & vOrderBy & "', '"& fuserid &"' "
	
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			'response.write sqlStr & "<br>"
			rsget.Open sqlStr, dbget
			rsget.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			FTotalPage = (FTotalCount\FPageSize)
	
			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
	
			redim preserve FItemList(FResultCount)
	
			FPageCount = FCurrPage - 1
			if  not rsget.EOF  then
				rsget.absolutePage=FCurrPage
				do until rsget.eof
					set FItemList(i) = new cdiary_oneitem
	
						FItemList(i).fdiaryid			= rsget("diaryid")
						FItemList(i).FCateName 			= rsget("Cate")
						FItemList(i).FItemid			= rsget("Itemid")
						FItemList(i).FDiaryBasicImg		= "http://webimage.10x10.co.kr/diary_collection/2012/basic/" & rsget("BasicImg")
						FItemList(i).FDiaryBasicImg2	= "http://webimage.10x10.co.kr/diary_collection/2012/basic2/" & rsget("BasicImg2")
						FItemList(i).FStoryImg		= "http://webimage.10x10.co.kr/diary_collection/2012/story/" & rsget("StoryImg")
						FItemList(i).FImageicon1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
						FItemList(i).FItemName			= db2html(rsget("ItemName"))
						FItemList(i).FSellCash			= rsget("SellCash")
						FItemList(i).FOrgPrice			= rsget("OrgPrice")
						FItemList(i).FMakerId			= rsget("MakerId")
						FItemList(i).FBrandName			= db2html(rsget("BrandName"))
						FItemList(i).FSellyn			= rsget("sellYn")
						FItemList(i).FSaleyn			= rsget("SaleYn")
						FItemList(i).FLimityn			= rsget("LimitYn")
						FItemList(i).FLimitNo			= rsget("LimitNo")
						FItemList(i).FLimitSold			= rsget("LimitSold")
						FItemList(i).FDeliverytype		= rsget("deliveryType")
						FItemList(i).FItemcouponyn		= rsget("itemcouponYn")
						FItemList(i).FItemcouponvalue	= rsget("itemCouponValue")
						FItemList(i).FItemcoupontype	= rsget("itemCouponType")
						FItemList(i).FEvalcnt			= rsget("evalCnt")
						FItemList(i).FItemDiv			= rsget("itemdiv")
						FItemList(i).FImageicon2		= "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")	
						FItemList(i).Fsocname		= rsget("socname")
						If fuserid <> "" then
							FItemList(i).Fuserid			= rsget("userid")
						End If 
					i=i+1
					rsget.moveNext
				loop
			end if
	
			rsget.Close
		End If
	end Sub

	'//다이어리 스토리 브랜드 - 브랜드리스트 하단
	Public Sub getDiaryStroyBrand_Kor()

		dim sqlStr , vAddwhere

		'viewlist 지난이벤트 리스트
		If Fbrandview = "Y" then
			vAddwhere = " and M.content_title <> ''  "
		End If 

		sqlStr = "SELECT M.makerid , C.socname_kor , M.idx , M.content_title " +vbcrlf
		sqlStr = sqlStr & " FROM " +vbcrlf 
		sqlStr = sqlStr & " db_diary2010.dbo.tbl_diary_brandstory_2012 as M " +vbcrlf
		sqlStr = sqlStr & " inner join " +vbcrlf
		sqlStr = sqlStr & " [db_user].[dbo].tbl_user_c as C " +vbcrlf
		sqlStr = sqlStr & " on M.makerid = C.userid " +vbcrlf
		sqlStr = sqlStr & " where M.isusing = 'Y' and C.isusing = 'Y' " & vAddwhere & +vbcrlf
		sqlStr = sqlStr & " order by c.socname_kor asc " +vbcrlf
		
		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
		Ftotalcount = rsget.recordcount

		redim preserve FItemList(ftotalcount)

		i=0

		IF  not rsget.EOF  Then
			Do Until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).FMakerId			= rsget("makerid")
				FItemList(i).Fsocname_kor		= rsget("socname_kor") 
				FItemList(i).Fidx					= rsget("idx")
				FItemList(i).Fcontent_title		= rsget("content_title")

				i=i+1
				rsget.Movenext
			Loop
		End If
		rsget.close
	End Sub
	'브랜드리스트
	public Sub getBrandStoryLIst()
		Dim sqlStr ,i , vOrderBy ,vAddwhere

		sqlStr = " select  " +vbcrlf
		sqlStr = sqlStr & " count(*) as totcnt , CEILING(CAST(Count(*) AS FLOAT)/ "& FPageSize &" ) as totPg " +vbcrlf 
		sqlStr = sqlStr & " from   " +vbcrlf 
		sqlStr = sqlStr & " db_diary2010.dbo.tbl_diary_brandstory_2012 as M " +vbcrlf 
		sqlStr = sqlStr & " inner join  " +vbcrlf 
		sqlStr = sqlStr & " db_user.[dbo].tbl_user_c as C " +vbcrlf 
		sqlStr = sqlStr & " on M.makerid = C.userid " +vbcrlf 
		sqlStr = sqlStr & " left outer join db_const.dbo.tbl_const_brandbest as B on M.makerid = B.designerid " +vbcrlf 
		sqlStr = sqlStr & " where M.isusing = 'Y' and C.isusing = 'Y' " +vbcrlf 
		
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
			FTotalCount = rsget("totcnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end If

		If FTotalCount > 0 Then
			If ftectSortMet = "new" Then
				vOrderBy = " order by M.sorting asc "
			ElseIf ftectSortMet = "best" Then
				vOrderBy = " order by B.favsum desc "
			ElseIf ftectSortMet = "like" Then
				vOrderBy = " order by C.hitrank desc "
			End If 
			
			sqlStr = " select  top "& Cstr(FPageSize * FCurrPage) & +vbcrlf
			sqlStr = sqlStr & " M.idx,M.makerid,M.list_mainimg,M.list_titleimg,M.list_text,M.list_spareimg,M.content_title,M.content_html,M.sorting	,B.favsum	,C.hitrank  " +vbcrlf 
			sqlStr = sqlStr & " from   " +vbcrlf 
			sqlStr = sqlStr & " db_diary2010.dbo.tbl_diary_brandstory_2012 as M " +vbcrlf 
			sqlStr = sqlStr & " inner join  " +vbcrlf 
			sqlStr = sqlStr & " db_user.[dbo].tbl_user_c as C " +vbcrlf 
			sqlStr = sqlStr & " on M.makerid = C.userid " +vbcrlf 
			sqlStr = sqlStr & " left outer join db_const.dbo.tbl_const_brandbest as B on M.makerid = B.designerid " +vbcrlf 
			sqlStr = sqlStr & " where M.isusing = 'Y' and C.isusing = 'Y' " & vOrderBy & +vbcrlf 
	
			'response.write sqlStr & "<br>"
			rsget.Open sqlStr, dbget
			rsget.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			FTotalPage = (FTotalCount\FPageSize)
	
			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

			redim preserve FItemList(FResultCount)

			FPageCount = FCurrPage - 1
			
			if  not rsget.EOF  then
				rsget.absolutePage=FCurrPage
				i=0
				do until rsget.eof
						set FItemList(i) = new cdiary_oneitem

						FItemList(i).fidx						= rsget("idx")
						FItemList(i).Fmakerid				= rsget("makerid")
						FItemList(i).Flist_mainimg		= rsget("list_mainimg")
						FItemList(i).Flist_titleimg		= rsget("list_titleimg")
						FItemList(i).Flist_text				= rsget("list_text")
						FItemList(i).Flist_spareimg		= rsget("list_spareimg")
						FItemList(i).Fcontent_title		= rsget("content_title")
						FItemList(i).Fcontent_html	= rsget("content_html")
						FItemList(i).Fsorting				= rsget("sorting")
						FItemList(i).Ffavsum				= rsget("favsum")
						FItemList(i).Fhitrank				= rsget("hitrank")
						
					i=i+1
					rsget.moveNext
				loop
			end if
	
			rsget.Close
		End If
	end Sub

	'//다이어리 스토리 브랜드아이템 - 브랜드리스트 중간 삽입 
	Public Sub getBrandStoryLIstItem()

		dim sqlStr 

		sqlStr = "SELECT m.itemid , m.basicimg2 , I.itemname " +vbcrlf
		sqlStr = sqlStr & " FROM " +vbcrlf 
		sqlStr = sqlStr & " db_diary2010.dbo.tbl_DiaryMaster as M " +vbcrlf
		sqlStr = sqlStr & " inner join " +vbcrlf
		sqlStr = sqlStr & " db_item.dbo.tbl_item as I " +vbcrlf
		sqlStr = sqlStr & " on M.itemid = I.itemid " +vbcrlf
		sqlStr = sqlStr & " where M.isusing = 'Y' and I.makerid = '"& FMakerId & "' " & +vbcrlf
		sqlStr = sqlStr & " order by M.itemid desc " +vbcrlf
		
		'response.write sqlStr
		rsget.Open sqlStr,dbget
		Ftotalcount = rsget.recordcount

		redim preserve FItemList(ftotalcount)

		Dim i : i = 0
		IF  not rsget.EOF  Then
			Do Until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).Fitemid = rsget("itemid") 
				FItemList(i).FDiaryBasicImg2	= "http://webimage.10x10.co.kr/diary_collection/2012/basic2/" & rsget("BasicImg2")
				FItemList(i).Fitemname = db2html(rsget("ItemName"))

				i=i+1
				rsget.Movenext
			Loop
		End If
		rsget.close
	End Sub
	'인터뷰 내용
	Public Sub getOnebrandInterview()

		dim sqlStr,i

		sqlStr = "SELECT top 1 m.idx , m.content_title , m.content_html  " +vbcrlf
		sqlStr = sqlStr & " FROM db_diary2010.dbo.tbl_diary_brandstory_2012 as M inner join [db_user].[dbo].tbl_user_c as C on M.makerid = C.userid  " +vbcrlf
		sqlStr = sqlStr & " where M.isusing = 'Y' and C.isusing = 'Y'  " +vbcrlf
		sqlStr = sqlStr & " and M.idx = '"& Fidx &"' " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then

				FOneItem.Fidx						= rsget("idx")
				FOneItem.Fcontent_title		= rsget("content_title")
				FOneItem.Fcontent_html		= rsget("content_html")
				
			End if
			rsget.close
	End Sub


	'//다이어리 모바일 _ 메인 리스트 2012-11-23
	Public Sub getCateDiaryList()

		dim sqlStr
		sqlStr = " select diaryid , cate , itemid , regdate , icon1image from " +vbcrlf
		sqlStr = sqlStr & "	( " +vbcrlf
		sqlStr = sqlStr & "		select top 4 m.diaryid , m.cate , m.itemid , m.regdate , i.icon1image from " +vbcrlf
		sqlStr = sqlStr & "db_diary2010.dbo.tbl_diaryMaster as m " +vbcrlf
		sqlStr = sqlStr & "	inner join  " +vbcrlf
		sqlStr = sqlStr & "	db_item.dbo.tbl_item as i " +vbcrlf
		sqlStr = sqlStr & "	on m.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & "	where m.isusing = 'Y' and i.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "	and m.cate = 10  " +vbcrlf
		sqlStr = sqlStr & "	order by m.regdate desc " +vbcrlf
		sqlStr = sqlStr & ") as T " +vbcrlf
		sqlStr = sqlStr & "union all " +vbcrlf
		sqlStr = sqlStr & "select diaryid , cate , itemid , regdate , icon1image from " +vbcrlf
		sqlStr = sqlStr & "( " +vbcrlf 
		sqlStr = sqlStr & "	select top 4 m.diaryid , m.cate , m.itemid , m.regdate , i.icon1image from " +vbcrlf
		sqlStr = sqlStr & "	db_diary2010.dbo.tbl_diaryMaster as m " +vbcrlf
		sqlStr = sqlStr & "	inner join  " +vbcrlf
		sqlStr = sqlStr & "	db_item.dbo.tbl_item as i " +vbcrlf
		sqlStr = sqlStr & "	on m.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & "	where m.isusing = 'Y' and i.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "	and m.cate = 20  " +vbcrlf
		sqlStr = sqlStr & "	order by m.regdate desc  " +vbcrlf
		sqlStr = sqlStr & ") as T " +vbcrlf
		sqlStr = sqlStr & "union all " +vbcrlf
		sqlStr = sqlStr & "select diaryid , cate , itemid , regdate , icon1image from " +vbcrlf
		sqlStr = sqlStr & "( " +vbcrlf
		sqlStr = sqlStr & "	select top 4 m.diaryid , m.cate , m.itemid , m.regdate , i.icon1image from " +vbcrlf
		sqlStr = sqlStr & "	db_diary2010.dbo.tbl_diaryMaster as m " +vbcrlf
		sqlStr = sqlStr & "	inner join  " +vbcrlf
		sqlStr = sqlStr & "	db_item.dbo.tbl_item as i " +vbcrlf
		sqlStr = sqlStr & "	on m.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & "	where m.isusing = 'Y' and i.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "	and m.cate = 30  " +vbcrlf
		sqlStr = sqlStr & "	order by m.regdate desc  " +vbcrlf
		sqlStr = sqlStr & ") as T " +vbcrlf
		sqlStr = sqlStr & "union all " +vbcrlf
		sqlStr = sqlStr & "select diaryid , cate , itemid , regdate , icon1image from " +vbcrlf
		sqlStr = sqlStr & "( " +vbcrlf
		sqlStr = sqlStr & "	select top 4 m.diaryid , m.cate , m.itemid , m.regdate , i.icon1image from " +vbcrlf
		sqlStr = sqlStr & "	db_diary2010.dbo.tbl_diaryMaster as m " +vbcrlf
		sqlStr = sqlStr & "	inner join  " +vbcrlf
		sqlStr = sqlStr & "	db_item.dbo.tbl_item as i " +vbcrlf
		sqlStr = sqlStr & "	on m.itemid = i.itemid " +vbcrlf
		sqlStr = sqlStr & "	where m.isusing = 'Y' and i.isusing = 'Y' " +vbcrlf
		sqlStr = sqlStr & "	and m.cate = 40  " +vbcrlf
		sqlStr = sqlStr & "	order by m.regdate desc " +vbcrlf
		sqlStr = sqlStr & ") as T " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
		Ftotalcount = rsget.recordcount

		redim preserve FItemList(ftotalcount)

		i=0

		IF  not rsget.EOF  Then
			Do Until rsget.eof
				set FItemList(i) = new cdiary_oneitem

				FItemList(i).FDiaryId				= rsget("diaryid")
				FItemList(i).FCate					= rsget("cate") 
				FItemList(i).FItemid				= rsget("itemid")
				FItemList(i).FImageicon1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
				FItemList(i).FRegdate			= rsget("regdate")

				i=i+1
				rsget.Movenext
			Loop
		End If
		rsget.close
	End Sub

	'//다이어리 모바일 _ 브랜드스토리 Row 2012-11-23
	Public Sub getOnebrand()

		dim sqlStr,i

		sqlStr = " select b.idx , b.makerid  , C.socname_kor , b.list_mainimg , b.list_text  from " +vbcrlf
		sqlStr = sqlStr & " db_diary2010.dbo.tbl_diary_brandstory_2012 as b " +vbcrlf
		sqlStr = sqlStr & " inner join  " +vbcrlf
		sqlStr = sqlStr & " db_user.[dbo].tbl_user_c as C " +vbcrlf
		sqlStr = sqlStr & " on b.makerid = C.userid " +vbcrlf
		sqlStr = sqlStr & " and b.idx = '"& Fidx &"' " +vbcrlf

		'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		set FOneItem = new cdiary_oneitem
			If Not rsget.EOF Then

				FOneItem.Fidx						= rsget("idx")
				FOneItem.Fmakerid				= rsget("makerid")
				FOneItem.Fsocname_kor		= rsget("socname_kor")
				FOneItem.Flist_mainimg		= rsget("list_mainimg")
				FOneItem.Flist_text				= rsget("list_text")
				
			End if
			rsget.close
	End Sub

	'//다이어리 모바일 _ 브랜드스토리 list 2012-11-23
	public Sub getOnebrandList()
		Dim sqlStr ,i , vOrderBy ,vAddwhere

		sqlStr = "SELECT count(*) as totcnt , CEILING(CAST(Count(*) AS FLOAT)/ "& FPageSize &" ) as totPg " +vbcrlf
		sqlStr = sqlStr & " FROM " +vbcrlf 
		sqlStr = sqlStr & " db_diary2010.dbo.tbl_DiaryMaster as M " +vbcrlf
		sqlStr = sqlStr & " inner join " +vbcrlf
		sqlStr = sqlStr & " db_item.dbo.tbl_item as I " +vbcrlf
		sqlStr = sqlStr & " on M.itemid = I.itemid " +vbcrlf
		sqlStr = sqlStr & " where M.isusing = 'Y' and I.makerid = '"& FMakerId & "' " & +vbcrlf
		
		'response.write sqlStr & "<br>"
		rsget.Open sqlStr, dbget
			FTotalCount = rsget("totcnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end If

		If FTotalCount > 0 Then
			If ftectSortMet = "newitem" Then
				vOrderBy = " ORDER BY m.mdpicksort DESC, m.diaryID DESC"
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
			End If 
					
			sqlStr = "SELECT top "& Cstr(FPageSize * FCurrPage) & +vbcrlf
			sqlStr = sqlStr & " m.itemid , i.icon1image  " +vbcrlf
			sqlStr = sqlStr & " FROM " +vbcrlf 
			sqlStr = sqlStr & " db_diary2010.dbo.tbl_DiaryMaster as M " +vbcrlf
			sqlStr = sqlStr & " inner join " +vbcrlf
			sqlStr = sqlStr & " db_item.dbo.tbl_item as I " +vbcrlf
			sqlStr = sqlStr & " on M.itemid = I.itemid " +vbcrlf
			sqlStr = sqlStr & " where M.isusing = 'Y' and I.makerid = '"& FMakerId & "'" & vOrderBy & +vbcrlf

			'response.write sqlStr & "<br>"
			rsget.Open sqlStr, dbget
			rsget.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			FTotalPage = (FTotalCount\FPageSize)
	
			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

			redim preserve FItemList(FResultCount)

			FPageCount = FCurrPage - 1
			
			if  not rsget.EOF  then
				rsget.absolutePage=FCurrPage
				i=0
				do until rsget.eof
						set FItemList(i) = new cdiary_oneitem

						FItemList(i).fitemid				= rsget("itemid")
						FItemList(i).FImageicon1		= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
						
					i=i+1
					rsget.moveNext
				loop
			end if
	
			rsget.Close
		End If
	end Sub

end Class

'// 기억 메뉴 - 2011 다이어리 선택된것 bestview로 사용
Function updatebestview(itemid,plusminus)

dim sql
sql = "update db_diary2010.dbo.tbl_DiaryMaster set bestview = bestview " & plusminus & " 1 where ItemID = "& itemid &""
dbget.execute sql

End Function



Function TwoNumber(number)
	Dim vNumber
	If len(number) = 1 Then
		vNumber = "0" & number
	Else
		vNumber = number
	End If
	TwoNumber = vNumber
End Function
	
	
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
			getcheckedcolorclass =  "selected"
			Exit Function
		end if

	next

end Function



Function GreatestCheck(t1,t2,t3,t4,t5,t6,t7)
	Dim i, vTopStr, vTopCnt
	vTopCnt = t7
	vTopStr = 7
	
	For i=6 To 1 Step -1
		If CDbl(vTopCnt) > CDbl(Eval("t"&i)) Then
		Else
			vTopCnt = Eval("t"&(i))
			vTopStr = i
		End If
	Next
	vTopCnt = t1 + t2 + t3 + t4 + t5 + t6 + t7
	GreatestCheck = vTopCnt & "|" & vTopStr
End Function

'// 다이어리 1+1, 1:1 구분
Function getDiaryoneandonegubun(itemid)
	Dim strsql

	strSQL = " Select top 1 plustype "
	strSQL = strSQL & " from [db_diary2010].[dbo].[tbl_OneplusOne] "
	strSQL = strSQL & " Where isusing='Y' And convert(varchar(10),startdate ,120) <= convert(varchar(10),getdate(),120) And itemid='"& itemid &"' "
	strSQL = strSQL & " order by startdate desc "
	rsget.Open strSQL, dbget, 1
	If Not rsget.EOF Then
		getDiaryoneandonegubun = rsget(0)
	Else
		getDiaryoneandonegubun = ""
	End If
	rsget.close
End Function

Function getDiaryoneandonegubun2(itemid)
	Dim strsql

	strSQL = " Select top 1 plustype, convert(varchar(10),startdate ,120) "
	strSQL = strSQL & " from [db_diary2010].[dbo].[tbl_OneplusOne] "
	strSQL = strSQL & " Where isusing='Y' And convert(varchar(10),startdate ,120) <= convert(varchar(10),getdate(),120) And itemid='"& itemid &"'"
	strSQL = strSQL & " order by startdate desc "
	rsget.Open strSQL, dbget, 1
	If Not rsget.EOF Then
		getDiaryoneandonegubun2 = rsget(0) & "||" & rsget(1)
	Else
		getDiaryoneandonegubun2 = ""
	End If
	rsget.close
End Function
%>
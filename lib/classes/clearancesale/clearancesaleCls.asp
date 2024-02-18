<%
'###########################################################
' Description : 클리어런스 세일 클래스
' Hieditor : 2016.01.25 유태욱 생성
'###########################################################
%>
<%
class CClearancesaleItem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

end class

class CClearancesalelist
	dim FTenOnlyYn

	public FItemList()
	public Fitemid
	public FItemName
	public FSellCash
	public FOrgPrice
	public FBrandName
	public FSellyn
	public FSaleyn
	public FLimitNo
	public FLimityn
	public FLimitSold
	public Fregdate
	public FReipgodate
	public FItemcouponyn
	public FItemCouponValue
	public FItemCouponType
	public FItemScore
	public FImageList
	public FImageList120
	public FImageSmall
	public FImageIcon1
	public FImageicon2
	public FItemSize
	public Fitemdiv
	public FImageBasic
'	public FImageBasic600
	public Fmakerid
	public FEvalCnt
	Public FIsusing
	public FCurrPage
	public FPageSize
	public FPageCount
	public FTotalPage
	public FTotalCount
	public FScrollCount
	public FResultCount
	public FItemArr
	public FFavCount
	public FRectSortMethod
	public FminPrice
	public FmaxPrice
	public FRectCateCode	'카테고리 코드
	public FdeliType1		'무료배송 (업체무료 : 2, 텐배무료 : 4 )
	public FdeliType2		'텐배배송 (텐배 : 1 )
	public Fpojangok		'포장상품여부
	public FmaxSalePercent	'최대 세일 %
	public FLowStockcnt		'매진임박상품(한정30개이하)
	public FLimitedLowStock
	public FSpecialUserItem
	public Fmaxidx
	public Fbestitem
	public Fnowsellitemcnt
	public Fnewsellregdate

	'// 해외직구배송작업추가
	Public FDeliverFixDay

	Public FPoints '별점
	public FAdultType

	Private Sub Class_Initialize()
		FCurrPage = 1
		FPageSize = 50
		Fbestitem = 0
		FTotalCount = 0
		FLowStockcnt = 0
		FResultCount = 0
		FScrollCount = 10
		FmaxSalePercent = 0
		FLimitedLowStock = 0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'// 우수회원샵 상품 여부
	public Function IsSpecialUserItem() '!
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

	'// 세일포함 실제가격
	public Function getRealPrice() '!
		getRealPrice = FSellCash

		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function

	'// 할인율 '!
	public Function getSalePro()
		if FOrgprice=0 then
			getSalePro = 0 & "%"
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"
		end if
	end Function

	'//품절여부
	public Function IsSoldOut()
		'isSoldOut = (FSellYn="N")
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

	'//세일상품여부
 	public Function IsSaleItem() '!
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

 	'// 상품 쿠폰 여부
	public Function IsCouponItem() '!
			IsCouponItem = (FItemCouponYN = "Y")
	end Function

	'//	한정 여부 '!
	public Function IsLimitItem()
			IsLimitItem= (FLimitYn="Y")
	end Function

	'// 텐바이텐 포장가능 상품 여부
	public Function IsPojangitem()
		IsPojangitem = (FPojangOk="Y")
	end Function

	'// 텐바이텐 독점상품 여부 '!
	public Function IsTenOnlyitem()
		IsTenOnlyitem = (FTenOnlyYn="Y")
	end Function

	'// 신상품 여부 '!
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 무료 배송 쿠폰 여부 '?
	public function IsFreeBeasongCoupon()
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function

	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (IsCouponItem) then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function

	'// 마일리지샵 아이템 여부 '!
	public Function IsMileShopitem() 
		IsMileShopitem = (FItemDiv="82")
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
	end Function
	
	'// 해외 직구 배송 여부 2018-02-06 이종화 - LIST (중복인데...)
	'// 해외직구배송작업추가
	Public Function IsDirectPurchase()
		IsDirectPurchase = False
		if (FDeliverFixDay = "G") Then
			IsDirectPurchase = true
		End if
	End Function

	''클리어런스 상품 리스트
	public Sub fnGetClearancesaleList
		dim sqlStr, sqlsearch, i, vOrderBy

'		'카테고리
'		if FRectCateCode<>"" then
'			sqlsearch = sqlsearch & " and i.dispcate1='" & FRectCateCode & "'"
'		end if

		'상품 총 갯수 구하기
		sqlStr = "exec [db_sitemaster].[dbo].[sp_Ten_clearance_list_cnt] '"&FminPrice&"', '"&FmaxPrice&"', '"&FRectCateCode&"', '"&FdeliType1&"', '"&FdeliType2&"', '"&Fpojangok&"', "&FPageSize&""

		'response.write sqlStr
		'response.end

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIAW",sqlStr,180)
        if (rsMem is Nothing) then Exit Sub ''추가
			Fmaxidx = rsMem("idx")
			FTotalCount = rsMem("cnt")
			FTotalPage = rsMem("totPg")
		rsMem.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		If FTotalCount > 0 Then
			if FRectSortMethod="ne" then						''신상순
				vOrderBy = vOrderBy & " order by i.itemid desc"
			elseif FRectSortMethod="be" then					''인기순
				vOrderBy = vOrderBy & " order by i.itemscore desc"
			elseif FRectSortMethod="lp" then					''낮은가격순
				vOrderBy = vOrderBy & " order by i.sellcash asc"
			elseif FRectSortMethod="hp" then					''높은가격순
				vOrderBy = vOrderBy & " order by i.sellcash desc"
			elseif FRectSortMethod="hs" then					''할인율순
				vOrderBy = vOrderBy & " order by SalePercent desc"
			elseif FRectSortMethod="hisale" then				''높은할인율순
				vOrderBy = vOrderBy & " order by SalePercent desc"
			elseif FRectSortMethod="lowsale" then				''낮은할인율순
				vOrderBy = vOrderBy & " order by SalePercent asc"
			else
				vOrderBy = vOrderBy & " order by i.itemid desc"
			end if

			'데이터 리스트
			sqlStr = " EXECUTE [db_sitemaster].[dbo].[sp_Ten_clearance_list] '" & Cstr(FPageSize * FCurrPage) & "', '"&FminPrice&"', '"&FmaxPrice&"', '"&FRectCateCode&"', '"&FdeliType1&"', '"&FdeliType2&"', '"&Fpojangok&"', "&Fmaxidx&", '"&vOrderBy&"' "

			'response.write sqlStr
			'response.end

			set rsMem = getDBCacheSQL(dbget,rsMem,"DIAW",sqlStr,180)
	        if (rsMem is Nothing) then Exit Sub ''추가

			rsMem.pagesize = FPageSize
			
			FResultCount = rsMem.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			if  not rsMem.EOF  then
				rsMem.absolutePage=FCurrPage
				do until rsMem.eof
					set FItemList(i) = new CClearancesalelist
	
					FItemList(i).Fitemid			= rsMem("itemid")
					FItemList(i).FSellYn			= rsMem("sellyn")
					FItemList(i).FSaleYn     		= rsMem("sailyn")
					FItemList(i).FRegdate 			= rsMem("regdate")
					FItemList(i).Fevalcnt 			= rsMem("evalCnt")
					FItemList(i).FItemSize			= rsMem("evalCnt")
					FItemList(i).Ffavcount			= rsMem("favcount")
					FItemList(i).Fitemdiv			= rsMem("itemdiv")
					FItemList(i).FLimitYn			= rsMem("limityn")
					FItemList(i).FLimitNo			= rsMem("limitno")
					FItemList(i).FSellcash			= rsMem("sellcash")
					FItemList(i).FOrgPrice			= rsMem("orgprice")
					FItemList(i).FitemScore 		= rsMem("itemScore")
					FItemList(i).FLimitSold			= rsMem("limitsold")
					FItemList(i).FReipgodate		= rsMem("reipgodate")
	                FItemList(i).Fitemcouponyn 		= rsMem("itemcouponYn")
					FItemList(i).Fitemcoupontype	= rsMem("itemCouponType")
					FItemList(i).FLimitedLowStock  	= rsMem("LimitedLowStock")
					FItemList(i).FItemCouponValue	= rsMem("itemCouponValue")
					FItemList(i).FItemName			= db2html(rsMem("itemname"))
					FItemList(i).FBrandName  		= db2html(rsMem("brandname"))
					FItemList(i).FImageList			= "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("listimage")
					FItemList(i).FImageList120		= "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("listimage120")
					FItemList(i).FImageSmall		= "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("smallImage")
					FItemList(i).FImageIcon1		= "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("icon1image")
					FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("icon2image")
					FItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("basicimage")
					FItemList(i).FPoints			= rsMem("totalpoint")
					FItemList(i).FAdultType			= rsMem("adultType")

					'// 해외배송직구작업추가
					FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

					i=i+1
					rsMem.moveNext
				loop
			end if
			rsMem.Close
			'response.write sqlStr &"<br>"
		end if
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
end class

%>
	
<%
'+-----------------------------------------------------------------------------------------------------------------+
'|                                             CWish Class 함 수 선 언                                             |
'+---------------------------------------+------+------------------------------------------------------------------+
'|                함 수 명               | Type |                          기    능                                |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getWisMatchUser()                     | Sub  | 나와 매치 수가 높은 회원 접수                                    |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getFollowUser()                       | Sub  | 내가 팔로우한 회원                                               |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getFollowUserList()                   | Sub  | 특정회원의 팔로잉/팔로워 목록                                    |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getCategoyWishUser()                  | Sub  | 카테고리-위시 회원                                               |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getRecentWishUser()                   | Sub  | 최근위시 회원 접수                                               |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getWishTrendUser()                    | Sub  | 위시트랜드 회원 접수                                             |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getWishUserFromItem()                 | Sub  | 특정 상품을 보유한 회원 접수(최근 업데이트 순)                   |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getWishCollectFromItem()              | Sub  | 특정 상품의 위시 컬렉션 (최근 업데이트 순, 회원 및 상품정보)     |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getWishItemListJson()                 | Func | 회원 위시 상품 접수(JSON OBJECT반환)                             |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getPopularWishListJson()              | Func | 인기 위시 상품 접수(JSON OBJECT반환)                             |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getBestSellerListJson()               | Func | Best Award - Best Seller 상품 접수(JSON OBJECT반환)              |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getBestWishListJson()                 | Func | Best Award - Best Wish 상품 접수(JSON OBJECT반환)                |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getUserInfo()                         | Sub  | 회원 정보 접수                                                   |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getUserBadgeListJson()                | Func | 회원 뱃지 목록 접수(JSON OBJECT반환)                             |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getUserWishFolderListJson()           | Func | 회원 Wish 폴더 목록 접수(JSON OBJECT반환)                        |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getDispCategoryListJson(sDepth)       | Func | 카테고리 목록 접수(JSON OBJECT반환)                              |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getMyZzimBrandListJson()              | Func | 브랜드 목록 접수(JSON OBJECT반환)                                |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getBrandInfo()                        | Sub  | 브랜드 Story / Tag                                               |
'+---------------------------------------+------+------------------------------------------------------------------+
'| getBrandDetailInfo()                  | Sub  | 브랜드 상세 정보                                                 |
'+---------------------------------------+------+------------------------------------------------------------------+


'// 위시 항목 클래스
Class CWishItem
	public Fuserid				'회워ID
	public FwishMateItemCnt		'위시매칭 상품수
	public Fitemid				'상품번호
	public Fmakerid				'브랜드id
	public Fbrandname			'브랜드명
	public Fitemname			'상품명
	public FfavCount			'위시수
	public ForgPrice			'원판매가
	public FsellPrice			'현재판매가
	public FisMyWish			'내 위시 여부(0:안됨, 1:위시됨)
	public FimageUrl			'상품이미지(일단 600px)
	public FwebItemUrl			'웹상세URL
	public FEvalcnt				'상품후기수

	public FfollowingCnt		'팔로잉 수
	public FfollowerCnt			'팔로워 수
	public FisMyFollow			'팔로잉 여부
	public FcounponCnt			'보유 쿠폰수
	public FcurrMileage			'보유 마일리지
	public FcurrDeposit			'보유 예치금
	public Fuserlevel			'회원등급

	'-- 상품 추가 정보
	public FLimitYn
	public FLimitNo
	public FLimitSold
	public FSellYn
	public FSaleYn
	public FSpecialUserItem
	public FRegdate
	public FItemCouponYN
	public FTenOnlyYn

	public FDeliverytype
	public FDefaultFreeBeasongLimit

	'-- 브랜드 추가 정보
	public FStoryTitle
	public FStoryCont
	public FphilosophyTitle
	public FphilosophyCont
	public Fdesignis
	public FTag
    
	'-- 브랜드 상세 정보
	public FbrandnameEng
	public FbrandZzimCnt
	public FisMyZzim
	public FiconName
	public FitemCnt
	public FwishCnt
	public FnewItemCnt
    public Fbgurl
    
    ''2014/09/25 추가 -------------------------------------------------
    public Fitemcoupontype
    public Fitemcouponvalue
    
    '// 세일포함 실제가격  '!
	public Function getRealPrice()
		getRealPrice = FsellPrice
		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FsellPrice)
		end if
	end Function	
	
	public Function getSalePro() 
		if FOrgprice=0 then
			getSalePro = "" ''0 & "%"
		elseif FOrgPrice=getRealPrice then
		    getSalePro = "" 
		else
			getSalePro = "["&CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"&"]"
		end if
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
	
	'// 상품 쿠폰 내용  '!
	public function GetCouponDiscountStr()
		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr = "["&CStr(Fitemcouponvalue) + "%"&"]"
			Case "2"
				GetCouponDiscountStr = "["&formatNumber(Fitemcouponvalue,0) + "원 할인"&"]"
			Case "3"
				GetCouponDiscountStr = "" '' "무료배송"
			Case Else
				GetCouponDiscountStr = "" ''Fitemcoupontype
		End Select
	end function
	
	public function GetSaleNCouponDiscountStr()
	    dim cpnPrc : cpnPrc = GetCouponAssignPrice
	    
	    GetSaleNCouponDiscountStr = ""
	    if FOrgprice=0 then
			GetSaleNCouponDiscountStr = "" 
		elseif FOrgPrice=cpnPrc then
		    GetSaleNCouponDiscountStr = "" 
		else
			GetSaleNCouponDiscountStr = "["&CLng((FOrgPrice-cpnPrc)/FOrgPrice*100) & "%"&"]"
		end if
		
	    
    end function

	'// 쿠폰 할인가 
	public Function GetCouponDiscountPrice() 
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
	
	''무료쿠폰은 표시 안함.
	public function getDiscountText()
	    getDiscountText = ""
	    if (IsSoldOut) then Exit function
	        
	    if NOT ((IsSaleItem) or (IsCouponItem)) then Exit function
	    
	    if (IsSaleItem) then
	        getDiscountText = getSalePro
	    end if
	    
	    if (IsCouponItem and (Not IsFreeBeasongCoupon)) then
	        getDiscountText = GetCouponDiscountStr
	    end if
	    
	    if (IsSaleItem) and (IsCouponItem and (Not IsFreeBeasongCoupon)) then
	        '' 세일 및 쿠폰 반영
	        getDiscountText = GetSaleNCouponDiscountStr
	    end if
    end function
    
    public function getDiscountColor()
        getDiscountColor = ""
	    if (IsSoldOut) then Exit function
	        
	    if NOT ((IsSaleItem) or (IsCouponItem)) then Exit function
	    
	    if (IsSaleItem) then
	        getDiscountColor = "#D60000"
	    end if
	    
	    if (IsCouponItem and (Not IsFreeBeasongCoupon)) then
	        getDiscountColor = "#1B8E09"
	    end if
	        
    end function

	''2014/09/25 추가 -------------------------------------------------
	
	'// 판매종료 여부(일시품절 포함)
	public Function IsSoldOut()
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

	'// 세일 상품 여부
	public Function IsSaleItem()
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FsellPrice>0)) or (IsSpecialUserItem)
	end Function

	'//	한정 여부
	public Function IsLimitItem()
			IsLimitItem= (FLimitYn="Y")
	end Function

	'// 상품 쿠폰 여부
	public Function IsCouponItem()
			IsCouponItem = (FItemCouponYN="Y")
	end Function

	'// 신상품 여부
	public Function IsNewItem()
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function

	'// 텐바이텐 독점상품 여부
	public Function IsTenOnlyitem()
		IsTenOnlyitem = (FTenOnlyYn="Y")
	end Function

	'// 우수회원샵 상품 여부
	public Function IsSpecialUserItem()
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

	'// 무료 배송 여부
	public Function IsFreeBeasong()
		if (cLng(FsellPrice)>=cLng(getFreeBeasongLimit())) then
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

	'무료 배송 기준액
	public Function getFreeBeasongLimit()
		''쇼핑에서는 사용자레벨에 상관없이 3만 / 업체 개별배송 5만
		if (FDeliverytype="9") then
		    If (IsNumeric(FDefaultFreeBeasongLimit)) and (FDefaultFreeBeasongLimit<>0) then
		        getFreeBeasongLimit = FDefaultFreeBeasongLimit
		    else
		        getFreeBeasongLimit = 50000
		    end if
		else
		    getFreeBeasongLimit = 30000
		end if
	end Function


    Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
End Class

'// 위시 클래스
Class CWish
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FstartPos
	public FPageSize
	public FResultCount
	public FScrollCount
	public FchkResult

	public FRectUserID
	public FRectMyUID
	public FRectItemid
	public FRectIsInclude	'내 상품 포함여부(Y:포함, N:제외)
	public FRectKind		'처리방법 구분
	public FRectFidx		'폴더ID
	public FrectIsSell		'판매여부 (Y:일시품절 이상, N:전체)

	public FRectSort		'정렬방법
	public FRectPrcMin		'검색 최저가
	public FRectPrcMax		'검색 최고가 (none:-1)
	public FRectColorCd		'컬러코드
	public FRectCateCd		'전시 카테고리
	public FRectKeyword		'검색어
	public FRectMakerid		'브랜드ID
	public FRectKeyType		'검색 초성 필터
	public FRectAttrib		'검색 속성 필터
	public FRectLimitCnt	'표시 제한선

	'// 나와 매치 수가 높은 회원 접수
	public Sub getWisMatchUser()
		dim sqlStr, sortSql, i
		dim chkMatch

		'#회원의 위시 상태 접수 (나와 매치되는 회원여부)
		sqlStr = "select count(*) myMatchCnt "
		sqlStr = sqlStr & "	from db_contents.dbo.tbl_app_wish_matchInfo "
		sqlStr = sqlStr & "	where userid='" & FRectUserID & "'"
		rsget.Open sqlStr,dbget,1
		if rsget("myMatchCnt")>0 then
			chkMatch = true
		else
			chkMatch = false
		end if
		rsget.Close

		'#사용자 목록
		if chkMatch then
			'매치되는 다른 회원이 있는 경우 (매치된 회원 목록 전달)
			Select Case FRectSort
				Case "new", "sale", "highprice", "lowprice"
					'sortSql = "order by lastupdate desc"
					sortSql = "order by matchCnt desc, lastupdate desc"
				Case "best"
					sortSql = "order by matchCnt desc, lastupdate desc"
				Case "desc"
					sortSql = "order by lastupdate asc "
				Case Else
					sortSql = "order by lastupdate desc"
			end Select

			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() over (" & sortSql & ") as RowNum "
			sqlStr = sqlStr & "			,targetUid, matchCnt "
			sqlStr = sqlStr & "		from db_contents.dbo.tbl_app_wish_matchInfo "
			sqlStr = sqlStr & "		where userid='" & FRectUserID & "'"
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		else
			'매치되는 회원이 없는 경우 (회원 추천:50개 이상의 상품 보유 회원)
			Select Case FRectSort
				Case "new", "sale", "highprice", "lowprice"
					sortSql = "order by max(lastupdate) desc"
				Case "best"
					sortSql = "order by sum(itemCnt) desc, max(lastupdate) desc"
				Case "desc"
					sortSql = "order by max(lastupdate) asc "
				Case Else
					sortSql = "order by max(lastupdate) desc"
			end Select

			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, userid as targetUid, 0 as matchCnt "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite_folder "
			sqlStr = sqlStr & "		where viewisusing='Y' "
			sqlStr = sqlStr & "			and userid<>'" & FRectUserID & "' "
			sqlStr = sqlStr & "		group by userid "
			sqlStr = sqlStr & "		having sum(itemCnt)>=50 "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		end if
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("targetUid")
				FItemList(i).FwishMateItemCnt        = rsget("matchCnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 내가 팔로우한 회원
	public Sub getFollowUser()
		dim sqlStr, sortSql, i, chkRst

		'카운팅
		sqlStr = " select count(*) cnt "
		sqlStr = sqlStr & " from db_contents.dbo.tbl_app_wish_followInfo "
		sqlStr = sqlStr & " where userid='" & FRectUserID & "'"
		rsget.Open sqlStr,dbget,1
		if rsget(0)>0 then
			chkRst = true		'팔로우 회원 있음
			FchkResult = 1
		else
			chkRst = false		'팔로우 회원 없음
			FchkResult = 0
		end if
		rsget.Close

		'정렬방법
		Select Case FRectSort
			Case "new", "sale", "highprice", "lowprice"
				sortSql = "order by max(a.lastupdate) desc"
			Case "best"
				sortSql = "order by sum(a.itemCnt) desc, max(a.lastupdate) desc"
			Case "desc"
				sortSql = "order by max(a.lastupdate) asc "
			Case Else
				sortSql = "order by max(a.lastupdate) desc"
		end Select

		'사용자 목록
		if chkRst then
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, a.userid as targetUid, isNull(max(m.matchCnt),0) matchCnt "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite_folder as a "
			sqlStr = sqlStr & "			join db_contents.dbo.tbl_app_wish_followInfo as b "
			sqlStr = sqlStr & "				on a.userid=b.followUid and b.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as m "
			sqlStr = sqlStr & "				on b.followUid=m.targetUid and m.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		where a.viewisusing='Y' and a.itemCnt>0 "
			sqlStr = sqlStr & "			and a.userid<>'" & FRectUserID & "' "
			sqlStr = sqlStr & "		group by a.userid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		else
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (order by count(*) desc) as RowNum, a.userid as targetUid, isNull(max(m.matchCnt),0) matchCnt "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite_folder as a "
			sqlStr = sqlStr & "			join db_contents.dbo.tbl_app_wish_followInfo as b "
			sqlStr = sqlStr & "				on a.userid=b.followUid "
			sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as m "
			sqlStr = sqlStr & "				on b.followUid=m.targetUid and m.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		where a.viewisusing='Y' and a.itemCnt>0 "
			sqlStr = sqlStr & "		group by a.userid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		end if
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("targetUid")
				FItemList(i).FwishMateItemCnt        = rsget("matchCnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 특정회원의 팔로잉/팔로워 목록
	public Sub getFollowUserList()
		dim sqlStr, sortSql, i

		'정렬방법
		sortSql = "order by max(b.regdate) desc"

		Select Case FRectKind
			Case "follower"
			'// 팔로워 목록
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, b.userid as targetUid, isNull(max(m.matchCnt),0) matchCnt "
			sqlStr = sqlStr & "		from db_contents.dbo.tbl_app_wish_followInfo as b "
			sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as m "
			sqlStr = sqlStr & "				on b.followUid=m.targetUid and m.userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & "		where b.followUid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		group by b.userid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)

			Case "following"
			'// 팔로잉 목록
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, b.followUid as targetUid, isNull(max(m.matchCnt),0) matchCnt "
			sqlStr = sqlStr & "		from db_contents.dbo.tbl_app_wish_followInfo as b "
			sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as m "
			sqlStr = sqlStr & "				on b.followUid=m.targetUid and m.userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & "		where b.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		group by b.followUid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		end Select
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("targetUid")
				FItemList(i).FwishMateItemCnt        = rsget("matchCnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub



	'// 카테고리-위시 회원
	public Sub getCategoyWishUser()
		dim sqlStr, sortSql, i

		'정렬방법
		Select Case FRectSort
			Case "new", "sale", "highprice", "lowprice"
				sortSql = "order by max(f.regdate) desc"
			Case "best"
				sortSql = "order by count(*) desc, max(f.regdate) desc"
			Case "desc"
				sortSql = "order by max(f.regdate) asc "
			Case Else
				sortSql = "order by max(f.regdate) desc"
		end Select

		'사용자 목록
		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() over (order by max(f.regdate) desc) as RowNum "
		sqlStr = sqlStr & "			,f.userid, isNull(max(m.matchCnt),0) matchCnt "
		sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite as f "
'		sqlStr = sqlStr & "			join db_item.dbo.tbl_display_cate_item as d "
'		sqlStr = sqlStr & "				on f.itemid=d.itemid "
'		sqlStr = sqlStr & "				and d.catecode like '" & FRectCateCd & "%' "
		sqlStr = sqlStr & "			join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & "				on f.itemid=i.itemid "
		sqlStr = sqlStr & "				and isusing='Y' and sellyn in ('Y','S') "
		sqlStr = sqlStr & "				and i.dispcate1='" & left(FRectCateCd,3) & "' "		'-- 상품의 1Depth 카테고리만 검색
		sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as m "
		sqlStr = sqlStr & "				on f.userid=m.targetUid and m.userid='" & FRectUserID & "' "
		sqlStr = sqlStr & "		where f.viewIsUsing='Y' "
		sqlStr = sqlStr & "			and f.userid<>'" & FRectUserID & "' "
		sqlStr = sqlStr & "		group by f.userid "
		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("userid")
				FItemList(i).FwishMateItemCnt        = rsget("matchCnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub



	'// 최근위시 회원 접수
	public Sub getRecentWishUser()
		dim sqlStr, sortSql, i

		'정렬방법
		Select Case FRectSort
			Case "new", "sale", "highprice", "lowprice"
				sortSql = "order by max(lastupdate) desc"
			Case "best"
				sortSql = "order by sum(itemCnt) desc, max(lastupdate) desc"
			Case "desc"
				sortSql = "order by max(lastupdate) asc "
			Case Else
				sortSql = "order by max(lastupdate) desc"
		end Select

		'사용자 목록
		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, userid, 0 as cnt "
		sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite_folder "
		sqlStr = sqlStr & "		where viewisusing='Y' and itemCnt>0 "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "			and userid<>'" & FRectUserID & "' "
		end if
		sqlStr = sqlStr & "		group by userid "
		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("userid")
				FItemList(i).FwishMateItemCnt        = rsget("cnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 위시 트랜드 회원 접수
	public Sub getWishTrendUser()
		dim sqlStr, sortSql, i
		if FRectLimitCnt="" then FRectLimitCnt=20

		'## 전체 결과 카운트
		sqlStr = " select count(*) cnt "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select p.userid "
		sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_favorite_popular as p "
		sqlStr = sqlStr & "			join db_my10x10.dbo.tbl_myfavorite as f "
		sqlStr = sqlStr & "				on p.itemid=f.itemid "
		sqlStr = sqlStr & "					and p.userid=f.userid "
		sqlStr = sqlStr & "					and f.viewisUsing='Y' "
		sqlStr = sqlStr & "		group by p.userid "
		sqlStr = sqlStr & " ) as T "
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		if FTotalCount>FRectLimitCnt then
			'# 최소 표시수보다 결과가 많아 인기위시 출력

			'정렬방법
			Select Case FRectSort
				Case "new", "sale", "highprice", "lowprice"
					sortSql = "order by max(p.regtime) desc, max(p.itemid) desc"
				Case "best"
					sortSql = "order by isnull(max(w.matchCnt),0) desc, max(p.regtime) desc, max(p.itemid) desc"
				Case "desc"
					sortSql = "order by max(p.regtime) asc, max(p.itemid) desc "
				Case Else
					sortSql = "order by max(p.regtime) desc, max(p.itemid) desc"
			end Select

			'사용자 목록
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum "
			sqlStr = sqlStr & "			, p.userid, max(p.regtime) as regTime, isnull(max(w.matchCnt),0) as cnt "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_favorite_popular as p "
			sqlStr = sqlStr & "			join db_my10x10.dbo.tbl_myfavorite as f "
			sqlStr = sqlStr & "				on p.itemid=f.itemid "
			sqlStr = sqlStr & "					and p.userid=f.userid "
			sqlStr = sqlStr & "					and f.viewisUsing='Y' "
			sqlStr = sqlStr & "			left join db_contents.dbo.tbl_app_wish_matchInfo as w "
			sqlStr = sqlStr & "				on p.userid=w.targetUid "
			sqlStr = sqlStr & "					and w.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		group by p.userid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
			rsget.Open sqlStr,dbget,1

			FResultCount = rsget.RecordCount

			redim preserve FItemList(FResultCount)

			if Not(rsget.EOF or rsget.BOF) then
				i=0
				Do until rsget.EOF
					set FItemList(i)          = new CWishItem
					FItemList(i).Fuserid        = rsget("userid")
					FItemList(i).FwishMateItemCnt        = rsget("cnt")

					i=i+1
					rsget.MoveNext
				loop
			end if
			rsget.Close
		else
			'# 최소 표시수보다 결과가 적어 최근 위시 회원 출력

			'정렬방법
			Select Case FRectSort
				Case "new", "sale", "highprice", "lowprice"
					sortSql = "order by max(lastupdate) desc"
				Case "best"
					sortSql = "order by sum(itemCnt) desc, max(lastupdate) desc"
				Case "desc"
					sortSql = "order by max(lastupdate) asc "
				Case Else
					sortSql = "order by max(lastupdate) desc"
			end Select

			'최근 위시 회원
			sqlStr = " select * "
			sqlStr = sqlStr & " from ( "
			sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, userid, 0 as cnt "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite_folder "
			sqlStr = sqlStr & "		where viewisusing='Y' and itemCnt>0 "
			if FRectUserID<>"" then
				sqlStr = sqlStr & "			and userid<>'" & FRectUserID & "' "
			end if
			sqlStr = sqlStr & "		group by userid "
			sqlStr = sqlStr & " ) as T "
			sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
			rsget.Open sqlStr,dbget,1

			FResultCount = rsget.RecordCount

			redim preserve FItemList(FResultCount)

			if Not(rsget.EOF or rsget.BOF) then
				i=0
				Do until rsget.EOF
					set FItemList(i)          = new CWishItem
					FItemList(i).Fuserid        = rsget("userid")
					FItemList(i).FwishMateItemCnt        = rsget("cnt")

					i=i+1
					rsget.MoveNext
				loop
			end if
			rsget.Close
		end if
	end Sub


	'// 특정 상품을 보유한 회원 접수(최근 업데이트 순)
	public Sub getWishUserFromItem()
		dim sqlStr, i

		sqlStr = " select top " & FPageSize & " wi.userid, sum(wf.itemCnt) as cnt, max(wf.lastupdate) as updt "
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite as wi "
		sqlStr = sqlStr & " 	join db_my10x10.dbo.tbl_myfavorite_folder as wf "
		sqlStr = sqlStr & " 		on wi.fidx=wf.fidx "
		sqlStr = sqlStr & " 			and wf.viewisusing='Y' "
		sqlStr = sqlStr & " where wi.itemid=" & FRectItemid & " "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "		and wi.userid<>'" & FRectUserID & "' "
		end if
		sqlStr = sqlStr & " group by wi.userid "
		sqlStr = sqlStr & " order by updt desc "
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).Fuserid        = rsget("userid")
				FItemList(i).FfavCount      = rsget("cnt")

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 특정 상품의 위시 컬렉션 (최근 업데이트 순, 회원 및 상품정보)
	public Sub getWishCollectFromItem()
		dim sqlStr, i

		sqlStr = "select A.userid, B.cnt, A.itemid, I.itemname, I.basicImage "
		sqlStr = sqlStr & "from ( "
		sqlStr = sqlStr & "		select * "
		sqlStr = sqlStr & "		from ( "
		sqlStr = sqlStr & "			select Row_Number() over (Partition by userid order by regdate desc) as rowno "
		sqlStr = sqlStr & "				,userid, fidx, itemid "
		sqlStr = sqlStr & "			from db_my10x10.dbo.tbl_myfavorite "
		sqlStr = sqlStr & "			where viewIsUsing='Y' and fidx<>0 "
		sqlStr = sqlStr & "				and userid in ( "
		sqlStr = sqlStr & "					select userid "
		sqlStr = sqlStr & "					from db_my10x10.dbo.tbl_myfavorite "
		sqlStr = sqlStr & "					where itemid=" & itemid & " "
		sqlStr = sqlStr & "						and viewisusing='Y' "
		sqlStr = sqlStr & "					group by userid "
		sqlStr = sqlStr & "				) "
		sqlStr = sqlStr & "		) as tt "
		sqlStr = sqlStr & "		where rowno<" & (FPageSize+1) & " "
		sqlStr = sqlStr & "	) as A "
		sqlStr = sqlStr & "	join ( "
		sqlStr = sqlStr & "		select top 4 wi.userid "
		sqlStr = sqlStr & "			, sum(wf.itemCnt) as cnt "
		sqlStr = sqlStr & "			, max(wf.lastupdate) as updt "
		sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite as wi "
		sqlStr = sqlStr & "			join db_my10x10.dbo.tbl_myfavorite_folder as wf "
		sqlStr = sqlStr & "				on wi.fidx=wf.fidx "
		sqlStr = sqlStr & "					and wf.viewisusing='Y' "
		sqlStr = sqlStr & "		where wi.itemid=" & itemid & " "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "			and wi.userid<>'" & FRectUserID & "' "
		end if
		sqlStr = sqlStr & "		group by wi.userid "
		sqlStr = sqlStr & "		order by updt desc "
		sqlStr = sqlStr & "	) as B "
		sqlStr = sqlStr & "		on A.userid=B.userid "
		sqlStr = sqlStr & "	join db_item.dbo.tbl_item as I "
		sqlStr = sqlStr & "		on A.itemid=I.itemid "
		if FRectLimitCnt>0 then
			sqlStr = sqlStr & "	where B.cnt>=" & FRectLimitCnt
		end if
		sqlStr = sqlStr & " order by B.updt desc, A.userid asc, A.rowno asc"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i) = new CWishItem
				FItemList(i).Fuserid	= rsget("userid")
				FItemList(i).FfavCount	= rsget("cnt")
				FItemList(i).Fitemid	= rsget("itemid")
				FItemList(i).Fitemname	= rsget("itemname")
				''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
                FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=400&height=400"
				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 회원 위시 상품 접수(JSON OBJECT반환)
	public Function getWishItemListJson()
		dim sqlStr, itemAdd, addSql, sortSql, i, objRst

		'정렬방법
		Select Case FRectSort
			Case "new"
				sortSql = "order by wi.regdate desc"
			Case "best"
				sortSql = "order by i.evalcnt desc, wi.regdate desc"
			Case "bestSell"
				sortSql = "order by i.itemscore desc, wi.regdate desc"
			Case "sale"
				sortSql = "order by (Case When orgprice>0 then (((orgprice-sellcash)/orgprice)*100) else 0 end) desc, wi.regdate desc "
			Case "desc"
				sortSql = "order by wi.regdate asc "
			Case "highprice"
				sortSql = "order by i.sellcash desc, wi.regdate desc "
			Case "lowprice"
				sortSql = "order by i.sellcash asc, wi.regdate desc "
			Case Else
				sortSql = "order by wi.regdate desc"
		end Select

		'가격 범위
		if FRectPrcMin>0 then itemAdd = itemAdd & " and i.sellcash>=" & FRectPrcMin
		if FRectPrcMax>0 then itemAdd = itemAdd & " and i.sellcash<=" & FRectPrcMax

		'브랜드
		if FRectMakerid<>"" then itemAdd = itemAdd & " and i.makerid='" & FRectMakerid & "'"

		'컬러 검색
		if FRectColorCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_item_colorOption "
			itemAdd = itemAdd & "	Where colorCode in (" & FRectColorCd & ")"
			itemAdd = itemAdd & ")"
		end if

		'카테고리 검색
		if FRectCateCd<>"" then
			if len(FRectCateCd)>3 then
				itemAdd = itemAdd & " and i.itemid in ("
				itemAdd = itemAdd & "	select distinct itemid "
				itemAdd = itemAdd & "	from db_item.dbo.tbl_display_cate_item "
				itemAdd = itemAdd & "	Where catecode like '" & FRectCateCd & "%'"
				itemAdd = itemAdd & ")"
			else
				'1depth라면 상품에서 검색
				itemAdd = itemAdd & " and i.dispcate1='" & left(FRectCateCd,3) & "' "
			end if
		end if

		'검색어
		if FRectKeyword<>"" then
			addSql = addSql & " and (i.itemname like '%" & FRectKeyword & "%'"
			addSql = addSql & " or ic.keywords like '%" & FRectKeyword & "%')"
		end if

		'폴더ID
		if FRectFidx<>"" then
			addSql = addSql & " and wi.fidx=" & FRectFidx & " "
		end if

		'상품 판매여부
		if FrectIsSell="Y" then
			itemAdd = itemAdd & " and i.sellyn in ('Y','S')"
		end if

		'내 상품 포함여부 확인 (A:기본적으로 빼고 없으면 포함, Y:포함, N:제외)
		if FRectMyUID<>"" then
			if FRectIsInclude="A" then
				sqlStr = "select count(*) cnt "
				sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite as wi "
				sqlStr = sqlStr & " 	join db_item.dbo.tbl_item as i "
				sqlStr = sqlStr & " 		on wi.itemid=i.itemid "
				sqlStr = sqlStr & " 			and i.isusing='Y' " & itemAdd
				sqlStr = sqlStr & " 	join db_item.dbo.tbl_item_contents as ic "
				sqlStr = sqlStr & " 		on i.itemid=ic.itemid "
				sqlStr = sqlStr & " 	left join ( "
				sqlStr = sqlStr & " 		select itemid "
				sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite where userid='" & FRectMyUID & "' "
				''if FRectUserID<>FRectMyUID then	sqlStr = sqlStr & " 		and viewIsUsing='Y' "	'내폴더가 아니면 공개된 상품만 매칭
				sqlStr = sqlStr & " 	) as ex "
				sqlStr = sqlStr & " 		on wi.itemid=ex.itemid "
				sqlStr = sqlStr & " where wi.userid='" & FRectUserID & "' "
				sqlStr = sqlStr & " 	and wi.viewisusing='Y' "
				sqlStr = sqlStr & " 	and ex.itemid is null " & addSql
				if FRectItemid<>"" then
					sqlStr = sqlStr & "	and wi.itemid<>" & FRectItemid
				end if
				rsget.Open sqlStr,dbget,1
				if rsget(0)>=FPageSize then
					'표시수보다 상품보유가 많으므로 내 위시상품은 제외
					FRectIsInclude = "N"
				else
					'표시수보다 상품보유가 적으므로 내 위시상품 포함 표시
					FRectIsInclude = "Y"
				end if
				rsget.Close
			end if
		else
			FRectIsInclude = "Y"
		end if

		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "

		sqlStr = sqlStr & " 	wi.itemid, i.makerid, i.brandname, i.itemname, i.orgprice, i.sellcash "
		sqlStr = sqlStr & " 	,ic.favcount, i.evalcnt, i.limitYn, i.limitNo, i.limitSold, i.sellYn, i.sailYn, i.itemcouponYn, i.SpecialUserItem, i.tenOnlyYn, i.regdate "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	, Case When ex.itemid is null then '0' else '1' end as isMy "
		else
			sqlStr = sqlStr & "		,'0' as isMy "
		end if
		sqlStr = sqlStr & " 	,i.basicimage600, i.basicimage, i.icon2image, i.deliverytype, c.defaultFreeBeasongLimit "
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite as wi "
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " 		on wi.itemid=i.itemid "
		sqlStr = sqlStr & " 			and i.isusing='Y' " & itemAdd
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item_contents as ic "
		sqlStr = sqlStr & " 		on i.itemid=ic.itemid "
		sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
		sqlStr = sqlStr & "			on i.makerid=c.userid "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	left join ( "
			sqlStr = sqlStr & " 		select itemid "
			sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			''if FRectUserID<>FRectMyUID then	sqlStr = sqlStr & " 		and viewIsUsing='Y' "	'내폴더가 아니면 공개된 상품만 매칭
			if FRectFidx<>"" then	sqlStr = sqlStr & " and fidx=" & FRectFidx & " "			'폴더 검색일경우
			sqlStr = sqlStr & " 	) as ex "
			sqlStr = sqlStr & " 		on wi.itemid=ex.itemid "
		end if
		sqlStr = sqlStr & " where wi.userid='" & FRectUserID & "' "
		if FRectMyUID<>FRectUserID then
			'내폴더가 아니면 공개된 상품만 출력
			sqlStr = sqlStr & " 	and wi.viewisusing='Y' "
		end if
		sqlStr = sqlStr & addSql
		if FRectMyUID<>"" then
			if FRectIsInclude="N" then
				sqlStr = sqlStr & " and ex.itemid is null "
			elseif FRectIsInclude="X" then
				sqlStr = sqlStr & " and ex.itemid is not null "
				'매칭 상품을 볼 때는 매칭 취합기준에 따라 필터링 (최근 1년 위시 상품)
				sqlStr = sqlStr & " and wi.fidx<>0 and datediff(day,wi.regdate,getdate())<=90 "
			end if
		end if
		if FRectItemid<>"" then
			sqlStr = sqlStr & "	and wi.itemid<>" & FRectItemid
		end if

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)

		'response.Write sqlStr & "<br>"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		'json Array선언
		Set objRst = jsArray()

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem

				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fbrandname		= rsget("brandname")
				FItemList(i).Fitemname		= rsget("itemname")
				FItemList(i).FfavCount		= rsget("favcount")
				FItemList(i).ForgPrice		= rsget("orgprice")
				FItemList(i).FsellPrice		= rsget("sellcash")
				FItemList(i).FisMyWish		= rsget("isMy")
				'if rsget("basicimage600")="" or isNull(rsget("basicimage600")) then
					''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
					FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=400&height=400"
				'else
				'	FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage600")
				'end if

                ''폴더내역은 작은이미지
                if (FRectFidx<>"") then
    				''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
    				FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=200&height=200"
                end if

				FItemList(i).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & rsget("itemid")
				FItemList(i).FEvalcnt		= rsget("evalcnt")

				FItemList(i).FLimitYn		= rsget("limitYn")
				FItemList(i).FLimitNo		= rsget("limitNo")
				FItemList(i).FLimitSold		= rsget("limitSold")
				FItemList(i).FSellYn		= rsget("sellYn")
				FItemList(i).FSaleYn		= rsget("sailYn")
				FItemList(i).FItemCouponYN	= rsget("itemcouponYn")
				FItemList(i).FSpecialUserItem	= rsget("SpecialUserItem")
				FItemList(i).FTenOnlyYn		= rsget("tenOnlyYn")
				FItemList(i).FRegdate		= rsget("regdate")

				FItemList(i).FDeliverytype	= rsget("deliverytype")
				FItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")

				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(Null)("productid") = cStr(FItemList(i).Fitemid)		'상품번호
				objRst(Null)("manufacturer") = FItemList(i).Fbrandname		'브랜드명
				objRst(Null)("name") = FItemList(i).Fitemname 				'상품명
				objRst(Null)("numofwish") = cStr(FItemList(i).FfavCount)		'위시수
				objRst(Null)("originalprice") = cStr(FItemList(i).ForgPrice)	'원판매가
				objRst(Null)("currentprice") = cStr(FItemList(i).FsellPrice)	'현재판매가(할인등)
				objRst(Null)("wishstate") = FItemList(i).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
				objRst(Null)("imageurl") = b64encode(FItemList(i).FimageUrl)	'상품이미지URL
				objRst(Null)("url") = b64encode(FItemList(i).FwebItemUrl)		'웹상품URL
				objRst(Null)("numofcomment") = cStr(FItemList(i).FEvalcnt)	'상품후기수

				Set objRst(Null)("state") = jsArray()										'판매상태 (아이콘)

				IF FItemList(i).isSoldOut Then
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "soldout"			'품절(일시품절 이상)
				else
					IF FItemList(i).isSaleItem Then
						'할인상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "sale"
					end if
					IF FItemList(i).isCouponItem Then
						'상품쿠폰
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "coupon"
					end if
					IF FItemList(i).isLimitItem Then
						'한정상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "limited"
					end if
					IF FItemList(i).IsTenOnlyitem Then
						'텐바이텐 독점상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "only"
					end if
					IF FItemList(i).isNewItem Then
						'신상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "new"
					end if
					IF FItemList(i).IsFreeBeasong Then
						'무료배송
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "freedelivery"
					end if
				end if

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getWishItemListJson = objRst

		Set objRst = Nothing

	end Function



	'// 인기 위시 상품 접수(JSON OBJECT반환)
	public Function getPopularWishListJson()
		dim sqlStr, itemAdd, addSql, sortSql, i, objRst

		'정렬방법
		Select Case FRectSort
			Case "new"
				sortSql = "order by wi.regtime desc"
			Case "best"
				sortSql = "order by wi.inCount desc, wi.regtime desc"
			Case "sale"
				sortSql = "order by (Case When orgprice>0 then (((orgprice-sellcash)/orgprice)*100) else 0 end) desc, wi.regtime desc "
			Case "desc"
				sortSql = "order by wi.regtime asc "
			Case "highprice"
				sortSql = "order by i.sellcash desc, wi.regtime desc "
			Case "lowprice"
				sortSql = "order by i.sellcash asc, wi.regtime desc "
			Case Else
				sortSql = "order by wi.regtime desc"
		end Select

		'가격 범위
		if FRectPrcMin>0 then itemAdd = itemAdd & " and i.sellcash>=" & FRectPrcMin
		if FRectPrcMax>0 then itemAdd = itemAdd & " and i.sellcash<=" & FRectPrcMax

		'브랜드
		if FRectMakerid<>"" then itemAdd = itemAdd & " and i.makerid='" & FRectMakerid & "'"

		'컬러 검색
		if FRectColorCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_item_colorOption "
			itemAdd = itemAdd & "	Where colorCode in (" & FRectColorCd & ")"
			itemAdd = itemAdd & ")"
		end if

		'카테고리 검색
		if FRectCateCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_display_cate_item "
			itemAdd = itemAdd & "	Where catecode like '" & FRectCateCd & "%'"
			itemAdd = itemAdd & ")"
		end if

		'검색어
		if FRectKeyword<>"" then
			addSql = addSql & " and (i.itemname like '%" & FRectKeyword & "%'"
			addSql = addSql & " or ic.keywords like '%" & FRectKeyword & "%')"
		end if

		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "

		sqlStr = sqlStr & " 	wi.itemid, i.makerid, i.brandname, i.itemname, i.orgprice, i.sellcash "
		sqlStr = sqlStr & " 	,ic.favcount, i.evalcnt, i.limitYn, i.limitNo, i.limitSold, i.sellYn, i.sailYn, i.itemcouponYn, i.SpecialUserItem, i.tenOnlyYn, i.regdate "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	, Case When ex.itemid is null then '0' else '1' end as isMy "
		else
			sqlStr = sqlStr & "		,'0' as isMy "
		end if
		sqlStr = sqlStr & " 	,i.basicimage600, i.basicimage, i.icon1image, i.deliverytype, c.defaultFreeBeasongLimit "
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_favorite_popular as wi "
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " 		on wi.itemid=i.itemid "
		sqlStr = sqlStr & " 			and i.sellyn in ('Y') "  '' ,'S'일시품절제외-상준요청 2014/06/11
		sqlStr = sqlStr & " 			and i.isusing='Y' " & itemAdd
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item_contents as ic "
		sqlStr = sqlStr & " 		on i.itemid=ic.itemid "
		sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
		sqlStr = sqlStr & "			on i.makerid=c.userid "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	left join ( "
			sqlStr = sqlStr & " 		select itemid "
			sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 	) as ex "
			sqlStr = sqlStr & " 		on wi.itemid=ex.itemid "
		end if
		sqlStr = sqlStr & addSql

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)

		'response.Write sqlStr & "<br>"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		'json Array선언
		Set objRst = jsArray()

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem

				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fbrandname		= rsget("brandname")
				FItemList(i).Fitemname		= rsget("itemname")
				FItemList(i).FfavCount		= rsget("favcount")
				FItemList(i).ForgPrice		= rsget("orgprice")
				FItemList(i).FsellPrice		= rsget("sellcash")
				FItemList(i).FisMyWish		= rsget("isMy")
				'if rsget("basicimage600")="" or isNull(rsget("basicimage600")) then
					''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
					''FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=400&height=400"
				'else
				'	FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage600")
				'end if

				''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1image")
                FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=200&height=200"

				FItemList(i).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & rsget("itemid")
				FItemList(i).FEvalcnt		= rsget("evalcnt")

				FItemList(i).FLimitYn		= rsget("limitYn")
				FItemList(i).FLimitNo		= rsget("limitNo")
				FItemList(i).FLimitSold		= rsget("limitSold")
				FItemList(i).FSellYn		= rsget("sellYn")
				FItemList(i).FSaleYn		= rsget("sailYn")
				FItemList(i).FItemCouponYN	= rsget("itemcouponYn")
				FItemList(i).FSpecialUserItem	= rsget("SpecialUserItem")
				FItemList(i).FTenOnlyYn		= rsget("tenOnlyYn")
				FItemList(i).FRegdate		= rsget("regdate")

				FItemList(i).FDeliverytype	= rsget("deliverytype")
				FItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")

				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(Null)("productid") = cStr(FItemList(i).Fitemid)		'상품번호
				objRst(Null)("manufacturer") = FItemList(i).Fbrandname		'브랜드명
				objRst(Null)("name") = FItemList(i).Fitemname 				'상품명
				objRst(Null)("numofwish") = cStr(FItemList(i).FfavCount)		'위시수
				objRst(Null)("originalprice") = cStr(FItemList(i).ForgPrice)	'원판매가
				objRst(Null)("currentprice") = cStr(FItemList(i).FsellPrice)	'현재판매가(할인등)
				objRst(Null)("wishstate") = FItemList(i).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
				objRst(Null)("imageurl") = b64encode(FItemList(i).FimageUrl)	'상품이미지URL
				objRst(Null)("url") = b64encode(FItemList(i).FwebItemUrl)		'웹상품URL
				objRst(Null)("numofcomment") = cStr(FItemList(i).FEvalcnt)	'상품후기수

				Set objRst(Null)("state") = jsArray()										'판매상태 (아이콘)

				IF FItemList(i).isSoldOut Then
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "soldout"			'품절(일시품절 이상)
				else
					IF FItemList(i).isSaleItem Then
						'할인상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "sale"
					end if
					IF FItemList(i).isCouponItem Then
						'상품쿠폰
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "coupon"
					end if
					IF FItemList(i).isLimitItem Then
						'한정상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "limited"
					end if
					IF FItemList(i).IsTenOnlyitem Then
						'텐바이텐 독점상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "only"
					end if
					IF FItemList(i).isNewItem Then
						'신상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "new"
					end if
					IF FItemList(i).IsFreeBeasong Then
						'무료배송
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "freedelivery"
					end if
				end if

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getPopularWishListJson = objRst

		Set objRst = Nothing

	end Function



	'// Best Award - Best Seller 상품 접수(JSON OBJECT반환)
	public Function getBestSellerListJson()
		dim sqlStr, itemAdd, addSql, sortSql, i, objRst

		'정렬방법
		Select Case FRectSort
			Case "new"
				sortSql = "order by wi.itemid desc"
			Case "best"
				sortSql = "order by wi.currrank asc, wi.itemid desc"
			Case "sale"
				sortSql = "order by (Case When orgprice>0 then (((orgprice-sellcash)/orgprice)*100) else 0 end) desc, wi.currrank asc "
			Case "desc"
				sortSql = "order by wi.currrank desc "
			Case "highprice"
				sortSql = "order by i.sellcash desc, wi.currrank asc "
			Case "lowprice"
				sortSql = "order by i.sellcash asc, wi.currrank asc "
			Case Else
				sortSql = "order by wi.currrank asc"
		end Select

		'가격 범위
		if FRectPrcMin>0 then itemAdd = itemAdd & " and i.sellcash>=" & FRectPrcMin
		if FRectPrcMax>0 then itemAdd = itemAdd & " and i.sellcash<=" & FRectPrcMax

		'최소가격 지정
		itemAdd = itemAdd & " and i.sellcash>=5000 "

		'전시안함 상품 제외
		itemAdd = itemAdd & " and i.cate_large<>'999' "

		'브랜드
		if FRectMakerid<>"" then itemAdd = itemAdd & " and i.makerid='" & FRectMakerid & "'"

		'컬러 검색
		if FRectColorCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_item_colorOption "
			itemAdd = itemAdd & "	Where colorCode in (" & FRectColorCd & ")"
			itemAdd = itemAdd & ")"
		end if

		'카테고리 검색
		if FRectCateCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_display_cate_item "
			itemAdd = itemAdd & "	Where catecode like '" & FRectCateCd & "%'"
			itemAdd = itemAdd & ")"
		end if

		'검색어
		if FRectKeyword<>"" then
			addSql = addSql & " and (i.itemname like '%" & FRectKeyword & "%'"
			addSql = addSql & " or ic.keywords like '%" & FRectKeyword & "%')"
		end if

		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "

		sqlStr = sqlStr & " 	wi.itemid, i.makerid, i.brandname, i.itemname, i.orgprice, i.sellcash "
		sqlStr = sqlStr & " 	,ic.favcount, i.evalcnt, i.limitYn, i.limitNo, i.limitSold, i.sellYn, i.sailYn, i.itemcouponYn, i.SpecialUserItem, i.tenOnlyYn, i.regdate "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	, Case When ex.itemid is null then '0' else '1' end as isMy "
		else
			sqlStr = sqlStr & "		,'0' as isMy "
		end if
		sqlStr = sqlStr & " 	,i.basicimage600, i.basicimage, i.icon1image, i.deliverytype, c.defaultFreeBeasongLimit "
		sqlStr = sqlStr & " from db_const.dbo.tbl_const_award as wi "
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " 		on wi.itemid=i.itemid "
		sqlStr = sqlStr & " 			and i.sellyn in ('Y') " ' ,'S' ''일시품절제외-상준요청 2014/06/11
		sqlStr = sqlStr & " 			and i.isusing='Y' " & itemAdd
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item_contents as ic "
		sqlStr = sqlStr & " 		on i.itemid=ic.itemid "
		sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
		sqlStr = sqlStr & "			on i.makerid=c.userid "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	left join ( "
			sqlStr = sqlStr & " 		select itemid "
			sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 	) as ex "
			sqlStr = sqlStr & " 		on wi.itemid=ex.itemid "
		end if
		sqlStr = sqlStr & " Where wi.awardgubun='b' " & addSql			'베스트 셀러

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)

		'response.Write sqlStr & "<br>"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		'json Array선언
		Set objRst = jsArray()

	if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem

				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fbrandname		= rsget("brandname")
				FItemList(i).Fitemname		= rsget("itemname")
				FItemList(i).FfavCount		= rsget("favcount")
				FItemList(i).ForgPrice		= rsget("orgprice")
				FItemList(i).FsellPrice		= rsget("sellcash")
				FItemList(i).FisMyWish		= rsget("isMy")
				'if rsget("basicimage600")="" or isNull(rsget("basicimage600")) then
					''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
					FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=400&height=400"
				'else
				'	FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage600")
				'end if

				''FItemList(i).FimageUrl		= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1image")
                FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=200&height=200"

				FItemList(i).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & rsget("itemid")
				FItemList(i).FEvalcnt		= rsget("evalcnt")

				FItemList(i).FLimitYn		= rsget("limitYn")
				FItemList(i).FLimitNo		= rsget("limitNo")
				FItemList(i).FLimitSold		= rsget("limitSold")
				FItemList(i).FSellYn		= rsget("sellYn")
				FItemList(i).FSaleYn		= rsget("sailYn")
				FItemList(i).FItemCouponYN	= rsget("itemcouponYn")
				FItemList(i).FSpecialUserItem	= rsget("SpecialUserItem")
				FItemList(i).FTenOnlyYn		= rsget("tenOnlyYn")
				FItemList(i).FRegdate		= rsget("regdate")

				FItemList(i).FDeliverytype	= rsget("deliverytype")
				FItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")

				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(Null)("productid") = cStr(FItemList(i).Fitemid)		'상품번호
				objRst(Null)("manufacturer") = FItemList(i).Fbrandname		'브랜드명
				objRst(Null)("name") = FItemList(i).Fitemname 				'상품명
				objRst(Null)("numofwish") = cStr(FItemList(i).FfavCount)		'위시수
				objRst(Null)("originalprice") = cStr(FItemList(i).ForgPrice)	'원판매가
				objRst(Null)("currentprice") = cStr(FItemList(i).FsellPrice)	'현재판매가(할인등)
				objRst(Null)("wishstate") = FItemList(i).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
				objRst(Null)("imageurl") = b64encode(FItemList(i).FimageUrl)	'상품이미지URL
				objRst(Null)("url") = b64encode(FItemList(i).FwebItemUrl)		'웹상품URL
				objRst(Null)("numofcomment") = cStr(FItemList(i).FEvalcnt)	'상품후기수

				Set objRst(Null)("state") = jsArray()										'판매상태 (아이콘)

				IF FItemList(i).isSoldOut Then
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "soldout"			'품절(일시품절 이상)
				else
					IF FItemList(i).isSaleItem Then
						'할인상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "sale"
					end if
					IF FItemList(i).isCouponItem Then
						'상품쿠폰
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "coupon"
					end if
					IF FItemList(i).isLimitItem Then
						'한정상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "limited"
					end if
					IF FItemList(i).IsTenOnlyitem Then
						'텐바이텐 독점상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "only"
					end if
					IF FItemList(i).isNewItem Then
						'신상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "new"
					end if
					IF FItemList(i).IsFreeBeasong Then
						'무료배송
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "freedelivery"
					end if
				end if

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getBestSellerListJson = objRst

		Set objRst = Nothing

	end Function


	'// Best Award - Best Wish 상품 접수(JSON OBJECT반환)
	public Function getBestWishListJson()
		dim sqlStr, itemAdd, addSql, sortSql, i, objRst

		'정렬방법
		Select Case FRectSort
			Case "new"
				''sortSql = "order by wi.itemid desc"
				sortSql = "order by wi.currrank asc, wi.itemid desc"
			Case "best"
				sortSql = "order by wi.currrank asc, wi.itemid desc"
			Case "sale"
				sortSql = "order by (Case When orgprice>0 then (((orgprice-sellcash)/orgprice)*100) else 0 end) desc, wi.currrank asc "
			Case "desc"
				sortSql = "order by wi.currrank desc "
			Case "highprice"
				sortSql = "order by i.sellcash desc, wi.currrank asc "
			Case "lowprice"
				sortSql = "order by i.sellcash asc, wi.currrank asc "
			Case Else
				sortSql = "order by wi.currrank asc"
		end Select

		'가격 범위
		if FRectPrcMin>0 then itemAdd = itemAdd & " and i.sellcash>=" & FRectPrcMin
		if FRectPrcMax>0 then itemAdd = itemAdd & " and i.sellcash<=" & FRectPrcMax

		'최소가격 지정
		itemAdd = itemAdd & " and i.sellcash>=5000 "

		'전시안함 상품 제외
		itemAdd = itemAdd & " and i.cate_large<>'999' "

		'브랜드
		if FRectMakerid<>"" then itemAdd = itemAdd & " and i.makerid='" & FRectMakerid & "'"

		'컬러 검색
		if FRectColorCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_item_colorOption "
			itemAdd = itemAdd & "	Where colorCode in (" & FRectColorCd & ")"
			itemAdd = itemAdd & ")"
		end if

		'카테고리 검색
		if FRectCateCd<>"" then
			itemAdd = itemAdd & " and i.itemid in ("
			itemAdd = itemAdd & "	select distinct itemid "
			itemAdd = itemAdd & "	from db_item.dbo.tbl_display_cate_item "
			itemAdd = itemAdd & "	Where catecode like '" & FRectCateCd & "%'"
			itemAdd = itemAdd & ")"
		end if

		'검색어
		if FRectKeyword<>"" then
			addSql = addSql & " and (i.itemname like '%" & FRectKeyword & "%'"
			addSql = addSql & " or ic.keywords like '%" & FRectKeyword & "%')"
		end if

		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "

		sqlStr = sqlStr & " 	wi.itemid, i.makerid, i.brandname, i.itemname, i.orgprice, i.sellcash "
		sqlStr = sqlStr & " 	,ic.favcount, i.evalcnt, i.limitYn, i.limitNo, i.limitSold, i.sellYn, i.sailYn, i.itemcouponYn, i.SpecialUserItem, i.tenOnlyYn, i.regdate "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	, Case When ex.itemid is null then '0' else '1' end as isMy "
		else
			sqlStr = sqlStr & "		,'0' as isMy "
		end if
		sqlStr = sqlStr & " 	,i.basicimage600, i.basicimage, i.icon1image, i.deliverytype, c.defaultFreeBeasongLimit "
		sqlStr = sqlStr & " from db_const.dbo.tbl_const_award as wi "
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " 		on wi.itemid=i.itemid "
		sqlStr = sqlStr & " 			and i.sellyn in ('Y') " ' ,'S' ''일시품절제외-상준요청 2014/06/11
		sqlStr = sqlStr & " 			and i.isusing='Y' " & itemAdd
		sqlStr = sqlStr & " 	join db_item.dbo.tbl_item_contents as ic "
		sqlStr = sqlStr & " 		on i.itemid=ic.itemid "
		sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
		sqlStr = sqlStr & "			on i.makerid=c.userid "
		if FRectMyUID<>"" then
			sqlStr = sqlStr & " 	left join ( "
			sqlStr = sqlStr & " 		select itemid "
			sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 	) as ex "
			sqlStr = sqlStr & " 		on wi.itemid=ex.itemid "
		end if
		sqlStr = sqlStr & " Where wi.awardgubun='f' " & addSql			'베스트 위시

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)

		'response.Write sqlStr & "<br>"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		'json Array선언
		Set objRst = jsArray()

	if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem

				FItemList(i).Fitemid		= rsget("itemid")
				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fbrandname		= rsget("brandname")
				FItemList(i).Fitemname		= rsget("itemname")
				FItemList(i).FfavCount		= rsget("favcount")
				FItemList(i).ForgPrice		= rsget("orgprice")
				FItemList(i).FsellPrice		= rsget("sellcash")
				FItemList(i).FisMyWish		= rsget("isMy")
				FItemList(i).FimageUrl		= "http://thumbnail.10x10.co.kr/webimage/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage") &"?cmd=thumb&width=400&height=400"

				FItemList(i).FwebItemUrl	= cstItemPrdUrl & "?itemid=" & rsget("itemid")
				FItemList(i).FEvalcnt		= rsget("evalcnt")

				FItemList(i).FLimitYn		= rsget("limitYn")
				FItemList(i).FLimitNo		= rsget("limitNo")
				FItemList(i).FLimitSold		= rsget("limitSold")
				FItemList(i).FSellYn		= rsget("sellYn")
				FItemList(i).FSaleYn		= rsget("sailYn")
				FItemList(i).FItemCouponYN	= rsget("itemcouponYn")
				FItemList(i).FSpecialUserItem	= rsget("SpecialUserItem")
				FItemList(i).FTenOnlyYn		= rsget("tenOnlyYn")
				FItemList(i).FRegdate		= rsget("regdate")

				FItemList(i).FDeliverytype	= rsget("deliverytype")
				FItemList(i).FDefaultFreeBeasongLimit = rsget("defaultFreeBeasongLimit")

				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(Null)("productid") = cStr(FItemList(i).Fitemid)		'상품번호
				objRst(Null)("manufacturer") = FItemList(i).Fbrandname		'브랜드명
				objRst(Null)("name") = FItemList(i).Fitemname 				'상품명
				objRst(Null)("numofwish") = cStr(FItemList(i).FfavCount)		'위시수
				objRst(Null)("originalprice") = cStr(FItemList(i).ForgPrice)	'원판매가
				objRst(Null)("currentprice") = cStr(FItemList(i).FsellPrice)	'현재판매가(할인등)
				objRst(Null)("wishstate") = FItemList(i).FisMyWish			'현재 위시여부 (0:안함, 1:위시됨)
				objRst(Null)("imageurl") = b64encode(FItemList(i).FimageUrl)	'상품이미지URL
				objRst(Null)("url") = b64encode(FItemList(i).FwebItemUrl)		'웹상품URL
				objRst(Null)("numofcomment") = cStr(FItemList(i).FEvalcnt)	'상품후기수

				Set objRst(Null)("state") = jsArray()										'판매상태 (아이콘)

				IF FItemList(i).isSoldOut Then
					Set objRst(Null)("state")(null) = jsObject()
					objRst(Null)("state")(null)("name") = "soldout"			'품절(일시품절 이상)
				else
					IF FItemList(i).isSaleItem Then
						'할인상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "sale"
					end if
					IF FItemList(i).isCouponItem Then
						'상품쿠폰
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "coupon"
					end if
					IF FItemList(i).isLimitItem Then
						'한정상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "limited"
					end if
					IF FItemList(i).IsTenOnlyitem Then
						'텐바이텐 독점상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "only"
					end if
					IF FItemList(i).isNewItem Then
						'신상품
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "new"
					end if
					IF FItemList(i).IsFreeBeasong Then
						'무료배송
						Set objRst(Null)("state")(null) = jsObject()
						objRst(Null)("state")(null)("name") = "freedelivery"
					end if
				end if

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getBestWishListJson = objRst

		Set objRst = Nothing

	end Function


	'// 회원 정보 접수
	public Sub getUserInfo()
		dim sqlStr, i

		sqlStr = "select u.userid, isNull(m.matchCnt,0) as matchCnt "
		sqlStr = sqlStr & " 	,isNull(followingCnt,0) as followingCnt "
		sqlStr = sqlStr & " 	,isNull(followerCnt,0) as followerCnt "
		sqlStr = sqlStr & " 	,Case When f.followUid is Null Then '0' Else '1' end as isFollow "
		if FRectUserID=FRectMyUID then
			'내 정보일 경우
			sqlStr = sqlStr & " 	,(select isNull(count(*),0) "
			sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 		) as favCnt "
			sqlStr = sqlStr & " 	,(select isnull(count(idx),0) "
			sqlStr = sqlStr & " 		from db_user.dbo.tbl_user_coupon "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 			and isusing='N' and deleteyn='N' and notvalid10x10='N' and startdate<=getdate() and expiredate>=getdate()) "
			sqlStr = sqlStr & " 	+(select isnull(count(couponidx),0) "
			sqlStr = sqlStr & " 		from db_item.dbo.tbl_user_item_coupon "
			sqlStr = sqlStr & " 		where userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 			and usedyn='N' and itemcouponstartdate<=getdate() and itemcouponexpiredate>=getdate()) as couponCnt "
			sqlStr = sqlStr & " 	,isnull((select  "
			sqlStr = sqlStr & " 			(m.jumunmileage +  m.flowerjumunmileage + m.bonusmileage  + m.academymileage - m.spendmileage -  IsNULL(m.expiredMile,0) - IsNULL(m.michulmile,0) - IsNULL(m.michulmileACA,0))  as currentmileage "
			sqlStr = sqlStr & " 			from [db_user].[dbo].tbl_user_current_mileage m "
			sqlStr = sqlStr & " 			where m.userid='" & FRectMyUID & "' "
			sqlStr = sqlStr & " 			),0) as  currentmileage "
			sqlStr = sqlStr & " 	,isNull((Select currentdeposit from db_user.dbo.tbl_user_current_deposit where userid='" & FRectMyUID & "'),0) as currentdeposit "
			sqlStr = sqlStr & " 	,Case "
			sqlStr = sqlStr & " 		When u.userlevel='5' Then 'orange' When u.userlevel='0' Then 'yellow' When u.userlevel='1' Then 'green' When u.userlevel='2' Then 'blue' "
			sqlStr = sqlStr & " 		When u.userlevel='3' Then 'vipsilver' When u.userlevel='4' Then 'vipgold' When u.userlevel='6' Then 'vvip' When u.userlevel='7' or u.userlevel='8' Then 'staff' else '' "
			sqlStr = sqlStr & " 	end as userlevel "
		else
			'내정보가 아니면 공란
			sqlStr = sqlStr & " ,'' as favCnt, '' as couponCnt, '' as currentmileage, '' as currentdeposit, '' as userlevel "
		end if
		sqlStr = sqlStr & " from db_user.dbo.tbl_logindata as u "
		sqlStr = sqlStr & " 	left join db_contents.dbo.tbl_app_wish_userInfo as w "
		sqlStr = sqlStr & " 		on u.userid=w.userid "
		sqlStr = sqlStr & " 	left join db_contents.dbo.tbl_app_wish_matchInfo as m "
		sqlStr = sqlStr & " 		on u.userid=m.targetUid "
		sqlStr = sqlStr & " 			and m.userid='" & FRectMyUID & "' "
		sqlStr = sqlStr & " 	left join db_contents.dbo.tbl_app_wish_followInfo as f "
		sqlStr = sqlStr & " 		on u.userid=f.followUid "
		sqlStr = sqlStr & " 			and f.userid='" & FRectMyUID & "' "
		sqlStr = sqlStr & " where u.userid='" & FRectUserID & "'"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			set FItemList(0)          = new CWishItem

			FItemList(0).Fuserid			= rsget("userid")			'회원ID
			FItemList(0).FwishMateItemCnt	= rsget("matchCnt")			'위시매칭 상품수
			FItemList(0).FfollowingCnt		= rsget("followingCnt")		'팔로잉 수
			FItemList(0).FfollowerCnt		= rsget("followerCnt")		'팔로워 수
			FItemList(0).FisMyFollow		= rsget("isFollow")			'팔로잉 여부

			FItemList(0).FfavCount			= rsget("favCnt")			'위시수
			FItemList(0).FcounponCnt		= rsget("couponCnt")		'보유 쿠폰수
			FItemList(0).FcurrMileage		= rsget("currentmileage")	'보유 마일리지
			FItemList(0).FcurrDeposit		= rsget("currentdeposit")	'보유 예치금
			FItemList(0).Fuserlevel			= rsget("userlevel")		'회원등급

		end if

		rsget.Close

	end Sub



	'// 회원 뱃지 목록 접수(JSON OBJECT반환)
	public Function getUserBadgeListJson()
		dim sqlStr, i, objRst

		sqlStr = "select b.badgeIdx, i.badgeName, i.dispno "
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_badge_userObtain as b "
		sqlStr = sqlStr & " 	join db_my10x10.dbo.tbl_badge_info as i "
		sqlStr = sqlStr & " 		on b.badgeIdx=i.badgeIdx "
		sqlStr = sqlStr & " where b.userid='" & FRectUserID & "' "
		sqlStr = sqlStr & " 	and i.useYn='Y' "
		sqlStr = sqlStr & " order by i.dispno"
		rsget.Open sqlStr,dbget,1

		'json Array선언
		Set objRst = jsArray()

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(Null)("name") = cStr(rsget("badgeName"))				'뱃지명
				'objRst(Null)("iconurl") = b64encode("http://fiximage.10x10.co.kr/web2013/common/badge/ico_badge_40_" & cStr(rsget("dispno")) & ".png")		'뱃지 Ico URL
				'objRst(Null)("imageurl") = b64encode("http://fiximage.10x10.co.kr/web2013/common/badge/ico_badge_116_" & cStr(rsget("dispno")) & ".png")		'뱃지 Image URL
				'objRst(Null)("imageurl") = b64encode("http://fiximage.10x10.co.kr/web2013/common/badge/ico_badge_40_" & cStr(rsget("dispno")) & ".png")		'뱃지 Image URL
				objRst(Null)("imageurl") = b64encode("http://fiximage.10x10.co.kr/web2013/common/badge/ico_badge_100w_" & cStr(rsget("dispno")) & ".png")		'뱃지 Image URL (100px White)

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getUserBadgeListJson = objRst

		Set objRst = Nothing
	end Function



	'// 회원 Wish 폴더 목록 접수(JSON OBJECT반환)
	public Function getUserWishFolderListJson()
		dim sqlStr, i, objRst

		'json Array선언
		Set objRst = jsArray()

		'내 정보를 보는것이면 기본폴더 표시
		if FRectUserID=FRectMyUID then
			sqlStr = "select "
			sqlStr = sqlStr & "	(select count(*) from db_my10x10.dbo.tbl_myfavorite "
			sqlStr = sqlStr & "	where userid='" & FRectUserID & "' and fidx=0) as icnt "
			sqlStr = sqlStr & "	,isNull((select top 1 '/image/basic/'+ case when i.itemid<100000 then '0' else '' end + cast(i.itemid/10000 as varchar(4))+'/'+i.basicimage as basicimage "
			sqlStr = sqlStr & "		from db_my10x10.dbo.tbl_myfavorite as w "
			sqlStr = sqlStr & "		join db_item.dbo.tbl_item as i on w.itemid=i.itemid "
			sqlStr = sqlStr & "		where w.userid='" & FRectUserID & "' and w.fidx=0 "
			sqlStr = sqlStr & "			order by w.regdate desc),'') as itemImage"
			rsget.Open sqlStr,dbget,1

			Set objRst(Null) = jsObject()
				objRst(null)("folderid") = "0"
				objRst(null)("name") = "기본폴더"
				objRst(null)("numofproduct") = cStr(rsget("icnt"))
				objRst(null)("public") = "0"
				if rsget("itemImage")<>"" then
					''objRst(null)("imageurl") = b64encode("http://webimage.10x10.co.kr" & cStr(rsget("itemImage")))	'폴더 이미지
					objRst(null)("imageurl") = b64encode("http://thumbnail.10x10.co.kr/webimage" & cStr(rsget("itemImage")) &"?cmd=thumb&width=200&height=200")	'폴더 이미지
				else
					objRst(null)("imageurl") = ""
				end if
			rsget.Close
		end if

		sqlStr = "select f.fidx, f.foldername, isNull(f.itemCnt,0) as itemCnt, Case When f.viewIsUsing='Y' Then '1' Else '0' end as viewIsUsing "
		sqlStr = sqlStr & " 	,isNull((select top 1 '/image/basic/'+ case when i.itemid<100000 then '0' else '' end + cast(i.itemid/10000 as varchar(4))+'/'+i.basicimage as basicimage "
		sqlStr = sqlStr & " 		from db_my10x10.dbo.tbl_myfavorite as w "
		sqlStr = sqlStr & " 			join db_item.dbo.tbl_item as i "
		sqlStr = sqlStr & " 				on w.itemid=i.itemid "
		sqlStr = sqlStr & " 		where w.userid='" & FRectUserID & "' and w.fidx=f.fidx "
		sqlStr = sqlStr & " 		order by w.regdate desc "
		sqlStr = sqlStr & " 	),'') as itemImage "
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite_folder as f "
		sqlStr = sqlStr & " where f.userid='" & FRectUserID & "' "
		if FRectUserID<>FRectMyUID then
			'조회 대상이 본인이 아니면 공개폴더만
			sqlStr = sqlStr & " 	and f.viewIsUsing='Y'"
		end if
		rsget.Open sqlStr,dbget,1

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(null)("folderid") = cStr(rsget("fidx"))				'폴더ID
				objRst(null)("name") = cStr(rsget("foldername"))					'폴더명
				objRst(null)("numofproduct") = cStr(rsget("itemCnt"))			'폴더내 상품수
				objRst(null)("public") = cStr(rsget("viewIsUsing"))				'폴더 공개여부
				if rsget("itemImage")<>"" then
					''objRst(null)("imageurl") = b64encode("http://webimage.10x10.co.kr" & cStr(rsget("itemImage")))	'폴더 이미지
					objRst(null)("imageurl") = b64encode("http://thumbnail.10x10.co.kr/webimage" & cStr(rsget("itemImage")) &"?cmd=thumb&width=200&height=200")	'폴더 이미지
				else
					objRst(null)("imageurl") = ""
				end if

				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close

		'// JSON결과 반환
		set getUserWishFolderListJson = objRst

		Set objRst = Nothing
	end Function


	'// 카테고리 목록 접수(JSON OBJECT반환)
	public Function getDispCategoryListJson(sDepth)
		dim sqlStr, objRst
		dim isLastDepth

		if sDepth="" then sDepth="1"

		sqlStr = "select c.catecode, c.catename "
		sqlStr = sqlStr & " ,(case when (isNULL(dh.catecode,'') <> '') then 'Y' else 'N' end) as ishot"
		sqlStr = sqlStr & " from db_item.dbo.tbl_display_cate c"
		sqlStr = sqlStr & "     left outer join [db_sitemaster].[dbo].[tbl_dispcate_hot] as dh"
	    sqlStr = sqlStr & "     on c.catecode = dh.catecode "
		sqlStr = sqlStr & " where c.useyn='Y' "
		sqlStr = sqlStr & " 	and c.depth=" & sDepth
		if FRectCateCd<>"" then
			sqlStr = sqlStr & " 	and c.catecode like '" & FRectCateCd & "%' "
		end if
		sqlStr = sqlStr & " order by c.sortNo asc, c.catecode asc "

		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

		'json Array선언
		Set objRst = jsArray()

		if Not(rsget.EOF or rsget.BOF) then
			Do until rsget.EOF
				'--------------------------------------------
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(null)("categoryid") = cStr(rsget("catecode"))	'카테고리 코드
				objRst(null)("name") = cStr(replace(rsget("catename"),"&nbsp;",""))			'카테고리명
				objRst(null)("ishot") = cStr(rsget("ishot"))			'isHot
				objRst(null)("numofitem") = cStr(0)			            'numofitem ''search쪽 과 통일하기 위해 넣음.(갯수가 1보다 작으면 갯수를 표시하지 않음)
				rsget.MoveNext
			loop
	    else
	        isLastDepth = (sDepth>0)
		end if
		rsget.Close
		
		''2014/09/25 추가
'        if (isLastDepth) then
'            sqlStr = "select c.catecode, c.catename "
'    		sqlStr = sqlStr & " ,(case when (isNULL(dh.catecode,'') <> '') then 'Y' else 'N' end) as ishot"
'    		sqlStr = sqlStr & " from db_item.dbo.tbl_display_cate c"
'    		sqlStr = sqlStr & "     left outer join [db_sitemaster].[dbo].[tbl_dispcate_hot] as dh"
'    	    sqlStr = sqlStr & "     on c.catecode = dh.catecode "
'    		sqlStr = sqlStr & " where c.useyn='Y' "
'    		sqlStr = sqlStr & " 	and c.depth=" & (sDepth-1)
'    		if FRectCateCd<>"" then
'    			sqlStr = sqlStr & " 	and c.catecode like '" & LEFT(FRectCateCd,LEN(FRectCateCd)-3) & "%' "
'    		end if
'    		sqlStr = sqlStr & " order by c.sortNo asc, c.catecode asc "
'    		rsget.Open sqlStr,dbget,1
'    
'    		if Not(rsget.EOF or rsget.BOF) then
'    			Do until rsget.EOF
'    				'--------------------------------------------
'    				'JSON OBJ 저장
'    				Set objRst(Null) = jsObject()
'    				objRst(null)("categoryid") = cStr(rsget("catecode"))	'카테고리 코드
'    				objRst(null)("name") = cStr(replace(rsget("catename"),"&nbsp;",""))			'카테고리명
'    				objRst(null)("ishot") = cStr(rsget("ishot"))			'isHot
'    				objRst(null)("numofitem") = cStr(0)			            'numofitem ''search쪽 과 통일하기 위해 넣음.(갯수가 1보다 작으면 갯수를 표시하지 않음)
'    				rsget.MoveNext
'    			loop
'    		end if
'    		rsget.Close
'        end if
        
		'// JSON결과 반환
		set getDispCategoryListJson = objRst

		Set objRst = Nothing
	end Function


	'// 나의 찜브랜드 목록(Simple Ver)
	public Function getMyBrandSimpleListJson()
		dim sqlStr, addSql, sortSql, objRst, oResult, i

		'// 내 찜브랜드 보유 여부 확인
		if FRectIsInclude="A" and FRectUserID<>"" then
			sqlStr = "Select count(*) cnt "
			sqlStr = sqlStr & "	from db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
			sqlStr = sqlStr & "			on z.makerid=c.userid "
			sqlStr = sqlStr & "				and c.isusing='Y' "
			sqlStr = sqlStr & "	where z.userid='" & FRectUserID & "'"
			rsget.Open sqlStr,dbget,1
			if rsget(0)>0 then
				FRectIsInclude = "Y"		'나의 찜브랜드
				if FRectSort="" then FRectSort = "new"
			else
				FRectIsInclude = "N"		'추천 찜브랜드
				FRectSort = "best"
			end if
			rsget.Close
		elseif FRectIsInclude="N" then
			FRectSort = "best"
		end if

		'정렬방법
		Select Case FRectSort
			Case "date"
				sortSql = "order by z.regdate desc"
			Case "new"
				sortSql = "order by b.regdate desc"
			Case "name"
				sortSql = "order by b.socname_kor asc"
			Case Else
				sortSql = "order by b.recommendcount desc"
		end Select

		'사용자 목록
		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "
		sqlStr = sqlStr & "			b.userid, b.socname, b.socname_kor, b.recommendcount "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "			,Case When z.makerid is null then '0' else '1' end as isMyZzim "
			sqlStr = sqlStr & "			,isNull(w.ttcnt,0) as myWishItemCnt "
		else
			sqlStr = sqlStr & "			,'0' as isMyZzim, '0' as myWishItemCnt "
		end if
		sqlStr = sqlStr & "			,b.itemcount, b.standardCateCode, h.subtopimage "
		sqlStr = sqlStr & "		from db_user.dbo.tbl_user_c as b "


		if FRectUserID<>"" then
			sqlStr = sqlStr & "			left join db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "				on b.userid=z.makerid "
			sqlStr = sqlStr & "					and z.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "			left join ( "
			sqlStr = sqlStr & "				Select mi.makerid ,count(mi.itemid) as ttcnt "
			sqlStr = sqlStr & "				from db_item.dbo.tbl_item as mi "
			sqlStr = sqlStr & "					join db_my10x10.dbo.tbl_myfavorite as mf "
			sqlStr = sqlStr & "						on mi.itemid=mf.itemid "
			sqlStr = sqlStr & "							and mf.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "				where mi.sellyn in ('Y','S') "
			sqlStr = sqlStr & "				group by mi.makerid "
			sqlStr = sqlStr & "			) as w "
			sqlStr = sqlStr & "				on b.userid=w.makerid "
		end if
		sqlStr = sqlStr & "			left join db_brand.dbo.tbl_street_manager as h "
		sqlStr = sqlStr & "				on b.userid=h.makerid "
		sqlStr = sqlStr & "					and h.brandgubun=4 "
		sqlStr = sqlStr & "		where b.isusing='Y' and b.userdiv<10 and b.itemcount>0 " & addSql

		if FRectUserID<>"" and FRectIsInclude="Y" then
			sqlStr = sqlStr & "		and z.makerid is not null "
		end if

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			oResult = rsget.getRows()
		else
			Set getMyZzimBrandListJson = jsArray()
			exit function
		end if
		rsget.Close

		'json Array선언
		Set objRst = jsArray()

		''0       1       2        3            4               5         6              7          8                 9
		''RowNum, userid, socname, socname_kor, recommendcount, isMyZzim, myWishItemCnt, itemcount, standardCateCode, subtopimage

		if uBound(oResult,2)>=0 then
			for i=0 to uBound(oResult,2)
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(null)("brandid") = oResult(1,i)				'브랜드ID
				objRst(null)("englishname") = oResult(2,i)			'브랜드 영문명
				objRst(null)("hangulname") = oResult(3,i)			'브랜드 한글명
				objRst(null)("numofzzim") = cStr(oResult(4,i))		'브랜드 찜수
				objRst(null)("zzim") = oResult(5,i)					'내 찜 여부
				objRst(null)("icon") = ""							'브랜드 아이콘
				objRst(null)("numofproduct") = cStr(oResult(7,i))	'보유상품수
				objRst(null)("numofmatch") = cStr(oResult(6,i))		'내 위시 상품수

				Set objRst(null)("product") = jsArray()		'상품Array

				'브랜드 배경 이미지(프리미엄 브랜드일 경우 지정배경, 일반은 카테고리별 이미지)
				if Not(oResult(9,i)="" or isNull(oResult(9,i))) then
					objRst(null)("brandimageurl") = b64encode(staticImgUrl & "/brandstreet/manager/" & oResult(9,i))
				elseif Not(oResult(8,i)="" or isNull(oResult(8,i))) then
					Select Case oResult(8,i)
						Case "101"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate01.jpg")
						Case "102"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate02.jpg")
						Case "103"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate03.jpg")
						Case "104"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate04.jpg")
						Case "106"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate06.jpg")
						Case "112"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate12.jpg")
						Case "113"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate13.jpg")
						Case "115"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate15.jpg")
						Case "110"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate10.jpg")
						Case "114"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate14.jpg")
						Case Else 		objRst(null)("brandimageurl") = ""
					End Select
				else
					objRst(null)("brandimageurl") = ""
				end if

				objRst(null)("numofnew") = "0"		'신상품 수
			next
		end if

		set getMyBrandSimpleListJson = objRst
	end Function



	'// 나의 찜브랜드 목록(Full Ver)
	public Function getMyZzimBrandListJson()
		dim sqlStr, addSql, sortSql, objRst, oDoc, oResult, i

		'// 내 찜브랜드 보유 여부 확인
		if FRectIsInclude="A" and FRectUserID<>"" then
			sqlStr = "Select count(*) cnt "
			sqlStr = sqlStr & "	from db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "		join db_user.dbo.tbl_user_c as c "
			sqlStr = sqlStr & "			on z.makerid=c.userid "
			sqlStr = sqlStr & "				and c.isusing='Y' "
			sqlStr = sqlStr & "	where z.userid='" & FRectUserID & "'"
			rsget.Open sqlStr,dbget,1
			if rsget(0)>0 then
				FRectIsInclude = "Y"		'나의 찜브랜드
				if FRectSort="" then FRectSort = "new"
			else
				FRectIsInclude = "N"		'추천 찜브랜드
				FRectSort = "best"
			end if
			rsget.Close
		elseif FRectIsInclude="N" then
			FRectSort = "best"
		end if

		'// 초성필터
		if FRectKeyType<>"" then
			dim sCh1, sCh2, lang
			Call convSchChar(FRectKeyType, sCh1, sCh2, lang)
			Select Case lang
				Case "kor"
					addSql = addSql & " and b.socname_kor between '" & sCh1 & "' and '" & sCh2 & "'"
					FRectSort = "kor"
				Case "eng"
					if sCh1<>"" then
						addSql = addSql & " and UPPER(left(b.socname,1)) between '" & sCh1 & "' and '" & sCh2 & "'"
					else
						addSql = addSql & " and not UPPER(left(b.socname,1)) between 'A' and 'Z'"
					end if
					FRectSort = "eng"
			end Select
		end if

		'// 속성필터
		if FRectAttrib<>"" then
			Select Case FRectAttrib
				Case "new"
					addSql = addSql & " and b.newFlg='Y'"
				Case "best"
					addSql = addSql & " and b.hitFlg='Y'"
				Case "only"
					addSql = addSql & " and b.onlyFlg='Y'"
				Case "artist"
					addSql = addSql & " and b.artistFlg='Y'"
				Case "k-design"
					addSql = addSql & " and b.kdesignFlg='Y'"
			end Select
		end if

		'// 카테고리 필터
		if FRectCateCd<>"" then
			addSql = addSql & " and b.standardCateCode='" & left(FRectCateCd,3) & "' "
		end if

		'정렬방법
		Select Case FRectSort
			Case "date"
				if FRectUserID<>"" then
					sortSql = "order by z.regdate desc"
				else
					sortSql = "order by b.regdate desc"
				end if
			Case "new", "sale", "highprice", "lowprice"
				sortSql = "order by isNull(i.newCnt,0) desc, b.regdate desc"
			Case "kor", "name"
				sortSql = "order by b.socname_kor asc"
			Case "eng"
				sortSql = "order by b.socname asc"
			Case "best"
				sortSql = "order by b.recommendcount desc"
			Case "desc"
				sortSql = "order by b.recommendcount asc"
			Case Else
				sortSql = "order by b.recommendcount desc"
		end Select

		'사용자 목록
		sqlStr = " select * "
		sqlStr = sqlStr & " from ( "
		sqlStr = sqlStr & "		select Row_Number() Over (" & sortSql & ") as RowNum, "
		sqlStr = sqlStr & "			b.userid, b.socname, b.socname_kor, b.recommendcount "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "			,Case When z.makerid is null then '0' else '1' end as isMyZzim "
			sqlStr = sqlStr & "			,isNull(w.ttcnt,0) as myWishItemCnt "
		else
			sqlStr = sqlStr & "			,'0' as isMyZzim, '0' as myWishItemCnt "
		end if
		sqlStr = sqlStr & "			,b.giftFlg, b.hitFlg, b.saleFlg, b.smileFlg, b.newFlg, b.onlyFlg, b.artistFlg, b.kdesignFlg "
		sqlStr = sqlStr & "			,b.itemcount ,b.standardCateCode, h.subtopimage "
		sqlStr = sqlStr & "			, isNull(i.newCnt,0) as newItemCnt "
		sqlStr = sqlStr & "		from db_user.dbo.tbl_user_c as b "

		'Tag검색 시
		if FRectKeyword<>"" then
			sqlStr = sqlStr & "			join db_brand.dbo.tbl_street_Hello as bh "
			sqlStr = sqlStr & "				on b.userid=bh.makerid "
			sqlStr = sqlStr & "					and bh.brandTag like '%" & FRectKeyword & "%' "
		end if

		if FRectUserID<>"" then
			sqlStr = sqlStr & "			left join db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "				on b.userid=z.makerid "
			sqlStr = sqlStr & "					and z.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "			left join ( "
			sqlStr = sqlStr & "				Select mi.makerid ,count(mi.itemid) as ttcnt "
			sqlStr = sqlStr & "				from db_item.dbo.tbl_item as mi "
			sqlStr = sqlStr & "					join db_my10x10.dbo.tbl_myfavorite as mf "
			sqlStr = sqlStr & "						on mi.itemid=mf.itemid "
			sqlStr = sqlStr & "							and mf.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "				where mi.sellyn in ('Y','S') "
			sqlStr = sqlStr & "				group by mi.makerid "
			sqlStr = sqlStr & "			) as w "
			sqlStr = sqlStr & "				on b.userid=w.makerid "
		end if
		sqlStr = sqlStr & "			left join ( "
		sqlStr = sqlStr & "				Select makerid, count(itemid) as newCnt "
		sqlStr = sqlStr & "				from db_item.dbo.tbl_item "
		sqlStr = sqlStr & "				where datediff(d,regdate,getdate())<7 "
		sqlStr = sqlStr & "					and sellyn in ('Y','S') "
		sqlStr = sqlStr & "				group by makerid "
		sqlStr = sqlStr & "			) as i "
		sqlStr = sqlStr & "				on b.userid=i.makerid "
		sqlStr = sqlStr & "			left join db_brand.dbo.tbl_street_manager as h "
		sqlStr = sqlStr & "				on b.userid=h.makerid "
		sqlStr = sqlStr & "					and brandgubun=4 "
		sqlStr = sqlStr & "		where b.isusing='Y' and b.userdiv<10 and b.itemcount>0 " & addSql

		if FRectUserID<>"" and FRectIsInclude="Y" then
			sqlStr = sqlStr & "		and z.makerid is not null "
		end if

		sqlStr = sqlStr & " ) as T "
		sqlStr = sqlStr & " where RowNum between " & FstartPos & " and " & (FstartPos+FPageSize-1)
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			oResult = rsget.getRows()
		else
			Set getMyZzimBrandListJson = jsArray()
			rsget.Close
			exit function
		end if
		rsget.Close

		'json Array선언
		Set objRst = jsArray()

		''0       1       2        3            4               5         6              7        8       9        10        11      12       13         14          15         16                17           18
		''RowNum, userid, socname, socname_kor, recommendcount, isMyZzim, myWishItemCnt, giftFlg, hitFlg, saleFlg, smileFlg, newFlg, onlyFlg, artistFlg, kdesignFlg, itemcount, standardCateCode, subtopimage, newItemCnt

		if uBound(oResult,2)>=0 then
			for i=0 to uBound(oResult,2)
				'JSON OBJ 저장
				Set objRst(Null) = jsObject()
				objRst(null)("brandid") = oResult(1,i)				'브랜드ID
				objRst(null)("englishname") = oResult(2,i)			'브랜드 영문명
				objRst(null)("hangulname") = oResult(3,i)			'브랜드 한글명
				objRst(null)("numofzzim") = cStr(oResult(4,i))		'브랜드 찜수
				objRst(null)("zzim") = oResult(5,i)					'내 찜 여부

				'브랜드 아이콘
				if oResult(12,i)="Y" then
					objRst(null)("icon") = "only"
				elseif oResult(11,i)="Y" then
					objRst(null)("icon") = "new"
				elseif oResult(9,i)="Y" then
					objRst(null)("icon") = "sale"
				elseif oResult(7,i)="Y" then
					objRst(null)("icon") = "gift"
				else
					objRst(null)("icon") = ""
				end if

				objRst(null)("numofproduct") = cStr(oResult(15,i))	'보유상품수
				objRst(null)("numofmatch") = cStr(oResult(6,i))		'내 위시 상품수

				'브랜드 상품
				set oDoc = new SearchItemCls
				oDoc.FListDiv = "brand"
				oDoc.FRectSearchItemDiv = "y"
				oDoc.FRectSearchCateDep = "T"
				oDoc.FRectCateCode	= FRectCateCd
				oDoc.FRectMakerid	= oResult(1,i)
				oDoc.StartNum = 0
				oDoc.FPageSize = 4
				oDoc.FimgKind = "icon1"		'상품 이미지 크기
				oDoc.FLogsAccept = false		'로그 없음
				Set objRst(null)("product") = oDoc.getSearchListJson()	'상품목록(array) 반환
				set oDoc = Nothing

				'브랜드 배경 이미지(프리미엄 브랜드일 경우 지정배경, 일반은 카테고리별 이미지)
				if Not(oResult(17,i)="" or isNull(oResult(17,i))) then
					objRst(null)("brandimageurl") = b64encode(staticImgUrl & "/brandstreet/manager/" & oResult(17,i))
				elseif Not(oResult(16,i)="" or isNull(oResult(16,i))) then
					Select Case oResult(16,i)
						Case "101"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate01.jpg")
						Case "102"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate02.jpg")
						Case "103"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate03.jpg")
						Case "104"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate04.jpg")
						Case "106"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate06.jpg")
						Case "112"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate12.jpg")
						Case "113"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate13.jpg")
						Case "115"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate15.jpg")
						Case "110"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate10.jpg")
						Case "114"		objRst(null)("brandimageurl") = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate14.jpg")
						Case Else 		objRst(null)("brandimageurl") = ""
					End Select
				else
					objRst(null)("brandimageurl") = ""
				end if

				objRst(null)("numofnew") = cStr(oResult(18,i))		'신상품 수

			next
		end if

		set getMyZzimBrandListJson = objRst
	end Function


	'// 브랜드 Story / Tag
	public Sub getBrandInfo()
		dim sqlStr, i

		sqlStr = " select c.userid, h.bgImageURL,h.StoryTitle, isNull(h.StoryContent,c.dgncomment) as StoryContent, h.philosophyTitle, h.philosophyContent, isNULL(h.designis,'') as designis, isNULL(h.brandTag,'') as brandTag "
		sqlStr = sqlStr & " ,c.socname, c.socname_kor, isNULL(c.sellrank,9999) as sellrank, c.newFlg, c.recommendcount"
		if FRectUserID<>"" then
			sqlStr = sqlStr & "	,(Case When z.makerid is null then '0' else '1' end) as isMyZzim "
	    else
	        sqlStr = sqlStr & "	,0 as isMyZzim"
	    end if
		sqlStr = sqlStr & " from db_user.dbo.tbl_user_c as c "
		sqlStr = sqlStr & " 	left join db_brand.dbo.tbl_street_Hello as h "
		sqlStr = sqlStr & " 		on c.userid=h.makerid and h.isusing='Y' "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "	left join db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "		on c.userid=z.makerid "
			sqlStr = sqlStr & "			and z.userid='" & FRectUserID & "' "
	    end if
		sqlStr = sqlStr & " where c.userid='" & FRectMakerid & "' "
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i=0
			Do until rsget.EOF
				set FItemList(i)          = new CWishItem
				FItemList(i).FStoryTitle		= rsget("StoryTitle")
				FItemList(i).FStoryCont			= rsget("StoryContent")
				FItemList(i).FphilosophyTitle	= rsget("philosophyTitle")
				FItemList(i).FphilosophyCont	= rsget("philosophyContent")
				FItemList(i).Fdesignis			= rsget("designis")
				FItemList(i).FTag				= rsget("brandTag")
                
                FItemList(i).Fbrandname		= rsget("socname_kor")
			    FItemList(i).FbrandnameEng	= rsget("socname")
			    FItemList(i).FisMyZzim		= rsget("isMyZzim")
			    FItemList(i).FbrandZzimCnt	= rsget("recommendcount")
			    
			    FItemList(i).Fbgurl         = rsget("bgImageURL")
			    if isNULL(FItemList(i).Fbgurl) then
			        ''FItemList(i).Fbgurl = "http://thumbnail.10x10.co.kr/imgstatic/brandstreet/hello/"&"7321/7321_20140207163720_hello.jpg"&"?cmd=crop&x=390&y=109&width=960&height=450"  '' 없을경우 카테고리 별로 정해진 이미지가 있다고 함.
			        
			        FItemList(i).Fbgurl = "http://fiximage.10x10.co.kr/m/2014/brand/brandbg00_none.jpg"
			    else
			        '' 원본 1740*668 보낼파일 640*300 *1.5배 =960*450 , x=(1740-960)/2, y=(668-450)/2
			        ''FItemList(i).Fbgurl = "http://thumbnail.10x10.co.kr/imgstatic/brandstreet/hello/"&FItemList(i).Fbgurl&"?cmd=crop&x=390&y=109&width=960&height=450"
			        FItemList(i).Fbgurl = "http://thumbnail.10x10.co.kr/imgstatic/brandstreet/hello/"&FItemList(i).Fbgurl&"?cmd=thumb&width=960&height=450"
			    end if
			    ''베스트 기준 sellrank<=90
			    '브랜드 아이콘
    			if rsget("sellrank")<=90 then
    			    FItemList(i).FiconName = "best"
    			elseif rsget("newFlg")="Y" then
    				FItemList(i).FiconName = "new"
    			'elseif rsget("onlyFlg")="Y" then
    			'	FItemList(i).FiconName = "only"
    			'elseif rsget("saleFlg")="Y" then
    			'	FItemList(i).FiconName = "sale"
    			'elseif rsget("giftFlg")="Y" then
    			'	FItemList(i).FiconName = "gift"
    			else
    				FItemList(i).FiconName = ""
    			end if
			    
				i=i+1
				rsget.MoveNext
			loop
		end if
		rsget.Close
	end Sub


	'// 브랜드 상세 정보 :: brandproduct.custom 에서 사용 : V2에서 삭제
	public Sub getBrandDetailInfo()
		dim sqlStr

		'사용자 목록
		sqlStr = sqlStr & "Select top 1 b.userid, b.socname, b.socname_kor, b.recommendcount "
		if FRectUserID<>"" then
			sqlStr = sqlStr & "	,Case When z.makerid is null then '0' else '1' end as isMyZzim "
			sqlStr = sqlStr & "	,isNull(w.ttcnt,0) as myWishItemCnt "
		else
			sqlStr = sqlStr & "	,'0' as isMyZzim, '0' as myWishItemCnt "
		end if
		sqlStr = sqlStr & "	,b.giftFlg, b.hitFlg, b.saleFlg, b.smileFlg, b.newFlg, b.onlyFlg, b.artistFlg, b.kdesignFlg "
		sqlStr = sqlStr & "	,b.itemcount ,b.standardCateCode, h.subtopimage "
		sqlStr = sqlStr & "	, isNull(i.newCnt,0) as newItemCnt "
		sqlStr = sqlStr & "From db_user.dbo.tbl_user_c as b "

		if FRectUserID<>"" then
			sqlStr = sqlStr & "	left join db_my10x10.dbo.tbl_mybrand as z "
			sqlStr = sqlStr & "		on b.userid=z.makerid "
			sqlStr = sqlStr & "			and z.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "	left join ( "
			sqlStr = sqlStr & "		Select mi.makerid ,count(mi.itemid) as ttcnt "
			sqlStr = sqlStr & "		from db_item.dbo.tbl_item as mi "
			sqlStr = sqlStr & "			join db_my10x10.dbo.tbl_myfavorite as mf "
			sqlStr = sqlStr & "				on mi.itemid=mf.itemid "
			sqlStr = sqlStr & "					and mf.userid='" & FRectUserID & "' "
			sqlStr = sqlStr & "		where mi.sellyn in ('Y','S') "
			sqlStr = sqlStr & "		group by mi.makerid "
			sqlStr = sqlStr & "	) as w "
			sqlStr = sqlStr & "		on b.userid=w.makerid "
		end if
		sqlStr = sqlStr & "	left join ( "
		sqlStr = sqlStr & "		Select makerid, count(itemid) as newCnt "
		sqlStr = sqlStr & "		from db_item.dbo.tbl_item "
		sqlStr = sqlStr & "		where datediff(d,regdate,getdate())<7 "
		sqlStr = sqlStr & "			and sellyn in ('Y','S') "
		sqlStr = sqlStr & "		group by makerid "
		sqlStr = sqlStr & "	) as i "
		sqlStr = sqlStr & "		on b.userid=i.makerid "
		sqlStr = sqlStr & "	left join db_brand.dbo.tbl_street_manager as h "
		sqlStr = sqlStr & "		on b.userid=h.makerid "
		sqlStr = sqlStr & "			and brandgubun=4 "
		sqlStr = sqlStr & "Where b.isusing='Y' and b.userdiv<10 and b.itemcount>0 "
		sqlStr = sqlStr & "	and b.userid='" & FRectMakerid & "'"
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			set FItemList(0)          = new CWishItem
			FItemList(0).Fmakerid		= rsget("userid")
			FItemList(0).Fbrandname		= rsget("socname_kor")
			FItemList(0).FbrandnameEng	= rsget("socname")
			FItemList(0).FbrandZzimCnt	= rsget("recommendcount")
			FItemList(0).FisMyZzim		= rsget("isMyZzim")
			FItemList(0).FitemCnt		= rsget("itemcount")
			FItemList(0).FwishCnt		= rsget("myWishItemCnt")
			FItemList(0).FnewItemCnt	= rsget("newItemCnt")

			'브랜드 아이콘
			if rsget("onlyFlg")="Y" then
				FItemList(0).FiconName = "only"
			elseif rsget("newFlg")="Y" then
				FItemList(0).FiconName = "new"
			elseif rsget("saleFlg")="Y" then
				FItemList(0).FiconName = "sale"
			elseif rsget("giftFlg")="Y" then
				FItemList(0).FiconName = "gift"
			else
				FItemList(0).FiconName = ""
			end if

			'브랜드 배경 이미지(프리미엄 브랜드일 경우 지정배경, 일반은 카테고리별 이미지)
			if Not(rsget("subtopimage")="" or isNull(rsget("subtopimage"))) then
				FItemList(0).FimageUrl = b64encode(staticImgUrl & "/brandstreet/manager/" & rsget("subtopimage"))
			elseif Not(rsget("standardCateCode")="" or isNull(rsget("standardCateCode"))) then
				Select Case rsget("standardCateCode")
					Case "101"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate01.jpg")
					Case "102"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate02.jpg")
					Case "103"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate03.jpg")
					Case "104"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate04.jpg")
					Case "106"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate06.jpg")
					Case "112"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate12.jpg")
					Case "113"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate13.jpg")
					Case "115"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate15.jpg")
					Case "110"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate10.jpg")
					Case "114"		FItemList(0).FimageUrl = b64encode("http://fiximage.10x10.co.kr/m/apps/street_bg_cate14.jpg")
					Case Else 		FItemList(0).FimageUrl = ""
				End Select
			else
				FItemList(0).FimageUrl = ""
			end if

		end if
		rsget.Close

	end Sub

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FstartPos = 1
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
		FchkResult = 0
	End Sub

	Private Sub Class_Terminate()
	End Sub

End Class


'// 스트리트 브랜드명 검색어 반환
Sub convSchChar(chrCd, byref chr1 , byref chr2, byRef lng)
	select case chrCd
		Case "가": chr1="ㄱ": chr2="ㄴ": lng="kor"
		Case "나": chr1="ㄴ": chr2="ㄷ": lng="kor"
		Case "다": chr1="ㄷ": chr2="ㄹ": lng="kor"
		Case "라": chr1="ㄹ": chr2="ㅁ": lng="kor"
		Case "마": chr1="ㅁ": chr2="ㅂ": lng="kor"
		Case "바": chr1="ㅂ": chr2="ㅅ": lng="kor"
		Case "사": chr1="ㅅ": chr2="ㅇ": lng="kor"
		Case "아": chr1="ㅇ": chr2="ㅈ": lng="kor"
		Case "자": chr1="ㅈ": chr2="ㅊ": lng="kor"
		Case "차": chr1="ㅊ": chr2="ㅋ": lng="kor"
		Case "카": chr1="ㅋ": chr2="ㅌ": lng="kor"
		Case "타": chr1="ㅌ": chr2="ㅍ": lng="kor"
		Case "파": chr1="ㅍ": chr2="ㅎ": lng="kor"
		Case "하": chr1="ㅎ": chr2="힣": lng="kor"
		Case "A": chr1="A": chr2="A": lng="eng"
		Case "B": chr1="B": chr2="B": lng="eng"
		Case "C": chr1="C": chr2="C": lng="eng"
		Case "D": chr1="D": chr2="D": lng="eng"
		Case "E": chr1="E": chr2="E": lng="eng"
		Case "F": chr1="F": chr2="F": lng="eng"
		Case "G": chr1="G": chr2="G": lng="eng"
		Case "H": chr1="H": chr2="H": lng="eng"
		Case "I": chr1="I": chr2="I": lng="eng"
		Case "J": chr1="J": chr2="J": lng="eng"
		Case "K": chr1="K": chr2="K": lng="eng"
		Case "L": chr1="L": chr2="L": lng="eng"
		Case "M": chr1="M": chr2="M": lng="eng"
		Case "N": chr1="N": chr2="N": lng="eng"
		Case "O": chr1="O": chr2="O": lng="eng"
		Case "P": chr1="P": chr2="P": lng="eng"
		Case "Q": chr1="Q": chr2="Q": lng="eng"
		Case "R": chr1="R": chr2="R": lng="eng"
		Case "S": chr1="S": chr2="S": lng="eng"
		Case "T": chr1="T": chr2="T": lng="eng"
		Case "U": chr1="U": chr2="U": lng="eng"
		Case "V": chr1="V": chr2="V": lng="eng"
		Case "W": chr1="W": chr2="W": lng="eng"
		Case "X": chr1="X": chr2="X": lng="eng"
		Case "Y": chr1="Y": chr2="Y": lng="eng"
		Case "Z": chr1="Z": chr2="Z": lng="eng"
		Case "etc": chr1="": chr2="": lng="eng"
	end select
end Sub

'// 전시카테고리 명 접수
Function CategoryNameUseLeftMenuDB(code)
	Dim vName, vQuery
	vQuery = "select db_item.dbo.getDisplayCateName('"&code&"')"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	If Not rsget.Eof Then
		vName = rsget(0)
	End IF
	rsget.close
	if isNull(vName) then vName=""
	CategoryNameUseLeftMenuDB = vName
End Function

'// 현재카테고리 
Function getCurrentCateListJson(dispcate,retCnt)
    dim objRst, i, cnt
    Set objRst = jsArray()
    
    Dim vName, vQuery
	vQuery = "select db_item.dbo.getCateCodeFullDepthName('"&dispcate&"')"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

	If Not rsget.Eof Then
		vName = rsget(0)
	End IF
	rsget.close
	if isNull(vName) then vName=""
	
	''마지막카테고리라면
'	if Len(dispcate)>0 and vName="" then
'	    vQuery = "select db_item.dbo.getCateCodeFullDepthName('"&Left(dispcate,Len(dispcate)-3)&"')"
'    	rsget.Open vQuery, dbget, 1
'    	If Not rsget.Eof Then
'    		vName = rsget(0)
'    	End IF
'    	rsget.close
'    	if isNull(vName) then vName=""
'	end if
	
	
	vName = split(vName,"^^")
	cnt   = len(dispCate)\3
	
	Set objRst(Null) = jsObject()
	    objRst(null)("categoryid") = cStr("(HOME)")
	    objRst(null)("name") = "HOME"
	    objRst(null)("ishot") = cStr("N")	
	    objRst(null)("numofitem") = cStr(0)
	    
	for i=0 to cnt-1
	    Set objRst(Null) = jsObject()
    	objRst(null)("categoryid") = cStr(LEFT(dispcate,(i+1)*3))	
    	if UBound(vName)>=i then
    	    objRst(null)("name") = cStr(vName(i))	
    	else
    	    objRst(null)("name") = cStr(objRst(null)("catecode"))
        end if
        objRst(null)("ishot")     = cStr("N")	
        
        ''현재 결과 수량
        if (i=cnt-1) then
            objRst(null)("numofitem") = cStr(retCnt)
        else
            objRst(null)("numofitem") = cStr(0)
        end if
    next	
	set getCurrentCateListJson = objRst
	Set objRst = Nothing
End Function

Function getCurrentCateListHomeOnly()
    dim objRst, i, cnt
    Set objRst = jsArray()
    Set objRst(Null) = jsObject()
    	    objRst(null)("categoryid") = cStr("(HOME)")
    	    objRst(null)("name") = "HOME"
    	    objRst(null)("ishot") = cStr("N")	
    	    objRst(null)("numofitem") = cStr(0)
    set getCurrentCateListHomeOnly = objRst
	Set objRst = Nothing
End Function
%>
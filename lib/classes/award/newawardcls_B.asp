<%
'#=========================================#
'# 어워드 아이템 클래스                    #
'#=========================================#
class CAwardItem
	public FItemID
	public FItemName
	public FSellYn
	public FLimitYn
	public FLimitNo
	public FLimitSold

	public FMakerID
	public FBrandName

	public FImageSmall
	public FImageList
	public FImageList120
	public FImageBasic
    public Ficon1image
    public Ficon2image
    
	public FSellCash

	public FCurrRank
	public FLastRank
	
	public FSaleYN
	public FOrgPrice
	public FSalePrice
	
	public FItemCouponYN
	public FItemCouponType
	public FItemCouponValue
	public FCurrItemCouponIdx
    
    public FEvalcnt
    public FReIpgoDate
    
	public FSpecialUserItem
	public Freviewcnt
	public FCurrPos
	Public Fyyyy
	Public Flastweek

	Public FSocName_Kor
	
	Public FGiftFlg
	Public FHhitFlg
	Public FSaleFlg
	Public FSmileFlg
	Public FDGNComment
	Public FNewFlg
	Public Fsoclogo
	public FSocname
	Public Fmodelimg

	Public Fmodelitem
	Public FModelBimg
	Public FDeliverytype

	public FCateCode
    public Fregdate
    public FItemDiv
    public FFavCount  '20140919 추가
	Public FevaUserid '20150604 추가
	Public FevaContents '20150604 추가
	Public FevaTotalpoint '20150604 추가

	public FPoints '별점
	public FadultType
	public FRecommendcount '찜브랜드카운트

	'// 해외직구배송작업추가
	Public FDeliverFixDay

    public Function IsNewItem()
        IsNewItem = datediff("d",FRegdate,Now()) < 14
    end function

	'// 마일리지샵 아이템 여부 '!
	public Function IsMileShopitem() 
		IsMileShopitem = (FItemDiv="82")
	end Function

    '// 판매종료  여부 : 판매중인것만 불러옴.;
	public Function IsSoldOut() '!
	    isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
	end Function
	
	'//	한정 여부
	public Function IsLimitItem() '! 
			IsLimitItem= (FLimitYn="Y")
	end Function
	
	'// 무료 배송 쿠폰 여부
	public function IsFreeBeasongCoupon() '?
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function
	
	'// 한정 상품 남은 수량
	public Function FRemainCount()	'!
		if IsSoldOut then
			FRemainCount=0
		else
			FRemainCount=(clng(FLimitNo) - clng(FLimitSold))
		end if
	End Function
	
	'// 재입고 상품 여부
	public Function isReipgoItem() 
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function

	'//일시품절 여부
	public Function isTempSoldOut() 
		isTempSoldOut = (FSellYn="S")
	end Function 

	'// 무료 배송 여부
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

	public function GetLevelUpArrow()
		if (FCurrRank<FLastRank) then
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_up.gif' width='7' height='4' align='absmiddle'> <font class='verdanared'><b>" & GetLevelUpCount() & "</b></font>"
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
			'##기존 GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2008/award/s_arrow_new.gif' width='9' height='5'>"
		elseif (FCurrRank=FLastRank) then
			GetLevelUpArrow = "<font class='eng11px00'><b>0</b></font>"
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
			'##기존 GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2008/award/s_arrow_new.gif' width='9' height='5'>"
		else
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_down.gif' width='7' height='4' align='absmiddle'> <font class='verdanabk'><b>" & GetLevelUpCount() & "</b></font>"
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpArrow = "<font class='eng11px00'><b>0</b></font>"
			end if
		end if
	end Function
		
	public function GetLevelUpArrowM()
		if (FCurrRank<FLastRank) then
			GetLevelUpArrowM = "<p class='elmBg bestUp'>" & GetLevelUpCount() & "</p>"
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpArrowM = ""
		elseif (FCurrRank=FLastRank) then
			GetLevelUpArrowM = ""
			'GetLevelUpArrow = ""
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpArrowM = ""
		else
			GetLevelUpArrowM = "<p class='elmBg bestDown'>" & GetLevelUpCount() & "</p>"
			if FCurrRank-FLastRank>=FCurrPos then
				'GetLevelUpArrow = "<font class='eng11px00'><b>0</b></font>"
				GetLevelUpArrowM = ""
			end if
		end if
	end Function
	
	public function GetLevelUpStr()

		if (FCurrRank<FLastRank) then
			GetLevelUpStr = "<font color=#C80708>▲" + CStr(FLastRank-FCurrRank) + "</font>"
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpStr = "<FONT color=#31AD00><B>NEW</B>"
		elseif (FCurrRank=FLastRank) then
			GetLevelUpStr = "&nbsp;<font color=#000000></font>"
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpStr = "<FONT color=#31AD00><B>NEW</B>"
		else
			GetLevelUpStr = "<font color=#005AFF>▼" + CStr(FCurrRank-FLastRank) + "</font>"
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpStr = "&nbsp;<font color=#000000></font>"
			end if
		end if
	end function

	public function GetSimpleUpStr()

		if (FCurrRank<FLastRank) then
			GetSimpleUpStr = "<font color=#C80708>+" + CStr(FLastRank-FCurrRank) + "</font>"
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetSimpleUpStr = "<FONT color=#31AD00><B>NEW</B>"
		elseif (FCurrRank=FLastRank) then
			GetSimpleUpStr = "<font color=#000000></font>"
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetSimpleUpStr = "<FONT color=#31AD00><B>NEW</B>"
		else
			GetSimpleUpStr = "<font color=#005AFF>-" + CStr(FCurrRank-FLastRank) + "</font>"
			if FCurrRank-FLastRank>=FCurrPos then
				GetSimpleUpStr = "<font color=#000000></font>"
			end if
		end if
	end function

	public function GetWriteDateStr()
		if IsNULL(Fregdate) then
			GetWriteDateStr = ""
		else
			GetWriteDateStr = Left(CStr(Fregdate),10)
		end if
	end function

	public function IsSpecialUserItem()
		IsSpecialUserItem = (FSpecialUserItem>0) and (getLoginUserLevel()>0 and getLoginUserLevel()<>5)
	end function

	public function IsSaleItem()
			IsSaleItem = ((FSaleYN="Y") and (FOrgPrice>FSellCash)) or (IsSpecialUserItem)
	end function
    
    public Function getSalePro() 
		if FOrgprice=0 then
			getSalePro = 0
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100) & "%"
		end if
	end Function
	
    public Function IsCouponItem() 
			IsCouponItem = (FItemCouponYN="Y")
	end Function
	
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
	
	' 상품 쿠폰 내용
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

	public function getOrgPrice()
		if FOrgPrice=0 then
			getOrgPrice = FSellCash
		else
			getOrgPrice = FOrgPrice
		end if
	end function

	public function getRealPrice()
		getRealPrice = FSellCash

		if (IsSpecialUserItem()) then
		    getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function
	
	'// 해외직구배송작업추가
	Public Function IsDirectPurchase()
		IsDirectPurchase = False
		if (FDeliverFixDay = "G") Then
			IsDirectPurchase = true
		End if
	End Function
		

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

'#=========================================#
'# 어워드 클래스                           #
'#=========================================#

class CAWard
	public FItemList()
	public FResultCount

	public FTotalPage
	public FPageSize
	public FScrollCount
	public FRectExtOnly
	public FRectJewelry
	public FRectFashion
	Public FRectCDL
	Public FRectCDM
	public FRectAwardgubun
	Public FRectLastWeek
	Public FPrevID
	Public FNextID
	
	public FMakerID1
	public FMakerID2
	public FMakerID3
	public FMakerID4
	Public FMoney1
	Public FMoney2

	Public FCurrpage
	
    public FRectDisp1
    public FRectDisp2

    public FRectDategubun	'기간별 검색 w:주간 , m:월간
    public FRectCateCode
	public FRectUserlevel
	public FRectAgegubun
	public FRectSexFlag	

	public function GetImageFolerName(byval i)
	    GetImageFolerName = GetImageSubFolderByItemid(FItemList(i).FItemID)
	end function

	public Sub GetNormalItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_awardItemList_2013 " & FPageSize & ",'" & FRectAwardgubun & "','" & FRectDisp1 & "','" & FRectDisp2 & "'"

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWRD",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount") 
				FItemList(i).FPoints			= rsMem("totalpoint")
				FItemList(i).FadultType			= rsMem("adultType")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	public Sub GetVIPItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_VIP_AwardItemList " & FPageSize & ""

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWVIP",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount") 

                FItemList(i).FevaUserid          = rsMem("evauserid") 
                FItemList(i).FevaContents          = rsMem("evaContents") 
                FItemList(i).FevaTotalpoint          = rsMem("evaTotalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	End Sub

	public Sub GetVIPItemList_2017()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_VIP_AwardItemList_2017 " & FPageSize & ", '"&FRectCateCode&"' "

'		if FRectExtOnly=true then
'			sqlStr = sqlStr + ",1"
'		else
'			sqlStr = sqlStr + ",0"
'		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWVIP",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount") 

                FItemList(i).FevaUserid          = rsMem("evauserid") 
                FItemList(i).FevaContents          = rsMem("evaContents") 
                FItemList(i).FevaTotalpoint          = rsMem("evaTotalpoint") 

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	End Sub

	public Sub GetBrandItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_Brand_AwardItemList " & FPageSize & ""

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWBRAND",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
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
                FItemList(i).FFavCount          = rsMem("favcount") 
				FItemList(i).FSocName_Kor  = rsMem("socName_kor")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	End Sub

	public Sub GetBrandItemList_2017()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_Brand_AwardItemList_2017 " & FPageSize & ", '"&FRectCateCode&"' "

'		if FRectExtOnly=true then
'			sqlStr = sqlStr + ",1"
'		else
'			sqlStr = sqlStr + ",0"
'		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWBRAND",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
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
                FItemList(i).FFavCount          = rsMem("favcount") 
				FItemList(i).FSocName_Kor		= rsMem("socName_kor")

				FItemList(i).Frecommendcount	= rsMem("recommendcount")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	End Sub

	public Sub GetManItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_Man_AwardItemList " & FPageSize & ""

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWMAN",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount") 

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	public Sub GetSteadyItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_Steady_AwardItemList  " & FPageSize & ""

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWSTEADY",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount") 

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	public Sub GetSteadyItemList_2017()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_Steady_AwardItemList_2017 " & FPageSize & ", '"&FRectCateCode&"' "

'		if FRectExtOnly=true then
'			sqlStr = sqlStr + ",1"
'		else
'			sqlStr = sqlStr + ",0"
'		end if
		
		'response.write sqlStr
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWSTEADY",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")
                
                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub


	public Sub GetToday30ItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_AwardItemList_Today30 " & FPageSize & ",'" & FRectCDL & "','" & FRectCDM & "'"

		if FRectExtOnly=true then
			sqlStr = sqlStr + ",1"
		else
			sqlStr = sqlStr + ",0"
		end if
'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsget("itemid")
				FItemList(i).FItemName  = db2html(rsget("itemname"))

				FItemList(i).FMakerID   = rsget("makerid")
				FItemList(i).FBrandName = db2html(rsget("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsget("listimage120")
				FItemList(i).FImageBasic = rsget("basicimage")
                
                FItemList(i).Ficon1image = rsget("icon1image")
                FItemList(i).Ficon2image = rsget("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsget("sellcash")

				FItemList(i).FSaleYN    = rsget("sailyn")
				FItemList(i).FSalePrice = rsget("sailprice")
				FItemList(i).FOrgPrice   = rsget("orgprice")

				FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
				FItemList(i).Freviewcnt         = rsget("evalcnt")
				FItemList(i).FRegdate           = rsget("regdate")
            
				FItemList(i).FItemCouponYN      = rsget("itemcouponyn")
                FItemList(i).FItemCouponType    = rsget("itemcoupontype") 
                FItemList(i).FItemCouponValue   = rsget("itemcouponvalue") 
                FItemList(i).FCurrItemCouponIdx = rsget("curritemcouponidx") 
                
                FItemList(i).FEvalcnt           = rsget("Evalcnt") 
                FItemList(i).FReIpgoDate        = rsget("reipgodate") 
                
                FItemList(i).FSellYn            = rsget("sellyn") 
                FItemList(i).FLimitYn           = rsget("limityn") 
                FItemList(i).FLimitNo           = rsget("limitno") 
                FItemList(i).FLimitSold         = rsget("limitsold") 


				FItemList(i).FCurrPos = i+1

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub


	public Sub GetLastWeekList()
		dim sqlStr,i

		sqlStr = "select top " + CStr(FPageSize) + "  yyyy,lastweek,itemid,itemname,imgsmall" + vbcrlf
		sqlStr = sqlStr + " from [db_log].[dbo].tbl_award_week_log" + vbcrlf
		sqlStr = sqlStr + " where awardgubun='" + FRectAwardgubun + "'"
		sqlStr = sqlStr + " and lastweek = " + Cstr(FRectLastWeek) + "" + vbcrlf
		sqlStr = sqlStr + " order by tcrank Asc, tcnt desc"
'response.write sqlStr
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).Fyyyy    = rsget("yyyy")
				FItemList(i).Flastweek    = rsget("lastweek")
				FItemList(i).FItemID    = rsget("itemid")
				FItemList(i).FItemName  = db2html(rsget("itemname"))
				if Len(FItemList(i).FItemName)>15 then
					FItemList(i).FItemName = Left(FItemList(i).FItemName,13) + "..."
				end if
				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("imgsmall")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close


		sqlStr = "select top 1 MIN(lastweek) as mweek from (" + vbcrlf
		sqlStr = sqlStr + " select  lastweek" + vbcrlf
		sqlStr = sqlStr + " from [db_log].[dbo].tbl_award_week_log" + vbcrlf
		sqlStr = sqlStr + " where awardgubun='" + FRectAwardgubun + "'"
		sqlStr = sqlStr + " and (lastweek > " + CStr(FRectLastWeek) + ") "
		sqlStr = sqlStr + " group by lastweek" + vbcrlf
		sqlStr = sqlStr + ") as T" + vbcrlf

		rsget.Open sqlStr, dbget, 1
		if  not rsget.EOF  then
              FPrevID = rsget("mweek")
		else
		      FPrevID = -1
		end if
		rsget.close

		sqlStr = "select top 1 MAX(lastweek) as mweek from (" + vbcrlf
		sqlStr = sqlStr + " select  lastweek" + vbcrlf
		sqlStr = sqlStr + " from [db_log].[dbo].tbl_award_week_log" + vbcrlf
		sqlStr = sqlStr + " where awardgubun='" + FRectAwardgubun + "'"
		sqlStr = sqlStr + " and (lastweek < " + CStr(FRectLastWeek) + ") "
		sqlStr = sqlStr + ") as T" + vbcrlf

		rsget.Open sqlStr, dbget, 1
		if  not rsget.EOF  then
              FNextID = rsget("mweek")
		else
		      FNextID = -1
		end if
		rsget.close

	end Sub

	'// 카테고리 지정시 목록 클래스 //
	public Sub GetBrandAwardList()
		dim sqlStr,i

		sqlStr = "exec db_const.dbo.sp_Ten_awardBrandList " & FPageSize & ",'" & FRectCDL & "','" & FRectAwardgubun & "'"

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FMakerID		= rsget("userid")
				FItemList(i).FSocname		= db2html(rsget("socname"))
				FItemList(i).FSocname_Kor	= db2html(rsget("socname_kor"))
				''FItemList(i).FDGNComment	= db2html(rsget("dgncomment"))
				If isNull(rsget("soclogo")) Then
					FItemList(i).Fsoclogo		= "http://fiximage.10x10.co.kr/web2009/bestaward/nologo.gif"
				Else
					FItemList(i).Fsoclogo		= "http://webimage.10x10.co.kr/image/brandlogo/" & db2html(rsget("soclogo"))
				End IF

				FItemList(i).FGiftFlg		= rsget("giftflg")
				FItemList(i).FHhitFlg		= rsget("hitflg")
				FItemList(i).FSaleFlg		= rsget("saleflg")
				FItemList(i).FSmileFlg		= rsget("smileflg")
				FItemList(i).FNewFlg		= rsget("newflg")

				FItemList(i).Fmodelitem		= rsget("modelitem")
				FItemList(i).FItemID		= FItemList(i).Fmodelitem
				''FItemList(i).FModelBimg		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).Fmodelitem) + "/" + rsget("modelbimg")

				FItemList(i).FCateCode		= rsget("catecode")
                
                FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsget("listimage120")
				FItemList(i).FImageBasic = rsget("basicimage")
                
                FItemList(i).Ficon1image = rsget("icon1image")
                FItemList(i).Ficon2image = rsget("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub


	'// 가격별 베스트 셀러 //
	public Sub GetBestSellersPrice()
		dim sqlStr,i

		sqlStr = "exec db_const.dbo.sp_Ten_AwardBestSellers_Price '" & FRectCDL & "','" & FMoney1 & "','" & FMoney2 & "'"
'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemDiv    = rsget("itemdiv")
				FItemList(i).FItemID    = rsget("itemid")
				FItemList(i).FItemName  = db2html(rsget("itemname"))

				FItemList(i).FMakerID   = rsget("makerid")
				FItemList(i).FBrandName = db2html(rsget("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsget("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsget("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsget("listimage120")
				FItemList(i).FImageBasic = rsget("basicimage")
                
                FItemList(i).Ficon1image = rsget("icon1image")
                FItemList(i).Ficon2image = rsget("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsget("sellcash")

				FItemList(i).FCurrRank     = rsget("currrank")
				FItemList(i).FLastRank     = rsget("lastrank")


				FItemList(i).FSaleYN    = rsget("sailyn")
				FItemList(i).FSalePrice = rsget("sailprice")
				FItemList(i).FOrgPrice   = rsget("orgprice")

				FItemList(i).FSpecialUserItem   = rsget("specialuseritem")
				FItemList(i).Freviewcnt         = rsget("evalcnt")
				FItemList(i).FRegdate           = rsget("regdate")
            
				FItemList(i).FItemCouponYN      = rsget("itemcouponyn")
                FItemList(i).FItemCouponType    = rsget("itemcoupontype") 
                FItemList(i).FItemCouponValue   = rsget("itemcouponvalue") 
                FItemList(i).FCurrItemCouponIdx = rsget("curritemcouponidx") 
                
                FItemList(i).FEvalcnt           = rsget("Evalcnt") 
                FItemList(i).FReIpgoDate        = rsget("reipgodate") 
                
                FItemList(i).FSellYn            = rsget("sellyn") 
                FItemList(i).FLimitYn           = rsget("limityn") 
                FItemList(i).FLimitNo           = rsget("limitno") 
                FItemList(i).FLimitSold         = rsget("limitsold") 


				FItemList(i).FCurrPos = i+1

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub



	'// 브랜드 베스트상품 목록 //
	public sub GetBrandAwardTop4ItemList()
		dim sqlStr, i

		'// 목록 접수 //
		sqlStr =	"exec db_const.dbo.sp_Ten_AwardBrandTop4ItemList " & FpageSize & ",'" & FMakerID1 & "','" & FMakerID2 & "','" & FMakerID3 & "','" & FMakerID4 & "'"

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FitemId		= rsget("itemid")
				FItemList(i).Ficon1Image	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1image")
				FItemList(i).FItemName		= rsget("itemname")
				FItemList(i).FMakerID		= rsget("makerid")

				i=i+1
				rsget.moveNext
			loop

		end if
		rsget.Close
	end sub	


	'// 지난주 브랜드 목록 클래스 //
	public Sub GetBrandLastWeekList()
		dim sqlStr,i

		'주간 인기 브랜드 접수
		sqlStr =	"Select top " & CStr(FPageSize) & "  yyyy, lastweek, makerid, modelitem, modelimg, socname_kor " &_
					"From [db_log].[dbo].tbl_brand_award_week_log " &_
					"Where awardgubun='" & FRectAwardgubun + "'" &_
					"		and lastweek = " & Cstr(FRectLastWeek) &_
					" Order by point desc "

		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).Fyyyy			= rsget("yyyy")
				FItemList(i).Flastweek		= rsget("lastweek")
				FItemList(i).Fmakerid		= rsget("makerid")
				FItemList(i).Fsocname_kor	= db2html(rsget("socname_kor"))
				FItemList(i).FItemID		= rsget("modelitem")
				FItemList(i).Fmodelimg		= "http://webimage.10x10.co.kr/image/small/" + GetBrandImageFolerName(FItemList(i).FItemID) + "/" + rsget("modelimg")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close


		sqlStr = "select top 1 MIN(lastweek) as mweek from (" + vbcrlf
		sqlStr = sqlStr + " select  lastweek" + vbcrlf
		sqlStr = sqlStr + " from [db_log].[dbo].tbl_brand_award_week_log" + vbcrlf
		sqlStr = sqlStr + " where awardgubun='" + FRectAwardgubun + "'"
		sqlStr = sqlStr + " and (lastweek > " + CStr(FRectLastWeek) + ") "
		sqlStr = sqlStr + " group by lastweek" + vbcrlf
		sqlStr = sqlStr + ") as T" + vbcrlf

		rsget.Open sqlStr, dbget, 1
		if  not rsget.EOF  then
              FPrevID = rsget("mweek")
		else
		      FPrevID = -1
		end if
		rsget.close

		sqlStr = "select top 1 MAX(lastweek) as mweek from (" + vbcrlf
		sqlStr = sqlStr + " select  lastweek" + vbcrlf
		sqlStr = sqlStr + " from [db_log].[dbo].tbl_brand_award_week_log" + vbcrlf
		sqlStr = sqlStr + " where awardgubun='" + FRectAwardgubun + "'"
		sqlStr = sqlStr + " and (lastweek < " + CStr(FRectLastWeek) + ") "
		sqlStr = sqlStr + ") as T" + vbcrlf

		rsget.Open sqlStr, dbget, 1
		if  not rsget.EOF  then
              FNextID = rsget("mweek")
		else
		      FNextID = -1
		end if
		rsget.close

	end Sub

	'기간별 베스트
	public Sub GetDateItemList()
		dim sqlStr,i
		if FRectDategubun <> "" then
			FRectDategubun = FRectDategubun
		else
			FRectDategubun = "m"
		end if

		sqlStr = "exec db_const.dbo.sp_Ten_Date_AwardItemList " & FPageSize & ", '" & FRectDategubun & "', '"&FRectCateCode&"'"

'		response.write sqlStr
'		response.end
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWDATE",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")
                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	public Sub GetCategoryBestItemList()
		dim sqlStr,i
		if FRectDategubun <> "" then
			FRectDategubun = FRectDategubun
		else
			FRectDategubun = "m"
		end if

		sqlStr = "exec db_temp.dbo.usp_WWW_Ten_Date_AwardItemList " & FPageSize & ", '" & FRectDategubun & "'"

'		response.write sqlStr
'		response.end
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWDATE",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")
                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	'회원등급별 베스트
	public Sub GetUserLevelItemList()
		dim sqlStr,i
		select case FRectUserlevel
			case 7,8,9
				FRectUserlevel = "Guest"
			case 0,5
				FRectUserlevel = "WHITE"
			case 1
				FRectUserlevel = "RED"
			case 2
				FRectUserlevel = "VIP"
			case 3
				FRectUserlevel = "VIP GOLD"
			case 4,6
				FRectUserlevel = "VVIP"
			case else
				FRectUserlevel = "Guest"
		end select

		sqlStr = "exec db_const.dbo.sp_Ten_UserLevel_AwardItemList " & FPageSize & ", '" & FRectUserlevel & "', '"&FRectCateCode&"'  "

'		response.write sqlStr
'		response.end
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWULEVEL",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")
                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	'연령별 베스트
	public Sub GetAgeItemList()
		dim sqlStr,i,rndm
		if FRectAgegubun <> "" and isNumeric(FRectAgegubun) then
			FRectAgegubun = FRectAgegubun
		else
			randomize
			rndm = int(Rnd*10)+1
		
			SELECT CASE rndm
				Case 1, 2 : FRectAgegubun = 10
				Case 3, 4, 5 : FRectAgegubun = 20
				Case 6, 7, 8 : FRectAgegubun = 30
				Case 9, 10 : FRectAgegubun = 40
				Case Else : FRectAgegubun = 20
			END SELECT
		end if

		if FRectSexFlag = "" then FRectSexFlag = 0

		sqlStr = "exec db_const.dbo.sp_Ten_Age_AwardItemList " & FPageSize & ", '" & FRectAgegubun & "', '"&FRectCateCode&"', " & FRectSexFlag & " "

'		response.write sqlStr
'		response.end
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWAGE",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")

                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub

	'첫구매 베스트
	public Sub GetFirstOrderItemList()
		dim sqlStr,i

		sqlStr = "exec db_const.dbo.sp_Ten_FirstOrder_AwardItemList " & FPageSize & ", '"&FRectCateCode&"' "

'		response.write sqlStr
'		response.end
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType = adOpenStatic
'		rsget.LockType = adLockOptimistic
'		rsget.Open sqlStr,dbget,1
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"AWFIRST",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		FResultCount = rsMem.Recordcount

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsMem.EOF  then
			do until rsMem.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FItemID    = rsMem("itemid")
				FItemList(i).FItemName  = db2html(rsMem("itemname"))

				FItemList(i).FMakerID   = rsMem("makerid")
				FItemList(i).FBrandName = db2html(rsMem("brandname"))

				FItemList(i).FImageSmall= "http://webimage.10x10.co.kr/image/small/" + GetImageFolerName(i) + "/" + rsMem("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageFolerName(i) + "/" + rsMem("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageFolerName(i) + "/" + rsMem("listimage120")
				FItemList(i).FImageBasic = rsMem("basicimage")
                
                FItemList(i).Ficon1image = rsMem("icon1image")
                FItemList(i).Ficon2image = rsMem("icon2image")
                

				if FItemList(i).FImageBasic<>"" then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageFolerName(i) + "/" + FItemList(i).FImageBasic
				end if
                
                if FItemList(i).Ficon1image<>"" then
					FItemList(i).Ficon1image = "http://webimage.10x10.co.kr/image/icon1/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon1image
				end if
				
				if FItemList(i).Ficon2image<>"" then
					FItemList(i).Ficon2image = "http://webimage.10x10.co.kr/image/icon2/" + GetImageFolerName(i) + "/" + FItemList(i).Ficon2image
				end if
				
                
				FItemList(i).FSellCash  = rsMem("sellcash")

				FItemList(i).FCurrRank     = rsMem("currrank")
				FItemList(i).FLastRank     = rsMem("lastrank")


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
                FItemList(i).FFavCount          = rsMem("favcount")
                FItemList(i).FPoints			= rsMem("totalpoint")

				'// 해외직구배송작업추가
                FItemList(i).FDeliverFixDay		= rsMem("deliverfixday")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsMem.moveNext
			loop
		end if

		rsMem.Close

	end Sub
	
	public function GetBrandImageFolerName(byval itemid)
    	If itemid <> ""  then
    		GetBrandImageFolerName = GetImageSubFolderByItemid(itemid)
    	End if
	end function


	'### 가격별 베스트 셀러. 카테고리별 가격 범위.
	Public Function GetPriceBetween(vCdl)
		Select Case vCdl
			Case "010"	'#디자인문구
				GetPriceBetween = "5000,10000,15000"
			Case "020"	'#오피스/개인
				GetPriceBetween = "5000,10000,15000"
			Case "030"	'#키덜트/취미
				GetPriceBetween = "5000,10000,25000"
			Case "040"	'#가구/수납
				GetPriceBetween = "30000,70000,150000"
			Case "050"	'#조명/데코
				GetPriceBetween = "10000,25000,50000"
			Case "055"	'#페브릭
				GetPriceBetween = "15000,30000,70000"
			Case "060"	'#주방/욕실
				GetPriceBetween = "10000,25000,50000"
			Case "070"	'#가방/슈즈/쥬얼리
				GetPriceBetween = "10000,25000,50000"
			Case "080"	'#Women
				GetPriceBetween = "15000,30000,50000"
			Case "090"	'#Men
				GetPriceBetween = "15000,25000,50000"
			Case "100"	'#Baby
				GetPriceBetween = "10000,25000,50000"
			Case "110"	'#감성채널
				GetPriceBetween = "5000,15000,30000"
		End Select
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

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrpage = 1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

'////카테고리 베스트 셀렉트 콤보 박스 - 대카테고리
Sub DrawSelectBoxCategoryLarge(byval selectBoxName,selectedId)
   dim tmp_str,query1
   %>
   <select name="<%=selectBoxName%>" onChange="changecontent('L')" style="width:48.5%" title="대분류를 선택해주세요">
     <option value="" <% if selectedId="" then response.write " selected"%>>전체</option>
	 <%
	   query1 = " select code_large, code_nm from [db_item].[dbo].tbl_Cate_large "
	   query1 = query1 + " where display_yn = 'Y' and channel < '99'"
	   query1 = query1 + " order by code_large Asc"

	   rsget.Open query1,dbget,1

	   if  not rsget.EOF  then
		   rsget.Movefirst

		   do until rsget.EOF
			   if Cstr(selectedId) = Cstr(rsget("code_large")) then
				   tmp_str = " selected"
			   end if
			   response.write("<option value='"&rsget("code_large")&"' "&tmp_str&">"& db2html(rsget("code_nm")) &"</option>")
			   tmp_str = ""
			   rsget.MoveNext
		   loop
	   end if
	   rsget.close
	   response.write("</select>")
end Sub

'////카테고리 베스트 셀렉트 콤보 박스 - 중카테고리
Sub DrawSelectBoxCategoryMid(byval selectBoxName,largeno,selectedId)
   dim tmp_str,query1
   %>
   <select name="<%=selectBoxName%>" onChange="changecontent('M')" style="width:48.5%" title="중분류를 선택해주세요">
     <option value="" <% if selectedId="" then response.write " selected"%>>전체</option>
	 <%
		query1 = " SELECT m.code_mid as code_mid, m.code_nm as code_nm FROM [db_item].dbo.tbl_Cate_mid m"
		query1 = query1 & " JOIN [db_item].dbo.tbl_Cate_small s  "
		query1 = query1 & "	ON m.code_mid=s.code_mid and m.code_large=s.code_large and s.display_Yn='Y' "
		query1 = query1 & "	WHERE m.code_large='" & largeno & "' and m.display_Yn='Y' "
		query1 = query1 & "	GROUP BY m.code_mid,m.orderNO,m.code_nm "
		query1 = query1 & "	ORDER BY m.orderNO, m.code_mid "

	   rsget.Open query1,dbget,1

	   if  not rsget.EOF  then
		   rsget.Movefirst

		   do until rsget.EOF
			   if Not(isNull(selectedId)) then
				   if Cstr(selectedId) = Cstr(rsget("code_mid")) then
					   tmp_str = " selected"
				   end if
			   end if
			   response.write("<option value='"&rsget("code_mid")&"' "&tmp_str&">"& db2html(rsget("code_nm")) &"</option>")
			   tmp_str = ""
			   rsget.MoveNext
		   loop
	   end if
	   rsget.close
	   response.write("</select>")
end Sub

'// 내 찜브랜드 상품 목록(검색 결과에서 상품목록 전송)
Sub getMyZzimBrandList(uid,iid,byRef sWArr)
  'Exit Sub ''사용안함 2014/09/23
	dim strSQL
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyZzimBrandSearchItem] '" & CStr(uid) & "', '" & cStr(iid) & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open strSQL,dbget,adOpenForwardOnly,adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
		sWArr = rsget.getRows()
	end if
	rsget.Close
end Sub

Function fnIsMyZzimBrand(arr,makerid)
Dim i, r
	r = False
	If isArray(arr) Then
		For i=0 To UBound(arr,2)
			If InStr((","&arr(0,i)&","),(","&makerid&",")) > 0 Then
				r = True
				Exit For
			End If
		Next
	End If
	fnIsMyZzimBrand = r
End Function

Function getUserAge(userid)
	dim strSql

	if userid="" then
		exit function
	end if

	strSql = "select top 1 " + vbcrlf
	strSql = strSql + "	Case When (year(getdate()) - year(n.birthday) + 1) >= 14 and (year(getdate()) - year(n.birthday) + 1) <= 19 Then '10' "  + vbcrlf
	strSql = strSql + "		When (year(getdate()) - year(n.birthday) + 1) >= 20 and (year(getdate()) - year(n.birthday) + 1) <= 29 Then '20' "  + vbcrlf
	strSql = strSql + "		When (year(getdate()) - year(n.birthday) + 1) >= 30 and (year(getdate()) - year(n.birthday) + 1) <= 39 Then '30' "  + vbcrlf
	strSql = strSql + "	Else '40' "  + vbcrlf
	strSql = strSql + "	end as age "  + vbcrlf
	strSql = strSql + "from db_user.dbo.tbl_user_n as n "  + vbcrlf
	strSql = strSql + "where userid='" & CStr(userid) &"' "
'response.write strSql
'response.end
	rsget.open strSql, dbget
	IF not rsget.EOF THEN
		getUserAge = rsget("age")
	else
		getUserAge = ""
	END IF
	rsget.close
End Function

Function getAdminAtype()
	dim strSql

	strSql = "select top 1 bestgubun from db_sitemaster.dbo.tbl_mobile_best_gubun" + vbcrlf
'response.write strSql
'response.end
	rsget.open strSql, dbget
	IF not rsget.EOF THEN
		getAdminAtype = rsget("bestgubun")
	else
		getAdminAtype = ""
	END IF
	rsget.close
End Function
%>



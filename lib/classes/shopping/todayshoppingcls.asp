<%
'' Require iteminfoCls.asp

Class CTodayShoppingCateCnt
    public FCDL
    public FCount
    
    Private Sub Class_Initialize()

	End Sub
    
    Private Sub Class_Terminate()

	End Sub
end Class

class CTodayShopping
    public FItemList()
    public FOneItem
    
	public FResultCount
	public FPageSize
	public FCurrpage
	public FTotalCount
	public FTotalPage
	public FScrollCount

    public FRectUserID
    public FRectCDL
	public FRectOrderType
	public FRectSortMethod
	public FRectItemIdArrList '2014/09/19 추가

	'// 2017/05/12 추가
	Public FRecttypeitem
	Public FRecttypeevt
	Public FRecttypemkt
	Public FRecttypebrand
	Public FRecttyperect
	Public FRectmaxid
	Public FRectstdnum
	Public FRectpagesize
	Public FRectplatform
	
	public function GetCommaDelimArr()
	    dim todayitemlistArr
        '' .js에서 Maxmum count 설정되어 있음. , (0) may be ''
        todayitemlistArr = Trim(request.cookies("todayviewitemidlist"))
        
        if (Left(todayitemlistArr,1)="|") then todayitemlistArr=Mid(todayitemlistArr,2,1024)
        
        if (Right(todayitemlistArr,1)="|") then todayitemlistArr=Left(todayitemlistArr,Len(todayitemlistArr)-1)
        
        todayitemlistArr = Replace(todayitemlistArr,"|",",")
        
	    GetCommaDelimArr = todayitemlistArr
    end function

	public function GetCateViewCount(iCdL)
	    GetCateViewCount = 0
	    '' Using Only CTodayShoppingCateCnt
        dim i
        
        GetCateViewCount = 0
        
        for i=0 to FResultCount-1
            if (FItemList(i).FCDL=iCdL) then
                GetCateViewCount = FItemList(i).FCount
                Exit function
            end if
        next
    end function
    
    
	public Sub getMyTodayViewCateCount()
	    dim sqlStr, todayitemlistArr
	    
    	todayitemlistArr = GetCommaDelimArr

        if (todayitemlistArr="") then Exit Sub
        
        sqlStr = "select cate_large, count(itemid) as cnt"
        sqlStr = sqlStr + " from [db_item].[dbo].tbl_item"
        sqlStr = sqlStr + " where itemid in (" & todayitemlistArr & ")"
        sqlStr = sqlStr + " group by cate_large"
        
        rsget.Open sqlStr,dbget,1
		
		FTotalCount  = 0
		FResultCount = rsget.RecordCount
		
		if (FResultCount<1) then FResultCount=0
		
		redim preserve FItemList(FResultCount)
		
		if Not rsget.Eof then
		    do until rsget.eof
				set FItemList(i)    = new CTodayShoppingCateCnt
    		    FItemList(i).FCDL   = rsget("cate_large")
    		    FItemList(i).FCount = rsget("cnt")
    		    
    		    FTotalCount         = FTotalCount + FItemList(i).FCount
    		    i=i+1
    		    rsget.MoveNext
    		loop
		end if
		rsget.close
		
	end Sub
	
    public Sub getMyTodayViewList()
        dim sqlStr, todayitemlistArr
        
        if (FRectItemIdArrList<>"") then
	        todayitemlistArr = FRectItemIdArrList  ''앱에서 사용
	    else
    	    todayitemlistArr = GetCommaDelimArr
    	end if

        if (todayitemlistArr="") then Exit Sub
        
        sqlStr = "select count(itemid) as cnt "
        sqlStr = sqlStr + " from [db_item].[dbo].tbl_item"
        sqlStr = sqlStr + " where itemid in (" & todayitemlistArr & ")"
        if (FRectCDL<>"") then
            sqlStr = sqlStr + " and cate_large='" & FRectCDL & "'"
        end if
        
        if (FRectSortMethod="saleop") then
            sqlStr = sqlStr + " and sailyn='Y'"
        elseif (FRectSortMethod="coupon") then
            sqlStr = sqlStr + " and itemcouponyn='Y'"
        elseif (FRectSortMethod="newitem") then
            sqlStr = sqlStr + " and datediff(day,regdate,getdate())<=14"
        elseif (FRectSortMethod="limit") then
            sqlStr = sqlStr + " and limityn='Y'"
        end if
        
        rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.close
		
		   
        sqlStr = "select top " & CStr(FPageSize*FCurrPage) & " cate_large, cate_mid, cate_small"
        sqlStr = sqlStr + " ,itemid, itemname, sellcash, sellyn, limityn, limitno, limitsold"
        sqlStr = sqlStr + " ,itemgubun, deliverytype, evalcnt, itemcouponyn, itemcoupontype, itemcouponvalue,curritemcouponidx"
        sqlStr = sqlStr + " ,smallimage, listimage, listimage120, icon1image, makerid, brandname, regdate, sailyn, sailprice"
        sqlStr = sqlStr + " ,orgprice, specialuseritem, evalcnt, optioncnt, itemdiv"
        sqlStr = sqlStr + " from [db_item].[dbo].tbl_item"
        sqlStr = sqlStr + " where itemid in (" & todayitemlistArr & ")"
        if FRectCDL<>"" then
            sqlStr = sqlStr + " and cate_large='" & FRectCDL & "'"
        end if
        
        if (FRectSortMethod="saleop") then
            sqlStr = sqlStr + " and sailyn='Y'"
        elseif (FRectSortMethod="coupon") then
            sqlStr = sqlStr + " and itemcouponyn='Y'"
        elseif (FRectSortMethod="newitem") then
            sqlStr = sqlStr + " and datediff(day,regdate,getdate())<=14"
        elseif (FRectSortMethod="limit") then
            sqlStr = sqlStr + " and limityn='Y'"
        end if
        
        if FRectOrderType="fav" then
            sqlStr = sqlStr + " order by itemscore desc, itemid desc"
        elseif (FRectSortMethod="highprice") then
            sqlStr = sqlStr + " order by sellcash desc"
        elseif (FRectSortMethod="lowprice") then
            sqlStr = sqlStr + " order by sellcash asc"
        else
            sqlStr = sqlStr + " order by itemid desc"
        end if
    
        rsget.pagesize = FPageSize
        rsget.Open sqlStr, dbget, 1
        
        FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
		
        redim preserve FItemList(FResultCount)
		i=0
		if Not rsget.Eof then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FcdL          = rsget("cate_large")
				FItemList(i).FcdM          = rsget("cate_mid")
				FItemList(i).FcdS          = rsget("cate_small")
				FItemList(i).FItemID       = rsget("itemid")
				FItemList(i).FItemName     = db2html(rsget("itemname"))
				FItemList(i).FItemDiv 	= rsget("itemdiv")		'상품 속성
				
				FItemList(i).FSellcash     = rsget("sellcash")
				FItemList(i).FSellYn       = rsget("sellyn")
				FItemList(i).FLimitYn      = rsget("limityn")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")
				FItemList(i).Fitemgubun    = rsget("itemgubun")
				FItemList(i).FDeliverytype = rsget("deliverytype")

				FItemList(i).Fevalcnt       = rsget("evalcnt")
				FItemList(i).Fitemcouponyn  = rsget("itemcouponyn")
				FItemList(i).Fitemcoupontype 	= rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue 	= rsget("itemcouponvalue")
				FItemList(i).Fcurritemcouponidx = rsget("curritemcouponidx")
				
				FItemList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("smallimage")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("listimage120")
				FItemList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("icon1image")
					
				FItemList(i).FMakerID   = rsget("makerid")
				FItemList(i).FBrandName = db2html(rsget("brandname"))
				FItemList(i).FRegdate   = rsget("regdate")

				FItemList(i).FSaleYn    = rsget("sailyn")
				'FItemList(i).FSalePrice = rsget("sailprice")
				FItemList(i).FOrgPrice   = rsget("orgprice")
				FItemList(i).FSpecialuseritem = rsget("specialuseritem")
				FItemList(i).Fevalcnt = rsget("evalcnt")
				FItemList(i).FOptioncnt	= rsget("optioncnt")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.close
    end Sub

	'// 최근 본 상품 리스트
	public sub GetMyViewRecentViewList()

		dim strSQL,i, j

		'// 목록내용 가져오기
		strSQL =" EXECUTE [db_EVT].[dbo].[usp_Ten_MyViewData_temp] " &_
					" @typeitem= '" &FRecttypeitem&"'" &_
					" ,@typeevt='" &FRecttypeevt&"' " &_
					" ,@typemkt='" &FRecttypemkt&"' " &_
					" ,@typebrand ='" &FRecttypebrand& "' " &_
					" ,@typerect='" &FRecttyperect&"' " &_
					" ,@userid='" &FRectUserid&"' " &_
					" ,@maxid='" &FRectmaxid&"' " &_
					" ,@stdnum='"&FRectstdnum&"' "&_
					" ,@pagesize ='"&FRectpagesize&"' "&_
					" ,@platform = '"&FRectplatform&"'"
		rsEVTget.CursorLocation = adUseClient
		rsEVTget.CursorType = adOpenStatic
		rsEVTget.LockType = adLockOptimistic
		'rsEVTget.PageSize=FPageSize
		rsEVTget.Open strSQL, dbEVTget
		'response.write strSQL
		'FResultCount = rsEVTget.RecordCount-((FCurrPage-1)*FPageSize)
		FResultCount = rsEVTget.RecordCount
		redim FItemList(FResultCount)

		i=0
		if  not rsEVTget.EOF  then
			'rsEVTget.absolutePage=FCurrPage
			do until rsEVTget.eof
				set FItemList(i) = new CMyViewContents

				FItemList(i).FIdx	= rsEVTget("idx")
				FItemList(i).Ftype	= rsEVTget("type")
				FItemList(i).FItemid	= rsEVTget("Itemid")
				FItemList(i).FRegdate		= rsEVTget("regdate")
				FItemList(i).FItemName	= db2html(rsEVTget("ItemName"))
				FItemList(i).Fevtname	= db2html(rsEVTget("evt_name"))
				FItemList(i).FSellCash	= rsEVTget("SellCash")
				FItemList(i).FOrgPrice	= rsEVTget("OrgPrice")
				FItemList(i).FMakerId	= rsEVTget("MakerId")
				FItemList(i).FSellyn	= rsEVTget("sellYn")
				FItemList(i).FSaleyn	= rsEVTget("sailyn")
				FItemList(i).FLimityn	= rsEVTget("LimitYn")
				FItemList(i).FBrandName	= db2html(rsEVTget("socname"))
				FItemList(i).FImageList	= "http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(rsEVTget("ListImage"))
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & db2html(rsEVTget("ListImage120"))
				FItemList(i).FImageSmall	= "http://webimage.10x10.co.kr/image/small/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(rsEVTget("smallImage"))
				FItemList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsEVTget("icon1image")
				FItemList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsEVTget("icon2image")
				FItemList(i).FReipgodate	= rsEVTget("reipgodate")
				FItemList(i).FItemcouponyn	= rsEVTget("itemcouponYn")
				FItemList(i).FItemcouponvalue	= rsEVTget("itemCouponValue")
				FItemList(i).FItemcoupontype	= rsEVTget("itemCouponType")
				FItemList(i).FEvalcnt	= rsEVTget("evalCnt")
				FItemList(i).FItemScore	= rsEVTget("itemScore")

				FItemList(i).Fevtcode	= rsEVTget("evtcode")
				FItemList(i).Frect	= rsEVTget("rect")
				FItemList(i).Fplatform = rsEVTget("platform")
				FItemList(i).Fevtstartdate = rsEVTget("evt_startdate")
				FItemList(i).Fevtenddate = rsEVTget("evt_enddate")
				FItemList(i).Fevtkind = rsEVTget("evt_kind")
				FItemList(i).Fevtstate = rsEVTget("evt_state")
				FItemList(i).Fevtusing = rsEVTget("evt_using")
				FItemList(i).Fevtsubcopyk = rsEVTget("evt_subcopyk")
				FItemList(i).Fevtsubname = rsEVTget("evt_subname")
				FItemList(i).FevtUsingPc = rsEVTget("isWeb")
				FItemList(i).FevtUsingMw = rsEVTget("isMobile")
				FItemList(i).FevtUsingApp = rsEVTget("isApp")
				FItemList(i).Fisusing = rsEVTget("isusing")
				FItemList(i).FBrandUsing = rsEVTget("makerusing")
				FItemList(i).FOptionCnt = rsEVTget("optioncnt")				
				FItemList(i).FAdultType = rsEVTget("adultType")								

				i=i+1
				rsEVTget.moveNext
			loop
		end if

		rsEVTget.Close
	End sub

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
		FResultCount  = 0
		FTotalCount = 0
		FPageSize = 12
		FCurrpage = 1
		FScrollCount = 10
	End Sub
    
    
    Private Sub Class_Terminate()

	End Sub

end Class

CLASS CMyViewContents

	'// 필수 변수  //
	
	dim FItemID
	dim FItemName
	dim FSellcash
	Dim fEval_excludeyn '//wish
	dim FOrgPrice
	Dim Fevtcode
	Dim Frect
	Dim Fplatform
	Dim Fevtname
	Dim Fevtstartdate
	Dim Fevtenddate
	Dim Fevtkind
	Dim Fevtstate
	Dim Fevtusing
	Dim Fevtsubcopyk
	Dim Fevtsubname
	Dim Ftype
	
	dim FNewitem
	
	dim FMakerID
	dim FBrandName
	dim FBrandName_kor
	dim FBrandLogo
	dim FBrandUsing
	dim FisBestBrand
	dim FUserDiv
	
	dim FItemDiv
	dim FMakerName
	dim FOrgMakerID

	dim FMileage
	dim FSourceArea
	dim FDeliverytype
	
	dim FLimitNo
	dim FLimitSold
	dim fsailprice
	
	dim FImageBasic
	dim FImageMask
	dim FImageList
	dim FImageList120
	dim FImageSmall
	dim FImageBasicIcon
	dim FImageMaskIcon
	dim FImageIcon1	'신상품리스트, 할인리스트에서 사용(200x200)
	dim FImageIcon2
	dim FIcon1Image
	dim FIcon2Image
	
	dim FItemContent
	
	dim Fisusing
	dim FStreetUsing

	dim FRegDate
	
	dim FReipgodate
	dim FSpecialbrand
	dim FtenOnlyYn

	dim FLimitYn
	dim FSellYn
	dim FItemScore

	dim Fitemgubun

	dim FSaleYn
	
	dim FEvalcnt
	dim FQnaCnt 
	dim FOptionCnt
	dim FAdultType

	dim FAddimageGubun '?
	dim FAddimageSmall '?
	dim FAddImageType
	dim FAddimage '?
	dim FIsExistAddimg
	dim Ffreeprizeyn '?
	
	Dim Freviewcnt	

	dim FReipgoitemyn
	dim FSpecialUserItem
	
	dim Fitemcouponyn
	dim FItemCouponType
	dim FItemCouponValue
	dim FItemCouponExpire
	dim FCurrItemCouponIdx

	Dim FevtUsingPc
	Dim FevtUsingMw
	Dim FevtUsingApp
	
	dim FAvailPayType               '결제 방식 지정 0-일반 ,1-실시간(선착순) 
	dim FDefaultFreeBeasongLimit    '업체 개별배송시 배송비 무료 적용값
	dim FDefaultDeliverPay		    ' 업체 개별배송시 배송비 	

	Public Fidx
	public FPoints
	public Fuserid
	public Fcontents
	public FImageMain
	public FImageMain2			'상품설명2 이미지 추가(2011.04.14)
	public FImageMain3
	public FlinkURL
	
	public FCurrRank
	public FLastRank

	public FPojangOk			'선물포장 가능 여부

	public FUseETC

	public FplusSalePro         ''세트구매 할인율.
	public FisJust1day			'Just 1day 상품 여부

	'상품상세 추가 2012-11-01
	Public FInfoname
	Public FInfoContent
	Public FinfoCode
	public FFavCount
	public FInCount
	public FRegTime

	Public FEvaluate '//wish
	Public FMyCount
	'상품상세 추가 2016-02-05 이종화
	Public Ftentenimage
	Public Ftentenimage50
	Public Ftentenimage200
	Public Ftentenimage400
	Public Ftentenimage600
	Public Ftentenimage1000

	'// 상품상세설명 동영상 추가(2016.02.17 원승현)
	Dim FvideoUrl
	Dim FvideoWidth
	Dim FvideoHeight
	Dim Fvideogubun
	Dim FvideoType
	Dim FvideoFullUrl

	Public ForderMinNum
	Public ForderMaxNum

	public FDisp
	public FCateCode

	Public FbetCateCd '// 비트윈 카테고리 코드
	Public FbetCateNm '// 비트윈 카테고리명
	
	'/상품상세추가
	public FLimitDispYn

	public fdevice
	public Fsdate
	public Fedate

	Public FMyFavItem '// 자신의 위시 상품과 일치여부
	Public FUserIconNo '// 회원 프로필 이미지 번호
	Public FisMyWishChk '// 위시 겹치는지 확인

	'// 상품쿠폰 시작 종료일 추가
	Public FitemCouponstartdate
	Public Fitemcouponexpiredate

    public FreserveItemTp		'2016추가 : 단독(예약)구매상품

	'브랜드 공지 추가2017-01-31 유태욱
	public FBrandNoticeGubun
	public FBrandNoticeTitle
	public FBrandNoticeText



	public function IsStreetAvail() ' !
		IsStreetAvail = (FStreetUsing="Y") and (Fuserdiv<10)
	end function


	'// 원 판매 가격  '!
	public Function getOrgPrice()
		if FOrgPrice=0 then
			getOrgPrice = FSellCash
		else
			getOrgPrice = FOrgPrice
		end if
	end Function
	
	'// 세일포함 실제가격  '!
	public Function getRealPrice()

		getRealPrice = FSellCash


		if (IsSpecialUserItem()) then
			getRealPrice = getSpecialShopItemPrice(FSellCash)
		end if
	end Function	
	
	'//상품코드  '!
	public Function FProductCode() 
		 FProductCode = Num2Str(FItemid,6,"0","R")
	end Function
	
	'// 상품명 
	public Function getCuttingItemName()
		if Len(FItemName)>18 then
			getCuttingItemName=Left(FItemName,18) + "..."
		else
			getCuttingItemName=FItemName
		end if
	end Function
	
	'// 상품 설명  '?
	public Function GetCuttingItemContents()
		''## 이상은 잘라버림.
		dim reStr
		reStr = LeftB(Fitemcontent,120)
		reStr = replace(reStr,"<P>","")
		reStr = replace(reStr,"<p>","")
		reStr = replace(reStr,"<br>",Chr(2))
		reStr = Left(reStr,100)
		reStr = replace(reStr,Chr(2),"&nbsp;")
		GetCuttingItemContents = reStr + "..."
	end Function

	'// 우수회원샵 상품 여부 '!
	public Function IsSpecialUserItem() 
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>1 and uLevel<>5)
	end Function
	
	'// 판매종료  여부 '! '2008/07/07 추가
	public Function IsSoldOut() 
		
		'isSoldOut = (FSellYn="N")
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function
	
	'//일시품절 여부 '2008/07/07 추가 '!
	public Function isTempSoldOut() 
	
		isTempSoldOut = (FSellYn="S")
		
	end Function 
	
	'// 세일 상품 여부 '! 
	public Function IsSaleItem() 
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

	'//	한정 여부 '! 
	public Function IsLimitItem() 
			IsLimitItem= (FLimitYn="Y") and (FLimitDispYn="Y" or isNull(FLimitDispYn))
	end Function

	'//	한정 여부 (표시여부와 상관없는 실제 상품 한정여부)
	public Function IsLimitItemReal()
			IsLimitItemReal= (FLimitYn="Y")
	end Function

	'// 신상품 여부 '! 
	public Function IsNewItem() 
			IsNewItem =	(datediff("d",FRegdate,now())<= 14)
	end Function
	
	'// 무료 배송 쿠폰 여부 '?
	public function IsFreeBeasongCoupon() 
		IsFreeBeasongCoupon = Fitemcoupontype="3"
	end function
	
	'// 상품 쿠폰 여부  '!
	public Function IsCouponItem()
			IsCouponItem = (FItemCouponYN="Y")
	end Function
	
	'// 사은품 증정 상품 여부 '?
	public Function IsGiftItem() 
			IsGiftItem	= (FFreePrizeYN ="Y")
	end Function
	
	'// 재입고 상품 여부
	public Function isReipgoItem() 
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function
	
	'// 마일리지샵 아이템 여부 '!
	public Function IsMileShopitem() 
		IsMileShopitem = (FItemDiv="82")
	end Function

	'// 텐바이텐 독점상품 여부 '!
	public Function IsTenOnlyitem()
		IsTenOnlyitem = (FTenOnlyYn="Y")
	end Function

	'// 텐바이텐 포장가능 상품 여부
	public Function IsPojangitem()
		IsPojangitem = (FPojangOk="Y")
	end Function

	'// 단독(예약) 배송 상품 여부
	Public Function IsReserveItem()
		IsReserveItem = False
		IsReserveItem = (CStr(FreserveItemTp)="1")					'단독(예약)구매
		IsReserveItem = IsReserveItem or (CStr(FItemDiv) = "08")	'티켓상품
		IsReserveItem = IsReserveItem or (CStr(FItemDiv) = "09")	'Present상품
		IsReserveItem = IsReserveItem or (CStr(FDeliverytype)="6")	'현장수령상품
	end Function

	'// 한정 상품 남은 수량 '!
	public Function FRemainCount()	
		if IsSoldOut then
			FRemainCount=0
		else
			FRemainCount=(clng(FLimitNo) - clng(FLimitSold))
		end if
	End Function
	
	'// 상품 문의 받기 '!
	public Function IsSpecialBrand() 
		IsSpecialBrand = FSpecialBrand="Y"
	End Function

	'// 할인가
	public Function getDiscountPrice() 
		dim tmp

		if (FDiscountRate<>1) then
			tmp = cstr(FSellcash * FDiscountRate)
			getDiscountPrice = round(tmp / 100) * 100
		else
			getDiscountPrice = FSellcash
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
	
	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (IsCouponItem) then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function
	
	'// 쿠폰 할인가 '?
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
	
	'// 상품 쿠폰 내용  '!
	public function GetCouponDiscountStr()

		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
			Case "2"
				GetCouponDiscountStr = formatNumber(Fitemcouponvalue,0) + "원 할인"
			Case "3"
				GetCouponDiscountStr ="무료배송"
			Case Else
				GetCouponDiscountStr = Fitemcoupontype
		End Select

	end function
	
	'// 무료 배송 여부
	public Function IsFreeBeasong() 
		if (cLng(getRealPrice())>=cLng(getFreeBeasongLimitByUserLevel())) then
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

	'// 해외 배송 여부(텐배 + 해외여부 + 상품무게)
	public Function IsAboardBeasong() 
		if FdeliverOverseas="Y" and FItemWeight>0 and (FDeliverytype="1" or FDeliverytype="3" or FDeliverytype="4") then
			IsAboardBeasong = true
		else
			IsAboardBeasong = false
		end if
	end function

	''// 업체별 배송비 부과 상품(업체 조건 배송)
	public Function IsUpcheParticleDeliverItem()
	    IsUpcheParticleDeliverItem = (FDefaultFreeBeasongLimit>0) and (FDefaultDeliverPay>0) and (FDeliveryType="9")
	end function
	
	''// 업체착불 배송여부
	public Function IsUpcheReceivePayDeliverItem()
	    IsUpcheReceivePayDeliverItem = (FDeliveryType="7")
	end function
	
	public function getDeliverNoticsStr()
	    getDeliverNoticsStr = ""
	    if (IsUpcheParticleDeliverItem) then
	        getDeliverNoticsStr = FBrandName & "(" & FBrandName_kor & ") 제품으로만" & "<br>"
	        getDeliverNoticsStr = getDeliverNoticsStr & FormatNumber(FDefaultFreeBeasongLimit,0) & "원 이상 구매시 무료배송 됩니다."
	        getDeliverNoticsStr = getDeliverNoticsStr & "배송비(" & FormatNumber(FDefaultDeliverPay,0) & "원)"
	    elseif (IsUpcheReceivePayDeliverItem) then
	        getDeliverNoticsStr = "착불 배송비는 지역에 따라 차이가 있습니다. " 
            getDeliverNoticsStr = getDeliverNoticsStr & " 상품설명의 '배송안내'를 꼭 읽어보세요." & "<br>"
	    end if
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

    '// 옵션 존재여부 옵션 갯수로 체크
    public function IsItemOptionExists()
        IsItemOptionExists = (FOptioncnt>0)
    end function

	'// 배송구분 : 무료배송은 따로 처리  '!
	public Function GetDeliveryName()
		Select Case FDeliverytype
			Case "1" 
				if IsFreeBeasong then
					GetDeliveryName="텐바이텐무료배송"
				else
					GetDeliveryName="텐바이텐배송"
				end if
			Case "2"
				if FMakerid="goodovening" then
					GetDeliveryName="업체배송"
				else
					GetDeliveryName="업체무료배송"
				end if
			'Case "3"
			'		GetDeliveryName="텐바이텐배송"
			Case "4"
					GetDeliveryName="텐바이텐무료배송"
			Case "5"
					GetDeliveryName="업체무료배송" 
			Case "6"
					GetDeliveryName="현장수령상품" 
			Case "7"
				GetDeliveryName="업체착불배송"
			Case "9"
				if Not IsFreeBeasong then
					GetDeliveryName="업체조건배송"
				else
					GetDeliveryName="업체무료배송" 
				end if
			Case Else
				GetDeliveryName="텐바이텐배송"
		End Select
	end Function


	'// 무이자 이미지 & 레이어  '!
	public Function getInterestFreeImg()
			if getRealPrice>=50000 then
				getInterestFreeImg="<img src=""http://fiximage.10x10.co.kr/web2009/category/btn_free.gif"" width=""57"" height=""13"" align=""absmiddle"" onClick=""ShowInterestFreeImg();"" style=""cursor:pointer;"">"
				'// 2013년 1월 1일부로 모든 카드 무이자혜택 제거
				getInterestFreeImg = ""
			end if
	end Function
    

    ''// 세트구매 할인가격
    public function GetPLusSalePrice()
        if (FplusSalePro>0) then
            GetPLusSalePrice = getRealPrice-CLng(getRealPrice*FplusSalePro/100)
        else
            GetPLusSalePrice = getRealPrice
        end if
    end function


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
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_none.gif' width='6' height='2' align='absmiddle'> <font class='eng11px00'><b>0</b></font>"
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
			'##기존 GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2008/award/s_arrow_new.gif' width='9' height='5'>"
		else
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_down.gif' width='7' height='4' align='absmiddle'> <font class='verdanabk'><b>" & GetLevelUpCount() & "</b></font>"
			if FCurrRank-FLastRank>=FCurrPos then
				GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2009/bestaward/award_none.gif' width='6' height='2' align='absmiddle'> <font class='eng11px00'><b>0</b></font>"
			end if
		end if
	end Function
	
	'// 안전인증정보 여부
	public Function IsSafetyYN() 
		if FsafetyYN="Y"  then
			IsSafetyYN = true
		else
			IsSafetyYN = false
		end if
	end Function
	
	'// 안전인증정보 마크
	public Function IsSafetyDIV() 
		if FsafetyDIV="10"  then
			IsSafetyDIV = "국가통합인증(KC마크)"
		ElseIf FsafetyDIV="20"  then
			IsSafetyDIV = "전기용품 안전인증"
		ElseIf FsafetyDIV="30"  then
			IsSafetyDIV = "KPS 안전인증 표시"
		ElseIf FsafetyDIV="40"  then
			IsSafetyDIV = "KPS 자율안전 확인 표시"
		ElseIf FsafetyDIV="50"  then
			IsSafetyDIV = "KPS 어린이 보호포장 표시"
		end if
	end function

	public Function fnRealAllPrice()
		'####### 쿠폰 할인 모두 다 계산하여 1가지로 나타냄. 할인&쿠폰 중 쿠폰이 우위.
		Dim vPrice
		vPrice = FSellCash
		IF FSaleyn = "Y" AND FItemcouponyn = "Y" Then
			vPrice = GetCouponAssignPrice
		Else
			If FItemcouponyn = "Y" Then
				vPrice = GetCouponAssignPrice
			End If
		End If
		fnRealAllPrice = vPrice
	End Function

    ''여행상품 //2016/04/15 추가
    public function IsTravelItem()
        IsTravelItem = False
        if FItemDiv="18" then
			IsTravelItem = true
		end if
    end function

	Private Sub Class_Initialize()
        FplusSalePro = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub

end CLASS

%>
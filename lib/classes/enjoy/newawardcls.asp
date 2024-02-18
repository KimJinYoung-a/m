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
	public FTenOnlyYn

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

	public FCateCode
    public Fregdate
    public FItemDiv
    public FCateLarge
    public FCateMid

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

	'//	텐바이텐 독점 여부
	public Function IsTenOnlyItem() '! 
			IsTenOnlyItem= (FTenOnlyYn="Y")
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
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2010/bestaward/ico_up.gif' align='absmiddle'> <font class='verdanared'><b>" & GetLevelUpCount() & "</b></font>"
		elseif (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
		elseif (FCurrRank=FLastRank) then
			'GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2010/bestaward/ico_none.gif' align='absmiddle'> <font class='eng11px00'><b>0</b></font>"
			GetLevelUpArrow = ""
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelUpArrow = ""
		else
			GetLevelUpArrow = "<img src='http://fiximage.10x10.co.kr/web2010/bestaward/ico_down.gif' align='absmiddle'> <font class='verdanabk'><b>" & GetLevelUpCount() & "</b></font>"
			if FCurrRank-FLastRank>=FCurrPos then
				'GetLevelUpArrow = "<font class='eng11px00'><b>0</b></font>"
				GetLevelUpArrow = ""
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

	public function GetLevelChgNum()
		if (FCurrRank=FLastRank) and (FLastRank=0) then
			GetLevelChgNum = "0"
		elseif (FCurrRank=FLastRank) then
			GetLevelChgNum = "0"
		elseif (FCurrRank>FLastRank) and (FLastRank=0) then
			GetLevelChgNum = "0"
		else
			GetLevelChgNum = CStr(FLastRank-FCurrRank)
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
	end function
		
	public Sub getItemCateName(byRef cdlNm,byRef cdmNm)
		dim strSql
		strSql = "select top 1 L.code_nm as cdL, M.code_nm as cdM " &_
				" from db_item.dbo.tbl_cate_large as L " &_
				"	join db_item.dbo.tbl_cate_mid as M " &_
				"		on L.code_large=M.code_large " &_
				" where L.code_large='" & FCateLarge & "' " &_
				"	and M.code_mid='" & FCateMid & "'"
		rsget.Open strSql, dbget, 1
		if Not(rsget.EOF or rsget.BOF) then
			cdlNm = rsget(0)
			cdmNm = rsget(1)
		end if
		rsget.Close
	end Sub

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
	Public FTotalCount
	public FCurrPage
	Public FPageCount
	public function GetImageFolerName(byval i)
	    GetImageFolerName = GetImageSubFolderByItemid(FItemList(i).FItemID)
	end function

	public Sub GetNormalItemList()
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_awardItemList " & FPageSize & ",'" & FRectAwardgubun & "','" & FRectCDL & "','" & FRectCDM & "'"
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
                FItemList(i).FTenOnlyYn         = rsget("tenOnlyYn")
                FItemList(i).FCateLarge			= rsget("cate_large")
                FItemList(i).FCateMid			= rsget("cate_mid")

				FItemList(i).FCurrPos = i+1

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub
	
	
	public Sub GetNormalItemList5down()		'카테고리메인에 베스트 5개 부분에 5개 상품이 아닐경우.
		dim sqlStr,i
		sqlStr = "exec db_const.dbo.sp_Ten_awardItemList_5down " & FPageSize & ",'" & FRectAwardgubun & "','" & FRectCDL & "','" & FRectCDM & "'"
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
                FItemList(i).FTenOnlyYn         = rsget("tenOnlyYn")


				FItemList(i).FCurrPos = i+1

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

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





	'// 탭 버튼 클릭시 해당 목록 클래스 //
	Public Sub GetBrandChoiceList()
		Dim sqlStr,i


		sqlStr = "exec db_const.dbo.sp_Ten_ChoiceBrandList_cnt " & FPageSize & ", '" & FRectAwardgubun & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.close

		sqlStr = "exec db_const.dbo.sp_Ten_ChoiceBrandList " & FPageSize & ", " & FCurrPage & ",'" & FRectAwardgubun & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		
		
		If (FCurrPage * FPageSize < FTotalCount) Then
			FResultCount = FPageSize
		Else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		End If

		FTotalPage = (FTotalCount\FPageSize)
		
		If (FTotalPage<>FTotalCount/FPageSize) Then FTotalPage = FTotalPage +1
		Redim preserve FItemList(FResultCount)
		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CAwardItem

				FItemList(i).FMakerID		= rsget("userid")
				FItemList(i).FSocname		= db2html(rsget("socname"))
				FItemList(i).FSocname_Kor	= db2html(rsget("socname_kor"))
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
















	public function GetBrandImageFolerName(byval itemid)
    	If itemid <> ""  then
    		GetBrandImageFolerName = GetImageSubFolderByItemid(itemid)
    	End if
	end function


	'### 가격별 베스트 셀러. 카테고리별 가격 범위.
	Public Function GetPriceBetween(vCdl)
		Select Case vCdl
			Case "010"	'#디자인문구
				GetPriceBetween = "3000,5000,10000"
			Case "020"	'#오피스/개인
				GetPriceBetween = "3000,10000,30000"
			Case "025"	'#디지털
				GetPriceBetween = "15000,30000,50000"
			Case "030"	'#키덜트/취미
				GetPriceBetween = "5000,10000,30000"
			Case "035"	'#여행/취미
				GetPriceBetween = "10000,30000,50000"
			Case "040"	'#가구
				GetPriceBetween = "50000,150000,500000"
			Case "045"	'#수납
				GetPriceBetween = "10000,30000,50000"
			Case "050"	'#조명/데코
				GetPriceBetween = "10000,30000,50000"
			Case "055"	'#페브릭
				GetPriceBetween = "20000,50000,70000"
			Case "060"	'#주방/욕실
				GetPriceBetween = "10000,35000,50000"
			Case "070"	'#가방/슈즈/쥬얼리
				GetPriceBetween = "10000,25000,50000"
			Case "075"	'#뷰티
				GetPriceBetween = "5000,10000,20000"
			Case "080"	'#Women
				GetPriceBetween = "10000,30000,50000"
			Case "090"	'#Men
				GetPriceBetween = "15000,25000,50000"
			Case "100"	'#Baby
				GetPriceBetween = "10000,30000,50000"
			Case "110"	'#감성채널
				GetPriceBetween = "3000,20000,50000"
		End Select
	End Function


	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()

	End Sub

	Public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	End Function

	Public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	End Function

	Public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	End Function




end Class
%>
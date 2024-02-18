<%
'###########################################################
' Description :  play class
' History : 2014.10.17 강준구 생성
'			2014.10.23 한용민 수정
'			2014.10.24 원승현 수정
'###########################################################
%>
<%
Class CPlayItem
	public Fidx
	public Fviewno
	public Fviewnotxt
	public Ftitle
	public Ftype
	public Ftypename
	public Fsubcopy
	public Fcontents_idx
	public Flistimg
	public Fmyfav
	public fpdidx
	public Fviewimg
	public Fviewtitle
	public Fviewtext
	public Freservationdate
	public Fstate
	public Forgimg
	public Fworktext
	public Fregdate
	public ffavcnt
	public fchkfav
	public fstyleidx
	public Fviewimg1
	public Fviewimg2
	public Fviewimg3
	public Fviewimg4
	public Fviewimg5
	public Ftextimg
	public fstyle_html_m
	public fstyleitemidx
	public fitemid
	public Fitemname
	public FImageicon1
	public FSellCash
	public FOrgprice
	public FMakerId
	public FBrandName
	public FSellYn
	public FSaleYn
	public FLimitYn
	public FLimitNo
	public FLimitSold
	public FDeliverytype
	public FItemCouponYN
	public Fitemcouponvalue
	public Fitemcoupontype
	public FEvalcnt
	public Ffavcount
	public FItemDiv
	public FImageicon2
	public Fsocname
	public FSpecialUserItem
	Public Fvideourl
	Public FvideourlM
	Public Fmo_contents '//그라운드 수작업 컨텐츠
	Public Fmainidx '//그라운드 메인
	Public Fsubidx '//그라운드 서브(모바일에서는 리스트중하나)
	Public Fmo_exec_check

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

	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class
			
Class CPlay
	public FItemList()
	public FItemOne
	public FOneItem
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FRectIdx
	public FRectUsing
	public FRectSearch
	public FRectSort
	public FRectType
	public FRectIsMine
	public FRectUserID
	public frectcontentsidx

	Private Sub Class_Initialize()
		FCurrPage = 1
		FTotalPage = 1
		FPageSize = 8
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'//play/playground.asp
	public Sub GetRowGroundSub()

		dim sqlStr
		sqlStr = "select top 1 * "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play where codeidx = s.gidx and subcodeidx = s.gcidx and playcode = "& FRectType &") as favcnt "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play where codeidx = s.gidx and subcodeidx = s.gcidx and playcode = "& FRectType &" and userid = '"& FRectUserID &"') as chkfav "
		sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_play_ground_sub as s"
		sqlStr = sqlStr + " where state = 7 and convert(varchar(10),getdate(),120) >= reservationdate and gcidx=" + CStr(frectcontentsidx) 

	'response.write sqlStr &"<Br>"
	rsget.Open SqlStr, dbget, 1
	FResultCount = rsget.RecordCount

	set FOneItem = new CPlayItem

		if Not rsget.Eof then

			FOneItem.Fmainidx				= rsget("gidx")
			FOneItem.Fsubidx				= rsget("gcidx")
			FOneItem.Fviewno				= rsget("viewno")
			FOneItem.Fviewtitle				= rsget("viewtitle")
			FOneItem.Fmo_contents			= rsget("mo_contents")
			FOneItem.Fmo_exec_check			= rsget("mo_exec_check")

			FOneItem.Ffavcnt				= rsget("favcnt")
			FOneItem.Fchkfav				= rsget("chkfav")

		end If

	rsget.Close
	end Sub

	'//play/playground_review.asp
	public Sub GetRowGroundSub_review()

		dim sqlStr
		sqlStr = "select top 1 * "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play where codeidx = s.gidx and subcodeidx = s.gcidx and playcode = "& FRectType &") as favcnt "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play where codeidx = s.gidx and subcodeidx = s.gcidx and playcode = "& FRectType &" and userid = '"& FRectUserID &"') as chkfav "
		sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_play_ground_sub as s"
		sqlStr = sqlStr + " where gcidx=" + CStr(frectcontentsidx) 

	'response.write sqlStr &"<Br>"
	rsget.Open SqlStr, dbget, 1
	FResultCount = rsget.RecordCount

	set FOneItem = new CPlayItem

		if Not rsget.Eof then

			FOneItem.Fmainidx				= rsget("gidx")
			FOneItem.Fsubidx				= rsget("gcidx")
			FOneItem.Fviewno				= rsget("viewno")
			FOneItem.Fviewtitle				= rsget("viewtitle")
			FOneItem.Fmo_contents			= rsget("mo_contents")
			FOneItem.Fmo_exec_check			= rsget("mo_exec_check")

			FOneItem.Ffavcnt				= rsget("favcnt")
			FOneItem.Fchkfav				= rsget("chkfav")

		end If

	rsget.Close
	end Sub

	'//play/playgrounditem.asp
	public Sub getPlayGrounditem()
		dim sqlStr, sqlsearch, i

		if frectcontentsidx="" then exit Sub

		sqlStr = "exec db_sitemaster.[dbo].[sp_Ten_Play_Mo_playgrounditem] '" & frectcontentsidx & "','" & FCurrPage & "','" & FPageSize & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		FTotalCount = rsget.RecordCount
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CPlayItem
					FItemList(i).fstyleitemidx		= rsget("itemidx")
					FItemList(i).Fidx				= rsget("subidx")
					FItemList(i).Fitemid			= rsget("itemid")
					FItemList(i).Fitemname			= rsget("itemname")
					FItemList(i).FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
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
					FItemList(i).Ffavcount			= rsget("favcount")
					FItemList(i).FItemDiv			= rsget("itemdiv")
					FItemList(i).FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")
					FItemList(i).fSpecialUserItem	= rsget("SpecialUserItem")
					FItemList(i).Fsocname			= rsget("socname")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
    end Sub


	'//play/playvideoclip.asp
	public Sub GetOneRowVideoClipContent()
	dim sqlStr
	sqlStr = "select * "
	sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play as p where p.codeidx = "& frectcontentsidx &" and p.playcode = "& FRectType &") as favcnt "
	sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play as p where p.codeidx = "& frectcontentsidx &" and p.playcode = "& FRectType &" and p.userid = '"& FRectUserID &"') as chkfav "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_play_video_clip"
	sqlStr = sqlStr + " where vidx=" + CStr(frectcontentsidx)

	rsget.Open SqlStr, dbget, 1
	FResultCount = rsget.RecordCount

	set FOneItem = new CPlayItem

	if Not rsget.Eof then

		FOneItem.Fidx						= rsget("vidx")
		FOneItem.Flistimg					= rsget("listimg")
		FOneItem.Fviewtitle					= rsget("viewtitle")
		FOneItem.Fviewtext					= rsget("viewtext")
		FOneItem.Freservationdate			= rsget("reservationdate")
		FOneItem.Fstate						= rsget("state")
		FOneItem.Fviewno					= rsget("viewno")
		FOneItem.Fworktext					= rsget("worktext")
		FOneItem.Fvideourl					= rsget("videourl")
		FOneItem.FvideourlM					= rsget("videourlM")
		FOneItem.Fregdate					= rsget("regdate")
		FOneItem.Ffavcnt					= rsget("favcnt")
        FOneItem.Fchkfav					= rsget("chkfav")


	end if
	rsget.Close
	end Sub

	'//play/playTEpisode.asp
	Public Sub GetOneRowTepisodeContent()
		dim sqlStr
		sqlStr = "select * "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play as p where p.codeidx = "& frectcontentsidx &" and p.playcode = "& FRectType &") as favcnt "
		sqlStr = sqlStr & " , (select count(*) from db_my10x10.dbo.tbl_myfavorite_play as p where p.codeidx = "& frectcontentsidx &" and p.playcode = "& FRectType &" and p.userid = '"& FRectUserID &"') as chkfav "
		sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_play_photo_pick"
		sqlStr = sqlStr + " where idx=" + CStr(frectcontentsidx)
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		set FOneItem = new CPlayItem

		if Not rsget.Eof then
			FOneItem.Fidx						= rsget("idx")
			FOneItem.Fviewtitle					= rsget("viewtitle")
			FOneItem.fstyle_html_m					= rsget("style_html_m")
			FOneItem.Fregdate					= rsget("regdate")
			FOneItem.Ffavcnt					= rsget("favcnt")
			FOneItem.Fchkfav					= rsget("chkfav")
		end if
		rsget.Close


	End Sub


	'//play/playTepisode.asp
	public Sub getplayTepisodeplusitem()
		dim sqlStr, sqlsearch, i

		if frectcontentsidx="" then exit Sub

		sqlStr = "exec db_sitemaster.[dbo].[sp_Ten_Play_Mo_playTepisodeplusitem] '" & frectcontentsidx & "','" & FCurrPage & "','" & FPageSize & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		FTotalCount = rsget.RecordCount
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CPlayItem
					FItemList(i).fstyleitemidx		= rsget("itemidx")
					FItemList(i).Fidx				= rsget("subidx")
					FItemList(i).Fitemid			= rsget("itemid")
					FItemList(i).Fitemname			= rsget("itemname")
					FItemList(i).FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
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
					FItemList(i).Ffavcount			= rsget("favcount")
					FItemList(i).FItemDiv			= rsget("itemdiv")
					FItemList(i).FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")
					FItemList(i).fSpecialUserItem	= rsget("SpecialUserItem")
					FItemList(i).Fsocname			= rsget("socname")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
    end Sub


	'//play/playStylePlus.asp
	public Sub getplaystyleplusitem()
		dim sqlStr, sqlsearch, i

		if frectcontentsidx="" then exit Sub

		sqlStr = "exec db_sitemaster.[dbo].[sp_Ten_Play_Mo_playstyleplusitem] '" & frectcontentsidx & "','" & FCurrPage & "','" & FPageSize & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		FTotalCount = rsget.RecordCount
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CPlayItem
					FItemList(i).fstyleitemidx		= rsget("styleitemidx")
					FItemList(i).Fidx				= rsget("styleidx")
					FItemList(i).Fitemid			= rsget("itemid")
					FItemList(i).Fitemname			= rsget("itemname")
					FItemList(i).Fviewno			= rsget("viewidx")
					''FItemList(i).FImageicon1		= webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon1image")
					FItemList(i).FImageicon1		= getThumbImgFromURL(webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(rsget("Itemid")) + "/" + rsget("basicimage"),"200","200","true","false")
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
					FItemList(i).Ffavcount			= rsget("favcount")
					FItemList(i).FItemDiv			= rsget("itemdiv")
					FItemList(i).FImageicon2		= webImgUrl & "/image/icon2/" & GetImageSubFolderByItemid(rsget("Itemid")) & "/" & rsget("icon2image")
					FItemList(i).fSpecialUserItem	= rsget("SpecialUserItem")
					FItemList(i).Fsocname		= rsget("socname")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
    end Sub

	'//play/playStylePlus.asp
	public Sub getplaystyleplus_one()
		dim sqlStr

		sqlStr = "exec db_sitemaster.[dbo].[sp_Ten_Play_Mo_playstyleplus_one] '" & frectcontentsidx & "','" & FRectType & "','" & FRectUserID & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount
		FTotalCount = rsget.RecordCount

		set FOneItem = new CPlayItem
	
		if Not rsget.Eof then
			FOneItem.fstyleidx = rsget("styleidx")
			FOneItem.Fviewimg1 = rsget("viewimg1")
			FOneItem.Fviewimg2 = rsget("viewimg2")
			FOneItem.Fviewimg3 = rsget("viewimg3")
			FOneItem.Fviewimg4 = rsget("viewimg4")
			FOneItem.Fviewimg5 = rsget("viewimg5")
			FOneItem.Ftextimg = rsget("textimg")
			FOneItem.Fviewtitle = db2html(rsget("viewtitle"))
			FOneItem.Fviewno = rsget("viewno")
			FOneItem.fstyle_html_m = db2html(rsget("style_html_m"))
			FOneItem.Ffavcnt = rsget("favcnt")

			if FRectUserID<>"" then
				FOneItem.fchkfav = rsget("chkfav")
			else
				FOneItem.fchkfav=0
			end if
		end if
		rsget.Close
	end Sub
	
	'/play/playPicDiary.asp
	public Sub getplayPicDiary_one()
		dim sqlStr

		if frectcontentsidx="" or FRectType="" then exit Sub

		sqlStr = "exec db_sitemaster.[dbo].[sp_Ten_Play_Mo_playPicDiary_one] '" & frectcontentsidx & "','" & FRectType & "','" & FRectUserID & "'"

		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.RecordCount
		FTotalCount = rsget.RecordCount
	
		set FOneItem = new CPlayItem
	
		if Not rsget.Eof then
			FOneItem.fpdidx = rsget("pdidx")
			FOneItem.Flistimg = rsget("listimg")
			FOneItem.Fviewimg = rsget("viewimg")
			FOneItem.Fviewtitle = db2html(rsget("viewtitle"))
			FOneItem.Fviewtext = db2html(rsget("viewtext"))
			FOneItem.Freservationdate = rsget("reservationdate")
			FOneItem.Fstate = rsget("state")
			FOneItem.Fviewno = rsget("viewno")
			FOneItem.Forgimg = rsget("orgimg")
			FOneItem.Fworktext = db2html(rsget("worktext"))
			FOneItem.Fregdate = rsget("regdate")
			FOneItem.ffavcnt = rsget("favcnt")
			
			if FRectUserID<>"" then
				FOneItem.fchkfav = rsget("chkfav")
			else
				FOneItem.fchkfav=0
			end if
		end if
		rsget.Close
	end Sub

	'/play/playPicDiary.asp		'//play/playStylePlus.asp
	public Function fnPlaydetail_one
		Dim strSql
		
		if FRectIdx="" then exit Function

		strSql = "exec db_sitemaster.dbo.sp_Ten_Play_Mo_Playdetail_one '" & FRectIdx & "'"

		'response.write strSql & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSql,dbget,1

		FTotalCount=rsget.recordcount
		FResultCount=rsget.recordcount
	
		set FOneItem = new CPlayItem

		if Not rsget.Eof then
			FOneItem.fidx = rsget("idx")
			FOneItem.fviewno = rsget("viewno")
			FOneItem.fviewnotxt = db2html(rsget("viewnotxt"))
			FOneItem.ftitle = db2html(rsget("title"))
			FOneItem.ftype = rsget("type")
			FOneItem.ftypename	= db2html(rsget("typename"))
			FOneItem.fcontents_idx = rsget("contents_idx")
			FOneItem.flistimg = rsget("listimg")
		end if
		rsget.Close
	End Function

	public Sub GetPlayList()
		dim strSql, addSql, i

		strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Play_Mo_List" & FRectIsMine & "] '1', '" & (FPageSize*FCurrPage) & "', '" & FRectType & "', '" & FRectUserID & "', '" & FRectSort & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
		FTotalCount = rsget(0)
		FTotalPage = rsget(1)
		rsget.Close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Play_Mo_List" & FRectIsMine & "] '2', '" & (FPageSize*FCurrPage) & "', '" & FRectType & "', '" & FRectUserID & "', '" & FRectSort & "'"
			'response.write strSql
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CPlayItem

					FItemList(i).Fidx			= rsget("idx")
					FItemList(i).Fviewno		= rsget("viewno")
					FItemList(i).Fviewnotxt		= db2html(rsget("viewnotxt"))
					FItemList(i).Ftitle			= db2html(rsget("title"))
					FItemList(i).Ftype			= rsget("type")
					FItemList(i).Ftypename		= rsget("typename")
					FItemList(i).Fsubcopy		= db2html(rsget("subcopy"))
					FItemList(i).Fcontents_idx	= rsget("contents_idx")
					FItemList(i).Flistimg		= rsget("listimg")
					FItemList(i).Fmyfav			= rsget("myfav")
					
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	end Sub
	
	public Function fnPlayRecentContents
		Dim strSql
		strSql = "[db_sitemaster].[dbo].[sp_Ten_Play_Mo_RecentContent]('" & FPageSize & "','" & FRectType & "','" & FRectIdx & "')"

		'response.write strSql & "<br>"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		FTotalCount=rsget.recordcount
		FResultCount=rsget.recordcount
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnPlayRecentContents = rsget.getRows()
		END IF
		rsget.close
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

Function fnPlayLinkMoWeb(ttype)
	Dim vTmp
	SELECT Case ttype
		Case "1" : vTmp = "/play/playGround.asp"	'### GROUND
		Case "2" : vTmp = "/play/playStylePlus.asp"	'### STYLE+
		Case "3" : vTmp = ""	'### Color trend
		Case "4" : vTmp = "/play/playDesignFingers.asp"	'### DESIGN FINGERS
		Case "5" : vTmp = "/play/playPicDiary.asp"	'### 그림일기
		Case "6" : vTmp = "/play/playVideoClip.asp"	'### VIDEO CLIP
		Case "7" : vTmp = "/play/playTEpisode.asp"	'### MOBILE Wallpaper
	End SELECT
	fnPlayLinkMoWeb = vTmp
End Function

Function fnTypeSelectBox(gubun,ttype,isusing)
	Dim sqlStr, vBody
	sqlStr = "select type, typename "
	sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_play_mo_code"
	sqlStr = sqlStr & " where isusing = '" & isusing & "' "
	If gubun = "one" Then
		sqlStr = sqlStr & " and type = '" & ttype & "'"
	End If
	'response.write sqlStr
	rsget.Open SqlStr, dbget, 1
	
	If gubun = "select" Then
		if  not rsget.EOF  then
			do until rsget.EOF
				vBody = vBody & "<option value=""" & rsget("type") & """"
				If CStr(rsget("type")) = CStr(ttype) Then
					vBody = vBody & " selected"
				End If
				vBody = vBody & ">" & rsget("typename") & "</option>"
				
				rsget.movenext
			loop
		end if
		rsget.Close
	ElseIf gubun = "one" Then
		if  not rsget.EOF  then
		vBody = rsget("typename")
		end if
		rsget.Close
	End If
	
	fnTypeSelectBox = vBody
End Function


Sub fnTypeSelectBoxV16(sType,sCallback)
	Dim sName, sResult
	Dim strSql
	sName = "전체"
	sResult=""

	strSql = "select type, typename "
	strSql = strSql & " from db_sitemaster.dbo.tbl_play_mo_code"
	strSql = strSql & " where isusing = 'Y' "
	rsget.Open strSql, dbget, 1
	if Not(rsget.EOF) then
		Do until rsget.EOF
			sResult = sResult & "<li"& chkIIF(cStr(sType)=cStr(rsget("type"))," class=""selected""","") &"><a href=""#"" onclick=""" & sCallback & "(" &rsget("type") &");return false;""><span>"& db2html(rsget("typename")) &"</span></a></li>"
			if cStr(sType)=cStr(rsget("type")) then sName=rsget("typename")
			rsget.movenext
		loop
	end if
	rsget.close

	sResult = "<button type=""button"">" & sName & "</button>" & vbCrLf &_
		"<div class=""sortNaviV16a depth2"">" & vbCrLf &_
		"	<ul>" & vbCrLf &_
		"		<li " & chkIIF(sType="","class=""selected""","") & "><a href=""#"" onclick=""" & sCallback & "('');return false;""><span>전체<span></a></li>" & vbCrLf & sResult &_
		"	</ul>" & vbCrLf &_
		"</div>"
	Response.Write sResult
End Sub


Function fnChkFav(playcode,contentsidx)
	Dim sqlStr
	sqlStr = "select count(*) from db_my10x10.dbo.tbl_myfavorite_play where codeidx = '" & contentsidx & "' and playcode = '" & playcode & "' and userid = '" & GetLoginUserID & "'"
	rsget.Open SqlStr, dbget, 1
	if  not rsget.EOF  then
		fnChkFav = rsget(0)
	else
		fnChkFav = 0
	end if
	rsget.Close
End Function


Function fnViewCountPlus(idx)
	Dim sqlStr
	sqlStr = "UPDATE [db_sitemaster].[dbo].[tbl_play_mo] SET favcnt = favcnt + 1 WHERE idx = '" & idx & "'"
	dbget.execute sqlStr
End Function


Function fngetTagList(pcate, pidx, stype)
	Dim sqlStr, TagListValueTemp
	Dim addsqlStr

	TagListValueTemp = ""
	If pcate = "1" Then '//그라운드일경우만
		addsqlStr = " and playidxsub = '"& pidx &"' "
	Else
		addsqlStr = " and playidx = '" & pidx & "' "
	End If 

	sqlStr = "select tagidx, playcate, playidx, tagurl, tagname, playidxsub, tagurl_mo, tagurl_appchk, tagurl_appurl from db_sitemaster.dbo.tbl_play_tag where playcate = '" & pcate & "'" & addsqlStr
	rsget.Open SqlStr, dbget, 1	

	if  not rsget.EOF  Then
		Do Until rsget.eof
			Select Case Trim(stype)
				Case "pc" '// pc쪽은 이미 있지만 나중에 쓸지도 모르니..일단 만들어만 둠.
					TagListValueTemp = TagListValueTemp&"<li><span><a href=''></a></span></li>"
				Case "mobile"
					If IsNull(rsget("tagurl_mo")) Or Trim(rsget("tagurl_mo"))="" Then
						TagListValueTemp = TagListValueTemp&"<li><a href='/search/search_item.asp?cpg=1&burl="&server.urlencode(Request.ServerVariables("URL") & "?" & Request.ServerVariables("QUERY_STRING"))&"&rect="&Server.urlEncode(rsget("tagname"))&"'>"&rsget("tagname")&"</a></li>"
					Else
						TagListValueTemp = TagListValueTemp&"<li><a href='"&rsget("tagurl_mo")&"'>"&rsget("tagname")&"</a></li>"
					End If

				Case "app"

					If IsNull(rsget("tagurl_appurl")) Or Trim(rsget("tagurl_appurl"))="" Then
						TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupSearch('"&rsget("tagname")&"');return false;"">"&rsget("tagname")&"</a></li>"
					Else
						
						Select Case Trim(rsget("tagurl_appchk"))

							Case "1"
								TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupProduct('"&rsget("tagurl_appurl")&"');return false;"">"&rsget("tagname")&"</a></li>"

							Case "2"
								TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupEvent('"&rsget("tagurl_appurl")&"');return false;"">"&rsget("tagname")&"</a></li>"

							Case "3"
								TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupBrand('"&rsget("tagurl_appurl")&"');return false;"">"&rsget("tagname")&"</a></li>"

							Case "4"
								TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupCategory('"&rsget("tagurl_appurl")&"');return false;"">"&rsget("tagname")&"</a></li>"

							Case Else
								'// 검색
								TagListValueTemp = TagListValueTemp&"<li><a href="""" onclick=""javascript:fnAPPpopupSearch('"&rsget("tagname")&"');return false;"">"&rsget("tagname")&"</li>"

						End Select

					End If

			End Select
		rsget.movenext
		Loop
	Else
		TagListValueTemp = ""
	End If
	rsget.Close

	fngetTagList = TagListValueTemp

End Function
%>
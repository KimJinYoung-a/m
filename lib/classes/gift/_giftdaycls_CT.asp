<%
'###########################################################
' Description :  기프트 - 모바일
' History : 2014.03.19 한용민 생성 -PC
' History : 2014.04.03 이종화 생성 -Mobile
'###########################################################

class Cgiftday_item
	public Fkeywordtype
	public Fkeywordidx
	public Fkeywordname
	public Fsortno
	public Fisusing
	public Fregdate
	public fmasteridx
	public ftitle
	public fstartdate
	public fenddate
	public flisttopimg_w
	public flisttopimg_m
	public fregtopimg_m
	public fdetailcount
	public fstatus
	public FTag
	public fdetailidx
	public fgiftgubun
	public fuserid
	public fcontents
	public fviewcount
	public fcommentcount
	public fkeywordcount
	public fdevice
	public fdetailcommentidx
	public fcomment
	
	public fitemregdate
	public fitemid
	public fitemname
	public FSellcash
	public FOrgPrice
	public FMakerId
	public FBrandName
	public FSellYn
	public FSaleYn
	public FLimitYn
	public FLimitNo
	public FLimitSold
	public FReipgodate
	public Fitemcouponyn
	public FItemCouponValue
	public Fitemcoupontype
	public Fevalcnt
	public FitemScore
	public FImageList
	public FImageList120
	public FImageSmall
	public FImageIcon1
	public FImageIcon2
	public Fitemdiv
	public FImageBasic
	public FImageBasic600
	public FfavCount
	public fspecialuseritem

	'// 세일 상품 여부 '! 
	public Function IsSaleItem() 
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem)
	end Function

	'// 상품 쿠폰 여부  '!
	public Function IsCouponItem()
			IsCouponItem = (FItemCouponYN="Y")
	end Function

	'// 세일포함 실제가격  '!
	public Function getRealPrice()

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

	end Function
	
	'// 우수회원샵 상품 여부 '!
	public Function IsSpecialUserItem() 
	    dim uLevel
	    uLevel = GetLoginUserLevel()
		IsSpecialUserItem = (FSpecialUserItem>0) and (uLevel>0 and uLevel<>5)
	end Function

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class Cgiftday_list
	public FItemList()
	public FOneItem
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectkeywordidx
	public FRectkeywordtype
	public Frecttitle
	public Frectisusing
	public Frectmasteridx
	public frectuserid
	public frectgiftgubun
	public FRectSort
	public frectdetailidx
	public frectitemid

	'//gift/keyword
	public Function fnGiftDayKeywordList
		Dim strSql, i, vKey
		
		strSql = "EXECUTE [db_Gifts].[dbo].[sp_Ten_Giftday_Keyword_List] "
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open strSql,dbCTget,1

		FResultCount = rsCTget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsCTget.EOF then
			fnGiftDayKeywordList = rsCTget.getRows()
		end if
		rsCTget.close
	End Function

	'//gift/day/view.asp
	Public Function getgiftday_detail_comment_paging()	
        dim strSQL, i, vKey

        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_comment_cnt '"&frectdetailidx&"', '"&frectuserid&"', '"&frectisusing&"'"

		'response.write strSQL & "<Br>"
		rsCTget.Open strSQL, dbCTget
            FTotalCount = rsCTget("cnt")
        rsCTget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_comment_list '"&frectdetailidx&"', '"&frectuserid&"', '"&frectisusing&"', "&CStr(FPageSize*FCurrPage)&""

		'response.write strSQL & "<Br>"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic'
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open strSQL, dbCTget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsCTget.EOF then
            i = 0
            rsCTget.absolutepage = FCurrPage
            do until (rsCTget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fdetailcommentidx = rsCTget("detailcommentidx")
	            FItemList(i).fdetailidx = rsCTget("detailidx")
	            FItemList(i).fuserid = rsCTget("userid")
	            FItemList(i).fcomment = db2html(rsCTget("comment"))
	            FItemList(i).fregdate = rsCTget("regdate")
	            FItemList(i).fdevice = rsCTget("device")
	            FItemList(i).fisusing = rsCTget("isusing")

        		rsCTget.MoveNext
        		i = i + 1
            loop
        end if
        rsCTget.close
	end Function

	'//gift/day/inc_bestday.asp
	Public Sub getgiftday_detail_bestday
		dim sqlStr,i

		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_bestday"
		
		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount
		redim preserve FItemList(FResultCount)

		i=0
		if not rsCTget.EOF  then
			do until rsCTget.EOF
				set fitemlist(i) = new Cgiftday_item

				FItemList(i).fdetailidx = rsCTget("detailidx")
				FItemList(i).fmasteridx = rsCTget("masteridx")
				FItemList(i).fgiftgubun = rsCTget("giftgubun")
				FItemList(i).fuserid = rsCTget("userid")
				FItemList(i).fcontents = db2html(rsCTget("contents"))
				FItemList(i).fviewcount = rsCTget("viewcount")
				FItemList(i).fcommentcount = rsCTget("commentcount")
				FItemList(i).fkeywordcount = rsCTget("keywordcount")
				FItemList(i).fdevice = rsCTget("device")
				FItemList(i).fregdate = rsCTget("regdate")
				FItemList(i).fisusing = rsCTget("isusing")

				rsCTget.movenext
				i=i+1
			loop
		end if
		rsCTget.Close
	end sub
	
	'//gift/day/view.asp
	Public Sub getgiftday_detail_preview
		Dim sqlStr, i
		
		if Frectmasteridx="" or Frectdetailidx="" then exit Sub

		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_preview '"&frectmasteridx&"', '"&frectdetailidx&"'"
		
		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsCTget.Eof then

				FOneItem.fdetailidx = rsCTget("detailidx")
				FOneItem.fmasteridx = rsCTget("masteridx")
				FOneItem.fgiftgubun = rsCTget("giftgubun")
				FOneItem.fuserid = rsCTget("userid")
				FOneItem.fcontents = db2html(rsCTget("contents"))
				FOneItem.fviewcount = rsCTget("viewcount")
				FOneItem.fcommentcount = rsCTget("commentcount")
				FOneItem.fkeywordcount = rsCTget("keywordcount")
				FOneItem.fdevice = rsCTget("device")
				FOneItem.fregdate = rsCTget("regdate")
				FOneItem.fisusing = rsCTget("isusing")

				FOneItem.fitemname = rsCTget("itemname")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("smallImage")
        	End If
        rsCTget.Close
	End Sub
 

	'//gift/day/view.asp
	Public Sub getgiftday_detail_nextview
		Dim sqlStr, i
		
		if Frectmasteridx="" or Frectdetailidx="" then exit Sub

		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_nextview '"&frectmasteridx&"', '"&frectdetailidx&"'"

		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsCTget.Eof then

				FOneItem.fdetailidx = rsCTget("detailidx")
				FOneItem.fmasteridx = rsCTget("masteridx")
				FOneItem.fgiftgubun = rsCTget("giftgubun")
				FOneItem.fuserid = rsCTget("userid")
				FOneItem.fcontents = db2html(rsCTget("contents"))
				FOneItem.fviewcount = rsCTget("viewcount")
				FOneItem.fcommentcount = rsCTget("commentcount")
				FOneItem.fkeywordcount = rsCTget("keywordcount")
				FOneItem.fdevice = rsCTget("device")
				FOneItem.fregdate = rsCTget("regdate")
				FOneItem.fisusing = rsCTget("isusing")

				FOneItem.fitemname = rsCTget("itemname")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("smallImage")
        	End If
        rsCTget.Close
	End Sub
 

	'//gift/day/view.asp
	Public Sub getgiftday_detail_one
		Dim sqlStr, i
		
		if Frectdetailidx="" then exit Sub

		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_one '"&frectdetailidx&"'"
		
		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsCTget.Eof then

				FOneItem.fdetailidx = rsCTget("detailidx")
				FOneItem.fmasteridx = rsCTget("masteridx")
				FOneItem.fgiftgubun = rsCTget("giftgubun")
				FOneItem.fuserid = rsCTget("userid")
				FOneItem.fcontents = db2html(rsCTget("contents"))
				FOneItem.fviewcount = rsCTget("viewcount")
				FOneItem.fcommentcount = rsCTget("commentcount")
				FOneItem.fkeywordcount = rsCTget("keywordcount")
				FOneItem.fdevice = rsCTget("device")
				FOneItem.fregdate = rsCTget("regdate")
				FOneItem.fisusing = rsCTget("isusing")
	            FOneItem.FTag		= rsCTget("tag")

	            FOneItem.fitemid		= rsCTget("itemid")
				FOneItem.fitemname = rsCTget("itemname")
				FOneItem.FSellcash    = rsCTget("sellcash")
				FOneItem.FOrgPrice   	= rsCTget("orgprice")
				FOneItem.FMakerId   	= db2html(rsCTget("makerid"))
				FOneItem.FBrandName  	= db2html(rsCTget("brandname"))
				FOneItem.FSellYn      = rsCTget("sellyn")
				FOneItem.FSaleYn     	= rsCTget("sailyn")
				FOneItem.FLimitYn     = rsCTget("limityn")
				FOneItem.FLimitNo     = rsCTget("limitno")
				FOneItem.FLimitSold   = rsCTget("limitsold")
				FOneItem.fitemregdate 		= rsCTget("itemregdate")
				FOneItem.FReipgodate		= rsCTget("reipgodate")
                FOneItem.Fitemcouponyn 	= rsCTget("itemcouponYn")
				FOneItem.FItemCouponValue= rsCTget("itemCouponValue")
				FOneItem.Fitemcoupontype	= rsCTget("itemCouponType")
				FOneItem.Fevalcnt 		= rsCTget("evalCnt")
				FOneItem.FitemScore 		= rsCTget("itemScore")
				FOneItem.FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("listimage")
				FOneItem.FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("listimage120")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("smallImage")
				FOneItem.FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("icon1image")
				FOneItem.FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("icon2image")
				FOneItem.Fitemdiv		= rsCTget("itemdiv")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage")
				FOneItem.FImageBasic600 = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage600")
				FOneItem.FfavCount	= rsCTget("favcount")
				FOneItem.fspecialuseritem	= rsCTget("specialuseritem")
				
        	End If
        rsCTget.Close
	End Sub

	'//gift/day/index.asp
	Public Function getgiftday_detail_paging()	
        dim strSQL, i, vKey

        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_cnt '"&frectmasteridx&"', '"&frectgiftgubun&"', '"&frectitemid&"', '"&frectuserid&"', '"&frectisusing&"', '"&FRectkeywordidx&"'"

		'response.write strSQL & "<Br>"
		rsCTget.Open strSQL, dbCTget
            FTotalCount = rsCTget("cnt")
        rsCTget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_list '"&frectmasteridx&"', '"&frectgiftgubun&"', '"&frectitemid&"', '"&frectuserid&"', '"&frectisusing&"', '"&FRectkeywordidx&"', '"&FRectSort&"', "&CStr(FPageSize*FCurrPage)&""

		'response.write strSQL & "<Br>"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic'
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open strSQL, dbCTget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsCTget.EOF then
            i = 0
            rsCTget.absolutepage = FCurrPage
            do until (rsCTget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fdetailidx = rsCTget("detailidx")
	            FItemList(i).fmasteridx = rsCTget("masteridx")
	            FItemList(i).fgiftgubun = rsCTget("giftgubun")
	            FItemList(i).fuserid = rsCTget("userid")
	            FItemList(i).fcontents = db2html(rsCTget("contents"))
	            FItemList(i).fviewcount = rsCTget("viewcount")
	            FItemList(i).fcommentcount = rsCTget("commentcount")
	            FItemList(i).fkeywordcount = rsCTget("keywordcount")
	            FItemList(i).fdevice = rsCTget("device")
	            FItemList(i).fregdate = rsCTget("regdate")
	            FItemList(i).fisusing = rsCTget("isusing")
	            FItemList(i).FTag		= rsCTget("tag")
	            FItemList(i).fitemid		= rsCTget("itemid")
	            FItemList(i).fitemname = rsCTget("itemname")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage")
				
        		rsCTget.MoveNext
        		i = i + 1
            loop
        end if
        rsCTget.close
	end Function

	'//gift/day/index_item.asp itemlist
	Public Function FnGiftDayIndexItemList()	
        dim strSQL, i, vKey

        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_indexitem_cnt '"&frectmasteridx&"' "

		'response.write strSQL & "<Br>"
		rsCTget.Open strSQL, dbCTget
            FTotalCount = rsCTget("cnt")
        rsCTget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_Gifts.dbo.sp_Ten_Giftday_indexitem_list '"&frectmasteridx&"', "& CStr(FPageSize*FCurrPage) &""

		'response.write strSQL & "<Br>"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic'
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		rsCTget.Open strSQL, dbCTget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsCTget.EOF then
            i = 0
            rsCTget.absolutepage = FCurrPage
            do until (rsCTget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fitemid			= rsCTget("itemid")
				FItemList(i).fitemname			= rsCTget("itemname")
				FItemList(i).FSellcash			= rsCTget("sellcash")
				FItemList(i).FOrgPrice   		= rsCTget("orgprice")
				FItemList(i).FMakerId   		= db2html(rsCTget("makerid"))
				FItemList(i).FBrandName  		= db2html(rsCTget("brandname"))
				FItemList(i).FSellYn			= rsCTget("sellyn")
				FItemList(i).FSaleYn     		= rsCTget("sailyn")
				FItemList(i).FLimitYn			= rsCTget("limityn")
				FItemList(i).FLimitNo			= rsCTget("limitno")
				FItemList(i).FLimitSold			= rsCTget("limitsold")
                FItemList(i).Fitemcouponyn 		= rsCTget("itemcouponYn")
				FItemList(i).FItemCouponValue	= rsCTget("itemCouponValue")
				FItemList(i).Fitemcoupontype	= rsCTget("itemCouponType")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("basicimage")
				FItemList(i).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsCTget("itemid"))&"/"&rsCTget("icon1image")
				
        		rsCTget.MoveNext
        		i = i + 1
            loop
        end if
        rsCTget.close
	end Function

	'//gift/day/index.asp
	Public Sub getgiftday_master_notpaging
		dim sqlStr,i

		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_master_notpaging"
		
		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount
		redim preserve FItemList(FResultCount)

		i=0
		if not rsCTget.EOF  then
			do until rsCTget.EOF
				set fitemlist(i) = new Cgiftday_item
				
				FItemList(i).fmasteridx = rsCTget("masteridx")
				FItemList(i).ftitle = db2html(rsCTget("title"))
				FItemList(i).fstartdate = rsCTget("startdate")
				FItemList(i).fenddate = rsCTget("enddate")
				FItemList(i).flisttopimg_w = rsCTget("listtopimg_w")
				FItemList(i).flisttopimg_m = rsCTget("listtopimg_m")
				FItemList(i).fregtopimg_m = rsCTget("regtopimg_m")
				FItemList(i).fregdate = rsCTget("regdate")
				FItemList(i).fisusing = rsCTget("isusing")

				rsCTget.movenext
				i=i+1
			loop
		end if
		rsCTget.Close
	end sub

	'//gift/day/index.asp
	Public Sub getgiftday_master_one
		Dim sqlStr, i
		
		sqlStr = "exec db_Gifts.dbo.sp_Ten_Giftday_master_one '"&Frectmasteridx&"','"&Frectisusing&"'"
		
		'Response.write sqlStr &"<br>"
        rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
        rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget
		
		ftotalcount = rsCTget.recordcount
		FResultCount = rsCTget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsCTget.Eof then

				FOneItem.fmasteridx = rsCTget("masteridx")
				FOneItem.ftitle = db2html(rsCTget("title"))
				FOneItem.fstartdate = rsCTget("startdate")
				FOneItem.fenddate = rsCTget("enddate")
				FOneItem.flisttopimg_w = rsCTget("listtopimg_w")
				FOneItem.flisttopimg_m = rsCTget("listtopimg_m")
				FOneItem.fregtopimg_m = rsCTget("regtopimg_m")
				FOneItem.fregdate = rsCTget("regdate")
				FOneItem.fisusing = rsCTget("isusing")
				FOneItem.fdetailcount = rsCTget("detailcount")
				FOneItem.fstatus = rsCTget("status")

        	End If
        rsCTget.Close
	End Sub


	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FCurrPage =1
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount = 0
	End Sub
	Private Sub Class_Terminate()
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
end Class

Function getdaydetailReadCount(detailidx)
	Dim vQuery

	if detailidx="" then exit function

	vQuery = "exec db_Gifts.dbo.sp_Ten_Giftday_detail_ReadCount '" & detailidx & "'"
	'response.write vQuery & "<br>"
	dbCTget.Execute vQuery
End function

Function fngiftdayTagLinkSetting(masteridx, g, tag)
	Dim vBody, i, vTemp, vTag, vKey, vPage
	If g = "i" Then
		vPage = "/gift/giftday/index.asp"
	ElseIf g = "m" Then
		vPage = ""
	End If
	
	if tag<>"" then
		For i = LBound(Split(tag,"@")) To UBound(Split(tag,"@"))
			vTemp = Split(tag,"@")(i)
			vKey = Split(vTemp,",")(0)
			vTag = Split(vTemp,",")(1)
			vBody = vBody & "<a href=""javascript:gogiftdayKeyword('"&masteridx&"', '"&vKey&"');"">" & db2html(vTag) &"</a>, "
		Next
	End IF

	If vBody <> "" Then
		vBody = Trim(vBody)
		If Right(vBody,1) = "," Then
			vBody = Left(vBody,Len(vBody)-1)
		End IF
	End IF
	
	fngiftdayTagLinkSetting = vBody
End Function

'// gift 키워드 항목 출력 (클릭함수,선택값)
Function getGiftKeyword(vClk,arrChk)
	Dim strRst, sqlStr
	sqlStr = "Select keywordIdx, keywordname "
	sqlStr = sqlStr & "From db_Gifts.dbo.tbl_gift_keyword "
	sqlStr = sqlStr & "Where isUsing='Y' and keywordType=1 "
	sqlStr = sqlStr & "Order by sortNo asc, keywordIdx asc "
	rsCTget.Open sqlStr, dbCTget, 1
	if Not(rsCTget.EOF or rsCTget.BOF) then
		strRst = "<ul>" & vbCrLf
		Do Until rsCTget.EOF
			strRst = strRst & "<li><span onclick=""" & vClk & """ keyIdx=""" & rsCTget("keywordIdx") & """ " & chkIIF(chkArrValue(arrChk,rsCTget("keywordIdx")),"class=""on""","") & ">" & rsCTget("keywordname") & "</span></li>"
			rsCTget.MoveNext
		Loop
		strRst = strRst & "<ul>" & vbCrLf
	end if
	rsCTget.Close

	getGiftKeyword = strRst
End Function

'// gift Tag 항목 출력 (어레이값,구분자1,구분자2,클릭함수)
Function getGiftTag(vTag,vDiv1,vDiv2,vClk)
	Dim strRst, arrGp, vItm, arrItm

	arrGp = split(vTag,vDiv1)
	if ubound(arrGp)<0 then Exit Function

	for each vItm in arrGp
		arrItm = split(vItm,vDiv2)
		if ubound(arrItm)>0 then
			strRst = strRst & chkIIF(strRst<>"",", ","")
			strRst = strRst & "<a href=""#"" onclick=""" & vClk & ";return false;"" keyIdx=""" & arrItm(0) & """>" & arrItm(1) & "</a>"
		end if
	next

	getGiftTag = strRst
End Function

'// 작성 시간 출력 (시간,표시제한시간)
Function getRegTimeTerm(vDt,vLimit)
	Dim strRst
	if Not(isDate(vDt)) then Exit Function

	if dateDiff("h",vDt,now)<vLimit then
		if dateDiff("h",vDt,now)<1 then
			'1시간 이내
			strRst = dateDiff("n",vDt,now) & "분 전"
		else
			'1시간 초과
			strRst = dateDiff("h",vDt,now) & "시간 전"
		end if
	else
		strRst = FormatDate(vDt,"0000.00.00")  
	end if

	getRegTimeTerm = strRst
End Function

'//남은 날짜 출력		'2014.04.03 한용민 생성
Function getdayTerm(vDt,vLimit)
	Dim strRst
	if Not(isDate(vDt)) then Exit Function

	strRst=datediff("d", now(), vDt)
	if strRst < vLimit then strRst=0

	getdayTerm = strRst
End Function
%>	
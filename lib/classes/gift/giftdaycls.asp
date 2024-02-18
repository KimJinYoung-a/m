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
	public fmtitle
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
	public Frectmtitle
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
		
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_Giftday_Keyword_List] "
		'response.write strSql
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSql,dbget,1

		FResultCount = rsget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsget.EOF then
			fnGiftDayKeywordList = rsget.getRows()
		end if
		rsget.close
	End Function

	'//gift/day/view.asp
	Public Function getgiftday_detail_comment_paging()	
        dim strSQL, i, vKey

        strSQL = "exec db_board.dbo.sp_Ten_Giftday_detail_comment_cnt '"&frectdetailidx&"', '"&frectuserid&"', '"&frectisusing&"'"

		'response.write strSQL & "<Br>"
		rsget.Open strSQL, dbget
            FTotalCount = rsget("cnt")
        rsget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_board.dbo.sp_Ten_Giftday_detail_comment_list '"&frectdetailidx&"', '"&frectuserid&"', '"&frectisusing&"', "&CStr(FPageSize*FCurrPage)&""

		'response.write strSQL & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic'
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSQL, dbget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fdetailcommentidx = rsget("detailcommentidx")
	            FItemList(i).fdetailidx = rsget("detailidx")
	            FItemList(i).fuserid = rsget("userid")
	            FItemList(i).fcomment = db2html(rsget("comment"))
	            FItemList(i).fregdate = rsget("regdate")
	            FItemList(i).fdevice = rsget("device")
	            FItemList(i).fisusing = rsget("isusing")

        		rsget.MoveNext
        		i = i + 1
            loop
        end if
        rsget.close
	end Function

	'//gift/day/inc_bestday.asp
	Public Sub getgiftday_detail_bestday
		dim sqlStr,i

		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_detail_bestday"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		redim preserve FItemList(FResultCount)

		i=0
		if not rsget.EOF  then
			do until rsget.EOF
				set fitemlist(i) = new Cgiftday_item

				FItemList(i).fdetailidx = rsget("detailidx")
				FItemList(i).fmasteridx = rsget("masteridx")
				FItemList(i).fgiftgubun = rsget("giftgubun")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).fviewcount = rsget("viewcount")
				FItemList(i).fcommentcount = rsget("commentcount")
				FItemList(i).fkeywordcount = rsget("keywordcount")
				FItemList(i).fdevice = rsget("device")
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fisusing = rsget("isusing")

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub
	
	'//gift/day/view.asp
	Public Sub getgiftday_detail_preview
		Dim sqlStr, i
		
		if Frectmasteridx="" or Frectdetailidx="" then exit Sub

		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_detail_preview '"&frectmasteridx&"', '"&frectdetailidx&"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsget.Eof then

				FOneItem.fdetailidx = rsget("detailidx")
				FOneItem.fmasteridx = rsget("masteridx")
				FOneItem.fgiftgubun = rsget("giftgubun")
				FOneItem.fuserid = rsget("userid")
				FOneItem.fcontents = db2html(rsget("contents"))
				FOneItem.fviewcount = rsget("viewcount")
				FOneItem.fcommentcount = rsget("commentcount")
				FOneItem.fkeywordcount = rsget("keywordcount")
				FOneItem.fdevice = rsget("device")
				FOneItem.fregdate = rsget("regdate")
				FOneItem.fisusing = rsget("isusing")

				FOneItem.fitemname = rsget("itemname")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("smallImage")
        	End If
        rsget.Close
	End Sub
 

	'//gift/day/view.asp
	Public Sub getgiftday_detail_nextview
		Dim sqlStr, i
		
		if Frectmasteridx="" or Frectdetailidx="" then exit Sub

		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_detail_nextview '"&frectmasteridx&"', '"&frectdetailidx&"'"

		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsget.Eof then

				FOneItem.fdetailidx = rsget("detailidx")
				FOneItem.fmasteridx = rsget("masteridx")
				FOneItem.fgiftgubun = rsget("giftgubun")
				FOneItem.fuserid = rsget("userid")
				FOneItem.fcontents = db2html(rsget("contents"))
				FOneItem.fviewcount = rsget("viewcount")
				FOneItem.fcommentcount = rsget("commentcount")
				FOneItem.fkeywordcount = rsget("keywordcount")
				FOneItem.fdevice = rsget("device")
				FOneItem.fregdate = rsget("regdate")
				FOneItem.fisusing = rsget("isusing")

				FOneItem.fitemname = rsget("itemname")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("smallImage")
        	End If
        rsget.Close
	End Sub
 

	'//gift/day/view.asp
	Public Sub getgiftday_detail_one
		Dim sqlStr, i
		
		if Frectdetailidx="" then exit Sub

		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_detail_one '"&frectdetailidx&"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsget.Eof then

				FOneItem.fdetailidx = rsget("detailidx")
				FOneItem.fmasteridx = rsget("masteridx")
				FOneItem.fgiftgubun = rsget("giftgubun")
				FOneItem.fuserid = rsget("userid")
				FOneItem.fcontents = db2html(rsget("contents"))
				FOneItem.fviewcount = rsget("viewcount")
				FOneItem.fcommentcount = rsget("commentcount")
				FOneItem.fkeywordcount = rsget("keywordcount")
				FOneItem.fdevice = rsget("device")
				FOneItem.fregdate = rsget("regdate")
				FOneItem.fisusing = rsget("isusing")
	            FOneItem.FTag		= rsget("tag")

	            FOneItem.fitemid		= rsget("itemid")
				FOneItem.fitemname = rsget("itemname")
				FOneItem.FSellcash    = rsget("sellcash")
				FOneItem.FOrgPrice   	= rsget("orgprice")
				FOneItem.FMakerId   	= db2html(rsget("makerid"))
				FOneItem.FBrandName  	= db2html(rsget("brandname"))
				FOneItem.FSellYn      = rsget("sellyn")
				FOneItem.FSaleYn     	= rsget("sailyn")
				FOneItem.FLimitYn     = rsget("limityn")
				FOneItem.FLimitNo     = rsget("limitno")
				FOneItem.FLimitSold   = rsget("limitsold")
				FOneItem.fitemregdate 		= rsget("itemregdate")
				FOneItem.FReipgodate		= rsget("reipgodate")
                FOneItem.Fitemcouponyn 	= rsget("itemcouponYn")
				FOneItem.FItemCouponValue= rsget("itemCouponValue")
				FOneItem.Fitemcoupontype	= rsget("itemCouponType")
				FOneItem.Fevalcnt 		= rsget("evalCnt")
				FOneItem.FitemScore 		= rsget("itemScore")
				FOneItem.FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("listimage")
				FOneItem.FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("listimage120")
				FOneItem.FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("smallImage")
				FOneItem.FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("icon1image")
				FOneItem.FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("icon2image")
				FOneItem.Fitemdiv		= rsget("itemdiv")
				FOneItem.FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
				FOneItem.FImageBasic600 = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage600")
				FOneItem.FfavCount	= rsget("favcount")
				FOneItem.fspecialuseritem	= rsget("specialuseritem")
				
        	End If
        rsget.Close
	End Sub

	'//gift/day/index.asp
	Public Function getgiftday_detail_paging()	
        dim strSQL, i, vKey

        strSQL = "exec db_board.dbo.sp_Ten_Giftday_detail_cnt '"&frectmasteridx&"', '"&frectgiftgubun&"', '"&frectitemid&"', '"&frectuserid&"', '"&frectisusing&"', '"&FRectkeywordidx&"'"

		'response.write strSQL & "<Br>"
		rsget.Open strSQL, dbget
            FTotalCount = rsget("cnt")
        rsget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_board.dbo.sp_Ten_Giftday_detail_list '"&frectmasteridx&"', '"&frectgiftgubun&"', '"&frectitemid&"', '"&frectuserid&"', '"&frectisusing&"', '"&FRectkeywordidx&"', '"&FRectSort&"', "&CStr(FPageSize*FCurrPage)&""

		'response.write strSQL & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic'
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSQL, dbget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fdetailidx = rsget("detailidx")
	            FItemList(i).fmasteridx = rsget("masteridx")
	            FItemList(i).fgiftgubun = rsget("giftgubun")
	            FItemList(i).fuserid = rsget("userid")
	            FItemList(i).fcontents = db2html(rsget("contents"))
	            FItemList(i).fviewcount = rsget("viewcount")
	            FItemList(i).fcommentcount = rsget("commentcount")
	            FItemList(i).fkeywordcount = rsget("keywordcount")
	            FItemList(i).fdevice = rsget("device")
	            FItemList(i).fregdate = rsget("regdate")
	            FItemList(i).fisusing = rsget("isusing")
	            FItemList(i).FTag		= rsget("tag")
	            FItemList(i).fitemid		= rsget("itemid")
	            FItemList(i).fitemname = rsget("itemname")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
				
        		rsget.MoveNext
        		i = i + 1
            loop
        end if
        rsget.close
	end Function

	'//gift/day/index_item.asp itemlist
	Public Function FnGiftDayIndexItemList()	
        dim strSQL, i, vKey

        strSQL = "exec db_board.dbo.sp_Ten_Giftday_indexitem_cnt '"&frectmasteridx&"' "

		'response.write strSQL & "<Br>"
		rsget.Open strSQL, dbget
            FTotalCount = rsget("cnt")
        rsget.Close

        if FTotalCount < 1 then exit Function
        
        strSQL = "exec db_board.dbo.sp_Ten_Giftday_indexitem_list '"&frectmasteridx&"', "& CStr(FPageSize*FCurrPage) &""

		'response.write strSQL & "<Br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic'
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSQL, dbget, 1

	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new Cgiftday_item

	            FItemList(i).fitemid			= rsget("itemid")
				FItemList(i).fitemname			= rsget("itemname")
				FItemList(i).FSellcash			= rsget("sellcash")
				FItemList(i).FOrgPrice   		= rsget("orgprice")
				FItemList(i).FMakerId   		= db2html(rsget("makerid"))
				FItemList(i).FBrandName  		= db2html(rsget("brandname"))
				FItemList(i).FSellYn			= rsget("sellyn")
				FItemList(i).FSaleYn     		= rsget("sailyn")
				FItemList(i).FLimitYn			= rsget("limityn")
				FItemList(i).FLimitNo			= rsget("limitno")
				FItemList(i).FLimitSold			= rsget("limitsold")
                FItemList(i).Fitemcouponyn 		= rsget("itemcouponYn")
				FItemList(i).FItemCouponValue	= rsget("itemCouponValue")
				FItemList(i).Fitemcoupontype	= rsget("itemCouponType")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("basicimage")
				FItemList(i).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"&rsget("icon1image")
				
        		rsget.MoveNext
        		i = i + 1
            loop
        end if
        rsget.close
	end Function

	'//gift/day/index.asp
	Public Sub getgiftday_master_notpaging
		dim sqlStr,i

		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_master_notpaging"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		redim preserve FItemList(FResultCount)

		i=0
		if not rsget.EOF  then
			do until rsget.EOF
				set fitemlist(i) = new Cgiftday_item
				
				FItemList(i).fmasteridx = rsget("masteridx")
				FItemList(i).ftitle = db2html(rsget("title"))
				FItemList(i).fmtitle = db2html(rsget("mtitle"))
				FItemList(i).fstartdate = rsget("startdate")
				FItemList(i).fenddate = rsget("enddate")
				FItemList(i).flisttopimg_w = rsget("listtopimg_w")
				FItemList(i).flisttopimg_m = rsget("listtopimg_m")
				FItemList(i).fregtopimg_m = rsget("regtopimg_m")
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fisusing = rsget("isusing")

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	'//gift/day/index.asp
	Public Sub getgiftday_master_one
		Dim sqlStr, i
		
		sqlStr = "exec db_board.dbo.sp_Ten_Giftday_master_one '"&Frectmasteridx&"','"&Frectisusing&"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

        SET FOneItem = new Cgiftday_item
	        If Not rsget.Eof then

				FOneItem.fmasteridx = rsget("masteridx")
				FOneItem.ftitle = db2html(rsget("title"))
				FOneItem.fmtitle = db2html(rsget("mtitle"))
				FOneItem.fstartdate = rsget("startdate")
				FOneItem.fenddate = rsget("enddate")
				FOneItem.flisttopimg_w = rsget("listtopimg_w")
				FOneItem.flisttopimg_m = rsget("listtopimg_m")
				FOneItem.fregtopimg_m = rsget("regtopimg_m")
				FOneItem.fregdate = rsget("regdate")
				FOneItem.fisusing = rsget("isusing")
				FOneItem.fdetailcount = rsget("detailcount")
				FOneItem.fstatus = rsget("status")

        	End If
        rsget.Close
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

	vQuery = "exec db_board.dbo.sp_Ten_Giftday_detail_ReadCount '" & detailidx & "'"
	'response.write vQuery & "<br>"
	dbget.Execute vQuery
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
	sqlStr = sqlStr & "From db_board.dbo.tbl_gift_keyword "
	sqlStr = sqlStr & "Where isUsing='Y' and keywordType=1 "
	sqlStr = sqlStr & "Order by sortNo asc, keywordIdx asc "
	rsget.Open sqlStr, dbget, 1
	if Not(rsget.EOF or rsget.BOF) then
		strRst = "<ul>" & vbCrLf
		Do Until rsget.EOF
			strRst = strRst & "<li><span onclick=""" & vClk & """ keyIdx=""" & rsget("keywordIdx") & """ " & chkIIF(chkArrValue(arrChk,rsget("keywordIdx")),"class=""on""","") & ">" & rsget("keywordname") & "</span></li>"
			rsget.MoveNext
		Loop
		strRst = strRst & "<ul>" & vbCrLf
	end if
	rsget.Close

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
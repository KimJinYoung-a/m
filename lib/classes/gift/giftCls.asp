<%
class CGiftTalkItem
	public FItemID
	public FItemName
	public FSellcash
	public FOrgPrice
	public FMakerID
	public FBrandName
	public FBrandName_kor
	public FBrandLogo
	public FMakerName
	public FcdL
	public FcdM
	public FcdS
	public FCateName
	public FImageBasic
	public FImageList
	public FImageList120
	public FImageSmall
	public FImageBasicIcon
	public FImageIcon1
	public FImageIcon2
	public FTalkIdx
	public FUserID
	public FTheme
	public FListCSS
	public FKeyword
	public FItem
	public FContents
	public FUseYN
	public FRegdate
	public FCommCnt
	public FIsNewComm
	public FIdx
	public FTag
	public FDevice
	public FViewCnt
	public FSelectoxab
    public fexecutetime
    public fisusing
    public forderno
    public flastadminid
    public flastupdate
    public fitemidx
    public fthemetype
    public ftitle
	public Fthemeidx
	public Fitemcnt
	public Fexecutedate
	public FsmallImage
	public fitemscore
	public ftalkcount
	public fitemarr
	public fspecialuseritem
	public FSaleYn
	public fgood
	public fbad
	public flistimage
	public ficon2image
	public FLimitYn
	public FLimitNo
	public FLimitSold
	public FReipgodate
	public Fitemcouponyn
	public FItemCouponValue
	public Fitemcoupontype
	public Fevalcnt
	public Fitemdiv
	public FImageBasic600
	public FfavCount
	public FSellYn

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

Class CGiftTalk
	public FItemList()
	public FOneItem
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectGubun
	public FRectIdx
	public FRectTalkIdx
	public FRectItemId
	public FRectUserId
	public FRectselectuserid
	public FRectTheme
	public FRectUseYN
	public FRectGoodBad
	public FRectContents
	public FRectKeyword
	public FRectOnlyCount
	public FRectDiv
	public FRectSort
	public FRectViewCnt
	public FRectCommCnt
	public FPre
	public FPreItem
	public FPreTitle
	public FNext
	public FNextItem
	public FNextTitle
	public F1Item
	public F2Item
	public frectexecutedate
	public frectthemeidx
	public fitemtop
	public FRectSortMtd
	public FRectPackIdx
	public FRectIsSoldOut

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

	'//gift/gifttalk/hint.asp		'/2015.02.04 한용민 생성
	Public Sub getGifthint_notpaging_B
		dim sqlStr,i

		sqlStr = "exec db_board.dbo.sp_Ten_Gifthint_notpaging '"& frectexecutedate &"','"& frectthemeidx &"', '"& fitemtop &"'"
		
		'Response.write sqlStr &"<br>"
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"GHINT",sqlStr,60*10)
        if (rsMem is Nothing) then Exit Sub ''추가

		ftotalcount = rsMem.recordcount
		FResultCount = rsMem.recordcount
		redim preserve FItemList(FResultCount)

		i=0
		if not rsMem.EOF  then
			do until rsMem.EOF
				set fitemlist(i) = new CGiftTalkItem
				
	            FItemList(i).Fthemeidx = rsMem("themeidx")
	            FItemList(i).Fthemetype = rsMem("themetype")
	            FItemList(i).fexecutetime = rsMem("executetime")
	            FItemList(i).Ftitle = db2html(rsMem("title"))
	            FItemList(i).Fregdate = rsMem("regdate")
	            FItemList(i).Flastupdate = rsMem("lastupdate")
	            FItemList(i).fitemarr = rsMem("itemarr")

				rsMem.movenext
				i=i+1
			loop
		end if
		rsMem.Close
	end sub

	'//gift/gifttalk/hint.asp		'/2015.02.04 한용민 생성
	Public Sub getGifthint_notpaging
		dim sqlStr,i

		sqlStr = "exec db_board.dbo.sp_Ten_Gifthint_notpaging '"& frectexecutedate &"','"& frectthemeidx &"', '"& fitemtop &"'"
		
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
				set fitemlist(i) = new CGiftTalkItem
				
	            FItemList(i).Fthemeidx = rsget("themeidx")
	            FItemList(i).Fthemetype = rsget("themetype")
	            FItemList(i).fexecutetime = rsget("executetime")
	            FItemList(i).Ftitle = db2html(rsget("title"))
	            FItemList(i).Fregdate = rsget("regdate")
	            FItemList(i).Flastupdate = rsget("lastupdate")
	            FItemList(i).fitemarr = rsget("itemarr")

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	'/gift/talk/index.asp		'/2015.02.04 한용민 생성
	public Sub getGiftTalkmain
		Dim strSql, i, vKey

		strSql = "EXECUTE [db_board].dbo.sp_Ten_GiftTalk_main_new_Count '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '', '" & FpageSize & "'"

		'response.write strSql & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget("cnt")
			FTotalPage	= rsget("totPg")
		rsget.close

		if FTotalCount < 1 then exit Sub
		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		strSql = "EXECUTE db_board.dbo.sp_Ten_GiftTalk_main_new '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '" & FRectselectuserid & "', '" & FRectSort & "', '" & (FpageSize*FCurrPage) & "'"

		'response.write strSql & "<br>"
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
				set FItemList(i) = new CGiftTalkItem

				FItemList(i).FTalkIdx	= rsget("talk_idx")
				FItemList(i).FUserID	= rsget("userid")
				FItemList(i).FTheme		= rsget("theme")
				If rsget("theme") = "1" Then
					FItemList(i).FListCSS = "YN"
				ElseIf rsget("theme") = "2" Then
					FItemList(i).FListCSS = "AB"
				End If

				FItemList(i).FContents	= db2html(rsget("contents"))
				FItemList(i).FUseYN		= rsget("useyn")
				FItemList(i).FRegdate	= rsget("regdate")
				FItemList(i).FCommCnt	= rsget("comm_cnt")
				FItemList(i).FIsNewComm	= rsget("isnewcomm")
				FItemList(i).FDevice	= rsget("device")
				FItemList(i).FViewCnt	= rsget("view_cnt")
				
				if FRectselectuserid <> "" then
					FItemList(i).FSelectoxab= rsget("selectoxab")
				end if

				FItemList(i).fidx		= rsget("idx")
				FItemList(i).fitemid	= rsget("itemid")
				FItemList(i).fgood		= rsget("good")
				FItemList(i).fbad		= rsget("bad")
				FItemList(i).fitemname	= db2html(rsget("itemname"))
				FItemList(i).fmakerid	= rsget("makerid")
				FItemList(i).fbrandname	= db2html(rsget("brandname"))
				FItemList(i).flistimage	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageIcon1= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
				FItemList(i).ficon2image= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon2image")
				FItemList(i).FImageBasic= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub

	'//gift/gifttalk/mytalk_act.asp		'/2015.02.04 한용민 생성
	public Sub getGiftTalkList
		Dim strSql, i, vKey

		strSql = "EXECUTE [db_board].dbo.sp_Ten_GiftTalk_List_new_Count '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '', '" & FpageSize & "'"

		'response.write strSql & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget("cnt")
			FTotalPage	= rsget("totPg")
		rsget.close

		if FTotalCount < 1 then exit Sub
		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		strSql = "EXECUTE db_board.dbo.sp_Ten_GiftTalk_List_new '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '" & FRectselectuserid & "', '" & FRectSort & "', '" & (FpageSize*FCurrPage) & "'"

		'response.write strSql & "<br>"
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
				set FItemList(i) = new CGiftTalkItem

				FItemList(i).FTalkIdx	= rsget("talk_idx")
				FItemList(i).FUserID	= rsget("userid")
				FItemList(i).FTheme		= rsget("theme")
				If rsget("theme") = "1" Then
					FItemList(i).FListCSS = "YN"
				ElseIf rsget("theme") = "2" Then
					FItemList(i).FListCSS = "AB"
				End If

				FItemList(i).FContents	= db2html(rsget("contents"))
				FItemList(i).FUseYN		= rsget("useyn")
				FItemList(i).FRegdate	= rsget("regdate")
				FItemList(i).FCommCnt	= rsget("comm_cnt")
				FItemList(i).FIsNewComm	= rsget("isnewcomm")
				FItemList(i).FDevice	= rsget("device")
				FItemList(i).FViewCnt	= rsget("view_cnt")

				if FRectselectuserid <> "" then
					FItemList(i).FSelectoxab= rsget("selectoxab")
				end if

				FItemList(i).fidx		= rsget("idx")
				FItemList(i).fitemid	= rsget("itemid")
				FItemList(i).fgood		= rsget("good")
				FItemList(i).fbad		= rsget("bad")
				FItemList(i).fitemname	= db2html(rsget("itemname"))
				FItemList(i).fmakerid	= rsget("makerid")
				FItemList(i).fbrandname	= db2html(rsget("brandname"))
				FItemList(i).Fitemdiv		= rsget("itemdiv")
				FItemList(i).flistimage	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageIcon1= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
				FItemList(i).ficon2image= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon2image")
				if rsget("itemdiv") = "21" then
					if instr(rsget("basicimage"),"/") > 0 then
						FItemList(i).FImageBasic= "http://webimage.10x10.co.kr/image/basic/" + rsget("basicimage")
					else
						FItemList(i).FImageBasic= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					end if			
				else
					FItemList(i).FImageBasic= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
				end if

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub

	'//gift/talk/search.asp		'/2015.02.04 한용민 생성
	public Sub getGiftTalksearch
		Dim strSql, i, vKey

		strSql = "EXECUTE [db_board].dbo.sp_Ten_GiftTalk_search_new_Count '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '', '" & FpageSize & "'"

		'response.write strSql & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget("cnt")
			FTotalPage	= rsget("totPg")
		rsget.close

		if FTotalCount < 1 then exit Sub
		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		strSql = "EXECUTE db_board.dbo.sp_Ten_GiftTalk_search_new '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectUseYN & "', '" & FRectselectuserid & "', '" & FRectSort & "', '" & (FpageSize*FCurrPage) & "'"

		'response.write strSql & "<br>"
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
				set FItemList(i) = new CGiftTalkItem

				FItemList(i).FTalkIdx	= rsget("talk_idx")
				FItemList(i).FUserID	= rsget("userid")
				FItemList(i).FTheme		= rsget("theme")
				If rsget("theme") = "1" Then
					FItemList(i).FListCSS = "YN"
				ElseIf rsget("theme") = "2" Then
					FItemList(i).FListCSS = "AB"
				End If

				FItemList(i).FContents	= db2html(rsget("contents"))
				FItemList(i).FUseYN		= rsget("useyn")
				FItemList(i).FRegdate	= rsget("regdate")
				FItemList(i).FCommCnt	= rsget("comm_cnt")
				FItemList(i).FIsNewComm	= rsget("isnewcomm")
				FItemList(i).FDevice	= rsget("device")
				FItemList(i).FViewCnt	= rsget("view_cnt")
				
				if FRectselectuserid <> "" then
					FItemList(i).FSelectoxab= rsget("selectoxab")
				end if

				FItemList(i).fidx		= rsget("idx")
				FItemList(i).fitemid	= rsget("itemid")
				FItemList(i).fgood		= rsget("good")
				FItemList(i).fbad		= rsget("bad")
				FItemList(i).fitemname	= db2html(rsget("itemname"))
				FItemList(i).fmakerid	= rsget("makerid")
				FItemList(i).fbrandname	= db2html(rsget("brandname"))
				FItemList(i).flistimage	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageIcon1= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
				FItemList(i).ficon2image= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon2image")
				FItemList(i).FImageBasic= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub

	'/gift/talk/search.asp
	Public Sub getGiftTalk_searchitem
		Dim sqlStr, i
		
		if Frectitemid="" then exit Sub

		sqlStr = "exec db_board.dbo.sp_Ten_GiftTalk_searchitem '"& Frectitemid &"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount

        SET FOneItem = new CCategoryPrdItem
	        If Not rsget.Eof then
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
				FOneItem.fregdate 		= rsget("itemregdate")
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

	'# 선물포장 상품 목록
	'//gift/WRAPPING.asp
	public Sub GetPackageList()
		dim sqlStr, addSql, orderSql, i

		'품절 포함 여부
		if FRectIsSoldOut<>"Y" then
			addSql = addSql & " and i.sellyn in ('Y','S')"
		else
			addSql = addSql & " and i.sellyn in ('Y')"
		end if

		Select Case FRectSortMtd
			Case "ne"		'신상순
				orderSql = " order by i.itemid desc"
			Case "be"		'인기순
				orderSql = " order by i.itemscore desc, i.itemid desc"
			Case "lp"		'낮은 가격
				orderSql = " order by i.sellcash asc, i.itemid desc"
			Case "hp"		'높은 가격
				orderSql = " order by i.sellcash desc, i.itemid desc"
			Case "hs"		'높은 할인율
				orderSql = " order by ((i.orgprice-i.sellcash)/i.orgprice) desc, (i.orgprice-i.sellcash) desc, i.itemid desc"
			Case Else
				orderSql = " order by i.itemscore desc, i.itemid desc"
		End Select

        sqlStr = "select count(d.itemid), CEILING(CAST(Count(d.itemid) AS FLOAT)/" & FPageSize & ") " + vbcrlf
        sqlStr = sqlStr & "from db_board.dbo.tbl_giftShop_packInfo as m "
        sqlStr = sqlStr & "	join db_board.dbo.tbl_giftShop_packItem as d "
        sqlStr = sqlStr & "		on m.packIdx=d.packIdx "
        sqlStr = sqlStr & "	join db_item.dbo.tbl_item as i "
        sqlStr = sqlStr & "		on d.itemid=i.itemid "
        sqlStr = sqlStr & "Where m.packIdx=" & FRectPackIdx & " " & addSql
        
        'response.write sqlStr & "<br>"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget(0)
			FtotalPage = rsget(1)
		rsget.close

        sqlStr = "Select top " + CStr(FPageSize * FCurrPage) + " i.*, c.* "
        sqlStr = sqlStr & "	, isNull(f.talkCount,0) talkCount, isNull(f.dayCount,0) as dayCount, isNull(f.themeCount,0) as themeCount "
        sqlStr = sqlStr & "from db_board.dbo.tbl_giftShop_packInfo as m "
        sqlStr = sqlStr & "	join db_board.dbo.tbl_giftShop_packItem as d "
        sqlStr = sqlStr & "		on m.packIdx=d.packIdx "
        sqlStr = sqlStr & "	join db_item.dbo.tbl_item as i "
        sqlStr = sqlStr & "		on d.itemid=i.itemid "
        sqlStr = sqlStr & "	join db_item.dbo.tbl_item_contents as c "
        sqlStr = sqlStr & "		on i.itemid=c.itemid "
        sqlStr = sqlStr & "	left join db_board.dbo.tbl_gift_itemInfo as f "
        sqlStr = sqlStr & "		on d.itemid=f.itemid "
        sqlStr = sqlStr & "where m.packIdx=" & FRectPackIdx & " " & addSql & orderSql

        'response.write sqlStr & "<br>"
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).Fitemid			= rsget("itemid")
				FItemList(i).Fmakerid			= rsget("makerid")
				FItemList(i).Fbrandname			= rsget("brandname")
				FItemList(i).Fitemname			= rsget("itemname")
				FItemList(i).FfavCount			= rsget("favcount")
				FItemList(i).FOrgprice			= rsget("orgprice")
				FItemList(i).FItemDiv 			= rsget("itemdiv")
				FItemList(i).FSellCash 			= rsget("sellcash")
				FItemList(i).FLimitNo			= rsget("limitno")
				FItemList(i).FLimitSold			= rsget("LimitSold")
				FItemList(i).FSpecialUserItem	= rsget("specialuseritem")
				FItemList(i).FDeliverytype		= rsget("deliverytype")
				FItemList(i).FEvalCnt			= rsget("evalcnt")
				FItemList(i).FOptionCnt			= rsget("optioncnt")
				FItemList(i).FisUsing			= rsget("isUsing")
				FItemList(i).FSellYn			= rsget("sellyn")
				FItemList(i).FSaleYn			= rsget("sailyn")
				FItemList(i).FLimitYn 			= rsget("limityn")
				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	= rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				FItemList(i).FAvailPayType		= rsget("AvailPayType")
				FItemList(i).FRegdate 			= rsget("regdate")
				FItemList(i).FtalkCnt			= rsget("talkCount")
				FItemList(i).FdayCnt			= rsget("dayCount")
				FItemList(i).FthemeCnt			= rsget("themeCount")

				if Not(rsget("basicimage")="" or isNull(rsget("basicimage"))) then
					FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("basicimage")
				end if

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	End Sub

	'####### talk 리스트 -->
	public Sub sbGiftTalkList
		Dim strSql, i, vKey

		FResultCount = 0

		If FRectTalkIdx = "" Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_List_Count] '" & FpageSize & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "', '" & FRectDiv & "'"

			'response.write strSql & "<br>"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSql,dbget,1
				FTotalCount = rsget(0)
				FTotalPage	= rsget(1)
			rsget.close

			If FRectTalkIdx <> "" Then
				FTotalCount = 1
				FTotalPage = 1
			End IF
		Else	'####### view.asp 에 사용
			FTotalCount = 1
		End IF

		If FTotalCount > 0 Then
			If FRectSort = "" Then
				FRectSort = "t.talk_idx DESC"
			Else
				If FRectSort = "1" Then
					FRectSort = "t.talk_idx DESC"
				ElseIf FRectSort = "2" Then
					FRectSort = "t.view_cnt DESC, t.talk_idx DESC"
				ElseIf FRectSort = "3" Then
					FRectSort = "t.comm_cnt DESC, t.talk_idx DESC"
				Else
					FRectSort = "t.talk_idx DESC"
				End If
			End IF

			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_List] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectItemId & "', '" & FRectTheme & "', '" & FRectKeyword & "', '" & FRectUseYN & "', '" & FRectDiv & "', '" & FRectSort & "'"

			'response.write strSql & "<br>"
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
					set FItemList(i) = new CGiftTalkItem
					
					FItemList(i).FTalkIdx	= rsget("talk_idx")
					FItemList(i).FUserID	= rsget("userid")
					FItemList(i).FTheme		= rsget("theme")
					If rsget("theme") = "1" Then
						FItemList(i).FListCSS = "YN"
					ElseIf rsget("theme") = "2" Then
						FItemList(i).FListCSS = "AB"
					End If
					FItemList(i).FItem		= rsget("item")
					'FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					FItemList(i).FContents	= db2html(rsget("contents"))
					FItemList(i).FUseYN		= rsget("useyn")
					FItemList(i).FRegdate	= rsget("regdate")
					FItemList(i).FCommCnt	= rsget("comm_cnt")
					FItemList(i).FIsNewComm	= rsget("isnewcomm")
					FItemList(i).FTag		= rsget("tag")
					FItemList(i).FDevice	= rsget("device")
					FItemList(i).FViewCnt	= rsget("view_cnt")

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Sub

	'####### gift write itemlist AJAX -->
	public Sub fnGiftTalkItemAjaxList
		Dim strSql, vArr, i
		
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_ItemAjaxList] '" & FRectItemId & "'"
		'response.write strSql
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1

		FResultCount = rsget.RecordCount
        if (FResultCount<1) then FResultCount=0

		if not rsget.EOF then
			vArr = rsget.getRows()
		end if
		rsget.close
		
		REDIM FItemList(FResultCount)
		
		For i=0 To FResultCount -1
			SET FItemList(i) = NEW CCategoryPrdItem
				FItemList(i).FItemid = vArr(0,i)
				FItemList(i).FItemName = db2html(vArr(1,i))
				FItemList(i).FMakerId = vArr(2,i)
				FItemList(i).FBrandName = db2html(vArr(3,i))
				FItemList(i).FImageList 	= "http://webimage.10x10.co.kr/image" & "/list/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(4,i))
				FItemList(i).FImageIcon1 = "http://webimage.10x10.co.kr/image" & "/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(5,i))
				FItemList(i).FImageIcon2 	= "http://webimage.10x10.co.kr/image" & "/icon2/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(6,i))
				FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image" & "/basic/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(vArr(7,i))
				FItemList(i).FSellCash = vArr(8,i)
				FItemList(i).FOrgPrice = vArr(9,i)
				FItemList(i).FSaleyn = vArr(10,i)
				FItemList(i).FSellyn = vArr(11,i)
				FItemList(i).FItemcouponyn = vArr(12,i)
				FItemList(i).FItemCouponValue = vArr(13,i)
				FItemList(i).FItemCouponType = vArr(14,i)
				FItemList(i).FSpecialUserItem = vArr(15,i)
				FItemList(i).FfavCount = vArr(16,i)
				FItemList(i).FEvalCnt = vArr(17,i)
				
				If FResultCount > 1 Then
					If CStr(Split(FRectItemId,",")(0)) = CStr(FItemList(i).FItemid) Then
						F1Item = i
					End If
					If CStr(Split(FRectItemId,",")(1)) = CStr(FItemList(i).FItemid) Then
						F2Item = i
					End If
				End If
		Next
	End Sub

	'####### 나의 아이템 리스트 -->
	public Function fnGiftTalkMyItemList
		Dim strSql, i
		
		strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_MyItemList_Count] '" & FpageSize & "', '" & FRectUserId & "'"
		'response.write strSql
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close
		

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_MyItemList] '" & FpageSize & "', '" & FRectUserId & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)
			
			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CGiftTalkItem
	
					FItemList(i).FItemID		= rsget("itemid")
					FItemList(i).FItemName		= db2html(rsget("itemname"))
					FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1image")
					FItemList(i).FBrandName		= db2html(rsget("brandname"))
					FItemList(i).FMakerID		= rsget("makerid")
					
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function

	'####### talk comment 리스트 -->
	public Function fnGiftTalkCommList
		Dim strSql, i

			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_CommList_Count] '" & FpageSize & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			'response.write strSql
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSql,dbget,1
				FTotalCount = rsget(0)
				FTotalPage	= rsget(1)
			rsget.close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_CommList] '" & (FpageSize*FCurrPage) & "', '" & FRectTalkIdx & "', '" & FRectUserId & "', '" & FRectUseYN & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSql,dbget,1
			'response.write strSql

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)

			i=0
			if  not rsget.EOF  then
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FItemList(i) = new CGiftTalkItem

					FItemList(i).FIdx		= rsget("idx")
					FItemList(i).FUserID	= rsget("userid")
					FItemList(i).FContents	= db2html(rsget("contents"))
					FItemList(i).FUseYN		= rsget("useyn")
					FItemList(i).FRegdate	= rsget("regdate")
					FItemList(i).FDevice	= rsget("device")

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
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

'//톡 조회수 증가
Function fnTalkReadCount(talkidx)
	Dim vQuery
	vQuery = "EXECUTE [db_board].[dbo].[sp_Ten_GiftTalk_ReadCount] '" & talkidx & "'"
	dbget.Execute vQuery
End function

Function fnTalkRegTime(d)
	If DateDiff("h",d,now()) > 23 Then
		fnTalkRegTime = Replace(Left(d,10),"-",".")
	ElseIf DateDiff("h",d,now()) = 0 Then
		fnTalkRegTime = "지금 막"
	Else 
		fnTalkRegTime = DateDiff("h",d,now()) & "시간 전"
	End If
End Function

'// 원 판매 가격  '!
Function getOrgPrice(FOrgPrice, FSellCash)
	if FOrgPrice=0 then
		getOrgPrice = FSellCash
	else
		getOrgPrice = FOrgPrice
	end if
End Function

'// 세일포함 실제가격  '!
Function getRealPrice(sellcash, specialuseritem)
	getRealPrice = sellcash

	if (IsSpecialUserItem(specialuseritem)) then
		getRealPrice = getSpecialShopItemPrice(sellcash)
	end if
End Function

'// 할인율 '!
Function getSalePro(FOrgprice, sellcash, specialuseritem)
	if FOrgprice=0 then
		getSalePro = 0 & "%"
	else
		getSalePro = CLng((FOrgPrice-getRealPrice(sellcash, specialuseritem))/FOrgPrice*100) & "%"
	end if
End Function

'// 우수회원샵 상품 여부 '!
Function IsSpecialUserItem(specialuseritem)
    dim uLevel
    uLevel = GetLoginUserLevel()
	IsSpecialUserItem = (specialuseritem>0) and (uLevel>0 and uLevel<>5)
End Function

'// 세일 상품 여부 '!
Function IsSaleItem(FSaleYn, FOrgPrice, FSellCash, specialuseritem)
    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) or (IsSpecialUserItem(specialuseritem))
End Function

'// 상품 쿠폰 여부  '!
Function IsCouponItem(FItemCouponYN)
	IsCouponItem = (FItemCouponYN="Y")
End Function

'// 쿠폰 적용가
Function GetCouponAssignPrice(FItemCouponYN, sellcash, specialuseritem, Fitemcoupontype, Fitemcouponvalue)
	if (IsCouponItem(FItemCouponYN)) then
		GetCouponAssignPrice = getRealPrice(sellcash, specialuseritem) - GetCouponDiscountPrice(Fitemcoupontype, Fitemcouponvalue, sellcash, specialuseritem)
	else
		GetCouponAssignPrice = getRealPrice(sellcash, specialuseritem)
	end if
End Function

'// 쿠폰 할인가 '?
Function GetCouponDiscountPrice(Fitemcoupontype, Fitemcouponvalue, sellcash, specialuseritem)
	Select case Fitemcoupontype
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(Fitemcouponvalue*getRealPrice(sellcash, specialuseritem)/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = Fitemcouponvalue
		case "3" ''무료배송 쿠폰
		    GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
End Function

'// 상품 쿠폰 내용  '!
Function GetCouponDiscountStr(Fitemcoupontype, Fitemcouponvalue)
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
End Function

Function fnSortMatching(a)
	SELECT Case a
		Case "fav" : fnSortMatching = "be"
		Case "new" : fnSortMatching = "ne"
		Case "highprice" : fnSortMatching = "hp"
		Case "lowprice" : fnSortMatching = "lp"
		Case Else : fnSortMatching = "be"
	End SELECT
End Function

function getthemetype(themetype)
	dim tmpthemetype

	if themetype="" then exit function

	if themetype="1" then
		tmpthemetype="HIM"
	elseif themetype="2" then
		tmpthemetype="TEEN"
	elseif themetype="3" then
		tmpthemetype="BABY"
	elseif themetype="4" then
		tmpthemetype="HER"
	elseif themetype="5" then
		tmpthemetype="HOME"
	end if
	
	getthemetype=tmpthemetype
end function

'// 작성 시간 출력
Function getRegTimeTerm(vDt,vLimit)
	Dim strRst
	if Not(isDate(vDt)) then Exit Function

	if dateDiff("d",vDt,now)<vLimit then
		if dateDiff("h",vDt,now)<1 then
			strRst = mid(vDt,11,6)
		else
			strRst = mid(vDt,11,6)
		end if
	else
		strRst = FormatDate(vDt,"0000.00.00")
	end if

	getRegTimeTerm = strRst
End Function

Function getgifttalk_my_count(ByVal userid)
	dim sqlStr, tmpcnt
		tmpcnt=0

	if userid="" then
		getgifttalk_my_count=0
		exit Function
	end if

	sqlStr = "exec db_board.dbo.sp_Ten_GiftTalk_my_Count '"&userid&"'"
	
	'Response.write sqlStr &"<br>"
    rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr, dbget

	'response.write SqlStr&"<br>"
	if not rsget.EOF then
        tmpcnt = rsget("cnt")
	end if
	rsget.close

	getgifttalk_my_count=tmpcnt
END Function

Function getgifttalk_item_count(ByVal itemid)
	dim sqlStr, tmpcnt
		tmpcnt=0

	if itemid="" then
		getgifttalk_item_count=0
		exit Function
	end if

	sqlStr = "exec db_board.dbo.sp_Ten_GiftTalk_item_Count '"&itemid&"'"
	
	'Response.write sqlStr &"<br>"
    rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr, dbget

	'response.write SqlStr&"<br>"
	if not rsget.EOF then
        tmpcnt = rsget("cnt")
	end if
	rsget.close

	getgifttalk_item_count=tmpcnt
END Function
%>
<%
'#######################################################
'	History	: 2014.09.11 원승현 생성
'	Description : 모바일 위시 클래스
'#######################################################


CLASS CAutoWish
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectItemId
	public FRectCD1
	public FRectCD2
	public FRectCD3
	public FRectDisp
	public FRectMakerID
	public FItemList()
	Public FRectSellScope
	Public FbetCateCd
	Public FbetCateNm
	Public FSellScope
	Public FSortMet

	public FDiscountRate
	public FWishList()
	public FWishSubList()
	public FWishPrdList()
	public FWishBrand()
	public FWishPrd
	public FADD()

	public FResultBCount
	public RoundUP

	public FRectBestType

	public FRectCH
	public FRectOrder
	public FRectStyleGubun
	public FRectItemStyle
	public FRectSort
	public FNotinlist
	Public FRectitemarr
	Public Fdesignerid
	Public FuserID
	Public FTargetUserID
	public FchkResult
	Public FFavCount
	Public FUserIconNo
	Public FisMyWishChk
	Public FFollowerCnt
	Public FFollowingCnt
	Public FFollowerChk
	Public FFolderIdx
	Public FFolderName
	Public FFolderViewusing
	Public FFolderitemcnt
	Public FFimageList
	Public FFvUChk
	Public FFBasicImage
	Public FCateCode

	Public FRectOnlySellY

	public FRectPercentLow
    public FRectPercentHigh

    public FRectSearchFlag
    public FRectSortMethod
	public FRectSearchItemDiv

	Public FFReturnValue

	Private Sub Class_Initialize()
		FCurrPage =0
		FPageSize = 10
		FTotalPage = 1
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub


	'// 위시 리스트 불러오기(트랜드)
	public Sub GetWishTrendList()
		dim strSQL,i, j

		strSQL = "exec [db_sitemaster].[dbo].[sp_Ten_WishList] '" + CStr(FPageSize)  + "','" + CStr(FCurrPage)+ "','" + FuserID + "'"  + vbcrlf
			'rw strSQL
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
'			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then
			FResultCount = rsget.RecordCount
            if (FResultCount<1) then FResultCount=0

			redim preserve FWishPrdList(FResultCount)
			i=0
'				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FWishPrdList(i) = new CCategoryPrdItem

					FWishPrdList(i).Fuserid = rsget("userid")
					FWishPrdList(i).FItemID       = rsget("itemid")
					FWishPrdList(i).FItemName     = db2html(rsget("itemname"))
					FWishPrdList(i).FSellcash     = rsget("sellcash")
					FWishPrdList(i).FSellYn       = rsget("sellyn")
					FWishPrdList(i).FLimitYn      = rsget("limityn")
					FWishPrdList(i).FLimitNo      = rsget("limitno")
					FWishPrdList(i).FLimitSold    = rsget("limitsold")
					FWishPrdList(i).Fitemgubun    = rsget("itemgubun")
					FWishPrdList(i).FDeliverytype = rsget("deliverytype")
					FWishPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FWishPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")
					FWishPrdList(i).FitemCouponstartdate	= rsget("itemcouponstartdate")
					FWishPrdList(i).Fitemcouponexpiredate	= rsget("itemcouponexpiredate")
					FWishPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

'					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FWishPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
'					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FWishPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("icon1image")
'					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")
'					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("BasicImage")
					if rsget("BasicImage600") <> "" then
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage600"),"600","600","true","false")
					else
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
					end if

					FWishPrdList(i).FMakerID = rsget("makerid")
					FWishPrdList(i).fbrandname = db2html(rsget("brandname"))
					FWishPrdList(i).FRegdate = rsget("regdate")

					FWishPrdList(i).FSaleYn    = rsget("sailyn")
					FWishPrdList(i).FOrgPrice   = rsget("orgprice")
					FWishPrdList(i).FSpecialuseritem = rsget("specialuseritem")
					FWishPrdList(i).Fevalcnt = rsget("evalcnt")
					FWishPrdList(i).FFavCount = rsget("favcount")
					FWishPrdList(i).FUserIconNo = rsget("usericonNo")
					FWishPrdList(i).FisMyWishChk = rsget("isMy")
					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub


	'// 위시 리스트 불러오기(팔로우)
	public Sub GetWishFollowList()
		dim strSQL,i, j

		strSQL = "exec [db_sitemaster].[dbo].[sp_Ten_WishList_follow] '" + CStr(FPageSize)  + "','" + CStr(FCurrPage)+ "','" + FuserID + "'"  + vbcrlf
			'rw strSQL
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
'			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then
			FResultCount = rsget.RecordCount
            if (FResultCount<1) then FResultCount=0

			redim preserve FWishPrdList(FResultCount)
			i=0
'				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FWishPrdList(i) = new CCategoryPrdItem

					FWishPrdList(i).Fuserid = rsget("followuid")
					FWishPrdList(i).FItemID       = rsget("itemid")
					FWishPrdList(i).FItemName     = db2html(rsget("itemname"))
					FWishPrdList(i).FSellcash     = rsget("sellcash")
					FWishPrdList(i).FSellYn       = rsget("sellyn")
					FWishPrdList(i).FLimitYn      = rsget("limityn")
					FWishPrdList(i).FLimitNo      = rsget("limitno")
					FWishPrdList(i).FLimitSold    = rsget("limitsold")
					FWishPrdList(i).Fitemgubun    = rsget("itemgubun")
					FWishPrdList(i).FDeliverytype = rsget("deliverytype")
					FWishPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FWishPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")
					FWishPrdList(i).FitemCouponstartdate	= rsget("itemcouponstartdate")
					FWishPrdList(i).Fitemcouponexpiredate	= rsget("itemcouponexpiredate")
					FWishPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

'					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FWishPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
'					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FWishPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("icon1image")
'					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")
'					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("BasicImage")
					if rsget("BasicImage600") <> "" then
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage600"),"600","600","true","false")
					else
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
					end if

					FWishPrdList(i).FMakerID = rsget("makerid")
					FWishPrdList(i).fbrandname = db2html(rsget("brandname"))
					FWishPrdList(i).FRegdate = rsget("regdate")

					FWishPrdList(i).FSaleYn    = rsget("sailyn")
					FWishPrdList(i).FOrgPrice   = rsget("orgprice")
					FWishPrdList(i).FSpecialuseritem = rsget("specialuseritem")
					FWishPrdList(i).Fevalcnt = rsget("evalcnt")
					FWishPrdList(i).FFavCount = rsget("favcount")
					FWishPrdList(i).FUserIconNo = rsget("usericonNo")
					FWishPrdList(i).FisMyWishChk = rsget("isMy")
					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub


	'// 위시 리스트 불러오기(메이트)
	public Sub GetWishMateList()
		dim strSQL,i, j

		strSQL = "exec [db_sitemaster].[dbo].[sp_Ten_WishList_mate] '" + CStr(FPageSize)  + "','" + CStr(FCurrPage)+ "','" + FuserID + "'"  + vbcrlf
			'rw strSQL
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
'			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then
			FResultCount = rsget.RecordCount
            if (FResultCount<1) then FResultCount=0

			redim preserve FWishPrdList(FResultCount)
			i=0
'				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FWishPrdList(i) = new CCategoryPrdItem

					FWishPrdList(i).Fuserid = rsget("targetuid")
					FWishPrdList(i).FItemID       = rsget("itemid")
					FWishPrdList(i).FItemName     = db2html(rsget("itemname"))
					FWishPrdList(i).FSellcash     = rsget("sellcash")
					FWishPrdList(i).FSellYn       = rsget("sellyn")
					FWishPrdList(i).FLimitYn      = rsget("limityn")
					FWishPrdList(i).FLimitNo      = rsget("limitno")
					FWishPrdList(i).FLimitSold    = rsget("limitsold")
					FWishPrdList(i).Fitemgubun    = rsget("itemgubun")
					FWishPrdList(i).FDeliverytype = rsget("deliverytype")
					FWishPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FWishPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")
					FWishPrdList(i).FitemCouponstartdate	= rsget("itemcouponstartdate")
					FWishPrdList(i).Fitemcouponexpiredate	= rsget("itemcouponexpiredate")
					FWishPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

'					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FWishPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
'					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FWishPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("icon1image")
'					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")
'					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("BasicImage")
					if rsget("BasicImage600") <> "" then
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage600"),"600","600","true","false")
					else
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
					end if

					FWishPrdList(i).FMakerID = rsget("makerid")
					FWishPrdList(i).fbrandname = db2html(rsget("brandname"))
					FWishPrdList(i).FRegdate = rsget("regdate")

					FWishPrdList(i).FSaleYn    = rsget("sailyn")
					FWishPrdList(i).FOrgPrice   = rsget("orgprice")
					FWishPrdList(i).FSpecialuseritem = rsget("specialuseritem")
					FWishPrdList(i).Fevalcnt = rsget("evalcnt")
					FWishPrdList(i).FFavCount = rsget("favcount")
					FWishPrdList(i).FUserIconNo = rsget("usericonNo")
					FWishPrdList(i).FisMyWishChk = rsget("isMy")
					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub


	'// 위시 리스트 불러오기(트랜드)
	public Sub GetWishCategoryList()
		dim strSQL,i, j

		strSQL = "exec [db_sitemaster].[dbo].[sp_Ten_WishList_Category] '" + CStr(FPageSize)  + "','" + CStr(FCurrPage)+ "','" + FuserID + "','" + FCateCode + "'"  + vbcrlf
			'rw strSQL
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
'			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then
			FResultCount = rsget.RecordCount
            if (FResultCount<1) then FResultCount=0

			redim preserve FWishPrdList(FResultCount)
			i=0
'				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FWishPrdList(i) = new CCategoryPrdItem

					FWishPrdList(i).Fuserid = rsget("userid")
					FWishPrdList(i).FItemID       = rsget("itemid")
					FWishPrdList(i).FItemName     = db2html(rsget("itemname"))
					FWishPrdList(i).FSellcash     = rsget("sellcash")
					FWishPrdList(i).FSellYn       = rsget("sellyn")
					FWishPrdList(i).FLimitYn      = rsget("limityn")
					FWishPrdList(i).FLimitNo      = rsget("limitno")
					FWishPrdList(i).FLimitSold    = rsget("limitsold")
					FWishPrdList(i).Fitemgubun    = rsget("itemgubun")
					FWishPrdList(i).FDeliverytype = rsget("deliverytype")
					FWishPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FWishPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")
					FWishPrdList(i).FitemCouponstartdate	= rsget("itemcouponstartdate")
					FWishPrdList(i).Fitemcouponexpiredate	= rsget("itemcouponexpiredate")
					FWishPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

'					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FWishPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
'					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FWishPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("icon1image")
'					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")
'					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("BasicImage")
					if rsget("BasicImage600") <> "" then
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage600"),"600","600","true","false")
					else
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
					end if

					FWishPrdList(i).FMakerID = rsget("makerid")
					FWishPrdList(i).fbrandname = db2html(rsget("brandname"))
					FWishPrdList(i).FRegdate = rsget("regdate")

					FWishPrdList(i).FSaleYn    = rsget("sailyn")
					FWishPrdList(i).FOrgPrice   = rsget("orgprice")
					FWishPrdList(i).FSpecialuseritem = rsget("specialuseritem")
					FWishPrdList(i).Fevalcnt = rsget("evalcnt")
					FWishPrdList(i).FFavCount = rsget("favcount")
					FWishPrdList(i).FUserIconNo = rsget("usericonNo")
					FWishPrdList(i).FisMyWishChk = rsget("isMy")
					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub



	'// 팔로잉 유저 카운트
	public Sub GetWishFollowingCnt()

		Dim sqlStr

		sqlStr = " Select count(*) From db_contents.dbo.tbl_app_wish_followInfo Where userid='"&FuserID&"' "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.bof Or rsget.eof) Then
			FFollowingCnt = rsget(0)
		else
			FFollowingCnt = 0
		end if
		rsget.Close

	End Sub

	'// 팔로워 유저 카운트
	public Sub GetWishFollowerCnt()

		Dim sqlStr

		sqlStr = " Select count(*) From db_contents.dbo.tbl_app_wish_followInfo Where followuid='"&FuserID&"' "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.bof Or rsget.eof) Then
			FFollowerCnt = rsget(0)
		else
			FFollowerCnt = 0
		end if
		rsget.Close
	End Sub


	'// 팔로워 유저 체크
	public Sub GetWishFollowerChk()

		Dim sqlStr

		sqlStr = " Select count(*) From db_contents.dbo.tbl_app_wish_followInfo Where userid='"&FuserID&"' And followuid='"&FTargetUserID&"' "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.bof Or rsget.eof) Then
			FFollowerChk = rsget(0)
		else
			FFollowerCnt = 0
		end if
		rsget.Close
	End Sub




	'// 위시 상품 카운트
	Public Sub GetWishPrdCnt()

		Dim sqlStr

		sqlStr = "Select count(*) as cnt , usericonNo From db_user.dbo.tbl_user_n A " + VbCrlf
		sqlStr = sqlStr & " inner join db_my10x10.dbo.tbl_myfavorite B on A.userid = B.userid " + VbCrlf
		sqlStr = sqlStr & " Where A.userid='"&FuserID&"'  " + VbCrlf
		If FFvUChk Then
		Else
	        sqlStr = sqlStr & " 	And B.viewisusing='Y' " + vbcrlf
		End If
        sqlStr = sqlStr & " 			group by usericonNo "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			'위시 상품이 있으면
			FchkResult = rsget("cnt")
			FUserIconNo = rsget("usericonNo")
		else
			'위시 상품이 없으면
			FchkResult = 0
			FUserIconNo = 0
		end if
		rsget.Close

	End Sub

	'// 위시 상품 매칭 카운트
	Public Sub GetWishMatchingCnt()

		'# 리빌딩 데이터 복사 시간동안 결과 반환 안함 (2015.02.13; 허진원)
		IF (formatdatetime(now(),4)>"04:30:00") and (formatdatetime(now(),4)<"04:40:00") then
			FResultCount = 0
			Exit Sub
		end if

		Dim sqlStr
		sqlStr = " Select * From db_contents.dbo.tbl_app_wish_matchInfo " + VbCrlf
		sqlStr = sqlStr & " Where userid='"&FuserID&"' And targetUid='"&FTargetUserID&"' "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.bof Or rsget.eof) Then
			FchkResult = rsget("matchCnt")
		Else
			FchkResult = 0
		End If
		rsget.Close

	End Sub

	'// 위시 상품 매칭 카운트(메이트 상품이 있는지 체크, 리스트용)
	Public Sub GetWishMatchingCntList()
		Dim sqlStr

		sqlStr = " Select count(*) as cnt From db_contents.dbo.tbl_app_wish_matchInfo " + VbCrlf
		sqlStr = sqlStr & " Where userid='"&FuserID&"'  "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.bof Or rsget.eof) Then
			FchkResult = rsget("cnt")
		Else
			FchkResult = 0
		End If
		rsget.Close

	End Sub


	'// 팔로워 리스트 가져오기
	Public Sub GetWishFollowerList()

		Dim sqlStr,i, j

		sqlStr = " Select A.userid, B.usericonNo,  " + VbCrlf
		sqlStr = sqlStr & " (Select top 1 matchcnt From db_contents.dbo.tbl_app_wish_matchInfo  " + VbCrlf
		sqlStr = sqlStr & " 	Where userid = '"&FTargetUserID&"'	And targetUid=A.userid) as matchcnt,  " + VbCrlf
		sqlStr = sqlStr & " (Select top 1 userid From db_contents.dbo.tbl_app_wish_followInfo  " + VbCrlf
		sqlStr = sqlStr & " 	Where followUid = A.userid And userid='"&FTargetUserID&"') as folloingchk " + VbCrlf
		sqlStr = sqlStr & " From db_contents.dbo.tbl_app_wish_followInfo A " + VbCrlf
		sqlStr = sqlStr & " left join db_user.dbo.tbl_user_n B on A.userid = B.userid " + VbCrlf
		sqlStr = sqlStr & " Where followuid='"&FuserID&"'  "
		rsget.Open sqlStr,dbget,1

			if  not rsget.EOF  then
				FResultCount = rsget.RecordCount

				if (FResultCount<1) then FResultCount=0

				redim preserve FWishPrdList(FResultCount)
				i=0
	'				rsget.absolutepage = FCurrPage
					do until rsget.eof
						set FWishPrdList(i) = new CAutoWish
						FWishPrdList(i).Fuserid = rsget("userid")
						FWishPrdList(i).FFavCount = rsget("matchcnt")
						FWishPrdList(i).FUserIconNo = rsget("usericonNo")
						FWishPrdList(i).FisMyWishChk = rsget("folloingchk")

						If IsNull(FWishPrdList(i).FFavCount) Or FWishPrdList(i).FFavCount="" Then
							FWishPrdList(i).FFavCount = 0
						End If

						If IsNull(FWishPrdList(i).FUserIconNo) Or FWishPrdList(i).FUserIconNo="" Then
							FWishPrdList(i).FUserIconNo = 0
						End If
						rsget.movenext
						i=i+1
					loop
			End If
			rsget.close

	End Sub


	'// 팔로잉 리스트 가져오기
	Public Sub GetWishFollowingList()

		Dim sqlStr,i, j

		sqlStr = " Select A.followUid, B.usericonNo,  " + VbCrlf
		sqlStr = sqlStr & " (Select top 1 matchcnt From db_contents.dbo.tbl_app_wish_matchInfo   " + VbCrlf
		sqlStr = sqlStr & "	Where userid = '"&FTargetUserID&"' And targetUid=A.followUid) as matchcnt, " + VbCrlf
		sqlStr = sqlStr & " (Select top 1 userid From db_contents.dbo.tbl_app_wish_followInfo   " + VbCrlf
		sqlStr = sqlStr & "	Where userid = '"&FTargetUserID&"' And followUid=A.followUid) as folloingchk  " + VbCrlf
		sqlStr = sqlStr & " From db_contents.dbo.tbl_app_wish_followInfo A  " + VbCrlf
		sqlStr = sqlStr & " left join db_user.dbo.tbl_user_n B on A.followUid = B.userid  " + VbCrlf
		sqlStr = sqlStr & " Where A.userid='"&FuserID&"' " + VbCrlf

		rsget.Open sqlStr,dbget,1

			if  not rsget.EOF  then
				FResultCount = rsget.RecordCount

				if (FResultCount<1) then FResultCount=0

				redim preserve FWishPrdList(FResultCount)
				i=0
	'				rsget.absolutepage = FCurrPage
					do until rsget.eof
						set FWishPrdList(i) = new CAutoWish
						FWishPrdList(i).Fuserid = rsget("followUid")
						FWishPrdList(i).FFavCount = rsget("matchcnt")
						FWishPrdList(i).FUserIconNo = rsget("usericonNo")
						FWishPrdList(i).FisMyWishChk = rsget("folloingchk")

						If IsNull(FWishPrdList(i).FFavCount) Or FWishPrdList(i).FFavCount="" Then
							FWishPrdList(i).FFavCount = 0
						End If

						If IsNull(FWishPrdList(i).FUserIconNo) Or FWishPrdList(i).FUserIconNo="" Then
							FWishPrdList(i).FUserIconNo = 0
						End If
						rsget.movenext
						i=i+1
					loop
			End If
			rsget.close

	End Sub


	'// 특정 유저와 매칭되는 상품 리스트(메이트)
	Public Sub GetWishMateSelectList()

		dim strSQL,i, j

		strSQL = "exec [db_sitemaster].[dbo].[sp_Ten_WishSelectMateList] '" + CStr(FPageSize)  + "','" + CStr(FCurrPage)+ "','" + FuserID + "','" + FTargetUserID + "' "  + vbcrlf
			'rw strSQL
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
'			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then
			FResultCount = rsget.RecordCount
            if (FResultCount<1) then FResultCount=0

			redim preserve FWishPrdList(FResultCount)
			i=0
'				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FWishPrdList(i) = new CCategoryPrdItem

					FWishPrdList(i).Fuserid = rsget("userid")
					FWishPrdList(i).FItemID       = rsget("itemid")
					FWishPrdList(i).FItemName     = db2html(rsget("itemname"))
					FWishPrdList(i).FSellcash     = rsget("sellcash")
'					FWishPrdList(i).FSellYn       = rsget("sellyn")
					FWishPrdList(i).FLimitYn      = rsget("limityn")
					FWishPrdList(i).FLimitNo      = rsget("limitno")
					FWishPrdList(i).FLimitSold    = rsget("limitsold")
					FWishPrdList(i).Fitemgubun    = rsget("itemgubun")
					FWishPrdList(i).FDeliverytype = rsget("deliverytype")
					FWishPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FWishPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")
'					FWishPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

'					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FWishPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"300","300","true","false")
'					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FWishPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("icon1image")
'					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")
'					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("BasicImage")
					if rsget("BasicImage600") <> "" then
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage600"),"600","600","true","false")
					else
						FWishPrdList(i).FImageBasic = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FItemid) + "/" + rsget("BasicImage"),"400","400","true","false")
					end if

					FWishPrdList(i).FMakerID = rsget("makerid")
					FWishPrdList(i).fbrandname = db2html(rsget("brandname"))
'					FWishPrdList(i).FRegdate = rsget("regdate")
'					FWishPrdList(i).FSaleYn    = rsget("sailyn")
					FWishPrdList(i).FOrgPrice   = rsget("orgprice")
					FWishPrdList(i).Fevalcnt = rsget("evalcnt")
					FWishPrdList(i).FFavCount = rsget("favcount")

					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub


	'// 폴더 리스트
	public Sub GetWishFolderList

		Dim strSql, i

		strSql = " Select T.fidx, T.userid, T.foldername, T.viewisusing, T.itemcnt, T.itemid, Y.basicimage From (   " + vbcrlf
		If isViewingChk Then
			strSql = strSql & " Select 0 as fidx , '"&FuserID&"' as userid, '기본폴더' as foldername, 'N' as viewisusing,  " + vbcrlf
			strSql = strSql & " 	(   " + vbcrlf
			strSql = strSql & "		Select count(*) From db_my10x10.dbo.tbl_myfavorite   " + vbcrlf
			strSql = strSql & "		Where userid='"&FuserID&"' And fidx=0  " + vbcrlf
			If FFvUChk Then
			Else
				strSql = strSql & "		And viewisusing='Y'  " + vbcrlf
			End If
			strSql = strSql & "	) as itemcnt,  " + vbcrlf
			strSql = strSql & "	(  " + vbcrlf
			strSql = strSql & "		Select max(itemid) as itemid From db_my10x10.dbo.tbl_myfavorite   " + vbcrlf
			strSql = strSql & "		Where userid='"&FuserID&"' And fidx=0   " + vbcrlf
			If FFvUChk Then
			Else
				strSql = strSql & "		And viewisusing='Y'  " + vbcrlf
			End If
			strSql = strSql & "	) as itemid  " + vbcrlf
			strSql = strSql & "	, -1 as sortno, getdate() as lastupdate  " + vbcrlf
			strSql = strSql & "	union all  " + vbcrlf
		End If
		strSql = strSql & "	Select A.fidx, A.userid, A.foldername, A.viewisusing, count(B.itemid) as itemcnt, max(B.itemid) as itemid, " + vbcrlf
		strSql = strSql & " A.sortno , MAX(B.regdate) as lastupdate  " + vbcrlf
		strSql = strSql & "	From [db_my10x10].[dbo].[tbl_myfavorite_folder] A  " + vbcrlf
		strSql = strSql & "	left join db_my10x10.dbo.tbl_myfavorite B on A.fidx = B.fidx And a.userid = b.userid  " + vbcrlf
		strSql = strSql & "	Where A.userid='"&FuserID&"'" + vbcrlf
		If FFvUChk Then
		Else
			strSql = strSql & "		And B.viewisusing='Y'  " + vbcrlf
		End If
		strSql = strSql & "	group by A.fidx, A.userid, A.foldername, A.viewisusing, A.sortno, A.lastupdate  " + vbcrlf
		strSql = strSql & "	)T  " + vbcrlf
		strSql = strSql & "	left join db_item.dbo.tbl_item Y on T.itemid = Y.itemid "
		strSql = strSql & "	Order by T.sortno asc , T.lastupdate Desc ,T.fidx desc  "
		rsget.Open strSql,dbget,1

			if  not rsget.EOF  then
				FResultCount = rsget.RecordCount

				if (FResultCount<1) then FResultCount=0

				redim preserve FWishPrdList(FResultCount)
				i=0
					do until rsget.eof
						set FWishPrdList(i) = new CAutoWish
						FWishPrdList(i).FFolderIdx = rsget("fidx")
						FWishPrdList(i).Fuserid = rsget("userid")
						FWishPrdList(i).FFolderName = rsget("foldername")
						FWishPrdList(i).FFolderViewusing = rsget("viewisusing")
						FWishPrdList(i).FFolderitemcnt = rsget("itemcnt")
						FWishPrdList(i).FRectItemId = rsget("itemid")
						FWishPrdList(i).FFBasicImage = rsget("basicimage")
						FWishPrdList(i).FFimageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FRectItemId) + "/" + rsget("basicimage"),"300","300","true","false")
						rsget.movenext
						i=i+1
					loop
			End If
			rsget.close
	End Sub

	'// 위시 리스트
	public Sub GetWishProfilePrdList

		Dim sqlStr, i

        sqlStr = " Select count(A.itemid) as cnt From db_my10x10.dbo.tbl_myfavorite A " + vbcrlf
        sqlStr = sqlStr & " inner join db_item.dbo.tbl_item B on A.itemid = B.itemid " + vbcrlf
        sqlStr = sqlStr & " Where A.userid='"&FuserID&"'  " + vbcrlf
		If FFvUChk Then
		Else
	        sqlStr = sqlStr & " 	And A.viewisusing='Y' " + vbcrlf
		End If
		If Trim(FFolderIdx) = "" Then
		Else
	        sqlStr = sqlStr & " 	And A.fidx='"&FFolderIdx&"' " + vbcrlf
		End If
        sqlStr = sqlStr & " 	And A.userid is not null "
        rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.close

        sqlStr = " Select top " & CStr(FPageSize*FCurrPage) & " A.userid, A.itemid, A.fidx, A.viewisUsing, B.basicimage From db_my10x10.dbo.tbl_myfavorite A " + vbcrlf
        sqlStr = sqlStr & " inner join db_item.dbo.tbl_item B on A.itemid = B.itemid " + vbcrlf
        sqlStr = sqlStr & " Where A.userid='"&FuserID&"'  " + vbcrlf
		If FFvUChk Then
		Else
	        sqlStr = sqlStr & " 	And A.viewisusing='Y' " + vbcrlf
		End If
		If Trim(FFolderIdx) = "" Then
		Else
	        sqlStr = sqlStr & " 	And A.fidx='"&FFolderIdx&"' " + vbcrlf
		End If
        sqlStr = sqlStr & " 	And A.userid is not null " + vbcrlf
		sqlStr = sqlStr & " order by A.regdate desc "

        rsget.pagesize = FPageSize
        rsget.Open sqlStr, dbget, 1

        FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0

        redim preserve FWishPrdList(FResultCount)
		i=0
		if Not rsget.Eof then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FWishPrdList(i) = new CAutoWish
				FWishPrdList(i).FFolderIdx = rsget("fidx")
				FWishPrdList(i).Fuserid = rsget("userid")
				FWishPrdList(i).FFolderViewusing = rsget("viewisusing")
				FWishPrdList(i).FRectItemId = rsget("itemid")
				FWishPrdList(i).FFBasicImage = rsget("basicimage")
				FWishPrdList(i).FFimageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FWishPrdList(i).FRectItemId) + "/" + rsget("basicimage"),"300","300","true","false")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.close

	End Sub
End Class



Function getDisplayCateNameDB(disp)
	Dim SQL

	'유효성 검사
	if disp="" then
		getDisplayCateNameDB = "카테고리"
		Exit Function
	end if

	SQL = "select [db_item].[dbo].getDisplayCateName('" & disp & "')"
	rsget.Open SQL, dbget
		if NOT(rsget.EOF or rsget.BOF) then
			getDisplayCateNameDB = db2html(rsget(0))
		else
			getDisplayCateNameDB = "카테고리"
		end if
	rsget.Close
End Function

%>

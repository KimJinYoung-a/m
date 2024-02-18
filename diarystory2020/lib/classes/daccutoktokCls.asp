<%
'#=========================================#
'# 다꾸톡톡 클래스                    #
'#=========================================#
class CDaccuTokTokItem
	public FMasterIdx '// 이미지 링크 MasterIdx
	public FMasterTitle '// 이미지 링크 마스터 타이틀
	public FMasterImage '// 이미지 링크에 사용될 배경 이미지
	public FMasterIsUsing '// 마스터 사용여부
	public FMasterRegDate '// 마스터 등록일자
	public FMasterLastUpDate '// 마스터 최종수정일자
	public FMasterRegUserImage '// 마스터 등록자 Front노출 이미지
	public FMasterRegUserFrontName '// 마스터 등록자 Front노출 이름

	public FUserMasterIdx
	public FUserMasterTitle
	public FUserMasterCate1
	public FUserMasterCate2
	public FUserMasterImage
	public FUserMasterUserId
	public FUserMasterIsUsing
	public FUserMasterRegDate
	public FUserMasterLastUpDate
	public FUserMasterViewCount
	public FUserDetailXValue
	public FUserDetailYValue

	public FUserDetailItemID
	public FUserDetailItemName
	public FUserDetailItemOption
	public FUserDetailItemOptionName
	public FUserDetailBasicImage
	public FUserDetailBasicImage600
	public FUserDetailBasicImage1000
	public FUserDetailIcon1Image
	public FUserDetailIcon2Image
	public FUserDetailMainImage
	public FUserDetailSmallImage
	public FUserDetailListImage
	public FUserDetailListImage120
	public FUserDetailBrandName
	public FUserDetailUserID
	public FUserDetailIconType

	public FDetailIdx '// 이미지 링크 상세 idx
	public FDetailXValue '// 이미지 링크 상세 X축값
	public FDetailYValue '// 이미지 링크 상세 Y축값
	public FDetailItemId '// 이미지 링크 상품코드
	public FDetailIconType '// 이미지 링크 상세 아이콘 타입
	public FDetailIsUsing '// 이미지 링크 상세 사용여부
	public FDetailRegDate '// 이미지 링크 상세 등록일자
	public FDetailLastUpDate '// 이미지 링크 상세 수정일자
	public FDetailItemName '// 이미지 링크 상세 상품명
	public FDetailMainImage
	public FDetailSmallImage
	public FDetailListImage
	public FDetailListImage120
	public FDetailBasicImage
	public FDetailIcon1Image
	public FDetailIcon2Image
	public FDetailBasicIMage600
	public FDetailBasicImage1000
	public FDetailItemOptionName
	public FDetailItemOption
	public FDetailMasterIdx
	public FDetailBrandName

	Public FOrderRegDate
	Public FOrderSerial
	Public FOrderItemId
	Public FOrderItemName
	Public FOrderItemOptionName
	Public FOrderBasicImage
	Public FOrderBasicImage600
	Public FOrderBasicImage1000
	Public FOrderIcon1Image
	Public FOrderIcon2Image
	Public FOrderMainImage
	Public FOrderSmallImage
	Public FOrderListImage
	Public FOrderListImage120
	Public FOrderBrandName
	Public FOrderItemOption

    public Function IsNewItem()
        IsNewItem = datediff("d",FRegdate,Now()) < 14
    end function

	'// 재입고 상품 여부
	public Function isReipgoItem() 
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function
		
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
'# 다꾸톡톡 클래스                           #
'#=========================================#

class CDaccuTokTok
	public FItemList()
	public FOneItem
	public FResultCount

	public FTotalPage
	public FPageSize
	public FScrollCount
	Public FTotalCount
	public FCurrPage
	Public FPageCount
	Public FRectMasterIdx
	Public FRectUserID

	'// 관리자가 입력한 다쿠톡톡 마스터 불러옴
	public Sub GetDaccuTokTokManagerList()
		dim sqlStr, i

		sqlStr = " SELECT Idx, Title, Image, IsUsing, RegDate, LastUpDate, RegUserImage, RegUserFrontName "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLink_Master With(NOLOCK) "
		sqlStr = sqlStr & " WHERE IsUsing = 'Y' "
		sqlStr = sqlStr & " AND ISNULL(RegUserImage,'') <> '' "
		sqlStr = sqlStr & " AND ISNULL(RegUserFrontName,'') <> '' "
		sqlStr = sqlStr & " ORDER BY Idx DESC "

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIDACCUTOK",sqlStr,30)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		rsMem.pagesize = FPageSize
		
		FTotalCount = rsMem.recordcount
		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1
		if  not rsMem.EOF  then
			i = 0
			rsMem.absolutePage=FCurrPage
			do until rsMem.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FMasterIdx					= rsMem("Idx")
					FItemList(i).FMasterTitle				= rsMem("Title")
					FItemList(i).FMasterImage				= rsMem("Image")
					FItemList(i).FMasterIsUsing				= rsMem("IsUsing")
					FItemList(i).FMasterRegDate				= rsMem("RegDate")
					FItemList(i).FMasterLastUpDate			= rsMem("LastUpDate")
					FItemList(i).FMasterRegUserImage		= rsMem("RegUserImage")
					FItemList(i).FMasterRegUserFrontName	= rsMem("RegUserFrontName")			
				i=i+1
				rsMem.moveNext
			loop
		end if
		rsMem.Close
	End sub

	'// 관리자가 입력한 MasterIdx값을 기반으로 Detail 상품 리스트 불러옴
	public Sub GetDaccuTokTokDetailManagerList()
		dim sqlStr, i

		sqlStr = " SELECT ID.Idx, ID.XValue, ID.YValue, ID.ItemID, ID.IconType, ID.IsUsing, ID.RegDate, ID.LastUpDate "
		sqlStr = sqlStr & " , i.itemname, i.mainimage, i.smallimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.basicimage600, i.basicimage1000 "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLink_Detail ID With(NOLOCK) "
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item I WITH(NOLOCK) ON ID.itemid = I.itemid "
		sqlStr = sqlStr & " WHERE ID.IsUsing = 'Y' "
		sqlStr = sqlStr & " AND ID.MasterIdx = '"&FRectMasterIdx&"' "
		sqlStr = sqlStr & " ORDER BY ID.Idx ASC "

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DIDACCUDETAILTOKTOK",sqlStr,30)
        if (rsMem is Nothing) then Exit Sub ''추가
            
		'rsMem.pagesize = FPageSize
		FTotalCount = rsMem.recordcount
		FResultCount = FTotalCount
		redim preserve FItemList(FResultCount)

		if  not rsMem.EOF  then
			'rsMem.absolutePage=FCurrPage
			do until rsMem.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FDetailIdx			= rsMem("Idx")
					FItemList(i).FDetailXValue		= rsMem("XValue")
					FItemList(i).FDetailYValue		= rsMem("YValue")
					FItemList(i).FDetailItemId		= rsMem("ItemID")
					FItemList(i).FDetailIconType	= rsMem("IconType")
					FItemList(i).FDetailIsUsing		= rsMem("IsUsing")
					FItemList(i).FDetailRegDate		= rsMem("RegDate")
					FItemList(i).FDetailLastUpDate	= rsMem("LastUpDate")
					FItemList(i).FDetailItemName	= rsMem("itemname")
					FItemList(i).FDetailListImage		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listImage")
					FItemList(i).FDetailListImage120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listImage120")
					FItemList(i).FDetailIcon1Image	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("icon1Image")
					FItemList(i).FDetailIcon2Image		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("icon2image")
					FItemList(i).FDetailBasicImage		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsMem("itemid"))&"/"& rsMem("basicimage")
				i=i+1
				rsMem.moveNext
			loop
		end if
		rsMem.Close
	End sub

	'// 사용자가 구매한 구매 리스트
	public Sub GetDaccuTokTokMyOrderList()
		dim sqlStr, i
		dim rsMem

		sqlStr = " SELECT COUNT(*) AS Cnt FROM "
		sqlStr = sqlStr & " db_order.dbo.tbl_order_master m WITH(NOLOCK) "
		sqlStr = sqlStr & " INNER JOIN db_order.dbo.tbl_order_detail d With(NOLOCK) ON m.orderserial = d.orderserial "
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemid = i.itemid "
		sqlStr = sqlStr & " INNER JOIN db_user.dbo.tbl_user_c c WITh(NOLOCK) ON d.makerid = c.userid "
		sqlStr = sqlStr & " WHERE m.sitename='10x10' AND m.ipkumdiv >= 7 "
		sqlStr = sqlStr & " AND m.cancelyn = 'N' AND m.jumundiv <> 9 "
		sqlStr = sqlStr & " AND m.jumundiv <> 6 AND d.cancelyn <> 'Y' "
		sqlStr = sqlStr & " AND d.itemid <> 0 AND d.itemid <> 100 "
		sqlStr = sqlStr & " AND d.currstate >= CASE WHEN d.oitemdiv='75' THEN 3 ELSE 7 END "
		sqlStr = sqlStr & " AND ISNULL(m.userDisplayYn, 'Y') = 'Y' "
		sqlStr = sqlStr & " AND m.userid = '"&FRectUserID&"' "
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly
			FTotalCount = rsget("Cnt")
		rsget.close

		sqlStr = " SELECT TOP " + CStr(FPageSize * FCurrPage) + " "
		sqlStr = sqlStr & " m.regdate, m.orderserial, d.itemid, i.itemname, d.itemoptionname "
		sqlStr = sqlStr & " , i.basicimage, i.basicimage600, i.basicimage1000, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.mainimage, i.smallimage, i.listimage, i.listimage120, c.socname, d.itemoption "
		sqlStr = sqlStr & " FROM db_order.dbo.tbl_order_master m With(NOLOCK) "
		sqlStr = sqlStr & " INNER JOIN db_order.dbo.tbl_order_detail d With(NOLOCK) ON m.orderserial = d.orderserial "
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemid = i.itemid "
		sqlStr = sqlStr & " INNER JOIN db_user.dbo.tbl_user_c c WITh(NOLOCK) ON d.makerid = c.userid "
		sqlStr = sqlStr & " WHERE m.sitename='10x10' AND m.ipkumdiv >= 7 "
		sqlStr = sqlStr & " AND m.cancelyn = 'N' AND m.jumundiv <> 9 "
		sqlStr = sqlStr & " AND m.jumundiv <> 6 AND d.cancelyn <> 'Y' "
		sqlStr = sqlStr & " AND d.itemid <> 0 AND d.itemid <> 100 "
		sqlStr = sqlStr & " AND d.currstate >= CASE WHEN d.oitemdiv='75' THEN 3 ELSE 7 END "
		sqlStr = sqlStr & " AND ISNULL(m.userDisplayYn, 'Y') = 'Y' "
		sqlStr = sqlStr & " AND m.userid = '"&FRectUserID&"' "
		sqlStr = sqlStr & " ORDER BY m.orderserial DESC "

        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FOrderRegDate				= rsget("regdate")
					FItemList(i).FOrderSerial				= rsget("orderserial")
					FItemList(i).FOrderItemId				= rsget("itemid")
					FItemList(i).FOrderItemName				= rsget("itemname")
					FItemList(i).FOrderItemOptionName		= rsget("itemoptionname")
					FItemList(i).FOrderBrandName			= rsget("socname")
					FItemList(i).FOrderItemOption			= rsget("itemoption")
					FItemList(i).FOrderListImage			= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
					FItemList(i).FOrderListImage120			= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
					FItemList(i).FOrderIcon1Image			= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
					FItemList(i).FOrderIcon2Image			= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
					FItemList(i).FOrderBasicImage			= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub

	'// 사용자가 입력한 이미지 링크 상품 리스트
	public Sub GetDaccuTokTokDetailItemList()
		dim sqlStr, i

		sqlStr = " SELECT "
		sqlStr = sqlStr & " d.idx, d.MasterIdx, d.itemid, i.itemname, d.itemoption, o.optionname "
		sqlStr = sqlStr & " , i.basicimage, i.basicimage600, i.basicimage1000, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.mainimage, i.smallimage, i.listimage, i.listimage120, c.socname "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLinkUser_Detail d With(NOLOCK) "
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemid = i.itemid "
		sqlStr = sqlStr & " INNER JOIN db_user.dbo.tbl_user_c c WITh(NOLOCK) ON i.makerid = c.userid "
		sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_option o WITH(NOLOCK) ON d.itemoption = o.itemoption AND d.itemid = o.itemid "
		sqlStr = sqlStr & " WHERE d.IsUsing = 'Y' AND d.MasterIdx='"&FRectMasterIdx&"' "
		sqlStr = sqlStr & " AND d.userid = '"&FRectUserID&"' "
		sqlStr = sqlStr & " ORDER BY d.IDX DESC "
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FDetailIdx					= rsget("idx")
					FItemList(i).FDetailMasterIdx			= rsget("MasterIdx")
					FItemList(i).FDetailItemId				= rsget("ItemId")
					FItemList(i).FDetailItemName			= rsget("itemname")
					FItemList(i).FDetailItemOption			= rsget("itemoption")
					FItemList(i).FDetailItemOptionName		= rsget("optionname")
					FItemList(i).FDetailBrandName			= rsget("socname")
					FItemList(i).FDetailListImage			= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
					FItemList(i).FDetailListImage120			= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
					FItemList(i).FDetailIcon1Image			= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
					FItemList(i).FDetailIcon2Image			= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
					FItemList(i).FDetailBasicImage			= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub

	'// 사용자가 입력한 다쿠톡톡 Master 리스트
	public Sub GetDaccuTokTokUserMasterList()
		dim sqlStr, i

		sqlStr = " SELECT COUNT(*) as cnt "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLinkUser_Master With(NOLOCK) "
		sqlStr = sqlStr & " WHERE IsUsing = 'Y' "

        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly
            FTotalCount = rsget("cnt")
        rsget.Close


		sqlStr = " SELECT top "&CStr(FPageSize * FCurrPage)&" Idx, Title, Cate1, Cate2, Image, UserId, IsUsing, RegDate, LastUpDate, ViewCount "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLinkUser_Master With(NOLOCK) "
		sqlStr = sqlStr & " WHERE IsUsing = 'Y' "
		sqlStr = sqlStr & " ORDER BY Idx DESC "

        rsget.pagesize = FPageSize
        rsget.Open sqlStr, dbget, 1

        FTotalPage =  CLng(FTotalCount\FPageSize)
		if ((FTotalCount\FPageSize)<>(FTotalCount/FPageSize)) then
			FTotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if FResultCount<1 then FResultCount=0

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			i = 0
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FUserMasterIdx				= rsget("idx")
					FItemList(i).FUserMasterTitle			= rsget("Title")
					FItemList(i).FUserMasterCate1			= rsget("Cate1")
					FItemList(i).FUserMasterCate2			= rsget("Cate2")
					FItemList(i).FUserMasterImage			= rsget("Image")
					FItemList(i).FUserMasterUserId			= rsget("userid")
					FItemList(i).FUserMasterIsUsing			= rsget("IsUsing")
					FItemList(i).FUserMasterRegDate			= rsget("RegDate")
					FItemList(i).FUserMasterLastUpDate		= rsget("LastUpDate")
					FItemList(i).FUserMasterViewCount		= rsget("ViewCount")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub

	'// 사용자가 입력한 다꾸 ViewCount 업데이트
	public Sub UpdDaccuTokTokUserMaster()
		dim sqlStr

		sqlStr = " Update db_sitemaster.dbo.tbl_ImageLinkUser_Master SET ViewCount = ViewCount + 1 "
		sqlStr = sqlStr & " Where idx='"&FRectMasterIdx&"' "
		dbget.execute sqlstr

	End Sub

	'// 사용자가 입력한 다꾸톡톡 Master View
	public Sub GetDaccuTokTokUserMasterOne()
		dim sqlStr, i

		sqlStr = " SELECT TOP 1 Idx, Title, Cate1, Cate2, Image, UserId, IsUsing, RegDate, LastUpDate, ViewCount"
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLinkUser_Master With(NOLOCK) "
		sqlStr = sqlStr & " WHERE IsUsing = 'Y' "
		sqlStr = sqlStr & " AND idx='"&FRectMasterIdx&"' "
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly

		if  not rsget.EOF  then
			set FOneItem = new CDaccuTokTokItem
            FOneItem.FUserMasterIdx     		= rsget("Idx")
            FOneItem.FUserMasterTitle         	= rsget("Title")
            FOneItem.FUserMasterCate1          	= rsget("Cate1")
			FOneItem.FUserMasterCate2          	= rsget("Cate2")
			FOneItem.FUserMasterImage          	= rsget("Image")
			FOneItem.FUserMasterUserId          	= rsget("UserId")
			FOneItem.FUserMasterIsUsing          	= rsget("IsUsing")
			FOneItem.FUserMasterRegDate          	= rsget("RegDate")
			FOneItem.FUserMasterLastUpDate          	= rsget("LastUpDate")
			FOneItem.FUserMasterViewCount          	= rsget("ViewCount")
		end if
		rsget.Close
	End sub

	'// 사용자가 입력한 다꾸톡톡 상품 리스트(MasterIdx 기반)
	public Sub GetDaccuTokTokDetailUserList()
		dim sqlStr, i

		sqlStr = " SELECT d.itemid, i.itemname, d.itemoption, o.optionname "
		sqlStr = sqlStr & " , i.mainimage, i.smallimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.basicimage600, i.basicimage1000, c.socname, d.userid, d.icontype, d.xvalue, d.yvalue "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_ImageLinkUser_Detail d With(NOLOCK) "
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item I WITH(NOLOCK) ON d.itemid = I.itemid "
		sqlStr = sqlStr & " INNER JOIN db_user.dbo.tbl_user_c c WITH(NOLOCK) ON i.makerid = c.userid "
		sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item_option o WITH(NOLOCK) ON d.itemoption = o.itemoption AND d.itemid = o.itemid "
		sqlStr = sqlStr & " WHERE d.IsUsing = 'Y' "
		sqlStr = sqlStr & " AND d.MasterIdx = '"&FRectMasterIdx&"' "
		sqlStr = sqlStr & " ORDER BY d.Idx ASC "
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CDaccuTokTokItem
					FItemList(i).FUserDetailXValue				= rsget("xvalue")
					FItemList(i).FUserDetailYValue				= rsget("yvalue")
					FItemList(i).FUserDetailItemID				= rsget("itemid")
					FItemList(i).FUserDetailItemName			= rsget("itemname")
					FItemList(i).FUserDetailItemOption			= rsget("itemoption")
					FItemList(i).FUserDetailItemOptionName		= rsget("optionname")
					FItemList(i).FUserDetailListImage			= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
					FItemList(i).FUserDetailListImage120		= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
					FItemList(i).FUserDetailIcon1Image			= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
					FItemList(i).FUserDetailIcon2Image			= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
					FItemList(i).FUserDetailBasicImage			= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
					FItemList(i).FUserDetailBrandName			= rsget("socname")
					FItemList(i).FUserDetailUserID				= rsget("userid")
					FItemList(i).FUserDetailIconType			= rsget("icontype")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub


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
<%
'#=========================================#
'# 18주년 나의 취향 클래스 아이템          #
'#=========================================#
class CTasteItem
    public FIdx '// 각각 테이블의 Idx값
    public FChasu '// chasu값
    public FMainKeyWord '// 해당 일자 주년 주제가 되는 키워드
    public FSubText '// 해당 키워드에 대한 간단한 서브 코멘트
    public FSearchKeyWord '// 검색시 사용하는 검색어(메인 키워드와 동일할 가능성이 매우 큼 일단 분리)
    public FGiftType '// 리워드 타입(원래 다양한 리워드를 하는줄 알았지만 현재로선 쿠폰만 발급)
    public FRegDate '// 각각 테이블의 등록일자 데이터

    public FMasterIdx '// Detail에서 사용하는 Masteridx값
    public FDetailIdx '// 사용자 취향 입력 테이블 idx값
    public FDetailChasu '// 사용자 취향 입력 테이블 chasu
    public FDetailUserId '// 사용자 취향 입력 테이블 userid
    public FDetailItemId '// 사용자 취향 입력 테이블 ItemId
    public FDetailIsUsing '// 사용자 취향 입력 테이블 IsUsing
    public FDetailRegDate '// 사용자 취향 입력 테이블 RegDate
    public FDetailLastUpDate '// 사용자 취향 입력 테이블 LastUpDate

	public FBasicImage
	public FBasicImage600
	public FBasicImage1000
	public FIcon1Image
	public FIcon2Image
	public FMainImage
	public FSmallImage
	public FListImage
	public FListImage120

    public FFolderIdx '// 위시 폴더 idx값

    public FWishCheck

    public Function IsNewItem()
        IsNewItem = datediff("d",FRegdate,Now()) < 14
    end function

	'// 재입고 상품 여부
	public Function isReipgoItem() 
		isReipgoItem = (datediff("d",FReIpgoDate,now())<= 14)
	end Function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

'#=========================================#
'# 18주년 나의 취향 클래스                 #
'#=========================================#

class CTaste
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
    Public FRectChasu
    Public FRectFolderName
    Public FRectFolderIdx

	'// 해당일자 주년 키워드 데이터 불러옴
	public Sub GetTasteMasterOne()
		dim sqlStr, i

		sqlStr = " SELECT TOP 1 idx, chasu, mainKeyWord, subText, searchKeyWord, giftType, regdate"
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Master With(NOLOCK) "
		sqlStr = sqlStr & " WHERE chasu = '"&FRectChasu&"' "
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly

        set FOneItem = new CTasteItem
		if  not rsget.EOF  then
            FOneItem.FIdx        		= rsget("Idx")
            FOneItem.FChasu         	= rsget("chasu")
            FOneItem.FMainKeyWord       = rsget("mainKeyWord")
			FOneItem.FSubText          	= rsget("subText")
			FOneItem.FSearchKeyWord     = rsget("searchKeyWord")
			FOneItem.FGiftType          = rsget("giftType")
			FOneItem.FRegDate          	= rsget("regdate")
        Else
            FOneItem.FIdx        		= ""
            FOneItem.FChasu         	= ""
            FOneItem.FMainKeyWord       = ""
			FOneItem.FSubText          	= ""
			FOneItem.FSearchKeyWord     = ""
			FOneItem.FGiftType          = ""
			FOneItem.FRegDate          	= ""
		end if
		rsget.Close
	End sub

	'// 해당일자 주년 사용자 등록취향 데이터 불러옴
	public Sub GetTasteDetailUserOne()
		dim sqlStr, i

		sqlStr = " SELECT TOP 1 d.idx, d.masterIdx, d.chasu, d.userID, d.itemID, d.isUsing, d.regdate, d.lastupdate"
		sqlStr = sqlStr & " , i.itemname, i.mainimage, i.smallimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.basicimage600, i.basicimage1000 "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail d With(NOLOCK) "
        sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemID = i.itemid "
		sqlStr = sqlStr & " WHERE d.chasu = '"&FRectChasu&"' AND d.masterIdx = '"&FRectMasterIdx&"' AND d.userID = '"&FRectUserID&"' "
        sqlStr = sqlStr & " ORDER BY idx DESC "
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly

        set FOneItem = new CTasteItem
		if  not rsget.EOF  then
            FOneItem.FDetailIdx        		= rsget("Idx")
            FOneItem.FMasterIdx             = rsget("masterIdx")
            FOneItem.FDetailChasu         	= rsget("chasu")
            FOneItem.FDetailUserId          = rsget("userID")
			FOneItem.FDetailItemId          = rsget("itemID")
			FOneItem.FDetailIsUsing         = rsget("isUsing")
			FOneItem.FDetailRegDate         = rsget("regdate")
			FOneItem.FDetailLastUpDate      = rsget("lastupdate")
            FOneItem.FListImage		        = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
            FOneItem.FListImage120	        = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
            FOneItem.FIcon1Image	        = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
            FOneItem.FIcon2Image		    = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
            FOneItem.FBasicImage		    = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")            
        Else
            FOneItem.FDetailIdx        		= ""
            FOneItem.FMasterIdx             = ""
            FOneItem.FDetailChasu         	= ""
            FOneItem.FDetailUserId          = ""
			FOneItem.FDetailItemId          = ""
			FOneItem.FDetailIsUsing         = ""
			FOneItem.FDetailRegDate         = ""
			FOneItem.FDetailLastUpDate      = ""
            FOneItem.FListImage		        = ""
            FOneItem.FListImage120	        = ""
            FOneItem.FIcon1Image	        = ""
            FOneItem.FIcon2Image		    = ""
            FOneItem.FBasicImage		    = ""
		end if
		rsget.Close
	End sub

	'// 사용자가 입력한 취향 리스트
	public Sub GetTasteUserHistoryList()
		dim sqlStr, i

		sqlStr = " SELECT m.Idx, m.chasu, m.mainKeyWord, m.subText, m.giftType, m.regDate "
        sqlStr = sqlStr & " , ISNULL(d.idx,'') AS detailIdx, ISNULL(d.userID,'') AS detailUserId, ISNULL(d.itemid,'') AS detailItemId, ISNULL(d.isUsing,'') AS detailIsUsing "
        sqlStr = sqlStr & " , ISNULL(d.regDate,'') AS detailRegDate, ISNULL(d.lastUpDate,'') AS detailLastUpDate "
		sqlStr = sqlStr & " , ISNULL(i.mainimage,'') AS mainimage, ISNULL(i.smallimage,'') AS smallimage, ISNULL(i.listimage,'') AS listimage "
        sqlStr = sqlStr & " , ISNULL(i.listimage120,'') AS listimage120, ISNULL(i.basicimage,'') AS basicimage, ISNULL(i.icon1image,'') AS icon1image "
        sqlStr = sqlStr & " , ISNULL(i.icon2image,'') AS icon2image, ISNULL(i.basicimage600,'') AS basicimage600, ISNULL(i.basicimage1000,'') AS basicimage1000 "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Master m WITH(NOLOCK) "
        sqlStr = sqlStr & " LEFT JOIN db_sitemaster.dbo.tbl_18thTasteEvent_Detail d WITH(NOLOCK) ON m.idx = d.masterIdx AND d.userid='"&FRectUserID&"' AND d.isUsing='Y' "
		sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item I WITH(NOLOCK) ON d.itemid = I.itemid "
		sqlStr = sqlStr & " ORDER BY m.Idx ASC "
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CTasteItem
					FItemList(i).FIdx           	= rsget("idx")
					FItemList(i).Fchasu				= rsget("chasu")
					FItemList(i).FMainKeyWord		= rsget("mainKeyWord")
					FItemList(i).FSubText			= rsget("subText")
					FItemList(i).FGiftType			= rsget("giftType")
					FItemList(i).FRegDate		    = rsget("regDate")
					FItemList(i).FDetailIdx			= rsget("detailidx")
					FItemList(i).FDetailUserId		= rsget("detailuserid")
                    FItemList(i).FDetailItemId      = rsget("detailitemid")
					FItemList(i).FDetailIsUsing		= rsget("detailisusing")
					FItemList(i).FDetailRegDate		= rsget("detailregdate")
					FItemList(i).FDetailLastUpDate	= rsget("detaillastupdate")
                    FItemList(i).FListImage		    = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("detailItemId")) + "/" + rsget("listImage")
                    FItemList(i).FListImage120	    = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("detailItemId")) + "/" + rsget("listImage120")
                    FItemList(i).FIcon1Image	    = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("detailItemId")) + "/" + rsget("icon1Image")
                    FItemList(i).FIcon2Image		= "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("detailItemId"))&"/"& rsget("icon2image")
                    FItemList(i).FBasicImage		= "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("detailItemId"))&"/"& rsget("basicimage")     
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub

	'// 히스토리 메뉴에 사용되는 사용자가 입력한 취향 리스트 히스토리
	Public Sub getTasteUserHistoryNavList()
		Dim sqlStr, i

		'sqlStr = " SELECT m.idx, m.chasu, d.idx AS detailIdx "
		'sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Master m WITH(NOLOCK) "
		'sqlStr = sqlStr & " LEFT JOIN db_sitemaster.dbo.tbl_18thTasteEvent_Detail d WITH(NOLOCK) ON m.idx = d.masterIdx AND d.userid='"&FRectUserID&"' AND d.isUsing='Y' "
		'sqlStr = sqlStr	& " ORDER BY m.idx ASC "
		sqlStr = " SELECT m.idx, m.chasu "
		IF Trim(FRectUserID) <> "" Then
			sqlStr = sqlStr & " ,(SELECT TOP 1 idx FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail WITH(NOLOCK) "
			sqlStr = sqlStr & " WHERE masteridx = m.idx AND userid='"&FRectUserID&"' AND isUsing='Y' ORDER BY idx DESC ) AS detailIdx "
		Else
			sqlStr = sqlStr & " ,NULL AS detailIdx "
		End If
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Master m WITH(NOLOCK) ORDER BY m.idx ASC "
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CTasteItem
					FItemList(i).FIdx           	= rsget("idx")
					FItemList(i).Fchasu				= rsget("chasu")
					FItemList(i).FDetailIdx			= rsget("detailidx")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End Sub

	'// 해당일자 주년 등록취향 데이터 불러옴
	public Sub GetTasteDetailTopOne()
		dim sqlStr, i

		sqlStr = " SELECT TOP 1 d.idx, d.masterIdx, d.chasu, d.userID, d.itemID, d.isUsing, d.regdate, d.lastupdate"
		sqlStr = sqlStr & " , i.itemname, i.mainimage, i.smallimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.basicimage600, i.basicimage1000 "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail d With(NOLOCK) "
        sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemID = i.itemid "
		sqlStr = sqlStr & " WHERE d.chasu = '"&FRectChasu&"' AND d.masterIdx = '"&FRectMasterIdx&"' AND d.isUsing = 'Y' "
        If Trim(FRectUserID) <> "" Then
            sqlStr = sqlStr & " AND d.userid <> '"&FRectUserID&"' "
        End If
        sqlStr = sqlStr & " ORDER BY idx DESC "
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly

        set FOneItem = new CTasteItem
		if  not rsget.EOF  then
            FOneItem.FDetailIdx        		= rsget("Idx")
            FOneItem.FMasterIdx             = rsget("masterIdx")
            FOneItem.FDetailChasu         	= rsget("chasu")
            FOneItem.FDetailUserId          = rsget("userID")
			FOneItem.FDetailItemId          = rsget("itemID")
			FOneItem.FDetailIsUsing         = rsget("isUsing")
			FOneItem.FDetailRegDate         = rsget("regdate")
			FOneItem.FDetailLastUpDate      = rsget("lastupdate")
            FOneItem.FListImage		        = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
            FOneItem.FListImage120	        = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
            FOneItem.FIcon1Image	        = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
            FOneItem.FIcon2Image		    = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
            FOneItem.FBasicImage		    = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")            
        Else
            FOneItem.FDetailIdx        		= ""
            FOneItem.FMasterIdx             = ""
            FOneItem.FDetailChasu         	= ""
            FOneItem.FDetailUserId          = ""
			FOneItem.FDetailItemId          = ""
			FOneItem.FDetailIsUsing         = ""
			FOneItem.FDetailRegDate         = ""
			FOneItem.FDetailLastUpDate      = ""
            FOneItem.FListImage		        = ""
            FOneItem.FListImage120	        = ""
            FOneItem.FIcon1Image	        = ""
            FOneItem.FIcon2Image		    = ""
            FOneItem.FBasicImage		    = ""
		end if
		rsget.Close
	End sub

	'// 해당일자 주년 등록취향 데이터 리스트
	public Sub GetTasteUserList()
		dim sqlStr, i

		sqlStr = " SELECT COUNT(*) as cnt "
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail d WITH(NOLOCK) "
        sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE d.chasu='"&FRectChasu&"' AND d.masterIdx='"&FRectMasterIdx&"' AND d.IsUsing = 'Y' "
        If Trim(FRectUserID) <> "" Then
            sqlStr = sqlStr & " AND d.userid<>'"&FRectUserID&"' "
        End If
        rsget.Open sqlStr, dbget, adOpenForwardOnly,adLockReadOnly
            FTotalCount = rsget("cnt")
        rsget.Close

		sqlStr = " SELECT top "&CStr(FPageSize * FCurrPage)&" d.idx, d.masteridx, d.userid, d.chasu, d.itemid, d.isusing, d.regdate, d.lastupdate "
		sqlStr = sqlStr & " , i.itemname, i.mainimage, i.smallimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image "
		sqlStr = sqlStr & " , i.basicimage600, i.basicimage1000 "
        If Trim(FRectUserID) <> "" And Trim(FRectFolderIdx) <> "" Then
            sqlStr = sqlStr & " , (SELECT TOP 1 fidx FROM db_my10x10.dbo.tbl_myfavorite WHERE itemid = d.itemid AND userid='"&FRectUserID&"' AND fidx='"&FRectFolderIdx&"') AS folderidx "
        End If
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_18thTasteEvent_Detail d With(NOLOCK) "
        sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON d.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE d.chasu='"&FRectChasu&"' AND d.masterIdx='"&FRectMasterIdx&"' AND d.IsUsing = 'Y' "
        If Trim(FRectUserID) <> "" Then
            sqlStr = sqlStr & " AND d.userid<>'"&FRectUserID&"' "
        End If        
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
				set FItemList(i) = new CTasteItem
                    FItemList(i).FDetailIdx        		= rsget("Idx")
                    FItemList(i).FMasterIdx             = rsget("masterIdx")
                    FItemList(i).FDetailChasu         	= rsget("chasu")
                    FItemList(i).FDetailUserId          = rsget("userID")
                    FItemList(i).FDetailItemId          = rsget("itemID")
                    FItemList(i).FDetailIsUsing         = rsget("isUsing")
                    FItemList(i).FDetailRegDate         = rsget("regdate")
                    FItemList(i).FDetailLastUpDate      = rsget("lastupdate")
                    FItemList(i).FListImage		        = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage")
                    FItemList(i).FListImage120	        = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
                    FItemList(i).FIcon1Image	        = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon1Image")
                    FItemList(i).FIcon2Image		    = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
                    FItemList(i).FBasicImage		    = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
                    If Trim(FRectUserID) <> "" And Trim(FRectFolderIdx) <> "" Then
                        FItemList(i).FFolderIdx             = rsget("folderidx")
                    End If
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End sub

	'// 해당 유저의 위시 폴더 fidx 값 가져옴
	public Sub GetUserWishFolderFidxImport()
		dim sqlStr, i
        sqlstr = "Select TOP 1 fidx From [db_my10x10].[dbo].[tbl_myfavorite_folder] WITH(NOLOCK) WHERE foldername = '" & trim(FRectFolderName) & "' and userid='" & FRectUserID & "' "
        rsget.Open sqlstr, dbget, adOpenForwardOnly,adLockReadOnly
        set FOneItem = new CTasteItem
		if  not rsget.EOF  then
            FOneItem.FFolderIdx = rsget("fidx")
        Else
            FOneItem.FFolderIdx = ""
        End If
        rsget.Close
    End Sub
    
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
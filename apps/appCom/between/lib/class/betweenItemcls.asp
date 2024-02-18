<%
'#######################################################
'	History	: 2008.03.26 허진원 생성
'			  2008.04.13 한용민 수정
'	Description : 카테고리 페이지(메인/목록) 클래스
'#######################################################

CLASS CAutoCategory
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
	Public FRectbetCateCd '// 비트윈 카테고리 코드
	Public FRectbetCateNm '// 비트윈 카테고리명
	Public FRectSellScope
	Public FbetCateCd
	Public FbetCateNm
	Public FSellScope
	Public FSortMet

	public FDiscountRate
	public FCategoryList()
	public FCategorySubList()
	public FCategoryPrdList()
	public FCategoryBrand()
	public FCategoryPrd
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

	Public FRectOnlySellY

	public FRectPercentLow
    public FRectPercentHigh
    
    public FRectSearchFlag
    public FRectSortMethod
	public FRectSearchItemDiv

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 10
		FTotalPage = 1
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'// 카테고리 브랜드 신상품 목록 불러오기(상품상세페이지 하단 브랜드/카테고리 상품 목록用)
	public sub GetBrandCategoryList()

		dim strSQL,i, j, tcd1, tcd2, tcd3
		
		'// 목록내용 가져오기
		strSQL =" EXECUTE db_item.dbo.sp_Ten_CategoryList " &_
					" @cdL= '" &FRectCD1&"'" &_
					" ,@cdM='" &FRectCD2&"' " &_
					" ,@cdS='" &FRectCD3&"' " &_ 
					" ,@Makerid ='" &FRectMakerid& "' " &_
					" ,@PgSize='" &FPageSize&"' " &_
					" ,@CurrPg='" &FCurrPage&"' " &_
					" ,@WhereMtd='' " &_
					" ,@SortMtd='' "&_
					" ,@SalePercentHigh ='' "&_
					" ,@SalePercentLow = ''"&_
					" ,@SearchItemDiv = ''" 													
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.PageSize=FPageSize
		rsget.Open strSQL, dbget
		'response.write strSQL
		FResultCount = rsget.RecordCount-((FCurrPage-1)*FPageSize)
		redim FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem
				
				FItemList(i).FCdL	= rsget("code_large")
				FItemList(i).FCdM	= rsget("code_mid")
				FItemList(i).FCdS	= rsget("code_small")
				'FItemList(i).Fcode_div	= arrData(3)
				FItemList(i).FItemid	= rsget("Itemid")
				FItemList(i).FItemName	= db2html(rsget("ItemName"))
				'FItemList(i).FKeyWords	= rsget("code_large")
				FItemList(i).FSellCash	= rsget("SellCash")
				FItemList(i).FOrgPrice	= rsget("OrgPrice")
				FItemList(i).FMakerId	= rsget("MakerId")
				FItemList(i).FBrandName	= db2html(rsget("BrandName"))
				FItemList(i).FImageList	= "http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(rsget("ListImage"))
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & db2html(rsget("ListImage120"))
				FItemList(i).FImageSmall	= "http://webimage.10x10.co.kr/image/small/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(rsget("smallImage"))
				FItemList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsget("icon1image")
				FItemList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & rsget("icon2image")
					
				FItemList(i).FSellyn	= rsget("sellYn")
				FItemList(i).FSaleyn	= rsget("SaleYn")
				FItemList(i).FLimityn	= rsget("LimitYn")
				FItemList(i).FRegdate		= rsget("regdate")
				FItemList(i).FReipgodate	= rsget("reipgodate")
				FItemList(i).FItemcouponyn	= rsget("itemcouponYn")
				FItemList(i).FItemcouponvalue	= rsget("itemCouponValue")
				FItemList(i).FItemcoupontype	= rsget("itemCouponType")
				FItemList(i).FEvalcnt	= rsget("evalCnt")
				FItemList(i).FItemScore	= rsget("itemScore")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	End sub

	'// 상품 리스트 불러오기
	public Sub GetCategoryList()
		dim strSQL,i, j

		strSQL = "exec [db_item].[dbo].ten_category_list_tcnt '" + CStr(FPageSize) + "','" + FRectCD1 + "','" + FRectCD2 + "','" + FRectCD3 + "','" + FRectMakerID + "','" + FRectOnlySellY + "','" + FRectSort + "','" + FRectPercentLow + "','" + FRectPercentHigh + "'"  + vbcrlf

			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
			rsget.Open strSQL, dbget

			FTotalCount = rsget("Totalcnt")
			FTotalPage 	=	rsget("TotalPage")
			rsget.close

		strSQL = "exec [db_item].[dbo].ten_category_list '" + CStr(FPageSize*FCurrPage) + "','" + FRectCD1 + "','" + FRectCD2 + "','" + FRectCD3 + "','" + FRectMakerID + "','" + FRectOnlySellY + "','" + FRectSort + "', '" + FRectOrder + "','" + FRectPercentLow + "','" + FRectPercentHigh + "'" + vbcrlf

		'response.write strSQL

			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenForwardOnly
			rsget.LockType = adLockReadOnly
			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if  not rsget.EOF  then

			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FTotalCount mod FPageSize) = 0 then
				 RoundUP = FTotalCount/FPageSize
			else
				 RoundUP = int(FTotalCount/FPageSize)+1
			end If

            if (FResultCount<1) then FResultCount=0

			redim preserve FCategoryPrdList(FResultCount)
			i=0
				rsget.absolutepage = FCurrPage
				do until rsget.eof
					set FCategoryPrdList(i) = new CCategoryPrdItem

					FCategoryPrdList(i).FItemID       = rsget("itemid")
					FCategoryPrdList(i).FItemName     = db2html(rsget("itemname"))

					FCategoryPrdList(i).FSellcash     = rsget("sellcash")
					FCategoryPrdList(i).FSellYn       = rsget("sellyn")
					FCategoryPrdList(i).FLimitYn      = rsget("limityn")
					FCategoryPrdList(i).FLimitNo      = rsget("limitno")
					FCategoryPrdList(i).FLimitSold    = rsget("limitsold")
					FCategoryPrdList(i).Fitemgubun    = rsget("itemgubun")
					FCategoryPrdList(i).FDeliverytype = rsget("deliverytype")
					FCategoryPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
					FCategoryPrdList(i).FItemCouponValue	= rsget("ItemCouponValue")

					FCategoryPrdList(i).Fevalcnt = rsget("evalcnt")
					FCategoryPrdList(i).Fitemcouponyn = rsget("itemcouponyn")

					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
					FCategoryPrdList(i).FImageList = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("listimage")
					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("listimage120")
					FCategoryPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon1image")
					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsget("icon2image")

					FCategoryPrdList(i).FMakerID = rsget("makerid")
					FCategoryPrdList(i).fbrandname = db2html(rsget("brandname"))
					FCategoryPrdList(i).FRegdate = rsget("regdate")

					FCategoryPrdList(i).FSaleYn    = rsget("sailyn")
					FCategoryPrdList(i).FOrgPrice   = rsget("orgprice")
					FCategoryPrdList(i).FSpecialuseritem = rsget("specialuseritem")
					FCategoryPrdList(i).Fevalcnt = rsget("evalcnt")
					rsget.movenext
					i=i+1
				loop
			end if
			rsget.close
	End Sub

	'// 비트윈 상품 리스트 불러오기(카테고리별)
	'// 101-커플, 102-소품/취미, 103-디지털, 104-푸드, 105-패션, 106-뷰티, 107-세일
	public Sub GetBetCategoryList()
		dim strSQL,i, j

		strSQL = "exec [db_outmall].[dbo].sp_Between_categoryList_Tcnt '" + FRectMakerID + "','" + CStr(FPageSize) + "','" + CStr(FCurrPage) + "','" + FSellScope + "','" + FRectbetCateCd + "'"  + vbcrlf
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenForwardOnly
			rsCTget.LockType = adLockReadOnly
			rsCTget.Open strSQL, dbCTget

			FTotalCount = rsCTget("Totalcnt")
			FTotalPage 	=	rsCTget("TotalPage")
			rsCTget.close

		strSQL = "exec [db_outmall].[dbo].sp_Between_categoryList '" + FRectMakerID + "','" + CStr(FPageSize) + "','" + CStr(FCurrPage) + "','" + FSellScope + "','" + FRectbetCateCd + "','" + CStr(FSortMet) + "'"  + vbcrlf
'rw strSQL
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenForwardOnly
			rsCTget.LockType = adLockReadOnly
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSQL, dbCTget, 1

			if  not rsCTget.EOF  then

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))

			if (FTotalCount mod FPageSize) = 0 then
				 RoundUP = FTotalCount/FPageSize
			else
				 RoundUP = int(FTotalCount/FPageSize)+1
			end If

            if (FResultCount<1) then FResultCount=0

			redim preserve FCategoryPrdList(FResultCount)
			i=0
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FCategoryPrdList(i) = new CCategoryPrdItem

					FCategoryPrdList(i).FItemID       = rsCTget("itemid")
					If Trim(db2html(rsCTget("chgItemname")))="" Then
						FCategoryPrdList(i).FItemName     = db2html(rsCTget("itemname"))
					Else
						FCategoryPrdList(i).FItemName     = db2html(rsCTget("chgItemname"))
					End If


					FCategoryPrdList(i).FSellcash     = rsCTget("sellcash")
					FCategoryPrdList(i).FSellYn       = rsCTget("sellyn")
					FCategoryPrdList(i).FLimitYn      = rsCTget("limityn")
					FCategoryPrdList(i).FLimitNo      = rsCTget("limitno")
					FCategoryPrdList(i).FLimitSold    = rsCTget("limitsold")
					FCategoryPrdList(i).Fitemgubun    = rsCTget("itemgubun")
					FCategoryPrdList(i).FDeliverytype = rsCTget("deliverytype")
					FCategoryPrdList(i).Fitemcoupontype	= rsCTget("itemcoupontype")
					FCategoryPrdList(i).FItemCouponValue	= rsCTget("ItemCouponValue")

					FCategoryPrdList(i).Fevalcnt = rsCTget("evalcnt")
					FCategoryPrdList(i).Fitemcouponyn = rsCTget("itemcouponyn")

					FCategoryPrdList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsCTget("smallimage")
					FCategoryPrdList(i).FImageList = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsCTget("BasicImage"),"200","200","true","false")
					FCategoryPrdList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsCTget("listimage120")
					FCategoryPrdList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsCTget("icon1image")
					FCategoryPrdList(i).FImageicon2 = "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsCTget("icon2image")
					FCategoryPrdList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemid) + "/" + rsCTget("BasicImage")

					FCategoryPrdList(i).FMakerID = rsCTget("makerid")
					FCategoryPrdList(i).fbrandname = db2html(rsCTget("brandname"))
					FCategoryPrdList(i).FRegdate = rsCTget("regdate")

					FCategoryPrdList(i).FSaleYn    = rsCTget("sailyn")
					FCategoryPrdList(i).FOrgPrice   = rsCTget("orgprice")
					FCategoryPrdList(i).FSpecialuseritem = rsCTget("specialuseritem")
					FCategoryPrdList(i).Fevalcnt = rsCTget("evalcnt")
					FCategoryPrdList(i).FbetCateCd = rsCTget("CateCode")
					FCategoryPrdList(i).FbetCateNm = rsCTget("catename")
					rsCTget.movenext
					i=i+1
				loop
			end if
			rsCTget.close
	End Sub



	'// 카테고리 Left Focus on Item 목록 접수 //
	Public sub GetCateLeftFocusItemList()
		dim i

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec db_sitemaster.dbo.sp_Ten_FocusOnItem_ListTop5 '" & FRectCD1 & "','" & FRectCD2 & "','" & FRectCD3 & "'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub
    
    
    '// 카테고리 Left Happy Together && Left Category Best 목록 접수 //
    '// Happy Together 우선적으로 채운후 Category Best로 채움
    Public sub GetCateRightHappyTogetherNCateBestItemList()
        dim i, pItemArr
        const MaxTopN = 20
        
        '커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		
		'저장프로시저 실행
		rsget.Open "exec db_sitemaster.dbo.sp_Ten_happyTogether_List " & CStr(FRectItemId) & "," & (MaxTopN) , dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		i=0
		pItemArr =""
		
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
				FItemList(i).Fitemdiv		= rsget("itemdiv")
				FItemList(i).FOrgPrice 		= rsget("orgprice")
				FItemList(i).FSellyn 		= rsget("sellyn")
				FItemList(i).FSaleyn 		= rsget("sailyn")
				FItemList(i).FLimityn 		= rsget("limityn")
				FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
				FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
				FItemList(i).FItemCouponType 	= rsget("itemCouponType")
                
                pItemArr = pItemArr + CStr(FItemList(i).FItemID) + ","
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
		
		''결과 값이 MaxTopN개 미만인경우 중복 안되게 MaxTopN개 채움 
		if (FResultCount<MaxTopN) then
            '커서 위치 지정
    		rsget.CursorLocation = adUseClient
    		rsget.CursorType = adOpenStatic
    		rsget.LockType = adLockOptimistic

    		If FRectDisp = "" OR FRectDisp = "0" Then
    			FRectDisp = "101"
    		End If
    		
    		'저장프로시저 실행
    		rsget.Open "exec db_sitemaster.dbo.[sp_Ten_dispcateBestChoice_List] '" & FRectDisp & "','" & (Len(FRectDisp)/3) & "'," & CStr(FRectItemId) & "," & MaxTopN , dbget
    		'rsget.Open "exec db_sitemaster.dbo.sp_Ten_cateBestChoice_List '" & FRectCD1 & "','" & FRectCD2 & "','" & FRectCD3 & "'," & CStr(FRectItemId) & "," & MaxTopN , dbget
    		
    		if  not rsget.EOF  then
    			do until rsget.eof
                    if (InStr(pItemArr,CStr(rsget("itemid")) & "," )>0) then
                        ''이미 표시된 상품인경우 skip
                    else
                        if (FResultCount>=MaxTopN) then Exit do
                        FResultCount = FResultCount + 1
                        redim preserve FItemList(FResultCount)
        				set FItemList(i) = new CCategoryPrdItem
                        
        				FItemList(i).FItemID		= rsget("itemid")
        				FItemList(i).FItemName		= db2html(rsget("itemname"))
        				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
        				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
        				FItemList(i).FBrandName		= db2html(rsget("brandname"))
        				FItemList(i).FMakerID		= db2html(rsget("makerid"))
        				FItemList(i).Fitemdiv		= rsget("itemdiv")
        				FItemList(i).FEvalCnt		= rsget("evalcnt")
        				FItemList(i).FfavCount		= rsget("favcount")
        				
						FItemList(i).FSellCash 		= rsget("sellcash")
						FItemList(i).FOrgPrice 		= rsget("orgprice")
						FItemList(i).FSellyn 		= rsget("sellyn")
						FItemList(i).FSaleyn 		= rsget("sailyn")
						FItemList(i).FLimityn 		= rsget("limityn")
						FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
						FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
						FItemList(i).FItemCouponType 	= rsget("itemCouponType")
        
        				i=i+1
    				end if
    				rsget.moveNext
    			loop
    		end if
    
    		rsget.Close
		end if
    end Sub

    '// Recopick 추천상품 및 Category Best 목록 접수 //
    Public sub GetRecoPick_CateBestItemList()
        dim i, pItemArr, strSql
        const MaxTopN = 20

		'// 추천상품 목록접수
		strSql = "Select top " & MaxTopN & " i.itemid, i.itemname, i.listimage, i.listimage120, "
		strSql = strSql & "	(Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid, "
		strSql = strSql & "	i.brandname, i.specialuseritem, i.itemdiv, i.evalcnt, ic.favcount, "
		strSql = strSql & "	isNull(i.sellcash,0) as sellcash, isNull(i.orgprice,0) as orgprice, "
		strSql = strSql & "	isNull(i.sellyn,'') as sellyn, isNull(i.sailyn,'') as sailyn, isNull(i.limityn,'') as limityn, "
		strSql = strSql & "	isNull(i.itemcouponyn,'') as itemcouponyn, isNull(i.itemCouponValue,'') as itemCouponValue, "
		strSql = strSql & "	isNull(i.itemCouponType,'') as itemCouponType "
		strSql = strSql & "from  [db_item].[dbo].tbl_item i "
		strSql = strSql & "	Join [db_item].[dbo].tbl_item_Contents ic  "
		strSql = strSql & "	on i.itemid=ic.itemid "
		strSql = strSql & "where i.itemid in (" & FRectitemarr & ") "
		strSql = strSql & "	and i.sellyn='Y' "
		strSql = strSql & "	and i.itemid<>" & FRectItemId & " "
		strSql = strSql & "order by i.itemscore desc"
		rsget.Open strSql, dbget, 1
		
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		pItemArr =""

		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
				FItemList(i).Fitemdiv		= rsget("itemdiv")

				FItemList(i).FSellCash 		= rsget("sellcash")
				FItemList(i).FOrgPrice 		= rsget("orgprice")
				FItemList(i).FSellyn 		= rsget("sellyn")
				FItemList(i).FSaleyn 		= rsget("sailyn")
				FItemList(i).FLimityn 		= rsget("limityn")
				FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
				FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
				FItemList(i).FItemCouponType 	= rsget("itemCouponType")
				FItemList(i).FEvalCnt 	= rsget("evalcnt")
				FItemList(i).FfavCount 	= rsget("favcount")
				FItemList(i).FUseETC	= "R"		'레코픽 추천

                pItemArr = pItemArr + CStr(FItemList(i).FItemID) + ","
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

		''결과 값이 MaxTopN개 미만인경우 중복 안되게 MaxTopN개 채움
		if (FResultCount<MaxTopN) then		
			'//전시카테고리 베스트
	
	        '커서 위치 지정
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
	
			If FRectDisp = "" OR FRectDisp = "0" Then
				FRectDisp = "101"
			End If
	
			'저장프로시저 실행
			rsget.Open "exec db_sitemaster.dbo.[sp_Ten_dispcateBestChoice_List] '" & FRectDisp & "','" & (Len(FRectDisp)/3) & "'," & CStr(FRectItemId) & "," & MaxTopN , dbget
	
			if  not rsget.EOF  then
				do until rsget.eof
	                if (InStr(pItemArr,CStr(rsget("itemid")) & "," )>0) then
	                    ''이미 표시된 상품인경우 skip
	                else
	                    if (FResultCount>=MaxTopN) then Exit do
	                    FResultCount = FResultCount + 1
	                    redim preserve FItemList(FResultCount)
	    				set FItemList(i) = new CCategoryPrdItem
	
	    				FItemList(i).FItemID		= rsget("itemid")
	    				FItemList(i).FItemName		= db2html(rsget("itemname"))
	    				FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
	    				FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
	    				FItemList(i).FBrandName		= db2html(rsget("brandname"))
	    				FItemList(i).FMakerID		= db2html(rsget("makerid"))
	    				FItemList(i).Fitemdiv		= rsget("itemdiv")
	    				FItemList(i).FEvalCnt		= rsget("evalcnt")
	    				FItemList(i).FfavCount		= rsget("favcount")
	
						FItemList(i).FSellCash 		= rsget("sellcash")
						FItemList(i).FOrgPrice 		= rsget("orgprice")
						FItemList(i).FSellyn 		= rsget("sellyn")
						FItemList(i).FSaleyn 		= rsget("sailyn")
						FItemList(i).FLimityn 		= rsget("limityn")
						FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
						FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
						FItemList(i).FItemCouponType 	= rsget("itemCouponType")
						FItemList(i).FEvalCnt 	= rsget("evalcnt")
						FItemList(i).FfavCount 	= rsget("favcount")
						FItemList(i).FUseETC	= "T"		'텐바이텐 베스트
	
	    				i=i+1
					end if
					rsget.moveNext
				loop
			end if
    		rsget.Close
		end if
    end Sub

	'// 카테고리 Left Focus on Item 목록 접수 //
	Public sub GetCateSmallItemIconList()
		dim i

		'커서 위치 지정
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		'저장프로시저 실행
		rsget.Open "exec [db_const].[dbo].[sp_Ten_ItemListSmallCategoryIcon] '" & FRectCD1 & "','" & FRectCD2 & "'", dbget
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FcdL			= rsget("cate_large")
				FItemList(i).FcdM			= rsget("cate_mid")
				FItemList(i).FcdS			= rsget("cate_small")
				FItemList(i).FCateName		= db2html(rsget("small_name"))
				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FImageSmall	= "http://webimage.10x10.co.kr/image/small/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" &db2html(rsget("smallImage"))

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub

	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function
	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function
	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
End Class

'#=========================================#
'# 상품 페이지 & 상품 리스트  추가 함수    #
'#=========================================#

'// 카테고리 코드 > 이름으로 변환
Function getCategoryNameDB(cd1,cd2,cd3)
	Dim SQL

	'유효성 검사
	if cd1="" then
		getCategoryNameDB = "전체보기"
		Exit Function
	end if

	SQL =	"exec [db_item].[dbo].sp_Ten_category_name '" & cd1 & "', '" & cd2 & "', '" & cd3 & "'"
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open SQL, dbget
		if NOT(rsget.EOF or rsget.BOF) then
			getCategoryNameDB = db2html(rsget(0))
		else
			getCategoryNameDB = "전체보기"
		end if
	rsget.Close
End Function

Function getDisplayCateNameDB(disp)
	Dim SQL

	'유효성 검사
	if disp="" then
		getDisplayCateNameDB = "전체보기"
		Exit Function
	end if

	SQL = "select [db_item].[dbo].getDisplayCateName('" & disp & "')"
	rsget.Open SQL, dbget
		if NOT(rsget.EOF or rsget.BOF) then
			getDisplayCateNameDB = db2html(rsget(0))
		else
			getDisplayCateNameDB = "전체보기"
		end if
	rsget.Close
End Function

'// 카테고리 관련 링크 테이블 출력
Sub printCategoryRelateLink(cd1,cd2,cd3)
	Dim SQL, strTemp

	'유효성 검사
	if cd1="" or cd2="" then
		Exit Sub
	end if

	SQL =	"exec [db_item].[dbo].sp_Ten_category_RelateLink '" & cd1 & "', '" & cd2 & "', '" & cd3 & "'"
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open SQL, dbget
		if NOT(rsget.EOF or rsget.BOF) then
			'테이블 시작
			strTemp = "<table border='0' cellspacing='0' cellpadding='0'>" &_
					"<tr>" &_
					"	<td style='padding-right:7px;'><img src='http://fiximage.10x10.co.kr/web2008/category/check_title.gif' width='103' height='16'></td>" &_
					"	<td class='gray11px02' style='padding-top:3px;'>"
			'내용 출력
			Do Until rsget.EOF
				strTemp = strTemp & "		<a href='" & rsget(1) & "' class='link_gray11px01'>" & rsget(0) & "</a>"
			rsget.MoveNext
				if NOt(rsget.EOF) then strTemp = strTemp & "<span class='wordspace01'> | </span>"
			loop
			'테이블 끝
			strTemp = strTemp & "	</td>" &_
					"</tr>" &_
					"</table>"
		end if
	rsget.Close

	Response.Write strTemp
End Sub

'// 카테고리 Histoty 출력(2008.07.18; 허진원 수정:[sp_Ten_category_history_name]로 1Query실행)
Sub printCategoryHistory(code)
	dim strHistory, strLink, SQL, i, j, StrLogTrack
	j = (len(code)/3)
    
	'히스토리 기본
	strHistory = "<a href='/'>HOME</a>"

	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
	rsget.Open SQL, dbget, 1

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
				strHistory = strHistory & "&nbsp;&gt;&nbsp;<a href=""/category/category_list.asp?disp="&Left(code,(3*i))&""">"
				if i = j then
					strHistory = strHistory & "" & Split(db2html(rsget(0)),"^^")(i-1) & ""
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				else
					strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				end if
				strHistory = strHistory & "</a>"
			next
		End If
	end if
	
	''logger 
	strHistory = strHistory & "<script language='JavaScript'>var _TRK_PNG='" & StrLogTrack  & "';</script>"
	
	rsget.Close

	Response.Write strHistory
end Sub

'// 카테고리 Histoty 출력
Sub printCategoryHistorymulti(code)
	dim strHistory, strLink, SQL, i, j, StrLogTrack
	j = (len(code)/3)
    
	'히스토리 기본
	strHistory = ""

	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
	rsget.Open SQL, dbget, 1

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
				if i<>1 then
					strHistory = strHistory & "&nbsp;&gt;&nbsp;"
				end if
				
				if i=1 then
					strHistory = strHistory & "<a href='' onclick=""moveCategorysub('"& Left(code,(3*i)) &"'); return false;"">"
				else
					strHistory = strHistory & "<a href='' onclick=""moveCategoryList('"& Left(code,(3*i)) &"','1','',''); return false;"">"
					'strHistory = strHistory & "<a href=""/category/category_list.asp?disp="&Left(code,(3*i))&""">"
				end if
				
				if i = j then
					strHistory = strHistory & "" & Split(db2html(rsget(0)),"^^")(i-1) & ""
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				else
					strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				end if
				
				strHistory = strHistory & "</a>"
			next
		End If
	end if
	
	''logger 
	strHistory = strHistory & "<script language='JavaScript'>var _TRK_PNG='" & StrLogTrack  & "';</script>"
	
	rsget.Close

	Response.Write strHistory
end Sub

'// 브랜드 카테고리 Histoty 출력 2014-03-06 이종화추가
Sub printBrandCategoryHistorymulti(code , makerid)
	dim strHistory, strLink, SQL, i, j, StrLogTrack
	j = (len(code)/3)
    
	'히스토리 기본
	strHistory = ""

	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
	rsget.Open SQL, dbget, 1

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
				if i<>1 then
					strHistory = strHistory & "&nbsp;&gt;&nbsp;"
				end if
				
				strHistory = strHistory & "<a href='' onclick=""moveBrandCategoryList('"& Left(code,(3*i)) &"','1','','','"& makerid &"'); return false;"">"
				
				if i = j then
					strHistory = strHistory & "" & Split(db2html(rsget(0)),"^^")(i-1) & ""
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				else
					strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				end if
				
				strHistory = strHistory & "</a>"
			next
		End If
	end if
	
	''logger 
	strHistory = strHistory & "<script language='JavaScript'>var _TRK_PNG='" & StrLogTrack  & "';</script>"
	
	rsget.Close

	Response.Write strHistory
end Sub

'// 검색페이지 카테고리 Histoty 출력 2014-03-24 이종화 추가
Sub printSearchCategoryHistorymulti(code)
	dim strHistory, strLink, SQL, i, j, StrLogTrack
	j = (len(code)/3)
    
	'히스토리 기본
	strHistory = ""

	'// 카테고리 이름 접수
	SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
	rsget.Open SQL, dbget, 1

	if NOT(rsget.EOF or rsget.BOF) then
		If Not(isNull(rsget(0))) Then
			for i = 1 to j
				if i<>1 then
					strHistory = strHistory & "&nbsp;&gt;&nbsp;"
				end if
				
				if i=1 then
					strHistory = strHistory & "<a href='' onclick=""fnSearch(document.frmSrch.dispCate,'"& Left(code,(3*i)) &"'); return false;"">"
				else
					strHistory = strHistory & "<a href='' onclick=""fnSearch(document.frmSrch.dispCate,'"& Left(code,(3*i)) &"'); return false;"">"
					'strHistory = strHistory & "<a href=""/category/category_list.asp?disp="&Left(code,(3*i))&""">"
				end if
				
				if i = j then
					strHistory = strHistory & "" & Split(db2html(rsget(0)),"^^")(i-1) & ""
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				else
					strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
				end if
				
				strHistory = strHistory & "</a>"
			next
		End If
	end if
	
	''logger 
	strHistory = strHistory & "<script language='JavaScript'>var _TRK_PNG='" & StrLogTrack  & "';</script>"
	
	rsget.Close

	Response.Write strHistory
end Sub

'////카테고리 셀렉트 option 박스
Function DrawSelectBoxDispCategory(disp,depth)
	dim tmp_str,query1, vBody
	vBody = "<option value="""">카테고리 선택</option>"
	
	query1 = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
	query1 = query1 & " where depth = '" & depth & "' and useyn = 'Y' "
	If depth <> "1" Then
		query1 = query1 & " and Left(catecode,"&(depth-1)*3&") = '" & Left(disp,(depth-1)*3) & "' "
	End If
	query1 = query1 & " order by sortno Asc"
	rsget.Open query1,dbget,1
	'response.write query1 & "!!" & disp
	if  not rsget.EOF  then
		do until rsget.EOF
			if Left(Cstr(disp),3*depth) = Cstr(rsget("catecode")) then
				tmp_str = " selected"
			end if
			vBody = vBody & "<option value='"&rsget("catecode")&"' "&tmp_str&">"& db2html(rsget("catename")) &"</option>"
			tmp_str = ""
		rsget.MoveNext
		loop
	end if
	rsget.close
	DrawSelectBoxDispCategory = vBody
End Function

'/카테고리 셀렉트 option 박스
'//apps/appcom/cal/webview/color/coloritemlist.asp
Function DrawSelectBoxDispCategorymulti(disp,depth)
	dim tmp_str,query1, vBody, isend
		isend=0

	'/카테고리 depth1 보다 클경우
	If depth > 1 Then
		'/다음카테고리가 있는지 체크
		query1 = "select count(*) as cnt"
		query1 = query1 & " from db_item.dbo.tbl_display_cate"
		query1 = query1 & " where useyn='Y' and depth = '" & depth & "'"
		query1 = query1 & " and Left(catecode,"&(depth-1)*3&") = '" & Left(disp,(depth-1)*3) & "'"
		
		'response.write query1 & "<BR>"
		rsget.Open query1,dbget,1
		if not rsget.EOF  then
			isend= rsget("cnt")
		end if
		rsget.close
	End If

	'//카테고리 depth1 보다 클경우
	If depth > 1 Then
		'/ 이전 카테고리의 전체를 뿌림
		vBody = "<option value="""& left(disp,len(disp)-3)&""">카테고리 선택</option>"
	else
		vBody = "<option value="""">카테고리 선택</option>"
	End If
	
	query1 = " select top 500 catecode, catename"
	query1 = query1 & " from [db_item].[dbo].tbl_display_cate"
	query1 = query1 & " where useyn = 'Y'"

	'/카테고리 depth1 보다 클경우
	If depth > 1 Then
		'//다음 Depth 카테고리를 가져옴
		If isend > 0 then
			query1 = query1 & " and depth = '" & depth & "'"
			query1 = query1 & " and Left(catecode,"&(depth-1)*3&") = '" & Left(disp,(depth-1)*3) & "'"

		'//다음 depth가 없으므로 현재 카테고리를 가져옴
		else
			query1 = query1 & " and depth = '" & depth-1 & "'"
			query1 = query1 & " and Left(catecode,"&(depth-2)*3&") = '" & Left(disp,(depth-2)*3) & "'"
		end if
	
	'//카테고리 depth1
	else
		query1 = query1 & " and depth = '" & depth & "'"
	End If

	query1 = query1 & " order by sortno Asc"

	'response.write query1 & "!!" & disp
	rsget.Open query1,dbget,1
	if  not rsget.EOF  then
		do until rsget.EOF
			if Left(Cstr(disp),3*depth) = Cstr(rsget("catecode")) then
				tmp_str = " selected"
			end if
			vBody = vBody & "<option value='"&rsget("catecode")&"' "&tmp_str&">"& db2html(rsget("catename")) &"</option>"
			tmp_str = ""
		rsget.MoveNext
		loop
	end if
	rsget.close
	
	DrawSelectBoxDispCategorymulti = vBody
End Function

'// 내가 찜한 상품 여부(위시)
Function getIsMyFavItem(uid,iid)
	dim strSQL
	strSQL = "execute [db_my10x10].[dbo].[sp_Ten_MyWishList_Count] '" & CStr(uid) & "','',''," & cStr(iid)

	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open strSQL, dbget

	if rsget("cnt")>0 then
		getIsMyFavItem = true
	else
		getIsMyFavItem = false
	end if
	rsget.Close
end Function
%>
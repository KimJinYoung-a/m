<%
'#######################################################
'	History	: 2008.09.01 서동석 생성
'           : 2008.10.31 허진원 - 쇼핑찬스_플러스세일 추가
'
'	Description : 세트 구매 할인 클래스
'#######################################################



Class CSetSaleItem
    public FItemList()
    
    public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	
	public FRectItemID
	
	public function IsSetSaleLinkItem()
	    dim strSQL
	    IsSetSaleLinkItem = False

		dim objConn, objCmd, rs

		set objConn = CreateObject("ADODB.Connection")
		objConn.Open Application("db_main") 
		Set objCmd = Server.CreateObject ("ADODB.Command")	

	    strSQL = " select top 1 plusSaleLinkItemid "
        strSQL = strSQL & " from db_item.dbo.tbl_PlusSaleLinkItemList s "
        strSQL = strSQL & " where s.plusSaleLinkItemid= ? "

		objCmd.ActiveConnection = objConn
		objCmd.CommandType = adCmdText
		objCmd.CommandText = strSQL

		objCmd.Parameters.Append(objCmd.CreateParameter("itemid",adchar, adParamInput, Len(CStr(FRectItemID)), CStr(FRectItemID)))

		set rs = objCmd.Execute

		if  not rs.EOF  then
			IsSetSaleLinkItem = True
		End if
		
		objConn.Close
		SET objConn = Nothing
    end function

	public Sub GetLinkSetSaleItemList()
	    dim sqlStr, i
	    sqlStr = " exec db_item.dbo.sp_Ten_PlusSaleLinkItemList " & CStr(FRectItemID)
	    
	    rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget
	    
	    FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemDiv		= rsget("itemdiv")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList	    = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FImageSmall	= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("smallimage")
				FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
                FItemList(i).FOrgPrice      = rsget("orgprice")
                FItemList(i).FSaleYn        = rsget("sailyn")
                FItemList(i).FSellYn        = rsget("sellyn")
                FItemList(i).FLimitYn       = rsget("limityn")
                FItemList(i).FLimitNo       = rsget("limitno")
                FItemList(i).FLimitSold     = rsget("limitsold")
                FItemList(i).FLimitDispYn   = rsget("limitdispyn")
                
                FItemList(i).FOptioncnt     = rsget("optioncnt")
                FItemList(i).FplusSalePro    = rsget("plusSalePro")
                
                FItemList(i).FCurrItemCouponIdx 		= rsget("curritemcouponidx")
				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	=	rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				
				FItemList(i).FSpecialUserItem = rsget("specialuseritem")

				FItemList(i).Freviewcnt         = rsget("evalCnt") '// 2015다이어리용
				FItemList(i).FFavCount   	   = rsget("favcount") '// 2015다이어리용

				FItemList(i).Fpoints		= rsget("totalpoint")
				
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
    end Sub

	public Sub GetLinkSetSaleItemListByTopCnt()
	    dim sqlStr, i
	    sqlStr = "Select top " & CStr(FPageSize) & " i.*, s.* " &_
	    		" from db_item.dbo.vw_Current_PlusSaleItem s " &_
	    		" 	join db_item.dbo.tbl_item i " &_
	    		" 		on s.plusSaleItemid=i.itemid " &_
	    		" 		and i.sellyn='Y' " &_
	    		" where s.plusSaleLinkItemid=" & CStr(FRectItemID) &_
	    		" order by i.itemid desc "
    	rsget.Open sqlStr,dbget,1
	    
	    FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList	    = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
                FItemList(i).FOrgPrice      = rsget("orgprice")
                FItemList(i).FSaleYn        = rsget("sailyn")
                FItemList(i).FSellYn        = rsget("sellyn")
                FItemList(i).FLimitYn       = rsget("limityn")
                FItemList(i).FLimitNo       = rsget("limitno")
                FItemList(i).FLimitSold     = rsget("limitsold")
                
                
                FItemList(i).FOptioncnt     = rsget("optioncnt")
                FItemList(i).FplusSalePro    = rsget("plusSalePro")
                
                FItemList(i).FCurrItemCouponIdx 		= rsget("curritemcouponidx")
				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	=	rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				
				FItemList(i).FSpecialUserItem = rsget("specialuseritem")
				
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
    end Sub

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
end Class

'// 쇼핑찬스 플러스세일 상품 목록
Class scPlusSaleList
	dim FItemList()
	dim FPageSize
	dim FCurrPage
	dim FScrollCount
	dim FResultCount
	dim FTotalCount
	dim FTotalPage
	
	dim FRectSortMethod		'정렬방식
	dim FRectCdL			'대카테고리코드
	dim FRectCdM			'중카테고리코드
	dim FRectCdS			'소카테고리코드

	Private Sub Class_initialize()
		FResultCount = 0
		FTotalCount = 0
		FPageSize = 5
		FCurrPage = 1
	End Sub	
	
	Private Sub Class_Terminate()
	
	End Sub

	'// 상품목록 접수
	Public Sub getPlussaleList()
	    dim sqlStr, i

	    '// 결과 카운트
	    sqlStr = "exec db_item.[dbo].[sp_Ten_PlusSaleItemList_cnt] '" & FRectCdL & "', '" & FRectCdM & "', '" & FRectCdS & "', " & FPageSize
	    rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
    	rsget.Open sqlStr,dbget
			FTotalCount	= rsget(0)
			FTotalPage	= rsget(1)
		rsget.Close

		'//목록
	    sqlStr = "exec db_item.[dbo].[sp_Ten_PlusSaleItemList] '" & FRectCdL & "', '" & FRectCdM & "', '" & FRectCdS & "', " & FCurrPage & ", " & FPageSize & ", '" & FRectSortMethod & "'"
	    rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
	    rsget.pagesize = FPageSize
	    rsget.Open sqlStr,dbget
	    
	    FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutePage=FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID		= rsget("itemid")
				FItemList(i).FItemName		= db2html(rsget("itemname"))
				FItemList(i).FImageList	    = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
				FItemList(i).FImageicon1	= "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("icon1image")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).FBrandName		= db2html(rsget("brandname"))
				FItemList(i).FMakerID		= db2html(rsget("makerid"))
                FItemList(i).FOrgPrice      = rsget("orgprice")
                FItemList(i).FSaleYn        = rsget("SaleYn")
                FItemList(i).FSellYn        = rsget("sellyn")
                FItemList(i).FLimitYn       = rsget("limityn")
                FItemList(i).FLimitNo       = rsget("limitno")
                FItemList(i).FLimitSold     = rsget("limitsold")

				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	=	rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				
				FItemList(i).FSpecialUserItem = rsget("specialuseritem")
				
				FItemList(i).Freviewcnt         = rsget("evalCnt")
				FItemList(i).FFavCount   	   = rsget("favcount")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end Sub

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
%>
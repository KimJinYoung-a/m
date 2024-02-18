<%
'' Require iteminfoCls.asp

class CMyFavoriteCateCnt
    public FCdL
    public FCount

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class


Class CMyFavorite
	public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectUserID
	public FRectCDL
	public FRectDisp
	public FRectSortMethod
	public FFolderIdx
	public FOldFolderIdx
    public FRectOrderType
    public FFolderName
	public fviewisusing
    public FWishEventPrice
    public FWishEventTotalCnt
    public FItemID
    public Fevtcode
	Public FRectMinprice

	Public FExB2BItemYn '// B2B상품 제외 여부

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

    public function GetCateFavCount(byval iCdL)
        '' Using Only CMyFavoriteCateCnt
        dim i

        GetCateFavCount = 0

        for i=0 to FResultCount-1
            if (FItemList(i).FCDL=iCdL) then
                GetCateFavCount = FItemList(i).FCount
                Exit function
            end if
        next
    end function

    public Sub getMyWishCateCount()
        dim sqlStr, i

        sqlStr = " select i.cate_large, Count(f.itemid) as Cnt"
        sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f, [db_item].[dbo].tbl_item i" + VbCrlf
	sqlStr = sqlStr + " where f.userid='" + FRectUserID + "'" + VbCrlf
	sqlStr = sqlStr + " and f.itemid=i.itemid" + VbCrlf
	sqlStr = sqlStr + " and f.fidx="+Cstr(FFolderIdx) + VbCrlf
	sqlStr = sqlStr + " group by i.cate_large"

		rsget.Open sqlStr,dbget,1

		FTotalCount  = 0
		FResultCount = rsget.RecordCount

		if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)

		if Not rsget.Eof then
		    do until rsget.eof
				set FItemList(i)    = new CMyFavoriteCateCnt
    		    FItemList(i).FCDL   = rsget("cate_large")
    		    FItemList(i).FCount = rsget("Cnt")

    		    FTotalCount         = FTotalCount + FItemList(i).FCount
    		    i=i+1
    		    rsget.MoveNext
    		loop
		end if
		rsget.close

    end Sub

	public Sub getMyWishList()
		dim sqlStr, i

		sqlStr = "select count(f.itemid) as cnt " + VbCrlf
		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f, [db_item].[dbo].tbl_item i" + VbCrlf
		sqlStr = sqlStr + " where f.userid='" + FRectUserID + "'" + VbCrlf
		sqlStr = sqlStr + " and f.itemid=i.itemid" + VbCrlf
		sqlStr = sqlStr + " and f.fidx="+Cstr(FFolderIdx) + VbCrlf
		if FRectCDL<>"" then
			sqlStr = sqlStr + " and i.cate_large='" + FRectCDL + "'" + VbCrlf
		end if
		If FExB2BItemYn = "Y" Then '// B2B상품 제외
			sqlStr = sqlStr + " and i.itemdiv <> '23'" + VbCrlf
		End If

        if FRectSortMethod="coupon" then
            sqlStr = sqlStr + " and i.itemcouponyn='Y'"
        elseif FRectSortMethod="saleop" then
            sqlStr = sqlStr + " and i.sailyn='Y'"
        elseif FRectSortMethod="limit" then
            sqlStr = sqlStr + " and i.limityn='Y'"
        elseif FRectSortMethod="newitem" then
            sqlStr = sqlStr + " and datediff(day, i.regdate,getdate()) <=14"
        end if

		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.close

		sqlStr = "select top " + CStr(FPageSize*FCurrPage) + " f.itemid, i.itemname, i.sellcash, i.orgprice, i.makerid, i.brandname, " + VbCrlf
		sqlStr = sqlStr + " i.sellyn, i.sailyn, i.itemgubun, " + VbCrlf
		sqlStr = sqlStr + " i.limityn, limitno, limitsold, i.listimage, i.listimage120, i.smallimage, i.sailprice, i.optioncnt, i.evalcnt," + VbCrlf
		sqlStr = sqlStr + " i.specialuseritem, i.itemcouponyn, i.itemcoupontype, i.itemcouponvalue, i.curritemcouponidx, i.regdate as itemregdate, i.itemdiv, i.deliverytype, " + VbCrlf
		sqlStr = sqlStr + " c.favcount, i.basicimage600, i.basicimage, f.regdate " + VbCrlf
		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f, [db_item].[dbo].tbl_item i" + VbCrlf
		sqlStr = sqlStr + "		inner join [db_item].[dbo].[tbl_item_contents] as c on i.itemid = c.itemid " + VbCrlf
		sqlStr = sqlStr + " where f.userid='" + FRectUserID + "'" + VbCrlf
		sqlStr = sqlStr + " and f.itemid=i.itemid" + VbCrlf
		sqlStr = sqlStr + " and f.fidx="+Cstr(FFolderIdx) + VbCrlf
		if FRectCDL<>"" then
			sqlStr = sqlStr + " and i.cate_large='" + FRectCDL + "'" + VbCrlf
		end if

		if FRectSortMethod="coupon" then
            sqlStr = sqlStr + " and i.itemcouponyn='Y'"
        elseif FRectSortMethod="saleop" then
            sqlStr = sqlStr + " and i.sailyn='Y'"
        elseif FRectSortMethod="limit" then
            sqlStr = sqlStr + " and i.limityn='Y'"
        elseif FRectSortMethod="newitem" then
            sqlStr = sqlStr + " and datediff(day, i.regdate,getdate()) <=14"
        end if
		If FExB2BItemYn = "Y" Then '// B2B상품 제외
			sqlStr = sqlStr + " and i.itemdiv <> '23'" + VbCrlf
		End If

		if FRectOrderType="new" then
		    sqlStr = sqlStr + " order by i.itemid desc"
		elseif FRectOrderType="fav" then
		    sqlStr = sqlStr + " order by i.itemscore desc, i.itemid desc"
		elseif FRectOrderType="highprice" then
		    sqlStr = sqlStr + " order by i.sellcash desc"
		elseif FRectOrderType="lowprice" then
		    sqlStr = sqlStr + " order by i.sellcash asc"
		else
		    sqlStr = sqlStr + " order by f.regdate desc"
		end if

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i)          = new CCategoryPrdItem

				FItemList(i).FItemID        = rsget("itemid")
				FItemList(i).FItemName      = db2html(rsget("itemname"))
				FItemList(i).Fmakerid       = rsget("makerid")
				FItemList(i).FBrandName     = db2html(rsget("brandname"))

				FItemList(i).FSellcash      = rsget("sellcash")
				FItemList(i).Fitemgubun     = rsget("itemgubun")
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("smallimage")
				If isNull(rsget("basicimage600")) Then
					FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
				Else
					FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage600")
				End If
				FItemList(i).FImageList120  = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage120")

				''품절된 상품중 이미지 없는것들 있음..
				if IsNULL(FItemList(i).FImageList120) then
				    FItemList(i).FImageList120 = FItemList(i).FImageList
				elseif (rsget("listimage120")="") then
				    FItemList(i).FImageList120 = FItemList(i).FImageList
				end if

				FItemList(i).FSellYn    = rsget("sellyn")
				FItemList(i).FLimitYn   = rsget("limityn")
				FItemList(i).FLimitNo   = rsget("limitno")
				FItemList(i).FLimitSold = rsget("limitsold")
				FItemList(i).FOptioncnt	= rsget("optioncnt")
                		FItemList(i).FItemDiv 	= rsget("itemdiv")		'?�품 ?�성

				FItemList(i).FSaleYn        = rsget("sailyn")
				''FItemList(i).FSalePrice     = rsget("sailprice")
				FItemList(i).FOrgPrice      = rsget("orgprice")
				FItemList(i).FSpecialUserItem   = rsget("specialuseritem")

				FItemList(i).Fitemcouponyn 		= rsget("itemcouponyn")
				FItemList(i).Fitemcoupontype 	= rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue 	= rsget("itemcouponvalue")
				FItemList(i).Fcurritemcouponidx = rsget("curritemcouponidx")

				FItemList(i).FRegdate           = rsget("itemregdate")
				FItemList(i).Fevalcnt           = rsget("evalcnt")
				FItemList(i).Fdeliverytype		= rsget("deliverytype")
				FItemList(i).Fregdate			= rsget("regdate")
				FItemList(i).FFavCount			= rsget("favcount")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end sub


public Sub getMyWishListNoFidx()
		dim sqlStr, i

		sqlStr = "select count(f.itemid) as cnt " + VbCrlf
		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f, [db_item].[dbo].tbl_item i" + VbCrlf
		sqlStr = sqlStr + " where f.userid='" + FRectUserID + "'" + VbCrlf
		sqlStr = sqlStr + " and f.itemid=i.itemid" + VbCrlf
		if FRectCDL<>"" then
			sqlStr = sqlStr + " and i.cate_large='" + FRectCDL + "'" + VbCrlf
		end if

        if FRectSortMethod="coupon" then
            sqlStr = sqlStr + " and i.itemcouponyn='Y'"
        elseif FRectSortMethod="saleop" then
            sqlStr = sqlStr + " and i.sailyn='Y'"
        elseif FRectSortMethod="limit" then
            sqlStr = sqlStr + " and i.limityn='Y'"
        elseif FRectSortMethod="newitem" then
            sqlStr = sqlStr + " and datediff(day, i.regdate,getdate()) <=14"
        end if

		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.close

		sqlStr = "select top " + CStr(FPageSize*FCurrPage) + " f.itemid, i.itemname, i.sellcash, i.orgprice, i.makerid, i.brandname, " + VbCrlf
		sqlStr = sqlStr + " i.sellyn, i.sailyn, i.itemgubun, " + VbCrlf
		sqlStr = sqlStr + " i.limityn, limitno, limitsold, i.listimage, i.listimage120, i.smallimage, i.sailprice, i.optioncnt, i.evalcnt," + VbCrlf
		sqlStr = sqlStr + " i.specialuseritem, i.itemcouponyn, i.itemcoupontype, i.itemcouponvalue, i.curritemcouponidx, i.regdate as itemregdate "
		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f, [db_item].[dbo].tbl_item i" + VbCrlf
		sqlStr = sqlStr + " where f.userid='" + FRectUserID + "'" + VbCrlf
		sqlStr = sqlStr + " and f.itemid=i.itemid" + VbCrlf
		if FRectCDL<>"" then
			sqlStr = sqlStr + " and i.cate_large='" + FRectCDL + "'" + VbCrlf
		end if

		if FRectSortMethod="coupon" then
            sqlStr = sqlStr + " and i.itemcouponyn='Y'"
        elseif FRectSortMethod="saleop" then
            sqlStr = sqlStr + " and i.sailyn='Y'"
        elseif FRectSortMethod="limit" then
            sqlStr = sqlStr + " and i.limityn='Y'"
        elseif FRectSortMethod="newitem" then
            sqlStr = sqlStr + " and datediff(day, i.regdate,getdate()) <=14"
        end if


		sqlStr = sqlStr + " order by f.fidx,  f.regdate desc"

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i)          = new CCategoryPrdItem

				FItemList(i).FItemID        = rsget("itemid")
				FItemList(i).FItemName      = db2html(rsget("itemname"))
				FItemList(i).Fmakerid       = rsget("makerid")
				FItemList(i).FBrandName     = db2html(rsget("brandname"))

				FItemList(i).FSellcash      = rsget("sellcash")
				FItemList(i).Fitemgubun     = rsget("itemgubun")
				FItemList(i).FImageList     = "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage")
				FItemList(i).FImageSmall    = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("smallimage")
               		 FItemList(i).FImageList120  = "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("listimage120")

				''품절된 상품중 이미지 없는것들 있음..
				if IsNULL(FItemList(i).FImageList120) then
				    FItemList(i).FImageList120 = FItemList(i).FImageList
				elseif (rsget("listimage120")="") then
				    FItemList(i).FImageList120 = FItemList(i).FImageList
				end if

				FItemList(i).FSellYn    = rsget("sellyn")
				FItemList(i).FLimitYn   = rsget("limityn")
				FItemList(i).FLimitNo   = rsget("limitno")
				FItemList(i).FLimitSold = rsget("limitsold")
				FItemList(i).FOptioncnt	= rsget("optioncnt")


				FItemList(i).FSaleYn        = rsget("sailyn")
				''FItemList(i).FSalePrice     = rsget("sailprice")
				FItemList(i).FOrgPrice      = rsget("orgprice")
				FItemList(i).FSpecialUserItem   = rsget("specialuseritem")

				FItemList(i).Fitemcouponyn 		= rsget("itemcouponyn")
				FItemList(i).Fitemcoupontype 	= rsget("itemcoupontype")
				FItemList(i).Fitemcouponvalue 	= rsget("itemcouponvalue")
				FItemList(i).Fcurritemcouponidx = rsget("curritemcouponidx")

				FItemList(i).FRegdate           = rsget("itemregdate")
				FItemList(i).Fevalcnt           = rsget("evalcnt")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end sub

	 public Sub delete(itemarray)
		dim sqlStr, i, oneitem, buf

		oneitem = Split(itemarray, ";")
		for i=0 to UBound(oneitem)
				  buf = Split(oneitem(i), ",")
				  if (UBound(buf) < 2) then exit for end if
		  sqlStr = "delete from [db_my10x10].[dbo].tbl_myfavorite" + VbCrlf
		  sqlStr = sqlStr + " where userid='" + FRectUserID + "'" + VbCrlf
		  sqlStr = sqlStr + " and itemid=" + CStr(buf(0))  +" and fidx= "+Cstr(FFolderIdx)+ VbCrlf
		  rsget.Open sqlStr,dbget,1
		  'response.write sqlStr
		next
	 end Sub

	 public Sub selectdelete(itemarray)
		dim sqlStr, i, oneitem, buf

		if (Left(itemarray,1)=",") then itemarray = Mid(itemarray,2,1024)
		if (Right(itemarray,1)=",") then itemarray = Left(itemarray,Len(itemarray) - 1)


		  sqlStr = "delete from [db_my10x10].[dbo].tbl_myfavorite" + VbCrlf
		  sqlStr = sqlStr + " where userid='" + FRectUserID + "'" + VbCrlf
		  sqlStr = sqlStr + " and itemid in (" + itemarray + ")" +" and fidx= "+Cstr(FFolderIdx)+ VbCrlf
		  rsget.Open sqlStr,dbget,1
		  'response.write sqlStr

	 end Sub


	'//���û�ǰ ���
	public Sub selectedinsert(itemarray)
		if (Left(itemarray,1)=",") then itemarray = Mid(itemarray,2,1024)
		if (Right(itemarray,1)=",") then itemarray = Left(itemarray,Len(itemarray) - 1)
		IF FFolderIdx = "" THEN FFolderIdx =0

		itemarray = split(itemarray,",")
		dbget.beginTrans
		for intloop = 0 to ubound(itemarray)
		    sqlStr = " IF Not Exists(SELECT itemid FROM [db_my10x10].[dbo].tbl_myfavorite WHERE userid ='" + FRectUserID + "' and itemid=" & itemarray(intLoop) & " and fidx="&FFolderIdx&" ) "
		    sqlStr = sqlStr + "	BEGIN " + VbCrlf
		    sqlStr = sqlStr + " insert into [db_my10x10].[dbo].tbl_myfavorite" + VbCrlf
		    sqlStr = sqlStr + " (userid,itemid,fidx,viewIsUsing)" + VbCrlf
		    sqlStr = sqlStr + " select '" + FRectUserID + "'," + CStr( itemarray(intLoop)) + ","+Cstr(FFolderIdx)+",isNull((select top 1 viewIsUsing from [db_my10x10].[dbo].tbl_myfavorite_folder where fidx="+Cstr(FFolderIdx)+"),'N')" + VbCrlf
		    sqlStr = sqlStr + "	END " + VbCrlf
		    dbget.Execute sqlStr
    		next

    		If dbget.Errors.Count <> 0 Then
    			dbget.RollbackTrans
		Else
    			dbget.CommitTrans
		End If
	End Sub

	'// 공개여부 Y 위시리스트 가져오기 '2010.04.09 한용민 추가
	public Sub iteminsert(itemid)
		IF FFolderIdx = "" THEN FFolderIdx =0
		 sqlStr = " IF Not Exists(SELECT itemid FROM [db_my10x10].[dbo].tbl_myfavorite WHERE userid ='" + FRectUserID + "' and itemid=" & itemid & " and fidx="&FFolderIdx&" ) "
		    sqlStr = sqlStr + "	BEGIN " + VbCrlf
		    sqlStr = sqlStr + " insert into [db_my10x10].[dbo].tbl_myfavorite" + VbCrlf
		    sqlStr = sqlStr + " (userid,itemid,fidx,viewIsUsing)" + VbCrlf
		    sqlStr = sqlStr + " select '" + FRectUserID + "'," + CStr(itemid) + ","+Cstr(FFolderIdx)+",isNull((select top 1 viewIsUsing from [db_my10x10].[dbo].tbl_myfavorite_folder where fidx="+Cstr(FFolderIdx)+"),'N')" + VbCrlf
		    sqlStr = sqlStr + "	END " + VbCrlf
		    dbget.Execute sqlStr
	End Sub

 	'// 새폴더 추가 '2010-04-09 한용민 수정
	public Function fnGetFolderList
		Dim strSql
		strSql ="[db_my10x10].[dbo].sp_Ten_myfavoritefolder_GetList ('"&FRectUserID&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetFolderList = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// ������ �߰�
	public Function fnSetFolder
		Dim objCmd
		Dim intResult

		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_my10x10].[dbo].sp_Ten_myfavoritefolder_insert ('"&FRectUserID&"','"&FFolderName&"','"&fviewisusing&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing

		fnSetFolder = intResult
	End Function

	'//폴더 이동
	public Function fnChangeFolder(itemarray)
	Dim objCmd
	Dim intResult

		if (Left(itemarray,1)=",") then itemarray = Mid(itemarray,2,1024)
		if (Right(itemarray,1)=",") then itemarray = Left(itemarray,Len(itemarray) - 1)
		IF FFolderIdx = "" THEN FFolderIdx =0
		itemarray = split(itemarray,",")
		dbget.beginTrans
		for intloop = 0 to ubound(itemarray)
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_my10x10].[dbo].sp_Ten_myfavoritefolder_Change ('"&FRectUserID&"',"&itemarray(intloop)&","&FFolderIdx&","&FOldFolderIdx&")}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing
		if intResult = 0 THEN
			dbget.RollBackTrans
			exit for
		end if
		next
		dbget.CommitTrans
		fnChangeFolder = intResult
	End Function

	'//폴더명 수정 '2010.04.09 한용민 수정
	public Function fnSetFolderUpdate
	Dim objCmd
	Dim intResult

		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_my10x10].[dbo].sp_Ten_myfavoritefolder_update ("&FFolderIdx&",'"&FFolderName&"','"&fviewisusing&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing

		fnSetFolderUpdate = intResult
	End Function

		'//폴더 삭제
	public Function fnSetFolderDelete
	Dim objCmd
	Dim intResult

		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_my10x10].[dbo].sp_Ten_myfavoritefolder_Delete ('"&FRectUserID&"',"&FFolderIdx&")}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing

		fnSetFolderDelete = intResult
	End Function

	'//폴더 정보 업데이트 (폴더별 상품수, 최근 업데이트 정보; 2013-12-19:허진원)
	public Sub fnUpdateFolderInfo()
		sqlStr = " update A " + VbCrlf
	    sqlStr = sqlStr + "	Set A.itemCnt=isNULL(B.cnt,0) " + VbCrlf
	    sqlStr = sqlStr + "		,A.lastupdate=isNULL(B.updt,getdate()) " + VbCrlf
	    sqlStr = sqlStr + "	from db_my10x10.dbo.tbl_myfavorite_folder as A " + VbCrlf
	    sqlStr = sqlStr + "		LEFT join  ( " + VbCrlf
	    sqlStr = sqlStr + "			select fidx, count(*) cnt, max(isNull(lastupdate,regdate)) updt " + VbCrlf
	    sqlStr = sqlStr + "			from db_my10x10.dbo.tbl_myfavorite " + VbCrlf
	    sqlStr = sqlStr + "			where userid='" + FRectUserID + "' " + VbCrlf
	    sqlStr = sqlStr + "			group by fidx " + VbCrlf
	    sqlStr = sqlStr + "		) as B " + VbCrlf
	    sqlStr = sqlStr + "		on A.fidx=B.fidx " + VbCrlf
	    sqlStr = sqlStr + "	where A.userid='" + FRectUserID + "' and (isNULL(A.itemCnt,0)<>isNULL(B.cnt,0) or A.lastupdate<>B.updt)"  + VbCrlf
		dbget.Execute sqlStr
	End Sub

 	'// ####### 위시리스트 이벤트 #######
	public Function fnWishListEventSave
		Dim strSql
        If (application("Svr_Info") = "Dev" And Fevtcode = "104280") Or (application("Svr_Info") <> "Dev" And Fevtcode = "108614") Then
            Dim itemidList
            itemidList = Split(FItemID, ",")
            For i=0 To UBound(itemidList)
                If itemidList(i) <> "" Then
                    strSql ="[db_my10x10].[dbo].sp_Ten_Wishlist_Event_New ('"&FRectUserID&"','"&FFolderIdx&"','"&itemidList(i)&"','"&Fevtcode&"')"
                    rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
                    IF dbget.errors.count > 0 Then
                        FResultCount = "x"
                    Else
                        FResultCount = "o"
                    END IF
                End If
            Next
        Else
            strSql ="[db_my10x10].[dbo].sp_Ten_Wishlist_Event ('"&FRectUserID&"','"&FFolderIdx&"','"&Fevtcode&"')"
            rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
            IF dbget.errors.count > 0 Then
                FResultCount = "x"
            Else
                FResultCount = "o"
            END IF
        End If
	End Function

	public Function fnWishListEventView
		Dim strSql
		strSql ="[db_my10x10].[dbo].sp_Ten_Wishlist_EventView ('"&FRectUserID&"','"&FFolderIdx&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF NOT rsget.Eof Then
			FWishEventPrice = rsget(0)
			FWishEventTotalCnt = rsget(1)
		Else
			FWishEventPrice = 0
			FWishEventTotalCnt = 0
		END IF
		rsget.close
	End Function
	'// ####### 위시리스트 이벤트 END #######

    
	'####### popular 리스트Ʈ -->
	public Function fnPopularList2014 '' �������� �ܼ�ȭ.
	    Dim strSql, i, orderby

		If FRectSortMethod <> "" Then
			SELECT CASE FRectSortMethod
				Case "1" : orderby = "p.regtime desc,"
				Case "2" : orderby = ""	'### 마지막 순서로 itemid desc 가 있음.
				Case "3" : orderby = "p.inCount desc,"
				Case "4" : orderby = "evalcnt desc,"
				Case "5" : orderby = "evalcnt asc,"
				Case "6" : orderby = "newid() asc,"
				Case Else orderby = ""
			END SELECT
		End If

		strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_New_Popularlist_Count_2014] '" & FpageSize & "', '" & FRectDisp & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close


		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_New_Popularlist_2014] '" & (FpageSize*FCurrPage) & "', '" & FRectDisp & "', '" & orderby & "'"
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
					set FItemList(i) = new CCategoryPrdItem

					FItemList(i).FItemID        = rsget("itemid")
					FItemList(i).FInCount       = rsget("inCount")
					FItemList(i).FRegTime       = rsget("regtime")

					If rsget("basicimage600") = "" Then
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					Else
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage600")
					End If

					FItemList(i).Fmakerid       = rsget("makerid")
					FItemList(i).FBrandName     = db2html(rsget("brandname"))
					FItemList(i).FItemName      = db2html(rsget("itemname"))
					FItemList(i).FFavCount      = rsget("favcount")
					''FItemList(i).FCateName		= rsget("code_nm")
					If Cstr(rsget("catecode")) <> "0" Then
						FItemList(i).FDisp		= Cstr(rsget("catecode"))
					End If
                    
                    FItemList(i).FSaleYN        = rsget("sailyn")
				    FItemList(i).Fsellcash      = rsget("sellcash")
				    FItemList(i).FOrgPrice      = rsget("orgprice")
				    FItemList(i).FEvalcnt           = rsget("Evalcnt") 
                    FItemList(i).FFavCount          = rsget("favcount") 
                    
                    FItemList(i).FItemCouponYN      = rsget("itemcouponyn")
                    FItemList(i).FItemCouponType    = rsget("itemcoupontype") 
                    FItemList(i).FItemCouponValue   = rsget("itemcouponvalue") 
                    FItemList(i).FCurrItemCouponIdx = rsget("curritemcouponidx") 
                
                    FItemList(i).Fsellyn        = rsget("sellyn")
                    FItemList(i).Flimityn       = rsget("limityn")
                    FItemList(i).Flimitno       = rsget("limitno")
                    FItemList(i).Flimitsold     = rsget("limitsold")
                    
					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
    end function

	public Function fnPopularList
		Dim strSql, i, orderby

		If FRectSortMethod <> "" Then
			SELECT CASE FRectSortMethod
				Case "1" : orderby = "p.regtime desc,"
				Case "2" : orderby = ""	'### 마지막 순서로 itemid desc 가 있음.
				Case "3" : orderby = "p.inCount desc,"
				Case "4" : orderby = "evalcnt desc,"
				Case "5" : orderby = "evalcnt asc,"
				Case "6" : orderby = "newid() asc,"
				Case Else orderby = ""
			END SELECT
		End If

		strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_New_Popularlist_Count] '" & FpageSize & "', '" & FRectDisp & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close


		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_New_Popularlist] '" & (FpageSize*FCurrPage) & "', '" & FRectDisp & "', '" & FRectUserID & "', '" & orderby & "'"
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
					set FItemList(i) = new CCategoryPrdItem

					FItemList(i).FItemID        = rsget("itemid")
					FItemList(i).FInCount       = rsget("inCount")
					FItemList(i).FRegTime       = rsget("regtime")

					If rsget("basicimage600") = "" Then
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage")
					Else
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("basicimage600")
					End If

					FItemList(i).Fmakerid       = rsget("makerid")
					FItemList(i).FBrandName     = db2html(rsget("brandname"))
					FItemList(i).FItemName      = db2html(rsget("itemname"))
					FItemList(i).FFavCount      = rsget("favcount")
					FItemList(i).FCateName		= rsget("code_nm")
					If Cstr(rsget("catecode")) <> "0" Then
						FItemList(i).FDisp		= Cstr(rsget("catecode"))
					End If

					i=i+1
					rsget.moveNext
				loop
			end if
			rsget.close
		End If
	End Function

    public Function fnPopularList_CT
		Dim strSql, i, orderby

		If FRectSortMethod <> "" Then
			SELECT CASE FRectSortMethod
				Case "1" : orderby = "p.regtime desc,"
				Case "2" : orderby = ""	'### 마지막 순서로 itemid desc 가 있음.
				Case "3" : orderby = "p.inCount desc,"
				Case "4" : orderby = "evalcnt desc,"
				Case "5" : orderby = "evalcnt asc,"
				Case "6" : orderby = "newid() asc,"
				Case Else orderby = ""
			END SELECT
		End If

		strSql = "EXECUTE [db_appWish].[dbo].[sp_Ten_New_Popularlist_Count] '" & FpageSize & "', '" & FRectDisp & "'"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_appWish].[dbo].[sp_Ten_New_Popularlist] '" & (FpageSize*FCurrPage) & "', '" & FRectDisp & "', '" & FRectUserID & "', '" & orderby & "'"
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)

			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CCategoryPrdItem

					FItemList(i).fEval_excludeyn= rsCTget("Eval_excludeyn")
					FItemList(i).FItemID        = rsCTget("itemid")
					FItemList(i).FInCount       = rsCTget("inCount")
					FItemList(i).FRegTime       = rsCTget("regtime")

					If rsCTget("basicimage600") = "" Then
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage")
					Else
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage600")
					End If

					FItemList(i).Fmakerid       = rsCTget("makerid")
					FItemList(i).FBrandName     = db2html(rsCTget("brandname"))
					FItemList(i).FItemName      = db2html(rsCTget("itemname"))
					FItemList(i).FFavCount      = rsCTget("favcount")
					FItemList(i).FEvalCnt		= rsCTget("evalcnt")
					FItemList(i).FEvaluate		= rsCTget("evaluate")
					FItemList(i).FCateName		= rsCTget("code_nm")
					If Cstr(rsCTget("catecode")) <> "0" Then
						FItemList(i).FDisp		= Cstr(rsCTget("catecode"))
					End If

					FItemList(i).FSellCash		= rsCTget("sellcash")
					FItemList(i).FOrgPrice		= rsCTget("orgprice")
					FItemList(i).FSellyn		= rsCTget("sellyn")
					FItemList(i).FSaleyn		= rsCTget("sailyn")
					FItemList(i).FLimityn		= rsCTget("limityn")
					FItemList(i).FItemcouponyn	= rsCTget("itemcouponyn")
					FItemList(i).FItemCouponValue = rsCTget("itemCouponValue")
					FItemList(i).FItemCouponType = rsCTget("itemCouponType")
					FItemList(i).FMyCount		= rsCTget("mycount")
					FItemList(i).FAdultType 	= rsCTget("adultType")
					FItemList(i).FItemOptCount  = rsCTget("optioncnt")

					IF application("Svr_Info") = "Dev" THEN
						FItemList(i).Ftotalpoint = 0
					Else
						FItemList(i).Ftotalpoint = rsCTget("totalpoint")
					End If
					
					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
		End If
	End Function

	public Function fnPopularFashionList_CT
		Dim strSql, i

		strSql = "EXECUTE [db_appWish].[dbo].[usp_Ten_New_FashionPopularlist_Count] '" & FpageSize & "', '" & FRectDisp & "'"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_appWish].[dbo].[usp_Ten_New_FashionPopularlist_Get] '" & (FpageSize*FCurrPage) & "', '" & FRectDisp & "', '" & FRectUserID & "', " & FRectSortMethod & " , "& FRectMinprice &""
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)

			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CCategoryPrdItem

					FItemList(i).fEval_excludeyn= rsCTget("Eval_excludeyn")
					FItemList(i).FItemID        = rsCTget("itemid")
					FItemList(i).FInCount       = rsCTget("inCount")
					FItemList(i).FRegTime       = rsCTget("regtime")

					If rsCTget("basicimage600") = "" Then
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage")
					Else
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage600")
					End If

					FItemList(i).Fmakerid       = rsCTget("makerid")
					FItemList(i).FBrandName     = db2html(rsCTget("brandname"))
					FItemList(i).FItemName      = db2html(rsCTget("itemname"))
					FItemList(i).FFavCount      = rsCTget("favcount")
					FItemList(i).FEvalCnt		= rsCTget("evalcnt")
					FItemList(i).FEvaluate		= rsCTget("evaluate")
					FItemList(i).FCateName		= rsCTget("code_nm")
					If Cstr(rsCTget("catecode")) <> "0" Then
						FItemList(i).FDisp		= Cstr(rsCTget("catecode"))
					End If

					FItemList(i).FSellCash		= rsCTget("sellcash")
					FItemList(i).FOrgPrice		= rsCTget("orgprice")
					FItemList(i).FSellyn		= rsCTget("sellyn")
					FItemList(i).FSaleyn		= rsCTget("sailyn")
					FItemList(i).FLimityn		= rsCTget("limityn")
					FItemList(i).FItemcouponyn	= rsCTget("itemcouponyn")
					FItemList(i).FItemCouponValue = rsCTget("itemCouponValue")
					FItemList(i).FItemCouponType = rsCTget("itemCouponType")
					FItemList(i).FMyCount		= rsCTget("mycount")

					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
		End If
	End Function

	public Function fnPopularLivingList_CT
		Dim strSql, i

		strSql = "EXECUTE [db_appWish].[dbo].[usp_Ten_New_FashionPopularlist_Count] '" & FpageSize & "', '" & FRectDisp & "'"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_appWish].[dbo].[usp_WWW_LivingPopularList_Get] '" & (FpageSize*FCurrPage) & "', '" & FRectDisp & "', "& FRectMinprice &""
			rsCTget.CursorLocation = adUseClient
			rsCTget.CursorType = adOpenStatic
			rsCTget.LockType = adLockOptimistic
			rsCTget.pagesize = FPageSize
			rsCTget.Open strSql,dbCTget,1

			FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
	        if (FResultCount<1) then FResultCount=0
			redim preserve FItemList(FResultCount)

			i=0
			if  not rsCTget.EOF  then
				rsCTget.absolutepage = FCurrPage
				do until rsCTget.eof
					set FItemList(i) = new CCategoryPrdItem

					FItemList(i).FItemID        = rsCTget("itemid")
					FItemList(i).FInCount       = rsCTget("inCount")
					FItemList(i).FRegTime       = rsCTget("regtime")

					If rsCTget("basicimage600") = "" Then
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage")
					Else
						FItemList(i).FImageBasic	= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsCTget("basicimage600")
					End If

					FItemList(i).Fmakerid       = rsCTget("makerid")
					FItemList(i).FBrandName     = db2html(rsCTget("brandname"))
					FItemList(i).FItemName      = db2html(rsCTget("itemname"))
					FItemList(i).FFavCount      = rsCTget("favcount")
					FItemList(i).FEvalCnt		= rsCTget("evalcnt")
					FItemList(i).FSellCash		= rsCTget("sellcash")
					FItemList(i).FOrgPrice		= rsCTget("orgprice")
					FItemList(i).FSellyn		= rsCTget("sellyn")
					FItemList(i).FSaleyn		= rsCTget("sailyn")
					FItemList(i).FLimityn		= rsCTget("limityn")
					FItemList(i).FItemcouponyn	= rsCTget("itemcouponyn")
					FItemList(i).FItemCouponValue = rsCTget("itemCouponValue")
					FItemList(i).FItemCouponType = rsCTget("itemCouponType")					

					i=i+1
					rsCTget.moveNext
				loop
			end if
			rsCTget.close
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


'//ī�װ���
function drawwishcategory(stats)
	dim userquery, tem_str

	response.write "<option value=''"
		if stats ="" then
			response.write " selected"
		end if
	response.write ">��ü ī�װ���</option>"

		userquery = "select L.code_large, L.code_nm"
		userquery = userquery + " from db_item.dbo.tbl_Cate_large as L "
		userquery = userquery + " where L.display_yn = 'Y' and L.code_large <> '999' "
		userquery = userquery + " order by orderNo asc"

	rsget.Open userquery, dbget, 1
	'response.write userquery&"<br>"

	if not rsget.EOF then
		do until rsget.EOF
			if cstr(stats) = cstr(rsget("code_large")) then
				tem_str = " selected"
			end if
			response.write "<option value='" & rsget("code_large") & "' " & tem_str & ">" & rsget("code_nm") & "</option>"
			tem_str = ""
			rsget.movenext
		loop
	end if
	rsget.close
End Function



'// 위시액션(하루에 5개 이상담으면 쿠폰발급)
Function fnWishActionCoupon(uid)
	Dim strQuery
	strQuery ="[db_event].[dbo].sp_Ten_event_WishAction_coupon ('"&uid&"')"
	rsget.Open strQuery, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnWishActionCoupon = rsget(0)
		ELSE
			fnWishActionCoupon = null
		END If
	rsget.close
End Function

''2015/11/23 위시액션(하루에 5개 이상담으면 쿠폰발급) APP
Function fnWishActionCouponInApp(uid)
	Dim sqlStr
	
	sqlStr ="db_event.dbo.sp_Ten_event_WishAction_coupon_InAPP('"&uid&"')"

    if (Trim(uid)="") then 
        fnWishActionCouponInApp="0"
        exit function
    end if
 
if (uid<>"icommang") then
  ''exit function  
end if


	Dim objCmd
	Dim intResult
	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = dbget
		.CommandType = adCmdText
		.CommandText = "{?=call "&sqlStr&" }"
		objCmd(0).Direction =adParamReturnValue
		.Execute, , adExecuteNoRecords
	End With
		intResult = objCmd(0).Value
	Set objCmd = nothing
	
	fnWishActionCouponInApp = intResult
	
End Function
%>
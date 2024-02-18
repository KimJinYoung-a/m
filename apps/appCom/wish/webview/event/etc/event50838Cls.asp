<%
'####################################################
' Description : 어머, 이건 담아야해_APP 런칭 이벤트 2차(APP)
' History : 2014.04.11 유태욱
'####################################################

function getnowdate()
	dim nowdate
	
	nowdate = date()
	'nowdate = "2014-05-12"
	
	getnowdate = nowdate
end function

function currenttime()
	dim tmpcurrenttime
	
	tmpcurrenttime = now()
	'tmpcurrenttime = #05/12/2014 18:00:00#
	
	currenttime = tmpcurrenttime
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21145
	Else
		evt_code   =  50838
	End If
	
	getevt_code = evt_code
end function

Class Cevent50838_list
	public FItemList()
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectDisp
	public FRectUserID
	public FRectCDL
	public FRectSortMethod
	public FFolderIdx
	public FOldFolderIdx
	public FRectOrderType
	public FFolderName
	
	public fviewisusing
	public FWishEventPrice
	public FWishEventTotalCnt
	public FRectviewisusing
	public FRectdeliType
	public FRectSellScope

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

	public Function fnGetFolderList
		Dim strSql, i, arrRst, chkBF: chkBF=false
		strSql ="[db_my10x10].[dbo].sp_Ten_myfavoritefolder_GetList2 ('"&FRectUserID&"')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrRst = rsget.GetRows()

			'기본폴더 존재 여부 확인
			for i=0 to ubound(arrRst,2)
				if arrRst(0,i)="0" then
					chkBF = true
					exit for
				end if
			next

			'// 기본폴더 없으면 기본폴더 추가
			if Not(chkBF) then
				dim tmpArr
				redim tmpArr(3,ubound(arrRst,2)+1)
				tmpArr(0,0) = 0
				tmpArr(1,0) = "기본폴더"
				tmpArr(2,0) = "N"
				tmpArr(3,0) = 0

				for i=0 to ubound(arrRst,2)
					tmpArr(0,i+1) = arrRst(0,i)
					tmpArr(1,i+1) = arrRst(1,i)
					tmpArr(2,i+1) = arrRst(2,i)
					tmpArr(3,i+1) = arrRst(3,i)
				next
				arrRst = tmpArr
			end if
		END IF

		'결과 반환
		fnGetFolderList = arrRst
		rsget.close
	End Function

	public Sub getMyWishList()
		dim sqlStr, addSql, i

		'// 추가 쿼리 작성
		if FRectviewisusing <> "" then
			addSql = addSql + " and b.viewisusing = 'Y'" + VbCrlf
		end if
		
        if FRectSortMethod="coupon" then
            addSql = addSql + " and i.itemcouponyn='Y'"
        elseif FRectSortMethod="saleop" then
            addSql = addSql + " and i.sailyn='Y'"
        elseif FRectSortMethod="limit" then
            addSql = addSql + " and i.limityn='Y'"
        elseif FRectSortMethod="newitem" then
            addSql = addSql + " and datediff(day, i.regdate,getdate()) <=14"          
        end if

		if FRectdeliType="TN" then
			'텐바이텐 배송
			addSql = addSql & " and (deliverytype='1' or deliverytype='4') "
		end if

		if FRectSellScope="Y" then
			'품절상품 제외
			addSql = addSql & " and (sellyn='Y') "
		end if

		'// 상품 전시 카테고리
		if FRectDisp<>"" then
			addSql = addSql & " and i.dispcate1='" & left(FRectDisp,3) & "' "
		end if

		'// 본문 접수
		sqlStr = "select top " + CStr(FPageSize*FCurrPage)
		sqlStr = sqlStr + " f.itemid, i.itemname, i.sellcash, i.orgprice, (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid, i.brandname" + VbCrlf
		sqlStr = sqlStr + " , i.sellyn, i.sailyn, i.itemgubun, i.limityn, limitno, limitsold, i.listimage" + VbCrlf
		sqlStr = sqlStr + " , i.icon1Image, i.icon2Image, i.listimage120, i.smallimage, i.sailprice, i.optioncnt, i.evalcnt, i.specialuseritem" + VbCrlf
		sqlStr = sqlStr + " , i.itemcouponyn, i.itemcoupontype, i.itemcouponvalue, i.curritemcouponidx" + VbCrlf
		sqlStr = sqlStr + " , i.regdate as itemregdate, i.itemdiv, i.deliverytype, t.favcount " + VbCrlf
		sqlStr = sqlStr + " from [db_my10x10].[dbo].tbl_myfavorite f" + VbCrlf
		sqlStr = sqlStr + " join [db_item].[dbo].tbl_item i " + VbCrlf
		sqlStr = sqlStr + " on f.itemid=i.itemid " + VbCrlf
		sqlStr = sqlStr + " join [db_item].[dbo].tbl_item_contents t " + VbCrlf
		sqlStr = sqlStr + "	on i.itemid=t.itemid " + VbCrlf
		sqlStr = sqlStr + " left join [db_my10x10].dbo.tbl_myfavorite_folder b" + VbCrlf
		sqlStr = sqlStr + " on f.fidx = b.fidx" + VbCrlf
		sqlStr = sqlStr + " where i.isusing='Y' and i.sellyn<>'N' and f.userid='" + FRectUserID + "'" & addSql + VbCrlf

		if FRectOrderType="new" then
		    sqlStr = sqlStr + " order by i.itemid desc"
		elseif FRectOrderType="fav" then
		    sqlStr = sqlStr + " order by i.itemscore desc, i.itemid desc"
		elseif FRectOrderType="highprice" then
		    sqlStr = sqlStr + " order by i.sellcash desc"
		elseif FRectOrderType="lowprice" then
		    sqlStr = sqlStr + " order by i.sellcash asc"
        elseif FRectOrderType="ran" then
            sqlStr = sqlStr + " order by newid()"
		else
		    sqlStr = sqlStr + " order by f.regdate desc"
		end if

		rsget.pagesize = FPageSize

		'response.write sqlStr &"<br>"
		rsget.Open sqlStr, dbget, 1

'		FtotalPage =  CInt(FTotalCount\FPageSize)
'		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
'			FtotalPage = FtotalPage +1
'		end if
'		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		FTotalCount=rsget.recordcount
		FResultCount=rsget.recordcount
		
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
				FItemList(i).FImageIcon1	= "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon1Image")
				FItemList(i).FImageIcon2	= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemID) + "/" + rsget("icon2Image")

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
                		FItemList(i).FItemDiv 	= rsget("itemdiv")		'상품 속성

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
				FItemList(i).FfavCount          = rsget("favcount")
				FItemList(i).Fdeliverytype      = rsget("deliverytype")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
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
end Class
%>
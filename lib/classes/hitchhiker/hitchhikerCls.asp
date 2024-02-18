<%
'###########################################################
' Description : 히치하이커 프론트페이지 클래스
' Hieditor : 2014.08.07 유태욱 생성
'###########################################################
%>
<%
class CHitchhikerItem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public Fidx
	public FReqcash
	public FReqTitle
	public FReqSdate
	public FReqEdate
	public FReqgubun
	public FReqlinkurl
	public FReqIsusing
	public FReqSortnum
	public FreqRegdate
	public FReqmileage
	public FReqpreview_detail
	public FReqpreview_thumbimg
	public FReqcon_viewthumbimg
	public FReqmovie
	public Freqimghtmltext
	public Freqissueimg
	
	public Fvol1
	public Fvol2
	public FimgCnt
	public FIsusing
	public Fsortnum
	public FRegdate
	public Fdetailidx
	public Fmasteridx
	public Fpreviewimg
	public FDevicename
	public FContentsSize
	public FContentslink
	public Fcontentsidx

	public Fdevice
end class

class CHitchhikerlist
	public FItemList()
	Public Fgubun
	Public FIsusing
	public FrectIdx
	Public FOneItem
	public FCurrPage
	public FPageSize
	public FPageCount
	public FTotalPage
	public FTotalCount
	public FScrollCount
	public FResultCount
	public FValiddate
	Public Frecttitle	
	public Frectisusing
	public Frectmasteridx
	public FrectCurrentpreview
	public Frectcontentsidx
	public FTotCnt
	public FItemArr
	public frectmakerid
	public frectsoldoutyn
	public frectsortno

	public Frectdevice

	public Function fnGetHitList
		dim sqlStr, sqlsearch, i

		if frectmakerid<>"" then
			sqlsearch = sqlsearch & " and i.makerid='"& frectmakerid &"'"
		end if
		if frectsoldoutyn="Y" then
			sqlsearch = sqlsearch & " and i.sellyn='Y'"
			sqlsearch = sqlsearch & " and (case"
			sqlsearch = sqlsearch & " 	when i.limityn='Y' then"
			sqlsearch = sqlsearch & " 		(case when ((i.limitno-i.limitsold)<=0) then '2' else '1' end)"
			sqlsearch = sqlsearch & " 	Else '1' end)='1'"
		end if

		'총 갯수 구하기
		sqlStr = "select count(*) as cnt"
		sqlStr = sqlStr & " FROM [db_item].[dbo].tbl_item as i"
		sqlStr = sqlStr & " LEFT JOIN [db_item].[dbo].[tbl_item_contents] AS c"
		sqlStr = sqlStr & " 	ON i.itemid = c.itemid "
		sqlStr = sqlStr & " WHERE i.isusing='Y' and i.sellyn in ('Y','S') " & sqlsearch

		'response.write sqlStr &"<br>"	
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
				
		'데이터 리스트 	
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage)
		sqlStr = sqlStr & " i.itemid, i.itemname, i.sellcash,i.orgprice"
		sqlStr = sqlStr & " ,(Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid"
		sqlStr = sqlStr & " ,i.brandname, i.listimage,i.listimage120, i.smallImage, i.sellyn, i.sailyn, i.limityn,i.limitno, i.limitsold,i.regdate,i.reipgodate"
		sqlStr = sqlStr & " ,itemcouponYn, itemCouponValue, itemCouponType, i.evalCnt, i.itemScore, icon1image, i.icon2image, '', i.itemdiv "
		sqlStr = sqlStr & " ,case i.limityn when 'Y' then case when ((i.limitno-i.limitsold)<=0) then '2' else '1' end Else '1' end as lsold "
		sqlStr = sqlStr & " ,i.basicimage, i.basicimage600, c.favcount ,isNull(convert(int,(ROUND(eps.TotalPoint,2)*100)),0) as totalpoint"
		sqlStr = sqlStr & " FROM [db_item].[dbo].tbl_item as i"
		sqlStr = sqlStr & " LEFT JOIN [db_item].[dbo].[tbl_item_contents] AS c"
		sqlStr = sqlStr & " 	ON i.itemid = c.itemid "
		sqlStr = sqlStr & " Left Join [db_board].[dbo].[tbl_const_eval_PointSummary] as eps WITH (NOLOCK) on eps.itemid=i.itemid"
		sqlStr = sqlStr & " WHERE i.isusing='Y' and i.sellyn in ('Y','S') " & sqlsearch
		
		if frectsortno="new" then
			sqlStr = sqlStr & " order by i.itemid desc"
		elseif frectsortno="best" then
			sqlStr = sqlStr & " order by i.itemscore desc"
		elseif frectsortno="min" then
			sqlStr = sqlStr & " order by i.sellcash asc"
		elseif frectsortno="max" then
			sqlStr = sqlStr & " order by i.sellcash desc"
		else
			sqlStr = sqlStr & " order by i.itemid desc"
		end if
		
		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).FItemID       = rsget("itemid")
				IF i =0 THEN
					FItemArr = 	FItemList(i).FItemID
				ELSE
					FItemArr = FItemArr&","&FItemList(i).FItemID
				END IF
				FItemList(i).FItemName    = db2html(rsget("itemname"))
				FItemList(i).FSellcash    = rsget("sellcash")
				FItemList(i).FOrgPrice   	= rsget("orgprice")
				FItemList(i).FMakerId   	= db2html(rsget("makerid"))
				FItemList(i).FBrandName  	= db2html(rsget("brandname"))
				FItemList(i).FSellYn      = rsget("sellyn")
				FItemList(i).FSaleYn     	= rsget("sailyn")
				FItemList(i).FLimitYn     = rsget("limityn")
				FItemList(i).FLimitNo     = rsget("limitno")
				FItemList(i).FLimitSold   = rsget("limitsold")
				FItemList(i).FRegdate 		= rsget("regdate")
				FItemList(i).FReipgodate		= rsget("reipgodate")
                FItemList(i).Fitemcouponyn 	= rsget("itemcouponYn")
				FItemList(i).FItemCouponValue= rsget("itemCouponValue")
				FItemList(i).Fitemcoupontype	= rsget("itemCouponType")
				FItemList(i).Fevalcnt 		= rsget("evalCnt")
				FItemList(i).FitemScore 		= rsget("itemScore")
				FItemList(i).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage")
				FItemList(i).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("listimage120")
				FItemList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("smallImage")
				FItemList(i).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon1image")
				FItemList(i).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("icon2image")
				FItemList(i).FItemSize	= rsget("evalCnt")
				FItemList(i).Fitemdiv		= rsget("itemdiv")
				FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage")
				'FItemList(i).FImageBasic600 = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(rsget("itemid"))&"/"& rsget("basicimage600")
				FItemList(i).FfavCount	= rsget("favcount")
				FItemList(i).FPoints	= rsget("totalpoint")
																	
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	End Function

	'###### 히치하이커 메인배너 리스트 ######
	Public Sub fnGetmainbanner
		Dim sqlStr, i, sqladd

		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_mainbannerlist '"& FrectCurrentpreview &"', '" & CStr(FPageSize*FCurrPage) & "'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount		
		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				Set FItemList(i) = new CHitchhikerItem
					FItemList(i).Fidx = rsget("idx")
					FItemList(i).FReqSdate = rsget("sdate")
					FItemList(i).FReqEdate = rsget("edate")
					FItemList(i).FReqgubun = rsget("gubun")
					FItemList(i).FReqIsusing = rsget("isusing")
					FItemList(i).FreqRegdate = rsget("regdate")
					FItemList(i).FReqSortnum = rsget("sortnum")
					FItemList(i).FReqlinkurl = rsget("linkurl")
					FItemList(i).FReqcon_viewthumbimg = rsget("con_viewthumbimg")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	End Sub

'	Public Sub fnGetmainbanner
'		Dim sqlStr, i, sqlsearch
'
'		if FrectCurrentpreview <> "" then
'			sqlsearch = sqlsearch & " and edate > getdate() "
'		end if		
'		if Frectisusing<>"" then
'			sqlsearch = sqlsearch & " and isusing = '"&Frectisusing&"'"
'		end if
'
'		sqlStr = "select top " & Cstr(FPageSize * FCurrPage)
'		sqlStr = sqlStr & " idx, linkurl, sdate, edate, isusing, sortnum, regdate, gubun, con_viewthumbimg"
'		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_mainbanner_list"
'		sqlStr = sqlStr & " where sdate <= getdate() " & sqlsearch
'		sqlStr = sqlStr & " order by sortnum asc"
'	
'		'response.write sqlStr &"<br>"
'		rsget.Open sqlStr,dbget,1
'		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
'		Redim preserve FItemList(FResultCount)
'		i = 0
'		If  not rsget.EOF  then
'			rsget.absolutepage = FCurrPage
'			Do until rsget.eof
'				Set FItemList(i) = new CHitchhikerItem
'					FItemList(i).Fidx = rsget("idx")
'					FItemList(i).FReqSdate = rsget("sdate")
'					FItemList(i).FReqEdate = rsget("edate")
'					FItemList(i).FReqgubun = rsget("gubun")
'					FItemList(i).FReqIsusing = rsget("isusing")
'					FItemList(i).FreqRegdate = rsget("regdate")
'					FItemList(i).FReqSortnum = rsget("sortnum")
'					FItemList(i).FReqlinkurl = rsget("linkurl")
'					FItemList(i).FReqcon_viewthumbimg = rsget("con_viewthumbimg")
'				i = i + 1
'				rsget.moveNext
'			Loop
'		End If
'		rsget.Close
'	End Sub

	'###### 프리뷰 썸네일 이미지 ######

	public sub fngetpreview()
		dim sqlStr,i

		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_previewthumb '"& FrectCurrentpreview &"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

	    SET FOneItem = new CHitchhikerItem
	        If Not rsget.Eof then
	        	FOneItem.Fidx = rsget("idx")
	        	FOneItem.FReqcash = rsget("cash")
	        	FOneItem.FReqTitle = rsget("title")
	        	FOneItem.FReqSdate = rsget("sdate")
				FOneItem.FReqEdate = rsget("edate")
	        	FOneItem.FReqSortnum = rsget("sortnum")
	        	FOneItem.FReqIsusing = rsget("isusing")
	        	FOneItem.FReqRegdate = rsget("regdate")
	        	FOneItem.FReqmileage = rsget("mileage")
	        	FOneItem.FReqpreview_detail = rsget("preview_detail")
	        	FOneItem.FReqpreview_thumbimg = rsget("preview_thumbimg")
	    	End If
	    rsget.Close
	end sub
	
'	Public Sub fngetpreview
'		Dim sqlStr, i, sqlsearch
'
'		if FrectCurrentpreview <> "" then
'			sqlsearch = sqlsearch & " and m.edate > getdate() "
'		end if
'
'		if Frectisusing<>"" then
'			sqlsearch = sqlsearch & " and m.isusing = '"&Frectisusing&"'"
'		end if
'
'		sqlStr = "SELECT TOP 1"
'		sqlStr = sqlStr & " m.idx, m.title, m.preview_detail, m.preview_thumbimg, m.sdate, m.edate, m.sortnum, m.isusing, m.regdate, m.cash, m.mileage"
'		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_hitchhiker_preview_list m"
'		sqlStr = sqlStr & " WHERE m.sdate <= getdate() " & sqlsearch
'		sqlStr = sqlStr & " order by idx desc" 
'		'response.write sqlStr &"<br>"
'		rsget.Open sqlStr, dbget, 1
'		
'		ftotalcount = rsget.recordcount
'	    SET FOneItem = new CHitchhikerItem
'	        If Not rsget.Eof then
'	        	FOneItem.Fidx = rsget("idx")
'	        	FOneItem.FReqcash = rsget("cash")
'	        	FOneItem.FReqTitle = rsget("title")
'	        	FOneItem.FReqSdate = rsget("sdate")
'				FOneItem.FReqEdate = rsget("edate")
'	        	FOneItem.FReqSortnum = rsget("sortnum")
'	        	FOneItem.FReqIsusing = rsget("isusing")
'	        	FOneItem.FReqRegdate = rsget("regdate")
'	        	FOneItem.FReqmileage = rsget("mileage")
'	        	FOneItem.FReqpreview_detail = rsget("preview_detail")
'	        	FOneItem.FReqpreview_thumbimg = rsget("preview_thumbimg")
'	    	End If
'	    rsget.Close
'	End Sub
	
	'###### 프리뷰 디테일 이미지 ######
	public sub fngetpreviewdetail()
		dim sqlStr,i
		
		if Frectmasteridx="" then exit sub
		
		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_previewdetail '"& Frectmasteridx &"', '"& Frectdevice &"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		i=0
		if  not rsget.EOF  then
			do until rsget.EOF
				set fitemlist(i) = new CHitchhikerItem
					FItemList(i).FIsusing = rsget("isusing")
					FItemList(i).Fsortnum = rsget("sortnum")
					FItemList(i).FRegdate = rsget("regdate")
					FItemList(i).Fdetailidx	= rsget("detailidx")
					FItemList(i).Fmasteridx	= rsget("masteridx")
					FItemList(i).Fdevice	= rsget("device")
					FItemList(i).fpreviewimg= rsget("previewimg")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub  
	
'	Public Sub fngetpreviewdetail
'		Dim sqlStr, i, sqlsearch
'		
'		if Frectmasteridx<>"" then
'			sqlsearch = sqlsearch & " and d.masteridx='"& Frectmasteridx &"'"
'		end if
'		if Frectisusing<>"" then
'			sqlsearch = sqlsearch & " and d.isusing = '"&Frectisusing&"'"
'		end if
'
'		sqlStr = "SELECT TOP " & CStr(FPageSize*FCurrPage)
'		sqlStr = sqlStr & " d.detailidx, d.masteridx, d.previewimg, d.isusing, d.regdate, d.sortnum"
'		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_hitchhiker_preview_detail as d"
'		sqlStr = sqlStr & " WHERE 1=1 " & sqlsearch
'		sqlStr = sqlStr & " ORDER BY d.sortnum ASC"
'		rsget.pagesize = FPageSize
'	
'		'response.write sqlStr &"<br>"
'		rsget.Open sqlStr,dbget,1
'		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
'		Redim preserve FItemList(FResultCount)
'		i = 0
'		If  not rsget.EOF  then
'			rsget.absolutepage = FCurrPage
'			Do until rsget.eof
'				Set FItemList(i) = new CHitchhikerItem
'					FItemList(i).FIsusing = rsget("isusing")
'					FItemList(i).Fsortnum = rsget("sortnum")
'					FItemList(i).FRegdate = rsget("regdate")
'					FItemList(i).Fdetailidx	= rsget("detailidx")
'					FItemList(i).Fmasteridx	= rsget("masteridx")
'					FItemList(i).fpreviewimg= rsget("previewimg")
'				i = i + 1
'				rsget.moveNext
'			Loop
'		End If
'		rsget.Close
'	End Sub

	'###### 이슈영역(모집&발간&기타) ######
	public sub fnGetissue
		dim sqlStr,i

		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_issuearea '"& FrectCurrentpreview &"'"
		
		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

	    SET FOneItem = new CHitchhikerItem
	        If Not rsget.Eof then
				FOneItem.Fidx = rsget("idx")
				FOneItem.Fvol1 = rsget("vol1")
				FOneItem.Fvol2 = rsget("vol2")
				FOneItem.FReqTitle = db2html(rsget("hic_title"))
				FOneItem.FReqIsusing = rsget("isusing")
				FOneItem.FReqSortnum = rsget("sortnum")
				FOneItem.FReqSdate = rsget("sdate")
				FOneItem.FReqEdate = rsget("edate")
				FOneItem.FreqRegdate = rsget("regdate")
				FOneItem.Freqgubun = rsget("gubun")
				FOneItem.Freqissueimg = rsget("issueimg")
				FOneItem.Freqimghtmltext = db2html(rsget("imghtmltext"))
	    	End If
	    rsget.Close
	end sub

'	public sub fnGetissue
'		dim sqlStr,i, sqlsearch
'
'		if FrectCurrentpreview <> "" then
'			sqlsearch = sqlsearch & " AND edate > getdate() "
'		end if
'		
'		if FrectIsusing <> "" Then
'			sqlsearch = sqlsearch & " AND isusing ='"& FrectIsusing &"'"
'		end if
'
'		sqlStr = "select top 1"
'		sqlStr = sqlStr & " idx, hic_title, isusing, sortnum, sdate, edate, regdate, gubun, imghtmltext, vol1, vol2, issueimg"
'		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_list"
'		sqlStr = sqlStr & " where sdate <= getdate() " & sqlsearch
'		sqlStr = sqlStr & " order by sortnum asc ,idx Desc"
'		
'		'response.write sqlStr &"<br>"
'		rsget.Open sqlStr,dbget,1
'		
'		ftotalcount = rsget.recordcount
'	    SET FOneItem = new CHitchhikerItem
'	        If Not rsget.Eof then
'				FOneItem.Fidx = rsget("idx")
'				FOneItem.Fvol1 = rsget("vol1")
'				FOneItem.Fvol2 = rsget("vol2")
'				FOneItem.FReqTitle = db2html(rsget("hic_title"))
'				FOneItem.FReqIsusing = rsget("isusing")
'				FOneItem.FReqSortnum = rsget("sortnum")
'				FOneItem.FReqSdate = rsget("sdate")
'				FOneItem.FReqEdate = rsget("edate")
'				FOneItem.FreqRegdate = rsget("regdate")
'				FOneItem.Freqgubun = rsget("gubun")
'				FOneItem.Freqissueimg = rsget("issueimg")
'				FOneItem.Freqimghtmltext = db2html(rsget("imghtmltext"))
'	    	End If		
'
'		rsget.Close
'	end sub	

	'###### 비디오######
	public sub fnGetvideo
		dim sqlStr,i, sqlsearch

		if FrectCurrentpreview <> "" then
			sqlsearch = sqlsearch & " AND con_edate > getdate() "
		end if

		if FrectIsusing <> "" Then
			sqlsearch = sqlsearch & " AND isusing ='"& FrectIsusing &"'"
		end if

		if Fgubun <> "" Then
			sqlsearch = sqlsearch & " AND gubun = 3 "
		end if
		
		'DB 데이터 리스트
		sqlStr = "select top 30"
		sqlStr = sqlStr & " contentsidx, gubun, con_viewthumbimg, con_title, con_sdate, con_edate"
		sqlStr = sqlStr & " ,con_movieurl, con_regdate, isusing, con_detail"
		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_contents_list"
		sqlStr = sqlStr & " where con_sdate <= getdate() " & sqlsearch
		sqlStr = sqlStr & " order by contentsidx desc"
		
		'response.write sqlStr &"<br>"
		rsget.Open sqlStr,dbget,1
		ftotalcount = rsget.recordcount
		FResultCount = rsget.recordcount
		'FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CHitchhikerItem
					FItemList(i).Fidx = rsget("contentsidx")
					FItemList(i).FReqgubun = rsget("gubun")
					FItemList(i).FReqpreview_detail = rsget("con_detail")
					FItemList(i).FReqIsusing = rsget("isusing")
					FItemList(i).FReqSdate = rsget("con_sdate")
					FItemList(i).FReqEdate = rsget("con_edate")
					FItemList(i).FreqRegdate = rsget("con_regdate")
					FItemList(i).FReqmovie = db2html(rsget("con_movieurl"))
					FItemList(i).FReqTitle = db2html(rsget("con_title"))
					FItemList(i).FReqcon_viewthumbimg = rsget("con_viewthumbimg")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub	

	'###### 월페이퍼######
	Public Sub fnGetwallpaper
		Dim sqlStr, i, sqladd

		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_wallpaper_Cnt '"&Fgubun&"'"

		'Response.write sqlStr &"<br>"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		if FTotalCount < 1 then exit Sub

		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_wallpaper '"&Fgubun&"', '" & CStr(FPageSize*FCurrPage) & "'"

		'Response.write sqlStr &"<br>"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CHitchhikerItem
					FItemList(i).FIsusing = rsget("isusing")
					FItemList(i).Fcontentsidx = rsget("contentsidx")
					FItemList(i).FReqcon_viewthumbimg = rsget("con_viewthumbimg")
																	
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	End Sub

'	public sub fnGetwallpaper()
'		dim sqlStr, addSql, i
'
'		addSql = ""
'		if Fgubun <> "" Then
'			addSql = addSql & " AND gubun ='"& Fgubun &"'"
'		end if
'
'		'총 갯수 구하기
'		sqlStr = "select count(*) as cnt"
'		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_contents_list"
'		sqlStr = sqlStr & " where isusing ='Y' " & addSql
'		
'		'response.write sqlStr &"<br>"	
'		rsget.Open sqlStr,dbget,1
'			FTotalCount = rsget("cnt")
'		rsget.Close
'				
'		'데이터 리스트 	
'		sqlStr = "select top " & Cstr(FPageSize * FCurrPage)
'		sqlStr = sqlStr & " contentsidx,gubun,con_viewthumbimg,con_title,con_sdate,con_edate"
'		sqlStr = sqlStr & " ,con_movieurl,con_regdate,isusing"
'		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_contents_list"
'		sqlStr = sqlStr & " where isusing ='Y' " & addSql
'		sqlStr = sqlStr & " order by contentsidx Desc"	
'				
'		'response.write sqlStr &"<br>"
'		rsget.pagesize = FPageSize
'		rsget.Open sqlStr,dbget,1
'
'		if (FCurrPage * FPageSize < FTotalCount) then
'			FResultCount = FPageSize
'		else
'			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
'		end if
'
'		FTotalPage = (FTotalCount\FPageSize)
'		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
'
'		redim preserve FItemList(FResultCount)
'
'		FPageCount = FCurrPage - 1
'
'		i=0
'		if  not rsget.EOF  then
'			rsget.absolutepage = FCurrPage
'			do until rsget.EOF
'				set FItemList(i) = new CHitchhikerItem
'					FItemList(i).FIsusing = rsget("isusing")
'					FItemList(i).Fcontentsidx = rsget("contentsidx")
'					FItemList(i).FReqcon_viewthumbimg = rsget("con_viewthumbimg")
'																	
'				rsget.movenext
'				i=i+1
'			loop
'		end if
'		rsget.Close
'	end sub

	'###### 월페이퍼 다운링크######
	public sub fnGetContents_link
		dim sqlStr,i
		
		if Fgubun="" then exit sub
		
		sqlStr = "exec db_sitemaster.dbo.sp_Ten_hitchhiker_WallPaperDownLink '"& Fgubun &"','"& Frectcontentsidx &"'"
		
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
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CHitchhikerItem
					FItemList(i).Freqgubun = rsget("gubun")
					FItemList(i).FIsusing = rsget("isusing")
					FItemList(i).FRegdate = rsget("regdate")
					FItemList(i).FSortnum = db2html(rsget("sortnum"))
					FItemList(i).FContentslink = db2html(rsget("contentslink"))
					FItemList(i).FDevicename = db2html(rsget("device_name"))
					FItemList(i).FContentsSize = db2html(rsget("contents_size"))
				
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

'	public sub fnGetContents_link
'		dim sqlStr,i, sqlsearch, hicprogbn
'
'			if Fgubun <> "" Then
'				sqlsearch = sqlsearch & " AND gubun ='"& Fgubun &"'"
'			end if
'			
'			if Frectisusing <> "" Then
'				sqlsearch = sqlsearch & " AND D.isusing ='"& Frectisusing &"'"
'			end if
'
'			sqlStr = "select top " & Cstr(FPageSize * FCurrPage)
'			sqlStr = sqlStr & " d.deviceidx, D.device_name, D.contents_size, D.gubun, D.isusing, D.sortnum, D.regdate, K.contentslink "
'			sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_hitchhiker_device_size as D"
'			sqlStr = sqlStr & "	join db_sitemaster.dbo.tbl_hitchhiker_contents_link as K"
'			sqlStr = sqlStr & "		on D.deviceidx = K.deviceidx"
'
'				if Frectcontentsidx <> "" Then
'					sqlStr = sqlStr & " AND K.contentsidx ='"& Frectcontentsidx &"'"
'				end if
'			sqlStr = sqlStr & " where 1=1 " & sqlsearch
'			sqlStr = sqlStr & " order by D.sortnum asc"
'
'			'response.write sqlStr &"<br>"
'			rsget.pagesize = FPageSize		
'			rsget.Open sqlStr,dbget,1
'			
'			FTotalCount = rsget.recordcount
'			FResultCount =  rsget.recordcount
'	
'			redim preserve FItemList(FResultCount)
'	
'			i=0
'			if  not rsget.EOF  then
'				rsget.absolutepage = FCurrPage
'				do until rsget.EOF
'					set FItemList(i) = new CHitchhikerItem
'						FItemList(i).Freqgubun = rsget("gubun")
'						FItemList(i).FIsusing = rsget("isusing")
'						FItemList(i).FRegdate = rsget("regdate")
'						FItemList(i).FSortnum = db2html(rsget("sortnum"))
'						FItemList(i).FContentslink = db2html(rsget("contentslink"))
'						FItemList(i).FDevicename = db2html(rsget("device_name"))
'						FItemList(i).FContentsSize = db2html(rsget("contents_size"))
'					
'					rsget.movenext
'					i=i+1
'				loop
'			end if
'			rsget.Close
'	end sub
	
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		
		FItemArr = ""
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
end class

%>
	
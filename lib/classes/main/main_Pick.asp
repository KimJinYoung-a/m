<%
Class CPickItem

	public Fidx
	public Fsubidx
	public Ftextname
	Public FsortNo
	public Fregdate
	Public Ftitle
	Public Flinkinfo
	Public FisUsing

	public Fimage 
	public Fitemname 
	public Fitemid 
	public FsellCash 
	public ForgPrice 
	public FsailYN 
	public FcouponYn 
	public Fcouponvalue
	public FLimitYn
	public Fcoupontype 
	public Fnewyn 
	public Flimitno 
	public Flimitdispyn
	public Fmakerid 
	public Fbrandname 
	
	public Fpoints
	public FFavCount
	public FMDevalcnt

	public Fitemdiv

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CPick
	public FItemList()
	public FItemOne

	public FTotalCount
	public FResultCount

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount

	public FRectIdx
	public FRectUsing
	public FRectSearch
	public FRectSort
	public FCategoryPrdList()

	Private Sub Class_Initialize()
		'redim preserve FItemList(0)
		redim  FItemList(0)

		FCurrPage =1
		FPageSize = 15
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		redim preserve FCategoryPrdList(0)
	End Sub

	Private Sub Class_Terminate()

	End Sub


	public Sub GetPickOne()
		dim sqlStr, addSql, i
		sqlStr = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_GetOne]"
		rsget.Open sqlStr,dbget,1
		if not rsget.EOF then
			FTotalCount = 1
			set FItemOne = new CPickItem
			FItemOne.Fidx = rsget("idx")
			FItemOne.Ftitle = db2html(rsget("title"))
		end if
		rsget.Close
	End Sub
	

	public Function GetPickItemList()
		dim strSql, addSql, i, arrItem, intI

		strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList] '1', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', ''"
		rsget.Open strSql,dbget,1
		FTotalCount = rsget(0)
		FTotalPage = rsget(1)
		rsget.Close

		If FTotalCount > 0 Then
			strSql = "EXECUTE [db_sitemaster].[dbo].[sp_Ten_Mobile_PICK_ItemList] '2', '" & (FPageSize*FCurrPage) & "', '" & FRectIdx & "', '" & FRectSort & "'"
			rsget.Open strSql,dbget,1
			IF Not (rsget.EOF OR rsget.BOF) THEN
				arrItem = rsget.GetRows()
			END IF
			rsget.close
	
			IF isArray(arrItem) THEN
				FResultCount = Ubound(arrItem,2)
				redim preserve FCategoryPrdList(FResultCount)

				For intI = 0 To FResultCount
				set FCategoryPrdList(intI) = new CCategoryPrdItem
					FCategoryPrdList(intI).FItemID       = arrItem(0,intI)
					FCategoryPrdList(intI).FItemName    = db2html(arrItem(1,intI))
	
					FCategoryPrdList(intI).FSellcash    = arrItem(2,intI)
					FCategoryPrdList(intI).FOrgPrice   	= arrItem(3,intI)
					FCategoryPrdList(intI).FMakerId   	= db2html(arrItem(4,intI))
					FCategoryPrdList(intI).FBrandName  	= db2html(arrItem(5,intI))
	
					FCategoryPrdList(intI).FSellYn      = arrItem(9,intI)
					FCategoryPrdList(intI).FSaleYn     	= arrItem(10,intI)
					FCategoryPrdList(intI).FLimitYn     = arrItem(11,intI)
					FCategoryPrdList(intI).FLimitNo     = arrItem(12,intI)
					FCategoryPrdList(intI).FLimitSold   = arrItem(13,intI)
	
					FCategoryPrdList(intI).FRegdate 		= arrItem(14,intI)
					FCategoryPrdList(intI).FReipgodate		= arrItem(15,intI)
	
	                FCategoryPrdList(intI).Fitemcouponyn 	= arrItem(16,intI)
					FCategoryPrdList(intI).FItemCouponValue= arrItem(17,intI)
					FCategoryPrdList(intI).Fitemcoupontype	= arrItem(18,intI)
	
					FCategoryPrdList(intI).Fevalcnt 		= arrItem(19,intI)
					FCategoryPrdList(intI).FitemScore 		= arrItem(20,intI)
	
					FCategoryPrdList(intI).FImageList = "http://webimage.10x10.co.kr/image/list/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(6,intI)
					FCategoryPrdList(intI).FImageList120 = "http://webimage.10x10.co.kr/image/list120/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(7,intI)
					FCategoryPrdList(intI).FImageSmall = "http://webimage.10x10.co.kr/image/small/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(8,intI)
					FCategoryPrdList(intI).FImageIcon1 = "http://webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(21,intI)
					FCategoryPrdList(intI).FImageIcon2 = "http://webimage.10x10.co.kr/image/icon2/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(22,intI)
					FCategoryPrdList(intI).FImageBasic = "http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(arrItem(0,intI))&"/"&arrItem(26,intI)
					FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
					FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)
	
				Next
			END IF
		ELSE
			FTotalCount = -1
		END IF
	end Function

	public function fnGetMdPickList()
        dim sqlStr, i

		'// 결과수 카운트
		sqlStr = "Select count(*) as cnt From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s " & vbcrlf
		sqlStr = sqlStr & " left join db_item.dbo.tbl_item as i " & vbcrlf
		sqlStr = sqlStr & " 	on s.itemid=i.itemid and i.itemid<>0 " & vbcrlf
		sqlStr = sqlStr & " left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l " & vbcrlf
		sqlStr = sqlStr & " 	on s.listidx = l.idx " & vbcrlf
		sqlStr = sqlStr & " LEFT OUTER JOIN [db_board].[dbo].[tbl_const_eval_PointSummary] as eps " & vbcrlf
		sqlStr = sqlStr & " 	ON i.itemid = eps.itemid  " & vbcrlf
		sqlStr = sqlStr & " Where s.isusing = 'Y' and l.isusing = 'Y' And i.isusing='Y' " & vbcrlf
		sqlStr = sqlStr & " and l.idx in (select top 7 idx from [db_sitemaster].dbo.tbl_mobile_main_mdpick_list where isusing = 'Y' and (convert(varchar(10),enddate,120) <= convert(varchar(10),getdate(),120)) and startdate <= getdate() order by enddate desc) "

		'response.write sqlStr &"<Br>"
        rsget.Open sqlStr,dbget,1
            FTotalCount = rsget("cnt")
        rsget.Close

		if FTotalCount < 1 then exit function

        '// 본문 내용 접수
        sqlStr = "select top " + Cstr(FPageSize * FCurrPage)  + vbcrlf
		sqlStr = sqlStr & " s.subidx , s.listidx , s.itemid " & vbcrlf
		sqlStr = sqlStr & " , s.isusing as itemusing , s.sortnum , i.itemname as itemname , i.basicimage " & vbcrlf
		sqlStr = sqlStr & " , datepart(hh, l.startdate) as starttime , datepart(hh, l.enddate) as endtime , l.mdpicktitle " & vbcrlf
		sqlStr = sqlStr & " , (case when DATEDIFF ( day , i.regdate , getdate()) < 14 then 'Y' else 'N' end) as newyn " & vbcrlf
		sqlStr = sqlStr & " , i.sellCash , i.orgPrice , i.sailyn , i.itemcouponYn , i.itemcouponvalue , i.limitYN " & vbcrlf
		sqlStr = sqlStr & " , i.itemcoupontype , (i.limitno - i.limitsold) as limitno , i.limitdispyn , i.makerid , i.brandname, i.evalcnt " & vbcrlf
		sqlStr = sqlStr & " ,isNull(convert(int,(ROUND(eps.TotalPoint,2)*100)),0) as totalpoint  " & vbcrlf
		sqlStr = sqlStr & " ,isNull(d.favcount,0) as favcount, i.itemdiv  " & vbcrlf
		sqlStr = sqlStr & " From [db_sitemaster].[dbo].tbl_mobile_main_mdpick_item as s " & vbcrlf
		sqlStr = sqlStr & " 	INNER JOIN [db_item].[dbo].tbl_item_contents AS d  " & vbcrlf
		sqlStr = sqlStr & " 		on s.itemid = d.itemid " & vbcrlf
		sqlStr = sqlStr & " 	left join db_item.dbo.tbl_item as i " & vbcrlf
		sqlStr = sqlStr & " 		on s.itemid=i.itemid and i.itemid<>0 " & vbcrlf
		sqlStr = sqlStr & " 	left join [db_sitemaster].dbo.tbl_mobile_main_mdpick_list as l " & vbcrlf
		sqlStr = sqlStr & " 		on s.listidx = l.idx " & vbcrlf
		sqlStr = sqlStr & " 	LEFT OUTER JOIN [db_board].[dbo].[tbl_const_eval_PointSummary] as eps " & vbcrlf
		sqlStr = sqlStr & " 		ON i.itemid = eps.itemid  " & vbcrlf
		sqlStr = sqlStr & " Where s.isusing = 'Y' and l.isusing = 'Y' And i.isusing='Y' " & vbcrlf
		sqlStr = sqlStr & " and l.idx in (select top 7 idx from [db_sitemaster].dbo.tbl_mobile_main_mdpick_list where isusing = 'Y' and (convert(varchar(10),enddate,120) <= convert(varchar(10),getdate(),120)) and startdate <= getdate() order by enddate desc) " & vbcrlf
		sqlStr = sqlStr & " order by l.idx asc , s.listidx asc , s.sortnum asc "

		'response.write sqlStr &"<Br>"
		'' response.end
        rsget.pagesize = FPageSize
        rsget.Open sqlStr,dbget,1

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
            do until rsget.EOF
                set FItemList(i) = new CPickItem

				If rsget("itemdiv") = "21" Then
					if instr(rsget("basicimage"),"/") > 0 then
                		FItemList(i).Fimage		  = webImgUrl & "/image/basic/" + db2Html(rsget("basicimage"))
					Else
						FItemList(i).Fimage		  = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(rsget("itemid"))) + "/" + db2Html(rsget("basicimage"))
					End If
				Else
                	FItemList(i).Fimage		  = webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(rsget("itemid"))) + "/" + db2Html(rsget("basicimage"))
				End If
				FItemList(i).Fitemname	  = rsget("itemname")
				FItemList(i).Fitemid	  = rsget("itemid")
				FItemList(i).FsellCash	  = rsget("sellCash")
				FItemList(i).ForgPrice	  = rsget("orgPrice")
				FItemList(i).FsailYN	  = rsget("sailyn")
				FItemList(i).FcouponYn	  = rsget("itemcouponYn")
				FItemList(i).Fcouponvalue = rsget("itemcouponvalue")
				FItemList(i).FLimitYn	  = rsget("limitYN")
				FItemList(i).Fcoupontype  = rsget("itemcoupontype")
				FItemList(i).Fnewyn		  = rsget("newyn")
				FItemList(i).Flimitno	  = rsget("limitno")
				FItemList(i).Flimitdispyn = rsget("limitdispyn")
				FItemList(i).Fmakerid	  = rsget("makerid")
				FItemList(i).Fbrandname	  = rsget("brandname")
				
				FItemList(i).Fpoints	  = rsget("totalpoint")
				FItemList(i).Ffavcount	  = rsget("favcount")
				FItemList(i).FMDevalcnt   = rsget("evalcnt")
				FItemList(i).Fitemdiv   = rsget("itemdiv")

                rsget.movenext
                i=i+1
            loop
        end if
        rsget.Close
    end Function

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


'//상품후기 총점수 %로 환산
function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/5)
				Else
					vTmp = ((Round(t,2) * 100)/5)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function
%>

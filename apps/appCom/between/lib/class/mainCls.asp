<%
Class CMainbannerItem
	Public FIdx
	Public FImgurl
	Public FImglink
	Public FSortno
	Public FStartdate
	Public FEnddate
	Public FRegdate
	Public FLastupdate
	Public FAdminid
	Public FLastadminid
	Public FIsusing

	Public FBasicImage
	Public FItemid
	Public FItemname
	Public FSellcash
	Public FOrgprice
	Public FsaleYn

	Public FGender
	Public FPjt_kind
	Public FLinkURL
	Public FBanBGColor
	Public FPartnerNMColor
	Public FBanTxtColor
	Public FBantext1
	Public FBantext2
	Public FFIsusing

	Public FMakerId
	Public FBrandName
	Public FSellYn
	Public FLimitYn
	Public FLimitNo
	Public FLimitSold
	Public FReipgodate
	Public Fitemcouponyn
	Public FItemCouponValue
	Public Fitemcoupontype
	Public Fevalcnt
	Public FitemScore
	Public Fitemdiv
	Public FImageBasic
	Public FCatecode

	Public FRank
	Public FLikeword

	Public Function getSalePro()
		If FOrgprice=0 then
			getSalePro = 0 & "%"
		Else
			getSalePro = CLng((FOrgPrice-FSellcash)/FOrgPrice*100) & "%"
		End if
	End Function

	public Function IsSoldOut()
		IF FLimitNo<>"" and FLimitSold<>"" Then
			isSoldOut = (FSellYn<>"Y") or ((FLimitYn = "Y") and (clng(FLimitNo)-clng(FLimitSold)<1))
		Else
			isSoldOut = (FSellYn<>"Y")
		End If
	end Function

	public Function IsSaleItem()
	    IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0))
	end Function

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
End Class

Class CMainbanner
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

    public FRectIdx
    public Fisusing
	Public Fsdt
	Public Fedt
	Public FRectGender
	Public FItemCnt
	Public FItemsort
	Public FTotCnt
	Public FMainItemList()

	'//admin/mobile/tpobanner/tpo_insert.asp
    public Sub GetOneContents()
        dim sqlStr
        sqlStr = "select top 1 * "
        sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_tpobanner "
        sqlStr = sqlStr + " where idx=" + CStr(FRectIdx)

		'rw sqlStr & "<Br>"
        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new CMainbannerItem

        if Not rsget.Eof then
    		FOneItem.fidx				= rsget("idx")
			FOneItem.Fbgimg			= staticImgUrl & "/mobile/tpobanner" & rsget("bgimg")
			FOneItem.Flimg			= staticImgUrl & "/mobile/tpobanner" & rsget("limg")
			FOneItem.Frimg			= staticImgUrl & "/mobile/tpobanner" & rsget("rimg")
			FOneItem.Flalt				= rsget("lalt")
			FOneItem.Fralt				= rsget("ralt")
			FOneItem.Flurl				= rsget("lurl")
			FOneItem.Frurl				= rsget("rurl")
			FOneItem.Fsortnum		= rsget("sortnum")
			FOneItem.Fstartdate		= rsget("startdate")
			FOneItem.Fenddate		= rsget("enddate")
			FOneItem.Fadminid		= rsget("adminid")
			FOneItem.Flastadminid	= rsget("lastadminid")
			FOneItem.Fisusing		= rsget("isusing")
        end If

        rsget.Close
    end Sub

    Public Sub get3bannerList()
        Dim sqlStr, i
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as cnt FROM db_outmall.dbo.tbl_between_main_3banner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"

		If Fsdt <> "" Then 			sqlStr = sqlStr & " and endDate > '" & Fsdt & " 00:00:00' "
		If Fedt <> "" Then 			sqlStr = sqlStr & " and startDate <= '" & Fedt & " 23:59:59' "
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		'response.write sqlStr &"<br>"
		rsCTget.Open sqlStr, dbCTget, 1
			FTotalCount = rsCTget("cnt")
		rsCTget.close

		If FTotalCount < 1 Then Exit Sub

        sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize * FCurrPage)
		sqlStr = sqlStr & " idx, imgurl, imglink, sortno, startdate, enddate, regdate, lastupdate, adminid, lastadminid, isusing "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_main_3banner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"
		If Fsdt <> "" Then sqlStr = sqlStr & " and endDate > '" & Fsdt & " 00:00:00' "
		If Fedt <> "" Then sqlStr = sqlStr & " and startDate <= '" & Fedt & " 23:59:59' "
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		sqlStr = sqlStr & " ORDER BY sortno ASC, idx DESC"
		'response.write sqlStr &"<br>"
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsCTget.EOF Then
		    i = 0
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FIdx			= rsCTget("idx")
					FItemList(i).FImgurl		= rsCTget("imgurl")
					FItemList(i).FImglink		= rsCTget("imglink")
					FItemList(i).FSortno		= rsCTget("sortno")
					FItemList(i).FStartdate		= rsCTget("startdate")
					FItemList(i).FEnddate		= rsCTget("enddate")
					FItemList(i).FRegdate		= rsCTget("regdate")
					FItemList(i).FLastupdate	= rsCTget("lastupdate")
					FItemList(i).FAdminid		= rsCTget("adminid")
					FItemList(i).FLastadminid	= rsCTget("lastadminid")
					FItemList(i).FIsusing		= rsCTget("isusing")
				i=i+1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.close
    End Sub

	Public Sub getMain3Mdpick(idxarr)
		Dim sqlStr, i, addSql
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as CNT, CEILING(CAST(Count(*) AS FLOAT)/" & FPageSize & ") as totPg "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.idx in ("&idxarr&")"
		rsCTget.Open sqlStr,dbCTget,1
			FTotalCount = rsCTget("cnt")
		rsCTget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		If FTotalCount < 1 Then Exit Sub

		sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize*FCurrPage) & " i.*, "
		sqlStr = sqlStr & " pg.idx, isnull(pg.MainMdpickSortNo, 0) as MainMdpickSortNo, pg.MainMdpickXMLRegdate "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.idx in ("&idxarr&")"
		sqlStr = sqlStr & " ORDER BY pg.MainMdpickSortNo ASC "
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsCTget.EOF Then
		    i = 0
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FBasicImage				= rsCTget("basicimage")
					If Not(FItemList(i).FBasicImage="" or isNull(FItemList(i).FBasicImage)) Then
						FItemList(i).FBasicImage = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsCTget("itemid")) & "/" & rsCTget("basicimage")
					Else
						FItemList(i).FBasicImage = "http://fiximage.10x10.co.kr/images/spacer.gif"
					End If
					FItemList(i).FItemid					= rsCTget("itemid")
					FItemList(i).FItemname					= rsCTget("itemname")
					FItemList(i).FSellcash					= rsCTget("sellcash")
					FItemList(i).FOrgprice					= rsCTget("orgprice")
					FItemList(i).FsaleYn					= rsCTget("sailyn")

				i = i + 1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.Close
	End Sub

	Public Sub sbMain3Mdpick(gender)
		Dim sqlStr, i, addSql
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as CNT, CEILING(CAST(Count(*) AS FLOAT)/" & FPageSize & ") as totPg "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.mdpickgender = '"&gender&"' and pg.mdpickIsUsing = 'Y' "
		rsCTget.Open sqlStr,dbCTget,1
			FTotalCount = rsCTget("cnt")
		rsCTget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		If FTotalCount < 1 Then Exit Sub

		sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize*FCurrPage) & " i.*, "
		sqlStr = sqlStr & " pg.idx, isnull(pg.MainMdpickSortNo, 0) as MainMdpickSortNo, pg.MainMdpickXMLRegdate "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_AppWish.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.mdpickgender = '"&gender&"' and pg.mdpickIsUsing = 'Y' "
		sqlStr = sqlStr & " ORDER BY pg.MainMdpickSortNo ASC "
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsCTget.EOF Then
		    i = 0
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FBasicImage				= rsCTget("basicimage")
					If Not(FItemList(i).FBasicImage="" or isNull(FItemList(i).FBasicImage)) Then
						FItemList(i).FBasicImage = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsCTget("itemid")) & "/" & rsCTget("basicimage")
					Else
						FItemList(i).FBasicImage = "http://fiximage.10x10.co.kr/images/spacer.gif"
					End If
					FItemList(i).FItemid					= rsCTget("itemid")
					FItemList(i).FItemname					= rsCTget("itemname")
					FItemList(i).FSellcash					= rsCTget("sellcash")
					FItemList(i).FOrgprice					= rsCTget("orgprice")
					FItemList(i).FsaleYn					= rsCTget("sailyn")

				i = i + 1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.Close
	End Sub

	Public Sub getMainTopBanner
       Dim sqlStr, i
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as cnt FROM db_outmall.dbo.tbl_between_main_topbanner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"

		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		'response.write sqlStr &"<br>"
		rsCTget.Open sqlStr, dbCTget, 1
			FTotalCount = rsCTget("cnt")
		rsCTget.close

		If FTotalCount < 1 Then Exit Sub

        sqlStr = ""
		sqlStr = sqlStr & " SELECT idx, gender, pjt_kind, imgurl, linkURL, BanBGColor, partnerNMColor, BanTxtColor, bantext1, bantext2, isusing  "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_main_topbanner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		sqlStr = sqlStr & " ORDER BY idx DESC"
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsCTget.EOF Then
		    i = 0
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FIdx			= rsCTget("idx")
					FItemList(i).FGender		= rsCTget("gender")
					FItemList(i).FPjt_kind		= rsCTget("pjt_kind")
					FItemList(i).FImgurl		= rsCTget("imgurl")
					FItemList(i).FLinkURL		= rsCTget("linkURL")
					FItemList(i).FBanBGColor	= rsCTget("BanBGColor")
					FItemList(i).FPartnerNMColor= rsCTget("partnerNMColor")
					FItemList(i).FBanTxtColor	= rsCTget("BanTxtColor")
					FItemList(i).FBantext1		= rsCTget("bantext1")
					FItemList(i).FBantext2		= rsCTget("bantext2")
					FItemList(i).FFIsusing		= rsCTget("isusing")
				i=i+1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.close
	End Sub

	Public Sub getMainItemlist()
		Dim sqlStr , i
		sqlStr = "EXECUTE [db_outMall].[dbo].sp_Between_MainItem_CNT '" & FPageSize & "' "
		'response.write sqlStr
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open sqlStr,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.Close

		sqlStr = "EXECUTE [db_outMall].dbo.sp_Between_MainItem '" & FItemCnt & "', '"& FItemsort & "'"
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		'rsget.Open sqlStr, dbget, 1
		rsCTget.Open sqlStr,dbCTget,1
		FResultCount = rsCTget.RecordCount - (FPageSize * (FCurrPage - 1))
        If (FResultCount < 1) Then FResultCount = 0
		Redim preserve FMainItemList(FResultCount)

		i = 0
		IF Not (rsCTget.EOF OR rsCTget.BOF) THEN
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FMainItemList(i) = new CMainbannerItem
					FMainItemList(i).FItemID			= rsCTget("itemid")
					FMainItemList(i).FItemName			= db2html(rsCTget("itemname"))
					FMainItemList(i).FSellcash			= rsCTget("sellcash")
					FMainItemList(i).FOrgPrice   		= rsCTget("orgprice")
					FMainItemList(i).FMakerId   		= db2html(rsCTget("makerid"))
					FMainItemList(i).FBrandName  		= db2html(rsCTget("brandname"))
					FMainItemList(i).FSellYn			= rsCTget("sellyn")
					FMainItemList(i).FSaleYn			= rsCTget("sailyn")
					FMainItemList(i).FLimitYn			= rsCTget("limityn")
					FMainItemList(i).FLimitNo			= rsCTget("limitno")
					FMainItemList(i).FLimitSold			= rsCTget("limitsold")
					FMainItemList(i).FRegdate			= rsCTget("regdate")
					FMainItemList(i).FReipgodate		= rsCTget("reipgodate")
				    FMainItemList(i).Fitemcouponyn		= rsCTget("itemcouponYn")
					FMainItemList(i).FItemCouponValue	= rsCTget("itemCouponValue")
					FMainItemList(i).Fitemcoupontype	= rsCTget("itemCouponType")
					FMainItemList(i).Fevalcnt			= rsCTget("evalCnt")
					FMainItemList(i).FitemScore			= rsCTget("itemScore")
					FMainItemList(i).Fitemdiv			= rsCTget("itemdiv")
					FMainItemList(i).FImageBasic		= rsCTget("basicimage")
					FMainItemList(i).FCatecode		= rsCTget("catecode")
				i = i + 1
				rsCTget.moveNext
			Loop
		End If
	End Sub

	Public Sub getSearchLikeword(idxarr)
		Dim sqlStr, i, addSql
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as CNT, CEILING(CAST(Count(*) AS FLOAT)/" & FPageSize & ") as totPg "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_search_likeWord "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and idx in ("&idxarr&")"
		rsCTget.Open sqlStr,dbCTget,1
			FTotalCount = rsCTget("cnt")
		rsCTget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		If FTotalCount < 1 Then Exit Sub

		sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize*FCurrPage) 
		sqlStr = sqlStr & " idx, rank, likeword "
		sqlStr = sqlStr & " FROM db_outmall.dbo.tbl_between_search_likeWord "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and idx in ("&idxarr&")"
		sqlStr = sqlStr & " ORDER BY rank ASC "
		rsCTget.pagesize = FPageSize
		rsCTget.Open sqlStr, dbCTget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsCTget.EOF Then
		    i = 0
			rsCTget.absolutepage = FCurrPage
			Do until rsCTget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FRank		= rsCTget("rank")
					FItemList(i).FLikeword	= rsCTget("likeword")
				i = i + 1
				rsCTget.moveNext
			Loop
		End If
		rsCTget.Close
	End Sub

    Private Sub Class_Initialize()
		Redim  FItemList(0)
		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0

		Redim preserve FMainItemList(0)
		FTotCnt = 0
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
end Class

'// STAFF 이름 접수
public Function getStaffUserName(uid)
	if uid="" or isNull(uid) then
		exit Function
	end if

	Dim strSql
	strSql = "Select top 1 username From db_partner.dbo.tbl_user_tenbyten Where userid='" & uid & "'"
	rsget.Open strSql, dbget, 1
	if Not(rsget.EOF or rsget.BOF) then
		getStaffUserName = rsget("username")
	end if
	rsget.Close
End Function

Sub sbMainNewItemList
	Dim iEndCnt, intJ, intIx, i, iTotCnt, itemid, vItemClass, vTotalPage, intI
	i = 0
	intI = 0
	SET cMainItem = new CMainbanner
		cMainItem.FCurrPage		= vPage
		cMainItem.FItemcnt		= vTopCount
		cMainItem.FItemsort		= "N"
		cMainItem.getMainItemlist
		iTotCnt = cMainItem.FResultCount
		vTotalPage = cMainItem.FTotalPage
	IF (iTotCnt > 0) THEN

		For intI =0 To cMainItem.FResultCount-1
			IF cMainItem.FMainItemList(intI).isSaleItem Then
				vItemClass = "sale"
			End If
%>
					<li>
						<div <%= Chkiif(vItemClass <> "", "class="&vItemClass&"", "") %>>
							<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%= cMainItem.FMainItemList(intI).FItemid %>&dispCate=<%=cMainItem.FMainItemList(intI).FCatecode%>">
								<p class="pdtPic"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic/<%=GetImageSubFolderByItemid(cMainItem.FMainItemList(intI).FItemID) & "/" & cMainItem.FMainItemList(intI).FImageBasic & "?cmd=thumb&width=400&height=400"%>" alt="<% = cMainItem.FMainItemList(intI).FItemName %>" /></p>
								<p class="pdtName"><%=chrbyte(cMainItem.FMainItemList(intI).FItemName,"50","Y")%></p>
								<p class="price"><%= FormatNumber(cMainItem.FMainItemList(intI).FSellCash, 0) %>원</p>
								<span class="seller"><!--<%= cMainItem.FMainItemList(intI).FBrandName %>--></span>
								<% If vItemClass = "sale" Then %><p class="pdtTag saleRed"><%=cMainItem.FMainItemList(intI).getSalePro%></p><% End If %>
							</a>
						</div>
					</li>
<%
			vItemClass = ""
			i = i + 1
		Next
	End If
	set cMainItem = Nothing
End Sub

Sub sbMainBestItemList
	Dim iEndCnt, intJ, intIx, i, iTotCnt, itemid, vItemClass, vTotalPage, intI, iNum
	i = 0
	intI = 0
	SET cMainItem = new CMainbanner
		cMainItem.FCurrPage		= vPage2
		cMainItem.FItemcnt		= vTopCount2
		cMainItem.FItemsort		= "B"
		cMainItem.getMainItemlist
		iTotCnt = cMainItem.FResultCount
		vTotalPage = cMainItem.FTotalPage
	IF (iTotCnt > 0) THEN
		If vTopCount2 <= 10 Then
			iNum = 0
		ElseIf vTopCount2 > 11 and vTopCount2 <=20 Then
			iNum = 10
		ElseIf vTopCount2 > 21 and vTopCount2 <=30 Then
			iNum = 20
		End If

		For intI =0 To cMainItem.FResultCount-1
			IF cMainItem.FMainItemList(intI).isSaleItem Then
				vItemClass = "sale"
			End If
%>
					<li>
						<div <%= Chkiif(vItemClass <> "", "class="&vItemClass&"", "") %>>
							<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%= cMainItem.FMainItemList(intI).FItemid %>&dispCate=<%=cMainItem.FMainItemList(intI).FCatecode%>">
								<strong class="rank"><%= iNum + 1 %></strong>
								<p class="pdtPic"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic/<%=GetImageSubFolderByItemid(cMainItem.FMainItemList(intI).FItemID) & "/" & cMainItem.FMainItemList(intI).FImageBasic & "?cmd=thumb&width=400&height=400"%>" alt="<% = cMainItem.FMainItemList(intI).FItemName %>" /></p>
								<p class="pdtName"><%=chrbyte(cMainItem.FMainItemList(intI).FItemName,"50","Y")%></p>
								<p class="price"><%= FormatNumber(cMainItem.FMainItemList(intI).FSellCash, 0) %>원</p>
								<span class="seller"><!--<%= cMainItem.FMainItemList(intI).FBrandName %>--></span>
								<% If vItemClass = "sale" Then %><p class="pdtTag saleRed"><%=cMainItem.FMainItemList(intI).getSalePro%></p><% End If %>
							</a>
						</div>
					</li>
<%
			vItemClass = ""
			i = i + 1
			iNum = iNum + 1
		Next
	End If
	Set cMainItem = Nothing
End Sub
%>
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
		sqlStr = sqlStr & " SELECT COUNT(*) as cnt FROM db_etcmall.dbo.tbl_between_main_3banner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"

		If Fsdt <> "" Then 			sqlStr = sqlStr & " and endDate > '" & Fsdt & " 00:00:00' "
		If Fedt <> "" Then 			sqlStr = sqlStr & " and startDate <= '" & Fedt & " 23:59:59' "
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		'response.write sqlStr &"<br>"
		rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close

		If FTotalCount < 1 Then Exit Sub

        sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize * FCurrPage)
		sqlStr = sqlStr & " idx, imgurl, imglink, sortno, startdate, enddate, regdate, lastupdate, adminid, lastadminid, isusing "
		sqlStr = sqlStr & " FROM db_etcmall.dbo.tbl_between_main_3banner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"
		If Fsdt <> "" Then sqlStr = sqlStr & " and endDate > '" & Fsdt & " 00:00:00' "
		If Fedt <> "" Then sqlStr = sqlStr & " and startDate <= '" & Fedt & " 23:59:59' "
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		sqlStr = sqlStr & " ORDER BY sortno ASC, idx DESC"
		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsget.EOF Then
		    i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FIdx			= rsget("idx")
					FItemList(i).FImgurl		= rsget("imgurl")
					FItemList(i).FImglink		= rsget("imglink")
					FItemList(i).FSortno		= rsget("sortno")
					FItemList(i).FStartdate		= rsget("startdate")
					FItemList(i).FEnddate		= rsget("enddate")
					FItemList(i).FRegdate		= rsget("regdate")
					FItemList(i).FLastupdate	= rsget("lastupdate")
					FItemList(i).FAdminid		= rsget("adminid")
					FItemList(i).FLastadminid	= rsget("lastadminid")
					FItemList(i).FIsusing		= rsget("isusing")
				i=i+1
				rsget.moveNext
			Loop
		End If
		rsget.close
    End Sub

	Public Sub getMain3Mdpick(idxarr)
		Dim sqlStr, i, addSql
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as CNT, CEILING(CAST(Count(*) AS FLOAT)/" & FPageSize & ") as totPg "
		sqlStr = sqlStr & " FROM db_etcmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_item.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.idx in ("&idxarr&")"
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		If FTotalCount < 1 Then Exit Sub

		sqlStr = ""
		sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize*FCurrPage) & " i.*, "
		sqlStr = sqlStr & " pg.idx, isnull(pg.MainMdpickSortNo, 0) as MainMdpickSortNo, pg.MainMdpickXMLRegdate "
		sqlStr = sqlStr & " FROM db_etcmall.dbo.tbl_between_project_groupItem as pg "
		sqlStr = sqlStr & " JOIN db_item.dbo.tbl_item as i on pg.itemid = i.itemid "
		sqlStr = sqlStr & " WHERE 1 = 1 "
		sqlStr = sqlStr & " and pg.idx in ("&idxarr&")"
		sqlStr = sqlStr & " ORDER BY pg.MainMdpickSortNo ASC "
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsget.EOF Then
		    i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FBasicImage				= rsget("basicimage")
					If Not(FItemList(i).FBasicImage="" or isNull(FItemList(i).FBasicImage)) Then
						FItemList(i).FBasicImage = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("basicimage")
					Else
						FItemList(i).FBasicImage = "http://fiximage.10x10.co.kr/images/spacer.gif"
					End If
					FItemList(i).FItemid					= rsget("itemid")
					FItemList(i).FItemname					= rsget("itemname")
					FItemList(i).FSellcash					= rsget("sellcash")
					FItemList(i).FOrgprice					= rsget("orgprice")
					FItemList(i).FsaleYn					= rsget("sailyn")

				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.Close
	End Sub

	Public Sub getMainTopBanner
       Dim sqlStr, i
		sqlStr = ""
		sqlStr = sqlStr & " SELECT COUNT(*) as cnt FROM db_etcmall.dbo.tbl_between_main_topbanner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"

		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		'response.write sqlStr &"<br>"
		rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close

		If FTotalCount < 1 Then Exit Sub

        sqlStr = ""
		sqlStr = sqlStr & " SELECT idx, gender, pjt_kind, imgurl, linkURL, BanBGColor, partnerNMColor, BanTxtColor, bantext1, bantext2, isusing  "
		sqlStr = sqlStr & " FROM db_etcmall.dbo.tbl_between_main_topbanner "
		sqlStr = sqlStr & " WHERE 1 = 1 and isusing = 'Y'"
		If FRectGender <> "" Then	sqlStr = sqlStr & " and gender = '"&FRectGender&"' "
		sqlStr = sqlStr & " ORDER BY idx DESC"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FtotalPage =  CInt(FTotalCount\FPageSize)
		If (FTotalCount \ FPageSize) <> (FTotalCount / FPageSize) Then
			FTotalPage = FTotalPage +1
		End If
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If not rsget.EOF Then
		    i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				Set FItemList(i) = new CMainbannerItem
					FItemList(i).FIdx			= rsget("idx")
					FItemList(i).FGender		= rsget("gender")
					FItemList(i).FPjt_kind		= rsget("pjt_kind")
					FItemList(i).FImgurl		= rsget("imgurl")
					FItemList(i).FLinkURL		= rsget("linkURL")
					FItemList(i).FBanBGColor	= rsget("BanBGColor")
					FItemList(i).FPartnerNMColor= rsget("partnerNMColor")
					FItemList(i).FBanTxtColor	= rsget("BanTxtColor")
					FItemList(i).FBantext1		= rsget("bantext1")
					FItemList(i).FBantext2		= rsget("bantext2")
					FItemList(i).FFIsusing		= rsget("isusing")
				i=i+1
				rsget.moveNext
			Loop
		End If
		rsget.close
	End Sub

	Public Sub getMainItemlist()
		Dim sqlStr , i
		sqlStr = "EXECUTE [db_etcmall].[dbo].sp_Between_MainItem_CNT '" & FPageSize & "' "
		'response.write sqlStr
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget(0)
			FTotalPage	= rsget(1)
		rsget.close

		sqlStr = "EXECUTE db_etcmall.dbo.sp_Between_MainItem '" & FItemCnt & "', '"& FItemsort & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount - (FPageSize * (FCurrPage - 1))
        If (FResultCount < 1) Then FResultCount = 0
		Redim preserve FMainItemList(FResultCount)

		i = 0
		IF Not (rsget.EOF OR rsget.BOF) THEN
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				Set FMainItemList(i) = new CMainbannerItem
					FMainItemList(i).FItemID			= rsget("itemid")
					FMainItemList(i).FItemName			= db2html(rsget("itemname"))
					FMainItemList(i).FSellcash			= rsget("sellcash")
					FMainItemList(i).FOrgPrice   		= rsget("orgprice")
					FMainItemList(i).FMakerId   		= db2html(rsget("makerid"))
					FMainItemList(i).FBrandName  		= db2html(rsget("brandname"))
					FMainItemList(i).FSellYn			= rsget("sellyn")
					FMainItemList(i).FSaleYn			= rsget("sailyn")
					FMainItemList(i).FLimitYn			= rsget("limityn")
					FMainItemList(i).FLimitNo			= rsget("limitno")
					FMainItemList(i).FLimitSold			= rsget("limitsold")
					FMainItemList(i).FRegdate			= rsget("regdate")
					FMainItemList(i).FReipgodate		= rsget("reipgodate")
				    FMainItemList(i).Fitemcouponyn		= rsget("itemcouponYn")
					FMainItemList(i).FItemCouponValue	= rsget("itemCouponValue")
					FMainItemList(i).Fitemcoupontype	= rsget("itemCouponType")
					FMainItemList(i).Fevalcnt			= rsget("evalCnt")
					FMainItemList(i).FitemScore			= rsget("itemScore")
					FMainItemList(i).Fitemdiv			= rsget("itemdiv")
					FMainItemList(i).FImageBasic		= rsget("basicimage")
					FMainItemList(i).FCatecode		= rsget("catecode")
				i = i + 1
				rsget.moveNext
			Loop
		End If
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
								<span class="seller"><%= cMainItem.FMainItemList(intI).FBrandName %></span>
								<% If vItemClass = "sale" Then %><p class="pdtTag saleRed"><%=cMainItem.FMainItemList(intI).getSalePro%></p><% End If %>
							</a>
						</div>
					</li>
<%
			vItemClass = ""
			i = i + 1
		Next
		If CInt(vPage) >= "3" Then
			Response.Write "<script>$('#newbtn').hide();</script>"
		End If
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
								<span class="seller"><%= cMainItem.FMainItemList(intI).FBrandName %></span>
								<% If vItemClass = "sale" Then %><p class="pdtTag saleRed"><%=cMainItem.FMainItemList(intI).getSalePro%></p><% End If %>
							</a>
						</div>
					</li>
<%
			vItemClass = ""
			i = i + 1
			iNum = iNum + 1
		Next
		If CInt(vPage2) >= "3" Then
			Response.Write "<script>$('#bestbtn').hide();</script>"
		End If

	End If
	Set cMainItem = Nothing
End Sub
%>
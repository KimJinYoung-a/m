<%
Class CDBSearchItem
	public Fidx
	public Fdisp
	public Fdispname
	public Fbggubun
	public Fbgcolor
	public Fbgimg
	public Fmaskingimg
	public Ftextinfouse
	public Ftextinfo1
	public Ftextinfo1url
	public Ftextinfo2
	public Ftextinfo2url
	public Fquicklinkbody


	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class
			
Class CDBSearch
	public FItemList()
	public FItemOne
	public FOneItem
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FRectDisp
	public FRectKeyword
	public FRectIDX
	public FRectDevice
	public FRectIsMasking
	public FRectUseYN
	public FRectNowDate


	Private Sub Class_Initialize()
		FCurrPage = 1
		FTotalPage = 0
		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
		FRectDisp = "0"
	End Sub
	Private Sub Class_Terminate()
	End Sub


	public Function fnDispNameList()
		dim sqlStr, i

		sqlStr = "EXEC [db_item].[dbo].[sp_Ten_Display_DownCateList] '" & FRectDisp & "' "
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		FResultCount = rsget.RecordCount
		if (FResultCount<1) then FResultCount=0
		FTotalCount = FResultCount

		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnDispNameList = rsget.getRows()
		END IF
		rsget.Close
    End Function
    
    
	public Sub fnSearchScreen()
        dim sqlStr, sqlsearch, i

        '// 본문 내용 접수
		sqlStr = "EXEC [db_sitemaster].[dbo].[usp_Ten_SearchScreenView] "
		sqlStr = sqlStr & "'" & FRectDevice & "', '" & FRectIDX & "','" & FRectIsMasking & "','" & FRectUseYN & "','" & FRectNowDate & "'"
		'response.write sqlStr &"<Br>"
		'response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		FResultCount = rsget.RecordCount
		
		set FOneItem = new CDBSearchItem
		
		if Not rsget.Eof then
			If FRectIsMasking = "o" Then
				FOneItem.Fmaskingimg		= rsget("maskingimg")
			Else
				FOneItem.Fbggubun		= rsget("bggubun")
				FOneItem.Fbgcolor		= rsget("bgcolor")
				FOneItem.Fbgimg			= rsget("bgimg")
				FOneItem.Fmaskingimg		= rsget("maskingimg")
				FOneItem.Ftextinfouse	= rsget("textinfouse")
				FOneItem.Ftextinfo1		= rsget("textinfo1")
				FOneItem.Ftextinfo1url	= rsget("textinfo1url")
				FOneItem.Ftextinfo2		= rsget("textinfo2")
				FOneItem.Ftextinfo2url	= rsget("textinfo2url")
			End If
		end if
        rsget.Close
    end Sub
    
    
	public Function fnSearchCuratorList()
		dim sqlStr, i

		sqlStr = "EXEC [db_sitemaster].[dbo].[usp_Ten_Search_Curator] '" & FRectKeyword & "'"
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		
		i=0
		IF Not (isNull(rsget(0))) THEN
			do until rsget.eof
				set FItemList(i) = new CCategoryPrdItem

				FItemList(i).Fidx		= rsget("idx")
				FItemList(i).Ftitle		= db2html(rsget("title"))
				FItemList(i).Fbgclass	= rsget("bgclass")
				FItemList(i).FItemName	= db2html(rsget("itemname"))
				FItemList(i).Fitemgubun	= rsget("gubun")
				FItemList(i).FItemID		= rsget("contentsidx")
				
				If rsget("gubun") = "item" Then
					FItemList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsget("contentsidx")) & "/" & rsget("basicimage")
				Else
					FItemList(i).FImageBasic		= rsget("basicimage")
				End If

				FItemList(i).Fitemdiv		= rsget("itemdiv")
				FItemList(i).FSellCash 		= rsget("sellcash")
				FItemList(i).FOrgPrice 		= rsget("orgprice")
				FItemList(i).FSellyn 		= rsget("sellyn")
				FItemList(i).FSaleyn 		= rsget("sailyn")
				FItemList(i).FLimityn 		= rsget("limityn")
				FItemList(i).FItemcouponyn 	= rsget("itemcouponyn")
				FItemList(i).FItemCouponValue 	= rsget("itemCouponValue")
				FItemList(i).FItemCouponType 	= rsget("itemCouponType")
				FItemList(i).FLimitNo      = rsget("limitno")
				FItemList(i).FLimitSold    = rsget("limitsold")
              	FItemList(i).FOptionCnt = rsget("optioncnt")
	
              	FItemList(i).Fevt_kind	= rsget("evt_kind")
              	FItemList(i).Fevt_linktype = rsget("evt_linktype")
              	FItemList(i).Fevt_bannerlink = rsget("evt_bannerlink")
				FItemList(i).FAdultType = rsget("adultType")

				i=i+1
				rsget.moveNext
			loop
		ELSE
			FResultCount = 0
		END IF
		rsget.Close
    End Function
    
    
	public Function fnSearchQuickLink()
		dim sqlStr, i
		sqlStr = "EXEC [db_sitemaster].[dbo].[usp_Ten_Search_QuickLink] '" & FRectKeyword & "', '" & FRectIDX & "' "
		'response.write sqlStr & "<br>"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		
		FResultCount = rsget.RecordCount

		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnSearchQuickLink = rsget.getRows()
		END IF
		rsget.Close
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


Function fnFullNameDisplay(fullname,keyword)
	Dim vTemp
	vTemp = Replace(fullname, keyword, "<b>" & keyword & "</b>")
	vTemp = Replace(vTemp, "^^", " &gt; ")
	fnFullNameDisplay = vTemp
End Function


Function fnMaskingImage()
	Dim cSScrn, vMasking
	SET cSScrn = New CDBSearch
	cSScrn.FRectDevice = "m"
	cSScrn.FRectIsMasking = "o"
	cSScrn.FRectUseYN = "y"
	cSScrn.FRectDevice = "m"
	cSScrn.FRectNowDate = date() & " 10:00:00"
	cSScrn.fnSearchScreen
	vMasking = "i$$" & cSScrn.FOneItem.Fmaskingimg

	If cSScrn.FResultCount < 1 Then
		vMasking = "c$$BAD3E0"
	End If
	SET cSScrn = Nothing
	fnMaskingImage = vMasking
End Function


Function fnFirstCharacter(word)
	Dim vArr1, vArr2, vTemp, i
	vArr1 = "가나다라마바사아자차카타파하"
	vArr2 = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ"
	
	If word = "Ω" Then
		vTemp = "etc"
	Else
		i = InStr(vArr1,word)
		vTemp = Mid(vArr2,i,1)
	End If
	fnFirstCharacter = vTemp
End Function


Function fnSalePojang(s,p)
	Dim r
	If s = "sc" and p = "o" Then
		r = "scpk"
	ElseIf s <> "sc" and p <> "o" Then
		r = ""
	ElseIf s = "sc" and p <> "o" Then
		r = "sc"
	ElseIf s <> "sc" and p = "o" Then
		r = "pk"
	Else
		r = s
	End If
	fnSalePojang = r
End Function


Function fnGetSearchEventClass(i)
	Dim c
	SELECT CASE i mod 4
		Case 0 : c = "blue"
		Case 1 : c = "pink"
		Case 2 : c = "green"
		Case 3 : c = "yellow"
	END SELECT
	fnGetSearchEventClass = c
End Function

Function fnCleanSearchValue(m)
	Dim vTemp
	vTemp = m
	If vTemp <> "" Then
		If Right(vTemp, 1) = "," Then
			vTemp = Trim(Left(vTemp, Len(vTemp)-1))
		End If
		If Left(vTemp, 1) = "," Then
			vTemp = Trim(Right(vTemp, Len(vTemp)-1))
		End If
	End IF
	fnCleanSearchValue = vTemp
End Function

Function fnGetCompareItem(g,userid)
	Dim sqlStr, arr, itemid
	If g = "list" Then
		sqlStr = "select c.itemid, i.basicimage, i.adultType from db_my10x10.dbo.tbl_my_itemCompare as c "
		sqlStr = sqlStr & "left join db_item.dbo.tbl_item as i on c.itemid = i.itemid "
		sqlStr = sqlStr & "where c.userid = '"&userid&"' "
		sqlStr = sqlStr & "order by c.itemid desc"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if not rsget.eof then
			arr = rsget.getRows()
		End If
		rsget.close
	ElseIf g = "count" Then
		sqlStr = "select count(c.itemid) from db_my10x10.dbo.tbl_my_itemCompare as c "
		sqlStr = sqlStr & "where c.userid = '"&userid&"'"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if not rsget.eof then
			arr = rsget(0)
		End If
		rsget.close
	ElseIf g = "load" Then
		itemid = userid	'### userid 자리에 상품코드 받아옴.
		If itemid <> "" Then
			sqlStr = "select itemid, basicimage, adultType from db_item.dbo.tbl_item "
			sqlStr = sqlStr & "where itemid in("&userid&")"
			sqlStr = sqlStr & "order by itemid desc"
			rsget.CursorLocation = adUseClient
			rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
			if not rsget.eof then
				arr = rsget.getRows()
			End If
			rsget.close
		End If
	End If
	
	fnGetCompareItem = arr
End Function


Function fnGetDispName(d)
	Dim sqlStr, dname
	if d <> "" Then
		sqlStr = "select [db_item].[dbo].[getDisplayCateName]('" & d & "')"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		if not rsget.eof then
			dname = rsget(0)
		end if
		rsget.close
	end if
	fnGetDispName = dname
End Function


Function fnURLTypeGB(u)
	Dim vTmp, vResult
	If InStr(u,"/") > 0 Then
		vTmp = Split(u,"/")(1)
		vTmp = LCase(vTmp)
	End If
	
	SELECT CASE vTmp
		case "category"
			If InStr(u,"category_list.asp") > 0 Then
				vResult = "category"
			ElseIf InStr(u,"category_itemPrd.asp") > 0 Then
				vResult = "prd"
			Else
				vResult = "etc"
			End If
		case "street" : vResult = "brand"
		case "search" : vResult = "search"
		case "event" : vResult = "event"
		case else : vResult = "etc"
	END SELECT
	fnURLTypeGB = vResult
End Function


Function fnEventNameSplit(ename,gubun)
	Dim tmp
	If InStr(ename,"|") > 0 Then
		If gubun = "name" Then
			tmp = Split(ename,"|")(0)
		ElseIf gubun = "salecoupon" Then
			tmp = Split(ename,"|")(1)
		End If
	Else
		tmp = ename
	End If
	fnEventNameSplit = tmp
End Function


Function fnMoAppDifferentURL(u)
	Dim vURL : vURL = u
	If InStr(vURL, "/shoppingtoday/shoppingchance_newitem.asp") > 0 Then	'### NEW 앱 경로
		vURL = Replace(vURL,"/shoppingtoday/shoppingchance_newitem.asp","/newitem/newitem.asp")
	ElseIf InStr(vURL, "/shoppingtoday/shoppingchance_saleitem.asp") > 0 Then	'### SALE 앱 경로
		vURL = Replace(vURL,"/shoppingtoday/shoppingchance_saleitem.asp","/sale/saleitem.asp")
	ElseIf InStr(vURL, "/award/awarditem.asp") > 0 Then	'### Best 파라메터 붙임.
		If InStr(vURL,"?") > 0 Then
			vURL = vURL & "&gnbflag=1"
		Else
			vURL = vURL & "?gnbflag=1"
		End If
	ElseIf InStr(vURL, "/playing/") > 0 Then	'### Playing 파라메터 붙임.
		If InStr(vURL,"?") > 0 Then
			vURL = vURL & "&gnbflag=1"
		Else
			vURL = vURL & "?gnbflag=1"
		End If
	End IF
	fnMoAppDifferentURL = vURL
End Function
%>
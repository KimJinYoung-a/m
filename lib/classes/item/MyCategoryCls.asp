<%
Class cateLargeItem
	public FcdL
	public FCdLName
	public Fcatecode
	public Fcatename
	public FIsEnd
	public fcateimage
	public fisnew
	Public Fishot
	Public Fkword1
	Public Fkword2
	Public Fkword3
	Public Fkwordurl1
	Public Fkwordurl2
	Public Fkwordurl3
	Public Fappdiv
	Public Fappcate

End Class

CLASS MyCategoryCls
	public FUserID
	public FDepth
	public FDisp
	public FResultCount
	public ftotalcount
	public FItemList
	public foneitem
	
	'####### 내카테고리 리스트
	public Function fnMyCategoryListLeft
		'####### 카테고리코드 한개 필드만 받아옴. catecode 값.
		Dim strSql, i, vArr, vBody
		strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_MyCategory_GetList] '" & FUserID & "', '" & FDepth & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open strSQL, dbget
		
		If Not rsget.EOF Then
			vArr = rsget.GetRows()
			For i = 0 To UBound(vArr,2)
				If Len(vArr(0,i)) = 2 OR Len(vArr(0,i)) = 5 OR Len(vArr(0,i)) = 8 Then
					vBody = vBody & "0" & vArr(0,i) & "|"
				Else
					vBody = vBody & vArr(0,i) & "|"
				End IF
			Next
			fnMyCategoryListLeft = vBody
		End if
		rsget.close
	End Function

	'####### 대카테고리 리스트
	public Function fnCategoryLargeList
		'####### 전체 대카테고리 목록 받아옴
		Dim strSql, i, vArr, vBody
		strSql = "select code_large, code_nm " &_
				" from db_item.dbo.tbl_cate_large " &_
				" where display_yn='Y' " &_
				"	and code_large<>'999' " &_
				" order by orderNo"
		rsget.Open strSQL, dbget, 1

		FResultCount = rsget.RecordCount
		REDIM FItemList(FResultCount)

		If Not(rsget.EOF or rsget.BOF) Then
			For i = 0 To rsget.RecordCount-1
				SET FItemList(i) = new cateLargeItem
				FItemList(i).FCdL		= rsget("code_large")
				FItemList(i).FCdLName	= rsget("code_nm")
				rsget.MoveNext
			Next
		End if
		rsget.close
	End Function
	
	'####### 전시카테고리 1뎁스 리스트
	public Function fnDisplayCategoryList
		'####### 전체 대카테고리 목록 받아옴
		Dim strSql, i, vArr, vBody
		
		strSql = "select c.catecode, c.catename, c.isnew" &_
				" ,(select count(catecode) from db_item.dbo.tbl_display_cate where depth = '" & FDepth+1 & "' and useyn='Y' and Left(catecode,Len(c.catecode)) = c.catecode) as isend " &_
				" , case when dh.catecode <> '' then 'o' else 'x' end as ishot " &_
				" from db_item.dbo.tbl_display_cate as c " &_
				" left outer join [db_sitemaster].[dbo].[tbl_dispcate_hot] as dh " &_
				" on c.catecode = dh.catecode " &_
				" where c.depth = '" & FDepth & "' and c.useyn='Y' "
				
				If FDepth > 1 Then
					strSql = strSql & " and Left(c.catecode," & Len(FDisp) & ") = '" & FDisp & "' "
				End IF
				
		strSql = strSql & " order by c.sortNo asc"

		'response.write strSql & "<br>"
		rsget.Open strSQL, dbget, 1
		
		FResultCount = rsget.RecordCount
		REDIM FItemList(FResultCount)

		If Not(rsget.EOF or rsget.BOF) Then
			For i = 0 To rsget.RecordCount-1
				SET FItemList(i) = new cateLargeItem
				
				FItemList(i).Fcatecode	= rsget("catecode")
				FItemList(i).Fcatename  = db2html(rsget("catename"))
				FItemList(i).fisnew	= rsget("isnew")
				FItemList(i).FIsEnd		= CStr(rsget("isend"))
				FItemList(i).Fishot		= CStr(rsget("ishot"))
				
				rsget.MoveNext
			Next
		End if
		rsget.close
	End Function

	'####### 전체 대카테고리 목록 받아옴, 대표 이미지 포함		'/2013.12.15 한용민 생성
	'/category/category_main.asp
	public Function fnDisplayCategoryimageList
		Dim strSql, i
		
		strSql = "select top 1000"
		strSql = strSql & " c.catecode, c.catename, c.isnew, g.cateimage"
		strSql = strSql & " from db_item.dbo.tbl_display_cate as c"
		strSql = strSql & " left join db_sitemaster.dbo.tbl_mobile_cateimg g"
		strSql = strSql & " 	on c.catecode=g.catecode"
		strSql = strSql & " 	and g.isusing='Y'"
		strSql = strSql & " where c.depth = '" & FDepth & "' and c.useyn='Y'"
				
		If FDepth > 1 Then
			strSql = strSql & " and Left(c.catecode," & Len(FDisp) & ") = '" & FDisp & "' "
		End IF
				
		strSql = strSql & " order by c.sortNo asc"

		'response.write strSql & "<br>"
		rsget.Open strSQL, dbget, 1
		
		FResultCount = rsget.RecordCount
		REDIM FItemList(FResultCount)

		If Not(rsget.EOF or rsget.BOF) Then
			For i = 0 To rsget.RecordCount-1
				SET FItemList(i) = new cateLargeItem
				
				FItemList(i).Fcatecode	= rsget("catecode")
				FItemList(i).Fcatename	= db2html(rsget("catename"))
				FItemList(i).fisnew	= rsget("isnew")				
				FItemList(i).fcateimage		= staticImgUrl & "/mobile/catecode" & db2html(rsget("cateimage"))
				
				rsget.MoveNext
			Next
		End if
		rsget.close
	End Function
	
	'/카테고리 정보 가져오기		'/2013.12.15 한용민 생성
	'//category/category_sub.asp
	public Function fnDisplayCategoryone
		Dim strSql, i
		
		if FDisp="" then exit Function
		
		strSql = "select top 1"
		strSql = strSql & " c.catecode, c.catename, c.isnew "
		strSql = strSql & " , case when dh.catecode <> '' then 'o' else 'x' end as ishot "
		strSql = strSql & " , g.kword1 , g.kword2 , g.kword3 , g.kwordurl1 , g.kwordurl2 , g.kwordurl3 "
		strSql = strSql & " from db_item.dbo.tbl_display_cate as c "
		strSql = strSql & " left outer join [db_sitemaster].[dbo].[tbl_dispcate_hot] as dh "
		strSql = strSql & " on c.catecode = dh.catecode "
		strSql = strSql & " left join db_sitemaster.dbo.tbl_mobile_cateimg g"
		strSql = strSql & " on c.catecode=g.catecode "
		strSql = strSql & " and g.isusing='Y' "
		strSql = strSql & " where c.useyn='Y' and c.catecode='"& FDisp &"'"

		'response.write strSql & "<br>"
		rsget.Open strSQL, dbget, 1

		ftotalcount = rsget.RecordCount

		If Not(rsget.EOF or rsget.BOF) Then
			SET foneitem = new cateLargeItem
			
			foneitem.Fcatecode	= rsget("catecode")
			foneitem.Fcatename  = db2html(rsget("catename"))
			foneitem.fisnew	= rsget("isnew")
			foneitem.Fishot	= rsget("ishot")
			foneitem.Fkword1	= rsget("kword1")
			foneitem.Fkword2	= rsget("kword2")
			foneitem.Fkword3	= rsget("kword3")
			foneitem.Fkwordurl1	= rsget("kwordurl1")
			foneitem.Fkwordurl2	= rsget("kwordurl2")
			foneitem.Fkwordurl3	= rsget("kwordurl3")

		End if
		rsget.close
	End Function


	'####### 인기태그 2014 리뉴얼 추가 - 이종화
	'/category/category_sub.asp
	public Function fnDispCateTag
		Dim strSql, i
		
		strSql = "select  "
		strSql = strSql & " catecode , kword1 , kwordurl1 , kwordurl2 , appdiv , appcate "
		strSql = strSql & " from  db_sitemaster.dbo.tbl_mobile_catetag as g "
		strSql = strSql & " where catecode = '" & FDisp & "' and isusing='Y'"
		strSql = strSql & " order by idx asc"

		'response.write strSql & "<br>"
		rsget.Open strSQL, dbget, 1
		
		FResultCount = rsget.RecordCount
		REDIM FItemList(FResultCount)

		If Not(rsget.EOF or rsget.BOF) Then
			For i = 0 To rsget.RecordCount-1
				SET FItemList(i) = new cateLargeItem
				
				FItemList(i).Fcatecode	= rsget("catecode")
				FItemList(i).Fkword1	= rsget("kword1")
				FItemList(i).Fkwordurl1	= rsget("kwordurl1")
				FItemList(i).Fkwordurl2	= rsget("kwordurl2")
				FItemList(i).Fappdiv	= rsget("appdiv")
				FItemList(i).Fappcate	= rsget("appcate")
				
				rsget.MoveNext
			Next
		End if
		rsget.close
	End Function

	
	'####### 내찜브랜드리스트 & 없을땐 베스트3개.
	public Function fnMyZzimBrandList
		'####### userid, socname, isnew, 추천인지내가찜한것인지 구분값(b or m) 필드만 받아옴. 배열순서동일.
		Dim strSql
		strSql = "EXECUTE [db_my10x10].[dbo].[sp_Ten_MyZzimBrand_inCate] '" & FUserID & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open strSQL, dbget
		
		FResultCount = rsget.RecordCount
		
		If Not rsget.EOF Then
			fnMyZzimBrandList = rsget.GetRows()
		End if
		rsget.close
		
		If FResultCount < 1 Then
			strSql = "SELECT TOP 5 c.userid, c.socname_kor, (select case when count(itemid) > 0 then 'o' else 'n' end as isnew from db_item.dbo.tbl_item where makerid = c.userid and regdate > dateadd(d,-15,getdate())) as isnew, 'b' " & _
					 "	FROM [db_user].[dbo].tbl_user_c AS c " & _
					 "	WHERE c.smilerank<>0 AND c.isusing='Y' AND c.streetusing='Y' AND c.modelitem is Not NULL AND c.hitrank < 21 " & _
					 "ORDER BY newid()"
			rsget.Open strSql,dbget
			fnMyZzimBrandList = rsget.getRows()
			FResultCount = rsget.RecordCount
			rsget.close
		End If
	End Function
	
End Class


Function fnCheckMyCategory(arr,cate)
	If InStr(arr,cate) > 0 Then
		fnCheckMyCategory = True
	Else
		fnCheckMyCategory = False
	End If
End Function


Function fnCategoryListSelectBox(cate1,cate2,cate3)
	Dim oGrCat, GRScope, lp
	If cate1 = "" Then
		GRScope = "large"
	ElseIf cate2 = "" Then
		GRScope = "mid"
	ElseIf cate3 = "" Then
		GRScope = "small"
	End if
	
	If cate1 <> "" AND cate2 <> "" AND cate3 <> "" Then
		GRScope = "small"
	End If

	Set oGrCat = new SearchItemCls
	oGrCat.FRectSortMethod = ""
	oGrCat.FRectSearchFlag = ""
	oGrCat.FCurrPage = 1
	oGrCat.FPageSize = 200
	oGrCat.FScrollCount =10
	oGrCat.FListDiv = "category"
	oGrCat.FRectCdL	= cate1
	oGrCat.FRectCdM	= cate2
	'oGrCat.FRectCdS	= cate3
	oGrCat.FdeliType	= ""
	oGrCat.FcolorCode	= ""
	oGrCat.FGroupScope = GRScope
	
	oGrCat.FLogsAccept = False '그룹형은 절대 !!! False
	oGrCat.getGroupbyCategoryList
	
	If oGrCat.FResultCount>0 Then
		FOR lp = 0 to oGrCat.FResultCount-1
			If GRScope = "large" Then
				If oGrCat.FItemList(lp).FCdLName <> "" Then
					Response.Write "<option value=""" & oGrCat.FItemList(lp).FcdL & """>" & db2html(oGrCat.FItemList(lp).FCdLName) & " (" & oGrCat.FItemList(lp).FSubTotal & ")</option>"
				End IF
			ElseIf GRScope = "mid" Then
				If oGrCat.FItemList(lp).FCdMName <> "" Then
					Response.Write "<option value=""" & oGrCat.FItemList(lp).FcdM & """>" & db2html(oGrCat.FItemList(lp).FCdMName) & " (" & oGrCat.FItemList(lp).FSubTotal & ")</option>"
				End IF
			ElseIf GRScope = "small" Then
				If oGrCat.FItemList(lp).FCdSName <> "" Then
					Response.Write "<option value=""" & oGrCat.FItemList(lp).FcdS & """ " & CHKIIF(oGrCat.FItemList(lp).FcdS=cate3,"selected","") & ">" & db2html(oGrCat.FItemList(lp).FCdSName) & " (" & oGrCat.FItemList(lp).FSubTotal & ")</option>"
				End IF
			End If
		Next
	End If
	
	set oGrCat = nothing
End Function
%>
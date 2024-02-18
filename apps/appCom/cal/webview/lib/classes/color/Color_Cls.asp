<%
'#######################################################
'	Description : 컬러 클래스
'	History	:  2014.02.17 한용민 생성
'#######################################################

Class Ccoloritem
	Public FIdx
	Public FColorCode
	Public FColorName
	Public FIconImageUrl1
	Public FIconImageUrl2
	Public FColor_str
	Public FWord_rgbCode
	Public FIsusing
	Public FRegdate
	Public FSortNo
	Public FYyyymmdd
	Public FImageURL
	Public FImageURL2
	Public FColor_idx
	Public FLastupdate
	Public FRegedItemCnt
	Public FItemid
	Public FSellyn
	Public FItemisusing
	Public FImageSmall
	Public FImageicon1
	public FImageBasic
	public fitemname
End Class

Class Ccolorlist
    public FItemList()
    public FOneItem
	public FCurrPage
	public FTotalPage
	public FTotalCount
	public FPageSize
	public FPageCount
	public FResultCount
	public FScrollCount
	
	public FRectyyyymmdd
	
	'/apps/appcom/cal/webview/color/dailylist.asp
	Public Sub getDailyColoritemlist
		Dim sqlStr, i, sqladd
		
		if FRectyyyymmdd="" then exit Sub
		
		if FRectyyyymmdd<>"" then
			sqladd = sqladd & " and d.yyyymmdd='"& FRectyyyymmdd &"'"
		end if
		
'		sqlStr = "SELECT count(*) as cnt"
'		sqlStr = sqlStr & " FROM db_contents.dbo.tbl_app_color_detail as d"
'		sqlStr = sqlStr & " JOIN db_item.dbo.tbl_item as i"
'		sqlStr = sqlStr & " 	on d.itemid = i.itemid"
'		sqlStr = sqlStr & " WHERE d.isusing='Y' and i.isusing='Y' and i.sellyn<>'N' " & sqladd
'
'		'response.write sqlStr & "<br>"
'		rsget.Open sqlStr,dbget,1
'			FTotalCount = rsget("cnt")
'		rsget.Close
'
'		If FTotalCount<1 Then
'			Exit Sub
'		End If

		sqlStr = "SELECT TOP " & CStr(FPageSize*FCurrPage)
		sqlStr = sqlStr & " d.yyyymmdd, d.itemid, d.regdate, d.sortNo"
		sqlStr = sqlStr & " , i.itemname, i.smallimage, i.icon1image, i.basicimage"
		sqlStr = sqlStr & " FROM db_contents.dbo.tbl_app_color_detail as d"
		sqlStr = sqlStr & " JOIN db_item.dbo.tbl_item as i"
		sqlStr = sqlStr & " 	on d.itemid = i.itemid"
		sqlStr = sqlStr & " WHERE d.isusing='Y' and i.isusing='Y' and i.sellyn<>'N' " & sqladd
		sqlStr = sqlStr & " ORDER BY d.sortNo asc, i.itemid desc"
		
		'response.write sqlStr & "<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		
		FTotalCount = rsget.RecordCount
		FResultCount = rsget.RecordCount
'		If (FCurrPage * FPageSize < FTotalCount) Then
'			FResultCount = FPageSize
'		Else
'			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
'		End If
'		FTotalPage = (FTotalCount\FPageSize)
'		If (FTotalPage<>FTotalCount/FPageSize) Then FTotalPage = FTotalPage +1
		Redim preserve FItemList(FResultCount)
		FPageCount = FCurrPage - 1
		i = 0
		If not rsget.EOF Then
			rsget.absolutepage = FCurrPage
			Do until rsget.EOF
				Set FItemList(i) = new Ccoloritem

					FItemList(i).FYyyymmdd		= rsget("yyyymmdd")
					FItemList(i).FItemid		= rsget("itemid")
					FItemList(i).FRegdate		= rsget("regdate")
					FItemList(i).FSortNo		= rsget("sortNo")
					FItemList(i).fitemname		= rsget("itemname")
					FItemList(i).FImageSmall	= rsget("smallimage")
					If FItemList(i).FImageSmall <> "" Then FItemList(i).FImageSmall = "http://webimage.10x10.co.kr/image/small/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & FItemList(i).FImageSmall
					FItemList(i).FImageicon1	= rsget("icon1image")
					If FItemList(i).FImageicon1 <> "" Then FItemList(i).FImageicon1 = "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & FItemList(i).FImageicon1
					FItemList(i).FImageBasic	= rsget("basicimage")
					If FItemList(i).FImageBasic <> "" Then FItemList(i).FImageBasic = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(FItemList(i).FItemid) & "/" & FItemList(i).FImageBasic
				
				rsget.movenext
				i = i + 1
			Loop
		End If
		rsget.Close
	End Sub

	'/apps/appcom/cal/webview/color/dailylist.asp
	Public Sub getDailyColorinfo
		Dim strSQL, sqladd

		if FRectyyyymmdd<>"" then
			sqladd = sqladd & " and m.yyyymmdd='"& FRectyyyymmdd &"'"
		end if
		
		strSQL = "SELECT top 1"
		strSQL = strSQL & " M.yyyymmdd, M.imageURL, M.imageURL2, M.color_idx"
		strSQL = strSQL & " ,l.colorCode, l.colorName, l.iconImageUrl1, l.iconImageUrl2, l.color_str, l.word_rgbCode"
		strSQL = strSQL & " FROM db_contents.dbo.tbl_app_color_master m"
		strSQL = strSQL & " join db_contents.dbo.tbl_app_color_list l"
		strSQL = strSQL & " 	on M.color_idx = L.idx"
		strSQL = strSQL & " WHERE l.isusing='Y' " & sqladd
		strSQL = strSQL & " order by M.yyyymmdd desc"
		
		'response.write strSQL & "<br>"
        rsget.Open strSQL, dbget, 1
        
		FTotalCount = rsget.RecordCount
		
        Set FOneItem = new Ccoloritem
        If Not rsget.EOF Then

			FOneitem.FYyyymmdd		= rsget("yyyymmdd")
			FOneitem.FImageURL		= rsget("imageURL")
			FOneitem.FImageURL2	= rsget("imageURL2")
			FOneitem.FColor_idx	= rsget("color_idx")			
			FOneitem.fcolorCode	= rsget("colorCode")
			FOneitem.FColorName	= db2html(rsget("colorName"))
			FOneitem.ficonImageUrl1	= rsget("iconImageUrl1")
			FOneitem.ficonImageUrl2	= rsget("iconImageUrl2")
			FOneitem.fcolor_str	= rsget("color_str")
			FOneitem.fword_rgbCode	= rsget("word_rgbCode")

        End If
		rsget.Close
	End Sub
	
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	Public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	End Function
	Public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	End Function
	Public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	End Function
End Class	
%>
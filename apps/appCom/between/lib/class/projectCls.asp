<%
Class CProjectItem
	public FPCode
	public FPName
	public FPKind
	public FPTopImg
	public FPGender
	public FPState
	public FPRegdate
	public FPIsUsing
	public FPLastupdate
	public FPSortType

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
End Class

Class CProject
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FTotCnt
	
	public FRectPCode
	public FRectPGCode
    public FRectIdx
    public Fisusing
	Public FRectGender
	Public FEItemCnt
	Public FItemsort
	Public FItemArr
	public FCategoryPrdList()

	

	'### 기획리스트
    Public Function getProjectGroupList()
        Dim sqlStr, i
		IF 	FRectPCode = "" THEN Exit Function
		IF  FRectPGCode = "" THEN FRectPGCode = 0
			
		sqlStr = "[db_outmall].[dbo].[sp_Between_projectitem_group]('" & FRectPCode & "', '" & FRectPGCode & "')"
		'response.write sqlStr
		rsCTget.Open sqlStr, dbCTget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsCTget.EOF OR rsCTget.BOF) THEN
			getProjectGroupList = rsCTget.getRows()
		End If
		rsCTget.close
    End Function
    

    public Sub getOneProject()
        dim strSql
        IF 	FRectPCode = "" THEN Exit Sub

		strSql = "[db_outmall].[dbo].[sp_Between_project_content]('" & FRectPCode & "')"
		rsCTget.Open strSql, dbCTget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		
		Set FOneItem = New CProjectItem
			IF Not (rsCTget.EOF OR rsCTget.BOF) THEN
				FOneItem.FPCode = rsCTget("pjt_code")
				FOneItem.FPName = rsCTget("pjt_name")
				FOneItem.FPKind = rsCTget("pjt_kind")
				FOneItem.FPTopImg = rsCTget("pjt_topImgUrl")
				FOneItem.FPGender = rsCTget("pjt_gender")
				FOneItem.FPState = rsCTget("pjt_state")
				FOneItem.FPRegdate = rsCTget("pjt_regdate")
				FOneItem.FPIsUsing = rsCTget("pjt_using")
				FOneItem.FPLastupdate = rsCTget("pjt_lastupdate")
				FOneItem.FPSortType = rsCTget("pjt_sortType")
   			ELSE
   				FOneItem.FPCode = ""
			END IF
		rsCTget.close
    end Sub
    
    
	'##### 상품 리스트 ######
	public Function getProjectItem
		Dim strSql, arrItem,intI
		IF FRectPCode = "" THEN Exit Function
		IF FRectPGCode = "" THEN FRectPGCode= 0
			
			 
		strSql = "EXECUTE [db_outmall].[dbo].sp_Between_project_GetItem_Count " & FPageSize & ", " & FRectPCode & ", " & FRectPGCode & ", " & FEItemCnt & ""
		'response.write strSql
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.Open strSql,dbCTget,1
			FTotalCount = rsCTget(0)
			FTotalPage	= rsCTget(1)
		rsCTget.close
			
		strSql = "EXECUTE [db_outmall].[dbo].sp_Between_project_GetItem " & FRectPCode & ", " & FRectPGCode & ", " & FEItemCnt & ", " & FItemsort & ""
		rsCTget.CursorLocation = adUseClient
		rsCTget.CursorType = adOpenStatic
		rsCTget.LockType = adLockOptimistic
		rsCTget.pagesize = FPageSize
		'response.write strSql
		rsCTget.Open strSql,dbCTget,1
		FResultCount = rsCTget.RecordCount-(FPageSize*(FCurrPage-1))
        if (FResultCount<1) then FResultCount=0
		redim preserve FCategoryPrdList(FResultCount)

		intI = 0
		IF Not (rsCTget.EOF OR rsCTget.BOF) THEN
			rsCTget.absolutepage = FCurrPage
			do until rsCTget.eof
				set FCategoryPrdList(intI) = new CCategoryPrdItem
					FCategoryPrdList(intI).FItemID       = rsCTget("itemid")
					FCategoryPrdList(intI).FItemName    = db2html(rsCTget("itemname"))
	
					FCategoryPrdList(intI).FSellcash    = rsCTget("sellcash")
					FCategoryPrdList(intI).FOrgPrice   	= rsCTget("orgprice")
					FCategoryPrdList(intI).FMakerId   	= db2html(rsCTget("makerid"))
					FCategoryPrdList(intI).FBrandName  	= db2html(rsCTget("brandname"))
	
					FCategoryPrdList(intI).FSellYn      = rsCTget("sellyn")
					FCategoryPrdList(intI).FSaleYn     	= rsCTget("sailyn")
					FCategoryPrdList(intI).FLimitYn     = rsCTget("limityn")
					FCategoryPrdList(intI).FLimitNo     = rsCTget("limitno")
					FCategoryPrdList(intI).FLimitSold   = rsCTget("limitsold")
	
					FCategoryPrdList(intI).FRegdate 		= rsCTget("regdate")
					FCategoryPrdList(intI).FReipgodate		= rsCTget("reipgodate")
	
	                FCategoryPrdList(intI).Fitemcouponyn 	= rsCTget("itemcouponYn")
					FCategoryPrdList(intI).FItemCouponValue= rsCTget("itemCouponValue")
					FCategoryPrdList(intI).Fitemcoupontype	= rsCTget("itemCouponType")
	
					FCategoryPrdList(intI).Fevalcnt 		= rsCTget("evalCnt")
					FCategoryPrdList(intI).FitemScore 		= rsCTget("itemScore")
	
					FCategoryPrdList(intI).FItemSize	= rsCTget("itemsize")
					FCategoryPrdList(intI).Fitemdiv		= rsCTget("itemdiv")
					
					FCategoryPrdList(intI).FImageBasic = rsCTget("basicimage")
	
				intI=intI+1
				rsCTget.moveNext
			loop

		END IF
		rsCTget.close
	End Function


    Private Sub Class_Initialize()
		Redim  FItemList(0)
		FCurrPage         = 1
		FPageSize         = 30
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0
		
		redim preserve FCategoryPrdList(0)
		FTotCnt = 0
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
end Class


Sub sbEvtItemList
	Dim iEndCnt, intJ, intIx, intI, i, iTotCnt, itemid, vItemClass, vTotalPage

	IF vIdx = "" THEN Exit Sub
	intI = 0
	i = 0

	set cProj = new CProject
	cProj.FCurrPage		= vPage
	cProj.FRectPCode	= vIdx
	cProj.FRectPGCode 	= vGroupCode
	cProj.FEItemCnt		= vTopCount
	cProj.FItemsort		= vSort
	cProj.FPagesize		= 10
	cProj.getProjectItem
	iTotCnt = cProj.FResultCount
	vTotalPage = cProj.FTotalPage
	IF (iTotCnt > 0) THEN

		For intI =0 To cProj.FResultCount-1
			If cProj.FCategoryPrdList(intI).isSoldOut = True Then
				vItemClass = "soldout"
			Else
				IF cProj.FCategoryPrdList(intI).isSaleItem Then
					vItemClass = "sale"
				End If
			End If
%>
			<li>
				<div class="<%=vItemClass%>">
					<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=cProj.FCategoryPrdList(intI).FItemID%>">
						<p class="pdtPic"><img src="http://thumbnail.10x10.co.kr/webimage/image/basic/<%=GetImageSubFolderByItemid(cProj.FCategoryPrdList(intI).FItemID) & "/" & cProj.FCategoryPrdList(intI).FImageBasic & "?cmd=thumb&width=400&height=400"%>" alt="<% = cProj.FCategoryPrdList(intI).FItemName %>" /></p>
						<p class="pdtName"><%=chrbyte(cProj.FCategoryPrdList(intI).FItemName,"50","Y")%></p>
						<p class="price"><%=FormatNumber(cProj.FCategoryPrdList(intI).getRealPrice,0)%>원</p>
						<% If vItemClass = "sale" Then %><p class="pdtTag saleRed"><%=cProj.FCategoryPrdList(intI).getSalePro%></p><% End If %>
						<% If vItemClass = "soldout" Then %><p class="pdtTag soldOut">품절</p><% End If %>
					</a>
				</div>
			</li>
<%
			vItemClass = ""
			i = i + 1
		Next


	'If vPrjGender = "A" AND CStr(vTotalPage) = CStr(vPage) Then
	If CStr(vTotalPage) <= CStr(vPage) Then
		Response.Write "<script>$(function(){$('#btnMoreList').hide();});</script>"
	End If

	end if
	set cProj = Nothing
End Sub
%>
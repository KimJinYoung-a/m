<%
'----------------------------------------------------
' ClsEvtCont : 이벤트 내용
'----------------------------------------------------
Class ClsEvtCont
	public FECode   '이벤트 코드
	public FEGCode
   	public FEGPCode

	public FEKind
	public FEManager
	public FEScope
	public FEName
	public FESDate
	public FEEDate
	public FEState
	public FERegdate
	public FEPDate
	public FECategory
	public FECateMid
	public FSale
	public FGift
	public FCoupon
	public FComment
	public FBBS
	public FItemeps
	public FApply
	public FTemplate
	public FEMimg
	public FEHtml
	public FItemsort
	public FBrand
	public FGimg
	public FFullYN
	public FIteminfoYN
	public FLinkEvtCode
	public FblnBlogURL
	Public FItempriceYN '상품 가격
	Public FDateViewYN	'이벤트 기간 노출여부

	'##### 이벤트 내용 ######
	public Function fnGetEvent
		Dim strSql
		IF 	FECode = "" THEN Exit Function
		FGimg = ""
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_content "&FECode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
				FEKind		= rsget("evt_kind")
				FEManager 	= rsget("evt_manager")
				FEScope 	= rsget("evt_scope")
				FEName 		= db2html(rsget("evt_name"))
				FESDate 	= rsget("evt_startdate")
				FEEDate 	= rsget("evt_enddate")
				FEState 	= rsget("evt_state")
				FERegdate 	= rsget("evt_regdate")
				FEPDate  	= rsget("evt_prizedate")
   				FECategory 	= rsget("evt_category")
   				FECateMid 	= rsget("evt_cateMid")
   				FSale 		= rsget("issale")
   				FGift 		= rsget("isgift")
   				FCoupon   	= rsget("iscoupon")
   				FComment 	= rsget("iscomment")
   				FBBS	 	= rsget("isbbs")
   				FItemeps 	= rsget("isitemps")
   				FApply 		= rsget("isapply")
   				FTemplate 	= rsget("evt_template")
   				FEMimg 		= rsget("evt_mainimg")
   				FEHtml 		= db2html(rsget("evt_html"))
   				FItemsort 	= rsget("evt_itemsort")
   				FBrand 		= db2html(rsget("brand"))
   				IF FGift THEN FGimg		= rsget("evt_giftimg")
   				FFullYN		= rsget("evt_fullYN")
   				FIteminfoYN	= rsget("evt_iteminfoYN")
   				FLinkEvtCode = rsget("link_evtCode")
   				FblnBlogURL	= rsget("isGetBlogURL")
				FItempriceYN	= rsget("evt_itempriceyn")
				FDateViewYN = rsget("evt_dateview")
   			ELSE
   				FECode = ""
			END IF
		rsget.close
	END Function

	'##### 그룹 내용 ######
	public Function fnGetEventGroup
		Dim strSql
		IF  FEGCode = "" THEN FEGCode = 0
		strSql ="EXEC [db_event].[dbo].sp_Ten_eventitem_group "&FECode&","&FEGCode&""
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventGroup = rsget.getRows()
		END IF
		rsget.close
	End Function

	'##### 최근리스트 10개 ######
	public Function fnGetRecentEvt
		Dim strSql
		strSql ="EXEC [db_event].[dbo].sp_Ten_event_top_list '"&FECategory&"'"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdText
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetRecentEvt = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'///브랜드데이 최근리스트 20090323 한용민추가 '/street/street_main.asp
	public Function fngetbrandday
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_brandday "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fngetbrandday = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'///브랜드데이총리스트 20090423 한용민추가 '/street/street_brandday.asp
	public Function fngetbrandday_list
		Dim strSql
		strSql ="[db_event].[dbo].sp_Ten_event_brandday_all "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fngetbrandday_list = rsget.GetRows()
		END IF
		rsget.close
	End Function

	'// 브랜드데이인지 체크 20090324 한용민추가  '/street/street_brandday.asp
    public Function fngetbranddaycheck
        dim SqlStr

		SqlStr ="[db_event].[dbo].sp_Ten_event_brandday_all "

		'response.write sqlStr&"<br>"
		rsget.Open SqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

        if rsget.Eof then
			response.write "<script>"
			response.write "alert('브랜드데이 이벤트가 아니거나 종료된 이벤트 입니다');"
			response.write "history.go(-1);"
			response.write "</script>"
			dbget.close()	:	response.End
        end if
        rsget.close
    end Function

	public Function fnGetRedRibbonRecentCode
		Dim strSql
		strSql ="[db_redribbon].[dbo].ten_RecentEvent "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FECode		= rsget("evt_code")
				FEKind		= rsget("evt_kind")
   			ELSE
   				FECode = ""
   				FEKind = ""
			END IF
		rsget.close
	End Function

END Class


'----------------------------------------------------
' ClsEvtItem : 상품
'----------------------------------------------------
Class ClsEvtItem
	public FECode   '이벤트 코드
	public FEGCode
	public FEItemCnt
	public FItemsort
	public FTotCnt
	public FItemArr

	public FCategoryPrdList()

	Private Sub Class_Initialize()
		redim preserve FCategoryPrdList(0)
		FTotCnt = 0
		FItemArr = ""
	End Sub

	Private Sub Class_Terminate()

	End Sub

	'##### 상품 리스트 ######
	public Function fnGetEventItem
		Dim strSql, arrItem,intI
		IF FECode = "" THEN Exit Function
		IF FEGCode = "" THEN FEGCode= 0
		strSql ="EXEC [db_item].[dbo].sp_Ten_event_GetItem "&FECode&","&FEGCode&","&FEItemCnt&","&FItemsort&""

		'response.write strSql &"<br>"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			arrItem = rsget.GetRows()
		END IF
		rsget.close

		IF isArray(arrItem) THEN
			FTotCnt = Ubound(arrItem,2)
			redim preserve FCategoryPrdList(FTotCnt)

			For intI = 0 To FTotCnt
			set FCategoryPrdList(intI) = new CCategoryPrdItem
				FCategoryPrdList(intI).FItemID       = arrItem(0,intI)
				IF intI =0 THEN
				FItemArr = 	FCategoryPrdList(intI).FItemID
				ELSE
				FItemArr = FItemArr&","&FCategoryPrdList(intI).FItemID
				END IF
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
				FCategoryPrdList(intI).FItemSize	= arrItem(23,intI)
				FCategoryPrdList(intI).Fitemdiv		= arrItem(24,intI)

			Next
		ELSE
			FTotCnt = -1
		END IF
	End Function

End Class

'----------------------------------------------------
' sbEvtItemView_Apps : 상품목록 보여주기 (일반형태)
'----------------------------------------------------
Sub sbEvtItemView_Apps
	Dim iEndCnt, intJ

	IF eCode = "" THEN Exit Sub
	intI = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF


	IF (iTotCnt >= 0) THEN
		For intI =0 To iTotCnt
%>
		<li onclick="location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';">
			<div class="product">
				<div class="product-img">
					<img src="<% = cEventItem.FCategoryPrdList(intI).FImageIcon1 %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" width="132" height="132">
				</div>
				<div class="product-spec">
					<div class="product-brand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></div>
					<div class="product-name"><% = cEventItem.FCategoryPrdList(intI).FItemName %></div>
					<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
						<div class="product-price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %></strong>원
							<% if int((cEventItem.FCategoryPrdList(intI).ForgPrice-cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice)/cEventItem.FCategoryPrdList(intI).ForgPrice*100)>0 then %>
							<span class="discount"><%=int((cEventItem.FCategoryPrdList(intI).ForgPrice-cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice)/cEventItem.FCategoryPrdList(intI).ForgPrice*100) & "%"%>↓</span>
							<% end if %>
						</div>
					<% Else %>
						<div class="product-price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></strong><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></div>
					<% End if %>
					<div class="featured">
					<%
						IF cEventItem.FCategoryPrdList(intI).isSaleItem Then Response.Write "<span class=""sale"">SALE</span>"
						IF cEventItem.FCategoryPrdList(intI).isLimitItem Then Response.Write "<span class=""limited"">한정</span>"
						IF cEventItem.FCategoryPrdList(intI).isNewItem Then Response.Write "<span class=""new"">NEW</span>"
						IF cEventItem.FCategoryPrdList(intI).isCouponItem Then Response.Write "<span class=""coupon"">쿠폰</span>"
						IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then Response.Write "<span class=""only"">품절</span>"
					%>
					</div>
					<!-- <div class="product-meta">
						<span class="comment">200</span>
						<span class="love">222</span>
					</div> -->
				</div>
				<div class="clear"></div>
			</div>
		</li>
<%
		next
	End IF
End Sub

'----------------------------------------------------
' sbEvtItemList_Apps : 상품목록 보여주기 (아이콘형태)
'----------------------------------------------------
Sub sbEvtItemList_Apps
	Dim iEndCnt, intJ, intIx, i

	IF eCode = "" THEN Exit Sub
	intI = 0
	i = 0

	set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= itemlimitcnt
	cEventItem.FItemsort= eitemsort
	cEventItem.fnGetEventItem
	iTotCnt = cEventItem.FTotCnt

	IF itemid = "" THEN
		itemid = cEventItem.FItemArr
	ELSE
		itemid = itemid&","&cEventItem.FItemArr
	END IF

	IF (iTotCnt >= 0) THEN
		'// 이미지 사이즈가 큰경우(200px) 먼저 표시(2013.01.29; 허진원)
		if cEventItem.FCategoryPrdList(0).FItemSize="2" or cEventItem.FCategoryPrdList(0).FItemSize="200" then

		For intI =0 To iTotCnt
			'큰이미지가 끝나면 출력 종료
			if cEventItem.FCategoryPrdList(intI).FItemSize="1" or cEventItem.FCategoryPrdList(intI).FItemSize="100" or cEventItem.FCategoryPrdList(intI).FItemSize="150" then
				response.write "</ul>"
				Exit For
			end if
%>
			<% if i = 0 then %>
			<ul class="product-list list-type-<%=chkIIF(blnItemifno or blnitempriceyn="0","1","")%>">
			<% End If %>
				<li onclick="location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';">
					<div class="product">
						<div class="product-img">
							<img src="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageIcon1,200,200,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" width="132" height="132">
						</div>
						<% if blnItemifno or blnitempriceyn="0" then %>
						<div class="product-spec">
							<% if blnItemifno then %>
							<div class="product-brand ellipsis1"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></div>
							<div class="product-name ellipsis1"><% = cEventItem.FCategoryPrdList(intI).FItemName %></div>
							<% end if %>
							<% if blnitempriceyn="0" then %>
							<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
								<div class="product-price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %></strong>원
									<span class="discount"><%=int((cEventItem.FCategoryPrdList(intI).ForgPrice-cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice)/cEventItem.FCategoryPrdList(intI).ForgPrice*100) & "%"%>↓</span>
								</div>
							<% Else %>
								<div class="product-price"><strong><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %></strong><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></div>
							<% End if %>
							<% end if %>
							<div class="featured diff-10">
								<%
									IF cEventItem.FCategoryPrdList(intI).isSaleItem Then Response.Write "<span class=""sale"">SALE</span>"
									IF cEventItem.FCategoryPrdList(intI).isLimitItem Then Response.Write "<span class=""limited"">한정</span>"
									IF cEventItem.FCategoryPrdList(intI).isNewItem Then Response.Write "<span class=""new"">NEW</span>"
									IF cEventItem.FCategoryPrdList(intI).isCouponItem Then Response.Write "<span class=""coupon"">쿠폰</span>"
									IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then Response.Write "<span class=""only"">품절</span>"
								%>
							</div>
							<!-- <div class="product-meta">
								<span class="comment">200</span>
								<span class="love">222</span>
							</div> -->
						</div>
						<% end if %>
						<div class="clear"></div>
					</div>
				</li>
			<% if intI = iTotCnt then response.write "</ul><div class=""diff clear""></div>" %>

<%
			Set cEventItem.FCategoryPrdList(intI) = nothing
			i = i + 1
		Next
		
		end if
	end if

	'// 일반 사이즈 상품 목록 출력
	intIx = intI
	i = 0

	IF (iTotCnt >= 0) THEN
		For intI =intIx To iTotCnt 
%>
			<% if i = 0 then %>
			<ul class="product-list list-type-3">
			<% End If %>
			<li onclick="location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';">
				<div class="product">
					<div class="product-img">
						<img src="<% = getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageIcon1,150,150,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" width="132" height="132">
					</div>
				</div>
				<div class="clear"></div>
			</li>
			<% if intI = iTotCnt then response.write "</ul><div class=""diff clear""></div>" %>
<%
			i = i + 1
		Next
	End If

	set cEventItem = Nothing
End Sub
%>
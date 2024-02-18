<%
	dim oHTBCItem '함께 구매한상품 & 카테고리 인기상품

	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = vDisp
	
	'if cdl<>"999" then
		oHTBCItem.GetCateRightHappyTogetherNCateBestItemList
	'end if

	'// 상품검색 'sale
	dim oDoc,iLp
	set oDoc = new SearchItemCls
		oDoc.FRectSearchTxt = ""
		oDoc.FRectPrevSearchTxt = ""
		oDoc.FRectExceptText = ""
		oDoc.FRectSortMethod	= "ne"
		oDoc.FRectSearchFlag = "sc"
		oDoc.FRectSearchItemDiv = "n"
		oDoc.FRectSearchCateDep = "T"
		oDoc.FRectCateCode	= vDisp
		oDoc.FminPrice	= ""
		oDoc.FmaxPrice	= ""
		oDoc.FdeliType	= ""
		oDoc.FCurrPage = "1"
		oDoc.FPageSize = "9"
		oDoc.FScrollCount = "5"
		oDoc.FListDiv = "list"
		oDoc.FLogsAccept = true
		oDoc.FcolorCode = "0"
		oDoc.FSellScope= "Y"
		oDoc.getSearchList

	if oHTBCItem.FResultCount>0 then
%>	
<div class="morePdtListWrap">
	<div class="tabItem03">
		<ul>
			<li class="current">함께 구매한 상품</li>
		</ul>
	</div>
	<div class="morePdtCont">
		<div class="morePdtList autoWswiper pdtSwiper1">
			<div class="swiper-wrapper">
				<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
				<% if lp>10 then Exit For %>
				<div class="swiper-slide">
					<span class="pic"><a href="/category/category_itemprd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemId %>"><img src="<%=oHTBCItem.FItemList(lp).FImageList120 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" style="width:100%;" /></a></span>
					<div class="pdtCont">
						<p class="ftSmall c999"><%=oHTBCItem.FItemList(lp).FBrandName%></p>
						<p class="ftMidSm b textOver"><%=oHTBCItem.FItemList(lp).FItemName%></p>
						<!-- <p class="ftSmall2 c999"><del>
						<%
						If oHTBCItem.FItemList(lp).IsSaleItem or oHTBCItem.FItemList(lp).isCouponItem Then
							If oHTBCItem.FItemList(lp).Fitemcoupontype <> "3" Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).FOrgPrice,0) & "원"
							End If
						End If
						%>
						</del></p> -->
						<p class="ftMidSm"><%
						If oHTBCItem.FItemList(lp).IsSaleItem or oHTBCItem.FItemList(lp).isCouponItem Then
							IF oHTBCItem.FItemList(lp).IsSaleItem Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) & "원"
								Response.Write " <span class=""cC40"">[" & oHTBCItem.FItemList(lp).getSalePro & "]</span>"
							End IF
							IF oHTBCItem.FItemList(lp).IsCouponItem Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).GetCouponAssignPrice,0) & "원"
								Response.Write " <span class=""c2c9336"">[" & oHTBCItem.FItemList(lp).GetCouponDiscountStr & "]</span>"
							End IF
						Else
							Response.Write FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) & "원"
						End If
						%></p>
					</div>
				</div>
				<%	next %>
			</div>
		</div>
	</div>
</div>
<% if oHTBCItem.FResultCount > 10 then %>
<div class="morePdtListWrap pdtTabArea bestNsale">
	<div class="tabItem03">
		<ul>
			<li class="current" name="tab01">카테고리 인기상품</li>
			<% IF oDoc.FResultCount >0 Then %>
			<li class="cC40" name="tab02">SALE</li>
			<% End If %>
		</ul>
	</div>
	<div class="morePdtCont">
		<!-- 카테고리 인기상품 -->
		<div class="morePdtList autoWswiper pdtSwiper2" id="tab01">
			<p class="ftSmall moreView"><a href="/category/category_list.asp?disp=<%=vDisp%>&cpg=1&srm=be&imgsize=290"><span class="elmBg c555 b">더보기</span></a></p>
			<div class="swiper-wrapper">
				<%	For lp = 10 To oHTBCItem.FResultCount - 1 %>
				<% if lp>19 then Exit For %>
				<div class="swiper-slide">
					<span class="pic"><a href="/category/category_itemprd.asp?itemid=<%=oHTBCItem.FItemList(lp).FItemId %>"><img src="<%=oHTBCItem.FItemList(lp).FImageList120 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" style="width:100%;" /></a></span>
					<div class="pdtCont">
						<p class="ftSmall c999"><%=oHTBCItem.FItemList(lp).FBrandName%></p>
						<p class="ftMidSm b textOver"><%=oHTBCItem.FItemList(lp).FItemName%></p>
						<!-- <p class="ftSmall2 c999"><del>
						<%
						If oHTBCItem.FItemList(lp).IsSaleItem or oHTBCItem.FItemList(lp).isCouponItem Then
							If oHTBCItem.FItemList(lp).Fitemcoupontype <> "3" Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).FOrgPrice,0) & "원"
							End If
						End If
						%>
						</del></p> -->
						<p class="ftMidSm"><%
						If oHTBCItem.FItemList(lp).IsSaleItem or oHTBCItem.FItemList(lp).isCouponItem Then
							IF oHTBCItem.FItemList(lp).IsSaleItem Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) & "원"
								Response.Write " <span class=""cC40"">[" & oHTBCItem.FItemList(lp).getSalePro & "]</span>"
							End IF
							IF oHTBCItem.FItemList(lp).IsCouponItem Then
								Response.Write FormatNumber(oHTBCItem.FItemList(lp).GetCouponAssignPrice,0) & "원"
								Response.Write " <span class=""c2c9336"">[" & oHTBCItem.FItemList(lp).GetCouponDiscountStr & "]</span>"
							End IF
						Else
							Response.Write FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) & "원"
						End If
						%></p>
					</div>
				</div>
				<%	next %>	
			</div>
		</div>
		<!--// 카테고리 인기상품 -->
		<!-- SALE -->
		<div class="morePdtList autoWswiper pdtSwiper3" id="tab02">
			<p class="ftSmall moreView"><a href="/category/category_list.asp?disp=<%=vDisp%>&cpg=1&srm=hs&imgsize=290&sflag=sc"><span class="elmBg c555 b">더보기</span></a></p>
			<div class="swiper-wrapper">
			<% IF oDoc.FResultCount >0 Then %>
				<% For i=0 To oDoc.FResultCount-1 %>
				<div class="swiper-slide">
					<span class="pic"><a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>"><img src="<% = oDoc.FItemList(i).FImageIcon1 %>" alt="<% = oDoc.FItemList(i).FItemName %>" style="width:100%;" /></a></span>
					<div class="pdtCont">
						<p class="ftSmall c999"><% = oDoc.FItemList(i).FBrandName %></p>
						<p class="ftMidSm b textOver"><% = oDoc.FItemList(i).FItemName %></p>
						<!-- <p class="ftSmall2 c999"><del>
						<%
						If oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
							If oDoc.FItemList(i).Fitemcoupontype <> "3" Then
								Response.Write FormatNumber(oDoc.FItemList(i).getOrgPrice,0) & "원"
							End If
						End If
						%>
						</del></p> -->
						<p class="ftMidSm"><%
						If oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
							IF oDoc.FItemList(i).IsSaleItem Then
								Response.Write FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원"
								Response.Write " <span class=""cC40"">[" & oDoc.FItemList(i).getSalePro & "]</span>"
							End IF
							IF oDoc.FItemList(i).IsCouponItem Then
								Response.Write FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "원"
								Response.Write " <span class=""cC40"">[" & oDoc.FItemList(i).GetCouponDiscountStr & "]</span>"
							End IF
						Else
							Response.Write FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원"
						End If
						%></p>
					</div>
				</div>
				<% Next %>
			<% End If %>
			</div>
		</div>
		<!--// SALE -->
	</div>
</div>
<%
	End If '카테고리인기상품
	end if

	Set	oDoc = Nothing 
	set oHTBCItem = Nothing
%>
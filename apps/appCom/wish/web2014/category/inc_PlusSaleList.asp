<!-- PLUS SALE-->
<%
	'메인관련 할인 상품 목록 접수/출력
	Dim oPlusSaleItem , vTmp , bi
	set oPlusSaleItem = new CSetSaleItem
	oPlusSaleItem.FRectItemID = itemid
	oPlusSaleItem.GetLinkSetSaleItemList

	vTmp = oPlusSaleItem.FResultCount-1

	If vTmp >= 0 Then 
%>
<aside id="plussaleSwiper" class="recommend-item plus-sale">
	<h2>PLUS ITEM <small>함께 구매하면 좋아요!</small></h2>
	<div class="items type-list">
		<div class="swiper-container">
			<ul class="swiper-wrapper">
				<%
					For bi=0 To vTmp
				%>
				<li class="swiper-slide">
					<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oPlusSaleItem.FItemList(bi).Fitemid%>">
						<div class="thumbnail"><img src="<%=getThumbImgFromURL(oPlusSaleItem.FItemList(bi).FImageBasic,200,200,"true","false")%>" alt="<%=oPlusSaleItem.FItemList(bi).FitemName%>" /></div>
						<div class="desc">
							<p class="name"><%=oPlusSaleItem.FItemList(bi).FitemName%></p>
							<div class="price">
								<div class="unit">
									<b class="sum"><%= FormatNumber(oPlusSaleItem.FItemList(bi).GetPLusSalePrice,0) %><span class="won">원</span></b>
									<% if oPlusSaleItem.FItemList(bi).FPLusSalePro>0 then %>
									<b class="discount color-red"><%= oPlusSaleItem.FItemList(bi).FPLusSalePro %>%</b>
									<% end if %>
								</div>
							</div>
						</div>
					</a>
				</li>
				<%
					Next
				%>
			</ul>
		</div>
	</div>
</aside>
<%
	End If 

	set oPlusSaleItem = Nothing
%>
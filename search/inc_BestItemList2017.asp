<%
'#######################################################
'	History	:  2015.06.15 허진원 생성
'	Description : 베스트셀러
'                 검색결과가 없을때 BEST순(itemscroe) 상품 목록
'#######################################################

	'// 베스트 상품 접수
	Dim oKDoc
	set oKDoc = new SearchItemCls
	oKDoc.FRectSortMethod	= "be"			'Best순
	oKDoc.FRectSearchCateDep = "T"
	oKDoc.FRectSearchItemDiv = "y"
	oKDoc.FCurrPage = 1
	oKDoc.FPageSize = 10
	oKDoc.FScrollCount = 0
	oKDoc.FListDiv = "bestlist"
	oKDoc.FSellScope="Y"
	oKDoc.FRectSearchFlag = "n"
	'oKDoc.FminPrice	= "6000"			'최소 금액제한

	oKDoc.getSearchList

	if oKDoc.FResultCount>0 then
%>
		<section class="suggestion-bestseller">
			<h2>가끔은 베스트셀러도 좋아요!</h2>
			<div class="items type-list">
				<ul>
					<% For lp=0 To (oKDoc.FResultCount-1) %>
					<li>
						<a href="" onClick="TnGotoProduct('<%=oKDoc.FItemList(lp).FItemid%>'); return false;">
							<div class="thumbnail"><img src="<%=getThumbImgFromURL(oKDoc.FItemList(lp).FImageBasic,286,286,"true","false")%>" alt="" /></div>
							<div class="desc">
								<b class="no"><%=Num2Str(lp+1,2,"0","R")%></b>
								<span class="brand"><%=oKDoc.FItemList(lp).FBrandName%></span>
								<p class="name"><%=oKDoc.FItemList(lp).FItemName%></p>
								<div class="price">
									<% IF oKDoc.FItemList(lp).IsSaleItem or oKDoc.FItemList(lp).isCouponItem Then %>
										<% IF oKDoc.FItemList(lp).IsSaleItem Then %>
											<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).getRealPrice,0) %><span class="won">원</span></b> <b class="discount red"><% = oKDoc.FItemList(lp).getSalePro %></b></div>
										<% End IF %>
										<% IF oKDoc.FItemList(lp).IsCouponItem AND oKDoc.FItemList(lp).GetCouponDiscountStr <> "무료배송" Then %>
											<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).GetCouponAssignPrice,0) %><span class="won">원</span></b> <b class="discount green"><% = oKDoc.FItemList(lp).GetCouponDiscountStr %></b></div>
										<% End IF %>
									<% Else %>
										<div class="unit"><b class="sum"><% = FormatNumber(oKDoc.FItemList(lp).getRealPrice,0) %><span class="won"><% if oKDoc.FItemList(lp).IsMileShopitem then %> Point<% else %> 원<% end  if %></span></b></div>
									<% End if %>
								</div>
							</div>
						</a>
					</li>
					<% Next %>
				</ul>
			</div>
			<div class="btn-group">
				<a href="/award/awarditem.asp" class="btn-more"><span>더 보기</span></a>
			</div>
		</section>
<%
	End if

	set oKDoc = Nothing
%>
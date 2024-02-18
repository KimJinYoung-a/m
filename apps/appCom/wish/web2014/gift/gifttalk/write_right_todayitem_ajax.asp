<%@ language=vbscript %>
<% option Explicit %>
<% Response.CharSet = "UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트
' History : 2015.02.09 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/lib/giftFunction.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->

<%
Const MAX_TODAYVIEW_ITEMCOUNT = 40
dim itemarr, i, lp
	itemarr     = requestCheckVar(request("itemarr"),800)

dim myTodayShopping
set myTodayShopping = new CTodayShopping
myTodayShopping.FPageSize        = MAX_TODAYVIEW_ITEMCOUNT
myTodayShopping.FCurrpage        = 1
myTodayShopping.FScrollCount     = 10
myTodayShopping.FRectUserID      = GetLoginUserID()
myTodayShopping.FRectItemIdArrList = itemarr

if (itemarr<>"") and GetLoginUserID() <> "" then
    myTodayShopping.getMyTodayViewList
end if
%>
<% If myTodayShopping.FResultCount>0 Then %>
<h3>최근 본 상품</h3>
	<ul class="pdtList">
		<% For lp=0 To myTodayShopping.FResultCount-1 %>
			<li onclick="fnAPPopenerJsCallClose('TalkItemSelect(<%=myTodayShopping.FItemList(lp).FItemID%>)');">
				<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%= myTodayShopping.FItemList(lp).FImageicon1 %>" alt="<% = myTodayShopping.FItemList(lp).FItemName %>" /></div>
				<div class="pdtCont">
					<p class="pBrand"><%= myTodayShopping.FItemList(lp).FBrandName %></p>
					<p class="pName"><%= myTodayShopping.FItemList(lp).FItemName %></p>
					<% IF myTodayShopping.FItemList(lp).IsSaleItem or myTodayShopping.FItemList(lp).isCouponItem Then %>
						<% IF myTodayShopping.FItemList(lp).IsSaleItem then %>
							<p class="ftSmall2 c999"><del><%= FormatNumber(myTodayShopping.FItemList(lp).getOrgPrice,0) %>원</del></p>
							<p class="pPrice"><%= FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원 <span class="cGr1">[<%= myTodayShopping.FItemList(lp).getSalePro %>%]</span></p>
						<% End IF %>
						<% IF myTodayShopping.FItemList(lp).IsCouponItem Then %>
							<% IF Not(myTodayShopping.FItemList(lp).IsFreeBeasongCoupon() or myTodayShopping.FItemList(lp).IsSaleItem) then %>
								<p class="ftSmall2 c999"><del><% = FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원</del></p>
							<% End IF %>
							<p class="pPrice"><% = FormatNumber(myTodayShopping.FItemList(lp).GetCouponAssignPrice,0) %>원 [<% = myTodayShopping.FItemList(lp).GetCouponDiscountStr %>]<% IF myTodayShopping.FItemList(lp).IsFreeBeasong Then Response.Write "[무료배송]" %></p>
						<% end if %>
					<% Else %>
						<p class="pPrice"><%= FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %><% if myTodayShopping.FItemList(lp).IsMileShopitem then %> Point<% else %> 원<% end if %></p>
					<% End if %>
					<span class="button btS1 btRed cWh1"><button type="button" >추가</button></span>
																			   
				</div>
			</li>
		<% next %>
	</ul>
<% else %>
	<div class="topGyBdr btmGyBdr ct innerH25 tMar10">
		<p class="ftMid c999 innerH25">최근 본 상품이 없습니다.</p>
	</div>
<% end if %>

<%
set myTodayShopping=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
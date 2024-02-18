<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim flag, atype, vDisp, chkCnt, sNo, PageSize
vDisp = RequestCheckVar(request("disp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
if CurrPage="" then CurrPage=1
if PageSize="" then PageSize=10
'If atype = "" Then atype = "n"  'n 기본값
If atype = "" Then atype = "f"  'n 기본값
dim minPrice: minPrice=4500		'검색 최저가

if (CurrPage*PageSize)>50 then
	'50위까지만 표시
	dbget.Close: Response.End
end if

Dim oaward, i, iLp, eNo, tPg

set oaward = new CAWard
	oaward.FPageSize = PageSize*CurrPage
    oaward.FCurrPage 		= CurrPage
	oaward.GetSteadyItemList


	'// 3개 이하일 경우엔 하단 상품후기 부분 가려야 되므로 체킹함
	chkCnt = oaward.FResultCount

If (oaward.FResultCount < 3) Then
	''oaward.FRectCDL = vDisp  ''??
	''oaward.GetNormalItemList5down
	
	set oaward = Nothing
	set oaward = new SearchItemCls
		oaward.FListDiv 			= "bestlist"
		oaward.FRectSortMethod	    = "be"
		''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
		oaward.FPageSize 			= 50
		oaward.FCurrPage 			= 1
		oaward.FSellScope			= "Y"
		oaward.FScrollCount 		= 1
		oaward.FRectSearchItemDiv   ="D"
		oaward.FRectCateCode		= vDisp
		oaward.FminPrice	= minPrice
		oaward.getSearchList
End If

sNo = PageSize*(CurrPage-1)

%>
<% for i=sNo to oaward.FResultCount-1 %>
<li class="<%=CHKIIF(oaward.FItemList(i).IsSoldOut,"soldOut","")%> <%=chkIIF((i+1)<4,"topRankV15","")%> <% If oaward.FItemList(i).GetLevelUpCount > "29" then response.write " bestUpV15" %>">
	<div class="pPhoto" onclick="fnAPPpopupProduct('<%=oaward.FItemList(i).FItemID%>');"><p><span><em>품절</em></span></p><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>" /></div>
	<div class="pdtCont">
		<p class="ranking"><span><%= (i-sNo)+((CurrPage-1)*PageSize)+1 %></span></p>
		<p class="pBrand"><%=oaward.FItemList(i).FBrandName %></p>
		<p class="pName" onclick="fnAPPpopupProduct('<%=oaward.FItemList(i).FItemID%>');"><%=oaward.FItemList(i).FItemName %></p>
		<% IF oaward.FItemList(i).IsSaleItem or oaward.FItemList(i).isCouponItem Then %>
			<% IF oaward.FItemList(i).IsSaleItem Then %>
				<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oaward.FItemList(i).getSalePro %>]</span></p>
			<% End IF %>
			<% IF oaward.FItemList(i).IsCouponItem Then %>
				<% IF Not(oaward.FItemList(i).IsFreeBeasongCoupon() or oaward.FItemList(i).IsSaleItem) then %>
				<% End IF %>
				<!--p class="pPrice"><% = FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oaward.FItemList(i).GetCouponDiscountStr %>]</span></p-->
			<% End IF %>
		<% Else %>
			<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %><% if oaward.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
		<% End if %>
		<p class="pShare">
			<span class="cmtView"><%=FormatNumber(oaward.FItemList(i).FEvalcnt,0)%></span>
			<span class="wishView" onclick="TnAddFavoritePrd('<%=oaward.FItemList(i).FItemID%>');"><%=FormatNumber(oaward.FItemList(i).FFavCount,0)%></span>
		</p>
	</div>
</li>
<% next %>
<%
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
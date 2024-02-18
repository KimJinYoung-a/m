<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim catecode, lp,sPercent, flo1, flo2, price, i
catecode = getNumeric(requestCheckVar(Request("disp"),3))
price =	getNumeric(requestCheckVar(Request("price"),2))
flo1 =	requestCheckVar(Request("flo1"),5) '// 무료배송
flo2 =	requestCheckVar(Request("flo2"),5) '// 한정판매
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
dim icoSize		: icoSize = requestCheckVar(request("icoSize"),1)
dim minPrice, maxPrice

If price = "" Then
	price = "all"
End IF

'할인률 적용
Select Case price
	Case "0"
		minPrice = "1"
		maxPrice = "9999"
	Case "1"
		minPrice = "10000"
		maxPrice = "29999"
	Case "3"
		minPrice = "30000"
		maxPrice = "49999"
	Case "5"
		minPrice = "50000"
		maxPrice = "99999"
	Case "10"
		minPrice = "100000"
		maxPrice = "10000000"
end Select

if icoSize="" then icoSize="M"	'상품 아이콘 기본(중간)

dim ScrollCount
ScrollCount = 10

'추가 이미지 사이즈
dim imgSz	: imgSz = chkIIF(icoSize="M",180,150)

if SortMet="" then SortMet="pj"
if CurrPage="" then CurrPage=1
if PageSize ="" then PageSize =16
'rw sPercent & "!"
dim oDoc,iLp
set oDoc = new SearchItemCls

oDoc.FListDiv 			= "fulllist"
oDoc.FRectSortMethod	= SortMet
oDoc.FRectSearchFlag 	= "pk"
oDoc.FPageSize 			= PageSize
oDoc.FRectCateCode		= catecode
oDoc.FisFreeBeasong		= flo1	'// 무료배송
oDoc.FisLimit			= flo2	'// 한정판매
oDoc.FminPrice			= minPrice
oDoc.FmaxPrice			= maxPrice
oDoc.FRectSearchItemDiv = "n"
oDoc.FRectSearchCateDep = "T"
oDoc.FCurrPage 			= CurrPage
oDoc.FSellScope 		= "Y"
oDoc.FScrollCount 		= ScrollCount

oDoc.getSearchList

%>

<% IF oDoc.FResultCount >0 Then %>
	<% For i=0 To oDoc.FResultCount-1 %>
	<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%> onclick="fnAPPpopupProduct('<% = oDoc.FItemList(i).Fitemid %>');">
		<div class="pPhoto">
			<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<p><span><em>품절</em></span></p>","")%>
			<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" />
		</div>
		<div class="pdtCont">
			<p class="pBrand"><% = oDoc.FItemList(i).FBrandName %></p>
			<p class="pName"><% = oDoc.FItemList(i).FItemName %></p>
			<% IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then %>
				<% IF oDoc.FItemList(i).IsSaleItem And oDoc.FItemList(i).isCouponItem = false Then %>
					<!-- <p class="ftSmall2 c999"><del><% = FormatNumber(oDoc.FItemList(i).getOrgPrice,0) %>원</del></p> -->
					<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oDoc.FItemList(i).getSalePro %>]</span></p>
				<% End IF %>
				<% IF oDoc.FItemList(i).IsCouponItem Then %>
					<% IF Not(oDoc.FItemList(i).IsFreeBeasongCoupon() or oDoc.FItemList(i).IsSaleItem) then %>
						<!-- <p class="ftSmall2 c999"><del><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원</del></p> -->
					<% End IF %>
					<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oDoc.FItemList(i).GetCouponDiscountStr %>]</span></p>
				<% End IF %>
			<% Else %>
				<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %><% if oDoc.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
			<% End if %>
			<p class="pShare">
				<span class="cmtView"><%=formatNumber(oDoc.FItemList(i).FEvalCnt,0)%></span>
				<span class="wishView" _onclick="TnAddFavoritePrd('<%=oDoc.FItemList(i).FItemID%>');"><%=FormatNumber(oDoc.FItemList(i).FFavCount,0)%></span>
				<% IF oDoc.FItemList(i).IsPojangitem Then %><i class="pkgPossb">선물포장 가능상품</i><% End If %>
			</p>
		</div>
	</li>
	<% Next %>
<% End If %>

<% Set oDoc = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
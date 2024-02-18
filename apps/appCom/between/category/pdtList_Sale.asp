<%
Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
Dim vDepth, i,TotalCnt
	vDepth = "1"
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
dim searchFlag 	: searchFlag = "sale"
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)


dim ListDiv,ScrollCount
ListDiv="salelist"
ScrollCount = 5

if CurrPage="" then CurrPage=1
PageSize =10

If SortMet = "" Then SortMet = "ne"

dim oDoc,iLp
set oDoc = new SearchItemCls
	oDoc.FListDiv 			= ListDiv
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag 	= searchFlag
	oDoc.FPageSize 			= PageSize
	oDoc.FRectCateCode			= vDisp
	oDoc.FCurrPage 			= CurrPage
	oDoc.FSellScope 		= "Y"
	oDoc.FScrollCount 		= ScrollCount
	oDoc.getSearchList
	
TotalCnt = oDoc.FResultCount

%>

<ul class="pdtList list03">
	<% IF oDoc.FResultCount >0 then %>
	<%
	For i=0 To TotalCnt-1
	
	IF (i <= TotalCnt-1) Then
	%>
	<li>
		<div <% IF oDoc.FItemList(i).isSaleItem then %>class="sale"<% End If %>>
			<a href="">
				<p class="pdtPic"><img src="<% = oDoc.FItemList(i).FImageBasic %>" alt="<% = oDoc.FItemList(i).FItemName %>" /></p><!-- for dev msg : 상품명 alt값 속성에 넣어주세요(이하동일) -->
				<p class="pdtName"><% = oDoc.FItemList(i).FItemName %></p>
				<p class="price">
					<%
						If oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
							IF oDoc.FItemList(i).IsSaleItem Then
								Response.Write FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원"
								Response.Write "<span class=""cC40"">[" & oDoc.FItemList(i).getSalePro & "]</span>"
							End IF
							IF oDoc.FItemList(i).IsCouponItem Then
								Response.Write FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "원"
								Response.Write "<span class=""c2c9336"">[" & oDoc.FItemList(i).GetCouponDiscountStr & "]</span>"
							End IF
						Else
							Response.Write FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원"
						End If
					%>
				</p>
			</a>
		</div>
	</li>
	<% End IF %>
	<% Next %>
	<% end if %>
</ul>
<div class="listAddBtn">
	<a href="">상품 더 보기</a>
</div>
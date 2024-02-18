<%
	dim oBBDoc
	set oBBDoc = new SearchItemCls
		oBBDoc.FRectSearchTxt = ""
		oBBDoc.FRectPrevSearchTxt = ""
		oBBDoc.FRectExceptText = ""
		oBBDoc.FRectSortMethod	= "be"		'인기상품
		oBBDoc.FRectSearchFlag = "n"			'일반상품
		oBBDoc.FRectSearchItemDiv = "n"		'기본 카테고리만
		oBBDoc.FRectSearchCateDep = "T"		'하위 카테고리 포함
		oBBDoc.FRectMakerid	= vMakerid
		oBBDoc.FminPrice	= ""
		oBBDoc.FmaxPrice	= ""
		oBBDoc.FdeliType	= ""
		oBBDoc.FCurrPage = 1
		oBBDoc.FPageSize = 9					'9개 접수
		oBBDoc.FScrollCount = 5
		oBBDoc.FListDiv = "brand"				'상품목록
		oBBDoc.FLogsAccept = False			'로그 기록안함
		oBBDoc.FAddLogRemove = true			'추가로그 기록안함
		oBBDoc.FcolorCode = "0"				'전체컬러
		oBBDoc.FSellScope= "Y"				'판매중인 상품만
		oBBDoc.getSearchList

	If oBBDoc.FResultCount > 1 Then
%>
<div class="addPdtList box1 tMar20 brandPdt">
	<h2 class="tPad10 lPad05"><span>브랜드 인기상품</span></h2>
	<span class="moreBtn"><a href="#" onclick="fnAPPpopupBrand('<%=oItem.Prd.Fmakerid%>');return false;">브랜드 인기상품 리스트로 이동</a></span>
	<div class="swiper-container swiper1">
		<div class="swiper-wrapper">
			<ul class="simpleList swiper-slide">
<%
			For i=0 To oBBDoc.FResultCount-1
%>
				<li>
					<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= oBBDoc.FItemList(i).Fitemid %>">
						<p><img src="<%=getStonThumbImgURL(oBBDoc.FItemList(i).FImageBasic,200,200,"true","false")%>" alt="<%=oBBDoc.FItemList(i).FitemName%>" /></p>
						<span><%=oBBDoc.FItemList(i).FitemName%></span>
						<span class="price">
							<% = FormatNumber(oBBDoc.FItemList(i).getRealPrice,0) %>원
							<% If oBBDoc.FItemList(i).IsSaleItem Then %>
							<em class="cRd1">[<% = oBBDoc.FItemList(i).getSalePro %>]</em>
							<% end if %>
						</span>
					</a>
				</li>
<%
				if (i mod 3)=2 and i<oBBDoc.FResultCount-1 then Response.Write "</ul><ul class=""simpleList swiper-slide"">"
			Next
%>
			</ul>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<%
	End if

	set oBBDoc = Nothing
%>
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
<div class="bestsellerV15">
	<h2>텐바이텐 <span class="cRd1">베스트셀러</span></h2>
	<div class="pdtListWrap">
		<ul class="pdtList">
		<% For lp=0 To (oKDoc.FResultCount-1) %>
			<li onclick="TnGotoProduct(<%=oKDoc.FItemList(lp).FItemid%>);">
				<strong <%=chkIIF(lp<3,"class=""cRd1""","")%>><%=Num2Str(lp+1,2,"0","R")%></strong>
				<div class="pPhoto"><img src="<%= getThumbImgFromURL(oKDoc.FItemList(lp).FImageBasic,286,286,"true","false") %>" alt="<% = oKDoc.FItemList(lp).FItemName %>" /></div>
				<div class="pdtCont">
					<p class="pName"><%=oKDoc.FItemList(lp).FItemName%></p>
					<p class="pPrice"><%=FormatNumber(oKDoc.FItemList(lp).GetCouponAssignPrice,0)%>원
						<% if oKDoc.FItemList(lp).IsSaleItem or oKDoc.FItemList(lp).isCouponItem Then %>
							<% IF oKDoc.FItemList(lp).IsSaleItem then %>
							<span class="cRd1">[<%=oKDoc.FItemList(lp).getSalePro%>]</span>
							<% End If %>
							<% IF oKDoc.FItemList(lp).IsCouponItem Then %>
							<span class="cGr1">[<%=oKDoc.FItemList(lp).GetCouponDiscountStr%>]</span>
							<% End If %>
						<% End If %>
					</p>
				</div>
			</li>
		<% Next %>
		</ul>
	</div>
	<div class="btnWrap tPad20">
		<div class="ct"><span class="button btB1 btRed cWh1 w90p"><a href="/award/awarditem.asp">더보기</a></span></div>
	</div>
</div>
<%
	End if

	set oKDoc = Nothing
%>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	dim oHTBCItem, chkHT, itemid, catecode, rcpUid, vPrdList, vMtdList, mtv, tmpArr
	dim lp, vIid, vMtd(), vLnk(), IValue
	ReDim vMtd(8), vLnk(8)

	itemid = requestCheckVar(request("itemid"),128)	'상품코드
	catecode = requestCheckVar(request("disp"),18)	'전시카테고리


	'//클래스 선언
	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = catecode


	'// 텐바이텐 해피투게더 상품 목록
	''oHTBCItem.GetCateRightHappyTogetherNCateBestItemList
    oHTBCItem.GetCateRightHappyTogetherList   ''FImageicon1 => FIcon1Image  //2017/06/19 edit by eastone

	if oHTBCItem.FResultCount>0 then
%>
<div class="itemAddWrapV16a hpytgthrV16a">
	<div class="bxLGy2V16a">
		<h3>HAPPY TOGETHER</h3>
	</div>
	<div class="bxWt1V16a">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<ul class="simpleListV16a swiper-slide">
					<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
					<% if lp>8 then Exit For %>
						<li>
							<a href="/category/category_itemprd.asp?itemid=<%= oHTBCItem.FItemList(lp).FItemId %>&rc=item_happy_<%=lp+1%>">
								<p><img src="<%=oHTBCItem.FItemList(lp).FIcon1Image %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" /></p>
								<span><%=oHTBCItem.FItemList(lp).FItemName%></span>
								<span class="price">
									<% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %>원
									<% If oHTBCItem.FItemList(lp).IsSaleItem Then %>
									<em class="cRd1">[<% = oHTBCItem.FItemList(lp).getSalePro %>]</em>
									<% end if %>
								</span>
							</a>
						</li>
						<% Select Case Trim(lp) %>
							<% Case "2" %>
								</ul>
								<% if (oHTBCItem.FResultCount>3) then %>
								<ul class="simpleListV16a swiper-slide">
							    <% end if %>
							<% Case "5" %>
								</ul>
								<% if (oHTBCItem.FResultCount>6) then %>
								<ul class="simpleListV16a swiper-slide">
								<% end if %>
							<% Case "8" %>
						<% End Select %>
					<% Next %>
				</ul>
			</div>
		</div>
	</div>
	<div class="paginationDot"></div>
</div>

<%
	end if
	set oHTBCItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<script>
	mySwiper2 = new Swiper('.hpytgthrV16a .swiper-container',{
		pagination:'.hpytgthrV16a .paginationDot',
		paginationClickable:true,
		resizeReInit:true,
		calculateHeight:true
	});
</script>
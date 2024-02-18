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
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>

<%
	dim oHTBCItem, chkHT, itemid, catecode, rcpUid, vPrdList, vMtdList, mtv, tmpArr, mAbTestMobile
	dim lp, vIid, vMtd(), vLnk(), IValue
	ReDim vMtd(8), vLnk(8)

	itemid = requestCheckVar(request("itemid"),10)	'상품코드 128=>10
	catecode = requestCheckVar(request("disp"),18)	'전시카테고리
	'// 모바일 고도화용 a/b 테스트
	mAbTestMobile = requestCheckVar(request("amp"),18)


	'//클래스 선언
	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid
	oHTBCItem.FRectDisp = catecode


	'// 텐바이텐 해피투게더 상품 목록
	oHTBCItem.GetCateRightHappyTogetherList
%>

<%
    dim hpyDataExists : hpyDataExists =false
	if oHTBCItem.FResultCount>3 then
	    hpyDataExists = True
%>
		<div class="itemAddWrapV16a ctgyBestV16a">
			<div class="bxLGy2V16a">
				<h3><strong>이 상품과 같이 본 상품</strong></h3>
			</div>
			<div class="bxWt1V16a">
				<ul class="simpleListV16a simpleListV16b">
					<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
					<% if lp>36 then Exit For %>
						<li>
							<a href="/category/category_itemprd.asp?itemid=<%= oHTBCItem.FItemList(lp).FItemId %>&rc=item_happy_<%=lp+1%>&disptype=g" onclick="fnAmplitudeEventMultiPropertiesAction('click_itemprd_happytogether','itemid|index|searchkeyword|disptype','<%= oHTBCItem.FItemList(lp).FItemId %>|<%=lp%>|none|g');">
								<p><img src="<%=oHTBCItem.FItemList(lp).FIcon1Image %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" /></p>
								<span class="name"><%=oHTBCItem.FItemList(lp).FItemName%></span>
								<span class="price">
									<b class="sum"><% = FormatNumber(oHTBCItem.FItemList(lp).getRealPrice,0) %><small class="won"><%=chkIIF(oHTBCItem.FItemList(lp).IsMileShopitem,"Point","원")%></small></b>
									<% If oHTBCItem.FItemList(lp).IsSaleItem Then %>
									<b class="discount color-red"><% = oHTBCItem.FItemList(lp).getSalePro %></b>
									<% end if %>
								</span>								
							</a>
						</li>
					<% Next %>
				</ul>
			</div>
		</div>
<%
	end if
	set oHTBCItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
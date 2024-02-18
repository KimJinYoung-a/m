<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	dim oHTBCItem, chkHT, itemid, catecode, rcpUid, vPrdList, vMtdList, mtv, tmpArr
	dim lp, vIid, vMtd(), vLnk(), IValue, ti, userid, isBaguniUserLoginOk, guestSessionID, userKey, strSql
	ReDim vMtd(10), vLnk(10)

	If IsUserLoginOK() Then
		userid = getEncLoginUserID ''GetLoginUserID '' ''
		isBaguniUserLoginOK = true
	Else
		userid = GetLoginUserID
		isBaguniUserLoginOK = false
	End If
	guestSessionID = GetGuestSessionKey

    if (userid<>"") then
	    userKey = userid
	elseif (guestSessionID<>"") then
	    userKey = guestSessionID
	end If

	'// 해당 유저의 가장 최근에 장바구니에 담은 상품코드를 가져온다.
	strSql = " Select top 10 itemid From db_my10x10.dbo.tbl_my_baguni Where userKey='"&userKey&"' order by lastupdate, regdate desc "
	rsget.Open strSql, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
		Do Until rsget.eof
			itemid = itemid&","&rsget("itemid")
		rsget.movenext
		Loop
	Else
		
		Response.write ""
		dbget.close()
		Response.End
	End If
	rsget.close

	'// 현재 유저의 장바구니에 담긴 상품 리스트를 가져온다.
	If left(itemid, 1)="," Then
		itemid = Right(itemid, Len(itemid)-1)
	Else
		Response.write ""
		dbget.close()
		Response.End
	End If


	'//클래스 선언
	set oHTBCItem = New CAutoCategory
	oHTBCItem.FRectItemId = itemid

	'// 텐바이텐 해피투게더 상품 목록
	oHTBCItem.GetCateRightHappyTogetherNCateBestItemShoppingBagList


	if oHTBCItem.FResultCount>0 then
%>
<div class="cartRecobell inner10 tMar15">
	<h2 class="tit01"><span>함께 보면 좋은 상품</span></h2>
	<div class="swiper-container swiper15">
		<div class="swiper-wrapper">
			<ul class="simpleList swiper-slide">
				<%	For lp = 0 To oHTBCItem.FResultCount - 1 %>
				<% if lp>8 then Exit For %>
					<li>
						<a href="" onclick="fnAPPpopupProduct_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%= oHTBCItem.FItemList(lp).FItemId %>&ab=001_b_5');return false;">
							<p><img src="<%=oHTBCItem.FItemList(lp).FImageicon1 %>" alt="<%=oHTBCItem.FItemList(lp).FItemName%>" /></p>
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
						<% Case "2", "5" %>
							</ul>
							<ul class="simpleList swiper-slide">
						<% Case "8" %>
							</ul>
					<% End Select %>
				<% Next %>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<script>
	mySwiper15 = new Swiper('.swiper15',{
		pagination:'.cartRecobell .pagination',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true
	});
</script>
<%
	end if
	set oHTBCItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


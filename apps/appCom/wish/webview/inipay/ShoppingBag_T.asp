<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
''만료된 페이지 관련..

'' 사이트 구분
Const sitename = "10x10"
'' 마일리지샵 가능 여부
Const IsMileShopEnabled = true


''계속 쇼핑하기 URL
dim LastShoppingUrl
LastShoppingUrl = getPreShoppingLocation()


dim userid, guestSessionID
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey


dim chKdp, itemid, itemoption, itemea, requiredetail, sBagCount
chKdp		= requestCheckVar(request.Form("chKdp"),10)
itemid      = requestCheckVar(request.Form("itemid"),9)
itemoption  = requestCheckVar(request.Form("itemoption"),4)
itemea      = requestCheckVar(request.Form("itemea"),9)
requiredetail = request.Form("requiredetail")


dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserID    = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename


''쇼핑백 내용 쿼리
oshoppingbag.GetShoppingBagDataDB

sBagCount = oshoppingbag.FShoppingBagItemCount


''마일리지 및 쿠폰 정보
dim availtotalMile
dim oSailCoupon, oItemCoupon, oMileage

availtotalMile = 0

'// 마일리지 정보
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0


'// 할인권정보
set oSailCoupon = new CCoupon
oSailCoupon.FRectUserID = userid
oSailCoupon.FPageSize=100

if (userid<>"") then
	oSailCoupon.getValidCouponList
end if

'' (%) 보너스쿠폰 존재여부 - %할인쿠폰이 있는경우만 [%할인쿠폰제외상품]표시하기위함
dim intp, IsPercentBonusCouponExists
IsPercentBonusCouponExists = false
for intp=0 to oSailCoupon.FResultCount-1
    if (oSailCoupon.FItemList(intp).FCoupontype=1) then
        IsPercentBonusCouponExists = true
        Exit for
    end if
next

'// 쿠폰 정보
set oItemCoupon = new CUserItemCoupon
oItemCoupon.FRectUserID = userid
oItemCoupon.FPageSize=100

if (userid<>"") then
	oItemCoupon.getValidCouponList
end if

'' 상품 쿠폰 적용. //201204추가 === 쿠폰 적용가를 구하기 위함.
dim IsItemFreeBeasongCouponExists
IsItemFreeBeasongCouponExists = false
for i=0 to oItemCoupon.FResultCount-1
	if oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx) then
		oshoppingbag.AssignItemCoupon(oItemCoupon.FItemList(i).Fitemcouponidx)

		if (oshoppingbag.IsCouponItemExistsByCouponIdx(oItemCoupon.FItemList(i).Fitemcouponidx)) and (oitemcoupon.FItemList(i).IsFreeBeasongCoupon) then
		    IsItemFreeBeasongCouponExists = true
		end if
	end if
next

'// 마일리지 샾 상품
dim oMileageShop

set oMileageShop = new CMileageShop
oMileageShop.FPageSize=30

if (IsMileShopEnabled) and (userid<>"") then
    oMileageShop.GetMileageShopItemList
end if

dim iCols, iRows
iCols=5
iRows = CLng(oMileageShop.FResultCount \ iCols)

if (oMileageShop.FResultCount mod iCols)>0 then
	iRows = iRows + 1
end if


''포토북 편집 안한상품 존재
dim NotEditPhotobookExists
NotEditPhotobookExists = False
''주문제작 상품 문구 적지 않은 상품
dim NotWriteRequireDetailExists
dim iErrMsg
dim i, j, idx
i=0
idx=0

dim optionBoxHtml

'' OldType Option Box를 한 콤보로 표시
function getOneTypeOptionBoxHtmlMile(byVal iItemID, byVal isItemSoldOut, byval iOptionBoxStyle)
	dim i, optionHtml, optionTypeStr, optionKindStr, optionSoldOutFlag, optionSubStyle
    dim oItemOption

	set oItemOption = new CItemOption
    oItemOption.FRectItemID = iItemID
    oItemOption.FRectIsUsing = "Y"
    oItemOption.GetOptionList

    if (oItemOption.FResultCount<1) then Exit Function

    optionTypeStr = oItemOption.FItemList(0).FoptionTypeName
    if (Trim(optionTypeStr)="") then
        optionTypeStr = "옵션 선택"
    else
        optionTypeStr = optionTypeStr + " 선택"
    end if

	optionHtml = "<select name='item_option_"&iItemID&"' " + iOptionBoxStyle + ">"
    optionHtml = optionHtml + "<option value='' selected>" & optionTypeStr & "</option>"


    for i=0 to oItemOption.FResultCount-1
	    optionKindStr       = oItemOption.FItemList(i).FOptionName
	    optionSoldOutFlag   = ""

		if (oItemOption.FItemList(i).IsOptionSoldOut) then optionSoldOutFlag="S"

		''품절일경우 한정표시 안함
    	if ((isItemSoldOut) or (oItemOption.FItemList(i).IsOptionSoldOut)) then
    		optionKindStr = optionKindStr + " (품절)"
    		optionSubStyle = "style='color:#DD8888'"
    	else
    	    if (oitemoption.FItemList(i).Foptaddprice>0) then
    	    '' 추가 가격
    	        optionKindStr = optionKindStr + " (" + FormatNumber(oitemoption.FItemList(i).Foptaddprice,0)  + "원 추가)"
    	    end if

    	    if (oitemoption.FItemList(i).IsLimitSell) then
    		''옵션별로 한정수량 표시
    			optionKindStr = optionKindStr + " (한정 " + CStr(oItemOption.FItemList(i).GetOptLimitEa) + " 개)"
        	end if
        	optionSubStyle = ""
        end if

        optionHtml = optionHtml + "<option id='" + optionSoldOutFlag + "' " + optionSubStyle + " value='" + oItemOption.FItemList(i).FitemOption + "'>" + optionKindStr + "</option>"
	next

    optionHtml = optionHtml + "</select>"

	getOneTypeOptionBoxHtmlMile = optionHtml
	set oItemOption = Nothing
end function

Dim iTicketItemCNT : iTicketItemCNT = 0
Dim oTicketItem, TicketBookingExired : TicketBookingExired=FALSE

Dim iPresentItemCNT : iPresentItemCNT = 0

Dim eachCnt : eachCnt = 0 ''//각 개별 카운트

'=============================== 추가 정보 ==========================================
dim rstWishItem: rstWishItem=""
dim rstWishCnt: rstWishCnt=""
'// 장바구니 상품목록 작성
if IsUserLoginOK then
	dim rstArrItemid: rstArrItemid=""
	IF oshoppingbag.FShoppingBagItemCount>0 then
		for i=0 to oshoppingbag.FShoppingBagItemCount -1
			rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oshoppingbag.FItemList(i).FItemID
		Next
	End if
	'// 위시결과 상품목록 작성
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid,rstArrItemid,rstWishItem, rstWishCnt)
	end if
end if
'====================================================================================
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/webview/js/shoppingbag_script.js"></script>
<script type="text/javascript" src="/lib/js/itemPrdDetail.js"></script>
<!-- #include virtual="/apps/appCom/wish/webview/inipay/ShoppingBag_javascript.asp" -->
</head>
<body class="shop">
    <div class="wrapper cart">
        <header id="header">
            <h1 class="page-title">장바구니</h1>
            <ul class="txt-list">
                <li>장바구니는 접속 종료 후 14일동안 보관됩니다.</li>
                <li>장기간 상품을 보관하시려면 위시리스트 (wish list)에 넣어주세요.</li>
            </ul>
        </header><!-- #header -->
        <div id="content">
			<form name="frmC" method="get" action="/apps/appCom/wish/webview/shoppingtoday/couponshop_process.asp" style="margin:0px;">
			<input type="hidden" name="stype" value="" />
			<input type="hidden" name="idx" value="" />
			<input type="hidden" name="reval" value="" />
			</form>

			<% If oshoppingbag.IsShoppingBagVoid Then %>
            <div class="no-item-message t-c">
                <p class="diff-10"></p>
                <img src="../img/img-sad.png" alt="" width="50">
                <p class="diff-10"></p>
                <p class="x-large quotation" style="width:164px;">
                    <strong>장바구니에 담긴<br><span class="red">상품이 없습니다.</span></strong>
                </p>
            </div>
            <div class="diff"></div>
            <div class="grey-box">
                <h2>유의사항</h2>
                <ul class="txt-list">
                    <li>상품배송비는 텐바이텐배송/업체배송/업체조건배송/업체착불배송 4가지 기준으로 나누어 적용됩니다.</li>
                    <li>업체배송 및 업체조건배송, 업체착불배송 상품은 해당 업체에서 별도로 배송되오니 참고하여 주시기 바랍니다.</li>
                </ul>
            </div>
			<% Else %>
			<form name="baguniFrm" method="post" action="/apps/appCom/wish/webview/inipay/shoppingbag_process.asp" onSubmit="return false" >
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="jumundiv" value="1">

			<!-- 티켓구매 START -->
			<% if (oshoppingbag.IsTicketSangpumExists) then %>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>티켓 단독 상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
						eachCnt = 0 ''//배송별 수량카운트
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if (oshoppingbag.FItemList(i).IsTicketItem) Then

							TicketBookingExired = FALSE

	                        set oTicketItem = new CTicketItem
	                        oTicketItem.FRectItemID = oshoppingbag.FItemList(i).FItemID
	                        oTicketItem.GetOneTicketItem
	                        IF (oTicketItem.FResultCount>0) then
	                            TicketBookingExired = oTicketItem.FOneItem.IsExpiredBooking
	                        END IF
	                        set oTicketItem = Nothing
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
							<input type="hidden" name="soldoutflag" value="<% if (oshoppingbag.FItemList(i).IsSoldOut) or (TicketBookingExired) then response.write "Y" else response.write "N" end if %>">
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>">
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N">
							<input type="hidden" name="dtypflag" value="0">
							<input type="hidden" name="mtypflag" value="t">
							<input type="hidden" name="isellprc" value="<%= oshoppingbag.FItemList(i).getRealPrice %>">
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1">
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0">
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100" height="100"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
                                	<span class="red">[현장수령상품]</span>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>
                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 매진 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1

							iTicketItemCNT = iTicketItemCNT +1
							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt %>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice+oshoppingbag.GetTicketItemBeasongPrice,0) %><span class="unit">원</span></strong>
                    티켓 단독상품 <%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice,0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.GetTicketItemBeasongPrice,0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice+oshoppingbag.GetTicketItemBeasongPrice,0) %><span class="unit">원</span>
                </div>
            </div>
			<% end if %>

			<!-- 현장수령 상품 START -->
			<% if (oshoppingbag.IsRsvSiteSangpumExists)  then %>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>현장수령 상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
						eachCnt = 0 ''//배송별 수량카운트
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if (oshoppingbag.FItemList(i).IsReceiveSite) Then
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>">
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>">
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N">
							<input type="hidden" name="dtypflag" value="0">
							<input type="hidden" name="mtypflag" value="r">
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1">
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0">
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100" height="100"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
                                	<span class="red">[현장수령상품]</span>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>
                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1

							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt %>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice+oshoppingbag.GetRsvSiteItemBeasongPrice,0) %><span class="unit">원</span></strong>
                    상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice,0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.GetRsvSiteItemBeasongPrice,0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice+oshoppingbag.GetRsvSiteItemBeasongPrice,0) %><span class="unit">원</span>
                </div>
            </div>
			<% end if %>

			<!-- Present 상품 START -->
			<% if (oshoppingbag.IsPresentSangpumExists)  then %>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>10x10 Present 상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
						<%
							eachCnt = 0 ''//배송별 수량카운트
							for i=0 to oshoppingbag.FShoppingBagItemCount -1
								if (oshoppingbag.FItemList(i).IsPresentItem) then
						%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>">
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>">
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N">
							<input type="hidden" name="dtypflag" value="0">
							<input type="hidden" name="mtypflag" value="p">
							<input type="hidden" name="nophothofileflag" value="0">
							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100" height="100"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
									<span class="red">[단독구매상품]</span>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><span class="blue">[선착순구매상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
						<%
								iPresentItemCNT = iPresentItemCNT +1
								idx = idx +1
								eachCnt = eachCnt + 1
								end if
							next
						%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt %>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice+oshoppingbag.GetPresentItemBeasongPrice,0) %><span class="unit">원</span></strong>
                    10x10 Present <%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice,0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.GetPresentItemBeasongPrice,0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice+oshoppingbag.GetPresentItemBeasongPrice,0) %><span class="unit">원</span>
                </div>
            </div>
			<% end if %>

			<!-- 텐바이텐 배송 상품 START -->
			<%	if (oshoppingbag.IsTenBeasongInclude) or (oshoppingbag.IsMileShopSangpumExists)  then	%>
            <div class="cart-box by-10x10">
                <h1 class="cart-title"><span>텐바이텐 배송상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
						eachCnt = 0 ''//배송별 수량카운트
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if (Not oshoppingbag.FItemList(i).IsReceivePayItem ) and (Not oshoppingbag.FItemList(i).IsUpcheBeasong) and (Not oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (Not oshoppingbag.FItemList(i).IsTicketItem) and Not(oshoppingbag.FItemList(i).IsReceiveSite)and Not(oshoppingbag.FItemList(i).IsPresentItem) then
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>"/>
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>"/>
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>"/>
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>"/>
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>"/>
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>"/>
							<input type="hidden" name="dtypflag" value="1"/>
							<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
							<input type="hidden" name="mtypflag" value="o"/>
							<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %>
							<input type="hidden" name="mtypflag" value="m"/>
							<% else %>
							<input type="hidden" name="mtypflag" value="" />
							<% end if %>
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1" />
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0" />
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" width="100px" height="100px" class="product-img"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><span class="red">[<strong>+</strong> Sale 상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><span class="red">[마일리지샵상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><span class="red">[무료배송상품]</span><% end if %>
									<% end if %>
									<% if (oshoppingbag.FItemList(i).IsSpecialUserItem) then %><span class="red">[우수회원샵상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><span class="blue">[선착순구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><span class="blue">[주문제작상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsForeignDeliverValid) then %><span class="blue">[해외배송가능]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).FOrgPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>
                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>

                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% End If  %>
                            </table>

                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>

                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt %>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice+oshoppingbag.getTenDeliverItemBeasongPrice,0) %><span class="unit">원</span></strong>
                    상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice,0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.getTenDeliverItemBeasongPrice,0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice+oshoppingbag.getTenDeliverItemBeasongPrice,0) %><span class="unit">원</span>
                </div>

            </div>
			<% end If %>

			<!-- 업체 배송상품 배송 상품 START -->
			<% if (oshoppingbag.IsUpcheBeasongInclude)  then	%>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>업체 배송상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
					eachCnt = 0 ''//배송별 수량카운트
					for i=0 to oshoppingbag.FShoppingBagItemCount -1
						if ( oshoppingbag.FItemList(i).IsUpcheBeasong) then

							'####### 포토북일 경우 -> 포토북편집을 해놓은 경우는 주문가능. 안한경우는 pc버전 window 상에서 편집 후 주문가능 경고창 띄움. #######
							if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName = "") then
								NotEditPhotobookExists = True
							end if
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>" />
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>" />
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="dtypflag" value="2" />
							<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
							<input type="hidden" name="mtypflag" value="o" />
							<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %>
							<input type="hidden" name="mtypflag" value="m" />
							<% else %>
							<input type="hidden" name="mtypflag" value="" />
							<% end if %>
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1" />
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0" />
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="2" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100" height="100"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><span class="red">[<strong>+</strong> Sale 상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><span class="red">[마일리지샵상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><span class="red">[무료배송상품]</span><% end if %>
									<% end if %>
									<% if (oshoppingbag.FItemList(i).IsSpecialUserItem) then %><span class="red">[우수회원샵상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><span class="blue">[선착순구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><span class="blue">[주문제작상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsForeignDeliverValid) then %><span class="blue">[해외배송가능]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).FOrgPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>
                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt %>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice+oshoppingbag.getUpcheBeasongPrice,0) %><span class="unit">원</span></strong>
                    상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice,0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.getUpcheBeasongPrice,0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice+oshoppingbag.getUpcheBeasongPrice,0) %><span class="unit">원</span>
                </div>
            </div>
            <% end If %>

            <!----- 업체 조건 배송 상품 목록 START ----->
			<%
			if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
				oshoppingbag.GetParticleBeasongInfoDB

				for j=0 to oshoppingbag.FParticleBeasongUpcheCount - 1
			%>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>업체 조건 배송상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
						eachCnt = 0 ''//배송별 수량카운트
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if ( oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (LCase(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid)=LCase(oshoppingbag.FItemList(i).FMakerid)) then
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>" />
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>" />
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="dtypflag" value="3" />
							<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
							<input type="hidden" name="mtypflag" value="o" />
							<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %>
							<input type="hidden" name="mtypflag" value="m" />
							<% else %>
							<input type="hidden" name="mtypflag" value="" />
							<% end if %>
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1" />
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0"/>
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="3" value="<%= idx %>"/>
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100px" height="100px"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><span class="red">[<strong>+</strong> Sale 상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><span class="red">[마일리지샵상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><span class="red">[무료배송상품]</span><% end if %>
									<% end if %>
									<% if (oshoppingbag.FItemList(i).IsSpecialUserItem) then %><span class="red">[우수회원샵상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><span class="blue">[선착순구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><span class="blue">[주문제작상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsForeignDeliverValid) then %><span class="blue">[해외배송가능]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).FOrgPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>

                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt%>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid)+oshoppingbag.getUpcheParticleItemBeasongPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %><span class="unit">원</span></strong>
                    상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %><span class="unit">원</span> + 배송비 <%= FormatNumber(oshoppingbag.getUpcheParticleItemBeasongPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %><span class="unit">원</span> = <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid)+oshoppingbag.getUpcheParticleItemBeasongPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %><span class="unit">원</span>
                </div>
            </div>
			<%
				next
			end if
			%>
			<!-- 업체 착불배송 START -->
			<% if (oshoppingbag.IsReceivePayItemInclude)  then %>
            <div class="cart-box by-indie">
                <h1 class="cart-title"><span>업체 착불 배송상품</span></h1>
                <label for="checkAll" class="check-all"><input type="checkbox" id="checkAll" class="form"> 전체선택</label>
                <div class="product-in-cart">
                    <ul>
					<%
						eachCnt = 0 ''//배송별 수량카운트
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if ( oshoppingbag.FItemList(i).IsReceivePayItem) then
					%>
                        <li>
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>">
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>">
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>">
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>">
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>">
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="<% if oshoppingbag.FItemList(i).IsForeignDeliverValid then response.write "Y" else response.write "N" end if %>">
							<input type="hidden" name="dtypflag" value="3">
							<% if oshoppingbag.FItemList(i).Is09Sangpum then %>
							<input type="hidden" name="mtypflag" value="o">
							<% elseif oshoppingbag.FItemList(i).IsMileShopSangpum then %>
							<input type="hidden" name="mtypflag" value="m">
							<% else %>
							<input type="hidden" name="mtypflag" value="">
							<% end if %>
							<% if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName="") then %>
							<input type="hidden" name="nophothofileflag" value="1">
							<% else %>
							<input type="hidden" name="nophothofileflag" value="0">
							<% end if %>
							<input type="checkbox" class="form checker" name="chk_item" id="3" value="<%= idx %>" />
                            <a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= oshoppingbag.FItemList(i).FItemName %>" class="product-img" width="100px" height="100px"></a>
                            <div class="product-spec">
                                <h2 class="product-name"><%= oshoppingbag.FItemList(i).FItemName %></h2>
                                <div>
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><span class="red">[<strong>+</strong> Sale 상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><span class="red">[마일리지샵상품]</span><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><span class="red">[단독구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><span class="red">[무료배송상품]</span><% end if %>
									<% end if %>
									<% if (oshoppingbag.FItemList(i).IsSpecialUserItem) then %><span class="red">[우수회원샵상품]</span><% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><span class="blue">[%보너스쿠폰제외상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><span class="blue">[선착순구매상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><span class="blue">[주문제작상품]</span><% end if %>
									<% if (oshoppingbag.FItemList(i).IsForeignDeliverValid) then %><span class="blue">[해외배송가능]</span><% end if %>
                                </div>
                                <div class="option">
                                    <span class=""><%= oshoppingbag.FItemList(i).getOptionNameFormat %></span>
                                </div>
                            </div>
                            <hr class="clear">
                            <table>
	                            <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">Pt</span></td>
	                                </tr>
								<% else %>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).FOrgPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <tr>
	                                    <th>할인판매가</th>
	                                    <td>
	                                        <strong class="red"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="uint">원</span></strong>   <span class="discount red"><%=oshoppingbag.FItemList(i).getSalePro%>↓</span>
	                                    </td>
	                                </tr>
	                                <% else %>
	                                <tr>
	                                    <th>판매가</th>
	                                    <td><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %><span class="unit">원</span></td>
	                                </tr>
	                                <% end if %>
								<% end if %>

                                <tr>
                                    <th>수량</th>
                                    <td>
                                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
                                        	<%= oshoppingbag.FItemList(i).FItemEa %>개<input name="itemea" type="hidden" value="<%= oshoppingbag.FItemList(i).FItemEa %>" class="ct c333 w40B" />
                                        <% else %>
	                                        <div class="input-with-btn">
	                                        	<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" class="form">
	                                        	<input type="button" class="btn type-d" onClick="EditItem('<%= idx %>');" value="변경">
	                                        </div>
                                        <% end if %>
                                        <input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>"></dd>
                                    </td>
                                </tr>

                                <% if (oshoppingbag.FItemList(i).FUserVaildCoupon) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</strong></td>
                                </tr>
                                <% elseif Not IsNULL(oshoppingbag.FItemList(i).Fcurritemcouponidx) then %>
                                <tr>
                                    <th>상품쿠폰 적용가</th>
                                    <td><strong class="green">[<%= oshoppingbag.FItemList(i).getCouponTypeStr %>] <a href="javascript:jsDownCouponShoppingbag('prd','<%= oshoppingbag.FItemList(i).FCurrItemCouponIdx %>','S');" class="btn type-a small">쿠폰받기</a></strong></td>
                                </tr>
                                <% end if %>

								<% if oshoppingbag.FItemList(i).ISsoldOut then %>
								<tr>
									<th></th>
									<td><strong class="red">상품이 품절 되었습니다.</strong></td>
								</tr>
								<% else %>
                                <tr>
                                    <th>총금액</th>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">Pt</span></strong></td>
									<% else %>
									<td><strong><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %><span class="unit">원</span></strong></td>
									<% end if %>
                                </tr>
                                <% end if %>
                            </table>
                           	<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
                            <hr class="clear">
                            <table>
                                <colgroup>
                                    <col width="110"/>
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th class="v-t">주문제작문구</th>
                                    <td class="t-l">
										<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then %>
										(! 주문제작문구를 넣어주세요.)
										<% NotWriteRequireDetailExists = True %>
										<% else %>
										<%= oshoppingbag.FItemList(i).getRequireDetailHtml %>
										<% end if %>
                                        <input type="button" class="btn type-e small full-size" style="margin-top:5px;" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <hr class="clear">
                            <div class="three-btns">
                                <div class="col">
                                	<input type="button" class="btn type-e small" onClick="DelItem('<%= idx %>');" value="삭제">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-f small <%=chkIIF(chkArrValue(rstWishItem,oshoppingbag.FItemList(i).FItemid),"red","")%>" onClick="TnAddFavorite('<%= oshoppingbag.FItemList(i).FItemid %>');" value="위시">
                                </div>
                                <div class="col">
                                	<input type="button" class="btn type-b small" onClick="DirectOrder('<%= idx %>');" value="바로주문">
                                </div>
                            </div>
                            <div class="clear"></div>
                        </li>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							end if
						next
					%>
                    </ul>
                </div>

                <div class="cart-sum">
                    <strong class="red">총 <%=eachCnt%>개 / <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice,0) %><span class="unit">원</span></strong>
                    상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice+0,0) %><span class="unit">원</span> + 배송비 착불 부과
                </div>

            </div>
			<% end if %>
			<!-- 업체 착불배송 END -->

            <div class="inner">
                <table class="cart-total plain">
                    <tr>
                        <th>총 주문상품 수</th>
                        <td><%= idx %>종(<%= oshoppingbag.GetTotalItemEa %>개)</td>
                    </tr>
                    <tr>
                        <th>적립마일리지</th>
                        <td><%= FormatNumber(oshoppingbag.getTotalGainmileage,0) %> Point</td>
                    </tr>
                    <tr>
                        <th>총 상품주문 합계</th>
                        <td><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %> <span class="unit">원</span></td>
                    </tr>
                    <tr>
                        <th>총 배송비 합계</th>
                        <td><%= FormatNumber(oshoppingbag.GetTotalBeasongPrice,0) %> <span class="unit">원</span></td>
                    </tr>
					<% if oshoppingbag.GetMileageShopItemPrice<>0 then %>
                    <tr>
                        <th>마일리지샵 금액</th>
                        <td><%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %> <span class="unit">Point</span></td>
                    </tr>
					<% end if %>
                    <tr class="highlight">
                        <th>총 합계</th>
                        <td><strong><%= FormatNumber(oshoppingbag.getTotalPrice("0000")-oshoppingbag.GetMileageShopItemPrice,0) %> <span class="unit">원</span></strong></td>
                    </tr>
                </table>

                <div class="three-btns">
                    <div class="col">
                    	<input type="button" class="btn type-a" onClick="delSelected();" value="선택상품 삭제">
                    </div>
                    <div class="col">
                    	<input type="button" class="btn type-f" onClick="PayNextSelected(1);" value="선택상품 주문">
                    </div>
                    <div class="col">
                    	<input type="button" class="btn type-f" onClick="PayNextSelected(2);" value="해외배송 주문">
                    </div>
                </div>
                <div class="clear"></div>
                <div class="diff-10"></div>
				<%
				''Check Confirm
				if oshoppingbag.IsSoldOutSangpumExists then
					iErrMsg = "죄송합니다. 품절된 상품은 구매하실 수 없습니다."
				elseif oshoppingbag.Is09NnormalSangpumExists then
					iErrMsg = "단독구매 및 예약판매 상품과 일반상품은 같이 구매하실 수 없습니다.\n\n단독구매 및 예약판매 상품은 별도로 장바구니에 담아주세요"
				elseif oshoppingbag.IsTicketNnormalSangpumExists then
					iErrMsg = "티켓 단독구매상품과 일반상품은 같이 구매 할 수 없으니 따로 주문해 주시기 바랍니다"
				elseif oshoppingbag.IsRsvSiteNnormalSangpumExists then
					iErrMsg = "현장수령상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다"
				elseif oshoppingbag.IsPresentNnormalSangpumExists then
					iErrMsg = "Present상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다"
				elseif (oshoppingbag.GetMileshopItemCount>0) and (oshoppingbag.GetTenBeasongCount<1) then
					iErrMsg = "마일리지샾 상품은 텐바이텐 배송상품과 함께 구매 하셔야 배송 가능 합니다."
				elseif (availtotalMile<oshoppingbag.GetMileageShopItemPrice) then
					iErrMsg = "마일리지샾 상품을 구매하실 수 있는 마일리지가 부족합니다. 현재 마일리지 : " & FormatNumber(availtotalMile,0) & " point"
				elseif oshoppingbag.IsTicketSangpumExists and (not IsUserLoginOk) then
					iErrMsg = "죄송합니다. 티켓 상품은 회원 구매만 가능합니다."
				elseif (iTicketItemCNT>1) then
				    iErrMsg = "티켓 상품은 한번에 한 상품씩 구매 가능합니다."
				elseif oshoppingbag.IsPresentSangpumExists and (not IsUserLoginOk) then
					iErrMsg = "죄송합니다. Present상품은 회원 구매만 가능합니다."
				elseif (iPresentItemCNT>1) then
					iErrMsg = "Present상품은 한번에 한 상품씩 구매 가능합니다."
				end if

				If NotEditPhotobookExists = True Then %>
				<input type="button" class="btn type-b full-size" onClick="alert('포토북 상품은 모바일에서가 아닌\n일반 PC상에서 포토북 편집후\n구매가 가능합니다.');" value="전체상품 주문하기">
				<% Else %>
				<input type="button" class="btn type-b full-size" onClick="PayNext(baguniFrm,1,'<%= iErrMsg %>');" value="전체상품 주문하기">
				<% End If %>

            </div>
			</form>
            <div class="diff"></div>
            <div class="grey-box">
                <h2>유의사항</h2>
                <ul class="txt-list">
                    <li>상품배송비는 텐바이텐배송/업체배송/업체조건배송/업체착불배송 4가지 기준으로 나누어 적용됩니다.</li>
                    <li>업체배송 및 업체조건배송, 업체착불배송 상품은 해당 업체에서 별도로 배송되오니 참고하여 주시기 바랍니다.</li>
					<% if (oshoppingbag.IsTicketSangpumExists) then %><li>티켓예매는 일반상품과 함께 구매가 안되며 티켓만 단독으로 주문가능합니다.</li><% end if %>
					<% if (oshoppingbag.IsRsvSiteSangpumExists) then %><li>현장수령 상품은 일반상품과 함께 구매가 안되며 단독으로만 주문가능합니다.</li><% end if %>
					<% if (oshoppingbag.IsPresentSangpumExists) then %><li>Present상품은 일반상품과 함께 구매가 안되며 단독으로만 주문가능합니다.</li><% end if %>
                </ul>
            </div>
            <% End if %>

			<form name="mileForm" style="margin:0px;">
			<%
				if (IsMileShopEnabled) then
					if (oMileageShop.FResultCount>0) then
			%>
            <div class="diff"></div>
            <div class="inner">
                <div class="mileage-shop">
                    <dl class="mileage-header">
                        <dt>마일지리샵</dt>
                        <dd>현재 마일리지 <strong class="red"><%= FormatNumber(oMileage.FTotalMileage,0) %> point</strong></dd>
                    </dl>
                    <ul class="mileage-shop-product-list">
                    <% for i=0 to oMileageShop.FResultCount-1 %>
                        <li class="bordered-box">
                            <div class="product-info gutter">
                                <div class="product-img"><a href="/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<% = omileageshop.FItemList(i).FItemID %>"><img src="<%= omileageshop.FItemList(i).Flistimage120 %>" alt="<%= Replace(Replace(oMileageShop.FItemList(i).FItemName,"[마일리지샵]",""),"[마일리지샵]","") %>" style="width:100%" /></a></div>
                                <div class="product-spec"><p class="product-name"><%= Replace(Replace(oMileageShop.FItemList(i).FItemName,"[마일리지샵]",""),"[마일리지샵]","") %></p></div>
                                <div class="point"><strong><%= FormatNumber(oMileageShop.FItemList(i).getMileageCash,0) %> Point</strong></div>
                                <div style="padding-bottom:5px;"><%
								optionBoxHtml = ""
								''품절시 제외.
								If (omileageshop.FItemList(i).IsItemOptionExists) and (Not omileageshop.FItemList(i).IsSoldOut) then
								optionBoxHtml = getOneTypeOptionBoxHtmlMile(omileageshop.FItemList(i).FItemID,omileageshop.FItemList(i).IsSoldOut,"style=""width:110px;height:18px;""")
								End If

								response.write optionBoxHtml
								%></div>
								<% if omileageshop.FItemList(i).IsSoldOut then %>
									<strong>SOLD OUT</strong>
								<% elseif (availtotalMile<omileageshop.FItemList(i).getMileageCash) then %>
									<input type="button" class="btn type-b small btn-cart" value="장바구니 담기" onClick="alert('마일리지샾 상품을 구매하실 수 있는 마일리지가 부족합니다. 현재 마일리지 : <%= formatnumber(availtotalMile,0) %>');">
								<% else %>
									<input type="button" class="btn type-b small btn-cart" value="장바구니 담기" onClick="AddMileItem2('<%= omileageshop.FItemList(i).FItemID %>','0000','1');">
								<% end if %>
                            </div>
                        </li>
					<% next %>
                    </ul>
                </div>
            </div>
            <div class="grey-box">
                <ul class="txt-list">
                    <li>마일리지는 구매 또는 상품후기 작성으로 쌓을 수 있습니다.</li>
                    <li>마일리지샵 상품은 텐바이텐 배송 상품과 함께 한 상품당 하나씩만 구매하실 수 있습니다.</li>
                </ul>
            </div>
			<%
					end if
				end if
			%>
			</form>

			<form name="reloadFrm" method="post" action="/apps/appCom/wish/webview/inipay/shoppingbag_process.asp" onsubmit="return false;">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="itemoption" value="">
			<input type="hidden" name="itemea" value="">
			</form>

			<form name="NextFrm" method="post" action="<%= Replace(wwwUrl,"http:","http:") %>/apps/appCom/wish/webview/inipay/userinfo.asp">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="jumundiv" value="1">
			<input type="hidden" name="subtotalprice" value="<%= oshoppingbag.getTotalPrice("0000") %>">
			<input type="hidden" name="itemsubtotal" value="<%= oshoppingbag.GetTotalItemOrgPrice %>">
			<input type="hidden" name="mileshopitemprice" value="<%= oshoppingbag.GetMileageShopItemPrice %>">
			</form>

			<form name="frmConfirm" method="post" action="/apps/appCom/wish/webview/inipay/shoppingbag_process.asp">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="tp" value="">
			<input type="hidden" name="fc" value="on">
			<input type="hidden" name="itemid" value="<%= itemid %>">
			<input type="hidden" name="itemoption" value="<%= itemoption %>">
			<input type="hidden" name="itemea" value="<%= itemea %>">
			<input type="hidden" name="requiredetail" value="<%= doubleQuote(requiredetail) %>">
			</form>

			<%
			if (oshoppingbag.IsFixNnormalSangpumExists) then
				response.write "<script language='javascript'> ChkErrMsg = '지정일 배송상품(꽃배달)과 일반택배 상품은 같이 배송되지 않으니 양해하시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsTicketNnormalSangpumExists) then
				response.write "<script language='javascript'> ChkErrMsg = '티켓 단독구매상품과 일반상품은 같이 구매 할 수 없으니 따로 주문해 주시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsRsvSiteNnormalSangpumExists) then
				response.write "<script language='javascript'> ChkErrMsg = '현장수령상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsPresentNnormalSangpumExists) then
				response.write "<script language='javascript'> ChkErrMsg = 'Present상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다.';</script>"
			elseif oshoppingbag.Is09NnormalSangpumExists then
				response.write "<script language='javascript'> ChkErrMsg = '단독구매 및 예약판매 상품과 일반상품은 같이 구매하실 수 없습니다.\n\n단독구매 및 예약판매 상품은 별도로 장바구니에 담아주세요';</script>"
			elseif (oshoppingbag.GetMileshopItemCount>0) and (oshoppingbag.GetTenBeasongCount<1) then
				response.write "<script language='javascript'> ChkErrMsg = '마일리지샾 상품은 텐바이텐 배송상품과 함께 하셔야 배송 가능 합니다.';</script>"
			elseif (oshoppingbag.GetMileageShopItemPrice>availtotalMile) then
				response.write "<script language='javascript'> ChkErrMsg = '사용 가능한 마일리지는 " & availtotalMile & " 입니다. - 마일리지 상품 합계가 현재 마일리지보다 많습니다.';</script>"
			end if

			if (NotWriteRequireDetailExists) then
				response.write "<script language='javascript'> ChkErrMsg = '주문 제작 문구를 작성하지 않은 상품이 존재합니다. - 주문 제작문구를 작성해주세요.';</script>"
			end if

			if (NotEditPhotobookExists) then
				response.write "<script language='javascript'> ChkErrMsg = '편집이 안되 포토북 상품이 있습니다 - 포토북 상품은 윈도우의 일반PC웹에서 편집 후 구매해 주세요.';</script>"
			end if
			%>
        </div><!-- #content -->

		<script>
			function getOnload(){
				<% if (chKdp="on") then %>
				NtcCenterLayer();
				<% end if %>
				if (ChkErrMsg){
					alert(ChkErrMsg);
				}
			}
			window.onload = getOnload;
		</script>
		<iframe id="wishProc" name="wishProc" src="about:blank" frameborder="0px" width="0px" height="0px" style="display:block;"></iframe>

        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div>
    <div id="modalCont" style="display:none;"></div>

    <script>
    $('.cart-box').each(function(){
        var box = $(this);
        $('.check-all input[type="checkbox"]', box).on('click', function(){
            if ( $(this).is(":checked") == true) {
                $('.product-in-cart .checker', box).attr('checked', true);
            } else {
                $('.product-in-cart .checker', box).attr('checked', false);
            }
        });
    });

    </script>

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
	set oShoppingBag = Nothing
	set oMileageShop = Nothing
	set oSailCoupon  = Nothing
	set oItemCoupon  = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
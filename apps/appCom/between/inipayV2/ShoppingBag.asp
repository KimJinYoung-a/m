<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
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


dim userid, userSn
userid = fnGetUserInfo("tenId")
userSn = fnGetUserInfo("tenSn")

dim chKdp, itemid, itemoption, itemea, requiredetail, sBagCount
chKdp		= requestCheckVar(request.Form("chKdp"),10)
itemid      = requestCheckVar(request.Form("itemid"),9)
itemoption  = requestCheckVar(request.Form("itemoption"),4)
itemea      = requestCheckVar(request.Form("itemea"),9)
requiredetail = request.Form("requiredetail")


dim oShoppingBag
set oShoppingBag = new CShoppingBag
oShoppingBag.FRectUserSn    = "BTW_USN_" & userSn
oShoppingBag.FRectSiteName  = sitename

''쇼핑백 내용 쿼리
oshoppingbag.GetShoppingBagDataDB

sBagCount = oshoppingbag.FShoppingBagItemCount

''쇼핑백 갯수 처리
Call setBetweenCartCount(sBagCount)


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
Dim eachTCnt : eachTCnt = 0 ''//각 개별 총 카운트

%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script type="text/javascript" src="/apps/appCom/between/lib/js/shoppingbag_script.js"></script>
<script type="text/javascript" src="/lib/js/itemPrdDetail.js"></script>
<!-- #include virtual="/apps/appCom/between/inipay/ShoppingBag_javascript.asp" -->
</head>
<body>
<div class="wrapper <%=chkIIF(oshoppingbag.IsShoppingBagVoid,"","cartWrap")%>" id="btwMypage">
	<div id="content">
		<!-- include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA">장바구니</h1>
			</div>

			<% If Not(oshoppingbag.IsShoppingBagVoid) Then %>
			<div class="section">
				<p>장바구니에 담으신 상품은 14일 동안 보관됩니다.</p>
			</div>
			<% end If %>

			<form name="frmC" method="get" action="/apps/appCom/between/shoppingtoday/couponshop_process.asp" style="margin:0px;">
			<input type="hidden" name="stype" value="" />
			<input type="hidden" name="idx" value="" />
			<input type="hidden" name="reval" value="" />
			</form>
			
		<% If oshoppingbag.IsShoppingBagVoid Then %>
			<div class="noData cartNoData">
				<p>
					<strong>장바구니에 담긴 상품이 없습니다.</strong>
					<% '더 다양한 상품을 만나보세요 :) %>
				</p>

				<% '<div class="btnArea"><span class="btn02 btw btnBig"><a href="/apps/appCom/between/">비트윈 추천 보러가기</a></span></div> %>
			</div>
		<% Else %>
			<form name="baguniFrm" method="post" action="/apps/appCom/between/inipay/shoppingbag_process.asp" onSubmit="return false" >
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="jumundiv" value="1">
			
			<!-- 티켓구매 START -->
			<% if (oshoppingbag.IsTicketSangpumExists) then %>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">티켓 단독 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
						eachCnt = 0 ''//배송별 수량카운트
						eachTCnt = 0	''//배송별 상품 개수
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
						<div class="cart pdtList list02 boxMdl">
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
										<strong class="txtSaleRed">[현장수령상품]</strong>
										<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
										<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1
	
							iTicketItemCNT = iTicketItemCNT +1
							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice,0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.GetTicketItemBeasongPrice,0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTicketItemPrice+oshoppingbag.GetTicketItemBeasongPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<% end if %>
			
			<!-- 현장수령 상품 START -->
			<% if (oshoppingbag.IsRsvSiteSangpumExists)  then %>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">현장수령 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
						eachCnt = 0 ''//배송별 수량카운트
						eachTCnt = 0	''//배송별 총상품 개수
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if (oshoppingbag.FItemList(i).IsReceiveSite) Then
					%>
						<div class="cart pdtList list02 boxMdl">
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
										<strong class="txtSaleRed">[현장수령상품]</strong>
										<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
										<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1

							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice,0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.GetRsvSiteItemBeasongPrice,0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingRsvSiteItemPrice+oshoppingbag.GetRsvSiteItemBeasongPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<% end if %>
			
			<!-- Present 상품 START -->
			<% if (oshoppingbag.IsPresentSangpumExists)  then %>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">10x10 Present 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
						<%
							eachCnt = 0 ''//배송별 수량카운트
							eachTCnt = 0	''//배송별 총상품 개수
							for i=0 to oshoppingbag.FShoppingBagItemCount -1
								if (oshoppingbag.FItemList(i).IsPresentItem) then
						%>
						<div class="cart pdtList list02 boxMdl">
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
										<strong class="txtSaleRed">[단독구매상품]</strong>
										<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><strong class="txtBtwDk">[선착순구매상품]</strong><% end if %>
										<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
						<%
								iPresentItemCNT = iPresentItemCNT +1
								idx = idx +1
								eachCnt = eachCnt + 1
								eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
								end if
							next
						%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice,0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.GetPresentItemBeasongPrice,0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingPresentItemPrice+oshoppingbag.GetPresentItemBeasongPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<% end if %>
			
			<!-- 텐바이텐 배송 상품 START -->
			<%	if (oshoppingbag.IsTenBeasongInclude) or (oshoppingbag.IsMileShopSangpumExists)  then	%>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">텐바이텐 배송상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
						eachCnt = 0 ''//배송별 수량카운트
						eachTCnt = 0	''//배송별 총상품 개수
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if (Not oshoppingbag.FItemList(i).IsReceivePayItem ) and (Not oshoppingbag.FItemList(i).IsUpcheBeasong) and (Not oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (Not oshoppingbag.FItemList(i).IsTicketItem) and Not(oshoppingbag.FItemList(i).IsReceiveSite)and Not(oshoppingbag.FItemList(i).IsPresentItem) then
					%>
						<div class="cart pdtList list02 boxMdl">
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>"/>
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>"/>
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>"/>
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>"/>
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>"/>
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N"/>
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><strong class="txtSaleRed">[+ Sale 상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><strong class="txtSaleRed">[마일리지샵상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><strong class="txtSaleRed">[무료배송상품]</strong><% end if %>
									<% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><strong class="txtBtwDk">[선착순구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><strong>[주문제작상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice,0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.getTenDeliverItemBeasongPrice,0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingTenDeliverItemPrice+oshoppingbag.getTenDeliverItemBeasongPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<% end If %>
			
			<!-- 업체 배송상품 배송 상품 START -->
			<% if (oshoppingbag.IsUpcheBeasongInclude)  then	%>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">업체 배송 상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
					eachCnt = 0 ''//배송별 수량카운트
					eachTCnt = 0	''//배송별 총상품 개수
					for i=0 to oshoppingbag.FShoppingBagItemCount -1
						if ( oshoppingbag.FItemList(i).IsUpcheBeasong) then

							'####### 포토북일 경우 -> 포토북편집을 해놓은 경우는 주문가능. 안한경우는 pc버전 window 상에서 편집 후 주문가능 경고창 띄움. #######
							if (oshoppingbag.FItemList(i).ISFujiPhotobookItem) and (oshoppingbag.FItemList(i).getPhotobookFileName = "") then
								NotEditPhotobookExists = True
							end if
					%>
						<div class="cart pdtList list02 boxMdl">
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>" />
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>" />
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N" />
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><strong class="txtSaleRed">[+ Sale 상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><strong class="txtSaleRed">[마일리지샵상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><strong class="txtSaleRed">[무료배송상품]</strong><% end if %>
									<% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><strong class="txtBtwDk">[선착순구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><strong>[주문제작상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice,0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.getUpcheBeasongPrice,0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheItemPrice+oshoppingbag.getUpcheBeasongPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
            <% end If %>
            
            <!----- 업체 조건 배송 상품 목록 START ----->
			<%
			if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
				oshoppingbag.GetParticleBeasongInfoDB

				for j=0 to oshoppingbag.FParticleBeasongUpcheCount - 1
			%>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">업체 조건 배송상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
						eachCnt = 0 ''//배송별 수량카운트
						eachTCnt = 0	''//배송별 총상품 개수
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if ( oshoppingbag.FItemList(i).IsUpcheParticleBeasong) and (LCase(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid)=LCase(oshoppingbag.FItemList(i).FMakerid)) then
					%>
						<div class="cart pdtList list02 boxMdl">
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>" />
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>" />
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N" />
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><strong class="txtSaleRed">[+ Sale 상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><strong class="txtSaleRed">[마일리지샵상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><strong class="txtSaleRed">[무료배송상품]</strong><% end if %>
									<% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><strong class="txtBtwDk">[선착순구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><strong>[주문제작상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %>원
							 + 배송비 <%= FormatNumber(oshoppingbag.getUpcheParticleItemBeasongPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %>원
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheParticleItemPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid)+oshoppingbag.getUpcheParticleItemBeasongPrice(oshoppingbag.FParticleBeasongUpcheList(j).FMakerid),0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<%
				next
			end if
			%>
			<!-- 업체 착불배송 START -->
			<% if (oshoppingbag.IsReceivePayItemInclude)  then %>
				<fieldset>
					<div class="hWrap hrBtw">
						<h2 class="headingB">업체 착불 배송상품</h2>
					</div>

					<div class="shoppingCart addSelection">
					<%
						eachCnt = 0 ''//배송별 수량카운트
						eachTCnt = 0	''//배송별 총상품 개수
						for i=0 to oshoppingbag.FShoppingBagItemCount -1
							if ( oshoppingbag.FItemList(i).IsReceivePayItem) then
					%>
						<div class="cart pdtList list02 boxMdl">
							<input type="hidden" name="itemkey" value="<%=oshoppingbag.FItemList(i).FItemID %>_<%=oshoppingbag.FItemList(i).FItemOption %>" />
							<input type="hidden" name="itemid" value="<%= oshoppingbag.FItemList(i).FItemID %>" />
							<input type="hidden" name="itemoption" value="<%= oshoppingbag.FItemList(i).FItemoption %>" />
							<input type="hidden" name="soldoutflag" value="<% if oshoppingbag.FItemList(i).IsSoldOut then response.write "Y" else response.write "N" end if %>" />
							<input type="hidden" name="maxnoflag" value="<%= oshoppingbag.FItemList(i).GetLimitOrderNo %>" />
							<input type="hidden" name="minnoflag" value="<%= oshoppingbag.FItemList(i).GetMinumOrderNo %>">
							<input type="hidden" name="foreignflag" value="N" />
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

							<input type="checkbox" class="form checker" name="chk_item" id="1" value="<%= idx %>" title="주문상품 선택" />
							<div>
								<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%=oshoppingbag.FItemList(i).FItemID%>">
									<p class="pdtPic"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" alt="<%= Replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" /></p>
									<p class="pdtName"><%= oshoppingbag.FItemList(i).FItemName %></p>
									<p class="pdtEtc">
									<% if oshoppingbag.FItemList(i).IsPLusSaleItem then %><strong class="txtSaleRed">[+ Sale 상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).IsMileShopSangpum then %><strong class="txtSaleRed">[마일리지샵상품]</strong><% end if %>
									<% if oshoppingbag.FItemList(i).Is09Sangpum then %><strong class="txtSaleRed">[단독구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsFreeBeasongItem) then %>
										<% if (oshoppingbag.FItemList(i).FMakerid<>"goodovening") then %><strong class="txtSaleRed">[무료배송상품]</strong><% end if %>
									<% end if %>
									<% if (IsPercentBonusCouponExists and (oshoppingbag.FItemList(i).IsUnDiscountedMarginItem and Not oshoppingbag.FItemList(i).IsMileShopSangpum )) then %><strong>[%보너스쿠폰제외상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsBuyOrderItem) then %><strong class="txtBtwDk">[선착순구매상품]</strong><% end if %>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %><strong>[주문제작상품]</strong><% end if %>
									</p>
									<p class="pdtOption"><%= oshoppingbag.FItemList(i).getOptionNameFormat %></p>
									<% if (oshoppingbag.FItemList(i).IsManufactureSangpum) then %>
									<p class="pdtWord">문구 :
										<%
											if (oshoppingbag.FItemList(i).IsManufactureSangpum) and (oshoppingbag.FItemList(i).getRequireDetail="") then
												Response.Write "(! 주문제작문구를 넣어주세요.)"
												NotWriteRequireDetailExists = True
											else
												Response.Write oshoppingbag.FItemList(i).getRequireDetailHtml
											end if
										%>
                                        <!--<input type="button" class="btn" value="내용수정" onClick="TnEditItemRequire(<%= oshoppingbag.FItemList(i).FItemid %>,'<%= oshoppingbag.FItemList(i).FItemoption %>');">-->
									</p>
									<% end if %>
								</a>
							</div>

							<ul class="priceCount">
								<li>
									<span>판매가</span>
									<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
									<span><em class="txtSaleRed">[<%=oshoppingbag.FItemList(i).getSalePro%>] <%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% else %>
									<span><em><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원</em></span>
									<% end if %>
								</li>
								<li>
									<span>수량</span>
									<span>
										<input type="text" name="itemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>" pattern="[0-9]*" title="수량 입력" />
										<button type="button" class="btn02 btw" onClick="EditItem('<%= idx %>');"><em>변경</em></button>
										<input type="hidden" name="chkolditemea" value="<%= oshoppingbag.FItemList(i).FItemEa %>">
									</span>
								</li>
								<% if oshoppingbag.FItemList(i).ISsoldOut or (TicketBookingExired) then %>
								<li><span class="soldout"><strong class="txtSaleRed">상품이 품절되었습니다.</strong></span></li>
								<% else %>
								<li>
									<span><strong>소계금액</strong></span>
									<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.FItemList(i).GetRealPrice*oshoppingbag.FItemList(i).FItemEa,0) %> 원</strong></span>
								</li>
								<% end if %>
							</ul>
							<button type="button" class="btnDel" onClick="DelItem('<%= idx %>');"><span>삭제</span></button>
						</div>
					<%
							idx = idx +1
							eachCnt = eachCnt + 1
							eachTCnt = eachTCnt + oshoppingbag.FItemList(i).FItemEa
							end if
						next
					%>
						<div class="total">
							<em>[총 <%=eachCnt %>종/<%=eachTCnt%>개] 상품합계 <%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice+0,0) %>원
							 + 배송비 착불 부과
							 = <strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.GetCouponNotAssingUpcheReceivePayItemPrice,0) %>원</strong></em>
						</div>
					</div>
				</fieldset>
			<% end if %>
			<!-- 업체 착불배송 END -->

				<!-- 총 결제금액 -->
				<div class="hWrap hrBtw">
					<h2 class="headingB">총 결제금액 (<%= idx %>종 / <%= oshoppingbag.GetTotalItemEa %>개)</h2>
				</div>
				<div class="cart totalPrice">
					<ul class="priceCount">
						<li>
							<span>상품 총 금액</span>
							<span><em class="txtBlk"><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %> 원</em></span>
						</li>
						<li>
							<span>배송비</span>
							<span><em class="txtBlk"><%= FormatNumber(oshoppingbag.GetTotalBeasongPrice,0) %> 원</em></span>
						</li>
						<li>
							<span><strong>결제 예정 금액</strong></span>
							<span><strong class="txtBtwDk"><%= FormatNumber(oshoppingbag.getTotalPrice("0000")-oshoppingbag.GetMileageShopItemPrice,0) %> 원</strong></span>
						</li>
					</ul>
				</div>
				<!-- //총 결제금액 -->

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
					elseif oshoppingbag.IsTicketSangpumExists and (not getIsTenLogin) then
						iErrMsg = "죄송합니다. 티켓 상품은 회원 구매만 가능합니다."
					elseif (iTicketItemCNT>1) then
					    iErrMsg = "티켓 상품은 한번에 한 상품씩 구매 가능합니다."
					elseif oshoppingbag.IsPresentSangpumExists and (not getIsTenLogin) then
						iErrMsg = "죄송합니다. Present상품은 회원 구매만 가능합니다."
					elseif (iPresentItemCNT>1) then
						iErrMsg = "Present상품은 한번에 한 상품씩 구매 가능합니다."
					end if
				%>
				<div class="floatingBar boxMdl cartIn cartOrder">
					<div class="btnWrap">
						<div class="btn01 btnDel"><a href="" onClick="delSelected();return false;" class="cnclGry">선택상품 삭제</a></div>
						<div class="btn01 btnOrderSelect"><a href="" onClick="PayNextSelected(1);return false;" class="wht">선택상품 주문</a></div>
						<div class="btn01 btnOrderAll"><a href="" onClick="PayNext(baguniFrm,1,'<%= iErrMsg %>');return false;" class="edwPk">전체상품 주문</a></div>
					</div>
				</div>
			</form>
		<% End if %>

			<form name="reloadFrm" method="post" action="/apps/appCom/between/inipay/shoppingbag_process.asp" onsubmit="return false;">
			<input type="hidden" name="mode" value="">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="itemid" value="">
			<input type="hidden" name="itemoption" value="">
			<input type="hidden" name="itemea" value="">
			</form>

			<form name="NextFrm" method="post" action="<%= Replace(wwwUrl,"http:","http:") %>/apps/appCom/between/inipay/userinfo.asp">
			<input type="hidden" name="sitename" value="10x10">
			<input type="hidden" name="jumundiv" value="1">
			<input type="hidden" name="subtotalprice" value="<%= oshoppingbag.getTotalPrice("0000") %>">
			<input type="hidden" name="itemsubtotal" value="<%= oshoppingbag.GetTotalItemOrgPrice %>">
			<input type="hidden" name="mileshopitemprice" value="<%= oshoppingbag.GetMileageShopItemPrice %>">
			</form>

			<form name="frmConfirm" method="post" action="/apps/appCom/between/inipay/shoppingbag_process.asp">
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
				response.write "<script> ChkErrMsg = '지정일 배송상품(꽃배달)과 일반택배 상품은 같이 배송되지 않으니 양해하시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsTicketNnormalSangpumExists) then
				response.write "<script> ChkErrMsg = '티켓 단독구매상품과 일반상품은 같이 구매 할 수 없으니 따로 주문해 주시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsRsvSiteNnormalSangpumExists) then
				response.write "<script> ChkErrMsg = '현장수령상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다.';</script>"
			elseif (oshoppingbag.IsPresentNnormalSangpumExists) then
				response.write "<script> ChkErrMsg = 'Present상품과 일반상품은 같이 구매 할 수 없으니, 단독으로 주문해 주시기 바랍니다.';</script>"
			elseif oshoppingbag.Is09NnormalSangpumExists then
				response.write "<script> ChkErrMsg = '단독구매 및 예약판매 상품과 일반상품은 같이 구매하실 수 없습니다.\n\n단독구매 및 예약판매 상품은 별도로 장바구니에 담아주세요';</script>"
			elseif (oshoppingbag.GetMileshopItemCount>0) and (oshoppingbag.GetTenBeasongCount<1) then
				response.write "<script> ChkErrMsg = '마일리지샾 상품은 텐바이텐 배송상품과 함께 하셔야 배송 가능 합니다.';</script>"
			elseif (oshoppingbag.GetMileageShopItemPrice>availtotalMile) then
				response.write "<script> ChkErrMsg = '사용 가능한 마일리지는 " & availtotalMile & " 입니다. - 마일리지 상품 합계가 현재 마일리지보다 많습니다.';</script>"
			end if

			if (NotWriteRequireDetailExists) then
				response.write "<script> ChkErrMsg = '주문 제작 문구를 작성하지 않은 상품이 존재합니다. - 주문 제작문구를 작성해주세요.';</script>"
			end if

			if (NotEditPhotobookExists) then
				response.write "<script> ChkErrMsg = '편집이 안되 포토북 상품이 있습니다 - 포토북 상품은 윈도우의 일반PC웹에서 편집 후 구매해 주세요.';</script>"
			end if
			%>
			<script>
				$(function(){
					if (ChkErrMsg){
						alert(ChkErrMsg);
					}
				});
			</script>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
	set oShoppingBag = Nothing
	set oMileageShop = Nothing
	set oSailCoupon  = Nothing
	set oItemCoupon  = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
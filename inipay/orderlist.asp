<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->

<%	
Dim jumunDiv : jumunDiv = request("jk")
Dim IsForeignDlv : IsForeignDlv = (jumunDiv="2")        ''해외 배송 여부
Dim IsArmyDlv    : IsArmyDlv = (jumunDiv="3")              ''군부대 배송 여부


''20090603추가 KBCARD제휴
Dim IsKBRdSite : IsKBRdSite = (LCase(irdsite20)="kbcard")
''20090812추가 OKCashBAG
Dim IsOKCashBagRdSite : IsOKCashBagRdSite = (LCase(irdsite20)="okcashbag")
''IsOKCashBagRdSite = FALSE
''if (GetLoginUserID<>"icommang") then IsOKCashBagRdSite=FALSE

Dim kbcardsalemoney : kbcardsalemoney = 0

'' 사이트 구분
Const sitename = "10x10"
'' 할인권 사용 가능 여부
Const IsSailCouponDisabled = False
'' InVail 할인권 Display여부
Const IsShowInValidCoupon =TRUE

'' 상품쿠폰 기본체크 여부
Const IsDefaultItemCouponChecked =False
'' InVail 상품쿠폰 Display여부
Const IsShowInValidItemCoupon =False


'' 최소 마일리지 사용금액
Const mileageEabledTotal = 30000

'' 마일리지 사용가능여부
Dim IsMileageDisabled, MileageDisabledString
IsMileageDisabled = False

''주문제작 상품 문구 적지 않은 상품
dim NotWriteRequireDetailExists



dim userid, guestSessionID, i
userid = GetLoginUserID
guestSessionID = GetGuestSessionKey

dim oUserInfo
set oUserInfo = new CUserInfo
oUserInfo.FRectUserID = userid
if (userid<>"") then
    oUserInfo.GetUserData
end if

if (oUserInfo.FresultCount<1) then
    ''Default Setting
    set oUserInfo.FOneItem    = new CUserInfoItem
end if

dim oshoppingbag
set oshoppingbag = new CShoppingBag
oshoppingbag.FRectUserID = userid
oshoppingbag.FRectSessionID = guestSessionID
oShoppingBag.FRectSiteName  = sitename

oshoppingbag.GetShoppingBagDataDB_Checked

if (IsForeignDlv) then
    oshoppingbag.FcountryCode = "AA"
end if

''업체 개별 배송비 상품이 있는경우
if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
    oshoppingbag.GetParticleBeasongInfoDB_Checked
end if

dim goodname
goodname = oshoppingbag.getGoodsName
goodname = replace(goodname,"'","")

''KB카드 할인액 
if (IsKBRdSite) then
    oshoppingbag.FDiscountRate = 0.95
    kbcardsalemoney = oshoppingbag.GetAllAtDiscountPrice
end if

dim availtotalMile
dim oSailCoupon, oItemCoupon, oMileage

availtotalMile = 0

''실결제액.
dim subtotalprice
subtotalprice = oshoppingbag.GetTotalItemOrgPrice + oshoppingbag.GetOrgBeasongPrice -oshoppingbag.GetMileageShopItemPrice

%>

<div class="toolbar">
	<!-- #INCLUDE Virtual="/lib/inc_topMenu.asp" -->
</div>

<div id="home" selected="true">
	<!--네비게이션바-->
	<div id="history" selected="true"><a href="javascript:window.close();"><img src="http://fiximage.10x10.co.kr/m/common/btn_prev.png" width="82" height="30" class="btnprev"></a></div>
	<!--마이텐바이텐-->
	<div id="my2">
		<div id="my2Tit">
			<p> <img src="http://fiximage.10x10.co.kr/m/order/tit_orderlist.png" /> </p>
		</div>
		<!--주문한상품리스트-->
		<div id="vieworder">
			<div id="orderItem">
				<ul class="pdlist">
				<% for i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
					<li><a href="/category/category_itemPrd.asp?itemid=<%= oshoppingbag.FItemList(i).FItemID %>" title="_webapp"><img src="<%= oshoppingbag.FItemList(i).FImageList %>" width="90" height="90" class="pdimg">
					<div class="pdinfo">
						<div>[<%= oshoppingbag.FItemList(i).FMakerID %>]</div>
						<div class="pdinfoName"><%= oshoppingbag.FItemList(i).FItemName %></div>
                        <% if oshoppingbag.FItemList(i).IsMileShopSangpum then %>
    						<p><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> Pt</p>
    					<% else %>
    						<% if (oshoppingbag.FItemList(i).IsSailItem) then %>
    							<%= FormatNumber(oshoppingbag.FItemList(i).FOrgPrice,0) %> 원<br>
    							<p><span class="pdPrice"><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %>원[<%=oshoppingbag.FItemList(i).getSalePro%>]
    								<% If oshoppingbag.FItemList(i).FItemEa <> 1 Then Response.Write " X " & oshoppingbag.FItemList(i).FItemEa & "개 = " & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) End If %>
    								</span>
    							</p>
    						<% else %>
    							<p><%= FormatNumber(oshoppingbag.FItemList(i).getRealPrice,0) %> 원
    								<% If oshoppingbag.FItemList(i).FItemEa <> 1 Then Response.Write " X " & oshoppingbag.FItemList(i).FItemEa & "개 = " & FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) End If %>
    							</p>
    						<% end if %>
    					<% end if %>

					</div>
					<div style="clear:both;"></div>
					</a></li>
				<% next %>
				</ul>
			</div>
		</div>
		<div id="finalprice">
			<h1>총 주문금액</h1>
			<ul>
				<li>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr align="right">
						<td>주문상품수</td>
						<td width="100"><strong><%= i %>종 (<%= oshoppingbag.GetTotalItemEa %>개)</strong></td>
					</tr>
					<% if Not(oshoppingbag.IsPresentSangpumExists) then %>
					<tr align="right">
						<td>적립 마일리지</td>
						<td><strong><%= FormatNumber(oshoppingbag.getTotalGainmileage,0) %> Point</strong></td>
					</tr>
					<% end if %>
					<tr align="right">
					<% if (IsForeignDlv) then %>
						<td>총예상 상품중량</td>
						<td><strong><%= formatNumber(oshoppingbag.getEmsTotalWeight,0) %></strong>g</td>
					<% else %>
						<td>총배송비</td>
						<td><strong><%= FormatNumber(oshoppingbag.GetOrgBeasongPrice,0) %> 원</strong></td>
					<% end if %>
					</tr>
					<tr align="right">
						<td>상품 총금액</td>
						<td><strong><%= FormatNumber(oshoppingbag.GetTotalItemOrgPrice-oshoppingbag.GetMileageShopItemPrice,0) %> 원</strong></td>
					</tr>
					</table>
				</li>
				<li class="finaltotal"><% if oshoppingbag.GetMileageShopItemPrice<>0 then %>마일리지샵 금액 <%= FormatNumber(oshoppingbag.GetMileageShopItemPrice,0) %> Point<br><% end if %>총 합계 금액 <%= FormatNumber(subtotalprice,0) %> 원</li>
			</ul>
		</div>
	</div>
  
  <!-- #INCLUDE Virtual="/lib/inc_bottomMenu.asp" -->
<%
set oUserInfo   = nothing
set oshoppingbag= nothing
%>
<!--푸터영역-->
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->

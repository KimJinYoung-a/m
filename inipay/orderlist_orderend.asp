<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'' 사이트 구분
Const sitename = "10x10"

Dim ArrOrderitemid, ArrOrderPrice, ArrOrderEa ''logger Tracking

dim userid,guestSessionID, userlevel, i
dim orderserial, IsSuccess

orderserial = requestCheckVar(request("orderserial"),11)
userid = GetLoginUserID
IsSuccess   = request.cookies("shoppingbag")("before_issuccess")

dim oorderDetail
set oorderDetail = new CMyOrder
oorderDetail.FRectOrderserial = orderserial
oorderDetail.GetOrderDetail

''구매금액별 선택 사은품
Dim oOpenGift
Set oOpenGift = new CopenGift
oOpenGift.FRectOrderserial = orderserial

if (IsSuccess) and (userid<>"") then
    oOpenGift.getOpenGiftInOrder
end if
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
				<% for i=0 to oorderDetail.FResultCount - 1 %>
                <%
                ArrOrderitemid = ArrOrderitemid & oorderDetail.FItemList(i).FItemID & ";"
                ArrOrderPrice  = ArrOrderPrice & oorderDetail.FItemList(i).FItemCost & ";"
                ArrOrderEa     = ArrOrderEa & oorderDetail.FItemList(i).FItemNo & ";"
                
                %>
					<li><a href="/category/category_itemPrd.asp?itemid=<%= oorderDetail.FItemList(i).FItemID %>" title="_webapp"><img src="<%= oorderDetail.FItemList(i).FImageList %>" width="90" height="90" class="pdimg">
						<div class="pdinfo">
							<div class="pdinfoName">[<%= oorderDetail.FItemList(i).FItemID %>]<%= oorderDetail.FItemList(i).FItemName %>
		                        <% if oorderDetail.FItemList(i).FItemOptionName<>"" then %>
		                        (<%= oorderDetail.FItemList(i).FItemOptionName %>)
		                        <% end if %>
							</div>
							<p class="orderdate">마일리지 : <%= oorderDetail.FItemList(i).FMileage %> Point<br>
							판매가 : <%= FormatNumber(oorderDetail.FItemList(i).FItemCost,0) %> <%= CHKIIF(oorderDetail.FItemList(i).IsMileShopSangpum,"Pt","원") %><br>
							수량 : <%= oorderDetail.FItemList(i).FItemNo %><br>
							소계금액 : <strong><%= FormatNumber(oorderDetail.FItemList(i).FItemCost*oorderDetail.FItemList(i).FItemNo,0) %> <%= CHKIIF(oorderDetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></strong></p>
							<p class="tm5"><%= oorderDetail.FItemList(i).getDeliveryTypeName %></p>
						</div>
						<div style="clear:both;"></div>
						</a>
					</li>
				<% next %>
				</ul>
			</div>
		</div>
		<% if (oOpenGift.FREsultCount>0) then %>
		<div id="orderlist" style="padding:0 10px;">
			<h1>사은품 선택</h1>
			<ul>
			<% for i=0 to oOpenGift.FREsultCount-1 %>
				<li class="orderOption3">
					<%= oOpenGift.FItemList(i).Fevt_name %> - 
					<%= oOpenGift.FItemList(i).Fchg_giftStr %>
				</li>
			<% next %>
			</ul>
		</div>
		<% end if %>
	</div>
  
  <!-- #INCLUDE Virtual="/lib/inc_bottomMenu.asp" -->
<%
set oorderDetail   = nothing
Set oOpenGift = Nothing
%>
<!--푸터영역-->
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->

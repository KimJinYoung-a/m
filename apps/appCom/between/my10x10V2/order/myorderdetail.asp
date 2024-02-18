<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  비트윈 주문/배송조회
' History : 2014.04.23 한용민 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->

<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<%
Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가

dim i, j, usersn, orderserial, etype, pflag, cflag
	orderserial  = requestCheckVar(request("idx"),11)
	etype        = requestCheckVar(request("etype"),10)
	pflag        = requestCheckVar(request("pflag"),10)
	cflag        = requestCheckVar(request("cflag"),10)

	if (orderserial = "") then
		orderserial = requestCheckVar(request("orderserial"), 11)
	end if

usersn=fnGetUserInfo("tenSn")

dim myorder
set myorder = new CMyOrder
	myorder.FRectOldjumun = CHKIIF(pflag="P","on","")
    myorder.FRectUserID = usersn
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder

dim myorderdetail
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectOldjumun = CHKIIF(pflag="P","on","")
	
	if myorder.FResultCount>0 then
	    myorderdetail.GetOrderDetail
	    IsValidOrder = True
	
	    IsTicketOrder = myorder.FOneItem.IsTicketOrder
	    pflag=CHKIIF(myorder.FOneItem.fcancelyn<>"N","C","")
	end if

if (Not myorder.FOneItem.IsValidOrder) then
    IsValidOrder = False

    if (orderserial<>"") then
        response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
    end if
end if

%>

</head>
<body>
<% ' for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) %>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- #include virtual="/apps/appCom/between/my10x10V2/order/inc_myorderdetail_tab.asp" -->
			
			<% if (IsValidOrder) or (pflag="C") then %>
				<div class="shoppingCart">
					<div class="cart pdtList list02 boxMdl">
						<div>
						<a href="">
							<p class="pdtPic"><img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="상품명" /></p>
							<p class="pdtName"><%= myorderdetail.FItemList(i).FItemName %></p>
											
							<% if myorderdetail.FItemList(i).FItemoptionName <> "" then %>
								<p class="pdtOption"><%= myorderdetail.FItemList(i).FItemoptionName %></p>
							<% end if %>
				
							<!--<p class="pdtWord">문구 : 문구문구문구</p>-->
						</a>
					</div>

					<ul class="priceCount">
						<li>
							<span>판매가</span>
							<span>
								<% if (myorderdetail.FItemList(i).IsSaleItem) then %>
									<del class="txtBtwDk"><%= FormatNumber(myorderdetail.FItemList(i).Forgitemcost,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></del>
									<em class="txtSaleRed"><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></em>
								<% else %>
									<% if (myorderdetail.FItemList(i).IsItemCouponAssignedItem) then %>
										<del class="txtBtwDk"><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></del>
									<% else %>
										<%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
									<% end if %>
								<% end if %>
								
								<% if (myorderdetail.FItemList(i).IsItemCouponAssignedItem) then %>
									<em class="txtCpGreen"><%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %> 원</em>
								<% else %>
								
								<% end if %>
								
								<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
									<em class="txtSaleRed"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></em>
								<% end if %>							
							</span>
						</li>
						<li>
							<span>소계금액 <strong class="txtTopGry">(<%= myorderdetail.FItemList(i).FItemNo %>개)</strong></span>
							<span>
								<%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
								<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
									<strong class="txtCpGreen"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %> <%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %> 
									<em class="txtCpGreen">[보너스쿠폰 적용]</em></strong>	
								<% end if %>
							</span>
						</li>
						<li>
							<span>주문상태</span>
							<span><strong class="txtSaleRed"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></strong></span>
						</li>
						<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
						<li>
							<span>택배정보</span>
							<span><em class="txtTopGry"><%= myorderdetail.FItemList(i).GetDeliveryName %> | <%= myorderdetail.FItemList(i).GetSongjangURL %></em></span>
						</li>
						<% end if %>
						</ul>
					</div>
				</div>

				<!-- 결제금액 -->
				<div class="hWrap hrBtw">
					<h2 class="headingB">결제 금액 <em>(<%= i %>종/<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0) %>개)</em></h2>
				</div>
				<div class="section">
					<table class="tableType tableTypeB">
					<caption>결제금액 정보</caption>
					<tbody>
					<tr>
						<th scope="row">상품 총 금액</th>
						<td>
							<%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice,0) %> 원
						</td>
					</tr>
					<tr>
						<th scope="row">배송비</th>
						<td>
							<%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %> 원 <!-- 배송비 쿠폰 적용전 -->
							<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
								- 배송비쿠폰할인 <%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %> 원
							<% end if %>
						</td>
					</tr>
					
				<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
					<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
						<tr class="hr">
							<th scope="row">보너스쿠폰 사용</th>
							<td>
								<em class="txtCpGreen">-<%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %> 원</em>
							</td>
						</tr>
					<% end if %>
					<!--<tr>
						<th scope="row">상품쿠폰 사용</th>
						<td><em class="txtCpGreen">- 17,400 원</em></td>
					</tr>-->
					
					<% IF (myorder.FOneItem.Fmiletotalprice<>0) then %>
						<tr>
							<th scope="row">마일리지 사용</th>
							<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %> P</em></td>
						</tr>
					<% end if %>
					
					<% if (myorder.FOneItem.Fspendtencash<>0)  then %>
						<tr>
							<th scope="row">예치금 사용</th>
							<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fspendtencash,0) %> 원</em></td>
						</tr>
					<% end if %>
					
					<% if (myorder.FOneItem.Fspendgiftmoney<>0)  then %>
						<tr>
							<th scope="row">Gift카드 사용</th>
							<td><em class="txtSaleRed">-<%= FormatNumber(myorder.FOneItem.Fspendgiftmoney,0) %> 원</em></td>
						</tr>
					<% end if %>

					<% if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then %>
						<tr>
							<th scope="row">기타할인</th>
							<td><em class="txtSaleRed">-<%= FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) %> 원</em></td>
						</tr>
					<% end if %>
				<% end if %>

					<tr class="sum">
						<th scope="row"><strong class="txtBlk">최종결제액</strong></th>
						<td>
							<div>
								<strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %> 원</strong>
								
								<% if myorder.FOneItem.FTotalSum-myorder.FOneItem.FsubtotalPrice > 0 then %>
									<p class="txtBlk">
										(총 <%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FsubtotalPrice,0 )%>원 할인되었습니다.)
									</p>
								<% end if %>
							</div>
						</td>
					</tr>
					</tbody>
					</table>
				</div>
				<!-- //결제금액 -->

				<div class="btnArea">
					<% if (myorder.FOneItem.IsWebOrderCancelEnable) then %>
						<span class="btn02 btw btnBig full"><a href="/apps/appCom/between/my10x10V2/order/myorderallcancel.asp?idx=<%=orderserial%>">주문취소 신청</a></span>
					<% end if %>

					<span class="btn02 cnclGry btnBig full"><a href="/apps/appCom/between/my10x10V2/order/myorderlist.asp">목록으로 돌아가기</a></span>
				</div>
			<% end if %>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
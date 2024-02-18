<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 주문배송조회 상세
' History : 2015.06.04 한용민 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "주문상세조회"

Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsBiSearch   : IsBiSearch   = False   '''비회원 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가
Dim isEvtGiftDisplay : isEvtGiftDisplay = TRUE		''사은품 표시 여부

dim i, j, userid, orderserial, etype, vTmp, pflag, cflag, tensongjangdiv, itemtotal
userid       = getEncLoginUserID()

orderserial  = requestCheckVar(request("idx"),16)
etype        = requestCheckVar(request("etype"),10)
pflag        = requestCheckVar(request("pflag"),10)
cflag        = requestCheckVar(request("cflag"),10)
vTmp		 = 0
itemtotal=0
dim myorder
set myorder = new CMyOrder
	myorder.FRectOldjumun = pflag

	if IsUserLoginOK() then
	    myorder.FRectUserID = userid
	    myorder.FRectOrderserial = orderserial
	    myorder.GetShopOneOrder
	end if

dim myorderdetail, vIsCancel
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectOldjumun = pflag

	if myorder.FResultCount>0 Then
		myorderdetail.FRectUserID = userid
	    myorderdetail.GetShopOrderDetail
	    IsValidOrder = True

	    IsTicketOrder = myorder.FOneItem.IsTicketOrder
	end if

	if (Not myorder.FOneItem.IsValidOrder) then
	    IsValidOrder = False

	    if (orderserial<>"") then
	    	vIsCancel = "o"
	    	'### <!doctype html> 위에 나오면 소스깨짐
	        'response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
	    end if
	end if

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function() {
	$(".nav li a").click(function() {
		$(".nav li a").removeClass("on");
		$(this).addClass("on");
	});

});

</script>
</head>
<body class="default-font body-sub body-1depth">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="myOrderView">
			<div class="myTenNoti">
				<h2 class="hide">주문상세조회</h2>
				<p class="orderSummary box5"><%= FormatDate(myorder.FOneItem.Fshopregdate,"0000.00.00") %><em class="cBk1">l</em>주문번호 <b><%= orderserial %></b></p>
			</div>

			<!-- 주문상품 -->
			<div class="inner10" style="border-top:1.02rem solid #f4f4f4;">
				<div class="cartGroup">
					<div class="groupCont">
						<ul>
							<% For i=0 To myorderdetail.FResultCount-1 %>
							<li>
								<div class="box3">
									<div class="pdtWrap">
										<div class="pPhoto"><img src="<%= myorderdetail.FItemList(i).FListImage %>" alt="<%= myorderdetail.FItemList(i).FItemName %>" onerror="this.src='http://fiximage.10x10.co.kr/web2017/my10x10/bnr_offline.png'" /></div>
										<div class="pdtCont">
											<p class="pBrand">[<%= myorderdetail.FItemList(i).FBrandName %>]</p>
											<p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
											<p class="pOption"><%= myorderdetail.FItemList(i).FItemOptionName %></p>
										</div>
									</div>
									<div class="pdtInfo">
										<dl class="pPrice">
											<dt>판매가</dt>
											<dd>
												<span><%= FormatNumber(myorderdetail.FItemList(i).FSellPrice,0) %>원</span>
												<!-- <span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).FRealSellPrice,0) %>원</span> -->
											</dd>
										</dl>
										<dl class="pPrice">
											<dt>소계금액(1개)</dt>
											<dd>
												<span><%= FormatNumber(myorderdetail.FItemList(i).FSellPrice*myorderdetail.FItemList(i).FItemNo,0) %>원</span>
												<!-- <span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).FRealSellPrice*myorderdetail.FItemList(i).FItemNo,0) %>원</span> -->
											</dd>
										</dl>
									</div>
								</div>
							</li>
							<% itemtotal = itemtotal + myorderdetail.FItemList(i).FItemNo %>
							<% Next %>
						</ul>
					</div>
				</div>
				<h3 class="tit02 tMar3r"><span>총결제금액</span></h3>
				<div class="groupTotal box3 tMar12">
					<dl class="pPrice">
						<dt>주문상품수</dt>
						<dd><%=i%>종 (<%=itemtotal%>개)</dd>
					</dl>
					<dl class="pPrice">
						<dt>적립 매장 마일리지</dt>
						<dd><%=FormatNumber(myorder.FOneItem.Fgainmile,0)%> Point</dd>
					</dl>
					<dl class="pPrice">
						<dt>상품 총금액</dt>
						<dd><%=FormatNumber(myorder.FOneItem.FTotalSum,0)%>원</dd>
					</dl>
					<dl class="pPrice tMar05">
						<dt>총 합계금액</dt>
						<dd><strong class="cRd1"><%=FormatNumber(myorder.FOneItem.Frealsum,0)%>원</strong></dd>
					</dl>
				</div>
				<!--// 주문상품 -->
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
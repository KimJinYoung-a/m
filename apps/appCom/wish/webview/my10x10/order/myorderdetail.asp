<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "utf-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
dim i, j
dim userid, orderserial, etype, vTmp
dim pflag, aflag
dim tensongjangdiv

userid       = GetLoginUserID()
orderserial  = request("idx")
etype        = request("etype")
pflag 		= requestCheckvar(request("pflag"),10)
aflag 		= requestCheckvar(request("aflag"),2)
vTmp		 = 0

Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가


dim myorder
set myorder = new CMyOrder
myorder.FRectOldjumun = pflag

if IsUserLoginOK() then
    myorder.FRectUserID = GetLoginUserID()
    myorder.FRectOrderserial = orderserial
    myorder.GetOneOrder
elseif IsGuestLoginOK() then
    myorder.FRectOrderserial = GetGuestLoginOrderserial()
    myorder.GetOneOrder
end if


dim myorderdetail
set myorderdetail = new CMyOrder
myorderdetail.FRectOrderserial = orderserial
myorderdetail.FRectOldjumun = pflag

if myorder.FResultCount>0 then
    myorderdetail.GetOrderDetail

    IsTicketOrder = myorder.FOneItem.IsTicketOrder
end if

if Not myorder.FOneItem.IsValidOrder then
    'response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
end if

'// 티켓상품정보 접수
if myorder.FOneItem.IsTicketOrder then
	IF myorderdetail.FResultCount>0 then
    	Dim oticketItem, TicketDlvType, ticketPlaceName, ticketPlaceIdx

		Set oticketItem = new CTicketItem
		oticketItem.FRectItemID = myorderdetail.FItemList(0).FItemID
		oticketItem.GetOneTicketItem
		TicketDlvType = oticketItem.FOneItem.FticketDlvType			'티켓수령방법
		ticketPlaceName = oticketItem.FOneItem.FticketPlaceName		'공연장소
		ticketPlaceIdx = oticketItem.FOneItem.FticketPlaceIdx		'약도일련번호
		Set oticketItem = Nothing
	end if
end if

strPageTitle = "생활감성채널, 텐바이텐 > 주문배송조회:상세내역"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
	function viewOrderDetailDiv(gb) {
		$("#myorderTab1").hide();
		$("#myorderTab2").hide();
		$("#myorderTab3").hide();
		$("#myorderTab4").hide();
		$("#myorderTab"+gb).show();

		for ( i = 1 ; i <=4 ; i ++ )
		{
			if ( i == gb ){
				$("#tab"+gb).addClass("active");
			}else{
				$("#tab"+i).removeClass("active");
			}
		}
	}
	function goLink(page,pflag,aflag){
	    location.href="myorderlist.asp?page=" + page + "&pflag=" + pflag + "&aflag=" + aflag;
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
		<% If  IsGuestLoginOK()  Then %>
		<!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="/apps/appcom/wish/webview/my10x10/order/myorderlist.asp" class="active">주문배송 조회</a>
                <a href="/apps/appcom/wish/webview/my10x10/qna/myqnalist.asp">1:1 상담</a>
            </div>
        </header><!-- #header -->
		<div class="well type-b">
            <ul class="txt-list">
                <li>최근 2개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
                <li>2개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다. </li>
            </ul>
        </div>
		<% End If %>
		
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="tabs type-c three">
                    <a href="javascript:goLink(1,'<%=pflag%>','');" class="<%=chkIIF(aflag="","active","")%>">일반주문</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','AB');" class="<%=chkIIF(aflag="AB","active","")%>">해외배송 주문조회</a>
                    <a href="javascript:goLink(1,'<%=pflag%>','XX');" class="<%=chkIIF(aflag="XX","active","")%>">취소 주문조회</a>
                    <div class="clear"></div>
                </div>
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">주문 상세내역</span></h1>
                </div>
            </div>
            <div class="inner">                
                <div class="bordered-box">
                    <div class="box-meta">
                        <span class="date"><%=formatdate(myorder.FOneItem.Fregdate,"0000.00.00")%></span>
                        <span class="box-title">주문번호(<%=orderserial%>)</span>
                    </div>                    
                </div>
                <div class="diff"></div>
                <div class="tabs type-c four">
                    <a href="javascript:viewOrderDetailDiv('1')" class="active" id="tab1">주문상품</a>
                    <a href="javascript:viewOrderDetailDiv('2')" class="" id="tab2" >구매자</a>
                    <a href="javascript:viewOrderDetailDiv('3')" class="" id="tab3" >결제</a>
                    <a href="javascript:viewOrderDetailDiv('4')" class="" id="tab4" ><%=chkIIF(Not(IsTicketOrder),"배송지","수령정보")%></a>
                </div>
                <div class="diff-10"></div>
				<!-- 주문상품 -->
				<div id="myorderTab1">
					<% for i=0 to myorderdetail.FResultCount-1 %>
					<div class="bordered-box">                   
						<div class="product-info gutter">
							<div class="product-img">
								<a href="/apps/appcom/wish/webview/category/category_itemprd.asp?itemid=<%=myorderdetail.FItemList(i).Fitemid%>"><img src="<%= myorderdetail.FItemList(i).FImageList %>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>"></a>
							</div>
							<div class="product-spec">
								<p class="product-brand">[<%= myorderdetail.FItemList(i).Fmakerid %>] </p>
								<p class="product-name"><%= myorderdetail.FItemList(i).FItemName %></p>
								<% If myorderdetail.FItemList(i).FItemoptionName <> "" Then %>
								<p class="product-option">옵션 : <%= myorderdetail.FItemList(i).FItemoptionName %></p>
								<% End If %>
							</div>
						</div>
						<hr class="week clear"></hr>
						<div class="product-meta-info gutter">
							<table class="plain">
								<tr>
									<th>판매가</th>
									<td class="t-r">
										<%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %>
											<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
											<font color="red"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %></font>
											<% end if %>
											<%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
									</td>
								</tr>
								<tr>
									<th>소계금액(<%= myorderdetail.FItemList(i).FItemNo %>개)</th>
									<td class="t-r">
										<%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>
										<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
										<font color="red"><img src='http://fiximage.10x10.co.kr/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > <%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %></font>
										<% end if %>
										<%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
									</td>
								</tr>
								<tr>
									<th>출고상태</th>
									<td class="t-r"><span class="red"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></span></td>
								</tr>
								<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
								<tr>
									<th>택배정보</th>
									<td class="t-r"><%= myorderdetail.FItemList(i).GetDeliveryName %> : <%= GetSongjangURL(myorderdetail.FItemList(i).Fcurrstate,myorderdetail.FItemList(i).FDeliveryURL,myorderdetail.FItemList(i).FSongjangNO) %></td>
								</tr>  
								<% elseif IsTicketOrder or myorder.FOneItem.IsReceiveSiteOrder then %>
								<tr>
									<th>택배정보</th>
									<td class="t-r">현장수령</td>
								</tr>  
								<% end if %>
							</table>
						</div>
					</div>
					<% next %>
					<div class="diff"></div>
					<div class="order-total-box">
						<h1>총결제금액</h1>
						<table class="filled">
							<tr>
								<th>주문상품수</th>
								<td><%= i %><span class="unit">종(<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0) %>개)</span></td>
							</tr>
							<tr>
								<th>적립마일리지</th>
								<td><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %><span class="unit">Point</span></td>
							</tr>
							<tr>
								<th>총 배송비</th>
								<td><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %><span class="unit">원</span></td>
							</tr>
							<tr>
								<th>상품 총금액</th>
								<td><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice,0) %><span class="unit">원</span></td>
							</tr>
							<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
							<tr>
								<th>배송비쿠폰할인</th>
								<td>-<%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %><span class="unit">원</span></td>
							</tr>
							<% end if %>
							<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
							<tr>
								<th>보너스쿠폰할인</th>
								<td>-<%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %><span class="unit">원</span></td>
							</tr>
							<% end if %>
							<tr>
								<th>총 합계금액</th>
								<td><strong><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %><span class="unit">원</span></strong></td>
							</tr>
							<% if (myorder.FOneItem.IsReceiveSiteOrder) then %>
								<div align="center">
									<img src="http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=21&data=<%=orderserial%>&height=60&barwidth=2">
								</div>
							<% end if %>
						</table>
					</div>
					<div class="diff"></div>
				</div>
				<!-- 주문상품 -->
				<!-- 구매자 -->
				<div id="myorderTab2" style="display:none">
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>주문하신분</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyName %></td>
						</tr>
						<tr>
							<th>이메일 주소</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyEmail %></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyPhone %></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td class="t-l"><%= myorder.FOneItem.FBuyhp %></td>
						</tr>
					</table>
					<div class="diff"></div>
				</div>
				<!-- 구매자 -->
				<!-- 결제 -->
				<div id="myorderTab3" style="display:none">
					<table class="filled">
						<colgroup>
							<col width="140"/>
							<col/>
						</colgroup>
						<tr>
							<th>결제방법</th>
							<td class="t-l"><%= myorder.FOneItem.GetAccountdivName %></td>
						</tr>
						<% if myorder.FOneItem.FAccountdiv = 7 then %>
						<tr>
							<th>입금하실 계좌</th>
							<td  class="t-l"><%= myorder.FOneItem.Faccountno %>&nbsp;&nbsp;(주)텐바이텐</td>
						</tr>
						<tr>
							<th>입금 예정자명</th>
							<td  class="t-l"><%= myorder.FOneItem.Faccountname %></td>
						</tr>
						<% end if %>
						<tr>
							<th>결제확인일시</th>
							<td class="t-l"><%= myorder.FOneItem.FIpkumDate %></td>
						</tr>
						<tr>
							<th>마일리지 사용금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %><span class="unit">Point</span></td>
						</tr>
						<tr>
							<th>할인권 사용금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>기타 할인 금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>총 결제금액</th>
							<td class="t-l"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %><span class="unit">원</span></td>
						</tr>
						<tr>
							<th>마일리지 적립금액</th>
							<td class="t-l">
							<% if (myorder.FOneItem.FIpkumdiv>3) then %>
								<%= FormatNumber(myorder.FOneItem.FTotalMileage,0) %> <span class="unit">Point</span>
							<% else %>
								결제 후 적립 &nbsp;
							<% end if %>
							</td>
						</tr>
					</table>
					<div class="diff"></div>
				</div>
				<!-- 결제 -->
				<!-- 배송지 -->
				<div id="myorderTab4" style="display:none">
					 <% if (myorder.FOneItem.IsForeignDeliver) then %>
					 <table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>Country</th>
							<td class="t-l"><%= myorder.FOneItem.FDlvcountryName %></td>
						</tr>
						<tr>
							<th>수령인명(Name)</th>
							<td class="t-l"><%= myorder.FOneItem.FReqName %></td>
						</tr>
						<tr>
							<th>이메일(E-mail)</th>
							<td class="t-l"><%= myorder.FOneItem.FReqEmail %></td>
						</tr>
						<tr>
							<th>전화번호(Tel.No)</th>
							<td class="t-l"><%= myorder.FOneItem.FReqPhone %></td>
						</tr>
						<tr>
							<th>우편번호(Zipcode)</th>
							<td class="t-l"><%= myorder.FOneItem.FemsZipCode %></td>
						</tr>
						<tr>
							<th>도시 및 주 (City/State)</th>
							<td class="t-l"><%= myorder.FOneItem.Freqaddress %></td>
						</tr>
						<tr>
							<th>상세주소 (Address)</th>
							<td class="t-l"><%= myorder.FOneItem.Freqzipaddr %></td>
						</tr>
					</table>
					<% elseif myorder.FOneItem.IsReceiveSiteOrder or myorder.FOneItem.IsTicketOrder then %>
					<p class="cC40 ftMid lh12 inner">※ 본 상품은 현장수령 상품으로 공연 당일 현장 교부처에서 예매번호 및 본인 확인 후 티켓 수령 (현장수령 시 예약확인서 및 신분증 필수 지참)</p>
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>수령인명</th>
							<td class="t-l"><%= myorder.FOneItem.FReqName %></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td class="t-l"><%= myorder.FOneItem.FReqHp %></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td class="t-l"><%= myorder.FOneItem.FReqPhone %></td>
						</tr>
						<% if myorder.FOneItem.IsTicketOrder and TicketDlvType="9" then %>
						<tr>
							<th>주소</th>
							<td class="t-l"><%= myorder.FOneItem.Freqzipaddr %> <%= myorder.FOneItem.Freqaddress %></td>
						</tr>
						<tr>
							<th>배송 유의사항</th>
							<td class="t-l"><%= nl2Br(myorder.FOneItem.Fcomment) %></td>
						</tr>
						<% end if %>
					</table>
					<%
							if myorder.FOneItem.IsTicketOrder then
								IF myorderdetail.FResultCount>0 then
								Dim oticketSchedule

								Set oticketSchedule = new CTicketSchedule
								oticketSchedule.FRectItemID = myorderdetail.FItemList(0).FItemID
								oticketSchedule.FRectItemOption = myorderdetail.FItemList(0).FItemOption
								oticketSchedule.getOneTicketSchdule
					%>
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>공연명</th>
							<td class="t-l"><%= myorderdetail.FItemList(0).FItemName %></td>
						</tr>
						<tr>
							<th>공연일시</th>
							<td class="t-l"><%= oticketSchedule.FOneItem.getScheduleDateStr %></td>
						</tr>
						<tr>
							<th>티켓수량</th>
							<td class="t-l"><%= myorderdetail.FItemList(0).FItemNo %><span class="unit">매</span></td>
						</tr>
						<tr>
							<th>공연시간</th>
							<td class="t-l"><%= oticketSchedule.FOneItem.getScheduleDateTime %></td>
						</tr>
						<tr>
							<th>공연장소</th>
							<td class="t-l"><%= ticketPlaceName %></td>
						</tr>
						<tr>
							<th>약도</th>
							<td class="t-l"><a href="<%=webURL%>/my10x10/popTicketPLace.asp?placeIdx=<%= ticketPlaceIdx %>" target="_blank">약도보기</a></td>
						</tr>
					</table>
					<%
								Set oticketSchedule = Nothing
								end if
							end if
						else
					%>
					<table class="filled">
						<colgroup>
							<col width="120"/>
							<col/>
						</colgroup>
						<tr>
							<th>받으시는 분</th>
							<td class="t-l"><%= myorder.FOneItem.FReqName %></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td class="t-l"><%= myorder.FOneItem.FReqHp %></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td class="t-l"><%= myorder.FOneItem.FReqPhone %></td>
						</tr>
						<% if (Not myorder.FOneItem.IsReceiveSiteOrder) then %>
						<tr>
							<th>주소</th>
							<td class="t-l"><%= myorder.FOneItem.Freqzipaddr %> <%= myorder.FOneItem.Freqaddress %></td>
						</tr>
						<tr>
							<th>배송 유의사항</th>
							<td class="t-l"><%= nl2Br(myorder.FOneItem.Fcomment) %></td>
						</tr>
						<% end if %>
					</table>
					<% End If %>
					<div class="diff"></div>
				</div>
				<!-- 배송지 -->
            </div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
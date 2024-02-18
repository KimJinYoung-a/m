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
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
Dim IsValidOrder : IsValidOrder = False   '''정상 주문인가.
Dim IsBiSearch   : IsBiSearch   = False   '''비회원 주문인가.
Dim IsTicketOrder : IsTicketOrder = FALSE ''티켓주문인가

dim i, j, userid, orderserial, etype, vTmp, pflag, cflag, tensongjangdiv
userid       = getEncLoginUserID()
orderserial  = requestCheckVar(request("idx"),11)
etype        = requestCheckVar(request("etype"),10)
pflag        = requestCheckVar(request("pflag"),10)
cflag        = requestCheckVar(request("cflag"),10)
vTmp		 = 0

dim myorder
set myorder = new CMyOrder
	myorder.FRectOldjumun = pflag
	
	if IsUserLoginOK() then
	    myorder.FRectUserID = userid
	    myorder.FRectOrderserial = orderserial
	    myorder.GetOneOrder
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetOneOrder
	
	    IsBiSearch = True
	    orderserial = myorder.FRectOrderserial
	end if

dim myorderdetail
set myorderdetail = new CMyOrder
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.FRectOldjumun = pflag
	
	if myorder.FResultCount>0 then
	    myorderdetail.GetOrderDetail
	    IsValidOrder = True
	
	    IsTicketOrder = myorder.FOneItem.IsTicketOrder
	end if
	
	if (Not myorder.FOneItem.IsValidOrder) then
	    IsValidOrder = False
	
	    if (orderserial<>"") then
	        'response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
	    end if
	end if

Dim MyOrdActType : MyOrdActType = "E"
Dim IsWebEditEnabled
IsWebEditEnabled = (MyOrdActType = "E")

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
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

function viewOrderDetailDiv(gb) {
	$("#myorderTab1").hide();
	$("#myorderTab2").hide();
	$("#myorderTab3").hide();
	$("#myorderTab4").hide();
	$("#myorderTab"+gb).show();

	for ( i = 1 ; i <=4 ; i ++ ){
		if ( i == gb ){
			$("#tab"+gb).addClass("current");
		}else{
			$("#tab"+i).removeClass("current");
		}
	}
}

function popEditOrderInfo(orderserial,etype){
	fnAPPpopupBrowserURL('플라워 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype);
}

function popEditOrderInfoordr(orderserial,etype){
	fnAPPpopupBrowserURL('구매자 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype);
}

function popEditOrderInforecv(orderserial,etype){
	fnAPPpopupBrowserURL('배송지 정보변경','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditOrderInfo.asp?orderserial=' + orderserial + '&etype=' + etype);
}

$( document ).ready(function() {
	setTimeout("fnAPPchangPopCaption('주문상세조회')",200);
});

function popTicketPLace(ticketPlaceIdx){
	fnAPPpopupBrowserURL('약도','<%=webURL%>/my10x10/popTicketPLace.asp?placeIdx='+ticketPlaceIdx);
}

function popEditHandMadeReq(orderserial,idx){
	fnAPPpopupBrowserURL('문구 수정','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderPopup/popEditHandMadeReq.asp?orderserial=' + orderserial + '&idx=' + idx);
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="myOrderView inner10">
				<div class="myTenNoti">
					<h2 class="hide">주문상세조회</h2>
					<p class="orderSummary box5"><%=formatdate(myorder.FOneItem.Fregdate,"0000.00.00")%><em class="cBk1">l</em>주문번호(<%=orderserial%>)</p>
				</div>
				<div class="tab02">
					<ul class="tabNav">
						<li class="current" id="tab1"><a href="" onclick="viewOrderDetailDiv('1'); return false;">주문상품</a></li>
						<li id="tab2"><a href="" onclick="viewOrderDetailDiv('2'); return false;">구매자</a></li>
						<li id="tab3"><a href="" onclick="viewOrderDetailDiv('3'); return false;">결제정보</a></li>
						<li id="tab4"><a href="" onclick="viewOrderDetailDiv('4'); return false;">배송지</a></li>
					</ul>
				</div>

				<!-- 주문상품 -->
				<div id="myorderTab1">
					<div class="cartGroup">
						<div class="groupCont">
							<ul>
								<% for i=0 to myorderdetail.FResultCount-1 %>
								<li>
									<div class="box3">
										<div class="pdtWrap">
											<div class="pPhoto">
												<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%= myorderdetail.FItemList(i).Fitemid %>">
											<img src="<%=getThumbImgFromURL(myorderdetail.FItemList(i).FImageBasic,286,286,"true","false")%>" alt="<%= Replace(myorderdetail.FItemList(i).FItemName,"""","") %>" /></a>
											</div>
											<div class="pdtCont">
												<p class="pBrand">[<%= myorderdetail.FItemList(i).Fbrandname %>]</p>
												<p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
												
												<% if myorderdetail.FItemList(i).FItemoptionName<>"" then %>
													<p class="pOption">옵션 : <%= myorderdetail.FItemList(i).FItemoptionName %></p>
												<% end if %>
											</div>
										</div>
										
										<% if Not(IsNull(myorder.FOneItem.Freqdate)) and Not(myorder.FOneItem.IsReceiveSiteOrder) then %>
											<div class="addInfo">
												<div class="box4">
													<dl class="pPrice">
														<dt>보내시는 분</dt>
														<dd>
															<span><%= myorder.FOneItem.Ffromname %></span>
														</dd>
													</dl>
													<dl class="pPrice">
														<dt>희망배송일</dt>
														<dd>
															<span><%= myorder.FOneItem.Freqdate %>일 <%= myorder.FOneItem.GetReqTimeText %></span>
														</dd>
													</dl>
													<dl class="pPrice">
														<dt>메시지 선택</dt>
														<dd>
															<span><%= myorder.FOneItem.GetCardLibonText %></span>
														</dd>
													</dl>
													<dl class="pPrice msgCont">
														<dt><span>메시지 내용</span></dt>
														<dd>
															<%= myorder.FOneItem.Fmessage %>
														</dd>
													</dl>
												</div>
												<span class="button btM1 btRed cWh1 w100p tMar10">
													<a href="" onclick="popEditOrderInfo('<%= orderserial %>','flow'); return false;">플라워 정보 변경</a>
												</span>
											</div>
										<% end if %>

										<% 'if (myorder.FOneItem.IsRequireDetailItemExists(myorderdetail)) or (myorder.FOneItem.IsPhotoBookItemExists(myorderdetail)) then %>
										<% if (myorderdetail.FItemList(i).IsRequireDetailExistsItem) or (myorderdetail.FItemList(i).ISFujiPhotobookItem) then %>
											<div class="addInfo">
												<div class="box4">
													<dl class="pPrice msgCont">
														<% if myorderdetail.FItemList(i).ISFujiPhotobookItem then %>
															<dt><span>포토룩스 상품</span></dt>
														<% else %>
															<% if IsNULL(myorderdetail.FItemList(i).Frequiredetail) or (myorderdetail.FItemList(i).Frequiredetail="") then %>
																<dt><span>주문제작문구를 넣어주세요.</span></dt>
															<% else %>
																<dt><span>주문제작문구</span></dt>
																<dd><%= nl2Br(myorderdetail.FItemList(i).getRequireDetailHtml) %></dd>
															<% end if %>
														<% end if %>
													</dl>
												</div>
												
												<% IF IsValidOrder Then %>
													<% if not(myorderdetail.FItemList(i).ISFujiPhotobookItem) then %>
														<% if (myorderdetail.FItemList(i).IsRequireDetailExistsItem) and (myorderdetail.FItemList(i).IsEditAvailState) then %>
															<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditHandMadeReq('<%= orderserial %>','<%= myorderdetail.FItemList(i).Fidx %>'); return false;">문구 수정</a></span>
														<% else %>
															<span class="button btM1 btGry2 cWh1 w100p tMar10"><a href="" style="cursor:default;">문구 수정 불가</a></span>
														<% end if %>
													<% end if %>
												<% end if %>
											</div>
										<% end if %>

										<div class="pdtInfo">
											<dl class="pPrice">
												<dt>판매가</dt>
												<dd>
													<span><%= FormatNumber(myorderdetail.FItemList(i).getItemcostCouponNotApplied,0) %>원</span>
													
													<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
														<span class="cRd1 cpPrice">
															<%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %>
														</span>
													<% end if %>
												</dd>
											</dl>
											<dl class="pPrice">
												<dt>소계금액(<%= myorderdetail.FItemList(i).FItemNo %>개)</dt>
												<dd>
													<span><%= FormatNumber(myorderdetail.FItemList(i).FItemCost*myorderdetail.FItemList(i).FItemNo,0) %>원</span>
													
													<% if (myorderdetail.FItemList(i).IsSaleBonusCouponAssignedItem) then %>
														<span class="cRd1 cpPrice"><%= FormatNumber(myorderdetail.FItemList(i).getReducedPrice*myorderdetail.FItemList(i).FItemNo,0) %><%= CHKIIF(myorderdetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></span>
													<% end if %>
												</dd>
											</dl>
											<dl class="pPrice">
												<dt>출고상태</dt>
												<dd><span class="cBk1"><%= myorderdetail.FItemList(i).GetItemDeliverStateName(myorder.FOneItem.FIpkumDiv, myorder.FOneItem.FCancelyn) %></span></dd>
											</dl>

											<% if myorderdetail.FItemList(i).GetDeliveryName<>"" then %>
												<dl class="pPrice">
													<dt>택배정보</dt>
													<dd><%= myorderdetail.FItemList(i).GetDeliveryName %> : <%= myorderdetail.FItemList(i).GetSongjangURL %></dd>
												</dl>
											<% elseif IsTicketOrder or myorder.FOneItem.IsReceiveSiteOrder then %>
												<dl class="pPrice">
													<dt>택배정보</dt>
													<dd>현장수령</dd>
												</dl>
											<% end if %>
										</div>
									</div>
								</li>
								<% next %>

							</ul>
						</div>
					</div>
					<h3 class="tit02"><span>총결제금액</span></h3>
					<div class="groupTotal box3 tMar12">
						<dl class="pPrice">
							<dt>주문상품수</dt>								
							<dd><%= i %>종(<%= FormatNumber(myorder.FOneItem.GetTotalOrderItemCount(myorderdetail),0) %>개)</dd>
						</dl>
						<dl class="pPrice">
							<dt>적립 마일리지</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %> Point</dd>
						</dl>
						<dl class="pPrice tMar05">
							<dt>상품 총금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FTotalSum-myorder.FOneItem.FDeliverPrice,0) %>원</dd>
						</dl>
						<dl class="pPrice">
							<dt>총 배송비</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied,0) %> 원</dd>
						</dl>
						<% if (myorder.FOneItem.FDeliverpriceCouponNotApplied>myorder.FOneItem.FDeliverprice) then %>
							<dl class="pPrice">
								<dt>배송비쿠폰 할인</dt>
								<dd>- <%= FormatNumber(myorder.FOneItem.FDeliverpriceCouponNotApplied-myorder.FOneItem.FDeliverprice,0) %>원</dd>
							</dl>
						<% end if %>
						<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
							<dl class="pPrice">
								<dt>보너스쿠폰 할인</dt>
								<dd>- <%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %>원</dd>
							</dl>
						<% end if %>
						<% IF (myorder.FOneItem.Fmiletotalprice<>0) then %>
							<dl class="pPrice">
								<dt>마일리지 사용금액</dt>
								<dd>- <%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %>원</dd>
							</dl>
						<% end if %>
						<% if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then %>
							<dl class="pPrice">
								<dt>기타 할인금액</dt>
								<dd>- <%= FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) %>원</dd>
							</dl>
						<% end if %>

						<dl class="pPrice tMar05">
							<dt>총 합계금액</dt>
							<dd><strong class="cRd1"><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</strong></dd>
						</dl>
					</div>
					<% if (myorder.FOneItem.IsReceiveSiteOrder) then %>
						<div align="center">
							<img src="http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=21&data=<%=orderserial%>&height=60&barwidth=2">
						</div>
					<% end if %>
				</div>
				<!--// 주문상품 -->

				<!-- 구매자 -->
				<div id="myorderTab2" style="display:none">
					<div class="groupTotal box3 tMar15">
						<dl class="pPrice">
							<dt>주문하신분</dt>
							<dd><%= myorder.FOneItem.FBuyName %></dd>
						</dl>
						<dl class="pPrice">
							<dt>이메일 주소</dt>
							<dd><%= myorder.FOneItem.FBuyEmail %></dd>
						</dl>
						<dl class="pPrice">
							<dt>전화번호</dt>
							<dd><%= myorder.FOneItem.FBuyPhone %></dd>
						</dl>
						<dl class="pPrice">
							<dt>휴대폰번호</dt>
							<dd><%= myorder.FOneItem.FBuyhp %></dd>
						</dl>
					</div>
					
					<% IF IsValidOrder Then %>
						<% if (MyOrdActType = "E") then %>
							<% if (myorder.FOneItem.IsWebOrderInfoEditEnable) then %>
								<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditOrderInfoordr('<%= orderserial %>','ordr'); return false;">구매자 정보변경</a></span>
							<% end if %>
						<% end if %>
					<% end if %>
				</div>
				<!--// 구매자 -->

				<!-- 결제정보 -->
				<div id="myorderTab3" style="display:none" class="groupTotal box3 tMar15">
					<dl class="pPrice">
						<dt>결제방법</dt>
						<dd><%= myorder.FOneItem.GetAccountdivName %></dd>
					</dl>
					<dl class="pPrice">
						<dt>결제확인일시</dt>
						<dd><%= myorder.FOneItem.FIpkumDate %></dd>
					</dl>

					<% if (myorder.FOneItem.FAccountDiv="110") then %>
						<dl class="pPrice tMar05">
							<dt>OK캐시백 사용금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FokcashbagSpend,0) %>원</dd>
						</dl>
						<dl class="pPrice">
							<dt>신용카드 결제금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice-myorder.FOneItem.FokcashbagSpend,0) %>원</dd>
						</dl>
					<% else %>
						<% if myorder.FOneItem.FAccountdiv = 7 then %>
							<dl class="pPrice">
								<dt>입금하실 계좌</dt>
								<dd><%= myorder.FOneItem.Faccountno %> (주)텐바이텐</dd>
							</dl>
							<dl class="pPrice">
								<dt>입금 예정자명</dt>
								<dd><%= myorder.FOneItem.Faccountname %></dd>
							</dl>
						<% end if %>
					<% end if %>	

					<% if (myorder.FOneItem.Fspendtencash<>0)  then %>
						<dl class="pPrice">
							<dt>예치금 사용금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Fspendtencash,0) %>원</dd>
						</dl>
					<% end if %>
					<% if (myorder.FOneItem.Fspendgiftmoney<>0)  then %>
						<dl class="pPrice">
							<dt>GIFT카드 사용금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.Fspendgiftmoney,0) %>원</dd>
						</dl>
					<% end if %>

					<% if myorder.FOneItem.FIpkumdiv>3 then %>
						<dl class="pPrice">
							<dt>결제 금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
						</dl>
					<% else %>
						<dl class="pPrice tMar05">
							<dt>결제하실 금액</dt>
							<dd><%= FormatNumber(myorder.FOneItem.FsubtotalPrice,0) %>원</dd>
						</dl>
					<% end if %>
				</div>
				<!--// 결제정보 -->

				<!-- 배송지 -->
				<div id="myorderTab4" style="display:none">
					<div>
						<% if (myorder.FOneItem.IsForeignDeliver) then %>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>Contry</dt>
									<dd><%= myorder.FOneItem.FDlvcountryName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>수령인명(Name)</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %></dd>
								</dl>
								<dl class="pPrice">
									<dt>우편번호(Zip Code)</dt>
									<dd><%= myorder.FOneItem.FemsZipCode %></dd>
								</dl>
								<dl class="pPrice">
									<dt>도시/주(City/State)</dt>
									<dd><%= myorder.FOneItem.Freqaddress %></dd>
								</dl>
								<dl class="pPrice">
									<dt>상세주소(Address)</dt>
									<dd><%= myorder.FOneItem.Freqzipaddr %></dd>
								</dl>
								<dl class="pPrice">
									<dt>배송 유의사항</dt>
									<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
								</dl>
							</div>
						<% elseif myorder.FOneItem.IsReceiveSiteOrder or myorder.FOneItem.IsTicketOrder then %>
							<p class="tMar15 fs12 lh12">※ 본 상품은 현장수령 상품으로 공연 당일 현장 교부처에서 예매번호 및 본인 확인 후 티켓 수령 (현장수령 시 예약확인서 및 신분증 필수 지참)</p>
							<p class="tMar15 fs12"><strong>수령인 정보</strong></p>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>수령인명(Name)</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>휴대전화 번호</dt>
									<dd><%= myorder.FOneItem.FReqHp %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %><dd>
								</dl>
								
								<% if myorder.FOneItem.IsTicketOrder and TicketDlvType="9" then %>
									<dl class="pPrice">
										<dt>주소</dt>
										<dd><%= myorder.FOneItem.Freqzipaddr %> <%= myorder.FOneItem.Freqaddress %></dd>
									</dl>
									<dl class="pPrice">
										<dt>배송 유의사항</dt>
										<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
									</dl>
								<% end if %>
							</div>
	
							<%
							if myorder.FOneItem.IsTicketOrder then
								IF myorderdetail.FResultCount>0 then
								Dim oticketSchedule
	
								Set oticketSchedule = new CTicketSchedule
									oticketSchedule.FRectItemID = myorderdetail.FItemList(0).FItemID
									oticketSchedule.FRectItemOption = myorderdetail.FItemList(0).FItemOption
									oticketSchedule.getOneTicketSchdule
							%>
								<p class="tMar15 fs12"><strong>공연 정보</strong></p>
								<div class="groupTotal box3 tMar15">
									<dl class="pPrice">
										<dt>공연명</th>
										<dd><%= myorderdetail.FItemList(0).FItemName %></dd>
									</dl>
									<dl class="pPrice">
										<dt>공연일시</th>
										<dd><%= oticketSchedule.FOneItem.getScheduleDateStr %></dd>
									</dl>
									<dl class="pPrice">
										<dt>티켓수량</th>
										<dd><%= myorderdetail.FItemList(0).FItemNo %>매</dd>
									</dl>
									<dl class="pPrice">
										<dt>공연시간</th>
										<dd><%= oticketSchedule.FOneItem.getScheduleDateTime %></dd>
									</dl>
									<dl class="pPrice">
										<dt>공연장소</th>
										<dd><%= ticketPlaceName %></dd>
									</dl>
									<dl class="pPrice">
										<dt>약도</th>
										<dd><a href="" onclick="popTicketPLace('<%= ticketPlaceIdx %>'); return false;">약도보기</a></dd>
									</dl>
								</div>
							<%
								Set oticketSchedule = Nothing
								end if
							end if
							%>
						<% else %>
							<div class="groupTotal box3 tMar15">
								<dl class="pPrice">
									<dt>받으시는 분</dt>
									<dd><%= myorder.FOneItem.FReqName %></dd>
								</dl>
								<dl class="pPrice">
									<dt>휴대전화 번호</dt>
									<dd><%= myorder.FOneItem.FReqHp %></dd>
								</dl>
								<dl class="pPrice">
									<dt>전화번호(Tel. No)</dt>
									<dd><%= myorder.FOneItem.FReqPhone %><dd>
								</dl>
	
								<% if (Not myorder.FOneItem.IsReceiveSiteOrder) then %>
									<dl class="pPrice">
										<dt>주소</dt>
										<dd><%= myorder.FOneItem.Freqzipaddr %> <%= myorder.FOneItem.Freqaddress %></dd>
									</dl>
									<dl class="pPrice">
										<dt>배송 유의사항</dt>
										<dd><%= nl2Br(myorder.FOneItem.Fcomment) %></dd>
									</dl>
								<% end if %>
							</div>
						<% end if %>
					</div>
					
					<% IF IsValidOrder Then %>
						<span class="button btM1 btRed cWh1 w100p tMar10"><a href="" onclick="popEditOrderInforecv('<%= orderserial %>','recv'); return false;">배송지 정보변경</a></span>
					<% end if %>
				</div>
				<!--// 배송지 -->
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<%
set myorder = Nothing
set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
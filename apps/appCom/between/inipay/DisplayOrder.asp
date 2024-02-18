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
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<%
Const sitename = "10x10"
Dim ArrOrderitemid, ArrOrderPrice, ArrOrderEa ''logger Tracking
Dim userid, usersn
Dim orderserial, IsSuccess

userid		= fnGetUserInfo("tenId")
usersn		= fnGetUserInfo("tenSn")		'rduserid가 됨
orderserial = session("before_orderserial")
IsSuccess   = session("before_issuccess")

'' session is String
If LCase(CStr(IsSuccess))="true" then
	IsSuccess = true
Else
	IsSuccess = false
End If

'############################# 진영 test 데이터 ##############################
'orderserial = "14042961899"
'IsSuccess	= true
'#############################################################################

Dim oorderMaster
Set oorderMaster = new CMyOrder
	oorderMaster.FRectUserID = usersn
	oorderMaster.FRectOrderserial = orderserial
	oorderMaster.GetOneOrder

Dim oshoppingbag
set oshoppingbag = new CShoppingBag
	oshoppingbag.FRectUserSn	= "BTW_USN_" & usersn
	oShoppingBag.FRectSiteName	= sitename

Dim i
Dim CheckRequireDetailMsg
CheckRequireDetailMsg = False

''//주문리스트 확인------신규
Dim oorderDetail
Set oorderDetail = new CMyOrder
	oorderDetail.FRectOrderserial = orderserial
	oorderDetail.GetOrderDetail


'GA Ecommerce 데이터 생성 - incFooter 밑에 출력 ; 2014.05.02 허진원 추가
Dim gaCmcSCRIPT, r
if (IsSuccess) then
    if (oorderMaster.FResultCount>0) then
		gaCmcSCRIPT = "ga('require', 'ecommerce', 'ecommerce.js');"	 & vbCrLf

		'주문 정보
		gaCmcSCRIPT = gaCmcSCRIPT & "ga('ecommerce:addTransaction', {"
		gaCmcSCRIPT = gaCmcSCRIPT & "'id': '" & orderserial & "',"																	'주문 번호
		gaCmcSCRIPT = gaCmcSCRIPT & "'affiliation': '10x10',"																		'상점명(제휴명)
		gaCmcSCRIPT = gaCmcSCRIPT & "'revenue': '" & (oorderMaster.FOneItem.FTotalSum-oorderMaster.FOneItem.FDeliverPrice) & "',"	'배송제외 총액
		gaCmcSCRIPT = gaCmcSCRIPT & "'shipping': '" & oorderMaster.FOneItem.FDeliverPrice & "',"									'배송비
		gaCmcSCRIPT = gaCmcSCRIPT & "'currency': 'KRW' });"	 & vbCrLf																'통화구분

		'주문 상품정보
        If oorderDetail.FResultCount > 0 Then
        	For r = 0 to oorderDetail.FResultCount - 1
        		gaCmcSCRIPT = gaCmcSCRIPT & "ga('ecommerce:addItem',{"
        		gaCmcSCRIPT = gaCmcSCRIPT & "'id': '" & orderserial & "',"														'주문 번호
        		gaCmcSCRIPT = gaCmcSCRIPT & "'name': '" & replace(oorderDetail.FItemList(r).FItemName,"'","\'") & "',"			'상품명
        		gaCmcSCRIPT = gaCmcSCRIPT & "'sku': '" & oorderDetail.FItemList(r).FItemID & "',"								'상품코드
        		gaCmcSCRIPT = gaCmcSCRIPT & "'category': '" & replace(oorderDetail.FItemList(r).Fbrandname,"'","\'") & "',"	'카테고리 (비트윈 노출용으로 해야될듯 > 일단 브랜드명으로)
        		gaCmcSCRIPT = gaCmcSCRIPT & "'price': '" & oorderDetail.FItemList(r).FItemCost & "',"							'상품 판매가
        		gaCmcSCRIPT = gaCmcSCRIPT & "'quantity': '" & oorderDetail.FItemList(r).FItemNo & "'"							'주문 갯수
        		gaCmcSCRIPT = gaCmcSCRIPT & "});" & vbCrLf
        		gaCmcSCRIPT = gaCmcSCRIPT & "ga('ecommerce:send');" & vbCrLf
        	Next
        End If
	end if
end if
%>
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
$(function() {
	// 주문리스트 상세 보기 버튼 컨트롤
	$('.orderList .extendBtn').click(function(){
		$('.orderList .pdtList').toggleClass('extend');
		$(this).toggleClass('cut');
		if ($(this).hasClass('cut')) {
			$(this).html('주문리스트 상세 닫기');
		} else {
			$(this).html('주문리스트 상세 보기');
		};
	});
});
</script>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<div class="cont">
			<div class="hWrap hrBlk">
				<h1 class="headingA"><%= Chkiif(IsSuccess, "주문완료", "주문실패") %></h1>
				<% If getIsTenLogin() Then %>
				<div class="option">
					<span class="afterLogin"><strong><%= userid %></strong>님 <a href="" onclick="fnTenLogout();return false;">[텐바이텐 로그아웃]</a></span>
				</div>
				<% End If %>
			</div>
		<% If IsSuccess Then %>
			<div class="msgBox">
				<p>주문이 정상적으로 완료 되었습니다.<br /> 이용해 주셔서 감사합니다.</p>
				<p><strong class="txtBtwDk">주문번호 : <%= orderserial %></strong></p>
			</div>
			<div class="hWrap hrBtw">
				<h2 class="headingB">결제정보 확인</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeA">
				<caption>결제정보 확인</caption>
				<tbody>
				<tr>
					<th scope="row">결제방법</th>
					<td><%= oorderMaster.FOneItem.GetAccountdivName %></td>
				</tr>
				<% If oorderMaster.FOneItem.GetAccountdivName = "무통장" Then %>
				<tr>
					<th scope="row">입금가상계좌</th>
					<td>
						<div class="bankAccount"><strong><%= oorderMaster.FOneItem.Faccountno %></strong> <strong>(주)텐바이텐</strong></div>
					</td>
				</tr>
				<% End If %>
				<tr>
					<th scope="row">주문일시</th>
					<td><%= oorderMaster.FOneItem.FRegDate %></td>
				</tr>
				<tr>
					<th scope="row">최종결제액</th>
					<td>
						<div class="finalPayment">
							<strong class="txtBtwDk"><%= FormatNumber(oorderMaster.FOneItem.FsubtotalPrice,0) %>원</strong>
						<% If oorderMaster.FOneItem.FOrderTenID <> "" Then %>
							<ul>
							<% If (oorderMaster.FOneItem.Fmiletotalprice <> 0) Then %>
								<li>마일리지 사용 : <em class="txtSaleRed"><%= FormatNumber(oorderMaster.FOneItem.Fmiletotalprice,0) %>P</em></li>
							<% End If %>
							<% If (oorderMaster.FOneItem.Fspendtencash <> 0) Then %>
								<li>예치금 사용 : <em class="txtSaleRed"><%= FormatNumber(oorderMaster.FOneItem.Fspendtencash,0) %>원</em></li>
							<% End If %>
							<% If (oorderMaster.FOneItem.Fspendgiftmoney <> 0)  Then %>
								<li>Gift 카드 사용 : <em class="txtSaleRed"><%= FormatNumber(oorderMaster.FOneItem.Fspendgiftmoney,0) %>원</em></li>
							<% End If %>
							<% If (oorderMaster.FOneItem.Ftencardspend <> 0) Then %>
								<li>보너스쿠폰 사용 : <em class="txtSaleRed"><%= FormatNumber(oorderMaster.FOneItem.Ftencardspend,0) %>원</em></li>
							<% End If %>
							</ul>
						<% End If %>
						</div>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문리스트 확인 (<%=oorderDetail.FResultCount%>종 / <%= oorderDetail.FSumItemno %>개)</h2>
			</div>
			<div class="orderList orderListMore">
				<div class="extendBtn">주문리스트 상세 보기</div>
				<ul class="pdtList list02 boxMdl">
				<%
					For i = 0 to oorderDetail.FResultCount - 1
						ArrOrderitemid = ArrOrderitemid & oorderDetail.FItemList(i).FItemID & ";"
						ArrOrderPrice  = ArrOrderPrice & oorderDetail.FItemList(i).FItemCost & ";"
						ArrOrderEa     = ArrOrderEa & oorderDetail.FItemList(i).FItemNo & ";"
				%>
					<li>
						<div>
							<a href="/apps/appCom/between/category/category_itemPrd.asp?itemid=<%= oorderDetail.FItemList(i).FItemid %>">
								<p class="pdtPic"><img src="<%= oorderDetail.FItemList(i).FImageList %>" alt="<%= oorderDetail.FItemList(i).FItemName %>" /></p>
								<p class="pdtName"><%= oorderDetail.FItemList(i).FItemName %></p>
								<p class="subtotal">소계금액 : <strong class="txtBtwDk"><%= FormatNumber(oorderDetail.FItemList(i).FItemCost*oorderDetail.FItemList(i).FItemNo,0) %> <%= CHKIIF(oorderDetail.FItemList(i).IsMileShopSangpum,"Pt","원") %></strong> (<%= oorderDetail.FItemList(i).FItemNo %>개)</p>
								<p class="delivery">[<%= oorderDetail.FItemList(i).getDeliveryTypeName %>]</p>
							</a>
						</div>
					</li>
				<% Next %>
				</ul>
			</div>
			<div class="hWrap hrBtw">
				<h2 class="headingB">주문고객정보 확인</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeA">
				<caption>주문고객 정보</caption>
				<tbody>
				<tr>
					<th scope="row">보내시는 분</th>
					<td><%= oorderMaster.FOneItem.FBuyName %></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td><%= oorderMaster.FOneItem.FBuyEmail %></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><%= oorderMaster.FOneItem.FBuyhp %></td>
				</tr>
				</tbody>
				</table>
			</div>
			<div class="hWrap hrBtw">
				<h2 class="headingB">배송지정보 확인</h2>
			</div>
			<div class="section">
				<table class="tableType tableTypeA">
				<caption>배송지 정보</caption>
				<tbody>
				<tr>
					<th scope="row">받으시는 분</th>
					<td><%= oorderMaster.FOneItem.FReqName %></td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td><%= oorderMaster.FOneItem.FReqHp %></td>
				</tr>
				<tr class="deliveryAddress">
					<th scope="row">주소</th>
					<td>
						<span>[<%= oorderMaster.FOneItem.FreqzipCode %>]</span>
						<p><%= oorderMaster.FOneItem.Freqzipaddr %> <%= oorderMaster.FOneItem.Freqaddress %></p>
					</td>
				</tr>
				<% If nl2Br(oorderMaster.FOneItem.Fcomment) <> "" Then %>
				<tr>
					<th scope="row">배송유의사항</th>
					<td><%= nl2Br(oorderMaster.FOneItem.Fcomment) %></td>
				</tr>
				<% End If %>
				</tbody>
				</table>
			</div>
			<% '<div class="btnArea"><span class="btn02 btw btnBig full"><a href="/apps/appCom/between/index.asp">쇼핑 계속하기</a></span></div> %>
		<% Else %>
			<div class="msgBox">
				<p class="txtBlk">고객님의 <strong class="txtBtwDk">주문이 실패</strong>하였습니다.</p>
				<p>오류내용 : <%= oorderMaster.FOneItem.FResultmsg %></p>
			</div>
			<div class="section ct">
				<p>텐바이텐 고객행복센터 <a href="tel:1644-6030" class="txtSaleRed"><em>1644-6030</em></a> / <a href="mailto:customer@10x10.co.kr" class="txtBtwDk">customer@10x10.co.kr</a></p>
			</div>
			<div class="btnArea">
				<span class="btn02 btw btnBig full"><a href="/apps/appCom/between/inipay/ShoppingBag.asp">다시 주문하기</a></span>
			</div>
		<% End If %>
		</div>
	<%
		If (IsSuccess) then
			oshoppingbag.ClearShoppingbag
			Dim CartCnt : CartCnt = getDBCartCount
			SetCartCount(CartCnt)

			If CheckRequireDetailMsg then
				response.write "<script>alert('주문제작 문구가 정확히 입력되셨는지 다시한번 확인해 주시기 바랍니다.\n문구를 수정하시려면 내용수정 버튼을 클릭하신후 수정 가능합니다.');</script>"
			End if
		End If
	%>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
	<%
		if gaCmcSCRIPT<>"" then
			Response.Write "<script>" & gaCmcSCRIPT & "</script>"
		end if
	%>
</div>
</body>
</html>
<%
Set oorderDetail	= nothing
Set oshoppingbag	= Nothing
Set oorderMaster	= Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
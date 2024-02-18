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

if myorder.FResultCount>0 then
    IsValidOrder = True

    IsTicketOrder = myorder.FOneItem.IsTicketOrder
    pflag=CHKIIF(myorder.FOneItem.fcancelyn<>"N","C","")
end if

if (Not myorder.FOneItem.IsValidOrder) then
    IsValidOrder = False

    if (orderserial<>"") then
        ''response.write "<script language='javascript'>alert('취소된 주문건 또는 올바른 주문이 아닙니다.');</script>"
    end if
end if

%>

</head>
<body>
<% ' for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) %>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- #include virtual="/apps/appCom/between/my10x10/order/inc_myorderdetail_tab.asp" -->

			<!-- 결제 -->
			<div class="sectionLine">
				<table class="tableType tableTypeA">
				<caption>결제정보</caption>
				<tbody>
				<tr>
					<th scope="row">결제방법</th>
					<td><strong><%= myorder.FOneItem.GetAccountdivName %></strong></td>
				</tr>
				<tr>
					<th scope="row">입금예정자명</th>
					<td><strong><%= myorder.FOneItem.Faccountname %></strong></td>
				</tr>
				<tr>
					<th scope="row">결제확인일시</th>
					<td><%= myorder.FOneItem.FIpkumDate %></td>
				</tr>
			<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
				<% IF (myorder.FOneItem.Fmiletotalprice<>0) then %>
					<tr>
						<th scope="row">마일리지 사용</th>
						<td><em class="txtSaleRed"><%= FormatNumber(myorder.FOneItem.Fmiletotalprice,0) %> P</em></td>
					</tr>
				<% end if %>
				
				<% IF (myorder.FOneItem.Ftencardspend<>0) then %>
					<tr>
						<th scope="row">보너스쿠폰 사용</th>
						<td><em class="txtCpGreen"><%= FormatNumber(myorder.FOneItem.Ftencardspend,0) %> 원</em></td>
					</tr>
				<% end if %>
				
				<% if (myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership<>0) then %>
					<tr>
						<th scope="row">기타 할인</th>
						<td><em class="txtSaleRed"><%= FormatNumber((myorder.FOneItem.Fallatdiscountprice + myorder.FOneItem.Fspendmembership),0) %> 원</em></td>
					</tr>
				<% end if %>
			<% end if %>

				<% if (myorder.FOneItem.FAccountDiv="110") then %>
					<tr>
						<th scope="row">OK캐쉬백 사용금액</th>
						<td><strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.FokcashbagSpend,0) %> 원</strong></td>
					</tr>
					<tr>
						<th scope="row">신용카드결제 금액</th>
						<td><strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice-myorder.FOneItem.FokcashbagSpend,0) %> 원</strong></td>
					</tr>
				<% else %>
					<% if myorder.FOneItem.FAccountdiv = 7 then %>
						<tr>
							<th scope="row">입금하실 계좌</th>
							<td>
								<div class="bankAccount"><strong><%= myorder.FOneItem.Faccountno %>&nbsp;&nbsp;(주)텐바이텐</strong></div>
							</td>
						</tr>
						<tr>
							<th scope="row"><%= CHKIIF(myorder.FOneItem.FIpkumdiv>3,"결제 금액","결제하실 금액") %></th>
							<td><strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice,0) %> 원</strong></td>
						</tr>
					<% else %>
						<tr>
							<th scope="row"><%= CHKIIF(myorder.FOneItem.FIpkumdiv>3,"결제 금액","결제하실 금액") %></th>
							<td><strong class="txtBtwDk"><%= FormatNumber(myorder.FOneItem.TotalMajorPaymentPrice,0) %> 원</strong></td>
						</tr>
					<% end if %>
				<% end if %>
					
				<% if Not(myorder.FOneItem.FOrderTenID="" or isNull(myorder.FOneItem.FOrderTenID)) then %>
				<tr>
					<th scope="row">적립 마일리지</th>
					<td><strong><%= FormatNumber(myorder.FOneItem.Ftotalmileage,0) %></strong></td>
				</tr>
				<% end if %>
				</tbody>
				</table>
			</div>
			<!-- //결제 -->

			<div class="btnArea">
				<span class="btn02 cnclGry btnBig full"><a href="/apps/appCom/between/my10x10/order/myorderlist.asp">목록으로 돌아가기</a></span>
			</div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
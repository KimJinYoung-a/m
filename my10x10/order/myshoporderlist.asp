<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'####################################################
' Description : 마이텐바이텐 - 주문배송조회
' History : 2014-08-29 이종화 생성
'####################################################
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cancelOrderLib.asp" -->
<%
'해더 타이틀
strHeadTitleName = "주문배송조회"

dim i, j, lp
dim page
dim pflag, aflag
pflag = requestCheckvar(request("pflag"),10)
aflag = requestCheckvar(request("aflag"),2)
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = getEncLoginUserID()

dim myorder
set myorder = new CMyOrder

myorder.FPageSize = 10
myorder.FCurrpage = page
myorder.FRectUserID = userid
myorder.FRectSiteName = "10x10"
myorder.FRectOldjumun = pflag
myorder.FRectStartDate = FormatDateTime(DateAdd("m",-6,now()),2)
myorder.FRectEndDate = FormatDateTime(now(),2)

If aflag = "XX" Then
	if IsUserLoginOK() then
	    myorder.GetMyCancelOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyCancelOrderList
	end if
Else
	myorder.FRectArea = aflag

	if IsUserLoginOK() then
	    myorder.GetMyShopOrderListProc
	end if
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 주문배송조회</title>
<script type='text/javascript'>
function goPage(pg){
	var frm = document.frmsearch;
	frm.page.value=pg;
	frm.submit();
}
function goLink(page,pflag,aflag){
    location.href="?page=" + page + "&pflag=" + pflag + "&aflag=" + aflag;
}
</script>
</head>
<body class="default-font body-sub body-1depth">
	<form name="frmsearch" method="post" action="myshoporderlist.asp" style="margin:0px;">
	<input type="hidden" name="pflag" value="<%=pflag%>">
	<input type="hidden" name="aflag" value="<%=aflag%>">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
			<ul class="grid2">
				<li><a href="/my10x10/order/myorderlist.asp">온라인 주문</a></li>
				<li><a href="#" class="on">매장 주문</a></li>
			</ul>
		</div>
		<div class="myOrderMain">
			
			<div class="myTenNoti">
				<ul>
					<li>최근 6개월간 오프라인 주문건별 구매 내역 정보입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
					<li>오프라인 주문 정보는 일별로 매장 마감한 상품 기준으로 갱신됩니다.</li>
					<li>오프라인 상품의 할인, 가격 정보는 매장별 정책에 따라 온라인 상품 정보와 상이할 수 있습니다.</li>
					<li>오프라인 구매 상품의 교환 및 환불 신청은 구매 매장에 문의 부탁드립니다.</li>
				</ul>
			</div>

			<% if myorder.FResultCount < 1 then %>
			<div class="nodata-list default-font">
				<div class="nodata">
					<h2>주문내역이 없습니다.</h2>
					<p>매장 결제시 텐바이텐 멤버십카드를 제시하시면<br/><em>구매 금액의 3%를 매장 마일리지로 적립</em>해드립니다.</p>
					<p>※ 멤버십카드는 [마이텐바이텐] 메뉴에서 확인 가능</p>
				</div>
				<div class="thumb"><img src="http://fiximage.10x10.co.kr/m/2018/my10x10/img_my_ten_app.png" alt=""></div>
			</div>
			<% Else %>
			<!-- 주문내역 -->
			<ul class="myOdrList">
				<% For i = 0 To (myorder.FResultCount - 1) %>
				<li>
					<a href="/my10x10/order/myshoporderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%= pflag %>">
						<div class="odrInfo">
							<p><%= FormatDate(CStr(myorder.FItemList(i).Fregdate),"0000.00.00") %></p>
							<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
						</div>
						<div class="odrCont">
							<p class="type"><%=myorder.FItemList(i).FShopName%><% If myorder.FItemList(i).FSubTotalPrice<0 Then %> [반품]<% End If %></p>
							<p class="item"><%=myorder.FItemList(i).GetItemNames%></p>
							<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
						</div>
					</a>
				</li>
				<% Next %>
			</ul>
			<%=fnDisplayPaging_New(myorder.FcurrPage,myorder.FtotalCount,myorder.FPageSize,4,"goPage")%>
			<!--// 주문 내역 -->
			<% end if %>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
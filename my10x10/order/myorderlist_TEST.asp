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
	    myorder.GetMyOrderList
	elseif IsGuestLoginOK() then
	    myorder.FRectOrderserial = GetGuestLoginOrderserial()
	    myorder.GetMyOrderList
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
	<form name="frmsearch" method="post" action="myorderlist.asp" style="margin:0px;">
	<input type="hidden" name="pflag" value="<%=pflag%>">
	<input type="hidden" name="aflag" value="<%=aflag%>">
	<input type="hidden" name="page" value="1">
	</form>
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="myOrderMain">
			<div class="myTenNoti">
				<!--<h2 class="tit01">주문배송조회</h2>-->
				<ul>
					<li>최근 6개월간 고객님의 주문내역입니다. 주문번호를 탭하시면 상세조회를 하실 수 있습니다.</li>
					<li>6개월 이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다.</li>
					<li>상품 일부만 취소하고자 하시는 경우 고객행복센터로 문의 바랍니다. <a href="/my10x10/qna/myqnalist.asp" class="cRd1" style="white-space:nowrap;">1:1상담 바로가기 &gt;</a></li>
				</ul>
			</div>
			<div class="nav nav-stripe nav-stripe-default nav-stripe-red">
				<ul class="grid3">
					<li><a href="" onclick="goLink(1,'<%=pflag%>','');return false;"  <%=chkIIF(aflag="","class='on'","")%>>전체</a></li>
					<li><a href="" onclick="goLink(1,'<%=pflag%>','AB');return false;" <%=chkIIF(aflag="AB","class='on'","")%>>해외배송주문</a></li>
					<li><a href="" onclick="goLink(1,'<%=pflag%>','XX');return false;" <%=chkIIF(aflag="XX","class='on'","")%>>취소주문</a></li>
				</ul>
			</div>
			<% if myorder.FResultCount > 0 then %>
			<ul class="myOdrList">
				<% for i = 0 to (myorder.FResultCount - 1) %>
				<li>
					<a href="/my10x10/order/myorderdetail.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>&pflag=<%= pflag %>">
						<div class="odrInfo">
							<p><%= formatdate(myorder.FItemList(i).Fregdate,"0000.00.00") %></p>
							<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
						</div>
						<div class="odrCont">
							<p class="type">
								<span class="<%=myorder.FItemList(i).GetIpkumDivColor%>">[<%=chkIIF(myorder.FItemList(i).FCancelyn<>"N","취소주문",myorder.FItemList(i).GetIpkumDivName)%><%=chkIIF(myorder.FItemList(i).IsReceiveSiteOrder,"(현장수령)","")%>]</span>
							</p>
							<p class="item"><%=myorder.FItemList(i).GetItemNames%></p>
							<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
						</div>
					</a>

					<%	if (myorder.FItemList(i).FCancelyn="N") and (myorder.FItemList(i).IsWebOrderCancelEnable or myorder.FItemList(i).IsWebStockOutItemCancelEnable) then %>
					<div class="btnCancel">
						<%
						if myorder.FItemList(i).IsWebStockOutItemCancelEnable and myorder.FItemList(i).FmaystockoutYN = "Y" then
							if (ChkStockoutItemExist_Proc(myorder.FItemList(i).FOrderSerial)) then
						%>
						<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/order/order_cancel_detail_TEST.asp?mode=so&idx=<%= myorder.FItemList(i).FOrderSerial %>">품절상품 취소</a></span>
						<%
							end if
						end if
						%>
						<% if myorder.FItemList(i).IsWebOrderCancelEnable then %>
						<span class="button btS1 btnRed1V16a cRd1V16a"><a href="/my10x10/order/order_cancel_detail_TEST.asp?idx=<%= myorder.FItemList(i).FOrderSerial %>">주문취소</a></span>
						<% end if %>
					</div>
					<%	end if %>
				</li>
				<% Next %>
			</ul>
			<% Else %>
			<div class="nodata nodata-default">
				<p>주문내역이 없습니다.</p>
			</div>
			<% End If %>
			<%=fnDisplayPaging_New(myorder.FcurrPage,myorder.FtotalCount,myorder.FPageSize,4,"goPage")%>
		</div>
	</div>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

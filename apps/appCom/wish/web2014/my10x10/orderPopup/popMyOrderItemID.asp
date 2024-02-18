<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "03" %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<%
dim i

''로그인 한 경우만 가능 ( 주문번호 로그인은 불가)
dim userid
userid = getEncLoginUserID()

dim frmname, targetname
frmname     = request("frmname")
targetname  = request("targetname")

Dim page	: page = req("page",1)

Dim orderSerial
if IsUserLoginOK() then
	orderSerial	= req("orderSerial","")
elseif IsGuestLoginOK() then
	orderSerial	= GetGuestLoginOrderserial()
end if

dim myorderdetail
set myorderdetail = new CMyOrder

If orderSerial <> "" Then
	myorderdetail.FRectOrderserial = orderserial
	myorderdetail.GetOrderDetail
ElseIf getEncLoginUserID() <> "" Then
	myorderdetail.FPageSize = 5
	myorderdetail.FCurrpage = page
	myorderdetail.GetMyOrderItemList
Else
	response.write "<script>" & vbCrLf
	response.write "alert('잘못된 호출입니다.');" & vbCrLf
	response.write "window.close();" & vbCrLf
	response.write "</script>" & vbCrLf
	Set myorderdetail	= Nothing
	dbget.close()	:	response.End
End If
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
function jsGoPage(iP){ //페이지 이동
	location.href = "/apps/appCom/wish/web2014/my10x10/orderPopup/popMyOrderItemID.asp?frmname=<%=frmname%>&targetname=<%=targetname%>&orderserial=<%=orderSerial%>&page="+iP;
	return false;
}

function RetItemID(orderserial, itemid, inm, iprc) {
	fnAPPopenerJsCallClose("jsReActWithItemID('" + orderserial + "', '" + itemid + "', '" + inm + "', '" + iprc + "')");
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content myReview" id="contentArea">
			<div class="myTenNoti">
				<ul>
					<li>최근 2개월간 고객님의 주문내역입니다. <br />상담을 원하시는 주문번호/상품명을 선택해주세요.</li>
				</ul>
			</div>
			<div class="inner10">
				<% if myorderdetail.FResultCount < 1 then %>
				<div class="noDataBox">
					<p class="noDataMark"><span>!</span></p>
					<p class="tPad05">주문한 상품내역이 없습니다.</p>
				</div>
				<% Else %>
				<ul class="reviewList">
					<% for i = 0 to (myorderdetail.FResultCount - 1) %>
					<li>
						<a href="javascript:RetItemID('<%= myorderdetail.FItemList(i).ForderSerial %>', '<%= myorderdetail.FItemList(i).FItemid %>','<%= chrbyte(myorderdetail.FItemList(i).FItemName,30,"Y") %>','<%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %>')">
							<div class="odrInfo">
								<span>주문번호(<%= myorderdetail.FItemList(i).ForderSerial %>)</span>
								<span>상품코드(<%= myorderdetail.FItemList(i).FItemid %>)</span>
							</div>
							<div class="pdtWrap">
								<p class="pic"><img src="<%=myorderdetail.FItemList(i).FImageList%>" alt="<%= myorderdetail.FItemList(i).FItemName %>" /></p>
								<div class="pdtInfo">
									<p class="pName"><%= myorderdetail.FItemList(i).FItemName %></p>
									<p class="option">
										<% if (myorderdetail.FItemList(i).FItemOptionName <> "") then %>
										옵션 : <%= myorderdetail.FItemList(i).FItemOptionName %>
										<% end if %>
									</p>
									<p class="pPrice"><strong><%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %></strong>원</p>
								</div>
							</div>
						</a>
					</li>
					<% next %>
				</ul>
				<% End If %>

				<%= fnDisplayPaging_New(page, myorderdetail.FtotalCount, myorderdetail.FPageSize, 5,"jsGoPage") %>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

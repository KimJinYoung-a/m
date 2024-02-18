<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#-------------------------------------#
'| 내 주문상품 찾기 (모달창용)         |
'#-------------------------------------#
%>
<!-- #include virtual="/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
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
	response.write "fnCloseModal();" & vbCrLf
	response.write "</script>" & vbCrLf
	Set myorderdetail	= Nothing
	dbget.close()	:	response.End
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
function goPage(page){
	fnOpenModal('/my10x10/orderPopup/pop_MyOrderItemID.asp?orderserial=<%=orderserial%>&page=' + page);
}
</script>
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>내가 주문한 상품</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content myReview" id="layerScroll">
			<div id="scrollarea">
				<div id="my2">
					<div id="my2Tit" class="myTenNoti">
						<ul>
							<li>최근 6개월간 고객님의 주문내역입니다. <br />상담을 원하시는 주문번호/상품명을 선택해주세요.</li>
						</ul>
					</div>
					<div class="inner10">
						<% if myorderdetail.FResultCount < 1 then %>
						<div class="noDataBox">
							<p class="noDataMark"><span>!</span></p>
							<p class="tPad05">주문한 상품내역이 없습니다.</p>
						</div>
						<% else %>
						<ul class="reviewList">
							<% for i = 0 to (myorderdetail.FResultCount - 1) %>
							<li>
								<a href="" onclick="putMyItemid('<%= myorderdetail.FItemList(i).ForderSerial %>', '<%= myorderdetail.FItemList(i).FItemid %>','<%= chrbyte(myorderdetail.FItemList(i).FItemName,30,"Y") %>','<%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %>');return false;">
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
						<% end if %>

						<!--페이지표시-->
						<%=fnDisplayPaging_New(myorderdetail.FcurrPage,myorderdetail.FtotalCount,myorderdetail.FPageSize,4,"goPage")%>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
	set myorderdetail = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

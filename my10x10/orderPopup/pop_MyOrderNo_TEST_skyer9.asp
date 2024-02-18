<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

'#-------------------------------------#
'| 내 주문번호 찾기 (모달창용)         |
'#-------------------------------------#
%>
<!-- #include virtual="/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
''로그인 한 경우만 가능 ( 주문번호 로그인은 불가)
dim userid
userid = GetLoginUserID()

dim frmname, targetname
frmname     = request("frmname")
targetname  = request("targetname")

Dim page	: page = req("page",1)

dim myorderList
set myorderList = new CMyOrder
myorderList.FRectUserID = userid
myorderList.FPageSize = 10
myorderList.FCurrpage = page

if IsUserLoginOK() then
    myorderList.GetMyOrderList
end if

dim i
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
function goPage(page){
	fnOpenModal('/my10x10/orderPopup/pop_MyOrderNo.asp?page='+ page);
}
</script>
</head>
<body>
<div class="heightGrid layerPopup">
	<div class="container popWin">
		<div class="header">
			<h1>주문배송조회</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content popQnaOdrList" id="layerScroll">
			<div id="scrollarea">
				<div id="my2">
					<div class="myTenNoti" id="my2Tit">
						<ul>
							<li>최근 6개월간 고객님의 주문내역입니다. <br />상담을 원하시는 주문번호/상품명을 선택해주세요.</li>
						</ul>
					</div>
					<div class="inner10" id="my2order">
						<% if myorderList.FResultCount < 1 then %>
						<div class="noDataBox">
							<p class="noDataMark"><span>!</span></p>
							<p class="tPad05">검색된 주문내역이 없습니다.</p>
						</div>
						<% else %>
						<ul class="myOdrList">
							<% for i = 0 to (myorderList.FResultCount - 1) %>
							<li>
								<a href="" onclick="putMyOrderNo('<%= myorderList.FItemList(i).FOrderSerial %>','<%= Left(CStr(myorderList.FItemList(i).Fregdate),10) %>','<%= FormatNumber(myorderList.FItemList(i).FSubTotalPrice,0) %>','<%= myorderList.FItemList(i).getAccountDivName %>');return false;">
									<div class="odrInfo">
										<p><%= Left(CStr(myorderList.FItemList(i).Fregdate),10) %></p>
										<p>주문번호(<%= myorderList.FItemList(i).FOrderSerial %>)</p>
									</div>
									<div class="odrCont">
										<p class="type">[<%= myorderList.FItemList(i).GetIpkumDivName %>]</p>
										<p class="item"><%= myorderList.FItemList(i).GetItemNames %></p>
										<p class="price"><strong><%= FormatNumber(myorderList.FItemList(i).FSubTotalPrice,0) %></strong>원</p>
									</div>
								</a>
							</li>
							<% next %>
						</ul>
						<% end if %>
						<%=fnDisplayPaging_New(myorderList.FcurrPage,myorderList.FtotalCount,myorderList.FPageSize,4,"goPage")%>
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
	set myorderList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

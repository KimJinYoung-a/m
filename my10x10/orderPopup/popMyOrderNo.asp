<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "03" %>
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
''로그인 한 경우만 가능 ( 주문번호 로그인은 불가)
dim userid
userid = getEncLoginUserID()

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
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<script>
function goPage(page){
	location.href = "?frmname=<%=frmname%>&targetname=<%=targetname%>&page=" + page;
}
function RetOrderSerial(orderserial){
	var frm = eval('opener.<%= frmname %>');
	frm.orderserial.value = orderserial;
	frm.itemid.value = "";
	frm.submit();
	window.close();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>주문배송조회</h1>
			<p class="btnPopPrev"><a href="javascript:window.close();" class="pButton">이전으로</a></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div id="my2">
				<div id="my2Tit">
					<p class="pDesc">최근 6개월간 고객님의 주문내역입니다. 상담을 원하시는 주문번호/상품명을 선택해주세요.</p>
				</div>
				<!--주문배송조회-->
				<div id="my2order">
					<div id="my2orderList">
						<ul>
							<% if myorderList.FResultCount < 1 then %>
							<li class="noData">검색된 주문내역이 없습니다.</li>
							<% else %>
							<% for i = 0 to (myorderList.FResultCount - 1) %>
							<li>
								<a href="javascript:RetOrderSerial('<%= myorderList.FItemList(i).FOrderSerial %>');">
									<div class="orderNum">
										<dl>
											<dt>주문번호 <%= myorderList.FItemList(i).FOrderSerial %> <span class=""><%= myorderList.FItemList(i).GetIpkumDivName %></span></dt>
											<dd>
												<p><%= myorderList.FItemList(i).GetItemNames %></p>
												<p><%= FormatNumber(myorderList.FItemList(i).FSubTotalPrice,0) %>원</p>
												<p><%= Left(CStr(myorderList.FItemList(i).Fregdate),10) %></p>
											</dd>
										</dl>
									</div>
								</a>
							</li>
							<% next %>
							<% end if %>
						</ul>
					</div>
				</div>
				<!--페이지표시-->
				<div class="paging tMar25">
					<%=fnDisplayPaging_New(myorderList.FcurrPage,myorderList.FtotalCount,myorderList.FPageSize,4,"goPage")%>
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
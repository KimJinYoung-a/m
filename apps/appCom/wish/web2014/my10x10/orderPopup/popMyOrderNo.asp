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
myorderList.FPageSize = 4
myorderList.FCurrpage = page

if IsUserLoginOK() then
    myorderList.GetMyOrderList
end if

dim i
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
function jsGoPage(iP){ //페이지 이동
	location.href = "/apps/appCom/wish/web2014/my10x10/orderPopup/popMyOrderNo.asp?frmname=<%=frmname%>&targetname=<%=targetname%>&page="+iP;
	return false;
}

function RetOrderSerial(orderserial,odt,oprc,oacc){
	fnAPPopenerJsCallClose("jsReActWithOrderserial('" + orderserial + "', '" + odt + "', '" + oprc + "', '" + oacc + "')");
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<!-- content area -->
		<div class="content popQnaOdrList" id="contentArea">
			<div class="myTenNoti">
				<ul>
					<li>최근 6개월간 고객님의 주문내역입니다. <br />상담을 원하시는 주문번호/상품명을 선택해주세요.</li>
				</ul>
			</div>
			<div class="inner10">
				<% if myorderList.FResultCount < 1 then %>
				<div class="noDataBox">
					<p class="noDataMark"><span>!</span></p>
					<p class="tPad05">검색된 주문내역이 없습니다.</p>
				</div>
				<% else %>
				<ul class="myOdrList">
					<% for i = 0 to (myorderList.FResultCount - 1) %>
					<li>
						<a href="javascript:RetOrderSerial('<%= myorderList.FItemList(i).FOrderSerial %>','<%= Left(CStr(myorderList.FItemList(i).Fregdate),10) %>','<%= FormatNumber(myorderList.FItemList(i).FSubTotalPrice,0) %>','<%= myorderList.FItemList(i).getAccountDivName %>');">
							<div class="odrInfo">
								<p><%= formatdate(CStr(myorderList.FItemList(i).Fregdate),"0000.00.00") %></p>
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
				<%= fnDisplayPaging_New(page, myorderList.FtotalCount, myorderList.FPageSize, 4,"jsGoPage") %>
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

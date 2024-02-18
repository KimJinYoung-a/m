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
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<script>
function goPage(page){
	location.href = "?frmname=<%=frmname%>&targetname=<%=targetname%>&orderserial=<%=orderserial%>&page=" + page;
}
function RetItemID(orderSerial, itemid)
{
	var comp = eval('opener.<%= frmname %>.<%= targetname %>');
	var frm = eval('opener.<%= frmname %>');
	frm.orderserial.value = orderSerial;
	comp.value = itemid;
	frm.submit();
	window.close();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>내가 주문한 상품</h1>
			<p class="btnPopPrev"><a href="javascript:window.close();" class="pButton">이전으로</a></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div id="my2">
				<div id="my2Tit">
					<h2>내가 주문한 상품</h2>
					<p class="tMar10 pDesc">최근 2개월간 고객님의 주문내역입니다. 상담을 원하시는 주문번호/상품명을 선택해주세요.</p>
				</div>
				<!--주문배송내역-->
				<ul class="list01">
					<% if myorderdetail.FResultCount < 1 then %>
					<li class="noData">주문한 상품내역이 없습니다.</li>
					<% Else %>
					<% for i = 0 to (myorderdetail.FResultCount - 1) %>
					<li class="inner"><a href="javascript:RetItemID('<%= myorderdetail.FItemList(i).ForderSerial %>', '<%= myorderdetail.FItemList(i).FItemid %>');">
						<span class="pic"><img src="<%=myorderdetail.FItemList(i).FImageList%>" alt="페이퍼웨이즈 만년다이어리 저널 - 위클리" style="width:100%"></span>
						<div class="pdtCont">
							<p class="ftMidSm b">주문번호 <%= myorderdetail.FItemList(i).ForderSerial %></p>
							<p class="ftMidSm b">상품코드 <%= myorderdetail.FItemList(i).FItemid %></p>
							<p class="ftSmall c999"><%= myorderdetail.FItemList(i).FItemName %></p>
							<p class="ftBasic b"><%= FormatNumber(myorderdetail.FItemList(i).FItemCost,0) %><span class="ftMidSm">원</span></p>
						</div></a>
					</li>
					<% next %>
					<% End If %>
				</ul>
				<!--페이지표시-->
				<div class="paging tMar25">
					<%=fnDisplayPaging_New(myorderdetail.FcurrPage,myorderdetail.FtotalCount,myorderdetail.FPageSize,4,"goPage")%>
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
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 반품 Step1
' History : 2018.09.10 원승현 생성
'####################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "반품/환불"

dim i, j, lp
dim page
page = requestCheckvar(request("page"),9)
if (page="") then page = 1

dim userid
userid = getEncLoginUserID()

dim myorder
set myorder = new CMyOrder

myorder.FPageSize = 10
myorder.FCurrpage = page

if IsUserLoginOK() then
	myorder.FRectUserID = userid
	myorder.GetMyReturnOrderListLoginUser()
elseif IsGuestLoginOK() then
	myorder.FRectOrderserial = GetGuestLoginOrderserial()
	myorder.GetMyReturnOrderListGuestLoginUser()
end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 반품/환불</title>
<script type='text/javascript'>
function goPage(pg){
	var frm = document.frmsearch;
	frm.page.value=pg;
	frm.submit();
}
function goLink(page,pflag,aflag){
    location.href="?page=" + page;
}
function pop_ReturnInfo(){
	fnOpenModal("/my10x10/orderpopup/act_popReturnInfo.asp");
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="myorder_return_step1.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<div id="content" class="content">
		<div class="returnWrap">
			<div class="returnNoti">
				<h2 class="tit05">반품안내</h2>
				<p>상품 출고일 기준 7일 이내 (평일 기준)에 반품 및 환불이 가능합니다.</p>
				<a href="" onclick="fnAPPpopupBrowserURL('반품안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/orderpopup/act_popReturnInfo.asp'); return false;" class="btn-detail">자세히</a>
			</div>

			<ol class="returnStep">
				<li class="on"><em class="num">1</em>주문선택</li>
				<li><em class="num">2</em>상품선택</li>
				<li><em class="num">3</em>정보확인</li>
				<li><em class="num">4</em>접수완료</li>
			</ol>

			<% if myorder.FResultCount > 0 then %>
				<%' 주문내역 있는 경우 %>
				<ul class="myOdrList">
					<% for i = 0 to (myorder.FResultCount - 1) %>
						<li>
							<a href="/apps/appCom/wish/web2014/my10x10/order/myorder_return_step2.asp?idx=<%=myorder.FItemList(i).FOrderSerial%>">
								<div class="odrInfo">
									<p><%= formatdate(myorder.FItemList(i).Fregdate,"0000.00.00") %></p>
									<p>주문번호(<%= myorder.FItemList(i).FOrderSerial %>)</p>
								</div>
								<div class="odrCont">
									<p class="type">[<%=chkIIF(myorder.FItemList(i).FCancelyn<>"N","취소주문",myorder.FItemList(i).GetIpkumDivName)%><%=chkIIF(myorder.FItemList(i).IsReceiveSiteOrder,"(현장수령)","")%>]</p>
									<p class="item"><%=myorder.FItemList(i).GetItemNames%></p>
									<p class="price"><strong><%=FormatNumber(myorder.FItemList(i).FSubTotalPrice,0)%></strong>원</p>
								</div>
							</a>
							<div class="btnReturn">
								<span class="button"><a href="/apps/appCom/wish/web2014/my10x10/order/myorder_return_step2.asp?idx=<%=myorder.FItemList(i).FOrderSerial%>">반품 접수</a></span>
							</div>
						</li>
					<% Next %>
				</ul>
				<%' //주문내역 있는 경우 %>
				<%=fnDisplayPaging_New(myorder.FcurrPage,myorder.FtotalCount,myorder.FPageSize,4,"goPage")%>
			<% Else %>
				<div class="nodata-list">
					<h2>반품 신청 가능한 주문 내역이 없습니다.</h2>
					<p>불량, 파손 등의 반품 문의나 더 궁금하신 사항은<br>1:1 상담을 이용해주세요.</p>
					<a href="" onclick="fnAPPpopupBrowserURL('1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp','right','','sc');return false;" class="btn-counsel">1:1 상담하기</a>
				</div>
			<% End If %>
			<div class="btn-return-list"><a href="" onclick="fnAPPpopupBrowserURL('내가 신청한 서비스','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/order/order_cslist.asp','right','','sc'); return false;"><span>나의 반품 내역 보기</span></a></div>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<%
set myorder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
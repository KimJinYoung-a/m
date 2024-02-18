<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/noticefaqCls.asp" -->
<%
	Dim cNoti, WeekNotiCnt
	
	SET cNoti = New CNoticeFaq
		WeekNotiCnt = cNoti.getNoticeCnt
	SET cNoti = nothing
%>
</head>
<body>
<div class="wrapper" id="btwMypage">
	<div id="content">
		<h1 class="noView">마이페이지</h1>
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<!-- 내 보관함 -->
			<div class="hWrap hrBlk">
				<h2 class="headingA txtCnclGry">내 보관함</h2>
			</div>
			<div class="myStorage">
				<ul class="tabMenu">
					<li class="cart">
						<a href="/apps/appCom/between/inipay/ShoppingBag.asp"><p>장바구니</p></a>
						<span class="newIco saleRed"><%=GetBetweenCartCount()%></span>
					</li>
					<li class="order">
						<a href="/apps/appCom/between/my10x10/order/myorderlist.asp"><p>주문/배송 조회</p></a>
					</li>
				</ul>
				<!--
				<ul class="myList">
					<li><a href="/apps/appCom/between/my10x10/order/myordercancellist.asp"><p>취소/교환/반품 내역</p></a></li>
				</ul>
				-->
			</div>
			<!--// 내 보관함 -->

			<!-- 안내 -->
			<div class="hWrap hrBlk">
				<h2 class="headingA txtCnclGry">안내</h2>
			</div>
			<div class="myGuide">
				<ul class="myList">
					<li><a href="/apps/appCom/between/my10x10/notice.asp"><p>공지사항</p> <%=Chkiif(WeekNotiCnt > 0, "<span class='newIco saleRed'>"&WeekNotiCnt&"</span>", "")%></a></li>
					<li><a href="/apps/appCom/between/my10x10/faq.asp"><p>FAQ</p></a></li>
					<li><a href="/apps/appCom/between/my10x10/cscenter.asp"><p>텐바이텐 고객센터</p></a></li>
				</ul>
			</div>
			<!--// 안내 -->
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
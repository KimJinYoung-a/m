<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim itemid	: itemid = requestCheckVar(request("itemid"),9)
dim backurl : backurl = requestCheckVar(request("backurl"),100)
If backurl <> "" Then
	backurl = request.ServerVariables("HTTP_REFERER")	
End If
%>
<style>
.pkgGoodV15a {overflow:hidden; padding:5px 5px 20px 5px;}
.pkgGoodV15a li {float:left; width:50%; padding:6px;}
.pkgGoodV15a li div {background-repeat:no-repeat; background-position:50% 12%; font-size:11px; color:#777; padding:65% 10% 10% 10%; line-height:1.3;}
.pkgGoodV15a li div strong {display:block; font-size:12px; color:#000; padding-bottom:5px;}
.pkgGoodV15a li.good1V15a div {background-image:url(http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_good1.png); background-color:#f7f5ed; background-size:49.3% auto;}
.pkgGoodV15a li.good2V15a div {background-image:url(http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_good2.png); background-color:#f5f1f8; background-size:49.3% auto;}
.pkgGoodV15a li.good3V15a div {background-image:url(http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_good3.png); background-color:#edf6f7; background-size:49.3% auto;}
.pkgGoodV15a li.good4V15a div {background-image:url(http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_good4.png); background-color:#f9f0ed; background-size:49.3% auto;}
@media (min-width:480px) {
	.pkgGoodV15a {padding:7px 7px 30px 7px;}
	.pkgGoodV15a li {padding:9px;}
	.pkgGoodV15a li div {font-size:16px;}
	.pkgGoodV15a li div strong {font-size:18px; padding-bottom:7px;}
}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>선물포장 안내</h1>
			<% If backurl <> "" Then %>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('<%=wwwUrl%>/<%=backurl%>'); return false;">닫기</button></p>
			<% Else %>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('<%=wwwUrl%>/category/category_itemprd.asp?itemid=<%=itemid%>'); return false;">닫기</button></p>
			<% End If %>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="pkgIntroV15a">
				<p><img src="http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_img.png" alt="" /></p>
				<h2><img src="http://fiximage.10x10.co.kr/m/2015/common/pkg_intro_tit.png" alt="텐바이텐 포장서비스 이런 점이 좋아요" /></h2>
				<ul class="pkgGoodV15a">
					<li class="good1V15a">
						<div>
							<strong>모아서 포장하기</strong>
							<p>여러 가지 상품을 한번에 모아서 주고 싶을 때</p>
						</div>
					</li>
					<li class="good2V15a">
						<div>
							<strong>여럿이서 나누기</strong>
							<p>여러 사람에게 줄 선물을 한번에 분배해야 할 때</p>
						</div>
					</li>
					<li class="good3V15a">
						<div>
							<strong>내것도 친구 것도~</strong>
							<p>누군가에게 줄 선물도 사면서 내가 필요한 것도 사고 싶을 때</p>
						</div>
					</li>
					<li class="good4V15a">
						<div>
							<strong>포장을 부탁해!</strong>
							<p>받아서 포장하고 카드는 쓰는 번거로움을 줄이고 싶을 때</p>
						</div>
					</li>
				</ul>
				<div class="inner10 bgGry">
					<div class="introBoxV15a btmLineV15a">
						<h3>알아두기</h3>
						<ul class="notiList">
							<li>선물포장은 <span class="cRd1">포장 1건당 2,000원</span>의 비용이 책정되는 <span class="cRd1">유료서비스</span> 입니다.</li>
							<li>불가피한 사정으로 인해 <span class="cRd1">포장 협의가 필요</span>할 경우 회원님께 <span class="cRd1">직접 연락</span>을 드린 후 선물포장을 진행합니다.</li>
							<li>선물포장(메시지 쓰기, 모아서 포장하기)는 주문결제 단에서 하실 수 있습니다.</li>
							<li>선물패키지의 포장 기준에 맞지 않을 경우 선물포장을 지원하지 않습니다.</li>
						</ul>
					</div>
					<div class="introBoxV15a tMar10">
						<h3>취소 및 환불 정책</h3>
						<ul class="notiList">
							<li>주문결제 후 ‘<span class="cRd1">상품준비중</span>’ 단계로 넘어갔을 경우, 이미 선물포장 작업이 들어간 상태이기 때문에 주문을 취소하여도 <span class="cRd1">선물포장비 환불이 불가능</span>합니다.</li>
							<li>교환/환불시 <span class="cRd1">상품에 문제가 있을 경우</span>에만 재포장 교환 및 환불이 가능합니다.</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<!-- //content area -->
		<div class="floatingBarV15 bgWht">
			<div class="btnWrap inner5 w100p">
				<div><span class="button btB1 btRed cWh1"><a href="" onclick="location.href='<%=wwwUrl%>/shoppingtoday/gift_recommend.asp'; return false;">선물포장 상품보기</a></span></div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
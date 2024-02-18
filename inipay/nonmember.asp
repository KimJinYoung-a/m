<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'// 해더 타이틀
	strHeadTitleName = "비회원 정보수집동의"

	dim strBackPath, strGetData, strPostData
	 strBackPath = ReplaceRequestSpecialChar(request("backpath"))
	 strBackPath = Replace(strBackPath,"^^","&")
	 strGetData  = ReplaceRequestSpecialChar(request("strGD"))
	 strPostData = ReplaceRequestSpecialChar(request("strPD"))
%>
<title>10x10: 비회원 정보수집 동의</title>
<script type="text/javascript">
	var myCatScroll;
	function loaded() {
		myCatScroll = new iScroll('scrollarea',{
			onBeforeScrollStart: function (e) {
				var target = e.target;
				while (target.nodeType != 1) target = target.parentNode;
				if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
					e.preventDefault();
			}
		});
	}
	document.addEventListener('DOMContentLoaded', function() {setTimeout(loaded, 200);}, false);

	function chkAgreement() {
		gfrm = document.frmLoginGuest;
		gfrm.chkAgree.value="Y";
		gfrm.action = '/login/dobagunilogin.asp';
		gfrm.submit();
	}
</script>
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>비회원 정보수집 동의</h1>
			<p class="btnPopClose"><button class="pButton" onclick="history.back();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<form name="frmLoginGuest" method="post" action="">
				<input type="hidden" name="backpath" value="<%=strBackPath%>">
				<input type="hidden" name="strGD" value="<%=strGetData%>">
				<input type="hidden" name="strPD" value="<%=strPostData%>">
				<input type="hidden" name="chkAgree" value="N" />
				<div class="nomemAgreeV16a">
					<div class="bxWt1V16a">
						<div class="tPad3r fs1-3r cBk1V16a">비회원으로 구매 시, 다음 개인정보 수집항목을 확인 후 동의하셔야 합니다.</div>
						<div class="bxLGy2V16a agreeBoxV15a">
							<h2>1. 수집하는 개인정보 항목</h2>
							<p>- e-mail, 전화번호, 성명, 주소, 은행계좌번호</p>

							<h2 class="tMar1-8r">2. 수집 목적</h2>
							<ol>
								<li>① e-mail, 전화번호: 고지의 전달. 불만처리나 주문/배송정보 안내 등 원활한 의사소통 경로의 확보.</li>
								<li>② 성명, 주소: 고지의 전달, 청구서, 정확한 상품 배송지의 확보.</li>
								<li>③ 은행계좌번호: 구매상품에 대한 환불시 확보.</li>
							</ol>

							<h2 class="tMar1-8r">3. 개인정보 보유기간</h2>
							<ol>
								<li>① 계약 또는 청약철회 등에 관한 기록 : 5년</li>
								<li>② 대금결제 및 재화 등의 공급에 관한 기록 : 5년</li>
								<li>③ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
							</ol>
						</div>
					</div>
					<div class="btnAreaV16a">
						<p><button type="button" class="btnV16a btnRed1V16a" onclick="chkAgreement();">동의하고 비회원 구매하기</button></p>
					</div>
				</div>
				</form>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/inc/incLogScript.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
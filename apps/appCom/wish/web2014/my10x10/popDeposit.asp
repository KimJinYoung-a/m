<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.deposit-guide {padding:2.13rem 1.62rem 0;}
.deposit-guide li {position:relative; padding-left:0.8rem; font-size:1.1rem; line-height:1.7; color:#676767; word-break:keep-all;}
.deposit-guide li + li {margin-top:0.3rem;}
.deposit-guide li:before {content:' '; display:inline-block; position:absolute; left:0; top:0.85rem; width:0.38rem; height:1px; background:#676767;}
</style>
</head>
<body class="default-font">
<div class="content">
	<div class="deposit-guide">
		<ul>
			<li>텐바이텐 온라인 쇼핑몰에서 반품/취소 시 해당 반환 금액을 현금처럼 사용 가능한 예치금으로 돌려 드립니다.</li>
			<li>예치금은 사용 유효기간이 없으며 최소 구매 금액 제한 없이 사용 가능합니다.</li>
			<li>예치금은 현금 반환 신청이 가능하며  신청일 기준 약 2-3일 내 모든 반환 처리가 완료됩니다.</li>
		</ul>
		<a href="" onclick="fnAPPpopupBrowserURL('예치금 반환 신청','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/deposit/depositapply.asp'); return false;" class="btn btn-xlarge btn-block cRd1V16a tMar1-8r" style="border-color:#ff3131;">예치금 반환 신청</a>
	</div>
</div>
</body>
</html>
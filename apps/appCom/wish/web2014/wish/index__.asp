<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'// 페이지 타이틀
	strPageTitle = ""
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
		EVENT
		<p><p>
			<a href="javascript:fnAPPpopupCategory('101','','','디자인문구','','');">카테고리:디자인문구</a>
			<p>
			<a href="javascript:fnAPPpopupCategory('101','101103','','디자인문구','노트/메모지','');">카테고리:디자인문구-노트/메모지</a>
			<p>
			<a href="javascript:fnAPPpopupCategory('101','101109','','디자인문구','데스크 정리/보관','');;">카테고리:디자인문구-데스크 정리/보관</a>
			<p>
			<a href="javascript:fnAPPpopupProduct('1124168');">상품팝업</a>
			<p>
			<a href="javascript:fnAPPpopupProduct('1124164');">상품팝업</a>
			<p>
			<a href="javascript:fnAPPpopupEvent('54326');">이벤트팝업</a>
			<p>
			<a href="javascript:fnAPPpopupEvent('54871');">이벤트팝업</a>
			<p>
			<a href="javascript:fnAPPpopupBrand('mmmg');">브랜드팝업</a>
			<p>
			<a href="javascript:fnAPPpopupBrand('7321');">브랜드팝업</a>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
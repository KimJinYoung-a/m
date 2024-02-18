<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<title>10x10: 상품 검색</title>
<%
	dim retUrl, vTotalCount
	retUrl = request.ServerVariables("HTTP_REFERER")

	'// 인기검색어
	DIM oPpkDoc, arrPpk, arrTg, SearchText
	SET oPpkDoc = New SearchItemCls
		oPpkDoc.FPageSize = 8
		'arrPpk = oPpkDoc.getPopularKeyWords()			'일반형태
		oPpkDoc.getPopularKeyWords2 arrPpk,arrTg		'순위정보 포함
	SET oPpkDoc = NOTHING 
%>
<script type="text/javascript">
	$(function(){
		fnAmplitudeEventMultiPropertiesAction("view_search_main","","");
	});
</script>
<script type="text/javascript" src="/lib/js/SearchAutoComplete2017.js?v=1.2"></script>
</head>
<body class="default-font searchindex">
	<!-- #include virtual="/search/inc_searchform.asp" -->
	<div class="search-content">
		<nav class="nav-search">
			<ul>
				<li class="category"><a href="/search/dispnamelist.asp" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_main','action','category');>카테고리 검색</a></li>
				<li class="brand"><a href="/search/brandlist.asp" onclick=fnAmplitudeEventMultiPropertiesAction('click_search_main','action','brand');>브랜드 검색</a></li>
			</ul>
		</nav>
		<section class="searching-keyword">
			<h2>인기 검색어</h2>
			<div class="list-roundbox">
			<%
				If isArray(arrPpk)  THEN
					If Ubound(arrPpk)>0 then
						For mykeywordloop=0 To UBOUND(arrPpk)
							if trim(arrPpk(mykeywordloop))<>"" then
								Response.Write "<a href=""/search/search_item.asp?rect=" & Server.URLEncode(arrPpk(mykeywordloop)) & "&burl=" & Server.URLEncode(retUrl) & """ onclick=fnAmplitudeEventMultiPropertiesAction('click_search_main','action','hotkeyword');>"
								Response.Write arrPpk(mykeywordloop) & "</a>" & vbCrLf
							end if
						Next
					End If
				End If
			%>
			</div>
		</section>
	</div>
	<div id="mask" style="overflow:hidden; display:none; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
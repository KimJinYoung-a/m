<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	Dim vSScrnGubun, vSScrnMasking
	vSScrnMasking = fnMaskingImage()
	vSScrnGubun = Split(vSScrnMasking,"$$")(0)
	vSScrnMasking = Split(vSScrnMasking,"$$")(1)
	If vSScrnGubun = "i" Then
		vSScrnMasking = "style=""background-image:url(" & vSScrnMasking & ");"""
	ElseIf vSScrnGubun = "c" Then
		vSScrnMasking = "style=""background-color:#" & vSScrnMasking & ";"""
	End If
%>
<script type="text/javascript">
$(function(){
	jsGetBrandList("가");
});

function jsGetBrandList(w){
	$.ajax({
		url: "/search/act_brandlist.asp?word="+w,
		cache: false,
		async: false,
		success: function(message) {
			$("#searchcontent").empty().html(message);
			$("body,html").animate({scrollTop:0}, "fast");
		}
	});
}

function jsBrandSearch(){
	if($("#rect").val() == ""){
		alert("브랜드명을 입력해주세요.");
		return false;
	}
}
</script>
</head>
<body class="default-font">
	<header id="headerSearch" class="header-search-bg header-search-brand">
		<div class="btn-back"><a href="" onclick="history.back(); return false;">이전</a></div>
		<div class="bg" <%=vSScrnMasking%>></div>
		<h1>브랜드 검색</h1>
		<h1 class="heading">브랜드 검색</h1>
	</header>
	<div id="searchcontent" class="search-content search-content-brand">
	</div>
	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
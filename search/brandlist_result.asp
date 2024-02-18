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


	Dim DocSearchText, DocSearchWord, vInitialSlide, vBrandList
	Dim CurrPage, PageSize, lp, vResultCount
	Dim oBrand

	DocSearchText	 = requestCheckVar(request("rect"),100)
	DocSearchWord	 = NullFillWith(requestCheckVar(request("word"),1),"가")
	CurrPage		= NullFillWith(getNumeric(requestCheckVar(request("cpg"),8)),1)

	'// 이벤트 검색결과
	set oBrand = new SearchBrandCls
	oBrand.FRectSearchTxt = DocSearchText
	oBrand.FRectWord = DocSearchWord
	oBrand.FCurrPage = CurrPage
	oBrand.FPageSize = "10"
	oBrand.FScrollCount = 10
	oBrand.getBrandList
	
	vResultCount = oBrand.FResultCount

	if oBrand.FResultCount>0 then
		FOR lp = 0 to oBrand.FResultCount-1
			vBrandList = vBrandList & "<li><a href=""/street/street_brand.asp?makerid=" & oBrand.FItemList(lp).Fuserid & """>" & fnFullNameDisplay(oBrand.FItemList(lp).Fsocname_kor,DocSearchText)
			If oBrand.FItemList(lp).Fhitflg = "Y" Then
				vBrandList = vBrandList & " <span class=""label label-line"">BEST</span></a>"
			End If
			vBrandList = vBrandList & "</a></li>" & vbCrLf
		Next
	End If

	Set oBrand = nothing
%>
<script type="text/javascript">
var vPg=1, vScrl=true;
$(function(){
	$(window).scroll(function() {
		var y = $(window).scrollTop();
		if (y > 0) {
			$(".search-content-brand-list").addClass("sticky");
			$("#headerSearch").addClass('header-small');
		} else if (y < 10) {
			$(".search-content-brand-list").removeClass("sticky");
			$("#headerSearch").removeClass('header-small');
		}
		
		
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				<% If vBrandList <> "" Then %>
				$("#lyLoading").show()
				<% End If %>
				vScrl = false;
				vPg++;
				$.ajax({
					type: "POST",
					url: "/search/act_brandlist_result.asp?rect=<%=DocSearchText%>&cpg="+vPg,
					data: $("#bfrm").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#searchResult").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
							$("#lyLoading").hide()
						}
					}
				});
			}
		}
	});
});
</script>
</head>
<body class="default-font">
	<header id="headerSearch" class="header-search-bg header-search-brand">
		<div class="btn-back"><a href="" onclick="history.back(); return false;">이전</a></div>
		<div class="bg" <%=vSScrnMasking%>></div>
		<h1>브랜드 검색</h1>
		<h1 class="heading">브랜드 검색</h1>
	</header>
	<div id="searchcontent" class="search-content search-content-brand-list">
		<div id="searchbar" class="searchbar searchbar-round">
			<form id="bfrm" name="bfrm" method="get" action="brandlist_result.asp" onSubmit="return jsBrandSearch();">
				<fieldset>
				<legend class="hidden">브랜드 검색 폼</legend>
				<div class="textfield">
					<input type="search" id="rect" name="rect" value="<%=DocSearchText%>" title="브랜드명 입력" onKeyPress="if (event.keyCode == 13){ bfrm.submit;}" autocomplete="off" placeholder="브랜드명을 입력해주세요" />
					<button type="reset" class="btn-reset">리셋</button>
				</div>
				</fieldset>
			</form>
		</div>
		<% If vResultCount > 0 Then %>
		<div class="list-line search-result-list search-result-brand">
			<ul id="searchResult">
				<%=vBrandList%>
			</ul>
		</div>
		<% Else %>
		<div class="nodata nodata-search">
			<p><b>아쉽게도 일치하는 내용이 없습니다</b></p>
			<p>품절 또는 종료된 경우에는 검색되지 않습니다</p>
		</div>
		<% End If %>
		<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
	</div>
</body>
</html>
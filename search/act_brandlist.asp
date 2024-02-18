<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	Dim DocSearchText, DocSearchWord, vInitialSlide, vBrandList
	Dim CurrPage, PageSize, lp
	Dim oBrand

	DocSearchText	 = requestCheckVar(request("rect"),100)
	DocSearchWord	 = NullFillWith(requestCheckVar(request("word"),1),"가")
	CurrPage		= NullFillWith(getNumeric(requestCheckVar(request("cpg"),8)),1)
	PageSize		= requestCheckVar(request("psz"),5)

	Select Case DocSearchWord
		case "가", "나", "다", "라", "마", "바", "사"
			vInitialSlide = "0"
		case else
			vInitialSlide = "6"
	End Select

        
	set oBrand = new SearchBrandCls
	oBrand.FRectSearchTxt = DocSearchText
	oBrand.FRectWord = DocSearchWord
	oBrand.FCurrPage = CurrPage
	oBrand.FPageSize = "600"
	oBrand.FScrollCount = 10
	oBrand.getBrandList

	if oBrand.FResultCount>0 then
		FOR lp = 0 to oBrand.FResultCount-1
			vBrandList = vBrandList & "<li><a href=""/street/street_brand.asp?makerid=" & oBrand.FItemList(lp).Fuserid & """>" & oBrand.FItemList(lp).Fsocname_kor
			If oBrand.FItemList(lp).Fhitflg = "Y" Then
				vBrandList = vBrandList & " <span class=""label label-line"">BEST</span></a>"
			End If
			vBrandList = vBrandList & "</a></li>" & vbCrLf
		Next
	End If

	Set oBrand = nothing
%>
<script type="text/javascript">
$(function(){
	/* filter for brand swipe */
	var filterbrandSwiper = new Swiper("#filterBrand .swiper-container", {
		slidesPerView:"auto",
		initialSlide:<%=vInitialSlide%>
	});

	$(window).scroll(function() {
		var y = $(window).scrollTop();
		if (y > 55) {
			$(".search-content-brand").addClass("sticky");
			$("#headerSearch").addClass("header-small");
		} else {
			$(".search-content-brand").removeClass("sticky");
			$("#headerSearch").removeClass("header-small");
		}
	});
});
</script>
<div id="filterBrand" class="filter-brand">
	<div class="swiper-container">
		<ol class="swiper-wrapper">
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('가'); return false;" <%=CHKIIF(DocSearchWord="가","class=""on""","")%>>ㄱ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('나'); return false;" <%=CHKIIF(DocSearchWord="나","class=""on""","")%>>ㄴ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('다'); return false;" <%=CHKIIF(DocSearchWord="다","class=""on""","")%>>ㄷ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('라'); return false;" <%=CHKIIF(DocSearchWord="라","class=""on""","")%>>ㄹ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('마'); return false;" <%=CHKIIF(DocSearchWord="마","class=""on""","")%>>ㅁ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('바'); return false;" <%=CHKIIF(DocSearchWord="바","class=""on""","")%>>ㅂ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('사'); return false;" <%=CHKIIF(DocSearchWord="사","class=""on""","")%>>ㅅ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('아'); return false;" <%=CHKIIF(DocSearchWord="아","class=""on""","")%>>ㅇ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('자'); return false;" <%=CHKIIF(DocSearchWord="자","class=""on""","")%>>ㅈ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('차'); return false;" <%=CHKIIF(DocSearchWord="차","class=""on""","")%>>ㅊ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('카'); return false;" <%=CHKIIF(DocSearchWord="카","class=""on""","")%>>ㅋ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('타'); return false;" <%=CHKIIF(DocSearchWord="타","class=""on""","")%>>ㅌ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('파'); return false;" <%=CHKIIF(DocSearchWord="파","class=""on""","")%>>ㅍ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('하'); return false;" <%=CHKIIF(DocSearchWord="하","class=""on""","")%>>ㅎ</a></li>
			<li class="swiper-slide"><a href="" onClick="jsGetBrandList('Ω'); return false;" <%=CHKIIF(DocSearchWord="Ω","class=""on""","")%>>etc</a></li>
		</ol>
	</div>
</div>
<div id="searchbar" class="searchbar searchbar-round">
	<form id="bfrm" name="bfrm" method="get" action="brandlist_result.asp" onSubmit="return jsBrandSearch();">
		<fieldset>
		<legend class="hidden">브랜드 검색 폼</legend>
		<div class="textfield">
			<input type="search" id="rect" name="rect" title="브랜드명 입력" onKeyPress="if (event.keyCode == 13){ bfrm.submit;}" autocomplete="off" placeholder="브랜드명을 입력해주세요" />
			<button type="reset" class="btn-reset">리셋</button>
		</div>
		</fieldset>
	</form>
</div>
<div id="navBrand" class="list-search-brand">
	<h2 class="index"><%=fnFirstCharacter(DocSearchWord)%></h2>
	<ul class="list-line">
		<%=vBrandList%>
	</ul>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
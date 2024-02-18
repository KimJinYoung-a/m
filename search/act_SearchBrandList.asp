<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
	Dim DocSearchText, SortMet, SearchItemDiv, ListDiv
	Dim CurrPage, PageSize, lp
	Dim oGrBrn ''//브랜드

	DocSearchText	 = requestCheckVar(request("rect"),100)
	SortMet			 = requestCheckVar(request("srm"),3)
	SearchItemDiv	 = "y"			'기본 카테고리만
	ListDiv			 = "search"		'검색 구분
	CurrPage		= getNumeric(requestCheckVar(request("cpg"),8))
	PageSize		= requestCheckVar(request("psz"),5)

	if CurrPage="" then CurrPage="1"
	if SortMet="" then SortMet="be"
	if PageSize="" then PageSize="20"  ''2016/06/16 추가

	'// 브랜드별 검색결과
	set oGrBrn = new SearchItemCls
	oGrBrn.FRectSearchTxt = DocSearchText
	oGrBrn.FRectSortMethod = SortMet
	oGrBrn.FRectSearchItemDiv = SearchItemDiv
	oGrBrn.FCurrPage = CurrPage
	oGrBrn.FPageSize = PageSize
	oGrBrn.FScrollCount =10
	oGrBrn.FListDiv = ListDiv
	oGrBrn.FLogsAccept = False
	oGrBrn.getGroupbyBrandList

	if oGrBrn.FResultCount>0 then

		for lp=0 to oGrBrn.FResultCount-1
%>
	<li><a href="/street/street_brand.asp?makerid=<%=oGrBrn.FItemList(lp).FMakerID%>"><span><%=oGrBrn.FItemList(lp).FBrandName%> (<%=formatNumber(oGrBrn.FItemList(lp).FItemScore,0)%>) <% if oGrBrn.FItemList(lp).FisBestBrand="Y" then %><em class="icoHot">BEST</em><% End If %></span></a></li>
<%
		next
	End If

	Set oGrBrn = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


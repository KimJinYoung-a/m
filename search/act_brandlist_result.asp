<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	Dim DocSearchText, DocSearchWord, vInitialSlide, vBrandList, vSort
	Dim CurrPage, PageSize, lp, vResultCount, vBrandName
	Dim oBrand

	DocSearchText	 = requestCheckVar(request("rect"),100)
	DocSearchWord	 = NullFillWith(requestCheckVar(request("word"),1),"가")
	CurrPage		 = NullFillWith(getNumeric(requestCheckVar(request("cpg"),8)),1)
	vSort			 = NullFillWith(requestCheckVar(request("sort"),30),"sort_kor")
	PageSize		= 10
	

	'// 브랜드 검색결과
	set oBrand = new SearchBrandCls
	oBrand.FRectSearchTxt = DocSearchText
	oBrand.FRectWord = DocSearchWord
	oBrand.FCurrPage = CurrPage
	oBrand.FPageSize = PageSize
	oBrand.FScrollCount = 10
	oBrand.FRectSort = vSort
	oBrand.getBrandList
	
	vResultCount = oBrand.FResultCount

	if oBrand.FResultCount>0 then
		FOR lp = 0 to oBrand.FResultCount-1
		
			vBrandName = fnFullNameDisplay(oBrand.FItemList(lp).Fsocname_kor,DocSearchText)
			
			vBrandList = vBrandList & "<li><a href=""/street/street_brand.asp?makerid=" & oBrand.FItemList(lp).Fuserid & """>" & vBrandName

			If oBrand.FItemList(lp).Fhitflg = "Y" Then
				vBrandList = vBrandList & " <span class=""label label-line"">BEST</span></a>"
			End If
			vBrandList = vBrandList & "</a></li>"
		Next
	End If

	Set oBrand = nothing
	
	Response.Write vBrandList
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
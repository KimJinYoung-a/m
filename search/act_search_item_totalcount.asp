<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%
	Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim SearchFlag : SearchFlag = NullFillWith(requestCheckVar(request("sflag"),2),"n")
	dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
	
	dim ListDiv : ListDiv = "search" '카테고리/검색 구분용
	dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
	dim deliType : deliType = requestCheckVar(request("deliType"),2)
	dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
	If retUrl = "" Then retUrl = wwwUrl End If

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
	dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
	dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
	dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))

	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
	dim DocSearchText

	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword
	Dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부 X => procMySearchKeyword(쿠키)

	Dim vCateDepth, vWishArr, search_on, vListOption, vRealResearch
	
	search_on = requestCheckVar(request("search_on"),2)
	vListOption = NullFillwith(requestCheckVar(request("listoption"),10),"all")

	if dispCate<>"" then
		vCateDepth = cStr(len(dispCate)\3)+1			'하위 뎁스
	else
		vCateDepth = "1"
	end if
	if vCateDepth>3 then vCateDepth=3

	If mode = "" Then mode = "L"

	dim ScrollCount : ScrollCount = 4
	if CurrPage="" then CurrPage=1
	If mode = "L" then
		'### 1줄에 1개
		if PageSize="" then PageSize=15
	Else
		'### 1줄에 2개
		if PageSize="" then PageSize=30
	End If

	'if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne


	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")
	ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\_\s]","")

	IF CheckReSearch Then
		''ReSearchText = ReSearchText & " " & SearchText

		ReSearchText = RepWord(ReSearchText,SearchText,"")
		ReSearchText = RepWord(ReSearchText,"[\s]{2,}"," ")
		ReSearchText = RepWord(ReSearchText,"^[+\s]","")
		vRealResearch = ReSearchText
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		'ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if
	
	'### 실제 입력한 결과내검색어
	ReSearchText = vRealResearch

	'특정 단어 삭제
	DocSearchText = Trim(Replace(DocSearchText,"상품",""))

	IF Len(DocSearchText)<>0 and isNumeric(DocSearchText) THEN
		If Left(DocSearchText,1) <> "0" Then
			DocSearchText = Cdbl(DocSearchText)
		End If
	'	DocSearchText = Cdbl(DocSearchText)
	END IF

	'// 검색어 DB저장
	tmpPrevSearchKeyword = PrevSearchText
	tmpCurrSearchKeyword = SearchText

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText


	'// 상품검색
	dim oDoc, vTotalCount
	set oDoc = new SearchItemCls
	oDoc.FRectSearchTxt = DocSearchText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag = fnSalePojang(searchFlag,pojangok)
	oDoc.FRectSearchItemDiv = SearchItemDiv
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectSearchCateDep = SearchCateDep
	oDoc.FRectMakerid	= fnCleanSearchValue(makerid)
	oDoc.FminPrice	= minPrice
	oDoc.FmaxPrice	= maxPrice
	oDoc.FdeliType	= deliType
	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
	oDoc.FScrollCount = ScrollCount
	oDoc.FListDiv = ListDiv
	oDoc.FLogsAccept = LogsAccept
	oDoc.FRectColsSize = 6
	oDoc.FcolorCode = fnCleanSearchValue(colorCD)
	oDoc.FSellScope=SellScope
	oDoc.FstyleCd = fnCleanSearchValue(styleCd)
	oDoc.getTotalCount

	vTotalCount = oDoc.FTotalCount
set oDoc = Nothing

Response.Write FormatNumber(vTotalCount,0)
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
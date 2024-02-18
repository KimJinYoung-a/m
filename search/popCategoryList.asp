<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/memcacheLib.asp" -->
<%
	Dim oGrCat

	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = request("srm")
	dim SearchFlag : SearchFlag = request("sflag")
	dim ListDiv : ListDiv = "search" '카테고리/검색 구분용 
	dim minPrice : minPrice = requestCheckVar(request("minPrc"),8)
	dim maxPrice : maxPrice = requestCheckVar(request("maxPrc"),8)
	dim deliType : deliType = request("deliType")
	dim colorCD : colorCD = request("iccd")
	dim CurrPage : CurrPage = request("cpg")
	dim PageSize	: PageSize = requestCheckVar(request("psz"),5)
	dim LogsAccept : LogsAccept = true
	dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
	dim makerid : makerid = request("mkr")
	dim lp, i
	Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)

	dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "N"
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
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부
	
	Dim vCateDepth

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
		if PageSize="" then PageSize=12
	Else
		if PageSize="" then PageSize=12
	End If 

	if colorCD="" then colorCD="0"
	if SortMet="" then SortMet="ne"		'베스트:be, 신상:ne


	if CheckResearch="undefined" then CheckResearch=""
	if len(CheckResearch)>5 then CheckResearch=""
	IF CheckResearch="" then CheckResearch=false
	if CheckExcept="undefined" then CheckExcept=""
	if len(CheckExcept)>5 then CheckExcept=""
	IF CheckExcept="" then CheckExcept=false

	SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\s]","")
	ExceptText = RepWord(ExceptText,"[^가-힣a-zA-Z0-9.&%\-\s]","")

	IF CheckReSearch Then
		ReSearchText = ReSearchText & " " & SearchText

		ReSearchText = RepWord(ReSearchText,SearchText,"")
		ReSearchText = RepWord(ReSearchText,"[\s]{2,}"," ")
		ReSearchText = RepWord(ReSearchText,"^[+\s]","")
		ReSearchText = ReSearchText & " " & SearchText
		DocSearchText = ReSearchText
	Else
		ReSearchText  =	SearchText
		DocSearchText = SearchText
	End if

	if CheckExcept then
		ReSearchText  =	ReSearchText
		DocSearchText = ReSearchText
		SearchText = ExceptText
	end if

	IF Len(DocSearchText)<>0 and isNumeric(DocSearchText) THEN
		If Left(DocSearchText,1) <> "0" Then
			DocSearchText = Cdbl(DocSearchText)
		End If
	'	DocSearchText = Cdbl(DocSearchText)
	END IF

	'// 카테고리별 검색결과
	set oGrCat = new SearchItemCls
	oGrCat.FRectSearchTxt = SearchText
	oGrCat.FRectSortMethod = SortMet
	oGrCat.FRectSearchFlag = searchFlag
	oGrCat.FRectSearchItemDiv = SearchItemDiv
	oGrCat.FRectSearchCateDep = SearchCateDep
	oGrCat.FCurrPage = 1
	oGrCat.FPageSize = 200
	oGrCat.FScrollCount =10
	oGrCat.FListDiv = ListDiv
	oGrCat.FminPrice	= minPrice
	oGrCat.FmaxPrice	= maxPrice
	oGrCat.FdeliType	= deliType
	oGrCat.FcolorCode	= colorCD
	oGrCat.FRectCateCode = left(dispCate,3*vCateDepth-1)	'추가
	oGrCat.FSellScope=SellScope
	oGrCat.FGroupScope = vCateDepth
	oGrCat.FLogsAccept = False '그룹형은 절대 !!! False 
	oGrCat.getGroupbyCategoryList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 카테고리 선택</title>
<script type="text/javascript">
function goResultPg(disp) {
	location.replace("/search/search_item.asp?rect=<%=server.URLEncode(SearchText)%>&prvtxt=<%=server.URLEncode(SearchText)%>&dispCate="+disp+"&burl=<%=server.UrlEncode(retUrl)%>");
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('<%=wwwUrl%>/category/category_list.asp?disp=101'); return false;">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="categoryListup">
				<ul>
				<% If oGrCat.FResultCount>0 Then %>
					<% FOR lp = 0 to oGrCat.FResultCount-1 %>
					<li><a href="" onclick="goResultPg('<%= left(oGrCat.FItemList(lp).FCateCode,vCateDepth*3) %>'); return false;"><%= splitValue(oGrCat.FItemList(lp).FCateName,"^^",(vCateDepth-1)) &" ("& oGrCat.FItemList(lp).FSubTotal &")" %></a></li>
					<% Next %>
				<% end if %>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<% set oGrCat = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
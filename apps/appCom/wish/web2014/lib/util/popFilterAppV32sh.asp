<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
	'// 페이지 타이틀
	strPageTitle = ""
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<%
'' 앱과 통신에서만 사용됨. 인클루드 부분 바뀌어야 함.

dim filter : filter = request("filter")
dim oJsonResult

dim DocSearchText
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
dim deliType : deliType = requestCheckVar(request("deliType"),2)
dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
dim styleCD : styleCD = CStr(ReplaceRequestSpecialChar(request("styleCd")))
dim colorCD : colorCD = CStr(requestCheckVar(request("iccd"),128))
dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
dim offset : offset = requestCheckVar(request("offset"),10)
dim vListOption : vListOption = NullFillwith(requestCheckVar(request("listoption"),10),"all")



''기존 필터를 통으로 받음.
dim sortMtd
if (filter<>"") then
    set oJsonResult = JSON.parse(filter)
    call getParseFilterV32(oJsonResult, SearchText, SellScope, deliType, SearchFlag, pojangok, mode, SortMet, dispCate, makerid, styleCD, colorCD, minPrice, maxPrice, ReSearchText, offset, vListOption)
	set oJsonResult = Nothing
end if
'SearchText = "가방"
'dispCate = "101"
	If makerid <> "" Then
		makerid = "," & makerid & ","
	End IF
	
	If styleCD <> "" Then
		styleCD = "," & styleCD & ","
	End IF
	
	If colorCD <> "" Then
		colorCD = "," & colorCD & ","
	End IF


	if SearchFlag = "" then SearchFlag = "n"
	Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim ListDiv : ListDiv = "list" '카테고리/검색 구분용
	if (makerid<>"") then ListDiv="brand"
	if (SearchText<>"") then ListDiv="search"
	dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
	dim LogsAccept : LogsAccept = true
	dim lp, i
	Dim retUrl : retUrl = requestCheckVar(request("burl"),256)
	If retUrl = "" Then retUrl = wwwUrl End If
	if SellScope = "" then SellScope = "Y"
	if (SellScope="") then
	    if (ListDiv="brand") then
	    
	    else
	        SellScope="Y"
	    end if
	end if
	
	dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
	dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))
	dim CheckResearch : CheckResearch= request("chkr")
	dim CheckExcept : CheckExcept= request("chke")
	dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
	
	Dim tmpPrevSearchKeyword , tmpCurrSearchKeyword
	Dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
	Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부 X => procMySearchKeyword(쿠키)
	Dim vCateDepth, vWishArr, search_on, vRealResearch

	search_on = requestCheckVar(request("search_on"),2)

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

	IF ReSearchText <> "" Then
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

	dim oGrCat,rowCnt ''//카테고리
	Dim oGrEvt ''//이벤트

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

    '// 검색 조건 재설정 //2015/03/12 추가 (기존에 없었음)
    PrevSearchText = SearchText
    
    dim oDoc, iLp, objCmd, returnValue, vTotalCount
    
	'// 상품검색
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
	oDoc.getSearchList
	
	vTotalCount = oDoc.FTotalCount
	set oDoc = Nothing


dim userid : userid=getLoginUserid
dim IS_SHOWDEVMSG : IS_SHOWDEVMSG = false

if (userid="icommang" or userid="fun" or userid="qpark99" or userid="okkang77") then
    IS_SHOWDEVMSG = true
end if

'IS_SHOWDEVMSG = FALSE
'// 바로배송 표시여부
Dim showQuickDivStatus
showQuickDivStatus = FALSE
If now() > #07/31/2019 12:00:00# Then
	showQuickDivStatus = FALSE
Else
	showQuickDivStatus = TRUE
End If
%>
<script src="/apps/appCom/wish/web2014/lib/js/jquery.nouislider.min.js"></script>

</head>
<body class="default-font">
<form name="sFrm" id="listSFrm" method="get" action="/search/search_item.asp" style="margin:0px;">
<input type="hidden" name="search_on" value="on">
<input type="hidden" id="rect" name="rect" value="<%= SearchText %>">
<input type="hidden" id="rstxt" name="rstxt" value="<%= ReSearchText %>">
<input type="hidden" id="sflag" name="sflag" value="<%= SearchFlag  %>">
<input type="hidden" id="dispCate" name="dispCate" value="<%= dispCate %>">
<input type="hidden" id="cpg" name="cpg" value="<%=CurrPage%>">
<input type="hidden" id="chkr" name="chkr" value="<%= CheckResearch %>">
<input type="hidden" name="chke" value="<%= CheckExcept %>">
<input type="hidden" id="mkr" name="mkr" value="<%= makerid %>">
<input type="hidden" id="sscp" name="sscp" value="<%= SellScope %>">
<input type="hidden" name="psz" value="<%= PageSize %>">
<input type="hidden" id="srm" name="srm" value="<%= SortMet %>">
<input type="hidden" id="iccd" name="iccd" value="<%=colorCD%>">
<input type="hidden" id="styleCd" name="styleCd" value="<%=styleCd%>">
<input type="hidden" name="attribCd" value="<%=attribCd%>">
<input type="hidden" name="mode" id="mode" value="<%=mode%>">
<input type="hidden" name="arrCate" value="<%=arrCate%>">
<input type="hidden" id="deliType" name="deliType" value="<%=deliType%>">
<input type="hidden" id="minPrc" name="minPrc" value="<%=minPrice%>">
<input type="hidden" id="maxPrc" name="maxPrc" value="<%=maxPrice%>">
<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
<input type="hidden" name="burl" value="<%=retUrl%>">
<input type="hidden" name="itemid" value="">
<input type="hidden" name="ErBValue" value="99">
<input type="hidden" name="listoption" value="<%=vListOption%>">
<input type="hidden" id="pojangok" name="pojangok" value="<%= pojangok %>">
</form>
<%
Dim vSelectedFilter, vSelectedPreHtml
vSelectedPreHtml = "<li class=swiper-slide><button type=button class=btn-del"
%>
<div id="searchFilter" class="search-filter fixed-bottom" style="display:block; height:100%;">
	<div class="ly-header">
		<h2>필터</h2>
		<button type="reset" class="btn-reset" onClick="jsGoDefaultSetting(); return false;">초기화</button>
	</div>
	<div class="inner">
		<div class="ly-contents">
			<div class="scrollwrap">
				<!-- 빠른 메뉴 -->
				<div class="panel quickmenu">
					<div class="hgroup">
						<h3>빠른메뉴</h3>
						<div class="option">
							<ul class="value">
								<li><button type="button" <%=CHKIIF(SellScope="N","class=""on""","")%> id="fastpum" onClick="jsFastOnOff('pum');">품절상품 포함</button></li>
								<li><button type="button" <%=CHKIIF(deliType="TN","class=""on""","")%> id="fasttendeli" onClick="jsDeliverySearch('TN');">텐바이텐 배송</button></li>
								<li><button type="button" <%=CHKIIF(SearchFlag="sc","class=""on""","")%> id="fastsale" onClick="jsFastOnOff('sale');">세일중인 상품</button></li>
								<li><button type="button" <%=CHKIIF(pojangok="o","class=""on""","")%> id="fastpojang" onClick="jsFastOnOff('pojang');">선물포장 가능</button></li>
							</ul>
						</div>
					</div>
				</div>
				<%
				If SellScope = "N" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pum');>품절상품 포함</button></li>"
				End If
				If deliType = "TN" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('TN');>텐바이텐 배송</button></li>"
				End If
				If SearchFlag = "sc" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('sale');>세일중인 상품</button></li>"
				End If
				If pojangok = "o" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pojang');>선물포장 가능</button></li>"
				End If
				%>
				<!-- 보기 옵션 -->
				<div class="panel viewoption">
					<div class="hgroup">
						<h3>보기 옵션</h3>
						<div class="option">
							<ul class="value">
								<li><button type="button" class="icon-list <%=CHKIIF(mode="L","on","")%>" onClick="jsViewoption('L');">리스트형</button></li>
								<li><button type="button" class="icon-grid <%=CHKIIF(mode="S","on","")%>" onClick="jsViewoption('S');">격자형</button></li>
							</ul>
						</div>
					</div>
				</div>

<%
	Dim vDispTitle
	If dispcate <> "" Then
		vDispTitle = fnGetDispName(dispcate)
		vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('disp');>" & vDispTitle & "</button></li>"
	End If
%>
				<div id="filterCategory" class="panel category">
					<div class="hgroup" onclick="jsFilterShow('Category');">
						<a href="#filterCategory">
							<h3>카테고리</h3>
							<div class="option">
								<p class="value" id="disptitle"><%=vDispTitle%></p>
							</div>
						</a>
					</div>
					<div class="panelcont">
						<div id="navCategory">
						</div>
					</div>
				</div>
<%
	
	'// 브랜드 검색결과
	Dim oBrand, vBrandTitle, vBrandList, vTitleCnt
	vTitleCnt = 0
	set oBrand = new SearchItemCls
	oBrand.FRectSearchTxt = DocSearchText
	oBrand.FRectSortMethod	= SortMet
	oBrand.FRectSearchFlag = "n"
	oBrand.FRectSearchItemDiv = SearchItemDiv
	oBrand.FRectSearchCateDep = SearchCateDep
	oBrand.FCurrPage = 1
	oBrand.FPageSize = 30
	oBrand.FScrollCount = 10
	oBrand.FListDiv = ListDiv
	oBrand.FLogsAccept = False
	oBrand.FRectColsSize = 6
	oBrand.FSellScope="Y"
	oBrand.getGroupbyBrandList
	
	if oBrand.FResultCount>0 then
%>
				<div id="filterBrand" class="panel brand">
					<div class="hgroup" onclick="jsFilterShow('Brand');">
						<a href="#filterBrand">
							<h3>브랜드</h3>
							<div class="option">
								<p class="value" id="filterbrandtitle"></p>
							</div>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 multi-select" id="filterbrandlist">
						<%
						FOR lp = 0 to oBrand.FResultCount-1
							vBrandList = vBrandList & "<li><a href="""" id=""filterbrand"&lp&""" "
							If chkArrValue(makerid,oBrand.FItemList(lp).FMakerID) Then
								vBrandList = vBrandList & " class=""on"" "
								vTitleCnt = vTitleCnt + 1
								If vTitleCnt = 1 Then
									vBrandTitle = oBrand.FItemList(lp).FBrandName
								End If
							End If
							vBrandList = vBrandList & "onclick=""jsSelectFilterSomething('brand','filterbrand"&lp&"','"&oBrand.FItemList(lp).FMakerID&"','mkr'); return false;"">" & oBrand.FItemList(lp).FBrandName
							If oBrand.FItemList(lp).FisBestBrand = "Y" Then
								vBrandList = vBrandList & " <span class=""label label-line"">BEST</span></a>"
							End If
							vBrandList = vBrandList & "</a></li>"
						Next
						
						Response.Write vBrandList
						
						vBrandTitle = vBrandTitle & CHKIIF(vTitleCnt>1," 외 " & vTitleCnt-1 & "건","")
						%>
						</ul>
					</div>
				</div>
<%
		'### 브랜드 선택된거 타이틀과, 선택된항목버튼 셋팅
		If vBrandTitle <> "" Then
			vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('brand');>" & vBrandTitle & "</button></li>"
			vBrandTitle = "$(""#filterbrandtitle"").text(""" & vBrandTitle & """);"
		End If
	End If
	
	Set oBrand = nothing
	
	'//스타일 검색결과
	dim oGrStl, vStyleTitle, vStyleList
	vTitleCnt = 0
	set oGrStl = new SearchItemCls
	oGrStl.FRectSearchTxt = DocSearchText
	oGrStl.FRectSearchFlag = "n"
	oGrStl.FRectSearchItemDiv = SearchItemDiv
	oGrStl.FRectSearchCateDep = SearchCateDep
	oGrStl.FCurrPage = 1
	oGrStl.FPageSize = 10
	oGrStl.FScrollCount =10
	oGrStl.FListDiv = ListDiv
	oGrStl.FSellScope="Y"			'판매/품절상품 포함 여부
	oGrStl.FLogsAccept = False

	oGrStl.getGroupbyStyleList
	
	If oGrStl.FResultCount>0 Then
%>
				<div id="filterStyle" class="panel style">
					<div class="hgroup" onclick="jsFilterShow('Style');">
						<a href="#filterStyle">
							<h3>스타일</h3>
							<div class="option">
								<p class="value" id="filterstyletitle"></p>
							</div>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 multi-select" id="filterstylelist">
						<%
						FOR lp = 0 to oGrStl.FResultCount-1
							vStyleList = vStyleList & "<li><a href="""" id=""filterstyle"&lp&""" "
							If chkArrValue(styleCd,oGrStl.FItemList(lp).FStyleCd) Then
								vStyleList = vStyleList & " class=""on"" "
								vTitleCnt = vTitleCnt + 1
								If vTitleCnt = 1 Then
									vStyleTitle = getStyleKor(oGrStl.FItemList(lp).FStyleCd)
								End If
							End If
							vStyleList = vStyleList & "onclick=""jsSelectFilterSomething('style','filterstyle"&lp&"','"&oGrStl.FItemList(lp).FStyleCd&"','styleCd'); return false;"">" & getStyleKor(oGrStl.FItemList(lp).FStyleCd)
							vStyleList = vStyleList & "</a></li>"
						Next
						
						Response.Write vStyleList
						
						vStyleTitle = vStyleTitle & CHKIIF(vTitleCnt>1," 외 " & vTitleCnt-1 & "건","")
						%>
						</ul>
					</div>
				</div>
<%
			'### 스타일 선택된거 타이틀과, 선택된항목버튼 셋팅
			If vStyleTitle <> "" Then
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('style');>" & vStyleTitle & "</button></li>"
				vStyleTitle = "$(""#filterstyletitle"").text(""" & vStyleTitle & """);"
			End If
		
	end if
	set oGrStl = nothing
	
	function getStyleKor(scd)
		dim arrSnm
		if isNumeric(scd) then
			if cInt(scd)>90 then 
				getStyleKor = "all"
				exit function
			end if
            
            ''2015/04/22 추가 //벌크작업시 오류 있을수 있음.
            if cInt(scd)<10 then 
				getStyleKor = "all"
				exit function
			end if
			
			'컬러명 배열로 세팅 (코드순으로 나열)
			arrSnm = split("클래식,큐티,댄디,모던,내추럴,오리엔탈,팝,로맨틱,빈티지",",")

			'반환
			getStyleKor = arrSnm(cInt(scd)/10-1)
		else
			getStyleKor = "all"
		end if
	end function
	
	'// 컬러칩 //
	dim oGrClr, vColorList, vColorTitle, vExcludeColor
	vTitleCnt = 0
	vExcludeColor = " AND idx_colorCd!='023' AND idx_colorCd!='010' AND idx_colorCd!='021' AND idx_colorCd!='004' AND idx_colorCd!='024' AND idx_colorCd!='019' AND idx_colorCd!='006' "
	vExcludeColor = vExcludeColor & " AND idx_colorCd!='018' AND idx_colorCd!='017' AND idx_colorCd!='022' AND idx_colorCd!='014' AND idx_colorCd!='015' AND idx_colorCd!='028' "
	vExcludeColor = vExcludeColor & " AND idx_colorCd!='029' AND idx_colorCd!='030' AND idx_colorCd!='031' "
	
	set oGrClr = new SearchItemCls
	oGrClr.FRectSearchTxt = SearchText
	oGrClr.FRectSearchFlag = "n"
	oGrClr.FRectSearchItemDiv = SearchItemDiv
	oGrClr.FRectSearchCateDep = SearchCateDep
	oGrClr.FRectColorExclude = vExcludeColor
	'oGrClr.FRectCateCode = dispCate
	'oGrClr.FarrCate=arrCate
	oGrClr.FCurrPage = 1
	oGrClr.FPageSize = 31
	oGrClr.FScrollCount =10
	oGrClr.FListDiv = ListDiv
	oGrClr.FSellScope="Y"			'판매/품절상품 포함 여부
	oGrClr.FLogsAccept = False

	oGrClr.getTotalItemColorCount
	
	If oGrClr.FResultCount>0 Then
%>
				<div id="filterColor" class="panel color">
					<div class="hgroup" onclick="jsFilterShow('Color');">
						<a href="#filterColor">
							<h3>컬러</h3>
							<div class="option">
								<p class="value" id="filtercolortitle"></p>
							</div>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 multi-select" id="filtercolorlist">
						<%
						FOR lp = 0 to oGrClr.FResultCount-1
							vColorList = vColorList & "<li class=""" & LCase(getColorEng(oGrClr.FItemList(lp).FcolorCode)) & """><a href="""" id=""filtercolor"&lp&""" "
							If chkArrValue(colorCD,oGrClr.FItemList(lp).FcolorCode) Then
								vColorList = vColorList & " class=""on"" "
								vTitleCnt = vTitleCnt + 1
								If vTitleCnt = 1 Then
									vColorTitle = getColorEng(oGrClr.FItemList(lp).FcolorCode)
								End If
							End If
							vColorList = vColorList & "onclick=""jsSelectFilterSomething('color','filtercolor"&lp&"','"&oGrClr.FItemList(lp).FcolorCode&"','iccd'); return false;"">" & getColorEng(oGrClr.FItemList(lp).FcolorCode)
							vColorList = vColorList & "</a></li>"
						Next
						
						Response.Write vColorList
						
						vColorTitle = vColorTitle & CHKIIF(vTitleCnt>1," 외 " & vTitleCnt-1 & "건","")
						%>
						</ul>
					</div>
				</div>
<%
			'### 컬러 선택된거 타이틀과, 선택된항목버튼 셋팅
			If vColorTitle <> "" Then
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('color');>" & vColorTitle & "</button></li>"
				vColorTitle = "$(""#filtercolortitle"").text(""" & vColorTitle & """);"
			End If

	end if
	
	set oGrClr = Nothing

	function getColorEng(ccd)
		dim arrCnm
		if isNumeric(ccd) then
			if cInt(ccd)>31 then 
				getColorEng = "all"
				exit function
			end if

			'컬러명 배열로 세팅 (코드순으로 나열)
			arrCnm = split("Red,Orange,Yellow,Beige,Green,Skyblue,Blue,Violet,Pink,Brown,White,Grey,Black,Silver,Gold,Mint,Babypink,Lilac,Khaki,Navy,Camel,Charcoal,Wine,Ivory,Check,Stripe,Dot,Flower,Drawing,Animal,Geometric",",")

			'반환
			getColorEng = arrCnm(cInt(ccd)-1)
		else
			getColorEng = "all"
		end if
	end function
	
	Dim vDeliveryTitle
	SELECT CASE deliType
		Case "FD" : vDeliveryTitle = "무료배송"
		Case "TN" : vDeliveryTitle = "텐바이텐 배송"
		Case "FT" : vDeliveryTitle = "무료+텐바이텐 배송"
		Case "WD" : vDeliveryTitle = "해외배송"
		'// 해외직구배송작업추가
		Case "QT" : If showQuickDivStatus Then vDeliveryTitle = "바로배송" Else vDeliveryTitle = "" End If
		Case "DT" : vDeliveryTitle = "해외직구"
	END SELECT
%>
				<!-- 배송방법 -->
				<div id="filterShipping" class="panel shipping">
					<div class="hgroup" onClick="jsFilterShow('Shipping');">
						<a href="#filterShipping">
							<h3>배송방법</h3>
							<div class="option">
								<p class="value" id="deliverytitle"><%=vDeliveryTitle%></p>
							</div>
						</a>
					</div>
					<div class="panelcont">
						<ul class="depth1 one-select" id="filterdeliverylist">
							<li><a href="" <%=CHKIIF(deliType="FD","class=""on""","")%> id="deli_FD" onClick="jsDeliverySearch('FD','무료배송'); return false;">무료배송</a></li>
							<li><a href="" <%=CHKIIF(deliType="TN","class=""on""","")%> id="deli_TN" onClick="jsDeliverySearch('TN','텐바이텐 배송'); return false;">텐바이텐 배송</a></li>
							<li><a href="" <%=CHKIIF(deliType="FT","class=""on""","")%> id="deli_FT" onClick="jsDeliverySearch('FT','무료+텐바이텐 배송'); return false;">무료+텐바이텐 배송</a></li>
							<% '// 해외직구배송작업추가 %>
							<% If showQuickDivStatus Then %>
								<li><a href="" <%=CHKIIF(deliType="QT","class=""on""","")%> id="deli_QT" onClick="jsDeliverySearch('QT','바로배송'); return false;">바로배송</a></li>
							<% End If %>
							<li><a href="" <%=CHKIIF(deliType="DT","class=""on""","")%> id="deli_DT" onClick="jsDeliverySearch('DT','해외직구'); return false;">해외직구</a></li>
							<li><a href="" <%=CHKIIF(deliType="WD","class=""on""","")%> id="deli_WD" onClick="jsDeliverySearch('WD','해외배송'); return false;">해외배송</a></li>
						</ul>
					</div>
				</div>
<%
				If deliType = "FD" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FD');>무료배송</button></li>"
				End If
				If deliType = "FT" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FT');>무료+텐바이텐 배송</button></li>"
				End If
				If deliType = "WD" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('WD');>해외배송</button></li>"
				End If
				'// 해외직구배송작업추가
				If deliType = "QT" Then
					If showQuickDivStatus Then
						vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('QT');>바로배송</button></li>"
					End If
				End If
				If deliType = "DT" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('DT');>해외직구</button></li>"
				End If				
'// 가격범위 표시 //
dim oGrPrc, vMinPrice, vMaxPrice, vMinRange, vMaxRange
set oGrPrc = new SearchItemCls
oGrPrc.FRectSearchTxt = SearchText
'oGrPrc.FRectMakerid = fnCleanMakerID(makerid)
oGrPrc.FRectSearchItemDiv = SearchItemDiv
oGrPrc.FRectSearchCateDep = SearchCateDep
'oGrPrc.FRectCateCode = dispCate
'oGrPrc.FarrCate=arrCate
oGrPrc.FCurrPage = 1
oGrPrc.FPageSize = 1
oGrPrc.FScrollCount =10
oGrPrc.FListDiv = ListDiv
oGrPrc.FSellScope="Y"			'판매/품절상품 포함 여부
oGrPrc.FLogsAccept = False

oGrPrc.getItemPriceRange

If oGrPrc.FResultCount>0 Then
	vMinPrice = chkIIF(minPrice>0,minPrice,oGrPrc.FItemList(0).FminPrice)
	vMaxPrice = chkIIF(maxPrice>0,maxPrice,oGrPrc.FItemList(0).FmaxPrice)
	vMinRange = oGrPrc.FItemList(0).FminPrice
	vMaxRange = oGrPrc.FItemList(0).FmaxPrice
Else
	vMinPrice = 10000
	vMaxPrice = 300000
	vMinRange = 10000
	vMaxRange = 300000
End If

set oGrPrc = Nothing
%>
				<!-- 가격대 -->
				<div class="panel price">
					<div class="hgroup">
						<h3>가격대</h3>
					</div>
					<div class="form">
						<fieldset>
						<legend class="hidden">가격대 검색</legend>
							<div class="textfield">
								<span class="itext"><input type="text" title="최소 가격" id="minprice" value="<%=FormatNumber(vMinPrice,0)%>" onFocus="jsPriceComma('up','min');" onBlur="jsPriceComma('down','min');" autocomplete="off" pattern="[0-9]*" /><button type="reset" class="btn-reset">리셋</button></span>
								<span>~</span>
								<span class="itext"><input type="text" title="최대 가격" id="maxprice" value="<%=FormatNumber(vMaxPrice,0)%>" onFocus="jsPriceComma('up','max');" onBlur="jsPriceComma('down','max');" autocomplete="off" pattern="[0-9]*" /><button type="reset" class="btn-reset">리셋</button></span>
							</div>
							<button type="button" class="btn-submit" onClick="jsPriceSearch();">입력</button>
						</fieldset>
						<input type="hidden" id="minpricehidden" value="<%=FormatNumber(vMinPrice,0)%>">
						<input type="hidden" id="maxpricehidden" value="<%=FormatNumber(vMaxPrice,0)%>">
					</div>
				</div>
<%
				'If vMinPrice <> "" AND vMaxPrice <> "" Then
				'	vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('price');>" & vMinPrice & " ~ " & vMaxPrice & "</button></li>"
				'End If
%>
				<!-- 결과 내 검색 -->
				<div class="panel searching">
					<div class="hgroup">
						<h3>결과 내 검색</h3>
					</div>
					<div class="form">
						<fieldset>
						<legend class="hidden">결과 내 검색</legend>
							<input type="search" name="sMtxt" id="sMtxt" maxlength="50" value="<%=ReSearchText%>" placeholder="검색어를 입력해주세요" />
							<button type="button" class="btn-submit" onClick="jsResearchTxt(); return false;">입력</button>
						</fieldset>
					</div>
				</div>
<%
				If ReSearchText <> "" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('researchtxt');>" & ReSearchText & "</button></li>"
				End If
%>
			</div>
		</div>
	</div>
	<div class="ly-footer">
		<button type="button" class="btn-close" onClick="jsGoSearchh();"><b id="resulttotalcount"><%=FormatNumber(vTotalCount,0)%></b>건의 결과보기</button>
	</div>
	<button type="button" class="btn-close-down" onClick="jsSearchLayerClose(); return false;">닫기</button>
</div>
<script type="text/javascript">
//####### 필터 관련 스크립트 #######
var itemSwiper;
var isloading=false;

$(function(){
	/* filiter list */
	var filterSwiper = new Swiper("#filterList .swiper-container", {
		slidesPerView:"auto"
	});

	$("#filterList .btn-del").on("click", function(e){
		$(this).parent().remove();
	});


	/* view option */
	$(".viewoption .value button").on("click", function(){
		$(".viewoption .value button").removeClass("on");
		if ($(this).hasClass("on")){
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});
	
	/* category */

	/* price */
	$(".price .textfield .itext input").on("keyup", function(){
		$(this).next().show();
	});
	$(".price .textfield .itext .btn-reset").on("click", function(){
		$(this).parent().find("input").val('');
	});
});

//필터 선택하면 값 넣고 css on 하고 text 표시.
function jsSelectFilterSomething(gubun,thing,title,realvalue){
	var m = $("#"+realvalue+"").val();
	var t = "";

	if($("#"+thing+"").hasClass("on")){	//이미선택된것
		$("#"+thing+"").removeClass("on");
		t = m.replace(","+title+",", ",");
		
		if(t == ","){
			t = "";
		}
		
		$("#"+realvalue+"").val(t);
	}else{
		$("#"+thing+"").addClass("on");
		if(m == ""){
			$("#"+realvalue+"").val(","+title+",");
		}else{
			$("#"+realvalue+"").val(m+title+",");
		}
	}
	
	var l = $("#filter"+gubun+"list li").length;
	var a = $("#filter"+gubun+"list li a");
	var tit = "";
	var tit2 = "";
	var titcnt = 0;
	for(var i=0; i<l; i++){
		if(a.eq(i).hasClass("on")){
			if(tit == ""){
				tit = $("#filter"+gubun+"list li a").eq(i).text();
			}
			titcnt = titcnt + 1;
		}
	}
	
	if(titcnt > 1){
		tit2 = " 외 " + (titcnt-1) + "건";
	}
	
	tit = tit.replace(" BEST","")
	
	$("#filter"+gubun+"title").text(tit+tit2);
	
	jsResultTotalCount();
}

//보기옵션. 리스트형 격자형
function jsViewoption(m){
	$("#mode").val(m);
}

//결과내검색
function jsResearchTxtProc(){
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi
	if(regExp.test($("#sMtxt").val())){
		alert("특수문자는 입력할 수 없습니다.");
		$("#sMtxt").val("");
		return false;
	}
	$("#rstxt").val($("#sMtxt").val());
	$("#chkr").val("true");
}

function jsResearchTxt(){
	jsResearchTxtProc();
	
	$("#cpg").val("1");
	jsGoSearchh();
}

function jsGoSearchh(){
	jsResearchTxtProc();
	jsPriceSearchProc();
	
	var keyWd = $("#rect").val();
	var sscp = $("#sscp").val();
	var delitp = $("#deliType").val();
	var sflag = $("#sflag").val();
	var pojok = $("#pojangok").val();
	var mde = $("#mode").val();
	var srtmt = $("#srm").val();
	var catCd = $("#dispCate").val();
	var mkrid = $("#mkr").val();
	var prcMin = $("#minPrc").val().replace(/,/gi, "");
	var prcMax = $("#maxPrc").val().replace(/,/gi, "");
	var rstxt = $("#rstxt").val();
	var styCd = $("#styleCd").val();
	var ColrCd = $("#iccd").val();
	var listOption = $("#listoption").val();
	var categoryname = $("#disptitle").text();
	var brandname = $("#filterbrandtitle").text();
	
	mkrid = jsDelComma(mkrid);
	styCd = jsDelComma(styCd);
	ColrCd = jsDelComma(ColrCd);

	var ifilter = {"keyword":keyWd,"sscp":sscp,"delitp":delitp,"sflag":sflag,"pojangok":pojok,"mode":mde,"displaytype":srtmt,"categoryid":catCd,"brandid":mkrid,"pricelimitlow":prcMin,"pricelimithigh":prcMax,"rstxt":rstxt,"stylecd":styCd,"colorcd":ColrCd,"offset":"","listoption":listOption,"categoryname":categoryname,"brandname":brandname};
	<% if (IS_SHOWDEVMSG) then %>
    //alert( JSON.stringify(ifilter));
    <% end if %>
    callNativeFunction('setFilter', ifilter);
    setTimeout("fnAPPclosePopup()",500);
}

function jsDelComma(v){
	var r = v;
	if(r != ""){
		if(r.substring(0,1) == ","){
			r = r.substring(1);
		}
		if(r.substring(r.length-1) == ","){
			r = r.substring(0,r.length-1);
		}
	}
	return r;
}

//빠른메뉴 구분에 따라 값 저장
function jsFastSearch(g){
	if(g == "pum"){ //품절상품 포함
		if($("#sscp").val() == "N"){
			$("#sscp").val("");
		}else{
			$("#sscp").val("N");
		}
	}else if(g == "tendeli"){ //텐바이텐 배송
		if($("#deliType").val() == "TN"){
			$("#deliType").val("");
		}else{
			$("#deliType").val("TN");
		}
	}else if(g == "sale"){ //세일중인 상품
		if($("#sflag").val() == "sc"){
			$("#sflag").val("");
		}else{
			$("#sflag").val("sc");
		}
	}else if(g == "pojang"){ //선물포장 가능
		if($("#pojangok").val() == "o"){
			$("#pojangok").val("");
		}else{
			$("#pojangok").val("o");
		}
	}
}

//빠른메뉴 버튼 온오프. 값 저장하고 css on off
function jsFastOnOff(v){
	jsFastSearch(v);
	if($("#fast"+v+"").hasClass("on")){
		$("#fast"+v+"").removeClass("on");
	}else{
		$("#fast"+v+"").addClass("on");
	}
	
	jsResultTotalCount();
}

//배송필터액션
function jsDeliverySearch(v,title){
	if($("#deliType").val() == v){
		$("#deliType").val("");
		jsDeliOff();
		$("#deliverytitle").text("");
	}else{
		if(v == "TN"){
			if($("#fasttendeli").hasClass("on")){
				$("#deliType").val("");
				jsDeliOff();
			}else{
				$("#deliType").val("TN");
				jsDeliOff();
				$("#deli_TN").addClass("on");
				$("#fasttendeli").addClass("on");
			}
		}else{
			jsDeliOff();
			$("#deliType").val(v);
			$("#deli_"+v+"").addClass("on");
		}
		
		$("#deliverytitle").text(title);
	}
	
	jsResultTotalCount();
}

//배송필터 버튼 클릭시 css on off
function jsDeliOff(){
	$("#deli_FD").removeClass("on");
	$("#deli_TN").removeClass("on");
	$("#deli_FT").removeClass("on");
	$("#deli_WD").removeClass("on");
	<%'// 해외직구배송작업추가 %>
	$("#deli_QT").removeClass("on");
	$("#deli_DT").removeClass("on");
	$("#fasttendeli").removeClass("on");
}

//가격검색
function jsPriceSearchProc(){
	if($("#minprice").val() == "" || isNaN($("#minprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최저가를 숫자만로 입력해주세요.");
		$("#minprice").focus();
		return;
	}
	if($("#maxprice").val() == "" || isNaN($("#maxprice").val().replace(/,/gi, ""))){
		alert("가격대 범위 최고가를 숫자만로 입력해주세요.");
		$("#maxprice").focus();
		return;
	}
	$("#minPrc").val($("#minprice").val());
	$("#maxPrc").val($("#maxprice").val());
}

function jsPriceSearch(){
	jsPriceSearchProc();
	
	$("#cpg").val("1");
	jsGoSearchh();
}

function jsPriceComma(g,p){
	var v = $("#"+p+"price").val();

	if(!IsDigit(v.replace(/,/gi, "")) || v == ""){
		alert("금액은 숫자로만 입력하셔야 합니다.");
		$("#"+p+"price").val($("#"+p+"pricehidden").val());
		return;
	}

	if(g == "up"){
		v = v.replace(/,/gi, "");
		$("#"+p+"price").val(v);
	}else if(g == "down"){
		v = getMoneyFormat(v);
		$("#"+p+"price").val(v);
	}
}

function getMoneyFormat(m){
	var a,b;

	if(m.toString().indexOf('.') != -1) {
		var nums = m.toString().split('.');
		a = nums[0];
		b = '.' + nums[1];
	} else {
		a = m;
		b = "";
	}

	return a.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") + b;
}

//카테고리 리스트 가져옴.
function jsGetDispCate(cd){
	var dispid = "";
	
	if(cd == ""){
		dispid = "navCategory";
	}else{
		var ddep = cd.length/3;
		dispid = "disp"+cd+"";
		
		if(ddep == 1){
			$(".depth1 > li > ul").hide();
		} else if(ddep == 2){
			$(".depth2 > li > ul").hide();
		}
		
		if($("#"+dispid+"").is(":hidden")){
			$("#"+dispid+"").show();
		}else{
			$("#"+dispid+"").hide();
		}

	}
	
	$.ajax({
		url: "/search/act_searchDispcate2017.asp?rect=<%=DocSearchText%>&clickdisp="+cd+"",
		cache: false,
		async: false,
		success: function(message) {
			$("#"+dispid+"").empty().html(message);
		}
	});
}

//카테고리검색
function jsDispSearch(d,t){
	jsGetDispCate(d);
	
	jsjsDispClassInsert(d);
	
	<% If dispcate <> "" AND Len(dispcate) = 3 Then %>
		if(d == "<%=dispcate%>"){
			$("#dispCate").val("");
		}
	<% End If %>
	
	if($("#dispCate").val() == d){
		$("#dispCate").val("");
		$("#disptitle").text("");
		jsDispListClassAllDel();
		$("#disp"+d+"").hide();
	}else{
		$("#dispCate").val(d);
		$("#disptitle").text(t);
	}

	jsResultTotalCount();
}

//선택한 카테고리 클래스주입
function jsjsDispClassInsert(d){
	jsDispListClassAllDel();
	
	$(".category"+d+" > a").addClass("on");
	if(d.length == 6){
		$(".category"+d.substring(0,3)+" > a").addClass("on");
	} else if(d.length == 9){
		$(".category"+d.substring(0,3)+" > a").addClass("on");
		$(".category"+d.substring(0,6)+" > a").addClass("on");
	}
	
	$(".category"+d+" > a").addClass("selected");
}

//선택된 클래스 삭제
function jsDispListClassAllDel(){
	$(".depth1 > li > a").removeClass("on");
	$(".depth1 > li > a").removeClass("selected");
	$(".depth1 > li > ul > li > a").removeClass("on");
	$(".depth1 > li > ul > li > a").removeClass("selected");
	$(".depth1 > li > ul > li > ul > li > a").removeClass("on");
	$(".depth1 > li > ul > li > ul > li > a").removeClass("selected");
}

//필터 액션에 따라 즉시 결과카운트 표시
function jsResultTotalCount(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	
	var rstr = $.ajax({
			type: "GET",
	        url: "/search/act_search_item_totalcount.asp",
	        data: formData,
	        dataType: "text",
	        async: false
	}).responseText;

	if(rstr!="") {
		$("#resulttotalcount").text(rstr);
    }
}

//필터 펼치기
function jsFilterShow(f){
	if(f == "Category"){
		jsGetDispCate("");
	}

	if($("#filter"+f+" .panelcont").is(":hidden")){
		$("#filter"+f+" .panelcont").show();
	}else{
		$("#filter"+f+" .panelcont").hide();
	}
	
	if(f != "Category"){
		$("#filterCategory .panelcont").hide();
	}
	if(f != "Brand"){
		$("#filterBrand .panelcont").hide();
	}
	if(f != "Style"){
		$("#filterStyle .panelcont").hide();
	}
	if(f != "Color"){
		$("#filterColor .panelcont").hide();
	}
	if(f != "Shipping"){
		$("#filterShipping .panelcont").hide();
	}

	return false;
}

//필터 검색한 값들 클릭시 초기값변경
function jsSelectedFilter(g){
	if(g == "pum"){
		$("#sscp").val("");
	}else if(g == "TN" || g == "FD" || g == "FT" || g == "WD" ){
		$("#deliType").val("");
	}else if(g == "sale"){
		$("#sflag").val("");
	}else if(g == "pojang"){
		$("#pojangok").val("");
	}else if(g == "disp"){
		$("#dispCate").val("");
	}else if(g == "brand"){
		$("#mkr").val("");
	}else if(g == "style"){
		$("#styleCd").val("");
	}else if(g == "color"){
		$("#iccd").val("");
	}else if(g == "price"){
		$("#minPrc").val("");
		$("#maxPrc").val("");
	}else if(g == "researchtxt"){
		$("#rstxt").val("");
	}
	
	
	jsGoSearchh();
}

function jsGoDefaultSetting(){
	callNativeFunction('resetfilter');
	return false;
	//location.href = "http://m.10x10.co.kr/apps/appCom/wish/web2014/lib/util/popFilterAppV32sh.asp?rect=<%=SearchText%>";
}

function jsSearchLayerClose(){
	callNativeFunction('filterlayerClose');
	return false;
}
//####### 필터 관련 스크립트 #######

<%=vBrandTitle%>
<%=vStyleTitle%>
<%=vColorTitle%>
$("#selectedfilter").html("<%=vSelectedFilter%>");

if($("#selectedfilter").html() == ""){
	$("#filterbtn").removeClass("on");
}
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
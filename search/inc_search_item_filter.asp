<%
'// 바로배송 표시여부
Dim showQuickDivStatus
showQuickDivStatus = FALSE
If now() > #07/31/2019 12:00:00# Then
	showQuickDivStatus = FALSE
Else
	showQuickDivStatus = TRUE
End If

Dim vSelectedFilter, vSelectedPreHtml
'vSelectedPreHtml = "<li class=swiper-slide><button type=button class=btn-del"
vSelectedPreHtml = "<li class=swiper-slide><a "
%>
<div id="searchFilter" class="search-filter fixed-bottom">
	<div class="ly-header">
		<h2>필터</h2>
		<button type="reset" class="btn-reset" onClick="location.href='/search/search_item.asp?rect=<%=SearchText%>';">초기화</button>
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
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pum'); class='on'>품절상품 포함</button></li>"
				End If
				'If deliType = "TN" Then
				'	vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('TN');>텐바이텐 배송</button></li>"
				'End If
				If SearchFlag = "sc" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('sale'); class='on'>세일중인 상품</button></li>"
				End If
				If pojangok = "o" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('pojang'); class='on'>선물포장 가능</button></li>"
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
		vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('disp'); class='on'>" & vDispTitle & "</button></li>"
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
			vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('brand'); class='on'>" & vBrandTitle & "</button></li>"
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
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('style'); class='on'>" & vStyleTitle & "</button></li>"
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
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('color'); class='on'>" & vColorTitle & "</button></li>"
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
				'If deliType = "FD" Then
				'	vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FD');>무료배송</button></li>"
				'End If
				'If deliType = "FT" Then
				'	vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('FT');>무료+텐바이텐 배송</button></li>"
				'End If
				If deliType = "WD" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('WD'); class='on'>해외배송</button></li>"
				End If
				'// 해외직구배송작업추가
				If deliType = "QT" Then
					If showQuickDivStatus Then
						vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('QT'); class='on'>바로배송</button></li>"
					End If
				End If
				If deliType = "DT" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('DT'); class='on'>해외직구</button></li>"
				End If

				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onclick=jsGoSearchStaticButtonSubmit('FD',this);return false; "&CHKIIF(deliType="FD","class='on'","")&">무료배송</a></li>"
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onclick=jsGoSearchStaticButtonSubmit('FT',this);return false; "&CHKIIF(deliType="FT","class='on'","")&">무료+텐바이텐 배송</a></li>"
				vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onclick=jsGoSearchStaticButtonSubmit('TN',this);return false; "&CHKIIF(deliType="TN","class='on'","")&">텐바이텐 배송</a></li>"
				
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
							<button type="button" class="btn-submit" onClick="jsResearchTxt();">입력</button>
						</fieldset>
					</div>
				</div>
<%
				If ReSearchText <> "" Then
					vSelectedFilter = vSelectedFilter & vSelectedPreHtml & " onClick=jsSelectedFilter('researchtxt'); class='on'>" & ReSearchText & "</button></li>"
				End If
%>
			</div>
		</div>
	</div>
	<div class="ly-footer">
		<button type="button" class="btn-close"><b id="resulttotalcount"><%=FormatNumber(vTotalCount,0)%></b>건의 결과보기</button>
	</div>
	<button type="button" class="btn-close-down" onClick="jsSearchLayerClose('searchFilter');">닫기</button>
</div>
<script type="text/javascript">
function jsGoSearchStaticButtonSubmit(type, t) {
	if ($(t).hasClass("on")){
		$(t).removeClass("on");
		$("#deliType").val("");
		$("#listSFrm").submit();
	}
	else {
		$(t).addClass("on");		
		$("#deliType").val(""+type+"");
		$("#listSFrm").submit();
	}
}
<%=vBrandTitle%>
<%=vStyleTitle%>
<%=vColorTitle%>
$("#selectedfilter").html("<%=vSelectedFilter%>");

if($("#selectedfilter").html() == ""){
	$("#filterbtn").removeClass("on");
}
</script>
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
	<div id="mask" style="overflow:hidden; display:none; position:fixed; top:0; left:0; z-index:25; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
	<div id="searchFilter" class="search-filter fixed-bottom" style="display:none;">
		<div class="ly-header">
			<h2>필터</h2>
			<button type="reset" class="btn-reset" onClick="location.href='/category/category_list.asp?dispCate=<%=dispCate%>';">초기화</button>
		</div>
		<div class="inner">
			<div class="ly-contents">
				<div class="scrollwrap">
					<!-- 빠른 이동 -->
					<div class="panel quickmove">
						<div class="hgroup">
							<h3>빠른이동</h3>
						</div>
						<div class="form">
							<fieldset>
							<legend class="hidden">결과 내 빠른이동</legend>
								<input type="hidden" id="maxfilterpage" value=<%=filterttpg%> />
								<input type="number" id="filterpage" oninput="maxLengthCheck(this)" maxlength="4" title="페이지 넘버 입력" placeholder="<%= CurrPage %>" /> <span class="page-no"><span class="slash">/</span> <b><%= FormatNumber(filterttpg,0) %> </b>페이지</span>
								<button type="button" onclick="jsGoPage();" class="btn-submit">이동</button>
							</fieldset>
						</div>
					</div>
	
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
					Dim y, y1, y2, y3, vArrD1, vArrD2, vArrD3, vCa1, vTmp1, vCa2, vTmp2, vCa3, vTmp3, vDispTitle
			
					
					'//스타일 검색결과
					dim oGrStl, vStyleTitle, vStyleList, vTitleCnt
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
					oGrStl.FRectCateCode = dispCate
					oGrStl.FarrCate=arrCate
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
					vExcludeColor = vExcludeColor & " AND idx_colorCd!='018' AND idx_colorCd!='017' AND idx_colorCd!='022' AND idx_colorCd!='014' AND idx_colorCd!='015' AND idx_colorCd!='015' AND idx_colorCd!='028' "
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
					oGrClr.FRectCateCode = dispCate
					oGrClr.FarrCate=arrCate
	
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
					oGrPrc.FCurrPage = 1
					oGrPrc.FPageSize = 1
					oGrPrc.FScrollCount =10
					oGrPrc.FListDiv = ListDiv
					oGrPrc.FSellScope="Y"			'판매/품절상품 포함 여부
					oGrPrc.FLogsAccept = False
					
					
					oGrPrc.FRectCateCode = dispCate
					oGrPrc.FarrCate=arrCate
					
											
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
									<span class="itext"><input type="text" title="최소 가격" id="minprice" value="<%=FormatNumber(vMinPrice,0)%>" onClick="jsPriceComma('up','min');" onFocusOut="jsPriceComma('down','min');" autocomplete="off" /><button type="reset" class="btn-reset">리셋</button></span>
									<span>~</span>
									<span class="itext"><input type="text" title="최대 가격" id="maxprice" value="<%=FormatNumber(vMaxPrice,0)%>" onClick="jsPriceComma('up','max');" onFocusOut="jsPriceComma('down','max');" autocomplete="off" /><button type="reset" class="btn-reset">리셋</button></span>
								</div>
								<button type="button" class="btn-submit" onClick="jsPriceSearch();">입력</button>
							</fieldset>
							<input type="hidden" id="minpricehidden" value="<%=FormatNumber(vMinPrice,0)%>">
							<input type="hidden" id="maxpricehidden" value="<%=FormatNumber(vMaxPrice,0)%>">
						</div>
					</div>

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
//####### 필터 관련 스크립트 #######

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
function jsResearchTxt(){
	$("#rstxt").val($("#sMtxt").val());
	$("#chkr").val("true");
	$("#cpg").val("1");
	$("#listSFrm").submit();
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
function jsPriceSearch(){
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
	
	$("#listSFrm").submit();
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

//카테고리검색
function jsDispSearch(d,t){

	$("#dispCate").val(d);
	$("#disptitle").text(t);

	jsResultTotalCount();
}

//필터 액션에 따라 즉시 결과카운트 표시
function jsResultTotalCount(){
	var formData = $("#listSFrm").serialize().replace(/=(.[^&]*)/g,
		function($0,$1){ 
		return "="+escape(decodeURIComponent($1)).replace('%26','&').replace('%3D','=')
	});
	
	var rstr = $.ajax({
			type: "GET",
	        url: "/category/act_search_item_totalcount.asp",
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
	}else if(g == "TN" || g == "FD" || g == "FT" || g == "WD" || g == "QT" || g == "DT"  ){
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
	
	
	$("#listSFrm").submit();
}

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
//####### 필터 관련 스크립트 #######

<%=vDispTitle%>
<%'=vBrandTitle%>
<%=vStyleTitle%>
<%=vColorTitle%>
$("#selectedfilter").html("<%=vSelectedFilter%>");

if($("#selectedfilter").html() == ""){
	$("#filterbtn").removeClass("on");
}
</script>
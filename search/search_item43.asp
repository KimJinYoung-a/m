<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/search43cls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
	dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
	dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
	dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
	dim SortMet		: SortMet = request("srm")
	dim SearchFlag : SearchFlag = request("sflag")
	dim ListDiv : ListDiv = "search" '카테고리/검색 구분용 
	dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
	dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
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
	if SortMet="" then SortMet="be"		'베스트:be, 신상:ne


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

	'// 검색어 DB저장
	tmpPrevSearchKeyword = PrevSearchText
	tmpCurrSearchKeyword = SearchText

	dim oGrCat,rowCnt ''//카테고리
	Dim oGrBrn ''//브랜드

	'검색 로그 저장 여부
	IF CStr(SearchText)=CStr(PrevSearchText) Then
		LogsAccept = false
	End if

	'// 총 검색수 산출
	dim oTotalCnt 
	set oTotalCnt = new SearchItemCls
	oTotalCnt.FRectSearchTxt = SearchText
	oTotalCnt.FRectSearchItemDiv = SearchItemDiv
	''oTotalCnt.FRectCateCode	= dispCate
	oTotalCnt.FListDiv = ListDiv
	oTotalCnt.getTotalCount

	'// 상품검색
	dim oDoc,iLp
	set oDoc = new SearchItemCls
	oDoc.FRectSearchTxt = SearchText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag = searchFlag
	oDoc.FRectSearchItemDiv = SearchItemDiv
	oDoc.FRectCateCode	= dispCate
	oDoc.FRectSearchCateDep = SearchCateDep
	oDoc.FRectMakerid	= makerid
	oDoc.FminPrice	= minPrice
	oDoc.FmaxPrice	= maxPrice
	oDoc.FdeliType	= deliType
	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
	oDoc.FScrollCount = ScrollCount
	oDoc.FListDiv = ListDiv
	oDoc.FLogsAccept = LogsAccept
	oDoc.FRectColsSize = 6
	oDoc.FcolorCode = colorCD
	oDoc.FSellScope=SellScope
	oDoc.getSearchList

	'// 숫자만 입력될경우 체크후 상품페이지로 넘기기
	IF oDoc.FTotalCount=1 and isNumeric(SearchText) Then

		on Error Resume Next

		'// 존재하는 상품인지 검사
		dim objCmd,returnValue

		Set objCmd = Server.CreateObject("ADODB.Command")

		objCmd.ActiveConnection = dbget
		objCmd.CommandType = adCmdStoredProc
		objCmd.CommandText = "[db_item].[dbo].sp_Ten_PrdExists"

		objCmd.Parameters.Append objCmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
		objCmd.Parameters.Append objCmd.CreateParameter("@@vItemID",adVarWChar,adParamInput,10,CLng(DocSearchText))

		objCmd.Execute

		returnValue = objCmd("RETURN_VALUE").value

		Set objCmd = Nothing
		IF returnValue=1 Then
			response.redirect "/category/category_itemprd.asp?itemid=" & CLng(DocSearchText)
			dbget.close()	:	response.End
		End IF

		on Error Goto 0

	End if

	'// 브랜드별 검색결과
	set oGrBrn = new SearchItemCls
	oGrBrn.FRectSearchTxt = SearchText
	oGrBrn.FRectSortMethod = SortMet
	oGrBrn.FRectSearchItemDiv = SearchItemDiv
	oGrBrn.FCurrPage = 1
	oGrBrn.FPageSize = 100
	oGrBrn.FScrollCount =10
	oGrBrn.FListDiv = ListDiv
	oGrBrn.FLogsAccept = False
	oGrBrn.getGroupbyBrandList


	Dim brnTTCnt : brnTTCnt = oGrBrn.FResultCount '//브랜드 총카운트
	Dim moreYn

	if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) then
		'// 내검색어 쿠키 저장
		call procMySearchKeyword(tmpCurrSearchKeyword)
	End If 

	'// 카테고리 현재 위치
	Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
	if dispCate<>"" and isNumeric(dispCate) then
		vIsLastDepth = (len(dispCate)\3)>=3
		vCateNavi = printDistCateHistory(dispCate,vIsLastDepth,vCateCnt)

		vCateItemCount = FormatNumber(oDoc.FTotalCount,0)
		vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")
	end if

	'// 카테고리 Histoty 출력
	function printDistCateHistory(code,lastdep,byRef vCateCnt)
		dim strHistory, strLink, SQL, i, j, StrLogTrack
		j = (len(code)/3)
	    
		'히스토리 기본
		strHistory = ""
	
		i = 0
		'// 카테고리 이름 접수
		SQL = "SELECT ([db_item].[dbo].[getCateCodeFullDepthName]('" & code & "'))"
		rsget.Open SQL, dbget, 1
	
		if NOT(rsget.EOF or rsget.BOF) then
			If Not(isNull(rsget(0))) Then
				for i = 1 to j
				
					If i=j AND lastdep = True Then
						strHistory = strHistory & "<p class=""swiper-slide""><span class=""button btS1 btGry2 cWh1""><a href="""" onclick=""popDistCategory(); return false;"">"
					Else
						strHistory = strHistory & "<em class=""swiper-slide""><a href="""" onclick=""goCategoryList('" & Left(code,(3*i)) & "');return false;"">"
					End If
					
					strHistory = strHistory & Split(db2html(rsget(0)),"^^")(i-1)
					StrLogTrack = StrLogTrack & Split(db2html(rsget(0)),"^^")(i-1)
					
					If i=j AND lastdep = True Then
						strHistory = strHistory & "</a></span></p>"
					Else
						strHistory = strHistory & chkIIF(i=j," ()","") & "</a></em>"
					End If
				next
			End If
		end if
		
		rsget.Close
		vCateCnt = i
		
		printDistCateHistory = strHistory
	end function

	'RecoPick 스트립트 관련 내용 추가; 2014.11.17 허진원 추가
	RecoPickSCRIPT = "	recoPick('page', 'search', '" & SearchText & "');"
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 상품 검색 결과</title>
<script type="text/javascript" src="/lib/js/SearchAutoComplete.js"></script>
<script type="text/javascript">
$(function(){
	var mySwiper0 = new Swiper('.location .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:<%=vCateCnt-1%>,
		slidesPerView: 'auto'
	})

	$('.relatedBrd .relTit').click(function(){
		$(this).toggleClass('on');
		$(this).next('.viewBrd').slideToggle();
	});

	$('.viewBrd li').hide();
	$('.viewBrd li:lt(3)').show();
	var listItem = $('.viewBrd li').length;
	var visibleItem = 6;
	$('.viewBrd .more').click(function () {
		visibleItem = $('.viewBrd li:visible').size()+6;
		if(visibleItem< listItem) {$('.viewBrd li:lt('+visibleItem+')').slideDown(300);}
		else {$('.viewBrd li:lt('+listItem+')').slideDown();
			$('.viewBrd .more').hide();
		}
	});
	if(3 > listItem) {
		$('.viewBrd .more').hide();
	}
});

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.action = "/search/search_item.asp";
	sFrm.submit();
}

function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
	document.sFrm.action = "/search/search_item.asp";
	sFrm.submit();
}

function goCategoryList(disp){
	document.sFrm.dispCate.value=disp;
	document.sFrm.action = "/search/search_item.asp";
	sFrm.submit();
}

function popDistCategory(){
	document.sFrm.action = "/search/popCategoryList.asp";
	sFrm.submit();
}

function goFilterSearch(rect,disp,mkr,iccd,styleCd,attribCd,deliType,minPrc,maxPrc){
	document.sFrm.rect.value		= rect;
	document.sFrm.dispCate.value	= disp;
	document.sFrm.mkr.value			= mkr;
	document.sFrm.iccd.value		= iccd;
	document.sFrm.styleCd.value		= styleCd;
	document.sFrm.attribCd.value	= attribCd;
	document.sFrm.deliType.value	= deliType;
	document.sFrm.minPrc.value		= minPrc;
	document.sFrm.maxPrc.value		= maxPrc;
	document.sFrm.submit();
}

function popFilterSearch(){
	var rect		= encodeURIComponent(document.sFrm.rect.value);
	var disp		= document.sFrm.dispCate.value;
	var mkr			= document.sFrm.mkr.value;
	var iccd		= document.sFrm.iccd.value;
	var styleCd		= document.sFrm.styleCd.value;
	var attribCd	= document.sFrm.attribCd.value;
	var deliType	= document.sFrm.deliType.value;
	var minPrc		= document.sFrm.minPrc.value;
	var maxPrc		= document.sFrm.maxPrc.value;
	var lstDiv		= document.sFrm.lstDiv.value;

	fnOpenModal('/category/pop_Filter43.asp?rect='+rect+'&disp='+disp+'&mkr='+mkr+'&iccd='+iccd+'&styleCd='+styleCd+'&attribCd='+attribCd+'&deliType='+deliType+'&minPrc='+minPrc+'&maxPrc='+maxPrc+'&lstDiv='+lstDiv);
}
</script>
</head>
<body>
<div class="heightGrid" style="height:auto !important;">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<h1 class="hide">검색</h1>
			<!-- search  -->
			<div class="search">
				<form action="<%=wwwUrl%>/search/search_item.asp" onSubmit="return fnTopSearch();" name="searchForm" method="get">
				<input type="hidden" name="cpg" value="1">
				<input type="hidden" name="burl" value="<%=retUrl%>">
					<fieldset>
						<input type="search" name="rect" value="<%=SearchText%>" title="검색어 입력" required placeholder="검색어를 입력하세요." onkeyup="fnKeyInput();" autocomplete="off" />
						<input type="submit" value="검색" class="btnSch" />
						<button type="button" class="btnCancel" onclick="location.href='<%=retUrl%>'; return false;">취소</button>
					</fieldset>
				</form>
			</div>
			<!-- //search -->

			<!-- 자동완성 -->
			<div id="lyrAutoComp" class="autoComplete" style="display:none;">
				<div class="schKwd">
					<div id="atl"></div>
					<p class="schFoot"><button type="button" class="closeKwd" onclick="fnSACLayerOnOff(false)">닫기</button></p>
				</div>
				<div class="bg"></div>
			</div>
			<!-- 자동완성 -->

			<!-- 검색 결과 -->
			<% IF oDoc.FResultCount >0 Then %>
			<div class="schResult">

				<%
					'// 연관검색어
					Dim iRows
					if oTotalCnt.FTotalCount>0 then
						dim oRckDoc, arrList
						set oRckDoc = new SearchItemCls
							oRckDoc.FRectSearchTxt = SearchText
							arrList = oRckDoc.getRecommendKeyWords()
						Set oRckDoc = nothing

						IF isArray(arrList) THEN
							if Ubound(arrList)>0 then
				%>
				<div class="relatedKwd">
					<p class="relTit"><strong>연관 검색어</strong></p>
					<ul>
					<% Dim tempcount 
						If Ubound(arrList) > 5 Then
							tempcount  = Ubound(arrList) - 2
						Else 
							tempcount  = Ubound(arrList)
						End if
						For iRows=0 To tempcount
							Response.Write "<li><a href='/search/search_item.asp?rect=" & Server.URLEncode(arrList(iRows)) & "&exkw=1&burl=" & Server.URLEncode(retUrl) & "'>" & arrList(iRows) & "</a></li>"
						Next
					%>
					</ul>
				</div>
				<%
							end if
						end if
					end if
				%>

				<%
					'// 브랜드 검색결과
					if oGrBrn.FResultCount>0 then
				%>
				<div class="relatedBrd">
					<p class="relTit"><strong>브랜드(<%=brnTTCnt%>)</strong></p>
					<div class="viewBrd">
						<ul>
						<%
							for lp=0 to oGrBrn.FResultCount-1
						%>
							<li><a href="/street/street_brand.asp?makerid=<%=oGrBrn.FItemList(lp).FMakerID%>"><em><%=oGrBrn.FItemList(lp).FBrandName%></em> (<%=formatNumber(oGrBrn.FItemList(lp).FItemScore,0)%>) <% if oGrBrn.FItemList(lp).FisBestBrand="Y" then %><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_best2.png" alt="Best" style="width:19px" class="ico" /><% End If %></a></li>
						<%
							next

							if oGrBrn.FResultCount>3 then  moreYn="Y"
						%>
						</ul>
						<% if moreYn="Y" then %><p class="more" onclick=""><span>더보기</span></p><% End If %>
					</div>
				</div>
				<%
					End If 
				%>
			</div>

			<div class="schResultTxt">
				<p>"<strong class="cRd1"><%=SearchText%></strong>" 검색결과 <strong class="cRd1"><%=FormatNumber(oTotalCnt.FTotalCount,0)%></strong>개</p>
			</div>

			<div class="location">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<em class="swiper-slide"><a href="" onclick="goCategoryList(''); return false;" >전체</a></em>
						<% If vIsLastDepth Then %>
							<%= vCateNavi %>
						<% Else %>
							<%= vCateNavi %><p class="swiper-slide"><span class="button btS1 btGry2 cWh1"><a href="" onclick="popDistCategory(); return false;">카테고리</a></span></p>
						<% End If %>
					</div>
				</div>
			</div>

			<div class="inner10">
				<div class="sorting">
					<p <%=CHKIIF(SortMet="ne","class=selected","")%>><span class="button"><a href="" onclick="jsGoSort('ne'); return false;">신상순</a></span></p>
					<p <%=CHKIIF(SortMet="be","class=selected","")%>><span class="button"><a href="" onclick="jsGoSort('be'); return false;">인기순</a></span></p>
					<p <%=CHKIIF(SortMet="br","class=selected","")%>><span class="button"><a href="" onclick="jsGoSort('br'); return false;">리뷰순</a></span></p>
					<% If SortMet = "lp" OR SortMet = "hp" Then %>
						<% If SortMet = "hp" Then %>
						<p class="selected downSort"><span class="button priceBtn"><a href="" onclick="jsGoSort('lp'); return false;">가격순</a></span></p>
						<% Else %>
						<p class="selected upSort"><span class="button priceBtn"><a href="" onclick="jsGoSort('hp'); return false;">가격순</a></span></p>
						<% End If %>
					<% Else %>
						<p><span class="button priceBtn"><a href="" onclick="jsGoSort('lp'); return false;">가격순</a></span></p>
					<% End If %>
					<p><span class="button filterBtn"><a href="" onclick="popFilterSearch(); return false;">필터</a></span></p>
				</div>
				<div class="pdtListWrap">
					<ul class="pdtList">
						<% For i=0 To oDoc.FResultCount-1 %>
						<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%>>
							<div class="pPhoto" onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>';">
								<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<p><span><em>품절</em></span></p>","")%>
								<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" />
							</div>
							<div class="pdtCont">
								<p class="pBrand"><% = oDoc.FItemList(i).FBrandName %></p>
								<p class="pName" onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>';"><% = oDoc.FItemList(i).FItemName %></p>
								<% IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then %>
									<% IF oDoc.FItemList(i).IsSaleItem Then %>
										<!-- <p class="ftSmall2 c999"><del><% = FormatNumber(oDoc.FItemList(i).getOrgPrice,0) %>원</del></p> -->
										<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oDoc.FItemList(i).getSalePro %>]</span></p>
									<% End IF %>
									<% IF oDoc.FItemList(i).IsCouponItem Then %>
										<% IF Not(oDoc.FItemList(i).IsFreeBeasongCoupon() or oDoc.FItemList(i).IsSaleItem) then %>
											<!-- <p class="ftSmall2 c999"><del><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원</del></p> -->
										<% End IF %>
										<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oDoc.FItemList(i).GetCouponDiscountStr %>]</span></p>
									<% End IF %>
								<% Else %>
									<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %><% if oDoc.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
								<% End if %>
								<p class="pShare">
									<span class="cmtView"><%=formatNumber(oDoc.FItemList(i).FEvalCnt,0)%></span>
									<span class="wishView" onclick=""><%=formatNumber(oDoc.FItemList(i).FfavCount,0)%></span>
								</p>
							</div>
						</li>
						<%
							Next
						%>
					</ul>
				</div>
				<%=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,12,4,"jsGoPage")%>
			</div>
			<% Else %>
			<div class="noResult">
				<p><strong>흠...<span class="cRd1">검색결과</span>가 없습니다.</strong></p>
				<p class="tPad10 fs12">해당상품이 품절 되었을 경우 <br />검색이 되지 않습니다.</p>
			</div>
			<% End If %>
			<!-- // 검색 결과 -->
		</div>
		<form name="sFrm" id="listSFrm" method="get" action="/search/search_item.asp" style="margin:0px;">
		<input type="hidden" name="rect" value="<%= SearchText %>">
		<input type="hidden" name="prvtxt" value="<%= PrevSearchText %>">
		<input type="hidden" name="rstxt" value="<%= ReSearchText %>">
		<input type="hidden" name="extxt" value="<%= ExceptText %>">
		<input type="hidden" name="sflag" value="<%= SearchFlag  %>">
		<input type="hidden" name="dispCate" value="<%= dispCate %>">
		<input type="hidden" name="cpg" value="">
		<input type="hidden" name="chkr" value="<%= CheckResearch %>">
		<input type="hidden" name="chke" value="<%= CheckExcept %>">
		<input type="hidden" name="mkr" value="<%= makerid %>">
		<input type="hidden" name="sscp" value="<%= SellScope %>">
		<input type="hidden" name="psz" value="<%= PageSize %>">
		<input type="hidden" name="srm" value="<%= SortMet %>">
		<input type="hidden" name="iccd" value="<%=colorCD%>">
		<input type="hidden" name="styleCd" value="<%=styleCd%>">
		<input type="hidden" name="attribCd" value="<%=attribCd%>">
		<input type="hidden" name="icoSize" value="">
		<input type="hidden" name="arrCate" value="<%=arrCate%>">
		<input type="hidden" name="deliType" value="<%=deliType%>">
		<input type="hidden" name="minPrc" value="<%=minPrice%>">
		<input type="hidden" name="maxPrc" value="<%=maxPrice%>">
		<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
		<input type="hidden" name="burl" value="<%=retUrl%>">
		</form>
		<!-- //content area -->
	</div>
</div>
<div id="modalLayer" style="display:none;"></div>
<% IF application("Svr_Info") <> "Dev" THEN %>
<!-- Google -->
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-16971867-4']);
  _gaq.push(['_trackPageview']);
   <%
   if (googleANAL_ADDSCRIPT<>"") then
		Response.Write googleANAL_ADDSCRIPT
   end if
   %>
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>

<!-- RecoPick -->
<script type="text/javascript">
  (function(w,d,n,s,e,o) {
    w[n]=w[n]||function(){(w[n].q=w[n].q||[]).push(arguments)};
    e=d.createElement(s);e.async=1;e.charset='utf-8';e.src='//static.recopick.com/dist/production.min.js';
    o=d.getElementsByTagName(s)[0];o.parentNode.insertBefore(e,o);
  })(window, document, 'recoPick', 'script');
  recoPick('site', '10x10.co.kr');
<%
	if (RecoPickSCRIPT<>"") then
		Response.Write RecoPickSCRIPT
	else
		Response.Write "recoPick('page','view');"
	end if

	if request.cookies("uinfo")("shix")<>"" then
		response.Write "recoPick('setMID', '" & request.cookies("uinfo")("shix") & "');"
	end if
%>
</script>
<% end if %>
</body>
</html>
<%
	set oGrCat = Nothing
	set oTotalCnt = Nothing
	set oDoc = Nothing
	Set oGrBrn = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
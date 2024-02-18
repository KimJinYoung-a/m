<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_M.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/memcacheLib.asp" -->
<%
Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
If vDisp = "" Then
	vDisp = "101"
End If
Dim vDepth
	If vDisp = "" Then
		vDepth = "1"
	Else
		vDepth = Len(vDisp)/3
	End If
	
dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로
Dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
Dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
Dim ListDiv : ListDiv = "list" '카테고리/검색 구분용 
Dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
Dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
Dim deliType : deliType = requestCheckVar(request("deliType"),2)
Dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
dim arrCate : arrCate = ReplaceRequestSpecialChar(request("arrCate"))
dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))
Dim CurrPage : CurrPage = getNumeric(requestCheckVar(request("cpg"),6))
dim CheckExcept : CheckExcept= request("chke")
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),5))
Dim LogsAccept : LogsAccept = true
Dim makerid : makerid = requestCheckVar(request("mkr"),32)
dim DocSearchText
dim SearchItemDiv : SearchItemDiv="n"	'기본 카테고리만
dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
dim ExceptText : ExceptText=requestCheckVar(request("extxt"),100) '결과내 제외어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
	if SellScope = "" then SellScope = "Y"
dim PrevSearchText : PrevSearchText = requestCheckVar(request("prvtxt"),100) '이전 검색어
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
Dim tmpPrevSearchKeyword, tmpCurrSearchKeyword
Dim isSaveSearchKeyword : isSaveSearchKeyword = true  ''검색어 DB에 저장 여부
dim CheckResearch : CheckResearch= request("chkr")
dim IsRealTypedKeyword : IsRealTypedKeyword = True
Dim lp, LicdL,LicdM,LicdS
Dim GRScope, pLicdL, pLicdM, vImgSize, i
	vImgSize = getNumeric(requestCheckVar(request("imgsize"),3))
	if vImgSize = "" Then vImgSize = 290
		
	If vImgSize <> "200" AND vImgSize <> "290" Then
		vImgSize = "290"
	End If

Dim ScrollCount : ScrollCount = 5	
	If CurrPage="" Then CurrPage=1
	If PageSize="" Then PageSize=12
	'If colorCD="" Then colorCD="0"
	If SortMet="" Then SortMet="ne"		'베스트:be, 신상:ne
	IF searchFlag="" Then searchFlag= "n"

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

'// 총 검색수 산출
dim oTotalCnt
set oTotalCnt = new SearchItemCls
	oTotalCnt.FRectSearchTxt = DocSearchText
	oTotalCnt.FRectExceptText = ExceptText
	oTotalCnt.FRectSearchItemDiv = SearchItemDiv
	oTotalCnt.FRectSearchCateDep = SearchCateDep
	oTotalCnt.FListDiv = ListDiv
	oTotalCnt.FSellScope=SellScope
	oTotalCnt.getTotalCount

'// 상품검색
dim oDoc,iLp
set oDoc = new SearchItemCls
	oDoc.FRectSearchTxt = DocSearchText
	oDoc.FRectPrevSearchTxt = PrevSearchText
	oDoc.FRectExceptText = ExceptText
	oDoc.FRectSortMethod	= SortMet
	oDoc.FRectSearchFlag = searchFlag
	oDoc.FRectSearchItemDiv = SearchItemDiv
	oDoc.FRectSearchCateDep = SearchCateDep
	oDoc.FRectCateCode	= vDisp
	oDoc.FRectMakerid	= makerid
	oDoc.FminPrice	= minPrice
	oDoc.FmaxPrice	= maxPrice
	oDoc.FdeliType	= deliType
	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
	oDoc.FScrollCount = ScrollCount
	oDoc.FListDiv = ListDiv
	oDoc.FLogsAccept = LogsAccept
	oDoc.FcolorCode = colorCD
	oDoc.FSellScope=SellScope
	oDoc.getSearchList

'// 검색어 DB저장
tmpPrevSearchKeyword = PrevSearchText
tmpCurrSearchKeyword = SearchText

'// 검색 조건 재설정
PrevSearchText = SearchText
'CheckResearch=false

'// 검색결과 내위시 표시정보 접수
if IsUserLoginOK then
	'// 검색결과 상품목록 작성
	dim rstArrItemid: rstArrItemid=""
	IF oDoc.FResultCount >0 then 
		For iLp=0 To oDoc.FResultCount -1
			rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(iLp).FItemID
		Next
	End if
	'// 위시결과 상품목록 작성
	dim rstWishItem: rstWishItem=""
	dim rstWishCnt: rstWishCnt=""
	if rstArrItemid<>"" then
		Call getMyFavItemList(getLoginUserid(),rstArrItemid,rstWishItem, rstWishCnt)
	end if
end if

'// 카테고리 총상품수 산출 함수
function getCateListCount(srcFlag,sDiv,sDep,dspCd,arrCt,mkrid,ccd,stcd,atcd,deliT,lDiv,sRect,sExc)
	dim oTotalCnt
	set oTotalCnt = new SearchItemCls
		oTotalCnt.FRectSearchFlag = srcFlag
		oTotalCnt.FRectSearchItemDiv = sDiv
		oTotalCnt.FRectSearchCateDep = sDep
		oTotalCnt.FRectCateCode	= dspCd
		oTotalCnt.FarrCate=arrCt
		oTotalCnt.FRectMakerid	= mkrid
		oTotalCnt.FcolorCode= ccd
		oTotalCnt.FstyleCd= stcd
		oTotalCnt.FattribCd = atcd
		oTotalCnt.FdeliType	= deliT
		oTotalCnt.FListDiv = lDiv
		oTotalCnt.FRectSearchTxt = sRect
		oTotalCnt.FRectExceptText = sExc
		oTotalCnt.FSellScope=SellScope
		oTotalCnt.getTotalCount
		getCateListCount = oTotalCnt.FTotalCount
	set oTotalCnt = Nothing
end function

''// 검색어 로그 저장
'if isSaveSearchKeyword and (tmpCurrSearchKeyword <> tmpPrevSearchKeyword) and (Not CheckResearch) and IsRealTypedKeyword then
'	dim oKeyword
'	dim keywordDataArray(3)
'	set oKeyword = new CKeywordCls
'
'	keywordDataArray(0) = oTotalCnt.FTotalCount
'
'	if IsUserLoginOK then
'		keywordDataArray(1) = GetLoginUserID
'	else
'		keywordDataArray(1) = ""
'	end if
'
'	keywordDataArray(2) = Request.ServerVariables("REMOTE_ADDR")
'
'	Call oKeyword.SaveToDatabaseWithDataArray(tmpCurrSearchKeyword, tmpPrevSearchKeyword, keywordDataArray)
'
'	set oKeyword = Nothing
'end if


'### 현재 위치 ###
Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
vIsLastDepth = fnIsLastDepth(vDisp)
vCateNavi = printCategoryHistorymultiNew(vDisp,vIsLastDepth,true,vCateCnt)

If (searchFlag="n") Then
	vCateItemCount = FormatNumber(oDoc.FTotalCount,0)
ElseIf (isShowSumamry) Then
	vCateItemCount = FormatNumber(getCateListCount("n",SearchItemDiv,SearchCateDep,vDisp,arrCate,makerid,colorCD,styleCd,attribCd,deliType,ListDiv,DocSearchText,ExceptText),0)
End If
vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=getDisplayCateNameDB(vDisp)%></title>
<script type="text/javascript">
$(function() {
	var mySwiper0 = new Swiper('.location .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:<%=vCateCnt-1%>,
		slidesPerView: 'auto'
	})
});
function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.action = "category_list.asp";
	sFrm.submit();
}
function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
	document.sFrm.action = "category_list.asp";
	sFrm.submit();
}
function moveCategorysub(cate1){
	location.href="/category/category_sub.asp?disp="+cate1;
}
function goCategoryList(){
	document.sFrm.action = "popCategoryList.asp";
	sFrm.submit();
}
function goFilterSearch(){
	document.sFrm.action = "popFilter.asp";
	sFrm.submit();
}
function goWishPop(i){
<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
	document.sFrm.itemid.value = i;
	document.sFrm.action = "/common/popWishFolder.asp";
	sFrm.submit();
<% Else %>
	top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
<% End If %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="location">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<em class="swiper-slide"><a href="/">HOME</a></em>
							<% If vIsLastDepth Then %>
								<%= vCateNavi %>
							<% Else %>
								<%= vCateNavi %><p class="swiper-slide"><span class="button btS1 btGry2 cWh1"><a href="" onClick="goCategoryList(); return false;">카테고리</a></span></p>
							<% End If %>
						</div>
					</div>
				</div>
				<form name="sFrm" id="listSFrm" method="get" action="category_list.asp" style="margin:0px;">
				<input type="hidden" name="rect" value="<%= SearchText %>">
				<input type="hidden" name="prvtxt" value="<%= PrevSearchText %>">
				<input type="hidden" name="rstxt" value="<%= ReSearchText %>">
				<input type="hidden" name="extxt" value="<%= ExceptText %>">
				<input type="hidden" name="sflag" value="<%= SearchFlag  %>">
				<input type="hidden" name="disp" value="<%= vDisp %>">
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
				<input type="hidden" name="itemid" value="">
				<input type="hidden" name="ErBValue" value="1">
				</form>
				<div class="inner10">
					<div class="sorting">
						<p <%=CHKIIF(SortMet="ne","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('ne'); return false;">신상순</a></span></p>
						<p <%=CHKIIF(SortMet="be","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('be'); return false;">인기순</a></span></p>
						<p <%=CHKIIF(SortMet="br","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('br'); return false;">리뷰순</a></span></p>
						<% If SortMet = "lp" OR SortMet = "hp" Then %>
							<% If SortMet = "hp" Then %>
							<p class="selected upSort"><span class="button priceBtn"><a href="" onClick="jsGoSort('lp'); return false;">가격순</a></span></p>
							<% Else %>
							<p class="selected downSort"><span class="button priceBtn"><a href="" onClick="jsGoSort('hp'); return false;">가격순</a></span></p>
							<% End If %>
						<% Else %>
							<p><span class="button priceBtn"><a href="" onClick="jsGoSort('lp'); return false;">가격순</a></span></p>
						<% End If %>
						<p><span class="button filterBtn"><a href="" onClick="goFilterSearch(); return false;">필터</a></span></p>
					</div>
					<% IF oDoc.FResultCount >0 Then %>
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
										<span class="wishView" onclick="goWishPop('<%= oDoc.FItemList(i).FItemID %>');"><%=formatNumber(oDoc.FItemList(i).FfavCount,0)%></span>
									</p>
								</div>
							</li>
							<% Next %>
						</ul>
					</div>
					<%=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,12,4,"jsGoPage")%>
					<% Else %>
						<div class="noData ct tMar30">
							<p><strong>흠...<span class="cRd1">조건에 맞는 상품</span>이 없습니다.</strong></p>
							<p class="fs12">해당상품이 품절 되었을 경우 <br />검색이 되지 않습니다.</p>
						</div>
					<% End If %>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
	set oTotalCnt = Nothing
	set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
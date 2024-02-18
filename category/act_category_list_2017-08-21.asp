<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
If vDisp = "" Then
	vDisp = "101"
End If

'클리어런스 카테고리 > sale클리어런스로 이동(2016.07.26)
if vDisp="123" then
	Response.Redirect "/clearancesale/"
end if

'//logparam
Dim logparam : logparam = "&pCtr="&vDisp

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
%>
<% For i=0 To oDoc.FResultCount-1 %>
<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%>>
	<div class="pPhoto" onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam%>';">
		<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<p><span><em>품절</em></span></p>","")%>
		<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" />
	</div>
	<div class="pdtCont">
		<p class="pBrand"><% = oDoc.FItemList(i).FBrandName %></p>
		<p class="pName" onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=logparam%>';"><% = oDoc.FItemList(i).FItemName %></p>
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
			<% If G_IsPojangok Then %>
			<% IF oDoc.FItemList(i).IsPojangitem Then %><i class="pkgPossb">선물포장 가능상품</i><% End if %>
			<% End if %>
		</p>
	</div>
</li>
<% Next %>
<%
	set oTotalCnt = Nothing
	set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

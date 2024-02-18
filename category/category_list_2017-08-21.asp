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
	If SortMet="" Then SortMet="be"		'베스트:be, 신상:ne '// 2017-06-27 이종화 ne => be 변경
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
function getCateListCount(srcFlag,sDiv,sDep,dspCd,arrCt,mkrid,ccd,stcd,atcd,deliT,lDiv,sRect,sExc,SellScope)
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
vCateNavi = fnPrnCategoryHistorymultiV16(vDisp,"X",vCateCnt,"goCategoryList")

If (searchFlag="n") Then
	vCateItemCount = FormatNumber(oDoc.FTotalCount,0)
ElseIf (isShowSumamry) Then
	vCateItemCount = FormatNumber(getCateListCount(searchFlag,SearchItemDiv,SearchCateDep,vDisp,arrCate,makerid,colorCD,styleCd,attribCd,deliType,ListDiv,DocSearchText,ExceptText,SellScope),0)
End If
vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")

'//페이지 타이틀
strHeadTitleName = getDisplayCateNameDB(vDisp)
strPageKeyword = CategoryNameUseLeftMenuDB(left(vDisp,3)) & ", " & replace(strHeadTitleName,"""","")

'// 카테고리=사용안함, 2016-06-15, skyer9
dim vCateNameToSearchStr : vCateNameToSearchStr = ""
if oDoc.FResultCount < 1 then
	if GetCategoryUseYN(vDisp) = "N" then
		vCateNameToSearchStr = Server.URLEncode(Replace(strHeadTitleName, "/", " "))

		Response.Redirect "/search/search_item.asp?rect=" & vCateNameToSearchStr & "&exkw=1"
		dbget.Close
		REsponse.End
	end if
end If

'// 구글 ADS 스크립트 관련(2017.05.29 원승현 추가)
googleADSCRIPT = " <script type='text/javascript'> "&vbCrLf
googleADSCRIPT = googleADSCRIPT & " var google_tag_params = { "&vbCrLf
googleADSCRIPT = googleADSCRIPT & "		ecomm_prodid: '', "&vbCrLf
googleADSCRIPT = googleADSCRIPT & "		ecomm_pagetype: 'category', "&vbCrLf
googleADSCRIPT = googleADSCRIPT & "		ecomm_totalvalue: '' "&vbCrLf
googleADSCRIPT = googleADSCRIPT & "	}; "&vbCrLf
googleADSCRIPT = googleADSCRIPT & "	</script> "

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=getDisplayCateNameDB(vDisp)%></title>
<script type="text/javascript">
$(function() {
	var mySwiper0 = new Swiper('.breadcrumbV15a .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:<%=vCateCnt-1%>,
		slidesPerView: 'auto'
	})

	//content area height calculate
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

	//Open option Nani control
	$(".viewSortV16a button").click(function(){
		if($(this).parent('.sortGrp').hasClass('current')){
			$(".sortGrp").removeClass('current');
			$("#contBlankCover").fadeOut();
		} else {
			$(".sortGrp").removeClass('current');
			$(this).parent('.sortGrp').addClass('current');
			$("#contBlankCover").fadeIn();
			contHCalc();
		}
	});

	//Close option Nani control
	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
	});

	<% if CurrPage>1 then %>window.parent.$('html,body').animate({scrollTop:$(".itemWrapV15a").offset().top}, 0);<% end if %>
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

function goCategoryList(disp){
	document.sFrm.cpg.value = 1;
	document.sFrm.disp.value=disp;
	document.sFrm.action = "category_list.asp";
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

function goFilterSearch(rect,disp,mkr,iccd,styleCd,attribCd,deliType,minPrc,maxPrc,rstxt,sflag,sscp){
	document.sFrm.rect.value		= rect;
	if(rstxt.length>0) {
		document.sFrm.rstxt.value		= rstxt;
		document.sFrm.chkr.value		= true;
	} else {
		document.sFrm.rstxt.value		= "";
		document.sFrm.chkr.value		= false;
	}
	document.sFrm.disp.value	= disp;
	document.sFrm.mkr.value			= mkr;
	document.sFrm.iccd.value		= iccd;
	document.sFrm.styleCd.value		= styleCd;
	document.sFrm.attribCd.value	= attribCd;
	document.sFrm.deliType.value	= deliType;
	document.sFrm.minPrc.value		= minPrc;
	document.sFrm.maxPrc.value		= maxPrc;
	document.sFrm.sflag.value		= sflag;
	document.sFrm.sscp.value		= sscp;
	document.sFrm.submit();
}

function popFilterSearch(){
	var rect		= encodeURIComponent(document.sFrm.rect.value);
	var rstxt		= encodeURIComponent(document.sFrm.rstxt.value);
	var disp		= document.sFrm.disp.value;
	var mkr			= document.sFrm.mkr.value;
	var iccd		= document.sFrm.iccd.value;
	var styleCd		= document.sFrm.styleCd.value;
	var attribCd	= document.sFrm.attribCd.value;
	var deliType	= document.sFrm.deliType.value;
	var minPrc		= document.sFrm.minPrc.value;
	var maxPrc		= document.sFrm.maxPrc.value;
	var lstDiv		= document.sFrm.lstDiv.value;
	var sflag		= document.sFrm.sflag.value;
	var sscp		= document.sFrm.sscp.value;

	fnOpenModal('/category/pop_Filter.asp?rect='+rect+'&disp='+disp+'&mkr='+mkr+'&iccd='+iccd+'&styleCd='+styleCd+'&attribCd='+attribCd+'&deliType='+deliType+'&minPrc='+minPrc+'&maxPrc='+maxPrc+'&lstDiv='+lstDiv+'&rstxt='+rstxt+'&sflag='+sflag+'&sscp='+sscp);
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					type: "POST",
					url: "act_category_list.asp?cpg="+vPg,
					data: $("#listSFrm").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content ctgyListV15a" id="contentArea">
			<%
				'카테고리가 있을때만 표시
				if vDepth>1 then
			%>
			<!-- breadcrumb -->
			<div class="breadcrumbV15a">
				<div class="swiper-container">
					<div class="swiper-wrapper"><%= vCateNavi %></div>
				</div>
			</div>
			<% end if %>

			<!-- sorting -->
			<div class="viewSortV16a ctgySortV16a">
				<div class="sortV16a">
					<div class="sortGrp category">
					<%
						'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
						Call fnPrntDispCateNaviV16(vDisp,"E","goCategoryList")
					%>
					</div>
					<div class="sortGrp array">
					<%
						'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
						Call fnPrntSortNaviV16(SortMet,"abcgdef", "jsGoSort")
					%>
					</div>
					<div class="sortGrp linkBtn">
						<p><a href="#" onclick="popFilterSearch(); return false;" class="fltrBtn">FILTER</a></p>
					</div>
				</div>
				<div id="contBlankCover" class="contBlankCover"></div>
			</div>
			<!--// sorting -->

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

				<section class="itemWrapV15a">
					<h2>카테고리 상품 리스트</h2>

					<% IF oDoc.FResultCount >0 Then %>
					<div class="pdtListWrapV15a">
						<ul class="pdtListV15a" id="lyrEvtList">
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
						</ul>
					</div>
					<%'=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,12,4,"jsGoPage")%>
					<% Else %>
						<script type="text/javascript" src="/common/addlog.js?tp=noresult&ror=<%=server.UrlEncode(Request.serverVariables("HTTP_REFERER"))%>"></script>
						<div class="noData ct tMar30">
							<p><strong>흠...<span class="cRd1">조건에 맞는 상품</span>이 없습니다.</strong></p>
							<p class="fs12">해당상품이 품절 되었을 경우 <br />검색이 되지 않습니다.</p>
						</div>
					<% End If %>
				</section>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
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

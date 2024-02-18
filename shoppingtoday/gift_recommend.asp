<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
Dim catecode, lp,sPercent, flo1, flo2, price, i
catecode = getNumeric(requestCheckVar(Request("disp"),3))
price =	requestCheckVar(Request("price"),3)
flo1 =	requestCheckVar(Request("flo1"),5) '// 무료배송
flo2 =	requestCheckVar(Request("flo2"),5) '// 한정판매
dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
dim icoSize		: icoSize = requestCheckVar(request("icoSize"),1)
dim minPrice, maxPrice

If price = "" Then
	price = "all"
End IF

'할인률 적용
Select Case price
	Case "0"
		minPrice = "1"
		maxPrice = "9999"
	Case "1"
		minPrice = "10000"
		maxPrice = "29999"
	Case "3"
		minPrice = "30000"
		maxPrice = "49999"
	Case "5"
		minPrice = "50000"
		maxPrice = "99999"
	Case "10"
		minPrice = "100000"
		maxPrice = "10000000"
end Select

if icoSize="" then icoSize="M"	'상품 아이콘 기본(중간)

dim ScrollCount
ScrollCount = 10

'추가 이미지 사이즈
dim imgSz	: imgSz = chkIIF(icoSize="M",180,150)

if SortMet="" then SortMet="ne"			''pj:인기포장순, ne:신상순
if CurrPage="" then CurrPage=1
if PageSize ="" then PageSize =16
'rw sPercent & "!"
dim oDoc,iLp
set oDoc = new SearchItemCls

oDoc.FListDiv 			= "fulllist"
oDoc.FRectSortMethod	= SortMet
oDoc.FRectSearchFlag 	= "pk"
oDoc.FPageSize 			= PageSize
oDoc.FRectCateCode		= catecode
oDoc.FisFreeBeasong		= flo1	'// 무료배송
oDoc.FisLimit			= flo2	'// 한정판매
oDoc.FminPrice			= minPrice
oDoc.FmaxPrice			= maxPrice
oDoc.FRectSearchItemDiv = "n"
oDoc.FRectSearchCateDep = "T"
oDoc.FCurrPage 			= CurrPage
oDoc.FSellScope 		= "Y"
oDoc.FScrollCount 		= ScrollCount

oDoc.getSearchList
%>
<script type="text/javascript">
$(function() {
	//sorting option control
	//content area height calculate
	function contHCalc() {
		var contH = $('.content').outerHeight();
		$('.contBlankCover').css('height',contH+'px');
	}

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

	$(".contBlankCover").click(function(){
		$(".contBlankCover").fadeOut();
		$(".viewSortV16a div").removeClass('current');
	});

	$(".sortNaviV16a li a").click(function(e){
		e.preventDefault()
		var selectTxt = $(this).text();
		$(this).parents('.sortNaviV16a').find('li').removeClass('selected');
		$(this).parent('li').addClass('selected');
		$(this).parents('.sortGrp').children('button').text(selectTxt);
		$(this).parents('.sortGrp').removeClass('current');
		$(".contBlankCover").fadeOut();
	});
	
	var mySwiper0 = new Swiper('.location .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:2, //for dev msg : location 슬라이드 갯수(-1)만큼 적용되도록 처리해주세요
		slidesPerView: 'auto'
	})
});

function goPage(iP){
	document.sFrm.cpg.value = iP;
	sFrm.submit();
}

function jsGoUrl(v){
    document.sFrm.price.value = v;
	document.sFrm.cpg.value = 1;
	sFrm.submit();
}

function fnSearch(frmval){
	document.sFrm.srm.value = frmval;
	document.sFrm.cpg.value=1;
	sFrm.submit();
}

function jsCateGo(v){
	document.sFrm.disp.value = v;
	document.sFrm.cpg.value=1;
	sFrm.submit();
}

function jsSortMet(a){
	document.sFrm.cpg.value = 1;
	document.sFrm.srm.value = a;
	document.sFrm.submit();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content wrapListV16a" id="contentArea">
				<div class="pkgGuideBnrV15a ">
					<p>정성 두배, 감동 두배! 선물포장 서비스를 지금 이용해보세요!<br />여러 가지 상품을 한번에 모아서 선물을 보낼 수 있습니다.</p>
					<em>포장비 2,000원 (선물 메시지 포함)</em>
				</div>
				<form name="sFrm" method="get" action="/shoppingtoday/gift_recommend.asp" style="margin:0px;">
				<input type="hidden" name="sflag" value="<%= oDoc.FRectSearchFlag  %>">
				<input type="hidden" name="disp" value="<%= oDoc.FRectcatecode %>">
				<input type="hidden" name="srm" value="<%= oDoc.FRectSortMethod%>">
				<input type="hidden" name="cpg" value="<%=oDoc.FCurrPage %>">
				<input type="hidden" name="price" value="<%= price%>">
				</form>
				<div class="viewSortV16a wrappSortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'정렬상자 호출; sDisp:전시카테고리, sType:확장여부, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntDispCateNaviV16(catecode,"F","jsCateGo")
						%>
						</div>
						<div class="sortGrp array">
							<button type="button">
							<%	'### css 안먹어서.
							SELECT CASE price
								Case "all" : Response.Write "전체 가격대"
								Case "0" : Response.Write "1만원 미만"
								Case "1" : Response.Write "1~3만원"
								Case "3" : Response.Write "3~5만원"
								Case "5" : Response.Write "5~10만원"
								Case "10" : Response.Write "10만원 이상"
							End SELECT
							%>
							</button>
							<div class="sortNaviV16a">
								<ul>
									<li <%=CHKIIF(price="all","class='selected'","")%>><a href="" onClick="jsGoUrl('all');return false;">전체 가격대</a></li>
									<li <%=CHKIIF(price="0","class='selected'","")%>><a href="" onClick="jsGoUrl('0');return false;">1만원 미만</a></li>
									<li <%=CHKIIF(price="1","class='selected'","")%>><a href="" onClick="jsGoUrl('1');return false;">1~3만원</a></li>
									<li <%=CHKIIF(price="3","class='selected'","")%>><a href="" onClick="jsGoUrl('3');return false;">3~5만원</a></li>
									<li <%=CHKIIF(price="5","class='selected'","")%>><a href="" onClick="jsGoUrl('5');return false;">5~10만원</a></li>
									<li <%=CHKIIF(price="10","class='selected'","")%>><a href="" onClick="jsGoUrl('10');return false;">10만원 이상</a></li>
								</ul>
							</div>
						</div>
						<div class="sortGrp array">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviV16(SortMet,"ahbcdef", "jsSortMet")
						%>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>
				<div class="pdtListWrapV15a">
					<ul class="pdtListV15a">
					<% IF oDoc.FResultCount >0 Then %>
						<% For i=0 To oDoc.FResultCount-1 %>
						<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%> onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>';">
							<div class="pPhoto">
								<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<p><span><em>품절</em></span></p>","")%>
								<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,300,300,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" />
							</div>
							<div class="pdtCont">
								<p class="pBrand"><% = oDoc.FItemList(i).FBrandName %></p>
								<p class="pName"><% = oDoc.FItemList(i).FItemName %></p>
								<% IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then %>
									<% IF oDoc.FItemList(i).IsSaleItem And oDoc.FItemList(i).isCouponItem = false Then %>
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
									<span class="wishView" _onclick="goWishPop('<%= oDoc.FItemList(i).FItemID %>');"><%=formatNumber(oDoc.FItemList(i).FfavCount,0)%></span>
									<% IF oDoc.FItemList(i).IsPojangitem Then %><i class="pkgPossb">선물포장 가능상품</i><% End If %>
								</p>
							</div>
						</li>
						<% Next %>
					<% Else %>
						<div align="center" id="srcnolist"><img src="http://fiximage.10x10.co.kr/m/common/noresult.png"></div>
					<% End If %>
					</ul>
				</div>

				<%=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,PageSize,4,"goPage")%>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% Set oDoc = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  브랜드
' History : 2013.12.13 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/search/searchcls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
Dim isShowSumamry : isShowSumamry = true  ''탭별 검색 갯수 표시 여부 : 느릴경우 FALSE 로

Dim oStreet, makerid, i, iLp, vDisp, vDepth, snsimg
makerid = requestCheckVar(Request("makerid"),32)
vDisp = requestCheckVar(getNumeric(Request("disp")),18)
If vDisp = "" Then
	vDepth = 1
Else
	vDepth = Len(vDisp)/3
End If

'상세검색용 파라메터
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
Dim colorCD : colorCD = requestCheckVar(request("iccd"),128)
dim styleCD : styleCD = ReplaceRequestSpecialChar(request("styleCd"))
dim attribCd : attribCd = ReplaceRequestSpecialChar(request("attribCd"))
Dim deliType : deliType = requestCheckVar(request("deliType"),2)
Dim minPrice : minPrice = getNumeric(requestCheckVar(request("minPrc"),8))
Dim maxPrice : maxPrice = getNumeric(requestCheckVar(request("maxPrc"),8))
SearchText = RepWord(SearchText,"[^가-힣a-zA-Z0-9.&%\-\s]","")

'// 나의 찜 브랜드
Dim LoginUserid
Dim isMyFavBrand: isMyFavBrand=false
LoginUserid = getLoginUserid()
If IsUserLoginOK then
	isMyFavBrand = getIsMyFavBrand(LoginUserid, makerid)
End If

Set oStreet = New CStreet
	oStreet.FRectMakerid = makerid
	oStreet.GetBrandstreetInfo

If oStreet.FResultCount=0 then
	Call Alert_Return("존재하지 않는 브랜드입니다.")
	dbget.close()	:	response.End
End If

Dim oDoc, PageSize, sflag
PageSize = requestCheckVar(getNumeric(request("pagesize")),3)
if PageSize = "" Then PageSize = 12

sflag = requestCheckVar(request("sflag"),4)
Dim SortMet		: SortMet = requestCheckVar(request("srm"),9)
Dim CurrPage 	: CurrPage = requestCheckVar(getNumeric(request("cpg")),9)
Dim SellScope 	: SellScope = requestCheckVar(request("sscp"),1)			'품절상품 제외여부
IF CurrPage="" Then CurrPage=1
IF SortMet="" Then SortMet="ne"

Dim ListDiv,ColsSize,ScrollCount
ListDiv="brand"
ScrollCount = 4

Set oDoc = new SearchItemCls
	oDoc.FRectSortMethod = SortMet
	oDoc.FRectSearchCateDep = "T"
	oDoc.FRectCateCode	= vDisp
	oDoc.FRectSearchItemDiv = "y"
	oDoc.FScrollCount = ScrollCount
	oDoc.FRectMakerid	= makerid
	oDoc.FCurrPage = CurrPage
	oDoc.FPageSize = PageSize
	oDoc.FListDiv = ListDiv
	oDoc.FSellScope=SellScope

	'상세 검색 추가(2016.05.23; 허진원)
	oDoc.FRectSearchTxt = SearchText
	oDoc.FcolorCode = colorCD
	oDoc.FstyleCd= styleCD
	oDoc.FattribCd = attribCd
	oDoc.FdeliType	= deliType
	oDoc.FminPrice	= minPrice
	oDoc.FmaxPrice	= maxPrice

	oDoc.getSearchList


Dim vArrIssue, vLink, cEvent, veventcnt
	veventcnt=0

set cEvent = new ClsEvtCont
	cEvent.FECode = 0
	cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
	cEvent.FDevice = "M" 'device
	cEvent.FBrand = makerid
	cEvent.FEDispCate = ""
	vArrIssue = cEvent.fnEventISSUEList
set cEvent = nothing

'### 현재 위치 ###
Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
if vDisp<>"" then
	vIsLastDepth = fnIsLastDepth(vDisp)
	vCateNavi = fnPrnCategoryHistorymultiV16(vDisp,"A",vCateCnt,"jsGoCategory")

	If (isShowSumamry) Then
		vCateItemCount = FormatNumber(getCateListCount("","","",vDisp,"",makerid,"","","","",ListDiv,"",""),0)
	End If
	vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")
end if

strPageKeyword = "브랜드 스트리트, " & replace(oStreet.FOneItem.Fsocname,"""","") & ", " & replace(oStreet.FOneItem.Fsocname_kor,"""","")

	'// 상품상세 로그 사용여부(2017.01.12)
	Dim LogUsingCustomChk
	If LoginUserId="thensi7" Then
		LogUsingCustomChk = True
	Else
		LogUsingCustomChk = True
	End If

	'// 상품상세 로그저장(2017.01.11 원승현)
	If LogUsingCustomChk Then
		If IsUserLoginOK() Then
			Call fnUserLogCheck("brand", LoginUserid, "", "", makerid, "mw")
		End If
	End If

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 브랜드: <%=oStreet.FOneItem.Fsocname_kor%></title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

$(function() {
	var mySwiper0 = new Swiper('.breadcrumbV15a .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:<%=cInt(len(vDisp)/3)-1%>,
		slidesPerView: 'auto'
	})

	$("div.evtnIsu h2").click(function(){
		if($("div.evtnIsu ul").is(":hidden")){
			$(this).parent().children('ul').show();
			$(this).children('em').hide();
		}else{
			$(this).parent().children('ul').hide();
			$(this).children('em').show();
		};
	});

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

});

function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
//	document.sFrm.action = "/street/street_brand.asp";
//	sFrm.submit();
	var vprm = $(document.sFrm).serialize()
	location.replace("?"+vprm);
}

function jsGoCategory(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.disp.value = a;
//	document.sFrm.action = "/street/street_brand.asp";
//	sFrm.submit();
	var vprm = $(document.sFrm).serialize()
	location.replace("?"+vprm);
}

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.action = "/street/street_brand.asp";
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

function TnMyBrandZZim(){
	<% If IsUserLoginOK() Then %>
		jjimfrm.action = "/street/domybrandjjim.asp";
		jjimfrm.submit();
	<% Else %>
		alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\로그인 하시겠습니까?");
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	<% End If %>
}

function goFilterSearch(rect,disp,mkr,iccd,styleCd,attribCd,deliType,minPrc,maxPrc,rstxt,sflag,sscp){
	document.sFrm.rect.value		= rstxt;
	document.sFrm.disp.value		= disp;
	document.sFrm.makerid.value		= mkr;
	document.sFrm.iccd.value		= iccd;
	document.sFrm.styleCd.value		= styleCd;
	document.sFrm.attribCd.value	= attribCd;
	document.sFrm.deliType.value	= deliType;
	document.sFrm.minPrc.value		= minPrc;
	document.sFrm.maxPrc.value		= maxPrc;
	document.sFrm.sflag.value		= sflag;
	document.sFrm.sscp.value		= sscp;
//	document.sFrm.submit();
	document.sFrm.cpg.value = "1";
	var vprm = $(document.sFrm).serialize()
	location.replace("?"+vprm);
}

function popFilterSearch(){
	var rect		= "";//encodeURIComponent(document.sFrm.rect.value);
	var rstxt		= encodeURIComponent(document.sFrm.rect.value);
	var disp		= document.sFrm.disp.value;
	var mkr			= document.sFrm.makerid.value;
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
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content brViewV16a" id="contentArea">
				<% ' for dev msg : 브랜드가 속한 대표카테고리별로 클래스 적용해주세요 (뒤의 숫자는 카테고리 코드) %>
				<% If oStreet.FOneItem.FBgImageURL = "" Then %>
					<%
					Select Case oStreet.FOneItem.FCatecode
						Case "101"		response.write "<div class='brandTitWrap ctgyBg01'>"
						Case "102"		response.write "<div class='brandTitWrap ctgyBg02'>"
						Case "103"		response.write "<div class='brandTitWrap ctgyBg03'>"
						Case "104"		response.write "<div class='brandTitWrap ctgyBg04'>"
						Case "114"		response.write "<div class='brandTitWrap ctgyBg14'>"
						Case "106"		response.write "<div class='brandTitWrap ctgyBg06'>"
						Case "112"		response.write "<div class='brandTitWrap ctgyBg12'>"
						Case "113"		response.write "<div class='brandTitWrap ctgyBg13'>"
						Case "115"		response.write "<div class='brandTitWrap ctgyBg15'>"
						Case "110"		response.write "<div class='brandTitWrap ctgyBg10'>"
						Case "111"		response.write "<div class='brandTitWrap ctgyBg11'>"
						Case "117"		response.write "<div class='brandTitWrap ctgyBg17'>"
						Case "116"		response.write "<div class='brandTitWrap ctgyBg16'>"
						Case "118"		response.write "<div class='brandTitWrap ctgyBg18'>"
						Case "121"		response.write "<div class='brandTitWrap ctgyBg21'>"	'/가구/조명
						Case "122"		response.write "<div class='brandTitWrap ctgyBg22'>"	'/데코/플라워
						Case "120"		response.write "<div class='brandTitWrap ctgyBg20'>"	'/패브릭/수납
						Case else 		response.write "<div class='brandTitWrap ctgyBg00'>"
					End Select
					%>
				<% elseIf oStreet.FOneItem.FBgImageURL <> "" Then %>
					<div class='brandTitWrap ctgyBg00'>
				<% else %>
					<div class='brandTitWrap ctgyBg00'>
				<% end if %>

					<div class="brandTitBox">
						<div class="brandTit">
							<div>
								<h2>
									<p><%=oStreet.FOneItem.Fsocname%></p>
									<span><%=oStreet.FOneItem.Fsocname_kor%></span>
								</h2>
								<span class="zzimBrView <%=chkIIF(isMyFavBrand,"myZzimBr","")%>">
									<a href="" onclick="TnMyBrandZZim(); return false;"><em><%=CurrFormat(oStreet.FOneItem.FRecommendcount)%></em></a>
								</span>
								<span class="zzimBrView brShare">
									<%
									if oStreet.FOneItem.FImageBasic<>"" and oStreet.FOneItem.fitemid<>"" then
										snsimg = getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(oStreet.FOneItem.fitemid) & "/" & oStreet.FOneItem.FImageBasic,"300","200","true","false")
									else
										snsimg = oStreet.FOneItem.Fsoclogo
									end if
									%>
									<a href="" onClick="popSNSShare('<%=oStreet.FOneItem.Fsocname_kor%>','<%=wwwUrl&CurrURLQ()%>','10x10 브랜드','<%= snsimg %>'); return false;"><img src="http://fiximage.10x10.co.kr/m/2014/brand/ico_brand_share.png" alt="공유" /></a>
								</span>
							</div>
						</div>
					</div>
					<span class="bkMask"></span>
					
					<% if oStreet.FOneItem.FBgImageURL<>"" then %>
						<% ' for dev msg : 브랜드 이미지 없는 경우 아예 노출안되게 해주세요 / alt값 속성에는 브랜드 명 넣어주세요 %>
						<img src="<%=getThumbImgFromURL(staticImgUrl &"/brandstreet/hello/"&oStreet.FOneItem.FBgImageURL,"480","225","true","false")%>" alt="<%=oStreet.FOneItem.Fsocname%>" />
					<% end if %>
				</div>

				<% if oStreet.FOneItem.FDesignis<>"" then %>
					<% ' for dev msg : design is 내용이 없는 브랜드인경우 통째로 노출안되게 해주세요 %>
					<div class="brandMsg">
						<dl>
							<dt>Design is</dt>
							<dd><%= oStreet.FOneItem.FDesignis %></dd>
						</dl>
					</div>
				<% end if %>

				<%
				if isArray(vArrIssue) THEN
				
					For i = 0 To UBound(vArrIssue,2)
						veventcnt = veventcnt + 1
					Next
				%>
					<% ' for dev msg : 이벤트 없는경우 통째로 노출안되게 해주세요 %>
					<div class="evtnIsuWrap">
						<div class="evtnIsu box1">
							<h2><span>EVENT &amp; ISSUE</span> <em class="cRd1">(<%= veventcnt %>)</em></h2>
							<ul class="list01">
								<%
								For i = 0 To UBound(vArrIssue,2)
									IF vArrIssue(2,i)="I" and vArrIssue(3,i)<>"" THEN '링크타입 체크
										vLink = "location.href='" & vArrIssue(3,i) & "';"
									ELSE
										vLink = """ onClick=""TnGotoEventMain('" & vArrIssue(0,i) & "'); return false;"
									END IF
								%>							
									<li><a href="<%=vLink%>"><%=db2html(vArrIssue(1,i))%></a></li>
								<% Next %>
							</ul>
						</div>
					</div>
				<% End If %>

				<%
					'카테고리가 있을때만 표시
					if len(vDisp)>=3 then
				%>
				<!-- breadcrumb -->
				<div class="breadcrumbV15a">
					<div class="swiper-container">
						<div class="swiper-wrapper"><%= vCateNavi %></div>
					</div>
				</div>
				<% end if %>

				<div class="viewSortV16a ctgySortV16a">
					<div class="sortV16a">
						<div class="sortGrp category">
						<%
							'정렬상자 호출; sMakerid:브랜드ID, sDisp:전시카테고리, sCallback:콜백함수명 (via BrandStreetCls.asp)
							Call fnStreetDispCateNaviV16(makerid, vDisp,"jsGoCategory")
						%>
						</div>
						<div class="sortGrp array">
						<%
							'정렬상자 호출; sType:정렬방법, sUse:사용처 구분, sCallback:콜백함수명 (via functions.asp)
							Call fnPrntSortNaviV16(SortMet,"dft", "jsGoSort")
						%>
						</div>
						<div class="sortGrp linkBtn">
							<p><a href="#" onclick="popFilterSearch(); return false;" class="fltrBtn">FILTER</a></p>
						</div>
					</div>
					<div id="contBlankCover" class="contBlankCover"></div>
				</div>

				<form name="sFrm" id="listSFrm" method="get" action="/street/street_brand.asp" style="margin:0px;">
					<input type="hidden" name="disp" value="<%= vDisp %>">
					<input type="hidden" name="cpg" value="1">
					<input type="hidden" name="makerid" value="<%= makerid %>">
					<input type="hidden" name="sscp" value="<%= SellScope %>">
					<input type="hidden" name="pagesize" value="<%= PageSize %>">
					<input type="hidden" name="srm" value="<%= SortMet %>">
					<input type="hidden" name="lstDiv" value="<%=ListDiv%>">
					<input type="hidden" name="ErBValue" value="8">
					<input type="hidden" name="itemid" value="">
					<input type="hidden" name="rect" value="<%= SearchText %>">
					<input type="hidden" name="rstxt" value="">
					<input type="hidden" name="sflag" value="<%= sflag  %>">
					<input type="hidden" name="iccd" value="<%=colorCD%>">
					<input type="hidden" name="styleCd" value="<%=styleCd%>">
					<input type="hidden" name="attribCd" value="<%=attribCd%>">
					<input type="hidden" name="deliType" value="<%=deliType%>">
					<input type="hidden" name="minPrc" value="<%=minPrice%>">
					<input type="hidden" name="maxPrc" value="<%=maxPrice%>">
				</form>

				<div class="pdtListWrapV15a">
					<ul class="pdtListV15a">
						<% IF oDoc.FResultCount >0 Then %>
							<% For i=0 To oDoc.FResultCount-1 %>
							<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%>>
								<div class="pPhoto" onclick="location.href='/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>&pBtr=<%=makerid%>';">
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
						<% Else %>
							<div align="center" id="srcnolist"><img src="http://fiximage.10x10.co.kr/m/common/noresult.png"></div>
						<% End If %>

					</ul>
				</div>
				<%=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,12,4,"jsGoPage")%>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form method="post" name="jjimfrm" style="margin:0px;" target="ifrm">
	<input type="hidden" name="makerid" value="<%=makerid%>">
</form>
<iframe name="ifrm" frameborder="0" width="0" height="0"></iframe>
</body>
</html>

<%
	Set oStreet = nothing
	Set oDoc = nothing
%>
<!-- #INCLUDE Virtual="/lib/db/dbclose.asp" -->
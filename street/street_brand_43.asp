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
<!-- #INCLUDE Virtual="/lib/classes/search/search43cls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
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
	oDoc.getSearchList

Dim vArrIssue, vLink, cEvent, veventcnt
	veventcnt=0

set cEvent = new ClsEvtCont
	cEvent.FECode = 0
	cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
	cEvent.FBrand = makerid
	cEvent.FEDispCate = ""
	vArrIssue = cEvent.fnEventISSUEList
set cEvent = nothing

'### 현재 위치 ###
Dim vCateNavi, vCateItemCount, vIsLastDepth, vCateCnt
if vDisp<>"" then
	vIsLastDepth = fnIsLastDepth(vDisp)
	vCateNavi = printstreetCategoryHistorymultiNew(vDisp,vIsLastDepth,vCateCnt,makerid)

	If (isShowSumamry) Then
		vCateItemCount = FormatNumber(getCateListCount("","","",vDisp,"",makerid,"","","","",ListDiv,"",""),0)
	End If
	vCateNavi = replace(vCateNavi,"()","(" & vCateItemCount & ")")
end if

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 브랜드: <%=oStreet.FOneItem.Fsocname_kor%></title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

$(function() {
	var mySwiper0 = new Swiper('.location .swiper-container',{
		pagination:false,
		freeMode:true,
		freeModeFluid:true,
		visibilityFullFit:true,
		initialSlide:2, //for dev msg : location 슬라이드 갯수(-1)만큼 적용되도록 처리해주세요
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

});

function jsGoSort(a){
	document.sFrm.cpg.value = "1";
	document.sFrm.srm.value = a;
	document.sFrm.action = "/street/street_brand.asp";
	sFrm.submit();
}

function goCategoryList(){
	document.sFrm.action = "/street/pop_street_CategoryList.asp";
	sFrm.submit();
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

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
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

				<div class="location">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<em class="swiper-slide"><a href="/">HOME</a></em>

							<% If vIsLastDepth Then %>
								<%= vCateNavi %>
							<% Else %>
								<%= vCateNavi %>
								<p class="swiper-slide">
									<span class="button btS1 btGry2 cWh1">
										<a href="" onClick="goCategoryList(); return false;">카테고리</a>
									</span>
								</p>
							<% End If %>
						</div>
					</div>
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
				</form>				
				<div class="inner10">
					<div class="sorting">
						<p <%=CHKIIF(SortMet="ne","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('ne'); return false;">신상순</a></span></p>
						<p <%=CHKIIF(SortMet="be","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('be'); return false;">인기순</a></span></p>
						<p <%=CHKIIF(SortMet="br","class=selected","")%>><span class="button"><a href="" onClick="jsGoSort('br'); return false;">리뷰순</a></span></p>
						<% If SortMet = "lp" OR SortMet = "hp" Then %>
							<% If SortMet = "lp" Then %>
								<p class="selected downSort"><span class="button priceBtn"><a href="" onClick="jsGoSort('hp'); return false;">가격순</a></span></p>
							<% Else %>
								<p class="selected upSort"><span class="button priceBtn"><a href="" onClick="jsGoSort('lp'); return false;">가격순</a></span></p>
							<% End If %>
						<% Else %>
							<p><span class="button priceBtn"><a href="" onClick="jsGoSort('lp'); return false;">가격순</a></span></p>
						<% End If %>
					</div>
					<div class="pdtListWrap">
						<ul class="pdtList">
							<% IF oDoc.FResultCount >0 Then %>
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
							<% Else %>
								<div align="center" id="srcnolist"><img src="http://fiximage.10x10.co.kr/m/common/noresult.png"></div>
							<% End If %>
	
						</ul>
					</div>

					<%=fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,12,4,"jsGoPage")%>
				</div>
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
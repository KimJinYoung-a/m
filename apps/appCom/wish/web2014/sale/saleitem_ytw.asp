<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim sortName
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	Dim vDepth, i,TotalCnt
		vDepth = "1"
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	dim searchFlag 	: searchFlag = "sale"
	dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
	dim atype		: atype = requestCheckVar(request("atype"),2)

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim ListDiv,ScrollCount
	ListDiv="salelist"
	ScrollCount = 5

	If atype = "" Then atype = "b"
	
	'// 정렬별 명칭구분
	Select Case Trim(atype)
		Case "b"
			sortName = "인기순"
			SortMet = "be"
		Case "n"
			sortName = "신상순"
			SortMet = "ne"
		Case "f"
			sortName = "위시순"
			SortMet = "ws"
		Case "s"
			sortName = "할인순"
			SortMet = "hs"
	End Select

	if CurrPage="" then CurrPage=1
	PageSize = 10

	If SortMet = "" Then SortMet = "be"

	dim oDoc,iLp
	set oDoc = new SearchItemCls
		oDoc.FListDiv 			= ListDiv
		oDoc.FRectSortMethod	= SortMet
		oDoc.FRectSearchFlag 	= searchFlag
		oDoc.FPageSize 			= PageSize
		oDoc.FRectCateCode			= vDisp
		oDoc.FCurrPage 			= CurrPage
		oDoc.FSellScope 		= "Y"
		oDoc.FScrollCount 		= ScrollCount
		oDoc.getSearchList
		
	TotalCnt = oDoc.FResultCount
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/iscroll.js"></script>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script type="text/javascript">
	function goPage(page){
		document.sFrm.cpg.value=page;
		document.sFrm.submit();
	}

	function fnSearch(frmval){
		document.sFrm.cpg.value=1;
		document.sFrm.srm.value=frmval;
		document.sFrm.submit();
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
	<% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1)%>
	   fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=6");
	<% Else %>
		calllogin();
		return false;
	<% End If %>
	}

	// Wish Cnt 증가
	function FnPlusWishCnt(iid) {
		var vCnt = $("#wish"+iid).html();
		vCnt = jsgetNumber(vCnt);
		if(vCnt=="") vCnt=0;
		vCnt++;
		$("#wish"+iid).html(vCnt);
	}

    function jsgetNumber(istr) {
        istr = "" + istr.replace(/,/gi,''); // 콤마 제거
        istr = istr.replace(/(^\s*)|(\s*$)/g, ""); // trim
        return (new Number(istr));
    }
    
    function FnPlusWishCntNg(iid) {
        setTimeout("fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);",500);
        FnPlusWishCnt(iid);
    }
    
var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-354){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_saleitem.asp?sflag=<%=searchFlag%>&srm=<%=SortMet%>&atype=<%=atype%>&psz=<%=PageSize%>&disp=<%=vDisp%>&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrSaleList").append(message);
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
	<div class="container bgGry">
		<div class="content saleIdxV15a" id="contentArea">
			<form name="sFrm" method="get" action="" style="margin:0px;">
			<input type="hidden" name="sflag" value="<%= oDoc.FRectSearchFlag  %>"/>
			<input type="hidden" name="srm" value="<%= oDoc.FRectSortMethod%>"/>
			<input type="hidden" name="cpg" value="<%=oDoc.FCurrPage %>"/>
			<input type="hidden" name="psz" value="<%= PageSize%>"/>
			<input type="hidden" name="atype" value="<%= atype%>">
			<input type="hidden" name="disp" value="<%= vDisp%>">
			</form>
			<div class="pdtListWrapV15a">
				<% IF oDoc.FResultCount >0 Then %>
				<ul class="pdtListV15a" id="lyrSaleList">
					<% For i=0 To oDoc.FResultCount-1 %>
					<li <%=CHKIIF(oDoc.FItemList(i).isSoldOut,"class=soldOut","")%>>
						<div class="pPhoto" onclick="fnAPPpopupProduct('<%=oDoc.FItemList(i).FItemID%>');">
							<%=CHKIIF(oDoc.FItemList(i).isSoldOut,"<p><span><em>품절</em></span></p>","")%>
							<img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,286,286,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>" />
						</div>
						<div class="pdtCont">
							<p class="pBrand"><% = oDoc.FItemList(i).FBrandName %></p>
							<p class="pName" onclick="fnAPPpopupProduct('<%=oDoc.FItemList(i).FItemID%>');"><% = oDoc.FItemList(i).FItemName %></p>
							<% IF oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then %>
								<% IF oDoc.FItemList(i).IsSaleItem And oDoc.FItemList(i).isCouponItem = false Then %>
									<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oDoc.FItemList(i).getSalePro %>]</span></p>
								<% End IF %>
								<% IF oDoc.FItemList(i).IsCouponItem Then %>
									<% IF Not(oDoc.FItemList(i).IsFreeBeasongCoupon() or oDoc.FItemList(i).IsSaleItem) then %>
									<% End IF %>
									<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oDoc.FItemList(i).GetCouponDiscountStr %>]</span></p>
								<% End IF %>
							<% Else %>
								<p class="pPrice"><% = FormatNumber(oDoc.FItemList(i).getRealPrice,0) %><% if oDoc.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
							<% End if %>
							<p class="pShare">
								<span class="cmtView"><%=formatNumber(oDoc.FItemList(i).FEvalCnt,0)%></span>
								<span class="wishView" id="wish<%=oDoc.FItemList(i).FItemID%>" onClick="TnAddFavoritePrd('<%=oDoc.FItemList(i).FItemID%>');"><%=formatNumber(oDoc.FItemList(i).FfavCount,0)%></span>
							</p>
						</div>
					</li>
					<% Next %>
				</ul>
				<% Else %>
					<div align="center" id="srcnolist"><img src="http://fiximage.10x10.co.kr/m/common/noresult.png"></div>
				<% End If %>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		</div>
		<% '' 정렬기능 변경 2016-01-28 유태욱 %>
		<div class="floatingBar sortingBarV15 bestSortV15">
			<div class="btnWrap">
				<%' for dev msg : 현재 보고있는 탭에 클래스 current 넣어주세요 %>
				<div class="cateBtn <% If vDisp<>"" Then %>current<% End If %>"><span class="button"><a href="" onClick="openHalfModal('/common/popCateModal.asp','<%=Server.URLencode("/apps/appCom/wish/web2014/sale/saleitem.asp")%>','<%=vDisp%>','<%=atype%>');return false;">
					<%
						If vDisp = "" Then
							response.write "전체 카테고리"
						Else
							response.write getDisplayCateNameDB(vdisp)
						End If
					%>
				</a></span></div>
				<div><span class="button btRed cWh1"><a href="" onclick="openHalfModal('/common/popSortModal.asp','<%=Server.URLencode("/apps/appCom/wish/web2014/sale/saleitem.asp")%>','<%=vDisp%>','<%=atype%>');return false;"><%=sortName%></a></span></div>
				<div><span class="button btGry3 cWh1"><a href="" onclick="fnAPPpopupBrowserURL('CLEARANCE SALE','<%=wwwUrl%>/apps/appCom/wish/web2014/clearancesale/','','');return false;">CLEARANCE</a></span></div>
			</div>
		</div>
	</div>
	<span id="gotop" class="goTop">TOP</span>
	<div id="modalLayer" style="display:none;"></div>
	<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
	<!-- incLogScript 2015.07.22 원승현 추가(앱용 로그관련 스크립트는 전부 이쪽으로..) -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
</div>
</body>
</html>
<%
set oDoc = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
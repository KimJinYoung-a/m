<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
	Dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	Dim vDepth, i,TotalCnt
		vDepth = "1"
	dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	dim searchFlag 	: searchFlag = "sale"
	dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	dim SortMet		: SortMet = requestCheckVar(request("srm"),2)

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim ListDiv,ScrollCount
	ListDiv="salelist"
	ScrollCount = 5

	if CurrPage="" then CurrPage=1
	PageSize =20

	If SortMet = "" Then SortMet = "hs" ''be 임시

	dim oDoc,iLp
	set oDoc = new SearchItemCls
		oDoc.FListDiv 			= ListDiv
		oDoc.FRectSortMethod	= SortMet
		oDoc.FRectSearchFlag 	= searchFlag
		oDoc.FPageSize 			= PageSize
		oDoc.FRectCateCode		= vDisp
		oDoc.FCurrPage 			= CurrPage
		oDoc.FSellScope 		= "Y"
		oDoc.FScrollCount 		= ScrollCount
		oDoc.getSearchList
		
	TotalCnt = oDoc.FResultCount

	'=============================== 추가 정보 ==========================================
	dim rstWishItem: rstWishItem=""
	dim rstWishCnt: rstWishCnt=""
	'// 장바구니 상품목록 작성
	if IsUserLoginOK then
		dim rstArrItemid: rstArrItemid=""
		IF oDoc.FResultCount>0 then
			for i=0 to oDoc.FResultCount -1
				rstArrItemid = rstArrItemid & chkIIF(rstArrItemid="","",",") & oDoc.FItemList(i).FItemID
			Next
		End if
		'// 위시결과 상품목록 작성
		if rstArrItemid<>"" then
			Call getMyFavItemList(getLoginUserid,rstArrItemid,rstWishItem, rstWishCnt)
		end if
	end if
	'====================================================================================
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
	function goPage(page){
		sFrm.cpg.value=page;
		sFrm.submit();
	}

	function fnSearch(frmnm,frmval){
		frmnm.value = frmval;

		var frm = document.sFrm;
		frm.cpg.value=1;
		frm.submit();
	}

	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
		<% if IsUserLoginOK then %>
		if($("#btnFav"+iitemid).hasClass("red")) {
			alert('이미 위시한 상품입니다.');
		} else {
			jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=' + iitemid + '&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
		}
		<% else %>
		calllogin();
		//location.href='/apps/appCom/wish/webview/login/login.asp?backpath=<%=server.URLEncode(CurrURLQ())%>';
		<% end if %>
		return;
	}
	
	
$(function() {
//gnb셋팅
	seltopmenu('sale');
});
</script>
</head>
<body class="event">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <!-- <header id="header" class="t-c">
            <h1 class="page-title with-stroke">ENJOY EVENT</h1>
        </header> --><!-- #header -->
        <!-- #content -->
        <div id="content">
			<div class="inner btmGyBdr overHidden">
				<!-- category -->
				<form name="sFrm" method="get" action="" style="margin:0px;">
				<input type="hidden" name="sflag" value="<%= oDoc.FRectSearchFlag  %>">
				<input type="hidden" name="srm" value="<%= oDoc.FRectSortMethod%>">
				<input type="hidden" name="cpg" value="<%=oDoc.FCurrPage %>">
				<input type="hidden" name="psz" value="<%= PageSize%>">			
				<div class="two-inputs">
					<div class="col">
						<select name="disp" onChange="goPage('');" id="category1" class="form red">
							<%=DrawSelectBoxDispCategorymulti(vDisp,vDepth) %>
						</select>
					</div>
					<div class="col">
						<select name="ttsrtm" id="category2" class="form red" onchange="fnSearch(this.form.srm,this.value);">
							<option value="ne" <% if SortMet="ne" then response.write "selected" %>>신상품순</option>
							<option value="be" <% if SortMet="be" then response.write "selected" %>>인기상품순</option>
							<option value="hp" <% if SortMet="hp" then response.write "selected" %>>높은가격순</option>
							<option value="lp" <% if SortMet="lp" then response.write "selected" %>>낮은가격순</option>
							<option value="hs" <% if SortMet="hs" then response.write "selected" %>>높은할인율순</option>
						</select>
					</div>
				</div><!-- category -->

				<div class="clear diff-10"></div>

				<!-- product-list -->
				<ul class="product-list list-type-1">
					<% IF oDoc.FResultCount >0 then %>
					<%
					For i=0 To TotalCnt-1
					
					IF (i <= TotalCnt-1) Then
					%>
					<li>
						<div class="product">
							<div class="product-img" onclick="location.href='/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %>';">
								<img src="<% = oDoc.FItemList(i).FImageBasic %>" alt="<% = oDoc.FItemList(i).FItemName %>" width="132" height="132">
							</div>
							<div class="product-spec">
								<div class="product-brand"><% = oDoc.FItemList(i).FBrandName %></div>
								<div class="product-name"><% = oDoc.FItemList(i).FItemName %></div>
								<div class="product-price">
									<%
									If oDoc.FItemList(i).IsSaleItem or oDoc.FItemList(i).isCouponItem Then
										IF oDoc.FItemList(i).IsSaleItem Then
											Response.Write " <strong>" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "</strong>원"
											Response.Write " <span class=""discount"">[" & oDoc.FItemList(i).getSalePro & "]↓</span>"
										End IF
										IF oDoc.FItemList(i).IsCouponItem Then
											Response.Write " <strong>" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "</strong>원"
											Response.Write " <span class=""coupon"">[" & oDoc.FItemList(i).GetCouponDiscountStr & "]↓</span>"
										End IF
									Else
										Response.Write " <strong>" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "</strong>원"
									End If
									%>
								</div>
								<% IF oDoc.FItemList(i).isSaleItem then %>
								<div class="featured">
										<span class="sale">SALE</span>
										<% IF oDoc.FItemList(i).IsSoldOut then %>
										<span class="only">품절</span>
										<% End If %>
								</div>
								<% end if %>
								<div class="product-meta">
										<span class="comment"><%=oDoc.FItemList(i).Fevalcnt%></span>
										<span class="love <%=chkIIF(chkArrValue(rstWishItem,oDoc.FItemList(i).FItemid),"red loved","")%>" id="btnFav<% = oDoc.FItemList(i).Fitemid %>" onclick="TnAddFavoritePrd('<% = oDoc.FItemList(i).Fitemid %>');"><%=chkIIF(chkArrValue(rstWishItem,oDoc.FItemList(i).FItemid),chkArrSelVal(rstWishItem,rstWishCnt,oDoc.FItemList(i).FItemid),oDoc.FItemList(i).FfavCount)%></span>
								</div>
							</div>
							<div class="clear"></div>
						</div>
					</li>
					<% End IF %>
					<% Next %>
					<% end if %>
				</ul><!-- product-list -->

				<div class="clear"></div>
				<%= fnDisplayPaging_New(CurrPage,oDoc.FTotalCount,PageSize,4,"goPage")%>
				<div class="diff"></div>
				</form>
			</div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            <% if flgDevice="I" then %><a href="#" class="btn-back">back</a><% end if %>
            <a href="#" class="btn-top">top</a>
        </footer><!-- #footer -->
		<div id="modalCont" style="display:none;"></div>

    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
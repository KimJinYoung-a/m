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
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
	Dim vDisp, vCurrPage, i , vSort
	vDisp = requestCheckVar(Request("disp"),5)
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vSort = NullFillWith(RequestCheckVar(Request("sort"),1),"1")
	If vCurrPage = "" Then vCurrPage = 1
	
	Dim cPopular
	SET cPopular = New CMyFavorite
	cPopular.FPageSize = 10
	cPopular.FCurrpage = vCurrPage
	cPopular.FRectDisp = vDisp
	cPopular.FRectSortMethod = vSort
	cPopular.fnPopularList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 위시:POPULAR</title>
	<script type="text/javascript">
	function goPage(pg){
		var frm = document.frmsearch;
		frm.action = "popularwish.asp";
		frm.cpg.value = pg;
		frm.submit();
	}
	
	function fnSearchCat(disp){
		var frm = document.frmsearch;
		frm.disp.value = disp;
		frm.submit();
	}
	
	// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
	function TnAddFavoritePrd(iitemid){
		var popwin = window.open('/my10x10/popMyFavorite.asp?ispop=pop&mode=add&itemid=' + iitemid + '&backurl=/my10x10/popularwish.asp', 'FavoritePrd', 'width=500,height=500,scrollbars=yes,resizable=yes');
		popwin.focus();
	}

	function fnSearch(frmnm,frmval){
		frmnm.value = frmval;

		var frm = document.frmsearch;
		frm.cpg.value=1;
		frm.disp.value="<%=vDisp%>";
		frm.submit();
	}
	</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="innerW tPad15">
					<h2>WISH</h2>
					<p class="c999 ftMidSm2 tMar05">바로 지금! 다른 사람들의 ♥위시는?<br /><strong>POPULAR</strong> 위시에서 텐바이텐의 쇼핑 트랜드를 만나보세요.</p>
				</div>
				<ul class="tabItem tMar20">
					<li class="on w50"><a href="/my10x10/popularwish.asp">POPULAR<span class="elmBg"></span></a></li>
					<li class="w50"><a href="/my10x10/mywishlist.asp">MY WISH<span class="elmBg"></span></a></li>
				</ul>

				<div class="wishList topGyBdr btmGyBdr">
					<form name="frmsearch" method="post" action="popularwish.asp" style="margin:0px;">
					<input type="hidden" name="cpg" value="1">
					<input type="hidden" name="disp" value="<%=vDisp%>">
					<input type="hidden" name="sort" value="<%=vSort%>" />
					<select onChange="fnSearchCat(this.value)">
					<%=DrawSelectBoxDispCategory(vDisp,"1") %>
					</select>
					<select onchange="fnSearch(this.form.sort,this.value);">
						<option value="1" <% if vSort="1" then response.write "selected" %>>최근위시</option>
						<option value="2" <% if vSort="2" then response.write "selected" %>>신상품위시</option>
						<option value="3" <% if vSort="3" then response.write "selected" %>>인기위시</option>
						<option value="4" <% if vSort="4" then response.write "selected" %>>상품후기 많은순</option>
					</select>

					</form>
					<% If (cPopular.FResultCount < 1) Then %>
						<div class="afterNone bgDiagonal tMar20">
							<div class="box1 bgWt rdBox2 inner15 ct ftMidSm2 b tMar05">
								<em class="elmBg"></em>
								등록된 위시 상품이 없습니다.
							</div>
						</div>
					<% Else %>
						<ul class="tMar15">
						<% For i = 0 To cPopular.FResultCount-1 %>
							<li>
								<div class="time">
									<span class="frLt" onClick="fnSearchCat('<%= cPopular.FItemList(i).FDisp %>')"><%= cPopular.FItemList(i).FCateName %></span>
									<span class="ftRt elmBg"><%= cPopular.FItemList(i).FRegTime %></span>
									<span class="arr"></span>
								</div>
								<div class="innerW tPad15">
									<p class="ftSmall c999"><a href="/street/street_brand.asp?makerid=<%=cPopular.FItemList(i).Fmakerid%>"><u><%= cPopular.FItemList(i).FBrandName %></u></a></p>
									<p class="ftMidSm b tMar05"><%= cPopular.FItemList(i).FItemName %></p>
								</div>
								<div class="pic"><a href="/category/category_itemPrd.asp?itemid=<%= cPopular.FItemList(i).FItemID %>"><img src="<%= cPopular.FItemList(i).FImageBasic %>" alt="<%= cPopular.FItemList(i).FItemName %>" style="width:100%" /></a></div>
								<p class="rt inner bPad15"><span class="btn btn1 redB w90B heartBg2"><a href="javascript:TnAddFavoritePrd('<%= cPopular.FItemList(i).FItemID %>');" class="vPad1em"><em class="elmBg3"><%= FormatNumber(cPopular.FItemList(i).FFavCount,0) %></em></a></span></p>
							</li>
						<% Next %>
						</ul>
					<% End If %>
				</div>
				
				<br /><br />
				<%=fnDisplayPaging_New(vCurrPage,cPopular.FTotalCount,10,4,"goPage")%>

			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<% SET cPopular = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/main/main_Pick.asp" -->
<%
	Dim cPk, vIdx, vTitle, intI
	
	SET cPk = New CPick
	cPk.GetPickOne()
	
	If cPk.FTotalCount > 0 Then
		vIdx = cPk.FItemOne.Fidx
		vTitle = cPk.FItemOne.Ftitle
	End IF
	
	If vIdx <> "" Then
		cPk.FPageSize = 50
		cPk.FCurrPage = 1
		cPk.FRectIdx = vIdx
		cPk.FRectSort = 1
		cPk.GetPickItemList()
	End If
%>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content evtView" id="contentArea">
				<h1 class="hide">PICK</h1>
				<div class="evtTypeC pickList">
				<%
				If cPk.FResultCount > 0 Then
					For intI =0 To cPk.FResultCount
						If (intI mod 2) = 0 Then
				%>
						<div class="evtPdtListWrap">
							<div class="pdtListWrap">
								<ul class="pdtList">
				<% 		End If %>
								<li onclick="location.href='/category/category_itemPrd.asp?itemid=<% = cPk.FCategoryPrdList(intI).Fitemid %>&flag=e';">
									<div class="pPhoto">
										<% IF cPk.FCategoryPrdList(intI).IsSoldOut Then %><p><span><em>품절</em></span></p><% End if %>
										<img src="<% = cPk.FCategoryPrdList(intI).FImageBasic %>" alt="<% = cPk.FCategoryPrdList(intI).FItemName %>" /></div>
									<div class="pdtCont">
										<p class="pBrand"><% = cPk.FCategoryPrdList(intI).FBrandName %></p>
										<p class="pName"><% = cPk.FCategoryPrdList(intI).FItemName %></p>
										<% IF cPk.FCategoryPrdList(intI).IsSaleItem or cPk.FCategoryPrdList(intI).isCouponItem Then %>
											<% IF cPk.FCategoryPrdList(intI).IsSaleItem Then %>
												<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cPk.FCategoryPrdList(intI).getSalePro %>]</span></p>
											<% End IF %>
											<% IF cPk.FCategoryPrdList(intI).IsCouponItem Then %>
												<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cPk.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
											<% End IF %>
										<% Else %>
											<p class="pPrice"><% = FormatNumber(cPk.FCategoryPrdList(intI).getRealPrice,0) %><% if cPk.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
										<% End if %>
									</div>
								</li>
				<% If (intI mod 2) = 1 OR intI = cPk.FResultCount Then %>
								</ul>
							</div>
						</div>
				<%
						End If
					Next
				End If
				%>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% SET cPk = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
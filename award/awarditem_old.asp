<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim flag, atype, vDisp 
vDisp = RequestCheckVar(request("disp"),3)
flag = RequestCheckVar(request("flag"),1)
atype = RequestCheckVar(request("atype"),1)
dim CurrPage : CurrPage = getNumeric(request("cpg"))
if CurrPage="" then CurrPage=1
'If atype = "" Then atype = "n"  'n 기본값
If atype = "" Then atype = "f"  'n 기본값
dim minPrice: minPrice=4500		'검색 최저가

Dim oaward, i, iLp, sNo, eNo, tPg
if (atype="n") then
    ''신상품 베스트
    set oaward = new SearchItemCls
	    oaward.FListDiv 		= "newlist"
	    oaward.FRectSortMethod	= "be"
	    oaward.FRectSearchFlag 	= "newitem"
	    oaward.FPageSize 		= 50
	    oaward.FCurrPage 		= 1
	    oaward.FSellScope		= "Y"
	    oaward.FScrollCount 	= 1
	    oaward.FRectSearchItemDiv ="D"
	    oaward.FRectCateCode	  = vDisp
	    oaward.FminPrice	= minPrice
	    oaward.FSalePercentLow = 0.89

	    oaward.getSearchList

elseif (atype="s") then
	set oaward = new SearchItemCls
		''oaward.FListDiv 		= "salelist"
		oaward.FListDiv 		= "saleonly"
		oaward.FRectSortMethod	= "be"		'인기순(be), 세일순(hs)
		oaward.FRectSearchFlag 	= "saleitem"
		oaward.FPageSize 		= 50
		oaward.FRectCateCode	= vDisp
		oaward.FCurrPage 		= 1
		oaward.FSellScope 		= "Y"
		oaward.FScrollCount 	= 1
		oaward.FminPrice	= minPrice
		oaward.getSearchList
	'TotalCnt = oaward.FResultCount
else
    set oaward = new CAWard
	    oaward.FPageSize = 50
	    oaward.FRectDisp1   = vDisp
		oaward.FRectAwardgubun = atype
		oaward.GetNormalItemList

	If (oaward.FResultCount < 3) Then
		''oaward.FRectCDL = vDisp  ''??
		''oaward.GetNormalItemList5down
		
		set oaward = Nothing
		set oaward = new SearchItemCls
	        oaward.FListDiv 			= "bestlist"
	        oaward.FRectSortMethod	    = "be"
	        ''oaward.FRectSearchFlag 	= "newitem"  ''검색범위
	        oaward.FPageSize 			= 50
	        oaward.FCurrPage 			= 1
	        oaward.FSellScope			= "Y"
	        oaward.FScrollCount 		= 1
	        oaward.FRectSearchItemDiv   ="D"
	        oaward.FRectCateCode		= vDisp
	        oaward.FminPrice	= minPrice
	        oaward.getSearchList
        
	End if
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: Best Award</title>
<script type='text/javascript'>
function changeCate(){
	document.frm.cpg.value = 1;
	document.frm.atype.value = "<%=atype%>";
	document.frm.submit();
}

function changeAType(atype){
    document.frm.cpg.value = 1;
    document.frm.atype.value = atype
	document.frm.submit();
}

function goPage(page) {
    document.frm.cpg.value = page;
    document.frm.atype.value = "<%=atype%>";
	document.frm.submit();
}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
   location.href = "/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=4";
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
				<div class="bestMain inner5">
					<!-- 카테고리별 정렬 -->
					<form name="frm" method="get" action="">
				    <input type="hidden" name="cpg" value="1">
				    <input type="hidden" name="atype" value="<%=atype%>">
					<div class="sorting cateBest">
						<p class="all">
							<select name="disp" class="selectBox" title="카테고리 선택" onChange="changeCate()">
								<%=DrawSelectBoxDispCategory(vDisp,"1") %>
							</select>
						</p>
						<p <%=CHKIIF(atype="b","class='selected'","")%>><span class="button"><a onClick="changeAType('b');">SELLER</a></span></p>
						<p <%=CHKIIF(atype="n","class='selected'","")%>><span class="button"><a onClick="changeAType('n');">NEW</a></span></p>
						<p <%=CHKIIF(atype="f","class='selected'","")%>><span class="button"><a onClick="changeAType('f');">WISH</a></span></p>
						<p <%=CHKIIF(atype="s","class='selected'","")%>><span class="button"><a onClick="changeAType('s');">SALE</a></span></p>
					</div>
					<!--// 카테고리별 정렬 -->
					<% if (FALSE) then %>
					<!-- 타겟별 정렬 -->
					<div class="sorting tMar05">
						<p><span class="button"><a href="">나 혼자산다</a></span></p>
						<p><span class="button"><a href="">돌아온 슈퍼맘</a></span></p>
						<p><span class="button"><a href="">아임 젠틀맨이다</a></span></p>
					</div>
					<!--// 타겟별 정렬 -->
                    <% end if %>
                    </form>
					<div class="box1 inner5">
						<%
						if CurrPage=1 then
							sNo=0
							eNo=14
						else
							sNo=(CurrPage-1) * 15
							eNo=(CurrPage * 15)-1
						end if

						if (oaward.FResultCount-1)<eNo then eNo = oaward.FResultCount-1

						tPg = (oaward.FResultCount\15)
						if (tPg<>(oaward.FResultCount/15)) then tPg = tPg +1

						If oaward.FResultCount > sNo Then
					  		If oaward.FResultCount Then
						%>
						<div class="pdtListWrap">
							<ul class="pdtList">
							<% For i=sNo to eNo %>
								<li class="<%=CHKIIF(oaward.FItemList(i).IsSoldOut,"soldOut","")%> <%=chkIIF((i+1)<4,"top"&(i+1),"")%>">
									<div class="pPhoto" onclick="TnGotoProduct('<%=oaward.FItemList(i).FItemID%>');" ><p><span><em>품절</em></span></p><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"286","286","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>" /></div>
									<div class="pdtCont">
										<p class="ranking"><%= i+1 %></p>
										<p class="pBrand"><%=oaward.FItemList(i).FBrandName %></p>
										<p class="pName" onclick="TnGotoProduct('<%=oaward.FItemList(i).FItemID%>');"><%=oaward.FItemList(i).FItemName %></p>
										
										<% IF oaward.FItemList(i).IsSaleItem or oaward.FItemList(i).isCouponItem Then %>
                                        	<% IF oaward.FItemList(i).IsSaleItem Then %>
                                        		<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %>원 <span class="cRd1">[<% = oaward.FItemList(i).getSalePro %>]</span></p>
                                        	<% End IF %>
                                        	<% IF oaward.FItemList(i).IsCouponItem Then %>
                                        		<% IF Not(oaward.FItemList(i).IsFreeBeasongCoupon() or oaward.FItemList(i).IsSaleItem) then %>
                                        		<% End IF %>
                                        		<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = oaward.FItemList(i).GetCouponDiscountStr %>]</span></p>
                                        	<% End IF %>
                                        <% Else %>
                                        	<p class="pPrice"><% = FormatNumber(oaward.FItemList(i).getRealPrice,0) %><% if oaward.FItemList(i).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
                                        <% End if %>
										<p class="pShare">
											<span class="cmtView"><%=FormatNumber(oaward.FItemList(i).FEvalcnt,0)%></span>
											<span class="wishView" onclick="TnAddFavoritePrd('<%=oaward.FItemList(i).FItemID%>');"><%=FormatNumber(oaward.FItemList(i).FFavCount,0)%></span>
										</p>
									</div>
								</li>
							<% Next %>
							</ul>
						</div>
						<%=fnDisplayPaging_New(CurrPage,oaward.FResultCount,15,4,"goPage")%>
						<%
							End If
						End If
						%>
					</div>
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
set oaward = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
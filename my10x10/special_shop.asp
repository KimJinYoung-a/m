<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
'####################################################
' Description : 마이텐바이텐 - 우수회원샵
' History : 2014-09-01 이종화 
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual ="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual ="/lib/classes/shopping/specialshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "우수회원샵"

'####### 회원등급 재조정 #######
Call getDBUserLevel2Cookie()
'####### 회원등급 재조정 #######

Dim iTotCnt
Dim iPageSize, iCurrpage ,iDelCnt
Dim iStartPage, iEndPage, iTotalPage, iPerCnt
Dim i,j, ix, userlevel, userLevelUnder, ospecialshop, iCols, iRows, vTitle, vSDate, vEDate

	iCurrpage = NullFillWith(requestCheckVar(Request("iC"),10),1)	'현재 페이지 번호
	iPageSize = 10		'한 페이지의 보여지는 열의 수
	iPerCnt   = 3		'보여지는 페이지 간격

	userlevel = GetLoginUserLevel
	'### 레벨이 없거나, 오렌지(5)거나, 옐로우(0), 그린(1) 일때 0으로 지정. 블루(2),VIP(3),Staff(7),Mania(4),Friends(8)
	If userlevel = "" OR userlevel = 5 OR userlevel = 0 OR userlevel = 1 Then
		userlevel = 0
	End If

	set ospecialshop = new CSpecialShop
	If userlevel > 0 Then
		ospecialshop.FNowDate = date()
		ospecialshop.GetSpecialShopInfo
		vTitle = ospecialshop.Ftitle
		vSDate = ospecialshop.Fsdate
		vEDate = ospecialshop.Fedate
		
		ospecialshop.FCurrPage = iCurrpage
		ospecialshop.FPageSize = iPageSize
		ospecialshop.FRectUserLevelUnder = userlevel
		
		If vTitle <> "" Then
			ospecialshop.GetSpecialItemList
		End If
		
		iTotCnt = ospecialshop.FTotalCount

		iCols=1
		iRows = CLng(ospecialshop.FResultCount / iCols)

		iTotalPage =   int((iTotCnt-1)/iPageSize) +1
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 우수회원샵</title>
<script type="text/javascript">
function goPage(iP){
		document.frmPrize.iC.value = iP;
		document.frmPrize.submit();
}
// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
   location.href = "/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=9";
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content vipShop bgGry" id="contentArea">
				<div class="inner10">
					<% If IsSpecialShopUser() Then %>
					<!--<h2 class="tit01 tMar10">우수회원샵</h2>-->
					<p class="grade"><span><%=getEncLoginUserID()%> 님은 <strong class="m<%=Replace(GetUserStrlarge(userlevel)," ","")%>"><%=GetUserStrlarge(userlevel)%></strong>회원입니다. <strong class="cRd1">[<%=getSpecialShopPercent()%>%]</strong></span></p>
						<% If IsSpecialShopUser() AND vTitle <> "" Then %>
						<dl class="weeklyTheme">
							<dt>이번 주 테마</dt>
							<dd>
								<h3><%=vTitle%></h3>
								<p><%=Replace(vSDate,"-",".")%> ~ <%=Right(Replace(vEDate,"-","."),5)%></p>
							</dd>
						</dl>
						<% End If %>
					<% End If %>
					<form name="frmPrize" method="post" action="special_shop.asp">
					<input type="hidden" name="iC" value="<%=iCurrpage%>">
					</form>
					
					<div class="pdtListWrap">
						<% If userlevel > 0 Then %>
						<ul class="pdtList">
						<% if iTotCnt = 0 then
								Dim vReservDate
								vReservDate = fnReservDate()
						%>
							<div class="comingSoon">
								<h3>COMING SOON!</h3>
								<p>다음 우수회원샵이 곧 오픈될 예정입니다.<br />곧 오픈될 상품들도 기대해주세요!</p>
								<% If vReservDate <> "" Then %><p class="cRd1 tPad15">오픈예정일 : <%=Replace(vReservDate,"-",".")%></p><% End If %>
							</div>
							<% else %>
								<% for j=0 to iRows-1 %>
									<li <% IF ospecialshop.FItemList(j).isSoldOut Then %>class="soldOut"<% End If %>>
										<div class="pPhoto" onclick="top.location.href='/category/category_itemPrd.asp?itemid=<%= ospecialshop.FItemList(j).FItemID %>';"><% IF ospecialshop.FItemList(j).isSoldOut Then %><p><span><em>품절</em></span></p><% End If %><img src="<%= ospecialshop.FItemList(j).FImageBasic %>" alt="<%= ospecialshop.FItemList(j).FItemName %>" /></div>
										<div class="pdtCont">
											<p class="pBrand"><%= ospecialshop.FItemList(j).FBrandName %></p>
											<p class="pName"><%= ospecialshop.FItemList(j).FItemName %></p>
											<%
												If ospecialshop.FItemList(j).IsSaleItem or ospecialshop.FItemList(j).isCouponItem Then
													Response.Write "<p class=""pPrice"">" & FormatNumber(ospecialshop.FItemList(j).FOrgPrice,0) & "원</p>"
													IF ospecialshop.FItemList(j).IsSaleItem Then
														Response.Write "<p class=""pPrice"">" & FormatNumber(ospecialshop.FItemList(j).getRealPrice,0) & "원 <span class=""cRd1"">[" & ospecialshop.FItemList(j).getSalePro & "]</span></p>"
													End IF
													IF ospecialshop.FItemList(j).IsCouponItem Then
														Response.Write "<p class=""pPrice"">" & FormatNumber(ospecialshop.FItemList(j).GetCouponAssignPrice,0) & "원 <span class=""cGr1"">[" & ospecialshop.FItemList(j).GetCouponDiscountStr & "]</span></p>"
													End IF
												Else
													Response.Write "<p class=""pPrice"">" & FormatNumber(ospecialshop.FItemList(j).getRealPrice,0) & "원</p>"
												End If
											%>
											<p class="pShare">
												<span class="cmtView"><%=FormatNumber(ospecialshop.FItemList(j).FEvalCnt,0)%></span>
												<span class="wishView" onclick="TnAddFavoritePrd('<%=ospecialshop.FItemList(j).FItemID%>');"><%=FormatNumber(ospecialshop.FItemList(j).FFavCount,0)%></span>
											</p>
										</div>
									</li>
								<% next %>
							<% end if %>
						</ul>
						<% Else %>
						<ul class="pdlist ct">
							<li class="noData lh14">죄송합니다.<br />우수회원샵의 혜택은 <strong class="mBLUE">블루회원</strong>부터 적용됩니다.<br /><br /></li>
						</ul>
						<% End If %>
					</div>
					<% IF iTotCnt > 0 THEN %>
					<div class="paging tMar25">
						<%=fnDisplayPaging_New(iCurrpage,iTotCnt,iPageSize,4,"goPage")%>
					</div>
					<% End If %>
				</div>
			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
set ospecialshop = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
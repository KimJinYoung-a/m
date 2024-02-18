<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "최근 본 상품"

'####################################################
' Description : 마이텐바이텐 - 최근 본 상품 
' History : 2014-09-01 이종화 
'####################################################
Const MAX_TODAYVIEW_ITEMCOUNT = 40

dim userid, page, pagesize, SortMethod, OrderType
userid      = getEncLoginUserID
page        = requestCheckVar(request("cpg"),9)
'cdl         = requestCheckVar(request("cdl"),3) '2014-09-01 리뉴얼시 빠짐 필요한가?!
pagesize    = requestCheckVar(request("pagesize"),9)
OrderType   = requestCheckVar(request("OrderType"),10)

if page="" then page=1
if pagesize="" then pagesize="20"


dim myTodayShopping
set myTodayShopping = new CTodayShopping
myTodayShopping.FPageSize        = pagesize
myTodayShopping.FCurrpage        = page
myTodayShopping.FScrollCount     = 10
myTodayShopping.FRectOrderType   = OrderType
'myTodayShopping.FRectCDL         = cdl
myTodayShopping.FRectUserID      = userid

if userid<>"" then
    myTodayShopping.getMyTodayViewList
end if

dim i, lp, iLp

dim ooption, optionBoxHtml
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 최근 본 상품</title>
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<script type="text/javascript">
	// 상품목록 페이지 이동
	function goPage(pg){
		var frm = document.frmtodays;
		frm.cpg.value=pg;
		frm.submit();
	}
</script>
</head>
<body>
<form name="frmtodays" method="post" action="mytodayshopping.asp">
<input type="hidden" name="cpg" value="<%=page%>">
</form>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--마이텐바이텐 START-->
				<!--<h2 class="innerW tMar15">최근 본 상품</h2>-->
				<% If myTodayShopping.FResultCount>0 Then %>
				<ul class="list01 topGyBdr tMar10">
					<% For lp=0 To myTodayShopping.FResultCount-1 %>
					<li class="inner">
						<a href="/category/category_itemPrd.asp?itemid=<% = myTodayShopping.FItemList(lp).Fitemid %>">
						<span class="pic"><img src="<% = myTodayShopping.FItemList(lp).FImageicon1 %>" alt="<% = myTodayShopping.FItemList(lp).FItemName %>" style="width:100%" /></span>
						<div class="pdtCont">
							<p class="ftSmall c999"><% = myTodayShopping.FItemList(lp).FBrandName %></p>
							<p class="ftMidSm lh12 b"><% = myTodayShopping.FItemList(lp).FItemName %></p>
							<% IF myTodayShopping.FItemList(lp).IsSaleItem or myTodayShopping.FItemList(lp).isCouponItem Then %>
							<% IF myTodayShopping.FItemList(lp).IsSaleItem then %>
								<p class="ftSmall2 c999"><del><% = FormatNumber(myTodayShopping.FItemList(lp).getOrgPrice,0) %>원</del></p>
								<p class="ftMidSm"><% = FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원 [<% = myTodayShopping.FItemList(lp).getSalePro %>]</p>
							<% End IF %>
							<% IF myTodayShopping.FItemList(lp).IsCouponItem Then %>
								<% IF Not(myTodayShopping.FItemList(lp).IsFreeBeasongCoupon() or myTodayShopping.FItemList(lp).IsSaleItem) then %>
									<p class="ftSmall2 c999"><del><% = FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원</del></p>
								<% End IF %>
									<p class="ftMidSm"><% = FormatNumber(myTodayShopping.FItemList(lp).GetCouponAssignPrice,0) %>원 [<% = myTodayShopping.FItemList(lp).GetCouponDiscountStr %>]</p>
							<% End IF %>
							<% Else %>
									<p class="ftMidSm"><% = FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %><% if myTodayShopping.FItemList(lp).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
							<% End if %>
							<p class="tagView">
								<% IF myTodayShopping.FItemList(lp).isTempSoldOut Then %>
								<img src="http://fiximage.10x10.co.kr/m/2013/common/tag_soldout.png" alt="품절" style="width:32px; height:14px;" class="rMar02" />
								<%
								   Else
										IF myTodayShopping.FItemList(lp).isLimitItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_limit.png" alt="한정" class="rMar02" style="width:32px; height:14px;" /><% End If
										IF myTodayShopping.FItemList(lp).isNewItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_new.png" alt="신상품" class="rMar02" style="width:32px; height:14px;" /><% End If
										IF myTodayShopping.FItemList(lp).isCouponItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_coupon.png" alt="쿠폰" class="rMar02" style="width:32px; height:14px;" /><% End If
										IF myTodayShopping.FItemList(lp).isSaleItem Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/tag_sale.png" alt="할인" class="rMar02" style="width:32px; height:14px;" /><% End If
								   End If
								   IF myTodayShopping.FItemList(lp).FEvalCnt>0 Then
								%>
								<!-- <img src="http://fiximage.10x10.co.kr/m/2012/category/ico_review.png" alt="상품후기" width="9" height="11"><span class="pd_review"><% = myTodayShopping.FItemList(lp).FEvalCnt %></span> -->
								<%End If%>
							</p>
						</div>
						</a>
					</li>
					<% Next %>
				</ul>
				<% Else %>
				<div class="topGyBdr btmGyBdr ct innerH25 tMar10">
					<p class="ftMid c999 innerH25">최근 본 상품이 없습니다.</p>
				</div>
				<% End If %>
				<!--상품리스트 END-->
				<% IF myTodayShopping.FTotalPage > 0 THEN %>
				<!--페이지표시-->
				<div class="paging tMar25">
					<%=fnDisplayPaging_New(myTodayShopping.FcurrPage,myTodayShopping.FtotalCount,myTodayShopping.FPageSize,4,"goPage")%>
				</div>
				<% End If %>
				<!--마이텐바이텐 END-->
			</div>
			<!-- //content area -->
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<%
	set myTodayShopping = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
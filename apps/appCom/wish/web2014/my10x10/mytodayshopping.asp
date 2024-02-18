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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 최근 본 상품 
' History : 2014-09-01 이종화 => 앱 서동석 (비회원도 조회 가능하게)
'####################################################
Const MAX_TODAYVIEW_ITEMCOUNT = 40

dim userid, page, pagesize, SortMethod, OrderType
dim itemarr
itemarr     = requestCheckVar(request("itemarr"),800)
userid      = getEncLoginUserID
page        = requestCheckVar(request("cpg"),9)
'cdl         = requestCheckVar(request("cdl"),3) '2014-09-01 리뉴얼시 빠짐 필요한가?!
pagesize    = requestCheckVar(request("pagesize"),9)
OrderType   = requestCheckVar(request("OrderType"),10)

if page="" then page=1
if pagesize="" then pagesize="40"


dim myTodayShopping
set myTodayShopping = new CTodayShopping
myTodayShopping.FPageSize        = pagesize
myTodayShopping.FCurrpage        = page
myTodayShopping.FScrollCount     = 10
myTodayShopping.FRectOrderType   = OrderType
'myTodayShopping.FRectCDL         = cdl
myTodayShopping.FRectUserID      = userid
myTodayShopping.FRectItemIdArrList = itemarr

if (itemarr<>"") then
    myTodayShopping.getMyTodayViewList
end if

dim i, lp, iLp

dim ooption, optionBoxHtml
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- <link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css"> -->
<style>
#contentArea .inner {margin:0 10px;}
.ftMid {font-size:0.9em !important;}
.ftMidSm {font-size:0.8em;}
.c999 {color:#999;}
.innerH25 {padding-top:25px; padding-bottom:25px;}
.bordered-box { margin-bottom: 10px; border-radius: 12px;-moz-border-radius: 12px;-webkit-border-radius: 12px;-o-border-radius: 12px; border:1px solid #f0f0f0; overflow: hidden;}
.bordered-box.filled {background: #f6f6f6;}
/*
.bordered-box .box-meta {border-radius: 12px;-moz-border-radius: 12px;-webkit-border-radius: 12px;-o-border-radius: 12px; background:#f0f0f0; line-height: 12px; font-size: 12px; height: 24px; display: block; text-decoration: none; color: #777; }
.bordered-box a.box-meta { background:#f0f0f0 url(../../img/icon-arrow-go-2.png) no-repeat 100% 50%; background-size: 20px auto;}
.bordered-box .box-meta .date { height: 24px; line-height: 24px; border-right:1px solid #fff; display: block; float:left; padding: 0 10px; width:80px;}
.bordered-box .box-meta .box-title { height: 24px; line-height: 24px; display: block; float:left; padding: 0 10px;}
*/
.bordered-box .gutter { padding: 10px; margin: 0; font-size: 12px;}
.product-info .order-status { display: block; line-height: 28px; margin-bottom: 10px;}
.product-info .order-status+.btn  {min-width:80px;}
.product-info .order-info { display: block; line-height: 16px; margin-bottom: 10px;}
.product-info .product-spec { margin-bottom:10px;}
.product-info p { margin: 0;}
.product-info .product-brand { font-size: 10px; color: #696969; line-height: 10px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;}
.product-info .product-name { font-size: 12px; font-weight: bold; line-height: 18px; color: #2a2a2a;  margin-bottom: 5px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;}
.product-info .product-option { font-size: 10px; color: #696969; line-height: 10px;}
.product-info .price { line-height: 20px;}
.product-info .price strong { font-size: 16px;}
.product-info .point { line-height: 14px; margin-bottom:5px;}
.product-info .point strong { font-size: 14px;}
.product-info .product-img { padding:0 10px 10px 0; float:left;}
.product-info .product-img img { width: 100px; height: 100px; display: block;}
.product-info .btn-cart { line-height: 24px !important;}
.product-info .price {color:#999; line-height:20px;}
</style>
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
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!--마이텐바이텐 START-->
			<% If myTodayShopping.FResultCount>0 Then %>
			<div class="inner">
				<% For lp=0 To myTodayShopping.FResultCount-1 %>
				<div class="bordered-box">
					<div class="product-info gutter">
						<a onClick="fnAPPpopupProduct('<% = myTodayShopping.FItemList(lp).Fitemid %>');">
							<div class="product-img">
								<img src="<% = myTodayShopping.FItemList(lp).FImageicon1 %>" alt="<% = myTodayShopping.FItemList(lp).FItemName %>" style="width:100px;height:100px" />
							</div>
							<div class="product-spec">
								<p class="product-brand"><% = myTodayShopping.FItemList(lp).FBrandName %></p>
								<p class="product-name"><% = myTodayShopping.FItemList(lp).FItemName %></p>
							</div>
							<div class="price">
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
							</div>
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
						</a>
					</div>
				</div>
				<% Next %>
			</div>
			<% Else %>
			<div class="bordered-box">
				<p class="ftMid c999 innerH25 ct">최근 본 상품이 없습니다.</p>
			</div>
			<% End If %>
			<!--상품리스트 END-->
			<% IF myTodayShopping.FTotalPage > 0 THEN %>
			<!--페이지표시-->
			    <%=fnDisplayPaging_New(myTodayShopping.FCurrpage,myTodayShopping.FTotalCount,myTodayShopping.FPageSize,"4","goPage")%>
			
			<% End If %>
			<!--마이텐바이텐 END-->
		</div>
		<!-- //content area -->
	</div>
</div>
<form name="frmtodays" method="post" action="mytodayshopping.asp">
<input type="hidden" name="cpg" value="<%=page%>">
</form>
</body>
</html>
<%
	set myTodayShopping = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
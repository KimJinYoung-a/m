<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 쿠폰리스트
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
<%
dim itemcouponidx, ocouponitemlist, page, makerid,sailyn, i, lp
	itemcouponidx = request("itemcouponidx")
	makerid = request("makerid")
	page = request("page")
	sailyn = request("sailyn")

if itemcouponidx="" then itemcouponidx=0
if page="" then page=1

set ocouponitemlist = new CItemCouponMaster
	ocouponitemlist.FPageSize=5
	ocouponitemlist.FCurrPage=page
	ocouponitemlist.FRectItemCouponIdx = itemcouponidx
	ocouponitemlist.GetItemCouponItemList
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script type='text/javascript'>

function goPage(page){
	frm.page.value=page;
	frm.submit();
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content mypage" id="contentArea">
			<!-- #content -->
			<div id="content">
				<form name="frm" method="get" action="">
					<input type="hidden" name="page" value="">
					<input type="hidden" name="itemcouponidx" value="<%= itemcouponidx %>">
				</form>
				<div class="inner">
					<div class="diff"></div>
					<div class="main-title">
						<h1 class="title"><span class="label"> 쿠폰 적용 상품보기</span></h1>
					</div>
				</div>
				<div class="inner">
					<div class="cp-count">쿠폰적용상품 : <strong><%=ocouponitemlist.FTotalCount%></strong>개</div>
					
					<% if ocouponitemlist.FResultCount>0 then %>
						<!-- product-list -->
						<ul class="product-list list-type-2">
							<% for i=0 to ocouponitemlist.FResultCount - 1 %>
		                    <li onclick="location.href='/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%= ocouponitemlist.FItemList(i).FItemID %>';">
		                        <div class="product">
		                            <div class="product-img">
		                                <img src="<%= ocouponitemlist.FitemList(i).FImageIcon1 %>" alt="<%= ocouponitemlist.FitemList(i).FItemName %>" width="132" height="132">
		                            </div>
		                            <div class="product-spec">
		                                <div class="product-brand"><%= ocouponitemlist.FitemList(i).FMakerid %></div>
		                                <div class="product-name"><%= ocouponitemlist.FitemList(i).FItemName %></div>
		                                <div class="product-price"><strong><%= FormatNumber(ocouponitemlist.FitemList(i).GetCouponSellcash,0) %></strong>원 <span class="discount"><%=ocouponitemlist.FitemList(i).Fitemcouponvalue%>%↓</span></div>
		                                <!-- <div class="featured">
		                                    <span class="only">ONLY</span>
		                                    <span class="limited">한정</span>
		                                    <span class="gift">GIFT</span>
		                                </div>
		                                <div class="product-meta">
		                                    <span class="comment">200</span>
		                                    <span class="love">222</span>
		                                </div> -->
		                            </div>
		                            <div class="clear"></div>
		                        </div>
		                    </li>
							<% next %>
						</ul>
						<!-- product-list -->
						
						<%=fnDisplayPaging_New(ocouponitemlist.FCurrPage,ocouponitemlist.FTotalCount,ocouponitemlist.FPageSize,ocouponitemlist.FScrollCount,"goPage")%>
					<% else %>
						<li>사용 가능한 상품쿠폰이 없습니다.</li>
					<% end if %>

					<div class="diff clear"></div>
				</div>
			</div><!-- #content -->
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<%
set ocouponitemlist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
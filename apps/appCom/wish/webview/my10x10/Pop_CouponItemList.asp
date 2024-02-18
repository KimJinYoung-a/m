<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->
<%
dim itemcouponidx
dim ocouponitemlist
dim page, makerid,sailyn

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

dim i, lp

strPageTitle = "생활감성채널, 텐바이텐 > 쿠폰 적용상품 보기"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	function goPage(page){
		frm.page.value=page;
		frm.submit();
	}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
		<form name="frm" method="get" action="">
		<input type="hidden" name="page" value="">
		<input type="hidden" name="itemcouponidx" value="<%= itemcouponidx %>">
		</form>
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">쿠폰 적용 상품보기</span></h1>
                </div>
            </div>
            <div class="inner">
            	<div class="cp-count">쿠폰적용상품 : <strong><%=ocouponitemlist.FTotalCount%></strong>개</div>
                <!-- product-list -->
                <ul class="product-list list-type-2">
				<% if ocouponitemlist.FResultCount<=0 then %>
					<li>사용 가능한 상품쿠폰이 없습니다.</li>
				<% else %>
					<% for i=0 to ocouponitemlist.FResultCount - 1 %>
                    <li onclick="location.href='/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%= ocouponitemlist.FItemList(i).FItemID %>';">
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
                 <% end if %>
                </ul><!-- product-list -->
				<%=fnDisplayPaging_New(ocouponitemlist.FCurrPage,ocouponitemlist.FTotalCount,ocouponitemlist.FPageSize,ocouponitemlist.FScrollCount,"goPage")%>
                <div class="diff"></div>

            </div>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->

	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<%
	set ocouponitemlist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
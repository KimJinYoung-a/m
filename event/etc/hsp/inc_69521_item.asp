<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 23 M&A
' History : 2016-03-08 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim userid, i, oItem
	isApp	= getNumeric(requestCheckVar(request("isApp"),1))
	userid = GetEncLoginUserID()
	
if isApp="" then isApp=0

dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66060
Else
	eCode   =  69521
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239226
	itemid2   =  786868
	itemid3   =  279397
	itemid4   =  1158976
	itemid5   =  786868
	itemid6   =  279397
Else
	itemid1   =  1448043
	itemid2   =  1448108
	itemid3   =  1448030
	itemid4   =  1448019
	itemid5   =  1445498
	itemid6   =  1447435
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get .item ul {overflow:hidden; padding:0 1%;}
.get .item ul li {position:relative; float:left; width:50%; margin-bottom:4%; padding:0 4%; color:#777; font-size:12px; text-align:center;}
.get .item ul li a {display:block;}
.get .item ul li span {display:block; margin-top:5px;}
.get .item ul li .price {font-weight:bold; margin-top:3px;}
.get .btnclose {top:15px; right:10px;}

@media all and (min-width:480px){
	.get .item ul li {font-size:16px;}
	.get .item ul li span {margin-top:7px;}
	.get .item ul li .price {margin-top:6px;}
}
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.31"></script>
<script type='text/javascript'>

$(function(){
    $(".heightGrid").css("height", "0");
})

</script>
</head>
<body class="">
<div class="heightGrid">
	<div class="container popWin">
		<% if isApp=1 then %>
		<% else %>
			<div class="header">
				<h1>구매하기</h1>
				<% if isApp=1 then %>
					<p class="btnPopClose"><button onclick="fnAPPclosePopup(); return false;" class="pButton">닫기</button></p>
				<% else %>
					<p class="btnPopClose"><button onclick="self.close(); return false;" class="pButton">닫기</button></p>
				<% end if %>
			</div>
		<% end if %>

		<%'' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/tit_buy.jpg" alt="단독 런칭 GIFT - 꼬까참새 브랜드 상품 5만원 이상 구매시 스마일 조명 증정" /></h2>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
						<%
						itemid = itemid1
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
						<% if oItem.FResultCount > 0 then %>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448043&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448043&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_01.jpg" alt="" />
									<span class="color">[꼬까참새] 골든아티스트</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
						<%
						itemid = itemid2
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448108&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448108&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_02.jpg" alt="" />
									<span class="color">[꼬까참새] 핑크블로썸</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
						<%
						itemid = itemid3
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448030&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448030&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_03.jpg" alt="" />
									<span class="color">[꼬까참새]캔디바</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
						<%
						itemid = itemid4
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1448019&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1448019&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_04.jpg" alt="" />
									<span class="color">[꼬까참새]심플체크</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
						<%
						itemid = itemid5
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1445498&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1445498&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_05.jpg" alt="" />
									<span class="color">[꼬까참새]정글삭스</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
						<%
						itemid = itemid6
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1447435&amp;pEtr=69521'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1447435&amp;pEtr=69521" target="_blank">
								<% end if %>
								<a href="/category/category_itemPrd.asp?itemid=1447435&amp;pEtr=69521">
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/69521/m/img_thumb_06.jpg" alt="" />
									<span class="color">[꼬까참새]빅파인삭스</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<% set oItem=nothing %>
						<% end if %>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<%'' //content area %>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
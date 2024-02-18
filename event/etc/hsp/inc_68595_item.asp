<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 18 MA item
' History : 2016-01-19 유태욱 생성
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
	eCode   =  66004
Else
	eCode   =  68595
End If

dim itemid, itemid1, itemid2, itemid3, itemid4
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239226
	itemid4   =  1239221
Else
	itemid1   =  1418254
	itemid2   =  1418269
	itemid3   =  1418291
	itemid4   =  1418312
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
.get .item ul li .soldout {position:absolute; left:50%; top:7%; width:70%; margin-left:-35%;}

@media all and (min-width:480px){
	.get .item ul li {font-size:16px;}
	.get .item ul li span {margin-top:7px;}
	.get .item ul li .price {margin-top:6px;}
}

/* 앱일 경우에만 해당 css 불러와 주세요 */
<% if isApp=1 then %>
/*.popWin .content {padding-top:0;}*/
<% end if %>
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
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/tit_featured.png" alt="FEATURED" /></h2>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
							<%
							itemid = itemid1
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
						<ul>
						<% if oItem.FResultCount > 0 then %>
							<li>
								<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/txt_soldout.png" alt="SOLD OUT" /></p>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418254&amp;pEtr=68595'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1418254&amp;pEtr=68595" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/img_thumb_01.jpg" alt="" />
									<span class="color">MOD TABLET 2 Mini</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418269&amp;pEtr=68595'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1418269&amp;pEtr=68595" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/img_thumb_02.jpg" alt="" />
									<span class="color">MOD MOBILE 2</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418291&amp;pEtr=68595'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1418291&amp;pEtr=68595" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/img_thumb_03.jpg" alt="" />
									<span class="color">STASH (iPhone6)</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418312&amp;pEtr=68595'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1418312&amp;pEtr=68595" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68595/m/img_thumb_04.jpg" alt="" />
									<span class="color">CORD TACOS - Grande 3 Pack</span>
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
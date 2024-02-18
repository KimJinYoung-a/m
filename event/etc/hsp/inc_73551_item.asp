<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 51 item M&A
' History : 2016-10-11 유태욱 생성
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
	eCode   =  66219
Else
	eCode   =  73551
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6, itemid7, itemid8, itemid9, itemid10, itemid11, itemid12
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1576373
	itemid2   =  1576365
	itemid3   =  1576368
	itemid4   =  1506304
	itemid5   =  1576372
	itemid6   =  1576363
	itemid7   =  1576367
	itemid8   =  1506305
	itemid9   =  1576370
	itemid10  =  1576361
	itemid11  =  1576366
	itemid12  =  1506306
Else
	itemid1   =  1576373
	itemid2   =  1576365
	itemid3   =  1576368
	itemid4   =  1506304
	itemid5   =  1576372
	itemid6   =  1576363
	itemid7   =  1576367
	itemid8   =  1506305
	itemid9   =  1576370
	itemid10  =  1576361
	itemid11  =  1576366
	itemid12  =  1506306
	
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.get h2 {padding:3rem 0 2.5rem; color:#333; text-align:center; font:bold 1.6rem/1.313em arial;}
.get h2 span {display:block; font-size:1.5rem;}
.get h3 {text-align:center; color:#333;}
.get h3 span {display:inline-block; height:2.2rem; padding:0 1rem; font-size:1.2rem; line-height:2.4rem; font-weight:bold; background-color:#ddd; border-radius:1rem;}
.get .item {padding:0 7.8%;}
.get .item div {padding-top:2.1rem; border-top:1px solid #ddd;}
.get .item div:first-child {border-top:0; padding-top:0;}
.get .item ul {overflow:hidden; margin-top:1.5rem; padding:0 9.25%; }
.get .item ul li {float:left; width:50%; margin-bottom:1.8rem; color:#777; font-size:1rem; text-align:center;}
.get .item ul li a {display:block;}
.get .item ul li .name {color:#333; font:bold 0.9rem/1 arial; letter-spacing:-0.02rem;}
.get .item ul li:nth-child(1) .name {color:#ebc201;}
.get .item ul li:nth-child(2) .name {color:#25ab6b;}
.get .item ul li:nth-child(3) .name {color:#ba9bf6;}
.get .item ul li:nth-child(4) .name {color:#ff3401;}
.get .item ul li .price {margin-top:0.3rem; color:#d50c0c; font:bold 1.2rem/1 arial;}
.get .btnclose {top:15px; right:10px;}

/* 앱일 경우에만 해당 css 불러와 주세요 */
<% if isApp=1 then %>
.popWin .content {padding-top:0;}
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
					<h2>SML x 3RD ROUND <span>콜라보레이션 상품 구매하기</span></h2>

					<div class="item">
						<div>
							<h3><span>S 사이즈</span></h3>
							<ul>
							<%
							itemid = itemid1
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
									<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576373&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576373&amp;pEtr=73551">
									<% End If %>
											<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_01.jpg" alt="YELLOW MON" /></span>
											<p class="name">YELLOW MON (25CM)</p>
											<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
										</a>
									</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid2
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576365&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576365&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_02.jpg" alt="" /></span>
										<p class="name">BIRD MON (30CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid3
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576368&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576368&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_03.jpg" alt="" /></span>
										<p class="name">BIG MON (30CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid4
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1506304&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1506304&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_04.jpg" alt="" /></span>
										<p class="name">RED MON (18CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing
							%>
							</ul>
						</div>
						<div>
							<h3><span>M사이즈</span></h3>
							<ul>
							<%
							itemid = itemid5
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576372&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576372&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_01.jpg" alt="YELLOW MON" /></span>
										<p class="name">YELLOW MON (30CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid6
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576363&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576363&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_02.jpg" alt="" /></span>
										<p class="name">BIRD MON (40CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid7
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576367&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576367&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_03.jpg" alt="" /></span>
										<p class="name">BIG MON (45CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid8
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1506305&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1506305&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_04.jpg" alt="" /></span>
										<p class="name">RED MON (24CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing
							%>
							</ul>
						</div>
						<div>
							<h3><span>L 사이즈</span></h3>
							<ul>
							<%
							itemid = itemid9
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576370&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576370&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_01.jpg" alt="YELLOW MON" /></span>
										<p class="name">YELLOW MON (45CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid10
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576361&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576361&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_02.jpg" alt="" /></span>
										<b class="name">BIRD MON (45CM)</b>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid11
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1576366&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1576366&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_03.jpg" alt="" /></span>
										<p class="name">BIG MON (55CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing

							itemid = itemid12
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
								<li>
									<% If isApp = 1 Then %>
										<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1506306&amp;pEtr=73551'); return false;">
									<% Else %>
										<a href="/category/category_itemPrd.asp?itemid=1506306&amp;pEtr=73551">
									<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73551/m/img_thumbnail_04.jpg" alt="" /></span>
										<p class="name">RED MON (55CM)</p>
										<p class="price"><strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong></p>
									</a>
								</li>
							<%
								end If	
							Set oItem=nothing
							%>								
							</ul>
						</div>
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
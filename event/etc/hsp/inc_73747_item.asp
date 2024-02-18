<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 49 item M&A
' History : 2016-09-27 이종화 생성
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
	eCode   =  66220
Else
	eCode   =  73747
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6 , itemid7 , itemid8 , itemid9
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
Else
	itemid1   =  1572519 'main
	itemid2   =  1572511 'sub
	itemid3   =  1572512
	itemid4   =  1572518
	itemid5   =  1572557
	itemid6   =  1572526
	itemid7   =  1572540
	itemid8   =  1572541
	itemid9   =  1572549
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get h2 {padding-top:3rem; color:#333; font:bold 1.7rem/1.313em arial; text-align:center;}
.get h2 span {font-weight:normal;}
.get .item .representative {margin:3rem 2rem 0; padding-bottom:3rem; border-bottom:1px solid #b2b2b2;}
.get .item .representative a {display:table; width:100%;}
.get .item .representative .thumbnail {display:table-cell; width:45%;}
.get .item .representative .option {display:table-cell; width:55%; padding-left:6%; vertical-align:middle; text-align:left;}
.get .item .representative .name {color:#333; font-size:1.4rem; font-weight:bold;}
.get .item .representative .price {margin-top:0.3rem;}
.get .item .representative .price s {font-size:1.2rem;}
.get .item .representative .price strong {margin-top:-0.3rem; font-size:1.6rem;}
.get .item .representative p {margin-top:0.5rem; color:#808080; font-size:1rem; line-height:1.25em;}

.get .item ul {overflow:hidden; margin-top:0.5rem; padding:0 1rem;}
.get .item ul li {overflow:hidden; float:left; width:50%; margin-top:2.7rem; padding:0 1rem; color:#777; font-size:1rem; text-align:center}
.get .item ul li .option {overflow:hidden; margin-top:0.7rem;}
.get .item ul li .name, .get .item ul li .price {display:block; font-size:1rem; color:#777;}
.get .item ul li .price {margin-top:0.3rem; font-weight:bold;}
.get .item ul li .name {font-weight:normal;}

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
					<h2>MARK’S <span>X</span> PAUL & JOE</h2>
					<div class="item">
						<div class="representative">
							<%
								itemid = itemid1
								Set oItem = new CatePrdCls
									oItem.GetItemData itemid
									If oItem.FResultCount > 0 Then
							%>
						<% If isApp = 1 Then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572519&amp;pEtr=73747'); return false;">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1572519&pEtr=73747">
						<% End If %>
								<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_01.jpg" alt="" /></span>
								<div class="option">
									<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) THEN %>
									<strong class="discount">단, 일주일만 ONLY 10%</strong>
									<b class="name">A5 Note Book</b>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
									<% Else %>
									<b class="name">A5 Note Book</b>
									<div class="price">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
									<% End If %>
									<p>사이즈 : 가로 14.8 x 세로 21(cm)<br />소재 : 하드커버, 종이</p>
								</div>
							</a>
						</div>
							<%
									End If
								Set oItem=nothing 
							%>
						<ul class="with">
							<%
								itemid = itemid2
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572511&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572511&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Masking tape 2 set</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid3
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572512&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572512&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Ballpoint pen</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid4
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572518&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572518&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_04.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Pen case</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid5
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572557&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572557&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_05.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Letter set</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid6
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572526&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572526&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_06.jpg" alt="" /></span>
									<div class="option">
										<span class="name">A6 Notebook</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid7
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572540&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572540&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_07.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Stationery case</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid8
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572541&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572541&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_08.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Sticky notes set</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
							<%
								itemid = itemid9
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1572549&amp;pEtr=73747'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1572549&pEtr=73747">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73747/m/img_thumbnail_09.jpg" alt="" /></span>
									<div class="option">
										<span class="name">Message card</span>
										<% if oItem.FResultCount > 0 then %>
											<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %><i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i><% End If %></span>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
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
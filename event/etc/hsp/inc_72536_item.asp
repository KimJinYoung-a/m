<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 42 item M&A
' History : 2016-08-02 김진영 생성
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
	eCode   =  66177
Else
	eCode   =  72182
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239226
	itemid4   =  1239115
	itemid5   =  1239226
	itemid6   =  1239226
Else
	itemid1   =  1542357
	itemid2   =  1531576
	itemid3   =  1531454
	itemid4   =  1531572
	itemid5   =  1531653
	itemid6   =  1531555
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.popWin .content {padding-bottom:0;}

.get h2 {padding:3rem 0 0; color:#333; font-size:1.5rem; font-weight:bold; text-align:center;}
.get .item ul {overflow:hidden; padding:0 3.125%;}
.get .item ul li {float:left; width:50%;}
.get .item ul li a {display:block; width:100%; padding:4% 3.125%; text-align:center; font-size:1rem; color:#777;}
.get .item ul li span {display:block; padding-top:0.5rem;}
.get .item ul li strong {display:block; margin-bottom:0; padding:0.3rem 1rem 0.1rem; font-size:1rem;}
.get .item ul li.typical {overflow:hidden; width:100%; margin-bottom:1.5rem; border-bottom:1px solid #b2b2b2}
.get .item ul li.typical a {display:table; width:100%;}
.get .item ul li.typical div {display:table-cell; width:50%; vertical-align:middle; text-align:left;}
.get .item ul li.typical div span {font-weight:bold; font-size:1.35rem; color:#000;}
.get .item ul li.typical div strong {padding-left:0; font-weight:bold; font-size:1.3rem; color:#000;}
.get .item ul li.typical div p {padding-top:1rem; font-size:0.85rem; color:#808080;}

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
					<h2>NORITAKE 구매하기</h2>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
						<%
							itemid = itemid1
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li class="typical">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1542357&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1542357&amp;pEtr=72536" target="_blank">
							<% End If %>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_00.png" alt="" /></div>
									<div class="lPad1r">
										<%' for dev msg : 상품코드 1542357 %>
										<span>INSIGHT BOY</span>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										<p class="lh12">재질 : 플라스틱<br />
										기종 : iphone SE / 5 / 5S<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6plus / 6S PLUS</p>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid2
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531576&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1531576&amp;pEtr=72536" target="_blank">
							<% End If %>
									<%' for dev msg : 상품코드 1531576 %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_01.png" alt="" />
									<span>CITY TOTE BAG</span>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid3
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531454&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1531454&amp;pEtr=72536" target="_blank">
							<% End If %>
									<%' for dev msg : 상품코드 1531454 %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_02.png" alt="" />
									<span>THIS IS PEN</span>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid4
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531572&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1531572&amp;pEtr=72536" target="_blank">
							<% End If %>
									<%' for dev msg : 상품코드 1531572 %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_03.png" alt="" />
									<span>YELLOW CARD</span>
									<b><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid5
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531653&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1531653&amp;pEtr=72536" target="_blank">
							<% End If %>
									<%' for dev msg : 상품코드 1531653 %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_04.png" alt="" />
									<span>PULL T SHIRTS</span>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid6
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1531555&amp;pEtr=72536'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1531555&amp;pEtr=72536" target="_blank">
							<% End If %>
									<%' for dev msg : 상품코드 1531555 %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72536/m/img_thumbnail_05.png" alt="" />
									<span>VOTE B3 POSTER</span>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 
						%>
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
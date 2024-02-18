<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016.01.11 한용민 생성
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
dim userid, i
	isApp	= getNumeric(requestCheckVar(request("isApp"),1))
	userid = GetEncLoginUserID()
	
if isApp="" then isApp=0

dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  65993
Else
	eCode   =  68133
End If

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1418361
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

'dim itemid2, itemid3
'IF application("Svr_Info") = "Dev" THEN
'	itemid2   =  1239115
'	itemid3   =  1239115
'Else
'	itemid2   =  1403589
'	itemid3   =  1403591
'End If

'dim oItem2
'set oItem2 = new CatePrdCls
'	oItem2.GetItemData itemid2

'dim oItem3
'set oItem3 = new CatePrdCls
'	oItem3.GetItemData itemid3


%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.get .big {position:relative;}
.get .link {display:block;}
.get .option {position:absolute; top:38.5%; left:52%;}
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px;}
.get .item ul {overflow:hidden; padding:0 1%;}
.get .item ul li {float:left; width:50%; margin-bottom:4%; padding:0 4%; color:#777; font-size:12px; text-align:center;}
.get .item ul li:nth-child(7) {margin-bottom:0;}
.get .item ul li a {display:block;}
.get .item ul li span {display:block; margin-top:5px;}
.get .item ul li .price {font-weight:bold; margin-top:3px;}
.get .btnclose {top:15px; right:10px;}

@media all and (min-width:480px){
	.get .item ul li {font-size:16px;}
	.get .item ul li span {margin-top:7px;}
	.get .item ul li .price {margin-top:6px;}
}

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

		<% '<!-- content area --> %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<div class="big">
						<% '<!-- for dev msg : 상품 링크 --> %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;" class="link">
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank" class="link">
						<% End If %>

							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_big.jpg" alt="" />
							<div class="option">
								<%
								'<!-- for dev msg : 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
								%>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<% If oItem.Prd.FOrgprice = 0 Then %>
										<% else %>
											<strong class="discount">텐바이텐 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<% End If %>

										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<em class="name"><span>WILD MICKEY</span></em>
									<% Else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<em class="name"><span>WILD MICKEY</span></em>
									<% End If %>
								<% End If %>
							</div>
						</a>
					</div>

					<% '<!-- for dev msg : 상품 링크 --> %>
					<div class="item">
						<ul>
							<% if oItem.FResultCount > 0 then %>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_01.jpg" alt="" />
									<span class="color">WHITE MICKEY</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_02.jpg" alt="" />
									<span class="color">TODAY MICKEY</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_03.jpg" alt="" />
									<span class="color">SNOW WHITE PRINCESS</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_04.jpg" alt="" />
									<span class="color">ORANGE MICKEY</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_05.jpg" alt="" />
									<span class="color">JUNGLE MICKEY</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_06.jpg" alt="" />
									<span class="color">DUMBO</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=68581" target="_blank">
								<% End If %>

									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/68581/m/img_thumb_07.jpg" alt="" />
									<span class="color">DONALD DUCK</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<% End If %>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<% '<!-- //content area --> %>
	</div>
</div>
</body>
</html>

<%
set oItem=Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
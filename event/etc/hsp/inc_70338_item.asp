<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 30
' History : 2016-04-19 원승현 생성
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
	eCode   =  66111
Else
	eCode   =  70338
End If

dim itemid, itemid1, itemid2, itemid3, itemid4
IF application("Svr_Info") = "Dev" Then
	itemid	  =  1473441
	itemid1   =  1450239
	itemid2   =  1434283
	itemid3   =  1431913
	itemid4   =  1418361
Else
	itemid	  =  1473441
	itemid1   =  1450239
	itemid2   =  1434283
	itemid3   =  1431913
	itemid4   =  1418361
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get .big {position:relative;}
.get .link {display:block;}
.get .option {position:absolute; top:38.5%; left:52%;}
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px; color:#737373; line-height:0.813em;}
.get .item ul {overflow:hidden; padding:0 1%;}
.get .item ul li {float:left; width:50%; margin-bottom:4%; padding:0 4%; color:#777; font-size:10px; text-align:center;}
.get .item ul li:nth-child(9), .get .item ul li:nth-child(10) {margin-bottom:0;}
.get .item ul li a {display:block;}
.get .item ul li span {display:block; margin-top:5px;}
.get .item ul li .price {font-weight:bold; margin-top:3px;}
.get .item ul li .itemname {overflow:hidden; text-overflow:ellipsis; white-space:nowrap; line-height:1.25em;}
.get .btnclose {top:15px; right:10px;}

@media all and (min-width:480px){
	.get .item ul li {font-size:16px;}
	.get .item ul li span {margin-top:7px;}
	.get .item ul li .price {margin-top:6px;}
}

<% if isApp="1" then %>
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
					<%
						dim oItem
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="big">
						<%' for dev msg : 상품 링크 %>
						<% if isApp=1 then %>
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1473441&amp;pEtr=70338'); return false;">
						<% else %>
							<a href="/category/category_itemPrd.asp?itemid=1473441&amp;pEtr=70338" class="link" target="_blank">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70338/m/img_thumb_big.jpg" alt="WOOL KNIT MUFFLER 구매하기" />
							<div class="option">
								<%' for dev msg : 할인기간 4/20~4/26 할인 / 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
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
										<em class="name"><span>사이즈 : 지름 7.5cm x 높이 9cm<br /> 소재 : 유리</span></em>
									<% Else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<em class="name"><span>사이즈 : 지름 7.5cm x 높이 9cm<br /> 소재 : 유리</span></em>
									<% End If %>
								<% End If %>
							</div>
						</a>
					</div>
					<% set oItem=nothing %>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
						<%
						itemid = itemid1
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
						%>
							<li>
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1450239&amp;pEtr=70338'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1450239&amp;pEtr=69521" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70338/m/img_thumb_01.jpg" alt="" />
									<span class="itemname">Vintage Mickey&amp;Mini_Pouch</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1434283&amp;pEtr=70338'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1434283&amp;pEtr=70338" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70338/m/img_thumb_02.jpg" alt="" />
									<span class="itemname">Vintage_PLAYING CARDS</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1431913&amp;pEtr=70338'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1431913&amp;pEtr=70338" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70338/m/img_thumb_03.jpg" alt="" />
									<span class="itemname">Vintage Mickey_Note(5종세트)</span>
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
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=70338'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1418361&amp;pEtr=70338" target="_blank">
								<% end if %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70338/m/img_thumb_04.jpg" alt="" />
									<span class="itemname">Vintage Mickey_아이폰 케이스</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
						<% set oItem=nothing %>
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
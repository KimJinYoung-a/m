<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 5
' History : 2015.10.06 한용민 생성
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
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64910
Else
	eCode   =  66637
End If

dim userid, i
	userid = GetEncLoginUserID()

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1364759
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim itemid2, itemid3
IF application("Svr_Info") = "Dev" THEN
	itemid2   =  1239115
	itemid3   =  1239115
Else
	itemid2   =  1364733
	itemid3   =  1364741
End If
   
dim oItem2
set oItem2 = new CatePrdCls
	oItem2.GetItemData itemid2

dim oItem3
set oItem3 = new CatePrdCls
	oItem3.GetItemData itemid3

	isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px;}

.item {padding:0 4.68%;}
.item li {overflow:hidden; padding:4% 0; border-top:1px solid #eee;}
.item li:first-child {padding-top:0; border-top:0;}
.item li a {display:table; width:100%;}
.item .figure {display:table-cell; width:44.82%; padding-right:5%;}
.item .option {display:table-cell; width:50.18%; vertical-align:middle;}
.item li:nth-child(2) .option .name, .item li:nth-child(2) .option .price,
.item li:nth-child(3) .option .name, .item li:nth-child(3) .option .price {color:#777; font-size:11px;}
.item li:nth-child(2) .option .price, .item li:nth-child(3) .option .price {display:block; margin-top:3px;}

@media all and (min-width:480px){
	.item li:nth-child(2) .option .name, .item li:nth-child(2) .option .price,
	.item li:nth-child(3) .option .name, .item li:nth-child(3) .option .price {font-size:16px;}
	.item li:nth-child(2) .option .price, .item li:nth-child(3) .option .price {margin-top:5px;}
}

<% if isApp=1 then %>
/* 앱일 경우에만 해당 css 불러와 주세요 */
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

		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<p><strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66637/m/tit_buy.png" alt="GOOLY GOOLY 구매하기" /></strong></p>
					<ul class="item">
						<li>
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1364759'); return false;">
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1364759">
							<% end if %>

								<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66637/m/img_item_01.jpg" alt="" /></span>
								<div class="option">
									<%
									'<!-- for dev msg : 10/07~10/13까지 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
									'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요 -->
									%>
									<% if oItem.FResultCount > 0 then %>
										<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
											<% If oItem.Prd.FOrgprice = 0 Then %>
											<% else %>
												<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
											<% end if %>
	
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% else %>
											<div class="price priceEnd">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
								</div>
							</a>
						</li>
						<% if oItem2.FResultCount > 0 then %>
							<li>
								<% if isApp then %>
									<a href="" onclick="fnAPPpopupProduct('1364733'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1364733">
								<% end if %>
	
									<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66637/m/img_item_02.jpg" alt="" /></span>
									<div class="option">
										<em class="name">POUCH</em>
										<strong class="price"><%= FormatNumber(oItem2.Prd.FSellCash,0) & chkIIF(oItem2.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								</a>
							</li>
						<% end if %>

						<% if oItem3.FResultCount > 0 then %>
							<li>
								<% if isApp then %>
									<a href="" onclick="fnAPPpopupProduct('1364741'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1364741">
								<% end if %>
	
									<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66637/m/img_item_03.jpg" alt="" /></span>
									<div class="option">
										<em class="name">ECO BAG</em>
										<strong class="price"><%= FormatNumber(oItem3.Prd.FSellCash,0) & chkIIF(oItem3.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								</a>
							</li>
						<% end if %>
					</ul>
				</div>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<%
set oItem=nothing
set oItem2=nothing
set oItem3=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
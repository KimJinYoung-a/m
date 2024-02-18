<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 16
' History : 2015-12-22 원승현 생성
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
	eCode   =  65993
Else
	eCode   =  68133
End If

dim userid, i
	userid = GetEncLoginUserID()

dim itemid , itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
	itemid2   =  1239115
	itemid3   =  1239115
	itemid4   =  1239115
	itemid5   =  1239115
	itemid6   =  1239115
Else
	itemid   =  1403587
	itemid2   =  1403589
	itemid3   =  1403591
	itemid4   =  1403595
	itemid5   =  1403597
	itemid6   =  1403593
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim oItem2
set oItem2 = new CatePrdCls
	oItem2.GetItemData itemid2

dim oItem3
set oItem3 = new CatePrdCls
	oItem3.GetItemData itemid3

dim oItem4
set oItem4 = new CatePrdCls
	oItem4.GetItemData itemid4

dim oItem5
set oItem5 = new CatePrdCls
	oItem5.GetItemData itemid5

dim oItem6
set oItem6 = new CatePrdCls
	oItem6.GetItemData itemid6

isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

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
.get .item ul li:nth-child(9), .get .item ul li:nth-child(10) {margin-bottom:0;}
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

		<%' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/tit_get.png" alt="WOOUF Laptop Sleeve 13형 구매하기" /></h2>
					<%' for dev msg : 상품 링크 걸어주세요 %>
					<div class="item">
						<ul>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403587'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403587&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_01.jpg" alt="" />
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403589'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403589&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_02.jpg" alt="Cactus" />
									<span class="price"><%= FormatNumber(oItem2.Prd.FSellCash,0) & chkIIF(oItem2.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem2.Prd.FOrgPrice-oItem2.Prd.FSellCash)/oItem2.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403591'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403591&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_03.jpg" alt="" />
									<span class="price"><%= FormatNumber(oItem3.Prd.FSellCash,0) & chkIIF(oItem3.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem3.Prd.FOrgPrice-oItem3.Prd.FSellCash)/oItem3.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403595'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403595&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_04.jpg" alt="" />
									<span class="price"><%= FormatNumber(oItem4.Prd.FSellCash,0) & chkIIF(oItem4.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem4.Prd.FOrgPrice-oItem4.Prd.FSellCash)/oItem4.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403597'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403597&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_05.jpg" alt="" />
									<span class="price"><%= FormatNumber(oItem5.Prd.FSellCash,0) & chkIIF(oItem5.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem5.Prd.FOrgPrice-oItem5.Prd.FSellCash)/oItem5.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1403593'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403593&pEtr=68133">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_thumb_06.jpg" alt="" />
									<span class="price"><%= FormatNumber(oItem6.Prd.FSellCash,0) & chkIIF(oItem6.Prd.IsMileShopitem,"Point","won") %> <em class="cRd1">[<%= Format00(2, CLng((oItem6.Prd.FOrgPrice-oItem6.Prd.FSellCash)/oItem6.Prd.FOrgPrice*100) ) %>%]</em></span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<%' //content area %>
	</div>
</div>
</body>
</html>
<%
set oItem=Nothing
set oItem2=nothing
set oItem3=Nothing
set oItem4=Nothing
set oItem5=Nothing
set oItem6=Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
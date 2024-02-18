<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 8
' History : 2015.10.27 원승현 생성
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
	eCode   =  64938
Else
	eCode   =  66910
End If

dim userid, i
	userid = GetEncLoginUserID()

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1344663
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim itemid2, itemid3, itemid4, itemid5
IF application("Svr_Info") = "Dev" THEN
	itemid2   =  1239115
	itemid3   =  1239115
	itemid4   =  1239115
	itemid5	  =  1239115
Else
	itemid2   =  1344657
	itemid3   =  1344665
	itemid4   =  1344683
	itemid5	  =  1344659
End If
   
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
.get .item ul li:nth-child(3), .get .item ul li:nth-child(4) {margin-bottom:0;}
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
					<div class="big">
						<%' for dev msg : 브랜드로 링크 걸어주세요 %>
						<% if isApp then %>
							<a href="" onclick="fnAPPpopupProduct('1344680'); return false;">							
						<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=1344680" class="link">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66910/m/img_thumb_big.jpg" alt="" />
							<div class="option">
								<% 
									'for dev msg : 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
									'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 
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
									<% Else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
									<em class="name"><span>SEA MINT</span></em>
								<% End If %>
							</div>
						</a>
					</div>

					<%' for dev msg : 상품 링크 걸어주세요 %>
					<div class="item">
						<ul>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1344657'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1344657">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66910/m/img_thumb_01.jpg" alt="" />
									<span class="color">BLACK SENSATION</span>
									<span class="price"><%= FormatNumber(oItem2.Prd.FSellCash,0) & chkIIF(oItem2.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1344665'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1344665">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66910/m/img_thumb_02.jpg" alt="" />
									<span class="color">COBRA</span>
									<span class="price"><%= FormatNumber(oItem3.Prd.FSellCash,0) & chkIIF(oItem3.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1344683'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1344683">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66910/m/img_thumb_03.jpg" alt="" />
									<span class="color">TIN CAN</span>
									<span class="price"><%= FormatNumber(oItem4.Prd.FSellCash,0) & chkIIF(oItem4.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1344659'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1344659">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/66910/m/img_thumb_04.jpg" alt="" />
									<span class="color">ROUGE PUR</span>
									<span class="price"><%= FormatNumber(oItem5.Prd.FSellCash,0) & chkIIF(oItem5.Prd.IsMileShopitem,"Point","won") %></span>
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
set oItem=nothing
set oItem2=nothing
set oItem3=Nothing
set oItem4=Nothing
set oItem5=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
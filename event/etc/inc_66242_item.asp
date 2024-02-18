<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 3
' History : 2015.09.22 한용민 생성
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
	'currenttime = #09/23/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64893
Else
	eCode   =  66242
End If

dim userid, i
	userid = GetEncLoginUserID()

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1354437
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

	isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px;}

.get .option .flag {display:inline-block; margin-bottom:10px; padding:2px 10px; border-radius:10px; background-color:#d50c0c; color:#fff; font-size:12px; line-height:1.375em;}
.get .option .flag {background-color:#999;}

.item {padding:0 4.68%;}
.item li {overflow:hidden; padding:4% 0; border-top:1px solid #eee;}
.item li:first-child {padding-top:0; border-top:0;}
.item li a {display:table;}
.item .figure {display:table-cell; width:44.82%; padding-right:5%;}
.item .option {display:table-cell; width:50.18%; vertical-align:middle;}

@media all and (min-width:480px){
	.get .option .flag {margin-bottom:15px; padding:3px 15px; font-size:18px;}
}

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

		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<p><strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/tit_buy.png" alt="CBB 구매하기" /></strong></p>
					<ul class="item">
						<li>
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1354437'); return false;" >
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1354437">
							<% end if %>

								<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_item_01.jpg" alt="" /></span>
								<div class="option">
									<%
									'<!-- for dev msg :  09/23~10/07 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
									'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
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

									<em class="name"><span>(5Type)</span></em>
								</div>
							</a>
						</li>
						<li>
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1354335'); return false;" >
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1354335">
							<% end if %>

								<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_item_02.jpg" alt="" /></span>
								<div class="option">
									<strong class="flag">MOUSEPAD</strong>
									<div class="price">
										<strong>4,000won</strong>
									</div>
									<em class="name"><span>(3Type)</span></em>
								</div>
							</a>
						</li>
						<li>
							<% if isApp then %>
								<a href="" onclick="fnAPPpopupProduct('1328744'); return false;" >
							<% else %>
								<a href="/category/category_itemPrd.asp?itemid=1328744">
							<% end if %>

								<span class="figure"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66242/m/img_item_03.jpg" alt="" /></span>
								<div class="option">
									<strong class="flag">DESK MAT</strong>
									<div class="price">
										<strong>9,800won</strong>
									</div>
									<em class="name"><span>(4Type)</span></em>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
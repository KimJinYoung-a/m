<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 2
' History : 2015.09.15 한용민 생성
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
	'currenttime = #09/09/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64880
Else
	eCode   =  66049
End If

dim userid, i
	userid = GetEncLoginUserID()

dim commentcount
commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1274641
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

	isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.31"></script>
<style type="text/css">
.get {position:relative;}
.get .option {position:absolute; top:17%; left:52%;}
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px;}

.get .item {top:13%;}
.get .item li:first-child {width:100%;}
.get .item li:first-child a {padding-bottom:42%;}
.get .item li a {padding-bottom:80.25%;}

.item {overflow:hidden; position:absolute; top:15%; left:50%; z-index:10; width:97.6%; margin-left:-48.8%;}
.item li {float:left; width:50%; margin-bottom:2.5%;}
.item li a {overflow:hidden; display:block; position:relative; height:0; margin:0 5%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter: alpha(opacity=0); cursor:pointer;}

<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
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
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/66049/m/img_get.jpg" alt="" />
					<div class="option">
						<%
						'<!-- for dev msg : 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
						'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 -->
						%>
						<% if oItem.FResultCount > 0 then %>
							<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
								<% If oItem.Prd.FOrgprice = 0 Then %>
								<% else %>
									<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
								<% end if %>

								<div class="price">
									<del><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></del>
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% else %>
								<div class="price priceEnd">
									<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
								</div>
							<% end if %>
						<% end if %>

						<em class="name"><span>W370 x D370 x H320mm</span></em>
					</div>
					<ul class="item">
						<% if isApp then %>
							<li><a href="" onclick="fnAPPpopupProduct('1274641'); return false;"><span></span>HACOBO</a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1274648'); return false;"><span></span>HACOBO 조립세트</a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1274649'); return false;"><span></span>HACOBO 바퀴세트</a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1274646'); return false;"><span></span>HACOBO 스툴용 쿠션시트</a></li>
							<li><a href="" onclick="fnAPPpopupProduct('1274647'); return false;"><span></span>HACOBO 테이블용 우드커버</a></li>
						<% else %>
							<li><a href="/category/category_itemPrd.asp?itemid=1274641"><span></span>HACOBO</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1274648"><span></span>HACOBO 조립세트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1274649"><span></span>HACOBO 바퀴세트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1274646"><span></span>HACOBO 스툴용 쿠션시트</a></li>
							<li><a href="/category/category_itemPrd.asp?itemid=1274647"><span></span>HACOBO 테이블용 우드커버</a></li>
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

<!-- #include virtual="/lib/db/dbclose.asp" -->
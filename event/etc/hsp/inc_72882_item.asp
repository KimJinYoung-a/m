<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 47 item M&A
' History : 2016-09-06 원승현 생성
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
	eCode   =  66196
Else
	eCode   =  72882
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
Else
	itemid1   =  1561880
	itemid2   =  1561881
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get h2 {padding:3rem 0 0; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get h2 span {display:block; font-weight:normal;}
.get .prdorder {width:8.85rem; height:1.75rem; margin:2.3rem auto 0; border-radius:20px; background-color:#d50c0c; color:#fff; font-size:1.1rem; line-height:1.75em; text-align:center;}
.get .item ul {overflow:hidden; padding:0 4.68%;}
.get .item ul li {overflow:hidden; width:100%; padding:2rem 0; border-top:1px solid #eee; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:46.2%;}
.get .item ul li .option {display:table-cell; width:53.8%; vertical-align:middle;}
.get .item ul li .name {color:#333; font-size:1.5rem; font-weight:normal;}
.get .item ul li .price {margin-top:1.1rem;}
.get .item ul li .price s {font-size:1.2rem;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.6rem;}
.get .item ul li .option p {margin-top:1.8rem; color:#777; font-size:0.9rem; line-height:1.375em;}

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
					<h2>[ SOCKS APPEAL X SML ] <span>Fruits &amp; Pattern socks 구매하기</span></h2>
					<p class="prdorder">19일 예약 발송</p>

					<div class="item">
						<%
							itemid = itemid1
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
						<ul>
							<li>
								<%' for dev msg : 상품코드 1561880 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1561880&amp;pEtr=72882">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Fruits/Pattern socks</b>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<p>FREE SIZE (230~275)<br /> Apple/Cherry/Orange/Pineapple<br /> Heart ring/Heart arrow</p>
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
								<%' for dev msg : 상품코드 1561881 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1561881&amp;pEtr=72882">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72882/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Fruits/Pattern socks</b>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<p>FREE SIZE (230~275)<br /> Cloud/rainbow/french fries<br /> hamburger/match navys<br /> match yellow</p>
									</div>
								</a>
							</li>
						</ul>
						<% 
								End If 
							Set oItem=nothing 
						%>
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
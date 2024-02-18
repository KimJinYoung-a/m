<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 37 item M&A
' History : 2016-06-21 유태욱 생성
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
	eCode   =  66156
Else
	eCode   =  71276
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239226
	itemid4   =  1239115
	itemid5   =  1239226	
Else
	itemid1   =  1504534
	itemid2   =  1504531
	itemid3   =  1504532
	itemid4   =  1504533
	itemid5   =  1504534
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.get h2 {padding:3rem 0 1.5rem; color:#333; font-size:1.5rem; font-weight:bold; text-align:center;}
.get .item ul {overflow:hidden; padding:0 0.9rem;}
.get .item ul li {overflow:hidden; width:100%; margin-top:2.5rem; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {border-top:0; margin-top:1.5rem;}
.get .item ul li a {display:table; width:100%; padding:0 6% 0 8%;}
.get .item ul li .thumbnail {display:table-cell; width:36%;}
.get .item ul li .option {display:table-cell; width:64%; vertical-align:middle;}
.get .item ul li .option {color:#737373; line-height:0.813em;}
.get .item ul li .discount {margin:0 0 0 2rem; padding:0.3rem 1rem 0.1rem;}
.get .item ul li .price {margin:0.3rem 0 0 2rem; font-weight:bold;}
.get .item ul li .price strong {line-height:1.188em;}
.get .item ul li .name {margin:1.3rem 0 0 2rem; color:#000; font-size:1.3rem; line-height:1.188em; letter-spacing:-0.05rem;}
.get .item ul li .info {margin:0.5rem 0 0 2rem; color:#808080; font-size:1rem; line-height:1.25em;}

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
					<h2>DENY Tapestries 구매하기</h2>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
							<%
							itemid = itemid1
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>
								<li>
									<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1504528&amp;pEtr=71276'); return false;">
									<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1504528&amp;pEtr=71276" target="_blank">
									<% end if %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71276/m/img_thumbnail_01.jpg" alt="" /></span>
										<div class="option">
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<strong class="discount">단, 일주일만 ONLY 20%</strong>
												<b class="name">WILD MONTANA</b>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% else %>
												<b class="name">WILD MONTANA</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
											<p class="info">사이즈 : 127x152cm<br /> 소재 : 폴리에스테르</p>
										</div>
									</a>
								</li>
							<% end if %>
							<% set oItem=nothing %>

							<%
							itemid = itemid2
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>
								<li>
									<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1504531&amp;pEtr=71276'); return false;">
									<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1504531&amp;pEtr=71276" target="_blank">
									<% end if %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71276/m/img_thumbnail_02.jpg" alt="" /></span>
										<div class="option">
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<strong class="discount">단, 일주일만 ONLY 20%</strong>
												<b class="name">CRYSTAL BLUE</b>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% else %>
												<b class="name">CRYSTAL BLUE</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
											<p class="info">사이즈 : 127x152cm<br /> 소재 : 폴리에스테르</p>
										</div>
									</a>
								</li>
							<% end if %>
							<% set oItem=nothing %>

							<%
							itemid = itemid3
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>							
								<li>
									<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1504532&amp;pEtr=71276'); return false;">
									<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1504532&amp;pEtr=71276" target="_blank">
									<% end if %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71276/m/img_thumbnail_03.jpg" alt="" /></span>
										<div class="option">
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<strong class="discount">단, 일주일만 ONLY 20%</strong>
												<b class="name">BEACH TOWER 5</b>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% else %>
												<b class="name">BEACH TOWER 5</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
											<p class="info">사이즈 : 127x152cm<br /> 소재 : 폴리에스테르</p>
										</div>
									</a>
								</li>
							<% end if %>
							<% set oItem=nothing %>

							<%
							itemid = itemid4
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>
								<li>
									<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1504533&amp;pEtr=71276'); return false;">
									<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1504533&amp;pEtr=71276" target="_blank">
									<% end if %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71276/m/img_thumbnail_04.jpg" alt="" /></span>
										<div class="option">
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<strong class="discount">단, 일주일만 ONLY 20%</strong>
												<b class="name">PACIFIC ISLANDS</b>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% else %>
												<b class="name">PACIFIC ISLANDS</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
											<p class="info">사이즈 : 127x152cm<br /> 소재 : 폴리에스테르</p>
										</div>
									</a>
								</li>
							<% end if %>
							<% set oItem=nothing %>

							<%
							itemid = itemid5
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>
								<li>
									<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1504534&amp;pEtr=71276'); return false;">
									<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1504534&amp;pEtr=71276" target="_blank">
									<% end if %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71276/m/img_thumbnail_05.jpg" alt="" /></span>
										<div class="option">
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<strong class="discount">단, 일주일만 ONLY 20%</strong>
												<b class="name">NEW YORK</b>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% else %>
												<b class="name">NEW YORK</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
											<p class="info">사이즈 : 127x152cm<br /> 소재 : 폴리에스테르</p>
										</div>
									</a>
								</li>
							<% end if %>
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
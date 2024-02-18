<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : hey, something project 시리즈 88
' 언제 어디서나,편안하게,당신곁에
' History : 2017-09-19 정태훈 생성
'###########################################################
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
dim userid, i, oItem, itemid
	isApp	= getNumeric(requestCheckVar(request("isApp"),1))
	userid = GetEncLoginUserID()
	
if isApp="" then isApp=0

dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66431
Else
	eCode   =  80569
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<base href="http://m.10x10.co.kr/">
<style type="text/css">.get h2 {padding-top:3rem; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get h2 span {display:block; font-weight:normal;}
.get .item ul {margin-top:2.5rem;}
.get .item ul li {overflow:hidden; width:100%; margin-top:1.7rem; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {margin-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:48.43%;}
.get .item ul li .option {display:table-cell; width:51.57%; vertical-align:middle;}
.get .item ul li .only {display:inline-block; height:1.8rem; padding:0 .7rem; background-color:#000; color:#fff; font-size:1rem; line-height:1.8rem;}
.get .item ul li .name {margin:.7rem 0 1.3rem; color:#333; font-size:1.48rem; font-weight:bold;}
.get .item ul li .price {margin-top:1.1rem;}
.get .item ul li .price s {font-size:1.2rem; font-weight:bold;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.6rem;}
.get .item ul li .option p {margin-top:1.8rem; color:#777; font-size:0.9rem; line-height:1.375em;}
</style>
</head>
<body class="default-font body-sub"><!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. -->
<div class="heightGrid">
	<div class="container popWin">
	<% if isApp=1 then %>
	<% else %>
		<div class="header">
			<h1>구매하기</h1>
			<% if isApp=1 then %>
				<p class="btnPopClose"><button onclick="fnAPPclosePopup(); return false;" class="pButton">닫기</button></p>
			<% else %>
				<p class="btnPopClose"><button onclick="history.back(); return false;" class="pButton">닫기</button></p>
			<% end if %>
		</div>
	<% end if %>
	<!-- contents -->
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<div class="item">
						<ul>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1789493
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789493&amp;pEtr=80569'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1789493&pEtr=80569">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
										<strong class="only">ONLY 10X10</strong>
										<b class="name">School 블랙</b>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> (<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
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
							<% set oItem = nothing %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1789494
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789494&amp;pEtr=80569'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1789494&pEtr=80569">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<strong class="only">ONLY 10X10</strong>
										<b class="name">Tomorrow 브라운</b>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> (<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
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
							<% set oItem = nothing %>
							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1789492
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1789492&amp;pEtr=80569'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1789492&pEtr=80569">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/80569/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
										<strong class="only">ONLY 10X10</strong>
										<b class="name">Today 블랙</b>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> (<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</strong>
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
							<% set oItem = nothing %>
						</ul>
					</div>
				</div>
			</div>
		</div>
	<!-- //contents -->

	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
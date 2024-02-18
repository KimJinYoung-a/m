<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 79
' History : 2017-07-18 유태욱 생성
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
	eCode   =  66397
Else
	eCode   =  79256
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get h2 {padding:3rem 0; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get .item ul li {color:#777; font-size:1rem; text-align:left;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:51%;}
.get .item ul li .option {display:table-cell; width:49%; padding-left:0.8rem; vertical-align:middle;}
.get .item ul li .only {display:inline-block; height:1.8rem; margin:0 0 1.2rem -1rem; padding:0 1rem; font-size:1.25rem; font-weight:bold; line-height:2rem; color:#fff; background-color:#000; border-radius:1.2rem;}
.get .item ul li .name {font-size:1.5rem; line-height:1.3;}
.get .item ul li .price {margin-top:.4rem;}
.get .item ul li .price s {display:block; font-size:1rem;}
.get .item ul li .price strong {display:inline-block; margin-top:-0.1rem; font-size:1.3rem;}
.get .btnclose {top:15px; right:10px;}
<% if isApp="1" then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.31"></script>

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
					<h2>K&amp;H 이지마운트<br />윈도우 베드 구매하기</h2>
					<div class="item">
						<ul>
							<%
								Dim itemid
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1721964
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1721964&amp;pEtr=79256'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1721964&pEtr=79256">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79256/m/img_thumbnail_1.jpg" alt="" /></span>
									<div class="option">
										<p class="name">Window Bed<br />Kitty Sill Green</p>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
												<%' for dev msg : 할인 중  %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
											<% Else %>
												<%' for dev msg : 할인 종료후 %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% End If %>
										<% End If %>	
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>

							<%
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1721981
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1721981&amp;pEtr=79256'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1721981&pEtr=79256">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79256/m/img_thumbnail_2.jpg" alt="" /></span>
									<div class="option">
										<span class="only">ONLY 10X10</span>
										<p class="name">Window Bubble<br />Pod Tan</p>
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
												<%' for dev msg : 할인 중  %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</strong>
												</div>
											<% Else %>
												<%' for dev msg : 할인 종료후 %>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% End If %>
										<% End If %>
									</div>
								</a>
							</li>
							<% Set oItem = Nothing %>
						</ul>
					</div>

				</div>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 77
' History : 2017-07-04 유태욱 생성
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
	eCode   =  66379
Else
	eCode   =  78959
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get h2 {padding-top:3rem; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get h2 span {display:block; font-weight:normal;}
.get .item {margin:0 5%;}
.get .item ul {margin-top:2.5rem; }
.get .item ul li {overflow:hidden; width:100%; padding:0.9rem 0; color:#777; font-size:1rem; text-align:left; border-bottom:solid 1px #eeeeee;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:44.8%;}
.get .item ul li .option {display:table-cell; width:48%; vertical-align:middle; padding-left:6.8%;}
.get .item ul li .name {padding-right:1.2rem; color:#333; font-size:1.3rem; line-height:1.3;}
.get .item ul li .price {margin-top:.4rem;}
.get .item ul li .price s {display:inline-block; font-size:1rem; font-weight:bold;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.25rem;}
.get .item ul li .option p {margin-top:1.8rem; color:#777; font-size:0.9rem; line-height:1.375em;}
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
					<h2>[Disney] The Little Mermaid<br /> 제품 구매하기</h2>
					<div class="item">
						<ul>
							<!-- for dev msg : 상품코드 1736459 -->
							<%
								Dim itemid
								IF application("Svr_Info") = "Dev" THEN
									itemid = 786868
								Else
									itemid = 1736459
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1736459&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1736459&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_1.jpg" alt="인어공주 뱃지 [E]" /></span>
									<div class="option">
										<b class="name">[Disney]Ariel<br />인어공주 뱃지</b>
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
									itemid = 1736460
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<!-- for dev msg : 상품코드 1736460 -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1736460&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1736460&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_2.jpg" alt="플라운더 뱃지 [E]" /></span>
									<div class="option">
										<b class="name">[Disney]Ariel<br />플라운더 뱃지</b>
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
									itemid = 1736461
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<!-- for dev msg : 상품코드 1736461 -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1736461&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1736461&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_3.jpg" alt="세바스찬 뱃지 [E]" /></span>
									<div class="option">
										<b class="name">[Disney]Ariel<br />세바스찬 뱃지</b>
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
									itemid = 1712139
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<!-- for dev msg : 상품코드 1712139 -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1712139&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1712139&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_4.jpg" alt="[Disney]Ariel_유리글라스" /></span>
									<div class="option">
										<b class="name">[Disney]Ariel<br />유리글라스</b>
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
									itemid = 1683251
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>							
							<li>
								<!-- for dev msg : 상품코드 1683251 -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1683251&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1683251&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_5.jpg" alt="PrincessMemo Pad" /></span>
									<div class="option">
										<b class="name">[Disney]Princess<br />Memo Pad</b>
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
									itemid = 1714017
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>							
							<li>
								<!-- for dev msg : 상품코드 1714017 -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1714017&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1714017&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_6.jpg" alt="[Disney]Ariel_비치타올" /></span>
									<div class="option">
										<b class="name">[Disney]Ariel<br />비치타올</b>
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
									itemid = 1683206
								End If
								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
								<!-- for dev msg : 상품코드 1683206  -->
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1683206&amp;pEtr=78959'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1683206&pEtr=78959">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78959/m/img_prd_list_7.jpg" alt="Princess Hologram Post Card" /></span>
									<div class="option">
										<b class="name">[Disney]Princess<br />Hologram Post Card</b>
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
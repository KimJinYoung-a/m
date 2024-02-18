<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 38 MA item
' History : 2016-06-28 김진영 생성
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
	
If isApp="" then isApp=0

Dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66161
Else
	eCode   =  71459
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239227
	itemid4   =  1239227
	itemid5   =  1239227
	itemid6   =  1239227
Else
	itemid1   =  1516362
	itemid2   =  1509356
	itemid3   =  1507612
	itemid4   =  1507611
	itemid5   =  1507610
	itemid6   =  1507606
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get .item ul {overflow:hidden; padding:0 1.5rem;}
.get .item ul li {overflow:hidden; width:100%; padding:1rem 0; color:#777; font-size:1.1rem; border-top:1px solid #eee; text-align:left;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:39%;}
.get .item ul li .option {display:table-cell; width:61%; vertical-align:middle;}
.get .item ul li .option {color:#737373; line-height:0.813em;}
.get .item ul li .discount {margin:0 0 0 1rem;}
.get .item ul li .price {margin:0 0 0 2rem; font-weight:bold;}
.get .item ul li .price strong {line-height:1.188em;}
.get .item ul li .name {margin:1rem 0 0.8rem 2rem; color:#000; font-size:1.3rem; line-height:1;}

.get .btnclose {top:15px; right:10px;}

<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
</head>
<body class="">
<div class="heightGrid">
	<div class="container popWin">
		<% If isApp=1 Then %>
		<% Else %>
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
					<%' for dev msg : 상품 링크 및 가격 부분 개발해주세요 %>
					<div class="item">
						<ul>
						<%
							itemid = itemid1
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 then 
						%>
							<li>
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1516362&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1516362&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
								<%' for dev msg : 할인기간 6/29~7/5, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">Glass Cup</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">Glass Cup</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 

							itemid = itemid2
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
							<li>
								<a href="/category/category_itemPrd.asp?itemid=1509356&amp;pEtr=71459">
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1509356&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1509356&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
								<%' for dev msg : 할인기간 6/29~7/5, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">Coaster (12P)</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">Coaster (12P)</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 

							itemid = itemid3
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
							<li>
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">PLAYING CARDS</b>
										<%' for dev msg : 현재 할인율 및 가격 적용 %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">PLAYING CARDS</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 

							itemid = itemid4
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
							<li>
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_04.jpg" alt="" /></span>
									<div class="option">
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">Pattern Dory iPhone6/6S Case</b>
										<%' for dev msg : 현재 할인율 및 가격 적용 %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">Pattern Dory iPhone6/6S Case</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 

							itemid = itemid5
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
							<li>
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_05.jpg" alt="" /></span>
									<div class="option">
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">Fantastic Dory iPhone6/6S Case</b>
										<%' for dev msg : 현재 할인율 및 가격 적용 %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">Fantastic Dory iPhone6/6S Case</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 

							itemid = itemid6
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
							%>
							<li>
								<% if isApp=1 then %>
									<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71459">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71459" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71459/m/img_thumbnail_06.jpg" alt="" /></span>
									<div class="option">
								<% if oItem.FResultCount > 0 then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐바이텐 ONLY 10%</strong>
										<b class="name">Stripe Dory iPhone6/6S Case</b>
										<%' for dev msg : 현재 할인율 및 가격 적용 %>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">Stripe Dory iPhone6/6S Case</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End If %>
									</div>
								</a>
							</li>
							<%
								End If
							set oItem = nothing 
							%>
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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-06-13 원승현 생성
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
	eCode   =  66339
Else
	eCode   =  78508
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get .item ul {margin:3.6rem 0 4rem;}
.get .item ul li {width:100%;padding-bottom:29.68%; margin-top:5rem; color:#777; font-size:1rem; text-align:left;}
.get .item ul li .thumbnail,
.get .item ul li .option {float:left;}
.get .item ul li .thumbnail {display:inline-block; width:43%;}
.get .item ul li .option {width:57%;}
.get .item ul li .name {padding-left:.8rem; color:#333; font-size:1.3rem; line-height:1.2em;}
.get .item ul li .price {padding-left:.8rem; margin-top:.1rem;}
.get .item ul li .price s {font-size:1.15rem;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.5rem;}
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
					<div class="item">
						<ul>
							<li>
								<%' for dev msg : 상품코드 1709650 %>
								<%
									Dim itemid
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1709650
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1709650&amp;pEtr=78508'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1709650&pEtr=78508">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78508/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
												<% if left(currenttime,10)>="2017-06-14" and left(currenttime,10)<"2017-06-22" then %>
													<strong class="discount">단 일주일만 ONLY 20%</strong>
												<% end if %>
												<b class="name">Flat Brimmed <br>Straw Ribbon Hat</b>
												<%' for dev msg : 할인 중  %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% Else %>
												<%' for dev msg : 할인 종료후 %>
												<b class="name">Flat Brimmed <br>Straw Ribbon Hat</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% End If %>
										<% End If %>
									</div>
								</a>
								<% Set oItem = Nothing %>
							</li>


							<li>
								<%' for dev msg : 상품코드 1709669 %>
								<%
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1709669
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1709669&amp;pEtr=78508'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1709669&pEtr=78508">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78508/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
												<% if left(currenttime,10)>="2017-06-14" and left(currenttime,10)<"2017-06-22" then %>
													<strong class="discount">단 일주일만 ONLY 20%</strong>
												<% end if %>
												<b class="name">Raffia Bucket Hat</b>
												<%' for dev msg : 할인 중  %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% Else %>
												<%' for dev msg : 할인 종료후 %>
												<b class="name">Raffia Bucket Hat</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% End If %>
										<% End If %>
									</div>
								</a>
								<% Set oItem = Nothing %>
							</li>

							<li>
								<%' for dev msg : 상품코드 1709632 %>
								<%
									IF application("Svr_Info") = "Dev" THEN
										itemid = 786868
									Else
										itemid = 1709632
									End If
									set oItem = new CatePrdCls
										oItem.GetItemData itemid
								%>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1709632&amp;pEtr=78508'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1709632&pEtr=78508">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/78508/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
										<% If oItem.FResultCount > 0 then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
												<% if left(currenttime,10)>="2017-06-14" and left(currenttime,10)<"2017-06-22" then %>
													<strong class="discount">단 일주일만 ONLY 20%</strong>
												<% end if %>
												<b class="name">Wide Raffia Hat</b>
												<%' for dev msg : 할인 중  %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% Else %>
												<%' for dev msg : 할인 종료후 %>
												<b class="name">Wide Raffia Hat</b>
												<div class="price priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% End If %>
										<% End If %>
									</div>
								</a>
								<% Set oItem = Nothing %>
							</li>
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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 67
' History : 2017-03-21 유태욱 생성
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
	eCode   =  66291
Else
	eCode   =  76797
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get .option {text-align:center;}
.get .option .name {color:#333; font-size:1.9rem; line-height:1.2em;}
.get .option .price {margin-top:1.3rem;}
.get .option .price s {display:inline; font-size:1.2rem;}
.get .option .price strong {display:inline; font-size:1.5rem;}
.get .option .price span {display:inline-block; width:2.9rem; height:1.5rem; padding-top:0.12rem; background-color:#d50c0c; color:#fff; font-size:1.1rem; line-height:1.5rem; vertical-align:0.2rem;}
@media (min-width:375px) {
	.get .option .price span {padding-top:0.15rem;}
}
.get .item {border-top:1px solid #ededed; padding-top:4.1rem;}
.get .item ul {overflow:hidden; margin-top:2.5rem;}
.get .item ul li {float:left; width:50%;}
.get .item1 {border-top:0;}
.get .item1 .price {margin-top:0.8rem;}
.get .item1 ul li:first-child {width:100%;}
.get .item2 {border-top:0; padding:5.8rem 0 3.7rem;}
.get .item2 ul li {width:32.28%;}
.get .item2 ul li:nth-child(3), .get .item2 ul li:nth-child(6) {width:33.44%;}
.get .item3 {padding:3.6rem 0 1rem;}
.get .item3 ul li {width:32.28%;}
.get .item3 ul li:nth-child(3), .get .item3 ul li:nth-child(6) {width:33.44%;}
.get .item4 {padding:3.6rem 0 1rem;}
.get .item4 ul li:nth-child(1), .get .item4 ul li:nth-child(2) {width:32.28%;}
.get .item4 ul li:nth-child(3) {width:33.44%;}

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

					<%
						Dim itemid
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1667442
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="item item1">
						<div class="option">
							<%'' for dev msg : 상품코드 1667442 할인기간 2017.03.22 ~ 03.28 할인기간이 지나면 <strong class="discount">...</strong> 숨겨주세요 %>
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
									<% if left(currenttime,10)>="2017-03-22" and left(currenttime,10)<="2017-03-28" then %>
										<strong class="discount">텐바이텐에서만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
									<% end if %>
									<b class="name">Lovedog Cardigan</b>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% else %>
									<b class="name">Lovedog Cardigan</b>
									<div class="price priceEnd">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
							<% end if %>
						</div>

						<% If isapp = "1" Then %>
							<ul>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1667442&pEtr=76797" onclick="fnAPPpopupProduct('1667442&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_01.jpg" alt="Bichon" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1667444&pEtr=76797" onclick="fnAPPpopupProduct('1667444&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_02_v1.jpg" alt="Beagle" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1667455&pEtr=76797" onclick="fnAPPpopupProduct('1667455&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_03_v1.jpg" alt="Dachshund" /></a></li>
							</ul>
						<% Else %>
							<ul>
								<li><a href="/category/category_itemPrd.asp?itemid=1667442&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_01.jpg" alt="Bichon" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1667444&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_02_v1.jpg" alt="Beagle" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1667455&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_01_03_v1.jpg" alt="Dachshund" /></a></li>
							</ul>
						<% End If %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/txt_item_info.gif" alt="소재 코튼 100%로 S사이즈는 어깨 35cm 가슴 47 cm 소매60cm 총길이 57cm며,  M은 어깨 36cm 가슴 48cm 소매 62cm 총길이 60cm 입니다." /></p>
					</div>
					<% Set oItem = Nothing %>

					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1669884
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="item item2">
						<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
									<b class="name">Pocket T</b>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% else %>
									<b class="name">Pocket T</b>
									<div class="price priceEnd">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
							<% end if %>
						</div>
						<% If isapp = "1" Then %>
							<ul>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669884&pEtr=76797" onclick="fnAPPpopupProduct('1669884&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_01_v1.jpg" alt="bichon" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669882&pEtr=76797" onclick="fnAPPpopupProduct('1669882&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_02_v1.jpg" alt="dachshund" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669880&pEtr=76797" onclick="fnAPPpopupProduct('1669880&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_06.jpg" alt="pug" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669883&pEtr=76797" onclick="fnAPPpopupProduct('1669883&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_03.jpg" alt="beagle" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669879&pEtr=76797" onclick="fnAPPpopupProduct('1669879&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_04.jpg" alt="collie" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669889&pEtr=76797" onclick="fnAPPpopupProduct('1669889&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_05.jpg" alt="french bulldog" /></a></li>
							</ul>
						<% Else %>
							<ul>
								<li><a href="/category/category_itemPrd.asp?itemid=1669884&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_01_v1.jpg" alt="bichon" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669882&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_02_v1.jpg" alt="dachshund" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669880&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_06.jpg" alt="pug" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669883&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_03.jpg" alt="beagle" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669879&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_04.jpg" alt="collie" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669889&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_02_05.jpg" alt="french bulldog" /></a></li>
							</ul>
						<% End If %>
					</div>
					<% Set oItem = Nothing %>

					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 1669898
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="item item3">
						<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
									<b class="name">Cover Socks</b>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% else %>
									<b class="name">Cover Socks</b>
									<div class="price priceEnd">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
							<% end if %>							
						</div>
						<% If isapp = "1" Then %>
							<ul>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669898&pEtr=76797" onclick="fnAPPpopupProduct('1669898&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_01.jpg" alt="bichon" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669899&pEtr=76797" onclick="fnAPPpopupProduct('1669899&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_02.jpg" alt="beagle" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669896&pEtr=76797" onclick="fnAPPpopupProduct('1669896&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_03.jpg" alt="pug" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669893&pEtr=76797" onclick="fnAPPpopupProduct('1669893&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_04.jpg" alt="dachshund" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669897&pEtr=76797" onclick="fnAPPpopupProduct('1669897&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_05.jpg" alt="collie" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1669890&pEtr=76797" onclick="fnAPPpopupProduct('1669890&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_06.jpg" alt="french bulldog" /></a></li>
							</ul>
						<% Else %>
							<ul>
								<li><a href="/category/category_itemPrd.asp?itemid=1669898&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_01.jpg" alt="bichon" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669899&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_02.jpg" alt="beagle" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669896&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_03.jpg" alt="pug" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669893&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_04.jpg" alt="dachshund" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669897&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_05.jpg" alt="collie" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1669890&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_03_06.jpg" alt="french bulldog" /></a></li>
							</ul>
						<% End If %>
					</div>
					<% Set oItem = Nothing %>

					<%
						IF application("Svr_Info") = "Dev" THEN
							itemid = 786868
						Else
							itemid = 949842
						End If
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="item item4">
						<div class="option">
							<% If oItem.FResultCount > 0 then %>
								<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>							
									<b class="name">Long Socks</b>
									<div class="price">
										<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% else %>
									<b class="name">Long Socks</b>
									<div class="price priceEnd">
										<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
									</div>
								<% end if %>
							<% end if %>
						</div>
						<% If isapp = "1" Then %>
							<ul>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=949842&pEtr=76797" onclick="fnAPPpopupProduct('949842&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_01.jpg" alt="dachshund" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1584229&pEtr=76797" onclick="fnAPPpopupProduct('1584229&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_02.jpg" alt="bichon" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1458245&pEtr=76797" onclick="fnAPPpopupProduct('1458245&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_03.jpg" alt="pug" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1015706&pEtr=76797" onclick="fnAPPpopupProduct('1015706&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_04.jpg" alt="beagle" /></a></li>
								<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1388794&pEtr=76797" onclick="fnAPPpopupProduct('1388794&amp;pEtr=76797');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_05.jpg" alt="collie" /></a></li>
							</ul>
						<% Else %>
							<ul>
								<li><a href="/category/category_itemPrd.asp?itemid=949842&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_01.jpg" alt="dachshund" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1584229&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_02.jpg" alt="bichon" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1458245&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_03.jpg" alt="pug" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1015706&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_04.jpg" alt="beagle" /></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1388794&pEtr=76797"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76797/m/img_thumbnail_04_05.jpg" alt="collie" /></a></li>
							</ul>
						<% End If %>
					</div>
					<% Set oItem = Nothing %>

				</div>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
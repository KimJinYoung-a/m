<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 18 MA item
' History : 2016-01-19 유태욱 생성
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
	eCode   =  66118
Else
	eCode   =  70431
End If

dim itemid, itemid1, itemid2, itemid3, itemid4
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239226
	itemid4   =  1239221
Else
	itemid1   =  1480689
	itemid2   =  1480688
	itemid3   =  1480689
	itemid4   =  1480688
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get .item ul {overflow:hidden; padding:0 1rem;}
.get .item ul li {position:relative; overflow:hidden; width:100%; padding:1.5rem 0.5rem; text-align:left; border-bottom:1px solid #eee;}
.get .item ul li:last-child {border-bottom:none;}
.get .item ul li a {overflow:hidden; display:block; width:100%; height:100%;}
.get .item ul li .thumbnail {float:left; width:13.85rem;}
.get .item ul li .option {padding-left:15rem; padding-top:0.5rem;}
.get .item ul li .option {color:#737373; line-height:0.813em;}
.get .item ul li .option p {position:absolute; left:15.5rem; bottom:1.5rem; line-height:1.2;}
.get .item ul li .price {margin-top:0; padding-top:1rem; font-size:1.2rem; }
.get .item ul li .price strong {font-size:1.6rem;}
.get .item ul li div.priceEnd {margin-top:1rem;}
.get .item ul li .name {color:#000; font-size:1.5rem; font-weight:normal;}
.get .item ul li .name span {overflow:hidden; color:#000; font-size:0.9rem; letter-spacing:-0.05rem; text-overflow:ellipsis; white-space:nowrap;}
.get .item ul li .gift {display:block; margin-top:0.5rem; color:#fbb21b; font-weight:bold; font-size:0.9rem; letter-spacing:-0.04rem;}
.get .item ul li .gift span {display:inline-block; padding:0.2rem 0.3rem 0.1rem 0.3rem; background-color:#ffba2a; color:#fff; font-family:arial, tahoma, sans-serif;}
.get .btnclose {top:15px; right:10px;}

/* 앱일 경우에만 해당 css 불러와 주세요 */
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

		<%'' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/txt_get.png" alt="마이빈스X텐바이텐 카네이션 선물세트 구매하기" /></p>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
							<%
							itemid = itemid1
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<% if oItem.FResultCount > 0 then %>
							<li class="typeA">
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1480689&pEtr=70431'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1480689&amp;pEtr=70431" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_thumb_01.jpg" alt="" /></span>
									<div class="option">
										<em class="name">Fake socks</em>

										<% if oItem.FResultCount > 0 then %>
											<% if oItem.Prd.isCouponItem then %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong style="color:#24965f;"><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %>[10%]</strong>
													<span class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</span>
												</div>
											<% else %>
												<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
													<div class="price">
														<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
														<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
														<span class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</span>
													</div>
												<% else %>
													<div class="priceEnd">
														<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
														<span class="gift"><span>GIFT</span> 3개 구매 시, 1개 랜덤 증정</span>
													</div>
												<% end if %>
											<% end if %>
										<% end if %>
										<p>Free size<br />Muzi / Tube / Apeach / Neo / Frodo / Con</p>
									</div>
								</a>
							</li>
							<% set oItem=nothing %>
							<%
							itemid = itemid2
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
							%>
							<li class="typeA">
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1480688&amp;pEtr=70431'); return false;">
								<% else %>
									<a href="/category/category_itemPrd.asp?itemid=1480688&amp;pEtr=70431" target="_blank">
								<% end if %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70431/m/img_thumb_02.jpg" alt="" /></span>
									<div class="option">
										<em class="name">Long socks</em>
										<% if oItem.FResultCount > 0 then %>
											<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
												<div class="price">
													<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %>[33%]</strong>
												</div>
											<% else %>
												<div class="priceEnd">
													<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
												</div>
											<% end if %>
										<% end if %>
										<p>Free size<br />Apeach / Muzi / Neo / Tube / Frodo / Jay-G</p>
									</div>
								</a>
							</li>
							<% set oItem=nothing %>
							<% end if %>
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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 42 item M&A
' History : 2016-08-02 김진영 생성
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
	eCode   =  66177
Else
	eCode   =  72182
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6, itemid7, itemid8
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239226
	itemid4   =  1239115
	itemid5   =  1239226
	itemid6   =  1239226
	itemid7   =  1239226
	itemid8   =  1239226
Else
	itemid1   =  1537564
	itemid2   =  1537566
	itemid3   =  1537568
	itemid4   =  1537569
	itemid5   =  1537570
	itemid6   =  1537571
	itemid7   =  1537572
	itemid8   =  1537565
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.popWin .content {padding-bottom:0;}

.get h2 {padding:3rem 0 0; color:#333; font-size:1.5rem; font-weight:bold; text-align:center;}
.get .item ul {overflow:hidden;}
.get .item ul li {overflow:hidden; width:100%; margin-top:3.5rem; color:#777; text-align:left;}
.get .item ul li:first-child {margin-top:2.5rem;}
.get .item ul li a {display:table; width:100%;}
.get .item ul li .thumbnail {display:table-cell; width:43.75%;}
.get .item ul li .option {display:table-cell; width:56.25%; color:#737373; line-height:0.813em; vertical-align:middle;}
.get .item ul li .discount {margin-bottom:0; padding:0.3rem 1rem 0.1rem; font-size:1rem;}
.get .item ul li .name {margin:1.1rem 0 0 0.01rem; color:#000; font-size:1rem; line-height:1.188em;}
.get .item ul li .price {margin:0.3rem 0 0 0.01rem; font-size:1.1rem; font-weight:bold;}
.get .item ul li .price strong {font-size:1.4rem; line-height:1.188em;}

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
					<h2>HALF ARTIST SOAP 구매하기</h2>

					<%''  for dev msg : 상품 링크 %>
					<div class="item">
						<ul>
						<%
							itemid = itemid1
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537564&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537564&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537564, 할인기간 8/3 ~ 8/9 할인기간이 지나면  <strong class="discount">...</strong> 숨겨주세요 이하 상품 할인 기간 동일합니다. %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿럭 캔디 비누</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿럭 캔디 비누</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
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
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537566&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537566&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537566 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿나잇 비누 다이아몬드 &apos;크리미 린넨&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿나잇 비누 다이아몬드 &apos;크리미 린넨&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid3
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537568&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537568&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537568 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿모닝 비누 다이아몬드 &apos;카렌듈라 샤워&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿모닝 비누 다이아몬드 &apos;카렌듈라 샤워&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid4
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537569&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537569&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_04.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537569 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿나잇 비누 초콜릿 &apos;스태리 나잇&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿나잇 비누 초콜릿 &apos;스태리 나잇&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid5
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537570&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537570&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_05.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537570 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿나잇 비누 초콜릿 &apos;크리미 린넨&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿나잇 비누 초콜릿 &apos;크리미 린넨&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid6
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537571&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537571&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_06.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537571 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿모닝 비누 초콜릿 &apos;프레시 밀크&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿모닝 비누 초콜릿 &apos;프레시 밀크&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid7
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537572&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537572&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_07.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537572 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">굿모닝 비누 초콜릿 &apos;카렌듈라 샤워&apos;</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">굿모닝 비누 초콜릿 &apos;카렌듈라 샤워&apos;</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 

							itemid = itemid8
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1537565&amp;pEtr=72182'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1537565&amp;pEtr=72182" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/72182/m/img_thumbnail_08.jpg" alt="" /></span>
									<div class="option">
									<%' for dev msg : 상품코드 1537565 %>
								<% If oItem.FResultCount > 0 Then %>
									<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
										<strong class="discount">텐텐 단독 선오픈 ONLY 10%</strong>
										<b class="name">선물용 패브릭 파우치</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">선물용 패브릭 파우치</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
								<% End if %>
									</div>
								</a>
							</li>
						<% 
								End If 
							Set oItem=nothing 
						%>
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
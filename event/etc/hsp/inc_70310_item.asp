<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 29
' History : 2016-04-26 김진영 생성
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
Dim userid, i
	isApp	= getNumeric(requestCheckVar(request("isApp"),1))
	userid = GetEncLoginUserID()
	
If isApp = "" Then isApp = 0

Dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66110
Else
	eCode   =  70310
End If

Dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" Then
	itemid	  =  22222
	itemid1   =  22222
	itemid2   =  33333
	itemid3   =  44444
	itemid4   =  55555
	itemid5	  =  66666
	itemid6	  =  777777
Else
	itemid	  =  1471403
	itemid1   =  1471409
	itemid2   =  1471305
	itemid3   =  1471304
	itemid4   =  1471303
	itemid5	  =  1471302
	itemid6	  =  1471301
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

.get .item ul {overflow:hidden; padding:0 1rem;}
.get .item ul li {float:left; width:50%; margin-top:2rem; padding:0 1rem; color:#777; font-size:1rem; text-align:center;}
.get .item ul li:first-child {margin-top:0;}
.get .item ul li:nth-child(3), .get .item ul li:nth-child(4) {margin-top:3.5rem;}
.get .item ul li a {display:block;}
.get .item ul li span {display:block;}
.get .item ul li .price {font-weight:bold; margin-top:0.3rem;}
.get .item ul li .name {overflow:hidden; margin-top:0.5rem; line-height:1.25em; text-overflow:ellipsis; white-space:nowrap;}

.get .item ul li.typeA {overflow:hidden; clear:left; width:100%; padding:0 1rem; text-align:left;}
.get .item ul li.typeA .thumbnail {float:left; width:46.42%;}
.get .item ul li.typeA .option {float:left; width:53.58%; padding-left:1.7rem;}
.get .item ul li.typeA .option {color:#737373; line-height:0.813em;}
.get .item ul li.typeA .name {margin-top:1rem; color:#000; font-size:0.9rem; font-weight:normal;}
.get .item ul li.typeA .name span {overflow:hidden; color:#000; font-size:0.9rem; letter-spacing:-0.05rem; text-overflow:ellipsis; white-space:nowrap;}

.get .btnclose {top:15px; right:10px;}

<% If isApp = "1" Then %>
	.popWin .content {padding-top:0;}
<% End If %>
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
		<% If isApp=1 Then %>
		<% Else %>
			<div class="header">
				<h1>구매하기</h1>
				<% If isApp = 1 then %>
					<p class="btnPopClose"><button onclick="fnAPPclosePopup(); return false;" class="pButton">닫기</button></p>
				<% Else %>
					<p class="btnPopClose"><button onclick="self.close(); return false;" class="pButton">닫기</button></p>
				<% End If %>
			</div>
		<% End If %>
		<%'' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/txt_get.png" alt="마이빈스X텐바이텐 카네이션 선물세트 구매하기" /></p>
					<%
						Dim oItem
						set oItem = new CatePrdCls
							oItem.GetItemData itemid
					%>
					<div class="item">
						<ul>
							<li class="typeA">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471403&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471403&amp;pEtr=70310" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_01.jpg" alt="" /></span>
									<div class="option">
								<%' for dev msg : 할인기간 4/27~5/3, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
								<% If oItem.FResultCount > 0 Then %>
									<% If (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) Then %>
										<strong class="discount">텐바이텐 ONLY 20%</strong>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
										<em class="name">텐바이텐 단독 상품 <span>구성 : 500mlx2, 카드, 쇼핑백</span></em>
								<% End If %>
									</div>
								</a>
							</li>
					<%
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid1
					%>
							<li class="typeA">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471409&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471409&amp;pEtr=70310" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_02.jpg" alt="" /></span>
									<div class="option">
								<%' for dev msg : 할인기간 4/27~5/3, 할인 종료 후 <div class="price">...</div>에는 클래스 priceEnd을 붙이고 <s>....<s>숨겨주세요, <strong class="discount">...<strong>도 숨겨 주세요 %>
								<% If oItem.FResultCount > 0 Then %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">텐바이텐 ONLY 20%</strong>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End If %>
										<em class="name">텐바이텐 단독 상품 <span>구성 : 더치팩 50mlx20포, 카드, 쇼핑백</span></em>
								<% End If %>
									</div>
								</a>
							</li>
					<% 
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid2
					%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471305&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471305&amp;pEtr=70310" target="_blank">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_03.jpg" alt="" />
									<span class="name">땡큐에디션 W(와인병)</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
					<% 
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid3
					%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471304&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471304&amp;pEtr=70310" target="_blank">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_04.jpg" alt="" />
									<span class="name">땡큐에디션 실속 500ml</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
					<% 
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid4
					%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471303&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471303&amp;pEtr=70310" target="_blank">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_05.jpg" alt="" />
									<span class="name">카네이션 땡큐 세트 250ml</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
					<% 
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid5
					%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471302&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471302&amp;pEtr=70310" target="_blank">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_06.jpg" alt="" />
									<span class="name">땡큐 선물세트 (250mlx4병)</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
					<% 
						set oItem = nothing
						set oItem = new CatePrdCls
							oItem.GetItemData itemid6
					%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1471301&amp;pEtr=70310'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1471301&amp;pEtr=70310" target="_blank">
							<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/70310/m/img_thumb_07.jpg" alt="" />
									<span class="name">땡큐 선물세트 (210mlx4병)</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
					<% 
						set oItem=nothing
					%>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<%' //content area %>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
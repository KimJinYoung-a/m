<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-12-20 유태욱 생성
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
	eCode   =  66255
Else
	eCode   =  75018
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.heySomething {padding-bottom:0;}
.get .discount {display:inline-block; margin-bottom:2rem; padding:0.5rem 0.8rem 0.3rem; color:#fff; text-align:center; background-color:#d50c0c; border-radius:1.2rem;}
.get .item {padding:0 6.25%;}
.get .item .representative {margin-bottom:2.5rem; padding-bottom:1.5rem; border-bottom:0.1rem solid #ccc;}
.get .item .representative a {display:table; width:100%;}
.get .item .representative .thumbnail {display:table-cell; width:48%;}
.get .item .representative .option {display:table-cell; width:52%; vertical-align:top; text-align:left;}
.get .item .representative .name {color:#333; font-size:1.4rem; line-height:1.2; font-weight:bold;}
.get .item .representative .price {margin-top:0.3rem;}
.get .item .representative .price s {font-size:1.2rem;}
.get .item .representative .price strong {margin-top:-0.3rem; font-size:1.6rem;}
.get .item .representative .discount {margin-bottom:1.5rem;}
.get .item .representative p {margin-top:0.5rem; color:#808080; font-size:1rem; line-height:1.25em;}

.get .item ul {overflow:hidden;}
.get .item ul li {overflow:hidden; float:left; width:50%; margin-bottom:2.7rem; color:#777; font-size:1rem; text-align:center}
.get .item ul li:nth-child(even) {padding-left:3.4%;}
.get .item ul li:nth-child(odd) {padding-right:3.4%;}
.get .item ul li .option {overflow:hidden; margin-top:0.7rem;}
.get .item ul li .name, .get .item ul li .price {display:block; font-size:1rem; color:#777;}
.get .item ul li .price {margin-top:0.3rem; font-weight:bold;}
.get .item ul li .name {font-weight:normal;}

.get .btnclose {top:15px; right:10px;}

<% if isApp="1" then %>
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

		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/75018/m/tit_alice_10x10.png" alt="" /></h2>
					<div class="item">
						<%
							Dim itemid
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1612371
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
						<div class="representative">
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1612371&amp;pEtr=75018'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1612371&amp;pEtr=75018">
							<% End If %>
								<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/75018/m/img_thumbnail_01.jpg" alt="" /></span>
								<div class="option">
									<% If oItem.FResultCount > 0 then %>
										<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
											<%'' for dev msg : 할인기간 12/21 ~ 12/27, 할인 종료 후 삭제 %>
											<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
											<b class="name">[Disney] Alice<br/>스트로베리 홍차 (7개입)</b>
											<p>식품 유형:침출차 (홍차)<br/>내용량:0.8g x 7 tea bags</p>
											<div class="price">
												<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% else %>
											<b class="name">[Disney] Alice<br/>스트로베리 홍차 (7개입)</b>
											<p>식품 유형:침출차 (홍차)<br/>내용량:0.8g x 7 tea bags</p>
											<div class="price">
												<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
											</div>
										<% end if %>
									<% end if %>
									
								</div>
							</a>
						</div>
						<% Set oItem = Nothing %>

						<% If Date()>= "2016-12-20" And Date < "2016-12-28" Then %>
							<%'' for dev msg : 할인기간 12/21 ~ 12/27, 할인 종료 후 삭제 %>
							<p class="ct"><strong class="discount">텐바이텐 only</strong></p>
						<% end if %>
						<ul class="with">
							<%
							Dim arritem, lp

							IF application("Svr_Info") = "Dev" THEN
								arritem = array(1239115,1239115,1239115,1239115,1239115,1239115)
							Else
								arritem = array(1422085,1405559,1474756,1593649,1542686,1413577)
							End If
							
							For lp = 0 To 5

							set oItem = new CatePrdCls
								oItem.GetItemData arritem(lp)
							%>
							<li>
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=75018'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=75018">
								<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/75018/m/img_thumbnail_<%= Format00(2, lp+2) %>.jpg" alt="" /></span>
									<div class="option">
										<% If lp = 0 Then %>
											<span class="name">Tea cup 2set (4pcs)</span>
										<% ElseIf lp = 1 Then %>
											<span class="name">Tea pot 2set</span>
										<% ElseIf lp = 2 Then %>
											<span class="name">Cushion (4style)</span>
										<% ElseIf lp = 3 Then %>
											<span class="name">Alice Poster</span>
										<% ElseIf lp = 4 Then %>
											<span class="name">Hologram Note</span>
										<% ElseIf lp = 5 Then %>
											<span class="name">Playing Cards</span>
										<% End If %>

										<% If oItem.FResultCount > 0 Then %>
											<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
												<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <i>(<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%)</i></span>
											<% Else %>
												<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
											<% End If %>
										<% End If %>
									</div>
								</a>
							</li>
							<%
								Set oItem = Nothing
								Next
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
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 DAILYLIKE 전기방석 M&A
' History : 2016-11-15 원승현 생성
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
	eCode   =  66236
Else
	eCode   =  74188
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.heySomething {padding-bottom:0;}
.get {padding-top:2.8rem;}
.get .discount {padding-bottom:1.2rem;}
.get .discount span {display:inline-block; height:1.8rem; padding:0 1.2rem; font-size:1.1rem; line-height:1.9rem; color:#fff; background:#d50c0c; border-radius:0.9rem;}
.get h2 {padding-bottom:0.5rem;}
.get .item ul {overflow:hidden; padding:0 4.68%;}
.get .item ul li {overflow:hidden; width:100%; padding:2rem 0; color:#777; text-align:left; border-top:1px solid #eee;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table; width:100%; padding-left:8%;}
.get .item ul li .thumbnail {display:table-cell; width:28%;}
.get .item ul li .option {display:table-cell; width:62%; padding-left:14%; color:#737373; vertical-align:middle;}
.get .item ul li .name {color:#000; font-size:1.4rem; line-height:1.8rem;}
.get .item ul li .price {margin-top:0.5rem; font-size:1.1rem; color:#8a8a8a;}
.get .item ul li .price strong {font-size:1.3rem; line-height:1.188em;}
.get .btnclose {top:15px; right:10px;}

<% if isApp="1" then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
<script type="text/javascript">
// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
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
					<%' for dev msg : 11/16~11/22 까지만 노출 %>
					<% If Date()>= "2016-11-15" And Date < "2016-11-23" Then %>
						<p class="discount ct"><span>단, 일주일만 <strong>ONLY 20%</strong></span></p>
					<% End If %>
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/txt_buy.png" alt="" /></h2>
					<div class="item">
						<ul class="with">
							<%
								Dim itemid , lp

								IF application("Svr_Info") = "Dev" THEN
									itemid = 1239115
								Else
									itemid = 1599887
								End If
								

								set oItem = new CatePrdCls
									oItem.GetItemData itemid
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_thumbnail_01.png" alt="" /></span>
									<div class="option">
										<b class="name">Dailylike 전기방석<br />알파카</b>
										<% if oItem.FResultCount > 0 then %>
										<div class="price">
											<% If left(currenttime,10)>="2016-11-15" and left(currenttime,10)<="2016-11-22" Then %>
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<% End If %>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<% End If %>
									</div>
								</a>
							</li>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_thumbnail_02.png" alt="" /></span>
									<div class="option">
										<b class="name">Dailylike 전기방석<br />플라밍고</b>
										<% if oItem.FResultCount > 0 then %>
										<div class="price">
											<% If left(currenttime,10)>="2016-11-15" and left(currenttime,10)<="2016-11-22" Then %>
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<% End If %>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<% End If %>
									</div>
								</a>
							</li>

							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>&amp;pEtr=74188">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74188/m/img_thumbnail_03.png" alt="" /></span>
									<div class="option">
										<b class="name">Dailylike 전기방석<br />크리스마스</b>
										<% if oItem.FResultCount > 0 then %>
										<div class="price">
											<% If left(currenttime,10)>="2016-11-15" and left(currenttime,10)<="2016-11-22" Then %>
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<% End If %>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
										<% End If %>
									</div>
								</a>
							</li>
							<%
								Set oItem = Nothing
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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 54 item M&A
' History : 2016-11-01 이종화 생성
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
	eCode   =  66225
Else
	eCode   =  73896
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
.get .item ul li .name {color:#000; font-size:1.4rem;}
.get .item ul li .price {margin-top:0.5rem; font-size:1.1rem; color:#8a8a8a;}
.get .item ul li .price strong {font-size:1.3rem; line-height:1.188em;}
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
					<!-- for dev msg : 11/2~11/8 까지만 노출 -->
					<% If Date()>= "2016-11-02" And Date < "2016-11-09" Then %>
					<p class="discount ct"><span>단, 일주일만 <strong>ONLY 10%</strong></span></p>
					<% End If %>
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73896/m/txt_buy.png" alt="" /></h2>
					<div class="item">
						<ul class="with">
							<%
								Dim arritem , lp

								IF application("Svr_Info") = "Dev" THEN
									arritem = array(1239115,1239115,1239115,1239115,1239115,1239115,1239115)
								Else
									arritem = array(1545424,1545423,1545425,1545422,1495674,1495626,1507390)
								End If
								
								For lp = 0 To 6

								set oItem = new CatePrdCls
									oItem.GetItemData arritem(lp)
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=73896'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=73896">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73896/m/img_thumbnail_0<%=lp+1%>.jpg" alt="" /></span>
									<div class="option">
										<% If lp = 0 Then %>
										<b class="name">PEANUTS WEEKLY<br />PLANNER 2017</b>
										<% elseIf lp = 1 Then %>
										<b class="name">PEANUTS<br />DAY TO DAY 2017</b>
										<% elseIf lp = 2 Then %>
										<b class="name">PEANUTS MINI<br />DAY TO DAY 2017</b>
										<% elseIf lp = 3 Then %>
										<b class="name">GAFIELD<br />DAY TO DAY 2017</b>
										<% elseIf lp = 4 Then %>
										<b class="name">PEANUTS<br />WALL 2017</b>
										<% elseIf lp = 5 Then %>
										<b class="name">PEANUTS MINI<br />WALL 2017</b>
										<% elseIf lp = 6 Then %>
										<b class="name">GAFIELD<br />WALL 2017</b>
										<% End If %>

										<% if oItem.FResultCount > 0 then %>
										<div class="price">
											<% If left(currenttime,10)>="2016-11-02" and left(currenttime,10)<="2016-11-08" Then %>
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

								Next
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
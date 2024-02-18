<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-11-22 김진영 생성
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
	eCode   =  66242
Else
	eCode   =  74435
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get h2 {padding-top:3rem; color:#333; font:bold 1.6rem/1.313em arial; text-align:center;}
.get h2 span {font-weight:normal;}
.get .item .discount {display:inline-block; height:1.8rem; margin-top:1rem; padding:0 0.8rem; color:#fff; font-size:1.1rem; line-height:1.9rem; background:#d50c0c; border-radius:0.9rem;}
.get .item ul {overflow:hidden; margin-top:0.5rem;}
.get .item ul li {overflow:hidden; float:left; width:50%; margin-top:2.7rem; padding:0 1.4rem; color:#777; font-size:1rem; letter-spacing:-0.025em; text-align:center}
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

		<%'' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<h2>MARK’S CHRISTMAS 구매하기</h2>
					<div class="item">
					<%' for dev msg : 11/23~11/29 까지만 노출 %>
					<% If Date()>= "2016-11-22" And Date < "2016-11-30" Then %>
						<p class="ct"><strong class="discount">단, 일주일만 ONLY 10%</strong></p>
					<% End If %>
						<ul class="with">
							<%' for dev msg : 상품별 가격 불러와주세요 %>
							<%
								Dim arritem, lp

								IF application("Svr_Info") = "Dev" THEN
									arritem = array(1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115)
								Else
									arritem = array(1598874,1598382,1598808,1598798,1598360,1598851,1598800,1598339,1598825,1598859,1598000,1597999)
								End If
								
								For lp = 0 To 11

								set oItem = new CatePrdCls
									oItem.GetItemData arritem(lp)
							%>
							<li>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=74435'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=74435">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74435/m/img_thumbnail_<%= Format00(2, lp+1) %>.jpg" alt="" /></span>
									<div class="option">
									<% If lp = 0 Then %>
										<span class="name">Snow Dome &amp; Music box_Tree</span>
									<% ElseIf lp = 1 Then %>
										<span class="name">Christmas Mini Game</span>
									<% ElseIf lp = 2 Then %>
										<span class="name">Felt Christmas Mobile</span>
									<% ElseIf lp = 3 Then %>
										<span class="name">Christmas Object-House Tree</span>
									<% ElseIf lp = 4 Then %>
										<span class="name">Palm-sized Doll-Santa</span>
									<% ElseIf lp = 5 Then %>
										<span class="name">Snow Dome-SS</span>
									<% ElseIf lp = 6 Then %>
										<span class="name">Christmas Motif Tree-L</span>
									<% ElseIf lp = 7 Then %>
										<span class="name">Palm-sized Doll-Round</span>
									<% ElseIf lp = 8 Then %>
										<span class="name">Felt Ornament-Christmas</span>
									<% ElseIf lp = 9 Then %>
										<span class="name">Snow Gift Dome-M</span>
									<% ElseIf lp = 10 Then %>
										<span class="name">Christmas Card-Ornament</span>
									<% ElseIf lp = 11 Then %>
										<span class="name">Masking Tape-Ornament</span>
									<% End If %>

								<% If oItem.FResultCount > 0 Then %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> <i class="cRd1">[<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</i></span>
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
		<%'' //content area %>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
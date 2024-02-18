<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2016-12-13 유태욱 생성
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
	eCode   =  66251
Else
	eCode   =  74912
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.heySomething {padding-bottom:0;}
.get {padding-top:2.8rem;}
.get .discount {padding-bottom:1.2rem;}
.get .discount span {display:inline-block; height:1.8rem; padding:0 1.25rem; font-size:1.1rem; line-height:1.9rem; color:#fff; background:#d50c0c; border-radius:0.9rem;}
.get h2 {padding-bottom:0.5rem;}
.get .item ul {overflow:hidden; padding:0 4.68%;}
.get .item ul li {overflow:hidden; width:100%; padding:1.5rem 0; color:#777; text-align:left; border-top:1px solid #eee;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table; width:100%; padding-left:8%;}
.get .item ul li .thumbnail {display:table-cell; width:35%;}
.get .item ul li .option {display:table-cell; width:62%; padding-left:14%; color:#737373; vertical-align:middle;}
.get .item ul li .name {color:#000; font-size:1.4rem; line-height:1.8rem;}
.get .item ul li .price {margin-top:0.5rem; font-size:1.1rem; color:#8a8a8a;}
.get .item ul li .price strong {font-size:1.3rem; line-height:1.188em;}
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
					<%'' for dev msg : 12/14 ~ 12/20 까지만 노출 %>
					<% If Date()>= "2016-12-13" And Date < "2016-12-20" Then %>
						<p class="discount ct"><span>단, 일주일만 <strong>ONLY 15%</strong></span></p>
					<% end if %>
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/txt_buy.png" alt="스위트 몬스터 구매하기" /></h2>
					<div class="item">
						<ul class="with">
							<%
							Dim arritem, lp

							IF application("Svr_Info") = "Dev" THEN
								arritem = array(1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115,1239115)
							Else
								arritem = array(1618385,1618511,1618394,1618384,1618513,1618393,1618383,1617788,1618509,1618386,1618512,1617789,1618386,1618389,1618388,1618387,1618380,1618382,1618381,1617790)
							End If
							
							For lp = 0 To 19

							set oItem = new CatePrdCls
								oItem.GetItemData arritem(lp)
							%>
								<li>
								<% If isApp = 1 Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=74912'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=<%=arritem(lp)%>&amp;pEtr=74912">
								<% End If %>
										<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/74912/m/img_item_<%= Format00(2, lp+1) %>.png" alt="" /></span>
										<div class="option">
											<% If lp = 0 Then %>
												<b class="name">몬스터<br />밀크캔디 30정</b>
											<% ElseIf lp = 1 Then %>
												<b class="name">몬스터 젤펜<br />0.4</b>
											<% ElseIf lp = 2 Then %>
												<b class="name">몬스터<br />아이스크림 퍼프</b>
											<% ElseIf lp = 3 Then %>
												<b class="name">몬스터<br />밀크캔디 50정</b>
											<% ElseIf lp = 4 Then %>
												<b class="name">몬스터<br />핸디노트</b>
											<% ElseIf lp = 5 Then %>
												<b class="name">몬스터 밀키<br />에어퍼프 6종 세트</b>
											<% ElseIf lp = 6 Then %>
												<b class="name">몬스터<br />동전지갑</b>
											<% ElseIf lp = 7 Then %>
												<b class="name">몬스터<br />파우치 L</b>
											<% ElseIf lp = 8 Then %>
												<b class="name">몬스터 밀크<br />뮤직 토이</b>
											<% ElseIf lp = 9 Then %>
												<b class="name">몬스터<br />초코볼 50g</b>
											<% ElseIf lp = 10 Then %>
												<b class="name">몬스터<br />A4 홀더</b>
											<% ElseIf lp = 11 Then %>
												<b class="name">몬스터<br />파우치S</b>
											<% ElseIf lp = 12 Then %>
												<b class="name">몬스터<br />밀크캔디 10정</b>
											<% ElseIf lp = 13 Then %>
												<b class="name">몬스터 롱 틴 케이스<br />& 에어퍼프 세트</b>
											<% ElseIf lp = 14 Then %>
												<b class="name">몬스터 원형 틴케이스<br />& 에어퍼프 세트</b>
											<% ElseIf lp = 15 Then %>
												<b class="name">몬스터 밀키<br />에어퍼프</b>
											<% ElseIf lp = 16 Then %>
												<b class="name">몬스터<br />원형 틴 케이스</b>
											<% ElseIf lp = 17 Then %>
												<b class="name">몬스터<br />팝콘틴</b>
											<% ElseIf lp = 18 Then %>
												<b class="name">몬스터 롱<br />틴 케이스초코볼 50g</b>
											<% ElseIf lp = 19 Then %>
												<b class="name">몬스터<br />배터리 파우치</b>
											<% End If %>

											<% If oItem.FResultCount > 0 Then %>
												<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
													<div class="price">
														<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
														<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
													</div>
												<% Else %>
													<div class="price priceEnd">
														<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
													</div>
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
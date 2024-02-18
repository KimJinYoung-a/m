<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 49 item M&A
' History : 2016-09-27 이종화 생성
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
	eCode   =  66196
Else
	eCode   =  73236
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
Else
	itemid1   =  1569789
	itemid2   =  1569790
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get h2 {padding:3rem 0 0; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get h2 span {display:block; font-weight:normal;}
.get .item ul {overflow:hidden; margin-top:4%;}
.get .item ul li {overflow:hidden; width:100%; margin-top:6%; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:50%;}
.get .item ul li .option {display:table-cell; width:50%; vertical-align:middle;}
.get .item ul li .option .discount {margin-left:0.8rem;}
.get .item ul li .name {margin-left:1rem; color:#333; font-size:1.2rem;}
.get .option .name, .get .option .name span {margin-left:1rem;}
.get .item ul li .price {margin-top:1.1rem; margin-left:1rem;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.5rem;}

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
					<h2>TOMS x Kakao friends <span>콜라보레이션 상품 구매하기</span></h2>

					<div class="item">
						<%
							itemid = itemid1
							Set oItem = new CatePrdCls
								oItem.GetItemData itemid
								If oItem.FResultCount > 0 Then
						%>
						<ul>
							<li>
								<%' for dev msg : 상품코드 1569789 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569789&amp;pEtr=73236'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1569789&amp;pEtr=73236">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
										<strong class="discount">텐바이텐 단독 선오픈</strong>
										<b class="name">KAKAO PINK APEACH<br /> CLASSICS TINY</b>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
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
								<%' for dev msg : 상품코드 1569790 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1569790&amp;pEtr=73236'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1569790&amp;pEtr=73236">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73236/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<strong class="discount">텐바이텐 단독 선오픈</strong>
										<b class="name">KAKAO CHAMBRAY<br /> APEACH CLASSICS (W)</b>
										<div class="price">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									</div>
								</a>
							</li>
						</ul>
						<% 
								End If 
							Set oItem=nothing 
						%>
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
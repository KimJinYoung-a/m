<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈
' History : 2017-03-07 김진영 생성
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
	eCode   =  66287
Else
	eCode   =  76525
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.get h2 {padding-top:3rem; color:#333; font-size:1.7rem; font-weight:bold; line-height:1.313em; text-align:center;}
.get h2 span {display:block; font-weight:normal;}
.get .item ul {margin-top:2.5rem;}
.get .item ul li {overflow:hidden; width:100%; margin-top:3rem; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {margin-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:52%;}
.get .item ul li .option {display:table-cell; width:48%; vertical-align:middle;}
.get .item ul li .name {padding-right:1.2rem; color:#333; font-size:1.3rem; line-height:1.2em;}
.get .item ul li .price {margin-top:1.1rem;}
.get .item ul li .price s {font-size:1.2rem;}
.get .item ul li .price strong {margin-top:-0.1rem; font-size:1.6rem;}
.get .item ul li .option p {margin-top:1.8rem; color:#777; font-size:0.9rem; line-height:1.375em;}
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
					<h2>슈퍼스무디 시크릿 블랙<br /> 구매하기</h2>
					<div class="item">
						<ul>
							<li>
						<%
							Dim itemid
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1659068
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
							<%' for dev msg : 상품코드 1659068 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1659068&amp;pEtr=76525'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1659068&amp;pEtr=76525">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76525/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단, 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<b class="name">슈퍼스무디 시크릿 블랙 30gx14팩 + 쉐이커</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">슈퍼스무디 시크릿 블랙 30gx14팩 + 쉐이커</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End if %>
								<% End If %>
									</div>
								</a>
							</li>
							<li>
						<%
							IF application("Svr_Info") = "Dev" THEN
								itemid = 786868
							Else
								itemid = 1659069
							End If
							set oItem = new CatePrdCls
								oItem.GetItemData itemid
						%>
							<%' for dev msg : 상품코드 1659069 %>
							<% If isApp = 1 Then %>
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1659069&amp;pEtr=76525'); return false;">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1659069&amp;pEtr=76525">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/76525/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
								<% If oItem.FResultCount > 0 then %>
									<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
										<strong class="discount">단 일주일만 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
										<b class="name">슈퍼스무디 시크릿 블랙 3개월 패키지 + 체중계</b>
										<div class="price">
											<s><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% Else %>
										<b class="name">슈퍼스무디 시크릿 블랙 3개월 패키지 + 체중계</b>
										<div class="price priceEnd">
											<strong><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></strong>
										</div>
									<% End if %>
								<% End If %>
									</div>
								</a>
							</li>

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
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 34
' History : 2016-05-31 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	isApp	= getNumeric(requestCheckVar(request("isApp"),1))
	if isApp="" then isApp=0
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.get .item ul {overflow:hidden; padding:0 6.8%;}
.get .item ul li {float:left; width:50%; padding-bottom:2rem;}
.get .item ul li p {padding-top:0.5rem; text-align:center; font-size:1.2rem; color:#777; font-weight:600;}
<% if isApp=1 then %>
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

		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/tit_duckoo.png" alt="DUCKOO FIGURE,NOTE 구매하기" /></h2>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/txt_price.png" alt="" /></div>

					<!-- for dev msg : 상품 링크 및 가격 부분 개발해주세요 -->
					<div class="item">
						<ul>
							<% if isApp=1 then %>
								<li><a href="" onclick="fnAPPpopupProduct('1500617&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_01.png" alt="" /><p>35,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1500623&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_02.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1464413&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_03.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1500618&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_04.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1464414&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_05.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1500619&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_06.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1464415&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_07.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1500620&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_08.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1464416&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_09.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="" onclick="fnAPPpopupProduct('1500621&amp;pEtr=71009');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_10.png" alt="" /><p>18,000 won</p></a></li>
							<% else %>
								<li><a href="/category/category_itemPrd.asp?itemid=1500617&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_01.png" alt="" /><p>35,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1500623&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_02.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1464413&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_03.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1500618&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_04.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1464414&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_05.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1500619&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_06.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1464415&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_07.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1500620&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_08.png" alt="" /><p>18,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1464416&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_09.png" alt="" /><p>39,000 won</p></a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1500621&amp;pEtr=71009" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71009/m/img_thumb_10.png" alt="" /><p>18,000 won</p></a></li>
							<% end if %>
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
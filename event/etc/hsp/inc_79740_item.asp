<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 82 노리타케
' History : 2017-08-08 유태욱 생성
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
	eCode   =  66408
Else
	eCode   =  79740
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.popWin .content {padding-bottom:0;}
.get h2 {padding:4rem 0 0; color:#333; font-size:1.5rem; font-weight:bold; text-align:center;}
.get .item ul {overflow:hidden; padding:0 6.2%;}
.get .item ul li {float:left; width:50%;}
.get .item ul li:nth-child(2n) a{padding-right:1rem;}
.get .item ul li:nth-child(2n+1) a {padding-left:1rem;}
.get .item ul li a {display:block; width:100%; margin-top:1.5rem; text-align:center; font-size:1rem; color:#777;}
.get .item ul li span {display:block; padding-top:0.5rem;}
.get .item ul li strong {display:block; margin-bottom:0; padding:0.3rem 1rem 0.1rem; font-size:1rem;}
.get .item ul li.typical {overflow:hidden; width:100%; margin-bottom:1.8rem; border-bottom:1px solid #b2b2b2}
.get .item ul li.typical a {display:table; width:100%; margin-top:0;}
.get .item ul li.typical div {display:table-cell; width:50%; padding-bottom:.5rem; vertical-align:middle; text-align:left;}
.get .item ul li.typical div span {font-weight:bold; font-size:1.35rem; color:#000;}
.get .item ul li.typical div strong {padding-left:0; font-weight:bold; font-size:1.3rem; color:#000;}
.get .item ul li.typical div p {padding-top:1rem; font-size:0.85rem; line-height:1.5rem; color:#808080;}
.get .btnclose {top:15px; right:10px;}
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
					<h2>NORITAKE 구매하기</h2>

					<!-- for dev msg : 상품 링크 및 가격 부분 개발해주세요 -->
					<div class="item">
						<ul>
							<li class="typical">
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760616&amp;pEtr=79740'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1760616&pEtr=79740">
								<% End If %>
									<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_thumbnail_0.png" alt="REPEAT BOY" /></div>
									<div class="lPad1r">
										<!-- for dev msg : 상품코드 1760616 -->
										<span>REPEAT BOY</span>
										<strong>23,000won</strong>
										<p class="lh12">사이즈 : A5, 180 Page<br />
										재질 : 종이<br />
										MADE IN JAPAN</p>
									</div>
								</a>
							</li>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760615&amp;pEtr=79740'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1760615&pEtr=79740">
								<% End If %>
									<!-- for dev msg : 상품코드 1760615 -->
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_thumbnail_1.png" alt="OPEN EYES TOTE BAG" />
									<span>OPEN EYES TOTE BAG</span>
									<strong>36,800won</strong>
								</a>
							</li>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760618&amp;pEtr=79740'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1760618&pEtr=79740">
								<% End If %>
									<!-- for dev msg : 상품코드 1760618 -->
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_thumbnail_2.png" alt="RAIN NOTE BOOK" />
									<span>RAIN NOTE BOOK</span>
									<strong>18,800won</strong>
								</a>
							</li>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760616&amp;pEtr=79740'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1760616&pEtr=79740">
								<% End If %>
									<!-- for dev msg : 상품코드 1760616 -->
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_thumbnail_3.png" alt="REPEAT BOY BOOK" />
									<span>REPEAT BOY BOOK</span>
									<strong>23,000won</strong>
								</a>
							</li>
							<li>
								<% If isapp="1" Then %>
									<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1760617&amp;pEtr=79740'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1760617&pEtr=79740">
								<% End If %>
									<!-- for dev msg : 상품코드 1760617 -->
									<img src="http://webimage.10x10.co.kr/eventIMG/2017/hey/79740/m/img_thumbnail_4.png" alt="GROWN PEN" />
									<span>GROWN PEN</span>
									<strong>4,300won</strong>
								</a>
							</li>
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
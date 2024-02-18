<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 38 MA item
' History : 2016-06-28 김진영 생성
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
	
If isApp="" then isApp=0

Dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66161
Else
	eCode   =  71459
End If

dim itemid, itemid1, itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid1   =  1239115
	itemid2   =  1239227
	itemid3   =  1239227
	itemid4   =  1239227
	itemid5   =  1239227
	itemid6   =  1239227
Else
	itemid1   =  1516362
	itemid2   =  1509356
	itemid3   =  1507612
	itemid4   =  1507611
	itemid5   =  1507610
	itemid6   =  1507606
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.get h2 {padding:3rem 0 1.5rem; color:#333; font-size:1.5rem; font-weight:bold; text-align:center;}
.get .item ul {overflow:hidden; padding:0 0.9rem;}
.get .item ul li {overflow:hidden; width:100%; padding:0.8rem 0; border-top:1px solid #eee; color:#777; font-size:1rem; text-align:left;}
.get .item ul li:first-child {border-top:0;}
.get .item ul li a {display:table;}
.get .item ul li .thumbnail {display:table-cell; width:44.8%;}
.get .item ul li .option {display:table-cell; width:55.2%; vertical-align:middle;}
.get .item ul li .option {color:#737373; line-height:0.813em;}
.get .item ul li .price {margin:0.3rem 0 0 3rem; font-weight:bold;}
.get .item ul li .price strong {margin-top:0.5rem; font-size:1.3rem; line-height:1.188em;}
.get .item ul li .name {margin:1.3rem 0 0 3rem; color:#000; font-size:1.3rem; line-height:1.188em; letter-spacing:-0.05rem;}

.get .btnclose {top:15px; right:10px;}

<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
</head>
<body class="">
<div class="heightGrid">
	<div class="container popWin">
		<% If isApp=1 Then %>
		<% Else %>
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
					<h2>THE JUNGLE BOOK 구매하기</h2>
					<%' for dev msg : 디즈니 상품은 할인 없이 진행합니다. %>
					<div class="item">
						<ul>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523840&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523840&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_01.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Flat Multi Pouch</b>
										<div class="price">
											<strong>18,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523844&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523844&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_02.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Basic Pouch S</b>
										<div class="price">
											<strong>15,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523839&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523839&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_03.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Make Up Pouch</b>
										<div class="price">
											<strong>16,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523843&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523843&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_04.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Basic Pouch L</b>
										<div class="price">
											<strong>18,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523838&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523838&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_05.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Sleep Mask</b>
										<div class="price">
											<strong>22,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523841&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523841&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_06.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Toiletry</b>
										<div class="price">
											<strong>35,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523833&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523833&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_07.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Beach Towel</b>
										<div class="price">
											<strong>37,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523842&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523842&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_08.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Snack Bag</b>
										<div class="price">
											<strong>35,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523836&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1523836&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_09.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Stand</b>
										<div class="price">
											<strong>68,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1520149&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1520149&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_10.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Rug medium</b>
										<div class="price">
											<strong>22,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1520151&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1520151&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_11.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Rug Large</b>
										<div class="price">
											<strong>32,000won</strong>
										</div>
									</div>
								</a>
							</li>
							<li>
							<% If isApp=1 Then %>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1526096&amp;pEtr=71684">
							<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1526096&amp;pEtr=71684" target="_blank">
							<% End If %>
									<span class="thumbnail"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/71684/m/img_thumbnail_12.jpg" alt="" /></span>
									<div class="option">
										<b class="name">Tropical Mat</b>
										<div class="price">
											<strong>45,000won</strong>
										</div>
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
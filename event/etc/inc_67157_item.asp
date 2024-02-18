<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 9
' History : 2015.10.27 원승현 생성
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
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  65941
Else
	eCode   =  67157
End If

dim userid, i
	userid = GetEncLoginUserID()

dim itemid
IF application("Svr_Info") = "Dev" THEN
	itemid   =  1239115
Else
	itemid   =  1378164
End If

dim oItem
set oItem = new CatePrdCls
	oItem.GetItemData itemid

dim itemid2, itemid3, itemid4, itemid5, itemid6
IF application("Svr_Info") = "Dev" THEN
	itemid2   =  1239115
	itemid3   =  1239115
	itemid4   =  1239115
	itemid5	  =  1239115
	itemid6	  =  1239115
Else
	itemid2   =  1378143
	itemid3   =  1378234
	itemid4   =  1378228
	itemid5	  =  1378208
	itemid6	  =  1378199
End If
   
dim oItem2
set oItem2 = new CatePrdCls
	oItem2.GetItemData itemid2

dim oItem3
set oItem3 = new CatePrdCls
	oItem3.GetItemData itemid3

dim oItem4
set oItem4 = new CatePrdCls
	oItem4.GetItemData itemid4

dim oItem5
set oItem5 = new CatePrdCls
	oItem5.GetItemData itemid5

dim oItem6
set oItem6 = new CatePrdCls
	oItem6.GetItemData itemid6


	isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.get .big {position:relative;}
.get .link {display:block;}
.get .option {text-align:center; padding-bottom:5%;}
.get .option .price, .get .option .name {margin-left:10px;}
.get .option .price {margin-top:0;}
.get .option .name {margin-top:13px;}
.get .item ul {overflow:hidden; padding:0 1%;}
.get .item ul li {float:left; width:50%; margin-bottom:4%; padding:0 4%; color:#777; font-size:12px; text-align:center;}
.get .item ul li:nth-child(5), .get .item ul li:nth-child(6) {margin-bottom:0;}
.get .item ul li a {display:block;}
.get .item ul li span {overflow:hidden; display:block; margin-top:5px; text-overflow:ellipsis; white-space:nowrap;}
.get .item ul li .price {font-weight:bold; margin-top:3px;}
.get .btnclose {top:15px; right:10px;}

@media all and (min-width:480px){
	.get .item ul li {font-size:16px;}
	.get .item ul li span {margin-top:7px;}
	.get .item ul li .price {margin-top:6px;}
}

/* 앱일 경우에만 해당 css 불러와 주세요 */
<% if isApp="1" then %>
/*.popWin .content {padding-top:0;}*/
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

		<%' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/txt_buy.png" alt="미러리스 카메라 클러치백 구매하기" /></p>
					<div class="big">
						<div class="option">
							<% 
								'for dev msg : 할인 종료 후 <strong class="discount">....</strong>숨겨 주시고 
								'<div class="price">...</div>에는 클래스 priceEnd을 붙이고 <del>....<del>숨겨주세요 
							%>
							<% if oItem.FResultCount > 0 then %>
								<% IF (oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0) THEN %>
									<% If oItem.Prd.FOrgprice = 0 Then %>
									<% else %>
										<strong class="discount">텐바이텐 ONLY <%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%</strong>
									<% End If %>
								<% End If %>
							<% End If %>
						</div>
					</div>

					<%' for dev msg : 상품 링크 걸어주세요 %>
					<div class="item">
						<ul>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378164'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378164">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_01.jpg" alt="" />
									<span class="color">클러치백_MATE</span>
									<span class="price"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378143'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378143">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_02.jpg" alt="" />
									<span class="color">클러치백_EVERYONE ENJOY!</span>
									<span class="price"><%= FormatNumber(oItem2.Prd.FSellCash,0) & chkIIF(oItem2.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378234'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378234">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_03.jpg" alt="" />
									<span class="color">속사케이스_MATE</span>
									<span class="price"><%= FormatNumber(oItem3.Prd.FSellCash,0) & chkIIF(oItem3.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378228'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378228">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_04.jpg" alt="" />
									<span class="color">속사케이스_EVERYONE ENJOY!</span>
									<span class="price"><%= FormatNumber(oItem4.Prd.FSellCash,0) & chkIIF(oItem4.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378208'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378208">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_05.jpg" alt="" />
									<span class="color">넥스트랩_MATE</span>
									<span class="price"><%= FormatNumber(oItem5.Prd.FSellCash,0) & chkIIF(oItem5.Prd.IsMileShopitem,"Point","won") %></span>
								</a>
							</li>
							<li>
								<% If isApp Then %>
									<a href="" onclick="fnAPPpopupProduct('1378199'); return false;">							
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1378199">
								<% End If %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/67157/m/img_thumb_06.jpg" alt="" />
									<span class="color">넥스트랩_EVERYONE ENJOY!</span>
									<span class="price"><%= FormatNumber(oItem6.Prd.FSellCash,0) & chkIIF(oItem6.Prd.IsMileShopitem,"Point","won") %></span>
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

<%
set oItem=nothing
set oItem2=nothing
set oItem3=Nothing
set oItem4=Nothing
set oItem5=Nothing
set oItem6=Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
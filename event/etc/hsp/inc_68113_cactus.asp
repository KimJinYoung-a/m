<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 16
' History : 2015-12-22 원승현 생성
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
	eCode   =  65993
Else
	eCode   =  68133
End If

dim userid, i
	userid = GetEncLoginUserID()

isApp	= requestCheckVar(request("isApp"),1)

if isApp="" then isApp=0

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.get #app {display:none;}
.get .item {position:relative;}
.get .item ul {overflow:hidden; position:absolute; top:63%; left:50%; width:80%; margin-left:-40%;}
.get .item ul li {position:relative; margin-bottom:1%;}
.get .item ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:13%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.get .item ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

/* 앱일 경우에만 해당 css 불러와 주세요 */
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

		<%' content area %>
		<div class="content" id="contentArea">
			<div class="heySomething">
				<div class="get">
					<div class="item">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/hey/68133/m/img_get_cactus.jpg" alt="WOOUF Laptop Banana 구매하기" /></p>
						<%' for dev msg : 상품 링크 %>
						<ul>
							<li>
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct('1403589'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403589&amp;pEtr=68133">
								<% End If %>
									<span></span>Laptop 13인치
								</a>
							</li>
							<li>
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct('1403588'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1403588&amp;pEtr=68133">
								<% End If %>
									<span></span>Laptop 11인치
								</a>
							</li>
							<li>
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct('1385744'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1385744&amp;pEtr=68133">
								<% End If %>
									<span></span>iPad
								</a>
							</li>
							<li>
								<% If isApp="1" Then %>
									<a href="" onclick="fnAPPpopupProduct('1385761'); return false;">
								<% Else %>
									<a href="/category/category_itemPrd.asp?itemid=1385761&amp;pEtr=68133">
								<% End If %>
									<span></span>iPad Mini
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
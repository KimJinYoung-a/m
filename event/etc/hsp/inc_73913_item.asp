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
	eCode   =  66230
Else
	eCode   =  73913
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}

.heySomething {padding-bottom:0;}
.heySomething ul li {margin-top:1.8%;}
.heySomething ul li:first-child {margin-top:0;}
/* 앱일 경우에만 해당 css 불러와 주세요 */
<% if isApp=1 then %>
.popWin .content {padding-top:0;}
<% end if %>
</style>
<script type="text/javascript">
// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
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
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/tit_tehtava.png" alt="테스타바 플러스" /></p>
			<div class="heySomething">
				<ul>
					<li><a href="" onclick="goEventLink('74091&eGc=192662');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_01.jpg" alt="Reversible Room Socks 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
					<li><a href="" onclick="goEventLink('74091&eGc=192663');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_02.jpg" alt="Touch Screen Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
					<li><a href="" onclick="goEventLink('74091&eGc=192664');return false;" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/hey/73913/m/img_slide_05_03.jpg" alt="Knit Gloves 더 보러 가기 2017 Tehtava+ 신상출시 기획전으로 이동" /></a></li>
				</ul>
			</div>

		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
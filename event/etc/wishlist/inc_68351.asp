<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  아임 유어 텐바이텐
' History : 2015.12.24 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68351 {background-color:#fef9db;}
.postcard {overflow:hidden; padding:0 4.2%;}
.postcard li {float:left; width:50%; padding:0 2.5% 1.8rem;}
.tenDelivery {display:block; width:54.6%; margin:0 auto;}
.bnr01 {padding-top:2.8rem;}
.bnr02 {padding-top:2.1rem;}
.bnr03 {padding-top:3rem;}
</style>
</head>
<body>

<!-- 아임 유어 텐바이텐 #2 -->
<div class="mEvt68351">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/tit_your_tenten.png" alt="아임유어텐바이텐" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/tit_banana.png" alt="02.아임유어바나나" /></h3>
	<ul class="postcard">
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/img_card_01.png" alt="엽서 이미지" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/img_card_02.png" alt="엽서 이미지" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/img_card_03.png" alt="엽서 이미지" /></li>
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/img_card_04.png" alt="엽서 이미지" /></li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/txt_get.png" alt="받는 방법 : 12월 28일 (월) 부터 텐바이텐 배송 상품을 포함해서 쇼핑하신 모든 분에게! ( 단, 한정수량으로 조기조진 될 수 있습니다.)" /></p>

	<% if isApp=1 then %>
		<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=66572'); return false;" class="tenDelivery">
	<% else %>
		<a href="/event/eventmain.asp?eventid=66572" target="_blank" class="tenDelivery">
	<% end if %>

	<img src="http://webimage.10x10.co.kr/eventIMG/2015/68351/m/btn_ten_deliver.png" alt="텐바이텐 배송상품 보러가기" /></a>
	<div class="bnr01">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68315'); return false;">
		<% else %>
			<a href="/event/eventmain.asp?eventid=68315" target="_blank">
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_wish.png" alt="2016년의 첫 행운을 텐바이텐에서 - 소원수리 대작전" /></a>
	</div>
	<div class="bnr02">
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68352'); return false;">
		<% else %>
			<a href="/event/eventmain.asp?eventid=68352" target="_blank">
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_screen.png" alt="스마트폰도 해피 뉴 이어! 새 마음 새 옷으로" /></a>
	</div>

	<% '<!-- for dev msg : 모바일웹일 경우에만 보여주세요 --> %>
	<% if not(isApp=1) then %>
		<div class="bnr03">
			<a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_app_download.png" alt="텐바이텐 APP 다운 받고 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a>
		</div>
	<% end if %>

</div>
<!--// 아임 유어 텐바이텐 #2 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
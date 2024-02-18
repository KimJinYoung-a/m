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
.mEvt68352 {background-color:#fef9db;}
.screen {overflow:hidden; padding:0 4.2%;}
.screen li {float:left; width:50%; padding:0 2.5% 2.6rem;}
.screen li .download {overflow:hidden;}
.screen li .download a {display:block; float:left; width:33.33333%; padding:0 3%;}
.tenDelivery {display:block; width:54.6%; margin:0 auto;}
.bnr01 {padding-top:1rem;}
.bnr02 {padding-top:2.1rem;}
.bnr03 {padding-top:3rem;}
</style>
</head>
<body>

<!-- 아임 유어 텐바이텐 #3 -->
<div class="mEvt68352">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/tit_your_tenten.png" alt="아임유어텐바이텐" /></h2>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/tit_new.png" alt="03.새 마음 새 옷으로" /></h3>
	<ul class="screen">
		<li>
			<div><a href="" onclick="fileDownload('3624'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/img_screen_01.png" alt="" /></a></div>
			<div class="download">
				<a href="" onclick="fileDownload('3622'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_01.png" alt="갤럭시" /></a>
				<a href="" onclick="fileDownload('3623'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_02.png" alt="아이폰" /></a>
				<a href="" onclick="fileDownload('3624'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_03.png" alt="아이폰+" /></a>
			</div>
		</li>
		<li>
			<div><a href="" onclick="fileDownload('3627'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/img_screen_02.png" alt="" /></a></div>
			<div class="download">
				<a href="" onclick="fileDownload('3625'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_01.png" alt="갤럭시" /></a>
				<a href="" onclick="fileDownload('3626'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_02.png" alt="아이폰" /></a>
				<a href="" onclick="fileDownload('3627'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_03.png" alt="아이폰+" /></a>
			</div>
		</li>
		<li>
			<div><a href="" onclick="fileDownload('3630'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/img_screen_03.png" alt="" /></a></div>
			<div class="download">
				<a href="" onclick="fileDownload('3628'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_01.png" alt="갤럭시" /></a>
				<a href="" onclick="fileDownload('3629'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_02.png" alt="아이폰" /></a>
				<a href="" onclick="fileDownload('3630'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_03.png" alt="아이폰+" /></a>
			</div>
		</li>
		<li>
			<div><a href="" onclick="fileDownload('3633'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/img_screen_04.png" alt="" /></a></div>
			<div class="download">
				<a href="" onclick="fileDownload('3631'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_01.png" alt="갤럭시" /></a>
				<a href="" onclick="fileDownload('3632'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_02.png" alt="아이폰" /></a>
				<a href="" onclick="fileDownload('3633'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68352/m/btn_download_03.png" alt="아이폰+" /></a>
			</div>
		</li>
	</ul>

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
			<a href="" onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=68351'); return false;">
		<% else %>
			<a href="/event/eventmain.asp?eventid=68351" target="_blank">
		<% end if %>

		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_postcard.png" alt="당신의 원숭이 해가 더 행복하도록 - 아임 유어 바나나" /></a>
	</div>

	<% '<!-- for dev msg : 모바일웹일 경우에만 보여주세요 --> %>
	<% if not(isApp=1) then %>
		<div class="bnr03">
			<a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68315/m/bnr_app_download.png" alt="텐바이텐 APP 다운 받고 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a>
		</div>
	<% end if %>

</div>
<!--// 아임 유어 텐바이텐 #3 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
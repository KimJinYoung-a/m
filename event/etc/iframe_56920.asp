<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트(NORDIC CHRISTMAS 메인페이지)M
' History : 2014.11.27 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<style type="text/css">
.xmasMain .styling {padding:8% 3% 5%;}
.xmasMain .styling ul li {margin-top:5%;}
.xmasMain .etc {margin:0 3%; padding-top:5%; padding-bottom:3%; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.png) repeat-x 0 0; background-size:1px 1px;}
.xmasMain .etc ul {overflow:hidden;}
.xmasMain .etc ul li {float:left; width:50%;}
.xmasMain .etc ul li a {display:block; padding:0 3%}
.xmasMain .etc ul li:nth-child(1) a {padding-left:0.5%;}
.xmasMain .etc ul li:nth-child(2) a {padding-right:0.5%;}
</style>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">
	<!-- CHRISTMAS MAIN -->
	<% if isApp=1 then %>
		<div class="xmasMain">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_nordic_christmas.gif" alt="북유럽 크리스마스 마을에서 특별한 선물을 보내드려요 이벤트 기간은 2014년 12월 1일부터 12월 23일까지입니다." /></p>
			<div class="bnr"><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21384" ELSE response.write "56926" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_special.jpg" alt="IT&apos;S SPECIAL - 크리스마스 스페셜 에디션" /></a></div>

			<div class="styling">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_nordic_home_styling.gif" alt="노르딕 홈스타일링 공간에 숨겨진 크리스마스 선물을 찾아보세요!" /></h3>
				<ul>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21380" ELSE response.write "56921" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_life.jpg" alt="북유럽 거실 만들기" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21381" ELSE response.write "56922" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_night.jpg" alt="침대 옆 크리스마스" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21382" ELSE response.write "56923" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_table.jpg" alt="크리스마스 디너 테이블" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21383" ELSE response.write "56925" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_village.jpg" alt="크리스마스 키즈룸" /></a></li>
				</ul>
			</div>

			<div class="etc">
				<ul>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21385" ELSE response.write "56927" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_message.gif" alt="크리스마스 카드 보내고 선물받기 참여" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_benefit.gif" alt="텐바이텐이 준비한 크리스마스 혜택" /></a></li>
				</ul>
			</div>

			<!-- EVENT & ISSUE -->
			<div class="inner5">
				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span></h2>
					<ul class="list01">
						<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=57001'); return false;">크리스마스 데코 쉽고 간단해요!</a></li>
						<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=56874'); return false;">3가지 크리스마스 스타일을 만나보세요</a></li>
						<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=57066'); return false;">1만원으로 끝내는 크리스마스 준비</a></li>
					</ul>
				</div>
			</div>
			<!--// EVENT & ISSUE -->

		</div>
	<% else %>
		<div class="xmasMain">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_nordic_christmas.gif" alt="북유럽 크리스마스 마을에서 특별한 선물을 보내드려요 이벤트 기간은 2014년 12월 1일부터 12월 23일까지입니다." /></p>
			<div class="bnr"><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21384" ELSE response.write "56926" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_special.jpg" alt="IT&apos;S SPECIAL - 크리스마스 스페셜 에디션" /></a></div>

			<div class="styling">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_nordic_home_styling.gif" alt="노르딕 홈스타일링 공간에 숨겨진 크리스마스 선물을 찾아보세요!" /></h3>
				<ul>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21380" ELSE response.write "56921" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_life.jpg" alt="북유럽 거실 만들기" /></a></li>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21381" ELSE response.write "56922" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_night.jpg" alt="침대 옆 크리스마스" /></a></li>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21382" ELSE response.write "56923" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_table.jpg" alt="크리스마스 디너 테이블" /></a></li>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21383" ELSE response.write "56925" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_village.jpg" alt="크리스마스 키즈룸" /></a></li>
				</ul>
			</div>

			<div class="etc">
				<ul>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21385" ELSE response.write "56927" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_message.gif" alt="크리스마스 카드 보내고 선물받기 참여" /></a></li>
					<li><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_bnr_main_benefit.gif" alt="텐바이텐이 준비한 크리스마스 혜택" /></a></li>
				</ul>
			</div>

			<!-- EVENT & ISSUE -->
			<div class="inner5">
				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span></h2>
					<ul class="list01">
						<li><a href="/event/eventmain.asp?eventid=57001">크리스마스 데코 쉽고 간단해요!</a></li>
						<li><a href="/event/eventmain.asp?eventid=56874">3가지 크리스마스 스타일을 만나보세요</a></li>
						<li><a href="/event/eventmain.asp?eventid=57066">1만원으로 끝내는 크리스마스 준비</a></li>
					</ul>
				</div>
			</div>
			<!--// EVENT & ISSUE -->

		</div>
	<% end if %>
	<!--// CHRISTMAS MAIN -->
</div>
<!--// 이벤트 배너 등록 영역 -->
<div class="mask"></div>
</body>
</html>
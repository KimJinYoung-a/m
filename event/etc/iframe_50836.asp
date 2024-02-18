<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  ★★★ 텐바이텐 위시 APP 런칭이벤트 2차,어머, 이건 담아야해!(M전용)
' History : 2014.04.15 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event50836Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim cEvent, eCode, ename, emimg
	eCode=getevt_code
dim currenttime
	currenttime = Now()
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 앱 위시 론칭2차</title>
<style type="text/css">
.mEvt50838 {position:relative;}
.mEvt50838 p {max-width:100%;}
.mEvt50838 img {vertical-align:top; width:100%;}
.mEvt50838 .time {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_time_bg.png) center top no-repeat; background-size:100%; padding-bottom:20px;}
.mEvt50838 .time > div {width:296px; height:39px; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_time.png) center top no-repeat; background-size:296px 39px;}
.mEvt50838 .time > div > p {padding-left:50%;}
.mEvt50838 .time > div > p span {display:inline-block; color:#fff; font-weight:bold; letter-spacing:0.7em; padding:12px 30px 0 3px;}
.mEvt50838 .todayList {overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_pdt_bg.png) center top repeat-y; background-size:100%; padding:0 1em 1em 1em;}
.mEvt50838 .todayList ul {overflow:hidden; border-top:2px solid #ccc; border-bottom:2px solid #ccc; padding:1em 0;}
.mEvt50838 .todayList li {width:33.33333%; float:left; padding:10px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; text-align:center; font-size:13px;}
@media all and (min-width:480px){
	.mEvt50838 .time {padding:20px 0 24px 0;}
	.mEvt50838 .time > div {width:444px; height:59px; background-size:444px 59px;}
	.mEvt50838 .time > div > p {font-size:28px;}
	.mEvt50838 .time > div > p span {letter-spacing:0.5em; padding:16px 44px 0 5px;}
}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
	var today=new Date(<%=Year(currenttime)%>, <%=Month(currenttime)-1%>, <%=Day(currenttime)%>, <%=Hour(currenttime)%>, <%=Minute(currenttime)%>, <%=Second(currenttime)%>);
	var minus_second = 0;

//남은시간 카운트
function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getFullYear() 
	var todaym=today.getMonth()
	var todayd=today.getDate()
	var todayh=today.getHours()
	var todaymin=today.getMinutes()
	var todaysec=today.getSeconds()

	var dateA = new Date(todayy,todaym,todayd,todayh,todaymin,todaysec);
	var dateB = new Date(todayy,todaym,todayd,17,00,00 );

	var ss  = Math.floor(dateB.getTime() - dateA.getTime() ) / 1000;
	var mm  = Math.floor(ss / 60);
	var hh  = Math.floor(mm / 60);
	var day    = Math.floor(hh / 24);
	
	var diff_hour   = Math.floor(hh % 24);
	var diff_minute = Math.floor(mm % 60);
	var diff_second = Math.floor(ss % 60);
	
	if (diff_hour<10){
		diff_hour="0"+diff_hour
	}
	if (diff_minute<10){
		diff_minute="0"+diff_minute
	}		
	//alert( todayh );
	if (todayh>=14 && todayh<17){
		$("#lyrCounter").html("<span>"+diff_hour+"</span><span>"+diff_minute+"</span>");
	}else{
		$("#lyrCounter").html("<span>00</span><span>00</span>");
	}

	minus_second = minus_second + 1;

	setTimeout("countdown()",1000)		
}

	$(function() {
		countdown();
	});

function kakaosendcall(){
	kakaosend50838();
}

function kakaosend50838(){
	var url =  "http://bit.ly/1gcRbhO";
	kakao.link("talk").send({
		msg : "오늘 WISH하면 내일 선물이?!\n어머, 이건 담아야 해!\n매일 새롭게 등장하는 행운의 선물을 위시하세요!",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "어머, 이건 담아야 해!",
		type : "link"
	});
}

</script>

</head>
<body>
	<!-- 텐바이텐 앱 위시 론칭2차 -->
	<div class="mEvt50838">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_tit.png" alt="어머, 이건 담아야해!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt1.png" alt="매일 새롭게 등장하는 행운의 선물을 위시하세요!" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt2_m.png" alt="이벤트 기간 및 당첨자 발표" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt3_m.png" alt="이벤트 참여 방법" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_img1.png" alt="이벤트 참여 방법 1 - 2" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_img2.png" alt="이벤트 참여 방법 3 - 4" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt3.png" alt="매일 오후 2시부터 5시까지" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt4.png" alt="TODAY WISH" /></p>
		<div class="todayList">
			<!-- 05.12 -->
			<% if currenttime >= #04/11/2014 00:00:00# and currenttime < #05/13/2014 00:00:00# then %>
				<ul class="today0415">
					<li><a href="" onclick="TnGotoProduct(963898);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_01.png" alt="라메카 빈티지 여행가방" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1014574);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_02.png" alt="United Pouch - Laptop" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1005758);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_03.png" alt="누드루미네상스 스탠딩조명" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1007042);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_04.png" alt="니콘 쿨픽스 P330" /></a></li>
					<li><a href="" onclick="TnGotoProduct(979160);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_05.png" alt="소니 3세대 헤드마운트 디스플레이 HMZ-T3" /></a></li>
					<li><a href="" onclick="TnGotoProduct(830847);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0415_06.png" alt="Lamy Safari 만년필" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.12 -->

			<!-- 05.13 -->
			<% if currenttime >= #05/13/2014 00:00:00# and currenttime < #05/14/2014 00:00:00# then %>
				<ul class="today0416">
					<li><a href="" onclick="TnGotoProduct(866102);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_01.png" alt="Wrapping Ball - Pink/Blue/White" /></a></li>
					<li><a href="" onclick="TnGotoProduct(873357);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_02.png" alt="LG 포토프린터 포켓포토 포포" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1011775);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_03.png" alt="셀리 스툴" /></a></li>
					<li><a href="" onclick="TnGotoProduct(990809);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_04.png" alt="북두칠성 귀걸이" /></a></li>
					<li><a href="" onclick="TnGotoProduct(884070);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_05.png" alt="[Mr.Maria] anana lamp" /></a></li>
					<li><a href="" onclick="TnGotoProduct(930730);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0416_06.png" alt="basic notebook pouch 13" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.13 -->

			<!-- 05.14 -->
			<% if currenttime >= #05/14/2014 00:00:00# and currenttime < #05/15/2014 00:00:00# then %>
				<ul class="today0417">
					<li><a href="" onclick="TnGotoProduct(679375);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_01.png" alt="enjoy check picnicmat" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1012187);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_02.png" alt="m.Humming NEO BAG" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1003632);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_03.png" alt="Manicure scissors - Seaflower" /></a></li>
					<li><a href="" onclick="TnGotoProduct(995544);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_04.png" alt="1 MAN TENT - ORANGE" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1005577);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_05.png" alt="다이슨 진공 핸드형 청소기" /></a></li>
					<li><a href="" onclick="TnGotoProduct(944301);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0417_06.png" alt="IRON MAN3 HAND" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.14 -->

			<!-- 05.15 -->
			<% if currenttime >= #05/15/2014 00:00:00# and currenttime < #05/16/2014 00:00:00# then %>
				<ul class="today0418">
					<li><a href="" onclick="TnGotoProduct(364400);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_01.png" alt="RAIN PARADE(우산)" /></a></li>
					<li><a href="" onclick="TnGotoProduct(931088);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_02.png" alt="밀크 테이블 스탠드" /></a></li>
					<li><a href="" onclick="TnGotoProduct(808666);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_03.png" alt="15inch Cabaret Pink" /></a></li>
					<li><a href="" onclick="TnGotoProduct(963413);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_04.png" alt="필립스 세코 반자동 커피머신 HD8325와 엔코 커피그라인더 세트" /></a></li>
					<li><a href="" onclick="TnGotoProduct(924864);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_05.png" alt="클래식 로드바이크" /></a></li>
					<li><a href="" onclick="TnGotoProduct(884073);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0418_06.png" alt="[Mr.Maria] Miffy lamp S" /></a></li>
				<% end if %>
				</ul>
			<!-- //05.15 -->

			<!-- 05.16~05.18 -->
			<% if currenttime >= #05/16/2014 00:00:00# and currenttime < #05/19/2014 00:00:00# then %>
				<ul class="today0421">
					<li><a href="" onclick="TnGotoProduct(830110);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_01.png" alt="[Aromaco] 티라이트 50P" /></a></li>
					<li><a href="" onclick="TnGotoProduct(946234);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_02.png" alt="쿠펠 우유가열기" /></a></li>
					<li><a href="" onclick="TnGotoProduct(772444);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_03.png" alt="sticky monster lab" /></a></li>
					<li><a href="" onclick="TnGotoProduct(931895);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_04.png" alt="알톤 피규어" /></a></li>
					<li><a href="" onclick="TnGotoProduct(816426);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_05.png" alt="[바이빔]비트 장 스탠드-에쉬" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1010223);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0421_06.png" alt="소니 A5000" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.16~05.18 -->

			<!-- 05.19 -->
			<% if currenttime >= #05/19/2014 00:00:00# and currenttime < #05/20/2014 00:00:00# then %>
				<ul class="today0422">
					<li><a href="" onclick="TnGotoProduct(827212);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_01.png" alt="아이코닉 스마트 사이드백" /></a></li>
					<li><a href="" onclick="TnGotoProduct(850794);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_02.png" alt="ALLEN SUNGLASSES - BLACK" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1030043);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_03.png" alt="[심슨]룰드 노트북/옐로우 하드 L" /></a></li>
					<li><a href="" onclick="TnGotoProduct(514766);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_04.png" alt="로즈워터 오 데 뚜왈렛" /></a></li>
					<li><!-- a href="" onclick="TnGotoProduct(979160);return false;" --><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_05.png" alt="텐바이텐 5만원 기프트카드" /><!--/a--></li>
					<li><a href="" onclick="TnGotoProduct(1021823);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0422_06.png" alt="티키타카 20_네온" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.19 -->

			<!-- 05.20 -->
			<% if currenttime >= #05/20/2014 00:00:00# and currenttime < #05/21/2014 00:00:00# then %>
				<ul class="today0423">
					<li><a href="" onclick="TnGotoProduct(949487);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_01.png" alt="[슈퍼잼] 무설탕 천연과일잼" /></a></li>
					<li><a href="" onclick="TnGotoProduct(307349);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_02.png" alt="Kaffe duo 커피메이커" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1020719);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_03.png" alt="SECOND BAG_INNER BAG" /></a></li>
					<li><a href="" onclick="TnGotoProduct(381047);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_04.png" alt="[젠하이저코리아 정품] PX200Ⅱ화이트" /></a></li>
					<li><a href="" onclick="TnGotoProduct(759831);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_05.png" alt="코지 리클라이닝 소파베드" /></a></li>
					<li><a href="" onclick="TnGotoProduct(990722);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0423_06.png" alt="[필드캔디] 리틀캠퍼 우주선" /></a></li>
				</ul>
			<% end if %>							
			<!-- //05.20 -->

			<!-- 05.21 -->
			<% if currenttime >= #05/21/2014 00:00:00# and currenttime < #05/22/2014 00:00:00# then %>
				<ul class="today0424">
					<li><a href="" onclick="TnGotoProduct(855317);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_01.png" alt="FOUR SEASONS" /></a></li>
					<li><a href="" onclick="TnGotoProduct(679209);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_02.png" alt="Bella Flora 장우산" /></a></li>
					<li><a href="" onclick="TnGotoProduct(655381);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_03.png" alt="C-탑 로딩 팩 블루/오렌지" /></a></li>
					<li><a href="" onclick="TnGotoProduct(987255);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_04.png" alt="필립스 아이폰5 도킹스피커" /></a></li>
					<li><a href="" onclick="TnGotoProduct(964441);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_05.png" alt="조본업 밴드" /></a></li>
					<li><a href="" onclick="TnGotoProduct(924888);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0424_06.png" alt="JIKE CLASSIC" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.21 -->

			<!-- 05.22 -->
			<% if currenttime >= #05/22/2014 00:00:00# and currenttime < #05/23/2014 00:00:00# then %>
				<ul class="today0425">
					<li><a href="" onclick="TnGotoProduct(540407);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_01.png" alt="WEEKADE Riding Bag" /></a></li>
					<li><a href="" onclick="TnGotoProduct(588234);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_02.png" alt="BRISEZ LA GLACE(망치)" /></a></li>
					<li><a href="" onclick="TnGotoProduct(841576);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_03.png" alt="Boxer(복서) 2596번" /></a></li>
					<li><a href="" onclick="TnGotoProduct(894718);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_04.png" alt="ED-1" /></a></li>
					<li><a href="" onclick="TnGotoProduct(920191);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_05.png" alt="스널커 Astronaut_Single" /></a></li>
					<li><!-- a href="" onclick="TnGotoProduct(830847);return false;" --><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0425_06.png" alt="텐바이텐 3만원 기프트카드" /><!-- /a --></li>
				</ul>
			<% end if %>
			<!-- //05.22 -->

			<!-- 05.23 -->
			<% if currenttime >= #05/23/2014 00:00:00# then %>
				<ul class="today0428">
					<li><a href="" onclick="TnGotoProduct(872776);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_01.png" alt="베이퍼 친환경 물병" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1017394);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_02.png" alt="벤시몽(Bensimon)" /></a></li>
					<li><a href="" onclick="TnGotoProduct(1004175);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_03.png" alt="북유럽스타일 패브릭 바스켓" /></a></li>
					<li><a href="" onclick="TnGotoProduct(822728);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_04.png" alt="인스탁스 mini25 Cath kidston(Mint)" /></a></li>
					<li><a href="" onclick="TnGotoProduct(894438);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_05.png" alt="허니브레인-블랙얼반 숄더&크로스백" /></a></li>
					<li><a href="" onclick="TnGotoProduct(990718);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/pdt0428_06.png" alt="파이어플라이스" /></a></li>
				</ul>
			<% end if %>
			<!-- //05.23 -->

		</div>
		<div class="time">
			<div>
				<p class="timeView" id="lyrCounter"><span>00</span><span>00</span></p>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt4_m.png" alt="10x10 WISH APP 다운로드 방법" /></p>
		<p class="overHidden">
			<a href="http://bit.ly/1l59Uup" class="ftLt" style="width:50%;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_img3.png" alt="아이폰 다운로드" /></a>
			<a href="market://details?id=kr.tenbyten.shopping" class="ftRt" style="width:50%;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_img4.png" alt="안드로이드 다운로드" /></a>
		</p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt5_m.png" alt="10x10 WISH를 소문내주세요" /></p>
		<div class="overHidden">
			<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode(ename)
			snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
			snpPre = Server.URLEncode("텐바이텐 이벤트")
			snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = Server.URLEncode("#10x10")
			snpImg = Server.URLEncode(emimg)
			%>

			<a href="" style="width:33.33333%" class="ftLt" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns1.png" alt="twitter" /></a>
			<a href="" style="width:33.33333%" class="ftLt" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns2.png" alt="Facebook" /></a>
			<!-- a href="" style="width:15%" class="ftLt" onclick="pinit('<%=snpLink%>','<%=snpImg%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3_m.png" alt="Pinterest" /></a -->
			<!--<a href="" style="width:33.33333%" class="ftLt" onclick="kakaoLink('etc','<%=snpLink%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3.png" alt="kakao talk" /></a>-->
			<a href="" style="width:33.33333%" class="ftLt" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_sns3.png" alt="kakaotalk" /></a>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50838/50838_txt7.png" alt="이벤트 유의사항" /></p>
	</div>
	<!-- //텐바이텐 앱 위시 론칭2차 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 신학기 GNB Event for mobile & app
' History : 2015-08-07 허진원 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64848
Else
	eCode   =  65326 '//이벤트 메인 상품리스트
End If

dim userid, i
	userid = getloginuserid()
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65326 {background:#a4e2e7 url(http://webimage.10x10.co.kr/eventIMG/2015/65326/bg_school.png) no-repeat 50% 0; background-size:100% auto;}

.topic {position:relative; padding-bottom:70.5%;}
.topic p {position:absolute; top:15%; left:50%; width:67%; margin-left:-33.5%;}
.topic h2 span {position:absolute;}
.topic h2 .letter1 {top:47%; left:15%; z-index:5; width:14.84%;}
.topic h2 .letter2 {top:43%; left:27.5%; width:18.28%;}
.topic h2 .letter3 {top:52%; left:46.2%; width:22.65%;}
.topic h2 .letter4 {top:38.5%; left:69%; width:20.15%;}
.topic strong {position:absolute; top:37.5%; left:2%; width:22.8%;}
.topic p { -webkit-animation-name:bounce; -webkit-animation-iteration-count:6; -webkit-animation-duration:1s; -moz-animation-name:bounce; -moz-animation-iteration-count:6; -moz-animation-duration:1s; -ms-animation-name:bounce; -ms-animation-iteration-count:6; -ms-animation-duration:1s;}
@-webkit-keyframes bounce {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:7px; -webkit-animation-timing-function:ease-in;}
}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:7px; animation-timing-function:ease-in;}
}

.goodtip {padding-bottom:11%;}
.goodtip .item {position:relative; width:87.5%; margin:0 auto; padding:7% 0 9%; border-radius:20px; background-color:#fff;}
.goodtip .item {-webkit-box-shadow: 10px 10px 24px 2px rgba(156,221,227,0.2);
-moz-box-shadow: 10px 10px 24px 2px rgba(156,221,227,0.2);
box-shadow: 10px 10px 24px 2px rgba(156,221,227,0.2);}
.goodtip .item .inner {display:block; width:74%; margin:5% auto 0; text-align:center;}
.goodtip .item figure {padding:2.36%; border:1px solid #d8d6d6;}
.goodtip .item .pName {overflow:hidden; margin-top:11%; padding-top:0; color:#000; text-overflow:ellipsis; white-space:nowrap;}
.goodtip .item .pPrice {margin-top:2%; padding-top:0;}
.goodtip .btnRefresh {position:absolute; top:69%; left:50%; width:14.64%; margin-left:-7.32%; background-color:transparent;}
.goodtip .btnmore {position:absolute; bottom:-3.4%; left:50%; width:25%; margin-left:-12.5%;}

.inbag .item {position:relative;}
.inbag .item ul li.inbag2 a, .inbag .item ul li.inbag3 a, .inbag .item ul li.inbag4 a, .inbag .item ul li.inbag5 a, .inbag .item ul li.inbag6 a, .inbag .item ul li.inbag7 a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:90.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.inbag .item ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0;}
.inbag .item ul li.inbag2 {position:absolute; top:27%; left:5%; width:40%;}
.inbag .item ul li.inbag3 {position:absolute; top:27%; right:5%; width:45%;}
.inbag .item ul li.inbag3 a {padding-bottom:97.25%;}
.inbag .item ul li.inbag4 {position:absolute; top:48.5%; left:5%; width:40%;}
.inbag .item ul li.inbag5 {position:absolute; top:52%; right:5%; width:45%;}
.inbag .item ul li.inbag6 {position:absolute; bottom:8%; left:7%; width:42.5%;}
.inbag .item ul li.inbag6 a {padding-bottom:99.25%;}
.inbag .item ul li.inbag7 {position:absolute; bottom:5%; right:5%; width:42%;}

.relateEvt {background-color:#f4f7f7;}
.relateEvt h3 {visibility:hidden; width:0; height:0;}
.relateEvt1 {padding-top:5%;}
.relateEvt1 ul {overflow:hidden;}
.relateEvt1 ul li {float:right; width:48.4%;}
.relateEvt1 ul li:first-child {float:left;}

.plusKeyword {position:relative; padding:12% 3.125% 5%; background-color:#f4f7f7;}
.plusKeyword h3 {position:absolute; top:7%; left:50%; width:41.4%; margin-left:-20.7%;}
.plusKeyword ul {overflow:hidden; position:absolute; top:20%; left:50%; width:86%; margin-left:-43%;}
.plusKeyword ul li {float:left; width:33.333%; margin-bottom:6%;}
.plusKeyword ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 4%; padding-bottom:118.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.plusKeyword ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0;}

.relateEvt2 {padding-bottom:6%;}

.itemList {overflow:hidden; background-color:#f4f7f7;}
.itemList h3 {visibility:hidden; width:0; height:0;}
.itemList .navigator {width:101%;}
.itemList .navigator:after {content:' '; display:block; clear:both;}
.itemList .navigator li {float:left; width:33.333%; text-align:center;}
.itemList .navigator li a {display:block; position:relative; margin-right:3px; height:50px; background-color:#6eaae8; color:#405e7d; font-size:14px; font-weight:bold; line-height:55px;}
.itemList .navigator li:last-child a {margin-right:0;}
.itemList .navigator li a.on {background-color:#00dd8f; color:#fff; font-size:15px;}
.itemList .navigator li a.on:after {content:' '; position:absolute; top:-17px; left:50%; width:35px; height:35px; margin-left:-17px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65326/ico_pictogram_v1.png) no-repeat 50% 0; background-size:100% auto;}
.itemList .navigator li:nth-child(2) a.on {background-color:#ff9764;}
.itemList .navigator li:nth-child(2) a.on:after {background-position:0 -35px;}
.itemList .navigator li:last-child a.on {background-color:#8784f9;}
.itemList .navigator li:last-child a.on:after {background-position:0 100%;}

#lyrTabItemList {padding:0 3.125%;}

@media all and (min-width:480px){
	.itemList .navigator li a {height:75px; font-size:21px; line-height:80px;}
	.itemList .navigator li a.on {font-size:22px;}
	.itemList .navigator li a.on:after {top:-26px; width:52px; height:52px; margin-left:-26px;}
	.itemList .navigator li:nth-child(2) a.on:after {background-position:0 -52px;}
}
</style>
<script type='text/javascript'>
$(function(){
	// 타이틀 에니메이션
	titleAnimation();
	$(".topic p, .topic strong").css({"opacity":"0"});
	$(".topic strong").css({"left":"0"});
	$(".topic h2 span").css({"opacity":"0"});
	$(".topic h2 .letter1").css({"top":"49%"});
	$(".topic h2 .letter2").css({"top":"45%"});
	$(".topic h2 .letter3").css({"top":"54%"});
	$(".topic h2 .letter4").css({"top":"40%"});
	function titleAnimation() {
		$(".topic h2 .letter1").delay(500).animate({"top":"47%", "opacity":"1"},600);
		$(".topic h2 .letter2").delay(900).animate({"top":"43%", "opacity":"1"},600);
		$(".topic h2 .letter3").delay(1300).animate({"top":"52%", "opacity":"1"},600);
		$(".topic h2 .letter4").delay(1900).animate({"top":"38.5%", "opacity":"1"},600);
		$(".topic strong").delay(2400).animate({"left":"2%", "opacity":"1"},600);
		$(".topic p").delay(2900).animate({"opacity":"1"},600);
	}

	//초기 꿀팁 상품 세팅
	getTipItemInfo();

	//초기 상품목록 세팅
	getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","136665","156388")%>);
});


function pageup(){
	window.$('html,body').animate({scrollTop:$("#itemlist").offset().top+600}, 0);
}

// 꿀팁 상품 출력
function getTipItemInfo() {
	$.ajax({
		type:"POST",
		url: "/event/etc/inc_65326_rndItem.asp",
		cache: false,
		success: function(message) {
			$("#lyrRcmItem").html(message);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 상품 목록 출력
function getEvtItemList(no,egc) {
	$(".navigator li a").removeClass("on");
	$("#"+no+">a").addClass("on");

	$.ajax({
		type:"POST",
		url: "/event/etc/inc_65326_itemlist.asp",
		data: "eGC="+egc,
		cache: false,
		success: function(message) {
			$("#lyrTabItemList").html(message);
			<% if isApp then %>
			// 순차 로딩
			$("img.lazy").lazyload().removeClass("lazy");
			<% end if %>
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<div class="mEvt65326">
	<section class="topic">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_cheer.png" alt="당신의 새학기를 응원합니다!" /></p>
		<h2>
			<span class="letter1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_letter_01.png" alt="투" /></span>
			<span class="letter2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_letter_02.png" alt="뿔" /></span>
			<span class="letter3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_letter_03.png" alt="에" /></span>
			<span class="letter4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_letter_04.png" alt="이" /></span>
		</h2>
		<strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/txt_plus.png" alt="A++" /></strong>
	</section>

	<section class="goodtip">
		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/tit_good_tip.png" alt="에이쁠러의 꿀팁" /></h3>
			<div id="lyrRcmItem"><!-- 꿀팁 상품 정보 --></div>
			<button type="button" class="btnRefresh" onclick="getTipItemInfo()"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/btn_refresh.png" alt="새로고침" /></button>
			<div class="btnmore"><a href="eventmain.asp?eventid=65329" onclick="goEventLink('65329');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63082/btn_more.png" alt="에이쁠러의 꿀팁 상품 더보기" /></a></div>
		</div>
	</section>

	<section class="inbag">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/tit_in_bag.png" alt="가방 속 비밀병기" /></h3>
		<div class="item">
			<ul>
				<li class="inbag1"><a href="eventmain.asp?eventid=65330" onclick="goEventLink('65330');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_item_inbag_01.jpg" alt="일등은 가방부터 다르다" /></a></li>
				<li class="inbag2"><a href="eventmain.asp?eventid=65371" onclick="goEventLink('65371');return false;"><span></span>필기가 솔솔</a></li>
				<li class="inbag3"><a href="eventmain.asp?eventid=65373" onclick="goEventLink('65373');return false;"><span></span>자꾸 보고픈 노트</a></li>
				<li class="inbag4"><a href="eventmain.asp?eventid=65374" onclick="goEventLink('65374');return false;"><span></span>내꺼야!</a></li>
				<li class="inbag5"><a href="eventmain.asp?eventid=65375" onclick="goEventLink('65375');return false;"><span></span>펜의 패션, 필통</a></li>
				<li class="inbag6"><a href="eventmain.asp?eventid=65377" onclick="goEventLink('65377');return false;"><span></span>밤샌거 티 안나게!</a></li>
				<li class="inbag7"><a href="eventmain.asp?eventid=65376" onclick="goEventLink('65376');return false;"><span></span>정리의 여왕</a></li>
			</ul>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_item_inbag_02_v1.jpg" alt="" />
		</div>
	</section>

	<section class="relateEvt relateEvt1">
		<h3>연관 이벤트</h3>
		<ul>
			<li><a href="eventmain.asp?eventid=65256" onclick="goEventLink('65256');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_bnr_01.jpg" alt="공부의 FEEL충전 느낌있는 스터디룸" /></a></li>
			<li><a href="eventmain.asp?eventid=65258" onclick="goEventLink('65258');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_bnr_02.jpg" alt="나 하버드대 갈거야! 말리지마." /></a></li>
		</ul>
	</section>

	<section class="plusKeyword">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/tit_keyword.png" alt="KEYWORD" /></h3>
		<ul>
			<li><a href="eventmain.asp?eventid=65335" onclick="goEventLink('65335');return false;"><span></span>#책상정리</a></li>
			<li><a href="eventmain.asp?eventid=65336" onclick="goEventLink('65336');return false;"><span></span>#엉덩이쿠션</a></li>
			<li><a href="eventmain.asp?eventid=65339" onclick="goEventLink('65339');return false;"><span></span>#데스크조명</a></li>
			<li><a href="eventmain.asp?eventid=65340" onclick="goEventLink('65340');return false;"><span></span>#브레인푸드</a></li>
			<li><a href="eventmain.asp?eventid=65341" onclick="goEventLink('65341');return false;"><span></span>#텀블러</a></li>
			<li><a href="eventmain.asp?eventid=65342" onclick="goEventLink('65342');return false;"><span></span>#키즈백팩</a></li>
		</ul>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_keyword_v1.jpg" alt="" />
	</section>

	<section class="relateEvt relateEvt2">
		<h3>연관 이벤트</h3>
		<div><a href="eventmain.asp?eventid=65343" onclick="goEventLink('65343');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_bnr_03.jpg" alt="스마트한 학교 생활" /></a></div>
	</section>

	<section class="itemList">
		<div><a href="eventmain.asp?eventid=65331" onclick="goEventLink('65331');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65326/img_bnr_04.png" alt="요즘은 예쁜 애들이 공부도 잘한다 스쿨라이프 TPO에 맞는 Style UP 제안" /></a></div>

		<h3>새학기 아이템</h3>
		<ul class="navigator">
			<li id="nav01"><a href="" onclick="getEvtItemList('nav01',<%=chkIIF(application("Svr_Info")="Dev","136665","156388")%>); return false;">개강총회</a></li>
			<li id="nav02"><a href="" onclick="getEvtItemList('nav02',<%=chkIIF(application("Svr_Info")="Dev","136666","156394")%>); return false;">강의실</a></li>
			<li id="nav03"><a href="" onclick="getEvtItemList('nav03',<%=chkIIF(application("Svr_Info")="Dev","136667","156400")%>); return false;">MT</a></li>
		</ul>

		<div id="lyrTabItemList"><!-- 상품 목록 --></div>
	</section>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->
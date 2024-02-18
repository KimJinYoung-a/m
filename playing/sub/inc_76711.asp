<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 마음씨약국
' History : 2017-03-09 김진영 생성
'####################################################
Dim eCode, sqlStr, LoginUserid, vDIdx, myresultCnt, totalresultCnt

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66288
Else
	eCode   =  76711
End If

vDIdx		= request("didx")
LoginUserid	= getencLoginUserid()

'1. 로그인을 했다면 tbl_event_subscript에 ID가 있는 지 확인
If IsUserLoginOK() Then
	sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 = 'result' "
	rsget.Open sqlStr,dbget,1
	If not rsget.EOF Then
		myresultCnt = rsget(0)
	End If
	rsget.close
Else
	myresultCnt = 0
End If


'2. 전체 참여자 카운트
sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND sub_opt1 = 'result' "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	totalresultCnt = rsget(0)
End If
rsget.close

dim snpTitle, snpLink1, snpLink2, snpLink3, snpLink4, snpLink5
snpTitle = Server.URLEncode("당신의 처방전은?")
snpLink1 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=76810")
snpLink2 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=76811")
snpLink3 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=76812")
snpLink4 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=76813")
snpLink5 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=76814")
%>
<style type="text/css">
.heartSeed .intro {position:relative; padding-bottom:4rem; background:#1f9d62 url(http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_intro.png) 0 0 no-repeat; background-size:100% auto;}
.heartSeed .intro h2 {position:absolute; left:50%; top:13rem; z-index:30; width:14.4rem; margin-left:-7.2rem; animation:flip 2s 1.8s; -webkit-animation:flip 2s 1.8s;}
.heartSeed .intro .deco1 {position:absolute; left:50%; top:7.75rem; width:18.4rem; margin-left:-9.2rem; z-index:20; animation:spin 1.5s .5s 1; -webkit-animation:spin 1.5s .5s 1;}
.heartSeed .intro .deco2 {position:absolute; left:50%; top:7.75rem; width:20%; margin-left:-10%; z-index:30;}
.heartSeed .intro .seed {width:42%; margin:0 auto; padding:27.8rem 0 1.5rem;}
.heartSeed .intro .swiper-container {width:85%; margin:3rem auto 2.2rem;}
.heartSeed .intro .pagination {position:absolute; bottom:1.5rem; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.heartSeed .intro .pagination span {display:inline-block; width:1rem; height:0.4rem; margin:0 0.4rem; border-radius:0.8rem; background:#fff; cursor:pointer; vertical-align:middle;}
.heartSeed .intro .pagination .swiper-active-switch {height:0.7rem;}
.heartSeed .intro .btnStart {display:block; width:57.5%; margin:0 auto; animation:bounce1 1s 30; -webkit-animation:bounce1 1s 30;}
.heartSeed .heartTest {position:relative; padding-bottom:4rem;background:#e7e7e7;}
.heartSeed .question {background:url(http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_gry.png) 0 0 repeat-y; background-size:100% auto;}
.heartSeed .question ul {overflow:hidden; padding:0 10.625%;}
.heartSeed .question li {position:relative; cursor:pointer;}
.heartSeed .question li i {display:none; position:absolute; z-index:40; width:1.5rem; height:1.5rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol010/m/ico_check.png) 0 0 no-repeat; background-size:100%;}
.heartSeed .question li.current i {display:block; animation:bounce1 .5s; -webkit-animation:bounce1 .4s;}
.heartSeed .question1 ul {width:78.75%; margin:0 auto; padding:4.2rem 1.6rem 1rem; background:#ffdd3f; border-radius:4.4rem;}
.heartSeed .question1 li {margin-bottom:3.2rem; padding-bottom:1rem; cursor:auto;}
.heartSeed .question1 li:after {content:''; display:inline-block; position:absolute; left:0; bottom:0; width:100%; height:0.3rem; border-radius:0.3rem; background:#f0cc28;}
.heartSeed .question1 li img {vertical-align:middle;}
.heartSeed .question1 li:first-child label {position:relative;}
.heartSeed .question1 li:first-child label:after {content:''; display:inline-block; position:absolute; right:0; top:-0.05rem; width:0.2rem; height:1.7rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol010/m/img_cursor.gif) 0 0 no-repeat; background-size:100%;}
.heartSeed .question1 li.cursor label:after {display:none;}
.heartSeed .question1 input {width:3.4rem; text-align:right; padding:0 0.2rem; font-size:1.6rem; border:0; color:#6c5c11; background:transparent;}
.heartSeed .question2 li {padding-bottom:1rem;}
.heartSeed .question2 li i {left:10%; top:50%; margin-top:-1.7rem;}
.heartSeed .question3 ul {margin:0 -3.15%;}
.heartSeed .question3 li {float:left; width:50%; padding:0 3.15% 1.6rem;}
.heartSeed .question3 li i {left:50%; top:6%; margin-left:-0.5rem;}
.heartSeed .question4 li {float:left; width:33.33333%; padding-bottom:1.6rem;}
.heartSeed .question4 li i {left:50%; top:66%; margin-left:-0.5rem;}
.heartSeed .question5 .word {position:relative;}
.heartSeed .question5 ul {padding:0;}
.heartSeed .question5 li {position:absolute; width:5.6rem; }
.heartSeed .question5 li span {overflow:hidden; position:absolute; left:0; top:0; height:2.5rem;}
.heartSeed .question5 li i {left:50%; top:-1rem; margin-left:-0.7rem;}
.heartSeed .question5 li.current img {margin-top:-2.65rem;}
.heartSeed .question5 li.w1 {left:8.4%; top:2.48%; width:4.4rem;}
.heartSeed .question5 li.w2 {left:26.875%; top:7.66%;}
.heartSeed .question5 li.w3 {left:49%; top:4.7%;}
.heartSeed .question5 li.w4 {left:72%; top:0;}
.heartSeed .question5 li.w5 {left:14.375%; top:27%;}
.heartSeed .question5 li.w6 {left:38%; top:32.5%;}
.heartSeed .question5 li.w7 {left:61%; top:21%;}
.heartSeed .question5 li.w8 {left:75.15%; top:35.6%;}
.heartSeed .question5 li.w9 {left:7.3%; top:48%; width:7.85rem;}
.heartSeed .question5 li.w10 {left:42.8%; top:53.4%;}
.heartSeed .question5 li.w11 {left:69.68%; top:53.41%; width:6.75rem;}
.heartSeed .question5 li.w12 {left:20.31%; top:65.83%;}
.heartSeed .question5 li.w13 {left:54%; top:68.9%; width:6.35rem;}
.heartSeed .btnSubmit {display:block; width:57.5%; margin:0 auto; animation:bounce1 1s infinite; -webkit-animation:bounce1 1s infinite;}
.heartSeed .loading {display:none; position:fixed; left:0; top:0; z-index:40; width:100%; height:100%; text-align:center; background:rgba(0,0,0,.6);}
.heartSeed .loading div {position:absolute; left:0; top:50%; width:100%; height:8.8rem; margin-top:-4.4rem; padding-top:6.7rem;}
.heartSeed .loading span {position:absolute; left:50%; top:0; width:4.8rem; margin-left:-2.4rem;}
.heartSeed .loading p {font-size:2rem; font-weight:600; color:#fff;}
.heartSeed .loadOn .loading {display:block;}
.heartSeed .loadOn .loading span {animation:spin 1.5s .5s 3; -webkit-animation:spin 1.5s .5s 3;}
.heartSeed .prescription {display:none; padding-top:3.8rem; text-align:center; background:#f8fdfb;}
.heartSeed .prescription .result {position:relative; padding:0 10.468%;}
.heartSeed .prescription .result .btnAgain {float:left; width:39.5%;}
.heartSeed .prescription .result .btnShare {float:right; width:39.5%;}
.heartSeed .prescription .result .name {padding:2.4rem 0 1rem; font-size:2rem; line-height:2.3rem; font-weight:600; color:#666;}
.heartSeed .prescription h3 {position:relative; padding:0 10.468% 1.4rem;}
.heartSeed .prescription h3:after {content:''; display:inline-block; position:absolute; left:50%; bottom:0; width:100%; height:0.5rem; margin-left:-50%;  background:url(http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_line.png) 50% 0 no-repeat; background-size:auto 100%;}
.heartSeed .kit {padding-bottom:2.5rem; text-align:center; background:#1f9d62;}
.heartSeed .kit .btnKit {display:block; width:57.5%; margin:0 auto; animation:bounce1 1s infinite; -webkit-animation:bounce1 1s infinite;}
.heartSeed .kit .total {padding-top:1.2rem; font-size:1.1rem; font-weight:600;}
@keyframes bounce1{
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
@-webkit-keyframes bounce1{
	from,to {-webkit-transform:translateY(0);}
	50% {-webkit-transform:translateY(5px);}
}
@keyframes flip {
  from {transform: perspective(200px) rotate3d(1, 0, 0, 90deg); animation-timing-function: ease-in;}
  40% {transform: perspective(200px) rotate3d(1, 0, 0, -30deg);}
  60% {transform: perspective(200px) rotate3d(1, 0, 0, 30deg);}
  80% {transform: perspective(200px) rotate3d(1, 0, 0, -5deg);}
  to {transform: perspective(200px);}
}
@-webkit-keyframes flip {
  from {-webkit-transform: perspective(200px) rotate3d(1, 0, 0, 90deg); -webkit-animation-timing-function: ease-in;}
  40% {-webkit-transform: perspective(200px) rotate3d(1, 0, 0, -30deg);}
  60% {-webkit-transform: perspective(200px) rotate3d(1, 0, 0, 30deg);}
  80% {-webkit-transform: perspective(200px) rotate3d(1, 0, 0, -5deg);}
  to {-webkit-transform: perspective(200px);}
}
@keyframes spin {
	from {transform:rotate(0deg);}
	to {transform:rotate(360deg);}
}
@-webkit-keyframes spin {
	from {-webkit-transform:rotate(0deg);}
	to {-webkit-transform:rotate(360deg);}
}
</style>
<script type="text/javascript">
$(function(){
	$("#uYear").blur(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,"").replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3"));
	});
	$("#uMonth").blur(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,"").replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3"));
	});
	$("#uDay").blur(function(){
		$(this).val($(this).val().replace(/[^0-9]/g,"").replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3"));
	});

	var mySwiper = new Swiper(".intro .swiper-container",{
		loop:true,
		speed:600,
		autoplay:2700,
		pagination:".intro .pagination"
	});

	$(".btnStart").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
	});
	$(".btnGo").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$("#kit").offset().top},500);
	});

	$(".question li").click(function(){
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
	});
	$('.question1 li input').focus(function() {
		$(this).closest("li").addClass("cursor");
	});

	// title animation
	titleAnimation()
	$(".intro h2").css({"opacity":"0"});
	$(".intro .deco2").css({"margin-top":"-10px","opacity":"0"});
	function titleAnimation() {
		$(".intro h2").delay(1800).animate({"opacity":"1"},800);
		$(".intro .deco2").delay(1300).animate({"margin-top":"0", "opacity":"1"},600);
	}
});

function jsplayingthing(num, sel){
<% If IsUserLoginOK() Then %>
	if(sel == 2) {$("#tmpex2").val(num);}
	if(sel == 3) {$("#tmpex3").val(num);}
	if(sel == 4) {$("#tmpex4").val(num);}
	if(sel == 5) {$("#tmpex5").val(num);}
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}

function jsplayingthingadd(v){
<%
If IsUserLoginOK() Then
%>
	if($("#uName").val() == ""){
		alert('이름을 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uYear").val() == ""){
		alert('생일을 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uYear").val() < 1900 || $("#uYear").val() >= 2017){
		alert('연도를 정확히 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uMonth").val() == ""){
		alert('생일을 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uMonth").val() < 1 || $("#uMonth").val() >= 13){
		alert('월을 정확히 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uDay").val() == ""){
		alert('생일을 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#uDay").val() > 31){
		alert('일을 정확히 입력하세요');
		window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
		return false;
	}

	if($("#tmpex2").val() == ""){
		alert('두 번째 기초테스트를 선택하세요');
		window.parent.$('html,body').animate({scrollTop:$("#Q2").offset().top},500);
		return false;
	}

	if($("#tmpex3").val() == ""){
		alert('세 번째 기초테스트를 선택하세요');
		window.parent.$('html,body').animate({scrollTop:$("#Q3").offset().top},500);
		return false;
	}

	if($("#tmpex4").val() == ""){
		alert('네 번째 감각테스트를 선택하세요');
		window.parent.$('html,body').animate({scrollTop:$("#Q4").offset().top},500);
		return false;
	}

	if($("#tmpex5").val() == ""){
		alert('다섯 번째 감정테스트를 선택하세요');
		window.parent.$('html,body').animate({scrollTop:$("#Q5").offset().top},500);
		return false;
	}
	var str;
	if(v == "1"){
		str = $.ajax({
			type: "POST",
			url: "/playing/sub/doEventSubscript76711.asp?mode=add",
			data: $("#sfrm").serialize(),
			dataType: "text",
			async: false
		}).responseText;
		console.log(str);
		var str1 = str.split("|")
		console.log(str);

		if (str1[0] == "OK"){
			$(".heartTest").removeClass("loadOn");
			$(".loading").show();
			$(".prescription").hide();

			$("#vResult").empty().html(str1[1]);
			$("#vResult").show();

			event.preventDefault();
			$(".heartTest").addClass("loadOn");
			$(".loading").delay(3500).fadeOut(100);
			$(".prescription").delay(3500).fadeIn(10);
			setTimeout(function(){
			  window.parent.$('html,body').animate({scrollTop:$("#prescription").offset().top},500);
			},3600);
		} else {
			alert('오류가 발생했습니다.');
			parent.location.reload();
			return false;
		}
	}else{
	<% If Now() > #03/23/2017 00:00:00# Then %>
		alert('응모가 마감되었습니다!');
		return false;
	<% Else %>
		str = $.ajax({
			type: "POST",
			url: "/playing/sub/doEventSubscript76711.asp?mode=result",
			data: $("#sfrm").serialize(),
			dataType: "text",
			async: false
		}).responseText;
		console.log(str);
		var str1 = str.split("|")
		console.log(str);

		if (str1[0] == "05"){
			alert('응모가 완료 되었습니다!');
			$("#vImage").attr("src","http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_kit_finish.png"); 
		}else if(str1[0] == "03"){
			alert('이미 응모하였습니다.!');
		} else {
			alert('오류가 발생했습니다.');
			parent.location.reload();
		}
		return false;
	<% End If %>
	}
<%
Else
%>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}

function logincheck(){
<%
If NOT IsUserLoginOK() Then 
	If isApp=1 Then
%>
		parent.calllogin();
		return false;
<%	Else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
<%
	End if
End if
%>
}

function fnReTest(){
	$("#tmpex2").val("");
	$("#tmpex3").val("");
	$("#tmpex4").val("");
	$("#tmpex5").val("");

	$("#uName").val("");
	$("#uYear").val("");
	$("#uMonth").val("");
	$("#uDay").val("");

	$(".question li").removeClass("current");
	$(".heartTest").removeClass("loadOn");

	$(".prescription").hide();
	window.parent.$('html,body').animate({scrollTop:$("#heartTest").offset().top},500);
	return false;	
}

function snschkresult(v) {
	if (v == "A"){
		popSNSPost('fb','<%= snpTitle %>', '<%= snpLink1 %>','','');
	}else if (v == "B"){
		popSNSPost('fb','<%= snpTitle %>', '<%= snpLink2 %>','','');
	}else if (v == "C"){
		popSNSPost('fb','<%= snpTitle %>', '<%= snpLink3 %>','','');
	}else if (v == "D"){
		popSNSPost('fb','<%= snpTitle %>', '<%= snpLink4 %>','','');
	}else if (v == "E"){
		popSNSPost('fb','<%= snpTitle %>', '<%= snpLink5 %>','','');
	}
	return false;
}
</script>
<div class="thingVol010 heartSeed">
<form name="sfrm" id="sfrm" method="post">
<input type="hidden" name="tmpex2" id="tmpex2">
<input type="hidden" name="tmpex3" id="tmpex3">
<input type="hidden" name="tmpex4" id="tmpex4">
<input type="hidden" name="tmpex5" id="tmpex5">
	<div class="intro">
		<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_heart_pharmacy.png" alt="마음씨 약국" /></h2>
		<div class="deco1"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_intro_deco_1.png" alt="" /></div>
		<div class="deco2"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_intro_deco_2.png" alt="" /></div>
		<div class="seed"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_seed.gif" alt="" /></div>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_purpose.png" alt="마음씨 약국에 오신 걸 환영합니다. 요즘 여러분의 증상은 어떤가요? 난 못하겠어 증상, 앞이 캄캄해 증상, 돌아갈래 증상,, 여러분의 증상을 체크하세요! 마음씨 약국이 씨약으로 처방해드립니다." /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_slide_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_slide_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_slide_04.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_slide_05.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
		</div>
		<button type="button" class="btnStart" onclick="logincheck(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_start.png" alt="증상 체크하기" /></button>
	</div>
	<%' 증상 테스트 (각 항목마다 선택한 li는 클래스 current 들어가게 해놓았습니다!) %>
	<div id="heartTest" class="heartTest">
		<%' Q1 %>
		<div class="question question1">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_question_1.png" alt="첫번째, 기초정보입력 - 이름과 생년월일을 적어주세요!" /></h3>
			<ul>
				<li>
					<label class="uName"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_name.png" alt="이름" style="width:4.3rem;" /></label>
					<input type="text" id="uName" name="uName" maxlength="30" class="lt" style="width:65%;" onClick="logincheck();" onKeyUp="logincheck();" />
				</li>
				<li>
					<label class="uYear"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_birth.png" alt="생일" style="width:3.1rem;" /></label>
					<input type="tel" id="uYear" name="uYear" style="width:5.5rem;" maxlength="4" onClick="logincheck();" onKeyUp="logincheck();" />
					<label class="uYear"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_year.png" alt="년" style="width:1.1rem;" /></label>
					<input type="tel" id="uMonth" name="uMonth" maxlength="2" onClick="logincheck();" onKeyUp="logincheck();" />
					<label class="uMonth"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_month.png" alt="월" style="width:1.2rem;" /></label>
					<input type="tel" id="uDay" name="uDay" maxlength="2" onClick="logincheck();" onKeyUp="logincheck();"/>
					<label class="uDay"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_day.png" alt="일" style="width:1.2rem;" /></label>
				</li>
			</ul>
		</div>
		<%' Q2 %>
		<div class="question question2" id="Q2">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_question_2.png" alt="두번째, 기초테스트 - 요즘 나의 관심사를 선택해 주세요!" /></h3>
			<ul>
				<li onclick="jsplayingthing('1','2'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_interest_1.png" alt="직장/학업" /></li>
				<li onclick="jsplayingthing('2','2'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_interest_2.png" alt="연애" /></li>
				<li onclick="jsplayingthing('3','2'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_interest_3.png" alt="다이어트" /></li>
			</ul>
		</div>
		<%' Q3 %>
		<div class="question question3" id="Q3">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_question_3.png" alt="세번째, 감각테스트 - 끌리는 색 조합을 선택해주세요!" /></h3>
			<ul>
				<li onclick="jsplayingthing('1','3'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_color_1.png" alt="" /></li>
				<li onclick="jsplayingthing('2','3'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_color_2.png" alt="" /></li>
				<li onclick="jsplayingthing('3','3'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_color_3.png" alt="" /></li>
				<li onclick="jsplayingthing('4','3'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_color_4.png" alt="" /></li>
			</ul>
		</div>
		<%' Q4 %>
		<div class="question question4" id="Q4">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_question_4.png" alt="네번째, 감정테스트 - 지금 나의 상태를 선택해주세요!" /></h3>
			<ul>
				<li onclick="jsplayingthing('1','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_1.png" alt="" /></li>
				<li onclick="jsplayingthing('5','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_2.png" alt="" /></li>
				<li onclick="jsplayingthing('3','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_3.png" alt="" /></li>
				<li onclick="jsplayingthing('4','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_4.png" alt="" /></li>
				<li onclick="jsplayingthing('2','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_5.png" alt="" /></li>
				<li onclick="jsplayingthing('6','4'); return false;"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_face_6.png" alt="" /></li>
			</ul>
		</div>
		<%' Q5 %>
		<div class="question question5" id="Q5">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/tit_question_5.png" alt="다섯번째, 무의식테스트 - 가장 먼저 보이는 단어는 무엇입니까?" /></h3>
			<div class="word">
				<ul>
					<li class="w1" onclick="jsplayingthing('1','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_1.png" alt="슬픈" /></span></li>
					<li class="w2" onclick="jsplayingthing('2','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_2.png" alt="즐거운" /></span></li>
					<li class="w3" onclick="jsplayingthing('3','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_3.png" alt="귀여운" /></span></li>
					<li class="w4" onclick="jsplayingthing('4','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_4.png" alt="심쿵한" /></span></li>
					<li class="w5" onclick="jsplayingthing('5','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_5.png" alt="행복한" /></span></li>
					<li class="w6" onclick="jsplayingthing('6','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_6.png" alt="지루한" /></span></li>
					<li class="w7" onclick="jsplayingthing('7','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_7.png" alt="편안한" /></span></li>
					<li class="w8" onclick="jsplayingthing('8','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_8.png" alt="심심한" /></span></li>
					<li class="w9" onclick="jsplayingthing('9','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_9.png" alt="사랑스러운" /></span></li>
					<li class="w10" onclick="jsplayingthing('10','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_10.png" alt="그리운" /></span></li>
					<li class="w11" onclick="jsplayingthing('11','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_11.png" alt="앞이캄캄" /></span></li>
					<li class="w12" onclick="jsplayingthing('12','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_12.png" alt="속상한" /></span></li>
					<li class="w13" onclick="jsplayingthing('13','5'); return false;"><i></i><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_word_13.png" alt="재미있는" /></span></li>
				</ul>
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/bg_question_5.png" alt="" /></div>
			</div>
		</div>
		<button type="button" class="btnSubmit" onclick="jsplayingthingadd('1'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/btn_submit.png" alt="처방받기" /></button>
		<%' 로딩중 %>
		<div class="loading">
			<div>
				<span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/ico_loading.png" alt="" /></span>
				<p>처방중...</p>
			</div>
		</div>
	</div>
	<div id="prescription" class="prescription">
		<h3><span><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_prescription.png" alt="처방전" /></span></h3>
		<div class="result" id="vResult" style="display:none;"></div>
	</div>
	<div class="kit" id="kit">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_kit.png" alt="마음씨 약국 씨앗 Kit로 증상을 완화하세요! 추첨을 통해 총50명에게 씨악 KIT를 드립니다. 한 ID당 1회 신청 가능합니다." /></p>
		<button type="button" class="btnKit" onclick="jsplayingthingadd('2'); return false;">
			<img id="vImage" src="http://webimage.10x10.co.kr/playing/thing/vol010/m/<%=Chkiif(myresultCnt =0, "btn_kit", "btn_kit_finish")%>.png" alt="씨앗 키트 신청하기" />
		</button>
		<p class="total">총 <%= totalresultCnt %>명이 신청했습니다</p>
	</div>
	<div><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/img_kit.jpg" alt="씨약 Kit 소개" /></div>
	<div class="vol010"><img src="http://webimage.10x10.co.kr/playing/thing/vol010/m/txt_vol010.png" alt="THING의 사물에 대한 생각 메마른 일상에 씨앗으로 일상을 치유하세요!" /></div>
</form>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 감나와라
' History : 2016-11-10 유태욱 생성
'####################################################
Dim eCode , LoginUserid, myresultCnt, vQuery, myKitCnt, lovecnt, workcnt, myKitgubun
dim vDIdx
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66233
	vDIdx = 43
Else
	eCode   =  74346
	vDIdx = 7
End If

lovecnt = 0
workcnt = 0
myKitCnt = 0
myresultCnt = 0
myKitgubun = 0
LoginUserid		= getencLoginUserid()

If IsUserLoginOK() Then
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 <> 'result' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		myresultCnt = rsget(0)
	End IF
	rsget.close
Else
	myresultCnt = 0
End If

if IsUserLoginOK() Then
	vQuery = ""
	vQuery = "SELECT count(*) as cnt , sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 = 'result' group by sub_opt2"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		myKitCnt = rsget("cnt")
		myKitgubun = rsget("sub_opt2")
	End IF
	rsget.close
end if

vQuery = ""
vQuery = "SELECT count(case when sub_opt2 = 1 then sub_opt2 end) as lovecnt, count(case when sub_opt2 = 2 then sub_opt2 end) as workcnt   FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "'  AND sub_opt1 = 'result'  "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	lovecnt = rsget("lovecnt")
	workcnt = rsget("workcnt")
End IF
rsget.close

dim snpTitle, snpLink1, snpLink2, snpLink3, snpLink4
snpTitle = Server.URLEncode("요즘 나에게 떨어진 감은?")
snpLink1 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74347")
snpLink2 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74348")
snpLink3 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74349")
snpLink4 = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=74350")
%>
<style type="text/css">
.feeling {overflow:hidden; background-color:#f15132;}
.feeling button {background-color:transparent;}

.feeling .intro {position:relative;}
.feeling .intro span {position:absolute; top:28.84%; left:50%; width:16.875%; margin-left:-8.437%;}
.feeling .intro p {position:absolute; top:51.3%; left:50%; width:51.09%; margin-left:-25.54%;}

.feeling .topic .hgroup {position:relative;}
.feeling .topic .hgroup p {position:absolute; top:18.96%; left:50%; width:40%; height:59.31%; margin-left:-20%;}
.feeling .topic .hgroup p span {display:block; position:absolute; top:0; left:50%;}
.feeling .topic .hgroup p .letter1 {width:32%; margin-left:-16%;}
.feeling .topic .hgroup p .letter2 {top:36%; left:0; width:100%;}
.feeling .topic .hgroup p .letter3 {top:76.19%; left:15.625%; width:66.8%;}
.feeling .topic .hgroup .bubble {position:absolute; top:21.5%;}
.feeling .topic .hgroup .bubble1 {left:24.68%; width:13.125%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/bg_speech_bubble_01.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .topic .hgroup .bubble2 {top:59.96%; right:20.625%; width:14.68%;}
.feeling .topic .hgroup .bubble2 i {position:absolute; top:38.2%; left:28.72%; width:46.8%;}

.feeling .start {padding-bottom:20%; position:relative;}
.feeling .start .btnStart {width:55.93%; margin:0 auto;}
.feeling .start .btnResult {position:absolute; bottom:4%; left:50%; width:35.93%; margin-left:-17.96%;}

.feeling .test {position:relative;}
.feeling .test .question {padding-bottom:5%; background-color:#ffda2b;}
.feeling .test .question2 {background-color:#ffc6ca;}
.feeling .test .question3 {background-color:#ddefcc;}
.feeling .test .question4 {background-color:#cbe8fe;}
.feeling .test .question5 {background-color:#e7d2de;}
.feeling .test .question p {position:relative; z-index:5; margin-bottom:-3%;}
.feeling .test .question .btnGroup {overflow:hidden; width:92.18%; margin:0 auto;}
.feeling .test .question .btnGroup button {float:left; position:relative; width:50%;}
.feeling .test .question .btnGroup button i {position:absolute; top:78.1%; left:50%; width:2.5rem; height:2.4rem; margin-left:-1.25rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_a.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .test .question .btnGroup button i {
	animation-name:bounce; animation-iteration-count:5; animation-duration:0.7s;
	-webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:0.7s;
}
.feeling .test .question .btnGroup .btnB i {animation-delay:0.1s;}

.feeling .test .lyResult {position:absolute; top:47.2%; left:50%; width:82.18%; margin-left:-41.09%;}
.feeling .test .question .btnGroup .btnB i {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_b.png);}

.feeling .result {position:relative;}
.feeling .result .id {position:absolute; top:6.5%; left:50%;  z-index:10; width:26rem; margin-left:-13rem; padding:0.7rem 0; border:2px solid #ed5335; border-radius:1rem; color:#ed5335; font-size:1.1rem; text-align:center;}
.feeling .result .id b {font-weight:bold;}
.feeling .result .btnMore {position:absolute; bottom:6.5%; left:50%; width:11.5rem; height:3.2rem; margin-left:-5.75rem; font-size:1.1rem; line-height:3.2rem; text-align:center;}
.feeling .result .btnMore span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_test_more.gif) no-repeat 50% 0; background-size:100% auto;}
.feeling .blue .id {border-color:#5992c7; color:#5992c7;}
.feeling .blue .btnMore span {background-position:50% 100%;}

.feeling .result .need {position:absolute; top:6.5%; left:50%; z-index:5; width:21.2rem; height:2.6rem; margin-left:-10.5rem; line-height:2.6rem;}
.feeling .result .need span {position:absolute; top:0; left:0; width:100%; height:100%; background:#ffe2e1 url(http://webimage.10x10.co.kr/playing/thing/vol002/tit_result.png) no-repeat 50% 0; background-size:21rem auto;}
.feeling .blue .need span {background-color:#eefaff; background-position:50% 100%;}

.feeling .kit {background-color:#f15132;}
.feeling .kit .navigator {overflow:hidden; width:30rem; margin:-1rem auto; padding-top:1rem;}
.feeling .kit .navigator li {float:left; width:14rem; height:6.2rem; margin:0 0.5rem; text-align:center;}
.feeling .kit .navigator li a {overflow:hidden; display:block; position:relative; width:100%; height:100%; color:#fff; line-height:6.2rem;}
.feeling .kit .navigator li a span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/img_navigator.png) no-repeat 0 0; background-size:29rem auto;}
.feeling .kit .navigator li a.on span {background-position:0 100%;}
.feeling .kit .navigator li a i {display:block; position:absolute; top:0.1rem; right:3rem; width:0.8rem; height:4.4rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/blt_arrow_right_oragne_ani.gif) no-repeat 0 0; background-size:100% auto;}
.feeling .kit .navigator li a.on {position:relative; z-index:5;}
.feeling .kit .navigator li a.on {
	animation-name:bounce; animation-iteration-count:5; animation-duration:0.7s;
	-webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:0.7s;
}
.feeling .kit .navigator li a.on i {display:none;}
.feeling .kit .navigator li.nav2 a span {background-position:100% 100%;}
.feeling .kit .navigator li.nav2 .on span {background-position:100% 0;}

.rolling .swiper {position:relative; width:88%; margin:0 auto;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:43%; z-index:5; width:6.25%; background-color:transparent;}
.rolling .swiper .btn-prev {left:2%;}
.rolling .swiper .btn-next {right:2%;}
.rolling .swiper .pagination {position:absolute; bottom:5%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center; line-height:0;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:10px; height:7px; margin:0 0.5rem; padding:0; border:0; border-radius:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_pagination.png) no-repeat 50% 0; background-size:10px auto; cursor:pointer; transition:all 0.5s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-position:50% 100%;}

.feeling .get {padding-bottom:15%; background-color:#f15132;}
.feeling .get .vote {position:relative; width:32rem; margin:0 auto; padding-top:2rem; background:#f15132 url(http://webimage.10x10.co.kr/playing/thing/vol002/m/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .get .vote ul {overflow:hidden; width:25.2rem; margin:0 auto;}
.feeling .get .vote ul li {float:left; width:11.5rem; margin:0 0.55rem;; text-align:center;}
.feeling .get .vote ul li button {position:relative; width:100%; height:12.1rem;}
.feeling .get .vote ul li button span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_vote_01.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .get .vote ul li .on span {background-position:50% 100%;}
.feeling .get .vote ul .vote2 button span {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_vote_02.png);}
.feeling .get .vote p {margin-top:0.9rem; color:#333; font-size:1.2rem;}
.feeling .get .btnSubmit {width:16.1rem; height:5.45rem; margin:1rem auto 0;}
.feeling .get .btnSubmit button {position:relative; width:100%; height:100%; }
.feeling .get .btnSubmit button span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_get.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .get .vote .btnSubmit button i {position:absolute;  top:0; right:2.9rem; width:1rem; height:4.4rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/blt_arrow_right_white_ani.gif) no-repeat 0 0; background-size:100% auto;}

.feeling .get .vote .hand {position:absolute; top:13.25rem; right:1.2rem; width:4.6rem; transition:all 1.2s ease-out;}
.feeling .get .vote .flash {animation-iteration-count:2;}

.feeling .get .vote .btnGroup {margin-top:1rem;}
.feeling .get .vote .btnGroup p {position:relative; width:15.3rem; height:4.6rem; margin:0 auto; font-size:1.2rem; line-height:3rem; text-align:center;}
.feeling .get .vote .btnGroup p span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_done_01.png) no-repeat 50% 0; background-size:100% auto;}
.feeling .get .vote .btnGroup .done2 span {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_done_02.png);}

.feeling .tip {position:relative;}
.feeling .tip .btnShare {position:absolute; top:31.36%; right:12.18%; width:28.9%;}

/* css3 animation */
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:-5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:-5px; animation-timing-function:ease-in;}
}

.lightSpeedIn {
	animation-name:lightSpeedIn; animation-timing-function:ease-out; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:1;
	-webkit-animation-name:lightSpeedIn; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;
}
@keyframes lightSpeedIn {
	0% {transform:translateY(-400%);}
	60% {transform:translateY(-100%);}
	80% {transform:translateY(50%);}
	100% {transform:translateY(0%);}
}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateY(-400%);}
	60% {-webkit-transform:translateY(-100%);}
	80% {-webkit-transform:translateY(50%);}
	100% {-webkit-transform:translateY(0%);}
}

.flash {
	animation-name:flash; animation-duration:1.5s; animation-fill-mode:both; animation-iteration-count:10;
	-webkit-animation-name:flash; -webkit-animation-duration:1.5s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:10;
}

@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}

.shake {
	animation-name: shake; animation-duration:0.5s; animation-fill-mode:both; animation-iteration-count:3;
	-webkit-animation-name: shake; -webkit-animation-duration:0.5s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:3;
}
@keyframes shake {
	0%, 100% {transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform:translateX(-10px);}
	20%, 40%, 60%, 80% {transform:translateX(10px);}
}

@-webkit-keyframes shake {
	0%, 100% {-webkit-transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {-webkit-transform:translateX(-10px);}
	20%, 40%, 60%, 80% {-webkit-transform:translateX(10px);}
}
</style>
<script type="text/javascript">
$(function(){
	animation();

	/* title animation */
	$("#animation span").css({"opacity":"0"});
	$("#animation p span").css({"margin-top":"3%"});
	$("#animation .bg").css({"opacity":"0"});
	function animation () {
		$("#animation p .letter1").delay(100).animate({"margin-top":"0", "opacity":"1"},700);
		$("#animation p .letter2").delay(300).animate({"margin-top":"0", "opacity":"1"},700);
		$("#animation p .letter3").delay(600).animate({"margin-top":"0", "opacity":"1"},700);
		$("#animation p .letter3").delay(900).addClass("shake");
		$("#animation .bg").delay(1200).animate({"opacity":"1"},100);
		$("#animation .bubble1").delay(1800).animate({"opacity":"1"},100);
		$("#animation .bubble2").delay(1800).animate({"opacity":"1"},100);
	}

	/* test hide */
	$("#test").hide();

	/* skip to test */
//	$("#btnStart a").on("click", function(e){
//		$("#test").slideDown();
//		event.preventDefault();
//		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},700);
//	});

	/* test */
	$("#test .question").hide();
	$("#test .lyResult").hide();
	$("#test .question:first").show();
//	$("#test .question button").on("click", function(e){
//		if ( $(this).parent(".btnGroup").parent(".question").hasClass("question5")) {
//			$("#test .question5").show();
//			$("#test .lyResult").show();
//		} else {
//			$("#test .question").hide();
//			$(this).parent(".btnGroup").parent(".question").next().show();
//		}
//	});

	/* result */
//	function result() {
//		if ( $("#result .grouping").hasClass("result3")) {
//			$("#result").addClass("blue");
//		} else if ($("#result .grouping").hasClass("result4")){
//			$("#result").addClass("blue");
//		} else {
//			$("#result").removeClass("blue");
//		}
//	}
//	result();

	/* tab on off */
	var mySwiper1, mySwiper2
	mySwiper1 = new Swiper('#rolling #tabcont1 .swiper-container',{
		loop:true,
		speed:800,
		autoplay:1500,
		pagination:"#rolling #tabcont1 .pagination",
		initialSlide:0,
		paginationClickable:true
	});

	mySwiper2 = new Swiper('#rolling #tabcont2 .swiper-container',{
		loop:true,
		speed:800,
		autoplay:1500,
		initialSlide:0,
		pagination:"#rolling #tabcont2 .pagination",
		paginationClickable:true
	});


	var firstview = Math.floor((Math.random()*2)+1);
	$("#rolling .navigator li a").each(function(){
		var thisCont = $(this).attr("href");
		if ( thisCont == "#tabcont"+firstview ){
			$("#rolling .navigator li a").removeClass("on");
			$(this).addClass("on");
			$(".tabcontainer").find(".tabcont").hide();
			$(".tabcontainer").find(thisCont).show();
			if(firstview==1) {
				mySwiper2.stopAutoplay();
			} else {
				mySwiper1.stopAutoplay();
			}
		}
	});

	$("#rolling .navigator li a").click(function(){
		$("#rolling .navigator li a").removeClass("on");
		$(this).addClass("on");
		var thisCont = $(this).attr("href");
		$("#rolling .tabcontainer").find(".tabcont").hide();
		$("#rolling .tabcontainer").find(thisCont).show();
		return false;
	});

	$("#rolling .navigator li.nav1 a").on("click",function(){
		mySwiper1.update(true);
		mySwiper1.slideTo(1);
		mySwiper1.startAutoplay();
		mySwiper2.stopAutoplay();
	});

	$("#rolling .navigator li.nav2 a").on("click",function(){
		mySwiper2.update(true);
		mySwiper2.slideTo(1)
		mySwiper2.startAutoplay();
		mySwiper1.stopAutoplay();
	});

	/* vote */
	$("#vote ul li:first-child button").addClass("on");
	$("#vote ul li button").click(function(){
		$("#vote ul li button").removeClass("on");
		if ( $(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

	function handAnimation() {
		var window_top = $(window).scrollTop();
		var div_top = $("#rolling").offset().top;
		if (window_top > div_top){
			$(".hand").addClass("flash");
			fade ();
		} else {
			$(".hand").removeClass("flash");
		}
	}

	$(function() {
		$(window).scroll(handAnimation);
		handAnimation();
	});

	function fade () {
		$(".feeling .get .vote .hand img").delay(1200).animate({"opacity":"0"},1000);
	}
});

///////////////////////////////////////////////////////////////////

function mySwiper1tab(){
	var mySwiper1tab
	mySwiper1tab = new Swiper('#rolling #tabcont1 .swiper-container',{
		loop:true,
		speed:800,
		autoplay:1500,
		pagination:"#rolling #tabcont1 .pagination",
		initialSlide:0,
		paginationClickable:true
	});
}
function mySwiper2tab(){
	var mySwiper2tab
	mySwiper2tab = new Swiper('#rolling #tabcont2 .swiper-container',{
		loop:true,
		speed:800,
		autoplay:1500,
		initialSlide:0,
		pagination:"#rolling #tabcont2 .pagination",
		paginationClickable:true
	});
}

function restart(){
	$("#resultviewbtn").hide();
	$("#test").hide();
	$("#lyResult").hide();
	$("#result").empty();
	$("#result").hide();
	$("#question2").hide();
	$("#question3").hide();
	$("#question4").hide();
	$("#question5").hide();
	$("#question1").show();
	$("#test").show();
	window.parent.$('html,body').animate({scrollTop:$("#question1").offset().top},700);
}

function jsplayingthing(num,sel){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript74346.asp",
		data: "mode=add&num="+num+"&sel="+sel,
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if(num==1){
					$("#test .question").hide();
					$("#question2").show();
				}else if(num==2){
					$("#test .question").hide();
					$("#question3").show();
				}else if(num==3){
					$("#test .question").hide();
					$("#question4").show();
				}else if(num==4){
					$("#test .question").hide();
					$("#question5").show();
				}else if(num==5){
					$("#test .question5").show();
					$("#test .lyResult").show();
					$("#resultviewbtn").show();
				}else{
					alert('잘못된 접속 입니다.1');
					parent.location.reload();
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<% else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>	
<% end if %>
}

function jsplayingthingresult(){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript74346.asp",
		data: "mode=result",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if (res[1]=="1") {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74347');
					$("#result").empty().html(res[2]);
					$("#result").show();
					$("#nav2tabid").removeClass("on");
					$("#nav1tabid").addClass("on");
					$("#tabcont2").hide();
					$("#tabcont1").show();
					mySwiper1tab();
					$("#vote2btn").removeClass("on");
					$("#vote1btn").addClass("on");
					$('#kitresultnum').val(1);
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="2") {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74348');
					$("#result").empty().html(res[2]);
					$("#result").show();
					$("#nav2tabid").removeClass("on");
					$("#nav1tabid").addClass("on");
					$("#tabcont2").hide();
					$("#tabcont1").show();				
					mySwiper1tab();	
					$("#vote2btn").removeClass("on");
					$("#vote1btn").addClass("on");
					$('#kitresultnum').val(1);
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="3") {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74349');
					$("#result").empty().html(res[2]);
					$("#result").show();
					$("#nav1tabid").removeClass("on");
					$("#nav2tabid").addClass("on");
					$("#tabcont1").hide();
					$("#tabcont2").show();
					mySwiper2tab();
					$("#vote1btn").removeClass("on");
					$("#vote2btn").addClass("on");
					$('#kitresultnum').val(2);
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else if(res[1]=="4") {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74350');
					$("#result").empty().html(res[2]);
					$("#result").show();
					$("#resultviewbtn").show();
					$("#nav1tabid").removeClass("on");
					$("#nav2tabid").addClass("on");
					$("#tabcont1").hide();
					$("#tabcont2").show();
					mySwiper2tab();
					$("#vote1btn").removeClass("on");
					$("#vote2btn").addClass("on");
					$('#kitresultnum').val(2);
					window.parent.$('html,body').animate({scrollTop:$("#result").offset().top},700);
				}else{
					parent.location.reload();
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
		}
	});
<% else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}

function fnkitneed(){
var kitnum = $('#kitresultnum').val();
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript74346.asp",
		data: "mode=kitresult&kitnum="+kitnum,
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				$("#kitbfbtn").empty();
				$("#kitbfbtn").hide();
				$("#kitafterbtn").empty().html(res[2]);
				return;
			}else{
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg);
				if(errorMsg="테스트를 완료 하셔야 신청할 수 있습니다.."){
					window.$('html,body').animate({scrollTop:$("#start").offset().top}, 0);
				}
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
		}
	});
<% else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}


function snschkresult(snsnum) {
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript74346.asp",
		data: "mode=snsresult",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if (res[1]==1) {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74347');
				}else if(res[1]==2) {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74348');
				}else if(res[1]==3) {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74349');
				}else if(res[1]==4) {
					$('#resultlink').val('http://m.10x10.co.kr/event/eventmain.asp?eventid=74350');
				}else{
					parent.location.reload();
				}
				var snpTitleresult = $('#resulttext').val();
				var snpLinkresult = $('#resultlink').val();
				if(snsnum=="fb"){
					if (res[1]==1) {
						popSNSPost('fb','<%= snpTitle %>', '<%= snpLink1 %>','','');
	//					popSNSPost('fb',snpTitleresult, snpLinkresult,'','');
					}else if(res[1]==2) {
						popSNSPost('fb','<%= snpTitle %>', '<%= snpLink2 %>','','');
					}else if(res[1]==3) {
						popSNSPost('fb','<%= snpTitle %>', '<%= snpLink3 %>','','');
					}else if(res[1]==4) {
						popSNSPost('fb','<%= snpTitle %>', '<%= snpLink4 %>','','');
					}else{
						parent.location.reload();
					}
					return false;
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
		}
	});
<% else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}

function fnkitvaluechg(kitval) {
	$('#kitresultnum').val(kitval);
}

function fnteststart() {
<% If IsUserLoginOK() Then %>
	$("#test").slideDown();
	event.preventDefault();
	window.parent.$('html,body').animate({scrollTop:$("#test").offset().top},700);
<% else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% end if %>
}
</script>
	<%' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
	<div class="thingVol002 feeling">
		<div class="section intro">
			<span class="lightSpeedIn"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_persimmon.png" alt="" /></span>
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_help_v1.png" alt="감 떨어지는 계절, 이 시기만 되면 감 떨어지시는 분들! 전처럼 일이 풀리지 않는 분들을 위해 텐바이텐 PLAYing이 당신의 떨어진 감을 잡아드립니다." /></p>
			<div class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/bg_oragnge_01.png" alt="" /></div>
		</div>

		<div class="section topic">
			<div id="animation" class="hgroup">
				<p>
					<span class="letter letter1"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_feeling_01.png" alt="감" /></span>
					<span class="letter letter2"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_feeling_02.png" alt="나와라" /></span>
					<span class="letter letter3"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_feeling_03.png" alt="뚝딱" /></span>
				</p>
				<span class="bubble bubble1"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_heart.png" alt="" class="flash" /></span>
				<span class="bubble bubble2">
					<img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/bg_speech_bubble_02.png" alt="" />
					<i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/img_eyes.gif" alt="" /></i>
				</span>
				<div class="bg"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/bg_persimmon_v1.png" alt="" /></div>
			</div>

			<div class="start">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_check_point.png" alt="체크포인트 이런 사람 모여라! 연애가 뭔지 기억이 안 나는 분, 요즘 따라 팀장님한테 자꾸 불려가는 분, 이성 앞에만 다가가면 얼음이 되는 분, 열심히 하는데 생각보다 잘 안 풀리는 분, 소개팅과는 인연이 아닌 분, 했던 일 또 하고 했던 일 또 하고 했던 일 또... 그런 분" /></p>
				<h3 id="start"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_start.png" alt="나에게 필요한 감 찾으러 가기" /></h3>

				<div id="btnStart" class="btnStart"><a href="" onclick="fnteststart(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_test_start.gif" alt="테스트 스타트" /></a></div>
				<%' for dev msg : 테스트 전에는 숨겨주세요 %>
				<% if myresultCnt = 5 then %>
					<div class="btnResult" id="resultviewbtn" <% if myresultCnt <> 5 then %>style="display:none"<% end if %> ><a href="" onclick="jsplayingthingresult(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_my_result.png" alt="내 결과 보기" /></a></div>
				<% end if %>
			</div>
		</div>

		<%' test %>
		<div id="test" class="section test">
			<input type="hidden" name="resulttext" id="resulttext" value="요즘 나에게 떨어진 감은?">
			<input type="hidden" name="resultlink" id="resultlink" value="http://m.10x10.co.kr/event/eventmain.asp?eventid=74347">
			<!-- question -->
			<div class="question question1" id="question1" style="display:none;">
				<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_test_01.png" alt="재미로 보는 TEST 지금, 당신에게 가장 필요한 감은?" /></h3>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_test_question_01.png" alt="대화를 할 때 당신은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('1','A'); return false;" class="btnA"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_01_a.png" alt="A 가슴뭉클한 영화관" /></button>
					<button type="button" onclick="jsplayingthing('1','B'); return false;" class="btnB"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_01_b.png" alt="B 별빛 가득 바다" /></button>
				</div>
			</div>

			<div class="question question2" id="question2" style="display:none;">
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_test_02.png" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_test_question_02.png" alt="사과는 이렇게 먹는 걸 좋아한다" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('2','A'); return false;" class="btnA"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_02_a.png" alt="A 한 입에 와작" /></button>
					<button type="button" onclick="jsplayingthing('2','B'); return false;" class="btnB"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_02_b.png" alt="B 조각으로 나눠서" /></button>
				</div>
			</div>

			<div class="question question3" id="question3" style="display:none;">
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_test_03.png" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_test_question_03.png" alt="더 끌리는 색 조합은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('3','A'); return false;" class="btnA"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_03_a.png" alt="A 비슷한 색의 조화" /></button>
					<button type="button" onclick="jsplayingthing('3','B'); return false;" class="btnB"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_03_b.png" alt="B 상반된 색의 조화" /></button>
				</div>
			</div>

			<div class="question question4" id="question4" style="display:none;">
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_test_04.png" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_test_question_04.png" alt="요즘! 가고 싶은 장소는?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('4','A'); return false;" class="btnA"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_04_a.png" alt="A 가슴뭉클한 영화관" /></button>
					<button type="button" onclick="jsplayingthing('4','B'); return false;" class="btnB"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_04_b.png" alt="B 컬러풀한 미술관" /></button>
				</div>
			</div>

			<div class="question question5" id="question5" style="display:none;">
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_test_05.png" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_test_question_05.png" alt="내 방 액자에 걸고 싶은 그림은?" /></p>
				<div class="btnGroup">
					<button type="button" onclick="jsplayingthing('5','A'); return false;" class="btnA"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_05_a.png" alt="A 노을 지는 바다" /></button>
					<button type="button" onclick="jsplayingthing('5','B'); return false;" class="btnB"><i></i><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_choice_05_b.png" alt="B 별빛 가득 바다" /></button>
				</div>
			</div>

			<div id="lyResult" class="lyResult" style="display:none;">
				<div class="btnView">
					<a href="" onclick="jsplayingthingresult(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_result_view.png" alt="결과보기" /></a>
				</div>
			</div>
		</div>

		<% If IsUserLoginOK() Then %>
		<div id="result">
		</div>
		<% end if %>

		<!-- kit intro -->
		<div class="section kit">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/tit_kit_v1.png" alt="당신을 위한 감 Kit를 준비했습니다." /></h3>
			<div id="rolling" class="rolling">
				<ul class="navigator">
					<li class="nav1"><a href="#tabcont1" id="nav1tabid"><span></span>연애감 Kit<i></i></a></li>
					<li class="nav2"><a href="#tabcont2" id="nav2tabid"><span></span>업무감 Kit<i></i></a></li>
				</ul>
				<div class="tabcontainer">
					<div id="tabcont1" class="tabcont">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_01_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_01_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_01_03.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_01_04.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_01_05.jpg" alt="" /></div>
								</div>
							</div>
							<div class="pagination"></div>
						</div>
					</div>
					<div id="tabcont2" class="tabcont">
						<div class="swiper">
							<div class="swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_01.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_02.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_03.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_04.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_05.jpg" alt="" /></div>
									<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/img_slide_02_06.jpg" alt="" /></div>
								</div>
							</div>
							<div class="pagination"></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- kit get -->
		<div class="get">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_get.png" alt="당신에게 필요한 감을 신청 해 주세요! 추첨을 통해 총 80분 Kit당 40분에게 해당, 감 떨어지지마 Kit를 드립니다. 한 ID당 1회 신청 가능하며, 응모 기간은 11월 21일부터 12월 5일이며, 당첨자 발표는 12월 6일 화요일입니다." /></p>

			<!--- for dev msg : Kit 신청 -->
			<div id="vote" class="vote">
			<input type="hidden" name="kitresultnum" id="kitresultnum" value="1">
				<fieldset>
					<ul>
						<li class="vote1">
							<button type="button" id="vote1btn" onclick="fnkitvaluechg('1'); return false;"><span></span>연애감 Kit</button>
							<p><p><b><%= lovecnt %></b>명이 신청</p></p>
						</li>
						<li class="vote2">
							<button type="button" id="vote2btn" onclick="fnkitvaluechg('2'); return false;"><span></span>업무감 Kit</button>
							<p><b><%= workcnt %></b>명이 신청</p>
						</li>
					</ul>

					<span class="hand"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/ico_hand.png" alt="" /></span>

					<% if myKitCnt < 1 then %>
						<div class="btnSubmit" id="kitbfbtn">
							<button type="submit" onclick="fnkitneed(); return false;"><span></span>감 Kit 신청하기<i></i></button>
						</div>
					<% end if %>

					<div class="btnGroup" id="kitafterbtn">
						<% if myKitgubun = 1 then %>
							<p class="done1"><span></span>연애감 신청완료</p>
						<% elseif myKitgubun = 2 then %>
							<p class="done2"><span></span>업무감 신청완료</p>
						<% end if %>
					</div>
				</fieldset>
			</div>
		</div>

		<!-- tip -->
		<div class="tip">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_tip.png" alt="당첨 확률 높이는 Tip 여러분! 감 챙기셔야죠. 내 결과 공유하면 당첨확률 UP! 근 텐바이텐에서 구매한 고객이라면 당첨확률 UP! 플레이 리뉴얼을 기다리셨던 고객이라면 당첨확률 UP!" /></p>
			<div class="btnShare"><a href="" onclick="snschkresult('fb'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/btn_share.png" alt="내 결과 공유하기" /></a></div>
		</div>

		<!-- volume -->
		<div class="volume">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol002/m/txt_vol002.png" alt="Volume 2 THING의 사물에 대한 생각 감으로 감을 잡자" /></p>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
	
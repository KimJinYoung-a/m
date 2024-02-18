<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 벗꽃을 찍어요 팡팡팡
' History : 2017-04-07 유태욱 생성
'####################################################
Dim eCode , LoginUserid, vDIdx, totalcnt, myresultcnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66302
Else
	eCode   =  77393
End If

vDIdx = request("didx")
totalcnt = 0
myresultcnt = 0
LoginUserid	= getencLoginUserid()
totalcnt = getevent_subscripttotalcount(eCode,"","","")

if LoginUserid <> "" then 
	myresultcnt = getevent_subscriptexistscount(eCode,LoginUserid,"","","")
end if

%>
<style type="text/css">
.blossomPang button {background-color:transparent;}
.blossomPang .topic {position:relative; padding:24% 0 16%; background:#feced9 url(http://webimage.10x10.co.kr/playing/thing/vol012/m/bg_pink.jpg) 50% 0 no-repeat; background-size:100% auto;}
.blossomPang .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/playing/thing/vol012/m/img_blossom_leaf.png) 50% 0 repeat; background-size:100% auto;}
.blossomPang .title {position:relative; padding:0;}
.blossomPang .title:after {background:none;}
.blossomPang .title span {position:absolute;}
.letter {top:0; left:0; width:100%;}
.pang {left:16.875%; width:17.5%;}
.pang1 {bottom:0;}
.blossomPang .title .pang2 {bottom:8.63%; left:41.56%; animation-delay:0.5s; -webkit-animation-delay:0.5s;}
.blossomPang .title .pang3 {bottom:4.31%; left:65.78%; z-index:5; animation-delay:1s; -webkit-animation-delay:1s;}
.leaf {position:absolute; top:55.75%; right:15.15%; width:4.375%;}
.blossomPang .title + p {margin-top:15%;}
.btnSkip {position:relative; z-index:5; width:49.375%; margin:13% auto 0;}
.btnSkip a {display:block; width:100%; height:100%; background:transparent url(http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_skip.png) 50% 0 no-repeat; background-size:100% auto;}
.btnSkip a:active {background-position:50% 100%;}

.blossomPang .make {background-color:#ffebf1;}
.make {overflow:hidden;}
.make ol li {position:relative;}
.make .before,
.make .after {position:absolute; top:0; left:0; width:100%; height:100%;}
.make .after {display:none;}
.make .object {position:absolute;}
.btnClick {position:absolute; top:0; left:0; width:17.18%; background:url(http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_v1.png) 50% 0 no-repeat; background-size:100% auto;}
.btnClick:active {background-position:50% 100%;}
.btnPang {position:absolute; width:23.75%;}
.ani {position:absolute;}
.step1 .btnClick {top:27.61%; left:53.75%;}
.step1 .btnPang {top:24.6%; left:52.187%;}
.step1 .object {top:33.98%; left:31.4%; width:22.34%;}
.step2 .btnClick {top:7.619%; left:33.125%;}
.step2 .btnPang {top:5.71%; left:31.56%;}
.step2 .object, .step2 .ani {top:11.42%; left:48.125%; width:43.75%;}
.step2 .ani {opacity:0;}
.step2 .ani1 {animation-delay:0.5s; -webkit-animation-delay:0.5s;}
.step2 .ani2 {animation-delay:1s; -webkit-animation-delay:1s;}
.step3 .btnClick {top:31.95%; left:68.43%;}
.step3 .btnPang {top:29.78%; left:66.875%;}
.step3 .object {top:33.91%; left:39.21%; width:24.68%;}
.step4 .btnClick {top:41.9%; left:52.81%;}
.step4 .btnPang {top:39.9%; left:51.25%;}
.step4 .object {top:0; left:53.9%; width:17.968%;}
.step4 .after .object {opacity:0;}
.step4 .ani {top:45.58%; left:22.34%; width:6.4%; opacity:0;}
.step4 .ani1 {animation-delay:0.7s; -webkit-animation-delay:0.7s;}
.step4 .ani2 {top:51.71%; left:36.56%; animation-delay:1.2s; -webkit-animation-delay:1.2s;}
.step4 .ani3 {top:45.34%; left:77.81%; animation-delay:1.8s; -webkit-animation-delay:1.8s;}
.step5 .btnClick {top:58.49%; left:37.18%;}
.step5 .btnPang {top:57.53%; left:35.78%;}
.step5 .ani {top:1.16%; left:-6.09%; width:50.78%; opacity:0;}
.step5 .ani2 {top:0; left:65%; width:43.28%; animation-delay:0.8s;}
.flower {position:absolute; top:5.41%; left:27.18%; width:49.375%;}

.rolling .swiper {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:4.68%; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; position:relative; width:8px; height:8px; margin:0 0.45rem; border:1px solid #fa647e; background-color:transparent; cursor:pointer;}
.rolling .swiper .pagination .swiper-pagination-switch {transform-style:preserve-3d; transition:transform 0.6s ease, opacity 0.6s ease; -webkit-transform-style:preserve-3d; -webkit-transition:-webkit-transform 0.6s ease, opacity 0.6s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#fa647e; transform: rotateY(180deg); -webkit-transform:rotateY(180deg);}
@media all and (min-width:360px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:12px; height:12px;}
}
.rolling .btnNav {position:absolute; top:38%; z-index:5; width:10.78%; padding:10% 0;}
.rolling .btnPrev {left:0;}
.rolling .btnNext {right:0;}

.blossomPang .event {position:relative;}
.btnGet {position:absolute; top:53.875%; left:50%; width:50.15%; margin-left:-25.075%;}
.count {position:absolute; top:86.25%; left:0; width:100%; text-align:center; color:#fff; font-size:1rem;}
.count b {margin:0 0.25rem 0 0.5rem; color:#fefdb0; font-weight:bold;}

.volume {margin-top:0.5rem;}

/* css3 animation */
.snowing {animation:snowing 30s linear 2; -webkit-animation:snowing 30s linear 2;}
@keyframes snowing {
	0% {background-position:50% 0}
	100%{background-position:50% 1000px;}
}
@-webkit-keyframes snowing {
	0% {background-position:50% 0}
	100%{background-position:50% 1000px;}
}
.pulse {animation:pulse 0.5s;}
@keyframes pulse {
	0% {transform:scale(0); opacity:0;}
	100% {transform:scale(1); opacity:1;}
}
.shake {animation:shake 1.5s 1 alternate; -webkit-animation:shake 1.5s 1 alternate;}
@keyframes shake {
	0% {transform:translateX(30px) translateY(-10px);}
	100% {transform:translateX(0) translateY(0);}
}
@-webkit-keyframes shake {
	0% {-webkit-transform:translateX(30px) translateY(-10px);}
	100% {-webkit-transform:translateX(0) translateY(0);}
}

.slideUp {animation:slideUp 1.8s cubic-bezier(0.19, 1, 0.22, 1) forwards; -webkit-animation:slideUp 1.8s cubic-bezier(0.19, 1, 0.22, 1) forwards;}
@keyframes slideUp {
	0% {transform:translateY(10px); opacity:0;}
	100% {transform:translateY(0); opacity:1;}
}
@-webkit-keyframes slideUp {
	0% {-webkit-transform:translateY(10px); opacity:0;}
	100% {-webkit-transform:translateY(0); opacity:1;}
}

.twinkle {animation:twinkle 0.7s 1; animation-fill-mode:both; -webkit-animation:twinkle 0.7s 1; -webkit-animation-fill-mode:both;}
@keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	100% {opacity:1;}
}

.fill {animation:fill 0.8s 1 alternate; -webkit-animation:fill 0.8s 1 alternate;}
@keyframes fill {
	0% {width:0; height:10%;}
	100% {width:100%; height:100%;}
}
@-webkit-keyframes fill {
	0% {width:0; height:10%;}
	100% {width:100%; height:100%;}
}

.scale {animation:scale 1s 1;}
@keyframes scale {
	0% {transform:scale(0);}
	100% {transform:scale(1);}
}
.move {animation:move 3s infinite;}
@keyframes move {
	0% {transform:translateX(10px) translateY(0); opacity:1;}
	100% {transform:translateX(0) translateY(130px); opacity:0;}
}
.up {animation:up 1s 1 cubic-bezier(0.19, 1, 0.22, 1) forwards;}
@keyframes up {
	0% {transform:translateX(0) translateY(20px); opacity:0;}
	100% {transform:translateX(0) translateY(0); opacity:1;}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.blossomPang').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	$("#topic .pang").hide();
	$("#topic .pang").fadeIn("slow");
	$("#topic .pang").addClass("pulse");

	$(window).scroll(function(){
		var position = $(window).scrollTop();
		console.log(position)
		if(position>=5){
			$("#topic .pang").fadeIn("slow");
			$("#topic .pang").addClass("pulse");
		}else{
			$("#topic .pang").fadeOut("fast");
			$("#topic .pang").removeClass("pulse");
		}
	});

	/* skip */
	$("#btnSkip a").on("click", function(e){
		window.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
		return false;
	});

	$(".make .btnClick").on("click", function(e){
		$(this).parent().hide();
		$(this).parent().next().fadeIn();
		$(".btnPang").addClass("scale");
	});
	$(".make .btnPang").on("click", function(e){
		$(this).parent().hide();
		$(this).parent().prev().fadeIn();
	});
	
	$(".step1 .btnClick").on("click", function(e){
		$(".step1 .after .object").show().addClass("shake");
	});
	$(".step2 .btnClick").on("click", function(e){
		$(".step2 .ani").show().addClass("twinkle");
	});
	$(".step3 .btnClick").on("click", function(e){
		$(".step3 .after .object img").show().addClass("fill");
	});
	$(".step4 .btnClick").on("click", function(e){
		$(".step4 .after span").show().addClass("slideUp");
	});
	$(".step5 .btnClick").on("click", function(e){
		$(".step5 .ani").show().addClass("move");
	});

	/* swipe */
	mySwiper = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext'
	});
});

function jsplayingthingresult(){
<% If IsUserLoginOK() Then %>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript77393.asp",
		data: "mode=result",
		cache: false,
		success: function(str) {
			var str = str.replace("undefined","");
			var res = str.split("|");

			if (res[0]=="OK") {
				alert('신청이 완료 되었습니다.');
				$("#recnt").empty().html(res[1]);
				$("#btnGet").addClass(" done");
				$("#btnGet").empty().html(res[2]);
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
	<% If isApp Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>	
<% end if %>
}
</script>
	<%'' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
	<%'' Vol.012 꽃을 찍어요 팡팡팡 : 77393 %>
	<div class="thingVol012 blossomPang">
		<div id="topic" class="seciton topic">
			<div class="bg snowing"></div>
			<p class="title">
				<span class="letter up"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/tit_blossom_pang_01.png" alt="꽃을 찍어요" /></span>
				<span class="pang pang1"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/tit_blossom_pang_02.png" alt="팡" /></span>
				<span class="pang pang2"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/tit_blossom_pang_02.png" alt="팡" /></span>
				<span class="pang pang3"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/tit_blossom_pang_02.png" alt="팡" /></span>
				<span class="leaf"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_leaf.png" alt="" /></span>
				<img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_blank.png" alt="" />
			</p>
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_blossom_pang_v1.png" alt="벚꽃이 팡팡 터지는 요즘, 꽃놀이 사진 찍으셨나요? 일상에서도 팡팡 꽃 피게 해줄 벚꽃 잎 스탬프를 여기저기 찍어보세요! 일상에 꽃이 날리는 좋은 일이 생길 거에요 Blossom Pang kit를 만나보세요" /></p>
			<div id="btnSkip" class="btnSkip">
				<a href="#make"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_skip_white.png" alt="Blossom Pang 만들러 가기"/></a>
			</div>
		</div>

		<div id="make" class="section make">
			<ol>
				<li class="step1">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_make_01.png" alt="꽃잎을 한 잎씩 찍어 꽃 한 송이를 만들어 주세요" /></p>
					<div class="before">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_01_before.png" alt="" /></span>
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_white.png" alt="Click" /></button>
					</div>
					<div class="after">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_01_after.png" alt="" /></span>
						<button type="button" class="btnPang"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_pang.png" alt="Pang" /></button>
					</div>
				</li>
				<li class="step2">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_make_02.png" alt="꽃잎에 나뭇가지 스탬프를 여러 번 찍어주세요" /></p>
					<div class="before">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_02_before.png" alt="" /></span>
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_white.png" alt="Click" /></button>
					</div>
					<div class="after">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_02_after_01.png" alt="" /></span>
						<span class="ani ani1"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_02_after_02.png" alt="" /></span>
						<span class="ani ani2"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_02_after_03.png" alt="" /></span>
						<button type="button" class="btnPang"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_pang.png" alt="Pang" /></button>
					</div>
				</li>
				<li class="step3">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_make_03.png" alt="꽃의 파릇파릇한 잎을 만들어주세요" /></p>
					<div class="before">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_03_before.png" alt="" /></span>
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_white.png" alt="Click" /></button>
					</div>
					<div class="after">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_03_after.png" alt="" /></span>
						<button type="button" class="btnPang"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_pang.png" alt="Pang" /></button>
					</div>
				</li>
				<li class="step4">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_make_04.png" alt="꽃잎을 찍은 후 나뭇가지 스탬프로 꽃받침을 만들어주세요" /></p>
					<div class="before">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_04_before.png" alt="" /></span>
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_white.png" alt="Click" /></button>
					</div>
					<div class="after">
						<span class="object"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_04_after_04.png" alt="" /></span>
						<span class="ani ani1"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_04_after_01.png" alt="" /></span>
						<span class="ani ani2"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_04_after_02.png" alt="" /></span>
						<span class="ani ani3"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_04_after_03.png" alt="" /></span>
						<button type="button" class="btnPang"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_pang.png" alt="Pang" /></button>
					</div>
				</li>
				<li class="step5">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_make_05_v2.jpg" alt="완성된 꽃들 주변에 흩날리는 꽃잎을 만들어주세요" /></p>
					<div class="before">
						<button type="button" class="btnClick"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_click_white.png" alt="Click" /></button>
						<span class="flower"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_flower_v2.png" alt="" /></span>
					</div>
					<div class="after">
						<span class="ani ani1"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_05_after_01.png" alt="" /></span>
						<span class="ani ani2"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_make_05_after_02.png" alt="" /></span>
						<button type="button" class="btnPang"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_pang.png" alt="Pang" /></button>
					</div>
				</li>
			</ol>
		</div>

		<div id="rolling" class="section rolling">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_slide_04.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/img_slide_05.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<div class="seciton kit">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_kit.jpg" alt="BLOSSOM PANG Mini KIT는 미니 꽃잎 스탬프 꽃잎3종 나뭇가지1종 10X10mm, 잉크패드pink 32x32mm, 무지 엽서2장 104x154mm, 미니 색연필 set로 구성되어있습니다." /></p>
		</div>

		<!-- for dev msg : 응모하기 -->
		<div class="seciton event">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_event.png" alt="BLOSSOM PANG KIT로 꽃을 팡팡팡 찍으세요! Blossom kit를 신청해주시면 추첨을 통해 총 70명에게 kit를 드립니다. 응모기간은 4월 10일부터 4월 23일까지며, 당첨자 발표는 4월 24일 월요일입니다. 한 ID당 1회 신청 가능합니다." /></p>
			<% if myresultcnt > 0 then %>
				<!-- 신청 후 -->
				<div class="btnGet" id="btnGet">
					<img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_get_done.png" alt="Blossom Pang Kit 신청완료" />
				</div>
			<% else %>
				<!-- 신청 전 -->
				<div class="btnGet" id="btnGet">
					<button type="button" onclick="jsplayingthingresult(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/btn_get.png" alt="Blossom Pang Kit 신청하기" /></button>
				</div>
			<% end if %>
			<p class="count">총 <b id="recnt"><%= totalcnt %></b>명이 신청했습니다</p>
		</div>

		<!-- volume -->
		<div class="section volume">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol012/m/txt_vol012.gif" alt="Volume 12 Thing의 사물에 대한 생각 일상의 꽃잎을 찍으세요!" /></p>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
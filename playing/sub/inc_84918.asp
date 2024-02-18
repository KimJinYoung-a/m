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
' Description : 플레이띵 Vol.36 오늘 뭐하지?
' History : 2018-03-02 원승현
'####################################################
Dim eCode, vQuery, currenttime, vConfirmCheckToDate
Dim TaroOpenDate, TaroIdx, TaroImgValue, vDIdx

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67511
Else
	eCode   =  84918
End If

currenttime = date()

'// 오늘자 응모데이터 bool
vConfirmCheckToDate = False

vDIdx = request("didx")

'// 오늘자 응모데이터가 있는지 확인한다.
'// sub_opt1 : 응모일자(날짜만)
'// sub_opt2 : db_temp.[dbo].[tbl_playingV36Taro] 에 있는 IDX값
'// sub_opt3 : 이미지 파일명
If IsUserLoginOK() Then
	vQuery = "SELECT sub_opt1, sub_opt2, sub_opt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & getEncLoginUserId & "' And evt_code='"&eCode&"' And convert(varchar(10), regdate, 120) ='"&currenttime&"' "
	rsget.Open vQuery,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vConfirmCheckToDate = True
		TaroOpenDate = rsget("sub_opt1")
		TaroIdx = rsget("sub_opt2")
		TaroImgValue = rsget("sub_opt3")
	End If
	rsget.close
End If

'### SNS 변수선언
Dim snpTitle, snpLink, snpPre, snpTag,  snpImg, kakaotitle, kakaoimage, kakaoimg_width, kakaoimg_height, kakaolink_url 
snpTitle	= "오늘뭐하지?"
snpLink		= "http://10x10.co.kr/playing/view.asp?didx="&vDIdx&""
snpPre		= "10x10 PLAYing"
snpTag 		= "텐바이텐 " & Replace("오늘뭐하지?"," ","")

snpTitle	= Server.URLEncode(snpTitle)
snpLink		= Server.URLEncode(snpLink)
snpPre		= Server.URLEncode(snpPre)


%>
<style type="text/css">
.thingVol036 button {background-color:transparent;}
.topic {position:relative;}
.topic h2 {position:absolute; left:0; top:7.5%; z-index:40; width:100%;}
.topic h2 .t1 {position:absolute; left:0; top:7.5%; z-index:40; width:100%;}
.topic h2 .t2 {position:absolute; left:0; top:7.5%; z-index:40; width:100%; animation:swing .9s ease-in-out; animation-delay:1.1s; transform-origin:60% 100%;}
.topic .img-card {position:absolute; left:50%; top:39%; margin-left:-30%; width:60%; z-index:10; animation:pulse 1 0.5s ; animation-fill-mode:forwards; -webkit-animation-fill-mode:forwards; animation-delay:1s; opacity:0;}
.topic .arrow {display:block; position:absolute; left:50%; top:88%; margin-left:-10%; width:20%; animation:bounce .8s 30; z-index:10;}
.section2 {position:relative;}
.section2 .card-shuffle-wrap {position:absolute; left:0; top:0; width:100%;}
.section2 .card-shuffle-wrap .btn-mixed {position:absolute; right:10%; top:90%; width:30%; outline:none; z-index:5;}
.section2 .card-shuffle {position:relative; width:100%; margin-top:49%;}
.section2 .card-shuffle li {float:left; position:absolute; left:50%; top:0; width:60%; margin-left:-30%; transition:all 0.5s cubic-bezier(0.68,-.55,.265,1.55); perspective:1000; -ms-transform:perspective(1000px); -moz-transform:perspective(1000px); -ms-transform-style:preserve-3d; -moz-transform-style:preserve-3d; z-index:5; transform-origin:50% 50%;}
.section2 .card-shuffle li + li {margin-left:-40%; opacity:0.8; z-index:4;}
.section2 .card-shuffle li + li + li {margin-left:-75%;  opacity:0.5; z-index:1;}
.section2 .card-shuffle li + li + li + li {margin-left:35%;  opacity:0.5; z-index:1;}
.section2 .card-shuffle li p {position:absolute; left:50%; top:0; width:100%; margin-left:-50%;}
.section2 .card-shuffle li.ani1 {margin-left:-30%; transform:rotate(-2deg); opacity:0.8; z-index:4;}
.section2 .card-shuffle li.ani2 {margin-left:-30%; transform:rotate(-5deg);  opacity:0.2; z-index:2;}
.section2 .card-shuffle li.ani3 {margin-left:-30%; transform:rotate(3deg);  opacity:0.4; z-index:1;}
.section2 .card-shuffle li .front {z-index:2; transform:rotateY(0deg);}
.section2 .card-shuffle li .back {width:100%; opacity:0; transform:rotateY(180deg) translateY(-20%);}
.section2 .card-shuffle li .back span {display:block; position:absolute; left:-20%; top:-6%; width:57%; background:url(http://webimage.10x10.co.kr/playing/thing/vol036/m/img_tooltip.png) 50% 0 no-repeat; background-size:100% auto; font-size:1.62rem; font-family:'malgun gothic', dotum, sans-serif; line-height:5.3; color:#fff; text-align:center; padding-right:1.2rem;}
.section2 .card-shuffle .flipper {position:relative; width:70%; margin-left:-35% !important; margin-top:-2.5%; transition:0.6s; transform-style:preserve-3d; transform:rotateY(180deg); z-index:10;}
.section2 .card-shuffle .flipper p.front {box-shadow:none; display:none;}
.section2 .card-shuffle .flipper p.back {animation:flip .6s 1; animation-fill-mode:both;}
.section2 .card-spread li:after {display:block; position:absolute; left:50%; top:0; width:100%; height:100%; margin-left:-138px; background:rgba(0,0,0,.6); content:''; border-radius:19px 19px;}
.section2 .card-spread li.flipper:after {display:none;}
.section2 .btn-spread {position:absolute; left:50%; bottom:15%; margin-left:-25%; width:50%;}
.section2 .btn-card-view {position:absolute; left:50%; bottom:5%;  margin-left:-25%; width:50%; z-index:10;}
.section2 .btn-share {display:none; position:absolute; left:50%; bottom:15%;  margin-left:-50%; width:100%; z-index:10;}
.section2 .txt-noti {display:none; position:absolute; left:50%; bottom:11%;  margin-left:-50%; width:100%; z-index:10;}
.section2 .dimed {display:none; position:absolute; left:0; top:0; bottom:0; width:100%; height:100%; background-color:rgba(0,0,0,.6); z-index:8;}
.section3 {position:relative;}
.section3 h3 {display:block; position:absolute; left:50%; top:12.5%; margin-left:-31%; width:19.5%; text-align:center; font-size:1.62rem; color:#000;}
.section3 .card-view {position:absolute; left:0; top:22%; width:100%;}
.section3 .card-view .swiper-slide {padding-top:0.6rem;}
.section3 .card-view .swiper-slide p {position:absolute; left:50%; top:0; width:50%; margin-left:-25%; background:url(http://webimage.10x10.co.kr/playing/thing/vol036/m/bg_date_box.png) 50% 0 no-repeat; background-size:100% auto; font-size:1.28rem; font-family:'malgun gothic', dotum, sans-serif; line-height:2; color:#fff; text-align:center;}
.section3 .btn-card-close {position:absolute; left:50%; bottom:8%; width:50%; margin-left:-25%;}
.final {position:relative;}
.final a {display:block; position:absolute; left:50%; bottom:18%; margin-left:-25%; width:50%; animation:shake 3s 50; animation-fill-mode:both;}
@keyframes swing {
	0%, 100% {transform:rotate(-5deg);}
	30%, 50%, 70% {transform:rotate(-5deg);}
	20%, 40%, 60%, 80% {transform:rotate(10deg);}
}
@keyframes pulse {
    0% {transform:scale(1.5); opacity:0;}
    100% {transform:scale(1); opacity:1;}
}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(8px); animation-timing-function:ease-in;}
}
@keyframes shake {
	0%, 100% {transform:translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform:translateX(-3px);}
	20%, 40%, 60%, 80% {transform:translateX(3px);}
}
@keyframes flip {
	from {opacity:0;}
	60%, 100% {opacity:1;}
}
</style>
<script type="text/javascript">
$(function(){
//	var position = $('.thingVol036').offset(); // 위치값
//	$('html,body').animate({ scrollTop : position.top },300); // 이동

	function checkVisible( elm, eval ) {
		eval = eval || "object visible";
		var viewportHeight = $(window).height(),
			scrolltop = $(window).scrollTop(),
			y = $(elm).offset().top,
			elementHeight = $(elm).height();
		if (eval == "object visible") return ((y < (viewportHeight + scrolltop)) && (y > (scrolltop - elementHeight)));
		if (eval == "above") return ((y < (viewportHeight + scrolltop)));
	}

	titleAnimation();
	$(".topic h2 .t1").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2 .t1").delay(100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}

	<%'// 오늘자 응모 데이터가 있으면 그냥 펼쳐준다. %>
	<% if vConfirmCheckToDate then %>
		$("#taroResult").empty().html("<span><%=TaroOpenDate%></span><img src='http://webimage.10x10.co.kr/playing/thing/vol036/m/<%=TaroImgValue%>' alt='' />");
		cardMix();
		$(".btn-mixed").fadeOut();
		setTimeout(function() {
			$(".card-shuffle li:first-child").addClass('flipper');
			$(".btn-spread").hide();
			$(".btn-share").fadeIn();
			$(".txt-noti").fadeIn();
			$(".dimed").fadeIn();
		}, 50);
	<% else %>
		$(".btn-mixed").css({"opacity":"0"});
		var isVisible = false;
		$(window).on('scroll',function() {
			if (checkVisible($('.section2'))&&!isVisible) {
				cardMix();
				$(".btn-mixed").delay(1000).animate({"opacity":"1"},700);
				isVisible=true;
			}
		});
	<% end if %>

	$('.btn-spread button').click(function() {
		<% if IsUserLoginOK() then %>
			<% if currenttime >= "2018-03-02" And currenttime < "2018-03-17" then %>
				<% if vConfirmCheckToDate then %>
					alert("금일은 이미 취미를 점치셨습니다.");
					return false;
				<% else %>
					$.ajax({
						type:"GET",
						url:"/playing/sub/doEventSubscript84918.asp?mode=add",
						dataType: "text",
						async:false,
						cache:true,
						success : function(Data, textStatus, jqXHR){
								//$str = $(Data);
								res = Data.split("||");
								if (jqXHR.readyState == 4) {
									if (jqXHR.status == 200) {
										if(Data!="") {
											if (res[0]=="ok")
											{
												$("#taroResult").empty().html(res[1]);
												$(".btn-mixed").fadeOut();
												setTimeout(function() {
													$(".card-shuffle li:first-child").addClass('flipper');
													$(".btn-spread").hide();
													$(".btn-share").fadeIn();
													$(".txt-noti").fadeIn();
													$(".dimed").fadeIn();
												}, 50);
											}
											else
											{
												alert(res[1]);
												document.location.reload();
											}
										} else {

										}
									}
								}
						},
						error:function(jqXHR, textStatus, errorThrown){
							alert("잘못된 접근 입니다.");
							return false;
						}
					});
				<% end if %>
			<% else %>
				alert("이벤트 응모기간이 아닙니다.");
				return false;
			<% end if %>
		<% else %>
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
				return false;
			<% end if %>
		<% end if %>
	});

	function cardMix() {
		$(".card-shuffle li").each(function(e) {
			setTimeout(function() {
				$(".card-shuffle li").eq(e).attr("class", "ani" + e);
			}, e * 150);
		});
	}

	$('.btn-mixed').click(function() {
		$(".card-shuffle li").each(function(e) {
//			if($(this).is("[class^='ani'")){
				$(".card-shuffle li").eq(e).attr("class", "");
				setTimeout(function() {
					$(".card-shuffle li").eq(e).attr("class", "ani" + e);
				}, e * 150);
//			} else {
//				cardMix();
//			};
		});
	});

	$(".section3").hide();
	$(".btn-card-view").on("click", function(){
		$.ajax({
			type:"GET",
			url:"/playing/sub/doEventSubscript84918.asp?mode=RecentView",
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
					//$str = $(Data);
					res = Data.split("||");
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								if (res[0]=="ok")
								{
									$("#RecentViewTaroCard").empty().html(res[1]);
									$(".section3").fadeIn();
									window.$('html,body').animate({scrollTop:$(".section3").offset().top},500);
									var cardSwiper1 = new Swiper('.section3 .swiper-container',{
										loop:false,
										slidesPerView:3,
										centeredSlides:true,
										spaceBetween:30,
										speed:600
									});
								}
								else
								{
									alert(res[1]);
								}
							} else {

							}
						}
					}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
	});

	$(".btn-card-close").on("click", function(){
		$(".section3").hide();
//		window.$('html,body').animate({scrollTop:$(".section2").offset().top},500);
	});
});
</script>

<div class="thingVol036">
	<div class="topic">
		<h2>
			<span class="t1"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/tit_taro1.png" alt="오늘 뭐하지" /></span>
			<span class="t2"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/tit_taro2.png" alt="?" /></span>
		</h2>
		<span class="img-card"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_card.png" alt="" /></span>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/bg_head.png" alt="매일 반복되는 일상, 하루에 오직 자신을 위해 보내는 시간이 있나요? 행복은 나 자신을 위한 시간 속에 있는지도 모릅니다." /></p>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/txt_section1_v2.png" alt="오늘 무엇을 하며 보낼지 취미를 점쳐보세요! 여러분들도 매일 취미 생활을 할 수 있습니다. 행운 취미 타로가 여러분들을 소소하지만 확실한 행복으로 만들어 줄 거에요! 오늘 나의 행운의 취미는?" /></p>
		<span class="arrow"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_btm_arrwo.png" alt="" /></span>
	</div>
	<div class="section2">
		<img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/bg_section2_v2.png" alt="행운의 취미 타로 - 매일 하루에 하나씩 취미를 점쳐보세요! 취미: 금전적 목적이 아닌 기쁨을 얻는 활동 [출처: 위키백과] / 오늘 어떤 일로 행복한 시간을 가질지 고민하면서 섞어주세요!" />
		<div class="card-shuffle-wrap">
			<ul class="card-shuffle">
				<li class="card0">
					<p class="front"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_card2.png" alt="" /></p>
					<%' 랜덤카드 이미지 노출(img_card_view01.png ~ img_card_view24.png) %>
					<p class="back" id="taroResult"></p>
				</li>
				<li class="card1"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_card2.png" alt="" /></p></li>
				<li class="card2"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_card2.png" alt="" /></p></li>
				<li class="card3"><p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/img_card2.png" alt="" /></p></li>
			</ul>
			<button type="button" class="btn-mixed"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_mixed.png" alt="섞기" /></button>
		</div>
		<p class="btn-spread"><button type="button"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_choice.png" alt="뽑기" /></button></p>
		<p class="btn-share"><button type="button" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_today_share.png" alt="오늘의 내 취미 공유하기" /></button></p>
		<p class="txt-noti"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/txt_once.png" alt="1일 1회 뽑기 가능(내일도 참여하세요!)" /></p>
		<%' 지난 카드 있는 경우만 노출 %><p class="btn-card-view"><button><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_card_view.png" alt="지난 카드 확인하기" /></button></p>
		<div class="dimed"></div>
	</div>
	<div class="section3">
		<h3><%=request.Cookies("uinfo")("musername")%></h3>
		<div class="card-view">
			<div class='swiper-container' style='width:210%; margin-left:-55%; margin-right:-55%;' id="RecentViewTaroCard">		
			</div>
		</div>
		<p class="btn-card-close"><button type="button"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_card_hide.png" alt="지난 카드 접어두기" /></button></p>
		<img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/bg_section3.png" alt="" />
	</div>
	<div class="final">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/txt_section4.png" alt="오늘 뽑은 취미 대신 다른 취미를 만나고 싶다면? 더 확실하게 원하는 취미를 골라보세요!" /></p>
		<% If IsApp="1" Then %>
			<a href="" onclick="fnAPPpopupEvent('84918');return false;" class="tMar30 btnShake"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_another_shopping.png" alt="다른 취미 쇼핑하기" /></a>
		<% Else %>
			<a href="/event/eventmain.asp?eventid=84918" class="tMar30 btnShake"><img src="http://webimage.10x10.co.kr/playing/thing/vol036/m/btn_another_shopping.png" alt="다른 취미 쇼핑하기" /></a>
		<% End If %>
	</div>
</div>


<!-- #include virtual="/lib/db/dbclose.asp" -->
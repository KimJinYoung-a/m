<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'########################################################
' PLAY #19 Holiday Sticker
' 2015-04-17 원승현 작성
'########################################################
Dim eCode, userid, vQuery
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61756
Else
	eCode   =  61577
End If

userid = getloginuserid()

Dim strSql, seaCnt, sakuraCnt, overseasCnt

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='sea' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		seaCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='sakura' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		sakuraCnt = rsget(0)
	End IF
	rsget.close

	vQuery = " Select count(userid) From [db_event].dbo.tbl_event_subscript Where evt_code='"&eCode&"' And sub_opt3='overseas' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		overseasCnt = rsget(0)
	End IF
	rsget.close

%>
<head>
<style type="text/css">
.mPlay20150420 {}
 img {width:100%; vertical-align:top;}
.mPlay20150420 img {width:100%; vertical-align:top;}
.holidaySticker {padding-bottom:10%; background:#d8f1f9;}
.holidaySticker a {display:block; width:64%; margin:0 auto;}
.goTravel {position:relative; background:#e8e8e6;}
.goTravel .slideTab {overflow:visible !important; width:320px; margin:0 auto;}
.goTravel .slideTab .slidesjs-pagination {overflow:hidden; position:absolute; left:50%; top:8%; width:260px; margin-left:-130px; z-index:40;}
.goTravel .slideTab .slidesjs-pagination li {float:left; width:74px; margin:0 6px;}
.goTravel .slideTab .slidesjs-pagination li a {display:block; width:100%; background-position:left top; background-repeat:no-repeat; background-size:100% 200%;}
.goTravel .slideTab .slidesjs-pagination li a.active {background-position:left bottom;}
.goTravel .slideTab .slidesjs-pagination li.p01 a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150420/tab01.png)}
.goTravel .slideTab .slidesjs-pagination li.p02 a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150420/tab02.png)}
.goTravel .slideTab .slidesjs-pagination li.p03 a {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150420/tab03.png)}
.applyEvent {padding-bottom:12%; background:#fff1d4;}
.applyEvent .holidayCont {position:relative;}
.applyEvent .holidayCont li {position:absolute; top:3%; width:31%; height:94%; text-align:center;}
.applyEvent .holidayCont li input {display:inline-block; position:absolute; left:50%; top:46%; width:16px; height:16px; margin-left:-8px; z-index:40;}
.applyEvent .holidayCont li label {display:inline-block; position:absolute; left:0; top:0%; width:100%; height:73%; z-index:30; color:transparent;}
.applyEvent .holidayCont li.type01 {left:2.5%;}
.applyEvent .holidayCont li.type02 {left:34.5%;}
.applyEvent .holidayCont li.type03 {right:2.5%;}
.applyEvent .holidayCont li .count {position:absolute; left:0; bottom:8%; width:100%; font-size:11px; line-height:1.2; font-weight:bold; color:#000;}
.applyEvent .holidayCont li .count strong {padding-right:2px;}
.applyEvent .holidayCont li.type01 .count strong {color:#1487c8;}
.applyEvent .holidayCont li.type02 .count strong {color:#eb57a0;}
.applyEvent .holidayCont li.type03 .count strong {color:#73a301;}
.applyEvent .btnApply {width:80%; margin:0 auto; padding-top:5%;}
.swiper {position:relative; overflow:hidden; width:320px; margin:0 auto;}
.swiper .swiper-container {width:100%;}
.swiper button {position:absolute; top:39%; width:12.5%; background:transparent; z-index:30;}
.swiper .arrowLeft {left:2%;}
.swiper .arrowRight {right:2%;}
.swiper .hPaging {position:absolute; left:0; bottom:4%; width:100%; z-index:30; text-align:center;}
.swiper .hPaging span {display:inline-block; width:16px; height:5px; margin:0 3px; border-radius:5px; background:#fff;}
.swiper .hPaging span.swiper-active-switch {background:#676767;}
@media all and (min-width:375px){
	.swiper {width:375px;}
}
@media all and (min-width:480px){
	.applyEvent .holidayCont li .count {font-size:17px;}
	.swiper {width:480px;}
	.goTravel .slideTab {width:480px;}
	.goTravel .slideTab .slidesjs-pagination {width:380px; margin-left:-190px;}
	.goTravel .slideTab .slidesjs-pagination li {width:110px;}
}
@media all and (min-width:568px){
	.swiper {width:568px;}
	.goTravel .slideTab {width:568px;}
}
@media all and (min-width:640px){
	.swiper {width:640px;}
	.goTravel .slideTab {width:640px;}
}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.hPaging',
		speed:600,
		autoplay:false,
		autoplayDisableOnInteraction: true,
		prevButton: '.arrowLeft',
		nextButton: '.arrowRight'
	});
	$('.arrowLeft').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.arrowRight').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$(".slideTab").slidesjs({
		width:"640", 
		height:"760",
		navigation:false,
		pagination:{effect:"fade"},
		play: {interval:4500, effect:"fade", auto:true},
		effect:{fade: {speed:800, crossfade:true}
		},
		callback: {
			complete: function(number) {
				var pluginInstance = $('.slideTab').data('plugin_slidesjs');
				setTimeout(function() {
					pluginInstance.play(true);
				}, pluginInstance.options.play.interval);
			}
		}
	});
	$('.slideTab .slidesjs-pagination li:nth-child(1)').addClass('p01');
	$('.slideTab .slidesjs-pagination li:nth-child(2)').addClass('p02');
	$('.slideTab .slidesjs-pagination li:nth-child(3)').addClass('p03');
	$('.slideTab .slidesjs-pagination li a').text('').append('<img src="http://webimage.10x10.co.kr/playmo/ground/20150420/tab_blank.gif" alt="" />');
});
</script>
<script type="text/javascript">
<!--

	function jsSubmit(){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>
		if($(':radio[name="votet"]:checked').length < 1){
			alert('가고 싶은 그 곳을 선택해주세요!');						
			return false;
		}
	   document.frmcom.votetour.value = $(':radio[name="votet"]:checked').val();
	   document.frmcom.submit();

	}
//-->
</script>
</head>
<body>
<div class="mPlay20150413">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/tit_holiday_sticker.jpg" alt="Holiday Sticker" /></h2>
	<div class="holidaySticker">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/txt_sticker_info.jpg" alt="업무는 쌓이고, 주말로는 피로가 회복되지 않는다… 나를 위한 시간은 점점 줄어들고, 남을 위한 시간만 남을 때! 어디론가 훌쩍 떠나서 모든 걸 잊고 쉬고 싶지 않나요? 당장은 떠날 수 없는 이유들이 많지만, 내 방 혹은 사무실 한편에 휴가지를 옮겨 둔다면 어떨까요. 그래도 조금은 위안을 얻고, 희망을 품고 일할 수 있지 않을까요! 텐바이텐 플레이에서는 지친 직장인들에게 작은 위로가 되는 휴가 스티커를 준비했습니다! 여러분께 힘이 되는 스티커가 되길 바랍니다!" /></p>
		<% if isApp=1 then %>
			<a href="" onclick="fnAPPpopupBrand('hitchhiker');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/btn_hitchhiker.gif" alt="히치하이커 보러가기" /></a>
		<% Else %>
			<a href="/hitchhiker/" target="_blank"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/btn_hitchhiker.gif" alt="히치하이커 보러가기" /></a>
		<% End If %>
	</div>
	<div class="goTravel">
		<div class="slideTab">
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_move01.gif" alt="" />
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_move02.gif" alt="" />
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_move03.gif" alt="" />
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_sample.jpg" alt="발 아래 뿐만 아니라 눈 앞에도 펼쳐지는 휴가지" /></div>
	<!-- 이벤트 참여 -->
	<div class="applyEvent">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/tit_event.gif" alt="EVENT - 어디론가 훌쩍 떠나고 싶은 이 순간, 가고 싶은 그 곳을 선택해보세요!" /></h3>
		<div class="holidayCont">
			<ul>
				<li class="type01">
					<div>
						<label for="select01">푸른 바다로 출발!</label>
						<input type="radio" id="select01" name="votet" value="sea"  />
						<p class="count">총 <strong><%=FormatNumber(seaCnt, 0)%></strong>명이<br />여행 중입니다.</p>
					</div>
				</li>
				<li class="type02">
					<div>
						<label for="select02">화사한 벚꽃길로 출발!</label>
						<input type="radio" id="select02" name="votet" value="sakura"  />
						<p class="count">총 <strong><%=FormatNumber(sakuraCnt, 0)%></strong>명이<br />여행 중입니다.</p>
					</div>
				</li>
				<li class="type03">
					<div>
						<label for="select03">새로운 해외로 출발!</label>
						<input type="radio" id="select03" name="votet" value="overseas"  />
						<p class="count">총 <strong><%=FormatNumber(overseasCnt, 0)%></strong>명이<br />여행 중입니다.</p>
					</div>
				</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_select_type.jpg" alt="" /></p>
		</div>
		<p class="btnApply"><a href="" onclick="jsSubmit();return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/btn_apply.gif" alt="응모하기" /></a></p>
	</div>
	<form name="frmcom" method="post" action="doEventSubscript61577.asp" style="margin:0px;">
		<input type="hidden" name="votetour">
	</form>
	<!--// 이벤트 참여 -->
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_slide01.jpg" alt="스티커 이미지1" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_slide02.jpg" alt="스티커 이미지2" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/img_slide03.jpg" alt="스티커 이미지3" /></div>
			</div>
			<div class="hPaging"></div>
		</div>
		<button type="button" class="arrowLeft"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/btn_prev.png" alt="이전" /></button>
		<button type="button" class="arrowRight"><img src="http://webimage.10x10.co.kr/playmo/ground/20150420/btn_next.png" alt="다음" /></button>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
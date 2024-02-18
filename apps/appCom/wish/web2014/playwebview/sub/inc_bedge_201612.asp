<script type="text/javascript">
$(function(){
	checkWidth();
	function checkWidth() {
		var boxWidth = $(".thingthing .hgroup").width();
		$(".thingthing .hgroup").css({"width":boxWidth, margin:"0 0 0"+"-"+($(".thingthing .hgroup").width() / 2)+"px"});
	}
	$(window).resize(function() {
		checkWidth();
	});
	var swiper1 = new Swiper("#thingRolling .swiper-container", {
		pagination:"#thingRolling .paginationDot",
		paginationClickable:true,
		loop:true,
		speed:800
	});
});
</script>
<article class="playDetailV16 thingthing">
	<div class="hgroup" style="margin: 0px 0px 0px -156px; width: 312px;">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>12월 THING</span></em>
			<p class="id">텐바이텐 X ed** 고객님</p>
			<h2>내 이름은 <b style="color:#03ac79;">말양말양</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container swiper-container-horizontal">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161209120402_0c026.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161209133215_0p156.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161209131151_0z516.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#03ac79;">
			<p>나는 작지만 큰마음을 가졌어요.<br>산타할아버지는 이런 나에게<br>선물 전달하는 일을 부탁하기도 한답니다.<br>세상 모든 걸 따뜻하게 담을 수 있는<br>나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#03ac79; color:#03ac79;">스말양</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">따숩단말양</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">속삭(續sock)</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">크리스말이</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">양말양</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">계란말이</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">바리바리</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">양말이란말이양말</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">냥마리냥</span></li>
				<li><span style="border-color:#03ac79; color:#03ac79;">산타의잃어버린양말</span></li>
			</ul>
		</div>
	</div>
</article>
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
	<div class="hgroup">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>08월 THING</span></em>
			<p class="id">텐바이텐 X  yys**** 고객님</p>
			<h2>내 이름은 <b style="color:#0080c9;">달군</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170811163122_0w226.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170811160258_0g586.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170811164641_0p416.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#0080c9;">
			<p>바쁘다 바뻐!<br> 손부채가 바빠지는 이 여름.<br> 무더운 여름의 열기를 식혀주는 <br> 달콤한 나의 이름을 지어주세요!<br> </p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#0080c9; color:#0080c9;">나이스크림</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">아이라이크림</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">어른’s크림</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">달콤달콘</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">내마음에두콘두콘</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">!scream</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">콘닥콘닥</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">두입</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">이맘때</span></li>
				<li><span style="border-color:#0080c9; color:#0080c9;">니입속에저장</span></li>
			</ul>
		</div>
	</div>
</article>
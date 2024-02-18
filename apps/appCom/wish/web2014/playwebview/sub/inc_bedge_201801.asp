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
			<em class="month"><span>1월 THING</span></em>
			<p class="id">텐바이텐 X jwk**** 고객님</p>
			<h2>내 이름은 <b style="color:#5aa1d8;">복이왔당개</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171229144459_0h596.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171229144304_0e046.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171229145028_0c286.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#5aa1d8;">
			<p>텐바이텐에서 디자인한 THING뱃지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">황개박이</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">박스발견</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">개프라이즈</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">내복댕이</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">택배왔독설레개</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">개프트</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">개탔당</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">백독(10x10)</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">개인박스</span></li>
				<li><span style="border-color:#5aa1d8; color:#5aa1d8;">열여덟개</span></li>
			</ul>
		</div>
	</div>
</article>
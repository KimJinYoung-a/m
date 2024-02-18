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
			<em class="month"><span>02월 THING</span></em>
			<p class="id">텐바이텐 X znzlak****고객님</p>
			<h2>내 이름은 <b style="color:#8f59d1;">띵띵빵빵</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170203144858_0g586.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170203144405_0f056.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170203144914_0o146.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#8f59d1;">
			<p>붕붕붕 =33<br>설렘을 가득 싣고 달리는<br>작은 자동차입니다.<br>새 출발을 위해 시동을 거는<br>나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">킵카 앤 캐리온</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">출발드림카</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">전방설렘주의</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">에블바리새출바리</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">붕 샤카라카°</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">따붕</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">고고thing</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">너이름이모닝?</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">붕고차</span></li>
				<li><span style="border-color:#8f59d1; color:#8f59d1;">비비디바비디붕</span></li>
			</ul>
		</div>
	</div>
</article>
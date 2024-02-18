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
			<em class="month"><span>10월 THING</span></em>
			<p class="id">텐바이텐 X ed** 고객님</p>
			<h2>내 이름은 <b style="color:#6ccfc9;">아임오케익</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171013115249_0x496.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171013120120_0u206.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171013130341_0p416.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#6ccfc9;">
			<p>텐바이텐에서 디자인한 THING.뱃지는<br>매달 이름짓기 이벤트를 통해 <br>100개 한정 제작됩니다.<br>10월 THING뱃지는 지난 응모기간동안<br>아임오케익으로 이름이 지어졌습니다. :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">베리구름</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">나이스케키</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">나이스베리</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">베리그뤠잇</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">stomaCAKE</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">아기딸기삼형제</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">달다루</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">한딸기케익하실래예</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">생일빵</span></li>
				<li><span style="border-color:#6ccfc9; color:#6ccfc9;">빵할아버지구름모자</span></li>
			</ul>
		</div>
	</div>
</article>
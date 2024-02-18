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
			<em class="month"><span>11월 THING</span></em>
			<p class="id">텐바이텐 X  ksr**** 고객님</p>
			<h2>내 이름은 <b style="color:#fdbc3f;">사랑의뱃토리</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171103105144_0s446.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171103105941_0p416.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171103105157_0f576.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#fdbc3f;">
			<p>텐바이텐에서 디자인한 THING.뱃지는<br>매달 이름짓기 이벤트를 통해 <br>100개 한정 제작됩니다.<br>11월 THING뱃지는 지난 응모기간동안<br>사랑의뱃토리로 이름이 지어졌습니다. :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">다람쥐마카롱</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">도토맆(leaf)</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">도토리버찌</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">웃토리</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">(:D)otori</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">아리가토리</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">산골시 도토리</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">He’s토리</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">김상수</span></li>
				<li><span style="border-color:#fdbc3f; color:#fdbc3f;">다람지밥</span></li>
			</ul>
		</div>
	</div>
</article>
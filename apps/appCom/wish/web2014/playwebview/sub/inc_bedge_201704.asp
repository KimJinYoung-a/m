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
	<div class="hgroup" style="margin: 0px 0px 0px -185px; width: 370px;">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>04월 THING</span></em>
			<p class="id">텐바이텐 X go****</p>
			<h2>내 이름은 <b style="color:#44c0e2;">봄빨간화분이</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170331112326_0a266.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170331111138_0m386.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170331105931_0f316.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#44c0e2;">
			<p>킁킁. 싱그러운 풀꽃 냄새가 느껴지나요?<br>하늘을 뒤덮은 미세먼지로<br>봄을 만나기 어렵다면<br>작은 반려식물과 함께하는 건 어때요?<br>봄을 담은 화분, 나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">내가기른그린</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">봄그레</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">봄이레옹</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">스프링캔</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">잇봄만개</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">춘(春)데레</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">풀라워</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">풀하우스</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">좋초</span></li>
				<li><span style="border-color:#44c0e2; color:#44c0e2;">co2줄게o2다오</span></li>
			</ul>
		</div>
	</div>
</article>
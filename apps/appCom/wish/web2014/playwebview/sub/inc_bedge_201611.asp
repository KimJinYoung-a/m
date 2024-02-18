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
	<div class="hgroup" style="margin: 0px 0px 0px -154px; width: 308px;">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>11월 THING</span></em>
			<p class="id">텐바이텐 X seo**** 고객님</p>
			<h2>내 이름은 <b style="color:#f74b39;">포구미</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container swiper-container-horizontal">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161117200033_0h335.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161114214014_0o142.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2016/7/20161114213957_0f572.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#f74b39;">
			<p>나는 무척이나 따뜻한 마음을 가졌어요.<br>기분이 삐쭉 빼쭉 할 때<br>나를 두 손으로 꼭 감싸면<br>기분이 사르르~ 헤~</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#f74b39; color:#f74b39;">구름한스푼</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">따뜨텐</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">따끈ing</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">미스터37씨</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">기분풀잔</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">김모락씨</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">안경에안개</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">후아후아</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">컵힝</span></li>
				<li><span style="border-color:#f74b39; color:#f74b39;">따따시</span></li>
			</ul>
		</div>
	</div>
</article>
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
			<em class="month"><span>05월 THING</span></em>
			<p class="id">텐바이텐 X lm** 고객님</p>
			<h2>내 이름은 <b style="color:#ff5700;">달릴레옹</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170428105237_0l376.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170428105906_0g066.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170428105253_0b536.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#ff5700;">
			<p>슈웅 ~ <br>빠르고 우아한 등장! <br>나는 스피드를 즐기는<br>롤러스케이트입니다.<br>날씨 좋은 날, 신나게 달려보자구요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#ff5700; color:#ff5700;">놀러스케이트</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">로라랜드</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">날아라슈케이트</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">달리슈</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">달로라</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">롤러왕</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">굴러가기좋은날씨</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">슈피드</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">내가제일잘나가</span></li>
				<li><span style="border-color:#ff5700; color:#ff5700;">나이씽</span></li>
			</ul>
		</div>
	</div>
</article>
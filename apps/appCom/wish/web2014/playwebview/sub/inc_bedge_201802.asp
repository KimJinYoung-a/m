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
			<em class="month"><span>2월 THING</span></em>
			<p class="id">텐바이텐 X kerteac**** 고객님</p>
			<h2>내 이름은 <b style="color:#fa4b4b;">콩닥지</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180126180410_0k106.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180126174914_0o146.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180126173502_0c026.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#fa4b4b;">
			<p>텐바이텐에서 디자인한 THING뱃지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">사랑알림이</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">심심이(心)</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">자니?</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">따신저</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">큐피톡</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">맘짝꿍이</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">넌나의핫트너</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">핫둘핫둘</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">라익희</span></li>
				<li><span style="border-color:#fa4b4b; color:#fa4b4b;">사랑두알</span></li>
			</ul>
		</div>
	</div>
</article>
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
			<em class="month"><span>3월 THING</span></em>
			<p class="id">텐바이텐 X yrros**** 고객님</p>
			<h2>내 이름은 <b style="color:#35ba86;">액자하나사과세요</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180223142243_0r436.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180223142250_0y506.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180223171927_0b276.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#35ba86;">
			<p>텐바이텐에서 디자인한 THING뱃지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#35ba86; color:#35ba86;">네모의 봄</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">정사과형</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">액자식 사과구성</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">3월의 4과</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">홍오키</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">춘 데레</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">#셀피#애플</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">봄레임</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">나만의 세잔</span></li>
				<li><span style="border-color:#35ba86; color:#35ba86;">사과토</span></li>
			</ul>
		</div>
	</div>
</article>
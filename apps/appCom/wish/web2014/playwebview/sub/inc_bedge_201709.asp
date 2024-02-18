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
			<em class="month"><span>09월 THING</span></em>
			<p class="id">텐바이텐 X lr**** 고객님</p>
			<h2>내 이름은 <b style="color:#c462b4;">우주라이크</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170913154043_0r434.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170913152939_0n394.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170913153248_0w484.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#c462b4;">
			<p>높아진 가을 하늘 -<br> 반짝이는 별들이 더 잘 보이지 않나요.<br> 저기 멀리 어딘가 있을<br>나의 행성에게 이름을 지어주세요!<br></p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#c462b4; color:#c462b4;">유행성</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">우쥬썸띵</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">별그래</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">웅성웅성</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">걘역시</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">우주프라이</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">배둘레햄성</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">내 안의 별수없이</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">헿성</span></li>
				<li><span style="border-color:#c462b4; color:#c462b4;">우주비마이프랜드</span></li>
			</ul>
		</div>
	</div>
</article>
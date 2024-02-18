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
			<em class="month"><span>4월 THING</span></em>
			<p class="id">텐바이텐 X u**** 고객님</p>
			<h2>내 이름은 <b style="color:#fc586f;">봄뭉치</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180323141952_0a526.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180323141618_0s186.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180323141625_0z256.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#fc586f;">
			<p>텐바이텐에서 디자인한 THING뱃지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#fc586f; color:#fc586f;">봄쉘통통</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">내맘에꽃들어</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">화목(花木)</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">벚콘나무</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">벚꽃핀</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">벚꽃나무팝콘열렸네</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">미세벚꽃주의보</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">봄구름</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">벚콜리</span></li>
				<li><span style="border-color:#fc586f; color:#fc586f;">스프링꽃러</span></li>
			</ul>
		</div>
	</div>
</article>
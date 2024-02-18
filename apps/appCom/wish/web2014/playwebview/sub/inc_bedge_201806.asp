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
			<em class="month"><span>6월 THING</span></em>
			<p class="id">텐바이텐 X vl**** 고객님</p>
			<h2>내 이름은 <b style="color:#ff7a22;">밤구석1열</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180615102718_0s186.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180615095601_0b016.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180615100654_0c546.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#ff7a22;">
			<p>텐바이텐에서 디자인한 THING배지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
			<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=1996613" onclick="TnGotoProduct('1996613');return false;">뱃지 구매하러가기</a>
			</div>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">여름밤꿈덮개</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">별냄새가뱄지</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">문(MOON)나잇</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">텐밤이텐</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">열밤열달</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">달 베개 별 이불</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">쉿, 들어밤</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">쇼미더스타</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">장수별침대</span></li>
				<li><span style="border-color:#ff7a22; color:#ff7a22;">별ㅇi빛ㄴr는곳</span></li>
			</ul>
		</div>
	</div>
</article>
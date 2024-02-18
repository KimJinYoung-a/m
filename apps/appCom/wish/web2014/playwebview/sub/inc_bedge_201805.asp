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
			<em class="month"><span>5월 THING</span></em>
			<p class="id">텐바이텐 X ruddls**** 고객님</p>
			<h2>내 이름은 <b style="color:#0eb075;">봄앤락</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180518145128_0c286.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180518144520_0u206.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180518142854_0c546.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#0eb075;">
			<p>텐바이텐에서 디자인한 THING배지는<br>매달 이름짓기 이벤트를 통해<br>한정수량 제작됩니다.<br>응모 기간 동안 재치있는 이름을<br>지어주신 여러분, 감사합니다 :)</p>
			<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=1964112" onclick="TnGotoProduct('1964112');return false;">뱃지 구매하러가기</a>
			</div>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#0eb075; color:#0eb075;">햇빛밀</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">봄냄새밴또</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">내안에다이소</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">바게토대왕</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">바스켓라빈스</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">박운이</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">빵크닉</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">브레드피크</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">빨강모자의심부름</span></li>
				<li><span style="border-color:#0eb075; color:#0eb075;">끠끄닉</span></li>
			</ul>
		</div>
	</div>
</article>
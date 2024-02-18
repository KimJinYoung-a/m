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
			<em class="month"><span>12월 THING</span></em>
			<p class="id">텐바이텐 X hyosil**** 고객님</p>
			<h2>내 이름은 <b style="color:#11ad88;">눈송송트리팡</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171206203056_0e564.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171206201429_0d294.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20171206201439_0n394.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#11ad88;">
			<p>텐바이텐에서 디자인한 THING.뱃지는<br>매달 이름짓기 이벤트를 통해 <br>한정수량 제작됩니다.<br>12월 THING뱃지는 지난 응모기간동안<br>눈송송트리팡으로 이름이 지어졌어요:)</p>
			<!--<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=1842723" onclick="TnGotoProduct('1842723');return false;">뱃지 구매하러가기</a>
			</div>-->
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#11ad88; color:#11ad88;">눈_눈</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">겨울시소복동사락리</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">소복희 마을</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">겨울보관소</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">웃눈사람</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">고 용한 밤</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">설경 구</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">小福小福</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">눈나만바라봐</span></li>
				<li><span style="border-color:#11ad88; color:#11ad88;">겨울을수노운볼</span></li>
			</ul>
		</div>
	</div>
</article>
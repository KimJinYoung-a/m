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
			<em class="month"><span>스페셜THING</span></em>
			<p class="id"></p>
			<h2>내 이름은 <b style="color:#f85236;">THANK YOU</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180420145809_0j096.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180420145815_0p156.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2018/7/20180420145821_0v216.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#f85236;">
			<p>매월 여러분이 지어주신 이름으로 출시된<br>THING배지가 감사의 달 5월을 맞이하여<br>이름칸을 비워두었습니다.<br>그 자리에 감사하는 분의 이름을<br>넣어 보시길 바랍니다.<br>이벤트 기간동안 위트있는 이름을<br>지어주신 여러분들, 감사합니다_:)</p>
			<div class="btnGet">
				<a href="/category/category_itemPrd.asp?itemid=1943630" onclick="TnGotoProduct('1943630');return false;">뱃지 구매하러가기</a>
			</div>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#f85236; color:#f85236;">감사한송이</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">메일고마워</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">카드네이션</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">맴신져</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">메일꽃</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">활짝드림</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">고맘이</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">마음담꽃</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">마음을 전해홍</span></li>
				<li><span style="border-color:#f85236; color:#f85236;">꽃톡왔숑</span></li>
			</ul>
		</div>
	</div>
</article>
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
	<div class="hgroup" style="margin: 0px 0px 0px -185px; width: 370px;">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>01월 THING</span></em>
			<p class="id">텐바이텐 X fkdlem**** 고객님</p>
			<h2>내 이름은 <b style="color:#f897a0;">둥근해가떠썬</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170106092037_0l376.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170105181255_0d555.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170105181301_0b015.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#f897a0;">
			<p>둥근 해가 떴습니다 ♬ <br>희망찬 새 출발을 준비하는<br>나는, 동그란 해님입니다.<br>세상 모든 아침의 기운을 모아 반짝이는<br>나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#f897a0; color:#f897a0;">HAEPPY</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">감동란</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">반닭반닭해</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">발그레</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">찬란</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">새해봉만이</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">써니텐x텐</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">썬라이즈킹덤</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">혜혜(계+해)</span></li>
				<li><span style="border-color:#f897a0; color:#f897a0;">햇반이</span></li>
			</ul>
		</div>
	</div>
</article>
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
			<em class="month"><span>07월 THING</span></em>
			<p class="id">텐바이텐 X yys**** 고객님</p>
			<h2>내 이름은 <b style="color:#ffac9e;">날아갈꺼에어</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div id="thingRolling" class="swiperFull">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170622191559_0h595.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170622193726_0a265.jpg" alt=""></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play2016/2017/7/20170622193734_0i345.jpg" alt=""></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#ffac9e;">
			<p>붉은 지붕의 나라로<br>파도 소리 들리는 바닷가로<br>떠나고 싶나요?<br>생각만으로도 어디로든 날아갈 수 있는<br>나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">돈워리비행피</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">플레윙</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">행복행비행기</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">어디든날아걸거에어</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">플라잉플레잉</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">꿈탄자</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">치티치티뱅기</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">나는텐</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">미스터 노피</span></li>
				<li><span style="border-color:#ffac9e; color:#ffac9e;">님부스2000</span></li>
			</ul>
		</div>
	</div>
</article>
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
	<div class="hgroup" style="margin: 0px 0px 0px -154px; width: 308px;">
		<div>
			<span class="corner">THING.</span>
			<em class="month"><span>03월 THING</span></em>
			<p class="id">텐바이텐 X mi12**** 고객님</p>
			<h2>내 이름은 <b style="color:#6dcb83;">봄달새</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170303111311_0l116.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170303111318_0s186.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170303113243_0r436.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#6dcb83;">
			<p>짹짹짹<br>봄이 오는 소리가 들리나요?<br>기지개를 켜고 봄기운을 한껏 느껴보세요.<br>반가운 봄소식을 물고 온<br>나의 이름을 지어주세요!</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">봄소식배달부 짹</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">봄울림</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">봄한조각가져왔조</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">산새베리와</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">싱글봄글</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">조조(아침의새)</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">짹과 봄나무</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">봄이로새</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">짹하고해뜰날</span></li>
				<li><span style="border-color:#6dcb83; color:#6dcb83;">봄날이나르샤</span></li>
			</ul>
		</div>
	</div>
</article>
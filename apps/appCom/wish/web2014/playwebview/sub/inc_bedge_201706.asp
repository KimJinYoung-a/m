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
			<em class="month"><span>06월 THING</span></em>
			<p class="id">텐바이텐 X qodn**** 고객님</p>
			<h2>내 이름은 <b style="color:#31a7dd;">행보캡</b></h2>
		</div>
	</div>
	<div class="badge-detail">
		<div class="swiperFull" id="thingRolling">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170526122934_0i346.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170526122927_0b276.jpg"></div>
					<div class="swiper-slide"><img alt="" src="http://webimage.10x10.co.kr/play2016/2017/7/20170526143008_0i086.jpg"></div>
				</div>
				<div class="paginationDot"></div>
			</div>
		</div>
		<div class="itemDesc" style="background-color:#31a7dd;">
			<p>걱정마세요!<br>당신의 주근깨는 내가 가져갈게요.<br>힘찬 햇살을 받으면 더욱더 발랄해지는<br>나의 이름을 지어주세요 :)</p>
		</div>
		<div class="other">
			<h3>그 외의 작명센스!</h3>
			<ul>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">울트라캡</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">햇피</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">모자군</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">나도한번써모자</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">햇살을부타캡</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">썬크림이모자라</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">uv990</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">하태핫햇</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">내머리에저장</span></li>
				<li><span style="border-color:#31a7dd; color:#31a7dd;">매일매일해피햇</span></li>
			</ul>
		</div>
	</div>
</article>
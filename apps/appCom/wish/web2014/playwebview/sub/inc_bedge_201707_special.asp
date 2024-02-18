<style type="text/css">
.thingVol019 {background-color:#fff;}
.topic {position:relative;}
.topic h2 {position:absolute; left:50%; top:13.5%; z-index:40;width:42%; margin-left:-21%;}
.topic p {position:absolute; left:50%; z-index:40;}
.topic p.collabo {top:8.7%; width:50%; margin-left:-25%;}
.topic p.meet {top:32%; width:73%; margin-left:-36.5%;}
.topic .pagination {position:absolute; left:0; bottom:2rem; z-index:40; width:100%; height:0.7rem; padding-top:0;}
.topic .pagination span {width:0.7rem; height:0.7rem; margin:0 0.5rem; background-color:#fff;}
.topic .pagination span.swiper-active-switch {background-color:#fd4f00;}
.aboutHitchhiker {position:relative;}
.aboutHitchhiker a {position:absolute; left:0; top:0; width:100%; height:100%; background:transparent; text-indent:-999em;}
.pickBadge {padding-bottom:5rem; background-color:#9ce1f7;}
.pickBadge ul {padding:0 3.125% 1.6rem; }
.pickBadge ul:after {content:' '; display:block; clear:both;}
.pickBadge li {float:left; width:33.33333%; padding:0 1.6% 1.5rem; text-align:center;}
.pickBadge li input[type=radio] {position:absolute; left:0; top:0; visibility:hidden; width:0; height:0; font-size:0; line-height:0;}
.pickBadge li label {display:block; position:relative; background-color:#fff; border-radius:50%; cursor:pointer; transition:all .2s;}
.pickBadge li span {display:inline-block; padding:0.9rem 0 0.4rem; font-size:1.1rem; font-weight:bold; color:#000; white-space:nowrap;}
.pickBadge li p {font-size:1rem; font-weight:600; color:#1c5263;}
.pickBadge li input[type=radio]:checked + label {background-color:#4bc7ec;}
.pickBadge li input[type=radio]:checked + label:after {content:''; display:inline-block; position:absolute; left:50%; top:-1.2rem; width:2.05rem; height:2.05rem; margin-left:-0.8rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol019/m/ico_select.png) 0 0 no-repeat; background-size:100%; animation:bounce1 .4s;}
.evtNoti {padding:4rem 6.25%; color:#000; background-color:#e6e6e6;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.5rem; font-weight:bold;}
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.4; padding:0.3rem 0 0 1rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.85rem; width:0.35rem; height:0.35rem; background-color:#000; border-radius:50%;}
@keyframes bounce1{
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
</style>
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

	mySwiper = new Swiper(".topic .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:600,
		effect:"fade",
		pagination:".topic .pagination",
		paginationClickable:true
	});
	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	$(".topic p.meet").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(600).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
		$(".topic p.meet").delay(1100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
});
</script>
<article class="playDetailV16 thingthing">
	<div class="badge-detail">
		<div class="thingVol019 imKyoto">
			<div class="topic">
				<p class="collabo"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_collabo.png" alt=""></p>
				<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/tit_kyoto.png" alt="내 이름은 KYOTO"></h2>
				<p class="meet"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_meet.png" alt="월간 THING. 뱃지가 감성 매거진 히치하이커를 만나 스페셜 뱃지가 탄생하였습니다."></p>
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_1.jpg" alt=""></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_2.jpg" alt=""></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_3.jpg" alt=""></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_4.jpg" alt=""></div>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
			<div class="item">
				<div class="mWeb">
					<!--<a href="/category/category_itemPrd.asp?itemid=1750843"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_1.jpg" alt="히치하이커 + PLAYing 뱃지 KYOTO SET"></a>-->
					<a href="/category/category_itemPrd.asp?itemid=1745808"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_2.jpg" alt="PLAYing THING. 스페셜 뱃지 KYOTO"></a>
					<!--<a href="/category/category_itemPrd.asp?itemid=1732642"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_3.jpg" alt="10X10 히치하이커 vol.64 KYOTO"></a>-->
				</div>
				<div class="mApp">
					<!--<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750843" onclick="fnAPPpopupProduct('1750843');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_1.jpg" alt="히치하이커 + PLAYing 뱃지 KYOTO SET"></a>-->
					<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1745808" onclick="fnAPPpopupProduct('1745808');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_2.jpg" alt="PLAYing THING. 스페셜 뱃지 KYOTO"></a>
					<!--<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1732642" onclick="fnAPPpopupProduct('1732642');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_3.jpg" alt="10X10 히치하이커 vol.64 KYOTO"></a>-->
				</div>
			</div>
			<div class="aboutHitchhiker">
				<p><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_hitchhiker.jpg" alt="히치하이커는 격월간으로 발행되는 텐바이텐의 감성 매거진입니다. 매 호 다른 주제로 우리 주변의 평범한 이야기와 일상의 풍경을 담아냅니다. 히치하이커가 당신에게 소소한 즐거움, 작은 위로가 될 수 있길 바랍니다."></p>
				<div>
					<a href="/street/street_brand.asp?makerid=hitchhiker" class="mWeb">히치하이커 바로가기</a>
					<a href="#" onclick="fnAPPpopupBrand('hitchhiker'); return false;" class="mApp">히치하이커 바로가기</a>
				</div>
			</div>
			<div class="aboutBadge">
				<div><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_thing.jpg" alt=""></div>
				<a href="/street/street_brand.asp?makerid=1010play" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_thing_v2.jpg" alt="THING. 뱃지는 텐바이텐이 디자인한 뱃지에 고객님이 지어주신 이름으로 매월 한정수량 출시됩니다. 이름 지어주기 이벤트는 텐바이텐의 다양한 콘텐츠를 만날 수 있는 코너 PLAYing에서 매달 참여할 수 있습니다."></a>
				<a href="#" onclick="fnAPPpopupBrand('1010play'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_thing_v2.jpg" alt="THING. 뱃지는 텐바이텐이 디자인한 뱃지에 고객님이 지어주신 이름으로 매월 한정수량 출시됩니다. 이름 지어주기 이벤트는 텐바이텐의 다양한 콘텐츠를 만날 수 있는 코너 PLAYing에서 매달 참여할 수 있습니다."></a>
			</div>
		</div>
	</div>
</article>
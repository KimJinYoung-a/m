<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'########################################################
' PLAY #25 CAMERA 찰칵
' 2015-09-18 원승현 작성
'########################################################
%>
<style type="text/css">
img {vertical-align:top;}
.mPlay20150921 button {background-color:transparent;}
.mPlay20150921 .topic p {visibility:hidden; width:0; height:0}
.mPlay20150921 .topic {position:relative;}
.topic .line {position:absolute; bottom:0; left:50%; z-index:56; width:1px; height:10%; background-color:#cbcbcb;}

.article {position:relative;}
.start {position:absolute; top:0; left:0; z-index:55; width:100%; height:100%;}
.start .btnstart {position:absolute; top:52%; left:50%; width:46%; margin-left:-23%;}
.start .line {position:absolute; top:0; left:50%; z-index:56; width:1px; height:16%; background-color:#fff;}

.swiper {position:relative;}
.swiper .swiper-container {width:100%;}
.swiper .swiper-slide {position:relative;}
.swiper .btn-prev, .swiper .btn-next {position:absolute; bottom:6%; left:50%; width:15.93%; z-index:50;}
.swiper .btn-prev {margin-left:-19.84%;}
.swiper .btn-next {margin-left:3.9%;}

.swiper-slide-1 .graphic {position:absolute; top:50%; left:50%; width:95.15%; margin-left:-27%;}
.swiper-slide-1 .btnfake {position:absolute; bottom:6%; left:50%; width:15.93%; z-index:50; margin-left:-19.84%;}

.swiper-slide-2 .graphic {position:absolute; top:48%; left:50%; width:67.18%; margin-left:-33.59%;}
.swiper-slide-2 .people01 {position:absolute; top:62%; left:57%; width:41.25%;}

.swiper-slide-3 .graphic {position:absolute; top:48%; left:4%; width:80%;}
.swiper-slide-3 .filmcase {position:absolute; top:52.5%; left:6%; z-index:10; width:17.78%;}
.swiper-slide-3 .swiper-slide-3 {position:absolute; top:48%;}
.swiper-slide-3 .film {position:absolute; top:56.3%; left:19%; width:79.375%;}

.swiper-slide-4 .graphic {position:absolute; top:40%; left:12%; width:82.5%;}
.swiper-slide-4 .btnpush {position:absolute; top:35%; left:21%; width:15.62%; z-index:50;}
.swiper-slide-4 .btnpush img {width:100%;}
.bounce {-webkit-animation-fill-mode:both; animation-fill-mode:both; webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-duration:3s; animation-duration:3s; -webkit-animation-iteration-count:10; animation-iteration-count:10;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-10px);}
	60% {-webkit-transform: translateY(-10px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-10px);}
	60% {transform: translateY(-10px);}
}
.swiper-slide-4 .after {position:absolute; top:32.5%; left:12%; width:89.6%; height:0; opacity:0; filter: alpha(opacity=0);}
.swiper-slide-4 .after.show {opacity:1; filter: alpha(opacity=100); height:auto;}

.swiper-slide-5 .btngo {position:absolute; top:68%; left:50%; width:54.53%; margin-left:-27.625%;}
.swiper-slide-5 .btnfake {position:absolute; bottom:6%; left:50%; width:15.93%; z-index:50; margin-left:3.9%;}
</style>
<script type="text/javascript">
$(function(){
	$(".btnstart").click(function(){
		$(".start").delay(200).animate({"height":"0"},500);
		$(".topic .line").hide();
		$(".swiper-slide-1 .graphic").delay(500).animate({"margin-left":"-27%"},1000);
	});
	$(".swiper-slide-1 .graphic").delay(500).animate({"margin-left":"0"},1000);

	$('.btn-prev').hide();
	if ($('.swiper1 .swiper-wrapper .swiper-slide').length > 1) {
		mySwiper = new Swiper('.swiper1',{
			loop:false,
			resizeReInit:true,
			calculateHeight:true,
			pagination:false,
			paginationClickable:true,
			speed:1000,
			autoplay:false,
			autoplayDisableOnInteraction: true,
			allowSwipeToPrev:true,
			nextButton:'.btn-next',
			prevButton:'.btn-prev',
			onSlideChangeStart: function(){
				$(".swiper-slide-1 .btnfake").hide();
				$(".swiper-slide-active .btnfake").hide();
				
				$(".swiper-slide-2 .people01").css({"left":"80%"});
				$(".swiper-slide-active").find(".people01").delay(100).animate({"left":"57%"},2000);

				$(".swiper-slide-3 .film").css({"left":"5%"});
				$(".swiper-slide-active").find(".film").delay(100).animate({"left":"19%"},2000);
				$(".swiper-slide-active").find(".btnpush").addClass("bounce");
			},
			onSlideChangeEnd: function () {
				$(".swiper-slide-5 .btnfake").show();
				$('.btn-prev').show()
				$('.btn-next').show()
				if(mySwiper.activeIndex==0){
					$('.btn-prev').hide()
				}
				if(mySwiper.activeIndex==mySwiper.slides.length-1){
					$('.btn-next').hide()
				}
			}
		});
	} else {
		$('.btn-prev').hide();
		$('.btn-next').hide();
	}

	$('.btn-prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.btn-next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$(".btnpush").click(function(){
		$(".after").addClass("show");
		$(".swiper-slide-4 .graphic").fadeOut();
		$(".btnpush").hide();
	});
});
</script>
<div class="mPlay20150921">
	<article>
		<div class="section topic">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/tit_chal_kak.jpg" alt="찰칵" /></h2>
			<p>무엇이든 빠르고 정확해야만 하는 강박관념 속에 살고 있는 우리에게 여유와 감성을 찾게 해줄 수 있는 것이 무얼까 떠올려 보았을 때 문득 일회용 카메라가 생각났습니다.</p>
			<p>그럴싸한 멋이 있는 겉모습도 아니고, 찍었던 사진을 미리 볼 수도 없습니다. 멀리 있는 것을 찍기 위해서는 한 발자국 더 움직여야하고 때로는 불편하기도 한 완전 수동식 카메라.</p>
			<p>하지만 꾸밈 없이 날 것의 결과물을 내어주는 필름의 솔직함과, 담고 싶은 순간을 위해 조금 더 집중하게 되고 한 장 한 장 신중하게 찍게 되는 특별한 매력과 재미가 있습니다.</p>
			<p>처음 만나거나 혹은 오랜만에 만날 일회용 카메라!</p>
			<p>지금 당신의 상상 속 카메라의 셔터음은 어떤 소리인가요?</p>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_plan.png" alt="" />
			<div class="line"></div>
		</div>

		<div class="section article">
			<div class="start">
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/tit_start.png" alt="일회용카메라로 촬영하기" /></h3>
				<button type="button" class="btnstart"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_start.png" alt="스타트" /></button>
				<div class="line"></div>
			</div>

			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide swiper-slide-1">
							<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_step_01.png" alt="1 구도 잡기 먼저 차분하게 여유를 가지고 주위를 둘러보세요. 멀리 있는 것을 찍기 위해서 한 발자국 더 움직여보고 신중하게, 집중해서 구도를 잡아보세요!" /></p>
							<div class="graphic"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_step_01.png" alt="" /></div>
							<div class="btnfake"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_prev_fake.png" alt="" /></div>
						</div>
						<div class="swiper-slide swiper-slide-2">
							<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_step_02.png" alt="2 필름 돌려주기 찍고자 하는 피사체가 생겼다면, 필름감기레버를 멈출 때까지 돌려주세요! 카메라 안의 필름은 촬영을 준비합니다." /></p>
							<div class="graphic"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_step_02_01.png" alt="" /></div>
							<div class="people01"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_people_01.png" alt="" /></div>
						</div>
						<div class="swiper-slide swiper-slide-3">
							<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_step_02.png" alt="" /></p>
							<div class="graphic"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_step_02_01.png" alt="" /></div>
							<div class="filmcase"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_film_case.png" alt="" /></div>
							<div class="film"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_film_people_v1.png" alt="" /></div>
						</div>
						<div class="swiper-slide swiper-slide-4">
							<p class="desc"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_step_03.png" alt="3 셔터 누르기 자, 이제 셔터를 누릅니다. 카메라의 가장 상단에 있는 버튼을 눌러보세요!" /></p>
							<button type="button" class="btnpush"><img src="http://webimage.10x10.co.kr/play/ground/20150921/btn_push.png" alt="버튼" /></button>
							<div class="graphic"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_step_03_01.png" alt="" /></div>
							<div class="after"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_step_03_02.png" alt="" /></div>
						</div>
						<div class="swiper-slide swiper-slide-5">
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_question.jpg" alt="Q.셔터음을 상상해보세요! 우리는 보통 카메라의 셔터음을  찰칵 으로 기억합니다. 여러분의 상상을 더해 새로운 셔터음을 만들어보세요! 응모하신 분들 중 추첨을 통해 총 5분에게 일회용카메라와 필름을 선물로 드립니다." /></p>
							<%' for dev msg : 코멘트 창 url입니다. http://testm.10x10.co.kr/html/play/ground/201509/camera03_comment.asp %>
							<% If isApp="1" Then %>
								<a href="" id="btngo" onclick="fnAPPpopupBrowserURL('셔터음&nbsp;상상해보기','http://m.10x10.co.kr/play/groundcnt/inc_66346_comment.asp?gb=ap','','');return false;" class="btngo"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_go.png" alt="응모하러 가기" /></a>
							<% Else %>
								<a href="/play/groundcnt/inc_66346_comment.asp" id="btngo" class="btngo" target="_blank"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_go.png" alt="응모하러 가기" /></a>
							<% End If %>
							<div class="btnfake"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_next_fake.png" alt="" /></div>
						</div>
					</div>
				</div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_next.png" alt="다음" /></button>
			</div>
		</div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
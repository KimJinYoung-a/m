<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAYing Thing Bag
' History : 2018-01-19 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim userid, couponcnt, vDIdx
dim getbonuscoupon1, couponcnt1
dim totalbonuscouponcountusingy1

IF application("Svr_Info") = "Dev" THEN
	getbonuscoupon1 = 11167
Else
	getbonuscoupon1 = 13353
End If

userid = getencloginuserid()
vDIdx = request("didx")
couponcnt=0
totalbonuscouponcountusingy1=0

couponcnt = getitemcouponexistscount("", getbonuscoupon1, "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" Then
'couponcnt=40000
	totalbonuscouponcountusingy1 = getitemcouponexistscount("", getbonuscoupon1, "Y","")
end if

%>
<style type="text/css">
.thingVol033 img {width:100%;}
.thingVol033 button {background-color:transparent;}

.swiper {position:relative;}
.swiper-slide {position:relative;}
.swiper-slide > div {position:absolute; top:0; left:0; width:100%;}
.swiper-slide .box {position:relative; margin:4.99rem 0 1.19rem;}
.swiper-slide .box strong {display:inline-block; width:100%; position:absolute; top:1.04rem; left:0;}
.swiper-slide span {display:inline-block; width:100%; margin-top:2.82rem;}
.swiper-slide em {display:inline-block;}
.swiper-slide em,
.swiper-slide span,
.swiper-slide strong {opacity:0;}

.swiper .btn-nav{position:absolute; top:50%; z-index:20; width:9.6%; margin-top:-2.47rem;}
.swiper button.prev {left:0;}
.swiper button.next {right:0;}
.swiper .pagingNo {position:absolute; bottom:3.54rem; right:3.67rem; z-index:20; font-size:1.11rem;}
.swiper .pagingNo strong {font-weight:600; color:rgba(0,0,0,.5);}

.main-slide h2{position:absolute; top:0; left:0; opacity:0; animation:slideY .7s .5s 1 forwards;}
.main-slide .logo {display:inline-block; padding:13.44rem 0 2.01rem;}
.main-slide i {display:inline-block; width:100%;}
.main-slide button {position:absolute; bottom:2.73rem; animation:slideX .7s 100;}

.slide-1 .box {position:relative; margin:3.07rem 0 1.28rem;}
.slide-1 > div {height:50%;}
.slide-1 .sth {top:50%;}
.slide-10 p {padding:12.93rem 0 1.45rem;}
.slide-10 #go-down{animation:bounce .7s 100 forwards;}

.thing-item {position:relative;}
.thing-item span{position:absolute; bottom:22.58%; padding:0 15.7%; animation:slideX .7s 100;}

.thing-evt #cheer-up {position:relative; top:-1px;}
.thing-evt #cheer-up p{display:inline-block; position:absolute; top:0; left:0; padding:0 13.26%;}
.thing-evt #cheer-up .num {position:absolute; top:6.83rem; left:50%; width:24.5rem; height:2.69rem; margin-left:-12.3rem; padding:0 1.71rem; background-color:#fff; font-size:1.1rem; line-height:2.95rem; border-radius:1.28rem; color:#4b4b4b;}
.thing-evt #cheer-up .num:after {content:' '; position:absolute; top:-.95rem; left:50%; margin-left:-.49rem; z-index:5; width:1.11rem; height:.98rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol033/m/img_num.png); background-size:100%;}
.thing-evt #cheer-up em {color:#e61010; font-weight:bold;}

.pop-ly {position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background-color:rgba(0, 0, 0, .5);}
.pop-ly > div {position:absolute; top: 50%; left: 50%; margin-right:-50%; transform: translate(-50%, -50%);}
.pop-ly p {width:68%; margin:0 auto;}
.pop-ly button {position:absolute; top:-.51rem; right:14.2%; width:2.77rem;}
.pop-ly a {display:inline-block; position:absolute; left:50%; bottom:8%; width:50%; height:12%; margin-left:-25%; text-indent:-999em;}

@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(8px); animation-timing-function:ease-in;}
}
@keyframes slideY {
	from {transform:translateY(10px); opacity:0; animation-timing-function:ease-out;}
	to {transform:translateY(0); opacity:1; animation-timing-function:ease-in;}
}
@keyframes slideX {
	from,to{transform:translateX(0);}
	 50% {transform:translateX(10px);}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.thingVol033').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		speed:800,
		autoplay:false,
		nextButton:'.next',
		prevButton:'.prev',
		autoplayDisableOnInteraction:false,
		onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagingNo .page strong").text(vActIdx-1);
			if ($(".main-slide").hasClass("swiper-slide-active")) {
				$(".pagingNo").hide();
			}
			else {
				$(".pagingNo").show();
			}
			if ($(".slide-1").hasClass("swiper-slide-active")) {
				sthAni();
			} else{
				$(".slide-1 em").css({"opacity":"0","margin-top":"1rem"});
				$(".slide-1 strong").css({"opacity":"0","margin-top":"1rem"});
			}

			$(".slide-ani").find("em").delay(100).animate({"margin-top":"1rem", "opacity":"0"},400);
			$(".swiper-slide-active.slide-ani").find("em").delay(50).animate({"margin-top":"0", "opacity":"1"},300);

			$(".slide-ani").find("span").delay(100).animate({"margin-top":"3rem", "opacity":"0"},400);
			$(".swiper-slide-active.slide-ani").find("span").delay(150).animate({"margin-top":"2.82rem", "opacity":"1"},300);

			$(".slide-ani").find("strong").delay(100).animate({"margin-top":"1rem", "opacity":"0"},400);
			$(".swiper-slide-active.slide-ani").find("strong").delay(300).animate({"margin-top":"0", "opacity":"1"},300);

		}
	});
	$('.pagingNo .page span').text(mySwiper.slides.length-3);

	function sthAni() {
		$(".slide-1 .nth em").delay(200).animate({"margin-top":"0", "opacity":"1"},500);
		$(".slide-1 .nth strong").delay(400).animate({"margin-top":"0", "opacity":"1"},700);
		$(".slide-1 .sth em").delay(900).animate({"margin-top":"0", "opacity":"1"},500);
		$(".slide-1 .sth strong").delay(700).animate({"margin-top":"0", "opacity":"1"},700);
	}

	$("#btn-start").on("click", function(e){
		mySwiper.slideTo(2);
		return false;
	});

	$(".slide-10 > div").on("click", function(e){
		window.parent.$('html,body').animate({scrollTop:$(".thing-item").offset().top},500);
	});

	$(".pop-ly").hide();
	$("#cheer-up").on("click", function(e){
		$(".pop-ly button").on("click", function(e){
			$(".pop-ly").hide();
		});
	});

});
</script>
<script type="text/javascript">

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #02/05/2018 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$(".pop-ly").show();
					$("#tcnt").empty().html(numberWithCommas(Number(<%=couponcnt%>)+1));
					return false;
				}else if (str1[0] == "12"){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return false;
				}else if (str1[0] == "13"){
					alert('이미 다운로드 받으셨습니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인 후 쿠폰을 받을 수 있습니다!');
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>



					<div class="thingVol033">
						<div class="section article">
							<div class="swiper">
								<div class="swiper-container swiper1">
									<div class="swiper-wrapper">
										<div class="swiper-slide main-slide">
											<h2>
												<i class="logo"><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_logo.png" alt="" /></i>
												<i><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/tit_thing_bag.png" alt="thing bag" /></i>
											</h2>
											<button id="btn-start"><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_next_slide_v2.png" alt="" /></button>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_1.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-1">
											<div class="nth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_1.png" alt="아무것도 아닌 것" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_wht.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth.png" alt="nothing" /></em>
											</div>
											<div class="sth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_1.png" alt="특별한 것" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_blck.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth.png" alt="something" /></em>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_2.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-2">
											<div class="nth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_2.png" alt="2017" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_wht.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth.png" alt="nothing" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_sub_2.png" alt="잘 가요 2017년! 버리지 못했던 좋지 않은 기억을 담으세요" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_3.jpg" alt=""  class="img-slide" />
										</div>


										<div class="swiper-slide slide-ani slide-3">
											<div class="sth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_2.png" alt="2018" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_blck.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth.png" alt="something" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_sub_2.png" alt="앞으로 새롭게 시작할 2018년! 새로운 기대를 담으세요" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_4.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-4">
											<div class="nth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_3.png" alt="do" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_wht.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth.png" alt="nothing" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_sub_3.png" alt="구겨졌던 쓴 기억들은 펼치지 말아요!" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_5.jpg" alt="" />
										</div>


										<div class="swiper-slide slide-ani slide-5">
											<div class="sth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_3.png" alt="do" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_blck.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth.png" alt="something" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_sub_3.png" alt="새로운 것들, 새로운 이야기는 펼칠 준비를 해도 좋아요!" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_6.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-6">
											<div class="nth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_4.png" alt="hello" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_wht.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth.png" alt="nothing" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_sub_4.png" alt="떠나 보내야 할 것들은 꾹꾹 담아서 새어 나오지 않게 묶어 주세요" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_7.jpg" alt="" />
										</div>


										<div class="swiper-slide slide-ani slide-7">
											<div class="sth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_4.png" alt="bye" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_blck.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth.png" alt="something" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_sub_4.png" alt="보송보송한 마음으로  새로운 시작을 기도해보아요!" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_8.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-8">
											<div class="nth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_5.png" alt="no think" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_wht_2.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth.png" alt="nothing" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_nth_sub_5.png" alt="오늘부터  아무것도 아닌 것에 깊은 생각 금지!" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_9.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-9">
											<div class="sth">
												<div class="box">
													<strong><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_5.png" alt="some think" /></strong>
													<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_box_blck_2.png" alt="" />
												</div>
												<em><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth.png" alt="something" /></em>
												<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_sth_sub_5.png" alt="오늘부터  어떤 일에도 특별하게 생각하기!" /></span>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_10.jpg" alt="" />
										</div>

										<div class="swiper-slide slide-ani slide-10">
											<div>
												<p><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_thing_bag.png" alt="thing bag" /></p>
												<button id="go-down""><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_arrow.png" alt="아래로이동" /></button>
											</div>
											<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_slide_11.jpg" alt="" />
										</div>
									</div>
								</div>

								<div class="pagingNo">
									<p class="page"><strong></strong>/<span></span></p>
								</div>
								<button type="button" class="btn-nav prev"><span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_prev.png" alt="이전" /></span></button>
								<button type="button" class="btn-nav next"><span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_next.png" alt="다음" /></span></button>
							</div>
						</div>

						<!-- 상품 -->
						<div class="thing-item">
							<a href="/category/category_itemPrd.asp?itemid=1879853&" onclick="TnGotoProduct('1879853');return false;">
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/img_thing_item.jpg" alt="THING BAG set (NOTHING BAG + SOMETHING BAG) 구매하러 가기 limited edition" /></p>
								<span><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_get.png" alt="구매하러 가기" /></span>
							</a>
						</div>

						<!-- 이벤트 -->
						<div class="thing-evt">
							<p><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_evt.jpg" alt="플레잉에서 만든 THING BAG을 응원해주세요! 관심을 가져주시는 만큼 힘을 얻어 150개 한정을 넘어서 더 많이 만나볼 수 있도록 제작하겠습니다. 응원해주시는 고객님들에게 THING BAG sET  10% 추가 할인 쿠폰 을 드립니다! 이벤트 기간 : 1.22(월) -2.5(월)" /></p>
							<button id="cheer-up">
								<img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/bg_cheer_up.jpg" alt="" />
								<p><!-- <img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_cheer_up.png" alt="THING BAG 응원하기" /> --></p>
								<p><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_cheer_up_closed.png" alt="응원종료" /></p>
								<p></p>
								<!-- for dev msg 이벤트 참여 인원수 --><div class="num">총 <em id="tcnt"><%=FormatNumber(couponcnt,0)%></em>명이 THING BAG을 응원했습니다.</div>
							</button>
							<div class="pop-ly">
								<div>
									<p><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/txt_ly.png" alt="응모완료! 감사합니다! thing bag SET 추가할인 쿠폰이 발급 되었습니다 추가할인 쿠폰 10%" /></p>
									<% if isApp=1 then %>
									<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '쿠폰북', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;">내 쿠폰함 바로가기</a>
									<% Else %>
									<a href="/my10x10/couponbook.asp" target="_blank">내 쿠폰함 바로가기</a>
									<% End If %>
									<button><img src="http://webimage.10x10.co.kr/playing/thing/vol033/m/btn_close.png" alt="닫기" /></button>
								</div>
							</div>
						</div>
					</div>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 10원의 마술상 M 랜딩페이지
' History : 2016.03.25 원승현 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<%

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg

	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("[텐바이텐] 10원의 마술상")
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=69932")
	snpPre = Server.URLEncode("10x10 이벤트")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 10원의 마술상")
	snpTag2 = Server.URLEncode("#10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐] 10원의 마술상\n\n텐바이텐과 처음처럼이\n놀라운 마술상을 준비했습니다.\n\n단돈 10원으로 구매할 수 있는\n이 엄청난 혜택을 직접 확인해 보세요!\n\n오직 텐바이텐에서!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/69883/img_kakao.jpg"
	Dim kakaoimg_width : kakaoimg_width = "200"
	Dim kakaoimg_height : kakaoimg_height = "200"
	Dim kakaolink_url
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=69883"

%>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.mEvt69932 {overflow:hidden;}
.mEvt69932 button {background-color:transparent;}

.topic {position:relative;}
.topic h2 {position:absolute; top:5.5%; left:0; width:100%;}
.topic h2 {animation-name:lightSpeedIn; animation-timing-function:ease-out; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:1;}
.topic h2 {-webkit-animation-name:lightSpeedIn; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;}
@keyframes lightSpeedIn {
	0% {transform:translateY(20%); opacity:0;}
	60% {transform:translateY(-10%); opacity:1;}
	80% {transform:translateY(10%); opacity:1;}
	100% {transform:translateY(0%); opacity:1;}
}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateY(20%); opacity:0;}
	60% {-webkit-transform:translateY(-10%); opacity:1;}
	80% {-webkit-transform:translateY(10%); opacity:1;}
	100% {-webkit-transform:translateY(0%); opacity:1;}
}
.topic .btnMore {position:absolute; top:25%; right:8%; width:31.25%;}
.topic .btnMore {animation-name:bounce; animation-iteration-count:5; animation-duration:2s; -webkit-animation-name:bounce; -webkit-animation-iteration-count:5; -webkit-animation-duration:2s;}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform:translateY(0);}
	40% {transform:translateY(7px);}
	60% {transform:translateY(3px);}
}
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform:translateY(0);}
	40% {-webkit-transform:translateY(7px);}
	60% {-webkit-transform:translateY(3px);}
}
.topic .btnApp {position:absolute; bottom:3%; left:50%; width:92.5%; margin-left:-46.25%;}

.rolling {position:relative; background:#106cb0 url(http://webimage.10x10.co.kr/eventIMG/2016/69883/bg_blue.jpg) no-repeat 50% 0; background-size:100% auto;}
.rolling .swiper {width:90.625%; margin:0 auto; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69883/bg_rolling.png) no-repeat 50% 0; background-size:100% auto;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .swiper-slide {position:relative;}
.swiper .pagination {position:absolute; bottom:6%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 10px; border-radius:50%; background-color:#ffe984; cursor:pointer; transition:background-color 1s ease;}
.swiper .pagination .swiper-active-switch {background-color:#8d7738;}
.rolling .swiper button {position:absolute; top:36%; z-index:10; width:11.72%; background:transparent;}
.rolling .swiper .desc {position:absolute; top:35%; left:0; width:100%;}
.rolling .swiper .btn-prev {left:-0.5%;}
.rolling .swiper .btn-next {right:-0.5%;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:13%; left:50%; width:86%; margin-left:-43%;}
.sns ul li {float:left; width:25%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 6%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.noti {padding-bottom:8%; background-color:#e4e4e4;}
.noti ul {padding:0 4.53%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#838181; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#838181;}

@media all and (min-width:480px){
	.swiper .pagination .swiper-pagination-switch {width:8px; height:8px;}
}

@media all and (min-width:768px){
	.swiper .pagination .swiper-pagination-switch {width:12px; height:12px;}
}

.lyItem {display:none; position:absolute; top:3%; left:50%; z-index:110; width:93.75%; margin-left:-46.875%;}
.slide {padding-top:3%;}
.slide .slidesjs-navigation {position:absolute; top:47%; z-index:110; width:5.78%; height:8.43%; text-indent:-999em; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69932/btn_prev.png) no-repeat; background-size:100% 100%;}
.slide .slidesjs-previous {left:3%;}
.slide .slidesjs-next {right:3%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69932/btn_next.png);}
.lyItem .btnclose2 {position:absolute; top:2%; right:1%; z-index:110; width:13.33%; background-color:transparent;}

#mask {display:none; position:absolute; top:0; left:0; z-index:105; width:100%; height:100%; background:rgba(0,0,0,.6);}
</style>

<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>


<script type="text/javascript">
$(function(){
	/* swipe */
	mySwiper = new Swiper(".swiper1",{
		loop:true,
		resizeReInit:true,
		autoplay:2500,
		speed:800,
		autoplayDisableOnInteraction:false,
		pagination:'.pagination',
		paginationClickable:true,
		nextButton:".btn-next",
		prevButton:".btn-prev",
		onSlideChangeStart: function (mySwiper) {
			$(".swiper-slide").find(".desc").delay(100).animate({"margin-top":"3%", "opacity":"0"},400);
			$(".swiper-slide-active").find(".desc").delay(100).animate({"margin-top":"0", "opacity":"1"},500);
		}
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});

	$("#btnMore").click(function(){
		$("#lyItem").show();
		slideMove()
		$("#mask").show();
	});

	$("#lyItem .btnclose2, #mask").click(function(){
		$("#lyItem").hide();
		$("#mask").hide();
	});

	function slideMove() {
		$("#slide").slidesjs({
			width:"640",
			height:"923",
			pagination:false,
			navigation:{effect:"slide"},
			play:{interval:1500, effect:"slide", auto:false},
			effect:{slide: {speed:800, crossfade:false}}
		});
	}
});

function gotoDownload(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?9120160325';
	return false;
};



function getsnscnt(snsno) {

	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doEventSubscript69932.asp",
		data: "mode=S&snsno="+snsno,
		dataType: "text",
		async: false
	}).responseText;
	if(str=="tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
	}else if(str=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(str=="ka"){
		parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
	}else if(str=="ln"){
		popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(str=="Err|잘못된 접속입니다."){
		alert("잘못된 접속입니다.");
		return false;
	}else if(str=="Err|이벤트 응모 기간이 아닙니다."){
		alert("이벤트 응모 기간이 아닙니다.");
		return false;
	}else if(str=="Err|오전 10시부터 응모하실 수 있습니다."){
		alert("오전 10시부터 응모하실 수 있습니다.");
		return false;
	}else if(str=="Err|로그인 후 참여하실 수 있습니다."){
		alert("로그인 후 참여하실 수 있습니다.");
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}

}

</script>

<%' [M] 69932 10원의 마술상 %>
<div class="mEvt69932">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/tit_ten_won.png" alt="텐바이텐과 처음처럼이 함께하는 10원의 마술상" /></h2>
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_item_01.jpg" alt="지금 단돈 10원으로 구매할 수 있는 이 놀라운 마술상을 직접 확인 해 보세요! 텐바이텐 앱에서만 구매할 수 있습니다." />
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/img_item_02.jpg" alt="처음처럼 10주년 기념 혼술상 + 처음처럼x스티키몬스터랩 상품 1개 10원" />
			</p>
			<a href="#lyItem" id="btnMore" class="btnMore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/btn_more.png" alt="처음처럼x스티키몬스터랩 상품 자세히 보기" /></a>

			<div id="lyItem" class="lyItem">
				<div id="slide" class="slide">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_01.jpg" alt="" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_02.jpg" alt="" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_03.jpg" alt="" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_04.jpg" alt="" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_05.jpg" alt="" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/img_slide_item_06.jpg" alt="" /></div>
				</div>
				<button type="button" class="btnclose2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/btn_close.png" alt="닫기" /></button>
			</div>

			<a href="" onclick="gotoDownload();return false;" class="btnApp"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69932/btn_app.png" alt="텐바이텐 앱으로 가기" /></a>
		</div>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<p class="desc desc01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_desc_01.png" alt="처음처럼 연구팀이 10년간의 연구 끝에" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/img_white.png" alt="" />
						</div>
						<div class="swiper-slide">
							<p class="desc desc01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_desc_02.png" alt="혼자 즐겨 마실 수 있는 혼술상을 개발했습니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/img_white.png" alt="" />
						</div>
						<div class="swiper-slide">
							<p class="desc desc01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_desc_03.png" alt="※ 참고로 술은 포함되지 않았습니다" /></p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/img_white.png" alt="" />
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<%' for dev msg : sns 공유 %>
		<section class="sns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/tit_sns.jpg" alt="친구에게 10원의 마술상 알려주고 즐거운 혜택 나눠갖자!" /></h3>
			<ul>
				<li><a href="" onclick="getsnscnt('fb');return false;"><span></span>페이스북</a></li>
				<li><a href="" onclick="getsnscnt('tw');return false;"><span></span>트위터</a></li>
				<li><a href="" onclick="getsnscnt('ka');return false;"><span></span>카카오톡</a></li>
				<li><a href="" onclick="getsnscnt('ln');return false;"><span></span>라인</a></li>
			</ul>
		</section>

		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69883/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
				<li>ID당 1일 1회만 응모 가능합니다.</li>
				<li>상품구성 및 세부옵션은 랜덤으로 발송되며, 선택할 수 없습니다.</li>
				<li>당첨된 상품은 당첨 당일 구매하셔야 결제 가능합니다. (익일 결제불가)</li>
				<li>이벤트는 상품 품절 시 조기 마감될 수 있습니다.</li>
				<li>이벤트는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
				<li>본 패키지에는 주류가 들어있지 않습니다.</li>
			</ul>
		</section>

		<div id="mask"></div>
	</article>
</div>
<%'// [M] 69932 10원의 마술상 %>
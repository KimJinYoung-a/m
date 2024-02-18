<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg, vIsEnd, vQuery, vState, vNowTime, vCouponMaxCount
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 16주년 텐쇼")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/16th/")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "텐바이텐이 벌써 16주년이 되었어요~\n\n16주년 기념 최대 30% 쿠폰쑈와\n다양한 쑈가 당신을 기다립니다.\n\n10월에는 텐바이텐으로 놀러오십쑈!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg"
Dim kakaoimg_width : kakaoimg_width = "400"
Dim kakaoimg_height : kakaoimg_height = "400"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/index.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/16th/"
End If
%>
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<style type="text/css">
#gotop {display:none !important;}
.event-head {display:none;}
.ten-show {padding-top:4.5rem;}
.ten-show .navigation {position:absolute; left:0; top:0; width:100%; z-index:999; -webkit-transform:translateZ(0); -webkit-transition:all .3s ease;}
.ten-show .navigation ul {overflow:hidden; background:#e8eaf2; box-shadow:0 0.3rem 0.3rem rgba(0,0,0,.3);}
.ten-show .navigation li {float:left; width:20%; text-align:center; font-weight:600;}
.ten-show .navigation li a {display:block; height:4.5rem; font-size:1.4rem; line-height:4.5rem; color:#474747; border-left:1px solid #c5c7cf;}
.ten-show .navigation li.current a {color:#ea1212; background-color:#fdfdfe;}
.ten-show .navigation li:first-child a {border-left:0;}
.ten-show .navigation.stickyTab {position:fixed;}
.ten-show .share {position:relative;}
.ten-show .share .btn-group {position:absolute; bottom:2.39rem; left:50%; margin-left:-9.2rem;}
.ten-show .share .btn-group a {display:inline-block; width:3.75rem; margin:0 .85rem;}
.ten-show .section {position:relative;}
.ten-show button {width:100%; background-color:transparent;}
.ten-show .btn-go {display:block; position:absolute; left:30%; width:40%; height:8%; text-indent:-999em;}
.show-event2 {text-align:center; background:#e12b2b;}
.show-event2 .btn-gift {display:block; position:absolute; left:30%; top:35%; width:40%; height:8%; text-indent:-999em;}
.show-event2 .btn-apply {display:block; position:absolute; left:50%; bottom:2%; width:50%; margin-left:-25%; padding:9%; }
.show-event3:after {content:''; display:inline-block; position:absolute; left:29.6%; top:69.72%; width:7.2%; height:5.4%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/bg_light.gif) no-repeat 0 0; background-size:100% 100%;}
.show-event3 .btn-go {top:47%; height:13%;}

.show-event4 {padding-bottom:2.47rem; background-color:#fff;}
.show-event4 .swiper-slide {width:70.5%; padding:0 2.5%;}
.show-event4 .swiper-slide a {display:block; position:absolute; left:10%; top:30%; width:38%; height:50%; text-indent:-999em;}
.show-event4 .swiper-slide a em {display:block; position:absolute; left:-23%; top:35%; width:122%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/txt_early.gif) no-repeat 0 0; background-size:100% auto;}
.show-event4 .pagination {height:2.1rem; margin-top:1.58rem; padding-top:0;}
.show-event4 .pagination .swiper-pagination-switch {width:2.1rem; height:2.1rem; margin:0 0.55rem; font-size:1.4rem; line-height:2.25rem; font-weight:600; color:#fff; background-color:#bcbcbc;}
.show-event4 .pagination .swiper-active-switch {background-color:#333;}
.show-event4 .btn-go {top:35%;}
.show-event4 .soldout {position:absolute; left:9.5%; bottom:31.52%; width:37%; height:2.2rem; color:#fff; font-size:1.4rem; line-height:2.3rem; font-weight:bold; text-align:center; background-color:rgba(0,0,0,.5);}
.show-event5 {background:#122b7c;}
.show-event5 .rank {position:relative;}
.show-event5 .rank li {position:absolute; width:21.0666%;}
.show-event5 .rank li:nth-child(1) {left:13.2%; top:13.45%;}
.show-event5 .rank li:nth-child(2) {left:38.8%; top:30.4%;}
.show-event5 .rank li:nth-child(3) {right:14%; top:47.85%;}
.show-event5 .btn-go {top:41%; height:12%;}

.comment-write {padding-bottom:2.65rem; background:#fff9d2 url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/bg_dot.png) repeat-y 0 0; background-size:100% auto;}
.comment-write .select-icon {overflow:hidden; width:56%; margin:0 auto -5%;}
.comment-write .select-icon > div {float:left; width:33.33333%; padding:0 2.6%;}
.comment-write .select-icon input[type=radio] {visibility:hidden; position:absolute; left:0; top:0;}
.comment-write .select-icon label {position:relative; display:block;}
.comment-write .select-icon input:checked + label:after {content:''; display:block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_check.png) no-repeat 0 0; background-size:100% 100%;}
.comment-write .write-cont {position:relative; width:84%; margin:0 auto;}
.comment-write .write-cont textarea {position:absolute; left:2%; bottom:4%; width:73%; height:65%; padding:0; color:#333; border:0;}
.comment-write .write-cont .btn-submit {position:absolute; right:0; bottom:0; width:23%; height:72%; font-size:1.4rem; font-weight:bold; color:#333;}
.comment-list {padding:2.56rem 0 3.5rem; background-color:#fff;}
.comment-list ul {padding:0 8%;}
.comment-list li {position:relative; margin-bottom:1.7rem; padding:1.05rem; border:0.3rem solid #499af5; border-radius:0.6rem;}
.comment-list li:after {content:''; display:inline-block; position:absolute; left:1.05rem; top:1.05rem; width:4.78rem; height:4.78rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_1.png) no-repeat 0 0; background-size:100% 100%;}
.comment-list li .info {height:5.7rem; text-align:right; color:#a7a7a7;}
.comment-list li .delete {display:inline-block; height:1.7rem; margin-bottom:0.6rem; padding:0 0.4rem; line-height:1.7rem; font-weight:600; color:#fff; background-color:#a7a7a7;}
.comment-list li .num {margin-bottom:0.5rem; color:#ff8a8a;}
.comment-list li .writer img {width:.8rem; margin:-0.1rem 0.3rem 0 0; vertical-align:middle;}
.comment-list li.cmt2 {border-color:#79ce54;}
.comment-list li.cmt3 {border-color:#cb8aec;}
.comment-list li.cmt2:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_2.png);}
.comment-list li.cmt3:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_3.png);}
.comment-list li .comment {overflow:auto; min-height:5rem; max-height:8rem; font-size:1.1rem; line-height:1.3; word-break:break-all; color:#666; -webkit-overflow-scrolling:touch;}

.layer {position:fixed; left:0; top:0; width:100%; height:100%; z-index:9999; background:rgba(0,0,0,.5);}
.layer .layer-cont {position:relative;}
.layer .btn-close {position:absolute; right:-7%; top:-5%; width:16%; padding:4%; background:transparent;}
#lyrCoupon {padding-top:30%;}
#lyrCoupon .btn-close {right:6%; top:7%;}
#lyrGiftList {padding-top:7%;}
#lyrGiftList .layer-cont {padding:0 7%;}
#lyrGiftList ul {overflow:hidden; position:absolute; left:15%; top:5%; width:70%; height:90%;}
#lyrGiftList ul li {float:left; width:50%; height:33.33333%;}
#lyrGiftList ul li a {display:block; height:100%; text-indent:-999em;}
#lyrGiftList .btn-close {right:6%; top:-3%;}
#lyrNoti {padding-top:20%; display:none;}
#lyrNoti .layer-cont {width:86%; margin:0 auto; padding:2.05rem 1.3rem 2.3rem; border:0.26rem solid #fff; text-align:center; background:#f5f5f5;}
#lyrNoti h4 {margin-bottom:1.9rem; text-align:center; font-weight:bold; color:#282828; font-size:1.62rem;}
#lyrNoti h4 i {display:inline-block; width:1.5rem; height:1.5rem; color:#fff; font-size:1rem; line-height:1.7rem; background:#212121; border-radius:50%; vertical-align:top;}
#lyrNoti ul {padding-bottom:2rem;}
#lyrNoti li {position:relative; font-size:1.1rem; line-height:1.35; color:#515151; padding:0 0 0.2rem .8rem; text-align:left;}
#lyrNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.6rem; width:0.4rem; height:0.12rem; background:#515151;}
#lyrNoti .btn-ten {display:inline-block; height:3rem; padding:0 1.5rem; font-size:1.37rem; line-height:3rem; color:#fff; font-weight:600;  background:#de2828;}
#lyrNoti .btn-ten i {font-size:1em; vertical-align:top; font-family:tahoma;}
#lyrGollabo {padding-top:2%;}
#lyrGollabo .layer-cont {padding:0 7.5%;}
#lyrGollabo .layer-cont > div {margin-top:12%;}
#lyrGollabo .onemore .btn-download {position:absolute; left:15%; top:25%; width:70%; height:38%; text-indent:-999em;}
#lyrGollabo .onemore ul {overflow:hidden; position:absolute; left:28%; top:80%; width:43%; height:11%;}
#lyrGollabo .onemore li {float:left; width:33.33333%; height:100%;}
#lyrGollabo .onemore li a {display:block; height:100%; text-indent:-999em;}
#lyrGollabo div.win {margin-top:0;}
#lyrGollabo .win .btn-mypage {display:block; position:absolute; left:50%; bottom:10%; margin-left:-30%; width:60%; height:13%; text-indent:-999em;}
#lyrGollabo .win .code {position:absolute; left:18%; top:3.8%; font-size:.8rem; color:#d6d6d6; letter-spacing:-0.05rem;}
#lyrGollabo .btn-close {right:6%; top:-3%;}
#lyrResult {padding-top:25%;}
#lyrResult .layer-cont {width:84%; height:26rem; margin:0 auto; padding:3rem 0 3.8rem; background-color:#fff; border-bottom:0.25rem solid #747474; border-radius:1.15rem; box-shadow:0 3px 7px rgba(0,0,0,.35);}
#lyrResult .layer-cont .user {padding-bottom:2.2rem; font-size:1.4rem; font-weight:bold; }
#lyrResult .layer-cont .user strong {display:inline-block; padding:0 1rem; font-size:1.3rem; border-bottom:0.2rem solid #404040; margin-top:-1rem; font-weight:600;}
#lyrResult .layer-cont .list {overflow:auto; width:88%; height:16.2rem; margin:0 auto; -webkit-overflow-scrolling:touch;}
#lyrResult .layer-cont table {width:100%;}
#lyrResult .layer-cont table tr:nth-child(odd) {background:#f6f6f6;}
#lyrResult .layer-cont table td {height:3.24rem; border-right:0.1rem solid #e4e4e4; vertical-align:middle;}
#lyrResult .layer-cont table td:nth-child(2) {width:40%;}
#lyrResult .layer-cont table td:last-child {border-right:0;}
#lyrResult .layer-cont table .color-red i {display:inline-block; padding-left:0.2rem; font-size:.7rem; vertical-align:middle;}
.ten-show .btn-result {padding-bottom:2.2rem; text-align:center; background:#e12b2b;}
.ten-show .btn-result a {display:inline-block; padding-bottom:0.1rem; font-size:1.4rem; line-height:1.4rem; font-weight:600; color:#ffb9b9; border-bottom:0.1rem solid #ffb9b9;}
.ten-show .btn-result a i {padding-left:0.3rem; font-family:tahoma;}
</style>
<script type="text/javascript">
$(function(){
	$(".layer").hide();
	$(".layer .btn-close").click(function(){
		$(".layer").hide();
	});

	$(".show-event4 .btn-layer").click(function(){
		$("#lyrNoti").show();
		event.preventDefault();
	});

	$(".btn-result").click(function(){
		$("#lyrResult").show();
		event.preventDefault();
	});

	var swiper = new Swiper(".show-event4 .swiper-container", {
		slidesPerView:"auto",
		centeredSlides:true,
		pagination:".show-event4 .pagination",
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (index + 1) + '</span>';
		}
	});

	$("#navigation li a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},600);
	});
});
window.onload=function(){
	var menuTop = $(".ten-show").offset().top;
	$(window).scroll(function(){
		if( $(window).scrollTop()>=menuTop ) {
			$("#navigation").addClass("stickyTab");
		} else {
			$("#navigation").removeClass("stickyTab");
		}
		$('#navigation li').removeClass('current');
		if( $(window).scrollTop()>=$("#comment-write").offset().top-$("#navigation").outerHeight()-60) {
			$('#navigation li').removeClass('current');
		} else if( $(window).scrollTop()>=$("#show-event5").offset().top-$("#navigation").outerHeight()-25) {
			$(".tab5").addClass("current");
		} else if( $(window).scrollTop()>=$("#show-event4").offset().top-$("#navigation").outerHeight()-25) {
			$(".tab4").addClass("current");
		} else if( $(window).scrollTop()>=$("#show-event3").offset().top-$("#navigation").outerHeight()-25) {
			$(".tab3").addClass("current");
		} else if( $(window).scrollTop()>=$("#show-event2").offset().top-$("#navigation").outerHeight()-25) {
			$(".tab2").addClass("current");
		} else if( $(window).scrollTop()>=$("#show-event1").offset().top-$("#navigation").outerHeight()-25) {
			$(".tab1").addClass("current");
		}
	});
}
function jsDownCoupon(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					$("#lyrCoupon").show();
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/16th/")%>');
<% end if %>
	return;
}

function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="pt"){
		pinit('<%=snpLink%>','<%=snpImg%>')
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}
</script>
<!-- 16주년 이벤트 : 메인 -->
<div class="ten-show">
	<div id="navigation" class="navigation">
		<ul>
			<li class="tab1"><a href="#show-event1">MAIN</a></li>
			<li class="tab2"><a href="#show-event2">골라보쑈</a></li>
			<li class="tab3"><a href="#show-event3">함께하쑈</a></li>
			<li class="tab4"><a href="#show-event4">선물왔쑈</a></li>
			<li class="tab5"><a href="#show-event5">뽑아주쑈</a></li>
		</ul>
	</div>
	<!-- 1.쿠폰왔쇼 -->
	<div id="show-event1" class="section show-event1">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/tit_tenshow_v2.gif" alt="텐쑈" /></h2>
	<% if Not(IsUserLoginOK) then %>
		<a href="#lyrCoupon" class="btn-layer" onclick="jsEventLogin();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_coupon_v3.gif" alt="16주년 쿠폰쑈! 최대 30%할인쿠폰 다운받기" /></a>
	<% Else %>
		<a href="#lyrCoupon" class="btn-layer" onclick="jsDownCoupon('prd,prd,prd','12823,12824,12825');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_coupon_v3.gif" alt="16주년 쿠폰쑈! 최대 30%할인쿠폰 다운받기" /></a>
	<% End IF %>
		<!-- 쿠폰 다운로드 레이어 -->
		<div id="lyrCoupon" class="layer" style="display:none;">
			<div class="layer-cont">
				<a href="/my10x10/couponbook.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/layer_coupon_v2.png" alt="쿠폰이 발급되었습니다 즐거운 쑈핑 되세요!" /></a>
				<a href="/apps/appCom/wish/web2014/my10x10/couponbook.asp" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/layer_coupon_v2.png" alt="쿠폰이 발급되었습니다 즐거운 쑈핑 되세요!" /></a>
				<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_layer_close.png" alt="닫기" /></button>
			</div>
		</div>
		<!--// 쿠폰 다운로드 레이어 -->
	</div>

	<%'!-- 2.골라보쑈 --%>
	<div id="show-event2" class="section show-event2">
		<% server.Execute("/event/16th/exc_dailypick.asp") %>
	</div>

	<!-- 3.함께하쑈 -->
	<div id="show-event3" class="section show-event3">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/tit_together.jpg" alt="서포터즈 이벤트 함께하쑈" /></h3>
		<a href="/event/16th/together.asp" class="btn-go mWeb">지원하러 가기</a>
		<a href="/apps/appcom/wish/web2014/event/16th/together.asp" class="btn-go mApp">지원하러 가기</a>
	</div>

	<!-- 4.선물왔쑈 -->
	<div id="show-event4" class="section show-event4">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/tit_gift.png" alt="선물왔쑈" /></h3>
		<a href="#lyrNoti" class="btn-go btn-layer">이벤트 유의사항</a>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<p class="soldout">SOLD OUT</p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_gift_1_v2.png" alt="4만원 이상 구매 시 텐바이텐 16주년 머그컵" />
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_gift_2_v4.png" alt="7만원이상 구매 시 플레잉 랩핑페이퍼 또는 2000마일리지 중 택1" />
					<p class="soldout">SOLD OUT</p>
					<a href="/playing/view.asp?didx=153" class="mWeb">플레잉 랩핑페이퍼 보러가기</a>
					<a href="#" onclick="fnAPPpopupPlay_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/playing/view.asp?didx=153');return false;" class="mApp">플레잉 랩핑페이퍼 보러가기</a>
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_gift_3.png" alt="30만원 이상 구매 시 레꼴뜨 프레스샌드메이커 또는 10000마일리지 중 택1" />
					<p class="soldout">SOLD OUT</p>
					<a href="/category/category_itemPrd.asp?itemid=1419077&pEtr=80410" class="mWeb">레꼴뜨 프레스샌드메이커 보러가기</a>
					<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1419077&pEtr=80410" onclick="fnAPPpopupProduct('1419077&amp;pEtr=80410');return false;" class="mApp">레꼴뜨 프레스샌드메이커 보러가기</a>
				</div>
			</div>
			<div class="pagination"></div>
		</div>
		<!-- 유의사항 레이어 -->
		<div id="lyrNoti" class="layer" style="display:none;">
			<div class="layer-cont">
				<h4><i>!</i> 구매사은 이벤트 유의사항</h4>
				<ul>
					<li>본 이벤트는 텐바이텐 회원님을 위한 혜택입니다 (비회원 증정 불가)</li>
					<li>텐바이텐 배송상품을 포함하여야 사은품 선택이 가능합니다</li>
					<li>쿠폰, 할인카드 등을 적용한 후<br /><span class="cRd1">구매확정액이 4/7/30만원 이상</span>이어야 합니다</li>
					<li>마일리지, 예치금, 기프트카드를 사용하신 경우에는 구매 확정액에 포함되어 사은품을 받을 수 있습니다</li>
					<li>텐바이텐 GIFT카드를 구매하신 경우에는 사은품 증정이 되지 않습니다</li>
					<li>사은품은 텐바이텐 배송 상품과 함께 배송됩니다</li>
					<li>환불/교환 시 최종 구매가격이 사은품 수령 가능금액 미만일 경우 사은품과 함께 반품해야 합니다</li>
					<li>마일리지는 차후 일괄 지급입니다.<br />1차 : 10월 23일 (10월 14일까지 결제완료 기준)<br />2차 : 11월 3일 (10월 15일 ~ 25일 결제완료 기준)</li>
					<li>사은품은 한정 수량이므로, 조기 소진될 수 있습니다.</li>
				</ul>
				<a href="/event/eventmain.asp?eventid=80481" class="btn-ten mWeb">텐바이텐 배송상품 보러가기 <i>&gt;</i></a>
				<a href="#" onclick="fnAPPpopupEvent('80481'); return false;" class="btn-ten mApp">텐바이텐 배송상품 보러가기 <i>&gt;</i></a>
				<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/btn_layer_close.png" alt="닫기" /></button>
			</div>
		</div>
		<!--// 유의사항 레이어 -->
	</div>

	<!-- 5.뽑아주쑈 -->
	<% server.Execute("/event/16th/inc_pickshow.asp") %>

	<!-- 공유하기 -->
	<div class="share">
		<div class="inner">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/tit_share.png" alt="1년에 한번 있는 텐바이텐 쑈! 친구와 함께하쑈~!" /></p>
			<div class="btn-group">
				<a href="#" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_fb_v2.png" alt="페이스북으로 텐쑈 공유하기" /></a>
				<a href="#" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_kakao.png" alt="카카오톡으로 텐쑈 공유하기" /></a>
				<a href="#" onclick="snschk('pt'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/m/btn_pinterest.png" alt="핀터레스트로 텐쑈 공유하기" /></a>
			</div>
		</div>
	</div>
	<!-- #include virtual="/event/16th/inc_comment.asp" -->
</div>
<!--// 16주년 이벤트 : 메인 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
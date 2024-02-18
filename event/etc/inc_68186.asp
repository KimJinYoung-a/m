<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 디지털 삼대장
' History : 2015.12.16 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65985"
	Else
		eCode = "68186"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2757"
	Else
		getbonuscoupon = "810"
	End If

	currenttime = now()
	'currenttime = #12/17/2015 14:05:00#

	userid = GetEncLoginUserID()
	getlimitcnt = 20000

dim bonuscouponcount, subscriptcount, totalsubscriptcount, totalbonuscouponcount
bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", "")

%>
<% '<!-- #include virtual="/lib/inc/head.asp" --> %>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt68186 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68186 .app {display:none;}
.mEvt68186 button {background:transparent;}

.coupon {position:relative;}
.coupon .crown {position:absolute; top:10%; left:50%; width:14.68%; margin-left:-7.34%;}
.crown {transition:2s ease-in-out; transform-origin:60% 0%; transform:rotateY(200deg); opacity:0;
	-webkit-transition:2s ease-in-out; -webkit-transform-origin:60% 0%; -webkit-transform:rotateY(200deg);
}
.crown.rotate {transform:rotateY(360deg); -webkit-transform:rotateY(360deg); opacity:1;}

.btnCoupon {overflow:hidden; display:block; position:absolute; bottom:11.5%; left:50%; width:86.25%; height:0; margin-left:-43.125%; padding-bottom:48.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.btnCoupon span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.rolling {padding-bottom:12.5%; background:#393b5a url(http://webimage.10x10.co.kr/eventIMG/2015/68186/bg_pattern.png) no-repeat 50% 0; background-size:100% auto;}
.rolling .swiper {position:relative;}
.rolling .swiper-wrapper {border-radius:20px;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper .pagination {position:absolute; bottom:-11%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:10px; height:10px; margin:0 4px; border:2px solid #fff; border-radius:50%; background-color:transparent; cursor:pointer; transition:background-color 1s ease;}
.rolling .swiper .pagination .swiper-active-switch {width:22px; border-radius:22px; background-color:#fff;}
.rolling .swiper button {position:absolute; top:48%; z-index:150; width:3.125%;}
.rolling .swiper .prev {left:1.5%;}
.rolling .swiper .next {right:1.5%;}

.item {overflow:hidden; position:absolute; top:20%; left:50%; width:92%; margin-left:-46%;}
.item li {position:relative; float:left; width:33.333%; margin-bottom:4.2%; padding:0 1%;}
.item li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:152.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.noti {padding:2.2rem 2.5rem; background-color:#e7e7e7;}
.noti h3 {color:#565656; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #565656;}
.noti ul {margin-top:2rem;}
.noti ul li {position:relative; margin-top:0.5rem; padding-left:1rem; color:#7a7a7a; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:0.6rem; height:0.2rem; background-color:#6e6e6e;}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 6px; }
	.rolling .swiper .pagination .swiper-active-switch {width:36px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-17" and left(currenttime,10)<"2015-12-24" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 or bonuscouponcount>0 then %>
				alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
				return;
			<% else %>
				<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
					alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
					return;
				<% else %>
					<% ' if Hour(currenttime) < 14 then %>
						//alert("쿠폰은 오후 2시부터 다운 받으실수 있습니다.");
						//return;
					<% ' else %>
						frm.action="/event/etc/doeventsubscript/doEventSubscript68186.asp";
						frm.target="evtFrmProc";
						frm.mode.value='couponreg';
						frm.submit();
					<% ' end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<div class="mEvt68186">
	<article>
		<h2 class="hidden">디지털 삼대장</h2>

		<div class="coupon">
			<span id="animation" class="crown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/img_crown.png" alt="" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/img_coupon.png" alt="남자의, 남자에 의한, 빙글러 남자들을 위한 디지털 삼대장을 쿠폰과 함께 만나보세요. 2015년 12월 17일부터 23일까지 7일간 사용하실수 있으며 텐바이텐에서만 사용 가능합니다." /></p>
			<% '<!-- for dev msg : 쿠폰받기 --> %>
			<button type="button" onclick="jseventSubmit(evtFrm1); return false;" class="btnCoupon"><span></span>5천원 쿠폰 받기 3만원 이상 구매시</button>
		</div>

		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/img_slide_01_v1.jpg" alt="" />
							<ul class="item mo">
								<li><a href="/category/category_itemPrd.asp?itemid=1167545&amp;pEtr=68186"><span></span>아이리버 블루투스 스피커</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1039511&amp;pEtr=68186"><span></span>인스탁스 와이파이프린터</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1265396&amp;pEtr=68186"><span></span>핏비트 차지 HR 스마트밴드</a></li>
							</ul>
							<ul class="item app">
								<li><a href="/category/category_itemPrd.asp?itemid=1167545&amp;pEtr=68186" onclick="fnAPPpopupProduct('1167545&amp;pEtr=68186');return false;"><span></span>아이리버 블루투스 스피커</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1039511&amp;pEtr=68186" onclick="fnAPPpopupProduct('1039511&amp;pEtr=68186');return false;"><span></span>인스탁스 와이파이프린터</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1265396&amp;pEtr=68186" onclick="fnAPPpopupProduct('1265396&amp;pEtr=68186');return false;"><span></span>핏비트 차지 HR 스마트밴드</a></li>
							</ul>
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/img_slide_02_v1.jpg" alt="" />
							<ul class="item mo">
								<li><a href="/category/category_itemPrd.asp?itemid=1384679&amp;pEtr=68186"><span></span>샤오미 액션캠</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1376063&amp;pEtr=68186"><span></span>인스탁스 MINI 70</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1404033&amp;pEtr=68186"><span></span>폴라로이드 디지털 즉석 카메라</a></li>
							</ul>
							<ul class="item app">
								<li><a href="/category/category_itemPrd.asp?itemid=1384679&amp;pEtr=68186" onclick="fnAPPpopupProduct('1384679&amp;pEtr=68186');return false;"><span></span>샤오미 액션캠</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1376063&amp;pEtr=68186" onclick="fnAPPpopupProduct('1376063&amp;pEtr=68186');return false;"><span></span>인스탁스 MINI 70</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1404033&amp;pEtr=68186" onclick="fnAPPpopupProduct('1404033&amp;pEtr=68186');return false;"><span></span>폴라로이드 디지털 즉석 카메라</a></li>
							</ul>
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/img_slide_03_v1.jpg" alt="" />
							<ul class="item mo">
								<li><a href="/category/category_itemPrd.asp?itemid=1190691&amp;pEtr=68186"><span></span>단보 보조배터리</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1311280&amp;pEtr=68186"><span></span>샤오미 보조배터리</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1215641&amp;pEtr=68186"><span></span>캡틴아메리카 보조배터리</a></li>
							</ul>
							<ul class="item app">
								<li><a href="/category/category_itemPrd.asp?itemid=1190691&amp;pEtr=68186" onclick="fnAPPpopupProduct('1190691&amp;pEtr=68186');return false;"><span></span>단보 보조배터리</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1311280&amp;pEtr=68186" onclick="fnAPPpopupProduct('1311280&amp;pEtr=68186');return false;"><span></span>샤오미 보조배터리</a></li>
								<li><a href="/category/category_itemPrd.asp?itemid=1215641&amp;pEtr=68186" onclick="fnAPPpopupProduct('1215641&amp;pEtr=68186');return false;"><span></span>캡틴아메리카 보조배터리</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<% '<!-- for dev msg : app일 경우에만 노출해주세요 --> %>
		<% if not(isApp=1) then %>
			<div class="tentenapp">
				<p><a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68186/btn_app.png" alt="텐바이텐 APP 설치하고 더 많은 혜택 받자!" /></a></p>
			</div>
		<% end if %>

		<!--section class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
				<li>쿠폰 발급 및 사용은 12/23(수) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</section-->
	</article>

	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="isapp" value="<%= isApp %>">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</div>

<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
	}else{
			$(".app").hide();
			$(".mo").show();
	}

	/* animation */
	function titleAnimation() {
		$("#animation").delay(50).addClass("rotate");
	}
	titleAnimation();


});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
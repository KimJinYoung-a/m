<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : vingle to meet you
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
		eCode = "65986"
	Else
		eCode = "68187"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2758"
	Else
		getbonuscoupon = "809"
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
img {vertical-align:top;}
.mEvt68187 {background:#ffe67d;}
.mEvt68187 h2 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68187/tit_vingle.png) no-repeat 50% 50%; background-size:120% 120%; opacity:0;}
.swiper {position:relative; padding-bottom:13%;}
.swiper .pagination {position:absolute; bottom:8%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.swiper .pagination .swiper-pagination-switch {display:inline-block; width:10px; height:10px; margin:0 4px; border:2px solid #e3b26a; border-radius:50%; background-color:transparent; cursor:pointer; transition:width .3s;}
.swiper .pagination .swiper-active-switch {width:22px; border-radius:22px; border:2px solid #f3393a; background-color:#f3393a;}
.swiper button {position:absolute; top:38.5%; z-index:150; width:6.25%; background:transparent;}
.swiper .prev {left:0;}
.swiper .next {right:0;}
@media all and (min-width:480px){
	.swiper .pagination .swiper-pagination-switch {width:16px; height:16px; margin:0 6px; }
	.swiper .pagination .swiper-active-switch {width:36px;}
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
						frm.action="/event/etc/doeventsubscript/doEventSubscript68187.asp";
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
<!-- Vingle to meet you -->
<div class="mEvt68187">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/bg_blank.png" alt="Vingle to meet you" /></h2>
	<% '<!-- 쿠폰 다운로드 --> %>
	<div class="coupon">
		<a href="" onclick="jseventSubmit(evtFrm1); return false;">
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/btn_coupon.png" alt="3만원 이상 구매 시 5천원 할인 쿠폰받기" /></a>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/txt_only_ten.png" alt="텐바이텐에서만 사용가능" /></p>
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<a href="/category/category_itemPrd.asp?itemid=1404956&amp;pEtr=68187" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_01.jpg" alt="" /></a>
					<a href="/category/category_itemPrd.asp?itemid=1404956&amp;pEtr=68187" onclick="fnAPPpopupProduct('1404956&amp;pEtr=68187');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_01.jpg" alt="" /></a>
				</div>
				<div class="swiper-slide">
					<a href="/category/category_itemPrd.asp?itemid=1306806&amp;pEtr=68187" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_02.jpg" alt="" /></a>
					<a href="/category/category_itemPrd.asp?itemid=1306806&amp;pEtr=68187" onclick="fnAPPpopupProduct('1306806&amp;pEtr=68187');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_02.jpg" alt="" /></a>
				</div>
				<div class="swiper-slide">
					<a href="/category/category_itemPrd.asp?itemid=1405084&amp;pEtr=68187" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_03.jpg" alt="" /></a>
					<a href="/category/category_itemPrd.asp?itemid=1405084&amp;pEtr=68187" onclick="fnAPPpopupProduct('1405084&amp;pEtr=68187');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_03.jpg" alt="" /></a>
				</div>
				<div class="swiper-slide">
					<a href="/category/category_itemPrd.asp?itemid=1216017&amp;pEtr=68187" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_04.jpg" alt="" /></a>
					<a href="/category/category_itemPrd.asp?itemid=1216017&amp;pEtr=68187" onclick="fnAPPpopupProduct('1216017&amp;pEtr=68187');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/img_slide_04.jpg" alt="" /></a>
				</div>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/btn_next.png" alt="다음" /></button>
	</div>
	
	<% if not(isApp=1) then %>
		<div class="mw">
			<a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68187/btn_app.png" alt="텐바이텐 APP설치하고 더 많은 혜택 받자!" /></a>
		</div>
	<% end if %>

	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="isapp" value="<%= isApp %>">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</div>
<!--// Vingle to meet you -->

</body>
</html>

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
	$('.mEvt68187 h2').animate({backgroundSize:'100%','opacity':'1'}, 800);
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}
});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 오렌지족
' History : 2016.01.14 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<%
dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66002"
	Else
		eCode = "68588"
	End If

currenttime = now()
'currenttime = #01/18/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "11116"
	Else
		couponidx = "11429"
	End If

dim subscriptcount, itemcouponcount
subscriptcount=0
itemcouponcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	itemcouponcount = getitemcouponexistscount(userid, couponidx, "", "")
end if
'response.write GetUserStrlarge(GetLoginUserLevel) & "/" & GetLoginUserLevel

dim administrator
	administrator=FALSE

if GetLoginUserID="greenteenz" or GetLoginUserID="djjung" or GetLoginUserID="bborami" or GetLoginUserID="kyungae13" or GetLoginUserID="tozzinet" then
	administrator=TRUE
end if

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68588 {overflow:hidden; position:relative; background:#f5c061;}
.intro {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.8); z-index:40;}
.intro .click {position:absolute; left:0; top:8%; width:100%; height:20%; z-index:50; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68588/m/bg_blank.png) repeat 0 0; background-size:100% 100%; text-indent:-999em; cursor:pointer;}
.title {overflow:hidden; position:relative;}
.title h2 {position:absolute; left:15.6%; top:8.8%; width:68.75%; z-index:30;}
.title .deco {position:absolute; left:50%; bottom:2%; width:7.5%; margin-left:-3.75%;}
.swiper {position:relative;}
.swiper .pageNum {position:absolute; left:0; top:53%; width:100%; height:10%; text-align:center; z-index:50;}
.swiper .pageNum span {display:inline-block; width:4%; height:100%; margin:0 0.3%; vertical-align:top; cursor:pointer;}
.getCoupon {position:relative;}
.getCoupon .goBuy {position:absolute; left:13%; top:0; width:74%;}
.evtNoti {color:#fff; padding:20px 4.2% 0; background:#674d37;}
.evtNoti h3 {padding-bottom:12px;}
.evtNoti h3 strong {display:inline-block; font-size:14px; line-height:20px; padding-left:25px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68588/m/ico_mark.png) no-repeat 0 0; background-size:19px 19px;}
.evtNoti li {position:relative; padding-left:10px; font-size:11px; line-height:1.4; letter-spacing:-0.015em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:5px; width:4px; height:1px; background:#fff;}
.couponLayer {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:40;}
.couponLayer .layerCont {position:absolute; left:0; top:8%; width:100%;}
.couponLayer .btnClose {position:absolute; right:9.5%; top:3%; width:10%; background:transparent;}

/* animation */
.spin {-webkit-animation:spin 1.5s 1; -moz-animation:spin 1.5s 1; -ms-animation:spin 1.5s 1; -o-animation:spin 1.5s 1; animation:spin 1.5s 1;}
@keyframes spin {from {transform:translate(-45%,0) rotate(0deg);} to { transform:translate(0,0) rotate(360deg);}}
@-webkit-keyframes spin {from { -webkit-transform:translate(-45%,0) rotate(0deg);} to { -webkit-transform:translate(0,0) rotate(360deg);}}
@-moz-keyframes spin {from { -moz-transform:translate(-45%,0) rotate(0deg);} to { -moz-transform:translate(0,0) rotate(360deg);}}
@-o-keyframes spin {from {-o-transform:translate(-45%,0) rotate(0deg);} to {-o-transform:translate(0,0) rotate(360deg);}}
@-ms-keyframes spin {from {-ms-transform:translate(-45%,0) rotate(0deg);} to {-ms-transform:translate(0,0) rotate(360deg);}}

.swing {-webkit-animation: swing 1s ease-in-out 0s 10 alternate; -moz-animation: swing 1s ease-in-out 0s 10 alternate; -ms-animation: swing 1s ease-in-out 0s 10 alternate; -o-animation: swing 1s ease-in-out 0s 10 alternate; animation: swing 1s ease-in-out 0s 10 alternate;}
@keyframes swing {from {transform: rotate(15deg) translate(-5px,0);} to {transform: rotate(-15deg) translate(5px,0);}}
@-webkit-keyframes swing { from {-webkit-transform: rotate(15deg) translate(-5px,0);} to {-webkit-transform: rotate(-15deg) translate(5px,0);}}
@-moz-keyframes swing {from {-moz-transform: rotate(15deg) translate(-5px,0);} to{-moz-transform: rotate(-15deg) translate(5px,0);}}
@-o-keyframes swing {from {-o-transform: rotate(15deg) translate(-5px,0);} to {-o-transform: rotate(-15deg) translate(5px,0);}}
@-ms-keyframes swing {from {-ms-transform: rotate(15deg) translate(-5px,0);} to {-ms-transform: rotate(-15deg) translate(5px,0);}}

.move {-webkit-animation: move 0.2s ease-in-out 4s 50 alternate; -moz-animation: move 0.2s ease-in-out 4s 50 alternate; -ms-animation: move 0.2s ease-in-out 4s 50 alternate; -o-animation: move 0.2s ease-in-out 4s 50 alternate; animation: move 0.2s ease-in-out 4s 50 alternate;}
@keyframes move {from {transform:translate(-3px,-3px);} to {transform:translate(3px,0);}}
@-webkit-keyframes move { from {-webkit-transform:translate(-3px,-3px);} to {-webkit-transform:translate(3px,0);}}
@-moz-keyframes move {from {-moz-transform:translate(-3px,-3px);} to{-moz-transform:translate(3px,0);}}
@-o-keyframes move {from {-o-transform:translate(-3px,-3px);} to {-o-transform:translate(3px,0);}}
@-ms-keyframes move {from {-ms-transform:translate(-3px,-3px);} to {-ms-transform:translate(3px,0);}}
</style>
<script type="text/javascript">

$(function(){
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		paginationClickable:true,
		pagination:'.pageNum',
		speed:400,
		autoplay:2500,
		effect:'fade'
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 500);
	});

	$(".title h2").css({"left":"-47%"});
	$(".title .deco").css({"opacity":"0"});
//	$(".intro .click").click(function(){
//		$(".intro").fadeOut(300);
//		$(".title h2").addClass("spin").animate({"left":"15.6%"},1200);
//		$(".title .deco").delay(1450).animate({"opacity":"1"},800).addClass("swing");
//	});

	$(".title h2").addClass("spin").animate({"left":"15.6%"},1200);
	$(".title .deco").delay(1450).animate({"opacity":"1"},800).addClass("swing");
//	$(".goBuy").click(function(){
//		$("#couponLayer").fadeIn(300);
//	});
	$(".btnClose").click(function(){
		$("#couponLayer").fadeOut(300);
		location.reload();
	});
});

function jscoupondown(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-18" and left(currenttime,10)<"2016-01-23" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 or itemcouponcount>0 then %>
				//alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
				$(".intro").fadeOut(300);
				$("#coupondownno").hide();
				$("#coupondownyes").show();
				$("#couponLayer").fadeIn(300);
				$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
				return;
			<% else %>
				<% if GetLoginUserLevel<>"5" and not(administrator) then %>
					alert("고객님은 쿠폰발급 대상이 아닙니다.");
					return;
				<% else %>
					<% if administrator then %>
						alert("[관리자] 특별히 관리자님이니까 오렌지 등급이 아니여도 다음 단계로 진행 시켜 드릴께요!");
					<% end if %>

					<% 'if Hour(currenttime) < 10 then %>
						//alert("쿠폰은 오전 10시부터 다운 받으실수 있습니다.");
						//return;
					<% 'else %>
						var str = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript68588.asp",
							data: "mode=coupondown&isapp=<%= isapp %>",
							dataType: "text",
							async: false
						}).responseText;
						//alert(str);
						var str1 = str.split("||")
						//alert(str1[0]);
						if (str1[0] == "11"){
							$(".intro").fadeOut(300);
							$("#coupondownyes").hide();
							$("#coupondownno").show();
							$("#couponLayer").fadeIn(300);
							$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
							return false;
						}else if (str1[0] == "10"){
							alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
							return false;
						}else if (str1[0] == "09"){
							alert('이미 쿠폰을 받으셨습니다.');
							return false;
						}else if (str1[0] == "08"){
							alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
							return false;
						}else if (str1[0] == "07"){
							alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오.');
							return false;
						}else if (str1[0] == "06"){
							alert('쿠폰은 오전 10시부터 다운 받으실수 있습니다.');
							return false;
						}else if (str1[0] == "05"){
							alert('고객님은 쿠폰발급 대상이 아닙니다.');
							return false;
						}else if (str1[0] == "04"){
							alert('한 개의 아이디당 한 번만 응모가 가능 합니다.');
							return false;
						}else if (str1[0] == "03"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (str1[0] == "03"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (str1[0] == "02"){
							alert('로그인을 해주세요.');
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
					<% 'end if %>
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

<div class="mEvt68588">
	<% '<!-- intro --> %>
<!-- 	<div class="intro"> -->
<!-- 		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/txt_warning.png" alt="이 페이지는 아직 한번도 구매하지 않은 당신을 위해 준비하였습니다." /></p> -->
<!-- 		<span class="click">클릭!</p> -->
<!-- 	</div> -->
	<% '<!--// intro --> %>
	<div class="title" id="title">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/tit_orange_foot.png" alt="오렌지 족" /></h2>
		<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_socks.png" alt="" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/bg_socks.png" alt="" /></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/txt_info.gif" alt="텐바이텐 오렌지족이란? 신규가입회원, 구매경험이 없는 고객" /></p>
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_slide_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_slide_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_slide_04.jpg" alt="" /></div>
			</div>
		</div>
		<div class="pageNum"></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/txt_price.png" alt="델리삭스 SET - 2000원(쿠폰할인가)" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/txt_process.png" alt="쿠폰발급받고 구매하러가기→원하는 세트 고르기→쿠폰 사용하여 결제하기" /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/txt_coupon.png" alt="오늘 당신만을 위한 엄청난 쿠폰으로 첫 구매에 도전하세요!" /></p>
	<% '<!-- 쿠폰 다운받기 --> %>
	<div class="getCoupon">
		<a href="#" onclick="jscoupondown(); return false;" class="goBuy move">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/btn_coupon.png" alt="쿠폰 받고 구매하러 가기" />
		</a>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/bg_socks_02.png" alt="" /></div>
	</div>

	<% '<!-- 구매하러가기 레이어 --> %>
	<div id="couponLayer" class="couponLayer" style="display:none;">
		<div class="layerCont">
			<% if isApp=1 then %>
				<a href="#" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1422226'); return false;">
			<% Else %>
				<a href="/category/category_itemPrd.asp?itemid=1422226" target="_blank">
			<% End If %>

				<% if subscriptcount>0 or itemcouponcount>0 then %>
					<% '<!-- 이미 발급 받은 경우 --> %>
					<img id="coupondownyes" src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_layer_buy_02.png" alt="이미 쿠폰이 발급되었습니다" />
				<% else %>
					<img id="coupondownno" src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_layer_buy_01.png" alt="쿠폰이 발급되었습니다" />
				<% end if %>
			</a>
			<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/btn_layer_close.png" alt="닫기" /></button>
		</div>
	</div>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>텐바이텐에서 한번도 구매이력이 없는 오렌지등급 고객님을 위한 이벤트입니다.</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>ID 당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
			<li>본 상품은 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68588/m/img_ex.png" alt="" /></div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->
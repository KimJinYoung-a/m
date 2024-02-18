<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 레드-썬
' History : 2017-12-15 이종화
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , getbonuscoupon2 , totalbonuscouponcountusingy1 , totalbonuscouponcountusingy2
Dim userid :  userid = getencloginuserid()
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67488
	getbonuscoupon1 = 2863
	getbonuscoupon2 = 2864
Else
	eCode   =  82766
	getbonuscoupon1 = 1016	
	getbonuscoupon2 = 1017	
End If

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1&","&getbonuscoupon2, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" or userid = "motions" Then
'couponcnt=200000
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if

%>
<style type="text/css">
.red-sun .topic {position:relative; background-color:#eb382f;}
.red-sun .slide,
#slideshow div {position:absolute; bottom:0; left:0; z-index:10; width:100%;}
#slideshow div {z-index:8; opacity:0.0;}
#slideshow div.active {z-index:10; opacity:1.0;}
#slideshow div.last-active {z-index:9;}

.red-sun-coupon {position:relative; background-color:#333858;}
.red-sun-coupon .label {position:absolute; top:32.67%; right:5.86%; width:14.8%;}
.red-sun-coupon .btn-download,
.red-sun-coupon .coupon-close,
.red-sun-coupon h3 {position:absolute; bottom:20.35%; left:50%; width:78.13%; margin-left:-39.065%;}
.red-sun-coupon h3 {bottom:3.84%;}
.red-sun-coupon .noti {display:none; position:absolute; top:93.72%; left:50%; z-index:10; width:29.44rem; height:19.71rem; margin-left:-14.72rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/82766/m/bg_pattern_purple.png) 50% 0 no-repeat; background-size:100% auto;}
.noti .btn-close {position:absolute; top:0.85rem; right:0; width:3.75rem; background-color:transparent;}
.noti ul {padding:4.1rem 2.05rem 0;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1.11rem; line-height:1.54em; text-align:left;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:currentColor;}

.red-sun-event-01 {background-color:#37314f;}
.red-sun-event-02 {padding-bottom:20%; background:#f03d34 url(http://webimage.10x10.co.kr/eventIMG/2017/82766/m/bg_red.jpg) 50% 0 repeat-y; background-size:100% auto;}
.red-sun-event-list {overflow:hidden; position:relative; width:89.5%; margin:0 auto;}
.red-sun-event-list .half {width:50%;}
.red-sun-event-list-01 .event03 {position:absolute; top:0; right:0;}
.red-sun-event-list-02 > div, .red-sun-event-list-04 > div {float:left;}
.red-sun-event-list-02 .event05, .red-sun-event-list-02 .event09, .red-sun-event-list-04 .event15 {width:58.2%;}
.red-sun-event-list-02 .event06, .red-sun-event-list-02 .event08, .red-sun-event-list-04 .event16 {width:41.8%;}
.red-sun-event-list-02 .event07, .red-sun-event-list-02 .event10 {float:none;}
.red-sun-event-list-03 .event12, .red-sun-event-list-03 .event13 {position:absolute; right:0;}
.red-sun-event-list-03 .event12 {top:0;}
.red-sun-event-list-03 .event13 {bottom:0;}

.scale-animation {backface-visibility:visible; animation:scale-animation 1.2s 7; animation-fill-mode:both;}
@keyframes scale-animation {
	0% {transform: scale(0.8); opacity:0;}
	100% {transform: scale(1); opacity:1;}
}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt82766").offset().top}, 0);
});

var isStopped = false;
function slideSwitch() {
	if (!isStopped) {
		var $active = $("#slideshow div.active");
		if ($active.length == 0) $active = $("#slideshow div:last");
		var $next = $active.next().length ? $active.next() : $("#slideshow div:first");

		$active.addClass('last-active');

		$next.css({
			opacity:0.0
		})
			.addClass("active")
			.animate({
			opacity: 1.0
		}, 0, function () {
			$active.removeClass("active last-active");
		});
	}
	}

	$(function () {
	setInterval(function () {
		slideSwitch();
	}, 500);

	$("#slideshow").hover(function () {
		isStopped = false;
	}, function () {
		isStopped = false;
	});

	$("#noti a").on("click", function(e){
		$("#noticontents").fadeIn(100);
		return false;
	});
	$("#noticontents .btn-close").on("click", function(e){
		$("#noticontents").fadeOut(100);
	});
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #12/18/2017 00:00:00# and now() < #12/19/2017 23:59:59# then %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n12월 19일 자정까지 사용하세요. ');
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
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
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

<div class="mEvt82766 red-sun">
	<div class="section topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/tit_red_sun.jpg" alt="레드 썬! 데이 단, 2일 마법에 걸린 특급세일 지금 확인하세요!" /></h2>
		<div id="slideshow" class="slide">
			<div class="active"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_upto_01.jpg" alt="Up to 94%" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_upto_02.jpg" alt="" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_upto_03.jpg" alt="" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_upto_04.jpg" alt="" /></div>
		</div>
	</div>

	<div class="section red-sun-coupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_coupon.png" alt="리얼쿠폰 진짜루? 할인에 할인을 도와주는 쿠폰! 6만원 이상 구매 시 만원 할인, 20만원 이상 삼만원 할인, 사용기간 12/18~19까지 2일간" /></p>
		<% If now() > #12/19/2017 00:00:00# Then %>
		<b class="label scale-animation"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_label_close.png" alt="마감 임박" /></b>
		<% End If %>
		<button type="button" class="btn-download" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/btn_download.gif" alt="쿠폰 한번에 다운받기" /></button>

		<h3 id="noti"><a href="#noticontents"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/tit_noti.png" alt="이벤트 유의사항" /></a></h3>
		<div id="noticontents" class="noti">
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
				<li>쿠폰은 12/19(화) 23시 59분 59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/btn_close.png" alt="닫기" /></button>
		</div>
	</div>

	<div class="section red-sun-event red-sun-event-01">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/tit_sale.jpg" alt="세일, 레드 썬 당신만을 위해 준비했어요!" /></h3>
		<ul>
			<li class="event01"><a href="eventmain.asp?eventid=82767"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_sale_01.jpg" alt="단독특가, 기대해! 연말 할인의 성장통, 텐바이텐 단독 세일 이벤트 바로가기" /></a></li>
			<li class="event02"><a href="eventmain.asp?eventid=82769"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_sale_02.jpg" alt="두고봐, 하나 더 줄거야! 이렇게 하나를 더? 이거 받아도 되는거에요? 이벤트 바로가기" /></a></li>
			<li class="event03"><a href="eventmain.asp?eventid=82768"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_sale_03.jpg" alt="숨지마~ 스크래치! 스크래치, 있는지 모를 정도의 퀄리티에 최저가로~ 이벤트 바로가기" /></a>
			</li>
		</ul>
	</div>

	<div class="section red-sun-event red-sun-event-02">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/tit_discount.png" alt="할인이 왜 거기서 나와?" /></h3>
		<div class="red-sun-event-list red-sun-event-list-01">
			<div class="event01 half"><a href="eventmain.asp?eventid=82928"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_01.jpg" alt="수제 브랜드전" /></a></div>
			<div class="event02 half"><a href="eventmain.asp?eventid=82950"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_02.jpg" alt="주얼리/시계 BEST ITEM" /></a></div>
			<div class="event03 half"><a href="eventmain.asp?eventid=82970"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_03.jpg" alt="패션 베스트 BRAND 5" /></a></div>
			<div class="event04"><a href="eventmain.asp?eventid=82897"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_04.jpg" alt="가구 베스트 BRAND 10" /></a></div>
		</div>
			
		<div class="red-sun-event-list red-sun-event-list-02">
			<div class="event05"><a href="eventmain.asp?eventid=82914"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_05.jpg" alt="여행 BEST ITEM" /></a></div>
			<div class="event06"><a href="eventmain.asp?eventid=82915"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_06.jpg" alt="BAG&amp;SHOES 브랜드대전" /></a></div>
			<div class="event07"><a href="eventmain.asp?eventid=82932"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_07.jpg" alt="본격! 뷰티 월동 준비" /></a></div>
			<div class="event08"><a href="eventmain.asp?eventid=82944"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_08.jpg" alt="브래디백 할인전" /></a></div>
			<div class="event09"><a href="eventmain.asp?eventid=82901"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_09.jpg" alt="러그 &amp; 발매트 특가 모음전" /></a></div>
			<div class="event10"><a href="eventmain.asp?eventid=82902"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_10.jpg" alt="캣앤독 베스트 BRAND 5" /></a></div>
		</div>

		<div class="red-sun-event-list red-sun-event-list-03">
			<div class="event11 half"><a href="eventmain.asp?eventid=82903"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_11.jpg" alt="토이 베스트 BRAND 5" /></a></div>
			<div class="event12 half"><a href="eventmain.asp?eventid=82898"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_12.jpg" alt="키친 베스트 BRAND 5" /></a></div>
			<div class="event13 half"><a href="eventmain.asp?eventid=82896"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_13.jpg" alt="데코/조명 베스트 BRAND 5" /></a></div>
		</div>

		<div class="red-sun-event-list red-sun-event-list-04">
			<div class="event14"><a href="eventmain.asp?eventid=83076"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_14.jpg" alt="패브릭 베스트 BRAND 5" /></a></div>
			<div class="event15"><a href="eventmain.asp?eventid=82943"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_15.jpg" alt="오아 브랜드전" /></a></div>
			<div class="event16"><a href="eventmain.asp?eventid=82899"><img src="http://webimage.10x10.co.kr/eventIMG/2017/82766/m/img_discount_16.jpg" alt="푸드 베스트 특가 모음전" /></a></div>
		</ul>
	</div>
</div>

<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" or userid = "motions" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량 : 쿠폰번호 "&getbonuscoupon1&"<br>"
	response.write totalbonuscouponcountusingy2&"-사용수량 : 쿠폰번호 "&getbonuscoupon2&""
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
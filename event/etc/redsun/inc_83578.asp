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
	eCode   =  83578
	getbonuscoupon1 = 1025	
	getbonuscoupon2 = 1026	
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
.red-sun .topic {position:relative; background-color:#3e03ba;}
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
.red-sun-coupon .noti {display:none; position:absolute; top:93.72%; left:50%; z-index:10; width:29.44rem; height:17.5rem; margin-left:-14.72rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/83578/m/bg_pattern_purple.png) 50% 0 no-repeat; background-size:100% auto;}
.noti .btn-close {position:absolute; top:1rem; right:0; width:3.75rem; background-color:transparent;}
.noti ul {padding:3.8rem 2.05rem 0;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#fff; font-size:1.11rem; line-height:1.54em; text-align:left;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:currentColor;}

.red-sun-event-01 {background-color:#0b0220;}
.red-sun-event-02 {padding-bottom:20%; background:#681a99 url(http://webimage.10x10.co.kr/eventIMG/2018/83578/m/bg_purple.png) 0 0 repeat; background-size:100% auto;}
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
	window.$('html,body').animate({scrollTop:$(".mEvt83578").offset().top}, 0);
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
		<% If now() > #01/15/2018 00:00:00# and now() < #01/16/2018 23:59:59# then %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n1월 16일 자정까지 사용하세요. ');
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

<div class="mEvt83578 red-sun">
	<div class="topic">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/tit_red_sun.jpg?v=1" alt="레드 썬! 데이 단, 2일 마법에 걸린 특급세일 지금 확인하세요!" /></h2>
		<div id="slideshow" class="slide">
			<div class="active"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_upto_01.jpg" alt="Up to 94%" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_upto_02.jpg" alt="" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_upto_03.jpg" alt="" /></div>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_upto_04.jpg" alt="" /></div>
		</div>
	</div>

	<div class="red-sun-coupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_coupon.jpg" alt="리얼쿠폰 진짜루? 할인에 할인을 도와주는 쿠폰! 6만원 이상 구매 시 만원 할인, 20만원 이상 삼만원 할인" /></p>
		<% If now() > #01/16/2018 00:00:00# Then %>
		<b class="label scale-animation"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_label_close.png" alt="마감 임박" /></b>
		<% End If %>
		<button type="button" class="btn-download" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/btn_download.gif" alt="쿠폰 한번에 다운받기" /></button>
		<h3 id="noti"><a href="#noticontents"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/tit_noti.png" alt="이벤트 유의사항" /></a></h3>
		<div id="noticontents" class="noti">
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
				<li>쿠폰은 01/16(화) 23시 59분 59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
			<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/btn_close.png" alt="닫기" /></button>
		</div>
	</div>

	<div class="red-sun-event-01">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/tit_sale.jpg" alt="세일, 레드 썬 당신만을 위해 준비했어요!" /></h3>
		<ul>
			<li><a href="/event/eventmain.asp?eventid=83579" onclick="jsEventlinkURL(83579);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_sale_01.jpg" alt="단독특가, 기대해! 연말 할인의 성장통, 텐바이텐 단독 세일 이벤트 바로가기" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=83581" onclick="jsEventlinkURL(83581);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_sale_02.jpg?v=1.1" alt="두고봐, 하나 더 줄거야! 이렇게 하나를 더? 이거 받아도 되는거에요? 이벤트 바로가기" /></a></li>
			<li><a href="/event/eventmain.asp?eventid=83580" onclick="jsEventlinkURL(83580);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_sale_03.jpg?v=1.1" alt="숨지마~ 스크래치! 스크래치, 있는지 모를 정도의 퀄리티에 최저가로~ 이벤트 바로가기" /></a>
			</li>
		</ul>
	</div>
	<div class="red-sun-event-02">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/tit_discount.png?v=1" alt="할인이 왜 거기서 나와?" /></h3>
		<div class="red-sun-event-list red-sun-event-list-01">
			<div class="event01 half"><a href="/event/eventmain.asp?eventid=83672" onclick="jsEventlinkURL(83672);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_01.jpg?v=1" alt="음향기기" /></a></div>
			<div class="event02 half"><a href="/event/eventmain.asp?eventid=83611" onclick="jsEventlinkURL(83611);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_02.jpg?v=1" alt="주얼리/시계" /></a></div>
			<div class="event03 half"><a href="/event/eventmain.asp?eventid=83640" onclick="jsEventlinkURL(83640);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_03.jpg?v=1" alt="패션" /></a></div>
			<div class="event04"><a href="/event/eventmain.asp?eventid=83624" onclick="jsEventlinkURL(83624);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_04.jpg?v=1" alt="가구" /></a></div>
		</div>
		<div class="red-sun-event-list red-sun-event-list-02">
			<div class="event05"><a href="/event/eventmain.asp?eventid=83622" onclick="jsEventlinkURL(83622);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_05.jpg?v=1" alt="여행" /></a></div>
			<div class="event06"><a href="/event/eventmain.asp?eventid=83585" onclick="jsEventlinkURL(83585);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_06.jpg?v=1" alt="BAG&amp;SHOES" /></a></div>
			<div class="event07"><a href="/event/eventmain.asp?eventid=83610" onclick="jsEventlinkURL(83610);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_07.jpg?v=1" alt="뷰티" /></a></div>
			<div class="event08"><a href="/event/eventmain.asp?eventid=83625" onclick="jsEventlinkURL(83625);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_08.jpg?v=1" alt="수납" /></a></div>
			<div class="event09"><a href="/event/eventmain.asp?eventid=83648" onclick="jsEventlinkURL(83648);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_09.jpg?v=1" alt="베이비" /></a></div>
			<div class="event10"><a href="/event/eventmain.asp?eventid=83635" onclick="jsEventlinkURL(83635);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_10.jpg?v=1" alt="캣앤독" /></a></div>
		</div>
		<div class="red-sun-event-list red-sun-event-list-03">
			<div class="event11 half"><a href="/event/eventmain.asp?eventid=83637" onclick="jsEventlinkURL(83637);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_11.jpg?v=1" alt="토이" /></a></div>
			<div class="event12 half"><a href="/event/eventmain.asp?eventid=83631" onclick="jsEventlinkURL(83631);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_12.jpg?v=1" alt="키친" /></a></div>
			<div class="event13 half"><a href="/event/eventmain.asp?eventid=83630" onclick="jsEventlinkURL(83630);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_13.jpg?v=1" alt="데코/조명" /></a></div>
		</div>
		<div class="red-sun-event-list red-sun-event-list-04">
			<div class="event14"><a href="/event/eventmain.asp?eventid=83641" onclick="jsEventlinkURL(83641);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_14.jpg?v=1" alt="패브릭" /></a></div>
			<div class="event15"><a href="/event/eventmain.asp?eventid=83618" onclick="jsEventlinkURL(83618);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_15.jpg?v=1" alt="디자인가전" /></a></div>
			<div class="event16"><a href="/event/eventmain.asp?eventid=83647" onclick="jsEventlinkURL(83647);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83578/m/img_discount_16.jpg?v=1" alt="푸드" /></a></div>
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
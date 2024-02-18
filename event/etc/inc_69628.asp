<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 방가방가 첫 구매! MA
' History : 2016.03.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<%
dim eCode, userid, currenttime, i
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66061"
	Else
		eCode = "69628"
	End If

currenttime = now()
'															currenttime = #03/14/2016 10:05:00#

userid = GetEncLoginUserID()

dim couponidx
	IF application("Svr_Info") = "Dev" THEN
		couponidx = "11124"
	Else
		couponidx = "11492"
	End If

Dim selectitemid
	IF application("Svr_Info") = "Dev" THEN
		selectitemid = "1210578"
	Else
		selectitemid = "1450183"
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

if GetLoginUserID="greenteenz" or GetLoginUserID="djjung" or GetLoginUserID="bborami" or GetLoginUserID="kyungae13" or GetLoginUserID="tozzinet" or GetLoginUserID="thensi7" or GetLoginUserID="baboytw" or GetLoginUserID="kobula" then
	administrator=TRUE
end If

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}
.mEvt69628 {overflow:hidden; position:relative;}
.swiper {position:relative;}
.swiper button {position:absolute; top:50%; z-index:40; width:9.375%; background:transparent;}
.swiper .prev {left:5%;}
.swiper .next {right:5%;}
.getCoupon {position:relative;}
.getCoupon .goBuy {position:absolute; left:13%; top:54.8%; width:75%;}
.evtNoti {color:#fff; padding:1.9rem 4.7% 0; background:#4d393b;}
.evtNoti h3 {padding-bottom:0.8rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2.1rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69628/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:10px; font-size:1.1rem; line-height:1.4; letter-spacing:-0.012em;}
.evtNoti li a {display:block; width:10.5rem; margin:0.3rem 0 0.8rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.55rem; width:0.4rem; height:1px; background:#fff;}
.couponLayer {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:50;}
.couponLayer .layerCont {position:absolute; left:6%; top:8%; width:88%;}
.couponLayer .btnClose {position:absolute; right:5.5%; top:4.5%; z-index:55; width:10%; background:transparent;}

/* animation */
.move {-webkit-animation:move 0.3s ease-in-out 2s 50 alternate; -moz-animation:move 0.3s ease-in-out 2s 50 alternate; -ms-animation:move 0.3s ease-in-out 2s 50 alternate; -o-animation:move 0.3s ease-in-out 2s 50 alternate; animation:move 0.3s ease-in-out 2s 50 alternate;}
@keyframes move {from {transform:translate(0,-6px);} to {transform:translate(0,0);}}
@-webkit-keyframes move { from {-webkit-transform:translate(0,-6px);} to {-webkit-transform:translate(0,0);}}
@-moz-keyframes move {from {-moz-transform:translate(0,-6px);} to{-moz-transform:translate(0,0);}}
@-o-keyframes move {from {-o-transform:translate(0,-6px);} to {-o-transform:translate(0,0);}}
@-ms-keyframes move {from {-ms-transform:translate(0,-6px);} to {-ms-transform:translate(0,0);}}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69628").offset().top}, 0);
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		pagination:false,
		speed:400,
		autoplay:2500,
		nextButton:'.next',
		prevButton:'.prev',
		effect:'fade'
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 500);
	});
	$(".btnClose").click(function(){
		$("#couponLayer").fadeOut(300);
	});
});

function jscoupondown(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-03-14" and left(currenttime,10)<"2016-03-21" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if GetLoginUserLevel<>"5" and not(administrator) then %>
				alert("고객님은 쿠폰발급 대상이 아닙니다.");
				return;
			<% else %>
				<% if administrator then %>
					alert("[관리자] 특별히 관리자님이니까 오렌지 등급이 아니여도 다음 단계로 진행 시켜 드릴께요!");
				<% end if %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript69628.asp",
					data: "mode=coupondown&isapp=<%= isapp %>",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").fadeIn(300);
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
					return false;
				}else if (str1[0] == "10"){
					alert('데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오.');
					return false;
				}else if (str1[0] == "09"){
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").show();
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
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
					$("#couponLayer").empty().html(str1[1]);
					$("#couponLayer").fadeIn();
					$('html,body').animate({scrollTop: $("#title").offset().top},'slow');
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
				}else if (str1[0] == "12"){
					alert('오전 10시부터 응모하실 수 있습니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
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

function goDirOrdItem()
{
	<% if isapp="1" then %>
        document.directOrd.target = "iiBagWin";
	<% end if %>
	document.directOrd.submit();
}

function poplayerclose()
{
	$("#couponLayer").hide();
	location.reload();
}
</script>
<div class="mEvt69628" id="title">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/tit_hello.gif" alt="방가방가 첫 구매" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/txt_first_buy.png" alt="아직 한번도 구매하지 않은 고개분들께 상콤하게 에코백을 제안합니다!" /></p>
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_slide_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_slide_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_slide_04.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_slide_05.jpg" alt="" /></div>
			</div>
		</div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/btn_next.png" alt="다음" /></button>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/txt_price.png" alt="데일리라이크 에코백(랜덤발송) - 4000원(쿠폰할인가)" /></p>
	<%'' 쿠폰 다운받기 %>
	<div class="getCoupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/txt_coupon.png" alt="오늘 당신만을 위한 엄청난 쿠폰으로 첫 구매에 도전하세요!" /></p>
		<a href="" onclick="jscoupondown(); return false;" class="goBuy move"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/btn_buy.png" alt="쿠폰 받고 구매하러 가기" /></a>
	</div>

	<%'' 구매하러가기 레이어 %>
	<div id="couponLayer" class="couponLayer" style="display:none;"></div>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>
				텐바이텐에서 한번도 구매이력이 없는 오렌지등급 고객님을 위한 이벤트입니다.
				<% If isapp="1" Then %>
					<p><a href="" onclick="fnAPPpopupBrowserURL('10X10 등급혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/pop_Benefit.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/btn_grade.png" alt="회원등급 보러가기" /></a></p>
				<% Else %>
					<p><a href="" onclick="window.open('/my10x10/userinfo/pop_Benefit.asp','addreg','width=400,height=400,scrollbars=yes,resizable=yes');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/btn_grade.png" alt="회원등급 보러가기" /></a></p>
				<% End If %>
			</li>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>ID 당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
			<li>이벤트는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
		</ul>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69628/m/img_ex.png" alt="" /></div>
</div>
<% If isapp="1" Then %>
	<form method="post" name="directOrd" action="/apps/appCom/wish/web2014/inipay/shoppingbag_process.asp">
<% Else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
<% End If %>
	<input type="hidden" name="itemid" value="<%=selectitemid%>">
	<input type="hidden" name="itemoption" value="0000">
	<input type="hidden" name="itemea" value="1">
<% If isapp="1" Then %>
	<input type="hidden" name="mode" value="DO3">
<% Else %>
	<input type="hidden" name="mode" value="DO2">
<% End If %>
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
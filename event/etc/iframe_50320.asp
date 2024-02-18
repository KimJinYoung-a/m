<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [무임승차이벤트]텐바이텐 배송 트럭을 잡아라! 
' History : 2014.03.20 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event50320Cls.asp" -->

<%
dim eCode, userid
	eCode=getevt_code
	userid = getloginuserid()

dim totalsubscriptcount, totalcouponcount, fixdaycouponcount, subscriptcount, couponcount
	totalsubscriptcount=0
	totalcouponcount=0
	fixdaycouponcount = 0
	subscriptcount = 0
	couponcount = 0

totalsubscriptcount = getevent_subscripttotalcount(eCode, getnowdate(), "", "")
totalcouponcount = getbonuscoupontotalcount(getcouponid, "", "", getnowdate())

if totalsubscriptcount > totalcouponcount then
	fixdaycouponcount = totalsubscriptcount
else
	fixdaycouponcount = totalcouponcount
end if

if fixdaycouponcount > maxcouponcount then fixdaycouponcount = maxcouponcount

subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate(), "", "")
couponcount = getbonuscouponexistscount(userid, getcouponid, "", "", getnowdate())
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > Love For Earth</title>
<style type="text/css">
.mEvt50321 {padding-bottom:7.7%;}
.mEvt50321 p {max-width:100%;}
.mEvt50321 img {vertical-align:top;}
.freeRiding {background-color:#caf7f1;}
.freeRiding img {width:100%;}
.freeRiding .eventTakepart .countDown {position:relative;}
.freeRiding .eventTakepart .countDown .count {position:absolute; left:38.33333%; top:0; width:29.27083%; padding-top:8%; text-align:center; color:#fff;}
.freeRiding .eventTakepart .countDown .count div {margin-bottom:5%;}
.freeRiding .eventTakepart .countDown .count div img {width:79px;}
.freeRiding .eventTakepart .countDown .count strong {border-bottom:3px solid #fff; font-size:26px;}
.freeRiding .eventTakepart .countDown .count strong img {width:16px; vertical-align:1px;}
@media all and (max-width:480px){
	.freeRiding .eventTakepart .countDown .count div img {width:52px;}
	.freeRiding .eventTakepart .countDown .count strong {font-size:17px;}
	.freeRiding .eventTakepart .countDown .count strong img {width:11px; vertical-align:-1px;}
}
</style>

<script type="text/javascript">

function jsnewcoupion(){
	<% If IsUserLoginOK() Then %>
		<% If not(getnowdate>="2014-03-24" and getnowdate<"2014-03-27") Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;			
		<% Else %>
			<% if maxcouponcount > fixdaycouponcount then %>
				<% if subscriptcount=0 and couponcount=0 then %>
					evtFrm1.mode.value="couponinsert";
					evtFrm1.submit();
				<% else %>
					alert("이미 다운 받으셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("오늘의 무임 승차권이 모두 발급 되었습니다.");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>

</head>
<body>

<!-- 텐바이텐 배송 트럭을 잡아라! -->
<div class="mEvt50321">
	<div class="freeRiding">
		<% ' for dev msg : 무임승차권이 모두 지급 되었을 경우 %>
		<% if maxcouponcount > fixdaycouponcount then %>
		<% else %>
			<p class="soldoutTicket"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_end_msg.jpg" alt="오늘의 무임승차권이 모두 지급되었습니다^^ 내일 다시 1000명에게 무임승차권을 드립니다! 내일은 놓치지 마세요~" /></p>
		<% end if %>

		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/tit_free_riding.jpg" alt="텐바이텐 상품 무임승차 이벤트 텐바이텐 배송트럭을 잡아라!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_free_riding.jpg" alt="서두르세요! 지금 텐바이텐 배송트럭이 출발하려고 합니다! 매일 하루에 1000명에게만 무료배송쿠폰을 드립니다. 이벤트 기간 : 2014.03.24~03.26 (3일간)" /></p>

		<div class="eventTakepart">
			<div class="countDown">
				<div class="count">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_count.gif" alt="현재 남은 오늘의 승차권" /></div>
					<strong><span><%= maxcouponcount-fixdaycouponcount %></span> <img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_count_amount.gif" alt="개" /></strong>
				</div>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/bg_delivery.jpg" alt="" />
			</div>

			<div class="ticket">
				<a href="" onclick="jsnewcoupion(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/btn_ticket.jpg" alt="무임승차권 발급 받기" /></a>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_condition.jpg" alt="무임승차권은 텐바이텐 배송상품만 가능하며, 1만원 이상 구매 시 사용할 수 있습니다." />
			</div>
		</div>

		<div class="eventNote">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50321/txt_note.gif" alt="이벤트 안내 : 무임승차권은 텐바이텐 배송상품만 적용됩니다. 아이디 당 하루에 1회만 쿠폰 다운이 가능하며, 쿠폰은 매일 선착순으로 1000명만 다운받을 수 있습니다. 무임승차권 다운 후 바로 적용하여 구매 가능합니다." /></p>
		</div>
	</div>
</div>
<!-- //텐바이텐 배송 트럭을 잡아라! -->
<form name="evtFrm1" action="/event/etc/doEventSubscript50320.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="coupongubun">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
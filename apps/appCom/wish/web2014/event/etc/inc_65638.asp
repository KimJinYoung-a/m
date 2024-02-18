<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 엄마쿠폰찬스! ..만원의 행복하고 비슷한..
' History : 2015.08.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, eCodedisp, userid, getbonuscoupon, currenttime, getlimitcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64863"
		eCodedisp = "64863"
	Else
		eCode = "65638"
		eCodedisp = "65638"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2734"
	Else
		getbonuscoupon = "794"
	End If

	currenttime = now()
	'currenttime = #08/25/2015 14:05:00#

	userid = getloginuserid()

	'//제한수량 없으나, 혹시나 해서 제한둠
	getlimitcnt = 1000000

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

<style type="text/css">
img {vertical-align:top;}

.mEvt65638 .topic h2 {visibility:hidden; width:0; height:0;}
.couponBox {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65638/bg_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.couponBox .go {position:absolute; top:6%; left:25%; width:28.12%;}
.couponBox .btnCoupon {display:block; width:59.4%; margin:6% auto 12%;}

.updown {-webkit-animation-name:updown; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s; -moz-animation-name:updown; -moz-animation-iteration-count:5; -moz-animation-duration:1s; -ms-animation-name:updown; -ms-animation-iteration-count: infinite; -ms-animation-duration:1s;}
@-webkit-keyframes updown {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:2%; -webkit-animation-timing-function:ease-in;}
}
@keyframes updown {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:2%; animation-timing-function:ease-in;}
}

.lyBox {display:none; position:absolute; top:6%; left:6%; z-index:50; width:94.2%;}
.lyBox .btnclose {position:absolute; bottom:12%; left:26%; width:43%; background-color:transparent;}
.mask {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.8);}

.noti {padding:30px 20px; background-color:#f7f6f5;}
.noti h3 {color:#fc9377; font-size:13px;}
.noti h3 strong {display:inline-block; padding:5px 12px 2px; border-radius:20px; border:2px solid #fc9377; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:15px; color:#666; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #fc9377; border-radius:50%; background-color:transparent;}

@media all and (min-width:480px){
	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-08-24" and left(currenttime,10)<"2016-01-01" ) Then %>
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
						frm.action="/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript65638.asp";
						frm.target="evtFrmProc";
						frm.mode.value='couponreg';
						frm.submit();
					<% ' end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<div class="mEvt65638">
	<article>
		<div class="topic">
			<h2>엄마 쿠폰찬스</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/txt_coupon_chance.png" alt="살까 말까 고민하지 말고, 엄마 쿠폰찬스로 시원한 쇼핑하세요!" /></p>
		</div>

		<div class="couponBox">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/txt_coupon_v1.png" alt="텐바이텐 5천원 할인 쿠폰 삼만원 이상 구매시 사용 가능하며 오늘 하루 텐바이텐 앱에서만 사용하실 수 있습니다." /></p>
			<p class="go updown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/txt_go.png" alt="용돈 줄게 텐바이텐 다녀와!" /></p>
			<a href="" onclick="jseventSubmit(evtFrm1); return false;" class="btnCoupon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/btn_coupon.png" alt="쿠폰 받기" /></a>

			<% '<!-- layer --> %>
			<div id="lyBox" class="lyBox">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/txt_done_v2.png" alt="쿠폰이 발급되었습니다. 오늘 하루동안 고민하지 말고 시원하게! 텐바이텐 5천원 할인 쿠폰 삼만원 이상 구매시 사용 가능하며 오늘 하루 텐바이텐 앱에서만 사용하실 수 있습니다." /></p>
				<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/btn_close.png" alt="레이어 팝업 닫기" /></button>
			</div>

			<% '<!-- for dev msg : 투데이의 찬스 더보기로 링크 걸어주세요 --> %>
			<div class="bnr">
				<a href="" onClick="fnAPPpopupBrowserURL('CHANCE','<%=wwwUrl%>/apps/appcom/wish/web2014/sale/saleitem.asp'); return false;">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65638/btn_go.png" alt="엄마쿠폰 쿠폰은 이렇게 쓰도록해! 용돈 쓰러가기" /></a>
			</div>
		</div>

		<div class="noti">
			<h3><strong>유의사항</strong></h3>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
				<li>쿠폰은 금일 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다. </li>
			</ul>
		</div>

		<div class="mask"></div>
	</article>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

</body>
<script type="text/javascript">
$(function() {
	$(".btnclose, .mask").click(function(){
		$("#lyBox").hide();
		$(".mask").fadeOut();
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
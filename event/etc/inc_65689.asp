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
' Description : 복면쿠폰.. 만원의행복과 비슷한..
' History : 2015.08.24 한용민 생성
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
		eCode = "64865"
		eCodedisp = "64865"
	Else
		eCode = "65689"
		eCodedisp = "65689"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2735"
	Else
		getbonuscoupon = "770"
	End If

	currenttime = now()
	'currenttime = #08/26/2015 14:05:00#

	userid = getloginuserid()

	getlimitcnt = 25000

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
.mEvt65689 {position:relative; background-color:#fff;}
.couponBox {position:relative;}
.couponBox .mask {position:absolute; bottom:0; right:0; width:94.375%;}
.couponBox .btncoupon {position:absolute; bottom:10%; left:50%; width:42%; margin-left:-21%;}

.updown {-webkit-animation-name:updown; -webkit-animation-iteration-count:5; -webkit-animation-duration:1s; -moz-animation-name:updown; -moz-animation-iteration-count:5; -moz-animation-duration:2s; -ms-animation-name:updown; -ms-animation-iteration-count: infinite; -ms-animation-duration:2s;}
@-webkit-keyframes updown {
	from, to{bottom:0; -webkit-animation-timing-function:ease-out;}
	60% {bottom:1.5%; -webkit-animation-timing-function:ease-in;}
}
@keyframes updown {
	from, to{bottom:0; animation-timing-function:ease-out;}
	60% {bottom:1.5%; animation-timing-function:ease-in;}
}

.lyBox {display:none; position:absolute; top:22.5%; left:0; z-index:50; width:100%;}
.lyBox .btnclose {position:absolute; bottom:20%; left:50%; width:53.75%; margin-left:-26.875%; background-color:transparent;}
.dimmed {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.6);}

.etcBox {padding-bottom:3%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65689/bg_purple.jpg) no-repeat 50% 0; background-size:100% auto;}
.etcBox a {display:block; width:93.9%; margin:0 auto 5%;}

.noti {padding:5% 4.2%;}
.noti h3 {color:#222; font-size:13px;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #111; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:12px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:2px; left:0; width:0; height:0; border-top:4px solid transparent; border-bottom:4px solid transparent; border-left:6px solid #5c5c5c;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-08-26" and left(currenttime,10)<"2015-08-27" ) Then %>
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
						frm.action="/event/etc/doeventsubscript/doEventSubscript65689.asp";
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

<div class="mEvt65689">
	<div class="couponBox">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/txt_coupon.jpg" alt="8월 미스터리 이벤트 2탄 복면 쿠폰 복면 속을 확인해보세요! 오늘 하루 당신을 놀랍게 할 쿠폰이 찾아옵니다." /></p>
		<div class="mask updown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/img_mask.png" alt="" /></div>
		<a href="" onclick="jseventSubmit(evtFrm1); return false;" class="btncoupon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/btn_coupon.png" alt="쿠폰 확인하기" /></a>
	</div>

	<% '<!-- layer --> %>
	<div id="lyBox" class="lyBox">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/txt_done.png" alt="쿠폰이 발급되었습니다. 5만원 이상 구매시 만원 할인되며 쿠폰 사용기간은 8월 26일 수요일 하루 자정까지 앱에서만 사용가능합니다." /></p>
		<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/btn_close.png" alt="레이어 팝업 닫기" /></button>
	</div>

	<div class="etcBox">
		<% if not(isApp=1) then %>
			<% '<!-- for dev msg: 앱일 경우 숨겨주세요 --> %>
			<a href="/event/appdown/" target="_blank" id="app"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/btn_down.png" alt="아직이신가요? 텐바이텐 앱 다운받기" /></a>
		<% end if %>

		<% If userid = "" Then %>
			<% ' <!-- for dev msg: 로그인 되어 있을 경우에 숨겨주세요 --> %>
			<% if isApp=1 then %>
				<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO!" /></a>
			<% else %>
				<a href="/member/join.asp" target="_top">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65689/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO!" /></a>
			<% end if %>
		<% end if %>
	</div>

	<div class="noti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다. </li>
			<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
			<li>쿠폰은 금일 8/26(수) 23시59분 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
	</div>

	<div class="dimmed"></div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

<script type="text/javascript">
$(function() {
	/* layer */
//	$(".btncoupon").click(function(){
//		$("#lyBox").show();
//		$(".dimmed").fadeIn();
//	});

	$(".btnclose, .dimmed").click(function(){
		$("#lyBox").hide();
		$(".dimmed").fadeOut();
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
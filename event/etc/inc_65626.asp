<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐 처음이라면서요? ..만원의 행복하고 비슷한..
' History : 2015.08.17 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64857"
	Else
		eCode = "65626"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2733"
	Else
		getbonuscoupon = "767"
	End If

	currenttime = now()
	'currenttime = #08/18/2015 14:05:00#

	userid = getloginuserid()
	getlimitcnt = 500000

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
.couponbox {position:relative;}
.couponbox .btnDown {position:absolute; bottom:10%; left:50%; width:63.6%; margin-left:-31.8%;}
.eventbox {padding:9% 0 3%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65626/bg_line_pattern.png) repeat-y 50% 0; background-size:100% auto;}
.eventbox a {display:block; width:84.2%; margin:0 auto 8%;}

.noti {padding-top:8%;}
.noti h2 {padding:0 3.125%; color:#000; font-size:14px;}
.noti h2 strong {display:inline-block; padding:4px 9px 0; border-radius:20px; background-color:#d5d6d6; line-height:1.5em;}
.noti ul {margin-top:13px; padding:0 3.125%;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:6px; left:0; width:4px; height:1px; border-radius:50%; background-color:#444;}
.noti p {margin-top:3%;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}
@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-08-18" and left(currenttime,10)<"2015-09-16" ) Then %>
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
						frm.action="/event/etc/doeventsubscript/doEventSubscript65626.asp";
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

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};

</script>
</head>
<body>

<% '<!-- [M+APP] 텐바이텐 처음이라면서요? --> %>
<div class="mEvt65626">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/txt_coocha.png" alt="쿠차고객에게만 드리는 선착순 쿠폰 받으세요!" /></p>
	<div class="couponbox">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/txt_coupon.png" alt="텐바이텐 3천원 할인 쿠폰! 만원이상 구매시 사용가능하며 오늘 하루 앱에서만 사용하실 수 있습니다." /></p>
		<a href="" onclick="jseventSubmit(evtFrm1); return false;" class="btnDown"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/btn_down.png" alt="쿠폰 다운받기" /></a>
	</div>

	<div class="eventbox">
		<% ' <!-- 웹에서만 노출 --> %>
		<% if not(isApp=1) then %>
			<a href="javascript:gotoDownload();" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/btn_app.png" alt="아직이신가요? 텐바이텐 앱 다운받기" /></a>
		<% end if %>
		
		<% '<!-- 비회원에게만 노출 --> %>
		<% If userid = "" Then %>
			<% if isApp=1 then %>
				<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO!" /></a>
			<% else %>
				<a href="/member/join.asp" target="_top">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하고 구매하러 GO!" /></a>
			<% end if %>
		<% end if %>
	</div>

	<div class="noti">
		<h2><strong>이벤트 유의사항</strong></h2>
		<ul>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
			<li>쿠폰은 금일 23시59분 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될수 있습니다.</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65626/img_ex.png" alt="주문결제시 할인정보 입력에서 모바일 쿠폰에서 해당 쿠폰을 선택하실 수 있습니다." /></p>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
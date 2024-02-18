<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : show me the coupon
' History : 2015.08.03 한용민 생성
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
		eCode = "64844"
	Else
		eCode = "65062"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2729"
	Else
		getbonuscoupon = "759"
	End If

	currenttime = now()
	'currenttime = #08/05/2015 14:05:00#

	userid = getloginuserid()
	getlimitcnt = 60000

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
.mEvt65062 {background:#000;}
.mEvt65062 img {vertical-align:top;}
.mEvt65062 .showmeTheCoupon {background:url(http://webimage.10x10.co.kr/eventIMG/2015/65062/bg_brick.png) 0 0 repeat-y; background-size:100% auto ;}
.mEvt65062 .couponDownload {position:relative;}
.mEvt65062 .couponDownload a {display:block; position:absolute; left:10%; top:2.5%; width:80%; height:95%; color:transparent; background:transparent; z-index:40;}
.mEvt65062 .couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:50;}
.mEvt65062 .goBtn {padding:0 8%;}
.mEvt65062 .goBtn p {padding-bottom:20px;}
.mEvt65062 .goBtn p:first-child {padding-top:26px;}
.mEvt65062 .goBtn p:last-child {padding-bottom:40px;}
.mEvt65062 .evtNoti {padding-top:30px; margin-top:-1px; text-align:left; background:rgba(0,0,0,.44)}
.mEvt65062 .evtNoti h3 {text-align:center;}
.mEvt65062 .evtNoti h3 span {display:inline-block; font-size:15px; padding-bottom:1px; font-weight:bold; color:#dc0610; border-bottom:3px solid #dc0610;}
.mEvt65062 .evtNoti ul {padding:18px 4.5% 15px;}
.mEvt65062 .evtNoti li {position:relative; font-size:12px; line-height:1.2; padding:0 0 4px 10px; color:#cac9c9; }
.mEvt65062 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:4px; height:4px; background:#d50c0c; border-radius:50%;}
@media all and (min-width:480px){
	.mEvt65062 .goBtn p {padding-bottom:30px;}
	.mEvt65062 .goBtn p:first-child {padding-top:39px;}
	.mEvt65062 .goBtn p:last-child {padding-bottom:60px;}
	.mEvt65062 .evtNoti {padding-top:45px;}
	.mEvt65062 .evtNoti h3 span {font-size:23px; border-bottom:4px solid #dc0610;}
	.mEvt65062 .evtNoti ul {padding:27px 4.5% 23px;}
	.mEvt65062 .evtNoti li {font-size:18px; padding:0 0 6px 15px;}
	.mEvt65062 .evtNoti li:after {top:5px; width:6px; height:6px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-08-05" and left(currenttime,10)<"2015-08-07" ) Then %>
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
						frm.action="/event/etc/doeventsubscript/doEventSubscript65062.asp";
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

<!-- SHOW ME THE COUPON  -->
<div class="mEvt65062">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/tit_coupon.png" alt="쇼핑하는 연결고리 SHOW ME THE COUPON" /></h2>
	<div class="couponDownload">
		<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/img_coupon.png" alt="3만원 이상 구매시 5천원 할인쿠폰 - 8월5일~6일 2일간 사용 가능" /></p>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" /></p>
		<% else %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/img_coupon.png" alt="3만원 이상 구매시 5천원 할인쿠폰 - 8월5일~6일 2일간 사용 가능" /></p>
			<a href="" onclick="jseventSubmit(evtFrm1); return false;">쿠폰 다운받기</a>
		<% end if %>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/txt_stage.gif" alt="Special Stage - 본 쿠폰을 사용하신 고객대상으로 8월 10일 특별한 5,000원 마일리지가 찾아갑니다!" /></p>
	<div class="showmeTheCoupon">
		<div class="goBtn">
			<% ' <!-- 웹에서만 노출 --> http://bit.ly/1m1OOyE %>
			<% if not(isApp=1) then %>
				<p><a href="http://m.10x10.co.kr/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/btn_app_down.png" alt="텐바이텐 APP 다운받기" /></a></p>
			<% end if %>
			<% '<!-- 비회원에게만 노출 --> %>
			<% If userid = "" Then %>
				<% if isApp=1 then %>
					<p>
						<a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/btn_join.png" alt="회원가입하고 구매하러 가기" /></a>
					</p>
				<% else %>
					<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
				<% end if %>
			<% end if %>
		</div>

		<% '<!-- 배너 추가 --> %>
		<% if left(currenttime,10)<"2015-08-06" then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/bnr_app_gift01.jpg" alt="APP전용 게릴라 사은 이벤트(5일)" style="display:none" /></p>
		<% else %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/bnr_app_gift02.jpg" alt="APP전용 게릴라 사은 이벤트(6일)" style="display:none" /></p>
		<% end if %>
		<% '<!--// 배너 추가 --> %>

		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능합니다.</li>
				<li>쿠폰은 8/6(목) 23시 59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
				<li>마일리지는 8월 10일 일괄지급 될 예정입니다.</li>
				<li>8월 10일에 지급되는 마일리지의 사용 기간은 12일 자정까지이며 기간 내에 사용하지 않을 시 사전 통보 없이 자동 소멸합니다.</li>
			</ul>
			<p style="margin-bottom:-16px;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65062/img_use_ex.png" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
		</div>
	</div>
</div>
<!--// SHOW ME THE COUPON  -->
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
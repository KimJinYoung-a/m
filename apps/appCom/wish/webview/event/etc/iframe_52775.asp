<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : oh! oh! oh!
' History : 2014.06.20 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event52775Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->

<%
dim eCode, userid, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
dim ename, cEvent, emimg, smssubscriptcount, usercell
	eCode=getevt_code
	userid = getloginuserid()

bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0
smssubscriptcount=0
usercell=""

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "2", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", left(currenttime,10))

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing

smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
usercell = getusercell(userid)
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > Oh! Oh! Oh!</title>
<style type="text/css">
.mEvt52775 {position:relative;}
.mEvt52775 img {vertical-align:top; width:100%;}
.mEvt52775 p {max-width:100%;}
.mEvt52775 .download {padding-bottom:10%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52727/bg_wave.png) left top repeat-y #46cdf9; background-size:100% auto;}
.mEvt52775 .download .coupon {margin:-17% 0 10%;}
.mEvt52775 .evtNoti {padding:24px 10px 0; text-align:left; background:#fcf3e4;}
.mEvt52775 .evtNoti dt {padding:0 0 15px 12px}
.mEvt52775 .evtNoti dt img {width:70px;}
.mEvt52775 .evtNoti li {padding:0 0 8px 12px; font-size:13px; color:#444; line-height:14px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52727/blt_round.png) left 5px no-repeat; background-size:4px 4px;}
.mEvt52775 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt52775 .evtNoti dt img {width:47px;}
	.mEvt52775 .evtNoti li {padding:0 0 5px 12px; font-size:11px; line-height:12px; background-position:left 4px;}
}
</style>
<script type="text/javascript">

	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
		}
	}

	function jseventSubmit(frm){
		<% if not(geteventisusingyn) then %>
			alert("종료 되었습니다.");
			return;
		<% end if %>
	
		<% If IsUserLoginOK() Then %>
			<% If left(currenttime,10)>="2014-06-23" and left(currenttime,10)<"2014-06-30" Then %>
				<% if subscriptcount=0 and bonuscouponcount=0 then %>
					<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
						alert("종료 되었습니다.");
						return;
					<% else %>
						<% if Hour(currenttime) < 09 then %>
							alert("쿠폰은 오전 9시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript52775.asp";
							frm.target="evtFrmProc";
							frm.mode.value='couponreg';
							frm.submit();
						<% end if %>
					<% end if %>
				<% else %>
					alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			//alert('로그인을 하셔야 참여가 가능 합니다');
			//return;
			calllogin();
		<% End IF %>
	}

</script>
</head>
<body>

<!-- Oh!Oh!Oh!(APP) -->
<div class="mEvt52775">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/tit_ohohoh.png" alt="Oh!Oh!Oh! 오직 텐바이텐 에서만! 오늘만 쓸 수 있는 오천원의 혜택" /></h3>
	<div class="download">
		<div class="coupon">
			<% if subscriptcount=0 and bonuscouponcount=0 then %>
				<a href="" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/btn_coupon_download.png" alt="10X10 APP DOWNLOAD" /></a>
			<% else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/img_coupon_finish.png" alt="다운로드가 완료되었습니다. APP에서 사용하세요!" />
			<% end if %>
		</div>

		<% If IsUserLoginOK() Then %>
			<p><a href="" onclick="alert('이미 회원가입이 되어 있습니다.'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/btn_join.png" alt="아직 텐바이텐 회원이 아니신가요? - 회원 가입하기" /></a></p>
		<% else %>
			<p><a href="/apps/appcom/wish/webview/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/btn_join.png" alt="아직 텐바이텐 회원이 아니신가요? - 회원 가입하기" /></a></p>
		<% end if %>
	</div>
	<div class="evtNoti">
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/tit_tip.png" alt="사용 TIP" /></dt>
			<dd>
				<ul>
					<li><strong>텐바이텐 APP에서만 사용 가능합니다.</strong></li>
					<li>한 ID당 1회 발급, 1회 사용 할 수 있습니다.</li>
					<li>쿠폰은 발급시간으로부터 24시간 이내 사용가능합니다.</li>
					<li>구매금액이 5,000원 보다 적을 경우, 결제 시 0원처리 됩니다.</li>
					<li>상품에 따라, 배송비용이 발생 할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52775/img_use_guide.png" alt="" /></p>
	</div>
</div>
<!-- //Oh!Oh!Oh!(APP) -->
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
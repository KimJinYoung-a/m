<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : oh! oh! oh!
' History : 2014.07.08 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event53150Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->

<%
dim eCode, userid, subscriptcount, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount, elinkCode
dim ename, cEvent, emimg, smssubscriptcount, usercell
	eCode=getevt_code
	elinkCode=getevt_linkcode
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

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > Oh! Oh! Oh!</title>
<style type="text/css">
.mEvt53150 {position:relative;}
.mEvt53150 img {vertical-align:top; width:100%;}
.mEvt53150 p {max-width:100%;}
.mEvt53150 .download {width:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53149/bg_coupon_event.png) left top repeat-y; background-size:100% 5px;}
.mEvt53150 .download .coupon {padding-bottom:40px;}
.mEvt53150 .evtNoti {padding-top:24px; margin-top:10%; text-align:left; background:#fcf3e4;}
.mEvt53150 .evtNoti dt {padding:0 0 15px 12px}
.mEvt53150 .evtNoti dt img {width:70px;}
.mEvt53150 .evtNoti ul {padding:0 10px 10px;}
.mEvt53150 .evtNoti li {position:relative; padding:0 0 8px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53150 .evtNoti li:after {content:''; display:block; position:absolute; top:4px; left:0; width:0; height:0; padding:2px; background:#5eceb2; border-radius:10px;}
.mEvt53150 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53150 .evtNoti dt img {width:47px;}
	.mEvt53150 .evtNoti li {padding:0 0 5px 12px; font-size:11px; line-height:12px; background-position:left 4px;}
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
			<% If left(currenttime,10)>="2014-07-10" and left(currenttime,10)<"2014-07-11" Then %>
				<% if subscriptcount=0 and bonuscouponcount=0 then %>
					<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
						alert("종료 되었습니다.");
						return;
					<% else %>
						<% if Hour(currenttime) < 09 then %>
							alert("쿠폰은 오전 9시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript53150.asp";
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
			calllogin();
		<% End IF %>
	}
</script>
</head>
<body>

<!-- Oh! 만원!(APP) -->
<div class="mEvt53150">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/tit_oh_coupon.png" alt="Oh!만원! - oh!오늘 하루 APP에서 만원의 쇼핑혜택을 드립니다." /></h3>
	<div class="download">
		<div class="coupon">
			<% if subscriptcount=0 and bonuscouponcount=0 then %>
				<a href="#" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/btn_coupon_download.png" alt="10X10 APP DOWNLOAD" /></a>
			<% Else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/img_coupon_finish.png" alt="다운로드가 완료되었습니다. APP에서 사용하세요!" />
			<% End If %>
		</div>
		<% If IsUserLoginOK() Then %>
			<p><a href="" onclick="alert('이미 회원가입이 되어 있습니다.'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/btn_join.png" alt="아직 텐바이텐 회원이 아니신가요? - 회원 가입하기" /></a></p>
		<% Else %>
			<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/btn_join.png" alt="아직 텐바이텐 회원이 아니신가요? - 회원 가입하기" /></a></p>
		<% End If %>
	</div>
	<div class="evtNoti">
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/tit_tip.png" alt="사용 TIP" /></dt>
			<dd>
				<ul>
					<li><strong>텐바이텐 APP에서만 사용 가능합니다.</strong></li>
					<li>한 ID당 1회 발급, 1회 사용 할 수 있습니다.</li>
					<li>쿠폰은 다운받은 시점으로부터 24시간 이내 사용가능합니다.</li>
					<li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
					<li>이벤트는 조기 마감 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53150/img_use_guide.png" alt="" /></p>
	</div>
</div>
<!-- //Oh! 만원!(APP) -->
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
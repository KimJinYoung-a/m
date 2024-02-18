<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 순 할 인
' History : 2015.06.12 한용민 생성
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
		eCode = "63790"
	Else
		eCode = "63570"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2722"
	Else
		getbonuscoupon = "745"
	End If

	currenttime = now()
	'currenttime = #06/15/2015 14:05:00#

	userid = getloginuserid()
	getlimitcnt = 23000

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

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt63570 img {vertical-align:top;}
.mEvt63570 .couponDownload {position:relative;}
.mEvt63570 .couponDownload a {display:block; position:absolute; left:23%; bottom:18%; width:54%; height:15%; color:transparent; background:transparent; z-index:40;}
.mEvt63570 .couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:50;}
.mEvt63570 .goBtn {padding:0 3.75%; background:#ffd350;}
.mEvt63570 .goBtn p {padding-top:24px;}
.mEvt63570 .goBtn p:last-child {padding-bottom:34px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/63570/bg_dash.gif) 0 100% repeat-x; background-size:6px auto;}
.mEvt63570 .evtNoti {padding-top:20px; text-align:left; background:#ffd350;}
.mEvt63570 .evtNoti h3 {padding-left:23px;}
.mEvt63570 .evtNoti h3 span {display:inline-block; font-size:14px; padding-bottom:1px; font-weight:bold; color:#dc0610; border-bottom:2px solid #dc0610;}
.mEvt63570 .evtNoti ul {padding:15px 13px 0;}
.mEvt63570 .evtNoti li {position:relative; font-size:11px; line-height:1.2; padding:0 0 4px 10px; color:#444; }
.mEvt63570 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:4px; height:4px; background:#fff; border-radius:50%;}
.mEvt63570 .evtNoti li.cRd1:after {background:#dc0610;}
@media all and (min-width:480px){
	.mEvt63570 .goBtn p {padding-top:36px;}
	.mEvt63570 .goBtn p:last-child {padding-bottom:51px; background-size:30px auto;}
	.mEvt63570 .evtNoti {padding-top:30px;}
	.mEvt63570 .evtNoti h3 span {font-size:21px; padding-bottom:2px;}
	.mEvt63570 .evtNoti ul {padding:23px 3.75% 0;}
	.mEvt63570 .evtNoti li {font-size:17px; padding:0 0 6px 15px;}
	.mEvt63570 .evtNoti li:after {top:4px; width:6px; height:6px;}
}
</style>
<script type="text/javascript">

	function jseventSubmit(frm){
		<% If IsUserLoginOK() Then %>
			<% If not( left(currenttime,10)>="2015-06-15" and left(currenttime,10)<"2015-06-16" ) Then %>
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
						<% if Hour(currenttime) < 11 then %>
							alert("쿠폰은 오전 11시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							frm.action="/event/etc/doEventSubscript63570.asp";
							frm.target="evtFrmProc";
							frm.mode.value='couponreg';
							frm.submit();
						<% end if %>
					<% end if %>
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

</script>
</head>
<body>

<!-- 처음처럼 순한 순할인 -->
<div class="mEvt63570">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/tit_coupon.gif" alt="처음처럼 순한 순할인" /></h2>
	<div class="couponDownload">
		<% '<!-- 쿠폰 소진 시<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/txt_soldout.png" alt="앗! 쿠폰이 모두 소진되었어요!" /></p>--> %>
		<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/img_coupon_download.gif" alt="APP전용쿠폰 - 3만원 이상 구매 시 1만원 할인(6월 15일 하루동안 APP에서만 사용)" /></p>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/txt_soldout.png" alt="앗! 쿠폰이 모두 소진되었어요!" /></p>
		<% else %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/img_coupon_download.gif" alt="APP전용쿠폰 - 3만원 이상 구매 시 1만원 할인(6월 15일 하루동안 APP에서만 사용)" /></p>
			<a href="" onclick="jseventSubmit(evtFrm1); return false;">쿠폰 다운받기</a>
		<% end if %>
	</div>
	<div class="goBtn">
		<% ' <!-- 모바일웹에서만 노출 --> %>
		<% if not(isApp=1) then %>
			<p><a href="http://bit.ly/1m1OOyE" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/btn_app_download.gif" alt="텐바이텐 APP 다운받기" /></a></p>
		<% end if %>

		<% ' <!-- 비회원에게만 노출 --> %>
		<% If userid = "" Then %>
			<% if isApp=1 then %>
				<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
			<% else %>
				<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
			<% end if %>
		<% end if %>
	</div>
	<div class="evtNoti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li class="cRd1">지급된 쿠폰은 텐바이텐 APP에서만 사용가능 합니다.</li>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>쿠폰은 금일 6/15(월) 23시59분에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다. </li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63570/img_use_ex.gif" alt="결제시 할인정보 입력에서 모바일 쿠폰 항목에서 사용할 쿠폰을 선택하세요" /></p>
	</div>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="isapp" value="<%= isApp %>">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!-- // 처음처럼 순한 순할인 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
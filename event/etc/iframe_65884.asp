<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 스폰서 쿠폰
' History : 2015.09.03 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "64877"
	Else
		eCode = "65884"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2737"
	Else
		getbonuscoupon = "773"
	End If

	currenttime = now()
	'currenttime = #09/07/2015 14:05:00#

	userid = GetEncLoginUserID()
	getlimitcnt = 100000		'50000

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
img {vertical-align:top;}
.mEvt65884 {overflow:hidden;}
.mEvt65884 .couponDownload {position:relative;}
.mEvt65884 .couponDownload p {position:absolute;}
.mEvt65884 .couponDownload .btnCpDown {left:10%; bottom:10%; width:80%; height:82%; z-index:30;}
.mEvt65884 .couponDownload .btnCpDown a {display:block; width:100%; height:100%; color:transparent; font-size:0;}
.mEvt65884 .couponDownload .finishSoon {left:6%; top:0; width:18.2%; z-index:50;}
.mEvt65884 .couponDownload .soldout {left:0; top:0; width:100%; z-index:40;}
.mEvt65884 .couponDownload .lastDay {position:absolute; left:0; top:0; width:100%;}
.mEvt65884 .goBtn {padding:0 10%; background:#ffe6c3;}
.mEvt65884 .goBtn p {padding-left:4.2%; padding-right:4.2%; padding:25px 0; border-top:1px solid #d9c4a6;}
.mEvt65884 .goBtn p:first-child {border-top:0;}
.mEvt65884 .evtNoti {padding:25px 0; text-align:left; background:#fff7ec;}
.mEvt65884 .evtNoti h3 {text-align:center; padding-bottom:15px;}
.mEvt65884 .evtNoti h3 strong {display:inline-block; font-size:15px; padding-bottom:1px; color:#333; border-bottom:2px solid #333;}
.mEvt65884 .evtNoti ul {padding:0 7.8%;}
.mEvt65884 .evtNoti li {position:relative; font-size:11px; line-height:1.3; padding:0 0 4px 13px; color:#6e6e6e; }
.mEvt65884 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:5px; height:2px; background:#808080;}
@media all and (min-width:480px){
	.mEvt65884 .goBtn p {padding:38px 0;}
	.mEvt65884 .evtNoti {padding:38px 0;}
	.mEvt65884 .evtNoti h3 {padding-bottom:23px;}
	.mEvt65884 .evtNoti h3 strong {font-size:23px; border-bottom:3px solid #333;}
	.mEvt65884 .evtNoti li {font-size:17px; padding:0 0 6px 20px;}
	.mEvt65884 .evtNoti li:after {top:6px; width:7px; height:3px;}
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-05" and left(currenttime,10)<"2015-09-10" ) Then %>
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
						frm.action="/event/etc/doeventsubscript/doEventSubscript65884.asp";
						frm.target="evtFrmProc";
						frm.mode.value='couponreg';
						frm.submit();
					<% ' end if %>
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

<div class="mEvt65884">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/tit_sponsor.gif" alt="스폰서 쿠폰" /></h2>
	<div class="couponDownload">
		<p class="btnCpDown"><a href="" onclick="jseventSubmit(evtFrm1); return false;">4만원 이상 구매시 1만원 할인쿠폰 다운받기</a></p>

		<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회를 기다려주세요" /></p>
		<% else %>
			<% if ((getlimitcnt - totalsubscriptcount) < 5000) or ((getlimitcnt - totalbonuscouponcount) < 5000) then %>
				<p class="finishSoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/txt_finish_soon.png" alt="마감임박" /></p>
			<% end if %>
		<% end if %>
		
		<% if left(currenttime,10)="2015-09-09" then %>
			<div class="lastDay"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/img_coupon_02.gif" alt="오늘 밤 12시 쿠폰이 종료됩니다!" /></div>
		<% end if %>

		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/img_coupon_01.gif" alt="" /></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/txt_special_stage.gif" alt="SPECIAL STAGE - 본 쿠폰을 사용하신 고객님께 9월 11일 특별한 5,000마일리지가 찾아갑니다!" /></p>
	<div class="goBtn">
		<% if not(isApp=1) then %>
			<p><a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/btn_app_down.png" alt="텐바이텐 APP 다운받기" /></a></p>
		<% end if %>

		<% If userid = "" Then %>
			<% if isApp=1 then %>
				<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
			<% else %>
				<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65884/m/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
			<% end if %>
		<% end if %>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 선착순 한정수량으로 진행되어 조기 마감될 수 있습니다.</li>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
			<li>쿠폰 사용은 9/9(수) 23시 59분 59초에 마감됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>마일리지는 9월 11일 일괄지급 될 예정입니다.</li>
			<li>9월 11일에 지급되는 마일리지의 사용 기간은 14일 자정까지이며 기간 내에 사용하지 않을 시, 사전 통보없이 자동 소멸됩니다.</li>
		</ul>
	</div>
</div>

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
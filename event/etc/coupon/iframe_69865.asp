<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 태양의 쿠폰2
' History : 2016-03-22 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim getbonuscoupon1 , getlimitcnt1, getlimitcnt2 , currenttime
Dim totcnt1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66066"
	Else
		eCode = "69865"
	End If

	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon1 = "2772"
	Else
		getbonuscoupon1 = "840"
	End If

	userid = getEncLoginUserID()
	getlimitcnt1 = 20000		'20000
	currenttime = now()

dim bonuscouponcount1, subscriptcount, totalsubscriptcount1, totalbonuscouponcount1

bonuscouponcount1=0
subscriptcount=0
totalsubscriptcount1=0
totalbonuscouponcount1=0


'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount1 = getbonuscouponexistscount(userid, getbonuscoupon1, "", "", "")
end if

'//전체 참여수
totalsubscriptcount1 = getevent_subscripttotalcount(eCode, "", "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.mEvt69634 {position:relative;}
.couponDownload {position:relative;}
.couponDownload .soon {position:absolute; right:0; top:-7%; width:18.6%; z-index:30;}
.couponDownload .soldout {position:absolute; left:0; top:0; z-index:30; width:100%;}
.btnArea {padding:0 4.68%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69727/m/bg_stripe.png) repeat-y 0 0; background-size:100% auto;}
.btnArea a {display:inline-block; padding:2.1rem 8.6%; border-bottom:1px solid #757468;}
.btnArea a:last-child {border-bottom:0;}
.evtNoti {color:#7a7a7a; padding:2.3rem 7.8% 0; background:#e3e3e3;}
.evtNoti h3 {padding-bottom:0.8rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:1.5rem; color:#2d2d2d; border-bottom:0.2rem solid #2d2d2d;}
.evtNoti li {position:relative; padding-left:1.2rem; font-size:1rem; line-height:1.4; letter-spacing:-0.012em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.5rem; height:1px; background:#6e6e6e;}
</style>
<script type="text/javascript">
function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) = "2016-03-23" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1 then %>
				alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
				return;
			<% else %>
				frm.action="/event/etc/doeventsubscript/doEventSubscript69865.asp";
				frm.target="evtFrmProc";
				frm.mode.value='coupon';
				frm.submit();
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
<% If userid = "cogusdk" Or userid = "greenteenz" Or userid = "motions" Then %>
<div>
	<p>&lt;<%=getbonuscoupon1%>&gt; 쿠폰 발급건수 : <%=totalbonuscouponcount1%> </p>
</div>
<% End If %>
<div class="mEvt69865">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/tit_sun_coupon.png" alt="태양의 쿠폰" /></h2>
	<div class="couponDownload">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69865/m/img_coupon.png" alt="6만원 이상 구매 시 1만원 할인 쿠폰" /></div>
	<% if totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1 then %>
		<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다!" /></p>
		<% else %>
	<a href="" onclick="jseventSubmit(evtFrm1);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/btn_coupon.png" alt="쿠폰 다운받기" /></a>
		<% if ((getlimitcnt1 - totalsubscriptcount1) < 5000) or ((getlimitcnt1 - totalbonuscouponcount1) < 5000) then %>
		<p class="soon"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/txt_soon.png" alt="마감임박" /></p>
		<% End If %>
	<% End If %>
	</div>
	<div class="btnArea">
		<% if not(isApp=1) then %>
		<a href="/event/appdown/" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/btn_app_down.png" alt="텐바이텐 APP 다운" /></a>
		<% End If %>
		<% If userid = "" Then %>
			<% if isApp=1 then %>
			<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/btn_join.png" alt="회원가입하고 구매하러 GO!" /></a>
			<% Else %>
			<a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/btn_join.png" alt="회원가입하고 구매하러 GO!" /></a>
			<% End If %>
		<% End If %>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
			<li>쿠폰은 금일 3/23(수) 23시 59분 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/69727/m/img_ex.png" alt="" /></div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
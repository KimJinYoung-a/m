<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 해피 두개다 (쿠폰 이벤트)
' History : 2015-12-02 이종화 생성
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
Dim getbonuscoupon1 , getbonuscoupon2 , getlimitcnt1, getlimitcnt2 , currenttime
Dim totcnt1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65966"
	Else
		eCode = "67865"
	End If

	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon1 = "2752"
		getbonuscoupon2 = "2753"
	Else
		getbonuscoupon1 = "801"
		getbonuscoupon2 = "802"
	End If

	userid = getEncLoginUserID()
	getlimitcnt1 = 30000		'20000
	getlimitcnt2 = 30000		'20000
	currenttime = now()

dim bonuscouponcount1, subscriptcount, totalsubscriptcount1, totalbonuscouponcount1
dim bonuscouponcount2, totalsubscriptcount2, totalbonuscouponcount2

bonuscouponcount1=0
subscriptcount=0
totalsubscriptcount1=0
totalbonuscouponcount1=0

bonuscouponcount2=0
totalsubscriptcount2=0
totalbonuscouponcount2=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount1 = getbonuscouponexistscount(userid, getbonuscoupon1, "", "", "")
	bonuscouponcount2 = getbonuscouponexistscount(userid, getbonuscoupon2, "", "", "")
end if

'//전체 참여수
totalsubscriptcount1 = getevent_subscripttotalcount(eCode, "", "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
totalbonuscouponcount2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")

%>
<style type="text/css">
img {vertical-align:top;}
.couponDownload {position:relative; padding-bottom:10%; background:#0e8139;}
.couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:40;}
.btnCpDown {position:relative;}
.btnCpDown .finishSoon {position:absolute; left:0; top:0; width:25%; z-index:40;}
.goBtn {padding:0 10%; background:#0a662c;}
.goBtn p {padding-left:4.2%; padding-right:4.2%; padding-top:30px;}
.goBtn p:last-child {padding-bottom:30px;}
.evtNoti {padding:25px 6.25%; text-align:left; background:#ebebeb;}
.evtNoti h3 {padding-bottom:15px; margin-left:13px;}
.evtNoti h3 strong {display:inline-block; font-size:15px; padding-bottom:1px; color:#0a662c; border-bottom:2px solid #0a662c;}
.evtNoti li {position:relative; font-size:12px; line-height:1.3; padding:0 0 4px 13px; color:#000;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; background:#000; border-radius:50%;}
@media all and (min-width:480px){
	.goBtn p {padding-top:45px;}
	.goBtn p:last-child {padding-bottom:45px;}
	.evtNoti {padding:38px 6.25%;}
	.evtNoti h3 {padding-bottom:23px; margin-left:20px;}
	.evtNoti h3 strong {font-size:23px;}
	.evtNoti li {font-size:18px; padding:0 0 6px 20px;}
	.evtNoti li:after {top:6px; width:6px; height:6px;}
}
</style>
<script type="text/javascript">
function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2015-12-07" and left(currenttime,10) <= "2015-12-08" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if (totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1) and (totalsubscriptcount2>=getlimitcnt2 or totalbonuscouponcount2>=getlimitcnt2) then %>
				alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
				return;
			<% else %>
				frm.action="/event/etc/doeventsubscript/doEventSubscript67865.asp";
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
<div class="mEvt65884">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/tit_happy_two.png" alt="해피 두개다" /></h2>
	<div class="couponDownload">
		<div>
			<% If Date() <= "2015-12-07" Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/img_coupon_1207.png" alt="6만원이상 구매시 1만원할인/20만원 이상 구매시 3만원 할인" />
			<% ElseIf Date() >= "2015-12-08" Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/img_coupon_1208.png" alt="6만원이상 구매시 1만원할인/20만원 이상 구매시 3만원 할인" />
			<% End If %>
		</div>
		<% if totalsubscriptcount1>=getlimitcnt1 or totalbonuscouponcount1>=getlimitcnt1 then %>
		<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회를 기다려주세요" /></p>
		<% else %>
		<div class="btnCpDown">
			<a href="" onclick="jseventSubmit(evtFrm1);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>
			<% if ((getlimitcnt1 - totalsubscriptcount1) < 5000) or ((getlimitcnt1 - totalbonuscouponcount1) < 5000) then %>
				<p class="finishSoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/txt_soon.gif" alt="마감임박" /></p>
			<% End If %>
		</div>
		<% End If %>
	</div>
	<!--// 쿠폰 다운로드 -->
	<div class="goBtn">
		<% if not(isApp=1) then %>
		<p><a href="/event/appdown/" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/btn_app_down.png" alt="텐바이텐 APP 다운받기" /></a></p>
		<% End If %>
		<% If userid = "" Then %>
			<% if isApp=1 then %>
			<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
			<% Else %>
			<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67865/m/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></p>
			<% End If %>
		<% End If %>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
			<li>쿠폰은 금일 12/08(화) 23시59분 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
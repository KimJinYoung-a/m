<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [12월 신규가입이벤트] 1+1 Coupon!
' History : 2016.11.28 유태욱
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "66245"
Else
	eCode = "74620"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
img {vertical-align:top;}
.evtNoti {padding-bottom:1.5rem; background:#f8bb5b;}
.evtNoti .evtNotiConts {padding:2.5rem 4.7%;  color:#fff; background:#d28e3f;}
.evtNoti h3 {padding-bottom:1.2rem; font-size:1.4rem; font-weight:bold;}
.evtNoti li {padding-left:0.75rem; text-indent:-0.75rem; font-size:1rem; line-height:1.7;}
.evtNoti li a {color:#f73419; text-decoration:underline;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt74620").offset().top}, 0);
});

function fnCouponDownload() {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript74620.asp",
		data: "mode=down",
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "dn") {
				alert('다운로드가 완료되었습니다.\n24시간안에 사용하세요!');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			document.location.reload();
			return false;
		}
	<% End If %>
}
</script>
	<div class="mEvt74620">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/74620/m/tit_happy.jpg" alt="신규회원 전용 쿠폰 이벤트 해피두개더 12월 텐바이텐에 가입하는 모든 분들께 드립니다." /></h2>
		<div class="getCoupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/74620/m/img_coupons.jpg" alt="6만원 이상 구매 시 10,000원 10만원 이상 구매 시 15,000원 사용기간 : 발급후 24시간" /></div>
			<a href="" onclick="fnCouponDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74620/m/btn_coupons.jpg" alt="쿠폰 다운 받기" /></a>
		</div>
		<div class="evtNoti">
			<div class="evtNotiConts">
				<h3>이벤트 유의 사항</h3>
				<ul>
					<li>- 12월  신규가입  고객에게만 발급되는 쿠폰입니다.</li>
					<li class="mWeb">- 쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
					<li class="mApp">- 쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
					<li>- 발급 후 24시간 이내 미 사용시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
					<li>- 이벤트는 조기 종료 될 수 있습니다.</li>
				</ul>
			</div>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
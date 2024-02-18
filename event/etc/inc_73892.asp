<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID

IF application("Svr_Info") = "Dev" THEN
	eCode = "73892"
Else
	eCode = "66223"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
img {vertical-align:top;}
.evtNoti {padding:2.9rem 2.5rem; background:#f8e1cf;}
.evtNoti h3 {width:20.93%;}
.evtNoti ul {padding:1.6rem 0 0 0;}
.evtNoti li {padding:0 0 0.3rem 1.7rem; font-size:1rem; line-height:1.4; font-weight:bold; color:#696969; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73892/m/noti_bg_02.png) no-repeat 0 0.6rem; background-size:auto;}
.evtNoti li a {color:#f73419;}

</style>
<script type="text/javascript">
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
		url:"/event/etc/doeventsubscript/doEventSubscript73892.asp",
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
<div class="mEvt73892">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73892/m/tit_coupon.png" alt="신규회원 전용 이벤트 1+1 coupon 11월 텐바이텐에 가입하는 모든 분들께 드립니다!" /></h2>
	<div class="getCoupon">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73892/m/img_coupons.png" alt="6만원 이상 구매시 10,000원 발급 후 24시간 10만원 이상 구매시 15,000원 발급 후 24시간" /></div>
		<a href="#" onclick="fnCouponDownload(); return false;" class="btnJoin mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73892/m/btn_go_coupon_v2.png" alt="가입하고 쿠폰받기" /></a>
	</div>
	<div class="evtNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/73892/m/txt_noti.png" alt="쿠폰사용법" /></h3>
		<ul>
			<li>11월 신규가입 고객에게만 발급되는 쿠폰입니다.</li>
			<% If isapp Then %>
			<li class="app">쿠폰은 <a href="/apps/appCom/wish/web2014/my10x10/couponbook.asp" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
			<% Else %>
			<li class="mo">쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
			<% End If %>
			<li>발급 후 24시간  이내 미 사용시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
			<li>이벤트는 조기 종료 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
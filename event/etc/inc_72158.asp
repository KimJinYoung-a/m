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
	eCode = "66176"
Else
	eCode = "72158"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.followCoupon .app {display:none;}

.coupon {position:relative;}
.coupon .btnDownload {position:absolute; bottom:6.2%; left:50%; width:79.68%; margin-left:-39.84%;}

.guide {padding-bottom:8%; background-color:#e4e5e9;}
.guide ul {padding:0 4.53%;}
.guide ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#333a4c; font-size:1rem; line-height:1.5em;}
.guide ul li:first-child {margin-top:0;}
.guide ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#333a4c;}
.guide ul li a {color:#e41e1e; text-decoration:underline;}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".followCoupon .app").show();
			$(".followCoupon .mo").hide();
	}else{
			$(".followCoupon .app").hide();
			$(".followCoupon .mo").show();
	}
});

function fnCouponDownloads() {
	<% If Now() > #08/05/2016 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% End If %>

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
		url:"/event/etc/doeventsubscript/doEventSubscript72158.asp",
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
<div class="mEvt72158 followCoupon">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72158/m/tit_follow_coupon.gif" alt="신규회원 전용 이벤트 follow 쿠폰 8월 텐바이텐에 가입하는 모든 분들께 드립니다!" /></p>
	<div class="coupon">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72158/m/img_coupon.jpg" alt="삼만원 이상 구매시 오천원 할인 쿠폰, 육만원 이상 구매시 만원 할인 쿠폰, 십만원 이상 구매 시 만오천원 할인 쿠폰을 드리며 사용 기간은 발급 후 24시간 이내입니다." /></p>
		<a href="#" onclick="fnCouponDownloads(); return false;" class="btnDownload"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72158/m/btn_download.png" alt="쿠폰 다운받기" /></a>
	</div>
	<div class="guide">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72158/m/tit_coupon_guide.png" alt="쿠폰 사용법" /></h3>
		<ul>
			<li>8월 신규가입  고객에게만 발급되는 쿠폰입니다.</li>
			<li class="mo">쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
			<li class="app">쿠폰은 <a href="/apps/appCom/wish/web2014/my10x10/couponbook.asp" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
			<li>발급 후 24시간  이내 미 사용시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
			<li>이벤트는 조기 종료 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
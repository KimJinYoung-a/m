<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [신규가입이벤트] 쿠폰
' History : 2017.06.30 유태욱
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
	eCode = "66378"
Else
	eCode = "78784"
End If

vUserID = getEncLoginUserID
%>
<style>
.evtNoti {padding:3.5rem 8.5% 2.5rem; text-align:left; background:#efefef;}
.evtNoti h3 {padding-bottom:1.4rem; font-size:1.5rem; line-height:1; font-weight:bold; color:#000;}
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.4; color:#666; padding:0 0 0.3rem 0.9rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.65rem; width:0.4rem; height:0.1rem; background-color:#666;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt78688").offset().top}, 0);
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
		url:"/event/etc/doeventsubscript/doEventSubscript78784.asp",
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
	<div class="mEvt78688">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78784/m/tit_welcome.png" alt="신규회원 웰컴쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78784/m/img_coupon_v3.png" alt="7만원 이상 구매 시 5천원, 15만원 이상 구매 시 1만원 할인쿠폰" /></div>
			<p class="download"><a href="" onclick="fnCouponDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78784/m/btn_download.png" alt="쿠폰 다운받기" /></a></p>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78784/m/txt_benefit.png" alt="신규회원 가입 시 추가 혜택 - 5만원 이상 구매 시 2천원 할인, 2만원이상 구매 시 무료배송 쿠폰 증정" /></div>
		<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78784/m/txt_app_v2.png" alt="지금 APP을 설치하시면 5천원 쿠폰을 드려요!" /></a>
		<div class="evtNoti">
			<h3>유의사항</h3>
			<ul>
				<li>텐바이텐 신규가입 고객에게만 발급되는 쿠폰입니다.</li>
				<li class="mWeb">쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li class="mApp">쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li>발급 후 24시간 이내 미사용시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
				<li>이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
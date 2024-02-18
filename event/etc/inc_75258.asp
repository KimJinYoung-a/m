<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [1월 신규가입이벤트] 해피뉴이어 Coupon!
' History : 2016.12.30 유태욱
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
	eCode = "66261"
Else
	eCode = "75258"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
img {vertical-align:top;}
.evtNoti {padding:2.5rem 1.5rem 2.15rem 1.5rem; background:#5998bd;}
.evtNoti h3 {font-size:1.5rem; color:#fff; font-weight:600;}
.evtNoti ul {padding:1rem 0 0 0;}
.evtNoti li {position:relative; padding:0.2rem 0 0.2rem 1rem; font-size:1rem; line-height:1.25; color:#fff;}
.evtNoti li:before {position:absolute; left:0; top:0.7rem; display:block; width:0.35rem; height:1px; background-color:#fff; content:'';}
.evtNoti li a {color:#fff;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75258").offset().top}, 0);
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
		url:"/event/etc/doeventsubscript/doEventSubscript75258.asp",
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
	<div class="mEvt75258">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/75258/m/tit_coupon.png" alt="신규회원 전용 쿠폰이벤트 해피뉴이어쿠폰 1월 텐바이텐에 가입하는 모든 분들께 드립니다!" /></h2>
		<div class="getCoupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/75258/m/img_coupons.png" alt="6만원 이상 구매시 10,000원 발급 후 24시간 10만원 이상 구매시 15,000원 발급 후 24시간" /></div>
			<a href="" onclick="fnCouponDownload(); return false;" class="btnJoin"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75258/m/btn_go_coupon.png" alt="쿠폰 다운받기" /></a>
		</div>
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>1월 신규가입 고객에게만 발급되는 쿠폰입니다.</li>
				<% if isapp then %>
					<li class="">쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
				<% else %>
					<li class="">쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a> 에서 확인할 수 있습니다.</li>
				<% end if %>
				<li>발급 후 24시간  이내 미 사용시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
				<li>이벤트는 조기 종료 될 수 있습니다.</li>
			</ul>
		</div>
		<% if isapp then %>
		<% else %>
			<div class="appDown mWeb">
				<a href="/event/appdown/" class="btnJoin"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75258/m/bnr_app_down.png" alt="지금 APP설치하면 3천원 쿠폰을 드려요!" /></a>
			</div>
		<% end if %>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
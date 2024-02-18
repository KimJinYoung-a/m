<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [3월 신규가입이벤트] 작심삼월 쿠폰
' History : 2017.02.28 유태욱
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
	eCode = "66284"
Else
	eCode = "76495"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
.coupon {position:relative;}
.coupon .hurryup {position:absolute; width:9.84%; bottom:13.9%;  right:20.3%; animation:bounce 1s infinite;}
.coupon .soldout {position:absolute; left:50%; top:0; width:76%; margin-left:-38%;}
.withTenten {background:#ffd996;}
.withTenten a {display:block;}
.evtNoti {padding:1.5rem 1.5rem 1.2rem; background:#f5f5f5;}
.evtNoti h3 {padding:0 33%; margin-bottom:1.2rem;}
.evtNoti li {position:relative; padding:0 0 0 0.65rem; font-size:1.1rem; line-height:1.7rem; color:#7f7f7f;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.6rem; width:0.35rem; height:1px; background:#7f7f7f;}
.evtNoti li a {text-decoration:underline; color:#7f7f7f;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt76495").offset().top}, 0);
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
		url:"/event/etc/doeventsubscript/doEventSubscript76495.asp",
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
	<!-- 3월 쿠폰 -->
	<div class="mEvt76495">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/tit_march_coupon.png" alt="작심삼월쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/img_coupon.png" alt="6만원이상 구매시 1만원할인, 10만원이상 구매시 1만5천원할인" /></div>
			<%'' 쿠폰 다운로드 %>
			<a href="" onclick="fnCouponDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>

			<%
			'<!-- 마감임박시--><p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/txt_hurryup.png" alt="마감임박" /></p>
			'<!-- 솔드아웃 --><p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다 다음 기회를 기다려주세요!" /></p>
			%>
		</div>
		<div class="withTenten">
			<%'' for dev msg : 앱다운로드 버튼은 클래스로 웹에서만 노출되게 처리했어요 %>
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/btn_app_download.png" alt="지금 APP설치하면 3천원 쿠폰을 드려요!" /></a>
		</div>
		<div class="evtNoti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76495/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>3월 신규가입 고객에게만 발급되는 쿠폰입니다.</li>
				<li class="mWeb">발급된 쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN > 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li class="mApp">발급된 쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN > 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li>발급 후 24시간 이내 미 사용시, 쿠폰은 소멸되며 재발급이 불가합니다.</li>
				<li>이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 3월 쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
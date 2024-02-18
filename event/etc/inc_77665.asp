<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [5월 신규가입이벤트] 오감만족쿠폰
' History : 2017.04.27 유태욱
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
	eCode = "66322"
Else
	eCode = "77665"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
.withTenten {background:#ffd996;}
.withTenten a {display:block;}
.evtNoti {padding:12.5% 0 11.5%; background:#999;}
.evtNoti h3 {width:17%; margin-left:6.1%;}
.evtNoti ul {padding:0.8rem 2.8rem 0 3.5rem; }
.evtNoti li {position:relative; padding-top:0.5rem; font-size:1.15rem; line-height:1.8rem; color:#fff;  list-style-type: disc; }
.evtNoti li a {color:#fff494;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt77665").offset().top}, 0);
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
		url:"/event/etc/doeventsubscript/doEventSubscript77665.asp",
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
	<!-- 오감만족 쿠폰 -->
	<div class="mEvt77665">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/tit_coupon.png" alt="오감만족 쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/txt_coupon.png" alt="6만원이상 구매시 1만원할인, 10만원이상 구매시 1만 5천원 할인" /></div>
			<a href="" onclick="fnCouponDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/btn_coupon_v2.png" alt="쿠폰 다운 받기" /></a>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/txt_evnet_2.png" alt="" /></div>
		<div class="withTenten">
			<%'' for dev msg : 앱다운로드 버튼은 클래스로 모바일웹에서만 노출되게 처리했습니다 %>
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/txt_app_download.png" alt="지금 APP을 설치하시면 3천원 쿠폰을 드려요! 텐바이텐 APP 다운받기" /></a>
		</div>
		<div class="evtNoti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/77665/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>5월 신규 가입 고객에게만 발급되는 쿠폰입니다.</li>
				<li class="mWeb">발급된 쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li class="mApp">발급된 쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN &gt; 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li>발급 후 24시간 이내 미사용 시 쿠폰은 소멸되며, 재발급이 불가합니다.</li>
				<li>이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 오감만족 쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
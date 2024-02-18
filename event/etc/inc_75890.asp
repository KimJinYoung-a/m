<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : [2월 신규가입이벤트] 새내기 쿠폰
' History : 2017.01.26 유태욱
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
	eCode = "66272"
Else
	eCode = "75890"
End If

vUserID = getEncLoginUserID
%>
<style type="text/css">
.coupon {position:relative;}
.coupon .hurryup {position:absolute; width:11.875%; bottom:16%; right:17.5%; animation:bounce 1s infinite;}
.coupon .soldout {position:absolute; left:50%; top:0; width:82%; margin-left:-41%;}
.withTenten {background:#eda293;}
.withTenten a {position:relative; display:block;}
.withTenten a:nth-child(2) {padding-top:2px;}
.withTenten a:nth-child(2):after {position:absolute; left:5%; top:-2px; width:90%; height:2px; background-color:#fdb7a4; content:'';}
.evtNoti {padding:1.5rem 1.5rem 1.8rem; background:#f5f5f5;}
.evtNoti h3 {margin-bottom:0.8rem; font-size:1.3rem; color:#7f7f7f; font-weight:bold; text-align:center;}
.evtNoti h3 span {position:relative; display:inline-block; line-height:2.1rem; padding-left:2.5rem;}
.evtNoti h3 span:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.9rem; height:1.9rem; font-size:1.3rem; line-height:1.8rem; color:#fff; border-radius:50%; background-color:#7f7f7f; font-weight:bold; font-family:tahoma, verdana, arial, sans-serif;}
.evtNoti li {padding-top:0.5rem; font-size:1rem; color:#7f7f7f;}
.evtNoti li a {text-decoration:underline; color:#7f7f7f;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt75890").offset().top}, 0);
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
		url:"/event/etc/doeventsubscript/doEventSubscript75890.asp",
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
	<!-- 새내기쿠폰 -->
	<div class="mEvt75890">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/tit_freshman_coupon.png" alt="새내기쿠폰" /></h2>
		<div class="coupon">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/img_coupon.png" alt="6만원이상 구매시 1만원할인, 20만원이상 구매시 3만원할인" /></div>
			<%'' 쿠폰 다운로드 %>
			<a href="" onclick="fnCouponDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/btn_download.png" alt="쿠폰 한번에 다운받기" /></a>
			<%
			'<!-- 마감임박시--><p class="hurryup"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/txt_hurryup.png" alt="마감임박" /></p>
			'<!-- 솔드아웃 --><p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다 다음 기회를 기다려주세요!" /></p>
			%>
		</div>
		<div class="withTenten">
			<%'' for dev msg : 앱다운로드 버튼은 클래스로 웹에서만 노출되게 처리했어요 %>
			<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/75890/m/btn_app_download.png" alt="지금 APP설치하면 3천원 쿠폰을 드려요!" /></a>
		</div>
		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>- 2월 신규가입 고객에게만 발급되는 쿠폰입니다.</li>
				<li class="mWeb">- 발급된 쿠폰은 <a href="/my10x10/couponbook.asp">MY TENBYTEN > 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li class="mApp">- 발급된 쿠폰은 <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;">MY TENBYTEN > 쿠폰/보너스쿠폰</a>에서 확인할 수 있습니다.</li>
				<li>- 발급 후 24시간 이내 미 사용시, 쿠폰은 소멸되며 재발급이 불가합니다.</li>
				<li>- 이벤트는 조기 종료될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 새내기쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
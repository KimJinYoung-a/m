<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 카카오페이 open!
' History : 2015.08.20 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, eCodedisp, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "64861"
	eCodedisp = "64861"
Else
	eCode = "65682"
	eCodedisp = "65682"
End If

currenttime = now()
'currenttime = #08/18/2015 14:05:00#

userid = getloginuserid()

%>

<style type="text/css">
img {vertical-align:top;}
.step1 {position:relative;}
.step1 .payIs {display:inline-block; position:absolute; left:48%; top:15%; width:33%; height:8%; color:transparent; font-size:0; background:transparent; z-index:20;}
.step1 .desc {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:24%; background:rgba(0,0,0,.4); z-index:30;}
.step1 .desc div {position:relative; opacity:0; margin-top:-10px;}
.step1 .desc a {display:block; position:absolute; left:15.5%; top:55%; width:47%;}
.step1 .desc .btnClose {position:absolute; right:7%; top:14%; width:10.5%; z-index:30;}
.step2 {position:relative;}
.step2 a {display:block; position:absolute; left:9%; bottom:11.5%; width:82%; height:30%; color:transparent; font-size:0;}
.evtNoti {padding:25px 14px; background:#fff;}
.evtNoti h3 {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #111;}
.evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2.5px; width:0; height:0; border-style:solid; border-width:3px 0 3px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.evtNoti {padding:38px 21px;}
	.evtNoti h3 {font-size:21px; margin-bottom:20px;}
	.evtNoti li {font-size:18px; padding-left:17px;}
	.evtNoti li:after {top:6px; width:0; height:0; border-style:solid; border-width:4.5px 0 4.5px 7px;}
}
</style>
<script type="text/javascript">

$(function(){
	$('.payIs').click(function(){
		$('.desc').fadeIn();
		$('.desc div').delay(100).animate({"opacity":"1","margin-top":"0"}, 400);
	});
	$('.desc .btnClose').click(function(){
		$('.desc div').animate({"opacity":"0","margin-top":"-10px"}, 400);
		$('.desc').fadeOut();
	});
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};

</script>
</head>
<body>

<% '<!-- 카카오페이 OPEN!(M) --> %>
<div class="mEvt65682">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/tit_kakaopay.png" alt="카카오페이 OPEN!" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/txt_discount.gif" alt="카카오페이 첫 결제 시 3,000원 즉시 할인+텐바이텐 APP신규 설치 3,000원 할인쿠폰" /></p>
	<div class="step1">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/txt_step1_.png" alt="선착순 단 3,000명에게만! 3만원 이상 카카오페이 첫 결제 시 5,000원 즉시 할인!" /></p>
		<!--<button class="payIs">카카오페이란?</button>-->
		<div class="desc">
			<div>
				<span class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/btn_close.gif" alt="닫기" /></span>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/txt_kakaopay.png" alt="카카오톡에서 카드(신용&amp;체크)를 등록하여 다양한 곳에서 간단하게 비밀번호만으로 결제할 수 있는 가장 빠른 모바일 결제 서비스입니다." /></p>
				<a href="http://paybiz-web.kakao.com/event/kakaopay/index201501/kakaopay_event.html" target="_blank">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/btn_join_kakao.gif" alt="카카오페이 가입하기" /></a>
			</div>
		</div>
	</div>
	<div class="step2">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/txt_step2.gif" alt="신규로 APP을 설치하면 3,000원 할인쿠폰까지!" /></p>
		<a href="/event/appdown/">할인쿠폰 받으러가기</a>
	</div>

	<% if not(isApp=1) then %>
		<p>
			<a href="javascript:gotoDownload();" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65682/btn_go_app.gif" alt="APP 설치하러 가기" /></a>
		</p>
	<% end if %>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>카카오 페이는 텐바이텐 모바일웹 및 APP에서만 결제 적용됩니다.</li>
			<li>카카오 페이 즉시 할인은 선착순 3천명 소진 시 조기종료되며, 이벤트 기간 중 ID당 최초 1회 결제 시 사용 가능합니다.</li>
			<li>최종 결제금액이 3만원 이상일 때 사용 가능합니다.</li>
			<li>본 이벤트 적용 주문건에 대해서는 부분 취소가 불가하며, 전체 취소 후 재주문시에는 다시 혜택을 받으실 수 있습니다.</li>
			<li>본 이벤트는 별도 고지없이 변경 또는 종료될 수 있습니다.</li>
			<li>APP 신규다운로드 후 발급된 쿠폰은 마이텐바이텐&lt;쿠폰함에서 확인 가능하며, 발급 후 24시간 이내 사용 가능합니다.</li>
			<li>텐바이텐에서 기존에 카카오페이로 결제 이력이 있을 경우, 본 이벤트 할인 적용이 불가합니다.</li>
		</ul>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<% '<!--// 카카오페이 OPEN!(M) --> %>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 여름엔 1인 빙수
' History : 2014.07.11 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event53459Cls.asp" -->

<%
dim eCode, userid
	eCode=getevt_code
	userid = getloginuserid()

dim onlineordercount, onlineemailyn, subscriptcount1, subscriptcount2, subscriptcount3
	onlineordercount=0
	onlineemailyn="N"
	subscriptcount1=0
	subscriptcount2=0
	subscriptcount3=0

If IsUserLoginOK() Then
	onlineordercount = get10x10onlineordercount(userid, "2014-07-10", "2014-07-21", "10x10", "app_wish", "", "N")
	onlineemailyn = get10x10onlinemailyn(userid, "Y", "Y", "")

	subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "BINGSU", "1", "")
	subscriptcount2 = getevent_subscriptexistscount(eCode, userid, "BINGSU", "2", "")
	subscriptcount3 = getevent_subscriptexistscount(eCode, userid, "BINGSU", "3", "")
end if
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 여름엔 1인 1빙수</title>
<style type="text/css">
.mEvt53460 {position:relative;}
.mEvt53460 img {vertical-align:top; width:100%;}
.mEvt53460 p {max-width:100%;}
.mEvt53460 .mission {padding-bottom:8px; text-align:center;background:url(http://webimage.10x10.co.kr/eventIMG/2014/53460/bg_mission.png) left top no-repeat #e9fdff; background-size:100% auto;}
.mEvt53460 .mission .msCont {position:relative; padding-bottom:5px;}
.mEvt53460 .mission input {-webkit-border-radius:0; -webkit-appearance:none;}
.mEvt53460 .mission .buyNum {padding:5% 0 12%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53460/bg_mission01_btm.png) left bottom no-repeat; background-size:100% auto;}
.mEvt53460 .mission .buyNum .t01 {width:149px;}
.mEvt53460 .mission .buyNum .t02 {width:68px;}
.mEvt53460 .mission .buyNum em {display:inline-block; position:relative; top:-2px; font-size:18px; line-height:20px; padding:0 3px; vertical-align:top; border-bottom:1px solid #000;}
.mEvt53460 .mission .buyNum p:first-child {padding-bottom:5px;}
.mEvt53460 .mission p a,
.mEvt53460 .mission p input {position:absolute; left:14%; bottom:23%; width:72%;}
.mEvt53460 .evtNoti {padding:40px 15px 30px; background:#fff;}
.mEvt53460 .evtNoti dt {padding:0 0 20px 13px; text-align:left;}
.mEvt53460 .evtNoti dt img {width:118px;}
.mEvt53460 .evtNoti dd {text-align:left; padding:0; margin:0;}
.mEvt53460 .evtNoti li {position:relative; padding:0 0 8px 13px; font-size:13px; color:#444; line-height:14px;}
.mEvt53460 .evtNoti li:after {content:''; display:block; position:absolute; top:3px; left:0; width:0; height:0; border-color:transparent transparent transparent #f12526; border-style:solid; border-width: 4px 0 4px 6px;}
.mEvt53460 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
.mEvt53460 .clear span {position:absolute; left:4.5%; top:0; display:block; width:91.4%; height:93%; margin:0 0 0 -1px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53460/txt_clear.png) left center no-repeat; background-size:100% auto; background-color:rgba(0,0,0,.5);}
.mEvt53460 .mission #m01 p input {position:static; margin:5px auto 0;}
.mEvt53460 .mission #m01.clear span {height:94%;}
@media all and (max-width:480px){
	.mEvt53460 .mission .buyNum .t01 {width:99px;}
	.mEvt53460 .mission .buyNum .t02 {width:45px;}
	.mEvt53460 .mission .buyNum em {top:-2px; font-size:11px; line-height:13px;}
	.mEvt53460 .clear span {width:91.8%; height:92%;}
	.mEvt53460 .mission #m03.clear span {height:89%;}
	.mEvt53460 .evtNoti {padding:30px 12px 20px;}
	.mEvt53460 .evtNoti dt {padding:0 0 15px 10px;}
	.mEvt53460 .evtNoti dt img {width:81px;}
	.mEvt53460 .evtNoti li {padding:0 0 5px 10px; font-size:11px; line-height:12px;}
	.mEvt53460 .evtNoti li:after {top:2px;}
}
</style>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
$(function(){
	$('.mission .clear').append('<span></span>');
});

	function jsSubmitbingsu1(frm){
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-07-14" and getnowdate<"2014-07-21" Then %>
				<% if subscriptcount1 < 1 then %>
					<% if onlineordercount > 0 then %>
						frm.bingsugubun.value='1';
				   		frm.mode.value="bingsureg";
						frm.action="/event/etc/doEventSubscript53459.asp";
						frm.target="evtFrmProc";
						frm.submit();
						return;
					<% else %>
						alert("텐바이텐APP 쇼핑 후, 응모하실 수 있습니다.");
						return;
					<% end if %>						
				<% else %>
					alert("이미 참여 하셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			//calllogin();
			//return;
			parent.jsevtlogin();
			return;
			//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
			//	winLogin.focus();
			//	return;
			//}
		<% End IF %>
	}

	function jsSubmitbingsu2(frm){
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-07-14" and getnowdate<"2014-07-21" Then %>
				<% if subscriptcount2 < 1 then %>
					<% if onlineemailyn="Y" then %>
						frm.bingsugubun.value='2';
				   		frm.mode.value="bingsureg";
						frm.action="/event/etc/doEventSubscript53459.asp";
						frm.target="evtFrmProc";
						frm.submit();
						return;
					<% else %>
						alert("텐바이텐 E-mail 수신동의후, 응모하실 수 있습니다.");
						return;
					<% end if %>						
				<% else %>
					alert("이미 참여 하셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			//calllogin();
			//return;
			parent.jsevtlogin();
			return;
			//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
			//	winLogin.focus();
			//	return;
			//}
		<% End IF %>
	}

</script>
</head>
<body>

<!-- 여름엔 1인 1빙수 -->
<div class="mEvt53460">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/tit_ice_flakes.png" alt="여름엔 1인 1빙수" /></h3>
	<div class="mission">
		<% ' for dev msg : 미션 수행 후 클래스 clear 넣어주세요 %>
		<div id="m01" class="msCont <% if subscriptcount1>0 then %>clear<% end if %>">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/img_mission01.png" alt="MISSION1- 텐바이텐 APP에서 접속하기" /></p>
			<div class="buyNum">
				<% If IsUserLoginOK() Then %>
					<p>
						<em><%= getloginuserid() %></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/txt_num01.png" alt="님의 APP쇼핑 횟수는" class="t01" />
						<em><%= onlineordercount %></em><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/txt_num02.png" alt="회 입니다." class="t02" />
					</p>
				<% end if %>
				<p>
					<% if onlineordercount > 0 then %>
						<input type="image" onclick="jsSubmitbingsu1(evtFrm1); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/53460/btn_apply.png" alt="응모하기" />
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/txt_apply_tip.png" alt="텐바이텐APP 쇼핑 후, 응모하실 수 있습니다." />
					<% end if %>
				</p>
			</div>
		</div>
		<div id="m02" class="msCont <% if subscriptcount2>0 then %>clear<% end if %>">
			<% if onlineemailyn="Y" then %>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/img_mission02_a.png" alt="MISSION2- 텐바이텐 E-mail 수신동의하기" />
					<input type="image" onclick="jsSubmitbingsu2(evtFrm1); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/53460/btn_apply.png" alt="응모하기" />
				</p>
			<% else %>
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/img_mission02_b.png" alt="MISSION2- 텐바이텐 E-mail 수신동의하기" />
					<a href="/my10x10/userinfo/confirmuser.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/btn_mypage.png" alt="마이텐바이텐 바로가기" /></a>
				</p>
			<% end if %>
		</div>
		<div id="m03" class="msCont <% if subscriptcount3>0 then %>clear<% end if %>">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/img_mission03.png" alt="MISSION3- 텐바이텐 APP에서 접속하기" /></p>
		</div>
	</div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/img_gift.png" alt="Mission Clear Gift" /></div>
	<div><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/btn_app_download.png" alt="이제는 텐바이텐을 APP으로 더 손쉽게 만나세요! - WISH APP DOWNLOAD" /></a></div>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53460/tit_notice.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 고객님을 위한 특별 이벤트 입니다.</li>
				<li>각 미션별로 참여할 수 있는 조건과 채널이 다릅니다. 이벤트 내용을 꼼꼼히 읽어주세요.</li>
				<li>이벤트 사은품 발송을 위해 개인정보를 요청할 수 있습니다.</li>
				<li>이벤트 당첨자는 2014년 7월 23일 수요일에 발표됩니다.</li>
			</ul>
		</dd>
	</dl>
</div>
<!-- //여름엔 1인 1빙수! -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<form name="evtFrm1" action="/event/etc/doEventSubscript53459.asp" method="post" target="evtFrmProc" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="bingsugubun">
</form>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
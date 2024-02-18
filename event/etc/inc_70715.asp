<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비밀의방 초대권 신청 페이지
' History : 2016.05.11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, subscriptcoun, totalcnt, dateimg, subscriptcount, systemok
	IF application("Svr_Info") = "Dev" THEN
		eCode = "66125"
	Else
		eCode = "70715"
	end if

currenttime = now()
'															currenttime = #05/20/2016 10:05:00#

userid = GetEncLoginUserID()

subscriptcount=0
'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", left(currenttime,10))
end if

totalcnt = getevent_subscripttotalcount(eCode, "", "", "")

dim layerimgweek, layerart
layerimgweek="_week"
layerart="초대장이 신청되었습니다 초대권을 받기 위해선 PUSH 알림 수신동의를 하셔야 합니다. app의 알림설정을 확인해주세요. 초대장은 익일 오전 푸쉬메시지로 나갈예정입니다 "

if left(currenttime,10) <= "2016-05-16" then
	dateimg = "0517"
elseif left(currenttime,10) <= "2016-05-17" then
	dateimg = "0518"
elseif left(currenttime,10) <= "2016-05-18" then
	dateimg = "0519"
elseif left(currenttime,10) <= "2016-05-19" then
	dateimg = "0520"
elseif left(currenttime,10) >= "2016-05-20" then
	dateimg = "0523"
	layerimgweek = ""
	layerart = "초대장이 신청되었습니다 초대장 받기 위해선 PUSH 알림 수신동의를 하셔야 합니다. app의 알림설정을 확인해주세요. 5월 20, 21, 22일 신청자들에게는 5월 23일 월요일 오전에 초대장이 발송됩니다!"
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 비밀의방")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 비밀의 방\n\n올해도 어김없이\n방이 열렸습니다.\n\n어떤 선물이 당신을 기다리고 있을지\n초대장을 신청해 보세요!\n\n지금 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/70715/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if

''응모 차단시 X로 변경
	'systemok="X"
	systemok="O"

if left(currenttime,10)<"2016-05-16" then
	systemok="X"
	if userid = "baboytw" or userid = "greenteenz" then
		systemok="O"
	end if
end if

%>

<style type="text/css">
img {vertical-align:top;}

.invite {position:relative; padding-bottom:28.5%; background:#a7946e url(http://webimage.10x10.co.kr/eventIMG/2016/70715/m/bg_doors_v1.jpg) no-repeat 50% 0; background-size:100% auto;}
.invite .btnKnock {position:absolute; top:4.8%; left:50%; z-index:10; width:40.78%; margin-left:-20.39%; background-color:transparent;}
.invite .btnKnock .time {position:absolute; top:16%; left:50%; width:79.69%; margin-left:-39.84%;}
.invite .btnKnock .time img {animation-name:swing; -webkit-animation-name:swing; animation-iteration-count:3; -webkit-animation-iteration-count:3; animation-duration:8s; -webkit-animation-duration:8s; animation-fill-mode:both;-webkit-animation-fill-mode:both;  transform-origin:50% 0%; -webkit-transform-origin:50% 0%;}
@keyframes swing {
	0% {transform:rotateZ(0deg);}
	30% {transform:rotateZ(-10deg);}
	60% {transform:rotateZ(10deg);}
	100% {transform:rotateZ(0deg);}
}
@-webkit-keyframes swing {
	0% {-webkit-transform:rotateZ(0deg);}
	30% {-webkit-transform:rotateZ(-10deg);}
	60% {-webkit-transform:rotateZ(10deg);}
	100% {-webkit-transform:rotateZ(0deg);}
}

.invite .shine {position:absolute; top:-3.2%; left:50%; width:62%; margin-left:-31%;}

.shine {animation-name:shine; -webkit-animation-name:shine; animation-iteration-count:5;  -webkit-animation-iteration-count:5; animation-duration:10s; -webkit-animation-duration:10s; animation-fill-mode:both;-webkit-animation-fill-mode:both;}
@-webkit-keyframes shine {
	0% {opacity:1;}
	50% {opacity:0;}
	100% {opacity:1;}
}
@keyframes shine {
	0% {opacity:1;}
	50% {opacity:0;}
	100% {opacity:1;}
}

.invite .appDown {position:absolute; bottom:8%; left:50%; width:76.25%; margin-left:-38.125%;}

<% if isapp then %>
.invite {padding-bottom:2.3%;}
.invite .btnKnock {top:6%}
<% end if %>

.lyLetter {display:none; position:absolute; top:-7%; left:50%; z-index:50; width:77.5%; margin-left:-38.75%;}
.lyLetter .btnclose {position:absolute; bottom:8%; left:50%; width:62.7%; margin-left:-31.35%;}
.mask {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:5% 3.125%;}
.noti h2 {color:#000; font-size:13px;}
.noti h2 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#d20700;}

@media all and (min-width:480px){
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>

<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt70715").offset().top+15}, 0);
});

$(function() {
	/* layer */
//	$(".btnKnock").click(function(){
//		$("#lyLetter").show();
//		$(".mask").fadeIn();
//		window.$('html,body').animate({scrollTop:300}, 500);
//	});

	$(".btnclose").click(function(){
		$("#lyLetter").hide();
		$(".mask").fadeOut();
	});
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401';
	}
};


function gotoDownloadapp(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?9320160512';
	return false;
};

function jsevtgo(e){
<% if systemok = "O" then %>
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-05-16" and left(currenttime,10)<"2016-05-23" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount > 0 then %>
				alert('이미 초대장을 신청 하셨습니다.');
				return;
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript70715.asp",
					data: "mode=evtgo",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					$("#lyLetter").show();
					$(".mask").fadeIn();
					window.$('html,body').animate({scrollTop:250}, 500);
//					alert('신청해주셔서 감사합니다.');
//					parent.location.reload();
					return false;
				}else if (str1[0] == "01"){
					alert('잘못된 접속입니다.');
					return false;
				}else if (str1[0] == "02"){
					alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
					return false;
				}else if (str1[0] == "03"){
					alert('이벤트 기간이 아닙니다.');
					return false;		
				}else if (str1[0] == "04"){
					alert('이미 초대장을 신청 하셨습니다.');
					return false;
				}else if (str1[0] == "00"){
					alert('정상적인 경로가 아닙니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
<% else %>
	alert('잠시 후 다시 시도해 주세요!!');
	return;
<% end if %>
}

function getsnscnt() {
	<% If IsUserLoginOK() Then %>
		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doeventsubscript/doEventSubscript70715.asp",
			data: "mode=S",
			dataType: "text",
			async: false
		}).responseText;
		if(str=="ka") {
			parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% else %>
		<% if isApp = "1" then %>
			calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% end if %>
}
</script>
<div class="mEvt70715">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/txt_invite_v1.jpg" alt="다시 돌아온 미스터리 이벤트 비밀의 방! 불이 켜진 비밀의 방으로 당신을 초대합니다. 초대장을 받으신 분들에게만 선물이 찾아갑니다!" /></p>

	<div class="invite">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/txt_knock_v2.png" alt="문을 두드려서 초대장을 신청하세요! 초대장은 푸쉬메시지로 발송될 예정입니다." /></p>
		<button type="button" onclick="jsevtgo(); return false;" class="btnKnock">
			<strong class="time"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/txt_date_<%= dateimg %>_v1.png" alt="<%= dateimg %>일" /></strong>
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/img_door.png" alt="초대장 신청하기" />
		</button>

		<div id="lyLetter" class="lyLetter">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/txt_invite_letter<%= layerimgweek %>.png" alt="<%= layerart %>" /></p>
			<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/btn_close.png" alt="초대장 발송 레이어 팝업 닫기" /></button>
		</div>

		<span class="shine"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/img_shine.png" alt="" /></span>

		<!-- for dev msg : 모바일웹일 경우에만 보입니다. -->
		<% if isapp then %>
		<% else %>
			<div class="appDown">
				<a href="/event/appdown/" onclick="gotoDownload(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/btn_app.png" alt="아직 텐바이텐 앱이 없다면 앱 설치하러 가기" /></a>
			</div>
		<% end if %>
	</div>

	<div class="eventGuide">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/txt_way.jpg" alt="이벤트 참여 방법은 초대장 신청하고 푸쉬 알림 켜기, 해당 날짜에 초대장 받기, 푸시 받고 선물을 확인하시면 됩니다." /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/img_present_list.jpg" alt="비밀의 방 선물 리스트는 디지털 즉석카메라, 베스킨라빈스 싱글 레귤러, 아이리버 블루투스 스피커, 무료 배송 쿠폰입니다." /></p>
	</div>
	
	<div class="kakaka">
		<a href="" onclick="getsnscnt(); return false;" title="카카오톡으로 비밀의 방 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70715/m/btn_kakao_v1.png" alt="친구와 함께 비밀의 방에 도전해보세요!" /></a>
	</div>

	<div class="noti">
		<h2><strong>이벤트 안내</strong></h2>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 APP에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1일 1회만 응모가능 합니다.</li>
			<li>초대장은 익일 발송될 예정입니다.</li>
			<li>주말(토, 일)에는 초대장이 발송되지 않습니다.</li>
		</ul>
	</div>

	<div class="mask"></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->

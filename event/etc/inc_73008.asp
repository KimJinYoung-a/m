<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode

IF application("Svr_Info") = "Dev" THEN

Else
	eCode = "73008"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 웰컴 투 더핑거스")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2016/73008/m/img_kakao.jpg")


'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 핸드메이드 플랫폼,\n더핑거스가 오픈되었습니다!\n더핑거스를 찾아주신 고객님께 선보이는\n특별한 이벤트에 당신을 초대합니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/73008/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If
%>
<style type="text/css">
img {vertical-align:top;}
.welcomeFingers .hotItem {padding-bottom:3.4rem; background:#ddf5f5;}
.welcomeFingers .swiper-container {position:relative; width:100%; margin-top:-12%;}
.welcomeFingers .swiper-container .swiper-slide {width:9.2rem; padding:0 0.8rem;}
.welcomeFingers .process {padding-top:3.6rem;}
.welcomeFingers .btnGo {display:block; width:78.75%; margin:0 auto;}
.welcomeFingers .shareFriends {position:relative;}
.welcomeFingers .shareFriends a {display:block; position:absolute; top:18%; width:16%; height:67%; background:transparent; text-indent:-999em;}
.welcomeFingers .shareFriends a.btnFb {right:24.5%;}
.welcomeFingers .shareFriends a.btnKakao {right:7%;}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<% end if %>
<script>
$(function(){
	mySwiper = new Swiper(".welcomeFingers .swiper-container",{
		loop:false,
		autoplay:2500,
		speed:600,
		slidesPerView:'auto',
		pagination:false
	});
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}
</script>
<!-- 오픈 이벤트 : 웰컴 투 더핑거스 -->
<div class="mEvt73008 welcomeFingers">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/m/tit_welcome.png" alt="웰컴 투 더핑거스" /></h2>
	<div class="hotItem">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6030.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6091.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6915.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6272.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_5963.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_5957.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6154.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6158.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6216.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_5973.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6975.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6833.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6435.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6770.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6468.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6252.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6860.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6661.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_6505.png" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/img_7035.png" alt="" /></div>
			</div>
		</div>
		<div class="process"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/m/img_event.png" alt="EVENT1. 만나서 반가워요 웰컴쿠폰 / EVENT2. 갖고싶은 작품을 담아주세요!" /></div>
		<div>
			<a href="http://m.thefingers.co.kr/event/openevent/welcome/" class="btnGo mw" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/m/btn_go.png" alt="더 핑거스로 가기" /></a>
			<a href="" onclick="openbrowser('http://m.thefingers.co.kr/event/openevent/welcome/');return false;" class="btnGo ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/m/btn_go.png" alt="더 핑거스로 가기" /></a>
		</div>
	</div>
	<!-- sns 공유 -->
	<div class="shareFriends">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/73008/m/txt_share.png" alt="핸드메이드를 좋아하는 친구들에게 알려주세요!" /></p>
		<a href="" class="btnFb" target="_blank" onclick="snschk('fb'); return false;">페이스북으로 공유</a>
		<a href="" class="btnKakao" onclick="kakaolink();return false;">카카오톡으로 공유</a>
	</div>
	<!--// sns 공유 -->
</div>
<script>
function kakaolink(){
	//카카오 SNS 공유
	Kakao.init('591e2d679fcfcd858a019bfca3c291ed');

	Kakao.Link.sendTalkLink({
		label: "[더핑거스] 핸드메이드 플랫폼,\n더핑거스가 오픈되었습니다!\n더핑거스를 찾아주신 고객님께 선보이는\n특별한 이벤트에 당신을 초대합니다.",
		image: {
		src: "http://image.thefingers.co.kr/m/2016/event/20160919/img_kakao.jpg",
		width: 200,
		height: 200
		},
		webButton: {
			text: '더핑거스 바로가기',
			url: "http://m.thefingers.co.kr/event/openEvent/welcome/"
		}
	});
}
</script>
<!--// 오픈 이벤트 : 웰컴 투 더핑거스 -->
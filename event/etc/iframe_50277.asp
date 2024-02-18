<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  ★★★ 텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.28 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event50277Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim ename, ecode, emimg, cEvent, userid
	eCode=getevt_code
	userid = getloginuserid()

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	eCode		= cEvent.FECode
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 앱 위시 론칭</title>
<style type="text/css">
.mEvt50278 p {max-width:100%;}
.mEvt50278 img {vertical-align:top;}
.wishAppLaunching img {width:100%;}
.wishAppLaunching .wishAppSns {position:relative;}
.wishAppLaunching .wishAppSns ul {overflow:hidden; position:absolute; left:0; bottom:12.5%; width:100%; padding:0 15% 0 10%; box-sizing:border-box; -moz-box-sizing:border-box;}
.wishAppLaunching .wishAppSns ul li {float:left; width:25%;}
.wishAppSwiperWrap {padding:12px 0; background-color:#630001;}
.wishAppSwiper {position:relative; overflow:hidden; }
.wishAppSwiper .swiper-container {overflow:hidden; position:relative; width:300px; height:506px; margin:0 auto;}
.wishAppSwiper .swiper-wrapper {overflow:hidden; position:relative;}
.wishAppSwiper .swiper-slide {overflow:hidden;  float:left; width:300px; height:506px;}
.wishAppSwiper .swiper-slide img {border-radius:5px;}
.wishAppSwiper .pagination {position:absolute; bottom:20px; left:0; width:100%; text-align:center;}
.wishAppSwiper .pagination span {display:inline-block; width:9px; height:9px; margin:0 2px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50278/btn_pagination.png) left top no-repeat; background-size:9px 9px; text-align:center; text-indent:-9999px;}
.wishAppSwiper .pagination span.swiper-active-switch {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50278/btn_pagination_active.png) left top no-repeat; background-size:9px 9px;}
@media all and (min-width:480px){
	.wishAppSwiper .swiper-container {width:450px; height:759px;}
	.wishAppSwiper .swiper-slide {width:450px; height:759px;}
}
</style>
<script type="text/javascript">
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		// 모바일 홈페이지 바로가기 링크 생성
		if(userAgent.match('iphone')) { //아이폰
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipad')) { //아이패드
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipod')) { //아이팟
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('android')) { //안드로이드 기기
			parent.document.location="market://details?id=kr.tenbyten.shopping"
		} else { //그 외
			parent.document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
		}
	};
</script>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
$(function(){
	swiper = new Swiper('.swiper0', {
		pagination : '.paging0',
		loop:true
	});
});
</script>
</head>
<body>

<!-- 텐바이텐 앱 위시 론칭 -->
<div class="mEvt50278">
	<div class="wishAppLaunching">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/tit_wish_app_launching.jpg" alt="드디어 우리가 원하던 APP이 나왔습니다! 10X10 WISH" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/txt_wish_app_launching.jpg" alt="모바일에서 만날 수 있는 텐바이텐 공식 앱이 출시되었어요. 이제 가장 트렌디하고 스타일리시한 텐바이텐 쇼핑을 스마트폰 APP에서 즐겨보세요!" /></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_wish_app_visual.jpg" alt="10X10 WISH" /></div>

			<!-- 수정 : 2014.04.15 -->
			<!--h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/tit_wish_app_launching_take_part.jpg" alt="웬만하면 당첨되는 런칭 기념 이벤트 위시도 담고, 선물도 받고!" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/txt_wish_app_launching_take_part.jpg" alt="위시를 담기만 해도 선물을 드립니다! 10x10 WISH APP을 다운받고 이벤트에 참여하신 분 중 3,000분께 스타벅스 아메리카노를 선물로 드립니다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/txt_wish_app_launching_way_01.jpg" alt="이벤트 참여방법 : 10x10 위시 APP을 다운받고 실행하세요. &rarr; 팝업창을 따라 이벤트 페이지로 이동하세요. &rarr;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/txt_wish_app_launching_way_02.jpg" alt="이벤트 페이지 내 이벤트 참여  버튼을 눌러 위시폴더를 생성하세요. &rarr; wish 이벤트  폴더가 생성된 것을 확인한 후 위시를 마구마구 담아주세요" /></p-->
			<!-- //수정 : 2014.04.15 -->
			
		<!-- 위시 앱 다운로드 -->
		<div class="wishAppDownload">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/tit_wish_app_download.jpg" alt="10X10 WISH APP 다운로드 받기" /></h3>
			<div><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/btn_download_app_tenbyten.jpg" alt="다운로드" /></a></div>
		</div>
		<!-- //위시 앱 다운로드 -->

		<!-- 위시 앱 SNS -->
		<div class="wishAppSns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/tit_wish_app_launching_sns_new.jpg" alt="친구들도 기다리던 텐바이텐 WISH APP SNS로 텐바이텐 WISH APP을 소개해주세요!" /></h3>
			<ul>
			<%
				'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
				dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
				snpTitle = Server.URLEncode(ename)
				snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
				snpPre = Server.URLEncode("텐바이텐 이벤트")
				snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
				snpTag2 = Server.URLEncode("#10x10")
				snpImg = Server.URLEncode(emimg)
			%>

				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/ico_sns_twitter.png" alt="트위터" /></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/ico_sns_facebook.png" alt="페이스북" /></a></li>
				<li><a href="" onclick="pinit('<%=snpLink%>','<%=snpImg%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/ico_sns_pinterest.png" alt="핀터레스트" /></a></li>
				<li><a href="" onclick="kakaoLink('event','<%=snpLink%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/ico_sns_kakao.png" alt="카카오톡" /></a></li>
			</ul>
		</div>
		<!-- //위시 앱 SNS -->

		<!--p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/txt_wish_app_launching_note.jpg" alt="이벤트 유의사항 : 반드시 이벤트 페이지에서 [이벤트 참여] 버튼을 눌러 상품을 담아야 이벤트 응모 인정됩니다. 많은 위시를 담을 수록 당첨 확률이 높아집니다! (위시 폴더에 상품이 없을 경우 응모 취소될 수 있습니다.)" /></p-->

		<!-- 2014.03.31 : Swipe -->
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/tit_wish_app_preview.jpg" alt="10X10 WISH APP 미리보기" /></h3>
		<div class="wishAppSwiperWrap">
			<div class="wishAppSwiper">
				<div class="swiper-container swiper0">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_01.png" alt="10X10 WISH" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_02.png" alt="마음에 든다면 WISH" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_03.png" alt="누르면 누를수록, 보인다 보인다!" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_04.png" alt="나와 비슷한 취향의 친구를 찾아 고고" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_05.png" alt="생각치 못한 보물을 찾을 수도 있어요!" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_06.png" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50278/img_slide_07.png" alt="" /></div>
					</div>
					<div class="pagination paging0"></div>
				</div>
			</div>
		</div>
		<!-- //2014.03.31 : Swipe -->
	</div>
</div>
<!-- //텐바이텐 앱 위시 론칭 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
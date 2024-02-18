<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'########################################################
' 15주년 이벤트 나의 리틀 텔레비전
' 2016-10-05 이종화
'########################################################
Dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "66213"
Else
	eCode = "73067"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[채널 teN 15] 나의 리틀텔레비전")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/tv.asp")
snpPre		= Server.URLEncode("10x10 15th 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 여러분의 일상을\nTV 화면에 담아 인증샷을\n올려주세요!\n\n50분에게 텐바이텐 GIFT 카드\n1만원 권을 선물해드려요!\n\n지금 텐바이텐에서 확인해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_kakao.png"
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
/* teN15th common */
.teN15th .noti {padding:3.5rem 2.5rem; background-color:#eee;}
.teN15th .noti h3 {position:relative; padding:0 0 1.2rem 2.4rem; font-size:1.4rem; line-height:2rem; font-weight:bold; color:#6752ac;}
.teN15th .noti h3:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.8rem; height:1.8rem; color:#eee; font-size:1.3rem; line-height:2rem; font-weight:bold; text-align:center; background-color:#6752ac; border-radius:50%;}
.teN15th .noti li {position:relative; padding:0 0 0.3rem 0.65rem; color:#555; font-size:1rem; line-height:1.4;}
.teN15th .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.35rem; height:1px; background-color:#555;}
.teN15th .noti li:last-child {padding-bottom:0;}
.teN15th .shareSns {position:relative;}
.teN15th .shareSns li {position:absolute; right:6.25%; width:31.25%;}
.teN15th .shareSns li.btnKakao {top:21.6%;}
.teN15th .shareSns li.btnFb {top:53.15%;}

/* my little television */
.myLitteTv .topic {overflow:hidden; position:relative;}
.myLitteTv .topic .tv {position:absolute; top:27.3%; left:9.21%; width:36.09%;}
.myLitteTv .topic .tv {
	animation-name:lightSpeedIn; animation-timing-function:ease-out; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:1;
	-webkit-animation-name:lightSpeedIn; -webkit-animation-timing-function:ease-out; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;
}
@keyframes lightSpeedIn {
	0% {transform:translateY(-50%);}
	60% {transform:translateY(-20%);}
	80% {transform:translateY(20%);}
	100% {transform:translateY(0%);}
}
@-webkit-keyframes lightSpeedIn {
	0% {-webkit-transform:translateY(-50%);}
	60% {-webkit-transform:translateY(-20%);}
	80% {-webkit-transform:translateY(20%);}
	100% {-webkit-transform:translateY(0%);}
}

.myLitteTv .rolling {padding-bottom:8%; background-color:#fff7e3;}
.myLitteTv .rolling .swiper {position:relative;}
.myLitteTv .rolling .swiper .swiper-container {width:100%;}
.myLitteTv .rolling button {position:absolute; top:34%; z-index:5; width:6.09%; padding:5% 0; background-color:transparent;}
.myLitteTv .rolling .swiper .btn-prev {left:0;}
.myLitteTv .rolling .swiper .btn-next {right:0;}

.myLitteTv .event {position:relative;}
.myLitteTv .event .btnGo {position:absolute; display:block; top:26.58%; left:0; width:23.125%;}

.myLitteTv .gallery {padding-bottom:10%; background-color:#bbe8f5;}
.myLitteTv .gallery ul {overflow:hidden; width:28.2rem; margin:0 auto;}
.myLitteTv .gallery ul li {float:left; width:13.1rem; height:13.1rem; margin:0 0.5rem 1rem; padding:0.35rem; background-color:#fff;}
.myLitteTv .gallery .btnLink {width:61.71%; margin:6% auto 0;}

.teN15th .noti li .btnGo {display:inline-block; margin-top:0.1rem; position:relative; height:1.6rem; padding:0.2rem 1.3rem 0 0.7rem; border-radius:1rem; background-color:#7658b4; color:#fff; line-height:1.5rem;}
.teN15th .noti li .btnGo:after {content:'>'; display:block; position:absolute; top:50%; right:0.5rem; height:1.6rem; margin-top:-0.72rem; color:#fff; line-height:1.5rem;}
</style>
<script type="text/javascript">
function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

$(function(){
	$('html,body').animate({scrollTop:$(".teN15th").offset().top}, 0);

	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:2000,
		speed:1000,
		nextButton:'#rolling .btn-next',
		prevButton:'#rolling .btn-prev',
		effect:"fade"
	});
});

$(function(){
	var randomMan = [ '01', '02', '03', '04', '05', '06'];
	var manSort = randomMan.sort(function(){
		return Math.random() - Math.random();
	});
	$('#gallery li img').each(function(index,item){
		$(this).attr("src","http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_"+manSort[index]+".jpg");
	});
});
</script>
<div class="teN15th myLitteTv">
	<div class="topic">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/txt_my_little_televisioin.jpg" alt="소소한 일상을 담은 나만의 방송! 일상을 TV 화면에 담아 인증샷을 올려주세요. 50분에게 텐바이텐 Gift 카드 1만원권을 선물해드려요!" /></p>
		<div class="tv"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_tv.png" alt="" /></div>
	</div>

	<div id="rolling" class="rolling">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_slide_01.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_slide_02.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_slide_03.jpg" alt="" /></div>
				</div>
			</div>
			<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>

	<div class="event">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/txt_event.png" alt="이벤트 참여 방법은 텐텐 배송상품을 쇼핑하면 배송상자 속 리플렛 확인 후 나의 리틀텔레비전으로 인증샷 찍고 인스타그램에 인증샷을 업로드해주세요. 필수 포함 해시태그는 #텐바이텐 #텐바이텐티비입니다." /></p>
		<a href="eventmain.asp?eventid=73440" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/btn_tenten_delivery.gif" alt="" /></a>
	</div>

	<div class="gallery" id="gallery">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/tit_gallery.png" alt="이렇게 참여해 보세요" /></h3>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_01.jpg" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_02.jpg" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_03.jpg" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_04.jpg" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_05.jpg" alt="" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/img_gallery_06.jpg" alt="" /></li>
		</ul>

		<div class="btnLink"><a href="https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%ED%8B%B0%EB%B9%84/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%ED%8B%B0%EB%B9%84/'); return false;" target="_blank" title="#텐바이텐티비 인스타그램으로 이동"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73067/m/btn_link.png" alt="고객 참여모습 보러 가기" /></a></div>
	</div>

	<%' 이벤트 유의사항 %>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>나의 리틀 텔레비전은 텐바이텐 배송상품과 함께 배송됩니다.<br /> <a href="eventmain.asp?eventid=73440" title="제가 바로 텐바이텐 배송입니다! 기획전으로 이동" class="btnGo">텐바이텐 배송상품 보러가기</a></li>
			<li>선착순 한정수량으로 발송되며, 소진 시 미포함될 수 있습니다.</li>
			<li>인스타그램 계정이 비공개일 경우 이벤트 참여에서 제외됩니다.</li>
			<li>당첨자발표는 10월 28일 금요일 공지사항을 통해 발표합니다.</li>
		</ul>
	</div>

	<%' SNS 공유 %>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
		<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="나의 리틀 텔레비전 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="나의 리틀 텔레비전 페이스북으로 공유" /></a></li>
		</ul>
	</div>

	<ul class="tenSubNav">
		<li class="tPad1-5r"><a href="eventmain.asp?eventid=73068"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_gift.png" alt="사은품을 부탁해" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73065"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_video.png" alt="전국영상자랑" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73053"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_main.png" alt="텐바이텐 15주년 이야기" /></a></li>
	</ul>
</div>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "66194"
Else
	eCode = "72782"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 더핑거스를 응원해줘")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 핑거스 아카데미가\n핸드메이드 전문 플랫폼\n더핑거스로 새단장하였습니다.\n응원 댓글 남기고,\n특별한 선물 받아가세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_kakao.png"
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
.cheerUpFingers .swiper {position:relative;}
.cheerUpFingers .swiper .swiper-container {width:100%;}
.cheerUpFingers .swiper .desc {position:absolute; left:0; top:0; width:100%;}
.cheerUpFingers .swiper button {position:absolute; top:42%; z-index:20; width:15.625%; background-color:transparent;}
.cheerUpFingers .swiper .btn-prev {left:0;}
.cheerUpFingers .swiper .btn-next {right:0;}
.cheerUpFingers .swiper .pagination {position:absolute; top:17.88%; left:0; z-index:10; width:100%; height:auto; padding-top:0; text-align:center;}
.cheerUpFingers .swiper .pagination span {display:inline-block; position:relative; width:7px; height:7px; margin:0 0.5rem; border:2px solid #adadad; background-color:#fff; cursor:pointer;}
.cheerUpFingers .swiper .pagination .swiper-active-switch {border:0; background-color:#5b5b5b;}
.cheerUpFingers .thefingersEvent {padding-bottom:3rem; background:#faffeb;}
.cheerUpFingers .thefingersEvent a {display:block; width:78.75%; margin:0 auto;}
.cheerUpFingers .shareFriends {position:relative;}
.cheerUpFingers .shareFriends a {display:block; position:absolute; top:17%; width:17%; height:70%; background:transparent; text-indent:-999em;}
.cheerUpFingers .shareFriends a.btnFb {right:24.5%;}
.cheerUpFingers .shareFriends a.btnKakao {right:6.5%;}
@media all and (min-width:480px){
	.cheerUpFingers  .swiper .pagination span {width:9px; height:9px;}
}
@media all and (min-width:768px){
	.cheerUpFingers  .swiper .pagination span {width:13px; height:13px; border:3px solid #adadad;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper(".cheerUpFingers .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:".cheerUpFingers .pagination",
		paginationClickable:true,
		prevButton:'.cheerUpFingers .btnPrev',
		nextButton:'.cheerUpFingers .btnNext'
	});
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
<div class="mEvt72782 cheerUpFingers">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/tit_cheerup.png" alt="더핑거스를 응원해줘" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_new_fingers.png" alt="핑거스 아카데미가 더핑거스로 새롭게 찾아갑니다." /></p>
	<div class="swiper">
		<div class="swiper-container swiper">
			<div class="swiper-wrapper">
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_slide_01.jpg" alt="POINT 1 내 취향에 맞는 핸드메이드 작품" />
					<p class="desc desc1"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_desc_01.png" alt="" /></p>
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_slide_02.jpg" alt="POINT 2 다양한 핸드메이드 클래스" />
					<p class="desc desc2"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_desc_02.png" alt="" /></p>
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_slide_03.jpg" alt="POINT 3 발손도 금손이 되는 DIY KIT" />
					<p class="desc desc3"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_desc_03.png" alt="" /></p>
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_slide_04.jpg" alt="POINT 4 핸드메이드 소식 &amp; 정보통! 매거진" />
					<p class="desc desc4"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_desc_04.png" alt="" /></p>
				</div>
				<div class="swiper-slide">
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/img_slide_05.jpg" alt="POINT 5 텐바이텐 마일리지를 더핑거스에서도!" />
					<p class="desc desc5"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_desc_05.png" alt="" /></p>
				</div>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/btn_next.png" alt="다음" /></button>
	</div>
	<div class="thefingersEvent">
		<div class="cheerCont">
			<ul>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_event_1.png" alt="EVENT1:더 핑거스 고객님께 드리는 마일리지 찬스! - 이벤트 기간 동안 더핑거스에서 상품 구매 시, 적립 마일리지가 10배!" /></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_event_2.png" alt="EVENT2:새로운 모습으로 변신중인 더핑거스를 응원해주세요! - 힘찬 응원 메시지를 남겨주신 분들 중 5분께 팝아트 초상화를 그려드립니다." /></li>
			</ul>
			<% If isapp = "1" Then %>
			<a href="" onclick="fnAPPpopupExternalBrowser('http://m.thefingers.co.kr/event/openevent/ch01/?ta=10x10_APP');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/btn_go.png" alt="이벤트 확인하러 가기" /></a>
			<% Else %>
			<a href="http://m.thefingers.co.kr/event/openevent/ch01/?ta=10x10_MOB" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/btn_go.png" alt="이벤트 확인하러 가기" /></a>
			<% End If %>
		</div>
	</div>

	<div class="shareFriends">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72782/m/txt_share.png" alt="핸드메이드를 좋아하는 친구들에게 알려주세요!" /></p>
		<a href="" class="btnFb" onclick="snschk('fb'); return false;">페이스북으로 공유</a>
		<a href="" class="btnKakao" onclick="snschk('ka'); return false;">카카오톡으로 공유</a>
	</div>
</div>
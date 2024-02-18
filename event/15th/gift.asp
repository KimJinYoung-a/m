<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'########################################################
' 15주년 이벤트 사은품을 부탁해
' 2016-10-05 이종화
'########################################################
Dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "66214"
Else
	eCode = "73068"
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[채널 teN 15] 사은품을 부탁해!")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/gift.asp")
snpPre		= Server.URLEncode("10x10 15th 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 15주년을 맞이하여 구매 금액별 사은품 군단을 소개합니다.\n\n지금 텐바이텐에서 확인해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_kakao.jpg"
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
.teN15th .noti li {position:relative; padding:0 0 0.3rem 0.65rem; color:#555; font-size:1rem; line-height:1.5;}
.teN15th .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.7rem; width:0.35rem; height:1px; background-color:#555;}
.teN15th .noti li:last-child {padding-bottom:0;}
.teN15th .shareSns {position:relative;}
.teN15th .shareSns li {position:absolute; right:6.25%; width:31.25%;}
.teN15th .shareSns li.btnKakao {top:21.6%;}
.teN15th .shareSns li.btnFb {top:53.15%;}

/* gift */
.giftGallery {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/bg_blue.jpg) no-repeat 0 0; background-size:100% 100%; padding-bottom:15%;}
.giftGallery .rolling {padding-top:4.4rem; width:27.3rem; margin:0 auto;}
.giftGallery .pagination {position:absolute; bottom:4.1rem; left:11.9rem; width:10.08rem; left:50%; margin-left:-5.04rem;}
.giftGallery .swiper .swiper-pagination-switch {width:0.8rem; height:0.8rem; margin:0 0.4rem; border:0.15rem solid #999ccb; background-color:transparent;}
.giftGallery .swiper .swiper-active-switch {background-color:#999ccb;}
.giftGallery .btn {position:absolute; top:45%; background:transparent; width:1.4rem; height:2.4rem;}
.giftGallery .btnPrev {left:2%;}
.giftGallery .btnNext {right:2%;}

/*.noti a {display:inline-block; width:11.9rem; height:1.3rem; margin-top:0.5rem;}*/
.purple {color:#5e3aa8; font-weight:bold;}

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

	mySwiper = new Swiper("#rolling .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext',
		spaceBetween:"5%"
	});
});
</script>
<div class="teN15th">
	<div class="gift">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/tit_gift.jpg" alt="사은품을 부탁해!" /><h2>
	</div>
	<div class="giftItems">
		<ul>
			<li>
				<!-- 상품 sold out시 img_prd_01_sold_out.jpg 로 이미지 대체  -->
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_prd_01.jpg" alt="6만원 이상 구매시" />
			</li>
			<li>
				<!-- 상품 sold out시 img_prd_02_sold_out_v02.jpg 로 이미지 대체  -->
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_prd_02_v02.jpg" alt="15만원 이상 구매시" />
			</li>
			<li>
				<!-- 상품 sold out시 img_prd_03_sold_out.jpg 로 이미지 대체  -->
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_prd_03_sold_out.jpg" alt="30만원 이상 구매시" />
			</li>
			<li>
				<!-- 상품 sold out시 img_prd_04_sold_out.jpg 로 이미지 대체  -->
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_prd_04_sold_out.jpg" alt="100만원 이상 구매시" />
			</li>
		</ul>
	</div> 

	<div class="giftGallery">
		<div id="rolling" class="rolling">
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_01.png" alt="" />
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_02.png" alt="" />
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_03.png" alt="" />
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_04.png" alt="" />
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_05.png" alt="" />
						</div>
						<div class="swiper-slide">
							<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/img_gallery_06.png" alt="" />
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btn btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/btn_pre.png" alt="이전" /></button>
				<button type="button" class="btn btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73068/m/btn_nxt.png" alt="다음" /></button>
			</div>
		</div>
	</div>

	<%' 이벤트 유의사항 %>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다.<br>(비회원 구매 시, 증정 불가)</li>
			<li><span class="purple">텐바이텐 배송상품</span>을 포함해야 사은품 선택이 가능합니다<br> <a href="eventmain.asp?eventid=73440" title="제가 바로 텐바이텐 배송입니다! 기획전으로 이동" class="btnGo">텐바이텐 배송상품 보러가기</a></li>
			<li>업체배송 상품으로만 구매시 마일리지만 선택 가능합니다.</li>
			<li>상품 쿠폰, 보너스 쿠폰 등의 사용 후 구매 확정액이<br><span class="purple">6/15/30/100만원 이상</span>이어야 합니다. (단일주문건 구매 확정액) 
</li>
			<li>마일리지, 예치금, Gift카드를 사용하신 경우에는 구매 확정액에<br>포함되어 사은품을 받을 수 있습니다.</li>
			<li>텐바이텐 Gift카드를 구매하신 경우에는 사은품 증정이 되지 않습니다.</li>
			<li>마일리지는 차후 일괄 지급 이며, 1차 : 10월 21일 (~14일까지 주문내역 기준) / 2차 : 10월 31일 (10/15~24일까지 주문내역 기준) 지급됩니다.</li>
			<li>환불이나 교환 시, 최종 구매가격이 사은품 수령 가능금액 미만일 경우 사은품과 함께 반품해야 합니다.</li>
			<li>각 상품별 한정 수량이므로, 조기 소진될 수 있습니다.</li>
		</ul>
	</div>

	<%' SNS %>
	<div class="shareSns">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
		<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="텐바이텐 15주년 이야기 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="텐바이텐 15주년 이야기 페이스북으로 공유" /></a></li>
		</ul>
	</div>
	<ul class="tenSubNav">
		<li class="tPad1-5r"><a href="eventmain.asp?eventid=73064"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_discount.png" alt="비정상할인" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73063"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_walk.png" alt="워킹맨" /></a></li>
		<li class="tPad1r"><a href="eventmain.asp?eventid=73053"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_main.png" alt="텐바이텐 15주년 이야기" /></a></li>
	</ul>
</div>
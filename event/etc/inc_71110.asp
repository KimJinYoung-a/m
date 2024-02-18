<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : tab1 : [사은이벤트] 선물은 비치볼
' History : 2016.06.10 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "66147"
Else
	eCode = "71110"
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("쇼핑만 하면 귀여운 비치볼이 온다! 선착순이니 서둘러 주세요. 영화 <도리를 찾아서>가 함께 합니다!")
snpLink		= Server.URLEncode("http://bit.ly/dori10x10_1")
snpPre		= Server.URLEncode("텐바이텐")
snpTag		= Server.URLEncode("텐바이텐")
snpTag2		= Server.URLEncode("#텐바이텐 #도리를찾아서")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 으로 도리를 찾아서!\n\n쇼핑만 즐겨도 비치볼이 온다!\n귀여운 도리가 그려진 비치볼을\n텐바이텐에서 받아 가세요.\n\n한정수량이니 서둘러야 해요!\n텐바이텐에서만 만날 수 있는\n영화 <도리를 찾아서> 이벤트\nbit.ly/dori10x10_1"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
end if
%>
<style type="text/css">
img {vertical-align:top;}

/* Finding Dory common */
.findingDory button {background-color:transparent;}
.noti {padding:8% 7% 10%; background-color:#05274c;}
.noti h3 {color:#75c9e3; font-size:1.2rem;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #75c9e3; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:1rem; color:#fff; font-size:1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.4rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#75c9e3;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; top:22%; right:7.8%; width:45%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin-left:13%; padding-bottom:86%; color:transparent; font-size:12px; line-height:12px; text-align:center;}
.sns ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.bnr {padding-top:4%; background-color:#e8ffff;}
.bnr ul li {margin-top:4%;}
.bnr ul li:first-child {margin-top:0;}

.intro {position:relative;}
.rolling {position:absolute; top:26.92%; left:50%; width:87.5%; margin-left:-43.75%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-10%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 0.5rem; border-radius:50%; background-color:#fff; cursor:pointer; transition:background-color 0.5s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#50dcff;}
.rolling .swiper button {position:absolute; top:40%; z-index:20; width:8.92%; background:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .mask {display:none; position:absolute; left:0; width:100%; height:36%;}
.rolling .mask-top {top:0;}
.rolling .mask-btm {bottom:0;}

.video {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:62.45%; background:#000;}
.video iframe {position:absolute; top:0; left:0; width:100%; height:100%}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}

/* gift */
.gift .rollingwrap {position:relative;}
.gift .rollingwrap .rolling {top:0; width:84.375%; margin-left:-42.1875%;}
.gift .rolling .swiper {padding:1.8%; background-color:#fff;}
.gift .rolling .swiper .soldout {display:block; position:absolute; top:0; left:0; width:100%; z-index:55;}
.gift .rolling .swiper button {top:44%; width:6.56%;}
.gift .rolling .swiper .pagination {bottom:6%;}
.gift .rolling .swiper .pagination .swiper-pagination-switch {border:2px solid #fff; background-color:transparent; transition:all .3s;}
.gift .rolling .swiper .pagination .swiper-active-switch {width:20px; border-radius:10px; background-color:#fff;}

@media all and (min-width:480px){
	.gift .rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
	.gift .rolling .swiper .pagination .swiper-active-switch {width:24px; border-radius:12px;}
}
@media all and (min-width:768px){
	.gift .rolling .swiper .pagination .swiper-pagination-switch {width:14px; height:14px; border:4px solid #fff;}
	.gift .rolling .swiper .pagination .swiper-active-switch {width:28px; border-radius:16px;}
}

.noti ul li a {display:block; width:14rem; margin:1rem 0;}
.noti ul li .btnmore {display:block; width:100%; margin-top:1.5rem;}
</style>
<script type="text/javascript">
$(function(){
	/* swipe */
	mySwiperGift = new Swiper('#rollingGift .swiper1',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:"#rollingGift .pagination",
		paginationClickable:true,
		nextButton:'#rollingGift .btn-next',
		prevButton:'#rollingGift .btn-prev'
	});

	mySwiperMovie = new Swiper('#rollingMovie .swiper1',{
		loop:true,
		autoplay:false,
		speed:800,
		pagination:"#rollingMovie .pagination",
		paginationClickable:true,
		nextButton:'#rollingMovie .btn-next',
		prevButton:'#rollingMovie .btn-prev'
	});

	/* notice */
	$("#noti ul li").hide();
	$("#noti ul li:nth-child(1), #noti ul li:nth-child(2), #noti ul li:nth-child(3)").show();
	$("#noti ul li .btnmore" ).on("click", function() {
		$("#noti ul li").show();
		$("#noti ul li .btnmore").hide();
	});
});
</script>
<div class="mEvt71110 findingDory">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_finding_dory.png" alt="텐바이텐과 도리를 찾아서 텐바이텢 어드벤쳐" /></h2>
		<section class="gift">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_gift.png" alt="선물은 비치볼 2만원 이상 구매 시 도리의 비치볼을 선물로 드립니다. 한정수량으로 조기 소진될 수 있습니다." /></h3>
			<div class="rollingwrap">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/txt_tip.png" alt="팁 비치볼 안쪽의 그림판이 팽팽하게 펴질 때까지 공기를 주입해주세요!" /></p>
				<div id="rollingGift" class="rolling">
					<div class="swiper">
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/txt_soldout_v1.png" alt="준비된 비치볼이 모두 소진되었습니다. 함께 해주셔서 감사합니다." /></p>
						<div class="swiper-container swiper1">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_gift_01.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_gift_02.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_gift_03.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_gift_04.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_gift_05.jpg" alt="" /></div>
							</div>
						</div>
						<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_prev_grey.png" alt="이전" /></button>
						<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_next_grey.png" alt="다음" /></button>
						<div class="pagination"></div>
					</div>
				</div>
			</div>
		</section>

		<section id="noti" class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>구매사은이벤트는 텐바이텐 회원님을 위한 혜택입니다. </li>
				<li>비회원 구매 시 사은품은 증정되지 않습니다.</li>
				<li>텐바이텐 배송상품을 포함해야 사은품 선택이 가능합니다.
				<% If isApp="1" Then %>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71237" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_tenten_delivery.png" alt="텐바이텐 배송상품 보러가기" /></a>
				<% Else %>
					<a href="/event/eventmain.asp?eventid=71237" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_tenten_delivery.png" alt="텐바이텐 배송상품 보러가기" /></a>
				<% End If %>
					<button type="button" class="btnmore"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_more.png" alt="" /></button>
				</li>
				<li>업체배송 상품으로만 구매시 사은품을 선택 할 수 없습니다.</li>
				<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 구매 확정액이 2만원 이상 이어야 합니다.</li>
				<li>마일리지, 예치금, 기프트카드를 사용 한 경우는 사은품을 받을 수 있습니다.</li>
				<li>기프트카드를 구매하신 경우는 사은품 증정이 되지 않습니다.</li>
				<li>사은품은 텐바이텐 배송 상품과 함께 배송됩니다.</li>
				<li>환불, 교환 시 최종 구매 가격이 사은품 수령 가능 금액 미만일 경우, 사은품과 함께 반품해야 합니다.</li>
				<li>각 상품별 한정 수량으로, 조기 소진 될 수 있습니다.</li>
			</ul>
		</section>

		<section class="intro">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_intro.png" alt="도리를 찾아서 2016년 7월 7일 개봉" /></h3>
			<div id="rollingMovie" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="video">
									<iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=776B75C9F93DD7C13D1FE75DA69B38681D3C&outKey=V128342fa5823e4a2d0a3994d9e29bba102c37f54388cb6d2c188994d9e29bba102c3&controlBarMovable=true&jsCallable=true&isAutoPlay=false&skinName=tvcast_white" frameborder="0" title="도리를 찾아서 예고편" allowfullscreen></iframe>
								</div>
								<div class="mask mask-top"></div>
								<div class="mask mask-btm"></div>
							</div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_04.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_slide_movie_05.jpg" alt="도리를 찾아서! 내가 누구라고? 도리? 도리! 무엇을 상상하든 그 이상을 까먹는 도리의 어드벤쳐가 시작된다! 니모를 함께 찾으면서 베스트 프렌드가 된 도리와 말린은 우여곡절 끝에 다시 고향으로 돌아가 평화로운 일상을 보내고 있다. 모태 건망증 도리가 기억이라는 것을 하기 전까지! 도리는 깊은 기억 속에 숨어 있던 가족의 존재를 떠올리고 니모와 말린과 함께 가족을 찾아 대책 없는 어드벤쳐를 떠나게 되는데… 깊은 바다도 막을 수 없는 스펙터클한 어드벤쳐가 펼쳐진다!" /></div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<section class="sns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_sns.png" alt="도리를 찾아서 이벤트! 친구에게도 놀라운 사실을 알려주자!" /></h3>
			<ul>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북으로 공유하기</a></li>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><span></span>트위터로 공유하기</a></li>
				<li class="kakao"><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡으로 공유하기</a></li>
			</ul>
		</section>

		<div class="bnr">
			<ul>
			<% If isApp="1" Then %>
				<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71111"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71111.jpg" alt="매일 터지는 도리의 선물 도리를 찾아서" /></a></li>
				<li><a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=71112"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71112.jpg" alt="텐바이텐과 디즈니 굿즈 런칭 도리를 내 품에!" /></a></li>
			<% Else %>
				<li><a href="/event/eventmain.asp?eventid=71111"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71111.jpg" alt="매일 터지는 도리의 선물 도리를 찾아서" /></a></li>
				<li><a href="/event/eventmain.asp?eventid=71112"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71112.jpg" alt="텐바이텐과 디즈니 굿즈 런칭 도리를 내 품에!" /></a></li>
			<% End If %>
			</ul>
		</div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : tab3 : [런칭이벤트] 도리를 내 품에
' History : 2016.06.09 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserID, irdsite20, winItemChk, winItemStr
Dim tab1eCode, tab2eCode, tab3eCode
Dim vSQL
vUserID		= GetLoginUserID
IF application("Svr_Info") = "Dev" THEN
	eCode = "66149"
Else
	eCode = "71112"
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2
snpTitle	= Server.URLEncode("영화 <도리를 찾아서>의 귀여운 친구들이 트럼프카드, 휴대폰케이스에 쏙! 이 놀라운 상품들은 오직 텐바이텐에서!")
snpLink		= Server.URLEncode("http://bit.ly/dori10x10_3")
snpPre		= Server.URLEncode("텐바이텐/디즈니")
snpTag		= Server.URLEncode("텐바이텐")
snpTag2		= Server.URLEncode("#텐바이텐 #도리를찾아서")
%>
<style type="text/css">
img {vertical-align:top;}

/* Finding Dory common */
.findingDory button {background-color:transparent;}

.bnr {padding-top:4%; background-color:#e8ffff;}
.bnr ul li {margin-top:4%;}
.bnr ul li:first-child {margin-top:0;}

.intro {position:relative;}
.intro .rolling {position:absolute; top:26.92%; left:50%; width:87.5%; margin-left:-43.75%;}
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

/* 71112 */
.item .rolling .swiper button {top:43%; width:10.93%;}
#rollingCase {background-color:#0e6897;}
#rollingCase .btn-prev {left:5%;}
#rollingCase .btn-next {right:5%;}
.item .rolling .swiper .pagination {bottom:6%;}
.item .rolling .swiper .pagination .swiper-pagination-switch {border:2px solid #fff; background-color:transparent; box-shadow:0 0 5px rgba(0,0,0,0.2); transition:all .3s;}
.item .rolling .swiper .pagination .swiper-active-switch {width:20px; border-radius:10px; background-color:#fff;}

@media all and (min-width:480px){
	.item .rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
	.item .rolling .swiper .pagination .swiper-active-switch {width:24px; border-radius:12px;}
}
@media all and (min-width:768px){
	.item .rolling .swiper .pagination .swiper-pagination-switch {width:14px; height:14px; border:4px solid #fff;}
	.item .rolling .swiper .pagination .swiper-active-switch {width:28px; border-radius:16px;}
}

.sns {position:relative;}
.sns ul {position:absolute; bottom:7%; left:0; width:100%; padding:0 14%;}
.sns ul:after {content:' '; display:block; clear:both;}
.sns ul li {float:left; position:relative; width:33.333%;}
.sns ul li button,
.sns ul li > a {display:block; margin:0 5%;}
.sns ul li.instagram .go {display:none; position:absolute; top:74%; left:-32%; z-index:50; width:160%;}
</style>
<script type="text/javascript">
$(function(){
	/* swipe */
	mySwiperCase = new Swiper('#rollingCase .swiper1',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:false,
		nextButton:'#rollingCase .btn-next',
		prevButton:'#rollingCase .btn-prev',
		effect:"fade"
	});

	mySwiperItem = new Swiper('#rollingItem .swiper1',{
		loop:true,
		autoplay:3000,
		speed:800,
		pagination:"#rollingItem .pagination",
		paginationClickable:true,
		nextButton:'#rollingItem .btn-next',
		prevButton:'#rollingItem .btn-prev'
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

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#item .app").show();
			$("#item .mo").hide();
	}else{
			$("#item .app").hide();
			$("#item .mo").show();
	}

	$("#sns .instagram button" ).on("click", function() {
		$("#sns .instagram .go").show();
	});
});
</script>

<div class="mEvt71112 findingDory">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/tit_finding_dory.png" alt="텐바이텐과 도리를 찾아서 텐바이텢 어드벤쳐" /></h2>

		<section id="item" class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/tit_item.png" alt="선물은 비치볼 2만원 이상 구매 시 도리의 비치볼을 선물로 드립니다. 한정수량으로 조기 소진될 수 있습니다." /></h3>
			<div id="rollingCase" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71112" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_01.jpg" alt="네이비, 블루 도리" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71112" onclick="fnAPPpopupProduct('1507610&amp;pEtr=71112');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_01.jpg" alt="네이비, 블루 도리" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71112" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_02.jpg" alt="도리와 니모, 도리와 행크" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71112" onclick="fnAPPpopupProduct('1507606&amp;pEtr=71112');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_02.jpg" alt="도리와 니모, 도리와 행크" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71112" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_03.jpg" alt="패턴 도리, 패턴 니모" /></a>
								<a href="/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71112" onclick="fnAPPpopupProduct('1507611&amp;pEtr=71112');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_case_03.jpg" alt="패턴 도리, 패턴 니모" /></a>
							</div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>

			<div class="card">
				<a href="/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71112" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_item_card.jpg" alt="트럼트 카드" /></a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71112" onclick="fnAPPpopupProduct('1507612&amp;pEtr=71112');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_item_card.jpg" alt="트럼트 카드" /></a>
			</div>

			<div id="rollingItem" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_01.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_04.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/img_slide_item_05.jpg" alt="" /></div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<div id="sns" class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/txt_sns.png" alt="영화 도리를 찾아서 굿즈 런칭 소식을 SNS에 공유해주세요! 추첨을 통해 총 10분께 도리의 트럼프 카드를 선물로 드립니다. #텐바이텐 #도리를찾아서 해시태그를 꼭 넣어주셔야 정상적으로 응모됩니다. 이벤트 기간은 2016년 6월 13일부터 6월 22일까지며, 당첨자 발표는 6월 24일 입니다" /></p>
			<ul>
				<li class="instagram">
					<button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_sns.png" alt="인스타그램으로 공유하기" /></button>
					<div class="go">
						<a href="https://www.instagram.com/your10x10/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_instagram.png" alt="본 페이지를 캡쳐해서 포스팅해주세요 인스타그램 바로가기" /></a>
					</div>
				</li>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_sns.png" alt="트위터으로 공유하기" /></a></li>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71112/m/btn_sns.png" alt="페이스북으로 공유하기" /></a></li>	
			</ul>
		</div>

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

		<div class="bnr">
			<ul>
				<!--li><a href="eventmain.asp?eventid=71110"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71110.jpg" alt="구매 사은 이벤트 선물은 비치볼" /></a></li-->
				<li><a href="eventmain.asp?eventid=71111"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/img_bnr_71111.jpg" alt="매일 터지는 도리의 선물 도리를 찾아서" /></a></li>
			</ul>
		</div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
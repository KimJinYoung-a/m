<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/instagrameventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAY #31-4
' History : 2016-06-23 유태욱 생성
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66157
Else
	eCode   =  71532
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 8		'한 페이지의 보여지는 열의 수

dim oinstagramevent
set oinstagramevent = new Cinstagrameventlist
	oinstagramevent.FPageSize	= iCPageSize
	oinstagramevent.FCurrPage	= iCCurrpage
	oinstagramevent.FTotalCount		= iCTotCnt  '전체 레코드 수
	oinstagramevent.FrectIsusing = "Y"
	oinstagramevent.FrectEcode = eCode
	oinstagramevent.fnGetinstagrameventList

	iCTotCnt = oinstagramevent.FTotalCount '리스트 총 갯수
	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.topic {position:relative; background-color:#2491eb;}
.topic h2 {position:absolute; top:11.68%; left:50%; z-index:5; width:46.25%; margin-left:-23.125%;}
.topic h2 {animation-name:pulse; animation-duration:1s; animation-iteration-count:2; -webkit-animation-name:pulse; -webkit-animation-duration:1s; -webkit-animation-iteration-count:2;}
.topic .bubble {position:absolute; top:5.53%; left:0; width:100%; text-align:center;}
.bubble {
	animation-name:bubble; animation-duration:3s; animation-timing-function:ease-in-out; animation-iteration-count:3; animation-direction:alternate; animation-delay:1s; animation-play-state:running;
	-webkit-animation-name:bubble; -webkit-animation-duration:3s; -webkit-animation-timing-function:ease-in-out; -webkit-animation-iteration-count:3; -webkit-animation-direction:alternate; -webkit-animation-delay:1.5s; -webkit-animation-play-state:running;
}
@keyframes bubble {
	0%{margin-top:0;}
	100%{margin-top:5%;}
}
@-webkit-keyframes bubble {
	0%{margin-top:0;}
	100%{margin-top:5%;}
}

.topic .favorite {position:absolute; top:34.66%; left:50%; width:10.46%; margin-left:-5.23%;}
.spin {
	animation-name:spin; animation-iteration-count:1; animation-fill-mode:both; animation-timing-function:linear; animation-duration:1.5s;
	-webkit-animation-name:spin; -webkit-animation-iteration-count:1; -webkit-animation-fill-mode:both; -webkit-animation-timing-function:linear; -webkit-animation-duration:1.5s;
}
@keyframes spin {
	0% {transform: rotateY(180deg);}
	100% {transform: rotateY(360deg);}
}
@-webkit-keyframes spin {
	0% {-webkit-transform: rotateY(180deg);}
	100% {-webkit-transform: rotateY(360deg);}
}
.rolling {position:relative;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {overflow:visible;}
.rolling .swiper .swiper-container {width:100%;}
.rolling button {position:absolute; top:26%; z-index:5; width:7.812%; background-color:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}
.rolling .swiper .pagination {position:absolute; top:0; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:6px; height:6px; margin:0 0.5rem; background-color:#d2746a; cursor:pointer; transition:all 0.3s;}
#rolling2 .swiper .pagination .swiper-pagination-switch {background-color:#3491ab;}
.rolling .swiper .pagination .swiper-active-switch {width:14px; border-radius:7px; background-color:#fff;}
#rolling2 .swiper .pagination .swiper-active-switch {background-color:#fff;}
.rolling .swiper .swiper-slide {position:relative;}
.rolling .swiper .swiper-slide .animation {position:absolute; top:3.875%; left:50%; width:84.375%; margin-left:-42.1875%;}
.rolling .swiper .swiper-slide .animation .opacity {position:absolute; top:0; left:0; width:100%;}
.rolling .swiper .btnMap {position:absolute; bottom:13.5%; left:50%; width:84%; margin-left:-42%; /*background:rgba(0,0,0,0.3);*/}
.rolling .swiper .swiper-slide .line {position:absolute; bottom:-5.4%; left:0; z-index:10; width:100%;}
#rolling2  .swiper .swiper-slide .animation {top:3.09%;}
#rolling2 .swiper .swiper-slide .line {bottom:-7.3%;}

.twinkle {
	animation-name:twinkle; animation-iteration-count:3; animation-duration:5s; animation-fill-mode:both;
	-webkit-animation-name:twinkle; -webkit-animation-iteration-count:3; -webkit-animation-duration:5s; -webkit-animation-fill-mode:both;
}
@keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}
@-webkit-keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
	.rolling .swiper .pagination .swiper-active-switch {width:20px; border-radius:10px;}
}
@media all and (min-width:768px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:16px; height:16px;}
	.rolling .swiper .pagination .swiper-active-switch {width:32px; border-radius:16px;}
}

.sns {position:relative;}
.sns .btnInstagram {position:absolute; top:50.17%; left:50%; width:67.1875%; margin-left:-33.5937%;}
.sns .btnInstagram:focus img,
.sns .btnInstagram:hover img {animation-name:pulse; animation-duration:1s; -webkit-animation-name:pulse; -webkit-animation-duration:1s;}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.1);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(1.1);}
	100% {-webkit-transform:scale(1);}
}

.instagram {padding-bottom:12%; background-color:#edf6fd;}
.instagram ul {overflow:hidden; padding:2% 4.2% 9%;}
.instagram ul li {float:left; width:50%; margin-top:2.1rem;}
.instagram ul li a {display:block; width:12.6rem; margin:0 auto;}
.instagram ul li .thumbnail {display:block; width:12.6rem; height:12.6rem; padding:0.25rem; border-radius:0.25rem; background-color:#fff;}
.instagram ul li .thumbnail img {width:12.1rem; height:12.1rem;}
.instagram ul li .author {overflow:hidden; height:1.2rem; margin-top:0.7rem; padding:0 0.5rem; color:#999; font-size:0.9rem; line-height:1.313em; text-align:right; text-overflow:ellipsis; white-space:nowrap;}
.instagram ul li .author span {color:#2491eb;}

.pagingV15a {margin-top:0;}
.pagingV15a span {width:3.1rem; height:3.1rem; margin:0 0.6rem; border:1px solid #d5d4d4; border-radius:50%;}
.pagingV15a span a {color:#898787; font-size:1.4rem; line-height:1.5rem; font-weight:bold;}
.pagingV15a span.current {border:0; background-color:#2491eb;}
.pagingV15a span.current a {color:#fff;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playmo/ground/20160627/btn_pagination_prev.png) no-repeat 50% 50%; background-size:0.95rem auto;}
.pagingV15a span.nextBtn {background:url(http://webimage.10x10.co.kr/playmo/ground/20160627/btn_pagination_next.png) no-repeat 50% 50%; background-size:0.95rem auto;}
</style>
<script type="text/javascript">
$(function(){
	<% if Request("eCC")<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#instagramlist").offset().top}, 0);
}

$(function(){
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 100) {
			$(".hotPlace #topic .favorite").addClass("spin");
		}
	});

	mySwiper1 = new Swiper("#rolling1 .swiper",{
		loop:true,
		speed:800,
		pagination:"#rolling1 .pagination",
		paginationClickable:true,
		nextButton:"#rolling1 .btn-next",
		prevButton:"#rolling1 .btn-prev",
		onSlideChangeStart: function (mySwiper1) {
			$(".swiper-slide").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active").find(".animation .opacity").addClass("twinkle");
		}
	});

	mySwiper2 = new Swiper("#rolling2 .swiper",{
		loop:true,
		speed:800,
		pagination:"#rolling2 .pagination",
		paginationClickable:true,
		nextButton:"#rolling2 .btn-next",
		prevButton:"#rolling2 .btn-prev",
		onSlideChangeStart: function (mySwiper2) {
			$(".swiper-slide").find(".animation .opacity").removeClass("twinkle");
			$(".swiper-slide-active").find(".animation .opacity").addClass("twinkle");
		}
	});
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>

	<!-- WATER #4 물 좋은 곳 이벤트 코드 : 71532  -->
	<div class="mPlay20160627 hotPlace">
		<article>
			<div id="topic" class="topic">
				<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/tit_hot_place.png" alt="나만 아는 물 좋은 곳" /></h2>
				<div class="bubble"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_bubble.png" alt="" /></div>
				<div class="bg"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/bg_wave.png" alt="" /></div>
				<div class="favorite"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/ico_favorite.png" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/txt_intro.png" alt="물 좋~다! 아름다운 풍경이 눈 앞에 펼쳐질 때, 우리는 스스로도 모르게 말하곤 합니다 여러분들은 물 좋다는 소리가 절로 나오는 나만의 장소를 가지고 있나요? 이번 주 PLAY에서는 마시는 물이 아닌 분위기가 멋진 물 좋은 장소를 소개하려고 합니다 텐바이텐이 소개하는 물 좋은 곳을 함께 거닐어 보고, 여러분의 소중한 장소도 소개해주세요!" /></p>
			</div>

			<section id="rolling1" class="rolling">
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/tit_memory.png" alt="인생 사진을 남기고 싶을 때" /></h3>
				<div class="swiper">
					<div class="swiper-container swiper">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_01_01.jpg" alt="서울숲 뚝섬 카페 하트앤애로우 핑크를 사랑하는 핑크인들의 취향 저격 카페 아기자기하고 러블리한 인테리어에 달콤한 디저트까지! 밝은 조명과 소품 때문에 사진이 더 예쁘게 나오는 것은 안 비밀 일요일과 월요일은 휴무이니 참고하여 방문하세요 서울 성동구 성수동1가 668-49" /></p>
								<a href="https://goo.gl/maps/UTsfd69nakH2" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/UTsfd69nakH2'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="하트앤애로우 핑크 위치 정보 구글맵으로 보기" /></a>
							</div>
							<div class="swiper-slide">
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_animation_02.jpg" alt="" /></span>
								</div>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_01_02.jpg" alt="성수동 창고형 카페 대림창고 요즘 sns에서 가장 핫한 갤러리 겸 카페 1970년대 정미소를 개조해서 만든 독특한 인테리어로 넓고 특이한 카페를 찾고 있었다면 이곳을 추천! 곳곳에 커다란 조형물을 구경하는 재미는 덤 서울 성동구 성수동2가 322-32" /></p>
								<a href="https://goo.gl/maps/iDUfA48gZV62" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/iDUfA48gZV62'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="대림창고 위치 정보 구글맵으로 보기" /></a>
							</div>
							<div class="swiper-slide">
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_animation_03.jpg" alt="" /></span>
								</div>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_01_03.jpg" alt="해방촌 루프탑바 oriole 옥상에서 남산타워 야경 보며 분위기를 즐기고 싶고, 루프탑바의 로망을 맘껏 즐기고 싶은 사람에게 추천! 가수 정엽이 운영하는 곳으로, 또 한번 유명해지기도 했어요 좌석이 많지 않아 명당자리를 차지하려면 빠르게 움직여야 해요" /></p>
								<a href="https://goo.gl/maps/9fGGeJDfZoD2" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/9fGGeJDfZoD2'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="oriole 위치 정보 구글맵으로 보기" /></a>
								<div class="line"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/bg_line_01.png" alt="" /></div>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_next.png" alt="다음" /></button>
				</div>
			</section>

			<section id="rolling2" class="rolling">
				<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/tit_healing_v1.png" alt="힐링이 필요할 때" /></h3>
				<div class="swiper">
					<div class="swiper-container swiper">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_animation_04_v1.jpg" alt="" /></span>
								</div>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_02_01.jpg" alt="홍대 한방카페 약다방 봄동 기분, 신체 상태에 따라 18가지 약차를 골라 마실 수 있고 한의사가 직접 태어난 달에 따라 자기와 딱 맞는 차도 추천 해줘요 족욕도 함께 즐길 수 있어 당신을 힐링 시켜 줄 최적의 장소! 한약을 싫어하는 사람도 거부감 없이 마실 수 있어요 서울 마포구 동교동 203-36" /></p>
								<a href="https://goo.gl/maps/2ULnj1pYjZS2" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/2ULnj1pYjZS2'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="약다방 위치 정보 구글맵으로 보기" /></a>
							</div>
							<div class="swiper-slide">
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_animation_05.jpg" alt="" /></span>
								</div>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_02_02.jpg" alt="불광천 스튜디오&amp;레스토랑 반디앤보스케 여행 분위기, 휴양지 분위기 내고 싶다면 이곳으로! 마당에 카라반, 해먹등 여행느낌 물씬나는 소품들이 많아 아직 떠나지 못한 여름 휴가 기분을 만끽하기엔 안성맞춤 2층은 스튜디오로 장소 렌탈도 가능해요 서울 서대문구 북가좌동 345-30" /></p>
								<a href="https://goo.gl/maps/nGbkYdJMTzj" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/nGbkYdJMTzj'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="반디앤보스케 위치 정보 구글맵으로 보기" /></a>
							</div>
							<div class="swiper-slide">
								<div class="animation">
									<span class="opacity"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_animation_06.jpg" alt="" /></span>
								</div>
								<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/img_slide_02_03.jpg" alt="전통 디저트 카페 병과점 미남미녀 제주도 종달리에 새로 생긴 핫플레이스 몸에 좋은 떡, 수정과, 식혜 등 전통 디저트만 취급하여 커피와 케이크가 지겹다! 하시는 분들에게 추천! 입소문을 빠르게 타고 있어 더 유명해지기 전에 먼저 가보세요 제주도 구좌읍 종달로1길 102" /></p>
								<a href="https://goo.gl/maps/TjFeTSdZsyD2" onclick="fnAPPpopupExternalBrowser('https://goo.gl/maps/TjFeTSdZsyD2'); return false;" target="_blank" title="새창" class="btnMap"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_map.png" alt="미남미녀 위치 정보 구글맵으로 보기" /></a>
								<div class="line"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/bg_line_02.png" alt="" /></div>
							</div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_next.png" alt="다음" /></button>
				</div>
			</section>

			<div class="sns">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/txt_share_v4.png" alt="나만 아는 물 좋은곳을 공유해주세요 추첨을 통해 5분께 텐바이텐 기프트카드 3만원권 증정 신청 기간은 6월 27일부터 7월 4일까지며, 당첨자 발표는 7월 5일 입니다. 인스타그램에 사진과 #텐바이텐물좋은곳 해시태그를 함께 업로드해주세요" /></p>
				<a href="https://www.instagram.com/explore/tags/텐바이텐물좋은곳/" target="_blank" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/explore/tags/텐바이텐물좋은곳/'); return false;" title="#텐바이텐물좋은곳 인스타그램으로 이동 새창" class="btnInstagram"><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/btn_instagram.png" alt="인스타그램에 공유하러 가기" /></a>
			</div>

			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="eCC" value="1">
			</form>
			<div class="instagram">
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160627/txt_noti_v2.png" alt="계정이 비공개인 경우, 집계가 되지 않습니다. 이벤트 기간 동안 #텐바이텐물좋은곳 해시태그로 업로드 한 사진은 이벤트 참여를 의미하며, 텐바이텐 플레이 페이지 노출에 동의하는 것으로 간주합니다." /></p>
				<% if oinstagramevent.fresultcount > 0 then %>
				<ul id="instagramlist">
					<% for i = 0 to oinstagramevent.fresultcount-1 %>
					<li>
						<a href="<%=oinstagramevent.FItemList(i).Flinkurl %>" target="_blank" onclick="fnAPPpopupExternalBrowser('<%=oinstagramevent.FItemList(i).Flinkurl %>'); return false;">
							<span class="thumbnail"><img src="<%=oinstagramevent.FItemList(i).Fimgurl%>" alt="" /></span>
							<div class="author"><span><%=printUserId(oinstagramevent.FItemList(i).Fuserid,2,"*")%></span> 님의 물 좋은 곳</div>
						</a>
					</li>
					<% next %>
				</ul>
				<% end if %>
				<!-- pagination -->
				<div class="paging pagingV15a">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
			
		</article>
	</div>
	<!-- // WATER #4 -->
<% set oinstagramevent = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
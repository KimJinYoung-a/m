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
' Description : 플레이띵 Vol.14 fly,play
' History : 2017-05-02 원승현
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66324
Else
	eCode   =  77710
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 6		'한 페이지의 보여지는 열의 수

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
.section {position:relative;}
.intro h2 span {position:absolute;}
.intro h2 span.tit1 {left:28.4%; top:13.21%; width:35.6%;}
.intro h2 span.tit2 {left:19.68%; top:27%; width:61.56%;}
.intro .airplane {position:absolute; left:67%; top:17.5%; width:19%;}
.intro .btnDown {position:absolute; left:50%; bottom:4%; width:9%; margin-left:-4.5%; animation:bounce 1.4s 50; -webkit-animation:bounce 1.4s 50;}
.weplayIs .deco {position:absolute;}
.weplayIs .click {left:9.5%; top:46%; width:11.7%; animation:bounce 1s 50; -webkit-animation:bounce 1s 50;}
.weplayIs .airplane {right:0; bottom:8%; width:34%; }
.weplayIs .airplane.fly {animation:fly 1.8s 1; -webkit-animation:fly 1.8s 1;}
.playVideo {background:#1b2b37;}
.playVideo .videoCont {position:relative;}
.playVideo .videoCont .area {overflow:hidden; position:absolute; left:9.5%; top:0; width:81%; height:100%; border-radius:1.3rem;}
.playVideo .videoCont iframe {width:100%; height:100%;}
.story .swiper-container {position:absolute; left:0; top:39.5%; width:100%;;}
.story .airplane {position:absolute; z-index:30; animation:bounce 1.2s 100; -webkit-animation:bounce 1.2s 100;}
.story .btnNext {position:absolute; left:5%; top:0; width:90%; height:95%; z-index:40; text-indent:-999em; background:transparent; outline:none;}
.story .swiper-slide {width:75.78%;}
.story .swiper-slide.step00 {width:100%;}
.story .swiper-slide.step01 {margin-left:8%;}
.story .swiper-slide:last-child {margin-right:15%;}
.story1 .airplane {left:5.78%; top:10.4%; width:81.8%;}
.story2 .airplane {left:13%; top:0; width:78.75%;}
.story3 .airplane {left:14%; top:5.6%; width:79%;}
.swiper button {position:absolute; top:43%; width:12.5%; z-index:30; background:transparent;}
.swiper .btnPrev {left:0;}
.swiper .btnNext {right:0;}
.swiper .pagination {position:absolute; left:0; bottom:1.7rem; width:100%; z-index:30;}
.swiper .pagination span {display:inline-block; width:0.8rem; height:0.8rem; margin:0 0.5rem; border:0.2rem solid #fff; background:transparent; box-shadow:0 0 0.3rem 0.2rem rgba(0,0,0,.1);}
.swiper .pagination span.swiper-active-switch {background:#fff;}
.applyEvent .sharePlace {padding-bottom:3rem; background-color:#fff2ae;}
.applyEvent .sharePlace ul {overflow:hidden; padding:2.8rem 5.7% 0;}
.applyEvent .sharePlace li {float:left; width:50%; padding:0 2.6% 2.1rem; text-align:center;}
.applyEvent .sharePlace li .pic {padding:0.25rem; background-color:#fff; border-radius:0.2rem;}
.applyEvent .sharePlace li p {text-align:center; padding-top:1rem; color:#999; font-size:1rem; font-weight:600; letter-spacing:-0.03em;}
.applyEvent .sharePlace li p span {color:#2491eb;}
/*.applyEvent .paging span {width:3.1rem; height:3.1rem; border:1px solid rgba(105,178,243,.4); border-radius:50%;}
.applyEvent .paging span a {color:#429bea; font-size:1.4rem; line-height:3rem; padding-top:0; font-weight:bold;}
.applyEvent .paging span.current {border:1px solid #429bea; background-color:#429bea;}
.applyEvent .paging span.current a {color:#fff;}
.applyEvent .paging span.arrow {border:0; background:url(http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_pagination.png) 0 0 no-repeat; background-size:auto 100%;}
.applyEvent .paging span.nextBtn {background-position:100% 0;}*/
.pagingV15a span {color:#86857c;}
.pagingV15a .current {color:#2999d8;}
.pagingV15a .arrow a:after {background-position:-5.8rem -9.56rem;}
.applyEvent .noti {position:relative;}
.applyEvent .noti a {display:block; position:absolute; left:45.5%; top:21%; width:45%; height:17%; text-indent:-999em;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(12px); animation-timing-function:ease-in;}
}
@-webkit-keyframes bounce {
	from, to {-webkit-transform:translateY(0); -webkit-animation-timing-function:ease-out;}
	50% {-webkit-transform:translateY(12px); -webkit-animation-timing-function:ease-in;}
}
@keyframes fly {
	from {opacity:1;}
	to {opacity:0; margin-right:70px; margin-bottom:-70px;}
}
@-webkit-keyframes fly {
	from {opacity:1;}
	to {opacity:0; margin-right:70px; margin-bottom:-70px;}
}
</style>
<script type="text/javascript">
$(function(){
	<% if Request("eCC")<>"" then %>
		setTimeout("pagedown()",300);
	<% end if %>
});

$(function(){
	//var position = $('.flyPlay').offset(); // 위치값
	//$('html,body').animate({ scrollTop : position.top }, 100); // 이동

	story1 = new Swiper(".story1 .swiper-container",{
		speed:600,
		freeMode:true,
		slidesPerView:'auto',
		nextButton:'.story1 .btnNext'
	});
	story2 = new Swiper(".story2 .swiper-container",{
		speed:600,
		freeMode:true,
		slidesPerView:'auto',
		nextButton:'.story2 .btnNext'
	});
	story3 = new Swiper(".story3 .swiper-container",{
		speed:600,
		freeMode:true,
		slidesPerView:'auto',
		nextButton:'.story3 .btnNext'
	});
	mySwiper = new Swiper(".swiper .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:800,
		effect:'fade',
		pagination:".swiper .pagination",
		paginationClickable:true,
		prevButton:'.swiper .btnPrev',
		nextButton:'.swiper .btnNext'
	});

	$(".btnDown").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(".weplayIs").offset().top},600);
	});

	titleAnimation();
	$(".intro h2 span.tit1").css({"margin-top":"20px","opacity":"0"});
	$(".intro h2 span.tit2").css({"margin-top":"20px","opacity":"0"});
	$(".intro .airplane").css({"margin-left":"-220px","margin-top":"220px","opacity":"0"});
	function titleAnimation() {
		$(".intro h2 span.tit1").delay(100).animate({"margin-top":"0","opacity":"1"},900);
		$(".intro h2 span.tit2").delay(700).animate({"margin-top":"0","opacity":"1"},900);
		$(".intro .airplane").delay(800).animate({"margin-left":"0","margin-top":"0","opacity":"1"},1200);
	}

	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 750 ) {
			$(".weplayIs .airplane").addClass("fly");
		}
	});
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#instagramlist").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
<%' THING. html 코딩 영역 : 클래스명은 thing+볼륨 예) thingVol001 / 이미지폴더는 볼륨을 따라 vol001 %>
<div class="thingVol014 flyPlay">
	<div class="section intro">
		<h2>
			<span class="tit1"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/tit_fly.png" alt="Fly" /></span>
			<span class="tit2"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/tit_play.png" alt="Play" /></span>
		</h2>
		<div class="airplane"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_airplane_01.png" alt="" /></div>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_intro.png" alt="어린 시절, 꿈을 담아 하늘에 날렸던 종이비행기 텐바이텐에서 종이비행기 국가대표팀 WEPLAY와 함께 종이비행기를 준비했습니다. 텐바이텐과 Weplay가 알려주는 비행기 접는 방법으로 하늘 높이 날려보세요!" /></p>
		<a href="#weplayIs" class="btnDown"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_down.png" alt="" /></a>
	</div>
	<div class="section weplayIs">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_team.png" alt="종이비행기 국가대표가 있다는 걸 아시나요? 3년마다 열리는 세계 종이비행기 대회 국내에서 오래, 멀리, 곡예 날리기 등 다양한 종목으로 국가대표가 뽑혀 진행됩니다" /></p>
		<div class="mWeb">
			<a href="http://www.redbullpaperwings.com//Countries/South_Korea/" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_go.png" alt="세계 종이 비행기 대회 보러가기" /></a>
			<a href="https://youtu.be/88C_9A9JAec" target="_blank"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_team.png" alt="WEPLAY팀 보러가기" /></a>
		</div>
		<div class="mApp">
			<a href="http://www.redbullpaperwings.com//Countries/South_Korea/" onclick="fnAPPpopupExternalBrowser('http://www.redbullpaperwings.com//Countries/South_Korea/'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_go.png" alt="세계 종이 비행기 대회 보러가기" /></a>
			<a href="https://youtu.be/88C_9A9JAec" onclick="fnAPPpopupExternalBrowser('https://youtu.be/88C_9A9JAec'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_team.png" alt="WEPLAY팀 보러가기" /></a>
		</div>
		<div class="deco click"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_click.png" alt="Click" /></div>
		<div class="deco airplane"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_airplane_02.png" alt="" /></div>
	</div>
	<div class="section playVideo">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_video.png" alt="WEPLAY팀과 함께 종이비행기 접는 방법 영상으로 보기" /></p>
		<div class="videoCont">
			<div class="area"><iframe src="https://player.vimeo.com/video/215664263" title="WEPLAY팀과 함께하는 종이비행기 접는 방법" frameborder="0" allowfullscreen></iframe></div>
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/bg_video.png" alt="" /></div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/bg_video_02.png" alt="" /></div>
	</div>
	<div class="section story story1">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_story_01_v3.png" alt="" /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide step00">
					<div><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_00.png" alt="" /></div>
					<div class="airplane"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story_airplane_01.png" alt="" /></div>
					<button type="button" class="btnNext">다음</button>
				</div>
				<div class="swiper-slide step01"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_01.png" alt="" /></div>
				<div class="swiper-slide step02"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_02.png" alt="" /></div>
				<div class="swiper-slide step03"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_03.png" alt="" /></div>
				<div class="swiper-slide step04"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_04.png" alt="" /></div>
				<div class="swiper-slide step05"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_05.png" alt="" /></div>
				<div class="swiper-slide step06"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_06.png" alt="" /></div>
				<div class="swiper-slide step07"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_07.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story01_08.png" alt="" /></div>
			</div>
		</div>
	</div>
	<div class="section story story2">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_story_02_v2.png" alt="" /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide step00">
					<div><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_00.png" alt="" /></div>
					<div class="airplane"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story_airplane_02.png" alt="" /></div>
					<button type="button" class="btnNext">다음</button>
				</div>
				<div class="swiper-slide step01"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_01.png" alt="" /></div>
				<div class="swiper-slide step02"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_02.png" alt="" /></div>
				<div class="swiper-slide step03"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_03.png" alt="" /></div>
				<div class="swiper-slide step04"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_04.png" alt="" /></div>
				<div class="swiper-slide step05"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_05.png" alt="" /></div>
				<div class="swiper-slide step06"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_06.png" alt="" /></div>
				<div class="swiper-slide step07"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_07.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_08.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_09.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_10.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_11.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story02_12.png" alt="" /></div>
			</div>
		</div>
	</div>
	<div class="section story story3">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_story_03_v2.png" alt="" /></p>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide step00">
					<div><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_00.png" alt="" /></div>
					<div class="airplane"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story_airplane_03.png" alt="" /></div>
					<button type="button" class="btnNext">다음</button>
				</div>
				<div class="swiper-slide step01"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_01.png" alt="" /></div>
				<div class="swiper-slide step02"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_02.png" alt="" /></div>
				<div class="swiper-slide step03"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_03.png" alt="" /></div>
				<div class="swiper-slide step04"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_04.png" alt="" /></div>
				<div class="swiper-slide step05"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_05.png" alt="" /></div>
				<div class="swiper-slide step06"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_06.png" alt="" /></div>
				<div class="swiper-slide step07"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_07.png" alt="" /></div>
				<div class="swiper-slide step08"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_story03_08.png" alt="" /></div>
			</div>
		</div>
	</div>
	<div class="swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_slide_01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_slide_02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_slide_03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/img_slide_04.jpg" alt="" /></div>
			</div>
			<div class="pagination"></div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
	<%' 인스타 공유하기 %>
	<div class="section applyEvent">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_event.png" alt="종이비행기와 #가고 싶은 장소를 적은 후 인증샷을 남겨주세요" /></p>
		<a href="https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%EC%A2%85%EC%9D%B4%EB%B9%84%ED%96%89%EA%B8%B0/" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_instagram.png" alt="인스타그램에 공유하러 가기." /></a>
		<a href="https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%EC%A2%85%EC%9D%B4%EB%B9%84%ED%96%89%EA%B8%B0/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%EC%A2%85%EC%9D%B4%EB%B9%84%ED%96%89%EA%B8%B0/'); return false;" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/btn_instagram.png" alt="인스타그램에 공유하러 가기." /></a>
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_upload.png" alt="인스타그램에 #텐바이텐종이비행기 #종이비행기국가대표 중 하나를 꼭 넣어 업로드해주세요" /></p>
		<div class="noti">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_noti_v2.png" alt="인스타그램 계정이 비공개인 경우, 집계가 되지 않습니다./이벤트 기간 동안 #텐바이텐종이비행기 해시태그로 업로드 한 사진은 이벤트 참여를 의미하며 텐바이텐 플레이 페이지에 노출됨을 동의하는 것으로 간주합니다." /></p>
			<a href="/event/eventmain.asp?eventid=65618" class="mWeb">텐바이텐 배송상품 보러가기</a>
			<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=65618" onclick="fnAPPpopupEvent('65618'); return false;" class="mApp">텐바이텐 배송상품 보러가기</a>
		</div>
		<%' 인스타 공유 목록 %>
		<% if oinstagramevent.fresultcount > 0 then %>
			<div class="sharePlace">
			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="eCC" value="1">
			</form>
				<ul>
					<%' 이미지 6개씩 노출 %>
					<% for i = 0 to oinstagramevent.fresultcount-1 %>
						<li>
							<div class="pic"><img src="<%= oinstagramevent.FItemList(i).Fimgurl %>" alt="" /></div>
							<p><span><%=printUserId(left(oinstagramevent.FItemList(i).Fuserid,10),2,"*")%></span> 님의 종이비행기</p>
						</li>
					<% next %>					
				</ul>
				<%' pagination %>
				<div class="paging pagingV15a">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
		<% End If %>
		<%'// 인스타 공유 목록 %>
	</div>
	<%'// 인스타 공유하기 %>

	<%' volume %>
	<div class="volume">
		<p><img src="http://webimage.10x10.co.kr/playing/thing/vol014/m/txt_vol014.png" alt="vol.014 THING의 사물에 대한 생각 종이비행기, 나의 이야기를 담아 날려보세요" /></p>
	</div>
</div>
<% set oinstagramevent = nothing %>
<%' //THING. html 코딩 영역 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
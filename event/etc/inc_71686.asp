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
' Description : 도리를 찾아서 2 WWW
' History : 2016-07-05 유태욱 생성
'####################################################
Dim eCode, userid, pagereload, i
dim iCCurrpage, iCTotCnt, eCC, iCPageSize, iCTotalPage
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66165
Else
	eCode   =  71686
End If

iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
IF iCCurrpage = "" THEN iCCurrpage = 1
IF iCTotCnt = "" THEN iCTotCnt = -1

eCC = requestCheckVar(Request("eCC"), 1)
pagereload	= requestCheckVar(request("pagereload"),2)
userid		= GetEncLoginUserID()

iCPageSize = 4		'한 페이지의 보여지는 열의 수

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


'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 텐바이텐에 온 도리")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 텐바이텐에 온 도리"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_kakao.jpg"
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
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.dory .app {display:none;}
.dory button {background-color:transparent;}

.topic {position:relative;}
.topic .icoDory {position:absolute; top:69.5%; right:18%; width:20.31%;}
.topic .icoDory {
	animation-name:bounce; animation-duration:1.5s; animation-iteration-count:5; animation-fill-mode:both; animation-direction:alternate; animation-play-state:running;
	-webkit-animation-name:bounce; -webkit-animation-duration:1.5s; -webkit-animation-iteration-count:5; -webkit-animation-fill-mode:both; -webkit-animation-direction:alternate; -webkit-animation-play-state:running;
}
@keyframes bounce {
	0% {top:75.5%;}
	100% {top:69.5%;}
}
@-webkit-keyframes bounce {
	0% {top:75.5%;}
	100% {top:69.5%;}
}

.item {background-color:#2160c1;}

.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-10%; left:0; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:8px; height:8px; margin:0 0.5rem; border-radius:50%; background-color:#fff; cursor:pointer; transition:background-color 0.5s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#50dcff;}
.rolling .swiper button {position:absolute; top:42%; z-index:20; width:10.3%; background-color:transparent;}
.rolling .swiper .btn-prev {left:0;}
.rolling .swiper .btn-next {right:0;}

.delivery {padding-bottom:10%; background-color:#ffcc00;}
.delivery ul {overflow:hidden; padding:0 4.1%;}
.delivery ul li {float:left; width:50%; margin-bottom:7%;}
.delivery ul li a {overflow:hidden; display:block; width:13.1rem; height:13.1rem; margin:0 auto;}
.delivery ul li a img {width:13.1rem; height:13.1rem;}
.delivery .group {position:relative;}
.delivery .group .btnDelivery {position:absolute; top:30.9%; right:0; width:56.56%;}

.pagingV15a {margin-top:0;}
.pagingV15a span {width:3.1rem; height:3.1rem; margin:0 0.6rem; border:1px solid #ffcc00; border-radius:50%;}
.pagingV15a span a {color:#d88b1e; font-size:1.3rem; line-height:1.5rem;}
.pagingV15a span.current {border:0; background-color:#d88b1e;}
.pagingV15a span.current a {color:#fff; font-weight:normal;}
.pagingV15a span.arrow {border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_pagination_prev.png) no-repeat 50% 50%; background-size:2.1rem auto;}
.pagingV15a span.nextBtn {background:url(http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_pagination_next.png) no-repeat 50% 50%; background-size:2.1rem auto;}

.offline {position:relative;}
.offline .btnOffline {position:absolute; bottom:7%; left:50%; width:45.78%; margin-left:-22.89%;}

.intro {position:relative;}
.intro .rolling {position:absolute; top:26.92%; left:50%; width:87.5%; margin-left:-43.75%;}

.video {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:62.45%; background:#000;}
.video iframe {position:absolute; top:0; left:0; width:100%; height:100%}

@media all and (min-width:480px){
	.intro .rolling .swiper .pagination .swiper-pagination-switch {width:10px; height:10px;}
}
@media all and (min-width:768px){
	.intro .rolling .swiper .pagination .swiper-pagination-switch {width:14px; height:14px;}
}

.sns {position:relative;}
.sns ul {position:absolute; bottom:16%; left:0; width:100%; padding:0 9%;}
.sns ul:after {content:' '; display:block; clear:both;}
.sns ul li {float:left; position:relative; width:25%;}
.sns ul li button,
.sns ul li > a {display:block; margin:0 8%;}
.sns ul li.instagram .go {display:none; position:absolute; top:75%; left:-146%; z-index:50; width:280%;}
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
	/* swipe */
	mySwiper1 = new Swiper('#rolling1 .swiper1',{
		loop:true,
		autoplay:2000,
		speed:800,
		nextButton:'#rolling1 .btn-next',
		prevButton:'#rolling1 .btn-prev'
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#rolling1 .app, #offline .app").show();
			$("#rolling1 .mo, #offline .mo").hide();
	}else{
			$("#rolling1 .app, #offline .app").hide();
			$("#rolling1 .mo, #offline .mo").show();
	}

	mySwiperMovie = new Swiper('#rollingMovie .swiper1',{
		loop:true,
		autoplay:false,
		speed:800,
		pagination:"#rollingMovie .pagination",
		paginationClickable:true,
		nextButton:'#rollingMovie .btn-next',
		prevButton:'#rollingMovie .btn-prev'
	});

	/* sns instagram */
	$("#sns .instagram button" ).on("click", function() {
		$("#sns .instagram .go").show();
	});
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
	<!-- [M/A] 71686 도리를찾아서 2차 - 텐바이텐에 온 도리 -->
	<div class="mEvt71686 dory">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/txt_dory_v1.jpg" alt="텐바이텐과 도리를 찾아서" /></p>
			<span class="icoDory"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_dory.png" alt="" /></span>
		</div>

		<div class="item">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/tit_item_v1.jpg" alt="텐바이텐 도리 굿즈 런칭!" /></h3>
			<div id="rolling1" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1516362&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_01.jpg" alt="Glass Cup" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1516362&amp;pEtr=71686" onclick="fnAPPpopupProduct('1516362&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_01.jpg" alt="Glass Cup" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1523834&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_02.jpg" alt="Towel" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523834&amp;pEtr=71686" onclick="fnAPPpopupProduct('1523834&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_02.jpg" alt="Towel" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1509356&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_03.jpg" alt="Coaster Set" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1509356&amp;pEtr=71686" onclick="fnAPPpopupProduct('1509356&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_03.jpg" alt="Coaster Set" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1520146&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_04.jpg" alt="Rug medium" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1520146&amp;pEtr=71686" onclick="fnAPPpopupProduct('1520146&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_04.jpg" alt="Rug medium" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1520147&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_05.jpg" alt="Rug Large" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1520147&amp;pEtr=71686" onclick="fnAPPpopupProduct('1520147&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_05.jpg" alt="Rug Large" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1523832&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_06.jpg" alt="Beach Towel" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1523832&amp;pEtr=71686" onclick="fnAPPpopupProduct('1523832&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_06.jpg" alt="Beach Towel" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_07.jpg" alt="Playing Cards" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507612&amp;pEtr=71686" onclick="fnAPPpopupProduct('1507612&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_07.jpg" alt="Playing Cards" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_08.jpg" alt="Pattern Dory 아이폰6, 6S 투명 케이스" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507611&amp;pEtr=71686" onclick="fnAPPpopupProduct('1507611&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_08.jpg" alt="Pattern Dory 아이폰6, 6S 투명 케이스" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_09.jpg" alt="Stripe Dory 아이폰6, 6S 케이스" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507606&amp;pEtr=71686" onclick="fnAPPpopupProduct('1507606&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_09.jpg" alt="Stripe Dory 아이폰6, 6S 케이스" /></a>
							</div>
							<div class="swiper-slide">
								<a href="/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71686" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_10.jpg" alt="Fantastic Dory 아이폰6, 6S 케이스" /></a>
								<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1507610&amp;pEtr=71686" onclick="fnAPPpopupProduct('1507610&amp;pEtr=71686');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_10.jpg" alt="Fantastic Dory 아이폰6, 6S 케이스" /></a>
							</div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_prev_01.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_next_01.png" alt="다음" /></button>
				</div>
			</div>
		</div>

		<div class="delivery">
			<div class="group">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/txt_delivery_box_v1.png" alt="배송송박스를 찍어주세요! 지금 텐바이텐 배송 상품을 주문하면 도리를 찾아서가 그려진 박스가 도착합니다. 도리의 사진을 찍어 인스타그램에 올려주세요! 100분에게는 시크릿 경품을 드립니다! 일부 상품 제외, 선착순 소진" /></p>
				<a href="eventmain.asp?eventid=65618" title="텐텐 배송 나가신다 길을 비켜라 이벤트 페이지로 이동" class="btnDelivery"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_delivery_tenten.png" alt="텐텐배송 보러가기" /></a>
			</div>

			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
			<input type="hidden" name="iCTot" value=""/>
			<input type="hidden" name="eCC" value="1">
			</form>
			
			<% if oinstagramevent.fresultcount > 0 then %>
			<div class="tentenBox" id="instagramlist" >
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/tit_tenten_box.png" alt="방금 도착한 텐바이텐 박스" /></h3>
				<ul>
					<% for i = 0 to oinstagramevent.fresultcount-1 %>
						<li><a href="<%= oinstagramevent.FItemList(i).Flinkurl %>" target="_blank" onclick="fnAPPpopupExternalBrowser('<%=oinstagramevent.FItemList(i).Flinkurl %>'); return false;"><img src="<%= oinstagramevent.FItemList(i).Fimgurl %>" alt="" /></a></li>
					<% next %>
				</ul>

				<!-- pagination -->
				<div class="paging pagingV15a">
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
			</div>
			<% end if %>
		</div>

		<div id="offline" class="offline">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/txt_offline.jpg" alt="매장을 찍어주세요! 도리를 찾아서 친구들과 함께 사진을 찍고 인증을 해주시면 한화 아쿠아플라넷 당첨의 기회가! 대학로, 김포롯데, 신제주점 매장방문시 비치볼과 메모잇 선물 증정 예정이며, 일부 상품은 제외되며, 선착순 소진 될 수 있습니다." /></p>
			<a href="/offshop/" target="_blank" title="텐바이텐 오프라인 매장 안내 페이지로 이동 새창" class="btnOffline mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_offline.png" alt="매장 위치 보러가기" /></a>
			<a href="/apps/appCom/wish/web2014/offshop/offshop/" title="텐바이텐 오프라인 매장 안내 페이지로 이동" onclick="fnAPPpopupBrowserURL('매장안내','http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/'); return false;" class="btnOffline app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_offline.png" alt="매장 위치 보러가기" /></a>
		</div>

		<div class="intro">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/tit_intro.png" alt="도리를 찾아서 2016년 7월 7일 개봉" /></h3>
			<div id="rollingMovie" class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="video">
									<iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=D567147FDDA7DDADED6733B78A0A9B260910&outKey=V12727c8482939b7c068adb72a5590d705f0f450805cde559a38bdb72a5590d705f0f&controlBarMovable=true&jsCallable=true&isAutoPlay=false&skinName=tvcast_white" frameborder="0" title="도리를 찾아서 예고편" allowfullscreen></iframe>
								</div>
								<div class="mask mask-top"></div>
								<div class="mask mask-btm"></div>
							</div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_movie_02.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_movie_03.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_movie_04.jpg" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/img_slide_movie_05.jpg" alt="" /></div>
						</div>
					</div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71110/m/btn_next.png" alt="다음" /></button>
					<div class="pagination"></div>
				</div>
			</div>
		</div>

		<!-- for dev msg : sns -->
		<div id="sns" class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/txt_sns.png" alt="텐바이텐과 영화 도리를 찾아서 친구에게도 알려주기" /></p>
			<ul>
				<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/ico_facebook.png" alt="페이스북에 텐바이텐에 온 도리 이벤트 공유하기" /></a></li>
				<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/ico_twitter.png" alt="트위터에 텐바이텐에 온 도리 이벤트 공유하기" /></a></li>
				<li class="kakao"><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/ico_kakao.png" alt="카카오톡으로 텐바이텐에 온 도리 이벤트 공유하기" /></a></li>
				<li class="instagram">
					<button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/ico_instagram.png" alt="인스타그램에 텐바이텐에 온 도리 이벤트 공유하기" /></button>
					<div id="instagram" class="go">
						<a href="https://www.instagram.com/your10x10/" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/your10x10/'); return false;" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71686/m/btn_instagram.png" alt="본 페이지를 캡쳐해서 포스팅해주세요 텐바이텐 공식 인스타그램 이동" /></a>
					</div>
				</li>
			</ul>
		</div>
	</div>
	<!-- //텐바이텐에 온 도리  -->
<% set oinstagramevent = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : the pen fair
' History : 2016-08-26 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<style type="text/css">
img {vertical-align:top;}
.thePenFair {background:#fff;}
.thePenFair .penList {position:relative; margin:3.4rem 0 4.5rem; z-index:1; background:#fff;}
.thePenFair .penList .swiper-content {position:relative; width:100%;}
.thePenFair .penList .swiper-content .swiper-slide {width:72%; padding:0 1%;}
.thePenFair .penList .swiper-content .btnItem { display:block; position:absolute;  top:28%; width:5.75%; padding:0 1%; z-index:40; background:transparent;}
.thePenFair .penList .swiper-content .btnItem.prev {left:11.5%;}
.thePenFair .penList .swiper-content .btnItem.next {right:11.5%;}
.thePenFair .navWrap {position:relative; width:220px; padding:20px 30px 0; margin:0 auto;}
.thePenFair .navWrap iframe {width:100%; height:3.6rem;}
.thePenFair .swiper-nav {overflow:hidden; position:relative; width:160px; height:23px !important; margin:0 auto;}
.thePenFair .swiper-nav .swiper-slide {width:22px !important; height:22px !important; margin:0 5px; text-align:center; color:#b9b9b9; font:normal 13px/22px arial;}
.thePenFair .swiper-nav .swiper-slide.swiper-slide-active {color:#fff; background:#4abc70; border-radius:50%;}
.thePenFair .btnNav {display:block; position:absolute; bottom:0; width:22px; height:22px; cursor:pointer;}
.thePenFair .penList .btnNav.prev {left:0;}
.thePenFair .penList .btnNav.next {right:0;}
.thePenFair .penNavWrap {border-top:1px solid #eee; border-bottom:1px solid #eee;}
.thePenFair .penPlay {padding-bottom:2.5rem; background:#f7f7f7;}
.thePenFair .penPlay .swiper1 {position:relative; padding-bottom:1.5rem;}
.thePenFair .penPlay .swiper-slide {width:15rem; margin-left:1rem;}
.thePenFair .penPlay .swiper-slide.book {width:30rem;}
.thePenFair .penPlay .pagination {position:absolute; left:0; bottom:0; z-index:50; width:100%; height:0.4rem; padding-top:0; text-align:center;}
.thePenFair .penPlay .pagination span {display:inline-block; width:0.5rem; height:0.5rem; margin:0 0.2rem; border:1px solid #b9b9b9; cursor:pointer; background:#f7f7f7;}
.thePenFair .penPlay .pagination .swiper-active-switch {border-color:#4abc70; background:#4abc70;}
.thePenFair .penPlay .movieWrap {padding:3rem 1rem 0;}
.thePenFair .penPlay .movieWrap .movie {overflow:hidden; position:relative; height:100%; padding-bottom:56.25%;}
.thePenFair .penPlay .movieWrap .movie iframe {position:absolute; top:0; left:0; bottom:0; width:100%; height:100%; vertical-align:top;}
.thePenFair .penPlay .book li {position:absolute; top:15%; width:22%; height:70%;}
.thePenFair .penPlay .book li.b1 {left:22.5%;}
.thePenFair .penPlay .book li.b2 {left:50%;}
.thePenFair .penPlay .book li.b3 {left:76%;}
.thePenFair .penPlay .book li a {display:block; width:100%; height:100%; text-indent:-999em;}
.thePenFair .penStory {padding:2.2rem 1rem 0.5rem; border-bottom:1px solid #f4f4f4;}
.thePenFair .penStory li {padding-bottom:2rem;}
.thePenFair .penStory li:first-child {padding-bottom:1rem;}
@media all and (min-width:480px){
	.thePenFair .navWrap {width:330px; padding:30px 45px 0;}
	.thePenFair .swiper-nav {width:240px; height:34px !important;}
	.thePenFair .swiper-nav .swiper-slide {width:33px !important; height:33px !important; margin:0 7px; font:normal 20px/33px arial;}
	.thePenFair .btnNav {width:33px; height:33px; cursor:pointer;}
}
</style>
<script type="text/javascript">
$(function(){
	var galleryTop = new Swiper('.swiper-content', {
		loop:true,
		slidesPerView:'auto',
		centeredSlides:true,
		nextButton: '.swiper-content .next',
		prevButton: '.swiper-content .prev'
	});
	var galleryThumbs = new Swiper('.swiper-nav', {
		loop:true,
		centeredSlides:true,
		slidesPerView:'auto',
		slideToClickedSlide: true,
		nextButton:'.navWrap .next',
		prevButton:'.navWrap .prev'
	});
	galleryTop.params.control = galleryThumbs;
	galleryThumbs.params.control = galleryTop;

	mySwiper1 = new Swiper('.penPlay .swiper-container',{
		loop:false,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		centeredSlides:true,
		pagination:'.penPlay .pagination',
		paginationClickable:true
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
</script>

	<!-- 이벤트 배너 등록 영역 -->
	<div class="evtContV15">

		<div class="mEvt72643 thePenFair">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/tit_pen_fair.png" alt="THE PEN FAIR" /></h2>
			<div class="penNavWrap">
				<!-- iframe -->
				<iframe id="iframe_72643" src="/event/etc/group/iframe_72643.asp?eventid=72643" width="1140" height="103" frameborder="0" scrolling="no" class="" title="the pen fair" allowtransparency="true"></iframe>
				<!--// iframe -->
			</div>
			<div class="penList">
				<div class="swiper-container swiper-content">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1489745&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_1.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1489745&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_1.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1489746&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_2.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1489746&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_2.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1489755&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_3.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1489755&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_3.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1243691&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_4.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1243691&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_4.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1476204&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_5.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1476204&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_5.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=978523&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_6.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('978523&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_6.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1188371&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_7.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1188371&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_7.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1482046&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_8.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1482046&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_8.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=951383&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_9.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('951383&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_9.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=654920&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_10.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('654920&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_10.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=814174&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_11.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('814174&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_11.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1522815&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_12.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1522815&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_12.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1093936&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_13.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1093936&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_13.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=348346&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_14.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('348346&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_14.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=750259&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_15.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('750259&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_15.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1544022&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_16.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1544022&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_16.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=816245&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_17.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('816245&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_17.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=815756&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_18.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('815756&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_18.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1459011&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_19.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1459011&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_19.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=846720&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_20.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('846720&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_20.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1467291&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_21.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1467291&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_21.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=583103&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_22.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('583103&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_22.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=194986&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_23.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('194986&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_23.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1489338&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_24.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1489338&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_24.jpg" alt="" /></a>
						</div>
						<div class="swiper-slide">
							<a href="/category/category_itemPrd.asp?itemid=1065630&amp;pEtr=72643" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_25.jpg" alt="" /></a>
							<a href="" onclick="fnAPPpopupProduct('1065630&amp;pEtr=72643');return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/img_pen_25.jpg" alt="" /></a>
						</div>
					</div>
					<button class="btnItem prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/btn_prev_2.png" alt="이전" /></button>
					<button class="btnItem next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/btn_next_2.png" alt="다음" /></button>
				</div>
				<div class="navWrap">
					<div class="swiper-container swiper-nav">
						<div class="swiper-wrapper">
							<div class="swiper-slide">1</div>
							<div class="swiper-slide">2</div>
							<div class="swiper-slide">3</div>
							<div class="swiper-slide">4</div>
							<div class="swiper-slide">5</div>
							<div class="swiper-slide">6</div>
							<div class="swiper-slide">7</div>
							<div class="swiper-slide">8</div>
							<div class="swiper-slide">9</div>
							<div class="swiper-slide">10</div>
							<div class="swiper-slide">11</div>
							<div class="swiper-slide">12</div>
							<div class="swiper-slide">13</div>
							<div class="swiper-slide">14</div>
							<div class="swiper-slide">15</div>
							<div class="swiper-slide">16</div>
							<div class="swiper-slide">17</div>
							<div class="swiper-slide">18</div>
							<div class="swiper-slide">19</div>
							<div class="swiper-slide">20</div>
							<div class="swiper-slide">21</div>
							<div class="swiper-slide">22</div>
							<div class="swiper-slide">23</div>
							<div class="swiper-slide">24</div>
							<div class="swiper-slide">25</div>
						</div>
					</div>
					<button class="btnNav prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/btn_prev.png" alt="이전" /></button>
					<button class="btnNav next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/btn_next.png" alt="다음" /></button>
				</div>
			</div>
			<div class="penPlay">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/tit_pen_play.png" alt="PEN PLAY" /></h3>
				<div class="swiper1">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_1.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_2.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_3.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_4.png" alt="" /></div>
							<div class="swiper-slide book">
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_5.png" alt="" /></div>
								<ul>
									<li class="b1">
										<a href="/category/category_itemPrd.asp?itemid=1550028&amp;pEtr=72643" class="mw">필사의 기초:조경국</a>
										<a href="" onclick="fnAPPpopupProduct('1550028&amp;pEtr=72643');return false;" class="ma">필사의 기초:조경국</a>
									</li>
									<li class="b2">
										<a href="/category/category_itemPrd.asp?itemid=1549999&amp;pEtr=72643" class="mw">필사의 힘:윤동주의 하늘과 바람과 별과 시 따라쓰기</a>
										<a href="" onclick="fnAPPpopupProduct('1549999&amp;pEtr=72643');return false;" class="ma">필사의 힘:윤동주의 하늘과 바람과 별과 시 따라쓰기</a>
									</li>
									<li class="b3">
										<a href="/category/category_itemPrd.asp?itemid=1550000&amp;pEtr=72643" class="mw">논어 철학노트 필사본</a>
										<a href="" onclick="fnAPPpopupProduct('1550000&amp;pEtr=72643');return false;" class="ma">논어 철학노트 필사본</a>
									</li>
								</ul>
							</div>
							<div class="swiper-slide"><a href="eventmain.asp?eventid=72760"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_transcribe_6.png" alt="" /></a></div>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
				<div class="movieWrap">
					<div class="movie">
						<iframe src="https://player.vimeo.com/video/180008631" title="" frameborder="0" allowfullscreen></iframe>
					</div>
				</div>
			</div>
			<ul class="penStory">
				<li><a href="eventmain.asp?eventid=72654"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/bnr_themselves.jpg" alt="01. PEN Themselves" /></a></li>
				<li><a href="eventmain.asp?eventid=72653"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/bnr_brand.jpg" alt="02. PEN Brand MAP" /></a></li>
				<li><a href="eventmain.asp?eventid=72645"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/bnr_type.jpg" alt="03. NIB Type12" /></a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72643/m/txt_comment.png" alt="COMMENT  EVENT" /></p>
		</div>

	</div>
	<!--// 이벤트 배너 등록 영역 -->
	
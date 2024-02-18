<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2020/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
Dim oExhibition
dim masterCode
dim i

IF application("Svr_Info") = "Dev" THEN
	masterCode = "3"
else
	masterCode = "10"
end if

SET oExhibition = new ExhibitionCls
%>
<%
public function couponDisp(couponVal)
	if couponVal = "" or isnull(couponVal) then exit function
	couponDisp = chkIIF(couponVal > 100, couponVal, couponVal & "%")
end function
%>
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.26">
<script type="text/javascript">
$(function() {
	//헤더
	/*var lastScrollTop1 = 0;
	$(window).scroll(function(event){
		var st1 = $(this).scrollTop();
		if (st1 > lastScrollTop1 && st1 > 0){
			$('.fixed').addClass('on')
		} else {
			$('.fixed').removeClass('on')
		}
		lastScrollTop1 = st1;
	});*/

	//메인 슬라이드
	var $total = $('.slide1').find(".swiper-slide").length;
	var $initScale = 1 / $total;
	var $progressFill = $('.slide1').find(".pagination-fill");
	$progressFill.css("transform", "scaleX(" + $initScale + ")");
	$('.slide1').swiper({
		autoplay:3800,
		loop:true,
		speed:500,
		effect:'fade',
		onSlideChangeStart: function (slideProgressbar) {
			var $current = slideProgressbar.activeIndex;
			if ($current == 0) {
				var $scale = 1;
			} else if ($current > $total) {
				var $scale = $initScale;
			} else {
				var $scale = $initScale * $current;
			}
			$progressFill.css("transform", "scaleX(" + $scale + ")");
		}
	});

	//기프트 슬라이드
	swiper = new Swiper('.slide2', {
		autoplay:3500,
		loop: true,
		effect:'fade',
	})

	//랭킹 디자인 효과
	$('.num-rolling').append('<svg><circle cx="1.5rem" cy="1.5rem" stroke="#ffe400" r="1.28rem" fill="none" stroke-width="2" stroke-miterlimit="10"></circle></svg>')

	// search filter dropdwon
	$(".diary-main .filter ul").hide();
	$( ".diary-main .filter > p" ).click(function() {
		$(this).toggleClass("selected");
		if ($(this).hasClass('selected')){
			$(this).next('ul').show();
		} else {
			$(this).next('ul').hide();
		}
	});

	//페이지내에서 탭 이동
	$(".diary-nav li a").click(function(){
		$('html,body').animate({'scrollTop': $(this.hash).offset().top-70},1000);
	});

});
</script>
	<!-- contents -->
	<div id="content" class="content diary-main">
		<%'// 2019-09-19 신규 헤더 적용 %>
		<div class="diary-header2">
			<h2><img src="//fiximage.10x10.co.kr/m/2019/diary2020/logo2.png" alt="Diary Story 2020"></h2>
			<ul>
				<li>
					<% if isapp = 1 then %>
					<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸랭킹', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccu_ranking.asp')">
					<% else %>
					<a href="/diarystory2020/daccu_ranking.asp">
					<% end if %>
						<p>다꾸랭킹</p>
					</a>
				</li>
				<li>
					<% if isapp = 1 then %>
					<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸TV', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccutv.asp')">
					<% else %>
					<a href="/diarystory2020/daccutv.asp">
					<% end if %>
						<p>다꾸TV</p>
					</a>
				</li>
				<li>
					<% if isapp = 1 then %>
					<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸톡톡', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/daccu_toktok.asp')">
					<% else %>
					<a href="/diarystory2020/daccu_toktok.asp">
					<% end if %>
						<p>다꾸톡톡</p>
						<!-- new 뱃지 --><span class="badge-new"><img src="//fiximage.10x10.co.kr/m/2019/diary2020/ico_new2.png" alt="new"></span>
					</a>
				</li>
				<li>
					<% if isapp = 1 then %>
                    <a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 검색', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/search.asp')">
                    <% else %>
                    <a href="/diarystory2020/search.asp">
                    <% end if %>
                        <p>검색</p>
                        <span class="ico-sch"><img src="//fiximage.10x10.co.kr/m/2019/diary2020/ico_search2.png" alt=""></span>
                    </a>
				</li>
			</ul>
		</div>
		<%'<!-- 상단 슬라이드 영역 -->%>
		<!-- #include virtual="/diarystory2020/inc/main/inc_main_rolling.asp" -->

		<%'<!-- 기프트 -->%>
		<!-- #include virtual="/diarystory2020/inc/main/inc_special_benefit.asp" -->

		<%'<!-- 추천다이어리 -->%>
		<!-- #include virtual="/diarystory2020/inc/main/inc_recommended_diary.asp" -->

		<%'<!-- 기획전 -->%>
		<!-- #include virtual="/diarystory2020/inc/main/inc_exhibition.asp" -->

		<%'<!-- 다이어리찾기 -->%>
		<!-- #include virtual="/diarystory2020/inc/main/inc_diary_search.asp" -->

		<%'<!-- 퍼블 수작업 미정 -->%>
		<!-- 하단 기획전 모음 0903수정 -->
		<section class="spc-area">
			<img src="//fiximage.10x10.co.kr/m/2019/diary2020/img_spc.jpg?v=1.01" alt="">
			<ul>
				<li><a href="/event/eventmain.asp?eventid=97018" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97018');return false;">Pen</a></li>
				<li><a href="/event/eventmain.asp?eventid=97021" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97021');return false;">Moleskine</a></li>
				<li><a href="/event/eventmain.asp?eventid=97017" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97017');return false;">Calendar</a></li>
				<li><a href="/event/eventmain.asp?eventid=97020" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97020');return false;">Memo</a></li>
				<li><a href="/event/eventmain.asp?eventid=97016" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97016');return false;">Sticker</a></li>
				<li><a href="/event/eventmain.asp?eventid=97019" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97019');return false;">6공 ITEM</a></li>
			</ul>
		</section>
	</div>
	<!-- //contents -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 나른 디즈니
' History : 2021-04-16 김진욱
'####################################################
Dim currentDate, evtStartDate, evtEndDate, eCode, userid, mktTest
Dim eventCoupons, isCouponShow, vQuery
mktTest = false

currentDate = now()
evtStartDate = Cdate("2021-04-18")
evtEndDate = Cdate("2021-04-18")

'test
'currentDate = Cdate("2021-04-16")

IF application("Svr_Info") = "Dev" THEN
	eCode = "104334"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "105348"
    mktTest = true    
Else
	eCode = "109527"
    mktTest = false
End If
%>
<script>
$(function() {
    $('.mEvt109527 .top-txt h2').addClass('on');
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
    var swiper = new Swiper(".section-01 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:1,
        loop:true,
        pagination:'.swiper-paginations01'
    });
    var swiper = new Swiper(".section-05 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:"auto",
        loop:true,
        spaceBetween:15,
        centeredSlides:false,
        pagination:'.swiper-pagination'
    });
    /* 팝업 닫기 */
    $('.mEvt109527 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});
</script>
<style>
.mEvt109527 .topic {position:relative;}
.mEvt109527 .topic .top-txt {position:absolute; left:50%; top:9%; transform: translate(-50%,0);}
.mEvt109527 .topic .top-txt .txt01 {width:63.86vw; margin:0 auto; opacity:0; transition:1s; transform: translateY(1rem);}
.mEvt109527 .topic .top-txt .txt02 {width:83.33vw; margin:0 auto; padding-top:1.73rem; opacity:0; transition:1s .6s; transform: translateY(1rem);}
.mEvt109527 .topic .top-txt .txt01.on {transform: translateY(0); opacity:1;}
.mEvt109527 .topic .top-txt .txt02.on {transform: translateY(0); opacity:1;}

.mEvt109527 .animate {opacity:0; transform:translateY(10%); transition:all 1.5s;}
.mEvt109527 .animate.on {opacity:1; transform:translateY(0);}

.mEvt109527 .section-01 {background:#ff7930;}
.mEvt109527 .section-01 .tit {width:76.53vw; margin:0 auto; padding:4.56rem 0 2.17rem;}
.mEvt109527 .slide-area {position:relative; padding-bottom:2.56rem;}
.mEvt109527 .slide-area .swiper-container {padding-bottom:2.13rem;}

.mEvt109527 .swiper-pagination {position:absolute; left:50%; bottom:0; transform:translate(-50%,0); z-index:10;}
.mEvt109527 .swiper-paginations01 {position:absolute; left:50%; bottom:0; transform:translate(-50%,0); z-index:10;}
.mEvt109527 .swiper-pagination-switch {display:inline-block; width:2.26vw; height:2.26vw; margin:0 0.43rem; border-radius:100px; background:#f34500;}
.mEvt109527 .section-05 .swiper-pagination-switch {display:inline-block; width:2.26vw; height:2.26vw; margin:0 0.43rem; border-radius:100px; background:#1aa8a1;}
.mEvt109527 .swiper-pagination-switch.swiper-active-switch {background:#ffd9c4;}
.mEvt109527 .section-05 .swiper-pagination-switch.swiper-active-switch {background:#fff9e6;}

.mEvt109527 .section-02,
.mEvt109527 .section-03,
.mEvt109527 .section-04 {position:relative;}
.mEvt109527 .section-02 .tit {position:absolute; left:50%; top:2.8%; width:70.13vw; margin-left:-35.06vw;}
.mEvt109527 .section-03 .tit,
.mEvt109527 .section-04 .tit {position:absolute; left:50%; top:2.5%; width:70.13vw; margin-left:-35.06vw;}
.mEvt109527 .section-05 {margin-top:13.33vw; background:#7dd1cd;}
.mEvt109527 .section-05 .slide-area .swiper-container {padding-bottom:4.13rem;}
.mEvt109527 .section-05 .swiper-slide {width:82.66vw;}
.mEvt109527 .section-05 .slide-area {padding-left:2.17rem;}

.mEvt109527 .section-06 {position:relative;}
.mEvt109527 .section-06 .vod {position:absolute; left:50%; bottom:5%; transform:translate(-50%,0); width:89vw; height:50vw;}
.mEvt109527 .section-06 .vod .inner {width:89vw; height:50vw;}
.mEvt109527 .section-06 .vod .inner iframe {width:100%; height:100%;}

.mEvt109527 .pop-container {position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt109527 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt109527 .pop-container .pop-inner a {display:inline-block; width:100%; height:5rem;}
.mEvt109527 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt109527 .pop-container .popcontents {position:relative;}
.mEvt109527 .pop-container .link-show01 {position:absolute; left:0; top:43%; width:100%;}
.mEvt109527 .pop-container .link-show02 {position:absolute; left:0; top:52%; width:100%;}
</style>
<div class="mEvt109527">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_main.jpg" alt="">
        <div class="top-txt">
            <h2 class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_tit01.png" alt="행복을 기다리는 우리에게"></h2>
            <h2 class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_tit02.png" alt="디즈니x텐바이텐 with 나른"></h2>
        </div>
    </div>
    <div class="section-01">
        <div class="tit animate">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub_txt01.png" alt="텐바이텐 단독 디즈니 맨살트렁크"></h2>
        </div>
        <!-- 롤링 영역 -->
        <div class="slide-area">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide01_01.jpg" alt="slide01">
                    </div>
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide01_02.jpg" alt="slide02">
                    </div>
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide01_03.jpg?v=2" alt="slide03">
                    </div>
                </div>
                <!-- Add Pagination -->
                <div class="swiper-paginations01"></div>
            </div>
        </div>
    </div>
    <div class="section-02">
        <div class="tit animate">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub_txt02.png" alt="텐바이텐 단독 디즈니 맨살트렁크 pooh"></h2>
        </div>
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub01.jpg" alt="나른 pooh">
    </div>
    <div class="section-03">
        <div class="tit animate">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub_txt03.png" alt="텐바이텐 단독 디즈니 맨살트렁크 piglet"></h2>
        </div>
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub02.jpg" alt="나른 piglet">
    </div>
    <div class="section-04">
        <div class="tit animate">
            <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub_txt04.png" alt="텐바이텐 단독 디즈니 맨살트렁크 tigger"></h2>
        </div>
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub03.jpg" alt="나른 tigger">
    </div>
    <div class="section-05">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_tit02.jpg" alt="디즈니 맨살트렁크 with 나른 이렇게 달라요!">
        <!-- 롤링 영역 -->
        <div class="slide-area">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide02_01.png" alt="slide01">
                    </div>
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide02_02.png" alt="slide02">
                    </div>
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide02_03.png" alt="slide03">
                    </div>
                    <div class="swiper-slide">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_slide02_04.png" alt="slide03">
                    </div>
                </div>
                <!-- Add Pagination -->
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </div>
    <div class="section-06">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/img_sub04.jpg" alt="package">
        <div class="vod">
            <div class="inner">
                <iframe src="https://www.youtube.com/embed/cKOy53kKtdk?;playlist=cKOy53kKtdk&amp;loop=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
            </div>
        </div>
    </div>
    <!-- 팝업 - 선물보기 -->
    <% If currentDate >= #04/18/2021 18:00:00# and currentDate < #04/19/2021 00:00:00# Then %>
    <div class="pop-container">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109527/m/pop_live.jpg" alt="나른x디즈니 쇼핑라이브">
                <!-- 깜짝 선물 미리보기 -->
                <div class="link-show01">
                    <a href="https://shoppinglive.naver.com/livebridge/111439" target="_blank" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://shoppinglive.naver.com/livebridge/111439'); return false;" class="mApp"></a>
                </div>
                <!-- 바로 보러가기 -->
                <div class="link-show02">
                    <a href="https://view.shoppinglive.naver.com/lives/111439" target="_blank" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://view.shoppinglive.naver.com/lives/111439'); return false;" class="mApp"></a>
                </div>
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <% end if %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
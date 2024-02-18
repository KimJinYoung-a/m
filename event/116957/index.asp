<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description :
' History :
'####################################################
%>
<style>
.mEvt116957 .txt-hidden {font-size:0; text-indent:-9999px;}
.mEvt116957 .topic {position:relative; padding-bottom:2rem; background:#bfeef8; overflow:hidden;}
.mEvt116957 .topic h2 {position:absolute; left:50%; top:-1rem; width:78.53vw; margin-left:-39.26vw; opacity:0; transform: translateY(-1.5rem); transition:1s;}
.mEvt116957 .topic.on h2 {opacity:1; transform: translateY(0);}
.mEvt116957 .topic .tag {position:absolute; right:1rem; top:99vw; width:24.67vw; z-index:5; animation:updown linear 0.8s 1.1s infinite alternate;}
.mEvt116957 .tab-list {width:100%; display:flex; background:#fff; z-index:10;}
.mEvt116957 .tab-list div {position:relative; width:33.3%; text-align:center;}
.mEvt116957 .tab-list a {display:inline-block; width:100%; padding:1.16rem 0; font-size:1.28rem; color:#acacac; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt116957 .tab-list a.on,
.mEvt116957 .tab-list a.first_on {color:#e2508e; font-size:1.28rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116957 .tab-list .on::before,
.mEvt116957 .tab-list .first_on::before {content:""; width:100%; height:0.21rem; background:#e2508e; position:absolute; left:0; bottom:1px;}
.mEvt116957 .tab-list.fixed {position:fixed; left:0; top:0;}
.mEvt116957 .tab-list.fixed-top {position:fixed; left:0; top:40px;}
.mEvt116957 .tab-list.hides {display:none;}
.mEvt116957 .contents {position:relative;}
.mEvt116957 .contents .section {position:relative; margin-top:-1px;}
.mEvt116957 .benefit-area .btn-cupon {position:absolute; left:50%; bottom:16%; margin-left:-12.8rem; width:25.6rem; height:6.4rem; background:#f2428d; color:#fff; font-size:1.71rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; border-radius:3rem;}
.mEvt116957 .benefit-area .btn-cupon.disabled {color:#fff; background:#797979; cursor:auto; pointer-events:none;}
.mEvt116957 .benefit-area .btn-pick {position:absolute; left:50%; bottom:19%; margin-left:-50%; width:100%; height:10rem; background:transparent;}
.mEvt116957 .benefit-area .btn-pick.disabled {cursor:auto; pointer-events:none;}
.mEvt116957 .benefit-area .btn-point {position:absolute; left:1.9rem; top:29.9rem; width:13.40rem; height:4.9rem; font-size:1.49rem; color:#fff; background:#16aaef; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116957 .benefit-area .btn-point.wish {left:16.7rem; top:29.9rem;}
.mEvt116957 .benefit-area .btn-point.disabled {background:#797979; cursor:auto; pointer-events:none;} 
.mEvt116957 .benefit-area .link {display:inline-block;}
.mEvt116957 .benefit-area .pick .item01 {position:absolute; left:9%; top:29%; width:34.13vw; animation:updown linear 1s 1.1s infinite alternate;}
.mEvt116957 .benefit-area .pick .item02 {position:absolute; left:66%; top:36%; width:25.33vw; animation:updown linear 1s infinite alternate;}
.mEvt116957 .benefit-area .pick .item03 {position:absolute; left:15%; top:51%; width:17.73vw; animation:updown linear 1s 1.3s infinite alternate;}
.mEvt116957 .benefit-area .pick .item04 {position:absolute; left:59%; top:54%; width:22.66vw; animation:updown linear 1s 1.2s infinite alternate;}
.mEvt116957 .b-list {position:relative;}
.mEvt116957 .b-list ul {position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt116957 .b-list ul li {width:100%; height:12.37rem; margin-bottom:1.07rem;}
.mEvt116957 .b-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt116957 .b-list.b-hide {display:none;}
.mEvt116957 .event-area {position:relative;}
.mEvt116957 .event-area .link01 {width:100%; height:15rem; position:absolute; left:0; top:32%;}
.mEvt116957 .event-area .link02 {width:100%; height:15rem; position:absolute; left:0; top:66%;}
.mEvt116957 .event-area .link03 {width:100%; height:15rem; position:absolute; left:0; top:0%;}
.mEvt116957 .pop {display:none; position:fixed; left:0; top:6.52rem; width:100%; height:auto; padding:0 1.92rem; z-index:110;}
.mEvt116957 .pop .btn-close {width:3rem; height:3rem; position:absolute; right:3rem; top:1rem; background:transparent;}
.mEvt116957 .pop .link-best {width:100%; height:10rem; position:absolute; left:0; bottom:0;}
.mEvt116957 .dim {display:none; position:absolute; left:0; top:0; width:100vw; height:100vh; background-color: rgb(0, 0, 0, 0.502); z-index:109;}
.mEvt116957 .btn-pop {position:absolute; right:6%; top:38%; width:4rem; height:4rem; background:transparent;}
@keyframes updown {
    0% {transform: translateY(0rem);}
    100% {transform: translateY(1rem);}
}
</style>
<script>
$(function(){
    $('.mEvt116957 .topic').addClass('on');
    var doScroll;
    // 스크롤시에 사용자가 스크롤했다는 것을 알림
    $(window).scroll(function(event){
        doScroll = true;
    }); // hasScrolled()를 실행하고 doScroll 상태를 재설정
    setInterval(function() {
        if (doScroll)
        { hasScrolled(); doScroll = false; }
    }, 250);

    function hasScrolled() { // 동작을 구현
        var lastScrollTop = 0;
        var tabBenefitStart = $('.tab-start').offset().top - 53; // 동작의 구현이 시작되는 위치
        var tabBenefitEnd = $('.tab-end').offset().top; // 동작의 구현이 끝나는 위치
        var tabRemove = $('#tab01').offset().top;
        var tabRemoveFirst = $('#tab02').offset().top;
        var header = $('#header').height(); // 영향을 받을 요소를 선택

        // 접근하기 쉽게 현재 스크롤의 위치를 저장한다.
        var st = $(this).scrollTop();

        if (st > tabBenefitStart){
            $('.tab-list').addClass('fixed').css('top',header);

            let query_param = new URLSearchParams(window.location.search);
            if(query_param.get("gnbflag") == '1' && isApp){
              $('.tab-list').addClass('fixed-top');
            }

            $('.tab-list .tab1 a').removeClass('first_on');
        } else {
            $('.tab-list').removeClass('fixed');
            $('.tab-list .tab1 a').addClass('first_on');
        }

        if (st <= tabRemove) {
            $('.tab-list .tab1 a').addClass('first_on');
        }

        if (st >= tabRemoveFirst) {
            $('.tab-list .tab1 a').removeClass('first_on');
        }

        if(st > tabBenefitEnd){
            $('.tab-list').addClass('hides');
            $('.tab4 a').removeClass('on');
        }else {
            $('.tab-list').removeClass('hides');
            $('.tab4 a').removeClass('on');
        }

        //스크롤시 특정위치서 탭 활성화
        var scrollPos = $(document).scrollTop() + 46;
        $('.tab-list .link').each(function () {
            var currLink = $(this);
            var refElement = $(currLink.attr("href"));
            if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() >= scrollPos) {
                $('.tab-list .link').removeClass("on");

                currLink.addClass("on");
            }
            else{
                currLink.removeClass("on");
            }
        });

    }
    // 탭 클릭시 활성화
    $('.tab-list a').on('click',function(){
        if($(this).hasClass('on')) {
            $('.tab-list a').removeClass('on')
        } else {
            $('.tab-list a').removeClass('on')
            $(this).addClass('on')
        }
    });
    // 더 보기 버튼 클릭
    $('.btn-more').on('click',function(){
        $(this).hide().prev('.b-list').removeClass('b-hide');
    });
});
</script>
<script>
    let isUserLoginOK = false;
    <% IF IsUserLoginOK THEN %>
        isUserLoginOK = true;
    <% END IF %>
</script>
<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="/vue/vue_dev.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.js"></script>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.min.js"></script>

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<!--	<script src="/vue/components/common/wish.js?v=1.0"></script>-->
<!--	<script src="/vue/components/common/sortbar.js?v=1.0"></script>-->
<!--	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>-->
<!--	<script src="/vue/components/common/item_module_header.js?v=1.0"></script>-->
<!--	<script src="/vue/components/common/modal.js?v=1.0"></script>-->
<!--	<script src="/vue/components/common/no_data.js?v=1.0"></script>-->
<!--    <script src="/vue/components/common/btn_top.js?v=1.0"></script>-->
	<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
	<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<!-- //Common Component -->

<!--<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>-->
<!--<script type="text/javascript" src="/event/lib/countdown.js"></script>-->

<script src="/vue/event/etc/116957/index.js?v=1.23"></script>
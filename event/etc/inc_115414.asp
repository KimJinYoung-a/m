<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'############################################################
' Description : 2022 페이퍼즈
' History : 2021.11.18 정태훈
'############################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, sliderNem, testDate, sqlstr, mileageReqCNT, currentDate2

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "109421"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "115414"
    mktTest = True
Else
	eCode = "115414"
    mktTest = False
End If

eventStartDate  = cdate("2021-11-22")		'이벤트 시작일
eventEndDate 	= cdate("2021-12-19")		'이벤트 종료일
testDate = request("testDate")
if testDate="" then testDate="2021-11-22"
LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = CDate(testDate)
    currentDate2 = now()
else
    currentDate = date()
    currentDate2 = now()
end if

'반값상품 슬라이더 시작위치 지정
if currentDate2>=#11/22/2021 00:00:00# and currentDate2<#11/24/2021 00:00:00# then
    sliderNem=0
elseif currentDate2>=#11/24/2021 00:00:00# and currentDate2<#11/29/2021 00:00:00# then
    sliderNem=1
elseif currentDate2>=#11/29/2021 00:00:00# and currentDate2<#12/01/2021 00:00:00# then
    sliderNem=2
elseif currentDate2>=#12/01/2021 00:00:00# and currentDate2<#12/06/2021 00:00:00# then
    sliderNem=3
elseif currentDate2>=#12/06/2021 00:00:00# and currentDate2<#12/08/2021 00:00:00# then
    sliderNem=4
elseif currentDate2>=#12/08/2021 00:00:00# and currentDate2<#12/13/2021 00:00:00# then
    sliderNem=5
elseif currentDate2>=#12/13/2021 00:00:00# and currentDate2<#12/15/2021 00:00:00# then
    sliderNem=6
elseif currentDate2>=#12/15/2021 00:00:00# then
    sliderNem=7
end if

sqlstr = "select count(sub_opt1)"
sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " where evt_code="& eCode
sqlstr = sqlstr & " and sub_opt3='try'"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
    mileageReqCNT = rsget(0)
END IF
rsget.close
%>
<style>
.mEvt115414 .topic {position:relative;}
.mEvt115414 .topic .txt {position:absolute; left:50%; top:31rem; width:25.09rem; margin-left:-12.54rem; opacity:0; transform:translateY(20%); transition: all 1s;}
.mEvt115414 .topic .txt.on {transform:translateY(0%); opacity:1;}
.mEvt115414 .btn-float {position:fixed; left:1rem; top:9rem; width:9.98rem; height:8.49rem; z-index:20;}
.mEvt115414 .btn-float .btn-float-close {position:absolute; right:0; top:0; width:2rem; height:2rem; font-size:0; text-indent:-9999px; background:transparent;}
.mEvt115414 .milige-area {position:relative;}
.mEvt115414 .milige-area .point {position:absolute; left:0; top:6.4rem; width:100%; height:7.3rem; line-height:7.3rem; text-align:center; font-size:3.54rem; color:#13110f; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt115414 .btn-group {position:relative;}
.mEvt115414 .btn-group a {display:inline-block; font-size:0; text-indent:-9999px;}
.mEvt115414 .btn-group .btn-payback {width:100%; height:10rem; position:absolute; left:0; top:0;}
.mEvt115414 .btn-group .btn-category {width:100%; height:10rem; position:absolute; left:0; bottom:0;}
.mEvt115414 .noti-area button {position:relative}
.mEvt115414 .noti-area button .icon {display:inline-block; width:0.98rem; height:0.60rem; position:absolute; left:50%; top:1.8rem; margin-left:2.31rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115414/m/icon_arrow.png) no-repeat 0 0; background-size:100%;}
.mEvt115414 .noti-area button.on .icon {transform:rotate(180deg);}
.mEvt115414 .noti-area button + .info {display:none;}
.mEvt115414 .noti-area button.on + .info {display:block;}
.mEvt115414 .section-02 {padding-bottom:6.66rem; background:#ce91f8;}
.mEvt115414 .section-02 .slide-area {position:relative; padding:0 4.91rem; background:#ce91f8;}
.mEvt115414 .section-02 .slide-area .swiper-container {position:static;}
.mEvt115414 .section-02 .slide-area .swiper-button-prev {width:2.28rem; height:2.77rem; left:2rem; transform:translateY(-50%); text-align:left; z-index:5;}
.mEvt115414 .section-02 .slide-area .swiper-button-next {width:2.28rem; height:2.77rem; right:3.5rem; transform:translateY(-50%); text-align:right; z-index:5;}
.mEvt115414 .section-02 .slide-area .swiper-button-next img,
.mEvt115414 .section-02 .slide-area .swiper-button-prev img {width:1.28rem; height:2.77rem;}
.mEvt115414 .section-02 .swiper-slide {position:relative;}
.mEvt115414 .section-02 .swiper-slide.sold-out .bg-soldout {position:absolute; left:0; top:0; z-index:5;}
.mEvt115414 .section-02 .swiper-slide .insta {width:7.72rem; height:2.73rem; position:absolute; left:0.90rem; top:2.13rem; z-index:2;}
.mEvt115414 .section-03 .top {position:relative;}
.mEvt115414 .section-03 .top .slide-area {position:absolute; left:0; top:14.5rem; padding:0 1.92rem;}
.mEvt115414 .section-03 .item-list02 .top .slide-area {top:16rem;}
.mEvt115414 .section-03 .item-list03 .top .slide-area {top:16rem;}
.mEvt115414 .section-03 .top .swiper-slide {width:100%; height:28.66rem;}
.mEvt115414 .section-03 .top .swiper-container {position:static;}
.mEvt115414 .section-03 .bottom.item01 {background:#0f0d0b url(//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_item.jpg?v=3) repeat-y 0 0; background-size:100%;}
.mEvt115414 .section-03 .bottom.item02 {background:#0f0d0b url(//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_item02.jpg?v=3) repeat-y 0 0; background-size:100%;}
.mEvt115414 .section-03 .bottom.item03 {background:#0f0d0b url(//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_item03.jpg?v=3) repeat-y 0 0; background-size:100%;}
.mEvt115414 .prd-list {position:relative; padding:0 1.92rem 1.92rem; background:transparent; overflow:hidden;}
.mEvt115414 .prd-list ul {display:flex; justify-content:space-between; flex-wrap:wrap; width:100%; padding:0 1.3rem 8rem; background:#fff; border-radius:0 0 1rem 1rem; box-shadow: 15.657px 0px 87px 0px rgba(21, 21, 21, 0.57);}
.mEvt115414 .prd-list ul li {width:48%;}
.mEvt115414 .prd-list ul li:nth-child(1),
.mEvt115414 .prd-list ul li:nth-child(2) {padding-top:0;}
.mEvt115414 .prd-list ul li .thumbnail {height:38.34vw; overflow:hidden;}
.mEvt115414 .prd-list ul li .thumbnail img {width:100%;}
.mEvt115414 .prd-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt115414 .prd-list .desc {padding:1.65rem 0 1.34rem; }
.mEvt115414 .prd-list .price {font-size:1.54rem; letter-spacing: -0.025em; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt115414 .prd-list .price span {padding-left:0.3rem; font-size:1.19rem; color:#ff214f;}
.mEvt115414 .prd-list .price s {font-size:1.17rem; color:#716e5d;}
.mEvt115414 .prd-list .desc .name {padding-top:0.86rem; color:#141414; font-size:1.19rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; line-height:1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;}
.mEvt115414 .prd-list .desc .brand {padding-top:0.65rem; color:#999; font-size:1.11rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt115414 .prd-list .btn-more {position:absolute; left:50%; bottom:3rem; transform:translateX(-50%); display: flex;align-items: center;justify-content: center;width: calc(100% - 10.46rem);height: 4.1rem;margin: 0 auto;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';font-size: 1.37rem;text-align: center;color:#999;border-radius: 2.05rem; background:#f1f2f2;}
.mEvt115414 .prd-list .hide-item {display:none;}
.mEvt115414 .prd-list .hide-item.on {display:block;}



.mEvt115414 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(19, 17, 15,0.502); z-index:150;}
.mEvt115414 .pop-container .pop-contents {position:relative;}
.mEvt115414 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 0.73rem 4.17rem; overflow-y: scroll;}
.mEvt115414 .pop-container .pop-inner a {display:inline-block;}
.mEvt115414 .pop-container .pop-inner .btn-close {position:absolute; right:4.2rem; top:6.6rem; width:2rem; height:2rem; text-indent:-9999px; background:transparent;}

.mEvt115414 .swiper-pagination {position:absolute; left:50%; bottom:-2rem; transform:translate(-50%,0); z-index:10;}
.mEvt115414 .swiper-pagination-switch {display:inline-block; width:0.51rem; height:0.51rem; margin:0 0.3rem; border-radius:100%; background:#d5d5d5;}
.mEvt115414 .swiper-pagination-switch.swiper-active-switch {background:#0087eb;}

.mEvt115414 .section-05 {margin-top:13.33vw; background:#7dd1cd;}
.mEvt115414 .section-05 .slide-area .swiper-container {padding-bottom:4.13rem;}
.mEvt115414 .section-05 .swiper-slide {width:82.66vw;}
.mEvt115414 .section-05 .slide-area {padding-left:2.17rem;}

.mEvt115414 .item-list01 .slider {position:absolute; left:0; top:14.5rem; width:100%; padding:0 1.92rem;}
.mEvt115414 .item-list02 .slider {position:absolute; left:0; top:16rem; width:100%; padding:0 1.92rem;}
.mEvt115414 .item-list03 .slider {position:absolute; left:0; top:16rem; width:100%; padding:0 1.92rem;}
.mEvt115414 .slider .slick-dots li {width:0.51rem; height:0.51rem;}
.mEvt115414 .slider .slick-dots li button {width:0.51rem; height:0.51rem; margin:0 0.3rem; background:#d5d5d5; border-radius:100%;}
.mEvt115414 .slider .slick-dots li.slick-active button {background:#0087eb;}

/* slick css */
/* Slider */
.slick-slider
{
    position: relative;
    display: block;
    box-sizing: border-box;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    -webkit-touch-callout: none;
    -khtml-user-select: none;
    -ms-touch-action: pan-y;
    touch-action: pan-y;
    -webkit-tap-highlight-color: transparent;
}

.slick-list
{
    position: relative;
    display: block;
    overflow: hidden;
    margin: 0;
    padding: 0;
}
.slick-list:focus
{
    outline: none;
}
.slick-list.dragging
{
    cursor: pointer;
    cursor: hand;
}

.slick-slider .slick-track,
.slick-slider .slick-list
{
    -webkit-transform: translate3d(0, 0, 0);
    -moz-transform: translate3d(0, 0, 0);
    -ms-transform: translate3d(0, 0, 0);
    -o-transform: translate3d(0, 0, 0);
    transform: translate3d(0, 0, 0);
}

.slick-track
{
    position: relative;
    top: 0;
    left: 0;

    display: block;
    margin-left: auto;
    margin-right: auto;
}
.slick-track:before,
.slick-track:after
{
    display: table;
    content: '';
}
.slick-track:after
{
    clear: both;
}
.slick-loading .slick-track
{
    visibility: hidden;
}

.slick-slide
{
    display: none;
    float: left;
    height: 100%;
    min-height: 1px;
}
[dir='rtl'] .slick-slide
{
    float: right;
}
.slick-slide img
{
    display: block;
}
.slick-slide.slick-loading img
{
    display: none;
}
.slick-slide.dragging img
{
    pointer-events: none;
}
.slick-initialized .slick-slide
{
    display: block;
}
.slick-loading .slick-slide
{
    visibility: hidden;
}
.slick-vertical .slick-slide
{
    display: block;
    height: auto;
    border: 1px solid transparent;
}
.slick-arrow.slick-hidden {
    display: none;
}
/* Dots */
.slick-dotted.slick-slider
{
    margin-bottom: 30px;
}

.slick-dots
{
    position: absolute;
    left:0;
    bottom: -25px;
    display: block;
    width: 100%;
    padding: 0;
    margin: 0;
    list-style: none;
    text-align: center;
}
.slick-dots li
{
    position: relative;
    display: inline-block;
    width: 0.51rem;
    height: 0.51rem;
    margin: 0 0.3rem;
    padding: 0;
    cursor: pointer;
}
.slick-dots li button
{
    font-size: 0;
    line-height: 0;
    display: block;
    width: 0.51rem;
    height: 0.51rem;
    cursor: pointer;
    color: transparent;
    border: 0;
    outline: none;
    background: transparent;
}
.slick-dots li button:hover,
.slick-dots li button:focus
{
    outline: none;
}
.slick-dots li button:hover:before,
.slick-dots li button:focus:before
{
    opacity: 1;
}
.slick-dots li button:before
{
    font-family: 'slick';
    font-size: 6px;
    line-height: 0.51rem;
    position: absolute;
    top: 0;
    left: 0;
    width: 0.51rem;
    height: 0.51rem;
    content: '';
    text-align: center;
    opacity: .25;
    color: black;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
.slick-dots li.slick-active button:before
{
    opacity: .75;
    color: black;
}
/* Arrows */
.slick-prev,
.slick-next
{
    font-size: 0;
    line-height: 0;
    position: absolute;
    top: 50%;
    display: block;
    width: 20px;
    height: 20px;
    padding: 0;
    -webkit-transform: translate(0, -50%);
    -ms-transform: translate(0, -50%);
    transform: translate(0, -50%);
    cursor: pointer;
    color: transparent;
    border: none;
    outline: none;
    background: transparent;
}
.slick-prev:hover,
.slick-prev:focus,
.slick-next:hover,
.slick-next:focus
{
    color: transparent;
    outline: none;
    background: transparent;
}
.slick-prev:hover:before,
.slick-prev:focus:before,
.slick-next:hover:before,
.slick-next:focus:before
{
    opacity: 1;
}
.slick-prev.slick-disabled:before,
.slick-next.slick-disabled:before
{
    opacity: .25;
}

.slick-prev:before,
.slick-next:before
{
    font-family: 'slick';
    font-size: 20px;
    line-height: 1;
    opacity: .75;
    color: white;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.slick-prev
{
    left: 0;
}
[dir='rtl'] .slick-prev
{
    right: 0;
    left: auto;
}
.slick-prev:before
{
    content: '←';
}
[dir='rtl'] .slick-prev:before
{
    content: '→';
}

.slick-next
{
    right:0;
}
[dir='rtl'] .slick-next
{
    right: auto;
    left:0;
}
.slick-next:before
{
    content: '→';
}
[dir='rtl'] .slick-next:before
{
    content: '←';
}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_115414.js?v=1.06"></script>
<script>
$(function() {
    $('.mEvt115414 .topic .txt').addClass('on');
    $('.noti-area button').on('click',function(){
        $(this).toggleClass('on');
    });
    var mySwiper = new Swiper(".section-02 .swiper-container", {
        speed: 1500,
        initialSlide: <%=sliderNem%>,
        nextButton:'.swiper-button-next',
        prevButton:'.swiper-button-prev',
    });
    /* slick slider */
    $('.item-list01 .slider').slick({
        slidesToShow:1,
        slidesToScroll:1,
        autoplay: true,
        autoplaySpeed: 1700,
        speed:800,
        dots: true,
        variableWidth:false,
        pauseOnFocus: false,
        pauseOnHover:false,
        arrows:false
    });
    $('.item-list02 .slider').slick({
        slidesToShow:1,
        slidesToScroll:1,
        autoplay: true,
        autoplaySpeed: 1700,
        speed:800,
        dots: true,
        variableWidth:false,
        pauseOnFocus: false,
        pauseOnHover:false,
        arrows:false
    });
    $('.item-list03 .slider').slick({
        slidesToShow:1,
        slidesToScroll:1,
        autoplay: true,
        autoplaySpeed: 1700,
        speed:800,
        dots: true,
        variableWidth:false,
        pauseOnFocus: false,
        pauseOnHover:false,
        arrows:false
    });
    /* 상품 더보기 버튼 */
    $('.prd-list .btn-more').on('click',function(){
        $(this).parent().find('ul').children('.hide-item').addClass('on');
        $(this).hide();
        $(this).parent().find('ul').css('padding-bottom','1rem');
    });
    /* float 버튼 닫기 */
    $('.btn-float-close').on('click',function(){
        $('.btn-float').css('width','0');
    });
    /* float 버튼 컨텐츠하단 도달시 숨기기 */
    var didScroll; 
    $(window).scroll(function(event){ 
        didScroll = true; 
    });
    setInterval(function() { 
        if (didScroll) 
        { hasScrolled(); didScroll = false; }
    }, 250);
    
    function hasScrolled() {
        var lastScrollTop = 0; 
        var lastSection = $('.section-03').offset().top + $('.section-03').outerHeight() -200; // 동작의 구현이 끝나는 위치
        var st = $(this).scrollTop();

        if (st > lastSection){
            $('.btn-float').hide();
        } else {
            $('.btn-float').show();
        }
    }
    /* 팝업 */
    $('.mEvt115414 .btn-pop').click(function(){
        $('.pop-container').fadeIn();
    })
    /* 팝업 닫기 */
    $('.mEvt115414 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })

    codeGrp = [4091999,4108484,4125694,4159944,4185276,3951839,3951838,4176250,4111673,4188377];
    var $rootEl = $("#itemlist01")
    var itemEle = tmpEl = ""
    var ix1 = 1;
    $rootEl.empty();

    codeGrp.forEach(function(item){
        if(ix1>6){
            tmpEl = '<li class="hide-item">\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="thumbnail"><img src="" alt=""></div>\
                            <div class="desc">\
                                <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                                <p class="name">상품명상품명상품명상품명상품명상품명</p>\
                                <p class="brand">brand name</p>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }else{
            tmpEl = '<li>\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="thumbnail"><img src="" alt=""></div>\
                            <div class="desc">\
                                <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                                <p class="name">상품명상품명상품명상품명상품명상품명</p>\
                                <p class="brand">brand name</p>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }
        itemEle += tmpEl;
        ++ix1;
    });
    
    $rootEl.append(itemEle)

    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemlist01",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp2 = [4138489,4135133,4188376,4204691,4186243,4087801,4184828,4150750,4166706,4140460];
    var $rootEl2 = $("#itemlist02")
    var itemEle2 = tmpEl2 = ""
    var ix2 = 1;
    $rootEl2.empty();

    codeGrp2.forEach(function(item){
        if(ix2>6){
            tmpEl2 = '<li class="hide-item">\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="prd-wrap">\
                                <div class="thumbnail"><img src="" alt=""></div>\
                                <div class="info">\
                                    <div class="desc">\
                                        <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                        <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                        <p class="brand">brand name</p>\
                                    </div>\
                                </div>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }else{
            tmpEl2 = '<li>\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="prd-wrap">\
                                <div class="thumbnail"><img src="" alt=""></div>\
                                <div class="info">\
                                    <div class="desc">\
                                        <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                        <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                        <p class="brand">brand name</p>\
                                    </div>\
                                </div>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }
        itemEle2 += tmpEl2;
        ++ix2;
    });
    
    $rootEl2.append(itemEle2)

    fnApplyItemInfoList2({
        items:codeGrp2,
        target:"itemlist02",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp3 = [4188384,4175973,4146408,4166784,4166506,4188614,4091998,4188379,4169534,4177391];
    var $rootEl3 = $("#itemlist03")
    var itemEle3 = tmpEl3 = ""
    var ix3 = 1;
    $rootEl3.empty();

    codeGrp3.forEach(function(item){
        if(ix3>6){
            tmpEl3 = '<li class="hide-item">\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="prd-wrap">\
                                <div class="thumbnail"><img src="" alt=""></div>\
                                <div class="info">\
                                    <div class="desc">\
                                        <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                        <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                        <p class="brand">brand name</p>\
                                    </div>\
                                </div>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }else{
            tmpEl3 = '<li>\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="prd-wrap">\
                                <div class="thumbnail"><img src="" alt=""></div>\
                                <div class="info">\
                                    <div class="desc">\
                                        <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                        <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                        <p class="brand">brand name</p>\
                                    </div>\
                                </div>\
                            </div>\
                        </a>\
                    </li>\
                    '
        }
        itemEle3 += tmpEl3;
        ++ix3;
    });
    
    $rootEl3.append(itemEle3)

    fnApplyItemInfoList3({
        items:codeGrp3,
        target:"itemlist03",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });
});

function goProduct(itemid) {
	<% if isApp then %>
		fnAPPpopupProduct(itemid);
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript115414.asp",
            data: {
                mode: 'add'
                <% if mktTest then %>,testDate: '<%=testDate%>'<% end if %>                
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>');
                    $("#mpoint").empty().html(data.mpoint);
                    alert(data.message);
                }else if(data.response == "err"){
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% end if %>
}

function fnSearchPapers(){
    fnAmplitudeEventMultiPropertiesAction('click_event_papers','evtcode','<%=eCode%>');
    setTimeout(function(){
        <% if isApp="1" then %>
            fnSearchEventText('2022페이퍼즈');
        <% else %>
            parent.location.href='/search/search_product2020.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&keyword=2022페이퍼즈';
        <% end if %>
    },1500);
    
}
</script>
			<div class="mEvt115414">
				<div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_main.jpg" alt="종이로 전하는 감성샵">
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/txt_papers.png?v=2" alt="2022 papers"></div>
                    <div class="btn-float" style="display:none">
                        <a href="" onclick="fnSearchPapers();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_float.png" alt="2022 페이퍼즈 상품 보러가기"></a>
                        <button type="button" class="btn-float-close">닫기</button>
                    </div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_sub01.jpg?v=2" alt="총 5,000만 포인트 페이백">
                    <% if mileageReqCNT>=10000 then %>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_soldout.jpg?v=2" alt="마일리지가 소진되었습니다."></div>
                    <% else %>
                    <div class="milige-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_point.jpg?v=2" alt="남은 마일리지">
                        <p class="point" id="mpoint"><%=FormatNumber(50000000-mileageReqCNT*5000,0)%>p</>
                    </div>
                    <% end if %>
                    <div class="btn-group">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/btn_group.jpg?v=2" alt="페이백 신청하기 / 디자인문구 카테고리 바로가기">
                        <a href="" onclick="doAction();return false;" class="btn-payback">페이백 신청하기</a>
                        <a href="/category/category_main2020.asp?disp=101" class="mWeb btn-category">디자인문구 카테고리 바로가기</a>
                        <a href="#" onclick="fnAPPpopupCategory('101','','','디자인문구','','');return false;" class="mApp btn-category">디자인문구 카테고리 바로가기</a>
                    </div>
                    <div class="noti-area">
                        <button type="button"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/btn_noti01.jpg" alt="유의사항"><span class="icon"></span></button>
                        <div class="info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_noti01.jpg" alt="유의사항 내용"></div>
                    </div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_sub02.jpg" alt="매주 월,수 10시 반값혜택">
                    <!-- slide -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                
                                <div class="swiper-slide<% If getitemlimitcnt(4214718) < 1 Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4214718);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide01.png" alt="11/22">
                                        <% If getitemlimitcnt(4214718) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png?v=3" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4215322) < 1 or (currentDate2 < #11/24/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4215322);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide02.png" alt="11/24">
                                        <% If currentDate2 < #11/24/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4215322) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4214774) < 1 or (currentDate2 < #11/29/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4214774);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide03.png" alt="11/29">
                                        <% If currentDate2 < #11/29/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4214774) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4218291) < 1 or (currentDate2 < #12/01/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4218291);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide04.png" alt="12/01">
                                        <% If currentDate2 < #12/01/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4218291) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4214755) < 1 or (currentDate2 < #12/06/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4214755);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide05.png" alt="12/06">
                                        <% If currentDate2 < #12/06/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4214755) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4214726) < 1 or (currentDate2 < #12/08/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4214726);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide06.png" alt="12/08">
                                        <% If currentDate2 < #12/08/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4214726) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4215005) < 1 or (currentDate2 < #12/13/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4215005);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide07.png" alt="12/13">
                                        <% If currentDate2 < #12/13/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4215005) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                                <div class="swiper-slide<% If getitemlimitcnt(4214861) < 1 or (currentDate2 < #12/15/2021 10:00:00#) Then %> sold-out<% end if %>">
                                    <a href="" onclick="goProduct(4214861);return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_main_slide08.png" alt="12/15">
                                        <% If currentDate2 < #12/15/2021 10:00:00# Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soon.png" alt="comming soon" class="bg-soldout">
                                        <% elseIf getitemlimitcnt(4214861) < 1 Then %>
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/bg_soldout.png" alt="sold out" class="bg-soldout">
                                        <% end if %>
                                        <div class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_insta.png" alt="인스타그램"></div>
                                    </a>
                                </div>
                            </div>
                            <div class="swiper-button-prev"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/icon_left_arrow.png" alt="left"></div>
                            <div class="swiper-button-next"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/icon_right_arrow.png" alt="right"></div>
						</div>
                    </div>
                    <button type="button" class="btn-pop"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/btn_all.jpg" alt="전체일정 보기"></button>
                    <div class="noti-area">
                        <button type="button"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/btn_noti02.jpg" alt="유의사항"><span class="icon"></span></button>
                        <div class="info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_noti02.jpg" alt="유의사항 내용"></div>
                    </div>
                </div>
                <div class="section-03">
                    <div class="item-list01">
                        <div class="top">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_top01.jpg" alt="사진 찍게 만드는 다이어리">
                            <!-- slide -->
                            <div class="slider">
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide01_01.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide01_02.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide01_03.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide01_04.png" alt=""></div>
                            </div>
                        </div>
                        <div class="bottom item01">
                            <!-- 상품 리스트 -->
                            <div class="prd-list">
                                <ul class="itemList itemlist01" id="itemlist01"></ul>
                                <button type="button" class="btn-more">더보기</button>
                            </div>
                        </div>
                    </div>
                    <div class="item-list02">
                        <div class="top">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_top02.jpg" alt="매달 바꿀 수 있는 인테리어">
                            <!-- slide -->
                            <div class="slider">
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide02_01.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide02_02.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide02_03.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide02_04.png" alt=""></div>
                            </div>
                        </div>
                        <div class="bottom item02">
                            <!-- 상품 리스트 -->
                            <div class="prd-list">
                                <ul class="itemList itemlist02" id="itemlist02"></ul>
                                <button type="button" class="btn-more">더보기</button>
                            </div>
                        </div>
                    </div>
                    <div class="item-list03">
                        <div class="top">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/img_top03.jpg" alt="데스크에 감성 더하기">
                            <!-- slide -->
                            <div class="slider">
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide03_01.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide03_02.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide03_03.png" alt=""></div>
                                <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/img_slide03_04.png" alt=""></div>
                            </div>
                        </div>
                        <div class="bottom item03">
                            <!-- 상품 리스트 -->
                            <div class="prd-list">
                                <ul class="itemList itemlist03" id="itemlist03"></ul>
                                <button type="button" class="btn-more">더보기</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 검색어 이동 -->
                <a href="" onclick="fnSearchPapers();return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/btn-papers.jpg" alt="2022 papers 상품 더 보러가기">
                </a>
                <!-- 팝업 -->
                <div class="pop-container">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/115414/m/popup.png" alt="8가지 상품">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
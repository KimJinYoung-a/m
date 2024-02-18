<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 타임세일 페이지
' History : 2021-06-09 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<style type="text/css">
    .time-ing .top button {background-color:transparent;}
    .time-ing .top {position:relative;}
    .time-ing .top .sale-timer {position:absolute; bottom:19%; left:7%; color:#fff; font-size:5.21rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .time-ing .top .btn-push {display:inline-block; position:fixed; top:116vw; right:0; z-index:10; width:25.3%;}
    .time-ing .top .tit-ready {position:absolute; left:7%; bottom:35.5%; color:#fff; font-size:1.52rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

    .show-time-current {position:absolute; right:-10%; top:40%;}
    .show-time-current .time-current-wrap {display:flex;}
    .show-time-current .time-current-wrap div {margin:0 0.56rem;}
    .show-time-current .time-current-wrap img {width:14.13vw; height:13.86vw;}

    .list-wrap {background:#fafafa;}
    .list-wrap .special-item {position:relative; height:43.48rem; background:#fff;}
    .list-wrap .special-item .list {position:absolute; right:0; top:-6%; width:calc(100% - 2.65rem); border-bottom:1px solid #6d6d6d;}/* 2021.06.17 손지수 수정 */
    .list-wrap .special-item a {display:inline-block; position:relative;}
    .list-wrap .special-item .thum {width:30rem; height:25.22rem;}
    .list-wrap .special-item .list li.sold-out {position:relative;}
    .list-wrap .special-item .list li.sold-out:after,
    .list-wrap .special-item .list li.sold-out:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:calc(100% + 1.1vw); content:'';}
    .list-wrap .special-item .list li.sold-out:before {width:9.4rem; height:9.4rem; top:8rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}
    .list-wrap .special-item .list li.sold-out .product-inner .thum {position:relative; width:30rem; height:25.22rem;}
    .list-wrap .special-item .list li.sold-out .product-inner .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; background-color:rgb(243, 243, 243); opacity:0.6;}

    .list-wrap .special-item .list li.not-open {position:relative;}
    .list-wrap .special-item .list li.not-open:after,
    .list-wrap .special-item .list li.not-open:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:calc(100% + 1.1vw); content:'';}
    .list-wrap .special-item .list li.not-open:before {width:9.4rem; height:9.4rem; top:8rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111787/m/txt_not_open.png)no-repeat 50% 50% / 100% 100%;}
    .list-wrap .special-item .list li.not-open .product-inner .thum {position:relative; width:30rem; height:25.22rem;}
    .list-wrap .special-item .list li.not-open .product-inner .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; background-color:rgb(243, 243, 243); opacity:0.6;}

    .list-wrap .special-item .desc {width:20rem; height:11rem; margin-top:1.73rem;}/* 2021.06.17 손지수 수정 */
    /* 2021-04-01 수정 */
    .list-wrap .special-item .desc .name {display:-webkit-box; width:100%; padding-right:0.5rem; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow:ellipsis; -webkit-line-clamp:2; word-break:break-all;}/* 2021.06.17 손지수 수정 */
    .list-wrap .special-item .desc .price {margin-top:1rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;line-height:1.8rem;}/* 2021.06.17 손지수 수정 */
    .list-wrap .special-item .desc .price s{display:block;}
    .list-wrap .special-item .desc .buy_now{position:absolute;top:1rem;left:21rem;width:20.5vw;}/* 2021.06.17 손지수 수정 */
    /* // */
    .list-wrap .special-item .desc .price s {top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
    .list-wrap .special-item .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}
    .list-wrap .special-item .desc .price .p-won {margin-left:0.69rem; font-size:1.30rem; color:#111; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
    .list-wrap .special-item .product-inner {position:relative;}
    .list-wrap .special-item .product-inner .num-limite {position:absolute; top:-3%; right:2%; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
    .list-wrap .special-item .product-inner .num-limite em {font-size:1.65rem;}
    .list-wrap .special-item .txt-noti {position:absolute; left:0.7rem; top:39.5rem; font-size:1rem; color:#9c9c9c; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

    .list-wrap #itemList {display:flex; flex-direction:column; align-items:flex-end; width:calc(100% - 2.60rem); margin-left:2.60rem;padding:5rem 0;}
    .list-wrap #itemList li {width:calc(100% - 2rem);}
    .list-wrap .desc {position:relative; height:7.5rem; margin-top:2.45rem; margin-bottom:3.33rem;} /* 03-26 수정 */
    .list-wrap .thumbnail {position:relative; width:100%; height:85.625vw; }
    .list-wrap .thumbnail .num-limite{display:inline-block; position:absolute; bottom:-15px; left:0; z-index:11; width:115px; height:38px; line-height:38px; font-size:20px; color:#fff; text-align:center; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111787/img_limit_num.png?v=4) no-repeat 50% 50%/100%;}
    .list-wrap .thumbnail .num-limite em {font-size:20px;}
    /* md상품 영역 수정 */
    /* 1줄일 때 */
    .list-wrap .desc.line_01 .name {font-size: 1.8rem; line-height: 1.8; color: #111; font-family: 'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3.2rem;}/* 03-26 수정 */
    .list-wrap .desc.line_01 .price {position:absolute; left:0; top:4.5rem; margin-top:.8rem; font-size:1.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';} /* 03-26 수정 */
    .list-wrap .desc.line_01 .price s {position:absolute; left:0; top:-1rem; font-size:1.17rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
    .list-wrap .desc.line_01 .price span {display:inline-block; margin-left:1.1rem; font-size:2.17rem; color:#ff0943;}
    /* 2줄일 때 */
    .list-wrap .desc.line_02 .name {font-size: 1.8rem; line-height: 1.2; color: #111; font-family: 'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3.2rem;}/* 03-26 수정 */
    .list-wrap .desc.line_02 .price {position:absolute; left:0; top:5.5rem; margin-top:.8rem; font-size:1.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';} /* 03-26 수정 */
    .list-wrap .desc.line_02 .price s {position:absolute; left:0; top:-1rem; font-size:1.17rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
    .list-wrap .desc.line_02 .price span {display:inline-block; margin-left:1.1rem; font-size:2.17rem; color:#ff0943;}
    /* // md상품 영역 수정 */

    .ready_list_wrap {background:#fff;}
    .product-list {padding-bottom:10rem;}
    /* 잠시 후 오픈 이미지->텍스트 수정 2021.06.09 손지수 */
    .product-list .open-time{position:relative;margin-left:2.60rem;margin-top:3.6rem;margin-bottom:1.2rem;text-align:left;font-size:2.2rem;color:#000;letter-spacing:-0.15rem;padding-left:0.8rem;padding-top:1.1rem;line-height:2.2rem;z-index:0;}
    .product-list .open-time::after{position:absolute;top:0;left:0;content:'';width:2.5rem;height:2.5rem;border-radius:50%;background-color:#a8ff00;z-index:-1;}
    .product-list .open-time span{font-weight:bold;font-size:2.4rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    /* // 잠시 후 오픈 이미지->텍스트 수정 2021.06.09 손지수 */
    .product-list .product-inner {position:relative; margin-left:2.60rem;}
    .product-list .product-inner .num-limite {position:absolute; bottom:-3%; right:0; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
    .product-list .product-inner .num-limite em {font-size:1.65rem;}
    .product-list .desc .name {position:absolute; left:1.73rem; top:19.5rem; width:90%; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
    .product-list .desc .price {position:absolute; left:1.73rem; top:24rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
    .product-list .desc .price s {position:absolute; left:0; top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
    .product-list .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}

    .teaser-timer {position:relative;}
    .teaser-timer .sale-timer {position:absolute; bottom:49%; left:7%; color:#fff; font-size:4.78rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .teaser-timer .btn-push {width:21.74rem; height:6.08rem; position:absolute; left:5%; bottom:13%; background:transparent;}

    /* 쿠폰영역 생성 */
    .coupon-area{position:relative;}
    .coupon-area a.go-coupon{width:100%;height:14rem;display:block;position:absolute;bottom:0;}
    /* // 쿠폰영역 생성 */

    .sold-out-list {padding-bottom:3rem;}
    .sold-out-list .slide-area {margin-left:2.60rem;}
    .sold-out-list .sold-prd {display:flex; width:11.74rem;}
    .sold-out-list .sold-prd .thum {position:relative; width:11.74rem;}
    .sold-out-list .sold-prd .tit-prd {width:inherit;}
    .sold-out-list .desc {position:relative; padding-bottom:4rem; margin:0.5rem 0 0 0.5rem;}
    .sold-out-list .desc .name {overflow:hidden; font-size:1.13rem; line-height:1.2; color:#797979; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
    .sold-out-list .desc .price {display:flex; align-items:baseline; position:absolute; left:0; top:2.5rem; display:flex; margin-top:.8rem; font-size:1.34rem; color:#6a6a6a; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; opacity:0;}
    .sold-out-list .desc .price s {position:absolute; left:0; top:-1.3rem; font-size:0.95rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
    .sold-out-list .desc .price span {display:inline-block; margin-left:0.47rem; color:#000; font-size:1.30rem;}
    .sold-out-list .desc .price .p-won {margin-left:1px; font-size:1.3rem; color:#6a6a6a; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
    .sold-out-list .sold-prd.sold-out .price {opacity:1;}
    .sold-out-list .sold-prd.sold-out .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:11.74rem; height:12.35rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_dim_sold.png) no-repeat 0 0; background-size:100%;}
    /* 2021.06.15 손지수 수정 */
    .sold-out-list li .sold-time{display:none;}
    .sold-out-list li.sold-out .sold-time{display:block;position:absolute; left:6%; top:53.5%; display:inline-block; font-size:1.08rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';}
    /* // 2021.06.15 손지수 수정 */
    /*.sold-out-list li.sold-out .thum:after {position:absolute; left:6%; top:75%; display:inline-block; font-size:1.08rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';}
    .sold-out-list li:nth-child(1).sold-out .thum:after {content:"오전 9시"; }
    .sold-out-list li:nth-child(2).sold-out .thum:after {content:"오후 12시"; left:4%;}
    .sold-out-list li:nth-child(3).sold-out .thum:after {content:"오후 3시"; left:4%;}
    .sold-out-list li:nth-child(4).sold-out .thum:after {content:"오후 6시"; left:4%;}*/

    .noti-area .btn-noti {position:relative;}
    .noti-area .btn-noti.on span img {transform:rotate(180deg);}
    .noti-area .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform:translate(590%,0);}
    .noti-area .noti-info {display:none;}
    .noti-area .noti-info.on {display:block;}

    .lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
    .lyr .inner {padding-top:6rem;}
    .lyr .btn-close {position:absolute; top:6.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
    .lyr-alarm p {padding-top:7.98rem;}
    .lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem;}
    .lyr-alarm .input-box input {width:100%; height:3rem; padding:0; background-color:transparent; border:0; border-bottom:solid 3px #acfe25; border-radius:0; color:#fff; font-size:1.56rem; text-align:left;}
    .lyr-alarm .input-box .btn-submit {width:4.69rem; height:3rem; margin-left:-1px; color:#acfe25; border-bottom:solid 3px #acfe25; font-size:1.47rem; background:transparent;}
    .lyr-alarm .input-box input::placeholder {font-size:1.47rem; color:#b7b7b7; text-align:left;}
</style>
<style>[v-cloak] { display: none; }</style>
<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const isUserLoginOK = "<%= IsUserLoginOK %>";
    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const rd_sitename = "<%= session("rd_sitename") %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";

    $(document).ready(function(){
        setTimeout(setSwiper, 2000);
    });

    function setSwiper(){
        // 슬라이더
        let swiper = new Swiper(".sold-out-list .swiper-container", {
            speed: 500,
            slidesPerView:"auto",
            spaceBetween:20,
            loop:false
        });
    }

    function goProduct(itemid) {
    	<% if isApp then %>
    		parent.location.href = 'javascript:fnAPPpopupProduct('+itemid+')';
    	<% else %>
    		parent.location.href = '/category/category_itemprd.asp?itemid='+itemid;
    	<% end if %>
    	return false;
    }
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<!-- Common Components -->
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
<script src="/vue/components/common/modal2.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<!-- //Common Components -->

<script type="text/javascript" src="/event/lib/countdown24.js?v=1.0"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_110063.js"></script>

<!-- Core -->
<script src="/vue/event/timesale/store.js?v=1.00"></script>
<script src="/vue/event/timesale/index.js?v=1.03"></script>
<!-- //Core -->
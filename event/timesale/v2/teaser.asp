<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 타임세일 티저 페이지
' History : 2021-06-09 김형태 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<style type="text/css">
    .teaser-main {position:relative;}
    .teaser-main .btn-more {display:block; width:100%; background-color:rgba(0,0,10,0.5);}
    .teaser-main .list-wrap a {position:relative; display:inline-block; width:100%; height:100%;}
    .teaser-main .txt01 {position:absolute; left:7%; top:11%; width:42.53vw; z-index:10;}
    .teaser-main .txt02 {position:absolute; left:32%; top:45.5%; width:44.26vw; z-index:10;}
    .teaser-main .show-days {position:absolute; left:6%; top:45.2%; font-size:11.60vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .teaser-main .show-days span {font-size:10vw;}
    .teaser-main .item-area {position:absolute; right:9%; top:15%; opacity:0.8;}
    .teaser-main .item-area .thumb .item1,
    .teaser-main .item-area .thumb .item2,
    .teaser-main .item-area .thumb .item3,
    .teaser-main .item-area .thumb .item4 {width:17.33vw; transition: .5s ease-in;}

    .teaser-timer {position:relative;}
    .teaser-timer .sale-timer {position:absolute; bottom:49%; left:7%; color:#fff; font-size:4.78rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .teaser-timer .btn-push {width:21.74rem; height:6.08rem; position:absolute; left:3%; bottom:9%; background:transparent;}

    .list-wrap {width:32rem; margin:0 auto;}
    .list-wrap .special-item a {display:inline-block; position:relative;}
    .list-wrap .special-item a:before,
    .teaser .list-wrap a:before {display:inline-block; position:absolute; top:-1.1vw; left:0; z-index:10; width:26%; height:9.84vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104371/m/badge_spc.png) no-repeat 50% 50%/100%; content:'';}

    .lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
    .lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
    .lyr-alarm p {padding-top:7.98rem;}
    .lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem;}
    .lyr-alarm .input-box input {width:100%; height:3rem; padding:0; background-color:transparent; border:0; border-bottom:solid 3px #acfe25; border-radius:0; color:#fff; font-size:1.56rem; text-align:left;}
    .lyr-alarm .input-box .btn-submit {width:4.69rem; height:3rem; margin-left:-1px; color:#acfe25; border-bottom:solid 3px #acfe25; font-size:1.47rem; background:transparent;}
    .lyr-alarm .input-box input::placeholder {font-size:1.47rem; color:#b7b7b7; text-align:left;}

    .product-list {background:#fff;}
    .product-list .product-inner {position:relative; margin-left:2.60rem;}
    .product-list .product-inner .num-limite {position:absolute; top:-3%; right:0; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
    .product-list .product-inner .num-limite em {font-size:1.65rem;}
    .product-list .desc .name {position:absolute; left:1.73rem; top:19.5rem; width:90%; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
    .product-list .desc .price {display:flex; align-items:baseline; position:absolute; left:1.73rem; top:24rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
    .product-list .desc .price s {position:absolute; left:0; top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
    .product-list .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}
    .product-list .desc .price .p-won {margin-left:0.60rem; font-size:1.30rem; font-weight:500; color:#111; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

    .noti-area{padding-top:15%;background:#fff;}
    .noti-area .btn-noti {position:relative;}
    .noti-area .btn-noti.on span img {transform:rotate(180deg);}
    .noti-area .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform:translate(590%,0);}
    .noti-area .noti-info {display:none;}
    .noti-area .noti-info.on {display:block;}

    /* 잠시 후 오픈 이미지->텍스트 수정 2021.06.09 손지수 */
    .product-list .open-time{position:relative;width:466px;height:52px;text-align:left;font-size:34px;color:#000;letter-spacing:-0.15rem;padding-left:15px;padding-top:18px;line-height:38px;z-index:0;}
    .product-list .open-time::after{position:absolute;top:0;left:0;content:'';width:45px;height:45px;border-radius:50%;background-color:#a8ff00;z-index:-1;}
    .product-list .open-time span{font-weight:bold;font-size:38px}
    /* // 잠시 후 오픈 이미지->텍스트 수정 2021.06.09 손지수 */
</style>
<style>[v-cloak] { display: none; }</style>
<div id="app"></div>

<script>
    const server_info = "<%= application("Svr_Info") %>";
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

<!-- Core -->
<script src="/vue/event/timesale/teaser/store.js?v=1.00"></script>
<script src="/vue/event/timesale/teaser/index.js?v=1.01"></script>
<!-- //Core -->
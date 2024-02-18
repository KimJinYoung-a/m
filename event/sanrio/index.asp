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

<style>
.mEvt113056 .hidden {font-size:0; text-indent:-9999px;}
.mEvt113056 .topic {position:relative;}
.mEvt113056 .topic p {width:76.40vw; position:absolute; left:50%; top:83%; margin-left:-38vw;}
.mEvt113056 .topic .cut01.check {width:74.53vw; position:absolute; left:7%; top:17%; transform: translateY(0); opacity:1;}
.mEvt113056 .topic .cut02.check {width:84vw; position:absolute; left:9%; top:33%; transform: translateY(0); opacity:1;}
.mEvt113056 .topic .cut03.check {width:85.07vw; position:absolute; left:9%; top:49%; transform: translateY(0); opacity:1;}
.mEvt113056 .topic .cut01 {width:74.53vw; position:absolute; left:7%; top:17%; opacity:0; transition:1s; transform: translateY(-1rem);}
.mEvt113056 .topic .cut02 {width:84vw; position:absolute; left:9%; top:33%; opacity:0; transition:1s .5s; transform: translateY(-1rem);}
.mEvt113056 .topic .cut03 {width:85.07vw; position:absolute; left:9%; top:49%; opacity:0; transition:1s 1s; transform: translateY(-1rem);}
.mEvt113056 .check-area {position:relative;}
.mEvt113056 .check-area button {position:relative;}
.mEvt113056 .check-area button.on::before {content:""; display:blcok; width:4.13vw; height:4.13vw; position:absolute; left:50%; top:4%; transform:translate(-42%,0); background:url(//webimage.10x10.co.kr/fixevent/event/2021/113056/m/icon_arrow.png) no-repeat 0 0; background-size: 4.13vw;}
.mEvt113056 .check-area .btn-ch01 {width:28vw; height:38.67vw; position:absolute; left:6%; top:0; background:transparent;}
.mEvt113056 .check-area .btn-ch02 {width:28vw; height:38.67vw; position:absolute; left:36%; top:0; background:transparent;}
.mEvt113056 .check-area .btn-ch03 {width:28vw; height:38.67vw; position:absolute; left:66%; top:0; background:transparent;}
.mEvt113056 .check-area .btn-ch04 {width:28vw; height:38.67vw; position:absolute; left:20%; top:32%; background:transparent;}
.mEvt113056 .check-area .btn-ch04.on::before {top:0%; transform:translate(-48%,0);}
.mEvt113056 .check-area .btn-ch05 {width:28vw; height:38.67vw; position:absolute; left:50%; top:32%; background:transparent;}
.mEvt113056 .check-area .btn-ch05.on::before {top:0%; transform:translate(-32%,0);}
.mEvt113056 .check-area .btn-ch06 {width:28vw; height:38.67vw; position:absolute; left:20%; top:62%; background:transparent;}
.mEvt113056 .check-area .btn-ch06.on::before {top:3%; transform:translate(-50%,0);}
.mEvt113056 .check-area .btn-ch07 {width:28vw; height:38.67vw; position:absolute; left:50%; top:62%; background:transparent;}
.mEvt113056 .check-area .btn-ch07.on::before {top:3%; transform:translate(-31%,0);}
.mEvt113056 .comment-area {position:relative;}
.mEvt113056 .comment-area .input-area {width:calc(100% - 8.78rem); height:5.03rem; position:absolute; left:50%; top:1.7rem; transform: translate(-50%,0); overflow:hidden;}
.mEvt113056 .comment-area .input-area textarea {width:100%; height:100%; padding:0; font-size:1.19rem; color:#979797; resize:none; border:0; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt113056 .comment-area .input-area textarea::placeholder {font-size:1.19rem; color:#979797;}
.mEvt113056 .comment-area .btn-photo {width:30%; height:4rem; position:absolute; left:12%; bottom:1%; background:transparent;}
.mEvt113056 .comment-area .count-num {position:absolute; right:13%; bottom:79%; font-size:1.02rem; color:#979797; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt113056 .comment-area .top {position:relative;}
.mEvt113056 .comment-area .md {position:relative;}
.mEvt113056 .comment-area .md .img-view {position:absolute; left:14%; top:4%; width:24.93vw; height:24.93vw; border:0.1rem solid #ebebeb;}
.mEvt113056 .comment-area .md .img-view .wrap {position:relative; width:100%; height:100%;}
.mEvt113056 .comment-area .md .img-view .wrap .img {width:100%; height:100%; overflow:hidden;}
.mEvt113056 .comment-area .md .img-view .wrap .img img {width:100%;}
.mEvt113056 .comment-area .md .img-view .wrap .btn-close {position:absolute; right:-10%; top:-11%; width:6vw; z-index:10; background:transparent;}
.mEvt113056 .comment-area .bottom {position:relative;}

.mEvt113056 .apply-area {position:relative;}
.mEvt113056 .btn-apply {position:absolute; left:0; top:0; width:100%; height:9rem; background:transparent;}
.mEvt113056 .review-area {padding:10.66rem 2.13rem 0; background:#fff4e3;}
.mEvt113056 .review-area .conts {position:relative; padding:1.06rem; margin-top:7.25rem; background:#fff;}
.mEvt113056 .review-area .conts:nth-child(1) {margin-top:0;}
.mEvt113056 .review-area .conts .select-ch {width:24.93vw; position:absolute; left:50%; top:-13%; transform:translate(-50%,0); z-index:5;}
.mEvt113056 .review-area .conts .img-view {width:100%; height:60vw; background:#ddd; overflow: hidden;}
.mEvt113056 .review-area .conts .img-view img {width:100%;}
.mEvt113056 .review-area .conts .info {padding:1.62rem 0; display:flex; align-items:flex-start; justify-content:space-between;}
.mEvt113056 .review-area .conts .info .num {font-size:1.19rem; color:#404040; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt113056 .review-area .conts .info .id {font-size:1.10rem; color:#9d9d9d; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt113056 .review-area .comment {padding-bottom:1.62rem; font-size:1.10rem; color:#5e4848; line-height:1.5; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

.mEvt113056 .pageWrapV15 {padding:4.05rem 0 6.82rem;}
.mEvt113056 .pagingV15a {position:relative; height:100%; margin:0; display:flex; align-items:center; justify-content:center;}
.mEvt113056 .pagingV15a span {display:inline-block; width:2.13rem; height:auto; margin:0 0.51rem; border:0; color:#686765; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.45rem;}
.mEvt113056 .pagingV15a span.current {color:#fff; background-color:#e32285; border-radius:50%;}
.mEvt113056 .pagingV15a span.arrow {display:inline-block; min-width:1.32rem; height:2.31rem; padding:0; background-color:transparent;}
.mEvt113056 .pagingV15a span.arrow a {width:100%; background-size:100% 100%;}
.mEvt113056 .pagingV15a span.arrow a:after {display:none;}
.mEvt113056 .pagingV15a span.arrow.prevBtn a{background:url(//webimage.10x10.co.kr/fixevent/event/2021/113056/m/icon_left.png) no-repeat 0 50%; background-size:0.76rem 1.32rem;}
.mEvt113056 .pagingV15a span.arrow.nextBtn a{background:url(//webimage.10x10.co.kr/fixevent/event/2021/113056/m/icon_right.png) no-repeat right 50%; background-size:0.76rem 1.32rem;}
/* .mEvt113056 .pagingV15a .current {background-color:#e32285; color:#fff; border-radius:50%;} */


.mEvt113056 .animate {opacity:0; transform:translateY(-2rem); transition:all 1s;}
.mEvt113056 .animate.on {opacity:1; transform:translateY(0);}
@keyframes updown {
    0% {top:93%;}
    100% {top:95%;}
}
@keyframes wide {
    0% { transform: scale(0) }
    100% { transform: scale(1) }
}
@keyframes show {
    0% {opacity:0;}
    100% {opacity:1;}
}
</style>

<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const loginUserLevel = "<%= GetLoginUserLevel %>";
    const loginUserID = "<%= GetLoginUserID %>";
    const server_info = "<%= application("Svr_Info") %>";
    const staticImgUpUrl = "<%= staticImgUpUrl %>";
    let android_image = "";

    let isUserLoginOK = false;
    <% IF IsUserLoginOK THEN %>
        isUserLoginOK = true;
    <% END IF %>

    function appUploadFinish(ret){
        android_image = staticImgUpUrl + "/etc_event/113056/" + ret.name;
        app.preview_image = android_image;
        app.image_add_flag = true;
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
<!-- //Common Components -->

<script type="text/javascript" src="/event/lib/countdown24.js?v=1.0"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_110063.js"></script>

<!-- Core -->
<script src="/vue/event/sanrio/store.js?v=1.00"></script>
<script src="/vue/event/sanrio/index.js?v=1.00"></script>
<!-- //Core -->
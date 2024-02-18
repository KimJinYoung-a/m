<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'############################################################
' Description : LUCKY FESTIVAL 스-페티벌
' History : 2021-07-23 이전도
'############################################################
%>
<style>
.mEvt112850 {position:relative; overflow:hidden; background:#fff;}
.mEvt112850 .topic {position:relative; overflow:hidden; }
.mEvt112850 .topic .icon {position:absolute; bottom:6vh; left:50%; margin-left:-50vw; width:100%; animation: bounce 1s ease-in-out alternate infinite;}
.mEvt112850 .event-list { position:relative;}
.mEvt112850 .event-list ul { position:absolute; top:23.3vh; left:2.26rem; width:28.66rem;}
.mEvt112850 .event-list li { display:block; width:100%; height:16.4rem; margin-top:1.06rem; background:Red;}
.mEvt112850 .event-list li:first-child { margin-top:0; }
.mEvt112850 .section-01 {position:relative;}
.mEvt112850 .section-01 .img-01 {width:100vw; position:absolute; left:50%; top:32.1%; margin-left:-50vw; z-index:5;}
.mEvt112850 .section-01 .img-02 {width:100vw; position:absolute; left:50%; top:23.2%; margin-left:-50vw; z-index:1;}
.mEvt112850 .section-01 .img-03 {width:100vw; position:absolute; left:50%; top:23.5%; margin-left:-50vw; z-index:1;}
.mEvt112850 .section-01 .event-btn {width:100vw; position:absolute; bottom:26%; left:50%; margin-left:-50vw; animation: shake-horizontal 4s cubic-bezier(0.455, 0.030, 0.515, 0.955) infinite both; background:transparent;}
.mEvt112850 .animate {opacity:0; transform:translateY(30%); transition:all 1s; }
.mEvt112850 .animate.on {opacity:1; transform:translateY(0); }
.mEvt112850 .img-02.on {animation:blinker 4s ease-in-out infinite;}
.mEvt112850 .img-03.on {animation:blinker 4s ease-in-out infinite;}
@keyframes blinker {
    0% {opacity:1;}
    25% {opacity:1;}
    50% {opacity:1;}
    75% {opacity:0;}
    100% {opacity:1;}
}
@keyframes shake-horizontal {
    0%,
    100% { transform:translateX(0);}
    10%,
    30%,
    50%,
    70% { transform:translateX(-10px);}
    20%,
    40%,
    60% { transform:translateX(10px);}
    80% { transform:translateX(8px);}
    90% { transform:translateX(-8px);}
}
.mEvt112850 .pop-container {position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.mEvt112850 .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 0 4.17rem; overflow-y: scroll;}
.mEvt112850 .pop-contents {position:relative;}
.mEvt112850 .pop-contents .btn-close {width:100%; height:5.3rem; position:absolute; left:0; bottom:0; text-indent:-9999px; background:transparent; background:transparent;}
.mEvt112850 .pop-contents .img-04 {width:100vw; position:absolute; left:50%; top:28.6%; margin-left:-50vw; z-index:152;}
.mEvt112850 .pop-contents .img-05 {width:100vw; position:absolute; left:50%; top:22.2%; margin-left:-50vw; z-index:151; animation: bounce 1s ease-in-out alternate infinite;}
.mEvt112850 .pop-point {width:100%; position:absolute; left:0; top:63.4%; text-align:center;}
.mEvt112850 .pop-point p {font-size:2.77rem; color:#111; letter-spacing:-0.1rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112850 .pop-contents.last-day .pop-point {top:67%;}
.mEvt112850 .pop-contents.last-day .img-04 {top:30.2%;}
.mEvt112850 .pop-contents.last-day .img-05 {top:23.2%;}
.mEvt112850 .prd-list {padding:0 2.38rem; background:#ffffff;}
.mEvt112850 .prd-list ul {display:flex; justify-content:space-between; flex-wrap:wrap; width:100%;}
.mEvt112850 .prd-list ul li {width:48%; padding-top:1.73rem;}
.mEvt112850 .prd-list ul li:nth-child(1),
.mEvt112850 .prd-list ul li:nth-child(2) {padding-top:0;}
.mEvt112850 .prd-list ul li .thumbnail {height:41.1vw; overflow:hidden;}
.mEvt112850 .prd-list ul li .thumbnail img {width:100%;height:100%;}
.mEvt112850 .prd-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt112850 .prd-list .desc {padding:1.65rem 0 1.3rem; }
.mEvt112850 .prd-list .price { position:relative; padding-top:2.98rem;font-size:1.36rem; letter-spacing:-1px; color:#141414; padding-left:3rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt112850 .prd-list .price.not-sale { padding-top:1rem; padding-left:0;}
.mEvt112850 .prd-list .price span { color:#ff1461; left:0; position:absolute; }
.mEvt112850 .prd-list .price s {font-size:1.19rem; color:#a0a79b; text-decoration:none; position:absolute; top:1rem; left:0; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112850 .prd-list .desc .name {height: 3.5rem; padding-top:0.81rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; line-height:1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;}
.mEvt112850 .prd-list .desc .brand { color:#000000; font-size:1rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt112850 .section-02 {position:relative;}
.mEvt112850 .section-02 a {position:absolute; left:50%; width:100vw; margin-left:-50vw;}
.mEvt112850 .section-02 a img {height:100%;}
.mEvt112850 .section-02 a.item-01 {top:27%;}
.mEvt112850 .section-02 a.item-02 {top:44%;}
.mEvt112850 .section-02 a.item-03 {bottom:24%;}
.mEvt112850 .section-02 a.item-04 {bottom:3%;}
.mEvt112850 .prd-wrap {position:relative;}
.mEvt112850 .prd-wrap a {position:absolute; left:50%; width:100vw; margin-left:-50vw;}
.mEvt112850 .prd-wrap a img {height:100%;}
.mEvt112850 .prd-wrap a.item-01 {top:13%;}
.mEvt112850 .prd-wrap a.item-02 {top:55%;}
.mEvt112850 .section-06 {position:relative;}
.mEvt112850 .section-06 .link-conts {display: flex; flex-wrap: wrap; width: 100%;position: absolute; left: 0; top: 18.6%; padding:0 6%;}
.mEvt112850 .section-06 .link-conts div {width:50%;}
.mEvt112850 .section-06 .link-conts div a {height:43.5vw; position:relative; display:inline-block; width:100%;}
@keyframes bounce {
    0% {transform: translateY(-0.5rem)}
    100% {transform: translateY(0.5rem)}
}
.fade-enter-active, .fade-leave-active {transition: opacity .5s;}
.fade-enter, .fade-leave-to {opacity: 0;}
</style>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>

<div id="app"></div>
<script src="/vue/event/etc/112850/data.js?v=1.10"></script>
<script src="/vue/event/etc/112850/spetivalItem.js?v=1.01"></script>
<script src="/vue/event/etc/112850/vue_112850.js?v=1.03"></script>
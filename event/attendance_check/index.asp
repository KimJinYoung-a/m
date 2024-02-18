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
    DIM userid

    userid = GetencLoginUserID
%>

<style>
    .mEvt113634 .hidden {font-size:0; text-indent:-9999px;}
    .mEvt113634 .topic {position:relative;}
    .mEvt113634 .topic h2 {width:61.73vw; position:absolute; left:50%; top:11%; margin-left:-31vw; opacity:0; transition:1.5s; transform: translateY(-1rem);}
    .mEvt113634 .topic h2.check {transform: translateY(0); opacity:1;}
    .mEvt113634 .topic .txt {width:67.47vw; position:absolute; left:50%; top:33%; margin-left:-33vw; opacity:0; transition:1.5s .5s; transform: translateY(-1rem);}
    .mEvt113634 .topic .txt.check {transform: translateY(0); opacity:1;}
    .mEvt113634 .section-photo {position:relative; overflow:hidden; z-index:10;}
    .mEvt113634 .section-photo .ph01 {width:22.80vw; position:absolute; left:28%; bottom:-10%; z-index:5;}
    .mEvt113634 .section-photo .ph02 {width:29.87vw; position:absolute; left:47%; bottom:-10%;}
    .mEvt113634 .section-photo .ph03 {width:21.20vw; position:absolute; left:44%; bottom:-10%; z-index:4;}
    .mEvt113634 .section-photo .ph04 {width:35.47vw; position:absolute; left:29%; bottom:-2%; z-index:3;}
    .mEvt113634 .section-photo .ph05 {width:9.47vw; position:absolute; left:18%; bottom:38%; z-index:3;}
    .mEvt113634 .section-photo .ph06 {width:20.53vw; position:absolute; left:61%; bottom:-10%;}
    .mEvt113634 .section-photo .ph07 {width:15.87vw; position:absolute; left:71%; bottom:-10%; z-index:4;}
    .mEvt113634 .section-photo .ph08 {width:29.47vw; position:absolute; left:14%; bottom:-10%;}
    .mEvt113634 .section-photo .ph09 {width:13.60vw; position:absolute; left:49%; bottom:19%; z-index:5;}
    .mEvt113634 .section-photo .ph01-01 {width:22.80vw; position:absolute; left:28%; bottom:-10%; z-index:5; animation:show 1.5s alternate infinite;}
    .mEvt113634 .section-photo .ph02-02 {width:29.87vw; position:absolute; left:47%; bottom:-10%; animation:show 1.5s alternate infinite;}
    .mEvt113634 .section-photo .ph03-03 {width:21.20vw; position:absolute; left:44%; bottom:-10%; z-index:4; animation:show 1.5s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph04-04 {width:35.47vw; position:absolute; left:29%; bottom:-2%; z-index:3; animation:show 1.5s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph05-05 {width:9.47vw; position:absolute; left:18%; bottom:38%; z-index:3; animation:show 2s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph06-06 {width:20.53vw; position:absolute; left:61%; bottom:-10%; animation:show 2s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph07-07 {width:15.87vw; position:absolute; left:71%; bottom:-10%; z-index:4; animation:show 3s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph08-08 {width:29.47vw; position:absolute; left:14%; bottom:-10%; animation:show 3s 1s alternate infinite;}
    .mEvt113634 .section-photo .ph09-09 {width:13.60vw; position:absolute; left:49%; bottom:19%; z-index:5; animation:show 3s 1s alternate infinite;}
    .mEvt113634 .section-photo .bar {width:75%; height:1.49rem; position:absolute; left:50%; bottom:0.05rem; transform:translate(-50%,0); background:#a37f4b; z-index:10;}
    .mEvt113634 .section-check {position:relative;}
    .mEvt113634 .section-check .btn-check {width:100%; height:8rem; position:absolute; left:0; bottom:23%; background:transparent;}
    .mEvt113634 .section-check .bar {width:100%; height:1rem; position:absolute; left:0; top:-1px; background:#20362a; z-index:11;}
    .mEvt113634 .section-mileage {background:#f1b9a8;}
    .mEvt113634 .section-mileage .id-area {padding-top:4rem; text-align:center;}
    .mEvt113634 .section-mileage .id-area p:nth-child(1) span {text-decoration:underline; text-decoration-color:#20362a;}
    .mEvt113634 .section-mileage .id-area p:nth-child(1) {padding-bottom:3%; font-size:1.92rem; color:#20362a; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .section-mileage .id-area p:nth-child(2) {font-size:2.50rem; color:#20362a; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .section-mileage .event-area {display:flex; align-items:center; justify-content:center; flex-wrap:wrap; padding-top:3.41rem;}
    .mEvt113634 .section-mileage .event-area .ch-fail,
    .mEvt113634 .section-mileage .event-area .ch-before,
    .mEvt113634 .section-mileage .event-area .ch-after {width:28.40vw; margin:0 0.42rem 1.28rem; text-align:center;}
    .mEvt113634 .section-mileage .event-area .ch-fail img {width:25.60vw;}
    .mEvt113634 .section-mileage .event-area .ch-before {position:relative;}
    .mEvt113634 .section-mileage .event-area .ch-before .point {position:absolute; left:50%; top:46%; transform: translate(-50%,0); font-size:2.34rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .section-mileage .show-mileage {position:relative;}
    .mEvt113634 .section-mileage .show-mileage .num {position:absolute; left:50%; top:40%; transform: translate(-50%,0); font-size:2.34rem; color:#383838; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .section-mileage .show-mileage .btn-mileage {width:12vw; height:16vw; position:absolute; right:16%; top:32%;}
    .mEvt113634 .section-alram {position:relative;}
    .mEvt113634 .section-alram .btn-alram {width:100%; height:8rem; position:absolute; left:0; bottom:17%; background:transparent;}
    .mEvt113634 .section-detail {margin-top:-1px;}
    .mEvt113634 .btn-detail {position:relative;}
    .mEvt113634 .btn-detail .icon {width:0.98rem; height:0.55rem; position:absolute; left:50%; top:51%; margin-left:7.55rem;}
    .mEvt113634 .noti {display:none;}
    .mEvt113634 .noti.on {display:block;}
    .mEvt113634 .icon.on {transform: rotate(180deg);}
    .mEvt113634 .icon {transform: rotate(0);}
    .mEvt113634 .section-bnr {position:relative;}
    .mEvt113634 .section-bnr a {display:inline-block; width:100%; height:100%;}
    .mEvt113634 .section-bnr .prd01 {width:100%; height:20rem; position:absolute; left:0; top:12%;}
    .mEvt113634 .section-bnr .prd02 {width:100%; height:26rem; position:absolute; left:0; top:23%;}
    .mEvt113634 .section-bnr .prd03 {width:100%; height:17rem; position:absolute; left:0; top:36%;}
    .mEvt113634 .section-bnr .prd04 {width:100%; height:28rem; position:absolute; left:0; top:46%;}
    .mEvt113634 .section-bnr .prd05 {width:100%; height:28rem; position:absolute; left:0; top:63%;}
    .mEvt113634 .section-bnr .prd06 {width:100%; height:28rem; position:absolute; left:0; top:80%;}
    .mEvt113634 .section-bnr .btn-go {width:100%; height:10rem; position:absolute; left:0; bottom:2%;}
    .mEvt113634 .animate {opacity:0; transform:translateY(-2rem); transition:all 1s;}
    .mEvt113634 .animate.on {opacity:1; transform:translateY(0);}

    .mEvt113634 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.502); z-index:150;}
    .mEvt113634 .pop-container .pop-contents {position:relative;}
    .mEvt113634 .pop-container .pop-contents .btn-alram-page {width:100%; height:10rem; position:absolute; left:0; bottom:0; background:transparent;}
    .mEvt113634 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
    .mEvt113634 .pop-container .pop-inner a {display:inline-block;}
    .mEvt113634 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113634/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
    .mEvt113634 .pop-container .pop-contents .point {position:absolute; left:50%; top:31%; transform:translate(-50%,0); font-size:2.56rem; color:#223a2c; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .pop-container .pop-contents .txt {width:100%; position:absolute; left:50%; top:61%; transform:translate(-50%,0); font-size:1.36rem; color:#111111; text-align:center;}
    .mEvt113634 .pop-container.check02 .pop-contents .txt {top:64%;}
    .mEvt113634 .pop-container .pop-contents .bold {padding-top:1rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
    .mEvt113634 .pop-container .pop-contents .txt span {color:#ff4713;}
    .mEvt113634 .pop-container .pop-contents .txt p {padding-bottom:1rem;}
    .mEvt113634 .pop-container .pop-contents .btn-tomorrow {width:100%; height:10rem; position:absolute; left:0; bottom:0; background:transparent;}
    .mEvt113634 .pop-container .pop-contents .btn-event {width:100%; height:10rem; position:absolute; left:0; bottom:0; background:transparent;}

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

<% If application("Svr_Info")="Dev" Then %>
    <script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<% END IF %>

<script>
    const userid = '<%= userid %>';
</script>


<div id="app"></div>

<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="/vue/vue_dev.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>

<script src="/vue/event/mileage_attendance/index_m.js?v=2.00"></script>
<script>
$(function(){
    $('.topic h2,.topic .txt').addClass('check');
});
</script>
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
    DIM userid, isLoginOk

    userid = GetencLoginUserID
    isLoginOk = IsUserLoginOK
%>

<style>
.box-tape button {background:transparent;}
.box-tape h2 {position:relative;}
.box-tape h2 .tit {position:absolute; left:50%; top:23%; width:67.47vw; margin-left:-33.5vw; opacity:0; transform:translateY(5%); transition:all 1s;}
.box-tape h2 .txt {position:absolute; left:50%; top:46%; width:67.20vw; margin-left:-33.5vw; opacity:0; transform:translateY(5%); transition:all 1s .5s;}
.box-tape h2 .txt.on,
.box-tape h2 .tit.on {opacity:1; transform:translateY(0);}
.box-tape .animate {opacity:0; transform:translateY(10%); transition:all 1s;}
.box-tape .animate.on {opacity:1; transform:translateY(0);}
.box-tape .section-01 {position:relative;}
.box-tape .section-01 .txt01 {position:absolute; left:50%; top:13%; width:84.67vw; margin-left:-42vw;}
.box-tape .section-01 .txt02 {position:absolute; left:50%; top:53%; width:86.93vw; margin-left:-43vw;}
.box-tape .section-02 {padding:0 1.08rem; background:#f5efea;}
.box-tape .section-02 ul {display:flex; flex-wrap:wrap; align-items:flex-start; justify-content:space-between;}
.box-tape .section-02 ul li {width:31.07vw;}
.box-tape .section-03 {position:relative;}
.box-tape .section-03 .btn-apply {width:100%; height:10rem; position:absolute; left:0; top:13%;}
.box-tape .section-04 {padding-bottom:8.32rem; background:#c6a378;}
.box-tape .section-04 .tit {position:relative;}
.box-tape .section-04 .tit .icon {width:5.33vw; position:absolute; right:7%; bottom:4%; animation: wing 1s alternate infinite;}
.box-tape .section-04 .copy-list {position:relative;}
.box-tape .section-04 .copy-list.copy-pd {padding-top:4.35rem;}
.box-tape .section-04 .copy-list .num-th {width:19.07vw; position:absolute; left:5%; bottom:15%;}
.box-tape .section-04 .copy-list .list {display:flex; align-items:center; overflow-x: scroll; width:100%; height:4.90rem; padding-left:8.10rem; background:#f70d0d;}
.box-tape .section-04 .copy-list .list img {margin-right:2.56rem;}
.box-tape .section-04 .copy-list .list01 .txt01 img {width:62.40vw;}
.box-tape .section-04 .copy-list .list01 .txt02 img {width:64.20vw;}
.box-tape .section-04 .copy-list .list01 .txt03 img {width:40.53vw;}
.box-tape .section-04 .copy-list .list01 .txt04 img {width:34.13vw;}
.box-tape .section-04 .copy-list .list01 .txt05 img {width:55.87vw;}
.box-tape .section-04 .copy-list .list02 .txt01 img {width:50.67vw;}
.box-tape .section-04 .copy-list .list02 .txt02 img {width:44.27vw;}
.box-tape .section-04 .copy-list .list02 .txt03 img {width:53.33vw;}
.box-tape .section-04 .copy-list .list02 .txt04 img {width:37.60vw;}
.box-tape .section-04 .copy-list .list02 .txt05 img {width:61.87vw;}
.box-tape .section-04 .copy-list .list03 .txt01 img {width:55.87vw;}
.box-tape .section-04 .copy-list .list03 .txt02 img {width:32.40vw;}
.box-tape .section-04 .copy-list .list03 .txt03 img {width:39.87vw;}
.box-tape .section-04 .copy-list .list03 .txt04 img {width:41.60vw;}
.box-tape .section-04 .copy-list .list03 .txt05 img {width:41.07vw;}
.box-tape .section-04 .copy-list .list04 .txt01 img {width:49.47vw;}
.box-tape .section-04 .copy-list .list04 .txt02 img {width:59.60vw;}
.box-tape .section-04 .copy-list .list04 .txt03 img {width:54.53vw;}
.box-tape .section-04 .copy-list .list04 .txt04 img {width:48.27vw;}
.box-tape .section-04 .copy-list .list04 .txt05 img {width:63.33vw;}
.box-tape .section-04 .copy-list .list05 .txt01 img {width:56.13vw;}
.box-tape .section-04 .copy-list .list05 .txt02 img {width:59.07vw;}
.box-tape .section-04 .copy-list .list05 .txt03 img {width:45.33vw;}
.box-tape .section-04 .copy-list .list05 .txt04 img {width:62.00vw;}
.box-tape .section-04 .copy-list .list05 .txt05 img {width:53.33vw;}
@keyframes wing {
    0% {transform: translateX(-.5rem);}
    100% {transform: translateX(.5rem);}
}
</style>

<script>
    const userid = '<%= userid %>';
    let isLoginOk = false;
    <% IF isLoginOk THEN %>
        isLoginOk = true;
    <% END IF %>
</script>


<div id="app"></div>

<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="https://unpkg.com/vue"></script>
    <script src="https://unpkg.com/vuex"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
    <script src="/vue/vuex.min.js"></script>
<% End If %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>

<script src="/vue/event/etc/113992/index.js?v=1.00"></script>
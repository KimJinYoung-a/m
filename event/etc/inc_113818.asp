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
.mEvt113819 .hiddens {font-size:0; text-indent:-9999px;}
.mEvt113819 button {background:transparent;}
.mEvt113819 .topic {position:relative;}
.mEvt113819 .topic .tit {width:33.33vw; position:absolute; left:50%; top:17%; margin-left:-16.5vw; animation: bouns .8s linear alternate infinite;}
.mEvt113819 .section-apply {position:relative;}
.mEvt113819 .section-apply .btn-apply {width:100%; height:10rem; position:absolute; left:0; bottom:4%;}
.mEvt113819 .section-apply .item01 {width:47.60vw; position:absolute; left:20%; top:23%; z-index:2;}
.mEvt113819 .section-apply .item02 {width:26.80vw; position:absolute; left:57%; top:27%; z-index:3;}
.mEvt113819 .section-apply .item03 {width:50.80vw; position:absolute; left:15%; top:47%; z-index:1;}
.mEvt113819 .section-apply .item04 {width:19.73vw; position:absolute; left:70%; top:46%;}
.mEvt113819 .section-apply .icon-arr {width:28.67vw; position:absolute; left:23%; bottom:26.5%; animation: swing 1s linear alternate infinite;}
.mEvt113819 .btn-detail {position:relative;}
.mEvt113819 .btn-detail .icon {width:0.98rem; height:0.55rem; position:absolute; left:50%; top:44%; margin-left:6.55rem;}
.mEvt113819 .noti {display:none;}
.mEvt113819 .noti.on {display:block;}
.mEvt113819 .icon.on {transform: rotate(180deg);}
.mEvt113819 .icon {transform: rotate(0);}
.mEvt113819 .section-alram {position:relative;}
.mEvt113819 .section-alram .btn-alram {width:100%; height:10rem; position:absolute; left:0; bottom:38%;}
.mEvt113819 .section-prd {position:relative;}
.mEvt113819 .section-prd .tit {width:33.33vw; position:absolute; left:50%; top:3%; margin-left:-16.5vw; animation: bouns .8s linear alternate infinite;}
.mEvt113819 .section-prd a {display:inline-block; width:100%; position:absolute; left:0;}
.mEvt113819 .section-prd .prd01 {height:24rem; top:13%;}
.mEvt113819 .section-prd .prd02 {height:21rem; top:23%;}
.mEvt113819 .section-prd .prd03 {height:21rem; top:32%;}
.mEvt113819 .section-prd .prd04 {height:30rem; top:44%;}
.mEvt113819 .section-prd .prd05 {height:38rem; top:57%;}
.mEvt113819 .section-prd .prd06 {height:25rem; top:72%;}
.mEvt113819 .section-prd .prd07 {height:25rem; top:82%;}
.mEvt113819 .section-prd .btn-event {height:10rem; bottom:2%;}
.mEvt113819 .section-first {position:relative;}
.mEvt113819 .section-first .btn-new {display:inline-block; width:100%; height:37rem; position:absolute; left:0; top:27%;}

.mEvt113819 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.502); z-index:150;}
.mEvt113819 .pop-container .pop-contents {position:relative;}
.mEvt113819 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt113819 .pop-container .pop-inner a {display:inline-block;}
.mEvt113819 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:2.73rem; height:2.73rem; text-indent:-9999px;}

.mEvt113819 .pop-container .pop-contents .btn-talk {width:100%; height:10rem; position:absolute; left:0; bottom:0;}
.mEvt113819 .pop-container .pop-contents .btn-kakao {width:19.33vw; height:19.33vw; position:absolute; left:23%; bottom:16%;}
.mEvt113819 .pop-container .pop-contents .btn-url {width:19.33vw; height:19.33vw; position:absolute; left:56%; bottom:16%;}
@keyframes bouns {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(0);}
}
@keyframes swing {
    0% {transform: translateX(-.5rem);}
    100% {transform: translateX(0);}
}
</style>

<script>
    const userid = '<%= userid %>';
    let isLoginOk = false;
    <% IF isLoginOk THEN %>
        isLoginOk = true;
    <% END IF %>

    // btn more
    $('.mEvt113819 .btn-detail').click(function (e) {
        $(this).next().toggleClass('on');
        $(this).find('.icon').toggleClass('on');
    });
    /* 이미지 순차 노출 */
    changingImg();
    function changingImg(){
        var i=1;
        var repeat = setInterval(function(){
            i++;
            if(i>2){i=1;}
            $('.mEvt113819 .item01').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item01_prd0'+ i +'.png');
            $('.mEvt113819 .item02').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item02_prd0'+ i +'.png');
            $('.mEvt113819 .item03').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item03_prd0'+ i +'.png');
            $('.mEvt113819 .item04').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113819/m/img_item04_prd0'+ i +'.png');
            /* if(i == 5) {
                clearInterval(repeat);
            } */
        },1300);
    }
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

<script src="/vue/event/etc/113819/index_m.js?v=1.00"></script>
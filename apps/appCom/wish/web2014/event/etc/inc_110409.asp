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
' Description : 4월정기세일 매일리지
' History : 2021.03.30 이전도 생성
'####################################################

Dim eCode

IF application("Svr_Info") = "Dev" THEN
    eCode = "104340"
Else
    eCode = "110409"
End If
%>
<style>
.mEvt110409 {position:relative; overflow:hidden; background-color:#ff8590;}
.mEvt110409 button {background:none;}
.mEvt110409 .topic {position:relative;}
.mEvt110409 .topic h2 {position:relative; z-index:5;}
.mEvt110409 .get-mileage {position:absolute; top:109vw; left:7.5%; z-index:10; width:57.2%;}
.mEvt110409 .get-mileage span {display:block; padding-right:.2em; font-family:'CoreSansCBold'; font-size:3rem; color:#fff;}
.mEvt110409 .chk-attendance {position:absolute; top:108vw; left:44.1%; z-index:10; width:51.2%; animation:bounce 1s both 20;}
.dc-group {position:absolute; top:0; left:0; width:100%; height:100%;}
.dc-group .dc {position:absolute; animation-iteration-count:100; animation-timing-function:linear; animation-fill-mode:both;}
.dc-group .dc1 {left:67%; top:19vw; width:40%; animation-name:move1; animation-duration:12s; animation-direction:alternate-reverse; transform-origin:-50% -50%;}
.dc-group .dc2 {left:-5%; top:56vw; width:31.5%; animation-name:move2; animation-duration:25s;}
.dc-group .dc3 {left:65%; top:84vw; width:20.5%; animation-name:move3; animation-duration:15s; transform-origin:-100% -100%;}
.dc-group .dc4 {left:61%; top:130vw; width:39.7%; animation-name:move3; animation-duration:15s; transform-origin:-40% -40%;}
@keyframes move1 {
	0% {transform:rotate(150deg) scale(.9);}
	100% {transform:rotate(-90deg) scale(.9);}
}
@keyframes move2 {
	0%,100% {transform:translate3d(-10rem,0,0);}
	25% {transform:translate3d(20rem,-30rem,0);}
	50% {transform:translate3d(35rem,10rem,0);}
	75% {transform:translate3d(15rem,40rem,0);}
}
@keyframes move3 {
	0% {transform:rotate(0deg);}
	100% {transform:rotate(360deg);}
}
.mEvt110409 .process {position:relative;}
.mEvt110409 .process .daily {position:absolute; display:flex; flex-direction:column; justify-content:center; width:27.2vw; height:24.3vw; text-align:center; color:#6bff8e; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110409/m/bg_daily.png) no-repeat center / contain;}
.mEvt110409 .process .daily:nth-of-type(1) {left:7.73%; top:39.6vw;}
.mEvt110409 .process .daily:nth-of-type(2) {left:38.8%; top:35.9vw;}
.mEvt110409 .process .daily:nth-of-type(3) {left:65.5%; top:51.6vw;}
.mEvt110409 .process .daily:nth-of-type(4) {left:37.9%; top:69.9vw;}
.mEvt110409 .process .daily:nth-of-type(5) {left:8.8%; top:85vw;}
.mEvt110409 .process .daily:nth-of-type(6) {left:33%; top:105.3vw;}
.mEvt110409 .process .daily:nth-of-type(7) {left:65.7%; top:100.5vw;}
.mEvt110409 .process .daily:nth-of-type(8) {left:67.5%; top:131vw;}
.mEvt110409 .process .daily:nth-of-type(9) {left:40%; top:145.2vw;}
.mEvt110409 .process .daily p {font-size:1.3rem; line-height:1.5;}
.mEvt110409 .process .daily strong {font-family:'CoreSansCBold'; font-size:2.13rem;}
.mEvt110409 .process .daily::before {position:absolute; top:0; right:0; bottom:0; left:0; content:' '; background:no-repeat center / contain;}
.mEvt110409 .process .daily.pass::before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/110409/m/txt_pass.png);}
.mEvt110409 .process .daily.done::before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/110409/m/txt_done.png);}
.mEvt110409 .process .daily.done::after {position:absolute; top:50%; left:50%; transform:translate(-50%,.2em) rotate(10deg); font-family:'CoreSansCBold'; font-size:1.2rem; color:#788aff; content:attr(data-point);}
.mEvt110409 .btn-push {display:block; width:100%;}
@keyframes bounce {
	0%,100% {transform:translateY(0rem); animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
.mEvt110409 .popup {position:fixed; top:0; right:0; bottom:0; left:0; z-index:30; background:rgba(0,0,0,.7);}
.mEvt110409 .popup .layer {overflow:hidden auto; position:absolute; top:50%; left:50%; width:27rem; max-height:90%; transform:translate(-50%,-50%);}
.mEvt110409 .popup .layer > div {position:relative;}
.mEvt110409 .popup .btn-close {position:absolute; top:0; right:0; width:15vw; height:15vw; font-size:0; color:transparent;}
.mEvt110409 .popup .btn-setting {position:absolute; left:0; bottom:0; width:100%; height:23%; font-size:0; color:transparent;}
.mEvt110409 .popup .btn-push {position:absolute; left:0; bottom:0; height:28%; font-size:0; color:transparent;}
.mEvt110409 .popup .link {position:absolute; left:0; bottom:0; width:100%; height:24%; font-size:0; color:transparent;}
.mEvt110409 .popup .today {position:absolute; right:66%; top:49%; font-family:'CoreSansCBold'; font-size:2.4rem; color:#788aff;}
.mEvt110409 .popup .last .today {top:51.3%;}
.mEvt110409 .popup .tomorrow {position:absolute; right:51.5%; top:66.3%; font-family:'CoreSansCRegular'; font-size:1.6rem; color:#363636;}
.fade-enter-active, .fade-leave-active {transition: opacity .5s;}
.fade-enter, .fade-leave-to  {opacity: 0;}
</style>

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

<script src="/vue/event/etc/110409/modal_110409.js?v=1.01"></script>
<script src="/vue/event/etc/110409/day.js?v=1.00"></script>
<script src="/vue/event/etc/110409/receive.js?v=1.01"></script>
<script src="/vue/event/etc/110409/alert.js?v=1.00"></script>
<script src="/vue/event/etc/110409/vue_110409.js?v=1.07"></script>
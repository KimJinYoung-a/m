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
' Description : 추석 응모 이벤트 - 브릿지 페이지
' History : 2021.09.14 이전도 생성
'####################################################
%>
<style>
.mEvt114117 section{position:relative;}

.mEvt114117 .section01 p.txt01{width:14.8vw;position:absolute;top:10rem;left:15vw;transform:translateY(-5rem); opacity:0; transition:all 1s;}
.mEvt114117 .section01 p.txt01.on{opacity:1;transform: translateY(0);}
.mEvt114117 .section01 p.txt02{width:14.9vw;position:absolute;top:17rem;right:50%;margin-right:1vw;transform: translateY(-5rem); opacity:0; transition:all 1s .5s;}
.mEvt114117 .section01 p.txt02.on{opacity:1;transform: translateY(0);}
.mEvt114117 .section01 .app_float{width:22.4vw;position:absolute;top:15em;left:50%;margin-left:20vw;animation:updown 1s ease-in-out alternate infinite;}


.mEvt114117 .section02 .float01{width:23.7vw;position:absolute;top:5em;left:50%;margin-left:-11.85vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt114117 .section02 a.submit{width:100%;height:8rem;position:absolute;left:0;bottom:4rem;}

.mEvt114117 .section03 a.notice{width:100%;height:6rem;position:absolute;top:17rem;;left:0;}
.mEvt114117 .section03 a.notice span{position:absolute;right:25vw;top:3rem;transform: rotate(0);}
.mEvt114117 .section03 a.notice span.on {transform:rotate(180deg);top:2.5rem;}
.mEvt114117 .section03 a.notice span img{width:2.9vw;}

.mEvt114117 .section04 button.alert{width:100%;height:8rem;position:absolute;left:0;bottom:6rmem;background:transparent;}

.mEvt114117 .section05 .slide{position:absolute;bottom:6rem;left:7vw;}
.mEvt114117 .section05 .swiper-slide img{width:45.3vw;}

.mEvt114117 .section06 .float02{width:33.3vw;position:absolute;top:5em;left:50%;margin-left:-16.65vw;animation:updown 1s ease-in-out alternate infinite;}
.mEvt114117 .section06 .item01{position:relative;}
.mEvt114117 .section06 .item01 .prd01{position:absolute;top:39rem;left:12vw;width:41vw;height:10rem;}
.mEvt114117 .section06 .item01 .prd02{position:absolute;top:49rem;right:0;width:59vw;height:14rem;}
.mEvt114117 .section06 .item01 .url01{position:absolute;top:55rem;left:6vw;width:35vw;height:5rem;}
.mEvt114117 .section06 .item01 .prd03{position:absolute;top:67rem;left:0;width:59vw;height:27rem;}
.mEvt114117 .section06 .item01 .url02{position:absolute;top:85rem;right:6vw;width:35vw;height:5rem;}

.mEvt114117 .section06 .item02{position:relative;}
.mEvt114117 .section06 .item02 .url01{position:absolute;top:12rem;right:20vw;width:35vw;height:5rem;}
.mEvt114117 .section06 .item02 .prd01{position:absolute;top:18rem;right:12vw;width:58vw;height:16rem;}
.mEvt114117 .section06 .item02 .prd02{position:absolute;bottom:11rem;left:6vw;width:59vw;height:14rem;}
.mEvt114117 .section06 .item02 .url02{position:absolute;bottom:6rem;right:15vw;width:35vw;height:5rem;}

.mEvt114117 .section06 .item03{position:relative;}
.mEvt114117 .section06 .item03 .url01{position:absolute;top:1rem;left:5vw;width:35vw;height:5rem;}
.mEvt114117 .section06 .item03 .prd01{position:absolute;top:0;right:0;width:58vw;height:25rem;}

.mEvt114117 .section06 .item04{position:relative;}
.mEvt114117 .section06 .item04 .url01{position:absolute;bottom:2rem;right:5vw;width:35vw;height:5rem;}
.mEvt114117 .section06 .item04 .prd01{position:absolute;top:0;left:0;width:100%;height:25rem;}

.mEvt114117 .section06 .item05{position:relative;}
.mEvt114117 .section06 .item05 .url01{position:absolute;top:2rem;left:5vw;width:35vw;height:5rem;}
.mEvt114117 .section06 .item05 .prd01{position:absolute;top:7rem;left:10vw;width:80vw;height:25rem;}

.mEvt114117 .section07 a.new_page{position:absolute;width:100%;height:37rem;top:15rem;left:0;}

@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
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

<script src="/vue/event/etc/114116/vue_114116.js?v=1.03"></script>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 취향 나눔 :) 이벤트
' History : 2021.09.14 정태훈 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<style>
.mEvt114022 section{position:relative;}

.mEvt114022 section .mini{width:5.6vw;position:absolute;top:2.6rem;right:11vw;}
.mEvt114022 section .mini p{margin-bottom:.4rem;opacity:0;}
.mEvt114022 section .mini p.on{opacity:1;}
.mEvt114022 section .mini p.h01{transition:all 1s;}
.mEvt114022 section .mini p.h02{transition:all 1s .5s;}
.mEvt114022 section .mini p.h03{transition:all 1s 1s;}
.mEvt114022 section .mini p.h04{transition:all 1s 1.5s;}
.mEvt114022 section .mini p.h05{transition:all 1s 2s;}

.mEvt114022 section .heart{width:14vw;position:absolute;bottom:2rem;left:7vw;animation:bounce 1s linear infinite;}

@keyframes bounce{
  0%, 100% {
    transform:none;  
    animation-timing-function:ease-out;
  }
  50% {
    transform: translateY(-2rem);
    animation-timing-function:ease-in;
  }
  
}
[v-cloak] { display: none; }
.sold-now {background:#fff;}
</style>
<script>
$(function() {
    $('.mEvt114022 section .mini p').addClass('on');
});
</script>
<link rel="stylesheet" type="text/css" href="/lib/css/apple.css?v=1.2">
<link rel="stylesheet" type="text/css" href="/lib/css/common.css?v=3.12">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css?v=6.90">
<link rel="stylesheet" type="text/css" href="/lib/css/section.css?v=4.86">
<link rel="stylesheet" type="text/css" href="/lib/css/app.css?v=1.98">
<%' 상품 리스트 %>
<div id="content" class="content sold-now">
    <div class="evtContV15">
        <div class="mEvt114022">
            <section>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/bg.jpg?v=3" alt="">
                <div class="mini">
                    <p class="h01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/mini_heart.png" alt=""></p>
                    <p class="h02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/mini_heart.png" alt=""></p>
                    <p class="h03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/mini_heart.png" alt=""></p>
                    <p class="h04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/mini_heart.png" alt=""></p>
                    <p class="h05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/mini_heart.png" alt=""></p>
                </div>
                <p class="heart"><img src="//webimage.10x10.co.kr/fixevent/event/2021/114022/m/heart.png" alt=""></p>
            </section>
        </div>
    </div>
    <h2 style="padding-bottom:0.07rem;"></h2>
    <div id="app"></div>
</div>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>
<script src="/vue/item/components/itemlist.js?v=1.00"></script>
<script src="/vue/item/main/justsold/filter.js?v=1.00"></script>
<script src="/vue/item/modules/storeEvent.js?v=1.01"></script>
<script src="/vue/item/main/justsold/index.js?v=1.00"></script>
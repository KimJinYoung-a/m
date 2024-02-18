<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 오뚜기
' History : 2019-12-30
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate 
dim debugMode
debugMode = request("debugMode")

dim eCode
'test
'currentDate = Cdate("2019-12-31")

IF application("Svr_Info") = "Dev" THEN
	eCode   =  90453
Else
	eCode   =  99723
End If
%>
<style type="text/css">
.mEvt99723 {background-color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt99723 .top {position:relative;}
.mEvt99723 .top h2 {position:absolute; bottom:8%; left:0;}
.mEvt99723 .top .t {display:inline-block; animation:fadeInX both .7s .3s 1;}
.mEvt99723 .top .t2 {margin:.55rem 0 .77rem; animation-delay:.5s;}
.mEvt99723 .top .t3 {animation-delay:.7s;}
@keyframes fadeInX {
    0% {transform:translateX(-50px); opacity:0;}
    100% {transform:translateX(0); opacity:1;}
}
.sc2 {position:relative;}
.sc2 .vod {position:absolute; top:12.45%; width:90.6%; z-index:10; height:0; left:50%; margin-left:-45.3%; padding-bottom:52.32%;}
.sc2 .vod iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.sc2 .composition {position:relative;}
.sc2 .composition a {position:absolute; top:36.82%; left:0;}
.sc2 .composition a:after, .sc4 a:after {display:inline-block; position:absolute; top:50%; right:38.4%; width:.68rem; height:1.15rem; margin-top:-.55rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99723/m/ico_get.png); background-size:100%; content:''; animation:moveX .8s 500 ease-in-out;}
@keyframes moveX {
    from, to {transform:translateX(0);}
    50%{transform:translateX(5px);}
}
.sc2 .limited {display:inline-block; position:absolute; top:26.2rem; right:5.3%; z-index:10; width:16%; animation:bounce 1s 500 both;}
@keyframes bounce {
    from, to {transform:translateY(0rem); animation-timing-function:ease-in;}
    50% {transform:translateY(0.8rem); animation-timing-function:ease-out;}
}
.sc3 .gallery {position:relative; width:100%; height:25.6rem;}
.sc3 .gallery .txt {position:absolute; top:-1.28rem; right:1.28rem; width:44.53%;}
.sc3 .gallery .thumb {width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99723/m/img_gallery.jpg?v=1.01) repeat 0 0 / auto 100%; animation:slide 45s 10 linear;}
@keyframes slide {
0% {background-position:0 0;}
100% {background-position:-136.11rem 0;}
}
.sc4 {position:relative;}
.sc4 .slider {position:relative; padding-bottom:4.27rem;}
.sc4 .slider .btn-nav {position:absolute; top:50%; z-index:10; width:2.56rem; height:2.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99723/m/btn_nav.png) no-repeat 50% 50% / 100%; text-indent:-999em;}
.sc4 .slider .btn-prev {left:1.71rem;}
.sc4 .slider .btn-next {right:1.71rem; transform:rotate(180deg);}
.sc4 a {position:absolute; bottom:4.53%; left:0; z-index:10;}
.slider2 .pagination {height:auto; padding-top:.85rem; margin-bottom:3.41rem;}
.slider2 .pagination .swiper-pagination-switch {width:.84rem; height:.84rem; margin:0 .38rem; border:solid .13rem #f22728; background-color:transparent;}
.slider2 .pagination .swiper-active-switch {background-color:#f22728;}
.cmt-box {margin:3.41rem 0;}
.cmt-box .preview {width:26.88rem; margin:0 auto; padding:1.88rem 1.49rem; background-color:#fff100; font-size:1.28rem; text-align:right;}
.cmt-box .preview .writer {display:block; text-align:left;}
.cmt-box .preview .word {display:inline-block; width:7.05rem; border-bottom:solid .17rem #000; line-height:1; text-align:center;}
.cmt-box .preview p {display:inline-block; margin-top:1.45rem;}
.cmt-box .select-list {display:flex; flex-wrap:wrap; width:24.6rem; height:13.65rem; margin:2.35rem auto 0;}
.cmt-box .select-list li {flex-basis:33.33%;}
.cmt-box .select-list li input[type=radio] {width:1.28rem; height:1.28rem; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2019/99723/m/ico_select.png) no-repeat 50% 0; background-size:100% auto; border:none; border-radius:0;}
.cmt-box .select-list li input[type=radio]:checked {background-position:50% 100%;}
.cmt-box .select-list li input[type=radio] + label {position:relative; top:.2rem; display:inline-block; font-size:1.28rem; margin-left:.55rem;}
.cmt-box .select-list li:nth-child(10) {flex-basis:100%;}
.cmt-box .select-list li:nth-child(10) #own-word {width:6.83rem; height:1.51rem; margin-left:.6rem; padding:0; border:0; border-bottom:solid .085rem #000; border-radius:0; color:#000; font-weight:bold; text-align:center;}
.cmt-section .select-list #own-word::placeholder {color:#777; font-size:1.1rem; font-weight:bold;}
.cmt-section .select-list #own-word::-webkit-input-placeholder {color:#777; font-size:1.18rem; font-weight:bold;}
.cmt-box .btn-submit {display:block; width:100%; background-color:transparent; animation:moveX .8s 500 ease-in-out;}
.cmt-list-wrap .ranking {position:relative; padding:1.88rem 0 4.39rem; background-color:#f22728;}
.cmt-list-wrap .ranking > p {width:22.67%; position:absolute; top:1.88rem; left:2.77rem;}
.cmt-list-wrap .ranking ul {padding-left:49.86%; color:#fff; font-size:1.11rem;}
.cmt-list-wrap .ranking ul li {margin-bottom:1.02rem;}
.cmt-list-wrap .cmt-list {width:26.88rem; margin:-2.56rem auto 1.92rem; }
.cmt-list-wrap .cmt-list li {position:relative; width:100%; margin-bottom:1.28rem; padding:1.79rem 1.45rem; background-color:#fff100; font-size:1.19rem; text-align:right;}
.cmt-list-wrap .cmt-list li .writer {position:absolute; top:1.79rem; left:1.45rem; font-size:1.11rem;}
.cmt-list-wrap .cmt-list li .num {display:block; color:#f22728; font-size:.9rem;}
.cmt-list-wrap .cmt-list li .promise {font-size:1.28rem;}
.cmt-list-wrap .cmt-list li .promise .word {display:inline-block; min-width:7.04rem; margin-top:1.39rem; border-bottom:solid .17rem #000; text-align:center; line-height:1;}
.cmt-list-wrap .cmt-list li .promise p {display:inline-block;}
.cmt-list-wrap .cmt-list li .btn-delete {display:inline-block; position:absolute; top:-.55rem; right:-.55rem; width:1.66rem; height:1.66rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/91819/m/btn_delete.png) no-repeat 50% 50%; background-size:contain; text-indent:-999em;}
.cmt-section .pagingV15a {margin-bottom:2.56rem;}
.cmt-section .pagingV15a .arrow {position:relative; top:-.2rem;}
.noti {padding:2.56rem; background-color:#000; color:#fff; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.noti h4 {font-size:1.48rem;}
.noti ul {margin-top:.85rem;}
.noti li {padding-left:.94rem; font-size:1.1rem; line-height:1.57; text-indent:-.64rem;}
</style>
<script>
	var isapp = '<%=isapp%>'
	var eventCode = '<%=eCode%>'
</script>
			<div class="mEvt99723">
                <div class="top">
                    <div class="prj"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_prj.jpg" alt="Happy Together Project"></div>
                    <h2>
                        <span class="t t1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_1.png" alt="텐바이텐 X 오뚜기 "></span>
                        <span class="t t2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_2.png" alt="주인공은 나니까 "></span>
                        <span class="t t3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_3.png?v=1.01" alt="화끈하게 살자구요"></span>
                    </h2>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/bg_top.jpg" alt="">
                </div>
                <div class="section sc1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_sc1.jpg" alt="01 우리의 이야기"></div>
                <div class="section sc2">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/tit_sc2.jpg" alt="02 화끈팩 구성이 궁금하다면"></h3>
                    <div class="vod"><iframe src="https://www.youtube.com/embed/bsBGSGl7ywo" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen=""></iframe></div>
                    <div class="composition">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_sc2_v2.jpg" alt="화끈팩 구성 화끈팩 박스 열라면 5봉 열라면 핫팩 5개 화끈 스티커팩(6매) 화끈 포스터">
                        <% If isapp="1" Then %>
                            <a href="" onclick="TnGotoProduct('2605091');return false;">
                        <% Else %>
                            <a href="/category/category_itemPrd.asp?itemid=2605091">
                        <% End If %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/btn_get.png" alt="구매하기">
                        </a>
                    </div>
                    <span class="limited"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_limited.png" alt="한정수량"></span>
                </div>
                <!--<div class="section sc3">
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_sc3.jpg" alt="03 런칭 이벤트"></div>
                    <div class="gallery">
                        <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99723/m/txt_gallery.png" alt="깨알같은 디테일"></p>
                        <div class="thumb"></div>
                    </div>
                </div>-->
				<div id="app"></div>
                <div class="noti">
                    <h4>유의사항</h4>
                    <ul>
                        <li>- 텐바이텐X오뚜기 화끈팩은 로그인 후 구매 가능합니다.</li>
                        <li>- 텐바이텐X오뚜기 화끈팩은 한정 수량 판매로, 조기 품절이 될 수 있습니다.</li>
                        <li>- 오뚜기 젓가랏 사은품은 선착순 구매 완료 300명에게 제공되는 사은품입니다.</li>
                        <li>- 화끈 다짐 응모 이벤트는 당첨 상품은 추첨을 통해 당첨됩니다.</li>
                        <li>- 텐바이텐X오뚜기 화끈팩은 개봉 후 환불이 어려움을 알려드립니다.</li>
                    </ul>
                </div>
			</div>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<% IF application("Svr_Info") = "Dev" or debugMode = 1 THEN %>
<script src="https://unpkg.com/vue"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/event/etc/comment/99723/rolling-99723.js"></script>
<script src="/vue/event/comment/list/comment-paging.js"></script>
<script src="/vue/event/comment/list/comment-container.js?v=1.00"></script>
<script src="/event/etc/comment/99723/index-99723.js?v=1.00"></script>
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt58696 {background:#faf7f2;}
.mEvt58696 img {vertical-align:top;}
.mEvt58696 .preview dd {position:relative;}
.mEvt58696 .hhSwiper {position:absolute; left:7%; top:3%; width:86%; height:97%;}
.mEvt58696 .hhSwiper .swiper-slide a {display:none;}
.mEvt58696 .hhSwiper .hPagination {position:absolute; left:0; bottom:0; width:100%; z-index:40; text-align:center;}
.mEvt58696 .hhSwiper .hPagination span {display:inline-block; width:9px; height:9px; margin:0 5px; border-radius:50%; border:1px solid #5f5340; background:#fff; vertical-align:bottom;}
.mEvt58696 .hhSwiper .hPagination span.swiper-active-switch {background:#5f5340;}
.mEvt58696 .hhSwiper button {display:block; position:absolute; bottom:8.5%; width:12%; background:none; z-index:40;}
.mEvt58696 .hhSwiper .btnPrev {left:-3%;}
.mEvt58696 .hhSwiper .btnNext {right:-3%;}
.mEvt58696 .video dd {padding:0 4.5% 42px;}
.mEvt58696 .video dd .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.mEvt58696 .video dd .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
@media all and (min-width:480px){
        .mEvt58696 .hPagination span {width:14px; height:14px; margin:0 7px;}
        .mEvt58696 .video dd {padding:0 4.5% 63pX;}
}
</style>

<script type="text/javascript">
$(function(){
        showSwiper= new Swiper('.swiper',{
                loop:true,
                resizeReInit:true,
                calculateHeight:true,
                pagination:'.hPagination',
                paginationClickable:true,
                speed:300,
                autoplay:5000,
                autoplayDisableOnInteraction: true
        });
        $(window).on("orientationchange",function(){
                var oTm = setInterval(function () {
                showSwiper.reInit();
                clearInterval(oTm);
                }, 500);
        });
        $('.btnPrev').on('click', function(e){
                e.preventDefault()
                showSwiper.swipePrev()
        });

        $('.btnNext').on('click', function(e){
                e.preventDefault()
                showSwiper.swipeNext()
        });
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
        // 모바일 홈페이지 바로가기 링크 생성
        if(userAgent.match('iphone')) { //아이폰
                parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
        } else if(userAgent.match('ipad')) { //아이패드
                parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
        } else if(userAgent.match('ipod')) { //아이팟
                parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
        } else if(userAgent.match('android')) { //안드로이드 기기
                parent.document.location="market://details?id=kr.tenbyten.hitchhiker"
        } else { //그 외
                parent.document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.hitchhiker"
        }
};
</script>
<!-- #include virtual="/lib/inc/incHeader.asp" -->
<div class="mEvt58696">
        <h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/tit_hitchhiker.jpg" alt ="HITCHHIKER" /></h2>
        <p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/txt_about.gif" alt ="about HITCHHIKER - 텐바이텐 감성매거진 히치하이커는 격월간으로 발행되며, 매 호 다른 주제로 일상의 풍경을 담아냅니다.히치하이커가 소소한 즐거움, 작은 위로가 되길 바랍니다." /></p>
        <dl class="preview">
                <dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/tit_preview.gif" alt ="PREVIEW" /></dt>
                <dd>
                        <p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/bg_slide.gif" alt ="" /></p>
                        <div class="hhSwiper">
                                <div class="swiper-container swiper">
                                        <div class="swiper-wrapper">
                                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/img_slide01.png" alt="HITCHHIKER 소통으로 담아내는 감성매거진" /></div>
                                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/img_slide02.png" alt="" /></div>
                                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/img_slide03.png" alt="" /></div>
                                        </div>
                                </div>
                                <div class="hPagination"></div>
                                <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/btn_slide_prev.png" alt="" /></button>
                                <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/btn_slide_next.png" alt="" /></button>
                        </div>
                </dd>
        </dl>
        <dl class="video">
                <dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/tit_video.gif" alt ="VIDEO" /></dt>
                <dd>
                        <div class="youtube"><iframe src="http://www.youtube.com/embed/dvqUY5AXB78" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe></div>
                </dd>
        </dl>
        <p><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58696/btn_app_download.jpg" alt ="언제든 히치하이커를 만나보세요!" /></a></p>
</div>
<!-- #include virtual="/lib/inc/incFooter.asp" -->

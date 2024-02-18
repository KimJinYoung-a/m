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
' Description :
' History :
'####################################################

dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호

IF application("Svr_Info") = "Dev" THEN
    eCode = "109445"
End If

dim vAdrVer
dim debugMode

debugMode = request("debugMode")
vAdrVer = 1.0
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>

<style>
.mEvt116455 section{position:relative;}

.mEvt116455 .section01 .float01{width:27.3vw;position:absolute;right:0;top:54vw;animation: updown 1.5s 0s ease-in-out infinite alternate;}
.mEvt116455 .section01 .float02{width:23.7vw;position:absolute;left:2vw;top:121vw;animation: updown 1.8s 0s ease-in-out infinite alternate;}

.mEvt116455 .time_sale .main_time{padding:0 2.13rem;background:#fff;padding-bottom:3.29rem;}
.mEvt116455 .time_sale .main_time .prd_item .prd_date{overflow:hidden;}
.mEvt116455 .time_sale .main_time .prd_item .prd_date .date{padding-top:4.79rem;font-size:2.77rem;letter-spacing:-0.03em;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.mEvt116455 .time_sale .main_time .prd_item .prd_date .date span{margin-top:0.85rem;display:block;font-size:1.54rem;color:#6B6B6B;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; }
.mEvt116455 .time_sale .main_time .prd_item .prd_date .date span b{font-size:1.71rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.mEvt116455 .time_sale .main_time .prd_item .prd_date .time{margin-top:0.59rem;float:right;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:2.65rem;position:relative;}
.mEvt116455 .time_sale .main_time .prd_item .prd_date .time::after{content:'';display:block;background: #FF0D38;width:0.68rem;height:0.68rem;border-radius:50%;position:absolute;top:-0.8rem;right:0;animation: twinkle ease-in-out alternate;-webkit-animation: twinkle alternate .6s infinite;}
.mEvt116455 .time_sale .main_time .thumbnail{display:block;margin:1.71rem auto;}
.mEvt116455 .time_sale .main_time .prd_info .prd_name{font-size:1.4rem;width:26.45rem;margin:0 auto;letter-spacing:-0.03em;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116455 .time_sale .main_time .prd_info .prd_price{margin-left:0.64rem;margin-top:1.49rem;margin-bottom:1.93rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:1.79rem;}
.mEvt116455 .time_sale .main_time .prd_info .prd_price s{font-size:1.45rem;color:#8C8C8C;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt116455 .time_sale .main_time .prd_info .prd_price span{font-size:1.96rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#FF0D38;margin-left:0.84rem;}
.mEvt116455 .time_sale .main_time .prd_link{font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:1.45rem;text-align:center;color:#fff;background:#000;width:27.73rem;display:block;height:4.27rem;line-height:4.27rem;border-radius:2.5rem;}

.mEvt116455 .time_sale .sub_time{padding:3.41rem 0 2.13rem;background:#F8F3EB;}
.mEvt116455 .time_sale .sub_time .swiper-container{transform:translateX(2.13rem);}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide{margin-right:0.85rem;width:11.61rem;height:11.61rem;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer figure{position:relative;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer figure .mask{position:absolute;top:0;left:0;right:0;bottom:0;background:#000;opacity:0.2;display:block;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer .time_date{text-align:left;font-size:1.28rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';position:absolute;top:0.55rem;left:0.6rem;color:#fff;z-index:999;letter-spacing:-0.05em;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer .time_date span{font-size:1.71rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';display:block;letter-spacing:-0.05em;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer .more{width:1.62rem;height:1.62rem;position:absolute;right:0.43rem;bottom:0.43rem;z-index:999;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer.close .mask{background:#222;opacity:0.2;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer.close figure img{filter: grayscale(100%);}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer.close .more{display:none;}
.mEvt116455 .time_sale .sub_time .swiper-container .swiper-slide .layer.close .time_date{text-align:center;width:100%;font-size:1.71rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';position:absolute;top:3.93rem;left:0;color:#fff;z-index:999;}

.mEvt116455 section .prd_code{width:87.1vw;height:84.3vw;display:block;position:absolute;top:64vw;left:50%;transform: translateX(-50%);}
.mEvt116455 section .prd_area{padding:15vw 0 0;}
.mEvt116455 section .prd_area ul{display:flex;justify-content:space-evenly;flex-wrap: wrap;}
.mEvt116455 section .prd_area li{width:41.7vw;margin-bottom:10vw;}
.mEvt116455 section .prd_area li .desc .brand{margin-top:4vw;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';letter-spacing:-0.05em;font-size:0.9rem;}
.mEvt116455 section .prd_area li .desc .name{margin:1vw 0 3vw;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';letter-spacing:-0.05em;font-size:1.2rem;line-height:1.5em;}
.mEvt116455 section .prd_area li .desc .price s{display:block;margin-bottom:2vw;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#a0a79b;text-decoration: none;font-size:1.1rem;}
.mEvt116455 section .prd_area li .desc .price{font-size:1.3rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116455 section .prd_area li .desc .price span{margin-right:2vw;color:#ff1461;float:left;}
/*.mEvt116455 section .prd_area li .desc .price span{margin-right:2vw;color:#ff1461;float:left;}*/
.mEvt116455 section .btn_go{display:block;text-align:center;margin:10vw 0 20vw;}
.mEvt116455 section .btn_go img{width:76.9vw;}

.mEvt116455 .section06 .prd_code{width:87.1vw;height:54vw;display:block;position:absolute;top:48vw;left:50%;transform: translateX(-50%);}
.mEvt116455 .section06 .btn_go{width:74vw;height:17vw;display:block;position:absolute;bottom:22vw;left:50%;transform: translateX(-50%);margin:0;}
@keyframes updown{
    0% {transform: translateY(2vw);}
    100% {transform: translateY(-2vw);}
}

@keyframes twinkle {
	0%{opacity: 0;}
	100%{opacity: 1;}
}
</style>
<script>
$(function() {
  let today_num = new Date().getDay();
  let initialSlide = today_num > 0 ? today_num : 7;
	var mySwiper = new Swiper(".sub_time .swiper-container", {
		autoplay:false,
		speed:1200,
    loop:false,
    slidesPerView:'auto',
    initialSlide:initialSlide
	});
});
</script>

<div id="app"></div>

<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js" ></script>
<script>
    const eCode = '<%= eCode %>';
    function fnSearchEventText(stext){
        <% If flgDevice="A" Then %>
            fnAPPpopupSearch(stext);
        <% Else %>
            <% If vAdrVer>="2.24" Then %>
                fnAPPpopupSearchOnNormal(stext,"product");
            <% Else %>
                fnAPPpopupSearch(stext);
            <% End If %>
        <% End If %>
    }
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="https://unpkg.com/vue"></script>
    <script src="https://unpkg.com/vuex"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
    <script src="/vue/vuex.min.js"></script>
<% End If %>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.js"></script>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.min.js"></script>

<!-- Common Component -->
	<script src="/vue/components/common/functions/common.js?v=1.0"></script>
	<script src="/vue/components/common/wish.js?v=1.0"></script>
	<script src="/vue/components/common/sortbar.js?v=1.0"></script>
	<script src="/vue/components/common/tab_view_type.js?v=1.0"></script>
	<script src="/vue/components/common/item_module_header.js?v=1.0"></script>
	<script src="/vue/components/common/modal.js?v=1.0"></script>
	<script src="/vue/components/common/no_data.js?v=1.0"></script>
    <script src="/vue/components/common/btn_top.js?v=1.0"></script>
	<script src="/vue/components/common/functions/item_mixins.js?v=1.1"></script>
	<script src="/vue/components/common/functions/modal_mixins.js?v=1.0"></script>
	<script src="/vue/components/common/functions/common_mixins.js?v=1.0"></script>
<!-- //Common Component -->

<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript" src="/event/lib/countdown.js"></script>

<script src="/vue/event/etc/116455/index.js?v=1.01"></script>
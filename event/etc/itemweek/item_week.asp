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
    eCode = "109407"
End If

dim vAdrVer
dim debugMode

debugMode = request("debugMode")
vAdrVer = 1.0
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>

<style>
.item_week section{position:relative;}

.item_week section .push_wrap{position:relative;}
.item_week section .push_wrap .event-btn{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115376/m/btn_start.png)no-repeat 0 0;background-size:100%;position:absolute;bottom:1rem;right:10vw;width:29.3vw;height:15.6vw;}
.item_week section .push_wrap .event-btn.end{background:url(//webimage.10x10.co.kr/fixevent/event/2021/115376/m/btn_end.png)no-repeat 0 0;background-size:100%;}

.item_week .time_sale .main_time{padding:0 2.13rem;background:#fff;padding-bottom:3.29rem;}
.item_week .time_sale .main_time .prd_item .prd_date{overflow:hidden;}
.item_week .time_sale .main_time .prd_item .prd_date .date{padding-top:4.79rem;font-size:2.77rem;letter-spacing:-0.03em;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.item_week .time_sale .main_time .prd_item .prd_date .date span{margin-top:0.85rem;display:block;font-size:1.54rem;color:#6B6B6B;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; }
.item_week .time_sale .main_time .prd_item .prd_date .date span b{font-size:1.71rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; }
.item_week .time_sale .main_time .prd_item .prd_date .time{margin-top:0.59rem;float:right;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:2.65rem;position:relative;}
.item_week .time_sale .main_time .prd_item .prd_date .time::after{content:'';display:block;background: #FF0D38;width:0.68rem;height:0.68rem;border-radius:50%;position:absolute;top:-0.8rem;right:0;animation: twinkle ease-in-out alternate;-webkit-animation: twinkle alternate .6s infinite;}
.item_week .time_sale .main_time .thumbnail{display:block;margin:1.71rem auto;}
.item_week .time_sale .main_time .prd_info .prd_name{font-size:1.4rem;width:26.45rem;margin:0 auto;letter-spacing:-0.03em;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.item_week .time_sale .main_time .prd_info .prd_price{margin-left:0.64rem;margin-top:1.49rem;margin-bottom:1.93rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:1.79rem;}
.item_week .time_sale .main_time .prd_info .prd_price s{font-size:1.45rem;color:#8C8C8C;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.item_week .time_sale .main_time .prd_info .prd_price span{font-size:1.96rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';color:#FF0D38;margin-left:0.84rem;}
.item_week .time_sale .main_time .prd_link{font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-size:1.45rem;text-align:center;color:#fff;background:#000;width:27.73rem;display:block;height:4.27rem;line-height:4.27rem;border-radius:2.5rem;}

.item_week .time_sale .sub_time{padding:3.41rem 0 2.13rem;background:#F8F3EB;}
.item_week .time_sale .sub_time .swiper-container{transform:translateX(2.13rem);}
.item_week .time_sale .sub_time .swiper-container .swiper-slide{margin-right:0.85rem;width:11.61rem;height:11.61rem;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer figure{position:relative;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer figure .mask{position:absolute;top:0;left:0;right:0;bottom:0;background:#000;opacity:0.2;display:block;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer .time_date{text-align:left;font-size:1.28rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';position:absolute;top:0.55rem;left:0.6rem;color:#fff;z-index:999;letter-spacing:-0.05em;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer .time_date span{font-size:1.71rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';display:block;letter-spacing:-0.05em;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer .more{width:1.62rem;height:1.62rem;position:absolute;right:0.43rem;bottom:0.43rem;z-index:999;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer.close .mask{background:#222;opacity:0.2;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer.close figure img{filter: grayscale(100%);}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer.close .more{display:none;}
.item_week .time_sale .sub_time .swiper-container .swiper-slide .layer.close .time_date{text-align:center;width:100%;font-size:1.71rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';position:absolute;top:3.93rem;left:0;color:#fff;z-index:999;}


.item_week .section05 .main{position:relative;}
.item_week .section05 .main .hashtag{position:absolute;top:17rem;left:50%;transform:translateX(-50%);width:fit-content;}
.item_week .section05 .item01 .main .hashtag{position:absolute;top:19rem;left:50%;transform:translateX(-50%);width:fit-content;}
.item_week .section05 .main .hashtag .hash{float:left;margin:0 1vw;}
.item_week .section05 .main .hashtag .hash a{background-color:#ffff00;color:#000;padding:0.5rem 0.9rem 0.3rem;border-radius: 1rem;font-size:1.2rem;line-height:1.2rem;font-weight:600;}
.item_week .section05 .main .purchase{width:88vw;height:5rem;display:block;position:absolute;bottom:6rem;left:50%;margin-left:-44vw;}

.item_week .pop-container { display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.6); z-index:150;}
.item_week .pop-container .pop-inner { width:100%; height:100%; padding:8.47rem 1.7rem 4.17rem; overflow-y: scroll;}
.item_week .pop-contents {position:relative;}
.item_week .pop-contents .btn-close {width:16%; height:28%; position:absolute; top:0; left:50%; margin-left:34%; text-indent:-9999px; background:transparent;}
.item_week .pop-contents .btn-push {width:70%; height:24%; position:absolute; bottom:15%; left:50%; margin-left:-35%;  text-indent:-9999px; background:transparent;}

@keyframes twinkle {
	0%{opacity: 0;}
	100%{opacity: 1;}
}
</style>
<script>
$(function() {
	var mySwiper = new Swiper(".sub_time .swiper-container", {
		autoplay:false,
		speed:1200,
        loop:false,
        slidesPerView:'auto'
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
    <script src="/vue/vue_dev.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
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

<script src="/vue/event/etc/itemweek/jsonData.js?v=1.00"></script>
<script>
    const event_data = event_<%= eCode %>;
</script>
<script src="/vue/event/etc/itemweek/index.js?v=1.01"></script>
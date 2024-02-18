<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 누구나 가슴속에 여행을 품고 산다 이벤트
' History : 2021.08.03 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "108385"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "113211"
    mktTest = True
Else
	eCode = "113211"
    mktTest = False
End If

eventStartDate  = cdate("2021-08-04")		'이벤트 시작일
eventEndDate 	= cdate("2021-08-17")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-04")
else
    currentDate = date()
end if
%>
<style>
.evt113211 .topic {position:relative;}
.evt113211 .topic .parasol-thumb {width:47.60vw; height:40.80vw; position:absolute; left:50%; top:31%; transform:translate(-50%,0);}
.evt113211 .topic .parasol-thumb img {width:100%; height:100%;}
.evt113211 .slide-area {padding:2.13rem 0; background:#62c6f8;}
.evt113211 .slide-area .swiper-slide {width:30.80vw; margin:0 1.62rem;}
.evt113211 .pouch-area {position:relative;}
.evt113211 .pouch-area .item01 {width:24.27vw; position:absolute; left:20%; top:2%; animation:show 1s infinite alternate;}
.evt113211 .pouch-area .item02 {width:41.73vw; position:absolute; left:52%; top:13%; animation:show 1s .3s infinite alternate;}
.evt113211 .pouch-area .item03 {width:38.53vw; position:absolute; left:4%; top:32%; animation:show 1s .5s infinite alternate;}
.evt113211 .pouch-area .item04 {width:38.80vw; position:absolute; left:49%; top:41%; animation:show 1s .2s infinite alternate;}
.evt113211 .basket-price {padding-bottom:2.77rem; background:#ffa025;}
.evt113211 .basket-price .name {color:#272420; font-size:1.62rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; text-align:center;}
.evt113211 .basket-price .name span {text-decoration:underline;}
.evt113211 .basket-price .txt {padding-top:0.94rem; color:#272420; font-size:1.19rem; text-align:center;}
.evt113211 .basket-price .price {width: calc(100% - 8.26rem); height:5.76rem; line-height:5.76rem; margin:1.28rem auto 0; padding-right:1.28rem; font-size:2.56rem; color:#787878; text-align:right; background:#fff; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.evt113211 .basket-price .price span {padding-left:0.38rem; font-size:1.36rem;}
.evt113211 .btn-detail {position:relative;}
.evt113211 .btn-detail .icon {width:0.93rem; height:0.59rem; position:absolute; left:50%; top:20%; margin-left:5.3rem;}
.evt113211 .noti {display:none;}
.evt113211 .noti.on {display:block;}
.evt113211 .icon.on {transform: rotate(180deg);}
.evt113211 .icon {transform: rotate(0);}
.evt113211 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.evt113211 .pop-container .pop-contents {position:relative;}
.evt113211 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.evt113211 .pop-container .pop-inner a {display:inline-block;}
.evt113211 .pop-container .contents-inner {position:relative;}
.evt113211 .pop-container .contents-inner .tit {position:absolute; left:50%; top:14%; line-height:1.5; text-align:center; transform:translate(-50%,0); font-size:1.70rem; color:#272420; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.evt113211 .pop-container .contents-inner .tit span {text-decoration:underline;}
.evt113211 .pop-container .contents-inner .btn-kakao {width:100%; height:12rem; position:absolute; left:0; bottom:0; background:transparent;}
.evt113211 .pop-container .pop-inner .btn-close {position:absolute; right:1.73rem; top:1.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
@keyframes show {
    0% {opacity:0;}
    100% {opacity:1;}
}
</style>
<script>
$(function(){
	// changing img
	(function changingImg(){
		var i=1;
		var repeat = setInterval(function(){
			i++;
			if(i>3){i=1;}
			$('.evt113211 .topic .parasol-thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_item0'+ i +'.png?v=4.1');
		},260);
	})();
    // slide
    var swiper1 = new Swiper('.swiper-container', {
		loop: true,
		speed: 1000,
		autoplay:1,
        centeredSlides:true,
        slidesPerView:'auto',
	});
	// btn more
	$('.evt113211 .btn-detail').click(function (e) { 
		$(this).next().toggleClass('on');
        $(this).find('.icon').toggleClass('on');
	});
});
</script>
            <div class="evt113211">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_tit.jpg?v=3" alt="여행을 품고산다"></h2>
                    <div class="parasol-thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_item01.png?v=4.1" alt=""></div>
				</div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub.jpg" alt="">
                <!-- slide 영역 -->
                <div class="slide-area">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide01.png" alt="slide01">
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide02.png" alt="slide02">
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide03.png" alt="slide03">
                            </div>
                        </div>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub01.jpg" alt="">
                <div class="pouch-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub02.jpg" alt="">
                    <div class="item01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd01.png" alt=""></div>
                    <div class="item02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd02.png" alt=""></div>
                    <div class="item03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd03.png" alt=""></div>
                    <div class="item04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd04.png" alt=""></div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub03_app.jpg" alt="">
                <!-- 장바구니 금액 -->
                <div class="basket-price">
                    <a href="/inipay/ShoppingBag.asp">
                        <% if IsUserLoginOK() then %>
                        <p class="name"><span><%=GetLoginUserName()%></span>님의 장바구니 금액</p>
                        <div class="price"><%= FormatNumber(getCartTotalAmount(LoginUserid), 0) %><span>원</span></div>
                        <p class="txt">*위 금액은 품절 상품 및 배송비를 제외한 금액입니다.</p>
                        <% else %>
                        <p class="name"><span>고객</span>님의 장바구니 금액</p>
                        <div class="price">100,000<span>원</span></div>
                        <p class="txt">*로그인 후 확인하세요</p>
                        <% end if %>
                    </a>
                </div>
                <a href="https://tenten.app.link/k7onUCwbhib?%24deeplink_no_attribution=true" class="btn-win"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_apply.jpg" alt="app에서 바로 응모하기"></a>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub04.jpg" alt="">
                <button type="button" class="btn-detail">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_txt01.jpg" alt="">
                    <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_arrow.png" alt=""></span>
                </button>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_txt01.jpg" alt=""></div>
                <button type="button" class="btn-detail">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_txt02.jpg" alt="">
                    <span class="icon" style="top:35%;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_arrow.png" alt=""></span>
                </button>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_txt02.jpg" alt=""></div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub05.jpg" alt="">
                <a href="/event/eventmain.asp?eventid=112115" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_link.jpg" alt=""></a>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
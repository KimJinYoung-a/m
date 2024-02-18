<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 나만의 여름별장 이벤트
' History : 2021-06-28 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate, mktTest
IF application("Svr_Info") = "Dev" THEN
	eCode = "108373"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "112407"
    mktTest = true
Else
	eCode = "112407"
    mktTest = false
End If

eventStartDate = cdate("2021-06-30")	'이벤트 시작일
eventEndDate = cdate("2021-07-11")		'이벤트 종료일
if mktTest then
currentDate = cdate("2021-06-30")
else
currentDate = date()
end if

userid = GetEncLoginUserID()
%>
<style>
.mEvt112407 {position:relative; overflow:hidden; background:#fff;}
.mEvt112407 .topic {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2021/112407/m/bg_main.gif) no-repeat 0 0; background-size:100%;}
.mEvt112407 .topic .icon-float {width:31.33vw; position:absolute; right:.8rem; top:89%; z-index:10;}
.mEvt112407 .topic .icon-float.fixed {position:fixed; top:10%; animation: updown 1s linear alternate infinite;}
.mEvt112407 .topic .icon-float.hide {display:none;}
.mEvt112407 .topic .icon-float a {display:inline-block; width:100%; height:100%;}
.mEvt112407 .section-01 {position:relative;}
.mEvt112407 .section-01 .icon-01 {position:absolute; right:-2%; top:-3%; width:17.33vw;}
.mEvt112407 .section-01 .icon-02 {position:absolute; left:7%; bottom:-9%; width:13.60vw; z-index:10;}
.mEvt112407 .section-02 {position:relative;}
.mEvt112407 .section-02 .item01 {position:absolute; left:52%; top:65%; width:100%; height:100%;}
.mEvt112407 .section-02 .item01 .inner {position:relative;}
.mEvt112407 .section-02 .item-sum01 {position:absolute; left:0; top:0; width:48vw;}
.mEvt112407 .section-02 .item-sum02 {position:absolute; left:-10%; top:-3rem; width:55.87vw; animation:fade 1s linear alternate infinite;}
.mEvt112407 .item02 {position:relative;}
.mEvt112407 .item02 .item-01 {position:absolute; left:-0.5rem; top:24%; width:19.07vw; animation:fade 1s alternate infinite;} 
.mEvt112407 .item02 .item-02 {position:absolute; left:33%; top:24%; width:19.07vw; animation:fade 1s .5s alternate infinite;}
.mEvt112407 .item02 .item-03 {position:absolute; left:16%; top:39%; width:19.07vw; animation:fade 1s .3s alternate infinite;}
.mEvt112407 .item02 .item-04 {position:absolute; right:11.3%; top:16.5%; width:11.20vw; animation:turn 5s linear infinite;}
.mEvt112407 .area-apply {position:relative;}
.mEvt112407 .area-apply .btn-apply {width:100%; height:10rem; position:absolute; left:0; top:10%; background:transparent;}
.mEvt112407 .btn-detail {position:relative;}
.mEvt112407 .btn-detail span {position:absolute; right:32%; top:.5rem; width:3.07vw; height:1.87vw; margin-right:-1.53vw; transform: rotate(180deg);}
.mEvt112407 .btn-detail.noti span {right:28%; top:3rem;}
.mEvt112407 .detail-info {display:none;}
.mEvt112407 .detail-info.on {display:block;}
.mEvt112407 .link-list-area {padding-top:3.87rem; background:#3b7bff;}
.mEvt112407 .basket-price {padding:0 4.69rem; background:#3b7bff;}
.mEvt112407 .basket-price .name {height:3.82rem; line-height:3.82rem; font-size:1.52rem; letter-spacing:-0.04rem; background:#fffc00; color:#3b7bff; text-align:center;}
.mEvt112407 .basket-price .name span {text-decoration-color: #3b7bff; text-decoration: underline;}
.mEvt112407 .basket-price .price {height:5.17rem; line-height:5.17rem; font-size:2.82rem; letter-spacing:-0.04rem; background:#fff; color:#282828; text-align:right; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt112407 .basket-price .price span {padding-left:0.43rem; padding-right:1.82rem; font-size:1.34rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112407 .basket-price a {display:inline-block; width:100%; height:100%;}
.mEvt112407 .link-list-area {position:relative;}
.mEvt112407 .link-list-area .link {position:absolute; left:0; top:23%; width:100%;}
.mEvt112407 .link-list-area a {display:inline-block; width:100%; height:13rem;}
.mEvt112407 .basket-price {padding:0 4.69rem; background:#3b7bff;}
.mEvt112407 .basket-price .name {height:3.82rem; line-height:3.82rem; font-size:1.52rem; letter-spacing:-0.04rem; background:#fffc00; color:#3b7bff; text-align:center;}
.mEvt112407 .basket-price .name span {text-decoration-color: #3b7bff; text-decoration: underline;}
.mEvt112407 .basket-price .price {height:5.17rem; line-height:5.17rem; font-size:2.82rem; letter-spacing:-0.04rem; background:#fff; color:#282828; text-align:right; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt112407 .basket-price .price span {padding-left:0.43rem; padding-right:1.82rem; font-size:1.34rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112407 .animate {opacity:0; transform:translateY(15%); transition:all 1s;}
.mEvt112407 .animate.on {opacity:1; transform:translateY(0);}

.mEvt112407 .swiper-container {padding:2rem 0;}
.mEvt112407 .swiper-wrapper {display:flex; align-items:center;}
.mEvt112407 .swiper-slide {width:20.61rem !important; margin:0 1.5rem; transition:1s;}
.mEvt112407 .swiper-slide.swiper-slide-active {transform: scale(1.1);}
.mEvt112407 .swiper-button-prev {position:absolute; left:4%; top:42%; width:6.27vw; height:14.80vw; font-size:0; background:transparent; z-index:10;}
.mEvt112407 .swiper-button-next {position:absolute; right:4%; top:42%; width:6.27vw; height:14.80vw; font-size:0; background:transparent; z-index:10;}
.mEvt112407 .bg-ff {height:3rem; background:#fff;}
@keyframes fade {
    0% {opacity:0;}
    100% {opacity:1;}
}
@keyframes turn {
    0% {transform: rotate(0);}
    100% {transform: rotate(360deg);}
}
@keyframes updown {
    0% {transform:translateY(-1rem);}
    100% {transform:translateY(1rem);}
}
</style>
<script>
$(function() {
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
        var height = $(document).scrollTop();
        var topsec = $('.section-01').offset().top;
        var bottomsec = $('.link-list-area').offset().top;
        if(height > topsec){ 
            $('.icon-float').addClass('fixed'); 
        }else { 
            $('.icon-float').removeClass('fixed'); 
        }

        if(height > bottomsec){
            $('.icon-float').addClass('hide'); 
        }else { 
            $('.icon-float').removeClass('hide'); 
        }
    });
    var swiper1 = new Swiper('.swiper-container', {
		loop: true,
		speed: 1000,
		autoplay: 2500,
        centeredSlides:true,
        slidesPerView:'auto',
        prevButton:'.swiper-button-prev',
		nextButton:'.swiper-button-next'
	});
    $('.btn-detail').on('click',function(){
        if($(this).next('.detail-info').hasClass('on')) {
            $(this).next('.detail-info').removeClass('on');
            $(this).children('.arrow').css('transform','rotate(180deg)');
        } else {
            $(this).next('.detail-info').removeClass('on');
            $(this).next('.detail-info').addClass('on');
            $(this).children('.arrow').css('transform','rotate(0)');
        }
    });
});
</script>
			<div class="mEvt112407">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/tit_main.png?V=2" alt="나만의 여름별장">
                    <div class="icon-float">
                        <a href="https://tenten.app.link/V5zPA77Jmhb?%24deeplink_no_attribution=true">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112406/m/icon_float.png" alt="app에서 응모하기">
                        </a>
                    </div>
				</div>
				<div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_sub01.jpg" alt="나만의 여름별장 을 찾아보는 건 어떨가요?">
                    <div class="icon-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower01.png" alt="꽃"></div>
                    <div class="icon-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower02.png" alt="꽃"></div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house01.jpg" alt="summer house" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house02.jpg" alt="summer house" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house03.jpg" alt="summer house" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house05.jpg" alt="summer house" class="animate">
                    <div class="item01">
                        <div class="inner">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house04.png" alt="" class="item-sum01 animate">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/txt_house.png" alt="my own summer house" class="item-sum02 animate">
                        </div>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/tit_sub01.jpg" alt="온전히 나를 위한 시간을 보낼 수 있는 곳이라면 어디든 나만의 여름 별장이 될 수 있어요!" class="animate">
                <!-- slide area -->
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_slide01.png" alt="slide01">
                        </div>
                        <div class="swiper-slide">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_slide02.png" alt="slide02">
                        </div>
                        <div class="swiper-slide">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_slide03.png" alt="slide03">
                        </div>
                        <div class="swiper-slide">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_slide04.png" alt="slide04">
                        </div>
                    </div>
                    <div class="swiper-button-prev"><img src='//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_arrow_left.png' alt='left'></div>
                    <div class="swiper-button-next"><img src='//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_arrow_right.png' alt='right'></div>
                </div>
                <div class="item02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_house06.jpg" alt="" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower03.png" alt="flower" class="item-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower03.png" alt="flower" class="item-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower04.png" alt="flower" class="item-03">
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/tit_sub02.jpg" alt="어느덧 반년이라는 시간을 열심히 달려온 나에게 달콥한 시간을 선물하세요." class="animate">
                <div class="item02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_sub02.jpg" alt="" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_flower05.png" alt="flower" class="item-04">
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/tit_sub03.jpg" alt="당신의 이번 여름 별장은 어디인가요?">
                <div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112406/m/img_m_event01.jpg" alt="여름별장을 꿈꾸는 당신에게 30만원의 지원금을 드립니다.">
                    
                    <div class="basket-price">
                        <a href="/inipay/ShoppingBag.asp">
                            <% if IsUserLoginOK() then %>
                            <div class="name">
                                <span><%=GetLoginUserName()%></span>님의 장바구니 금액
                            </div>
                            <div class="price">
                                <%= FormatNumber(getCartTotalAmount(userid), 0) %><span>원</span>
                            </div>
                            <% else %>
                            <div class="name">
                                로그인하고 응모하기
                            </div>
                            <div class="price">
                                300,000<span>원</span>
                            </div>
                            <% end if %>
                        </a>
                    </div>

                    <% if IsUserLoginOK() then %>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112406/m/img_info_login.jpg" alt="위 금액은 품절 상품 및 배송비를 제외한 금액입니다.">
                    <% else %>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112406/m/img_info_logout.jpg" alt="로그인 후 확인하세요.">
                    <% end if %>
                    <button type="button" class="btn-detail">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/btn_detail01.jpg" alt="응모방법 자세히 보기">
                        <span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_arrow.png" alt="화살표"></span>
                    </button>
                    <div class="detail-info">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/btn_detail01_info.jpg" alt="응모방법">
                    </div>
                    <button type="button" class="btn-detail noti">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/btn_detail02.jpg" alt="응모방법 자세히 보기">
                        <span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/icon_arrow.png" alt="화살표"></span>
                    </button>
                    <div class="detail-info">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/btn_detail02_info.jpg?v=2" alt="응모방법">
                    </div>
                    <div class="link-list-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112407/m/img_link_list02.jpg" alt="재미난 여름을 보내는 방법">
                        <div class="link">
                            <a href="#group372064"></a>
                            <a href="#group372065"></a>
                            <a href="#group372066"></a>
                            <a href="#group372067"></a>
                            <a href="/event/eventmain.asp?eventid=112115" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112115');return false;"></a>
                        </div>
                    </div>
                    <div class="bg-ff"></div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
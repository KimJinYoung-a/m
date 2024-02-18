<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  2022 굿노트 다이어리 무료 배포
' History : 2021.11.29 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim eCode, vUserID, cMil, vMileValue, vMileArr
dim eventStartDate, eventEndDate, currentDate, mktTest
vUserID = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
    mktTest = True
    eCode = "109424"
ElseIf application("Svr_Info")="staging" Then
    mktTest = True
    eCode = "115698"
Else
    mktTest = False
    eCode = "115698"
End If

eventStartDate  = cdate("2021-11-30")		'이벤트 시작일
eventEndDate 	= cdate("2021-12-31")		'이벤트 종료일

if mktTest then
currentDate = cdate("2021-11-30")
else
currentDate = date()
end if

%>
<style>
.mEvt115698 {position:relative;}
.mEvt115698 .topic {position:relative;}
.mEvt115698 .topic h2 {width:26.92rem; position:absolute; left:50%; top:14rem; margin-left:-13.45rem; opacity:0; transform:translateY(-50%); transition:all 1s;}
.mEvt115698 .topic .img01 {width:7.47rem; position:absolute; right:2rem; top:4.2rem; z-index:5; opacity:0; transform:translateY(-50%); transition:all 1s;}
.mEvt115698 .topic .img02 {width:20.40rem; position:absolute; left:50%; top:38rem; opacity:0; margin-left:-10.20rem; transform:translateY(-50%); transition:all 1s .7s;}
.mEvt115698 .topic .img03 {width:23.60rem; position:absolute; left:50%; top:58rem; margin-left:-11.30rem;}
.mEvt115698 .topic .img04 {width:27.78rem; position:absolute; left:50%; top:95rem; margin-left:-13.35rem;}
.mEvt115698 .topic .img05 {width:26.97rem; position:absolute; left:50%; top:125rem; margin-left:-13.45rem;}
.mEvt115698 .topic h2.on,
.mEvt115698 .topic .img01.on,
.mEvt115698 .topic .img02.on {opacity:1; transform:translateY(0);}
.mEvt115698 .animate {opacity:0; transform:translateY(-5rem); transition:all 1s;}
.mEvt115698 .animate.on {opacity:1; transform:translateY(0);}
.mEvt115698 .bnr-area a {display:inline-block;}
.mEvt115698 .bnr-float {z-index:10;}
.mEvt115698 .bnr-float .bnr-area {position:relative;}
.mEvt115698 .bnr-close {width:2.56rem; height:2.56rem; position:absolute; right:1.5rem; top:0.7rem; text-indent:-9999px; background:transparent;}
.mEvt115698 .slide-area {background:#fff;}
.mEvt115698 .slider .slick-prev {width:1.28rem; height:2.77rem; left:1rem; top:16rem; background:url('//webimage.10x10.co.kr/fixevent/event/2021/115698/m/icon_arr_left.png')no-repeat 0 0; background-size:100%; z-index:10;}
.mEvt115698 .slider .slick-next {width:1.28rem; height:2.77rem; right:1rem; top:16rem; background:url('//webimage.10x10.co.kr/fixevent/event/2021/115698/m/icon_arr_right.png')no-repeat 0 0; background-size:100%; z-index:10;}
.mEvt115698 .slider .slick-prev::before,
.mEvt115698 .slider .slick-next::before {content:"";}
.mEvt115698 .coupon-area {position:relative;}
.mEvt115698 .coupon-area .btn-coupon {display:inline-block; position:absolute; left:0; bottom:9rem; width:100%; height:7rem; text-indent:-9999px;}
.mEvt115698 .event-area {position:relative;}
.mEvt115698 .event-area .txt {position:absolute; left:4.5rem; top:35.1rem; width:8.96rem; height:2.13rem; animation:twing 1s infinite alternate;}
@keyframes twing {
    0% {opacity:0;}
    100% {opacity:1;}
}
.mEvt115698 .link-area {position:relative;}
.mEvt115698 .link-area .link01 {display:inline-block; width:100%; height:14rem; position:absolute; left:0; top:4rem;}
.mEvt115698 .link-area .link02 {display:inline-block; width:100%; height:14rem; position:absolute; left:0; top:18rem;}
.mEvt115698 .bnr-float.fixed {position:fixed; left:0; top:0;}
.mEvt115698 .bnr-float.hides {display:none;}
.mEvt115698 .download.hides {display:none;}
.mEvt115698 .download {position:fixed; left:0; bottom:0; width:100%; display:flex; align-items:center; flex-wrap:nowrap; padding:0.77rem 2.13rem 0; padding-bottom:calc(constant(safe-area-inset-bottom) + 0.77rem); padding-bottom:calc(env(safe-area-inset-bottom) + 0.77rem); background:#f8f8f8;}
.mEvt115698 .download .btn-download {width:100%; height:3.71rem; background:#e94543; color:#fff; font-size:1.32rem; text-align:center;}
.mEvt115698 .download .btn-share {width:2.05rem; height:2.39rem; margin-left:1.45rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/115698/m/icon_share.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
</style>
<script>
$(function() {
    $('.topic h2,.topic .img01,.topic .img02').addClass('on');
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.animate').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slick slider */
    $('.slide-area .slider').slick({
        slidesToShow:1,
        slidesToScroll:1,
        autoplay: true,
        autoplaySpeed: 1700,
        speed:800,
        dots: false,
        variableWidth:false,
        pauseOnFocus: false,
        pauseOnHover:false,
    });
    /* 배너 닫기 */
    $('.bnr-close').on('click',function(){
        $('.bnr-area').css('width',0);
    });
    /* top 버튼 위치 잡기 */
    $('.btn-top').css('bottom','calc(6.57rem + env(safe-area-inset-bottom))');
    var didScroll; 
    // 스크롤시에 사용자가 스크롤했다는 것을 알림 
    $(window).scroll(function(event){ 
        didScroll = true;
    }); // hasScrolled()를 실행하고 didScroll 상태를 재설정 
    setInterval(function() { 
        if (didScroll) 
        { hasScrolled(); didScroll = false; }
    }, 250);
    
    function hasScrolled() { // 동작을 구현 
        var lastScrollTop = 0; 
        var bnrStart = $('.bnr-float').offset().top; // 동작의 구현이 시작되는 위치
        var bnrEnd = $('.link-area').offset().top; // 동작의 구현이 끝나는 위치
        var downEnd = $('.link-area').offset().top - $('.link-area').outerHeight();
        var deadline = $('.deadline').offset().top;
        var header = $('#header').height(); // 영향을 받을 요소를 선택

        // 접근하기 쉽게 현재 스크롤의 위치를 저장한다. 
        var st = $(this).scrollTop();
        if (st >= 100){
            $('.bnr-float').addClass('fixed').css('top',header);
        } else {
            $('.bnr-float').removeClass('fixed');
        }

        if (st >= deadline){
            $('.bnr-float').removeClass('fixed');
        }

        if(st > bnrEnd){
            $('.bnr-float').addClass('hides');
        }else { 
            $('.bnr-float').removeClass('hides'); 
        }
        if(st > downEnd) {
            $('.download').addClass('hides');
        } else {
            $('.download').removeClass('hides'); 
        }
    }
});
function fnAPPSNSLayerOpen(){
	parent.fnAPPRCVpopSNS();
    fnAmplitudeEventMultiPropertiesAction('goodnote_event_share','evtcode','<%=eCode%>');
	return false;
}

function fnDownloadFile(){
	<% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
		return false;
	<% else %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript115698.asp",
            data: {
                mode: 'down'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('goodnote_event_download','evtcode','<%=eCode%>');
                }else if(data.response == "err"){
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
        fileDownload(5218);
    <% end if %>
}
function fnCouponBookMove(){
    fnAmplitudeEventMultiPropertiesAction('goodnote_event_coupon','evtcode','<%=eCode%>');
    <% if isApp="1" then %>
        fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=3');
    <% else %>
        location.href="/my10x10/couponbook.asp?tab=3";
    <% end if %>
    return false;
}
</script>
			<div class="mEvt115698">
                <div class="bnr-float">
                    <div class="bnr-area">
                        <a href="" onclick="fnCouponBookMove();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_bnr.png" alt="전 상품 4,000원 할인쿠폰 받기"></a>
                        <button type="button" class="bnr-close">닫기</button>
                    </div>
                </div>
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_main.jpg" alt="텐바이텐 굿즈 무료 배포">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/txt_main01.png" alt="2022 굿노트 다이어리"></h2>
                    <div class="img01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_stemp.png" alt="logo"></div>
                    <div class="img02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/txt_main02.png" alt="스티커도 있어요!"></div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_main02.jpg" alt="background">
                    <div class="img03 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/txt_main03.png" alt="알찬 구성의 2022 다이어리 템플릿! 지금부터 무료로 배포합니다."></div>
                    <div class="img04 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_diary.png" alt="2022 다이어리 템플릿!"></div>
                    <div class="img05 animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/txt_main04.png" alt="diary sticker"></div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_sub01.jpg" alt="다이어리 템플리 구성 한눈에 보기">
                <div class="slide-area">
                    <div class="slider">
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide01.png" alt="월간(만년형)"></div>
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide02.png" alt="주간(만년형)"></div>
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide03.png" alt="그림일기"></div>
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide04.png" alt="프리노트"></div>
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide05.png" alt="2022키워드"></div>
                        <div class="slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_slide06.png" alt="프로필"></div>
                    </div>
                </div>
                <div class="coupon-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_sub02.jpg" alt="다꾸러라면 깜짝 혜택!">
                    <a href="" onclick="fnCouponBookMove();return false;" class="btn-coupon">쿠폰 확인하기</a>
                </div>
                <div class="event-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_sub03.jpg" alt="인스타그램 디엠 이벤트">
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/txt_point.png" alt="텐바이텐 공식 계정!"></div>
                </div>
                <div class="link-area deadline">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/115698/m/img_bnr.jpg" alt="타블렛 100% 활용하는 법 / 텐바이텐이 처음이라면!">
                    <!-- 타블렛 100% 활용하는 법 -->
                    <a href="/event/eventmain.asp?eventid=114397" class="mWeb link01"></a>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=114397');return false;" class="mApp link01"></a>
                    <!-- 텐바이텐이 처음이라면 -->
                    <a href="https://m.10x10.co.kr/event/benefit/index.asp" class="mWeb link02"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('혜택 가이드','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/index.asp');return false;" class="mApp link02"></a>
                </div>
                <div class="download">
                    <button type="button" class="btn-download" onclick="fnDownloadFile();return false;">다운로드 받기</button>
                    <% if isApp then %>
                    <button type="button" class="btn-share" onclick="fnAPPSNSLayerOpen();return false;">공유하기</button>
                    <% end if %>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
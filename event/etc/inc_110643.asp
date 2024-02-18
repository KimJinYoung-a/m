<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 서촌도감05 - 텐바이텐X커피한잔
' History : 2021.04.22 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currentDate, eventStartDate, eventEndDate
dim eCode, userid, mktTest, subscriptcount

IF application("Svr_Info") = "Dev" THEN
	eCode = "105350"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110643"
    mktTest = true    
Else
	eCode = "110643"
    mktTest = false
End If

if mktTest then
    currentDate = #04/23/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-04-23")		'이벤트 시작일
eventEndDate = cdate("2021-05-06")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), 2, "")
end if
%>
<style>
.mEvt110643 {background:#fff;}
.mEvt110643 .topic {position:relative;}
.mEvt110643 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt110643 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt110643 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt110643 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}
.mEvt110643 .section-01 {position:relative;}
.mEvt110643 .section-01 .swiper-slide {width:100%;}
.mEvt110643 .section-01 .tit {opacity:0; transform:translateY(10%); transition:all 1s;}
.mEvt110643 .section-01 .tit.on {opacity:1; transform:translateY(0);}
.mEvt110643 .section-02 {position:relative;}
.mEvt110643 .section-03 {position:relative;}
.mEvt110643 .section-03 .link {display:inline-block; width:100%; height:9rem; position:absolute; left:0; top:44%; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt110643 .section-04 {position:relative;}
.mEvt110643 .section-04 .event-sec {position:relative;}
.mEvt110643 .section-04 .event-sec .btn-grp {display:flex; flex-wrap:wrap; align-items:flex-start; justify-content:flex-start; width:100%; position:absolute; left:0; top:16%;}
.mEvt110643 .section-04 .event-sec .btn-grp button {position:relative; display:inline-block; width:50%; height:16rem; margin-bottom:1rem; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt110643 .section-04 .event-sec .btn-grp button::before {content:""; position:absolute; left:13%; top:10%; display:inline-block; width:10vw; height:9.60vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109897/m/icon_check.png) no-repeat 0 0; background-size:100%; opacity:0;}
.mEvt110643 .section-04 .event-sec .btn-grp button.on::before {opacity:1;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(1):before {left:45%; top:8%;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(2):before {left:32%; top:8%;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(3):before {left:44%; top:2%;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(4):before {left:33%; top:2%;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(5)::before {left:14%; top:39%;}
.mEvt110643 .section-04 .event-sec .btn-grp button:nth-child(5) {width:100%; height:10rem;}
.mEvt110643 .section-04 .btn-apply {position:absolute; left:0; bottom:5%; width:100%; height:7rem; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt110643 .section-04 .event-tit {position:relative;}
.mEvt110643 .section-04 .event-tit .btn-benefit {position:absolute; left:0; top:57%; width:100%; height:5rem; background:transparent;}
.mEvt110643 .section-04 .item-look {position:relative; width:100%;}
.mEvt110643 .section-04 .item-look .swiper-button-prev {position:absolute; left:5%; top:44%; width:5.2vw;}
.mEvt110643 .section-04 .item-look .swiper-button-next {position:absolute; left:88%; top:44%; width:5.2vw;}
.mEvt110643 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt110643 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt110643 .pop-container .pop-inner a {display:inline-block;}
.mEvt110643 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109897/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
@keyframes updown {
    0% {top:77%;}
    100% {top:79%;}
}
@keyframes leftRight {
    0% {transform: translateX(1rem);}
    100% {transform: translateX(0);}
}
</style>
<script>
$(function(){
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.section-01 .tit').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slide */  
    var swiper = new Swiper(".section-01 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        pagination:".section-01 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-04 .swiper-container", {
        autoplay:false,
        speed: 1000,
        slidesPerView:1,
        loop:false,
        freeMode:true,
		nextButton : '.swiper-button-next', // 다음 버튼 클래스명
		prevButton : '.swiper-button-prev', // 이번 버튼 클래스명
    });
    /* event 버튼 선택 */
    $('.btn-grp button').on("click",function(){
        $(this).toggleClass("on").siblings().removeClass("on");
    });
    /* 쿠폰 사용 방법 팝업 */
    $('.mEvt110643 .btn-detail').click(function(){
        $('.pop-container.detail').fadeIn();
    })
    /* 팝업 닫기 */
    $('.mEvt110643 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});
function fnSelectSign(sn){
    $("#signNum").val(sn);
}
var numOfTry="<%=subscriptcount%>";
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(numOfTry == "1"){
			alert("오늘의 이벤트 참여는 완료되었습니다. 내일 또 참여해주세요!");
			return false;
		};
        if($("#signNum").val()==""){
			alert("정답을 선택해주세요.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript110643.asp",
            data: {
                mode: 'add',
                signNum: $("#signNum").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option','<%=eCode%>|'+$("#signNum").val())
                    $('.pop-container.win').fadeIn();
                }else if(data.response == "retry"){
                    alert("오늘의 이벤트 참여는 완료되었습니다. 내일 또 참여해주세요! ");
                }else{
                    $('.pop-container.fail').fadeIn();
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% end if %>
}
</script>
			<div class="mEvt110643">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=110643" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_tit.jpg" alt="즐겨찾길_서촌05 텐바이텐X커피한잔"></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <div class="section-01">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub01.jpg" alt="img01"></div>
                    <div class="tit tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt01.jpg" alt="멀리서부터 눈에 띄는 초록색 덕분에 눈길이 가는 곳, '커피한잔'."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub02.jpg" alt="img02"></div>
                    <div class="tit tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt02.jpg" alt="'레트로'를 흉내내는 곳이 아닌, 진짜 '레트로'를 한 가득 안고 있는 '커피한잔'."></div>
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_slide_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_slide_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_slide_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                    <div class="tit tit-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt03.jpg" alt="꽤 넓은 실내 공간에는 수 백장의 LP판부터 그때 그 시절을 생각나게 해주는 삐삐까지."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub03.jpg" alt="img03"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt04.jpg" alt="내가 알고 있는 추억의 아이템을 찾다보면, 어린 시즐의 보물찾기"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub04.jpg" alt="img04"></div>
                    <div class="tit tit-05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt05.jpg" alt="사장님이 직접 내려주시는 드립 커피"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub05.jpg" alt="img05"></div>
                    <div class="tit tit-06"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sub_txt06.jpg" alt="여러분도 맑은 날은 청량함 때문에 좋고, 비 오는 날에는 시원함 때문에 더 좋은 서촌의 '커피한잔'을 방문해보세요!"></div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_story.jpg" alt="커피한잔 에 대해 더 알아보기">
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_event.jpg" alt="텐바이텐과 커피한잔이 준비한 혜택">
                    <!-- 쿠폰사용 방법 보기 버튼 -->
                    <button type="button" class="link btn-detail"></button>
                </div>
                <div class="section-04">
                    <div class="event-tit">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_tit_event.jpg" alt="커피한잔 속 찐 레트로 아이템을 찾아주세요!">
                        <button type="button" class="btn-benefit"></button>
                    </div>
                    <div class="item-look">
                        <div class="slide-area">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_rolling_01.png" alt="">
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_rolling_02.png" alt="">
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_rolling_03.png" alt="">
                                    </div>
                                </div>
                                <!-- If we need navigation buttons -->
                                <div class="swiper-button-next"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/icon_right_arrow.png" alt=""></div>
                                <div class="swiper-button-prev"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/icon_left_arrow.png" alt=""></div>
                            </div>
                        </div>
                    </div>
                    <!-- event 영역 -->
                    <div class="event-sec">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_main_event.jpg" alt="커피한잔 공간 속 레트로 아이템이 아닌 것은 무엇일까요?">
                        <!-- 선택시 class on 추가 -->
                        <div class="btn-grp">
                            <button type="button" onclick="fnSelectSign(1);"></button>
                            <button type="button" onclick="fnSelectSign(2);"></button>
                            <button type="button" onclick="fnSelectSign(3);"></button>
                            <button type="button" onclick="fnSelectSign(4);"></button>
                            <button type="button" onclick="fnSelectSign(5);"></button>
                            <input type="hidden" id="signNum">
                        </div>
                        <!-- 정답 제출하기 버튼 -->
                        <button type="button" class="btn-apply" onclick="doAction();"></button>
                    </div>
                </div>
                <div class="section-05">
                    <div class="sns-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_sns.jpg" alt="sns 이벤트">
                    </div>
                    <!-- 즐겨찾길 이동 -->
                    <a href="/event/eventmain.asp?eventid=108102" onclick="jsEventlinkURL(108102);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_favorites.jpg" alt="즐겨찾길 메인으로 이동"></a>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/img_noti.jpg" alt="유의사항"></div>
                <!-- 팝업 - 쿠폰사용 방법 -->
                <div class="pop-container detail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/pop_coupon.png" alt="쿠폰사용방법">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 정답인 경우 -->
                <div class="pop-container win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/pop_win.png" alt="축하드립니다. 정답입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 오답인 경우 -->
                <div class="pop-container fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110643/m/pop_fail.png" alt="아쉽지만 오답!">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
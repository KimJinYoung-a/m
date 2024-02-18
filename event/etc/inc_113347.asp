<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : #즐겨찾길_서촌 06 텐바이텐X더레퍼런스
' History : 2021.08.12 정태훈 생성
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
	eCode = "108387"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "113347"
    mktTest = true    
Else
	eCode = "113347"
    mktTest = false
End If

if mktTest then
    currentDate = #08/16/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-08-16")		'이벤트 시작일
eventEndDate = cdate("2021-08-29")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), 2, "")
end if
%>
<style>
.mEvt113347 .topic {position:relative;}
.mEvt113347 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt113347 .section-01 .swiper-slide {width:100%;}
.mEvt113347 .section-01 {position:relative;}
.mEvt113347 .section-02 {position:relative;}
.mEvt113347 .section-01 .txt {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt113347 .section-01 .txt.on {opacity:1; transform:translateY(0);}
.mEvt113347 .section-02 .event-main {position:relative;}
.mEvt113347 .section-02 .btn-area {width:100%; position:absolute; left:0; top:0; display:flex; flex-wrap:wrap;}
.mEvt113347 .section-02 .btn-area button {position:relative; width:50%; height:21rem; background:transparent;}
.mEvt113347 .section-02 .btn-area button::before {content:""; display:inline-block; width:10vw; height:9.60vw; position:absolute; left:27%; top:9%;}
.mEvt113347 .section-02 .btn-area button.on::before {content:""; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113347/m/icon_check.png) no-repeat 0 0; background-size:100%;}
.mEvt113347 .section-02 .btn-area button:nth-child(2)::before,
.mEvt113347 .section-02 .btn-area button:nth-child(4)::before {left:15%;}
.mEvt113347 .section-02 .btn-apply {width:100%; height:10rem; position:absolute; left:0; bottom:4%; background:transparent;}

.mEvt113347 .pagination-wrap {display:flex; align-items:center; justify-content:center; margin-top:1.5rem;}
.mEvt113347 .pagination-wrap li a {display:inline-block; padding:1.5rem; font-size:4.26vw; color:#5c2b01; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt113347 .pagination-wrap li a img {width:2vw;}
.mEvt113347 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt113347 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt113347 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}

.mEvt113347 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt113347 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt113347 .pop-container .pop-inner a {display:inline-block;}
.mEvt113347 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113347/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}

@keyframes updown {
    0% {top:93%;}
    100% {top:95%;}
}
@keyframes wide {
    0% { transform: scale(0) }
    100% { transform: scale(1) }
}
</style>
<script>
$(function(){
    /* 팝업 닫기 */
    $('.mEvt113347 .btn-close,.mEvt113347 .btn-close02').click(function(){
        $(".pop-container").fadeOut();
    })
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.section-01 .txt').each(function(){
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
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-01 .pagination",
        loop:true
    });
    /* event check */
    $(".btn-area button").on("click",function(){
        $(this).toggleClass("on").siblings().removeClass("on");
    });
});

function fnSelectPlace(sn){
    $("#placeNum").val(sn);
}

var numOfTry="<%=subscriptcount%>";
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(numOfTry == "1"){
			$('.pop-container.done').fadeIn();
			return false;
		};
        if($("#placeNum").val()==""){
			alert("정답을 선택해주세요.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript113347.asp",
            data: {
                mode: 'add',
                placeNum: $("#placeNum").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option','<%=eCode%>|'+$("#signNum").val())
                    $('.pop-container.win').fadeIn();
                }else if(data.response == "retry"){
                    $('.pop-container.done').fadeIn();
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
			<div class="mEvt113347">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=113347" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_main.jpg" alt="텐바이텐 x 더레퍼런스"></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub01.jpg" alt="서점이면서 열람실이고, 전시도 함께 즐길 수 있는 곳, 여러분께 더레퍼런스을 소개합니다.">
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt01.jpg" alt="붉은색의 볅돌 건물에 하얀간판! 더레퍼런스 입니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub02.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt02.jpg" alt="더레퍼런스 지하 공간에서 열리는 전시에 궁금증을 더하죠" class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub03.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt03.jpg" alt="빼곡하게 있는 아트북을 만날 수 있답니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub04.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt04.jpg" alt="아트북을 마음껏 즐길 수 있죠!" class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt05.jpg" alt="볼거리가 참 다양하답니다." class="txt">
                    
                    <!-- 롤링 영역 -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_slide01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_slide02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_slide03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>

                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub05.jpg?v=2" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt06.jpg" alt="더레퍼런스 의 지하 공간으로 발검음을 돌립니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt07.jpg" alt="지하공간 에는 손정민 작각의 전시를 볼 수 있습니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub06.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt08.jpg" alt="모빌 등 입체 작업까지 다양하게 전개됩니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt09.jpg" alt="소소한 제스처를 엿볼 수 있는 매우 매력적인 전시랍니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub07.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt10.jpg" alt="서울 시립미술관 3층에서도 만나 볼 수 있답니다." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt11.jpg" alt="매력적인 책들이 준비되어 있어요." class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sub08.jpg" alt="img">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_txt12.jpg" alt="볼거리 가득한 시간을 즐겨보세요!" class="txt">
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_qna.jpg" alt="더레퍼런스 에 대해 더 알아보기">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_benefit.jpg" alt="텐바이텐과 더레퍼런스 가 준비한 혜택">
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_event.jpg?v=2" alt="event 1">
                    <div class="event-main">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_event02.jpg" alt="event 1">
                        <!-- 정답 선택 버튼 -->
                        <div class="btn-area">
                            <button type="button" onclick="fnSelectPlace(1);"></button>
                            <button type="button" onclick="fnSelectPlace(2);"></button>
                            <button type="button" onclick="fnSelectPlace(3);"></button>
                            <button type="button" onclick="fnSelectPlace(4);"></button>
                            <input type="hidden" id="placeNum">
                        </div>
                    </div>
                    <!-- 정답 제출하기 버튼 -->
                    <button type="button" class="btn-apply" onclick="doAction();"></button>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_sns.jpg" alt="sns 이벤트">
                <div class="section-03">
                    <!-- 더 레퍼런스 구경가기 -->
                    <a href="javascript:fnAPPpopupExternalBrowser('https://bit.ly/3iElUbw');" title="더 레퍼런스 이동" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_banner02.jpg" alt="더 레퍼런스 이동"></a>
                    <a href="https://bit.ly/3iElUbw" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_banner02.jpg" alt="더 레퍼런스 이동"></a>
                </div>
                <div class="section-03">
                    <!-- 즐겨찾길 메인으로 이동 -->
                    <a href="javascript:fnAPPpopupExternalBrowser('https://tenten.app.link/Cl6bQPapxdb');" title="즐겨찾길 메인으로 이동" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_banner.jpg" alt="즐겨찾길 메인으로 이동"></a>
                    <a href="https://tenten.app.link/Cl6bQPapxdb" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/img_banner.jpg" alt="즐겨찾길 메인으로 이동"></a>
                </div>

                <!-- 팝업 - 참여완료 -->
                <div class="pop-container done">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/pop_done.png" alt="참여완료">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 정답 -->
                <div class="pop-container win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/pop_win.png" alt="정답 입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 오답 -->
                <div class="pop-container fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/113347/m/pop_fail.png" alt="아쉽게도 오답 입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
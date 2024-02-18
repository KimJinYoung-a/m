<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 서촌도감04 - 텐바이텐X핀란드프로젝트
' History : 2021.03.30 정태훈 생성
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
	eCode = "104341"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "109897"
    mktTest = true    
Else
	eCode = "109897"
    mktTest = false
End If

if mktTest then
    currentDate = #04/02/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-04-02")		'이벤트 시작일
eventEndDate = cdate("2021-04-15")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), 2, "")
end if
%>
<style>
.mEvt109897 {background:#fff;}
.mEvt109897 .topic {position:relative;}
.mEvt109897 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt109897 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt109897 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt109897 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}

.mEvt109897 .section-01 {position:relative;}
.mEvt109897 .section-01 .swiper-slide {width:100%;}
.mEvt109897 .section-01 .tit {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt109897 .section-01 .tit.on {opacity:1; transform:translateY(0);}
.mEvt109897 .section-01 .img {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt109897 .section-01 .img.on {opacity:1; transform:translateY(0);}
.mEvt109897 .section-02 {position:relative;}
.mEvt109897 .section-03 {position:relative;}
.mEvt109897 .section-03 .link {display:inline-block; width:100%; height:9rem; position:absolute; left:0; top:59%; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt109897 .section-04 {position:relative;}
.mEvt109897 .section-04 .event-sec {position:relative;}
.mEvt109897 .section-04 .event-sec .btn-grp {width:100%; position:absolute; left:0; top:16%;}
.mEvt109897 .section-04 .event-sec .btn-grp button {position:relative; display:inline-block; width:100%; height:9rem; margin-bottom:1rem; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt109897 .section-04 .event-sec .btn-grp button::before {content:""; position:absolute; left:13%; top:10%; display:inline-block; width:10vw; height:9.60vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109897/m/icon_check.png) no-repeat 0 0; background-size:100%; opacity:0;}
.mEvt109897 .section-04 .event-sec .btn-grp button.on::before {opacity:1;}
.mEvt109897 .section-04 .event-sec .btn-grp button:nth-child(3):before {top:5%;}
.mEvt109897 .section-04 .event-sec .btn-grp button:nth-child(4)::before {top:2%;}
.mEvt109897 .section-04 .btn-apply {position:absolute; left:0; bottom:11%; width:100%; height:6rem; background:transparent; -webkit-tap-highlight-color:transparent;}
.mEvt109897 .section-04 .event-tit {position:relative;}
.mEvt109897 .section-04 .event-tit .btn-benefit {position:absolute; left:0; top:57%; width:100%; height:5rem; background:transparent;}

.mEvt109897 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt109897 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt109897 .pop-container .pop-inner a {display:inline-block;}
.mEvt109897 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109897/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}

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
        $('.section-01 .tit,.section-01 .img').each(function(){
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
    /* event 버튼 선택 */
    $('.btn-grp button').on("click",function(){
        $(this).toggleClass("on").siblings().removeClass("on");
    });
    //팝업
    /* 자세히보기 팝업 */
    $('.mEvt109897 .btn-detail').click(function(){
        $('.pop-container.detail').fadeIn();
    })
    /* 이벤트혜택 안내 팝업 */
    $('.mEvt109897 .btn-benefit').click(function(){
        $('.pop-container.benefit').fadeIn();
    })
    /* 팝업 닫기 */
    $('.mEvt109897 .btn-close').click(function(){
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
            url:"/event/etc/doeventsubscript/doEventSubScript109897.asp",
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
			<div class="mEvt109897">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=109897" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_tit.jpg" alt="즐겨찾길_서촌04 텐바이텐X핀란드프로젝트"></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <div class="section-01">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub01.jpg" alt="img01"></div>
                    <div class="tit tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub_txt01.jpg" alt="서촌의 조용한 주택가를 걷다 보면 의외의 장소에서 만나게 되는 '핀란드프로젝트' 멀리서부터 눈에 띄는 좌우 반전된 간판이 매력적인 캐주얼한 와인 집입니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub02.jpg" alt="img02"></div>
                    <div class="tit tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub_txt02.jpg" alt="멋스로운 개조 주택의 외관과 '핀란드츠로젝트'만의 공간 연출로 이색적인 분위기를 풍기는 공간으로 만들어졌답니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub03.jpg" alt="img03"></div>
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_slide1_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_slide1_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_slide1_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                    <div class="tit tit-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub_txt03.jpg" alt="특이하게도 어느 위치에 앉는지에 따라 분위기가 바뀌어 새로움을 느낄 수 있는 곳이죠. 곳곳에 따스한 조명과 앤트크한 가구, 사진 찍고 싶게 만드는 유니크한 소품들을 구경하는 재미도 있어요."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub04.jpg" alt="img04"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub_txt04.jpg" alt="'핀란드프로젝트' 직원이 직접 개발한 음식들은 와인과 아주 잘 어울리기도 하죠!"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub05.jpg" alt="img05"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub_txt05.jpg" alt="늦은 저녁, 아지트 같은 공간을 갖고 싶다면 서촌의 '필란드프로젝트'로 방문해보세요!"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sub06.jpg" alt="img06"></div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_story.jpg" alt="핀란드프로젝트에 대해 더 알아보기">
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_event_benefit.jpg" alt="이벤트 혜택">
                    <!-- 쿠폰사용 방법 보기 버튼 -->
                    <button type="button" class="link btn-detail"></button>
                </div>
                <div class="section-04">
                    <div class="event-tit">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_tit_event.jpg?v=2" alt="핀란드프로젝트의 진짜 간판을 찾아주세요">
                        <button type="button" class="btn-benefit"></button>
                    </div>
                    <!-- event 영역 -->
                    <div class="event-sec">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_event.jpg" alt="다음 중 핀란드프로젝트의 '진짜' 간판은 무엇일까요?">
                        <!-- 선택시 class on 추가 -->
                        <div class="btn-grp">
                            <button type="button" onclick="fnSelectSign(1);"></button>
                            <button type="button" onclick="fnSelectSign(2);"></button>
                            <button type="button" onclick="fnSelectSign(3);"></button>
                            <button type="button" onclick="fnSelectSign(4);"></button>
                            <input type="hidden" id="signNum">
                        </div>
                        <!-- 정답 제출하기 버튼 -->
                        <button type="button" class="btn-apply" onclick="doAction();"></button>
                    </div>
                </div>
                <div class="section-05">
                    <div class="sns-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_sns.jpg" alt="sns 이벤트">
                    </div>
                    <!-- 인스타그램으로 이동 -->
                    <a href="https://www.instagram.com/finland_project" onclick="fnAmplitudeEventMultiPropertiesAction('landing_instagram','evtcode','<%=eCode%>')" class="mWeb">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_insta.jpg" alt="핀란드프로젝트 구경하로 가기">
					</a>
                    <a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/finland_project');return false;" class="mApp">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_insta.jpg" alt="핀란드프로젝트 구경하로 가기">
					</a>
                    <!-- 즐겨찾길 이동 -->
                    <a href="/event/eventmain.asp?eventid=108102" onclick="jsEventlinkURL(108102);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_favorites.jpg" alt="즐겨찾길 메인으로 이동"></a>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/img_noti.jpg?v=2" alt="유의사항"></div>
                <!-- 팝업 - 쿠폰사용 방법 -->
                <div class="pop-container detail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/pop_coupon.png?v=2" alt="쿠폰사용방법">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 정답인 경우 -->
                <div class="pop-container win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/pop_win.png" alt="축하드립니다. 정답입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 오답인 경우 -->
                <div class="pop-container fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/pop_fail.png" alt="아쉽지만 오답!">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 이벤트혜택 안내 -->
                <div class="pop-container benefit">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109897/m/pop_benefit.png" alt="혜택 안내">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
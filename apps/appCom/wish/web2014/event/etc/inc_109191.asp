<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls109191.asp" -->
<%
'####################################################################
' Description : [텐바이텐X잡코리아] 2020년은 ‘직장인 치트킷(KIT)’과 함께!
' History : 2021-03-12 정태훈 생성
'####################################################################

dim currentDate '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim eCode, moECode, eventStartDate, eventEndDate

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "104323"
    moECode = "104322"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "109191"
    moECode = "109221"
    mktTest = true
Else
	eCode = "109191"
    moECode = "109221"
    mktTest = false
End If

eventStartDate	= cdate("2021-03-15")
eventEndDate	= cdate("2021-03-28")

if mktTest then
    '// 테스트용
    if request("testCheckDate")<>"" then
        currentDate = CDate(request("testCheckDate"))
    else
        currentDate = CDate("2021-03-15")
    end if
else
    currentDate = date()
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

dim pwdEvent, TryCNT
if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	TryCNT = pwdEvent.isParticipationDayBase()
end if

if TryCNT="" then TryCNT=0

%>
<style>
.mEvt109191 .topic {position:relative;}
.mEvt109191 .topic .tit-01 {position:absolute; left:50%; top:32%; width:41.06vw; transform:translate(-50%,1rem); transition:all 1s; opacity:0;}
.mEvt109191 .topic .tit-01.on {opacity:1; transform:translate(-50%,0);}
.mEvt109191 .topic .tit-02 {position:absolute; left:50%; top:44%; width:44.93vw; transform:translate(-50%,1rem); transition:all 1.5s .5s; opacity:0;}
.mEvt109191 .topic .tit-02.on {opacity:1; transform: translate(-50%,0);}
.mEvt109191 .topic .tit-03 {position:absolute; left:50%; top:56%; width:51.06vw; transform:translate(-43%,1rem); transition:all 2.5s .5s; opacity:0;}
.mEvt109191 .topic .tit-03.on {opacity:1; transform: translate(-43%,0);}
.mEvt109191 .topic .btn-float-kit {position:absolute; left:0; top:90%; width:41.06vw; animation:updown .8s ease-in-out alternate infinite;}
.mEvt109191 .topic .btn-float-kit.scrolled {position:fixed; left:0; top:0; z-index:100;}

.mEvt109191 .section-01 {position:relative;}
.mEvt109191 .section-01 .img-sec {position:absolute; left:50%; top:11%; width:92.4vw; opacity:0; transform:translate(-49%,1rem); transition:all 1s;}
.mEvt109191 .section-01 .txt-sec {position:absolute; left:50%; top:48%; width:54.40vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-01 .img-sec.img02 {top:56%; width:100%; transform:translate(-50%,1rem);}
.mEvt109191 .section-01 .txt-sec.txt02 {top:91%; width:86.53vw;}
.mEvt109191 .section-01 .img-sec.on {opacity:1; transform:translate(-49%,0);}
.mEvt109191 .section-01 .img-sec.img02.on {opacity:1; transform:translate(-50%,0);}
.mEvt109191 .section-01 .txt-sec.on {opacity:1; transform:translate(-49%,0);}

.mEvt109191 .section-02 {position:relative;}
.mEvt109191 .section-02 .img-sec {position:absolute; left:50%; top:11%; width:89.86vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-02 .txt-sec {position:absolute; left:50%; top:51%; width:75.06vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-02 .img-sec.img02 {top:57%; width:100%;}
.mEvt109191 .section-02 .txt-sec.txt02 {top:89%; width:52.66vw;}
.mEvt109191 .section-02 .img-sec.on {opacity:1; transform:translate(-50%,0);}
.mEvt109191 .section-02 .txt-sec.on {opacity:1; transform:translate(-50%,0);}

.mEvt109191 .section-03 {position:relative;}
.mEvt109191 .section-03 .img-sec {position:absolute; left:50%; top:0; width:100%; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-03 .txt-sec {position:absolute; left:50%; top:47%; width:64.26vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-03 .img-sec.img02 {top:53%; width:100%;}
.mEvt109191 .section-03 .txt-sec.txt02 {top:91%; width:52.53vw;}
.mEvt109191 .section-03 .img-sec.on {opacity:1; transform:translate(-50%,0);}
.mEvt109191 .section-03 .txt-sec.on {opacity:1; transform:translate(-50%,0);}

.mEvt109191 .section-04 {position:relative;}
.mEvt109191 .section-04 .img-sec {position:absolute; left:50%; top:10%; width:89.86vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-04 .txt-sec {position:absolute; left:50%; top:43%; width:62.26vw; opacity:0; transform:translate(-50%,1rem); transition:all 1s;}
.mEvt109191 .section-04 .img-sec.img02 {top:51%; width:100%;}
.mEvt109191 .section-04 .txt-sec.txt02 {top:87%; width:41.6vw;}
.mEvt109191 .section-04 .img-sec.on {opacity:1; transform:translate(-50%,0);}
.mEvt109191 .section-04 .txt-sec.on {opacity:1; transform:translate(-50%,0);}

.mEvt109191 .section-06 {background:#ededed;}
.mEvt109191 .section-06 .slide-area {padding-left:5.04rem;}
.mEvt109191 .section-05 .swiper-slide {width:100%;}
.mEvt109191 .section-06 .swiper-slide {width:69.19vw;}

.mEvt109191 .section-07 {position:relative}
.mEvt109191 .section-07 .btn-re {display:inline-block; position:absolute; left:0; top:41%; width:10rem; height:4rem;}

.mEvt109191 .quiz-section {position:relative;}
.mEvt109191 .quiz-section .quiz-answer {position: absolute; left: 50%; top: 43%; height: 14.00vw; width: 72.8vw; text-align: center; transform: translate(-50%, 0); border: 2px solid #222; border-radius:10px; font-size:4.8vw; color:#222;}
.mEvt109191 .quiz-section .quiz-answer::placeholder {color:#999;}
.mEvt109191 .quiz-section .btn-apply {width:100%; height:7rem; position:absolute; left:0; top:52%; background:transparent;}
.mEvt109191 .quiz-section .btn-job {display:inline-block; width:100%; height:7rem; position:absolute; left:0; bottom:9%;}

.mEvt109191 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt109191 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#3399ff;}
.mEvt109191 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#cccccc;}

.mEvt109191 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; z-index:150;}
.mEvt109191 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt109191 .pop-container .pop-inner a {display:inline-block;}
.mEvt109191 .pop-container .pop-inner .btn-close {position:absolute; right:3.5rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109191/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt109191 .pop-container .btn-info {width:100%; height:13rem; position:absolute; left:0; bottom:14%; background:transparent;}
.mEvt109191 .pop-container.win .pop-contents {position:relative; opacity:1;}
.mEvt109191 .pop-background {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color: rgb(51, 153, 255); opacity: 0.902; z-index:100;}
@keyframes updown {
    0% {transform: translateY(10%);}
    100% {transform: translateY(0);}
}
</style>
<script>
var numOfTry = <%=TryCNT%>;
$(function(){
    $('.topic h2').addClass('on');
    /* 팝업 닫기 */
    $('.mEvt109191 .btn-close').click(function(){
        $(".pop-container").fadeOut();
        $('.pop-background').fadeOut();
    })
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.img-sec,.txt-sec').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slide */
    var swiper = new Swiper(".section-05 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        pagination:".section-05 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-06 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        spaceBetween:20,
        loop:true
    });
    $(window).scroll(function(){
        var header_wrap = $('#header').outerHeight()+20; // header 높이
        var topic = $('.topic').outerHeight();
        var buttonKit = $('.btn-float-kit');
        var buttonKit_top = $('.btn-float-kit').offset().top; // btn-float-kit 위치
        var contents_top = $('.section-05').offset().top;  // float button 없어질 contents 위치

        // 현재 스크롤이 btn-float-kit 요소의 위치와 같거나 아래에 있을 때 btn-float-kit 에 scrolled 클래스 추가하여 btn-float-kit 고정
        if ($(this).scrollTop() >= buttonKit_top) {
            buttonKit.addClass('scrolled').css("top", header_wrap);
        }
        if($(this).scrollTop() <= topic) {
            buttonKit.removeClass('scrolled').css("top","90%");
        }

        // 현재 스크롤이 contents_top 요소보다 위에 있을 경우 btn-float-kit 에 scolled 클래스 제거하여 btn-float-kit 고정 해제
        if ($(this).scrollTop() >= contents_top) {
            buttonKit.removeClass('scrolled').css("top","90%");
        }
    });
});
function eventTry(){
    
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
		if(numOfTry >= 3){
			alert("오늘의 응모는 모두 완료하였습니다.");            
			return false;
		}
        if($("#answer").val() == ""){
			alert("답을 입력해주세요.");            
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add",
            answer: $("#answer").val(),
			<% if mktTest then %>
			param: "mktTest",
			<% end if %>
			evt_code: "<%=eCode%>"
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doeventSubscript109191.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + $("#answer").val())
					if(res!="") {
                        numOfTry++;
						// console.log(res)
						if(res.response == "C"){
							$('.pop-container.win').fadeIn();
                            $('.pop-background').fadeIn();
							return false;
						}else if(res.response == "B"){
							$('.pop-container.win-fail').fadeIn();
                            $('.pop-background').fadeIn();
							return false;
						}else if(res.response == "F"){
                            if(numOfTry==1){
							    $('.pop-container.fail').fadeIn();
                            }else if(numOfTry==2){
							    $('.pop-container.fail2').fadeIn();
                            }else{
                                $('.pop-container.fail3').fadeIn();
                            }
                            $('.pop-background').fadeIn();
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
</script>
			<div class="mEvt109191">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_main.jpg" alt="여러분의 직장 생활에 날개를 달아 줄 치트킷 을 준비했어요.">
                    <h2 class="tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/tit_main01.png" alt="직장인"></h2>
                    <h2 class="tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/tit_main02.png" alt="치트킷 은"></h2>
                    <h2 class="tit-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/tit_main03.png" alt="처음이지?"></h2>
                    <a href="#quiz-zone" class="btn-float-kit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/btn_float.png" alt="직장인 치트킷 받기"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit.jpg?v=2" alt="직장인 치트킷 이란?">
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit_section01.jpg?v=2" alt="직장 생활에 유익한 key caps 스티커">
                    <div class="img-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section01.png" alt=""></div>
                    <div class="txt-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section01.png" alt="칼퇴 후 모니터에 착 - 붙이고 가벼운 마음으로 퇴근하세요."></div>
                    <div class="img-sec img02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_sub01.jpg" alt="주말 ctrl c+v 필수"></div>
                    <div class="txt-sec txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section01_02.png" alt="주말이 조금만 더 길다면 얼마나 좋을까요? 아쉬우니 직장인 치트킷 스티커로 달래봅시다!"></div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit_section02.jpg?v=2" alt="넵 시리즈 마스킹 테이프">
                    <div class="img-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section02_01.png" alt="오늘 내가 슬 답변 모음"></div>
                    <div class="txt-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section02_01.png" alt="직장인의 고칠 수 없는 불치병 넵 마스킹테이프로 더 즐겁게 넵 하기"></div>
                    <div class="img-sec img02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section02_02.png" alt="오늘 점심 돈까스 먹을까요?"></div>
                    <div class="txt-sec txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section02_02.png" alt="점심 메뉴도 우리는 넵 마스킹테이프로 뭉친다."></div>
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit_section03.jpg" alt="칼퇴를 위한 to do list">
                    <div class="img-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section03_01.png" alt="세상 모든 일 내게로 오라"></div>
                    <div class="txt-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section03_01.png" alt="할 일은 많고 잊지 말아야 할때!"></div>
                    <div class="img-sec img02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section03_02.png" alt="나를 위한 휴식도 알차게"></div>
                    <div class="txt-sec txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section03_02.png" alt="빡빡한 업무 속 나만의 돌파구 하나 어때요?"></div>
                </div>
                <div class="section-04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit_section04.jpg" alt="업무 능력치를 높여 줄 엑셀 단축기 패드">
                    <div class="img-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section04_01.png" alt="이 구역 엑셀 1인자는 바로 나!"></div>
                    <div class="txt-sec"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section04_01.png" alt="엑셀 사용하다 막힐 때 있잖아요? 그때 스-윽 보면 완전 유용해요!"></div>
                    <div class="img-sec img02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_section04_02.png" alt="서로 돕고 살자구요!"></div>
                    <div class="txt-sec txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/txt_section04_02.png" alt="애정하는 동료끼리는 같이 나눠써도 좋아요!"></div>
                </div>
                <div class="section-05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit02.jpg?v=2" alt="event 아래의 퀴즈를 풀고 이벤트에 응모하신 분 중 실시간 당첨으로 직장인 치트킷을 선물로 드려요.">
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide01_01.jpg" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide01_02.jpg" alt="slide02">
								</div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                </div>
                <!-- quiz 영역 -->
                <div id="quiz-zone" class="quiz-section">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_quiz.jpg" alt="quiz">
                    <input type="text" class="quiz-answer" id="answer" placeholder="답을 입력해주세요" maxlength="6">
                    <button type="button" class="btn-apply" onclick="eventTry();"></button>
                    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('landing_jobkorea','evtcode|option1','<%=eCode%>|1');fnAPPpopupExternalBrowser('https://jobkorea.onelink.me/4KSi/327801e1');return false;" class="btn-job"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_quiz_sub.jpg" alt="텐바이텐 퀴즈 정답!">
                <div class="section-06">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_tit03.jpg" alt="잡코리아 소개">
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide02_01.jpg" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide02_02.jpg" alt="slide02">
								</div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide02_04.jpg" alt="slide03">
								</div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide02_05.jpg" alt="slide04">
								</div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_slide02_03.jpg" alt="slide05">
								</div>
                            </div>
						</div>
                    </div>
                    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('landing_jobkorea','evtcode|option1','<%=eCode%>|2');fnAPPpopupExternalBrowser('https://jobkorea.onelink.me/4KSi/327801e1');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/btn_app.jpg" alt="잡코리아 APP다운하러 가기"></a>
                </div>
                <div class="section-07">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/img_notice.jpg" alt="유의사항">
                    <a href="" onclick="fnAPPpopupBrowserURL('개인정보수정','<%=M_SSLUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp','right','','sc'); return false;" class="btn-re"></a>
                </div>
                <div class="pop-background"></div>
                <div class="pop-container win-fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/pop_fail01.png" alt="아쉽게도 당첨되지 않았어요.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <div class="pop-background"></div>
                <div class="pop-container fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/pop_fail02.png" alt="아쉽지만 오답입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <div class="pop-background"></div>
                <div class="pop-container fail2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/pop_fail03.png" alt="아쉽지만 오답입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <div class="pop-background"></div>
                <div class="pop-container fail3">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/pop_fail04.png" alt="아쉽지만 오답입니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <div class="pop-background"></div>
                <div class="pop-container win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109191/m/pop_win.png?v=2" alt="당첨을 축하드려요!">
                            <button type="button" class="btn-info" onclick="fnAPPpopupBrowserURL('개인정보수정','<%=M_SSLUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp','right','','sc'); return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
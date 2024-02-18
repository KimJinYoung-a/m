<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : #즐겨찾길_서촌 03 텐바이텐X미술관옆작업실
' History : 2021.02.05 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
dim currentDate, mktTest
dim eCode, LoginUserid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  104313
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
    eCode   =  108730
    mktTest = True
Else
	eCode   =  108730
    mktTest = False
End If

dim eventStartDate, eventEndDate
LoginUserid		= getencLoginUserid()
eventStartDate  = cdate("2021-03-05")		'이벤트 시작일
eventEndDate 	= cdate("2021-03-18")		'이벤트 종료일

if mktTest then
    currentDate = cdate("2021-03-05")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("#즐겨찾길 03 텐바이텐X미술관옆작업실")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "#즐겨찾길 03 텐바이텐X미술관옆작업실"
Dim kakaodescription : kakaodescription = "지금 텐바이텐에서 '미술관옆작업실' 감성을 느껴보세요!"
Dim kakaooldver : kakaooldver = "지금 텐바이텐에서 '미술관옆작업실' 감성을 느껴보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode

dim isSecondTried
dim isFirstTried, pwdEvent
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isFirstTried = pwdEvent.isParticipationDayBase(1)
end if

triedNum = chkIIF(isFirstTried, 1, 0)
%>
<style>
.mEvt108730 {background:#fff;}
.mEvt108730 .topic {position:relative;}
.mEvt108730 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt108730 .section-01 .swiper-slide,
.mEvt108730 .section-02 .swiper-slide,
.mEvt108730 .section-06 .swiper-slide {width:100%;}
.mEvt108730 .slide-review .swiper-slide {width:100%; position:relative;}
.mEvt108730 .section-02 .slide-area {padding-top:5.21rem;}
.mEvt108730 .section-05 {position: relative;}
.mEvt108730 .section-05 .link {display:inline-block; width:100%; height:9rem; position:absolute; left:0; top:51%; background:transparent;}
.mEvt108730 .section-06 .slide-area {padding:4.34rem 1.73rem 0; background-color:#f2eeeb;}
.mEvt108730 .section-06 .swiper-container {box-shadow: 19px 0px 27px 0px rgba(75, 75, 75, 0.2);}
.mEvt108730 .section-06 .pagination {left:50%; bottom:6%; transform: translate(-50%,0);}

.mEvt108730 .section-01 {position:relative;}
.mEvt108730 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt108730 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt108730 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}
.mEvt108730 .section-02 {position:relative;}
.mEvt108730 .section-02 .tit {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt108730 .section-02 .tit.on {opacity:1; transform:translateY(0);}
.mEvt108730 .section-02 .img {opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt108730 .section-02 .img.on {opacity:1; transform:translateY(0);}
.mEvt108730 .section-04 {position:relative; padding-bottom:5rem; background:#7080a5;}
.mEvt108730 .section-04 .btn-detail {position:absolute; left:0; top:31%; width:100%; height:6rem; background:transparent;}
.mEvt108730 .section-04 .hint-area {position:relative; padding-top:2rem;}
.mEvt108730 .section-04 .hint-area .btn-hint {width:37vw; position:absolute; left:50%; top:0; transform:translate(-50%,0);}
.mEvt108730 .section-04 .hint-area .btn-hint button {position:relative; background:transparent;}
.mEvt108730 .section-04 .hint-area .btn-hint button:before {content:""; position:absolute; right:26%; top:44%; width:2.5vw; height:1vh; background:url(//webimage.10x10.co.kr/fixevent/event/2021/108730/m/icon_arrow_down.png) no-repeat 0 0; background-size:100%;}
.mEvt108730 .section-04 .hint-area .btn-hint button.show:before {content:""; transform: rotate(180deg);}
.mEvt108730 .section-04 .hint-area .hidden-area {display:none;}
.mEvt108730 .section-04 .hint-area .hidden-area.show {display:block;}
.mEvt108730 .section-04 .hint-area .icon-click {position:absolute; left:3rem; top:0; width:17.86vw; animation: leftRight 1s ease-in-out alternate infinite;}
.mEvt108730 .section-04 .quiz-area {position:relative;}
.mEvt108730 .section-04 .quiz-area .inputs {width:19.5vw; height:8%; padding:0 0 0.3rem; position:absolute; left:50%; top:13.1%; transform:translate(-70%,0); text-align:center; color:#222; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:6.5vw; border-bottom:0.3rem solid #d3d3d4; border-top:0; border-left:0; border-right:0; border-radius:0;}
.mEvt108730 .section-04 .quiz-area .inputs.input02 {top:38.2%; transform:translate(-125%,0);}
.mEvt108730 .section-04 .quiz-area .inputs::placeholder {font-size:6.5vw; color:#d3d3d4; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt108730 .section-04 .quiz-area .btn-apply {width:100%; height:30%; position:absolute; left:0; bottom:13%;}

.mEvt108730 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt108730 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt108730 .pop-container .pop-inner a {display:inline-block;}
.mEvt108730 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt108730 .pop-container .pop-inner .btn-share {width:100%; height:60%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt108730 .pop-container.fail .pop-contents {position: relative;}
.mEvt108730 .pop-container.review .pop-inner .btn-close {position:absolute; right:2.73rem; top:0.5rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt108730 .navi-wrap {height:5.43rem; margin:0 2.17rem;}
.mEvt108730 .navi-wrap .swiper-button-prev {left:0; top:50%; transform: translate(0,-50%); width:2rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_left.png) no-repeat 0 50%; background-size:0.82rem 1.60rem;}
.mEvt108730 .navi-wrap .swiper-button-next {right:0; top:50%; transform: translate(0,-50%); width:2rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_right.png) no-repeat right 50%; background-size:0.82rem 1.60rem;}
.mEvt108730 .navi-wrap .swiper-slide a {display:inline-block; height:100%; line-height:5.43rem; margin:0 0.95rem; font-size:1.30rem; color:#999;}
.mEvt108730 .navi-wrap .swiper-slide.swiper-slide-active a {color:#191919; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt108730 .navi-wrap .swiper-slide div {font-size:1.30rem; color:#999999; text-align:center;}
.mEvt108730 .navi-wrap .swiper-wrapper {display:flex; align-items:center; justify-content:center; height:5.43rem;}
.mEvt108730 .navi-wrap .swiper-slide .txt {width:4.56rem; height:2.30rem; margin:0 0.95rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/txt_nav.png) no-repeat 0 0; background-size:100%;}
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
    //팝업
    /* 자세히보기 팝업 */
    $('.mEvt108730 .btn-detail').click(function(){
        $('.pop-container.detail').fadeIn();
    })
    /* 팝업 닫기 */
    $('.mEvt108730 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.section-02 .tit,.section-02 .img').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });

    /* 힌트 보기 */
    $(".btn-hint > button").click(function(){
        $(".hidden-area").toggleClass("show");
        $(this).toggleClass("show");
    });
    /* slide */
    var mySwiper = new Swiper(".navi-wrap .swiper-container", { 
        centeredSlides: true, //활성화된것이 중앙으로
        initialSlide:1, //활성화된 슬라이드
        slidesPerView:'auto',
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });  
    var swiper = new Swiper(".section-01 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        pagination:".section-01 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-02 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        pagination:".section-02 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-06 .swiper-container", {
        autoplay: 1,
        speed: 2500,
        slidesPerView:'auto',
        pagination:".section-06 .pagination",
        loop:true
    });
    $('.mEvt108730 .btn-apply').click(function(){
        eventTry();
    })
});
var numOfTry = "<%=triedNum%>";

function eventTry(){
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		if($("#answer1").val() == ""){
            // 한번 시도
			alert("답을 입력해주세요.");            
			return false;
		}
		if($("#answer2").val() == ""){
			alert("답을 입력해주세요.");
			return false;
		}
		var returnCode, data
		var data={
			mode: "add",
            answer1: $("#answer1").val(),
            answer2: $("#answer2").val()
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doeventSubscript108730.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            numOfTry++;
                            if(res.returnCode == "C01"){
                                $("#winpopup").show();
                            }
                            else{
                                $('#fail').show();
                            }
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
	<% End If %>
}
function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/event/etc/doeventSubscript108730.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "JSON",			
			success: function(res){
				isShared = "True"
				if(snsnum=="fb"){
					<% if isapp then %>
					fnAPPShareSNS('fb','<%=appfblink%>');
					return false;
					<% else %>
					popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
					<% end if %>
				}else{
					<% if isapp then %>
						fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','',"<%=kakaodescription%>");
						return false;
					<% else %>
						event_sendkakao("<%=kakaotitle%>" ,"<%=kakaodescription%>", "<%=kakaoimage%>" , "<%=kakaoMobileLink%>" );
					<% end if %>
				}					
			},
			error: function(err){
				alert('잘못된 접근입니다.')
			}
		})
}
</script>
			<div class="mEvt108730">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=108730" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_tit.jpg?v=2" alt="즐겨찾길_서촌02 텐바이텐X미술관옆작업실"></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <div class="section-01">
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide1_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide1_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide1_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                </div>
                <div class="section-02">
                    <div class="tit tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub_txt01.jpg" alt="‘미술관옆작업실’은 디자이너 김소연 대표가 2013년부터 혼자 운영하고 있는 1인 디자인브랜드입니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub01.jpg" alt="img01"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub02.jpg" alt="img02"></div>
                    <div class="tit tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub_txt02.jpg" alt="독특하게도 ‘미술관옆작업실’은 ‘블랙앤화이트’ 컨셉으로만 디자인하여, 지극히 아날로그 느낌이 담긴 디자인의 문구제품들을 만날 수 있어요."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub03.jpg" alt="img03"></div>
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide2_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide2_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_slide2_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                    <div class="tit tit-03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub_txt03.jpg" alt="원고지를 모티브로 하여 디자인한 메모지, 엽서, 편지지, 일기장, 노트는 물론이고 사각거림이 좋아 아직도 사용하고 있는 연필 등 아날로그 디자인 문방구답게 아날로그적인 문구 제품들이 있는 곳이랍니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub04.jpg" alt="img04"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub05.jpg" alt="img05"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub_txt04.jpg" alt="여러분도 더욱 생생한 그 감성을 느끼기 위해 '미술관옆작업실'을 방문해보세요!"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sub06.jpg" alt="img06"></div>
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_story.png" alt="미술관옆작업실에 대해 더 알아보기 Q & A">
                </div>
                <div class="section-05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_event_benefit.jpg" alt="이벤트 혜택">
                    <!-- 선물 자세히 보기 버튼 -->
                    <button type="button" class="link btn-detail"></button>
                </div>
                <div class="section-04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_tit_event.jpg?v=2" alt="미술관옆작업실 초성 퀴즈">
                    <!-- 선물 자세히 보기 버튼 -->
                    <button type="button" class="link btn-detail"></button>
                    <!-- 퀴즈 영역 -->
                    <div class="quiz-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_quiz.jpg" alt="디자이너 혼자 디자인하고 만드는 아날로그 문구브랜드 미술관옆작업실">
                        <!-- 정답 입력 input -->
                        <input type="text" class="input01 inputs" id="answer1" placeholder="ㅈㅇㄴ" maxlength="4">
                        <input type="text" class="input02 inputs" id="answer2" placeholder="ㄴㄹㄱ" maxlength="4">
                        <!-- 정답제출 버튼 -->
                        <div class="btn-apply">
                            <button type="button"></button>
                        </div>
                    </div>
                    <!-- 힌트 영역 -->
                    <div class="hint-area">
                        <!-- 힌트 보기 버튼 -->
                        <div class="icon-click"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_click.png" alt="click"></div>
                        <div class="btn-hint"><button type="button"><img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/btn_off.png" alt="hint button"></button></div>
                        <div class="hidden-area">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_hint.jpg" alt="hint">
                        </div>
                    </div>
                </div>
                <div class="section-06">
                    <div class="sns-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_sns.jpg?v=2" alt="sns 이벤트">
                    </div>
                    <!-- 인스타그램으로 이동 -->
                    <a href="https://www.instagram.com/workroom.bytheartmuseum" class="mWeb" onclick="fnAmplitudeEventMultiPropertiesAction('landing_instagram','evtcode|option1','<%=eCode%>|')">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_insta.jpg" alt="서촌도감 구경하로 가기">
					</a>
                    <a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/workroom.bytheartmuseum'); return false;" class="mApp">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/img_insta.jpg" alt="서촌도감 구경하로 가기">
					</a>
                    <!-- 즐겨찾길 이동 -->
                    <a href="/event/eventmain.asp?eventid=108102" onclick="jsEventlinkURL(108102);fnAmplitudeEventMultiPropertiesAction('landing_bookmark_seochon','evtcode|option1','<%=eCode%>|');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_favorites.jpg" alt="즐겨찾길 메인으로 이동"></a>
                </div>
                <!-- 팝업 - 자세히 보기 -->
                <div class="pop-container detail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/popup_detail.png" alt="집에서 느끼는 미술관옆작업실 감성 KIT">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 정답인 경우 -->
                <div class="pop-container win" id="winpopup">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/popup_win.png?v=2" alt="정답입니다. 본 이벤트에 응모가 완료되었습니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 오답인 경우 -->
                <div class="pop-container fail" id="fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/108730/m/popup_fail.png" alt="아쉽지만 오답! 카카오톡 공유하고 한 번 더 풀기">
                            <!-- 카카오톡 공유하고 한 번 더 풀기 -->
                            <a href="#" onclick="sharesns('ka')" class="btn-share"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
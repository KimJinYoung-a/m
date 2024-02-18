<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 다이어리 타임세일2 티저
' History : 2020-12-09 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim eCode
dim currentDate

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "104278"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "108350"
    mktTest = true    
Else
	eCode = "108350"
    mktTest = false
End If

if mktTest then
    '// 테스트용
    currentDate = CDate(request("testCheckDate"))
    'currentDate = CDate("2020-12-12 01:00:00")
    '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
    'currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

'// 2020년 12월 14일 이후엔 해당 페이지로 접근 하면 실제 이벤트 페이지로 자동으로 redirect 시켜줌
If Left(currentDate,10) >= "2020-12-14" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108176"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=108177"
        response.end
    End If
End If

%>
<style>
.mEvt108178 .topic {position:relative;}
.mEvt108178 .topic .number {position:absolute; right:1.52rem; top:43%; width:9.82rem; background:transparent; z-index:10;}
.mEvt108178 .section-01,
.mEvt108178 .section-02 {position:relative;}
.mEvt108178 .section-01 .go-link {position:absolute; left:50%; bottom:20%; transform:translate(-50%,0); width:25.57rem; background:transparent;}
.mEvt108178 .section-02 .go-link {position:absolute; right:2.82rem; bottom:15%; width:13.35rem; background:transparent;}
.mEvt108178 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; min-height:45.52rem; background-color:rgba(0, 0, 0,0.902); z-index:150;}
.mEvt108178 .pop-container .pop-inner {position:relative; width:100%; padding:8.47rem 1.73rem 4.17rem;}
.mEvt108178 .pop-container .pop-inner a {display:inline-block;}
.mEvt108178 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:2.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108178/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt108178 .pop-container .pop-contents {position:relative;}
.mEvt108178 .pop-container .pop-contents .link-kakao {width:calc(100% - 4.80rem); position:absolute; left:50%; top:57%; transform:translate(-50%, 0);}
.mEvt108178 .pop-container .pop-contents .tit {padding-right:7.87rem;}
.mEvt108178 .pop-container .pop-contents .pop-input {display:flex; align-items:center; justify-content:flex-start; padding:6.82rem 0 2.17rem;}
.mEvt108178 .pop-container .pop-contents .pop-input button {height:3rem; padding-left:2rem; border-bottom:2px solid #54ff00; border-radius:0; font-size:1.43rem; color:#54ff00; background:none; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt108178 .pop-container .pop-contents .pop-input input {width:17.83rem; height:3rem; padding-left:0; border:0; font-size:1.43rem; color:#cbcbcb; background:none; border-bottom:2px solid #54ff00; border-radius:0;}
.mEvt108178 .slide-area {position:absolute; left:0; bottom:31%; width:100%;}
.mEvt108178 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt108178 .swiper-wrapper .swiper-slide {width:14.78rem; padding:0 0.56rem;}
</style>
<script>
$(function(){
    /* slide */
    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: 1,
        speed: 5000,
        slidesPerView:'auto',
        loop:true
    });
    /* popup */
    // 알람 신청 팝업
	$(".mEvt108178 .btn-open").on("click", function(){
        <% If (left(currentDate, 10) < "2020-12-12" Or left(currentDate, 10) > "2020-12-13") Then %> 
            alert("이벤트 기간에만 신청하실 수 있습니다.");
            return false;
        <% End If %>            
		$(".pop-container").fadeIn();
	});
	// 팝업 닫기
	$(".mEvt108178 .btn-close").on("click", function(){
		$(".pop-container").fadeOut();
	});
});

//maxlength validation in input type number
function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}

function fnSendToKakaoMessage() {
    <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
    <% If (left(currentDate, 10) < "2020-12-12" Or left(currentDate, 10) > "2020-12-13") Then %> 
        alert("이벤트 기간에만 신청하실 수 있습니다.");
        return false;
    <% End If %>

    if ($("#phone").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone").focus();
        return;
    }
    var phoneNumber;
    if ($("#phone").val().length > 10) {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,7)+ "-" +$("#phone").val().substring(7,11);
    } else {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,6)+ "-" +$("#phone").val().substring(6,10);
    }

    $.ajax({
        type:"GET",
        url:"/event/etc/doeventSubscript108350.asp",
        data: "mode=kamsg&testCheckDate=<%=currentDate%>&phoneNumber="+btoa(phoneNumber),
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var str;
                        for(var i in Data)
                        {
                                if(Data.hasOwnProperty(i))
                            {
                                str += Data[i];
                            }
                        }
                        str = str.replace("undefined","");
                        res = str.split("|");
                        if (res[0]=="OK") {
                            alert('신청이 완료되었습니다.');
                            $("#phone").val('')
                            $(".pop-container").fadeOut();
                            return false;
                        }else{
                            errorMsg = res[1].replace(">?n", "\n");
                            alert(errorMsg );
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");					
            return false;
        }
    });
}
</script>
			<div class="mEvt108178">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_tit.jpg" alt="선착순 무료 배포 텐바이텐이 다이어리 쏜다! 여러분의 2021년을 응원하며, 텐바이텐이 내년 다이어리를 무료로 쏩니다!"></h2>
                    <div class="number"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_number.png" alt="총 1,000개"></div>
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide01.png" alt="diary">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide02.png" alt="diary">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide03.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide04.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide05.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide06.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide07.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide08.png" alt="diary">
                                </div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide09.png" alt="diary">
								</div>
                                <div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_slide10.png" alt="diary">
								</div>
							</div>
						</div>
                    </div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_sub_tit.jpg" alt="알람 신청하면 오픈되기 전에 잊지 않게 알려드릴게요!">
                    <!-- for dev msg : button 클릭시 팝업 노출 -->
                    <div class="go-link">
                        <button type="button" class="btn-open"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_btn01.png" alt="사전 알림 신청하기"></button>
                    </div>
                </div>
                <div class="section-02">
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_sub.jpg" alt="텐바이텐에서 28,487 개의 다이어리 중 나만의 다디어리를 찾아보세요!"></a>
                </div>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_noti.jpg" alt="유의사항"></p>
                <!-- for dev msg : 알람 신청 버튼 클릭 시 노출 팝업 -->
				<div class="pop-container">
					<div class="pop-inner">
                        <div class="pop-contents">
                            <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_pop_txt.png" alt="오픈 시간이 다가오면 카카오 알림톡 또는 문자메시지로 빠르게 알려드립니다."></p>
                            <div class="pop-input">
                                <input type="number" id="phone" placeholder="휴대폰 번호를 입력해주세요" maxlength="11" oninput="maxLengthCheck(this)">
                                <button type="button" onclick="fnSendToKakaoMessage()">확인</button>
                            </div>
                            <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108178/m/img_pop_txt02.png" alt="알림은 12월 14일 10시오픈 전에 1회만 발송되는 메시지입니다."></p>
                        </div>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                <!-- //알람 신청 버튼 클릭 시 노출 팝업 -->
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
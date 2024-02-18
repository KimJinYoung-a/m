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
' Description : 2021 스누피 찐덕후 능력고사
' History : 2021-07-06 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "108377"
	moECode = "104345"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111684"
	moECode = "112225"
    mktTest = True
Else
	eCode = "111684"
	moECode = "112225"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-07-12")		'이벤트 시작일
eventEndDate 	= cdate("2021-07-31")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-07-12")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("피너츠 찐덕후 능력고사")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/111684/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "피너츠 찐덕후 능력고사"
Dim kakaodescription : kakaodescription = "피너츠 어디까지 알고있니? 능력고사 참여하고 피너츠 덕후템 받아가자!"
Dim kakaooldver : kakaooldver = "피너츠 어디까지 알고있니? 능력고사 참여하고 피너츠 덕후템 받아가자!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/111684/m/img_kakao.jpg?v=2"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim subscriptcount
if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
end if

%>
<style>
/* common */
.mEvt111684 .section{position:relative;}

/* main section01 */
.mEvt111684 .main .test_start{position:absolute;top:44.8rem;left:50%;margin-left:-42.95vw;display:block;width:85.9vw;height:5.3rem;}

/* quiz section02 */
.mEvt111684 .quiz{display:none;}
.mEvt111684 .quiz .btn_close{width:12vw;height:4rem;position:absolute;top:1rem;right:1rem;display:block;z-index: 1;}
/* quiz01 */
.mEvt111684 .quiz .quiz01 button{position:absolute;left:50%;width:77.3vw;height:3.5rem;margin-left:-38.65vw;}
.mEvt111684 .quiz .quiz01 .button01{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A01_01.png)no-repeat 0 0;background-size:100%;top:26rem;}
.mEvt111684 .quiz .quiz01 .button02{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B01_01.png)no-repeat 0 0;background-size:100%;top:30.5rem;}
.mEvt111684 .quiz .quiz01 .button03{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C01_01.png)no-repeat 0 0;background-size:100%;top:35rem;}
.mEvt111684 .quiz .quiz01 .button04{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D01_01.png)no-repeat 0 0;background-size:100%;top:39.5rem;}
.mEvt111684 .quiz .quiz01 .button01.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A01_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz01 .button02.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B01_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz01 .button03.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C01_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz01 .button04.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D01_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}

/* quiz02 */
.mEvt111684 .quiz .quiz02 button{position:absolute;width:33.3vw;height:3.5rem;}
.mEvt111684 .quiz .quiz02 .button01{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A02_01.png)no-repeat 0 0;background-size:100%;top:24.5rem;left:13.3vw;}
.mEvt111684 .quiz .quiz02 .button02{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B02_01.png)no-repeat 0 0;background-size:100%;top:24.5rem;left:53.3vw;}
.mEvt111684 .quiz .quiz02 .button03{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C02_01.png)no-repeat 0 0;background-size:100%;top:41rem;left:13.3vw;}
.mEvt111684 .quiz .quiz02 .button04{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D02_01.png)no-repeat 0 0;background-size:100%;top:41rem;left:53.3vw;}
.mEvt111684 .quiz .quiz02 .button01.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A02_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz02 .button02.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B02_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz02 .button03.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C02_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz02 .button04.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D02_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}

/* quiz03 */
.mEvt111684 .quiz .quiz03 button{position:absolute;left:50%;width:77.3vw;height:3.5rem;margin-left:-38.65vw;}
.mEvt111684 .quiz .quiz03 .button01{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A03_01.png)no-repeat 0 0;background-size:100%;top:26rem;}
.mEvt111684 .quiz .quiz03 .button02{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B03_01.png)no-repeat 0 0;background-size:100%;top:30.5rem;}
.mEvt111684 .quiz .quiz03 .button03{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C03_01.png)no-repeat 0 0;background-size:100%;top:35rem;}
.mEvt111684 .quiz .quiz03 .button04{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D03_1.png)no-repeat 0 0;background-size:100%;top:39.5rem;}
.mEvt111684 .quiz .quiz03 .button01.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A03_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz03 .button02.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B03_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz03 .button03.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C03_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz03 .button04.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D03_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}

/* quiz04 */
.mEvt111684 .quiz .quiz04 button{position:absolute;left:50%;width:77.3vw;height:3.5rem;margin-left:-38.65vw;}
.mEvt111684 .quiz .quiz04 .button01{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A04_01.png)no-repeat 0 0;background-size:100%;top:28rem;}
.mEvt111684 .quiz .quiz04 .button02{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B04_01.png)no-repeat 0 0;background-size:100%;top:32.5rem;}
.mEvt111684 .quiz .quiz04 .button03{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C04_01.png)no-repeat 0 0;background-size:100%;top:37rem;}
.mEvt111684 .quiz .quiz04 .button04{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D04_01.png)no-repeat 0 0;background-size:100%;top:41.5rem;}
.mEvt111684 .quiz .quiz04 .button01.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A04_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz04 .button02.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B04_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz04 .button03.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C04_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz04 .button04.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D04_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}

/* quiz05 */
.mEvt111684 .quiz .quiz05 button{position:absolute;width:33.3vw;height:3.5rem;}
.mEvt111684 .quiz .quiz05 .button01{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A05_01.png)no-repeat 0 0;background-size:100%;top:24.5rem;left:13.3vw;}
.mEvt111684 .quiz .quiz05 .button02{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B05_01.png)no-repeat 0 0;background-size:100%;top:24.5rem;left:53.3vw;}
.mEvt111684 .quiz .quiz05 .button03{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C05_01.png)no-repeat 0 0;background-size:100%;top:41rem;left:13.3vw;}
.mEvt111684 .quiz .quiz05 .button04{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D05_01.png?v=2)no-repeat 0 0;background-size:100%;top:41rem;left:53.3vw;}
.mEvt111684 .quiz .quiz05 .button01.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/A05_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz05 .button02.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/B05_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz05 .button03.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/C05_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}
.mEvt111684 .quiz .quiz05 .button04.on{background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/D05_02.png)no-repeat 0 0;background-size:100%;transition: .5s ease all;}

/* final section03*/
.mEvt111684 .final{display:none;}
.mEvt111684 .final .f_title{position:absolute;width:71.1vw;top:3rem;left:8.93vw;animation-name: zoomer;	-webkit-animation-name: zoomer;animation-duration: 1s;-webkit-animation-duration: 1s;animation-timing-function: cubic-bezier(0.5, 0.2, 0.3, 1.0);	
	-webkit-animation-timing-function: cubic-bezier(0.5, 0.2, 0.3, 1.0);-webkit-animation-iteration-count: 1; animation-iteration-count: 1;visibility: visible !important;}
.mEvt111684 .final .f_img{position:absolute;width:58.93vw;top:11rem;left:50%;margin-left:-29.465vw;animation-name: zoomer;	-webkit-animation-name: zoomer;animation-duration: 1.5s;-webkit-animation-duration: 1.5s;animation-timing-function: cubic-bezier(0.5, 0.2, 0.3, 1.0);	
	-webkit-animation-timing-function: cubic-bezier(0.5, 0.2, 0.3, 1.0);-webkit-animation-iteration-count: 1; animation-iteration-count: 1;visibility: visible !important;}
.mEvt111684 .final .f_sub01{position:absolute;width:55.73vw;top:32.5rem;left:120%;margin-left:-27.865vw;-webkit-transition: all 1.5s 425ms cubic-bezier(0.680, -0.550, 0.265, 1.550);}
.mEvt111684 .final .f_sub01.on{left:50%;}
.mEvt111684 .final .f_sub02{position:absolute;width:78.53vw;top:36rem;left:150%;margin-left:-39.265vw;-webkit-transition: all 1.5s 555ms cubic-bezier(0.680, -0.550, 0.265, 1.550);}
.mEvt111684 .final .f_sub02.on{left:50%;}
.mEvt111684 .final .snoopy_submit{position:absolute;width:85.9vw;height:5.5rem;top:42rem;left:50%;margin-left:-42.95vw;display:block;background:transparent;}
.mEvt111684 .final .go_peanuts{position:absolute;width:85.9vw;height:5.5rem;top:57.5rem;left:50%;margin-left:-42.95vw;display:block;}
.mEvt111684 .final .again{position:absolute;width:85.9vw;height:5.5rem;top:64rem;left:50%;margin-left:-42.95vw;display:block;}
.mEvt111684 .final .btn_close{width:7.73vw;height:4rem;position:absolute;top:2.8rem;right:1.5rem;display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/111684/m/btn_close.png)no-repeat 0 0;background-size:100%;}

/* final02 */
.mEvt111684 .final .final04 .f_title{width:61.5vw;left:13.73vw;}
.mEvt111684 .final .final04 .f_sub01{width:54.93vw;margin-left:-27.465vw;}
.mEvt111684 .final .final04 .f_sub02{width:58.4vw;margin-left:-29.2vw;}

/* final03 */
.mEvt111684 .final .final03 .f_title{width:74.93vw;left:7.1vw;}
.mEvt111684 .final .final03 .f_sub01{width:54.93vw;margin-left:-27.465vw;}
.mEvt111684 .final .final03 .f_sub02{width:84.93vw;margin-left:-42.465vw;}

/* final04 */
.mEvt111684 .final .final02 .f_title{width:66.53vw;left:10.8vw;}
.mEvt111684 .final .final02 .f_sub01{width:53.9vw;margin-left:-26.95vw;}
.mEvt111684 .final .final02 .f_sub02{width:84.93vw;margin-left:-42.465vw;}

/* final05 */
.mEvt111684 .final .final01 .f_title{width:66.7vw;left:11.5vw;}
.mEvt111684 .final .final01 .f_sub01{width:53.3vw;margin-left:-26.65vw;}
.mEvt111684 .final .final01 .f_sub02{width:65.9vw;margin-left:-32.95vw;}

/* final06 */
.mEvt111684 .final .final00 .f_title{width:66.3vw;left:11.5vw;}
.mEvt111684 .final .final00 .f_sub01{width:54vw;margin-left:-27vw;}
.mEvt111684 .final .final00 .f_sub02{width:49.3vw;margin-left:-24.65vw;}

/* popup */
.mEvt111684 .popup .bg_dim{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.8);}
.mEvt111684 .popup .pop{display:none;position:absolute;top:5rem;left:50%;margin-left:-45.35vw;width:90.7vw;z-index: 1;}
.mEvt111684 .popup .pop .btn_close{position:absolute;top:0;width:5rem;height:5rem;right:0;display:block;}

/* popup01 */
.mEvt111684 .popup .popup01 .instagram{position:absolute;width:39.3vw;height:5.5rem;bottom:7rem;left:1.7rem;}
.mEvt111684 .popup .popup01 .kakao{position:absolute;width:39.3vw;height:5.5rem;bottom:7rem;right:1.7rem;}

/* popup02,03 */
.mEvt111684 .popup .pop .peanuts{position:absolute;width:80vw;left:50%;margin-left:-40vw;height:5.5rem;top:34rem;}

.mEvt111684 .swiper-slide {width:100%;}

@-webkit-keyframes zoomer {
  0% {
    -webkit-transform: scale(0);
  }
  100% {
    -webkit-transform: scale(1);
  }
}
@keyframes zoomer {
  0% {
    transform: scale(0);
  }
  100% {
    transform: scale(1);
  }
}
</style>
			<div class="mEvt111684">
                <!-- main -->
                <!-- 최초 접근 시 보이는 화면, 최초 접근 시에는 메인만 노출-->
                <div class="main section section01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/main.jpg" alt="">
                    <a href="" onclick="fnStartTest();return false;" class="test_start"></a>
                </div>
                <!-- 문제지 부분, 답 노출 후 다음 문제지로 슬라이드 되어야 함. -->
                <div class="quiz section section02">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide quiz01">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/question01.jpg?v=4" alt="">
                                <button type="button" class="button01 false" onclick="doAnswer(1,1);"></button>
                                <button type="button" class="button02 false" onclick="doAnswer(1,2);"></button>
                                <button type="button" class="button03 false" onclick="doAnswer(1,3);"></button>
                                <button type="button" class="button04 false" onclick="doAnswer(1,4);"></button>
                            </div>
                            <div class="swiper-slide quiz02">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/question02.jpg?v=4" alt="">
                                <button type="button" class="button01 false" onclick="doAnswer(2,1);"></button>
                                <button type="button" class="button02 false" onclick="doAnswer(2,2);"></button>
                                <button type="button" class="button03 false" onclick="doAnswer(2,3);"></button>
                                <button type="button" class="button04 false" onclick="doAnswer(2,4);"></button>
                            </div>
                            <div class="swiper-slide quiz03">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/question03.jpg?v=4" alt="">
                                <button type="button" class="button01 false" onclick="doAnswer(3,1);"></button>
                                <button type="button" class="button02 false" onclick="doAnswer(3,2);"></button>
                                <button type="button" class="button03 false" onclick="doAnswer(3,3);"></button>
                                <button type="button" class="button04 false" onclick="doAnswer(3,4);"></button>
                            </div>
                            <div class="swiper-slide quiz04">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/question04.jpg?v=4" alt="">
                                <button type="button" class="button01 false" onclick="doAnswer(4,1);"></button>
                                <button type="button" class="button02 false" onclick="doAnswer(4,2);"></button>
                                <button type="button" class="button03 false" onclick="doAnswer(4,3);"></button>
                                <button type="button" class="button04 false" onclick="doAnswer(4,4);"></button>
                            </div>
                            <div class="swiper-slide quiz05">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/question05.jpg?v=4" alt="">
                                <button type="button" class="button01 false" onclick="doAnswer(5,1);"></button>
                                <button type="button" class="button02 false" onclick="doAnswer(5,2);"></button>
                                <button type="button" class="button03 false" onclick="doAnswer(5,3);"></button>
                                <button type="button" class="button04 false" onclick="doAnswer(5,4);"></button>
                            </div>
                        </div>
                    </div>
                    <a href="" onclick="fnResetQuiz();return false;" class="btn_close"></a>
                </div>
                <!-- 결과지 부분 -->
                <div class="final section section03">
                    <div class="final05" style="display:none;"><!-- 5점 만점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg01.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title01.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img01.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub01_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub01_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <div class="final04" style="display:none;"><!-- 4점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg02.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title02.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img02.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub02_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub02_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <div class="final03" style="display:none;"><!-- 3점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg03.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title03.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img03.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub03_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub03_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <div class="final02" style="display:none;"><!-- 2점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg04.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title04.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img04.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub04_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub03_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <div class="final01" style="display:none;"><!-- 1점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg05.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title05.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img05.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub05_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub05_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <div class="final00" style="display:none;"><!-- 0점 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_bg06.jpg" alt="">
                        <p class="f_title"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_title06.png" alt=""></p>
                        <p class="f_img"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_img06.png" alt=""></p>
                        <p class="f_sub01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub06_01.png" alt=""></p>
                        <p class="f_sub02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/final_sub06_02.png" alt=""></p>
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="go_peanuts"></a>
                    </div>
                    <!-- 공통 적용된 부분 -->
                    <button type="button" onclick="doAction();return false;" class="snoopy_submit"></button>                    
                    <a href="" onclick="fnResetQuiz();return false;" class="again"></a>
                    <a href="" onclick="fnResetQuiz();return false;" class="btn_close"></a>
                </div>

                <!-- 팝업영역 -->
                <div class="popup section04">
                    <div class="bg_dim"></div>
                    <div class="popup01 pop" style="display:none;"><!-- 최초 응모 시 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/popup01.png?v=2" alt="">
                        <a href="" onclick="snschk('insta');return false;" class="instagram"></a>
                        <a href="" onclick="snschk('kakao');return false;" class="kakao"></a>
                        <a href="" class="btn_close"></a>
                    </div>
                    <div class="popup02 pop" style="display:none;"><!-- 1회 공유 완료 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/popup02.png?v=2" alt="">
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="peanuts"></a>
                        <a href="" class="btn_close"></a>
                    </div>
                    <div class="popup03 pop" style="display:none;"><!-- 공유 전부 사용 -->
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111684/m/popup03.png?v=2" alt="">
                        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112225');return false;" class="peanuts"></a>
                        <a href="" class="btn_close"></a>
                    </div>
                </div>
			</div>
<input type="hidden" id="q1">
<input type="hidden" id="q2">
<input type="hidden" id="q3">
<input type="hidden" id="q4">
<input type="hidden" id="q5">
<script>

$(function() {
    var swiper = document.querySelector('.swiper-container').swiper;
    swiper.disable();
    $(".snoopy_submit").click(function(){
        $(".bg_dim, .popup01").css("display","block");
        return false;
    });

    $(".pop .btn_close").click(function(){
        $(".bg_dim, .popup01").css("display","none");
        return false;
    });

    $(".mEvt111684 .quiz .btn_close").click(function(){
        $(".mEvt111684 .quiz").css("display","none");
        $(".mEvt111684 .main").css("display","block");
        return false;
    });

    $(".mEvt111684 .final .btn_close").click(function(){
        $(".mEvt111684 .final").css("display","none");
        $(".mEvt111684 .main").css("display","block");
        return false;
    });

    $(".mEvt111684 .section04 .btn_close").click(function(){
        $(".section04").css("display","none");
        $(".popup01").css("display","none");
        $(".popup02").css("display","none");
        $(".popup03").css("display","none");
        return false;
    });
});

function fnStartTest(){
    $(".mEvt111684 .main").css("display","none");
    $(".mEvt111684 .quiz").css("display","block");
    //setTimeout(function(){
        var mySwiper = new Swiper('.swiper-container',{
            speed:500,
            effect:'slide',
            loop:false,
            allowSwipeToPrev:false
        });
    //}, 1500);
    

    fnAmplitudeEventMultiPropertiesAction('click_peanuts_start','evtcode','<%=eCode%>');
    
    return false;
}

function doAnswer(questionNum,AnswerNum) {
    var swiper2 = document.querySelector('.swiper-container').swiper;
    //swiper2.disable();
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
	<% If IsUserLoginOK() Then %>
        $(".quiz0"+questionNum+" button").attr("disabled",true);
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubScript111684.asp",
            data: {
                mode : 'quiz',
                qnum : questionNum,
                qa : AnswerNum,
                q1 : $("#q1").val(),
                q2 : $("#q2").val(),
                q3 : $("#q3").val(),
                q4 : $("#q4").val()
            },
            dataType: "JSON",
            success: function(data){
                
                if(data.response == 'ok'){
                    $(".quiz0"+questionNum+' .button0'+data.anum).removeClass("false").addClass("true on");
                }else if(data.response == 'no'){
                    $(".quiz0"+questionNum+' .button0'+data.anum).removeClass("false").addClass("true on");
                    $(".quiz0"+questionNum+' .button0'+AnswerNum).addClass("on");
                    $(".quiz0"+questionNum+' .button0'+AnswerNum).siblings(".false").removeClass("on");
                }else{
                    alert(data.message);
                    return false;
                }
                $("#q"+questionNum).val(AnswerNum);
                
                if(questionNum!=5){
                    setTimeout(function(){swiper2.slideTo(questionNum, 500, false)},1000);
                    //alert(data.response + "/" + questionNum);
                }else{
                    setTimeout(function(){
                    $(".mEvt111684 .final").css("display","block");
                    $(".mEvt111684 .quiz").css("display","none");
                    $(".mEvt111684 .main").css("display","none");
                    $(".final0"+data.score).css("display","block");
                    $(".f_sub01, .f_sub02").addClass("on");
                    },1000);
                }
                return false;
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        });
	<% else %>
        parent.calllogin();
        return false;
	<% End If %>
}

function fnResetQuiz(){
    location.reload();
    
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
	<% If IsUserLoginOK() Then %>
        <% if subscriptcount > 0 then %>
            $(".section04").css("display","block");
            $(".bg_dim, .popup03").css("display","block");
            return false;
        <% else %>
            $.ajax({
                type: "POST",
                url:"/event/etc/doeventsubscript/doEventSubScript111684.asp",
                data: {
                    mode : 'add',
                    q1 : $("#q1").val(),
                    q2 : $("#q2").val(),
                    q3 : $("#q3").val(),
                    q4 : $("#q4").val(),
                    q5 : $("#q5").val()
                },
                dataType: "JSON",
                success: function(data){
                    fnAmplitudeEventMultiPropertiesAction('click_peanuts_sharing','evtcode','<%=eCode%>');
                    if(data.response == 'ok'){
                        $(".mEvt111684 .main").css("display","block");
                        $(".mEvt111684 .final").css("display","none");
                        $(".final0"+data.score).css("display","none");
                        $(".section04").css("display","block");
                        $(".bg_dim, .popup01").css("display","block");
                    }else{
                        alert(data.message);
                        return false;
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.');
                }
            });
        <% end if %>
	<% else %>
        parent.calllogin();
        return false;
	<% End If %>
}

function snschk(snsdiv) {
	<% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubScript111684.asp",
            data: {
                mode : 'share',
                share : snsdiv
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == 'ok'){
                    if(snsdiv=='kakao'){
                        fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
                    }else{
                        fnAPPShareInstagram('<%=kakaoimage%>', '<%=eCode%>', '<%=kakaotitle%>', 'event');
                    }
                    setTimeout(function(){
                        $(".popup01").css("display","none");
                        $(".bg_dim, .popup02").css("display","block");
                    },3000);
                }else{
                    alert(data.message);
                    return false;
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        });
	<% else %>
        parent.calllogin();
        return false;
	<% End If %>
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
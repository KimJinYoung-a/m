<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 호텔에서 신년 계획짜기
' History : 2022.01.03 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/event_myordercls.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode, sqlstr, myJoinCheck

IF application("Svr_Info") = "Dev" THEN
	eCode = "109439"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116317" 
    moECode = "116318"
    mktTest = True
Else
	eCode = "116317"
    moECode = "116318"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2022-01-06")		'이벤트 시작일
eventEndDate 	= cdate("2022-01-23")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2022-01-06")
else
    currentDate = date()
end if

'// 카카오 링크
Dim kakaotitle : kakaotitle = "호텔에서 신년 계획짜기"
Dim kakaodescription : kakaodescription = "2022년 새해 계획은 쾌적한 호텔에서 짜야 제맛! 2명의 주인공을 찾아요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/116317/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt116317 {position:relative; padding-bottom:5rem; background:#444260;}
.mEvt116317 .topic {position:relative;}
.mEvt116317 .topic .tit {width:20.70rem; position:absolute; left:50%; top:7rem; margin-left:-10.35rem; opacity:0; transform:translateY(2rem); transition:all 1s;}
.mEvt116317 .topic .tit.on {opacity:1; transform:translateY(0);}
.mEvt116317 .btn-join {width:26.89rem; position:fixed; left:50%; bottom:2rem; transform: translateX(-50%); background:transparent; z-index:10;}
.mEvt116317 .btn-join.hide {display:none;}
.mEvt116317 .noti-area {text-align:center; background:#444260;}
.mEvt116317 .noti-area .btn-noti {position:relative;}
.mEvt116317 .noti-area .btn-noti .icon {display:inline-block; width:0.90rem; height:0.60rem; position:absolute; right:30%; top:50%; margin-left:0.45rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/icon_arrow.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .noti-area .btn-noti.on .icon {transform: rotate(180deg);}
.mEvt116317 .noti-area .noti-info {display:none; margin-bottom:-10rem;}
.mEvt116317 .noti-area .btn-noti.on + .noti-info {display:block;}
.mEvt116317 .page {padding:2.13rem 1.7rem 8.13rem; position:fixed; left:0; top:0; width:100%; height:100vh; z-index:20; background:#fff; overflow-y:scroll;}
.mEvt116317 .page.page-02 {z-index:25;}
.mEvt116317 .page.page-03 {z-index:30;}
.mEvt116317 .page.pop {padding:0; z-index:31;}
.mEvt116317 .page .top {position:relative;}
.mEvt116317 .page .top .home {display:inline-block; width:6.10rem;}
.mEvt116317 .page .page-count {position:absolute; left:50%; top:0; transform:translateX(-50%); font-size:1.28rem; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt116317 .page .select-area {display:flex; align-items:flex-start; justify-content:center; flex-wrap:wrap;}
.mEvt116317 .page .select-area button {display:block; width:100%; height:100%; font-size:0; background:transparent;}
.mEvt116317 .page .select-area div:nth-child(odd) {margin-right:0.43rem;}
.mEvt116317 .page .select-area div:nth-child(even) {margin-left:0.43rem;}
.mEvt116317 .page-01 .tit {width:15.36rem; padding:5.76rem 0 5.97rem; margin:0 auto;}
.mEvt116317 .page-02 .tit {width:13.57rem; padding:5.76rem 0 5.97rem; margin:0 auto;}
.mEvt116317 .page-03 .tit {width:10.97rem; padding:5.76rem 0 5.97rem; margin:0 auto;}
.mEvt116317 .page-02 .select-area div {margin-bottom:2.35rem;}
.mEvt116317 .page-03 .select-area div {margin-bottom:2.35rem;}

.mEvt116317 .page-01 .select-area .item01 {width:13.87rem; height:24.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item01_01_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-01 .select-area .item01.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item01_01_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-01 .select-area .item02 {width:13.87rem; height:24.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item01_02_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-01 .select-area .item02.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item01_02_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area {height:55.5rem; overflow:hidden;}
.mEvt116317 .page-02 .select-area .item01 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_01_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item01.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_01_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item02 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_02_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item02.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_02_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item03 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_03_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item03.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_03_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item04 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_04_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item04.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_04_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item05 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_05_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item05.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_05_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item06 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_06_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item06.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_06_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item07 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_07_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item07.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_07_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item08 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_08_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item08.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_08_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item09 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_09_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item09.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_09_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item10 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_10_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item10.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_10_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item11 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_11_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item11.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_11_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item12 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_12_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item12.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_12_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item13 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_13_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item13.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_13_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item14 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_14_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item14.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_14_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item15 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_15_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item15.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_15_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item16 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_16_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item16.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_16_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item17 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_17_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item17.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_17_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item18 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_18_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item18.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_18_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item19 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_19_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item19.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_19_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item20 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_20_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item20.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_20_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item21 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_21_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item21.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_21_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item22 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_22_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item22.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_22_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item23 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_23_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item23.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_23_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item24 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_24_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-02 .select-area .item24.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_24_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item25 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_25_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item25.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_25_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item26 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_26_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item26.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_26_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item27 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_27_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item27.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_27_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item28 {width:13.87rem; height:16.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_28_off.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .page-03 .select-area .item28.on {background:url(//webimage.10x10.co.kr/fixevent/event/2021/116317/m/item02_28_on.png) no-repeat 0 0; background-size:100%;}
.mEvt116317 .pop .txt {position:absolute; left:50%; top:8.3rem; transform:translateX(-50%); font-size:2.77rem; line-height:1.3; color:#1a194b; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; white-space:nowrap;}
.mEvt116317 .pop .txt .id {display:inline-block; line-height:1; vertical-align:top; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; border-bottom:0.2rem solid #1a194b;}
.mEvt116317 .pop .home {position:absolute; left:1rem; top:1rem; width:8rem; height:3rem; font-size:0; text-indent:-9999px;}
.mEvt116317 .pop button {background:transparent; font-size:0; text-indent:-9999px;}
.mEvt116317 .pop button.btn-01 {position:absolute; left:0; top:33.5rem; width:100%; height:7rem;}
.mEvt116317 .pop button.btn-02 {position:absolute; left:0; top:41rem; width:100%; height:7rem;}
.mEvt116317 .pop .btn-03 {position:absolute; left:0; top:85rem; width:100%; height:7rem; font-size:0; text-indent:-9999px;}

.mEvt116317 .dim {display:none;width:100%; height:100vh; position:fixed; left:0; top:0; background:#fff; z-index:11;}
.mEvt116317 .page-02 .reload {text-align:center;}
.mEvt116317 .page-02 .btn-reload {width:9.94rem; height:5.24rem; margin:0 auto; font-size:0; background:transparent;}
.no-scroll {overflow:hidden;}

/* 당첨자 팝업 */
.mEvt116317 .lyr.pop02 {display:block; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116317 .lyr.pop02 .inner{width:86%;position:absolute; left:50%; top:9%; transform:translateX(-50%);padding-bottom: 12vw;}
.mEvt116317 .lyr.pop02 .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}
.mEvt116317 .lyr.pop02 .link01{display: block;width: 100%;height: 12.4vw;position: absolute;bottom:33vw;}
.mEvt116317 .lyr.pop02 .link02{display: block;width: 100%;height: 21vw;position: absolute;bottom:12vw;}
</style>
<script>
let _answer1=0;
let _answer2=0;
let _answer3=0;
let _reloaditem=1;
$(function() {
    $('.topic .tit').addClass('on');
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
        var deadline = $('.noti-area').offset().top - 600;

        // 접근하기 쉽게 현재 스크롤의 위치를 저장한다. 
        var st = $(this).scrollTop();

        if (st >= deadline){
            $('.btn-join').addClass('hide');
        } else {
            $('.btn-join').removeClass('hide');
        }
    }
    // 유의사항 활성화
    $('.btn-noti').on('click',function(){
        if($(this).hasClass('on')) {
            $('.btn-noti').removeClass('on')
        } else {
            $('.btn-noti').removeClass('on')
            $(this).addClass('on')
        }
    });

    // popup 위치조절
    var headerTop = $('#header').height();
    $('.page').css('top',headerTop);
    // popup 호출시 background 스크롤 막기
    /* var bodyscroll = $(top.document).find("body");
    if($('.page-01,.page-02,.page-03,.pop').is(':visible') == false) {
        $(bodyscroll).removeClass('no-scroll');
        $('.dim').css('display','none');
    } else {
        $(bodyscroll).addClass('no-scroll');
        $('.dim').css('display','block');
    };
    $(top.document).find("body").addClass("no-scroll-test"); */
    // item 선택
    $('.select-area button').on('click',function(){
        if($(this).parent().hasClass('on')) {
            $('.select-area button').parent().removeClass('on');
        } else {
            $('.select-area button').parent().removeClass('on');
            $(this).parent().addClass('on');
        }
    });

    // 당첨자 팝업
    if($('.pop02').is(':visible')){
        $('body').addClass('no-scroll');    
    }

    $('.mEvt116317 .pop02 .btn_close').click(function(){
        $('.pop02').css('display','none');
        $('body').removeClass('no-scroll'); 
        return false;
	})
});

function fnJoinEvent(){
<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
    alert("이벤트 참여기간이 아닙니다.");
    return false;
<% end if %>
<% If IsUserLoginOK() Then %>
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116317.asp",
        data: {
            mode: 'check'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $(".page-01").show();
                $('.dim').show();
            }else if(data.response == "retry"){
                alert(data.message);
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    })
<% else %>
    calllogin();
    return false;
<% end if %>
}

function fnResetEvent(obj){
    $(".page-01").show();
    $(".mEvt116317 .page-01 .select-area .item01").removeClass(" on");
    $(".mEvt116317 .page-01 .select-area .item02").removeClass(" on");
    $(obj).hide();
    $('.dim').hide();
    _answer1=0;
    _answer2=0;
    _answer3=0;
}

function fnCompleteEvent(obj){
    $(obj).hide();
    $('.dim').hide();
    _answer1=0;
    _answer2=0;
    _answer3=0;
}

function fnSelectHotel(obj){
    _answer1=obj;
    setTimeout(function () {
        $(".page-01").hide();
    }, 500);
    setTimeout(function () {
        $(".page-02").show();
    }, 500);
}

function fnReloadItem(){
    if(_reloaditem%4==0){
        $("#item1").show();
        $("#item2").show();
        $("#item3").show();
        $("#item4").show();
        $("#item5").show();
        $("#item6").show();
        $("#item7").hide();
        $("#item8").hide();
        $("#item9").hide();
        $("#item10").hide();
        $("#item11").hide();
        $("#item12").hide();
        $("#item13").hide();
        $("#item14").hide();
        $("#item15").hide();
        $("#item16").hide();
        $("#item17").hide();
        $("#item18").hide();
        $("#item19").hide();
        $("#item20").hide();
        $("#item21").hide();
        $("#item22").hide();
        $("#item23").hide();
        $("#item24").hide();
    }else if(_reloaditem%4==1){
        $("#item1").hide();
        $("#item2").hide();
        $("#item3").hide();
        $("#item4").hide();
        $("#item5").hide();
        $("#item6").hide();
        $("#item7").show();
        $("#item8").show();
        $("#item9").show();
        $("#item10").show();
        $("#item11").show();
        $("#item12").show();
        $("#item13").hide();
        $("#item14").hide();
        $("#item15").hide();
        $("#item16").hide();
        $("#item17").hide();
        $("#item18").hide();
        $("#item19").hide();
        $("#item20").hide();
        $("#item21").hide();
        $("#item22").hide();
        $("#item23").hide();
        $("#item24").hide();
    }else if(_reloaditem%4==2){
        $("#item1").hide();
        $("#item2").hide();
        $("#item3").hide();
        $("#item4").hide();
        $("#item5").hide();
        $("#item6").hide();
        $("#item7").hide();
        $("#item8").hide();
        $("#item9").hide();
        $("#item10").hide();
        $("#item11").hide();
        $("#item12").hide();
        $("#item13").show();
        $("#item14").show();
        $("#item15").show();
        $("#item16").show();
        $("#item17").show();
        $("#item18").show();
        $("#item19").hide();
        $("#item20").hide();
        $("#item21").hide();
        $("#item22").hide();
        $("#item23").hide();
        $("#item24").hide();
    }else if(_reloaditem%4==3){
        $("#item1").hide();
        $("#item2").hide();
        $("#item3").hide();
        $("#item4").hide();
        $("#item5").hide();
        $("#item6").hide();
        $("#item7").hide();
        $("#item8").hide();
        $("#item9").hide();
        $("#item10").hide();
        $("#item11").hide();
        $("#item12").hide();
        $("#item13").hide();
        $("#item14").hide();
        $("#item15").hide();
        $("#item16").hide();
        $("#item17").hide();
        $("#item18").hide();
        $("#item19").show();
        $("#item20").show();
        $("#item21").show();
        $("#item22").show();
        $("#item23").show();
        $("#item24").show();
    }
    _reloaditem++;
}

function fnSelectDiary(obj){
    _answer2=obj;
    setTimeout(function () {
        $(".page-02").hide();
    }, 500);
    setTimeout(function () {
        $(".page-03").show();
    }, 500);
}

function fnSelectDoll(obj){
    _answer3=obj;
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(_answer1=="" || _answer2=="" || _answer3==""){
			alert("답변 선택이 안 되었습니다.");
            fnResetEvent(3);
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116317.asp",
            data: {
                mode: 'add',
                answer1: _answer1,
                answer2: _answer2,
                answer3: _answer3
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|answer1|answer2|answer3','<%=eCode%>|' + _answer1 + '|' + _answer2 + '|' + _answer3);
                    $(".page-03").hide();
                    $('.pop').css('display','block');
                }else if(data.response == "retry"){
                    alert('이미 참여하셨습니다. 1월 26일 당첨일을 기다려주세요!');
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116317.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
                }else{
                    alert(data.message);
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function snschk(snsnum) {
<% if isapp then %>
    fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
    return false;
<% else %>
    event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
<% end if %>
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
			<div class="mEvt116317">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/main.jpg?v=2.1" alt=" 신년 이벤트">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/tit.png" alt="올해는 호텔에서 계획 세우자"></div>
				</div>
                <div class="noti-area">
                    <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/btn_noti.jpg" alt="유의사항 자세히 보기"><span class="icon"></span></button>
                    <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/noti.jpg" alt="유의사항"></div>
                </div>
                <div class="last-line"></div>
                <button type="button" class="btn-join" onclick="fnJoinEvent();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/btn_join.png" alt="참여하기"></button>
                <!-- 선택 화면 -->
                <!-- page 01 -->
                <div class="dim"></div>
                <div class="page page-01" style="display:none;">
                    <div class="top">
                        <a href="#" onclick="fnResetEvent('.page-01');return false;" class="home"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/home.png" alt="처음으로"></a>
                        <div class="page-count">1 / 3</div>
                        <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/tit02.png" alt="어떤 뷰가 좋아요?"></div>
                    </div>
                    <div class="select-area">
                        <div class="item01"><button type="button" onclick="fnSelectHotel(1);">시그니엘 서울</button></div>
                        <div class="item02"><button type="button" onclick="fnSelectHotel(2);">롯데호텔 제주</button></div>
                    </div>
                </div>
                <!-- page 02 -->
                <div class="page page-02" style="display:none;">
                    <div class="top">
                        <a href="#" onclick="fnResetEvent('.page-02');return false;" class="home"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/home.png" alt="처음으로"></a>
                        <div class="page-count">2 / 3</div>
                        <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/tit03.png" alt="어떤 다이어리에 쓰고 싶나요?"></div>
                    </div>
                    <div id="item-reload" class="select-area">
                        <div class="item01 items" id="item1"><button type="button" onclick="fnSelectDiary(1);">체리 다이어리</button></div>
                        <div class="item02 items" id="item2"><button type="button" onclick="fnSelectDiary(2);">라이프가드너 플래너</button></div>
                        <div class="item03 items" id="item3"><button type="button" onclick="fnSelectDiary(3);">러버스 레코드 6공</button></div>
                        <div class="item04 items" id="item4"><button type="button" onclick="fnSelectDiary(4);">유어플래너 스몰</button></div>
                        <div class="item05 items" id="item5"><button type="button" onclick="fnSelectDiary(5);">모트모트 호그와트</button></div>
                        <div class="item06 items" id="item6"><button type="button" onclick="fnSelectDiary(6);">투모로우 다이어리</button></div>
                        <div class="item07 items" id="item7"><button type="button" onclick="fnSelectDiary(7);">위시 다이어리</button></div>
                        <div class="item08 items" id="item8"><button type="button" onclick="fnSelectDiary(8);">오브적테 다이어리</button></div>
                        <div class="item09 items" id="item9"><button type="button" onclick="fnSelectDiary(9);">아이코닉 버블리</button></div>
                        <div class="item10 items" id="item10"><button type="button" onclick="fnSelectDiary(10);">keep 1년 먼쓸리</button></div>
                        <div class="item11 items" id="item11"><button type="button" onclick="fnSelectDiary(11);">산리오캐릭터즈</button></div>
                        <div class="item12 items" id="item12"><button type="button" onclick="fnSelectDiary(12);">A6 체리픽 지퍼</button></div>
                        <div class="item13 items" id="item13"><button type="button" onclick="fnSelectDiary(13);">몰스킨 다이어리</button></div>
                        <div class="item14 items" id="item14"><button type="button" onclick="fnSelectDiary(14);">오롤리데이 다이어리</button></div>
                        <div class="item15 items" id="item15"><button type="button" onclick="fnSelectDiary(15);">루카랩 빈티지</button></div>
                        <div class="item16 items" id="item16"><button type="button" onclick="fnSelectDiary(16);">6months 다이어리</button></div>
                        <div class="item17 items" id="item17"><button type="button" onclick="fnSelectDiary(17);">일상다꾸 다이어리</button></div>
                        <div class="item18 items" id="item18"><button type="button" onclick="fnSelectDiary(18);">딜라이트 위클리 다이어리</button></div>
                        <div class="item19 items" id="item19"><button type="button" onclick="fnSelectDiary(19);">체리 다이어리</button></div>
                        <div class="item20 items" id="item20"><button type="button" onclick="fnSelectDiary(20);">라이프가드너 플래너</button></div>
                        <div class="item21 items" id="item21"><button type="button" onclick="fnSelectDiary(21);">러버스 레코드 6공</button></div>
                        <div class="item22 items" id="item22"><button type="button" onclick="fnSelectDiary(22);">유어플래너 스몰</button></div>
                        <div class="item23 items" id="item23"><button type="button" onclick="fnSelectDiary(23);">모트모트 호그와트</button></div>
                        <div class="item24 items" id="item24"><button type="button" onclick="fnSelectDiary(24);">투모로우 다이어리</button></div>
                    </div>
                    <div class="reload"><button type="button" class="btn-reload" onclick="fnReloadItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/img_reload.png" alt="새로고침"></button></div>
                </div>
                <!-- page 03 -->
                <div class="page page-03" style="display:none;">
                    <div class="top">
                        <a href="#" onclick="fnResetEvent('.page-03');return false;" class="home"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/home.png" alt="처음으로"></a>
                        <div class="page-count">3 / 3</div>
                        <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/tit04.png" alt="어떤 친구와 함께 갈래요?"></div>
                    </div>
                    <div class="select-area">
                        <div class="item25"><button type="button" onclick="fnSelectDoll(1);">아기 호랑이</button></div>
                        <div class="item26"><button type="button" onclick="fnSelectDoll(2);">대형 스누피</button></div>
                        <div class="item27"><button type="button" onclick="fnSelectDoll(3);">아기 쿼카</button></div>
                        <div class="item28"><button type="button" onclick="fnSelectDoll(4);">마이멜로디</button></div>
                    </div>
                </div>
                <!-- 완료 팝업 -->
                <div class="page pop" style="display:none;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/pop01.jpg" alt="응모 완료!">
                    <div class="txt">
                        <p>좋아요!<br/><span class="id"><%=LoginUserid%></span> 님<br/>응모 완료!</p>
                    </div>
                    <a href="#" onclick="fnCompleteEvent('.pop');return false;" class="home">처음으로</a>
                    <button type="button" onclick="doAlarm();" class="btn-01">당첨자 발표 알림 신청</button>
                    <button type="button" class="btn-02" onclick="snschk('ka');">친구에게 공유하기</button>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2022/index.asp?gaparam=today_banner');return false;" class="btn-03">나에게 맞는 다이어리 고르러 가기</a>
                </div>

                <!-- 당첨자 팝업레이어 -->
                <div class="lyr pop02">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116317/m/pop02.png" alt="">
                        <a href="#" class="btn_close"></a>
                        <a href="#"  onclick="fnAPPpopupBrowserURL('당첨자 발표','http://m.10x10.co.kr/common/news/news_view.asp?type=&idx=19270&page=1');return false;" class="link01"></a>
                        <a href="#"  onclick="fnAPPpopupBrowserURL('진행중인 이벤트','http://m.10x10.co.kr/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt');return false;" class="link02"></a>
                    </div>
                </div> 
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
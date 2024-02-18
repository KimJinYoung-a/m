<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls109781.asp" -->
<%
'####################################################
' Description : 3월에 드리는 선물 1,000만원!
' History : 2021-02-24 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104321"
	moECode = "104320"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "109781"
	moECode = "109780"
    mktTest = True
Else
	eCode = "109781"
	moECode = "109780"
    mktTest = False
End If

Dim gaparamChkVal, testCheckDate
gaparamChkVal = requestCheckVar(request("gaparam"),30)
testCheckDate = requestCheckVar(request("testCheckDate"),10)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-03-02")		'이벤트 시작일
eventEndDate 	= cdate("2021-03-11")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    if testCheckDate<>"" then
        currentDate = cdate(testCheckDate)
    else
        currentDate = cdate("2021-03-02")
    end if
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("총 1,000만원의 혜택")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "총 1,000만원의 혜택"
Dim kakaodescription : kakaodescription = "나의 당첨 결과를 바로 확인해보세요!"
Dim kakaooldver : kakaooldver = "나의 당첨 결과를 바로 확인해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim isSecondTried
dim isFirstTried, checkprd
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if currentDate >= "2021-03-02" and currentDate < "2021-03-05" then
    checkprd = 1
elseif currentDate >= "2021-03-08" and currentDate < "2021-03-10" then
    checkprd = 2
elseif currentDate >= "2021-03-10" and currentDate < "2021-03-12" then
    checkprd = 3
end if

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isFirstTried = pwdEvent.isParticipationDayBase(1,checkprd)
end if

triedNum = chkIIF(isFirstTried, 1, 0)
%>
<style>
.mEvt109781 .topic {position:relative;}
.mEvt109781 .topic h2 {position:absolute; left:50%; top:17%; transform:translate(-50%,0); width:80.53vw; z-index:10;}
.mEvt109781 .topic .txt {position:absolute; left:50%; top:61%; transform:translate(-50%,0); width:77.73vw; z-index:10;}

.dc-group {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%;}
.dc-group .dc {display:inline-block; position:absolute; left:50%; background-repeat:no-repeat; background-size:contain; background-position:50%; animation-iteration-count:100; animation-timing-function:linear; animation-direction:alternate; transform-origin:-100% -100%; transform:scale(2);}
.dc-group .dc1 {top:31.6%; margin-left:-55%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move01.png); animation-name:move4; animation-duration:25s; animation-direction:normal;}
.dc-group .dc2 {top:37.7%; margin-left:-18.7%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move02.png); animation-name:move2; animation-duration:10s; animation-direction:alternate-reverse;}
.dc-group .dc3 {top:-1.7%; margin-left:23.7%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move03.png);animation-name:move1; animation-duration:13s;}
.dc-group .dc4 {top:78.7%; margin-left:-45.3%; width:16.93vw; height:16.93vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move04.png); animation-name:move1; animation-duration:13s;}
.dc-group .dc5 {top:23%; margin-left:40.7%; width:4vw; height:4vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move05.png); animation-name:move3; animation-duration:10s;}
.dc-group .dc6 {top:88.2%; margin-left:31.7%; width:45.33vw; height:33.6vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move06.png); animation-name:move2; animation-duration:15s;}
.dc-group .dc7 {top:50.2%; margin-left:20.7%; width:18.13vw; height:12.13vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move07.png); animation-name:move2; animation-duration:15s;}
.dc-group .dc8 {top:63.2%; margin-left:63.7%; width:17.06vw; height:16.26vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move08.png); animation-name:move2; animation-duration:15s;}
/* 2021-03-05 추가 */
.dc-group .dc9 {top:63.2%; margin-left:63.7%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move09.png); animation-name:move2; animation-duration:15s;}
.dc-group .dc10 {top:31.6%; margin-left:-55%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move09.png); animation-name:move4; animation-duration:15s;}
.dc-group .dc11 {top:-1.7%; margin-left:-18.7%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move09.png); animation-name:move2; animation-duration:15s;}
.dc-group .dc12 {top:50.2%; margin-left:20.7%; width:5.86vw; height:16.8vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_move09.png); animation-name:move1; animation-duration:15s;}
/* // */
.mEvt109781 .section-01 {position:relative;}
.mEvt109781 .section-01 .item-list {position:absolute; left:0; top:46%; width:100%; display:flex; align-items:flex-start; justify-content:center; flex-wrap:wrap;}
.mEvt109781 .section-01 .item-list.list-02 {top:62%;}
.mEvt109781 .section-01 .item-info .info-box {position:relative; height:23.93vw;}
.mEvt109781 .section-01 .item-list .item-01 {width:19.6vw; height:23.93vw; left:15%;}
.mEvt109781 .section-01 .item-info.item-01 .info-box::before {animation-duration:1.2s; animation-delay:.3s;}
.mEvt109781 .section-01 .item-list .item-02 {width:20.53vw; height:23.93vw; left:40%;}
.mEvt109781 .section-01 .item-list .item-03 {width:19.73vw; height:23.93vw; left:66%;}
.mEvt109781 .section-01 .item-info.item-03 .info-box::before {animation-duration:1.5s; animation-delay:.6s;}
.mEvt109781 .section-01 .item-list .item-04 {width:21.33vw; height:23.93vw; top:40vw; left:4%;}
.mEvt109781 .section-01 .item-list .item-05 {width:20.13vw; height:23.93vw; top:40vw; left:29%;}
.mEvt109781 .section-01 .item-info.item-05 .info-box::before {animation-duration:.8s; animation-delay:.4s;}
.mEvt109781 .section-01 .item-list .item-06 {width:21.33vw; height:23.93vw; top:40vw; left:54%;}
.mEvt109781 .section-01 .item-list .item-07 {width:20.8vw; height:23.93vw; top:40vw; left:77%;}
.mEvt109781 .section-01 .item-info.item-07 .info-box::before {animation-duration:1.8s; animation-delay:.8s;}
.mEvt109781 .section-01 .item-info {position:absolute; left:0; top:0; cursor:pointer;}
.mEvt109781 .section-01 .item-info img {position:absolute; left:0; top:0; z-index:10;}
.mEvt109781 .section-01 .item-info .info-box::before {content:""; position:absolute; left:50%; top:0; display:inline-block; width:17.2vw; height:18.59vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_ipad.png) no-repeat 50% 0; background-size:100%; z-index:1; transform:translate(-50%,0); animation: updown 1s ease-in-out alternate infinite;}
.mEvt109781 .section-01 .item-info .hide {display:none;}
.mEvt109781 .section-01 .item-info.on .hide {display:block;}
.mEvt109781 .section-01 .item-info .show {display:block;}
.mEvt109781 .section-01 .item-info.on .show {display:none;}
.mEvt109781 .section-01 .btn-apply {position:absolute; left:50%; bottom:5%; width:80.13vw; transform:translate(-50%,0); background:transparent;}

.mEvt109781 .section-02 {padding:4.34rem 1.73rem 0; background:#fff;}
.mEvt109781 .section-02 .btn-win {width:38.53vw; position:relative; background:transparent;}
.mEvt109781 .section-02 .btn-win::before {content:""; position:absolute; right:0; top:0.5rem; width:2.93vw; height:1.73vw; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_arrow.png) no-repeat 50% 0; background-size:100%; transform: rotate(180deg);}
.mEvt109781 .section-02 .btn-win.on::before {content:""; transform: rotate(0);}
.mEvt109781 .section-02 .winner-info {display:none;}
.mEvt109781 .section-02 .winner-info.on {display:block;}
.mEvt109781 .section-02 .winner-info .tit {padding-bottom:1.26rem; padding-top:2.17rem; font-size:3.73vw; color:#222; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt109781 .section-02 .winner-info .user,
.mEvt109781 .section-02 .winner-info .no-user {font-size:3.46vw; color:#444;}
.mEvt109781 .section-02 .winner-info .user {display:flex; flex-wrap:wrap;}
.mEvt109781 .section-02 .winner-info .user li {width:50%; padding-bottom:1.26rem;}
.mEvt109781 .section-02 .winner-info .user li:last-child {padding-bottom:0;}

.mEvt109781 .section-03 {height:97vw; padding:6.08rem 1.73rem 0; background:#fff;}
.mEvt109781 .section-03 .bar {position:absolute; left:0; top:0; width:100%; height:1px; background:#000;}
.mEvt109781 .section-03 .event-schedule {position:relative; margin-top:2rem;}
.mEvt109781 .section-03 .schedule-list {display:flex; align-items:flex-start; justify-content:center; position: absolute; left: 50%; top: -7vw; transform: translate(-50%,0); width: 100%; z-index: 10;}
.mEvt109781 .section-03 .schedule-list .day-02 {padding:0 21%;}
.mEvt109781 .section-03 .schedule-list .day-01 img {width:13.73vw;}
.mEvt109781 .section-03 .schedule-list .day-02 img {width:15.46vw;}
.mEvt109781 .section-03 .schedule-list .day-03 img {width:13.33vw;}
.mEvt109781 .section-03 .schedule-list a {display:inline-block;}

.mEvt109781 .section-04 {position:relative; padding:0 1.73rem; background:#fff;}
.mEvt109781 .section-04 .btn-alram {width:63vw; height:32%; position:absolute; left:4%; bottom:41%; background:transparent;}
.mEvt109781 .section-04 .user-name {padding-bottom:2.82rem; font-size:5.60vw; color:#111; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt109781 .section-04 .user-name span {display:inline-block; position:relative;}
.mEvt109781 .section-04 .user-name span::before {content:""; position:absolute; left:0; top:107%; width:100%; height:2px; background:#444;}

.mEvt109781 .section-05 {position:relative; padding:0 1.73rem; background:#fff;}
.mEvt109781 .section-05 .link-area {position:absolute; left:0; top:0; width:100%;}
.mEvt109781 .section-05 .link-area a {display:inline-block; width:100%; height:inherit;}
.mEvt109781 .section-05 .link-area div {width:100%; height:23vw; margin-bottom:4%;}
@keyframes updown {
    0% {top:0;}
    100% {top:-22%;}
}
@keyframes move1 {
	0%{transform:rotate(0deg) scale(1);}
	50%{transform:rotate(110deg) scale(1);}
	100%{transform:rotate(-110deg) scale(1);}
}
@keyframes move2 {
	0%{transform:rotate(0deg) scale(1);}
	100%{transform:rotate(360deg) scale(1);}
}
@keyframes move3 {
	0%{transform:translate3d(0, 0, 0) scale(1);}
	25%{transform:translate3d(-5rem, 8rem, 0) scale(1);}
	50%{transform:translate3d(-15rem, 0rem, 0) scale(1);}
	75%{transform:translate3d(-20rem, -8rem, 0) scale(1);}
	100%{transform:translate3d(-32rem, 0rem, 0) scale(1);}
}
@keyframes move4 {
	0%{transform:translate3d(0, 0, 0) scale(1);}
	25%{transform:translate3d(20rem, -15rem, 0) scale(1);}
	50%{transform:translate3d(23rem, 10rem, 0) scale(1);}
	75%{transform:translate3d(26rem, 35rem, 0) scale(1);}
	100%{transform:translate3d(0, 0, 0) scale(1);}
}
.mEvt109781 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt109781 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt109781 .pop-container .pop-inner a {display:inline-block;}
.mEvt109781 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt109781 .pop-container .pop-contents {position:relative;}

.mEvt109781 .pop-container.push .pop-contents .btn-push-check {width:100%; height:45%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109781 .pop-container.win .pop-contents .btn-win-check {width:100%; height:45%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109781 .pop-container.fail01 .pop-contents .btn-fail-check01 {width:100%; height:45%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109781 .pop-container.fail02 .pop-contents .btn-fail-check02 {width:100%; height:45%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109781 .pop-container.re-apply01 .pop-contents .btn-re-alram {width:100%; height:45%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt109781 .pop-container.re-apply02 .pop-contents .btn-kakao {width:100%; height:80%; position:absolute; left:0; bottom:0; background:transparent;}

/* 2021-03-05 추가 2차수정 css */
.mEvt109781 .section-01 .btn-apply.second {bottom:4%;}
.mEvt109781 .section-01 .items-list .info-box .case {position:relative; display:flex; flex-wrap:wrap; align-items:center; justify-content:flex-start; width:33.86vw;}
.mEvt109781 .section-01 .items-list .info-box .case::before {content:""; display:inline-block; width:24.8vw; height:17.59vw; position:absolute; left:50%; top:5%; transform:translate(-50%,0); background:url(//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_airpods.png) no-repeat 50% 0; background-size:100%; z-index:1; }
.mEvt109781 .section-01 .items-list .info-box.box-02 .case::before {content:""; top:-3%;}
.mEvt109781 .section-01 .items-list .info-box.box-03 .case::before,
.mEvt109781 .section-01 .items-list .info-box.box-04 .case::before {content:""; top:-4%;}
.mEvt109781 .section-01 .items-list .info-box.box-05 .case::before {content:""; top:-3%;}
.mEvt109781 .section-01 .items-list .info-box.box-06 .case::before {content:""; top:17%;}
.mEvt109781 .section-01 .items-list .info-box.box-07 .case::before {content:""; top:-3%;}
.mEvt109781 .section-01 .items-list .info-box.box-08 .case::before {content:""; top:-3%;}
.mEvt109781 .section-01 .items-list .info-box .case .case-top {animation: shake 1.5s 0.8s both linear infinite; transform-origin: right bottom;}
.mEvt109781 .section-01 .items-list .info-box.box-02 .case .case-top {animation-delay:0.5s; animation-duration:1s;}
.mEvt109781 .section-01 .items-list .info-box.box-03 .case .case-top {animation-delay:0.3s; animation-duration:1.3s;}
.mEvt109781 .section-01 .items-list .info-box.box-04 .case .case-top {animation-delay:0.7s; animation-duration:1.8s;}
.mEvt109781 .section-01 .items-list .info-box.box-05 .case .case-top {animation-delay:1s; animation-duration:1.6s;}
.mEvt109781 .section-01 .items-list .info-box.box-06 .case .case-top {animation-delay:0.8s; animation-duration:1.8s;}
.mEvt109781 .section-01 .items-list .info-box.box-07 .case .case-top {animation-delay:0.9s; animation-duration:2.1s;}
.mEvt109781 .section-01 .items-list .info-box.box-08 .case .case-top {animation-delay:0.7s; animation-duration:2.5s;}
.mEvt109781 .section-01 .items-list .info-box .case img {z-index:10;}
.mEvt109781 .section-01 .items-list .item-air .hide {display:none;}
.mEvt109781 .section-01 .items-list .item-air.on .hide {display:block;}
.mEvt109781 .section-01 .items-list .info-box.on .case::before {content:""; background:none;}
.mEvt109781 .section-01 .items-list .item-air .show {display:block;}
.mEvt109781 .section-01 .items-list .item-air.on .show {display:none;}

.mEvt109781 .section-01 .items-list .info-box.box-01 .case-top {width:29.59vw; margin-left:3%;} 
.mEvt109781 .section-01 .items-list .info-box.box-01 .case-bottom {width:33.86vw; margin-top:-2px;}
.mEvt109781 .section-01 .items-list .info-box.box-01 .hide {width:35.46vw;}
.mEvt109781 .section-01 .items-list .info-box.box-02 .case-top {width:31.06vw; margin-left:0;} 
.mEvt109781 .section-01 .items-list .info-box.box-02 .case-bottom {width:37.33vw; margin-top:-4.5px;}
.mEvt109781 .section-01 .items-list .info-box.box-02 .hide {width:39.06vw;}
.mEvt109781 .section-01 .items-list .info-box.box-03 .case-top {width:31.86vw; margin-left:0;} 
.mEvt109781 .section-01 .items-list .info-box.box-03 .case-bottom {width:36.4vw; margin-top:-1px;}
.mEvt109781 .section-01 .items-list .info-box.box-03 .hide {width:38vw;}
.mEvt109781 .section-01 .items-list .info-box.box-04 .case-top {width:31.33vw; margin-left:0;} 
.mEvt109781 .section-01 .items-list .info-box.box-04 .case-bottom {width:35.46vw; margin-top:-1px;}
.mEvt109781 .section-01 .items-list .info-box.box-04 .hide {width:37.2vw;}
.mEvt109781 .section-01 .items-list .info-box.box-05 .case-top {width:30.86vw; margin-left:0;} 
.mEvt109781 .section-01 .items-list .info-box.box-05 .case-bottom {width:34.93vw; margin-top:0px;}
.mEvt109781 .section-01 .items-list .info-box.box-05 .hide {width:36.8vw;}
.mEvt109781 .section-01 .items-list .info-box.box-06 .case-top {width:30.4vw; margin-left:0.9%;} 
.mEvt109781 .section-01 .items-list .info-box.box-06 .case-bottom {width:33.46vw; margin-top:0px;}
.mEvt109781 .section-01 .items-list .info-box.box-06 .hide {width:35.06vw;}
.mEvt109781 .section-01 .items-list .info-box.box-07 .case-top {width:31.73vw; margin-left:0.9%;} 
.mEvt109781 .section-01 .items-list .info-box.box-07 .case-bottom {width:35.46vw; margin-top:-0.5px;}
.mEvt109781 .section-01 .items-list .info-box.box-07 .hide {width:37.06vw;}
.mEvt109781 .section-01 .items-list .info-box.box-08 .case-top {width:31.73vw; margin-left:0.9%;} 
.mEvt109781 .section-01 .items-list .info-box.box-08 .case-bottom {width:35.6vw; margin-top:0px;}
.mEvt109781 .section-01 .items-list .info-box.box-08 .hide {width:37.33vw;}

.mEvt109781 .section-01 .items-list .info-box.box-01 {position:absolute; left:11%; top:35%;}
.mEvt109781 .section-01 .items-list .info-box.box-02 {position:absolute; left:55%; top:36%;}
.mEvt109781 .section-01 .items-list .info-box.box-03 {position:absolute; left:11%; top:48%;}
.mEvt109781 .section-01 .items-list .info-box.box-04 {position:absolute; left:55%; top:48%;}
.mEvt109781 .section-01 .items-list .info-box.box-05 {position:absolute; left:11%; top:61%;}
.mEvt109781 .section-01 .items-list .info-box.box-06 {position:absolute; left:55%; top:59%;}
.mEvt109781 .section-01 .items-list .info-box.box-07 {position:absolute; left:11%; top:74%;}
.mEvt109781 .section-01 .items-list .info-box.box-08 {position:absolute; left:55%; top:74%;}
@keyframes shake {
    0%, 50%, 100% {
        transform: rotate(0);
    }
    25% {
        transform: rotate(30deg);
    }
    75% {
        transform: rotate(0deg);
    }
}
/* // */
/* 2021-03-08 추가 3차수정 */
.mEvt109781 .section-01 .items-list .item-case .hide {display:none;}
.mEvt109781 .section-01 .items-list .item-case.on .hide {display:block;}
.mEvt109781 .section-01 .items-list .info-box.on .case::before {content:""; background:none;}
.mEvt109781 .section-01 .items-list .item-case .show {display:block;}
.mEvt109781 .section-01 .items-list .item-case.on .show {display:none;}

.mEvt109781 .section-01 .items-list .info-box .phone-case {animation: wave 1s 0.5s linear alternate infinite; transform-origin: center center;}
.mEvt109781 .section-01 .items-list .info-box.case-01 .phone-case {width:20.66vw;} 
.mEvt109781 .section-01 .items-list .info-box.case-01 .hide {width:22.26vw;}
.mEvt109781 .section-01 .items-list .info-box.case-02 .phone-case {width:20.13vw; animation-duration:.7s; animation-delay:.3s;} 
.mEvt109781 .section-01 .items-list .info-box.case-02 .hide {width:21.73vw;}
.mEvt109781 .section-01 .items-list .info-box.case-03 .phone-case {width:21.86vw; animation-duration:1s; animation-delay:.5s;}
.mEvt109781 .section-01 .items-list .info-box.case-03 .hide {width:23.59vw;}
.mEvt109781 .section-01 .items-list .info-box.case-04 .phone-case {width:20.13vw; animation-duration:.5s; animation-delay:.8s;}
.mEvt109781 .section-01 .items-list .info-box.case-04 .hide {width:21.73vw;}
.mEvt109781 .section-01 .items-list .info-box.case-05 .phone-case {width:24.13vw; animation-duration:.9s; animation-delay:.6s;}
.mEvt109781 .section-01 .items-list .info-box.case-05 .hide {width:25.73vw;}
.mEvt109781 .section-01 .items-list .info-box.case-06 .phone-case {width:20.4vw; animation-duration:.3s; animation-delay:.7s;} 
.mEvt109781 .section-01 .items-list .info-box.case-06 .hide {width:22.13vw;}
.mEvt109781 .section-01 .items-list .info-box.case-07 .phone-case {width:20.26vw; animation-duration:.5s; animation-delay:.4s;} 
.mEvt109781 .section-01 .items-list .info-box.case-07 .hide {width:21.86vw;}

.mEvt109781 .section-01 .items-list .info-box.case-01 {position:absolute; left:20%; top:35%;}
.mEvt109781 .section-01 .items-list .info-box.case-02 {position:absolute; left:58%; top:35%;}
.mEvt109781 .section-01 .items-list .info-box.case-03 {position:absolute; left:8%; top:50%;}
.mEvt109781 .section-01 .items-list .info-box.case-04 {position:absolute; left:40%; top:50%;}
.mEvt109781 .section-01 .items-list .info-box.case-05 {position:absolute; left:69%; top:50%;}
.mEvt109781 .section-01 .items-list .info-box.case-06 {position:absolute; left:21%; top:65%;}
.mEvt109781 .section-01 .items-list .info-box.case-07 {position:absolute; left:59%; top:65%;}
@keyframes wave {
    0%, 50%, 100% {
        transform: rotate(0);
    }
    25% {
        transform: rotate(5deg);
    }
    100% {
        transform: rotate(5deg);
    }
}
/* // */
</style>
<script>
var numOfTry = "<%=triedNum%>";
var winClicknum = 0;
$(function() {
    $(document).ready(function(){
        /* 아이패드 선택 토글 */
        var button = $(".section-01 .item-info");
        $(button).on("click",function(){
            $(this).toggleClass("on").siblings().removeClass("on");
        });
        /* 아이팟 선택 토글 */
        var button = $(".section-01 .item-air");
        $(button).on("click",function(){
            $(this).toggleClass("on").siblings().removeClass("on");
        });
        /* 3차 아이폰 케이스 선택 토글 */
        var button = $(".section-01 .item-case");
        $(button).on("click",function(){
            $(this).toggleClass("on").siblings().removeClass("on");
        });
        /* 당첨자 확인 토글 */
        $(".btn-win").on("click",function(){
            $(".winner-info").toggleClass("on");
            $(this).toggleClass("on");
            if(winClicknum<1){
                getWinners(1);
                getWinners(2);
                getWinners(3);
            }
            winClicknum++;
        });
        //팝업
        /* 팝업 닫기 */
        $('.mEvt109781 .btn-close').click(function(){
            $(".pop-container").fadeOut();
        })
        /* 팝업 닫고 오픈 알림 신청 으로 가기  */
        $('.mEvt109781 .btn-re-alram').click(function(){
            $(".pop-container").fadeOut();
        })
    });
});
function getWinners(num){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/realtimeEvent109781Proc.asp",
		dataType: "JSON",
		data: {
                mode: "winner",
                round: num
            },
		success : function(res){		
			renderWinners(res.data,num)
		},
		error:function(err){
			console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}
function renderWinners(data,num){
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	var ix=0;
	//$rootEl.empty();

    tmpEl = tmpEl + '<div class="event-0' + num + '">\
        <p class="tit">event ' + num + '</p>\
            <ul class="user">\
    '
	data.forEach(function(winner){
		tmpEl = tmpEl + '<li><span>' + printUserName(winner.userid, 2, "*") + '</span> <span>' + printUserName(winner.username, 1, "*") + '님</span></li>'
    });
	if(data.length<1){
        tmpEl = tmpEl + '<p class="no-user">아직 당첨자가 없습니다.</p>'
	}
    tmpEl = tmpEl + '   </ul>\
        </div>\
    '
    $rootEl.append(tmpEl)
}
function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}
function fnItemSelect(itemnum){
    $("#pouch").val(itemnum);
}
function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<%' If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		if($("#pouch").val()==""){
			alert("케이스를 선택해 주세요.");
			return false;
		}
        if(numOfTry == '1'){
			// 한번 시도
            <% If (currentDate >= #03/10/2021 00:00:00#) Then %>
			$("#secondTry2").eq(0).delay(500).fadeIn();
            <% else %>
            $("#secondTry").eq(0).delay(500).fadeIn();
            <% end if %>
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: $("#pouch").val()
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent109781Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + $("#pouch").val())
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt);
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
		<%' Else %>
			//alert("이벤트 응모 기간이 아닙니다.");
			//return;
		<%' End If %>
	<% End If %>
}
function popResult(returnCode, itemid, selectedPdt){
	numOfTry++;
	if(returnCode[0] == "B"){
        <% If (currentDate >= #03/08/2021 00:00:00#) Then %>
		$('#fail2').eq(0).delay(500).fadeIn();
        <% else %>
        $('#fail').eq(0).delay(500).fadeIn();
        <% end if %>
		return false;
	}else if(returnCode[0] == "C"){
		$("#winpop").eq(0).delay(500).fadeIn();
        $("#winners").empty();
        $("#itemid").val(itemid);
        getWinners(1);
        getWinners(2);
        getWinners(3);
	}else if(returnCode == "A02"){
        <% If (currentDate >= #03/10/2021 00:00:00#) Then %>
        $("#secondTry2").eq(0).delay(500).fadeIn();
        <% else %>
        $("#secondTry").eq(0).delay(500).fadeIn();
        <% end if %>
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}
function sharesns(snsnum) {
    if(snsnum=="fb"){
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        return false;
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    }else{
        <% if isapp then %>
            fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
            return false;
        <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
        <% end if %>
    }
}
function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/realtimeEvent109781Proc.asp?mode=pushadd",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $('.pop-container.push').fadeIn();
                return false;
            }else{
                alert(result.faildesc);
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    });
}
</script>
<!-- Criteo 홈페이지 태그 -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
window.criteo_q = window.criteo_q || [];
var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
window.criteo_q.push(
 { event: "setAccount", account: 8262}, // 이 라인은 업데이트하면 안됩니다
 { event: "setEmail", email: "<%=MD5(CStr(session("ssnuseremail")))%>" }, // 유저가 로그인이 안되 있는 경우 빈 문자열을 전달
 { event: "setSiteType", type: deviceType},
 { event: "viewHome"});
</script>
<!-- END Criteo 홈페이지 태그 -->
			<div class="mEvt109781">
            <% If (currentDate >= #03/08/2021 00:00:00#) and (currentDate < #03/10/2021 00:00:00#) Then %>
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/bg_top02.jpg" alt="bg">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_tit_02_01.png" alt="3월에 드리는 선물 1,000만원"></h2>
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_sub_02_01.png" alt="새롭게 시작하는 좋은 3월, 총1,000만 원 규모의 혜택 지금 도전하세요!"></div>
                    <div class="dc-group">
						<span class="dc dc9"></span>
						<span class="dc dc10"></span>
						<span class="dc dc12"></span>
						<span class="dc dc4"></span>
						<span class="dc dc5"></span>
						<span class="dc dc6"></span>
						<span class="dc dc7"></span>
						<span class="dc dc8"></span>
					</div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_event02.jpg" alt="에이팟이 숨어있는 케이스를 찾아보세요!">
                    <div class="items-list">
                        <div class="info-box item-air box-01" onclick="fnItemSelect(1);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case01_top.png" alt="케이스1 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case01_bottom.png" alt="케이스1 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case01_select.png" alt="케이스1 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-02" onclick="fnItemSelect(2);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case02_top.png" alt="케이스2 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case02_bottom.png" alt="케이스2 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case02_select.png" alt="케이스2 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-03" onclick="fnItemSelect(3);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case03_top.png" alt="케이스3 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case03_bottom.png" alt="케이스3 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case03_select.png" alt="케이스3 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-04" onclick="fnItemSelect(4);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case04_top.png" alt="케이스4 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case04_bottom.png" alt="케이스4 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case04_select.png" alt="케이스4 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-05" onclick="fnItemSelect(5);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case05_top.png" alt="케이스5 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case05_bottom.png" alt="케이스5 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case05_select.png" alt="케이스5 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-06" onclick="fnItemSelect(6);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case06_top.png" alt="케이스6 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case06_bottom.png" alt="케이스6 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case06_select.png" alt="케이스6 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-07" onclick="fnItemSelect(7);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case07_top.png" alt="케이스7 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case07_bottom.png" alt="케이스7 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case07_select.png" alt="케이스7 선택" class="hide">
                        </div>
                        <div class="info-box item-air box-08" onclick="fnItemSelect(8);">
                            <div class="case">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case08_top.png" alt="케이스8 위" class="show case-top">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case08_bottom.png" alt="케이스8 아래" class="show case-bottom">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_case08_select.png" alt="케이스8 선택" class="hide">
                        </div>
                    </div>
                    <button type="button" class="btn-apply second" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply.png" alt="응모하기"></button>
                </div>
            <% elseIf (currentDate >= #03/10/2021 00:00:00#) and (currentDate < #03/12/2021 00:00:00#) Then %>
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/bg_top03.jpg" alt="bg">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_tit_03_01.png" alt="3월에 드리는 선물 1,000만원"></h2>
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_sub_03_01.png" alt="새롭게 시작하는 좋은 3월, 총1,000만 원 규모의 혜택 지금 도전하세요!"></div>
                    <div class="dc-group">
						<span class="dc dc9"></span>
						<span class="dc dc10"></span>
						<span class="dc dc12"></span>
						<span class="dc dc4"></span>
						<span class="dc dc5"></span>
						<span class="dc dc6"></span>
						<span class="dc dc7"></span>
						<span class="dc dc8"></span>
					</div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_event03.jpg" alt="아이폰이 숨어있는 케이스를 찾아라!">
                    <div class="items-list">
                        <!-- for-dev-msg : class item-case 클릭시 활성화 -->
                        <div class="info-box item-case case-01" onclick="fnItemSelect(1);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item01.png" alt="케이스1" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item01_select.png" alt="케이스1 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-02" onclick="fnItemSelect(2);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item02.png" alt="케이스2" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item02_select.png" alt="케이스2 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-03" onclick="fnItemSelect(3);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item03.png" alt="케이스3" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item03_select.png" alt="케이스3 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-04" onclick="fnItemSelect(4);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item04.png" alt="케이스4" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item04_select.png" alt="케이스4 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-05" onclick="fnItemSelect(5);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item05.png" alt="케이스5" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item05_select.png" alt="케이스5 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-06" onclick="fnItemSelect(6);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item06.png" alt="케이스6" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item06_select.png" alt="케이스6 선택" class="hide">
                        </div>
                        <div class="info-box item-case case-07" onclick="fnItemSelect(7);">
                            <div class="">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item07.png" alt="케이스7" class="show phone-case">
                            </div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_phone_item07_select.png" alt="케이스7 선택" class="hide">
                        </div>
                    </div>
                    <% if currentDate >= "2021-03-02" and currentDate < "2021-03-12" then %>
                    <button type="button" class="btn-apply second" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply.png" alt="응모하기"></button>
                    <% else %>
                    <button type="button" class="btn-apply" disabled="disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply_off.png" alt="다음 오픈을 기다려주세요">
                    <% end if %>
                </div>
            <% else %>
				<div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/bg_top.png" alt="bg">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_tit.png" alt="3월에 드리는 선물 1,000만원"></h2>
                    <div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_top_sub.png" alt="새롭게 시작하는 좋은 3월, 총1,000만 원 규모의 혜택 지금 도전하세요!"></div>
                    <div class="dc-group">
						<span class="dc dc1"></span>
						<span class="dc dc2"></span>
						<span class="dc dc3"></span>
						<span class="dc dc4"></span>
						<span class="dc dc5"></span>
						<span class="dc dc6"></span>
						<span class="dc dc7"></span>
						<span class="dc dc8"></span>
					</div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_event.jpg?v=3.1" alt="아이패드가 숨어있는 파우치를 찾아보세요!">
                    <div class="item-list list-01">
                        <div class="item-info item-01" onclick="fnItemSelect(1);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item01.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item01_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-02" onclick="fnItemSelect(2);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item02.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item02_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-03" onclick="fnItemSelect(3);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item03.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item03_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-04" onclick="fnItemSelect(4);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item04.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item04_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-05" onclick="fnItemSelect(5);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item05.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item05_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-06" onclick="fnItemSelect(6);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item06.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item06_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                        <div class="item-info item-07" onclick="fnItemSelect(7);">
                            <div class="info-box">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item07.png" alt="파우치" class="show">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_item07_select.png" alt="파우치 선택" class="hide">
                            </div>
                        </div>
                    </div>
                    <% if currentDate >= "2021-03-02" and currentDate < "2021-03-12" then %>
                        <% if currentDate >= "2021-03-05" and currentDate < "2021-03-08" then %>
                            <button type="button" class="btn-apply" disabled="disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply_off.png" alt="다음 오픈을 기다려주세요"></button>
                        <% else %>
                            <button type="button" class="btn-apply" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply.png" alt="응모하기"></button>
                        <% end if %>
                    <% else %>
                        <button type="button" class="btn-apply" disabled="disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_apply_off.png" alt="오픈을 기다려주세요"></button>
                    <% end if %>
                </div>
            <% end if %>
                <input type="hidden" id="pouch">
                <div class="section-02">
                    <button type="button" class="btn-win"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/btn_check.png" alt="당첨자 확인하기"></button>
                    <div class="winner-info" id="winners"></div>
                </div>
                <div class="section-03">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_tit01.jpg" alt="다음 오픈 일정을 확인하세요."></div>
                    <div class="event-schedule">
                        <div class="bar"></div>
                        <div class="schedule-list">
                            
                            <div class="day-01">
                                <% if currentDate >= "2021-03-02" and currentDate < "2021-03-05" then %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_01_ing.png" alt="3/2 진행중"></div>
                                <% else %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_01_end.png" alt="3/2 종료"></div>
                                <% end if%>
                            </div>
                            <div class="day-02">
                                <% if currentDate >= "2021-03-08" and currentDate < "2021-03-10" then %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_02_ing.png" alt="3/8 진행중"></div>
                                <% elseif currentDate >= "2021-03-10" then %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_02_end.png" alt="3/8 종료"></div>
                                <% else %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_02_preview.png" alt="3/8 오픈 예정"></div>
                                <% end if%>
                            </div>
                            <div class="day-03">
                                <% if currentDate >= "2021-03-10" and currentDate < "2021-03-12" then %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_03_ing.png" alt="3/10 진행중"></div>
                                <% elseif currentDate >= "2021-03-12" then %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_03_end.png" alt="3/10 종료"></div>
                                <% else %>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_condition_03_preview.png" alt="3/10 오픈 예정"></div>
                                <% end if%>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="section-04" id="sec-alram">
                    <div class="user-name"><span><% if session("ssnusername") <>"" then %><%=session("ssnusername")%><% else %>고객<% end if%></span>님께 텐바이텐이 추천합니다.</div>
                </div>
                <div class="section-05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_event_list.jpg" alt="추천 이벤트 리스트">
                    <div class="link-area">
                        <div>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109452');return false;"></a>
                        </div>
                        <div>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109150');return false;"></a>
                        </div>
                        <div>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109362');return false;"></a>
                        </div>
                        <div>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');return false;"></a>
                        </div>
                        <div>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102465');return false;"></a>
                        </div>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/img_noti.jpg" alt="이벤트 유의사항">
                <%'<!-- 팝업 - 푸쉬 알림 신청완료 -->%>
                <div class="pop-container push">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_push.jpg" alt="푸쉬 알림 신청이 완료되었습니다.">
                            <button type="button" class="btn-push-check" onclick="fnAPPpopupSetting();return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 당첨! -->%>
                <div class="pop-container win" id="winpop">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <% if currentDate >= "2021-03-02" and currentDate < "2021-03-05" then %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_win01.jpg" alt="당첨을 축하드립니다!">
                            <% elseif currentDate >= "2021-03-08" and currentDate < "2021-03-10" then %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_win02.jpg" alt="당첨을 축하드립니다!">
                            <% elseif currentDate >= "2021-03-10" and currentDate < "2021-03-12" then %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_win03.jpg" alt="당첨을 축하드립니다!">
                            <% end if %>
                            <!-- 구매하러 가기 버튼 -->
                            <button type="button" class="btn-win-check" onclick="goDirOrdItem();"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 꽝 1차 -->%>
                <div class="pop-container fail01" id="fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_fail01.jpg" alt="아쉽게도 당첨은 아니지만...마일리지">
                            <button type="button" class="btn-fail-check01" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 꽝 2,3차 -->%>
                <div class="pop-container fail02" id="fail2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_fail02.jpg" alt="아쉽게도 당첨은 아니지만...쿠폰">
                            <button type="button" class="btn-fail-check02" onclick="fnAPPpopupBrowserURL('쿠폰북', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 재클릭 1,2차 -->%>
                <div class="pop-container re-apply01" id="secondTry">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_done01.jpg" alt="이미 1회 응모하였어요.">
                            <!-- 오픈 알림 받기 버튼 -->
                            <a href="#sec-alram" class="btn-re-alram" onclick="jsPickingUpPushSubmit();"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 재클릭 3차 -->%>
                <div class="pop-container re-apply02" id="secondTry2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/109781/m/pop_done02.jpg" alt="친구에게도 응모할 수 있는 기회를 알려주새요!">
                            <!-- 카카오톡 공유하기 버튼 -->
                            <button type="button" class="btn-kakao" onclick="sharesns('ka')"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
			</div>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
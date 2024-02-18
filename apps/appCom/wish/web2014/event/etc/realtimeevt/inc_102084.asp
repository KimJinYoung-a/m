<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<%
'####################################################
' Description : 2020 오늘의 꽃
' History : 2020-04-16 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, drwEvt, couponidx
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "102150"
    moECode = "90362"
    couponidx = 2951
Else
	eCode = "102084"
    moECode = "102083"
    couponidx = 1326
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-04-16")		'이벤트 시작일
eventEndDate 	= cdate("2020-04-29")		'이벤트 종료일
currentDate 	= date()
'test
'currentDate		= Cdate("2020-04-21")
LoginUserid		= getencLoginUserid()
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("오늘의 꽃 이벤트")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "오늘의 꽃 이벤트"
	Dim kakaodescription : kakaodescription = "도전해보세요! 당첨된 분께 집으로 꽃을 보내드립니다."
	Dim kakaooldver : kakaooldver = "도전해보세요! 당첨된 분께 집으로 꽃을 보내드립니다."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<%
dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set drwEvt = new DrawEventCls
	drwEvt.evtCode = eCode
	drwEvt.userid = LoginUserid
	isSecondTried = drwEvt.isParticipationDayBase(2)
	isFirstTried = drwEvt.isParticipationDayBase(1)
	isShared = drwEvt.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

dim flowerIdx, vQuery, iscouponeDown

Select Case currentDate
    Case "2020-04-21"
        flowerIdx = 1	'튤립 노랑
    Case "2020-04-22"
        flowerIdx = 2	'초롱꽃
    Case "2020-04-23"
        flowerIdx = 3	'라넌큘러스
    Case "2020-04-24", "2020-04-25", "2020-04-26"
        flowerIdx = 4	'프리지아
    Case "2020-04-27"
        flowerIdx = 5	'튤립핑크
    Case "2020-04-28"
        flowerIdx = 6	'부부젤라 장미
    Case "2020-04-29"
        flowerIdx = 7	'작약
    Case else
        flowerIdx = 7	'작약
End select

dim isTeaser : isTeaser = False
if (currentDate <= Cdate("2020-04-20")) or (currentDate >= Cdate("2020-04-25") and currentDate <= Cdate("2020-04-26"))  then
    isTeaser = True
end if


iscouponeDown = false

If IsUserLoginOK Then
	vQuery = "select count(1) from db_user.dbo.tbl_user_coupon where userid = '" & getencLoginUserid() & "'"
	vQuery = vQuery + " and masteridx = '"& couponidx &"'"
	vQuery = vQuery + " and isusing = 'N' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	If rsget(0) >= 1 Then	' 
		iscouponeDown = true
	End IF
	rsget.close
end if

%>
<style>
.mEvt102084 button {background-color:transparent;}
.mEvt102084 .topic {position:relative; margin:0 auto -.4rem;}
.mEvt102084 .topic h2,
.mEvt102084 .topic .btn-push-alarm,
.mEvt102084 .topic .today-flower,
.mEvt102084 .topic .btn-submit {display:block; position:absolute; top:5.3%; left:0; z-index:5; width:100%;}
.mEvt102084 .topic .btn-push-alarm,
.mEvt102084 .topic .btn-submit {top:61.3%; left:unset; right:0; width:50.53%; animation:bounce 1s 30;}
.mEvt102084 .vod-flower {width:100%;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(0.8rem); animation-timing-function:ease-out;}
}

.slide-shhedule {background-color:#8ac615;}
.slide-shhedule .swiper-container {padding:0 .94rem; color:#fff;}
.slide-shhedule .swiper-slide {width:10.28rem; margin:0 0.34rem;}
.slide-shhedule .btn-bg {width:100%; height:10.28rem; border-radius:50%; background-color:#d7d0ca;}
.slide-shhedule .coming .btn-bg {position:relative;}
.slide-shhedule .coming .btn-bg:before {display:flex; justify-content:center; align-items:center; position:absolute; top:0; left:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/txt_coming.png) no-repeat 50% 100%/100% 100%; color:#fff; font-size:1.28rem; content:''}
.slide-shhedule .flower-name {margin:.93rem 0 2.35rem; font-size:1.28rem; text-align:center; letter-spacing:-.03rem;}

.slide-flower .swiper-slide {width:100%;}
.slide-flower .swiper-slide .bg {overflow:hidden; background-repeat:no-repeat; background-position:0 0; background-size:100% auto;}
.slide-flower .swiper-slide .img {overflow:hidden; float:right; width:0%; transition:1s;}
.slide-flower .swiper-slide-active .img {width:100%;}
.slide-flower .swiper-slide .img img {float:right; width:100vw;}

.lyr {overflow:scroll; position:fixed; top:0; left:0; z-index:10011; width:100vw; height:100vh; background-color:rgba(0,0,0,.9);}
.lyr .btn-close {position:fixed; top:0; right:0; z-index:101; width:21vw; height:21vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_close.png) no-repeat 50%/100% auto;}
.lyr-alarm .input-box2 {position:absolute; top:60vw; left:8vw; display:flex; align-items:center; width:70vw; border-bottom:.5vw solid #a7d253;}
.lyr-alarm .input-box2 input {width:33%; flex:1; padding:0; font-size:4.5vw; color:#fff; background-color:transparent; border:0; border-radius:0; text-align:center;}
.lyr-alarm .input-box2 input::placeholder {color:#cbcbcb;}
.lyr-alarm .input-box2 span {margin:0 1vw; font-size:5vw; color:#a7d253;}
.lyr-alarm .input-box2 .btn-submit {padding:0 3vw 1vw; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:4.5vw; color:#a7d253; white-space:nowrap;}
.lyr-bg {z-index:10020;}
.lyr-bg .bg-thumb {position:relative; text-align:center;}
.lyr-bg .bg-thumb img {width:auto; height:100vh;}
.lyr-bg .bg-txt {position:fixed; top:2.5rem; left:47%; width:70%; padding:1rem 0 .8rem; color:#fff; font-size:1rem; line-height:1; text-align:center; background-color:rgba(0,0,0,.8); border-radius:3rem; transform:translateX(-50%);}
.lyr-bg .bg-txt i {color:#a7d253;}
.lyr-result {display:flex; justify-content:center; align-items:center; flex-wrap:wrap; padding:0 7%;}
.lyr-result .result {position:relative; background-color:#e6ff9b;}
.lyr-result .btn-close {position:absolute; width:16vw; height:16vw; background:none;}
.lyr-result .lyr-win {position:relative;}
.lyr-result .lyr-win .win-flower {position:absolute; top:23.63%; left:50%; width:50.57%; height:35.62%; transform:translateX(-50%); border-radius:50%;}
.lyr-result .lyr-try .next-flower {position:absolute; top:45%; left:50%; font-size:1.13rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; border-bottom:solid .23rem #fff; transform:translateX(-50%);}

.mEvt102084 .sns {position:relative;}
.mEvt102084 .sns .btn-share {position:absolute; top:0; right:24.67%; width:16%; height:100%; text-indent:-999em;}
.mEvt102084 .sns .btn-kakao {right:6.6%;}

.noti {position:relative;}
.noti .btn-modify {display:inline-block; position:absolute; top:41.62%; left:47.33%; width:23%; height:7.7%;}
</style>
<script type="text/javascript">
var flowerInfo
var flowerCode
$(function(){
	flowerCode = $('.open .today-flower').attr('data-flower-code');
	flowerInfo = [
		{date:'4/21', name:'튤립', vodCode:'953'},
		{date:'4/22', name:'초롱꽃', vodCode:'943'},
		{date:'4/23', name:'라넌큘러스', vodCode:'945'},
		{date:'4/24', name:'프리지아', vodCode:'946'},
		{date:'4/27', name:'튤립', vodCode:'947'},
		{date:'4/28', name:'부젤라 장미', vodCode:'948'},
		{date:'4/29', name:'작약', vodCode:'949'}
	]
	
	// topic 'open' UI
	if($('.topic.open').is(':visible')){
		$('.today-flower img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_flower'+ flowerCode +'.png?v=1.02');
		$('.vod-flower').attr('poster','//webimage.10x10.co.kr/video/vid'+ flowerInfo[flowerCode-1].vodCode +'.jpg');
		$('.vod-flower source').attr('src','//webimage.10x10.co.kr/video/vid'+ flowerInfo[flowerCode-1].vodCode +'.mp4');
		$('.vod-flower').get(0).load();
		$('.vod-flower').get(0).play();
	}

	// slideSchedule
	var winSwiper = new Swiper('#slideSchedule .swiper-container', {
		slidesPerView:'auto'
	});
	$('#slideSchedule .swiper-slide').each(function (i) {
		$(this).children('.btn-bg').children('img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_circle_flower'+ (i+1) +'.png');
		$(this).children('.btn-bg').attr('data-flower-code',(i+1));
		$(this).children('.flower-name').text(flowerInfo[i].date + ' ' + flowerInfo[i].name);
	});

	// slideFlower
	var prdSwiper = new Swiper('#slideFlower .swiper-container', {
		autoplay: 2000,
		speed: 1,
		autoplayDisableOnInteraction: false,
		effect: 'fade'
	});

	// 배경화면 다운 팝업레이어
	$('.btn-bg').click(function (e) {
		$('.result').hide();
		if ($(this).parent().hasClass('swiper-slide')) { //slideSchedule일 경우

			var slideFlowerCode = $(this).attr('data-flower-code');
			if($(this).parent().hasClass('coming')) {
				alert ('Coming Soon :)')
			}	else {
				showBg(slideFlowerCode);
			}

		} else {
			showBg(flowerCode)
		}
		function showBg(code) {
			$('.bg-thumb img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2020/102084/m/bg_flower' + code +'.jpg?v=1.01');
			$('#lyrBg').show();
		}
	});

	// 알림신청 팝업레이어
	$(".btn-push-alarm").click(function(){
		$('#lyrAlarm').fadeIn();
	});    

	// 팝업레이어 닫기
	$('.lyr .btn-close').click(function(){
		$('.lyr').hide();
	});
});
</script>
<script style="text/javascript">
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"

function eventTry(){
    <% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			$.ajax({
				type:"POST",
				url:"/event/etc/drawevent/drawEventProc2.asp",
				data: {
					mode: "add"
				},
                dataType: "JSON",
				success : function(data){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                    // console.log(data) //'test
                    if(data.response == "err"){
                        alert(data.faildesc)
                        return false
                    }
                    returnCode = data.result
                    itemid = data.winItemid
                    popResult(returnCode, itemid);
                    return false;
				},
				error:function(data){
					// console.log(data)
					// document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
function popResult(returnCode, itemid){
    $('#lyrResult').show();		                    
    $('.result').hide();
    
    if(returnCode[0] == "B"){
        $('#fail').show();
    }else if(returnCode[0] == "A"){
        $('#retry').show();
    }else if(returnCode[0] == "C"){
        $('#win').show();
    }
    if($('.lyr-win').is(':visible')) { // 당첨
        $('.win-flower img').attr('src', '//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_win_flower' + flowerCode +'.png');
    } else if ($('.lyr-try').is(':visible') && flowerInfo[flowerCode]){ // 재응모
        $('.next-flower').text(flowerInfo[flowerCode].date + ' 꽃 : ' + flowerInfo[flowerCode].name);
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
function fnSendToKakaoMessage() {    
    if ($("#phone1").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone1").focus();
        return;
    }

    if ($("#phone2").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone2").focus();
        return;
    }

    if ($("#phone3").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone3").focus();
        return;
    }

    var phoneNumber = $("#phone1").val()+ "-" +$("#phone2").val()+ "-" +$("#phone3").val();
    $.ajax({
        type:"post",
        url:"/event/etc/drawevent/drawEventProc2.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $("#lyrAlarm").fadeOut();
                alert('신청 되었습니다.')
                return false;
            }else{
                alert(result.faildesc);
                $("#lyrAlarm").fadeOut();
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    })
}
function handleClickCoupon(){
    <% If not IsUserLoginOK() Then %>
        calllogin();
        return false;
    <% end if %>
    var str = $.ajax({
        type: "POST",
        url: "/event/etc/coupon/couponshop_process.asp",
        data: "mode=cpok&stype=event&idx=<%=couponidx%>",
        dataType: "text",
        async: false
    }).responseText;
    var str1 = str.split("||")
    if (str1[0] == "11"){
        fnAmplitudeEventMultiPropertiesAction("click_advtg_appcoupondown","","");
		$(".btn-coupon").hide()
        alert('쿠폰 지급이 완료되었습니다.\n해당 쿠폰은 플라워 카테고리에서만 사용할 수 있는 쿠폰입니다.');
        return false;
    }else if (str1[0] == "12"){
        alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
        return false;
    }else if (str1[0] == "13"){
        alert('이미 다운로드 받으셨습니다.');
        return false;
    }else if (str1[0] == "02"){
        alert('로그인 후 쿠폰을 받을 수 있습니다!');
        return false;
    }else if (str1[0] == "01"){
        alert('잘못된 접속입니다.');
        return false;
    }else if (str1[0] == "00"){
        alert('정상적인 경로가 아닙니다.');
        return false;
    }else{
        alert('오류가 발생했습니다.');
        return false;
    }
}
function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}
</script>
<!-- 102084 -->
			<div class="mEvt102084">
                <!-- 티저1 (~4/20) -->
                <% if isTeaser then %>
                <% if currentDate <= Cdate("2020-04-20") then%>
                <div class="topic teaser">
                    <h2 class="today-flower"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_teaser1.png" alt="오늘의 꽃 4/21오픈"></h2>
                    <video preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" playsinline poster="//webimage.10x10.co.kr/video/vid953.jpg" class="vod-flower">
                        <source src="//webimage.10x10.co.kr/video/vid953.mp4" type="video/mp4">
                    </video>
                    <button class="btn-push-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/btn_alarm.png?v=1.01" alt="알림신청"></button>
                </div>
                <% else %>
                <!-- 티저2 (4/25 ~ 4/26) -->
                <div class="topic teaser">
                    <h2 class="today-flower"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_teaser2.png?v=1.01" alt="오늘의 꽃 4/27오픈"></h2>
                    <video preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" playsinline poster="//webimage.10x10.co.kr/video/vid947.jpg" class="vod-flower">
                        <source src="//webimage.10x10.co.kr/video/vid947.mp4" type="video/mp4">
                    </video>
                    <button class="btn-push-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/btn_alarm.png?v=1.01" alt="알림신청"></button>
                </div>
                <% end if %>
				<!-- slideSchedule -->
				<div class="slide-shhedule" id="slideSchedule">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_schedule_v2.png" alt="오늘의 꽃 스케줄 보기"></h3>
					<div class="swiper-container">
						<div class="swiper-wrapper">
                            <% For i = 0 To 6 %>
	                        <div class="swiper-slide  <%=chkIIF(i + 1 <= flowerIdx, "", "coming")%>">
								<button class="btn-bg">
									<img src="" alt="">
								</button>
								<div class="flower-name">날짜 꽃이름</div>
							</div>
                            <% Next %>
						</div>
					</div>
				</div>								
				<%'<!-- 공유 : 티저에만 노출 -->%>
				<div class="sns">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_sns.png" alt="친구에게도 이벤트 알려주기!">
					<button onclick="sharesns('fb')" class="btn-share btn-fb">페이스북으로 공유하기</button>
					<button onclick="sharesns('ka')" class="btn-share btn-kakao">카카오톡으로 공유하기</button>
				</div>
				<%'<!-- 1.팝업레이어: 푸시알림신청 -->%>
				<div class="lyr lyr-alarm" id="lyrAlarm" style="display:none;">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/txt_alarm.png" alt="이벤트가 오픈되면 알려드립니다. 잊지말고 참여하세요!"></p>
					<div class="input-box2">
						<!--<input type="number" name="" id="phone" placeholder="휴대폰 번호를 입력해주세요">-->
                        <input type="number" id="phone1" placeholder="000" maxlength="3" oninput="maxLengthCheck(this)"><span>-</span><input type="number" id="phone2" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)"><span>-</span><input type="number" id="phone3" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">
						<button type="button" class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button>
					</div>
					<button type="button" class="btn-close">닫기</button>
				</div>
				<%'<!-- 2.팝업레이어: 배경다운 -->%>
				<div class="lyr lyr-bg" id="lyrBg" style="display:none;">
					<div class="bg-thumb">
						<img src="" alt="">
					</div>
					<div class="bg-txt">이미지를 <i>꾹</i> 눌러 저장 해보세요 <i>:)</i></div>
					<button type="button" class="btn-close">닫기</button>
				</div>				
                <% else %>
				<%'<!-- 오픈: 4/21(화) ~ 4/24(금), 4/27(월) ~ 4/29(수) -->%>
				<div class="topic open">
					<%'<!-- 오픈 되는 꽃에 따라 순차적으로 [data-flower-code] 의 값을 1~7 할당 -->%>
					<h2 class="today-flower" data-flower-code="<%=flowerIdx%>"><img src="" alt="오늘의 꽃"></h2>
					<button class="btn-submit" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/btn_submit.png" alt="응모하기"></button>
					<video preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" playsinline poster="" class="vod-flower">
						<source src="" type="video/mp4">
					</video>
				</div>
				<!--// 오픈 -->

				<!-- slideSchedule -->
				<div class="slide-shhedule" id="slideSchedule">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_schedule_v2.png" alt="오늘의 꽃 스케줄 보기"></h3>
					<div class="swiper-container">
						<div class="swiper-wrapper">
                            <% For i = 0 To 6 %>
	                        <div class="swiper-slide  <%=chkIIF(i + 1 <= flowerIdx, "", "coming")%>">
								<button class="btn-bg">
									<img src="" alt="">
								</button>
								<div class="flower-name">날짜 꽃이름</div>
							</div>
                            <% Next %>
						</div>
					</div>
				</div>

				<%'<!-- 쿠폰 : 다운 받았을 경우 숨겨주세요 -->%>
				<% if not iscouponeDown then %>
				<button class="btn-coupon" onclick="handleClickCoupon()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_coupon.png" alt="선착순으로 드리는 꽃 할인 쿠폰 받아가세요!"></button>
				<% end if %>
				<%'<!-- slideFlower : 오픈 때만 노출 -->%>
				<div class="slide-flower" id="slideFlower">
					<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/tit_slide.png" alt="꽃, 이렇게 활용해보세요"></div>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div class="bg" style="background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_5.jpg);">
									<div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_1.jpg" alt=""></div>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="bg" style="background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_1.jpg);">
									<div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_2.jpg" alt=""></div>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="bg" style="background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_2.jpg);">
									<div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_3.jpg" alt=""></div>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="bg" style="background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_3.jpg);">
									<div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_4.jpg" alt=""></div>
								</div>
							</div>
							<div class="swiper-slide">
								<div class="bg" style="background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_4.jpg);">
									<div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_slide1_5.jpg" alt=""></div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<%'<!-- 2.팝업레이어: 배경다운 -->%>
				<div class="lyr lyr-bg" id="lyrBg" style="display:none;">
					<div class="bg-thumb">
						<img src="" alt="">
					</div>
					<div class="bg-txt">이미지를 <i>꾹</i> 눌러 저장 해보세요 <i>:)</i></div>
					<button type="button" class="btn-close">닫기</button>
				</div>

				<%'<!-- 3.팝업레이어: 응모결과 -->%>
				<div class="lyr lyr-result" id="lyrResult" style="display:none;">
					<%'<!-- 3_1. 응모결과: 당첨 -->%>
					<div class="result lyr-win" id="win" style="display:none;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/pop_win.png" alt="축하드립니다! 오늘의 꽃에 당첨되었습니다.">
						<span class="win-flower"><img src="" alt=""></span>
						<a href="" onclick="fnAPPpopupBrowserURL('개인정보수정',' https://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/btn_modify.png" alt="배송지 수정하러 가기">
						</a>
					</div>
                    <% if  currentDate = Cdate("2020-04-29") then %>
					<%'<!-- 3_2. 응모결과: 꽝 (마지막날) -->%>
					<div class="result" id="fail" style="display:none;">
						<button class="btn-bg">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/pop_fail_2.png" alt="아쉽게도 당첨되지 않았습니다">
							<button type="button" class="btn-close">닫기</button>
						</button>
					</div>
					<%'<!-- 3_4. 응모결과: 재응모 시도 (마지막날) -->%>
					<div class="result lyr-try" id="retry" style="display:none;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/pop_next_2.png" alt="이미 1회 응모하였습니다.">
						<a href="" onclick="fnAPPpopupBrowserURL('가정의달','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/family2020/index.asp');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_bnr_event2.png" alt=""></a>
						<button type="button" class="btn-close">닫기</button>
					</div>        
                    <% else %>  
					<%'<!-- 3_2. 응모결과: 꽝 -->%>
					<div class="result" id="fail" style="display:none;">
						<button class="btn-bg">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/pop_fail_1.png" alt="아쉽게도 당첨되지 않았습니다">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
					<%'<!-- 3_3. 응모결과: 재응모 시도 -->%>
					<div class="result lyr-try" id="retry" style="display:none;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/pop_next_1.png" alt="이미 1회 응모하였습니다.">
						<p class="next-flower">날짜 : 꽃 이름</p>
						<a href="" onclick="fnAPPpopupBrowserURL('가정의달','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/family2020/index.asp');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_bnr_event2.png" alt=""></a>
						<button type="button" class="btn-close">닫기</button>
					</div>                              
                    <% end if %>
				</div>

				<a href="" onclick="fnAPPpopupBrowserURL('가정의달','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/family2020/index.asp');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/img_bnr_event1.png" alt=""></a>
				<!-- 유의사항 -->
				<div class="noti">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/102084/m/txt_noti.png?v=1.01" alt="이벤트 유의사항">
					<a href="" onclick="fnAPPpopupBrowserURL('개인정보수정',' https://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');" target="_blank" class="btn-modify"></a>
				</div>
                <% end if %>
			</div>
			<!-- // 102084 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
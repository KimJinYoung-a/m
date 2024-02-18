<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/password_event/PasswordEventCls.asp" -->
<%
'####################################################
' Description : 2020 방탈출 비밀번호 이벤트
' History : 2020-03-05 원승현
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "100915"
	moECode = "101171"
Else
	eCode = "101180"
	moECode = "101171"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

'// 이벤트 상품 노출은 2020년 3월 9일부터 10일.
'// 실제 이벤트 응모 시작일자는 2020-03-11로 셋팅
eventStartDate  = cdate("2020-03-11")		'이벤트 시작일
eventEndDate 	= cdate("2020-03-20")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2020-03-13")'테스트
LoginUserid		= getencLoginUserid()
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[방탈출]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[방탈출]"
	Dim kakaodescription : kakaodescription = "방 비밀번호를 맞히고 원하는 상품을 가져가세요!"
	Dim kakaooldver : kakaooldver = "방 비밀번호를 맞히고 원하는 상품을 가져가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_kakao.jpg"
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
	set pwdEvent = new PasswordEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	isShared = pwdEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<link rel="stylesheet" href="//malihu.github.io/custom-scrollbar/jquery.mCustomScrollbar.min.css" />
<style type="text/css">
.mEvt101180 {position:relative;}
.mEvt101180 button {background:transparent;}
.mEvt101180 .share {position:relative;}
.mEvt101180 .share button {position:absolute; top:0; width:18%; height:60%; background:none; font-size:0; color:transparent;}
.mEvt101180 .share .btn-fb {left:0;}
.mEvt101180 .share .btn-ka {right:0;}
.mEvt101180 .evt-main button {height:100%;}
.mEvt101180 .evt-main .share .btn-fb {left:53.5%;}
.mEvt101180 .evt-main .share .btn-ka {right:10.5%;}
.mEvt101180 .item-wrap {position:relative; background-color:#d3ebff;}
.mEvt101180 .item-list {display:flex; flex-wrap:wrap; justify-content:space-between; width:87.47%; padding:1.84rem 5.7% 1.28rem; margin:0 auto; background-color:#ffd9ca; }
.mEvt101180 .item-list li {position:relative; flex-basis:50%; padding:0 4.2%; margin-bottom:1.07rem; text-align:center;}
.mEvt101180 .item-list li .thumb {position:relative; padding:.6rem; background-color:#e3dbee; border:solid .51rem #fff; border-radius:.56rem;}
.mEvt101180 .item-list li .thumb:before {display:flex; align-items:center; justify-content:center; position:absolute; top:0; left:0; width:100%; height:100%; margin:0; background-color:rgba(0,0,0,.4); font-style:italic; color:#31ffdb; font-size:1.25rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; content:'3/11 Open';}
.mEvt101180 .item-list li.open .thumb:before {background-color:rgba(0,0,0,0);}
.mEvt101180 .item-list li .name {margin-top:.51rem; color:#eb825a; font-size:1rem;}
.mEvt101180 .item-list li .btn-click {position:absolute; top:0; left:0; z-index:3; width:100%; height:100%;}
.mEvt101180 .item-list li:nth-child(3) .thumb:before,
.mEvt101180 .item-list li:nth-child(4) .thumb:before {content:'3/12 Open';}
.mEvt101180 .item-list li:nth-child(5) .thumb:before {content:'3/13 Open';}
.mEvt101180 .item-list li:nth-child(6) .thumb:before {content:'3/16 Open';}
.mEvt101180 .item-list li:nth-child(7) .thumb:before,
.mEvt101180 .item-list li:nth-child(8) .thumb:before {content:'3/17 Open';}
.mEvt101180 .item-list li:nth-child(9) .thumb:before,
.mEvt101180 .item-list li:nth-child(10) .thumb:before {content:'3/18 Open';}
.mEvt101180 .item-list li.soldout .thumb:before {color:#fff; content:'sold out';}
.mEvt101180 .item-list li:not(.open) .btn-click {display:none;}
.mEvt101180 .item-list li.open .thumb:before {content:'';}
.mEvt101180 .item-list li.open .thumb:after {position:absolute; top:0; left:0; width:100%; height:100%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_lock.png); background-size:100%; content:' ';}
.mEvt101180 .item-list .open .thumb:after {animation: shake 2.5s 20 cubic-bezier(.36,.07,.19,.97) both; transform: translate3d(0, 0, 0);}
.mEvt101180 .item-list .open.on2 .thumb:after {animation-delay:.3s;}
.mEvt101180 .item-list .open.on3 .thumb:after {animation-delay:.6s;}
.mEvt101180 .item-list .open.on4 .thumb:after {animation-delay:.9s;}
.mEvt101180 .item-list .open.on5 .thumb:after {animation-delay:1.2s;}
.mEvt101180 .item-list .open.on6 .thumb:after {animation-delay:1.5s;}
.mEvt101180 .item-list .open.on7 .thumb:after {animation-delay:1.8s;}
.mEvt101180 .item-list .open.on8 .thumb:after {animation-delay:2.1s;}
.mEvt101180 .item-list .open.on9 .thumb:after {animation-delay:2.4s;}
.mEvt101180 .item-list .open.on10 .thumb:after {animation-delay:2.7s;}
@keyframes shake {
  10%, 50% {transform:translate3d(-1px, 0, 0);}
  15%, 45% {transform:translate3d(2px, 0, 0);}
  20%, 30%, 40% {transform:translate3d(-4px, 0, 0);}
  25%, 35% {transform:translate3d(4px, 0, 0);}
	100% {transform:translate3d(0, 0, 0);}
}
.sns {position:relative;}
.sns a {position:absolute; top:35.5%; left:0; width:100%; height:25%; font-size:0;}
.sns .insta-sns {left:50%;}
.winner {position:relative;}
.winner .slider {width:100%; background-color:#fff3db;}
.winner .swiper-slide:first-child {margin-left:2.99rem;}
.winner .swiper-slide:last-child {margin-right:2.13rem;}
.winner .item,
.winner .blank {width:9.26rem; margin-right:1.28rem;}
.winner .blank {padding:0;}
.winner .item .thumb {overflow:hidden; width:9.26rem; height:9.26rem; padding:1.3rem; -webkit-border-radius:50%; border-radius:50%; background-color:#ffd9ca;}
.winner .item .thumb:before {display:none;}
.winner .desc {display:flex; justify-content:center; align-items:center; flex-direction:column; position:absolute; top:0; left:0; z-index:5; width:9.26rem; height:9.26rem; text-align:center; -webkit-border-radius:50%; border-radius:50%; background-color:rgba(0,0,0,.4);}
.winner .desc .pw {color:#fdff73; font-size:1.07rem;}
.winner .desc .user {display:block; margin-top:.52rem; font-size:.77rem; color:#fff;}
.ly-popup {display:none; position:relative; background-color:#ff895a;}
.ly-popup .share {display:flex; position:absolute; left:0; top:30%; width:100%; height:17%;}
.ly-popup .share button {width:50%; height:100%; background:none; font-size:0; color:transparent;}
.ly-password {height:100vh; padding-top:1.8rem;}
.ly-password .thumb {width:12.37em; height:12.37rem; margin:0 auto; background-color:transparent;}
.ly-password .thumb:before {opacity:0;}
.ly-password .txt-input {font-size:1.45rem; color:#fff; text-align:center;}
.ly-password .keypad {position:relative; width:23.81rem; margin:0 auto;}
.ly-password .keypad .keys {display:flex; justify-content:center; flex-wrap:wrap; position:absolute; top:0; left:0; width:100%; height:100%;}
.ly-password .keypad .keys button {flex-basis:33.3%; font-size:0; color:transparent; background:none;}
.ly-password .input-area {display:flex; justify-content:center; margin:1rem 0;}
.ly-password .input-area em, .ly-password .input-area span {display:inline-block; padding:1.07rem; font-size:0; color:transparent;}
.ly-password .input-area em:after {display:block; content:' '; width:1.11rem; height:1.11rem; border:0.13rem solid #fffea1; border-radius:50%;}
.ly-password .input-area em.active:after {background-color:#fffea1;}
.ly-password .input-area span:first-child {font-size:1.68rem; color:#fffea1;}
.ly-password .input-area span:first-child:after {display:none;}
.ly-password .btn-close,
.ly-password .btn-del {position:absolute; top:82.5%; z-index:10; width:30%; height:10%; font-size:0;}
.ly-password .btn-close {left:0;}
.ly-password .btn-del {right:0;}
.ly-winner .item {position:absolute; top:29.88%; left:0; width:100%; text-align:center;}
.ly-winner .item .thumb {width:46.67%; margin:0 auto;}
.ly-winner .item .name {color:#000; font-size:1.28rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.ly-fail2 .btn-coupon {position:absolute; top:65%; width:100%; height:5%; font-size:0;}
</style>
<script src="//malihu.github.io/custom-scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript">
var selectedItem = 0
var selectedItemImgCode, selectedItemName = ""
var firstPwd = ""
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	<%'// 메인, 팝업 display none/block%>
	$('.ly-password .btn-close, .ly-popup .btn-main').click(function() {
		$('.ly-popup').hide();
		$('.evt-main').show();
	});

	getEvtItemList();
    getWinner();
	$("#keys .pwd-btn").click(function(){
		if(userPwd.length < 3){
			var pressedNumber = $(this).text()
			userPwd += pressedNumber
			$($("#dispPwd em")[userPwd.length - 1]).addClass("active")
			if(userPwd.length == 3){
				$('#pwdLayer').hide();
				eventTry();
			}
		}else{
			return false;
		}
	})
	$('.open').each(function (index, element) {
		$(this).addClass('on'+ (index + 1));
	});
});
</script>
<script>
function getEvtItemList(){
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/password_event/pwdEscapeRoomEventProc.asp",
		data: "mode=evtobj",
		dataType: "text",
		async: false
	}).responseText;

	var resultData = JSON.parse(str).data;
	//console.log(resultData)
	renderList(resultData)
	setButton();
}
function eventTry(){
	if(!chkValid()) return false;

	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			res = $.ajax({
				type:"POST",
				url:"/event/etc/password_event/pwdEscapeRoomEventProc.asp",
				data: {
					mode: "add",
					selectedPdt: selectedItem,
					code: firstPwd+userPwd
				},
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + selectedItem)
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								// console.log(Data)
								var result = JSON.parse(Data)
								if(result.response == "ok"){
									returnCode = result.result
									itemid = result.winItemid
									popResult(returnCode, itemid);
									getEvtItemList();
                                    getWinner();
									return false;
								}else{
									alert(result.faildesc);
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
function sharesns(snsnum) {
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/password_event/pwdEscapeRoomEventProc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");

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
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
				return false;
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
			<% end if %>
		}
}
function chkValid(){
	if(userPwd.length != 3 || selectedItem == ""){
		alert("상품을 선택해서 비밀번호를 눌러주세요.");
		return false;
	}
	return true;
}
function popResult(returnCode, itemid){
	// console.log(returnCode)
	if(returnCode[0] == "B"){
		numOfTry++
		
		if(numOfTry >= 2){
			$("#fail2").show();
			return false;
		}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){
		numOfTry++
		$("#win").show();
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101180/m/" + selectedItemImgCode + ".png")
		$("#winItem").text(selectedItemName)
	}else if(returnCode == "A03"){
		$('#main').show();
		alert("오픈된 상품이 아닙니다.");
	}
}
function setButton(){
	$('#itemList .open').click(function(){
		<% If Not(IsUserLoginOK) Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				alert("앱에서만 참여 가능한 이벤트입니다.")
				return false;
			<% end if %>
		<% end if %>
		resetPassword();
		$(window).scrollTop(0);
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$('#main').hide();
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			alert("오늘의 응모는 모두 완료!");
			return false;
		}
		$('#main').hide();
		$('#pwdLayer').show();
		selectedItem = $(this).find("div").attr("itemId")
		selectedItemImgCode = $(this).find("div").attr("imgcode")	
		selectedItemName = $(this).find("div").attr("itemName")
		firstPwd = $(this).find("div").attr("firstPassWord")
		$("#selectedImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101180/m/"+ selectedItemImgCode +".png")
		$("#dispPwd").find("span").empty().html(firstPwd);
	});	
}
function resetPassword(){
	userPwd = ""
	$("#dispPwd em").attr("class", "")
}
function delPassword(){
	if(userPwd.length > 0){
		userPwd = userPwd.substring(0, userPwd.length-1)
		$($("#dispPwd em")[userPwd.length]).removeClass("active")
	}
	return false
}
function renderList(itemList){
	var today = new Date('<%=currentDate%>')
	//testdate
	// today = new Date('2019-10-31')

	var $rootEl = $("#itemList")
	var itemEle = tmpEl = tmpCls = info = ""
	$rootEl.empty();
	// 오픈 리스트
	if(itemList.length > 0){
		itemList.forEach(function(item){
			var tmpName = ""
			<% if GetLoginUserLevel = "7" then %>
			var tmpName = item.winner
			<% else %>
			var tmpName = printUserName(item.winner, 2, "*")			
			<% end if %>

			if(today.getDate() >= parseInt(item.openDate.substr(-2))){ //open
				tmpCls = 'open'
			}else{
				tmpCls = ''
			}
			if(item.winner != "0"){
				tmpCls = 'soldout'
			}
			tmpEl = '\
			<li class="'+ tmpCls +'">\
				<div class="thumb" imgCode=\''+ item.imgCode +'\' itemId=' + item.itemcode + ' itemName=\''+ item.itemName +'\' firstPassWord=' + item.firstPasswordCode + '>\
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/' + item.imgCode + '.png" alt="'+ item.itemName +'"><button class="btn-click"></button>\
				</div>\
                <p class="name">' +item.itemName+ '</p></li>\
			'
			itemEle += tmpEl
		});
	}

	// 대기 리스트
	$rootEl.append(
		itemEle
	)
}

function getWinner() {
    var reStr;
    var str = $.ajax({
        type: "GET",
        url:"/event/etc/password_event/pwdEscapeRoomEventProc.asp",
        data: "mode=winner",
        dataType: "text",
        async: false
    }).responseText;

    var resultData = JSON.parse(str).data;
    var winnerLength = resultData.length;
    var $rootEl = $("#winners")
    $rootEl.empty();

    var emptyEl = '<div class="swiper-slide"><div class="blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_none.png" alt=""></div></div>'

    $.each(resultData,function(key,value) {
        var itemEle = "";	
        itemEle = '<div class="swiper-slide">'
        itemEle = itemEle + '		<div class="item">'
        itemEle = itemEle + '			<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/'+value.imgcode+'.png" alt=""></div>'
        itemEle = itemEle + '			<div class="desc">'
        itemEle = itemEle + '				<strong class="pw">PW : ' + value.passwd + '</strong>'
        <% if GetLoginUserLevel = "7" then %>
        itemEle = itemEle + '				<span class="user">' + value.userid + '님</span>'
        <% else %>
        itemEle = itemEle + '				<span class="user">' + printUserName(value.userid, 2, "*") + '님</span>'
        <% end if %>	
        itemEle = itemEle + '			</div>'
        itemEle = itemEle + '		</div>'
        itemEle = itemEle + '	</div>'	
        $rootEl.append(					
            itemEle
        )
    });

    for(var i = 0 ; i < 10 - winnerLength; i++){
        $rootEl.append(emptyEl)
    }
    if (winnerLength<1) {
        winnerLength = 1;
    }

    <% If currentDate >= "2020-03-11" Then %>
    $(function(){
        // 당첨자 롤링
        winSwiper = new Swiper('.winner .swiper-container', {
            speed:1200,
            freeMode:true,
            slidesPerView:'auto',
            freeModeMomentumRatio:0.5,
            initialSlide:winnerLength-1
        });
        var win = $('.winner .swiper-wrapper');
        var tx = win.offset().left - 30;
    });
    <% End If %>

}

function printUserName(name, num, replaceStr){
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}
function handleClickCoupon(){
	couponClick++
	var alertTxt = couponClick < 2 ? "2,000원 할인 쿠폰이 발급되었습니다. \n쿠폰함을 확인해주세요." : "이미 쿠폰이 발급되었습니다."
	alert(alertTxt)
}
function handleClickBanner(link, cb){
	fnAmplitudeEventMultiPropertiesAction('click_cst_event_bnr','eventcode|link','<%=ecode%>|'+link, function(bool){if(bool) {cb();}});	
	return false;
}

</script>
<%'<!-- MKT 방탈출 (A) 101180 -->%>
<div class="mEvt101180">
<%'				
'   <!-- for dev msg : SNS 공유 텍스트 및 이미지
'       타이틀 : [방탈출]
'	    내용 : 방 비밀번호를 맞히고 원하는 상품을 가져가세요!
'		공유 이미지 : http://webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_kakao.jpg -->
'	<!-- for dev msg : 6종 상품명 및 이미지 (상품 리스트, 비밀번호 입력 팝업, 당첨 팝업 공통 사용)
'	    //webimage.10x10.co.kr/fixevent/event/2020/101180/m/ + 파일명 + .png
'		iMac 21.5형		    img_item1   수량 1개(2020년 3월 12일)
'		마샬 스피커 	    img_item2   수량 1개(2020년 3월 18일)
'		젤리빔 빔프로젝터	img_item3   수량 3개(2020년 3월 11일, 16일, 18일)
'		아이패드 에어	    img_item4   수량 1개(2020년 3월 17일)
'		드롱기 커피머신		img_item5   수량 2개(2020년 3월 11일, 13일)
'		바우젠 전해수기		img_item6   수량 2개(2020년 3월 12일, 17일)
'	-->
%>
    <div class="evt-main" id="main">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/tit_event.png" alt="방탈출"></h2>
        <%'<!-- 상품 목록 -->%>
        <div class="item-wrap">
            <ul class="item-list" id="itemList"></ul>
        </div>
        <div class="sns">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_sns.png" alt="비밀번호 힌트">
            <a href="javascript:void(0)" onclick="handleClickBanner('fb', function(){fnAPPpopupExternalBrowser('https://tenten.app.link/e/3KtZZw1sy4');})" class="fb-sns">텐바이텐 페북으로 이동</a>
            <a href="javascript:void(0)" onclick="handleClickBanner('in', function(){fnAPPpopupExternalBrowser('https://tenten.app.link/e/Ihhu48Tsy4');})" class="insta-sns">텐바이텐 인스타로 이동</a>
        </div>
        <% If currentDate >= "2020-03-11" Then %>
            <%'<!-- 당첨자 -->%>
            <div class="winner">
                <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/tit_winner.png" alt="비밀번호 당첨자를 소개합니다"></h3>
                <div class="slider">
                    <div class="swiper-container">
                        <div class="swiper-wrapper" id="winners"></div>
                    </div>
                </div>
            </div>
        <% End If %>
        <div class="event-list">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/tit_event_list.png" alt="밖에 못 나가서 심심하다면, 집에서 이건 어때요?"></p>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101019');return false;" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_event1.jpg" alt="뚝딱! 방구석 영화관 만들기"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100920');return false;" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_event2.jpg" alt="집순이들 공감하는 집콕 유형 5가지"></a>
        </div>
        <% If currentDate >= "2020-03-11" Then %>
            <div class="share">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_share.png" alt="친구에게 공유하고 한 번 더 도전하세요"></p>
                <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
                <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
            </div>
        <% End If %>
				<%'<!-- 유의사항 -->%>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101083');return false;" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/bnr_evt1.png" alt="마일리지이벤트"></a>
        <div class="noti">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/txt_noti.png" alt="유의사항">
        </div>
    </div>
    <%'<!-- 팝업 1. 암호입력 -->%>
    <div class="ly-popup ly-password" id="pwdLayer">
        <div class="thumb"><img id="selectedImg" src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_item1.png" alt=""></div>
        <p class="txt-input">비밀번호를 입력해주세요</p>
        <%'<!-- for dev msg : 입력시 클래스 active 추가 -->%>
        <div class="input-area" id="dispPwd">
            <span>1</span>
            <em>2</em>
            <em>3</em>
            <em>4</em>
        </div>
        <div class="keypad">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/bg_keypad.jpg" alt=""></p>
            <div class="keys" id="keys">
                <button type="button" class="pwd-btn">1</button>
                <button type="button" class="pwd-btn">2</button>
                <button type="button" class="pwd-btn">3</button>
                <button type="button" class="pwd-btn">4</button>
                <button type="button" class="pwd-btn">5</button>
                <button type="button" class="pwd-btn">6</button>
                <button type="button" class="pwd-btn">7</button>
                <button type="button" class="pwd-btn">8</button>
                <button type="button" class="pwd-btn">9</button>
                <button type="button" class="pwd-btn">0</button>
            </div>
            <button type="button" class="btn-close">뒤로 가기</button>
            <%'<!-- for dev msg : 한자리씩 삭제 -->%>
            <button type="button" class="btn-del" onclick="delPassword();">삭제</button>            
        </div>
    </div>
    <%'<!-- 팝업 2. 암호성공 -->%>
    <div class="ly-popup ly-winner" id="win">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/txt_winner.png" alt="축하드립니다"></p>
        <div class="ly-inner">
            <div class="item">
                <div class="thumb"><img id="winImg" src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/img_item1.png" alt=""></div>
                <p class="name" id="winItem"></p>
            </div>
            <button type="button" class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/btn_main.png" alt="이벤트 메인으로 이동"></button>
        </div>
    </div>
    <%'<!-- 팝업 3. 암호실패1 -->%>
    <div class="ly-popup ly-fail1" id="fail1">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/txt_fail1.png" alt="아쉽게도 비밀번호가 맞지 않습니다"></p>
        <div class="share">
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
        <button type="button" class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/btn_main.png" alt="이벤트 메인으로 이동"></button>
    </div>
    <%'<!-- 팝업 4. 공유 안하고 재도전시 -->%>
    <div class="ly-popup ly-already" id="secondTry">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/txt_already.png" alt="이미 한번 도전 하였습니다."></p>
        <div class="share">
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        </div>
        <button type="button" class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/btn_main.png" alt="이벤트 메인으로 이동"></button>
    </div>
    <%'<!-- 팝업 5. 암호실패2 -->%>
    <div class="ly-popup ly-fail2" id="fail2">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/txt_fail2.png" alt="비밀번호 2회 오류로 비활성화 되었습니다."></p>
        <button type="button" class="btn-coupon" onclick="handleClickCoupon()"><span>쿠폰 받기</span></button>
        <button type="button" class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101180/m/btn_main.png" alt="이벤트 메인으로 이동"></button>
    </div>
</div>
<%'<!--// MKT 방탈출 (A) 101180 -->%>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
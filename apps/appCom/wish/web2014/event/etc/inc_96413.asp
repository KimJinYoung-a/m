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
' Description : 2019 와이파이 비밀번호 이벤트
' History : 2019-08-05 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4

IF application("Svr_Info") = "Dev" THEN
	eCode = "90362"
	moECode = "90362"
Else
	eCode = "96413"
	moECode = "96411"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-08-05")		'이벤트 시작일
eventEndDate 	= cdate("2019-08-18")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-07-17")'테스트
LoginUserid		= getencLoginUserid()
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[WIFI 비밀번호 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96413/img_kakao.png")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[WIFI 비밀번호 이벤트]"
	Dim kakaodescription : kakaodescription = "가장 먼저 비밀번호를 맞히고 엄청난 상품을 받아가세요!"
	Dim kakaooldver : kakaooldver = "가장 먼저 비밀번호를 맞히고 엄청난 상품을 받아가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96413/img_kakao.png"
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
<style type="text/css">
.mEvt96413 {position:relative; background-color:#ececec;}
.mEvt96413 button {background-color:transparent;}
.mEvt96413 .topic {position:relative;}
.mEvt96413 h2:before, .mEvt96413 h2:after {display:inline-block; content:' '; position:absolute; top:21.9%; width:1.87vw; height:1.87vw; border-radius:50%; background-color:#070707; animation:blink .5s 3s 2;}
.mEvt96413 h2:before {left:35.6%;}
.mEvt96413 h2:after {left:50.9%;}
.mEvt96413 .ico-wifi {position:absolute; top:21.6%; left:56.7%; width:12.9%;}
.mEvt96413 .ico-wifi path {fill:#888;}
.mEvt96413 .ico-wifi .dot {fill:#ff40b0;}
.mEvt96413 .ico-wifi .arc {animation-duration:1.5s; animation-iteration-count:2; animation-fill-mode:both;}
.mEvt96413 .ico-wifi .arc1 {animation-name:arc1;}
.mEvt96413 .ico-wifi .arc2 {animation-name:arc2;}
.mEvt96413 .ico-wifi .arc3 {animation-name:arc3;}
@keyframes arc1 {
	0% {fill:#888;}
	15%, 85% {fill:#ff40b0;}
	100% {fill:#888;}
}
@keyframes arc2 {
	0%, 15% {fill:#888;}
	30%, 70% {fill:#ff40b0;}
	85% {fill:#888;}
}
@keyframes arc3 {
	0%, 30% {fill:#888;}
	45%, 55% {fill:#ff40b0;}
	70% {fill:#888;}
}
@keyframes blink {
	from,to {background-color:#070707;}
	50% {background-color:#ff40b0;}
}
.mEvt96413 .wifi-cont {display:none;}
.mEvt96413 .wifi-list {padding:0 4%;}
.wifi-list .tit-select {padding:1.7rem 0 0.9rem 2.13rem; font-size:1.28rem; color:#ef78be;}
.wifi-list .tit-winner {padding:2.43rem 0 0.9rem 2.13rem; font-size:1.28rem; color:#2270ff;}
.wifi-list ul {border-radius:1.45rem;}
.wifi-list .open {background-color:#fff;}
.wifi-list .wait {background-color:#f4f4f4;}
.wifi-list .open + .wait {margin-top:0.8rem;}
.wifi-list .win {background-color:#fff;}
.wifi-list li {display:flex; height:4.2rem; align-items:center; justify-content:flex-end; padding:0 1.8rem 0 2rem;}
.wifi-list .open li + li {border-top:1px solid #e3e3e3;}
.wifi-list .wait li + li {border-top:1px solid #d0d0d0;}
.wifi-list .win li + li {border-top:1px solid #e3e3e3;}
.wifi-list li .name {flex:1; font-weight:normal; text-align:left;}
.wifi-list .open li .name {font-size:1.54rem; color:#171717;}
.wifi-list .wait li .name {font-size:1.45rem; color:#adadad;}
.wifi-list .win li .name {font-size:1.54rem; color:#171717;}
.wifi-list li .num {font-size:0.77rem;}
.wifi-list .open li .num {color:#171717;}
.wifi-list .wait li .num {color:#adadad;}
.wifi-list .win li .num {color:#171717;}
.wifi-list li .txt {padding-right:0.85rem; font-size:0.98rem; color:#c2c2c2; text-align:right;}
.wifi-list li .txt .pwd {display:block; margin-bottom:0.3rem; font-size:1.19rem; color:#444;}
.wifi-list li .ico1, .wifi-list li .ico2 {display:inline-block; width:2.13rem; height:2.13rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/96413/m/icons.png) no-repeat; background-size:4.26rem auto;}
.wifi-list li .ico1 {background-position:0 0; margin-right:0.3rem;}
.wifi-list li .ico2 {background-position:100% 0;}
.wifi-list .open li .ico1, .wifi-list .open li .ico2 {background-position-y:50%;}
.wifi-list .win li .ico1, .wifi-list .win li .ico2 {background-position-y:100%;}
.mEvt96413 .sns-share {position:relative;}
.mEvt96413 .sns-share button {position:absolute; top:20%; width:20%; height:60%; background:none; font-size:0; color:transparent;}
.mEvt96413 .sns-share .btn-fb {right:27%;}
.mEvt96413 .sns-share .btn-ka {right:7%;}
.mEvt96413 .hint {position:relative;}
.mEvt96413 .hint .link {position:absolute; left:0; top:20%; width:100%; height:38%;}
.mEvt96413 .hint .link a {display:inline-block; float:left; width:50%; height:100%; font-size:0; color:transparent;}
.spinner {display:inline-block; position:relative; width:2rem; height:2rem; vertical-align:sub; margin-left:0.2rem;}
.spinner div {transform-origin:1rem 1rem;}
.spinner div:after {content:' '; display:block; position:absolute; top:0.22rem; left:0.9rem; width:0.15rem; height:0.4rem; border-radius:0.1rem; background-color:#bebebe; animation:spinner 1.2s linear infinite;}
.spinner div:nth-child(1) {transform:rotate(0deg);}
.spinner div:nth-child(1):after {animation-delay:-1.1s;}
.spinner div:nth-child(2) {transform:rotate(30deg);}
.spinner div:nth-child(2):after {animation-delay:-1s;}
.spinner div:nth-child(3) {transform:rotate(60deg);}
.spinner div:nth-child(3):after {animation-delay:-0.9s;}
.spinner div:nth-child(4) {transform:rotate(90deg);}
.spinner div:nth-child(4):after {animation-delay:-0.8s;}
.spinner div:nth-child(5) {transform:rotate(120deg);}
.spinner div:nth-child(5):after {animation-delay:-0.7s;}
.spinner div:nth-child(6) {transform:rotate(150deg);}
.spinner div:nth-child(6):after {animation-delay:-0.6s;}
.spinner div:nth-child(7) {transform:rotate(180deg);}
.spinner div:nth-child(7):after {animation-delay:-0.5s;}
.spinner div:nth-child(8) {transform:rotate(210deg);}
.spinner div:nth-child(8):after {animation-delay:-0.4s;}
.spinner div:nth-child(9) {transform:rotate(240deg);}
.spinner div:nth-child(9):after {animation-delay:-0.3s;}
.spinner div:nth-child(10) {transform:rotate(270deg);}
.spinner div:nth-child(10):after {animation-delay:-0.2s;}
.spinner div:nth-child(11) {transform:rotate(300deg);}
.spinner div:nth-child(11):after {animation-delay:-0.1s;}
.spinner div:nth-child(12) {transform:rotate(330deg);}
.spinner div:nth-child(12):after {animation-delay:0s;}
@keyframes spinner {
	0% {background-color:#bebebe;}
	100% {background-color:#cb8db1;}
}
.mEvt96413 .push {background-color:#f23ca7;}
.mEvt96413 .push .slider img {max-width:100vw;}
.mEvt96413 .push .swiper-button {top:36%; background:none;}
.mEvt96413 .push .swiper-button svg {vertical-align:top;}
.mEvt96413 .push .swiper-button-prev {left:8%;}
.mEvt96413 .push .swiper-button-next {right:8%;}
.mEvt96413 .noti {background-color:#2f2f2f;}
.mEvt96413 .noti h3 {text-align:center;}
.mEvt96413 .noti ul {padding:6vw 6.7% 11vw;}
.mEvt96413 .noti li {position:relative; padding-left:1rem; font-size:1.11rem; line-height:1.38; color:#fff; word-break:keep-all;}
.mEvt96413 .noti li + li {margin-top:1.19rem;}
.mEvt96413 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block;}
.ly-popup {display:none; position:relative;}
.ly-popup button {-webkit-touch-callout:none; -webkit-user-select:none; -khtml-user-select:none; -moz-user-select:none; -ms-user-select:none; user-select:none;}
.ly-pwd .tit-pwd {padding-top:7vw; font-size:1.32rem; color:#222; text-align:center; line-height:1.5;}
.ly-pwd .tit-pwd b {display:block; font-size:2.13rem;}
.ly-pwd .img-prd {width:35%; margin:0 auto 4vw;}
.ly-pwd .input-area {width:29.5rem; height:4.22rem; padding:1.32rem 0; margin:0 auto; background-color:#fff; border-radius:1.45rem;}
.ly-pwd .input-area .label {float:left; height:1.58rem; line-height:1.8rem; padding:0 1.5rem 0 2rem; margin-right:1.5rem; font-weight:normal; font-size:1.24rem; color:#171717; border-right:0.1rem solid #d2d2d2;}
.ly-pwd .input-area .input {display:flex; height:1.58rem;}
.ly-pwd .input-area em {display:inline-block; padding:0 0.21rem; font-family:'AppleSDGothicNeo-Regular','Noto Sans'; font-size:2.3rem; color:#adadad; line-height:1.2;}
.ly-pwd .input-area em.active {color:#ff40b0;}
.ly-pwd .keypad {padding:5vw 0 10vw; margin-top:6vw; background:#e0e0e0;}
.ly-pwd .keys {display:flex; flex-wrap:wrap; justify-content:space-between; width:29.5rem; margin:0 auto;}
.ly-pwd .keys button {width:9.34rem; height:4.78rem; margin:0.4rem 0; font-size:1.96rem; color:#444; background-color:#fff; border-radius:1.3rem;}
.ly-pwd .keys .btn-close, .ly-pwd .keys .btn-del {font-size:1.37rem; color:#8a8a8a; background-color:transparent;}
.ly-popup .bot-btn {display:flex; position:absolute; bottom:0; width:100%; height:20%; justify-content:center;}
.ly-popup .bot-btn button {width:50%; height:100%; font-size:0;}
.ly-win .prd-area {position:absolute; top:27%; left:0; width:100%;}
.ly-win .prd-area span {display:block;}
.ly-win .prd-area .img {width:49.7%; margin:0 auto;}
.ly-win .prd-area .name {font-size:0.98rem; text-align:center; color:#666;}
.ly-win .bot-btn {bottom:10%;}
.ly-popup .share {display:flex; position:absolute; left:0; width:100%; height:17%;}
.ly-popup .share button {width:50%; height:100%; background:none; font-size:0; color:transparent;}
.ly-fail1 .share {top:34%;}
.ly-already .share {top:46%;}
</style>
<script type="text/javascript">
var selectedItem = 0
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	$('.btn-challenge').click(function(){
		$(this).hide();
		$(this).siblings('.topic').hide();
		$('.wifi-cont').show();
		var pushSwiper = new Swiper('.push .swiper-container', {
			speed:1200,
			prevButton:'.push .swiper-button-prev',
			nextButton:'.push .swiper-button-next'
		});
	});

	$("#keys .pwd-btn").click(function(){
		if(userPwd.length < 4){
			pressedNumber = $(this).text()
			userPwd += pressedNumber
			$($("#dispPwd em")[userPwd.length - 1]).addClass("active")
			if(userPwd.length == 4){
				$('#pwdLayer').hide();
				eventTry();
			}
		}else{
			return false;
		}
	})

	getEvtItemList();
});
</script>
<script>
function getEvtItemList(){
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/password_event/wifiPwdEventProc.asp",
		data: "mode=evtobj",
		dataType: "text",
		async: false
	}).responseText;

	var resultData = JSON.parse(str).data;
	var itemListObj = getList(resultData);
	// console.log(itemListObj)
	renderList(itemListObj)
	setButton();
}
function eventTry(){
	if(!chkValid()) return false;

	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			alert("앱에서만 참여 가능한 이벤트입니다.")
			return false;
		<% end if %>
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			res = $.ajax({
				type:"POST",
				url:"/event/etc/password_event/wifiPwdEventProc.asp",
				data: {
					mode: "add",
					selectedPdt: selectedItem,
					code: userPwd
				},
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + selectedItem)
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var result = JSON.parse(Data)
								if(result.response == "ok"){
									returnCode = result.result
									itemid = result.winItemid
									popResult(returnCode, itemid);
									getEvtItemList();
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
			// console.log(res.responseText)
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
			url:"/event/etc/password_event/wifiPwdEventProc.asp",
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
	if(userPwd.length != 4 || selectedItem == ""){
		alert("상품을 선택해서 비밀번호를 눌러주세요.");
		return false;
	}
	return true;
}
function popResult(returnCode, itemid){
	// console.log(returnCode)
	if(returnCode[0] == "B"){
		numOfTry++
		if(numOfTry >= 2){$("#fail2").show(); return false;}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){
		numOfTry++
		$("#win").show();
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_"+getItemInfo(parseInt(itemid)).imgCode+".png")
	}else if(returnCode == "A03"){
		$('.wifi-main').show();
		alert("오픈된 상품이 아닙니다.");
	}
}
function setButton(){
	$('.wifi-list .open li').click(function(){
		<% If Not(IsUserLoginOK) Then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				alert("앱에서만 참여 가능한 이벤트입니다.")
				return false;
			<% end if %>
		<% end if %>			
		$(window).scrollTop(0);
		resetPassword();
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$('.wifi-main').hide();
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			alert("오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!");
			return false;
		}
		$('.wifi-main').hide();
		$('.ly-pwd').show();
		selectedItem = $(this).attr("itemId")				
		$("#itemName").html('\''+ getItemInfo(parseInt(selectedItem)).itemName +'\'의 <b>비밀번호 입력</b>')		
		$("#selectedImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_"+getItemInfo(parseInt(selectedItem)).imgCode+".png")
	});
	$('.ly-pwd .btn-close, .ly-popup .btn-main').click(function() {
		$('.ly-popup').hide();
		$('.wifi-main').show();
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

function getList(arr){
	var openList = []
	var waitingList = []
	var winnerList = []
	var today = new Date()	
	//testdate
	// today = new Date('2019-08-18')

	arr.forEach(function(item){		
		if(item.winner != "0"){
			winnerList.push(item)
		}else if(today.getDate() >= parseInt(item.openDate.substr(-2))){
			openList.push(item)
		}else{
			waitingList.push(item)
		}
	});
	return {
		open: openList,
		waiting: waitingList,
		winner: winnerList
	}
}
function renderList(itemListObj){
	var $rootEl = $("#wifiList")
	var itemEle = ""
	$rootEl.empty();
	// 오픈 리스트	
	if(itemListObj.open.length > 0){
		itemEle = '<div class="tit-select">상품선택...<div class="spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div></div>'
		itemEle = itemEle + '<ul class="open">'
		itemListObj.open.forEach(function(item){
			itemEle = itemEle + '<li itemId=' + item.itemcode + '>	'
			itemEle = itemEle + '	<strong class="name">'+ item.itemName +'<em class="num">'+ item.itemIdx +'</em></strong>	'
			itemEle = itemEle + '	<i class="ico1"></i>	'
			itemEle = itemEle + '	<i class="ico2"></i>	'
			itemEle = itemEle + '</li>	'
		});
		itemEle = itemEle + '</ul>'
	}
	// 대기 리스트
	if(itemListObj.waiting.length > 0){
		itemEle = itemEle + '<ul class="wait">'
		itemListObj.waiting.forEach(function(item){
			itemEle = itemEle + '<li>	'
			itemEle = itemEle + '	<strong class="name">'+ item.itemName +'<em class="num">'+ item.itemIdx +'</em></strong> '
			itemEle = itemEle + '	<span class="txt">' + (new Date(item.openDate).getMonth() + 1) + '월 '+ new Date(item.openDate).getDate() +'일 오픈</span> '
			itemEle = itemEle + '	<i class="ico1"></i> '
			itemEle = itemEle + '	<i class="ico2"></i> '
			itemEle = itemEle + '</li>	'
		});
		itemEle = itemEle + '</ul>'
	}
	// 당첨자
	if(itemListObj.winner.length > 0){
		itemEle = itemEle + '<div class="tit-winner">이벤트 당첨자들...</div>'
	}
	itemEle = itemEle + '<ul class="win">'
	itemListObj.winner.forEach(function(item){
		itemEle = itemEle + '<li> '
		itemEle = itemEle + '	<strong class="name">'+ item.itemName +'<em class="num">'+ item.itemIdx +'</em></strong> '
		<% if GetLoginUserLevel = "7" then %>
			itemEle = itemEle + '	<span class="txt"><b class="pwd">PW : ' + item.password + '</b> ' + item.winner + '님</span> '
		<% else %>
			itemEle = itemEle + '	<span class="txt"><b class="pwd">PW : ' + item.password + '</b> ' + printUserName(item.winner, 2, "*") + '님</span> '
		<% end if %>
		itemEle = itemEle + '	<i class="ico1"></i> '
		itemEle = itemEle + '	<i class="ico2"></i> '
		itemEle = itemEle + '</li> '
	});
	itemEle = itemEle + '</ul>'
	$rootEl.append(
		itemEle
	)
}
function printUserName(name, num, replaceStr){
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}
function getItemInfo(itemId){
	var imgCode = ""
	var itemName = ""
	switch (itemId) {
		case 2 :
		case 4 :
		case 7 :
		case 11 :
			imgCode = "airpod"
			itemName = "에어팟 2세대"
			break;
		case 5 :
			imgCode = "ipad"
			itemName = "아이패드 미니"
			break;						
		case 8 :
			imgCode = "ipad_gold"
			itemName = "아이패드 미니"
			break;			
		case 1 :
		case 10 :
			imgCode = "ipad_silver"
			itemName = "아이패드 미니"
			break;
		case 3 :
		case 12 :
			imgCode = "marshall"
			itemName = "마샬 스피커"
			break;
		case 6 :
		case 9 :
			imgCode = "marshall_white"
			itemName = "마샬 스피커"
			break;						
		default:
			break;
	}
	return {
		imgCode: imgCode,
		itemName: itemName
	}
}
function handleClickCoupon(){
	couponClick++
	var alertTxt = couponClick < 2 ? "3,000원 할인 쿠폰이 발급되었습니다.\n쿠폰함을 확인해주세요." : "이미 쿠폰이 발급되었습니다."
	alert(alertTxt)
}
<%
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" Then
%>
function getEvtstatList(){
	param = {
		mode: "stat"
	}
	$.getJSON("/event/etc/password_event/wifiPwdEventProc.asp", param, function(data, status){
		if(status== "success"){
			console.log(data.stat)
			var statData = data.stat
			var $rootEl = $("#stat")
			var itemEle = ""
			$rootEl.empty();

			statData.forEach(element => {
				itemEle = itemEle + `<div>${element.date} : ${element.cnt} - ${element.new}</div>`
			});
			console.log($rootEl)
			$rootEl.append(
				itemEle
			)			
		}
	})
}
$(function(){
	getEvtstatList()
})
<%
end if	
%>
</script>
			<!-- 96413 MKT 와이파이 -->
			<div id="stat"></div>
			<div class="mEvt96413">			
				<div class="wifi-main">			
					<div class="topic">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/tit_wifi.jpg" alt="WiFi 비밀번호"></h2>
						<div class="ico-wifi">
							<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" viewBox="0 0 155.8 120.1">
							<path class="dot" d="M77.9,89.7c8.4,0,15.2,6.8,15.2,15.2c0,8.4-6.8,15.2-15.2,15.2c-8.4,0-15.2-6.8-15.2-15.2 C62.7,96.5,69.5,89.7,77.9,89.7L77.9,89.7z"/>
							<path class="arc arc1" d="M77.9,75c9.2,0.1,16.2,3.5,22.9,9.6c9.8,6.9,17.3-5.7,9.4-11.8c-18.2-17.1-46.5-17.1-64.7,0 c-7.9,6-0.4,18.6,9.4,11.8C61.7,78.5,68.7,75.1,77.9,75z"/>
							<path class="arc arc2" d="M77.9,45c16.1,0.1,31.6,6.4,43.3,17.5c8.7,8.2,17.2-2.2,11.4-9.8c-30.1-30.2-79-30.3-109.3-0.2 c-0.1,0.1-0.2,0.2-0.2,0.2c-5.7,7.6,2.7,18,11.4,9.8C46.2,51.4,61.7,45.1,77.9,45z"/>
							<path class="arc arc3" d="M77.9,15c24.5,0.1,48,9.8,65.4,27.1c9.6,6.9,17-6.1,9.4-11.8C111-10.1,44.7-10.1,3.1,30.4 C-4.4,36,2.9,49,12.5,42.1C29.9,24.8,53.4,15.1,77.9,15z"/>
							</svg>
						</div>
					</div>
					<button type="button" class="btn-challenge"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/btn_challenge.jpg" alt="도전하기"></button>
					<div class="wifi-cont">
						<div class="topic">
							<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/tit_wifi.jpg" alt="WiFi 비밀번호"></h2>
							<div class="ico-wifi">
								<svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" viewBox="0 0 155.8 120.1">
								<path class="dot" d="M77.9,89.7c8.4,0,15.2,6.8,15.2,15.2c0,8.4-6.8,15.2-15.2,15.2c-8.4,0-15.2-6.8-15.2-15.2 C62.7,96.5,69.5,89.7,77.9,89.7L77.9,89.7z"/>
								<path class="arc arc1" d="M77.9,75c9.2,0.1,16.2,3.5,22.9,9.6c9.8,6.9,17.3-5.7,9.4-11.8c-18.2-17.1-46.5-17.1-64.7,0 c-7.9,6-0.4,18.6,9.4,11.8C61.7,78.5,68.7,75.1,77.9,75z"/>
								<path class="arc arc2" d="M77.9,45c16.1,0.1,31.6,6.4,43.3,17.5c8.7,8.2,17.2-2.2,11.4-9.8c-30.1-30.2-79-30.3-109.3-0.2 c-0.1,0.1-0.2,0.2-0.2,0.2c-5.7,7.6,2.7,18,11.4,9.8C46.2,51.4,61.7,45.1,77.9,45z"/>
								<path class="arc arc3" d="M77.9,15c24.5,0.1,48,9.8,65.4,27.1c9.6,6.9,17-6.1,9.4-11.8C111-10.1,44.7-10.1,3.1,30.4 C-4.4,36,2.9,49,12.5,42.1C29.9,24.8,53.4,15.1,77.9,15z"/>
								</svg>
							</div>
						</div>
						<div class="wifi-list" id="wifiList">
						</div>
						<div class="sns-share">
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/bnr_sns.jpg" alt="이벤트 소문내면 한 번 더 기회를 드려요!"></p>
							<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
							<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
						</div>
						<!-- 힌트 추가 -->
						<div class="hint">
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/bnr_hint.jpg" alt="비밀번호 힌트"></p>
							<div class="link mWeb">
								<a href="https://www.facebook.com/your10x10/" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>')" target="_blank">텐바이텐 페이스북으로 이동</a>
								<a href="https://www.instagram.com/your10x10/" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>')" target="_blank">텐바이텐 인스타그램으로 이동</a>
							</div>
							<div class="link mApp">
								<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function() {fnAPPpopupExternalBrowser('https://tenten.app.link/e/G3BQH6zp8Y'); return false;});return false;">텐바이텐 페이스북으로 이동</a>
								<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_floatingbanner_in_event','eventcode','<%=eCode%>', function() {fnAPPpopupExternalBrowser('https://tenten.app.link/e/avxD5iOp8Y'); return false;});return false;">텐바이텐 인스타그램으로 이동</a>
							</div>
						</div>
						<!-- 푸시 -->
						<div class="push">
							<button type="button" onclick="regAlram(true);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/btn_push.jpg" alt="내일 푸시 알림 받기"></button>
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/tit_push.jpg" alt="푸시 수신 설정 방법"></h3>
							<div class="slider swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_push_1.jpg" alt="STEP 01"></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_push_2.jpg" alt="STEP 02"></div>
									<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_push_3.jpg" alt="STEP 03"></div>
								</div>
								<button type="button" class="swiper-button swiper-button-prev">
									<svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
								</button>
								<button type="button" class="swiper-button swiper-button-next">
									<svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
								</button>
							</div>
						</div>
						<!-- 유의사항 -->
						<div class="noti">
							<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/tit_noti.png" alt="이벤트 유의사항"></h3>
							<ul>
								<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
								<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
								<li>비밀번호는 상품 별로 모두 다르게 설정되어 있습니다.</li>
								<li>모든 상품의 당첨자가 결정되면 이벤트는 마감됩니다.</li>
								<li>5만 원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 예정입니다.</li>
								<li>제세공과금은 텐바이텐 부담입니다.</li>
								<li>당첨자에게는 상품 수령 후, 인증 사진을 요청할 수 있습니다.</li>
								<li>당첨 상품은 아이패드 mini 64GB 실버 2대, 스페이스 그레이 1대, 골드 1대, 마샬 액톤 2 스피커 블랙 2대, 화이트 2대, 에어팟 2세대 유선 충전 케이스 모델 4대로, 총 12대입니다.</li>
								<li>본 이벤트는 애플과는 무관한 이벤트임을 알려드립니다.</li>
							</ul>
						</div>
					</div>
				</div>

				<%'<!-- for dev msg : 팝업 display none/block -->%>
				<%'<!-- 팝업 1. 암호입력 -->%>
				<div id="pwdLayer" class="ly-popup ly-pwd">
					<div class="tit-pwd" id="itemName">'아이패드 미니'의 <b>비밀번호 입력</b></div>
					<!-- for dev msg : 상품이미지 파일명 img_ 뒤에 ipad / airpod / marshall .png -->
					<div class="img-prd"><img id="selectedImg" src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_ipad.png" alt=""></div>
					<div class="input-area">
						<strong class="label">비밀번호</strong>
						<div class="input" id="dispPwd">
							<em>*</em>
							<em>*</em>
							<em>*</em>
							<em>*</em>
						</div>
					</div>
					<div class="keypad">
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
							<button type="button" class="btn-close">뒤로가기</button>
							<button type="button" class="pwd-btn">0</button>
							<button type="button" onclick="delPassword()" class="btn-del">지우기</button>
						</div>
					</div>
				</div>
				<%'<!-- 팝업 2. 암호성공 -->%>
				<div class="ly-popup ly-win" id="win">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/ly_win.jpg" alt="축하드립니다"></p>
					<div class="prd-area">
						<!-- for dev msg : 상품이미지 파일명 img_ 뒤에 ipad / airpod / marshall .png -->
						<span class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/img_ipad.png" id="winImg" alt=""></span>
						<span class="name">아이패드 mini 64GB 스페이스그레이</span>
					</div>
					<div class="bot-btn">
						<button type="button" class="btn-main">이벤트 메인으로 가기</button>
					</div>
				</div>
				<%'<!-- 팝업 3. 암호실패1 -->%>
				<div class="ly-popup ly-fail1" id="fail1">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/ly_fail_01.jpg" alt="공유하면 한 번 더"></p>
					<div class="share">
						<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<div class="bot-btn">
						<button type="button" class="btn-main">이벤트 메인으로 가기</button>
					</div>
				</div>
				<%'<!-- 팝업 4. 공유 안하고 재도전시 -->%>
				<div class="ly-popup ly-already" id="secondTry">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/ly_already.jpg" alt="이미 한 번 도전하였습니다"></p>
					<div class="share">
						<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<div class="bot-btn">
						<button type="button" class="btn-main">이벤트 메인으로 가기</button>
					</div>
				</div>
				<%'<!-- 팝업 5. 암호실패2 -->%>
				<div class="ly-popup ly-fail2" id="fail2">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96413/m/ly_fail_02.jpg" alt="비밀번호가 맞지 않습니다"></p>
					<div class="bot-btn">
						<button type="button" class="btn-main">이벤트 메인으로 가기</button>
						<button type="button" onclick="handleClickCoupon()" class="btn-cpn">쿠폰 받기</button>
					</div>
				</div>
			</div>
			<!--// 96413 MKT 와이파이 -->
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
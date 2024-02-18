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
' Description : 2019 비밀번호 이벤트
' History : 2019-10-10 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "90409"
	moECode = "90362"
Else
	eCode = "97806"
	moECode = "97805"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-10-10")		'이벤트 시작일
eventEndDate 	= cdate("2019-10-31")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-10-10")'테스트
LoginUserid		= getencLoginUserid()
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[돌아온 비밀번호 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/97806/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[돌아온 비밀번호 이벤트]"
	Dim kakaodescription : kakaodescription = "가장 먼저 비밀번호를 맞히고 엄청난 상품을 가져가세요!"
	Dim kakaooldver : kakaooldver = "가장 먼저 비밀번호를 맞히고 엄청난 상품을 받아가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/97806/img_kakao.jpg"
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
.mEvt97806 {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97806/m/bg_pat.jpg) repeat 0 0 / 17vw auto;}
.mEvt97806 button {background-color:transparent;}
.mEvt97806 .main {position:relative;}
.mEvt97806 .main .topic {position:relative;}
.mEvt97806 .main .ico-lock {position:absolute; top:21%; left:50%; width:5.6%; margin-left:-2.8%; animation:vibrate 3s 1s 2;}
@keyframes vibrate {
	0%,2%,4%,6%,8%,10%,12%,14%,16%,18% {
		-webkit-transform:translate3d(-0.1rem, 0, 0); transform:translate3d(-0.1rem, 0, 0);
	}
	1%,3%,5%,7%,9%,11%,13%,15%,17%,19% {
		-webkit-transform:translate3d(0.1rem, 0, 0); transform:translate3d(0.1rem, 0, 0);
	}
	20%, 100% {
		-webkit-transform:translate3d(0, 0, 0); transform:translate3d(0, 0, 0);
	}
}
.mEvt97806 .item-list {overflow:hidden; position:relative; width:88vw; margin:-2.67vw auto; z-index:0;}
.mEvt97806 .item-list li {float:left; width:26.67vw; height:26.67vw; margin:2.67vw 1.33vw;}
.mEvt97806 .item-list .item {position:relative; text-align:center; background-color:#fff; border-radius:2.13rem;}
.mEvt97806 .item-list .item .txt-soldout {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:57%; background:rgba(44,44,44,0.7) url(//webimage.10x10.co.kr/fixevent/event/2019/97806/m/txt_soldout.png) no-repeat 50% / 100% auto; border-radius:2.13rem;}
.mEvt97806 .item-list .item.soldout .txt-soldout {display:block;}
.mEvt97806 .item-list .item .txt-soldout .pw {font-size:1.07rem; color:#ffeab9; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.mEvt97806 .item-list .item .txt-soldout .user {margin-top:0.3rem; font-size:0.94rem; color:#bdbdbd;}
.mEvt97806 .item-list .item .txt-locked {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:57%; background:rgba(215,215,215,0.88) url(//webimage.10x10.co.kr/fixevent/event/2019/97806/m/bg_locked.png) no-repeat 50% / 100% auto; border-radius:2.13rem;}
.mEvt97806 .item-list .item.locked .txt-locked {display:block;}
.mEvt97806 .item-list .item .txt-locked .date {font-size:1.07rem; color:#666; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.mEvt97806 .item-list .item.open {border:0.26rem solid transparent; background-clip:padding-box;}
.mEvt97806 .item-list .item.open:after {content:' '; position:absolute; top:0; right:0; bottom:0; left:0; margin:-0.26rem; background:radial-gradient(#f1eb91 0%,#ffbf31 50%); background-size:200% 200%; background-position: 50% 0%; z-index:-1; border-radius:inherit; animation:gradient 1s 30;}
@keyframes gradient {
	0%,100% {background-position:50% 0%;}
	25% {background-position:100% 50%;}
	50% {background-position:50% 100%;}
	75% {background-position:0% 50%;}
}
.mEvt97806 .main .share {position:relative;}
.mEvt97806 .main .share button {position:absolute; top:12%; right:28vw; width:20vw; height:20vw; font-size:0; color:transparent;}
.mEvt97806 .main .share button:last-child {right:8vw;}
.mEvt97806 .hint {position:relative;}
.mEvt97806 .hint a {position:absolute; top:35%; right:50%; width:20vw; height:20vw; font-size:0; color:transparent;}
.mEvt97806 .hint a:last-child {right:inherit; left:50%;}
.mEvt97806 .noti {background-color:#868686;}
.mEvt97806 .noti ul {padding:8vw 6.7% 12vw;}
.mEvt97806 .noti ul li {position:relative; padding-left:0.8rem; font-size:1.11rem; line-height:1.4; color:#fff; word-break:keep-all;}
.mEvt97806 .noti ul li + li {margin-top:1rem;}
.mEvt97806 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block; line-height:1;}
.mEvt97806 .ly-detail {display:none; position:fixed; left:0; top:0; width:100%; height:100%; background:rgba(36,36,36,0.6);}
.mEvt97806 .ly-detail .inner {overflow:hidden; position:absolute; left:7vw; top:50%; width:86vw; margin-top:calc(-30vh - 10vw); border-radius:0.21rem;}
.mEvt97806 .ly-detail h3 {background-color:#fff;}
.mEvt97806 .ly-detail .btn-close {position:absolute; right:0; top:0; width:15vw; height:15vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97806/m/ico_close.png) no-repeat 50% / 5vw auto;}
.mEvt97806 .ly-detail .scroll {overflow-x:hidden; overflow-y:scroll; height:60vh;}
.mEvt97806 .ly-detail .mCSB_container {margin-right:0;}
.mEvt97806 .ly-detail .mCSB_scrollTools {width:8vw; height:57vh;}
.mEvt97806 .ly-detail .mCSB_draggerRail {width:2.4vw; background-color:rgba(241,241,241,0.8);}
.mEvt97806 .ly-detail .mCSB_dragger_bar {width:2.4vw; background-color:rgba(255,234,93,0.8);}
.mEvt97806 .mCSB_scrollTools .mCSB_dragger.mCSB_dragger_onDrag .mCSB_dragger_bar,
.mEvt97806 .mCSB_scrollTools .mCSB_dragger:active .mCSB_dragger_bar {background-color:rgba(255,234,93,0.8);}
.mEvt97806 .ly-popup {display:none; position:relative; text-align:center;}
.mEvt97806 .ly-popup .btn-main {position:absolute; bottom:10%; left:0; width:100%; height:10%; font-size:0; color:transparent;}
.mEvt97806 .ly-popup .btn-coupon {position:absolute; bottom:26%; left:0; width:100%; height:10%; font-size:0; color:transparent;}
.mEvt97806 .ly-popup .share {display:flex; justify-content:center; position:absolute; top:33%; left:0; width:100%;}
.mEvt97806 .ly-popup .share button {width:30vw; height:30vw; font-size:0; color:transparent;}
.mEvt97806 .ly-pwd {padding:7vw 0 11vw;}
.mEvt97806 .ly-pwd .img-prd {width:30vw; margin:0 auto;}
.mEvt97806 .ly-pwd .txt-input {font-size:1.45rem; color:#fff; line-height:1.5;}
.mEvt97806 .ly-pwd .input-area {display:flex; justify-content:center;}
.mEvt97806 .ly-pwd .input-area em {display:inline-block; width:3.54rem; height:3.54rem; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97806/m/ico_input.png) no-repeat 0 0 / 14.17rem auto;}
.mEvt97806 .ly-pwd .input-area em:nth-child(2) {background-position-x:33.3%;}
.mEvt97806 .ly-pwd .input-area em:nth-child(3) {background-position-x:66.6%;}
.mEvt97806 .ly-pwd .input-area em:nth-child(4) {background-position-x:99.9%;}
.mEvt97806 .ly-pwd .input-area em.active {background-position-y:100%;}
.mEvt97806 .ly-pwd .keypad {position:relative; width:23.81rem; margin:2vw auto 0;}
.mEvt97806 .ly-pwd .keypad .keys {display:flex; flex-wrap:wrap; position:absolute; top:0; left:0; width:100%; height:100%;}
.mEvt97806 .ly-pwd .keypad .keys button {flex-basis:33.3%; font-size:0; color:transparent;}
.mEvt97806 .ly-win .gift {position:absolute; top:28%; left:0; width:100%;}
.mEvt97806 .ly-win .img-prd {width:48vw; margin:0 auto;}
.mEvt97806 .ly-win .name {font-size:1.19rem; color:#c2c2c2;}
.mEvt97806 .bnr-mkt {position:relative;}
.mEvt97806 .bnr-mkt .link {position:absolute; top:21%; left:0; width:100%;}
.mEvt97806 .bnr-mkt .link > a {display:block; width:100%; padding-top:33%;}
</style>
<script src="//malihu.github.io/custom-scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript">
$(function(){
	$(".ly-detail .scroll").mCustomScrollbar();
	// 메인, 팝업 display none/block
	$('.ly-popup .btn-main, .ly-pwd .btn-close').click(function(){
		$('.mEvt97806 .ly-popup').hide();
		$('.mEvt97806 .main').show();
	});	
});
</script>
<script type="text/javascript">
var selectedItem = 0
var selectedItemImgCode, selectedItemName = ""
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	getEvtItemList();
	$("#keys .pwd-btn").click(function(){
		if(userPwd.length < 4){
			var pressedNumber = $(this).text()
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
});
</script>
<script>
function getEvtItemList(){
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/password_event/pwdEventProc.asp",
		data: "mode=evtobj",
		dataType: "text",
		async: false
	}).responseText;

	var resultData = JSON.parse(str).data;
	// console.log(itemListObj)
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
				url:"/event/etc/password_event/pwdEventProc.asp",
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
								// console.log(Data)
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
			url:"/event/etc/password_event/pwdEventProc.asp",
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
		
		if(numOfTry >= 2){
			$("#fail2").show();
			return false;
		}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){
		numOfTry++
		$("#win").show();
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/97806/m/" + selectedItemImgCode + ".png")
		$("#winItem").text(selectedItemName)
	}else if(returnCode == "A03"){
		$('#main').show();
		alert("오픈된 상품이 아닙니다.");
	}
}
function setButton(){
	$('#itemList li .open').click(function(){
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
		selectedItem = $(this).attr("itemId")
		selectedItemImgCode = $(this).attr("imgcode")	
		selectedItemName = $(this).attr("itemName")
		$("#selectedImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/97806/m/"+ selectedItemImgCode +".png")
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
	var today = new Date()
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
				tmpCls = 'locked'
				info = '\
					<div class="txt-locked">\
						<p class="date">'+ (new Date(item.openDate).getMonth() + 1) +'월 '+ new Date(item.openDate).getDate() +'일</p>\
					</div>\
				'
			}
			if(item.winner != "0"){
				tmpCls = 'soldout'
				info = '\
					<div class="txt-soldout">\
						<p class="pw">PW :'+ item.password +'</p>\
						<p class="user">'+ tmpName +'</p>\
					</div>\
				'
			}
			tmpEl = '\
			<li>\
				<div class="item '+ tmpCls +'" imgCode=\''+ item.imgCode +'\' itemId=' + item.itemcode + ' itemName=\''+ item.itemName +'\'>\
					<button type="button" class="btn-item"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/' + item.imgCode + '.png" alt="'+ item.itemName +'"></button>\
					'+ info +'\
				</div>\
			</li>\
			'
			itemEle += tmpEl
		});
		itemEle = itemEle + '<li><button type="button" class="btn-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/btn_detail.png" alt="자세히 보기"></button></li>'
	}

	// 대기 리스트
	$rootEl.append(
		itemEle
	)
	// 자세히 보기 팝업
	$('.mEvt97806 .btn-detail').click(function(){
		$('.ly-detail').fadeIn('fast');
	});
	$('.ly-detail .btn-close').click(function(){
		$('.ly-detail').fadeOut('fast');
	});	
}
function printUserName(name, num, replaceStr){
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}
function handleClickCoupon(){
	couponClick++
	var alertTxt = couponClick < 2 ? "2,000원 쿠폰이 발급되었습니다. \n24시간 이내에 사용하세요!" : "이미 쿠폰이 발급되었습니다."
	alert(alertTxt)
}
function handleClickBanner(link, cb){
	fnAmplitudeEventMultiPropertiesAction('click_cst_event_bnr','eventcode|link','<%=ecode%>|'+link, function(bool){if(bool) {cb();}});	
	return false;
}

</script>
			<!-- 97806 MKT 비밀번호 -->
			<div class="mEvt97806">
<%'				<!-- for dev msg : SNS 공유 텍스트 및 이미지
'											가장 먼저 비밀번호를 맞히고 엄청난 상품을 가져가세요!
'											http://webimage.10x10.co.kr/fixevent/event/2019/97806/img_kakao.jpg -->
'				<!-- for dev msg : 12종 상품명 및 이미지 (상품 리스트, 비밀번호 입력 팝업, 당첨 팝업 공통 사용)
'											//webimage.10x10.co.kr/fixevent/event/2019/97806/m/ + 파일명 + .png
'											아이폰 11 64GB 퍼플		iphone11_purple
'											아이폰 11 64GB 화이트	iphone11_white
'											마샬 액톤2 스피커 블랙		marshall_black
'											마샬 액톤2 스피커 화이트	marshall_white
'											아이패드 mini 64GB 스페이스		ipad_sg
'											아이패드 mini 64GB 실버			ipad_silver
'											에어팟 충전 케이스 모델		airpods
'											로우로우 R TRUNK 63L_머스타드	rawrow_mustard
'											로우로우 R TRUNK 63L_아이보리	rawrow_ivory
'											LG전자 시네빔 PH550			lg_cine
'											라이카 소포트 민트		leica_mint
'											라이카 소포트 블랙		leica_black
'											-->
%>											
				<div class="main" id="main">
					<div class="topic">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/tit_pwd.png" alt="비밀번호"></h2>
						<i class="ico-lock"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/ico_lock.png" alt=""></i>
					</div>
					<ul class="item-list" id="itemList"></ul>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/txt_guide.png" alt="비밀번호는 각 상품 별로 모두 다르게 설정되어 있습니다"></p>
					<%'<!-- for dev msg : SNS 공유 -->%>
					<div class="share">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/bnr_share.png" alt="공유"></p>
						<button type="button" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<div class="hint">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/txt_hint.png" alt="비밀번호 힌트"></p>
						<a href="javascript:void(0)" onclick="handleClickBanner('fb', function(){fnAPPpopupExternalBrowser('https://tenten.app.link/e/oVmxR23Jq0');})">텐바이텐 페이스북 바로가기</a>
						<a href="javascript:void(0)" onclick="handleClickBanner('in', function(){fnAPPpopupExternalBrowser('https://tenten.app.link/e/wHT0T9dKq0');})">텐바이텐 인스타그램 바로가기</a>
					</div>
					<div class="bnr-mkt">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/bnr_mkt.jpg" alt=""></p>
						<div class="link">
							<a href="/event/eventmain.asp?eventid=97607" onclick="jsEventlinkURL(97607);return false;"></a>
							<a href="/event/eventmain.asp?eventid=97594" onclick="jsEventlinkURL(97594);return false;"></a>
							<a href="/event/eventmain.asp?eventid=97641" onclick="jsEventlinkURL(97641);return false;"></a>
						</div>
					</div>
					<%'<!-- 97541(APP) 매일리지 1탄 이벤트 페이지 랜딩 -->%>
					<div>
						<a href="javascript:void(0)" onclick="handleClickBanner('97541', function(){fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97541')})">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/bnr_evt.jpg" alt="매일리지 1탄">
						</a>
					</div>
					<div class="noti">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/tit_noti.png" alt="이벤트 유의사항"></h3>
						<ul>
							<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
							<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
							<li>비밀번호는 상품 별로 모두 다르게 설정되어 있습니다.</li>
							<li>모든 상품의 당첨자가 결정되면 이벤트는 마감됩니다.</li>
							<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
							<li>당첨자에게는 상품 수령 후, 인증 사진을 요청할 수 있습니다.</li>
						</ul>
					</div>
				</div>

				<%'<!-- 팝업 1. 자세히 보기 (개발X) -->%>
				<div class="ly-detail">
					<div class="inner">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/tit_detail.png" alt="상품 자세히 보기"></h3>
						<button type="button" class="btn-close">닫기</button>
						<div class="scroll"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_detail.jpg" alt=""></div>
					</div>
				</div>
				<%'<!-- 팝업 2. 비밀번호 입력 -->%>
				<div class="ly-popup ly-pwd" id="pwdLayer">
					<%'<!-- for dev msg : 선택된 상품 이미지 노출 -->%>
					<div class="img-prd"><img id="selectedImg" src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/marshall_white.png" alt=""></div>
					<p class="txt-input">비밀번호를 입력해주세요</p>
					<%'<!-- for dev msg : 입력시 클래스 active 추가 -->%>
					<div class="input-area" id="dispPwd">
						<em>1</em>
						<em>2</em>
						<em>3</em>
						<em>4</em>
					</div>
					<div class="keypad">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_keypad.png" alt=""></p>
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
				<%'<!-- 팝업 3. 당첨 -->%>
				<div id="win" class="ly-popup ly-win">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_win.png" alt="축하드립니다"></p>
					<div class="gift">
						<%'<!-- for dev msg : 당첨된 상품 이미지 및 상품명 노출 -->%>
						<div class="img-prd"><img  id="winImg" src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/iphone11_purple.png" alt=""></div>
						<p class="name" id="winItem"></p>
					</div>
					<button type="button" class="btn-main">이벤트 메인으로 가기</button>
				</div>
				<%'<!-- 팝업 4. 꽝1 -->%>
				<div id="fail1" class="ly-popup">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_fail_01.png" alt="맞지 않습니다"></p>
					<%'<!-- for dev msg : SNS 공유 -->%>
					<div class="share">
						<button type="button" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<button type="button" class="btn-main">이벤트 메인으로 가기</button>
				</div>
				<%'<!-- 팝업 5. 꽝1 후 공유 안했을때 -->%>
				<div id="secondTry" class="ly-popup">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_already.png" alt="이미 1번 도전하였습니다"></p>
					<!-- for dev msg : SNS 공유 -->
					<div class="share">
						<button type="button" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<button type="button" class="btn-main">이벤트 메인으로 가기</button>
				</div>
				<%'<!-- 팝업 6. 꽝2 -->%>
				<div id="fail2" class="ly-popup">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97806/m/img_fail_02.png" alt="비밀번호 2회 오류"></p>
					<button type="button" onclick="handleClickCoupon()" class="btn-coupon">쿠폰 받기</button>
					<button type="button" class="btn-main">이벤트 메인으로 가기</button>
				</div>
			</div>
			<!--// 97806 MKT 비밀번호 -->
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
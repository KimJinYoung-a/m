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
' History : 2019-07-16 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4

IF application("Svr_Info") = "Dev" THEN
	eCode = "90338"	
	moECode = "90339"
Else
	eCode = "96063"
	moECode = "96062"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-07-16")		'이벤트 시작일 
eventEndDate 	= cdate("2019-07-31")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-07-17")'테스트
LoginUserid		= getencLoginUserid()

dim SqlStr

sqlStr = sqlStr & " select      "
sqlStr = sqlStr & "   (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt3 <> '0' and userid = 'secret-code' and sub_opt1 in ('1')) as '아이폰'  "
sqlStr = sqlStr & " , (SELECT 1 - count(1) as pdt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt3 <> '0' and userid = 'secret-code' and sub_opt1 in ('2')) as '맥북에어'  "
sqlStr = sqlStr & " , (SELECT 2 - count(1) as pdt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt3 <> '0' and userid = 'secret-code' and sub_opt1 in ('3','4')) as '아이패드'  "
sqlStr = sqlStr & " , (SELECT 3 - count(1) as pdt4 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt3 <> '0' and userid = 'secret-code' and sub_opt1 in ('5','6','7')) as '마샬스피커' 	  "

rsget.Open sqlstr, dbget, 1
	prd1 = rsget("아이폰")
	prd2 = rsget("맥북에어")
	prd3 = rsget("아이패드")
	prd4 = rsget("마샬스피커")
rsget.close				
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[비밀번호 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96063/img_kakao.jpg?v=1.0")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[비밀번호 이벤트]"
<<<<<<< HEAD
	Dim kakaodescription : kakaodescription = "가장 먼저 비밀번호를 맞추고 엄청난 상품의 주인공에 도전하세요!"
	Dim kakaooldver : kakaooldver = "가장 먼저 비밀번호를 맞추고 엄청난 상품의 주인공에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96063/img_kakao.jpg?v=1.0"
=======
	Dim kakaodescription : kakaodescription = "가장 먼저 비밀번호를 풀고 엄청난 상품에 도전하세요!"
	Dim kakaooldver : kakaooldver = "가장 먼저 비밀번호를 풀고 엄청난 상품에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96063/img_kakao.jpg"
>>>>>>> feature/비밀번호이벤트
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
if isShared then triedNum = 1
%>
<style type="text/css">
.mEvt96063 {position:relative;}
.mEvt96063 .topic {position:relative; background-color:#25233c;}
.mEvt96063 .topic .ico-lock {position:absolute; right:18.13%; top:34%;}
.mEvt96063 .topic .ico-lock:before,
.mEvt96063 .topic .ico-lock:after {content:' '; display:block; margin:0 auto;}
.mEvt96063 .topic .ico-lock:before {width:1.19rem; height:1.61rem; border:0.26rem solid #fff; border-bottom:0; background:transparent; border-radius:0.85rem 0.85rem 0 0; animation:lock-ani 5s 1s 20; transform-origin:95%;}
.mEvt96063 .topic .ico-lock:after {position:relative; width:2.13rem; height:1.96rem; margin-top:-.5rem; border-radius:0.3rem; background-color:#fff;}
@keyframes lock-ani {
	0%, 60%, 100% {transform:rotateY(0);}
	30% {transform:rotateY(180deg);}
}
.mEvt96063 .item-wrap {position:relative; background-color:#2f2a62;}
.mEvt96063 .item-list {position:absolute; top:7.8%; left:7%; right:7%; width:86%;}
.mEvt96063 .item-list li {position:relative; float:left; width:50%; margin-bottom:13.8%;}
.mEvt96063 .item-list .thumbnail {overflow:hidden; width:82%; margin:0 auto; border-radius:2.13rem; -webkit-mask-image:-webkit-radial-gradient(white, black);}
.mEvt96063 .item-list .btn-click {position:absolute; top:0; left:0; z-index:3; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_locked.png) no-repeat 50% / cover;}
.mEvt96063 .item-list .btn-click > img {animation:blink 3s 20;}
@keyframes blink {
	0%, 20%, 40%, 100% {opacity:1;}
	10%, 30% {opacity:0;}
}
.mEvt96063 .item-list .txt-soldout {display:none; position:absolute; top:0; left:0; z-index:4; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_soldout.png) no-repeat 50% / cover; font-size:0; color:transparent;}
.mEvt96063 .item-list .soldout .txt-soldout {display:block;}
.mEvt96063 .item-list .soldout .btn-click {display:none;}
.mEvt96063 .item-list .count {position:absolute; top:-.6rem; right:5%; z-index:5; padding:.15rem 1rem 0; line-height:2.26rem; font-size:1.24rem; color:#fff; background-color:#ff2727; border-radius:1.2rem;}
.mEvt96063 .item-list .count b {display:inline-block; font-family:'AvenirNext-DemiBold'; font-weight:bold; font-size:1.54rem; vertical-align:-1px;}
.mEvt96063 .sns-share {position:relative; background-color:#373b6b;}
.mEvt96063 .sns-share button {position:absolute; top:20%; width:18%; height:60%; background:none; font-size:0; color:transparent;}
.mEvt96063 .sns-share .btn-fb {right:28%;}
.mEvt96063 .sns-share .btn-ka {right:10%;}
.winner {position:relative;}
.winner .slider {position:absolute; top:21.6%; left:0; width:100%;}
.winner .swiper-slide:first-child {margin-left:2.99rem;}
.winner .swiper-slide:last-child {margin-right:2.13rem;}
.winner .item {width:10.24rem; margin-right:1.28rem;}
.winner .blank {width:11.09rem; margin-right:0.85rem;}
.winner .item .thumbnail {overflow:hidden; width:10.24rem; height:10.24rem; -webkit-border-radius:50%; border-radius:50%;}
.winner .item .thumbnail img {background-color:#ebebeb;}
.winner .desc {text-align:center;}
.winner .desc .date {display:inline-block; margin-top:0.85rem; padding:0.45rem 0.77rem 0.35rem; font-family:'AvenirNext-DemiBold'; font-weight:bold; font-size:1.02rem; color:#fff; background:#1a1a1a; -webkit-border-radius:1rem; border-radius:1rem; letter-spacing:.1rem;}
.winner .desc .name {display:block; overflow:hidden; margin-top:1.28rem; white-space:nowrap; text-overflow:ellipsis; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.28rem; color:#000;}
.winner .desc .user {display:block; margin-top:1rem; font-size:1.07rem; color:#e5e5e5;}
.mEvt96063 .push {background-color:#3f25a5;}
.mEvt96063 .push .swiper-button {top:36%; background:none;}
.mEvt96063 .push .swiper-button svg {vertical-align:top;}
.mEvt96063 .push .swiper-button-prev {left:8%;}
.mEvt96063 .push .swiper-button-next {right:8%;}
.mEvt96063 .noti {background-color:#24a8c1;}
.mEvt96063 .noti h3 {text-align:center;}
.mEvt96063 .noti ul {padding:2rem 6.7% 3.6rem;}
.mEvt96063 .noti li {position:relative; padding-left:1rem; font-size:1.11rem; line-height:1.38; color:#fff; word-break:keep-all;}
.mEvt96063 .noti li + li {margin-top:1.19rem;}
.mEvt96063 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block;}
.ly-popup {display:none; position:relative;}
.ly-popup .ly-inner {position:absolute; top:0; left:0; width:100%; height:100%;}
.ly-popup button {-webkit-touch-callout:none; -webkit-user-select:none; -khtml-user-select:none; -moz-user-select:none; -ms-user-select:none; user-select:none;}
.ly-popup .btn-bot {position:absolute; left:0; width:100%; padding:1rem 0; font-size:1.15rem; color:#fff; background:none;}
.ly-popup .btn-bot span {border-bottom:1px solid #fff;}
.ly-popup .btn-bot.btn-main {bottom:14%;}
.ly-popup .btn-bot.btn-main span {padding:0 .3rem;}
.ly-popup .btn-bot.btn-coupon {bottom:23%;}
.ly-popup .btn-bot.btn-coupon span {padding:0 .5rem;}
.ly-popup .share {display:flex; position:absolute; left:0; width:100%; height:17%;}
.ly-popup .share button {width:50%; height:100%; background:none; font-size:0; color:transparent;}
.ly-password .thumbnail {width:10rem; height:10rem; margin:2.18rem auto 0.75rem; background-color:transparent;}
.ly-password .thumbnail:before {opacity:0;}
.ly-password .txt-input {font-size:1.75rem; color:#fff; text-align:center;}
.ly-password .keypad {position:relative; /* width:74.4%; */ width:23.81rem; margin:0 auto;}
.ly-password .keypad .keys {display:flex; flex-wrap:wrap; position:absolute; top:0; left:0; width:100%; height:100%;}
.ly-password .keypad .keys button {flex-basis:33.3%; font-size:0; color:transparent; background:none;}
.ly-password .input-area {display:flex; justify-content:center; margin:1rem 0;}
.ly-password .input-area em {display:inline-block; padding:1.07rem; font-size:0; color:transparent;}
.ly-password .input-area em:after {display:block; content:' '; width:1.11rem; height:1.11rem; border:0.13rem solid #595094; border-radius:50%;}
.ly-password .input-area em.active:after {background-color:#595094;}
.ly-password .btn-close,
.ly-password .btn-del {position:absolute; top:82%; padding:1rem 3.41rem; font-size:1.15rem; color:#fff; background:none; -webkit-tap-highlight-color:rgba(255, 255, 255, 0);}
.ly-password .btn-close {left:0;}
.ly-password .btn-del {right:0;}
.ly-fail1 .share {top:34%;}
.ly-already .share {top:44%;}
</style>
<script type="text/javascript">
var numOfTry = <%=triedNum%>;
var password = ""
var selectedItem = ""
var isFirstTried = "<%=isFirstTried%>"
var isShareClick = false
$(function(){
	getWinner()

	// 비밀번호 암호 해제
	$('.item-list .btn-click').click(function() {
		<% If Not(IsUserLoginOK) Then %>
			calllogin();
			return false;
		<% end if %>
		// console.log(numOfTry)
		if(numOfTry==2 || '<%=isSecondTried%>' == 'True'){
			endAlert()
			return false;
		}else if(!isShareClick && numOfTry==1 && '<%=isShared%>'=='False'){			
			$('.evt-main').hide();
			$("#tryWithoutShare").css("display", "block")	
			return false;		
		}else if(isFirstTried == "True" && '<%=isShared%>'=='False'){			
			console.log('')
			$('.evt-main').hide();
			$("#tryWithoutShare").css("display", "block")	
			return false;
		}
		resetPassword();
				
		selectedItem = $(this).attr("itemOrder")
		$("#selectedImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_0" + selectedItem + ".png")
		//이미지		
		$('.ly-password').show();
		$('.evt-main').hide();
		window.parent.$('html,body').animate({scrollTop:$('.ly-password').offset().top});
	});

	$('.ly-password .btn-close, .ly-popup .btn-main').click(function() {
		resetPassword()
		$('.ly-popup').hide();
		$('.evt-main').show();
	});
	
	var win = $('.winner .swiper-wrapper');
	var tx = win.offset().left - 30;
	//win.css({"transform": "translate3d(" + tx + "px,0,0)"});

	// 푸시 롤링
	pushSwiper = new Swiper('.push .swiper-container', {
		speed:1200,
		prevButton:'.push .swiper-button-prev',
		nextButton:'.push .swiper-button-next'
	});

	$(".pwd-btn").click(function(){
		if(password.length < 4){
			pressedNumber = $(this).index() + 1
			password += pressedNumber	 
			$($(".input-area em")[password.length - 1]).addClass("active")
			if(password.length == 4){
				$('#passwordLayer').hide();
				eventTry();
			}
		}else{
			return false;
		}
	})
});
</script>
<script>
function resetPassword(){
	password = ""
	$(".input-area em").attr("class", "")
}
function delPassword(){
	if(password.length > 0){
		password = password.substring(0, password.length-1)
		$($(".input-area em")[password.length]).removeClass("active")
	}	
	return false
}
function chkValid(){
	if(password.length != 4 || selectedItem == ""){
		alert("상품을 선택해서 비밀번호를 눌러주세요.");
		return false;
	}
	return true;
}
function eventTry(){
	if(!chkValid()) return false;	
	
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			res = $.ajax({
				type:"POST",
				url:"/event/etc/password_event/pwdEventProc.asp",
				data: {
					mode: "add", 
					selectedPdt: selectedItem, 
					code: password
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
									// console.log(result.result)
									returnCode = result.result
									itemid = result.winItemid	
									popResult(returnCode, itemid);
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
			// console.log(res.responseText)
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
function endAlert(){
	<% if currentDate < Cdate("2019-07-31") then %>
		alert("오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!");
		$('.evt-main').show();
	<% else %>
		alert("이벤트 응모를 모두 완료하셨습니다.\n응모해주셔서 감사합니다.");
		$('.evt-main').show();
	<% end if %>	
}
function popResult(returnCode, itemid){	
	// console.log(numOfTry)
	if(numOfTry == 2){
		endAlert()
	} 

	if(returnCode[0] == "B"){
		numOfTry++				
		if(numOfTry == 1){
			$("#firstTryPopup").css("display", "block")
		}else{			
			$("#secondTryPopup").css("display", "block")
		}		
	}else if(returnCode[0] == "A"){ 
		if(returnCode == "A02"){
			endAlert()	
		}else{
			$("#tryWithoutShare").css("display", "block")
		}
	}else if(returnCode[0] == "C"){
		$("#success").show();
		// console.log(itemid)
		$("#successImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_win_"+getItemInfo(parseInt(itemid)).imgCode+".png?v=1.0")				
		numOfTry++
	}	
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
		
		isShareClick = true
		if(isFirstTried){
			isFirstTried = false
			numOfTry = 1
		}
		
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

function getItemInfo(itemid){
	var itemInfo = {}
	var imgCode;
	var itemName;			
	switch (itemid) {
		case 1 : 
			imgCode = "01"
			itemName = "아이폰XR"
			break;						
		case 2 : 
			imgCode = "02"
			itemName = "맥북에어"
			break;					
		case 34 : 
			imgCode = "03"
			itemName = "아이패드 mini"
			break;								
		case 567 : 
			imgCode = "04"
			itemName = "마샬 액톤2 스피커블랙"
			break;
	}	
	return {
		imgCode: imgCode,
		itemName: itemName
	}
}
function printUserName(name, num, replaceStr){	
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}
function getWinner() {	
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/password_event/pwdEventProc.asp",
			data: "mode=winner",
			dataType: "text",
			async: false
		}).responseText;
				
		var resultData = JSON.parse(str).data;
		var winnerLength = resultData.length;
		var $rootEl = $("#winners")
		$rootEl.empty();
		
		var emptyEl = '<div class="swiper-slide"><div class="blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/img_blank.png" alt=""></div></div>'
		$.each(resultData,function(key,value) {
			var itemEle = "";	
			var itemid = value.sub_opt2
			var tmpItemInfo = getItemInfo(itemid)
			itemEle = '<div class="swiper-slide">'

			itemEle = itemEle + '		<div class="item">'
			itemEle = itemEle + '			<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_'+tmpItemInfo.imgCode+'.png" alt=""></div>'
			itemEle = itemEle + '			<div class="desc">'
			itemEle = itemEle + '				<em class="date">' + value.pwd + '</em>'
			itemEle = itemEle + '				<strong class="name">' + tmpItemInfo.itemName + '</strong>'
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
		for(var i = 0 ; i < 7 - winnerLength; i++){
			$rootEl.append(emptyEl)
		}		
		$(function(){
			var position = $('.hundred').offset();
			$(".btn-schedule").click(function(){
				$("#lyrSch").fadeIn();
				//$('html,body').animate({scrollTop:position.top},300);
			});
			$(".layer-popup .btn-close, .layer-mask, .layer-popup .btn-ok").click(function(){
				$(".layer-popup").fadeOut();
			});
			winSwiper = new Swiper('.winner .swiper-container', {
				speed:1200,
				freeMode:true,
				slidesPerView:'auto',
				freeModeMomentumRatio:0.1,
				initialSlide: winnerLength < 4 ? 0: winnerLength - 3
			});
			var win = $('.winner .swiper-wrapper');
			var tx = win.offset().left - 30;
			win.css({"transform": "translate3d(" + tx + "px,0,0)"});			
			pushSwiper = new Swiper('.push .swiper-container', {
				speed:1200,
				prevButton:'.push .swiper-button-prev',
				nextButton:'.push .swiper-button-next'
			});
		});		
}
</script>
<%
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" Then		

		sqlStr = ""

		sqlStr = sqlStr & "SELECT DISTINCT T1.날짜	 	"
		sqlStr = sqlStr & "	 , T2.수 AS 참여수	"
		sqlStr = sqlStr & "	 , T1.수 AS 가입자수	"
		sqlStr = sqlStr & "  FROM (	"
		sqlStr = sqlStr & "   select a.날짜	"
		sqlStr = sqlStr & "	    , count(a.수) as 수	"
		sqlStr = sqlStr & "	 from (	"
		sqlStr = sqlStr & "	   select CONVERT(CHAR(10), b.REGDATE, 23) AS 날짜 	"
		sqlStr = sqlStr & "			, count(b.userid) as 수	"
		sqlStr = sqlStr & "  		 FROM DB_EVENT.DBO.tbl_event_subscript a	"
		sqlStr = sqlStr & "		inner join db_user.dbo.tbl_user_n b with(nolock) on a.userid = b.userid	"
		sqlStr = sqlStr & "		WHERE EVT_CODE = '"& CStr(eCode) &"'	"
		sqlStr = sqlStr & "			AND SUB_OPT3 = 'TRY' 	"
		sqlStr = sqlStr & "			and b.regdate > '2019-07-17'	"
		sqlStr = sqlStr & "		group by b.USERID, CONVERT(CHAR(10), b.REGDATE, 23)	"
		sqlStr = sqlStr & "	) as a	"
		sqlStr = sqlStr & "	group by 날짜 		"
		sqlStr = sqlStr & "  )AS T1	"
		sqlStr = sqlStr & "  ,(	"
		sqlStr = sqlStr & "	SELECT A.날짜  	"
		sqlStr = sqlStr & "		, COUNT(A.수) AS 수 	"
		sqlStr = sqlStr & "	FROM ( 	"
		sqlStr = sqlStr & "	SELECT CONVERT(CHAR(10), REGDATE, 23) AS 날짜 	"
		sqlStr = sqlStr & "		 	, COUNT(USERID) 수 	"
		sqlStr = sqlStr & "		FROM DB_EVENT.DBO.tbl_event_subscript  	"
		sqlStr = sqlStr & "	WHERE EVT_CODE = '"& CStr(eCode) &"'	"
		sqlStr = sqlStr & "		AND SUB_OPT3 = 'TRY' 	"
		sqlStr = sqlStr & "	GROUP BY USERID, CONVERT(CHAR(10), REGDATE, 23) 	"
		sqlStr = sqlStr & "	)AS A 	"
		sqlStr = sqlStr & "	WHERE 날짜 <> '2019-07-16' 	"
		sqlStr = sqlStr & "	GROUP BY 날짜 	 	"
		sqlStr = sqlStr & "  )AS T2	"
		sqlStr = sqlStr & "  WHERE T1.날짜 = T2.날짜	"
		sqlStr = sqlStr & "  ORDER BY T1.날짜 ASC	"
   

		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    numOfParticipantsPerDay = rsget.getRows()	
		end if
		rsget.close	

		if isArray(numOfParticipantsPerDay) then 		
		%>
		<div style="color:red">*마케팅만 노출</div>						
		<%
			for i=0 to uBound(numOfParticipantsPerDay,2) 
			response.write "<div>"& numOfParticipantsPerDay(0,i) &" : " & numOfParticipantsPerDay(1,i) & "-" & numOfParticipantsPerDay(2,i) & "</div>"																		
			next 
		end if 	
end if
%>
			<!-- MKT 비밀번호 잠금해제 (A) 96063 -->
			<div class="mEvt96063">
				<div class="evt-main">
					<div class="topic">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/tit_password.jpg" alt="비밀번호"></h2>
						<span class="ico-lock"></span>
					</div>
					<!-- 상품 목록 -->
					<div class="item-wrap">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_product.jpg" alt=""></p>						
						<ul class="item-list">
							<li class="item01 <%=chkIIF(prd1 < 1, "soldout", "")%>">							
								<div class="thumbnail">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_1.jpg" alt="">
									<button type="button" class="btn-click" itemOrder=1><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/txt_click.png" alt="클릭"></button>
									<span class="txt-soldout">품절</span>
								</div>
								<% if prd1 >= 1 then %>
								<span class="count"><b><%=prd1%></b>명</span>
								<% end if %>
							</li>
							<li class="item02 <%=chkIIF(prd2 < 1, "soldout", "")%>">
								<div class="thumbnail">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_2.jpg" alt="">
									<button type="button" class="btn-click" itemOrder=2><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/txt_click.png" alt="클릭"></button>
									<span class="txt-soldout">품절</span>
								</div>
								<% if prd2 >= 1 then %>
								<span class="count"><b><%=prd2%></b>명</span>
								<% end if %>
							</li>
							<li class="item03 <%=chkIIF(prd3 < 1, "soldout", "")%>">
								<div class="thumbnail">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_3.jpg" alt="">
									<button type="button" class="btn-click" itemOrder=3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/txt_click.png" alt="클릭"></button>
									<span class="txt-soldout">품절</span>
								</div>
								<% if prd3 >= 1 then %>
								<span class="count"><b><%=prd3%></b>명</span>
								<% end if %>
							</li>
							<li class="item04 <%=chkIIF(prd4 < 1, "soldout", "")%>">
								<div class="thumbnail">
									<img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_4.jpg" alt="">
									<button type="button" class="btn-click" itemOrder=4><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/txt_click.png" alt="클릭"></button>
									<span class="txt-soldout">품절</span>
								</div>
								<% if prd4 >= 1 then %>
								<span class="count"><b><%=prd4%></b>명</span>
								<% end if %>
							</li>
						</ul>
					</div>
					<!-- SNS 공유 -->
					<div class="sns-share">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bnr_sns.jpg" alt="친구에게 공유하고 한 번 더 도전하세요"></p>
						<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>													
						<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
					</div>
					<!-- 당첨자 -->
					<div class="winner">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_winner.jpg?v=1.0" alt="비밀번호를 맞힌 능력자들"></h3>
						<div class="slider">
							<div class="swiper-container">
								<div class="swiper-wrapper" id="winners">
								</div>								
							</div>
						</div>
					</div>
					<!-- 푸시 -->
					<div class="push">
						<button type="button" onclick="regAlram(true);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/btn_push.jpg" alt="내일 푸시 알림 받기"></button>
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/tit_push.jpg" alt="푸시 수신 설정 방법"></h3>
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_push_1.jpg" alt="STEP 01"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_push_2.jpg" alt="STEP 02"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_push_3.jpg" alt="STEP 03"></div>
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
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/tit_noti.jpg" alt="이벤트 유의사항"></h3>
						<ul>
							<li>이벤트 상품은 맥북에어 13형 128GB 골드 1대, 아이폰XR 64GB 블랙 1대, 아이패드 mini 64GB 골드 2대, 마샬 액톤 2 스피커 블랙 3대입니다.</li>
							<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
							<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
							<li>모든 상품의 당첨자가 결정되면 이벤트는 마감됩니다.</li>
							<li>5만 원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 예정입니다.</li>
							<li>제세공과금은 텐바이텐 부담입니다.</li>
							<li>당첨자에게는 상품 수령 후, 인증 사진을 요청할 수 있습니다.</li>
						</ul>
					</div>
				</div>				
				<%'<!-- 팝업 1. 암호입력 -->%>
				<div id="passwordLayer" class="ly-popup ly-password">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_layer.jpg" alt=""></p>
					<div class="ly-inner">				
						<div class="thumbnail"><img id="selectedImg" src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/img_item_03.png" alt=""></div>
						<p class="txt-input">비밀번호를 풀어주세요</p>						
						<div class="input-area">
							<em>1</em>
							<em>2</em>
							<em>3</em>
							<em>4</em>
						</div>
						<div class="keypad">
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_keypad.png" alt=""></p>
							<div class="keys">
								<button type="button" class="pwd-btn">1</button>
								<button type="button" class="pwd-btn">2</button>
								<button type="button" class="pwd-btn">3</button>
								<button type="button" class="pwd-btn">4</button>
								<button type="button" class="pwd-btn">5</button>
								<button type="button" class="pwd-btn">6</button>
								<button type="button" class="pwd-btn">7</button>
								<button type="button" class="pwd-btn">8</button>
								<button type="button" class="pwd-btn">9</button>
							</div>
						</div>
						<button type="button" class="btn-close">뒤로 가기</button>
						<!-- for dev msg : 한자리씩 삭제 -->
						<button type="button" onclick="delPassword()" class="btn-del">삭제</button>
					</div>
				</div>
				<%'<!-- 팝업 2. 암호성공 -->%>
				<div id="success" class="ly-popup ly-winner">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_layer.jpg" alt=""></p>
					<div class="ly-inner">						
						<p><img id="successImg" src="" alt="축하드립니다"></p>
						<button type="button" class="btn-bot btn-main"><span>메인으로 가기</span></button>
					</div>
				</div>
				<%'<!-- 팝업 3. 암호실패1 -->%>
				<div id="firstTryPopup" class="ly-popup ly-fail1">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_layer.jpg" alt=""></p>
					<div class="ly-inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/try_fail_1.png" alt="아쉽게도"></p>
						<div class="share">
							<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
							<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
						</div>
						<button type="button" class="btn-bot btn-main"><span>메인으로 가기</span></button>
					</div>
				</div>
				<%'<!-- 팝업 4. 공유 안하고 재도전시 -->%>
				<div id="tryWithoutShare" class="ly-popup ly-already">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_layer.jpg" alt=""></p>
					<div class="ly-inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/try_already.png" alt="이미 한번 도전"></p>
						<div class="share">
							<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
							<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
						</div>
						<button type="button" class="btn-bot btn-main"><span>메인으로 가기</span></button>
					</div>
				</div>
				<%'<!-- 팝업 5. 암호실패2 -->%>
				<div id="secondTryPopup" class="ly-popup ly-fail2">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/bg_layer.jpg" alt=""></p>
					<div class="ly-inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96063/m/try_fail_2.png" alt="암호 2회 오류로 비활성화"></p>
						<button type="button" onclick="alert('3,000원 할인 쿠폰이 발급되었습니다. 쿠폰함을 확인해주세요.')" class="btn-bot btn-coupon"><span>쿠폰 받기</span></button>
						<button type="button" class="btn-bot btn-main"><span>메인으로 가기</span></button>
					</div>
				</div>
			</div>
			<!--// MKT 비밀번호 잠금해제 (A) 96063 -->
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
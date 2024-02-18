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
' Description : 2019 세라벨 - 100원의 기적
' History : 2019-03-25 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10

if isApp < 1 then
	response.redirect "http://m.10x10.co.kr/event/eventmain.asp?eventid=93354" 
end if

IF application("Svr_Info") = "Dev" THEN
	eCode = "90247"	
Else
	eCode = "93355"
End If

eventStartDate  = cdate("2019-03-27")		'이벤트 시작일 
eventEndDate 	= cdate("2019-04-22")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-04-22")'테스트
LoginUserid		= getencLoginUserid()

dim SqlStr

sqlStr = " select      (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2290327)) as '맥북에어' "
sqlStr = sqlStr & "	 , (SELECT 2 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292048,2292964)) as '아이패드' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292057)) as '아이폰' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292077)) as '애플워치' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292085)) as '다이슨 청소기' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292103)) as '마샬 스피커' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292160)) as '발뮤다 공기청정기' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292200)) as '다이슨 드라이기' "
sqlStr = sqlStr & "	 , (SELECT 5 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2292207,2292988,2293045,2293047,2293053)) as '브리츠 스피커' "
sqlStr = sqlStr & "	 , (SELECT 3 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2293059,2293060,2292208)) as '코닥 카메라' 		"

rsget.Open sqlstr, dbget, 1
	prd1 = rsget("맥북에어")
	prd2 = rsget("아이패드")
	prd3 = rsget("아이폰")
	prd4 = rsget("애플워치")
	prd5 = rsget("다이슨 청소기")
	prd6 = rsget("마샬 스피커")
	prd7 = rsget("발뮤다 공기청정기")
	prd8 = rsget("다이슨 드라이기")
	prd9 = rsget("브리츠 스피커")
	prd10 = rsget("코닥 카메라")
rsget.close				
		
'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[100원의 기적]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=93354")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/bnr.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=93354"


''head.asp에서 출력
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[100원의 기적]"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=93354"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/bnr.jpg"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:description"" content=""여러분의 삶의 질을 업그레이드 시켜줄 인생템! 100원에 살 수 있는 기회에 도전하세요!"">" & vbCrLf

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[100원의 기적]"
Dim kakaodescription : kakaodescription = "여러분의 삶의 질을 업그레이드 시켜줄 인생템! 100원에 살 수 있는 기회에 도전하세요!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 여러분의 삶의 질을 업그레이드 시켜줄 인생템! 100원에 살 수 있는 기회에 도전하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/bnr.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=93355"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=93354"
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = LoginUserid	
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.hundred {position:relative; background:#4123d1;}
.hundred button {background:transparent; -webkit-tap-highlight-color:rgba(0, 0, 0, 0);}
.hundred .key-item {position:relative;}
.hundred .btn-schedule {position:absolute; top:4.43%; right:10.13%; width:28%; -webkit-animation:bounce 1.5s 20; animation:bounce 1.5s 20; -webkit-border-radius:50%; border-radius:50%; -webkit-box-shadow:1.45rem 1.45rem 1.71rem rgba(0,0,0,.15); box-shadow:1.45rem 1.45rem 1.71rem rgba(0,0,0,.15);}
@-webkit-keyframes bounce { from, to {transform:translateY(0); animation-timing-function:ease-out;} 50% {transform:translateY(0.7rem); animation-timing-function:ease-in;} }
@keyframes bounce { from, to {transform:translateY(0); animation-timing-function:ease-out;} 50% {transform:translateY(0.7rem); animation-timing-function:ease-in;} }
.hundred .noti {background:#0a2b44;}
.hundred .noti h3 {text-align:center;}
.hundred .noti ul {padding:1.7rem 6.67% 3.4rem;}
.hundred .noti li {position:relative; padding-left:1rem; font-size:1.11rem; line-height:1.73; color:rgba(218,219,231,.7); word-break:keep-all;}
.hundred .noti li + li {margin-top:0.64rem;}
.hundred .noti ul li:before {position:absolute; top:0; left:0; content:'·'; display:inline-block;}
.hundred .layer-popup {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%;}
.hundred .layer-popup .layer {position:absolute; top:3.84rem; left:7%; width:86%; background:#fff; -webkit-border-radius:0.85rem; border-radius:0.85rem; z-index:10;}
.hundred .layer .btn-close {position:absolute; right:0; top:0; width:17.5%; padding:6.15%;}
.hundred .layer-mask {position:absolute; top:0; left:0; z-index:1; width:100%; height:100%; background:rgba(0,0,0,.45);}
#lyrSch .scroll {overflow:hidden; overflow-y:scroll; height:31rem;}
#lyrSch .item-list ul {overflow:hidden; padding:1.71rem 4.6% 0;}
#lyrSch .item-list li {float:left; width:33.3%; height:13rem; padding:0 1.7%;}
#lyrSch .item-list li > a {display:block;}
#lyrSch .item-list .thumbnail {overflow:hidden; -webkit-border-radius:50%; border-radius:50%;}
#lyrSch .item-list li.soldout .thumbnail::after {content:'SOLD OUT'; position:absolute; top:0; left:0; z-index:3; width:100%; height:100%; background-color:rgba(17,17,17,.5); background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_soldout.png); background-position:50%; background-repeat:no-repeat; background-size:100%; font-size:0; color:transparent;}
#lyrSch .item-list .name {margin-top:0.94rem; font-size:1.02rem; line-height:1.15; color:#000; text-align:center;word-break:keep-all;}
#lyrSch .item-list li.soldout .name {opacity:.5;}
#lyrSch .item-list li .name span {font-size:0.94rem;}
#lyrSch .item-list li .name b {display:inline-block; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; color:#ff3131;}
@media all and (min-width:768px) {
	#lyrSch .scroll {height:50rem;}
	#lyrSch .item-list ul {padding-top:3rem;}
	#lyrSch .item-list li {height:18rem;}
}
@media screen and (orientation:landscape) {
	#lyrSch .scroll {height:50rem;}
	#lyrSch .item-list ul {padding-top:3rem;}
	#lyrSch .item-list li {height:20rem;}
	#lyrSch .item-list li .name {font-size:1.19rem;}
	#lyrSch .item-list li .name span {font-size:1.11rem;}
}
.hundred .share {position:relative;}
.hundred .sns-btns {position:absolute; left:0; bottom:0; width:100%;}
.hundred .sns-btns button {width:50%; float:left; padding-top:32%; font-size:0; color:transparent;}
.hundred .winner {background:#fff; padding-bottom:4.18rem;}
.hundred .winner h3 {margin-bottom:2.99rem;}
.hundred .winner .swiper-slide:first-child {margin-left:2.99rem;}
.hundred .winner .swiper-slide:last-child {margin-right:2.13rem;}
.hundred .winner .item {width:10.24rem; margin-right:1.28rem;}
.hundred .winner .blank {width:11.09rem; margin-right:0.85rem;}
.hundred .winner .thumbnail {overflow:hidden; -webkit-border-radius:50%; border-radius:50%;}
.hundred .winner .desc {text-align:center;}
.hundred .winner .desc .date {display:inline-block; margin-top:0.85rem; padding:0.43rem 0.77rem 0.34rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.02rem; color:#fff; background:#a34eff; -webkit-border-radius:1rem; border-radius:1rem;}
.hundred .winner .desc .name {display:block; overflow:hidden; margin-top:1.28rem; white-space:nowrap; text-overflow:ellipsis; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.28rem; color:#000;}
.hundred .winner .desc .user {display:block; margin-top:1rem; font-size:1.07rem; color:#2b3fae;}
.hundred .push {background:#66d2fa;}
.hundred .push .swiper-button {top:36%;}
.hundred .push .swiper-button svg {vertical-align:top;}
.hundred .push .swiper-button-prev {left:8%;}
.hundred .push .swiper-button-next {right:8%;}
#lyrWin .layer {padding-bottom:1.5rem;}
#lyrWin .code {font-size:1.02rem; color:rgba(17,17,17,.35); text-align:center; line-height:2;}
.hundred .delivery {position:relative;}
.hundred .delivery::after {content:' '; position:absolute; top:12.71%; left:50%; width:34.77%; padding-bottom:17.7%; transform:translateX(-50%); background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/ico_delivery.gif); background-position:50%; background-repeat:no-repeat; background-size:100%;}
</style>
<script style="text/javascript">
var numOfTry = 0;
<% if drawEvt.isParticipationDayBase(1) then %>
numOfTry = 1
<% end if %>
$(function(){
	<% if currentDate < Cdate("2019-04-22") then %>
	$(".layer-popup .btn-close, .layer-mask, .layer-popup .btn-ok").click(function(){				
		$(".layer-popup").fadeOut();

		// for dev msg : 푸시로 스크롤 이동 (일정팝업, 당첨팝업 제외)
		if($(".exeption").css("display") != "block"){
			var push = $(".push").offset();
			$('html,body').animate({scrollTop:push.top});
		}
	});	
	<% end if %>
})
$(document).ready(function(){
	getWinner()	
})
function printUserName(name, num, replaceStr){	
	return name.substr(0,name.length - num) + replaceStr.repeat(num)
}
function checkmyprize(){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If currentDate > eventStartDate And currentDate <= eventEndDate Then %>		
		var returnCode, md5value, itemid
			$.ajax({
				type:"GET",
				url:"/event/salelife/miracle_proc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){										
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {							
							if(Data!="") {
								var str= Data;								
								res = str.split("|");								
								// console.log(Data);
								if (res[0]=="ok"){
									returnCode = res[1]
									md5value = res[2]
									itemid = res[3]			
									popResult(returnCode, md5value, itemid);						
									getWinner();									
									return false;
								} else {
									alert(Data)
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

function popResult(returnCode, md5value, itemid){	
	if(returnCode[0] == "B"){ 
		numOfTry++				
		if(numOfTry == 1){			
			$("#firstTryPopup").css("display", "block")
		}else{			
			$("#secondTryPopup").css("display", "block")
		}
		if(numOfTry == 2) numOfTry = 0
	}else if(returnCode[0] == "A"){ 
		if(returnCode == "A02"){			
			$("#tryDone").css("display", "block")
		}else{
			alert("<100원의 기적> 공유하고\n한번 더 응모에 도전하세요!")		
		}
	}else if(returnCode[0] == "C"){
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_prize_"+getItemInfo(parseInt(itemid)).imgCode+".jpg?v=1.1")
		$("#md5code").html(md5value)	
		$("#itemid").val(itemid);	
		$("#winnerPopup").css("display", "block")
		numOfTry++
		if(numOfTry == 2) numOfTry = 0
	}	
}
function getItemInfo(itemid){
	var itemInfo = {}
	var imgCode;
	var itemName;			
	switch (itemid) {
		case 2290327 : 
			imgCode = "01"
			itemName = "맥북에어 13형 (Space Grey)"
			break;				
		case 2292048 : 
		case 2292964 : 
			imgCode = "02"
			itemName = "아이패드 Pro 64GB 11형 (Silver)"
			break;					
		case 2292057 : 
			imgCode = "03"
			itemName = "아이폰XR 128GB (블랙)"
			break;							
		case 2292077 : 
			imgCode = "04"
			itemName = "애플워치 40mm (Space Grey / 스포츠 밴드)"
			break;							
		case 2292085 : 
			imgCode = "05"
			itemName = "다이슨 V7 플러피 청소기"
			break;							
		case 2292103 : 
			imgCode = "06"
			itemName = "마샬 스피커 (Acton 2)"
			break;							
		case 2292160 : 
			imgCode = "07"
			itemName = "발뮤다 공기청정기 화이트그레이"
			break;							
		case 2292200 : 
			imgCode = "08"
			itemName = "다이슨 헤어드라이기 (슈퍼소닉)"
			break;						
		case 2292207 : 					
		case 2292988 : 
		case 2293045 : 	
		case 2293047 : 
		case 2293053 :
			imgCode = "09"
			itemName = "브리츠 블루투스 스피커 (다크체리)"
			break;							 
		case 2293059 : 
		case 2293060 : 
		case 2292208 : 									
			imgCode = "10"
			itemName = "코닥 프린토매틱 (옐로우)"
			break;
		default: 						
	}	
	return {
		imgCode: imgCode,
		itemName: itemName
	}
}

function sharesns(snsnum) {		
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/salelife/miracle_proc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "text",
			async: false
		}).responseText;
			reStr = str.split("|");

			if(reStr[1] == "tw") {
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}else if(reStr[1]=="fb"){
				<% if isapp then %>
				fnAPPShareSNS('fb','<%=appfblink%>');
				<% else %>
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
				<% end if %>
			}else if(reStr[1]=="pt"){
				popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
			}else if(reStr[1]=="ka"){
				<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=93354','http://m.10x10.co.kr/event/eventmain.asp?eventid=93354','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
				<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
				<% end if %>
				return false;
			}else if(reStr[1]=="비로그인"){
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
}
function getWinner() {	
		var reStr;
		var str = $.ajax({
			type: "GET",
			url:"/event/salelife/miracle_proc.asp",
			data: "mode=winner",
			dataType: "text",
			async: false
		}).responseText;
				
		var resultData = JSON.parse(str).data;		
		var winnerLength = resultData.length;
		var $rootEl = $("#winners")
		$rootEl.empty();
		
		var emptyEl = '<div class="swiper-slide"><div class="blank"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_blank.png" alt=""></div></div>'				
		$.each(resultData,function(key,value) {			
			var itemEle = "";	
			var itemid = value.sub_opt2			
			var tmpItemInfo = getItemInfo(itemid)			
			itemEle = '<div class="swiper-slide">'

			itemEle = itemEle + '		<div class="item">'
			itemEle = itemEle + '			<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_'+tmpItemInfo.imgCode+'.png?v=1.0" alt=""></div>'
			itemEle = itemEle + '			<div class="desc">'
			itemEle = itemEle + '				<em class="date">' + value.regdate.substring(5,7) + '.' + value.regdate.substring(8,10) + '</em>'
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
		for(var i = 0 ; i < 17 - winnerLength; i++){
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

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If currentDate > eventStartDate And currentDate <= eventEndDate Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>
</head>
<body>
<div class="mEvt93355 hundred">
	<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_app.jpg?v=1.0" alt="100원의 기적"></h2>
	<div class="key-item">
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_app.jpg?v=1.0" alt=""></p>
		<button class="btn-schedule"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_schedule.png" alt="전체상품 보기"></button>
	</div>
	<button onclick="checkmyprize()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_app.jpg?v=1.0" alt="도전하기"></button>
	<div class="share">
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_sns.jpg" alt="100원의 기적 공유하고 한 번 더 응모하세요"></p>
		<div class="sns-btns">
			<button onclick="sharesns('ka')">카카오톡으로 공유</button>
			<button onclick="sharesns('fb')">페이스북으로 공유</button>		
		</div>
	</div>
	<div class="winner">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_winner.png" alt="당첨자를 소개합니다"></h3>
		<div class="swiper-container">
			<div class="swiper-wrapper" id="winners">												
			</div>
		</div>
	</div>
	<% if currentDate < Cdate("2019-04-22") then %>
	<div class="push">
		<button onclick="regAlram(true);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_push.jpg?v=1.0" alt="푸시 알림 받기"></button>
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_push.jpg" alt="푸시 수신 설정 방법"></h3>
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_push_01.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_push_02.jpg" alt=""></div>
				<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_push_03.jpg" alt=""></div>
			</div>
			<button class="swiper-button swiper-button-prev">
				<svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
			</button>
			<button class="swiper-button swiper-button-next">
				<svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
			</button>
		</div>
	</div>
	<% end if %>
	<div class="noti">
		<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_noti.png" alt="유의사항"></h3>
		<ul>
			<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
			<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
			<li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
			<li>본 이벤트의 상품은 당첨 후 즉시 결제로만 구매할 수 있으며 배송 후 반품/교환/구매취소가 불가합니다.</li>
			<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
			<li>제세공과금은 텐바이텐 부담입니다.</li>
		</ul>
	</div>
	
	<div id="lyrSch" class="layer-popup exeption" style="display:none" >
		<div class="layer">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_schedule.png?v=1.0" alt="인생템 리스트"></h3>
			<div class="scroll">
				<div class="item-list">
					<ul>
						<li <%=chkIIF(prd1 < 1, "class=""soldout""", "")%>>
							<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_01.png" alt=""></div>
							<div class="name">맥북에어 13형 <span>(Space Grey)</span> <b><%=chkIIF(prd1 < 1, "", prd1 & "대")%></b></div>
						</li>
						<li <%=chkIIF(prd2 < 1, "class=""soldout""", "")%>>
							<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_02.png" alt=""></div>
							<div class="name">아이패드 Pro 64GB 11형 <span>(Silver)</span> <b><%=chkIIF(prd2 < 1, "", prd2 & "대")%></b></div>
						</li>
						<li <%=chkIIF(prd3 < 1, "class=""soldout""", "")%>>
							<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_03.png" alt=""></div>
							<div class="name">아이폰XR 128GB <span>(블랙)</span> <b><%=chkIIF(prd3 < 1, "", prd3 & "대")%></b></div>
						</li>
						<li <%=chkIIF(prd4 < 1, "class=""soldout""", "")%>>
							<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_04.png" alt=""></div>
							<div class="name">애플워치 40mm <span>(Space Grey / 스포츠 밴드)</span> <b><%=chkIIF(prd4 < 1, "", prd4 & "대")%></b></div>
						</li>
						<li <%=chkIIF(prd5 < 1, "class=""soldout""", "")%>>
							<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1932155&pEtr=93355" onclick="fnAPPpopupProduct('1932155&pEtr=93355');">
								<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_05.png" alt=""></div>
								<div class="name">다이슨 V7 플러피 <b><%=chkIIF(prd5 < 1, "", prd5 & "대")%></b></div>
							</a>
						</li>
						<li <%=chkIIF(prd6 < 1, "class=""soldout""", "")%>>
							<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_06.png" alt=""></div>
							<div class="name">마샬 스피커 <span>(Acton 2)</span> <b><%=chkIIF(prd6 < 1, "", prd6 & "대")%></b></div>
						</li>
						<li <%=chkIIF(prd7 < 1, "class=""soldout""", "")%>>
							<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1191473&pEtr=93355" onclick="fnAPPpopupProduct('1191473&pEtr=93355');">
								<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_07.png" alt=""></div>
								<div class="name">발뮤다 공기청정기 화이트그레이<b><%=chkIIF(prd7 < 1, "", prd7 & "대")%></b></div>
							</a>
						</li>
						<li <%=chkIIF(prd8 < 1, "class=""soldout""", "")%>>
							<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1555093&pEtr=93355" onclick="fnAPPpopupProduct('1555093&pEtr=93355');">
								<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_08.png?v=1.1" alt=""></div>
								<div class="name">다이슨 헤어드라이기 <span>(슈퍼소닉)</span> <b><%=chkIIF(prd8 < 1, "", prd8 & "대")%></b></div>
							</a>
						</li>
						<li <%=chkIIF(prd9 < 1, "class=""soldout""", "")%>>
							<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2074964&pEtr=93355" onclick="fnAPPpopupProduct('2074964&pEtr=93355');">
								<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_09.png" alt=""></div>
								<div class="name">브리츠 블루투스 스피커 <span>(다크체리)</span> <b><%=chkIIF(prd9 < 1, "", prd9 & "대")%></b></div>
							</a>
						</li>
						<li <%=chkIIF(prd10 < 1, "class=""soldout""", "")%>>
							<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2039765&pEtr=93355" onclick="fnAPPpopupProduct('2039765&pEtr=93355');">
								<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/img_item_10.png" alt=""></div>
								<div class="name">코닥 프린토매틱 <span>(옐로우)</span> <b><%=chkIIF(prd10 < 1, "", prd10 & "대")%></b></div>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_close.png" alt="닫기"></button>
		</div>
		<div class="layer-mask"></div>
	</div>
	<div class="layer-popup exeption" style="display:none" id="winnerPopup">
		<div class="layer" style="padding-bottom:1.5rem;">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_win.png" alt="축하드립니다 인생템 당첨"></h3>			
			<p><img id="winImg" src="" alt=""></p>
			<button class="" onclick="goDirOrdItem()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_buy.png" alt="100원에 구매하러 가기"></button>
			<p class="code" id="md5code" style="font-size:1.02rem; color:rgba(17,17,17,.35); text-align:center; line-height:2;"></p>
		</div>
		<div class="layer-mask"></div>
	</div>

	<div class="layer-popup" style="display:none" id="firstTryPopup">
		<div class="layer">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_fail_1.png" alt="아쉽게도 당첨되지 않았습니다"></h3>
			<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_fail_1.png" alt="친구에게 공유하고 한번 더 응모해보세요"></p>
			<div class="sns-btns">
				<button onclick="sharesns('ka')">카카오톡으로 공유</button>
				<button onclick="sharesns('fb')">페이스북으로 공유</button>		
			</div>
			<button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_close.png" alt="닫기"></button>
		</div>
		<div class="layer-mask"></div>
	</div>

<%
	dim tryImg1	
	dim tryImg2
	
	if currentDate < Cdate("2019-04-22") then
		tryImg1 = "//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_fail_2-1.png"	
		tryImg2 = "//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_fail_3-1.png"
	else	
		tryImg1	= "//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/tit_fail_2-2.png"
		tryImg2	= "//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_fail_3-2.png"
	end if
%>	
	<div class="layer-popup" style="display:none" id="secondTryPopup">
		<div class="layer">
			<h3><img src="<%=tryImg1%>" alt="응모해주셔서 감사합니다"></h3>
			<div class="delivery"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/txt_fail_2.png" alt="무료배송 쿠폰"></div>
			<button onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_coupon.png?v=1.0" alt="쿠폰 받기"></button>
			<button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_close.png" alt="닫기"></button>
		</div>
		<div class="layer-mask"></div>
	</div>		
	<div class="layer-popup" style="display:none" id="tryDone">
		<div class="layer">
			<button class="btn-ok"><img src="<%=tryImg2%>" alt="응모해주셔서 감사합니다"></button>
			<button class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/salabal/hundred/m/btn_close.png" alt="닫기"></button>
		</div>
		<div class="layer-mask"></div>
	</div>	
</div>
<% If IsUserLoginOK() Then %>
	<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
		<input type="hidden" name="itemid" id="itemid" value="">
		<input type="hidden" name="itemoption" value="0000">
		<input type="hidden" name="itemea" readonly value="1">
		<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
		<input type="hidden" name="isPresentItem" value="" />
		<input type="hidden" name="mode" value="DO3">
	</form>
<% end if %>	
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.4"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
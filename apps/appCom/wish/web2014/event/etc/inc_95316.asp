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
' Description : 2019 100원 자판기
' History : 2019-06-14 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim drawEvt, isParticipation
dim numOfParticipantsPerDay, i
dim prd1, prd2, prd3, prd4, prd5, prd6, prd7, prd8, prd9, prd10

IF application("Svr_Info") = "Dev" THEN
	eCode = "90318"	
Else
	eCode = "95316"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30) 

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid=95314&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-06-17")		'이벤트 시작일 
eventEndDate 	= cdate("2019-06-28")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-06-28")'테스트
LoginUserid		= getencLoginUserid()

dim SqlStr

sqlStr = sqlStr & " select      (SELECT 1 - count(1) as pdt1 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2394974)) as '맥북에어' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2394975)) as '아이패드' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt3 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2395008)) as '에어팟' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt4 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2395002)) as '아이폰' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt5 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2395009)) as '프라엘마스크' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt6 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2395062)) as '네스프레소' "
sqlStr = sqlStr & "	 , (SELECT 1 - count(1) as pdt7 FROM [db_event].[dbo].[tbl_event_subscript] WHERE EVT_CODE = "& eCode &" and sub_opt1 = '1' and sub_opt3 = 'draw' and sub_opt2 in (2394978)) as '마샬스피커' "

rsget.Open sqlstr, dbget, 1
	prd1 = rsget("맥북에어")
	prd2 = rsget("아이패드")
	prd3 = rsget("에어팟")
	prd4 = rsget("아이폰")
	prd5 = rsget("프라엘마스크")
	prd6 = rsget("네스프레소")
	prd7 = rsget("마샬스피커")
rsget.close				
		
'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg , appfblink
snpTitle	= Server.URLEncode("[100원 자판기]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=95314")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/95316/share.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid=95314"


''head.asp에서 출력
'strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[100원 자판기]"">" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=95314"" />" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/fixevent/event/2019/95316/share.jpg"">" & vbCrLf
'strOGMeta = strOGMeta & "<meta property=""og:description"" content=""다시 돌아온 100원의 기적에 도전하고, 시원한 여름을 준비해 보세요!"">" & vbCrLf

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[100원 자판기]"
Dim kakaodescription : kakaodescription = "다시 돌아온 100원의 기적에 도전하고, 시원한 여름을 준비해 보세요!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 다시 돌아온 100원의 기적에 도전하고, 시원한 여름을 준비해 보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/95316/share.jpg"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=95316"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=95314"
End If

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = LoginUserid	
%>
<style type="text/css">
.mEvt95316 {position:relative; background-color:#ffc2ca;}
.mEvt95316 .machine {position:relative;}
.machine .item-list {position:absolute; top:5%; left:12%; width:76%;}
.machine li {position:relative; float:left; width:50%;}
.machine li a, .machine li span {display:block; height:0; font-size:0;}
.machine .item01 a, .machine .item02 a {padding-top:98.95%;}
.machine .item03, .machine .item04, .machine .item05 {width:33.3%;}
.machine .item03 a, .machine .item04 a, .machine .item05 a {padding-top:155%;}
.machine .item06 a, .machine .item07 span {padding-top:91.58%;}
.machine .btn-challenge {position:absolute; right:0; bottom:12%; width:75%; height:17%; font-size:0; background:none;}
.machine li:before {content:' '; position:absolute; left:50%; bottom:4.5%; width:2rem; height:0.52rem; margin-left:-1rem; border-radius:0.26rem; background-color:#fff; box-shadow:0 0 0.3rem rgb(245, 247, 175);}
.machine li.on:before {background-color:#5dff7b;}
.machine li.soldout:after {content:'Sold out '; position:absolute; top:50%; left:50%; width:7.21rem; height:7.21rem; transform:translate(-50%,-50%); background:url(//webimage.10x10.co.kr/fixevent/event/2019/95316/m/txt_soldout.png) 50% / 100% no-repeat; font-size:0; color:transparent;}

.mEvt95316 .share {position:relative;}
.mEvt95316 .share button {position:absolute; top:20%; width:20%; height:60%; background:none; font-size:0; color:transparent;}
.mEvt95316 .btn-ka {right:4%;}
.mEvt95316 .btn-fb {right:25%;}

.winner {background:#fff; padding-bottom:4.18rem;}
.winner h3 {margin-bottom:2.9rem;}
.winner .swiper-slide:first-child {margin-left:2.99rem;}
.winner .swiper-slide:last-child {margin-right:2.13rem;}
.winner .item {width:10.24rem; margin-right:1.28rem;}
.winner .blank {width:11.09rem; margin-right:0.85rem;}
.winner .item .thumbnail {overflow:hidden; width:10.24rem; height:10.24rem; -webkit-border-radius:50%; border-radius:50%;}
.winner .desc {text-align:center;}
.winner .desc .date {display:inline-block; margin-top:0.85rem; padding:0.43rem 0.77rem 0.34rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.02rem; color:#fff; background:#00aaf4; -webkit-border-radius:1rem; border-radius:1rem;}
.winner .desc .name {display:block; overflow:hidden; margin-top:1.28rem; white-space:nowrap; text-overflow:ellipsis; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.28rem; color:#000;}
.winner .desc .user {display:block; margin-top:1rem; font-size:1.07rem; color:#2b3fae;}

.mEvt95316 .push {background:#73d9ff;}
.mEvt95316 .push .swiper-button {top:36%; background:none;}
.mEvt95316 .push .swiper-button svg {vertical-align:top;}
.mEvt95316 .push .swiper-button-prev {left:8%;}
.mEvt95316 .push .swiper-button-next {right:8%;}

.mEvt95316 .noti {background:#f34e68;}
.mEvt95316 .noti h3 {text-align:center;}
.mEvt95316 .noti ul {padding:2rem 6.7% 3.6rem;}
.mEvt95316 .noti li {position:relative; padding-left:1rem; font-size:1.11rem; line-height:1.38; color:#fff; word-break:keep-all;}
.mEvt95316 .noti li + li {margin-top:1.19rem;}
.mEvt95316 .noti ul li:before {position:absolute; top:0; left:0; content:'-'; display:inline-block;}

.mEvt95316 .layer-popup {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt95316 .layer-popup .layer-inner {overflow:hidden; position:absolute; left:50%; top:50%; width:26.7rem; transform:translate(-50%,-50%); z-index:10;}
.mEvt95316 .layer-mask {position:absolute; top:0; left:0; z-index:1; width:100%; height:100%; background:rgba(0,0,0,.45);}
.mEvt95316 .layer-popup button {background:none;}

#winnerPopup .layer-inner {background:#fff; -webkit-border-radius:1.71rem; border-radius:1.71rem; box-shadow:0 0.21rem 1.96rem rgba(39,39,39,0.3);}
#firstTryPopup .layer-inner {box-shadow:0 0.21rem 1.96rem rgba(39,39,39,0.3);}

#firstTryPopup .btn-ka, #firstTryPopup .btn-fb {position:absolute; bottom:0; width:21%; height:23%; background:none; font-size:0; color:transparent;}
#firstTryPopup .btn-ka {right:5%;}
#firstTryPopup .btn-fb {right:27%;}
#firstTryPopup .btn-close {position:absolute; right:0; top:0; padding:1.5rem 1.8rem;}
#firstTryPopup .btn-close img {width:1.45rem;}
</style>
<script type="text/javascript">
$(function(){
	// 당첨자 롤링
	winSwiper = new Swiper('.winner .swiper-container', {
		speed:1200,
		freeMode:true,
		slidesPerView:'auto',
		freeModeMomentumRatio:0.5,
		//initialSlide:1 // for dev msg : 첫 번째 당첨만 초기상태 / 가장 최근 당첨이 오른쪽
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

	// 팝업 닫기
	$(".layer-popup .btn-close, .layer-mask").click(function(){
		$(".layer-popup").fadeOut();
	});
});
</script>
<script style="text/javascript">
$(function(){
	function pickNow(){
		var numbers = [];
		var pickNumbers = 3;
		for(insertCur = 0; insertCur < pickNumbers ; insertCur++){
			numbers[insertCur] = Math.floor(Math.random() * 6) + 1;
			for(searchCur = 0; searchCur < insertCur; searchCur ++){
				if(numbers[insertCur] == numbers[searchCur]){
					insertCur--;
					break;
				}
			}
		}
		var result = "";
		for(i = 0; i < pickNumbers; i ++){
			if(i > 0){
				result += ",";
			}
			result += numbers[i];
		}
		$('.item-list li').removeClass('on');
		$('.item-list li').eq(result[0]).addClass('on');
		$('.item-list li').eq(result[2]).addClass('on');
		$('.item-list li').eq(result[4]).addClass('on');
	}
	var pushBtn=setInterval(pickNow,1000);
});

var numOfTry = 0;
<% if drawEvt.isParticipationDayBase(1) then %>
numOfTry = 1
<% end if %>
$(function(){
	<% if currentDate < Cdate("2019-04-22") then %>
	<% end if %>
})
$(document).ready(function(){	
	getWinner();	
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
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>		
		var returnCode, md5value, itemid
			$.ajax({
				type:"GET",
				url:"/event/etc/drawevent/drawEventProc.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){										
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var result = JSON.parse(Data)
								if(result.response == "ok"){									
									// console.log(result.result)
									returnCode = result.result
									md5value = result.md5userid
									itemid = result.winItemid	
									popResult(returnCode, md5value, itemid);						
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
			// $("#tryDone").css("display", "block")
			<% if currentDate < Cdate("2019-06-28") then  %>
				alert("오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!");
			<% else %>
				alert("이벤트 응모를 모두 완료하셨습니다.\n응모해주셔서 감사합니다.");
			<% end if %>			
		}else{
			alert("<100원 자판기> 공유하고\n한번 더 응모에 도전하세요!")		
		}
	}else if(returnCode[0] == "C"){
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/95316/m/win_"+getItemInfo(parseInt(itemid)).imgCode+".png")		
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
		case 2394974 : 
			imgCode = "01"
			itemName = "맥북에어 13형 (Space Grey)"
			break;						
		case 2394975 : 
			imgCode = "02"
			itemName = "ipad Pro 11형 64GB 실버"
			break;					
		case 2395008 : 
			imgCode = "03"
			itemName = "에어팟 2 충전 케이스 모델"
			break;								
		case 2395002 : 
			imgCode = "04"
			itemName = "아이폰XR 64GB (블랙)"
			break;								
		case 2395009 : 
			imgCode = "05"
			itemName = "[LG전자] 프라엘 더마LED마스크 BWJ1V 피부관리기"
			break;								
		case 2395062 : 
			imgCode = "06"
			itemName = "[네스프레소] 시티즈 D112 에스프레소 캡슐 커피머신 화이트"
			break;								
		case 2394978 : 
			imgCode = "07"
			itemName = "Marshall Acton 2 스피커 블랙"
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
			url:"/event/etc/drawevent/drawEventProc.asp",
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
				fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','http://www.10x10.co.kr/event/eventmain.asp?eventid=95314','http://m.10x10.co.kr/event/eventmain.asp?eventid=95314','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
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
			url:"/event/etc/drawevent/drawEventProc.asp",
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
			itemEle = itemEle + '			<div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/img_item_'+tmpItemInfo.imgCode+'.png" alt=""></div>'
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
		for(var i = 0 ; i < 10 - winnerLength; i++){
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
	<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
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
		sqlStr = sqlStr & "			AND SUB_OPT3 = 'DRAW' 	"
		sqlStr = sqlStr & "			and b.regdate > '2019-06-18'	"
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
		sqlStr = sqlStr & "		AND SUB_OPT3 = 'DRAW' 	"
		sqlStr = sqlStr & "	GROUP BY USERID, CONVERT(CHAR(10), REGDATE, 23) 	"
		sqlStr = sqlStr & "	)AS A 	"
		sqlStr = sqlStr & "	WHERE 날짜 <> '2019-06-17' 	"
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
			<!-- 100원 자판기 (App) 95316 -->
			<div class="mEvt95316">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/tit_100won.jpg" alt="100원 자판기"></h2>
				<div class="machine">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/img_machine.jpg" alt=""></p>					
					<ul class="item-list">
						<li class="item01 on <%=chkIIF(prd1 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2230980&pEtr=95316'); return false;">맥북</a></li>
						<li class="item02 <%=chkIIF(prd2 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2211392&pEtr=95316'); return false;">아이패드</a></li>
						<li class="item03 <%=chkIIF(prd3 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2389237&pEtr=95316'); return false;">에어팟</a></li>
						<li class="item04 <%=chkIIF(prd4 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2336252&pEtr=95316'); return false;">아이폰</a></li>
						<li class="item05 on <%=chkIIF(prd5 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2024516&pEtr=95316'); return false;">프라엘마스크</a></li>
						<li class="item06 on <%=chkIIF(prd6 < 1, "soldout", "")%>"><a href="" onclick="fnAPPpopupProduct('2368857&pEtr=95316'); return false;">네스프레소</a></li>
						<li class="item07 <%=chkIIF(prd7 < 1, "soldout", "")%>"><span>마샬스피커</span></li>
					</ul>					
					<button type="button" class="btn-challenge" onclick="checkmyprize()">상품 뽑기</button>
				</div>				
				<div class="share">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/txt_share.jpg" alt="친구에게 공유하고 한 번 더 도전하세요"></p>
					<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
					<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>							
				</div>				
				<div class="winner">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/tit_winner.png" alt="뽑기왕을 소개합니다"></h3>					
					<div class="swiper-container">
						<div class="swiper-wrapper" id="winners">
						</div>
					</div>
				</div>
				<% if currentDate < Cdate("2019-06-28") then %>
				<div class="push">
					<button type="button" onclick="regAlram(true);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/btn_push.jpg" alt="내일 푸시 알림 받기"></button>					
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/tit_push.jpg" alt="푸시 수신 설정 방법"></h3>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/txt_push_01.jpg" alt="STEP 01"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/txt_push_02.jpg" alt="STEP 02"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/txt_push_03.jpg" alt="STEP 03"></div>
						</div>
						<button type="button" class="swiper-button swiper-button-prev">
							<svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
						</button>
						<button type="button" class="swiper-button swiper-button-next">
							<svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></svg>
						</button>
					</div>
				</div>
				<% end if %>
				<!-- 유의사항 -->
				<div class="noti">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/tit_noti.png" alt="이벤트 유의사항"></h3>
					<ul>
						<li>본 이벤트는 텐바이텐 APP에서 로그인 후 참여 가능합니다.</li>
						<li>ID당 1일 1회만 응모 가능하며, 친구에게 공유 시 한 번 더 응모 기회가 주어집니다. (하루 최대 2번 응모 가능)</li>
						<li>모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
						<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
						<li>제세공과금은 텐바이텐 부담입니다.</li>
						<li>당첨자에게는 상품 수령 후, 인증 사진을 요청드릴 예정입니다.</li>
					</ul>
				</div>
				<div id="winnerPopup" class="layer-popup" style="display:none;">
					<div class="layer-inner">						
						<a href="javascript:goDirOrdItem()">
							<img id="winImg" src="" alt="">
						</a>							
					</div>
					<div class="layer-mask"></div>
				</div>					
				<div id="firstTryPopup" class="layer-popup" style="display:none;">
					<div class="layer-inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/try_fail1.png?v=1.0" alt="COUPON 3,000원"></p>
						<button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
						<button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
						<button type="button" class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95316/m/btn_close.png" alt="닫기"></button>
					</div>
					<div class="layer-mask"></div>
				</div>
				<%
				dim tmpImg 				

				if currentDate < Cdate("2019-06-28") then
					tmpImg = "//webimage.10x10.co.kr/fixevent/event/2019/95316/m/try_fail2.png"
				else 
					tmpImg = "//webimage.10x10.co.kr/fixevent/event/2019/95316/m/try_done.png?v=1.0"
				end if
				%>								
				<div id="secondTryPopup" class="layer-popup" style="display:none;">
					<div class="layer-inner">
						<button type="button" class="btn-close"><img src="<%=tmpImg%>" alt="확인"></button>
					</div>
					<div class="layer-mask"></div>
				</div>				
				<div id="tryDone" class="layer-popup" style="display:none;">
					<div class="layer-inner">
						<button type="button" class="btn-close"><img src="<%=tmpImg%>" alt="확인"></button>
					</div>
					<div class="layer-mask"></div>
				</div>
			</div>
			<!--// 100원 자판기 (A) 95316 -->
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
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
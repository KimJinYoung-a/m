<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'####################################################
' Description : 2020 득템하기좋은날 이벤트
' History : 2020-03-19 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "101592"
	moECode = "90472"
Else
	eCode = "101437"
	moECode = "101436"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-03-23")		'이벤트 시작일
eventEndDate 	= cdate("2020-03-31")		'이벤트 종료일

if mktTest then
currentDate = "2020-03-22"
else
currentDate 	= date()
end if

LoginUserid		= getencLoginUserid()
IF application("Svr_Info") = "Dev" THEN
	'LoginUserid = LoginUserid + Cstr(timer())
end if
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[득템하기 좋은 날]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[득템하기 좋은 날]"
	Dim kakaodescription : kakaodescription = "겔럭시 Z플립이 99,000원? 지금 바로 원하는 상품에 도전하세요!"
	Dim kakaooldver : kakaooldver = "겔럭시 Z플립이 99,000원? 지금 바로 원하는 상품에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_kakao.jpg"
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
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	isShared = pwdEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

dim currentTime
currentTime=Cdate("2020-03-22 23:59:59")
%>
<style type="text/css">
.mEvt101437 {background-color:#fffef4;}
.mEvt101437 button {background-color:transparent;}
.topic {position:relative; overflow:hidden;}
.topic:before {content:''; position:absolute; right:0; top:0; z-index:10; width:33%; height:400%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/bg_topic.png) repeat-y 0 0 / 100% auto; animation:itemslide 15s linear 3;}
.preview {display:none;}
.item-list {overflow:hidden;}
.item-list button {width:100%;}
.item-list li {position:relative; float:left; width:50%;}
.item-list li:nth-child(1) {width:100%;}
.item-list .quantity {position:absolute; top:35%; right:8.5%; width:4.4rem; height:4.4rem; padding-top:1.2rem; color:#fff; text-align:center; font-size:.9rem; border-radius:50%; background:#ff6d1e; box-shadow:.2rem .2rem .4rem .04rem rgba(0,0,0,.1);}
.item-list .quantity strong {display:block; padding-top:.2rem; font-size:1.3rem;}
.item-list li:nth-child(1) .quantity {right:46%; top:21%;}
.item-list li:nth-child(2) .quantity {background:#6861e5;}
.item-list li:nth-child(3) .quantity {background:#0cbb8b;}
.item-list li:nth-child(4) .quantity {background:#33aaee;}
.item-list li:nth-child(5) .quantity {background:#ea9500;}
.item-list li .thumb:after {content:''; overflow:hidden; position:absolute; left:50%; bottom:6.8%; width:64%; height:11.9%; margin-left:-32%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_submit.png) 50% 50% no-repeat; background-size:100% auto; border:.2rem solid #ff6d1e; border-radius:1.8rem;}
.item-list li:nth-child(1) .thumb:after {bottom:22%; width:32%; height:14.3%; margin-left:12%;}
.item-list li:nth-child(2) .thumb:after {border-color:#6861e5;}
.item-list li:nth-child(3) .thumb:after {border-color:#0cbb8b;}
.item-list li:nth-child(4) .thumb:after {border-color:#33aaee;}
.item-list li:nth-child(5) .thumb:after {border-color:#ea9500;}
.item-list li .sold:after {display:none;}
.winner {position:relative; padding:0 12.4% 2.22rem; background:#fff947;}
.winner-slide {overflow:hidden; position:relative;}
.winner-slide .swiper-slide {display:table; background:#fff;}
.winner-slide .swiper-slide .inner {display:table-cell; vertical-align:middle; height:11.78rem;}
.winner-slide .swiper-slide ul {overflow:hidden; width:66%; margin:0 auto; padding-top:1.37rem; color:#000; font-family:'CoreSansCMedium';}
.winner-slide .swiper-slide li {float:left; width:50%; font-size:1rem; padding-bottom:.5rem; text-align:center;}
.winner-slide .swiper-slide li:first-child:nth-last-child(1) {width:100%; font-size:1.2rem;}
.winner-slide .swiper-slide li span {display:inline-block; width:3rem;}
.winner-slide .swiper-slide li:nth-child(1) span:before {content:'01.';}
.winner-slide .swiper-slide li:nth-child(2) span:before {content:'02.';}
.winner-slide .swiper-slide li:nth-child(3) span:before {content:'03.';}
.winner-slide .swiper-slide li:nth-child(4) span:before {content:'04.';}
.winner-slide .swiper-slide li:nth-child(5) span:before {content:'05.';}
.winner-slide .swiper-slide li:nth-child(6) span:before {content:'06.';}
.winner-slide .swiper-slide li:nth-child(7) span:before {content:'07.';}
.winner-slide .swiper-slide li:nth-child(8) span:before {content:'08.';}
.winner-slide .swiper-slide li:nth-child(9) span:before {content:'09.';}
.winner-slide .swiper-slide li:nth-child(10) span:before {content:'10.';}
.winner .swiper-button-prev,
.winner .swiper-button-next {position:absolute; top:0; width:12.4%; height:11.78rem; text-indent:-999em; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_prev.png) no-repeat 0 50% / 100% auto;}
.winner .swiper-button-prev {left:0;}
.winner .swiper-button-next {right:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_next.png)}
.winner .swiper-button-disabled {opacity:.4;}
.winner .pagination {height:auto; padding-top:1.28rem; }
.winner .pagination span {width:.7rem; height:.7rem; background:#b0ac41;}
.winner .pagination span.swiper-active-switch {background:#393939;}
.alarm {display:none; overflow:hidden; position:relative;}
.alarm .btn-talk {display:block; position:absolute; left:8%; bottom:15%; width:54%; height:15%; text-indent:-999em;}
.alarm .time {overflow:hidden; position:absolute; left:7%; top:23%; width:93%; color:#000; font-size:7rem; font-family:'CoreSansCBold'; letter-spacing:-.5rem;}
.alarm .time span {float:left;}
.alarm .time span:before {content:':'}
.alarm .time span:first-child:before {content:'-'}
.sns-share {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_share.png) no-repeat 0 0 / 100% auto;}
.btn-share {display:flex; position:absolute; top:0; right:9.5%; width:36%; height:75%;}
.btn-share li {width:50%; height:100%;}
.btn-share li button {width:100%; height:100%; text-indent:-999em;}
.pop {display:none; position:fixed; top:0; left:0; z-index:30; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.pop .inner {position:relative; top:50%; width:80.67%; margin:0 auto; transform:translateY(-50%); background:#fffab1;}
.pop span {display:block; position:absolute; bottom:.3rem; left:0; width:100%; text-align:center; color:#fdb1ef;}
.pop .btn-close {position:absolute; top:0; right:0; width:4.74rem; height:5.12rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_close.png) no-repeat 0 0 / 100% auto;}
.pop .btn-share {top:56%; left:20%; width:60%; height:25.79%;}
.pop-fail .inner {width:86%;}
.pop-alarm {background-color:rgba(0,0,0,.9);}
.pop-alarm .inner {width:100%; background:none;}
.pop-alarm .inp-tel {position:relative; margin:0 8%; border-bottom:.17rem solid #ffed53;}
.pop-alarm .inp-tel input {display:block; width:80%; height:3rem; color:#fff; font-size:1.44rem; background:transparent; border:0;}
.pop-alarm .inp-tel button {position:absolute; right:0; top:0; width:20%; height:3rem; font-size:1.45rem; font-weight:600; text-align:center; color:#ffed53}
.pop-alarm .btn-close {right:0; top:0; width:7.04rem; height:7.47rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_close2.png); background-size:100% auto;}

/* teaser */
.teaser .topic:after {content:''; position:absolute; left:0; top:0; width:100%; height:100%;  background:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/tit_get_item_coming.png) 0 0 no-repeat / 100% 100%;}
.teaser .alarm,
.teaser .preview {display:block;}
.teaser .item-list,
.teaser .winner-wrap {display:none;}
.teaser .sns-share {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_share_coming.png);}
@keyframes itemslide {
  	from {background-position:0 0;}	to { background-position:0 -100%;}
}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script type="text/javascript"> 
var userPwd = "";
var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;
var _WinnerList="";

$(function(){
	$(".mEvt101437 .btn-close").click(function(){
		$(".mEvt101437 .pop").hide();
	});
    getEvtItemList();
	getWinners();

	setTimeout(function() {
		var winnerSwiper = new Swiper('.winner-slide', {
			pagination:'.winner-slide .pagination',
			nextButton:'.swiper-button-next',
			prevButton:'.swiper-button-prev',
			hashnav:true
		});
	}, 1000);
});

function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			//console.log(res.data)
			renderList(res.data)
		}
	})
}
function eventTry(s){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_fail2_2.png")
			$("#fail").show();
			return false;
		}
		if(numOfTry == '2'){
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_fail3.png")
			$("#fail").show();
			return false;
		}
//=============		
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEventProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt);
							getEvtItemList();
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
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/event/etc/realtimeevent/realtimeEventProc.asp",
			data: "mode=snschk&snsnum="+snsnum,
			dataType: "JSON",			
			success: function(res){
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
			},
			error: function(err){
				alert('잘못된 접근입니다.')
			}
		})
}
function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_fail2_1.png")
			$("#fail").show();
			return false;
		}
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_fail1.png")
		$("#fail").show();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_win_item"+ selectedPdt +".png?v=1.01")
		$("#win").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_fail3.png")
		$("#fail").show();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}
function renderList(itemList){
	var $rootEl = $("#itemList")
	var itemEle = tmpEl = tmpCls = info = ""
	$rootEl.empty();
	// 오픈 리스트
	if(itemList.length > 0){
		//var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
        var newArr = itemList
		newArr.forEach(function(item){
			if (item.isOpen){
				if(item.leftItems <= 0){ //open
					info = '\
                        <li>\
                            <div class="thumb sold"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_item'+ item.itemcode +'_out.jpg?v=1.05" alt="sold out"></div>\
                        </li>\
                        '
				}else{
					info = '\
						<li>\
                            <button class="thumb" onclick="eventTry('+ item.itemcode +')">\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_item'+ item.itemcode +'.jpg?v=1.04" alt="">\
                            </button>\
                            <p class="quantity">남은수량<strong>'+ item.leftItems +'개</strong></p>\
                        </li>\
					'
				}
			}
			else{
				info = '\
                        <li>\
                            <div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_item'+ item.itemcode +'_coming.jpg?v=1.05" alt=""></div>\
                        </li>\
                    '
			}
			
			tmpEl = info
			itemEle += tmpEl
		});
	}
	// 대기 리스트
	$rootEl.append(itemEle)
}
function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}
function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
		dataType: "JSON",
		data: { mode: "winner" },
		success : function(res){
            for (var i = 1; i < 6 ; i++) {
                renderWinners(res.data, i);
            }
		},
		error:function(err){
			console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}
function renderWinners(data, i){
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
    var itemEleTop=""
    var itemEleBottom=""
    var ix=0;
	$rootEl.empty();

    itemEleTop = '  <div class="swiper-slide">\
                        <div class="inner">\
                            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_win_' + i + '.png?v=1.01" alt=""></p>\
                            <ul>'
	data.forEach(function(winner){
        if(winner.code==i){
		    tmpEl = '           <li><span></span>' + printUserName(winner.userid, 2, "*") + '</li>'
            ix=ix+1;
            itemEle += tmpEl;
        }
	});
    itemEleBottom = '       </ul>\
                        </div>\
                    </div>'

    if(ix>0){
        _WinnerList = _WinnerList + itemEleTop + itemEle + itemEleBottom
        $rootEl.append(_WinnerList)
        //alert(_WinnerList);
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
countDownTimer("<%=Year(currentTime)%>"
                , "<%=TwoNumber(Month(currentTime))%>"
                , "<%=TwoNumber(Day(currentTime))%>"
                , "<%=TwoNumber(hour(currentTime))%>"
                , "<%=TwoNumber(minute(currentTime))%>"
                , "<%=TwoNumber(Second(currentTime))%>"
                , new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>));


function fnAlarm(){
    $('.pop-alarm').fadeIn();
}

function fnSendToKakaoMessage() {
    if ($("#phone").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone").focus();
        return;
    }

    var phoneNumber = $("#phone").val();

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/realtimeEventProc.asp",
        data: "mode=kamsg&phoneNumber="+phoneNumber,
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var result = JSON.parse(Data);
                        if(result.response == "ok"){
                            $("#phone").val('');
                            $(".pop-alarm").fadeOut();
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
            return false;
        }
    });
}
</script>
			<!-- 101437 득템하기 좋은 날 -->
			<!-- for dev msg : 티저 오픈 기간동안 클래스 teaser 넣어주세요 -->
			<div class="mEvt101437<% if currentDate < "2020-03-23" then %> teaser<% end if %>">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/tit_get_item.png" alt="득템하기 좋은 날"></h2>
				</div>
				<div class="preview"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/img_item_teaser.jpg" alt=""></div>
                <ul class="item-list" id="itemList"></ul>
				<div class="winner-wrap">
					 <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_winner.png" alt="당첨자를 소개합니다"></h3>
					 <div class="winner">
						<div class="winner-slide">
							<div class="swiper-wrapper" id="winners"></div>
							<div class="pagination"></div>
						</div>
						<div class="swiper-button-prev">이전</div>
						<div class="swiper-button-next">다음</div>
					</div>
				</div>
				<div class="alarm">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_alarm.png" alt="이벤트 오픈까지 남은 시간"></p>
					<div class="time" id="countdown"></div>
					<button class="btn-talk" onClick="fnAlarm();">이벤트 시작 전 알림받기</button>
                    <%'!-- 알람받기 레이어 --%>
					<div class="pop pop-alarm" style="display:none;">
						<div class="inner">
							<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/pop_txt_alarm.png?v=2" alt="기회를 놓치지 않는 가장 확실한 방법, 세일 시간이 다가오면 카카오 알림톡 또는 문자메시지로 빠르게 알려드립니다"></p>
							<div class="inp-tel"><input type="tel" id="phone" placeholder="휴대폰 번호를 입력해주세요"><button onclick="fnSendToKakaoMessage()">확인</button></div>
						</div>
						<button class="btn-close" onclikc="closeLyr();"></button>
					</div>
				</div>
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/btn_sns.png" alt="친구에게 공유하고 한 번 더 도전하세요!">
					<ul class="btn-share">
						<li><button onclick="sharesns('fb')">페이스북공유</button></li>
						<li><button onclick="sharesns('ka')">카카오톡공유</button></li>
					</ul>
				</div>
				<div class="evt-bnr">
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101418');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/bnr_event2.jpg" alt="창문 열고 집 청소 좀 해볼까"></a>
					<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96333');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/bnr_event1.jpg" alt="메일 구독하고 1,000P 받아가세요!"></a>
				</div>
				<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_noti.png" alt="이벤트 유의사항"></div>
				<!-- 당첨 -->
				<div class="pop" id="win">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_pop_winner.png" alt="당첨을 축하드립니다!"></p>
						<a href="javascript:goDirOrdItem();">
							<img id="winImg" alt="당첨 상품">
                        </a>
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101437/m/txt_caution.png" alt="3월 31일까지 구매하지 않을 경우 상품은 품절 처리될 예정입니다"></p>
					</div>
				</div>
				<div class="pop pop-fail" id="fail">
					<div class="inner">
						<div><img id="failImg" src="" alt=""></div>
						<button class="btn-close"></button>
						<ul class="btn-share">
							<li><button onclick="sharesns('fb')">페이스북공유</button></li>
							<li><button onclick="sharesns('ka')">카카오톡공유</button></li>
						</ul>
					</div>
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
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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
' Description : 에어팟 자판기
' History : 2020.06.22 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i
dim mktTest

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "102185"
Else
	eCode = "103766"
End If

eventStartDate  = cdate("2020-06-29")		'이벤트 시작일 
eventEndDate 	= cdate("2020-07-09")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

' 테스트용
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	mktTest = false
end if

if mktTest then
    currentDate = cdate("2020-06-29")
else
    currentDate = date()
end if

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

Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("<에어팟 자판기> 이벤트 오픈!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "<에어팟 자판기> 이벤트 오픈!"
Dim kakaodescription : kakaodescription = "에어팟이 500원인 자판기?! 한정수량 15대니 서둘러 도전하세요!"
Dim kakaooldver : kakaooldver = "에어팟이 500원인 자판기?! 한정수량 15대니 서둘러 도전하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode


%>
<style>
.mEvt103766 {position:relative; overflow:hidden;}
.mEvt103766 .topic {position:relative;}
.mEvt103766 .airpods {display:flex; flex-direction:column; overflow:hidden; position:absolute; top:25%; left:7%; width:86%; height:50%; padding:0 2vw;}
.mEvt103766 .airpods .row {display:flex; animation:slide 10s linear infinite alternate both;}
.mEvt103766 .airpods .row:nth-child(2) {animation-direction:alternate-reverse;}
.mEvt103766 .airpods .row .col {width:26.7vw; flex-shrink:0; margin:0 0.3vw;}
@keyframes slide {
	0% {transform:translateX(0);}
	100% {transform:translateX(-80vw);}
}
.mEvt103766 .airpods .link {position:absolute; left:0; top:0; width:100%; height:100%; font-size:0;}
.mEvt103766 .topic .limit {display:flex; flex-direction:column; justify-content:center; position:absolute; bottom:10%; left:7%; width:16%; height:13%; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:3.7vw; line-height:1.3; color:#111;}
.mEvt103766 .topic .limit span {display:block; color:#f81c1c;}
.mEvt103766 .topic .limit span b {font-size:4vw; letter-spacing:1px;}
.mEvt103766 .topic .btn-try {position:absolute; bottom:10%; right:0; width:76%; height:13%; font-size:0; background:none;}
.mEvt103766 .winner {position:relative; padding:10% 0 12%; background:#e8ffe7;}
.mEvt103766 .winner:before {content:' '; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_deco.png) center top no-repeat; background-size:100% auto;}
.mEvt103766 .winner .box {width:90%; margin:0 auto; background:#fff; border:0.17rem solid #111; border-radius:0.43rem;}
.mEvt103766 .winner .btn-toggle {position:relative; background:none;}
.mEvt103766 .winner .btn-toggle:after {content:' '; position:absolute; top:35%; right:7%; width:6.7vw; height:6.7vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103766/m/ico_arrow.png) center no-repeat; background-size:contain;}
.mEvt103766 .winner .active .btn-toggle:after {transform:rotate(180deg);}
.mEvt103766 .winner .winner-list {display:none; position:relative; height:13rem; padding:0 0 2rem 10%; margin-top:-1rem;}
.mEvt103766 .winner .active .winner-list {display:flex; flex-wrap:wrap;}
.mEvt103766 .winner .winner-list li {width:33.3%; padding:0.5rem 0; text-align:left; white-space:nowrap; color:#111;}
.mEvt103766 .lyr {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.mEvt103766 .lyr .inner {position:absolute; top:50%; left:6.5%; width:87%; transform:translateY(-50%);}
.mEvt103766 .lyr button {background:none;}
.mEvt103766 .lyr .btn-close {position:absolute; right:0; top:0; width:16vw; height:16vw; font-size:0;}
.mEvt103766 .lyr .link {position:absolute; left:0; bottom:0; width:100%; height:40%;}
/* 티저 css 추가 */
.mEvt103766 .btn-alarm {display:block; width:100%;}
.mEvt103766 .lyr-alarm {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,0.9);}
.mEvt103766 .lyr-alarm .inner {position:relative; width:32rem; margin:0 auto;}
.mEvt103766 .lyr-alarm .btn-close {position:absolute; right:0; top:0; width:7rem; height:7rem; font-size:0; background:none;}
.mEvt103766 .form {position:absolute; top:58%; left:0; width:100%;}
.mEvt103766 .form .input {display:flex; width:22.6rem; height:3.4rem; margin:0 2.56rem; border-bottom:0.17rem solid #a4ffa0;}
.mEvt103766 .form input {width:100%; height:auto; padding:0; font-size:1.45rem; color:#a8a8a8; border:0 none; background:none;}
.mEvt103766 .form .btn-submit {flex:0 0 4.6rem; font-size:1.45rem; color:#a4ffa0; background:none;}
</style>
<script>
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>";
$(function(){
	$('.winner .btn-toggle').click(function(){
		$(this).parent('.box').toggleClass('active');
	});
	// close popup (mask)
	$('.mEvt103766 .lyr').click(function(e){
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
	});
	// close popup (btn)
	$('.lyr .btn-close').click(function(){
		$(this).closest('.lyr').fadeOut();
	});
    // 알림 신청 팝업
	$('.lyr-alarm .btn-close').click(function(){
		$('#lyrAlarm').fadeOut();
	});
	// 알림신청 팝업레이어
	$(".btn-alarm").click(function(){
		$('#lyrAlarm').fadeIn();
	});    
    getWinners();
    getEvtItemCNT();
});

function getEvtItemCNT(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/vendingMachineEventProc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			 //console.log(res.data)
			renderItemCNT(res.data)
		}
	})
}

function renderItemCNT(itemList){
	var $rootEl = $("#itemCnt")
	var itemEle = tmpEl = tmpCls = info = ""
    $rootEl.empty();
    if(itemList.length > 0){
        var newArr = itemList
        newArr.forEach(function(item){
            tmpEl = '<b>'+ item.leftItems +'</b>개'
            itemEle += tmpEl        
        });
    }
	$rootEl.append(itemEle)
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/vendingMachineEventProc.asp",
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
		url:"/event/etc/realtimeevent/vendingMachineEventProc.asp",
		dataType: "JSON",
		data: { mode: "winner" },
		success : function(res){		
			renderWinners(res.data)
		},
		error:function(err){
			console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}

function renderWinners(data){
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	var ix=0;
	$rootEl.empty();
	data.forEach(function(winner){
		tmpEl = '<li>' + printUserName(winner.userid, 2, "*") + '님</li>'
		itemEle += tmpEl
		ix += 1;
	});
	if(ix==0){
		itemEle = '<li>아직 당첨자가 없습니다!</li>'
	}
	$rootEl.append(itemEle)
}

function eventTry(s){
	
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate < eventEndDate) or mktTest Then %>
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$('.lyr').hide();
			$('#result2').show();
			return false;
		}
		if(numOfTry == '2'){
			$('.lyr').hide();
			<% If (currentDate >= #07/08/2020 00:00:00#) Then %>
			$('#resultover2').show();
			<% else %>
			$('#resultover').show();
			<% end if %>
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
			url:"/event/etc/realtimeevent/vendingMachineEventProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt, res.md5userid);
							getEvtItemCNT();
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

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){
		if(numOfTry >= 2){
			<% If (currentDate >= #07/08/2020 00:00:00#) Then %>
			$("#result4").show();
			<% else %>
			$("#result3").show();
			<% end if %>
			return false;
		}
		$("#result").show();
	}else if(returnCode[0] == "C"){
        $("#itemid").val(itemid);
		$("#resultC").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$("#resultover").show();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate < eventEndDate) or mktTest Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
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
        url:"/event/etc/realtimeevent/vendingMachineEventProc.asp",
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

function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
    }
}
</script>

			<div class="mEvt103766">
				<% If (currentDate >= eventStartDate And currentDate < eventEndDate) or mktTest Then %>
                <% 'If (currentDate >= eventStartDate And currentDate < eventEndDate) Then %>
				<%'!-- topic 오픈 후 --%>
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/tit_airpod.jpg" alt="에어팟 자판기"></h2>
					<div class="airpods">
						<div class="row">
							<div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="1"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="2"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="3"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="4"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="5"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="6"></div>
						</div>
						<div class="row">
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="1"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="2"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="3"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="4"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="5"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="6"></div>
						</div>
						<div class="row">
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
						</div>
					</div>
					<%'!-- for dev msg : 남은 수량 및 뽑기 버튼 --%>
					<div class="limit"><span id="itemCnt"></span>남음</div>
					<button type="button" onclick="eventTry('1');" class="btn-try">에어팟 뽑기</button>
				</div>
				<div class="winner">
					<div class="box">
						<button type="button" class="btn-toggle"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/tit_winner.png" alt="당첨자"></button>
						<ul class="winner-list" id="winners"></ul>
					</div>
				</div>
                <% else %>
                <%'!-- topic 오픈 전 (티저) --%>
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/tit_airpod_teaser.jpg" alt="에어팟 자판기"></h2>
					<div class="airpods">
						<div class="row">
							<div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="1"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="2"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="3"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="4"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="5"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="6"></div>
						</div>
						<div class="row">
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="1"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="2"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="3"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="4"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt="5"></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt="6"></div>
						</div>
						<div class="row">
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_open.png" alt=""></div>
							 <div class="col"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/img_airpod_close.png" alt=""></div>
						</div>
					</div>
				</div>
				<%'!-- 알림 신청 : 오픈 전에만 --%>
                <button type="button" onclick="" class="btn-alarm">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/btn_alarm.jpg" alt="오픈 알림 받기">
				</button>
				<%'!-- 팝업 : 알림 신청 --%>
				<div id="lyrAlarm" class="lyr-alarm" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_alarm.png" alt="">
						<div class="form">
							<div class="input">
								<input type="number" id="phone1" maxlength="3" placeholder="000" oninput="maxLengthCheck(this)">
								<input type="number" id="phone2" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this)">
								<input type="number" id="phone3" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this)">
								<button type="button" onclick="fnSendToKakaoMessage()" class="btn-submit">확인</button>
							</div>
						</div>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
                <% end if %>
				<a href="https://tenten.app.link/e/cEYcC315v7"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/bnr_insta.jpg" alt="인스타 스토리"></a>
				<a href="/event/eventmain.asp?eventid=103771" target="_blank" class="mWeb">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/bnr_evt_01.jpg" alt="텐바이텐 여름 BIG SALE">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103771');" target="_blank" class="mApp">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/bnr_evt_01.jpg" alt="텐바이텐 여름 BIG SALE">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/txt_noti.jpg" alt="유의사항"></p>

				<%'!-- 팝업 : 당첨 --%>
				<div id="resultC" class="lyr" style="display:">
					<div class="inner">
						<a href="" onclick="goDirOrdItem();return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_win.png" alt="성공">
						</a>
					</div>
				</div>
				<%'!-- 팝업 : 꽝1 --%>
				<div id="result" class="lyr">
					<div class="inner">
						<button type="button" onclick="sharesns('ka');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_fail1.png" alt="꽝">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 공유 안하고 재응모 --%>
				<div id="result2" class="lyr">
					<div class="inner">
						<button type="button" onclick="sharesns('ka');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_already.png" alt="이미">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 꽝2 --%>
				<div id="result3" class="lyr">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_fail2.png" alt="내일 다시">
						<a href="/event/eventmain.asp?eventid=103771" target="_blank" class="link mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103771');" target="_blank" class="link mApp"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 꽝2 마지막날 --%>
				<div id="result4" class="lyr">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_fail2_last.png" alt="감사합니다">
						<a href="/event/eventmain.asp?eventid=103771" target="_blank" class="link mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103771');" target="_blank" class="link mApp"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 --%>
				<div id="resultover" class="lyr">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_fin.png" alt="내일 또">
						<a href="/event/eventmain.asp?eventid=103771" target="_blank" class="link mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103771');" target="_blank" class="link mApp"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 마지막날 --%>
				<div id="resultover2" class="lyr">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103766/m/pop_fin_last.png" alt="감사합니다">
						<a href="/event/eventmain.asp?eventid=103771" target="_blank" class="link mWeb"></a>
						<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103771');" target="_blank" class="link mApp"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>

<% If IsUserLoginOK() Then %>
<% if isApp=1 then %>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<% else %>
<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO1">
</form>
<% end if %>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
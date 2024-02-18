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
' Description : 2020 시원한 커피 이벤트
' History : 2020-05-14 원승현
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest, coffeeNumber, drawEvent

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "102165"
Else
	eCode = "102578"
End If

eventStartDate  = cdate("2020-05-18")		'이벤트 시작일
eventEndDate 	= cdate("2020-05-27")		'이벤트 종료일
if mktTest then
    currentDate = cdate("2020-05-27")
else
    currentDate 	= date()
end if
currentDate 	= date()

LoginUserid		= getencLoginUserid()
IF application("Svr_Info") = "Dev" THEN
	'LoginUserid = LoginUserid + Cstr(timer())
end if
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[커피 어떠세요?]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[커피 어떠세요?]"
	Dim kakaodescription : kakaodescription = "원하는 만큼 스타벅스 기프트카드를 드립니다. 응모해보세요!"
	Dim kakaooldver : kakaooldver = "원하는 만큼 스타벅스 기프트카드를 드립니다. 응모해보세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<%
dim isSecondTried
dim isFirstTried
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set drawEvent = new DrawEventCls
	drawEvent.evtCode = eCode
	drawEvent.userid = LoginUserid
	isSecondTried = drawEvent.isParticipationDayBase(2)
	isFirstTried = drawEvent.isParticipationDayBase(1)
	isShared = drawEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<link rel="stylesheet" href="//malihu.github.io/custom-scrollbar/jquery.mCustomScrollbar.min.css" />
<style type="text/css">
.topic {position:relative; width:100%; height:56.91rem; margin:0 auto;}
.topic h2 {position:fixed; top:16.67vw; left:0; z-index:7;}
.topic h2 span {display:block; position:relative; opacity:0;}
.topic h2 .t2 {margin:3.6% 0 1.7%;}
.topic h2 .t3 {left:-0.8%; margin-bottom:3.6%;}
.topic h2 .t4 {left:-0.8%;}
.topic.on h2 span {animation:fadeUp both .7s;}
.topic.on h2 .t2 {animation-delay:.3s;}
.topic.on h2 .t3 {animation-delay:.5s;}
.topic.on h2 .t4 {animation-delay:.7s;}
@keyframes fadeUp {
    0%{transform:translateY(1rem); opacity:0;}
    100%{transform:translateY(0); opacity:1;}
}
.topic .vod-wrap {position:absolute; top:0; left:0; z-index:5; width:100%; height:100%; clip:rect(0, auto, auto, 0);}
.topic .vod-wrap .vod-coffee {position:fixed; top:0; left:0; z-index:10; width:100vw;}
.topic .scroll {position:fixed; bottom:15.2vw; z-index:15; animation:bounce 1s 30;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(0.8rem); animation-timing-function:ease-out;}
}
.section {position:relative; z-index:10;}
.section-apply {background-color:#fff; color:#222; font-size:1.79rem; font-family:'CoreSansCBold','AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.section-apply .info {padding:0 7%;}
.section-apply .info .name {font-family:'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.section-apply .info .wrap {display:flex; position:relative; justify-content:space-between; margin-top:1.28rem; margin-bottom:2.71rem;}
.section-apply .info .wrap .prize {color:#ff3939; font-size:2.13rem;}
.section-apply .info .wrap select {width:10.67rem; height:2.6rem; padding:0 5.55rem 0 .43rem; margin:0; border:0; border-radius:0; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102578/m/btn_amount.png?v=1.01) no-repeat 50% 0; background-size:100%; color:inherit; font-size:1.79rem; line-height:2.9rem; font-family:'CoreSansCBold';}

.lyr {overflow:scroll; display:flex; justify-content:center; align-items:center; flex-wrap:wrap; position:fixed; top:0; left:0; z-index:10011; width:100vw; height:100vh; padding:0 7%; background-color:rgba(255,255,255,0.7);}
.lyr .result {position:relative; box-shadow:0.5rem 0.5rem 2rem 0.06rem rgba(21, 21, 21, .5); border-radius:1rem;}
.lyr .btn-close {position:absolute; top:0; right:0; z-index:101; width:17vw; height:17vw; font-size:0; color:transparent; background-color:transparent;}
.lyr .btn-share {position:absolute; top:41.72%; width:50%; height:21.1%; right:0;}
.lyr .btn-fb {right:unset; left:0;}
.lyr-win .prize {position:absolute; top:48.35%; left:0; width:100%; text-align:center; color:#fff; font-size:3rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.lyr-win .prize span {font-size:2.3rem;}

.section-winner {display:flex; align-items:center; height:3rem; background-color:#e5e5e5; color:#666; font-size:1.37rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.section-winner:after {display:block; position:absolute; top:-1%; z-index:20; width:100%; height:102%; content:'';}
.section-winner .tit-winner {width:28.93%;}
.section-winner .winner-list {overflow:hidden; display:flex; width:71.07%; height:100%;}
.section-winner .winner-info {display:flex; align-items:center; height:100%; padding-top:.3rem;}
.section-winner .winner-info .winner-name {padding-left:1.58rem;}
.section-winner .winner-info .prize {display:inline-block; padding-left:2.13rem;}

.section-sns {position:relative;}
.btn-share {display:inline-block; position:absolute; top:0; right:21.73%; width:11.73%; height:100%; background-color:transparent; text-indent:-999em;}
.btn-kakao {right:8%;}

.section-cups .set-wrap {position:relative;}
.section-cups .set {display:flex; flex-wrap:wrap; position:absolute; top:0; left:0; width:100%; height:100%;}
.section-cups a {display:inline-block; width:100%;}
.section-cups .column {display:flex; flex-wrap:wrap;}
.section-cups .column1 {width:100%; height:32.2%;}
.section-cups .column2 {width:50%; height:67.8%;}
.section-cups .lg-thumb {height:43.89%;}
.section-cups .mid-thumb {height:30.85%;}
.section-cups .sm-thumb {height:25.26%;}

/* mobile web */
.mw .topic {height:52.13rem;}
.mw .topic h2 {top:29.44vw;}
.mw .topic .scroll {bottom:7.2vw;}
</style>
<script type="text/javascript">
$(function(){

	// check app,web
	var chkapp = navigator.userAgent.match("tenapp");
	if ( !chkapp ){
		$(".mEvt102578").addClass('mw');
	}

	// coffee info
	var coffeeCode = $('.evt-coffee .topic').data('coffee-code');
	var coffeeInfo = [
		{name:'아이스 아메리카노', vodCode:'957'},
		{name:'아이스 라떼', vodCode:'958'},
		{name:'아이스 모카 라떼', vodCode:'959'},
		{name:'블루 레몬 에이드', vodCode:'960'},
		{name:'아이스 녹차 라떼', vodCode:'961'}
	]
	$('.vod-coffee').attr('poster','//webimage.10x10.co.kr/video/vid'+ coffeeInfo[coffeeCode].vodCode +'.jpg');
	$('.vod-coffee source').attr('src','//webimage.10x10.co.kr/video/vid'+ coffeeInfo[coffeeCode].vodCode +'.mp4');
	$('.vod-coffee').get(0).load();
	$('.vod-coffee').get(0).play();
	$('.section-apply .thumb-coffe img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_coffee'+ (coffeeCode+1) +'.jpg');
	$('.section-apply .name').text(coffeeInfo[coffeeCode].name);
	
	// animation
	setTimeout(function(){$('.topic').addClass('on');},2000);
	$(window).scroll(function() {
		var window_top = $(window).scrollTop();
		var div_top = $(".section-apply").offset().top;
		if (window_top > div_top){
			$(".topic h2, .scroll").hide();
		} else {
			$(".topic h2, .scroll").show();
		}
    })
    
});
</script>
<script type="text/javascript">
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	getWinners();
});
</script>
<script>
function eventTry(s){
	<% If Not(IsUserLoginOK) Then %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
//========\
		if(numOfTry == '1' && isShared != "True"){
            <%'// 한번 시도하고 공유 안했을때 %>
            $("#lyrResult").show();
			setTimeout("$('#secondTry').show()",200);
			return false;
		}
        <%'// 두번 다 시도 했을때 %>
		if(numOfTry == '2'){
            $("#lyrResult").show();
			setTimeout("$('#trylimit').show()",200);
			return false;
		}
//=============		
        var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s,
            coffeeCntVal: $("#coffeeCntVal").val()
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/drawevent/drawEventCoffeeProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						//console.log(res)
						if(res.response == "ok"){
                            popResult(res.result, res.winItemid, res.md5userid);
                            getWinners();
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
        url:"/event/etc/drawevent/drawEventCoffeeProc.asp",
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
            console.log(err);
            alert('잘못된 접근입니다.');
            return false;
        }
    });
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
    // 카카오 SNS 공유
    Kakao.init('c967f6e67b0492478080bcf386390fdd');

    Kakao.Link.sendTalkLink({
        label: label,
        image: {
        src: imageurl,
        width: width,
        height: height
        },
        webButton: {
            text: '10x10 바로가기',
            url: linkurl
        }
    });
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}
function popResult(returnCode, itemid, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
            <%'<-- 공유 후 두번째 응모시 -->%>
            $("#lyrResult").show();
			setTimeout("$('#fail2').show()",200);
			return false;
        }
        $("#lyrResult").show();        
		setTimeout("$('#fail1').show()",200);
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		$("#prizePrice").empty().html(numberWithCommas(itemid));	
        //$("#useridmd5").empty().html(md5userid)
        $("#lyrResult").show();
        setTimeout("$('#winnerPopup').show()",200);
	}else if(returnCode == "A02"){
        numOfTry = 2
        $("#lyrResult").show();
        setTimeout("$('#trylimit').show()",200);
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
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
		url:"/event/etc/drawevent/drawEventCoffeeProc.asp",
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
    $rootEl.empty();

    if(data != "") {
        data.forEach(function(winner){
            tmpEl = '<div class="swiper-slide">\
                <div class="winner-info"><div class="winner-name">' + printUserName(winner.userid, 2, "*") + '</div><span class="prize">' +numberWithCommas(winner.sub_opt2)+ '원</span></div>\
            </div>\
            '
            itemEle += tmpEl
        });
    } else {
        itemEle = '<div class="swiper-slide">\
            <div class="winner-info"><div class="winner-name">아직 당첨자가 없습니다!</div></div>\
        </div>\
        '
    }
    $rootEl.append(itemEle)

    if($(".winner-list .swiper-slide").length > 1){
        var swiperWinner = new Swiper('.winner-list ', {
            direction:'vertical',
            loop:true,
            speed:800,
            autoplay:900
        });
    }
}

function fnPriceCal(p) {
    var coffeeCntPrice;
    coffeeCntPrice = p*5000
    coffeeCntPrice = numberWithCommas(coffeeCntPrice);
    $("#coffeeCntVal").val(p);
    $("#coffeePrice").empty().html(coffeeCntPrice);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function popupCoffeeClose(p) {
    $("#lyrResult").hide();
    $("#"+p).hide();
}
</script>
<%'<!-- 커피이벤트 -->%>
<div class="mEvt102578 evt-coffee">
    <%'<!-- 상단 -->%>
    <%
        '// 커피 노출 일자 정리
		'name:아이스 아메리카노, vodCode:957 // 5/18, 5/23
		'name:아이스 라떼, vodCode:958, // 5/19, 5/24
		'name:아이스 모카 라떼, vodCode:959, // 5/20, 5/25
		'name:블루 레몬 에이드, vodCode:960, // 5/21, 5/26
		'name:아이스 녹차 라떼, vodCode:961 // 5/22, 5/27
        Dim data_coffee_code, data_coffee_name
        Select Case currentDate
            Case "2020-05-18","2020-05-23"
                data_coffee_code = "0"
                data_coffee_name = "아이스 아메리카노"
            Case "2020-05-19","2020-05-24"
                data_coffee_code = "1"
                data_coffee_name = "아이스 라떼"
            Case "2020-05-20","2020-05-25"
                data_coffee_code = "2"
                data_coffee_name = "아이스 모카 라떼"
            Case "2020-05-21","2020-05-26"
                data_coffee_code = "3"
                data_coffee_name = "블루 레몬 에이드"                
            Case "2020-05-22","2020-05-27"
                data_coffee_code = "4"
                data_coffee_name = "아이스 녹차 라떼"                
            Case Else
                data_coffee_code = "0"
        End Select
    %>
    <%'<!-- 오픈 되는 커피에 따라 순차적으로 [data-coffee-code] 의 값을 0 ~ 4 할당 해주세요 -->%>
    <div class="section topic" data-coffee-code="<%=data_coffee_code%>">
        <h2>
            <span class="t t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_coffee1.png" alt="시원한 커피 이벤트"></span>
            <span class="t t2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_coffee2.png" alt="마시고"></span>
            <span class="t t3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_coffee3.png" alt="싶은 만큼"></span>
            <span class="t t4"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_coffee4.png" alt="응모하세요!"></span>
        </h2>
        <div class="vod-wrap">
            <video preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" playsinline poster="" class="vod-coffee">
                <source src="" type="video/mp4">
            </video>
        </div>
        <i class="scroll"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_scroll.png" alt=""></i>
    </div>

    <%'<!-- 이벤트 안내 -->%>
    <div class="section section-gift"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/txt_gift_v2.jpg" alt="무려 10명에게 스타벅스 기프트카드를 선물합니다"></div>

    <%'<!-- 응모 -->%>
    <div class="section section-apply">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/txt_apply.png" alt="정말 원하는 만큼 담아보세요!"></p>
        <div class="thumb-coffe"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_coffee<%=data_coffee_code+1%>.jpg" alt="응모하기"></div>
        <div class="info">
            <div class="name"><%=data_coffee_name%></div>
            <div class="wrap">
                <div class="prize"><span id="coffeePrice">5,000</span>원</div>
                <select name="coffeeCnt" id="coffeeCnt" onchange="fnPriceCal(this.value);">
                    <% for coffeeNumber = 0 to 99 %>
                        <option value="<%=coffeeNumber+1%>" <% if coffeeNumber+1=1 Then %>selected<% End If %>><%=coffeeNumber+1%></option>
                    <% next %>
                </select>
            </div>
        </div>
        <button class="btn-apply" onclick="eventTry('<%=data_coffee_code%>');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/btn_apply.png" alt="응모하기"></button>
    </div>

    <%'<!-- 팝업레이어:응모결과 -->%>
    <div class="lyr" id="lyrResult" style="display:none;">
        <%'<!-- 결과:당첨 -->%>
        <div class="result lyr-win" id="winnerPopup" style="display:none;">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_win.png" alt="축하합니다! 응모한 금액에 당첨되었습니다">
            <%' <!-- 응모한 금액 --> %>
            <p class="prize"><span id="prizePrice"></span><span>원</span></p>
            <button class="btn-close" onclick="popupCoffeeClose('winnerPopup');return false;">닫기</button>
        </div>

        <%'<!-- 결과:1차 꽝 -->%>
        <div class="result" id="fail1" style="display:none;">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_fail_1.png" alt="아쉽게도 당첨되지 않았습니다..">
            <button class="btn-share btn-fb" onclick="sharesns('fb');return false;">페이스북 공유</button>
            <button class="btn-share btn-kakao" onclick="sharesns('ka');return false;">카카오톡 공유</button>
            <button class="btn-close" onclick="popupCoffeeClose('fail1');return false;">닫기</button>
        </div>

        <%'<!-- 결과:공유 X -> 2차응모 -->%>
        <div class="result" id="secondTry" style="display:none;">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_already.png" alt="이미 1회 응모하였습니다">
            <button class="btn-share btn-fb" onclick="sharesns('fb');return false;">페이스북 공유</button>
            <button class="btn-share btn-kakao" onclick="sharesns('ka');return false;">카카오톡 공유</button>
            <button class="btn-close" onclick="popupCoffeeClose('secondTry');return false;">닫기</button>
        </div>

        <% If currentDate>="2020-05-27" Then %>
            <%'<!-- 결과:2차 꽝 (마지막날) -->%>
            <div class="result" id="fail2" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_fail_2_last.png" alt="아쉽게도 당첨되지 않았습니다.. 응모해주셔서 감사합니다">
                <button class="btn-close" onclick="popupCoffeeClose('fail2');return false;">닫기</button>
            </div>
        <% Else %>
            <%'<!-- 결과:2차 꽝 -->%>
            <div class="result" id="fail2" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_fail_2.png" alt="아쉽게도 당첨되지 않았습니다.. 내일 다시 도전해보세요!">
                <button class="btn-close" onclick="popupCoffeeClose('fail2');return false;">닫기</button>
            </div>
        <% End If %>

        <% If currentDate>="2020-05-27" Then %>
            <%'<!-- 결과:3차 응모 시도 (마지막날) -->%>
            <div class="result" id="trylimit" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_next_last.png" alt="오늘의 응모는 모두 완료! 응모해주셔서 감사합니다:)">
                <button class="btn-close" onclick="popupCoffeeClose('trylimit');return false;">닫기</button>
            </div>
        <% Else %>
            <%'<!-- 결과:3차 응모 시도 -->%>
            <div class="result" id="trylimit" style="display:none;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/pop_next.png" alt="오늘의 응모는 모두 완료! 내일 또 도전해주세요:)">
                <button class="btn-close" onclick="popupCoffeeClose('trylimit');return false;">닫기</button>
            </div>
        <% End If %>
    </div>

    <%'<!-- 당첨자 -->%>
    <div class="section section-winner">
        <p class="tit-winner"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_winner.png" alt="당첨자"></p>
        <div class="winner-list swiper-container">
            <div class="swiper-wrapper" id="winners"></div>
        </div>
    </div>

    <%'<!-- 유의사항 -->%>
    <div class="section section-noti">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/txt_noti_v2.png" alt="이벤트 유의사항">
    </div>

    <%'<!-- sns 공유 -->%>
    <%'<!-- 카카오 공유 이미지 http://webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_kakao.jpg -->%>
    <div class="section section-sns">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_sns.png" alt="공유하기">
        <button class="btn-share btn-fb" onclick="sharesns('fb');return false;">페이스북 공유</button>
        <button class="btn-share btn-kakao" onclick="sharesns('ka');return false;">카카오톡 공유</button>
    </div>

    <%'<!-- 컵리스트 -->%>
    <div class="section section-cups">
        <h3>
            <a href="/category/category_itemPrd.asp?itemid=2412114&pEtr=102578" onclick="TnGotoProduct('2412114');return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/tit_cups.png" alt="커피는 유리컵에 마셔야 제맛! 나만의 유리컵을 찾아보세요">
            </a>
        </h3>
        <div class="set-wrap">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_cup_set1.jpg?v=1.00" alt="">
            <div class="set">
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2038134&pEtr=102578" onclick="TnGotoProduct('2038134');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2367572&pEtr=102578" onclick="TnGotoProduct('2367572');return false;" class="sm-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2766821&pEtr=102578" onclick="TnGotoProduct('2766821');return false;" class="lg-thumb"></a>
                </div>
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2364763&pEtr=102578" onclick="TnGotoProduct('2364763');return false;" class="lg-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=1817153&pEtr=102578" onclick="TnGotoProduct('1817153');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2248051&pEtr=102578" onclick="TnGotoProduct('2248051');return false;" class="sm-thumb"></a>
                </div>
                <div class="column column1">
                    <a href="/category/category_itemPrd.asp?itemid=2850644&pEtr=102578" onclick="TnGotoProduct('2850644');return false;"></a>
                </div>
            </div>
        </div>
        <div class="set-wrap">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_cup_set2.jpg?v=1.00" alt="">
            <div class="set">
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2660991&pEtr=102578" onclick="TnGotoProduct('2660991');return false;" class="lg-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2135846&pEtr=102578" onclick="TnGotoProduct('2135846');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2364766&pEtr=102578" onclick="TnGotoProduct('2364766');return false;" class="sm-thumb"></a>
                </div>
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2770780&pEtr=102578" onclick="TnGotoProduct('2770780');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2754607&pEtr=102578" onclick="TnGotoProduct('2754607');return false;" class="sm-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2837080&pEtr=102578" onclick="TnGotoProduct('2837080');return false;" class="lg-thumb"></a>
                </div>
                <div class="column column1">
                    <a href="/category/category_itemPrd.asp?itemid=2767303&pEtr=102578" onclick="TnGotoProduct('2767303');return false;"></a>
                </div>
            </div>
        </div>
        <div class="set-wrap">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/img_cup_set3.jpg?v=1.00" alt="">
            <div class="set">
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2746421&pEtr=102578" onclick="TnGotoProduct('2746421');return false;" class="lg-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2778465&pEtr=102578" onclick="TnGotoProduct('2778465');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2756880&pEtr=102578" onclick="TnGotoProduct('2756880');return false;" class="sm-thumb"></a>
                </div>
                <div class="column column2">
                    <a href="/category/category_itemPrd.asp?itemid=2723744&pEtr=102578" onclick="TnGotoProduct('2723744');return false;" class="mid-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=893699&pEtr=102578" onclick="TnGotoProduct('893699');return false;" class="sm-thumb"></a>
                    <a href="/category/category_itemPrd.asp?itemid=2538605&pEtr=102578" onclick="TnGotoProduct('2538605');return false;" class="lg-thumb"></a>
                </div>
                <div class="column column1">
                    <a href="/category/category_itemPrd.asp?itemid=2698820&pEtr=102578" onclick="TnGotoProduct('2698820');return false;"></a>
                </div>
            </div>
        </div>
        <div class="cup-event">
            <a href="/event/eventmain.asp?eventid=102178" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/bnr_cup_event.png" alt="유리컵 더 보실래요?"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102178');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102578/m/bnr_cup_event.png" alt="유리컵 더 보실래요?"></a>
        </div>
    </div>
</div>
<input type="hidden" name="coffeeCntVal" id="coffeeCntVal" value="1">
<%'<!--// 커피이벤트 -->%>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
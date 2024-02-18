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
' Description : 19주년 이벤트 - 왖챠 제휴 이벤트 - 방구석 영화관
' History : 2020.09.28 이종화
'####################################################
dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent , currentDateTime
dim isParticipation
dim numOfParticipantsPerDay, i
dim mktTest : mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "103235"
	moECode = "103236"
Else
	eCode = "106206"
	moECode = "106205"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-10-07")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-18")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

'// 테스트용 셋팅
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
	'// 테스트용 파라메터 
    if requestCheckVar(request("testCheckDate"),40) = "" then 
        currentDate = date()
    else
        currentDate = requestCheckVar(request("testCheckDate"),40)
        currentDateTime = right(currentDate,5)
        currentDate = Cdate(left(currentDate,10))
    end if 
    mktTest = true
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
	isSecondTried = pwdEvent.isParticipationDayBase(2)  '당일 응모 내역 체크
	isFirstTried = pwdEvent.isParticipationDayBase(1)   '당일 응모 내역 체크
	isShared = pwdEvent.isSnsShared     '이벤트 공유여부 확인
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

dim checkPrizeNumber , isPrize
Select Case currentDate
    Case "2020-10-07"
        if mktTest then 
            testChkWinPrizeNumber currentDateTime , "20:53", 30, isPrize
        else
            chkWinPrizeNumber "20:53", 30, isPrize
        end if 

        if isPrize then 
            checkPrizeNumber = 1 '// 꾸러미
        else
            checkPrizeNumber = 2 '// 1개월 이용권
        end if
    Case "2020-10-08"
        if mktTest then 
            testChkWinPrizeNumber currentDateTime, "12:39",  30, isPrize
        else
            chkWinPrizeNumber "12:39", 30, isPrize
        end if 

        if isPrize then 
            checkPrizeNumber = 1
        else
            checkPrizeNumber = 2
        end if
    Case "2020-10-12"
        if mktTest then 
            testChkWinPrizeNumber currentDateTime, "07:14", 30, isPrize
        else
            chkWinPrizeNumber "07:14", 30, isPrize
        end if
        
        if isPrize then 
            checkPrizeNumber = 1
        else
            checkPrizeNumber = 2
        end if
    Case "2020-10-14"
        if mktTest then 
            testChkWinPrizeNumber currentDateTime, "13:13", 30, isPrize
        else
            chkWinPrizeNumber "13:13", 30, isPrize
        end if 

        if isPrize then 
            checkPrizeNumber = 1
        else
            checkPrizeNumber = 2
        end if
    Case "2020-10-16"
        if mktTest then 
            testChkWinPrizeNumber currentDateTime, "16:42", 30, isPrize
        else
            chkWinPrizeNumber "16:42", 30, isPrize
        end if

        if isPrize then 
            checkPrizeNumber = 1
        else
            checkPrizeNumber = 2
        end if
    case else
        checkPrizeNumber = 2
End select

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐X왓챠 응모이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐X왓챠 응모이벤트]"
Dim kakaodescription : kakaodescription = "방구석 영화관 풀세트를 무료로 드립니다."
Dim kakaooldver : kakaooldver = "방구석 영화관 풀세트를 무료로 드립니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt106206 {position:relative; overflow:hidden;}
.mEvt106206 .topic {position:relative;}
.mEvt106206 .topic h2 {position:absolute; left:0; top:34.5%;}
.mEvt106206 .topic.on h2 {animation:fadeInDown 1.5s both ease-out;}
.mEvt106206 .gift {position:relative;}
.mEvt106206 .gift ul {display:flex; flex-wrap:wrap; position:absolute; top:29%; left:10vw; width:80vw;}
.mEvt106206 .gift li {width:40vw; height:43vw;}
.mEvt106206 .gift li a {display:block; width:100%; height:100%; font-size:0; color:transparent;}
.mEvt106206 button {background:none;}
.mEvt106206 .btn-try, .mEvt106206 .btn-notice, .mEvt106206 .btn-push {display:block; width:100%;}
.mEvt106206 .txt-notice {display:none;}
.mEvt106206 .notice, .mEvt106206 .winner {position:relative; background:#bdb9df;}
.mEvt106206 .winner-slider {padding:.5rem .5rem 0; text-align:center;}
.mEvt106206 .winner .swiper-slide {width:5.7rem; margin:0 .8rem; word-break:break-all;}
.mEvt106206 .winner .user-info > span {display:block;}
.mEvt106206 .winner .user-id {margin-top:.5em; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.02rem; color:#444;}
.mEvt106206 .winner .user-name {margin-top:.5em; font-size:.94rem; color:#666;}
.mEvt106206 .winner .no-winner {font-size:1.1rem;}
.mEvt106206 .btn-winner {display:flex; align-items:center; position:absolute; left:0; bottom:12vw; width:100%; padding:0 5%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.71rem; color:#000;}
.mEvt106206 .btn-winner.on::after {content:' '; display:inline-block; width:26.7vw; height:8vw; margin-left:.6rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/btn_winner.png) no-repeat 0 0 / contain;}
.mEvt106206 .lyr {display:none; position:fixed; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(255,255,255,.75);}
.mEvt106206 .lyr .inner {position:absolute; top:50%; left:50%; width:90%; transform:translate(-50%,-50%); background:#2a245e;}
.mEvt106206 .lyr .btn-close {position:absolute; right:0; top:0; width:15vw; height:15vw; font-size:0; color:transparent;}
.mEvt106206 .loadingV19 {position:absolute; top:50%; left:50%; padding:0; background:none; transform:translate(-50%,-50%);}
.mEvt106206 .loadingV19 i {background:rgba(255,255,255,.5);}
.mEvt106206 .loadingV19 i::before {background:rgba(255,255,255,.8);}
.mEvt106206 .loadingV19 p {font-size:1.37rem; color:#999;}
.mEvt106206 .winner-list {padding:0 5% 8%;}
.mEvt106206 .winner-list ol {overflow:hidden auto; max-height:50vw; display:flex; flex-wrap:wrap; justify-content:space-between; list-style-type:decimal-leading-zero; list-style-position:inside; text-align:left;}
.mEvt106206 .winner-list li {overflow:hidden; float:left; width:30%; font-family:'CoreSansCBold'; font-size:.85rem; line-height:2; color:#9f93ff; white-space:nowrap; text-overflow:ellipsis;}
.mEvt106206 .winner-list li span {font-family:'CoreSansCRegular'; font-size:1.11rem; color:#fff;}
@keyframes fadeInDown {
	0% {opacity:0; -webkit-transform:translate3d(0,-50%,0); transform:translate3d(0,-50%,0);}
	100% {opacity:1; -webkit-transform:none; transform:none;}
}
</style>
<script>
$(function() {
    $('.mEvt106206 .topic').addClass('on');
	$('.mEvt106206 .btn-notice').on('click', function() {
		$(this).next('.txt-notice').slideToggle();
	});
	// push
	$('.mEvt106206 #btnPush').on('click', function(e) {
		$('#lyrPush').fadeIn();
	});
	
	$('.mEvt106206 .btn-winner.on').on('click', function(e) {
		$('#lyrWinners').fadeIn();
	});
	// close popup
	$('.mEvt106206 .lyr .btn-close').on('click', function(e) {
		$(this).parent().parent().fadeOut();
		$('.loadingV19').remove();
	});
	$('.mEvt106206 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
		$('.loadingV19').remove();
    });
    
    getWinners();
});

function popLoading(lyr) {
	var loading = '<div class="loadingV19"><i></i><p>당첨 결과 확인 중</p></div>';
	lyr.children('.inner').hide();
	lyr.prepend(loading);
	lyr.fadeIn(function() {
		lyr.children('.inner').delay(1000).fadeIn();
	});
}

var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/RealtimeEventProc.asp",
		dataType: "JSON",
		data: { mode: "winner" },
		success : function(res){
			renderWinners(res.data)
		},
		error:function(err){
			alert("잘못된 접근 입니다.[0]");
			return false;
		}
	});
}

function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}

function renderWinners(data){
    var $rootEl = $("#winners");
    var $rootEl2 = $("#winners2");
    var $rootEl2Info = $("#winners2info");
    var itemEle = tmpEl = ""
    var itemEle2 = tmpEl2 = ""
    var itemWinners2Count = 0;
    $rootEl.empty();
    $rootEl2.empty();
    $rootEl2Info.empty();

	data.forEach(function(winner){
        // element 1
        if(winner.code == 1) {
            tmpEl = '<li class="swiper-slide">\
                        <div class="user-info">\
                            <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/' + winner.userlevelimg + '" alt=""></span>\
                            <span class="user-id">'+ printUserName(winner.userid, 2, "*") +'</span>\
                            <span class="user-name">'+ printUserName(winner.username, 1, "*") +'</span>\
                        </div>\
                    </li>\
            '
            itemEle += tmpEl
        }
        // element 2
        if(winner.code == 2) {
            tmpEl2 = '<li><span>'+ printUserName(winner.userid, 2, "*") +'</span></li>'
            itemEle2 += tmpEl2
            itemWinners2Count += 1
        }
    });
    
    $rootEl.append(itemEle);
    $rootEl2.append(itemEle2);
    
    if (itemWinners2Count > 0) {
        $rootEl2Info.append('<button type="button" class="btn-winner on" title="2등 당첨자 확인하기" onclick="winnerpop()">현재까지 '+ itemWinners2Count +'명 당첨</button>')
    } else {
        $rootEl2Info.append('<button type="button" class="btn-winner" disabled="disabled">현재까지 0명 당첨</button>')
    }

	// winner
	if ($('#winners').children('li').length < 1) {
		$('.winner-slider').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	} else {
        var swiper = new Swiper('.winner-slider', {
			slidesPerView: 'auto'
		});
    }
}

function winnerpop() {
    $("#lyrWinners").fadeIn()
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
    <% else %>
        popLoading($('#lyrWin1'));
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s = <%=checkPrizeNumber%>;
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			$('#trylimit').show();
			return false;
		}
//=============		
		var returnCode, itemid, data
		var data = {
			mode : "add",
            selectedPdt : s,
            <% if mktTest then %>
            testCheckDate : "<%=requestCheckVar(request("testCheckDate"),40)%>",
            testPercent : "<%=requestCheckVar(request("testPercent"),3)%>"
            <% end if %>
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/RealtimeEventProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt, res.md5userid);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다[0].");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다[1].");
				return false;
			}
		});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
            popLoading($("#result"));
			return false;
		}
		popLoading($("#fail1"));
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
        if(selectedPdt == 1) {
            popLoading($("#winnerPopup1"));
        } else {
            popLoading($("#winnerPopup2"));
        }
	}else if(returnCode == "A02"){
		numOfTry = 2
        popLoading($("#trylimit"));
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/RealtimeEventProc.asp",
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

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/RealtimeEventProc.asp?mode=pushadd",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $('#lyrPush').fadeIn();
                return false;
            }else{
                alert(result.faildesc);
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    });
}
</script>
<div class="mEvt106206">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/bg_topic.jpg" alt="">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/tit_watcha.png" alt="방구석 영화관"></h2>
    </div>
    <div class="gift">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/img_gift_01.jpg" alt="1등 상품">
        <ul>
            <li></li>
            <li><a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2952998&pEtr=106206');return false;">스누피 이불</a></li>
            <li><a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1370223&pEtr=106206');return false;">암막 커튼</a></li>
            <li><a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1804104&pEtr=106206');return false;">빔프로젝터</a></li>
            <li><a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1859658&pEtr=106206');return false;">팝콘 메이커</a></li>
            <li><a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2565251&pEtr=106206');return false;">수면 양말</a></li>
        </ul>
    </div>
    <button type="button" class="btn-try" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/img_gift_02.jpg" alt="2등 상품"></button>
    <div class="notice">
        <button type="button" class="btn-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/btn_notice.png" alt="이벤트 개요"></button>
        <p class="txt-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/txt_notice.png" alt="유의사항"></p>
    </div>

    <%'1등 당첨 리스트 %>
    <div class="winner">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/tit_grade_01.png" alt="1등 당첨자"></h3>
		<div class="winner-slider swiper-container">
            <ul class="swiper-wrapper" id="winners"></ul>
        </div>
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/tit_grade_02.png" alt="2등 당첨자"></h3>
        <div id="winners2info"></div>
    </div>

    <%'2등 당첨 리스트%>
    <div id="lyrWinners" class="lyr" style="display:none;">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_winner.png" alt="2등 당첨자">
            <div class="winner-list">
                <ol id="winners2"></ol>
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>

    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/txt_watcha.jpg" alt="WATCHA"></p>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/img_watcha.jpg" alt="상영 예정작"></p>

    <button type="button" id="btnPush" onclick="jsPickingUpPushSubmit()" class="btn-push">
        <% '<!-- 알림 신청 마지막날 --> %>
        <% If currentDate >= eventEndDate Then %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/btn_push_last.jpg" alt="다음 이벤트 알림 신청하기">
        <% '<!-- 알림 신청 --> %>
        <% else %>
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/btn_push.jpg" alt="내일 응모 알림 신청하기">
        <% end if %>
    </button>

    <% '<!-- 팝업 : 당첨(방구석 영화관 세트) --> %>
    <div id="winnerPopup1" class="lyr" style="display:none">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_win_01.png" alt="방구석 영화관 세트 당첨">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <% '<!-- 팝업 : 당첨(왓챠 이용권) --> %>
    <div id="winnerPopup2" class="lyr" style="display:none">
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_win_02.png" alt="왓챠 이용권 당첨">
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <% '<!-- 팝업 : 꽝1 --> %>
    <div id="fail1" class="lyr" style="display:none">
        <div class="inner">
            <% '<!-- 카카오톡 공유 --> %>
            <button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_fail1.png" alt="꽝1"></button>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <% '<!-- 팝업 : 공유 안하고 재응모 --> %>
    <div id="secondTry" class="lyr" style="display:none">
        <div class="inner">
            <% '<!-- 카카오톡 공유 --> %>
            <button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_already.png" alt="이미 1회응모"></button>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    
    <div id="result" class="lyr" style="display:none">
        <% '<!-- 팝업 : 꽝2 마지막날 --> %>
        <% If currentDate >= eventEndDate Then %>
        <div class="inner">
            <a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_fail2_last.png" alt="꽝2">
            </a>
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% '<!-- 팝업 : 꽝2 --> %>
        <% else %>
        <div class="inner">
            <a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_fail2.png" alt="꽝2">
            </a>
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% end if %>
    </div>

    <div id="trylimit" class="lyr" style="display:none">
        <% '<!-- 팝업 : 응모 횟수 초과 마지막날 --> %>    
        <% If currentDate >= eventEndDate Then %>
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_fin_last.png" alt="끝">
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% '<!-- 팝업 : 응모 횟수 초과 --> %>
        <% else %>
        <div class="inner">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_fin.png" alt="내일">
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% end if %>
    </div>
    
    <div id="lyrPush" class="lyr" style="display:none">
        <% '<!-- 팝업 : 푸시 신청 완료 마지막날 --> %>
        <% If currentDate >= eventEndDate Then %>
        <div class="inner">
            <button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_push_last.png" alt="푸시 설정 확인하기"></button>
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% else %>
        <% '<!-- 팝업 : 푸시 신청 완료 --> %>
        <div class="inner">
            <button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106206/m/pop_push.png" alt="푸시 설정 확인하기"></button>
            <button type="button" class="btn-close">닫기</button>
        </div>
        <% end if %>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
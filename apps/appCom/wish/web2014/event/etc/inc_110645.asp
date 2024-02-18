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
' Description : 2021 이상형 월드꽃
' History : 2021-04-08 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104346"
	moECode = "104345"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "110645"
	moECode = "110644"
    mktTest = True
Else
	eCode = "110645"
	moECode = "110644"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-04-12")		'이벤트 시작일
eventEndDate 	= cdate("2021-04-21")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-04-12")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("나의 이상형 꽃은?")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "나의 이상형 꽃은?"
Dim kakaodescription : kakaodescription = "지금 테스트해보세요! 진짜 꽃을 무료로 보내드립니다."
Dim kakaooldver : kakaooldver = "지금 테스트해보세요! 진짜 꽃을 무료로 보내드립니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim subscriptcount
if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
end if

%>
<style>
.mEvt110645 .topic {position:relative;}
.mEvt110645 .topic .btn-start {position:absolute; left:50%; top:63%; transform:translate(-50%,0); width:84vw; height:10rem; background:transparent;}
.mEvt110645 .topic .btn-share {position:absolute; left:50%; top:81%; transform:translate(-50%,0); width:34vw; height:10rem; background:transparent;}
.mEvt110645 .sec-event {position:relative;}
.mEvt110645 .sec-event .event-contents {position:absolute; left:0; top:38%; display:flex; justify-content:space-between; width:100%; padding:0 8vw;}
.mEvt110645 .sec-event .event-contents button {background:transparent;}
.mEvt110645 .sec-event .event-contents button img {width:36.4vw; height:60.13vw;}
.mEvt110645 .sec-event .count-num {position:absolute; left:50%; top:79%; transform:translate(-50%,0); color:#797572; font-size:1.30rem;}
.mEvt110645 .sec-event .btn-prev {position:absolute; left:50%; top:88%; transform:translate(-50%,0); width:11.2vw; background:transparent;}
.mEvt110645 .sec-result {position:relative;}
.mEvt110645 .sec-result .btn-apply {position:absolute; left:50%; top:65%; transform:translate(-50%,0); width:84vw; height:10rem; background:transparent;}
.mEvt110645 .sec-result .btn-share {position:absolute; left:50%; top:81%; transform:translate(-97%,0); width:35vw; height:10rem; background:transparent;}
.mEvt110645 .sec-result .btn-again {position:absolute; left:50%; top:81%; transform:translate(5%,0); width:35vw; height:10rem; background:transparent;}
.mEvt110645 .sec-result h2 {position:absolute; left:50%; top:7%; transform:translate(-50%,10%); width:66.13vw; transition:all 1s; opacity:0;}
.mEvt110645 .sec-result.on h2.animate {transform:translate(-50%,0); opacity:1;}
.mEvt110645 .sec-result .user-info {position:absolute; left:50%; top:22.5%; transform:translate(-50%,0); width:100%; text-align:center; font-size:1.52rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#797572;}
.mEvt110645 .sec-result .user-info .type-img {width:33.66vw; margin:0 auto; padding-top:8.26rem; transform:translateY(10%); transition:all 1s .5s; opacity:0;}
.mEvt110645 .sec-result.on .user-info .type-img.animate03 {transform:translateY(0); opacity:1; animation: zoom 1s .5s ease;}
.mEvt110645 .sec-result .user-info .txt-info {position:relative; transform:translateY(10%); transition:all 1s .3s; opacity:0;}
.mEvt110645 .sec-result.on .user-info .txt-info.animate02 {transform:translateY(0); opacity:1;}
.mEvt110645 .sec-result .user-info .txt-info span {position:absolute; left:50%; top:0; transform:translate(-50%,0); display:inline-block; width:100%; z-index:10;}
.mEvt110645 .sec-result .user-info .txt-info em {position:relative; z-index:10;}
.mEvt110645 .sec-result .user-info .txt-info em::before {content:""; position:absolute; left:0; top:9px; width:100%; height:1.5rem; background:#fdbda8; z-index:-1;}
.mEvt110645 .sec-result .user-info .txt-info.txt02 span {padding-top:2.7rem;}
.mEvt110645 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; z-index:150;}
.mEvt110645 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt110645 .pop-container .pop-inner a {display:inline-block;}
.mEvt110645 .pop-container .pop-inner .btn-close {position:absolute; right:3.5rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110645/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt110645 .pop-container.done .pop-contents {position:relative;}
.mEvt110645 .pop-container.done .user-name {position:absolute; left:50%; top:13.5%; transform:translate(-95%,0); font-size:2.80rem; color:#ff865c; font-family:'CoreSansCBold','AppleSDGothicNeo-Bold','NotoSansKRBold';}
.mEvt110645 .pop-container.done .kakao-share {position:absolute; left:0; bottom:0; width:100%; height:14rem; background:transparent;}
.mEvt110645 .pop-container.win .type-img {position:absolute; left:50%; top:37%; transform:translate(-50%,0); width:23.66vw;}
.mEvt110645 .pop-container.win .pop-contents {position:relative;}
.mEvt110645 .pop-container.win .btn-push {width:100%; height:10rem; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt110645 .pop-container.alram .pop-contents {position:relative;}
.mEvt110645 .pop-container.alram .btn-info {width:100%; height:13rem; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt110645 .pop-background {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color: rgb(0, 0, 0); opacity: 0.702; z-index:100;}
@keyframes zoom {
    0% {transform: scale(0);}
    100% {transform: scale(1);}
}
</style>
<script>
var _tournamentObj = [1,2,3,4,5,6];
var _tournamentObjName = ["자그마한 스타티스","매혹적인 라넌큘러스","뚝심있는 해바라기","장난꾸러기 튤립","예민한 장미","살벌한 프리지아"];
var _flowerName = ["스타티스","라넌큘러스","해바라기","튤립","장미","프리지아"];
var _tournamentWin = [];
var _tournamentHistory = [];
var _tournamentRound = 1;
$(function(){
    /* 팝업 닫기 */
    $('.mEvt110645 .btn-close').click(function(){
        $(".pop-container").fadeOut();
        $('.pop-background').fadeOut();
    })
    _tournamentObj.sort(function(a, b) {
        return .5 - Math.random();
    });
});

function doStartTournament() {
    var tmpEl = "";
    $("#start").hide();
    $("#tournament").show();
    tmpEl = `
            <button type="button" onClick="fnSelectFlower(`+_tournamentObj[0]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[0]+ `.png" alt="` + _tournamentObjName[_tournamentObj[0]-1] + `"></button>
            <button type="button" onClick="fnSelectFlower(`+_tournamentObj[1]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[1]+ `.png" alt="` + _tournamentObjName[_tournamentObj[1]-1] + `"></button>
            `
    $("#flowerdiv").append(tmpEl);
}

function fnSelectFlower(obj,taget){
    var tmpEl = "";
    if(_tournamentRound<4&&taget!='b'){
        _tournamentWin.push(obj);
    }
    if(_tournamentRound==1){
        tmpEl = `
                <button type="button" onClick="fnSelectFlower(`+_tournamentObj[2]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[2]+ `.png" alt="` + _tournamentObjName[_tournamentObj[2]-1] + `"></button>
                <button type="button" onClick="fnSelectFlower(`+_tournamentObj[3]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[3]+ `.png" alt="` + _tournamentObjName[_tournamentObj[3]-1] + `"></button>
                `
        $("#flowerdiv").empty().append(tmpEl);
    }else if(_tournamentRound==2){
        tmpEl = `
                <button type="button" onClick="fnSelectFlower(`+_tournamentObj[4]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[4]+ `.png" alt="` + _tournamentObjName[_tournamentObj[4]-1] + `"></button>
                <button type="button" onClick="fnSelectFlower(`+_tournamentObj[5]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentObj[5]+ `.png" alt="` + _tournamentObjName[_tournamentObj[5]-1] + `"></button>
                `
        $("#flowerdiv").empty().append(tmpEl);
    }else if(_tournamentRound==3){
        tmpEl = `
                <button type="button" onClick="fnSelectFlower(`+_tournamentWin[0]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentWin[0]+ `.png" alt="` + _tournamentObjName[_tournamentWin[0]-1] + `"></button>
                <button type="button" onClick="fnSelectFlower(`+_tournamentWin[1]+`,'');"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentWin[1]+ `.png" alt="` + _tournamentObjName[_tournamentWin[1]-1] + `"></button>
                `
        $("#flowerdiv").empty().append(tmpEl);
    }else if(_tournamentRound==4){
        var i=0;
        while (i<_tournamentWin.length){
            _tournamentHistory.push(_tournamentWin[i]);
            i=i+1;
        }
        if(obj==_tournamentWin[0]){
            _tournamentWin.splice(1,1);
        }else{
            _tournamentWin.splice(0,1);
        }
        tmpEl = `
                <button type="button" onClick="doEndTournament(`+_tournamentWin[0]+`);"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentWin[0]+ `.png" alt="` + _tournamentObjName[_tournamentWin[0]-1] + `"></button>
                <button type="button" onClick="doEndTournament(`+_tournamentWin[1]+`);"  class="btn-select"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_0` +_tournamentWin[1]+ `.png" alt="` + _tournamentObjName[_tournamentWin[1]-1] + `"></button>
                `
        $("#flowerdiv").empty().append(tmpEl);
    }
    ++_tournamentRound;
    $("#tournamentRound").html(_tournamentRound);
    if(_tournamentRound==4){
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_02.jpg');
    }else if(_tournamentRound==5){
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_03.jpg');
    }else{
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_01.jpg');
    }
}

function doEndTournament(obj) {
    var tmpEl = "";
    $("#tournament").hide();
    $("#result").show();
    $("#result").addClass("on");
    tmpEl = `
            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_0`+obj+`.png?v=1.01" alt="`+_tournamentObjName[obj-1]+`">
            `
    $("#resultflower").append(tmpEl);
    $("#resultflowerName").html(_flowerName[obj-1]);
    $("#flowernum").val(obj);
}

function fnTournamentBack(){
    if(_tournamentRound==4){
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_02.jpg');
    }else if(_tournamentRound==5){
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_03.jpg');
    }else{
        $("#tournamentIMG").attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_01.jpg');
    }
    if(_tournamentRound==1){
        _tournamentRound=1;
        _tournamentWin=[];
        _tournamentHistory = [];
        $("#flowerdiv").empty();
        $("#start").show();
        $("#tournament").hide();
        return false;
    }
    if(_tournamentRound==2){
        _tournamentRound=1;
        _tournamentWin.pop();
        $("#tournamentRound").html(_tournamentRound);
        $("#flowerdiv").empty();
        doStartTournament();
    }else if(_tournamentRound<5){
        _tournamentWin.pop();
        _tournamentRound=_tournamentRound-2;
        $("#tournamentRound").html(_tournamentRound);
        fnSelectFlower(_tournamentWin[_tournamentWin.length-1],'b');
    }else{
        _tournamentWin.pop();
        _tournamentWin.pop();
        var i=0;
        while (i<_tournamentHistory.length){
            _tournamentWin.push(_tournamentHistory[i]);
            i=i+1;
        }
        _tournamentRound=_tournamentRound-2;
        $("#tournamentRound").html(_tournamentRound);
        fnSelectFlower(_tournamentWin[_tournamentWin.length-1],'b');
    }
}

function doAction() {
    var tmpEl = "";
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
	<% If IsUserLoginOK() Then %>
		<% if subscriptcount > 0 then %>
            $('.pop-container.done').fadeIn();
            $('.pop-background').fadeIn();
			return false;
        <% else %>
            $.ajax({
                type: "POST",
                url:"/event/etc/doeventsubscript/doEventSubScript110645.asp",
                data: {
                    mode : 'add',
                    flowernum : $("#flowernum").val()
                },
                dataType: "JSON",
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option','<%=eCode%>|'+$("#flowernum").val());
                        $('.pop-container.win').fadeIn();
                        $('.pop-background').fadeIn();
                        tmpEl = `
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_0`+$("#flowernum").val()+`.png" alt="">
                                `
                        $("#loadflower").append(tmpEl);
                    }else{
                        alert(data.message);
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.');
                }
            });
		<% end if %>
	<% else %>
        parent.calllogin();
        return false;
	<% End If %>
}

function snschk(snsnum) {		
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

function fnFlowerSelectReset(){
    document.location.reload();
}

function fnPushSubmit(){
    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');
    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>
    $.ajax({
        type:"GET",
        url:"/event/etc/doeventsubscript/doEventSubScript110645.asp?mode=pushadd&evt_code=<%=eCode%>",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                $('.pop-container.alram').fadeIn();
                $('.pop-background').fadeIn();
                $('.pop-container.win').fadeOut();
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
			<div class="mEvt110645">
                <!-- main 시작 페이지 -->
                <div class="topic" id="start">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_main.jpg?v=1.01" alt="이상형 월드꽃">
                    <!-- 시작하기 버튼 -->
                    <button type="button" class="btn-start" onClick="doStartTournament();"></button>
                    <!-- 카카오 공유하기 버튼 -->
                    <button type="button" class="btn-share" onclick="snschk('ka');"></button>
                </div>

                <!-- event 페이지 -->
                <div class="sec-event" id="tournament" style="display:none">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_event_main_01.jpg?v=2.1" id="tournamentIMG" alt="하나만 선택해주세요!">
                    <!-- 꽃 선택 영역 -->
                    <div class="event-contents" id="flowerdiv"></div>
                    <div class="count-num">
                        <span id="tournamentRound">1</span> / <span>5</span>
                    </div>
                    <!-- 뒤로 가기 버튼 -->
                    <button type="button" class="btn-prev" onClick="fnTournamentBack();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/btn_prev.png" alt="뒤로"></button>
                </div>

                <!-- 결과 페이지 -->
                <div class="sec-result" id="result" style="display:none">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_result_main.jpg" alt="응모 후 당첨되면 선택한 꽃이 배달됩니다.">
                    <h2 class="animate"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/tit_result.png" alt="음..제 생각에는요"></h2>
                    <!-- 고객 성함, 최종 꽃 이름, 선택한 꽃 이미지 노출 -->
                    <div class="user-info">
                        <div class="txt-info animate02"><span><em><%=GetLoginUserName()%></em> 님은...</span></div>
                        <div class="txt-info txt02 animate02"><span><em id="resultflowerName">프리지아</em> 를 좋아하는 사람입니다!</span></div>
                        <div class="type-img animate03" id="resultflower"></div><input type="hidden" id="flowernum">
                    </div>
                    <!-- 응모하기 버튼 -->
                    <button type="button" class="btn-apply" onclick="doAction();"></button>
                    <!-- 카카오 공유하기 버튼 -->
                    <button type="button" class="btn-share" onclick="fnFlowerSelectReset();return false;"></button>
                    <!-- 꽃 다시 고르기 버튼 -->
                    <button type="button" class="btn-again" onclick="snschk('ka');"></button>
                </div>

                <!-- 유의사항 -->
                <div class="section-noti">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_noti.jpg?v=1.02" alt="유의사항을 꼭 확인해주세요!">
                    <!-- 텐바이텐 인스타그램 이동 -->
                    <a href="https://www.instagram.com/explore/tags/텐바이텐이벤트당첨" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_sns.jpg" alt="당첨자이신가요?"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/explore/tags/텐바이텐이벤트당첨'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_sns.jpg" alt="당첨자이신가요?"></a>
                    <!-- 알림신청 -->
                    <button type="button" class="btn-push" onclick="fnPushSubmit();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_push.jpg?v=1.02" alt="알림신청"></button>
                </div>
                
                <!-- 팝업 - 응모 완료 -->
                <div class="pop-container win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/pop_win.png" alt="응모가 완료되었습니다.">
                            <!-- 선택한 꽃 이미지 -->
                            <div class="type-img" id="loadflower"></div>
                            <!-- 당첨자 발표 알림받기 버튼 -->
                            <button type="button" class="btn-push" onclick="fnPushSubmit();"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 응모 후 재클릭 -->
                <div class="pop-container done">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <!-- 고객성함 노출 -->
                            <div class="user-name"><%=GetLoginUserName()%></div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/pop_done.png?v=1.02" alt="이미 응모되었어요!">
                            <!-- 카카오 공유하기 -->
                            <button type="button" class="kakao-share" onclick="snschk('ka');"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 알림 받기 클릭시 -->
                <div class="pop-background"></div>
                <div class="pop-container alram">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/pop_push.png" alt="발표 알림이 신청되었습니다.">
                            <!-- 푸시 수신 여부확인 버튼 -->
                            <button type="button" class="btn-info" onclick="fnAPPpopupSetting();return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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
dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "103224"
	moECode = "103223"
Else
	eCode = "105709"
	moECode = "105708"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-09-14")		'이벤트 시작일
eventEndDate 	= cdate("2020-09-20")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

'if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
'	currentDate = #09/14/2020 09:00:00#
'end if

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

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐X데일리라이크]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐X데일리라이크]"
Dim kakaodescription : kakaodescription = "경품이 가득한 보따리의 주인을 찾고 있어요! 서둘러 확인해보세요."
Dim kakaooldver : kakaooldver = "경품이 가득한 보따리의 주인을 찾고 있어요! 서둘러 확인해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt105709 button {display:block; width:100%; background:transparent;}

.topic {position:relative;}
.topic #top-slide {position:absolute; left:12.5%; top:30.25%; width:74.67%;}

.items {background:#ffc9ae;}
.items .link {position:relative;}
.items .link a {position:absolute; font-size:0; color:transparent;}
.items .link a:nth-of-type(1) {left:10%; top:23%; width:29vw; height:45vw;}
.items .link a:nth-of-type(2) {left:33%; top:31%; width:13vw; height:17.5vw; z-index:5;}
.items .link a:nth-of-type(3) {left:53%; top:23%; width:37vw; height:36vw;}
.items .link a:nth-of-type(4) {left:43%; top:42%; width:45vw; height:26vw; z-index:5;}
.items .link a:nth-of-type(5) {left:45%; top:50%; width:20vw; height:16vw; z-index:10;}
.items .link a:nth-of-type(6) {left:11%; top:53%; width:12vw; height:41vw;}
.items .link a:nth-of-type(7) {left:25%; top:53%; width:17.8vw; height:42vw;}
.items .link a:nth-of-type(8) {left:46.5%; top:62%; width:20vw; height:23vw;}
.items .link a:nth-of-type(9) {left:69%; top:60%; width:18vw; height:27vw;}

.noti .btn-tgl {position:relative;}
.noti .btn-tgl:after {content:''; position:absolute; left:36.8%; top:64%; width:2.67vw; height:1.73vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105709/m/btn_arrow.png) no-repeat 50% 50% / 100% auto; transition:all .3s;}
.noti .txt-tgl {display:none;}
.noti.on .btn-tgl:after {transform:rotate(180deg);}
.noti.on .txt-tgl {display:block;}

.winner-list {position:relative; padding-bottom:10.67vw; color:#666; background-color:#fff;}
.winner-list .no-winner {display:flex; justify-content:center; align-items:center; font-size:3.5vw; padding-top:1vw;}
.winner-list .winner-slider {padding:0 1.7vw; text-align:center; font:normal 3.2vw/1.05 'CoreSansCRegular','NotoSansKRMedium';}
.winner-list .swiper-slide {width:22.4vw; padding-bottom:4.2vw;}
.winner-list .swiper-slide:after {content:'보따리 당첨'; position:absolute; left:0; bottom:0; width:100%; text-align:center; font-size:2.67vw;}
.winner-list .user-grade {position:relative; padding:0 2.27vw 1.9vw;}
.winner-list .user-id {white-space:nowrap;}
.winner-list .win-z.swiper-slide:after {content:'Z플립 당첨'; color:#222;}
.winner-list .win-z .user-grade:after {content:''; position:absolute; left:50%; top:63.3%; z-index:10; width:6.13vw; height:5.47vw; margin-left:-3vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_medal.png) no-repeat 50% 0 / 100% auto;}

.lookbook {overflow:hidden; background:#fff;}
.lookbook li {float:left; width:50%; opacity:0; transition:.5s; transform:translateY(30px);}
.lookbook li:nth-child(1),.lookbook li:nth-child(6),.lookbook li:nth-child(7) {width:100%;}
.lookbook li:nth-child(2),.lookbook li:nth-child(5) {transform:translateX(-30px);}
.lookbook li:nth-child(3),.lookbook li:nth-child(4) {transform:translateX(30px);}
.lookbook li.on {opacity:1; transform:translate(0,0);}

.lyr {position:fixed; top:0; left:0; z-index:10012; width:100%; height:100%; background:rgba(255,255,255,.75);}
.lyr .inner {position:absolute; top:50%; left:50%; width:89.3%; transform:translate(-50%,-50%);}
.lyr .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0;color:transparent;}

.mEvt105709 .loadingV19 {position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:none;}
.mEvt105709 .loadingV19 p {font-size:1.37rem; color:#999;}
</style>
<script>
$(function() {
	swiper = new Swiper('#top-slide', {
		autoplay:600,
		effect:'fade',
		speed:10
	});

    $('.btn-tgl').click(function (e) { 
        e.preventDefault();
        $('.noti').toggleClass('on');
    });

	// winner slider
     if ( $('#winner_slider').find('.swiper-slide').length > 0 ) {
		var swiper = new Swiper('#winner_slider', {
			slidesPerView: 'auto'
		});
	} else {
		//$('#winner_slider').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}

	// apply popup
	//$('.btn-apply').on('click', function(e) {
	//	$('#lyrWin').fadeIn();
	//});

	// push popup
	//$('.mEvt105709 #btnPush1').on('click', function(e) {
	//	$('#lyrPush1').fadeIn();
	//});
	//$('.mEvt105709 #btnPush2').on('click', function(e) {
	//	$('#lyrPush2').fadeIn();
	//});

	// close popup
	$('.mEvt105709 .lyr .btn-close').on('click', function(e) {
		$(this).parent().parent().fadeOut();
	});
	$('.mEvt105709 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr'))	$(e.target).fadeOut();
	});

    $(window).scroll(function(){
        $('.lookbook li').each(function(){
			var y = $(window).scrollTop() + $(window).height() * .9;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
});

function popLoading(lyr) {
	var loading = '<div class="loadingV19"><i></i><p>당첨 결과 확인 중</p></div>';
	lyr.children('.inner').hide();
	lyr.prepend(loading);
	lyr.fadeIn(function() {
		lyr.children('.inner').delay(1000).fadeIn();
	});
}

var userPwd = "";
var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;

$(function(){
	getWinners();
});

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
			//console.log(err)
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
    var winitem="";
    var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	$rootEl.empty();

	data.forEach(function(winner){
        winitem = "";
		if (winner.code=="1") winitem="win-z";

		tmpEl = '<li class="swiper-slide '+winitem+'">\
                    <div class="user-info">\
						<span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/' + winner.userlevelimg + '" alt=""></span>\
                        <span class="user-id">' + printUserName(winner.userid, 2, "*") + '</span>\
                    </div>\
		        </li>\
		'
		itemEle += tmpEl
	});
	$rootEl.append(itemEle)

	// winner
	if ($('#winners').children('li').length < 1) {
		$('#winners').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s;
        <% if left(currentDate,10)="2020-09-16" then %>
        s=1;
        <% else %>
        s=2;
        <% end if %>
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= #09/21/2020 00:00:00#) Then %>
			$('#resultover2').show();
			<% else %>
			$('#trylimit').show();
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
                //alert(err.responseText);
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
			<% If (currentDate >= #09/21/2020 00:00:00#) Then %>
			//$("#result4").show();
			popLoading($("#result4"));
			<% else %>
			popLoading($("#result3"));
			<% end if %>
			return false;
		}
		popLoading($("#fail1"));
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
        <% if left(currentDate,10)="2020-09-16" then %>
		    popLoading($("#winnerPopup1"));
        <% else %>
            popLoading($("#winnerPopup2"));
        <% end if %>
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
                //alert('신청 되었습니다.')
                <% If (currentDate >= #09/21/2020 00:00:00#) Then %>
                $('#lyrPush2').fadeIn();
                <% else %>
				$('#lyrPush1').fadeIn();
                <% end if %>
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

			<% '<!-- MKT 보따리 주인을 찾습니다 (A) 105709 --> %>
			<div class="mEvt105709">
				<div class="topic">
					<h2 class="tit-rawrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/tit_find.png" alt="보따리 주인을 찾습니다!"></h2>
					<div id="top-slide">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_slide_1.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_slide_2.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_slide_3.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_slide_4.png" alt=""></div>
						</div>
					</div>
                </div>
                <div class="items">
					<div class="link">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_item.jpg" alt="보따리 구성품">
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2840959&pEtr=105709');return false;">히치하이커 파우치</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=3082296&pEtr=105709');return false;">토이 키링</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2834084&pEtr=105709');return false;">Z플립</a>
						<a href="javascript:fnSearchEventText('하루일상+스티커세트');">투명 파우치</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2408335&pEtr=105709');return false;">마스킹 테이프</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=3087942&pEtr=105709');return false;">스티커 핀셋</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=3010787&pEtr=105709');return false;">리무버 씰 8종 세트</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2393206&pEtr=105709');return false;">마스킹 씰</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2781369&pEtr=105709');return false;">마이버디 스티커 12종 세트</a>
					</div>
					<button type="button" class="btn-apply" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/btn_apply.png" alt="응모하기"></button>
                </div>
                
                <div class="noti">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/txt_noti_1.png" alt=""></p>
                    <button type="button" class="btn-tgl"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/btn_noti.png" alt="유의사항 확인하기"></button>
				    <div class="txt-tgl"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/txt_noti_2.png" alt="유의사항"></div>
                </div>

                <div id="winner_list" class="winner-list">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/tit_winner.png" alt="당첨자 리스트"></h3>
                    <div id="winner_slider" class="winner-slider swiper-container">
                        <% '<!-- for dev msg : 당첨자 리스트 - 회원등급 ( 이미지 파일명 ico_ white red vip gold vvip ) / Z플립 당첨자에 클래스 win-z 붙여주세요 --> %>
                        <ul class="swiper-wrapper" id="winners"></ul>
                    </div>
                </div>
				
				<ul class="lookbook">
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_1.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_2.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_3.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_4.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_5.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_6.jpg" alt=""></li>
                    <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/img_look_7.jpg" alt=""></li>
				</ul>
				<div class="brand"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/txt_brand.jpg" alt=""></div>

				<% If currentDate >= eventEndDate Then %>
					<% '<!-- 알림 신청 마지막날 --> %>
                    <button type="button" id="btnPush2" onclick="jsPickingUpPushSubmit()" class="btn-push">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/btn_alarm_2.png" alt="다음 이벤트 알림 신청하기">
                    </button>
				<% else %>
                    <% '<!-- 알림 신청 --> %>
                    <button type="button" id="btnPush1" onclick="jsPickingUpPushSubmit()" class="btn-push">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/btn_alarm_1.png" alt="내일 응모 알림 신청하기">
                    </button>
				<% end if %>

				<% '<!-- for dev msg : 레이어팝업 ( style="display:block" 붙여서 확인해 주세요 ) -->  %>
				<% '<!-- 팝업 : 당첨(z플립 보따리) --> %>
				<div id="winnerPopup1" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_win_1.jpg" alt="z플립 보따리 당첨">
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                
                <% '<!-- 팝업 : 당첨(그냥 보따리) --> %>
				<div id="winnerPopup2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_win_2.jpg" alt="보따리 당첨">
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                
				<% '<!-- 팝업 : 꽝1 --> %>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<% '<!-- 카카오톡 공유 --> %>
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_1.png" alt="꽝1"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 공유 안하고 재응모 --> %>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<% '<!-- 카카오톡 공유 --> %>
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_2.png" alt="이미 1회응모"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 꽝2 --> %>
				<div id="result3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_3.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 꽝2 마지막날 --> %>
				<div id="result4" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_4.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 응모 횟수 초과 --> %>
				<div id="trylimit" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_5.png" alt="내일">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 응모 횟수 초과 마지막날 --> %>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_case_6.png" alt="끝">
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                
				<% '<!-- 팝업 : 푸시 신청 완료 --> %>
				<div id="lyrPush1" class="lyr" style="display:none">
					<div class="inner">
                        <button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_alarm_1.png" alt="푸시 설정 확인하기"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 푸시 신청 완료 마지막날 --> %>
				<div id="lyrPush2" class="lyr" style="display:none">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105709/m/pop_alarm_2.png" alt="푸시 설정 확인하기"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>
			<% '<!-- // MKT 보따리 주인을 찾습니다 (A) 105709 --> %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
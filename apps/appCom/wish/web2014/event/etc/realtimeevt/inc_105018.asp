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
' Description : 로우로우 이벤트
' History : 2020.08.13 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "102210"
	moECode = "102209"
Else
	eCode = "105018"
	moECode = "105017"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-08-17")		'이벤트 시작일
eventEndDate 	= cdate("2020-08-23")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" then
	currentDate = #08/17/2020 09:00:00#
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

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐X로우로우]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐X로우로우]"
Dim kakaodescription : kakaodescription = "떠나고 싶나요? 우선, 경품이 가득 담긴 캐리어를 무료로 받아가세요!"
Dim kakaooldver : kakaooldver = "떠나고 싶나요? 우선, 경품이 가득 담긴 캐리어를 무료로 받아가세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt105018 {position:relative; overflow:hidden; padding-bottom:12%; background:#fff;}
.mEvt105018 button {display:block; background:none; -webkit-tap-highlight-color:rgba(255,255,255,0);}
.mEvt105018 .topic {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/bg_topic.jpg) no-repeat center / cover;}
.mEvt105018 .topic > * {opacity:0;}
.mEvt105018 .tit-rawrow {transform:translateY(2rem); transition:1.5s;}
.mEvt105018 .txt-carrier {transform:translateY(5rem); transition:1.8s .5s;}
.mEvt105018 .topic.on > * {opacity:1; transform:translateY(0);}
.mEvt105018 .txt-intro {position:relative;}
.mEvt105018 .btn-area {position:relative; left:0; bottom:0; width:100%; padding-bottom:.5em; z-index:10011; background:#fff;}
.mEvt105018 .btn-area.fixed {position:fixed;}
.mEvt105018 .btn-area .btn-try {width:100%;}
.mEvt105018 .btn-tgl {position:relative; width:100%;}
.mEvt105018 .btn-tgl::after {position:absolute; width:4vw; height:4vw; background:no-repeat center / contain; content:' ';}
.mEvt105018 .btn-notice::after {left:36%; bottom:4vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/ico_arr_blk.png);}
.mEvt105018 .btn-detail::after {left:59.7%; top:4vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/ico_arr_org.png);}
.mEvt105018 .btn-tgl.open::after {transform:rotate(180deg);}
.mEvt105018 .txt-tgl {display:none;}
.mEvt105018 .txt-notice {padding-bottom:3%;}
.mEvt105018 .txt-detail {padding-bottom:4%;}
.mEvt105018 .items {margin-top:9%; padding-bottom:8%; background:#fff3d8;}
.mEvt105018 .link {position:relative;}
.mEvt105018 .link a {position:absolute; left:0; top:0; width:10vw; height:10vw; font-size:0; color:transparent;}
.mEvt105018 .link a:nth-of-type(1) {left:0vw; top:35vw; width:22vw; height:45vw;}
.mEvt105018 .link a:nth-of-type(2) {left:22vw; top:35vw; width:35vw; height:45vw;}
.mEvt105018 .link a:nth-of-type(3) {left:57vw; top:35vw; width:43vw; height:60vw; z-index:5;}
.mEvt105018 .link a:nth-of-type(4) {left:0vw; top:80vw; width:31vw; height:23vw;}
.mEvt105018 .link a:nth-of-type(5) {left:0vw; top:103vw; width:31vw; height:28vw;}
.mEvt105018 .link a:nth-of-type(6) {left:31vw; top:80vw; width:69vw; height:55vw;}
.mEvt105018 .link a:nth-of-type(7) {left:0vw; top:131vw; width:45vw; height:49vw;}
.mEvt105018 .link a:nth-of-type(8) {left:40vw; top:135vw; width:30vw; height:23vw;}
.mEvt105018 .link a:nth-of-type(9) {left:70vw; top:135vw; width:30vw; height:23vw;}
.mEvt105018 .link a:nth-of-type(10) {left:45vw; top:158vw; width:22vw; height:22vw;}
.mEvt105018 .link a:nth-of-type(11) {left:67vw; top:158vw; width:33vw; height:22vw;}
.mEvt105018 .winner {padding-bottom:6%;}
.mEvt105018 .winner .no-winner {display:flex; justify-content:center; align-items:center; font-size:1.1rem; color:#999;}
.mEvt105018 .winner .winner-slider {padding:0 1.5rem;}
.mEvt105018 .winner .swiper-slide {width:5.7rem; margin:0 .5rem;}
.mEvt105018 .winner .user-info {text-align:center; font-size:1rem; line-height:1.4; color:#666;}
.mEvt105018 .winner .user-info > span {display:block;}
.mEvt105018 .winner .user-info .user-grade {margin-bottom:.5rem;}
.mEvt105018 .winner .user-info .user-id {overflow:hidden; text-overflow:ellipsis; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt105018 .lookbook li {opacity:0; transform:translateY(2rem); transition:1s;}
.mEvt105018 .lookbook li.move {opacity:1; transform:translateY(0);}
.mEvt105018 .btn-push {width:100%; padding:5% 0;}
.mEvt105018 .lyr {display:none; position:fixed; top:0; left:0; z-index:10012; width:100%; height:100%; background:rgba(255,255,255,.95);}
.mEvt105018 .lyr .inner {position:absolute; top:50%; left:50%; width:28.6rem; transform:translate(-50%,-50%);}
.mEvt105018 .lyr .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0;color:transparent;}
.mEvt105018 .loadingV19 {position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);}
.mEvt105018 .loadingV19 p {font-size:1.37rem; color:#999;}
</style>
<script>
$(function() {
	// ui
	$('.mEvt105018 .topic').addClass('on');
	var btnBot = $('.btn-area').offset().top + $('.btn-area').height();
	$(window).scroll(function(){
		var y = $(window).scrollTop() + $(window).height();
		if (y > btnBot)	$('.btn-area').addClass('fixed');
		else	$('.btn-area').removeClass('fixed');
		$('.lookbook li').each(function(i, el) {
			var imgTop = $(el).offset().top;
			if (y > imgTop)	$(el).addClass('move');
		});
	});
	$('.mEvt105018 .btn-tgl').on('click', function(e) {
		fnToggle($(e.currentTarget));
	});

	// close popup
	$('.mEvt105018 .lyr .btn-close').on('click', function(e) {
		$(this).parent().parent().fadeOut();
	});
	$('.mEvt105018 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr'))	$(e.target).fadeOut();
	});
});
function fnToggle(btn) {
	var [btn, target] = [btn, btn.next('.txt-tgl')],
		state = target.is(':visible');
	target.toggle();
	if (state)	btn.removeClass('open');
	else	btn.addClass('open');
}

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
			alert("잘못된 접근 입니다.");
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
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	$rootEl.empty();

	data.forEach(function(winner){
		tmpEl = '<li class="swiper-slide">\
                    <div class="user-info">\
                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/' + winner.userlevelimg + '" alt=""></span>\
                        <span class="user-id">' + printUserName(winner.userid, 2, "*") + '</span>\
                        <span class="user-name">' + printUserName(winner.username, 1, "*") + '</span>\
                    </div>\
		        </li>\
		'
		itemEle += tmpEl
	});
	$rootEl.append(itemEle)

	// winner slider
	if ($('.winner-slider').find('.swiper-slide').length > 0) {
		var swiper = new Swiper('.winner-slider', {
			slidesPerView: 'auto'
		});
	} else {
		$('.winner').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s;
        s=1;
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= #08/24/2020 00:00:00#) Then %>
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

function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #08/24/2020 00:00:00#) Then %>
			//$("#result4").show();
			popLoading(($("#result4"));
			<% else %>
			popLoading($("#result3"));
			<% end if %>
			return false;
		}
		popLoading($("#fail1"));
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		popLoading($("#winnerPopup"));
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
                <% If (currentDate >= #08/24/2020 00:00:00#) Then %>
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

			<div class="mEvt105018">
				<div class="topic">
					<h2 class="tit-rawrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/tit_rawrow.png" alt="텐바이텐 X 로우로우"></h2>
					<p class="txt-carrier"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_carrier.png" alt="캐리어 하나면 충분해"></p>
				</div>
				<div class="txt-intro">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_intro.png" alt="아 어디든 떠나고 싶다"></p>
					<div class="btn-area">
						<button type="button" class="btn-try" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_try.png" alt="응모하기"></button>
					</div>
				</div>
				<button type="button" class="btn-tgl btn-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_notice.png" alt="유의사항 확인하기"></button>
				<div class="txt-tgl txt-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_notice.png" alt="유의사항"></div>
				<div class="items">
					<div class="link">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_items.jpg" alt="캐리어 구성품">
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2816472&pEtr=105018');return false;">1 스누피 무빙펜</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2332829&pEtr=105018');return false;">2 아이패드</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2721042&pEtr=105018');return false;">3 캐리어 63L</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2937509&pEtr=105018');return false;">4 가죽지갑</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2441393&pEtr=105018');return false;">5 크로스백</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2734499&pEtr=105018');return false;">6 여행 파우치 세트</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2441385&pEtr=105018');return false;">7 백팩</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2783619&pEtr=105018');return false;">8 아이패드 파우치</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2937365&pEtr=105018');return false;">9 스누피 3공 다이어리</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2435183&pEtr=105018');return false;">10 선글라스</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2556615&pEtr=105018');return false;">11 스누피 키링</a>
					</div>
					<button type="button" class="btn-tgl btn-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_detail.png" alt="자세히 보기"></button>
					<div class="txt-tgl txt-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_detail.png" alt="상품명"></div>
				</div>
				<ul class="lookbook">
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_1.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_2.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_3.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_4.jpg" alt=""></li>
				</ul>
				<div class="brand">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_brand.jpg" alt="">
					<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105019');" target="_blank">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_brand.jpg" alt="신상 라인업 보러가기">
					</a>
				</div>
				<div class="winner">
					<div class="winner-slider swiper-container">
						<ul id="winners" class="swiper-wrapper"></ul>
					</div>
				</div>
				<!-- for dev msg : 알림 신청 -->
				<% If currentDate >= eventEndDate Then %>
				<button type="button" id="btnPush2" class="btn-push" onclick="jsPickingUpPushSubmit()">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_push_last.png" alt="다음 이벤트 알림 신청하기">
				</button>
				<% else %>
				<button type="button" id="btnPush1" class="btn-push" onclick="jsPickingUpPushSubmit()">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_push.png" alt="내일 알림 신청하기">
				</button>
				<% end if %>
				<%'<!-- 팝업 : 당첨 -->%>
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_win.jpg" alt="당첨">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 꽝1 -->%>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_fail1.jpg" alt="꽝1"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 공유 안하고 재응모 -->%>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_already.jpg" alt="이미"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 꽝2 -->%>
				<div id="result3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_fail2.jpg" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 꽝2 마지막날 -->%>
				<div id="result4" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_fail2_last.jpg" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 응모 횟수 초과 -->%>
				<div id="trylimit" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_fin.jpg" alt="내일">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 응모 횟수 초과 마지막날 -->%>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_fin_last.jpg" alt="끝">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 푸시 신청 완료 -->%>
				<div id="lyrPush1" class="lyr" style="display:none">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_push.jpg" alt="푸시"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 푸시 신청 완료 마지막날 -->%>
				<div id="lyrPush2" class="lyr" style="display:none">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/pop_push_last.jpg" alt="푸시"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
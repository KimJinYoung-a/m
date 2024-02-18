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
	eCode = "102217"
	moECode = "102216"
Else
	eCode = "105454"
	moECode = "105453"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-08-31")		'이벤트 시작일
eventEndDate 	= cdate("2020-09-06")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

'if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" or LoginUserid = "tozzinet" then
'	currentDate = #08/31/2020 09:00:00#
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

snpTitle	= Server.URLEncode("[텐바이텐X일리]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐X일리]"
Dim kakaodescription : kakaodescription = "홈카페 세트를 무료로 드립니다. 카페 말고 집에서 커피를 즐겨보세요!"
Dim kakaooldver : kakaooldver = "홈카페 세트를 무료로 드립니다. 카페 말고 집에서 커피를 즐겨보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<!-- <base href="http://m.10x10.co.kr"> -->
<style>
.mEvt105454 {position:relative; overflow:hidden; background:#fff;}
.mEvt105454 button {display:block; background:none; -webkit-tap-highlight-color:rgba(255,255,255,0);}
.mEvt105454 .topic {background:#ff2c2c;}
.mEvt105454 .tit-illy > img {opacity:0;}
.mEvt105454 .tit-illy > img:nth-child(1) {transform:translateY(-1rem); transition:1s;}
.mEvt105454 .tit-illy > img:nth-child(2) {transform:translateY(-2rem); transition:1.2s .5s;}
.mEvt105454 .tit-illy.on > img {opacity:1; transform:translateY(0);}
.mEvt105454 .items {position:relative;}
.mEvt105454 .items a {position:absolute; left:0; top:0; width:50vw; height:50vw; font-size:0; color:transparent;}
.mEvt105454 .items a:nth-of-type(1) {left:0vw; top:15vw; width:46vw; height:73vw;}
.mEvt105454 .items a:nth-of-type(2) {left:46vw; top:15vw; width:54vw; height:41vw;}
.mEvt105454 .items a:nth-of-type(3) {left:46vw; top:56vw; width:54vw; height:38vw;}
.mEvt105454 .items a:nth-of-type(4) {left:0vw; top:88vw; width:46vw; height:47vw;}
.mEvt105454 .items a:nth-of-type(5) {left:46vw; top:94vw; width:54vw; height:41vw;}
.mEvt105454 .items a:nth-of-type(6) {left:20vw; top:135vw; width:70vw; height:40vw;}
.mEvt105454 .btn-area {position:relative; left:0; bottom:0; width:100%; z-index:10011; background:#fff;}
.mEvt105454 .btn-area.fixed {position:fixed; padding-bottom:.5em;}
.mEvt105454 .btn-area .btn-try {width:100%;}
.mEvt105454 .btn-tgl {width:100%;}
.mEvt105454 .txt-tgl {display:none;}
.mEvt105454 .winner {position:relative;}
.mEvt105454 .winner .no-winner {font-size:1.1rem; color:#999;}
.mEvt105454 .winner-list {display:flex; justify-content:center;}
.mEvt105454 .winner-list li {width:5.7rem; margin:0 .8rem;}
.mEvt105454 .winner .user-info {text-align:center; font-size:1rem; line-height:1.4; color:#666;}
.mEvt105454 .winner .user-info > span {display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
.mEvt105454 .winner .user-info .user-grade {margin-bottom:.5rem;}
.mEvt105454 .winner .user-info .user-id {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt105454 .lookbook li {opacity:0; transform:translateY(2rem); transition:1s;}
.mEvt105454 .lookbook li.active {opacity:1; transform:translateY(0);}
.mEvt105454 .btn-push {width:100%;}
.mEvt105454 .lyr {display:none; position:fixed; top:0; left:0; z-index:10012; width:100%; height:100%; background:rgba(255,255,255,.9);}
.mEvt105454 .lyr .inner {overflow-y:auto; position:absolute; top:50%; left:50%; width:28.6rem; max-height:90vh; transform:translate(-50%,-50%);}
.mEvt105454 .lyr .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0;color:transparent;}
.mEvt105454 .loadingV19 {position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:none;}
.mEvt105454 .loadingV19 p {font-size:1.37rem; color:#999;}
</style>
<script>
$(function() {
	$('.mEvt105454 .tit-illy').addClass('on');
	var btnTry = $('.mEvt105454 .btn-area');
	var btnTryBot = btnTry.offset().top + btnTry.height();
	$(window).scroll(function() {
		var y = $(window).scrollTop() + $(window).height();
		if (y > btnTryBot)	btnTry.addClass('fixed');
		else	btnTry.removeClass('fixed');
		$('.mEvt105454 .lookbook li').each(function(i, el) {
			var imgTop = $(el).offset().top;
			if (y > imgTop)	$(el).addClass('active');
		});
	});
	$('.mEvt105454 .btn-tgl').on('click', function(e) {
		$(this).next('.txt-tgl').toggle();
	});

	// try popup
	//$('.mEvt105454 .btn-try').on('click', function(e) {
		// $('.mEvt105454 .lyr').eq(2).fadeIn();
	//});
	// push popup
	//$('.mEvt105454 #btnPush1').on('click', function(e) {
	//	$('#lyrPush1').fadeIn();
	//});
	$('.mEvt105454 #btnPush2').on('click', function(e) {
		$('#lyrPush2').fadeIn();
	});
	// close popup
	$('.mEvt105454 .lyr .btn-close').on('click', function(e) {
		$(this).parent().parent().fadeOut();
	});
	$('.mEvt105454 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr'))	$(e.target).fadeOut();
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
		tmpEl = '<li>\
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

	// winner
	if ($('.winner-list').children('li').length < 1) {
		$('.winner-list').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
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
			<% If (currentDate >= #09/07/2020 00:00:00#) Then %>
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
			<% If (currentDate >= #09/07/2020 00:00:00#) Then %>
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
                <% If (currentDate >= #09/07/2020 00:00:00#) Then %>
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

			<% '<!-- MKT 텐바이텐X일리 응모이벤트 (A) 105454 --> %>
			<% '<!-- 카카오톡 공유이미지 http://webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_kakao.jpg --> %>
			<div class="mEvt105454">
				<div class="topic">
					<h2 class="tit-illy">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/tit_illy_1.png" alt="텐바이텐 X 일리">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/tit_illy_2.png" alt="홈카페 선물 세트">
					</h2>
					<div class="items">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_items.jpg" alt="상품 구성">
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2255061&pEtr=105454');return false;">1 일리 Y3.3 캡슐머신 화이트</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=3140409&pEtr=105454');return false;">2 마샬 액톤2 스피커 화이트</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2318453&pEtr=105454');return false;">3 일리 캡슐 18개입 (랜덤)</a>
						<a href="" onclick="fnAPPpopupBrand('hitchhiker'); return false;">4 히치하이커 3권 (랜덤)</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2920331&pEtr=105454');return false;">5 피너츠 글라스컵 (각 1개)</a>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=2783818&pEtr=105454');return false;">6 스누피 우드 플레이트</a>
					</div>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/txt_intro.png" alt="나만의 홈카페"></p>
				<div class="btn-area">
					<% '<!-- for dev msg : 응모하기 --> %>
					<button type="button" class="btn-try" onclick="eventTry()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/btn_try.png" alt="응모하기"></button>
				</div>
				<button type="button" class="btn-tgl"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/btn_notice.png" alt="유의사항 확인하기"></button>
				<div class="txt-tgl"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/txt_notice.png" alt="유의사항"></div>
				<div class="winner">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/tit_winner.png" alt="당첨자 리스트"></h3>
					<% '<!-- for dev msg : 당첨자 리스트 - 회원등급 5가지 ( 이미지 파일명 ico_ white red vip gold vvip ) --> %>
					<ul class="winner-list" id="winners"></ul>
				</div>
				<ul class="lookbook">
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_lookbook_1.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_lookbook_2.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_lookbook_3.jpg" alt=""></li>
					<li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/img_lookbook_4.jpg" alt=""></li>
				</ul>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/txt_brand.jpg" alt="일리 커피"></p>
				<% '<!-- for dev msg : 푸시 알림 신청 --> %>

				<% If currentDate >= eventEndDate Then %>
					<% '<!-- for dev msg : 마지막날 --> %>
					<button type="button" id="btnPush2" onclick="jsPickingUpPushSubmit()" class="btn-push">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/btn_push_last.png" alt="다음 이벤트 알림 신청하기">
					</button>
				<% else %>
					<button type="button" id="btnPush1" onclick="jsPickingUpPushSubmit()" class="btn-push">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/btn_push.jpg" alt="내일 알림 신청하기">
					</button>
				<% end if %>

				<% '<!-- for dev msg : 팝업 ( style="display:block" 붙여서 확인해 주세요 ) --> %>
				<% '<!-- 팝업 : 당첨 --> %>
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_win.jpg" alt="당첨">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 꽝1 --> %>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_fail1.jpg" alt="꽝1"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 공유 안하고 재응모 --> %>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_already.jpg" alt="이미"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 꽝2 --> %>
				<div id="result3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_fail2.jpg" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 꽝2 마지막날 --> %>
				<div id="result4" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_fail2_last.jpg" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 응모 횟수 초과 --> %>
				<div id="trylimit" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_fin.jpg" alt="내일">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 응모 횟수 초과 마지막날 --> %>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_fin_last.jpg" alt="끝">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 푸시 신청 완료 --> %>
				<div id="lyrPush1" class="lyr" style="display:none">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_push.jpg" alt="푸시"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<% '<!-- 팝업 : 푸시 신청 완료 마지막날 --> %>
				<div id="lyrPush2" class="lyr" style="display:none">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105454/m/pop_push_last.jpg" alt="푸시"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>
			<% '<!-- // MKT 텐바이텐X일리 응모이벤트 (A) 105454 --> %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
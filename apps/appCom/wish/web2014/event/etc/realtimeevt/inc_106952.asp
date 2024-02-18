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
' Description : 2020 득템의 기회2 이벤트
' History : 2020-10-22 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "103247"
	moECode = "103238"
Else
	eCode = "106952"
	moECode = "106951"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-10-26")		'이벤트 시작일
eventEndDate 	= cdate("2020-11-03")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	mktTest = False
end if

if mktTest then
    currentDate = cdate("2020-10-26")
else
    currentDate 	= date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[다시 한번! 득템의 기회]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[다시 한번! 득템의 기회]"
Dim kakaodescription : kakaodescription = "이번엔 아이폰12가 59,000원? 지금 바로 원하는 상품에 도전해요!"
Dim kakaooldver : kakaooldver = "이번엔 아이폰12가 59,000원? 지금 바로 원하는 상품에 도전해요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

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
%>
<style>
.mEvt106511 {position:relative; overflow:hidden;}
.mEvt106511 button {background:none;}
.mEvt106511 .topic {position:relative;}
.mEvt106511 .topic .slider {position:absolute; top:0; right:0; width:100%;}
.mEvt106511 .topic .swiper-slide {width:100%;}
.mEvt106511 .item-list {position:relative;}
.mEvt106511 .item-list .item {position:relative; overflow:hidden;}
.mEvt106511 .item .btn-try {position:absolute; top:0; left:0; width:100%; height:100%; font-size:0; color:transparent;}
.mEvt106511 .item .quantity {position:absolute; bottom:30%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.7rem; color:#ff0000; letter-spacing:-1px;}
.mEvt106511 .item1 .quantity,.mEvt106511 .item3 .quantity {left:7%;}
.mEvt106511 .item2 .quantity,.mEvt106511 .item4 .quantity {right:7%;}
.mEvt106511 .item .quantity b {margin-left:.1em; font-size:3.4rem;}
.mEvt106511 .winner {position:relative; padding-bottom:12%; background:#fffef4;}
.mEvt106511 .winner .slider {padding:0 5%; text-align:center;}
.mEvt106511 .winner .swiper-slide {padding:0 .7em;}
.mEvt106511 .winner .thumb {width:10.24rem; height:10.24rem;}
.mEvt106511 .winner p {margin-top:.8em;}
.mEvt106511 .winner .name {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.28rem; color:#000;}
.mEvt106511 .winner .user {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1rem; color:#182d9c;}
.mEvt106511 .notice {padding-bottom:10%; background:#1e1e1e;}
.mEvt106511 .txt-notice {display:none;}
.mEvt106511 .btn-share,.mEvt106511 .btn-push,.mEvt106511 .btn-notice {display:block; width:100%;}
.mEvt106511 .lyr {display:none; position:fixed; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.6);}
.mEvt106511 .lyr .inner {position:absolute; top:50%; left:50%; width:27.52rem; transform:translate(-50%,-50%);}
.mEvt106511 .lyr .link {position:absolute; top:0; left:0; width:100%; height:100%; font-size:0; color:transparent;}
.mEvt106511 .lyr .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0; color:transparent;}
.mEvt106511 .lyr .pang {position:absolute; left:0; width:100%; transform:scale(.5);}
.mEvt106511 .lyr .pang.on {transform:scale(1); transition:.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);}
.mEvt106511 .loadingV19 {position:absolute; top:50%; left:50%; padding:0; background:none; transform:translate(-50%,-50%);}
.mEvt106511 .loadingV19 i {background:rgba(255,255,255,.5);}
.mEvt106511 .loadingV19 i::before {background:rgba(255,255,255,.8);}
.mEvt106511 .loadingV19 p {font-size:1.37rem; color:#fff;}
</style>
<script>
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"
var prizeInfo = [
	{name:'NEW 아이폰12 블랙'}, 
	{name:'NEW 아이패드 에어 실버'}, 
	{name:'애플워치 3세대'},
	{name:'스누피 테이블 M'}
]

$(function() {
	var swiper = new Swiper('.topic .slider', {
		autoplay: 500,
		speed: 10,
		effect: 'fade',
		fade: {crossFade:true}
	});

	$('.mEvt106511 .btn-notice').on('click', function(e) {
		$(this).next('.txt-notice').slideToggle();
	});
	$('.mEvt106511 .lyr').on('click', function(e) {
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
		$('.loadingV19').remove();
	});
	$('.mEvt106511 .lyr .btn-close').on('click', function(e) {
		$(this).closest('.lyr').fadeOut();
		$('.loadingV19').remove();
	});
    getEvtItemList();
	getWinners();
});

function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEvent106952Proc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			// console.log(res.data)
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
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#secondTry").eq(0).delay(500).fadeIn();
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= #11/03/2020 00:00:00#) Then %>
			$('#resultover2').eq(0).delay(500).fadeIn();
			<% else %>
			$('#resultover').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent106952Proc.asp",
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
			url:"/event/etc/realtimeevent/realtimeEvent106952Proc.asp",
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
			<% If (currentDate >= #11/03/2020 00:00:00#) Then %>
			$('#fail3').eq(0).delay(500).fadeIn();
			<% else %>
			$('#fail2').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/106952/m/pop_win_0"+ selectedPdt +".jpg?v=1.01")
		$("#winnerPopup").eq(0).delay(500).fadeIn();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$('#resultover').eq(0).delay(500).fadeIn();
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
        var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
		newArr.forEach(function(item){
			if (item.isOpen){
				if(item.leftItems <= 0){ //open
					info = '\
                        <li>\
                            <div class="item item'+ item.itemcode +'">\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_item'+ item.itemcode +'_out.jpg?v=1.05" alt="sold out">\
                                <span class="quantity">남은수량<b>0</b>개</span>\
                            </div>\
                        </li>\
                        '
				}else{
					info = '\
						<li>\
                            <div class="item item'+ item.itemcode +'">\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_item'+ item.itemcode +'.jpg?v=1.04" alt="">\
                                <span class="quantity">남은수량<b>'+ item.leftItems +'개</b></span>\
                                <button type="button" class="btn-try" onclick="eventTry('+ item.itemcode +')">도전하기</button>\
                            </div>\
                        </li>\
					'
				}
			}
			else{
				info = '\
						<li>\
                            <div class="item item'+ item.itemcode +'">\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_item'+ item.itemcode +'.jpg?v=1.04" alt="">\
                                <span class="quantity">남은수량<b>'+ item.leftItems +'개</b></span>\
                            </div>\
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
		url:"/event/etc/realtimeevent/realtimeEvent106952Proc.asp",
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

	data.forEach(function(winner){
		tmpEl = '<div class="swiper-slide">\
			<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_win_0'+ winner.code +'.png" alt=""></div>\
            <p class="name">' + prizeInfo[(winner.code-1)].name + '</p>\
			<p class="user">' + printUserName(winner.userid, 2, "*") + '님</p>\
		</div>\
		'
		itemEle += tmpEl
	});
    if(data.length<3){
        for(var ix=0; ix<(3-data.length); ix++){
            tmpEl = '<div class="swiper-slide">\
                <div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_win_blank.png" alt=""></div>\
            </div>\
            '
            itemEle += tmpEl
        }
    }
	$rootEl.append(itemEle)

	var swiper = new Swiper('.winner .slider', {
		slidesPerView: 'auto',
		speed: 500,
		initialSlide: data.length < 3 ? 0: data.length - 2
        
	});

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

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/realtimeevent/realtimeEvent106952Proc.asp?mode=pushadd",
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
			<div class="mEvt106511">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/tit_gotcha.jpg" alt="득템할 기회"></h2>
					<div class="slider">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_topic_01.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_topic_02.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_topic_03.png" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/img_topic_04.png" alt=""></div>
						</div>
					</div>
				</div>
				<div class="item-list">
					<ul id="itemList"></ul>
				</div>
				<!-- 팝업 : 당첨 -->
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<span class="pang"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_win_pang.png" alt=""></span>
						<img id="winImg" src="" alt="당첨을 축하드립니다!">
						<a href="" onclick="goDirOrdItem();return false;" class="link">구매하러 가기</a>
					</div>
				</div>
				<!-- 팝업 : 꽝1 -->
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<!-- for dev msg : 카카오톡 공유 -->
						<button type="button" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_fail1.jpg" alt="아쉽게도 실패했습니다"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- 팝업 : 공유 안하고 재응모 -->
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<!-- for dev msg : 카카오톡 공유 -->
						<button type="button" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_already.jpg" alt="이미 1회 응모하였습니다"></button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<!-- 팝업 : 꽝2 -->
				<div id="fail2" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_fail2.jpg" alt="아쉽게도 당첨되지 않았습니다 내일 다시 도전해보세요">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<div id="fail3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_fail2_last.jpg" alt="아쉽게도 당첨되지 않았습니다 응모해주셔서 감사합니다">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<div id="resultover" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_fin.jpg" alt="오늘의 응모는 모두 완료 내일 또 도전해 주세요">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_fin_last.jpg" alt="오늘의 응모는 모두 완료 응모해주셔서 감사합니다">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<div class="winner">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/tit_winner.png" alt="당첨자"></h3>
					<div class="slider">
						<div class="swiper-wrapper" id="winners"></div>
					</div>
				</div>
				<button type="button" class="btn-share" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/bnr_share.jpg" alt="카카오톡 공유"></button>
				<button type="button" class="btn-push" onclick="jsPickingUpPushSubmit();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/btn_push.jpg" alt="알림 신청하기"></button>
				<div id="lyrPush" class="lyr">
					<div class="inner">
						<button type="button" onclick="fnAPPpopupSetting();return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/pop_push.jpg" alt="푸시 설정 확인하기">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<div class="notice">
					<button type="button" class="btn-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/tit_notice.png" alt="유의사항"></button>
					<div class="txt-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/106952/m/txt_notice.png" alt=""></div>
				</div>
				<a href="" onclick="fnAPPpopupBrowserURL('19주년','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/19th/');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106511/m/bnr_19th.jpg" alt="19주년">
				</a>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->
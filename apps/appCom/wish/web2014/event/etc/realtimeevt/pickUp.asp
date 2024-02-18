<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/templateRealtimeCls.asp" -->
<%
'####################################################
' Description : 줍줍 이벤트
' History : 2020.07.22 정태훈 - 마샬스피커
' 			2020.08.10 정태훈 - 아이패드
' 			2020.08.24 정태훈 - 빔 프로젝터
'			2020.09.17 이종화 - 애플워치
'			2020.10.05 원승현 - 에어팟 프로
'			2020.12.22 정태훈 - 닌텐도
'			2021.01.13 정태훈 - 에어팟 프로
'####################################################

dim oEvent, eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent, mktTest
dim numOfParticipantsPerDay, i, arrEvtInfo, itemName, snsTitle, snsText, snsIMG, limitItemCNT, prizeIMG, evtState, etcText
dim isTeaser : isTeaser = False

set oEvent = new RealtimeEventCls
oEvent.FRectEvtCode = request("eventid")
arrEvtInfo = oEvent.getOneEventInfo

if isArray(arrEvtInfo) then
	eCode = arrEvtInfo(0,0)
	moECode = arrEvtInfo(1,0)
    eventStartDate  = cdate(arrEvtInfo(2,0))		'이벤트 시작일
    eventEndDate    = cdate(arrEvtInfo(3,0))		'이벤트 종료일
    limitItemCNT        = arrEvtInfo(4,0)			'상품 수량
    itemName        = arrEvtInfo(5,0)				'상품명
	snsTitle        = arrEvtInfo(6,0)				'sns제목
	snsText        = arrEvtInfo(7,0)				'sns내용
	snsIMG        = arrEvtInfo(8,0)					'sns이미지
	prizeIMG        = arrEvtInfo(9,0)					'당첨이미지
	evtState        = arrEvtInfo(10,0)					'이벤트 상태값
	etcText        = arrEvtInfo(11,0)					'추가 유의사항
else
	eCode = "109281"
	moECode = "109280"
    eventStartDate	= cdate("2021-02-01")
    eventEndDate	= cdate("2021-02-07")
    limitItemCNT    = 3
    itemName    = "아이패드 에어"
	snsTitle        = "[줍줍이벤트]"
	snsText        = "아이패드 에어를 79,000원에 구매하는 날! 지금 당신의 결과를 확인해보세요."
	snsIMG        = "http://webimage.10x10.co.kr/fixevent/event/2021/109281/m/img_kakao.jpg"
	prizeIMG        = "http://webimage.10x10.co.kr/fixevent/event/2021/109281/m/pop_win.png"
	evtState        = ""					'이벤트 상태값
	etcText        = ""					'추가 유의사항
end if
set oEvent = nothing

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "yeg0117" or LoginUserid = "wldbs4086" then
	if request("teaser")="Y" then
		isTeaser = True
	else
		if request("param") = "mktTest" then
			mktTest = True
		else
			mktTest = False
		end if
		if mktTest then
			currentDate = cdate(arrEvtInfo(2,0))
		else
			currentDate = date()
		end if
	end if
else
	if evtState<7 or currentDate < eventStartDate or currentDate > eventEndDate then
		isTeaser = True
	end if
end if

dim isSecondTried
dim isFirstTried, ItemCNT
dim triedNum : triedNum = 0
dim isShared : isShared = False
isSecondTried = false

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	ItemCNT = pwdEvent.isEventItemCNT()
	isShared = pwdEvent.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)

function WeekKor(weeknum)
    if weeknum="1" then
        WeekKor="일"
    elseif weeknum="2" then
        WeekKor="월"
    elseif weeknum="3" then
        WeekKor="화"
    elseif weeknum="4" then
        WeekKor="수"
    elseif weeknum="5" then
        WeekKor="목"
    elseif weeknum="6" then
        WeekKor="금"
    elseif weeknum="7" then
        WeekKor="토"
    end if
end function

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode(snsTitle)
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode(snsIMG)
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = snsTitle
Dim kakaodescription : kakaodescription = snsText
Dim kakaooldver : kakaooldver = snsText
Dim kakaoimage : kakaoimage = snsIMG
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
:root {
	--price-color: #ff3c00;		/* 이벤트가격 색상 */
	--btn-bg-color: #00c478;	/* 도전하기 버튼 배경색 */
	--btn-text-color: #fff;			/* 도전하기 버튼 텍스트 색상 */
}

.not-scroll {position:fixed; overflow:hidden; width:100%; height:auto;}
.bnr-anniv18 {display:none;}

.evt-jupjup {position:relative; overflow:hidden; background:#f7f7f7;}
.evt-jupjup h2 {position:absolute; font-size:0; color:transparent;}
.evt-jupjup button {font:inherit; background:none;}

.evt-jupjup .prd-img {position:relative; text-align:center; background:#fff;}
.evt-jupjup .prd-img img {width:100%;}
.evt-jupjup .prd-img a {position:absolute; top:0; left:0; width:100%; height:100%; font-size:0; color:transparent;}
.evt-jupjup .limit-bar {height:2em; padding-top:.1em; line-height:2; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.37rem; color:#fff; background:#222; text-align:center; letter-spacing:.05em;}
.evt-jupjup .prd-info .prd-name {padding:.9em 1.5rem .6em; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.62rem; line-height:1.3;}
.evt-jupjup .prd-info .prd-price {padding:0 1.5rem 2rem; text-align:right;}
.evt-jupjup .prd-info .prd-price .o-price {display:block; margin-bottom:.3em; font-size:1.54rem; color:#999;}
.evt-jupjup .prd-info .prd-price .o-price dfn {font-size:0; color:transparent;}
.evt-jupjup .prd-info .prd-price .set-price {font-family:'CoreSansCBold', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; color:var(--price-color);}
.evt-jupjup .prd-info .prd-price .set-price dfn {margin-right:0.3em; font-size:1.28rem;}
.evt-jupjup .prd-info .prd-price .set-price b {font-size:2.56rem;}

.evt-jupjup .btn-area {position:relative; display:flex; justify-content:space-between; height:4.7rem; padding:0 1.7rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.54rem;}
.evt-jupjup .btn-area.fixed {position:fixed; z-index:21;}
.evt-jupjup .btn-area .btn-try {flex:1 1 100%; padding-top:.1rem; color:var(--btn-text-color); background:var(--btn-bg-color); border-radius:.85rem; word-break:keep-all;}
.evt-jupjup .btn-area .btn-try[disabled] {color:#fff; background:#8d8d8d;}
.evt-jupjup .btn-area .btn-share {flex:0 0 4.6rem; margin-left:0.4rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104374/m/ico_share.png) center no-repeat; background-size:50%; font-size:0; color:transparent;}

.evt-jupjup .evt-info {margin-top:3rem; font-size:1.2rem; color:#444; line-height:1.6;}
.evt-jupjup .evt-info dl {padding:.1rem 0;}
.evt-jupjup .evt-info dt {padding-left:1.5rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.evt-jupjup .evt-info dd {word-break:keep-all;}
.evt-jupjup .evt-info dl.row {display:flex;}
.evt-jupjup .evt-info dl.row dt {flex:0 0 26%;}
.evt-jupjup .evt-info dl.notice {margin:.8rem 0 1rem;}
.evt-jupjup .evt-info .btn-notice {padding:0 .3rem 0 0; line-height:1.2; border-bottom:1px solid #444; color:#444;}
.evt-jupjup .evt-info .btn-notice::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .3rem .5rem; border:solid #444; border-width:0 2px 2px 0; transform:rotate(45deg);}
.evt-jupjup .evt-info .btn-notice.open::after {margin:0 0 0 .5rem; transform:rotate(-135deg);}
.evt-jupjup .evt-info .notice-list {display:none;}
.evt-jupjup .evt-info .notice-list ul {padding:.8rem 1.5rem 0;}
.evt-jupjup .evt-info .notice-list li {position:relative; padding-left:.8rem;}
.evt-jupjup .evt-info .notice-list li::before {content:'-'; position:absolute; top:0; left:0;}

.evt-jupjup .winner-list {position:relative; margin-top:.8rem;}
.evt-jupjup .winner-list .no-winner {display:flex; justify-content:center; align-items:center; font-size:1.1rem; color:#999;}
.evt-jupjup .winner-list .winner-slider {padding:0 1.5rem;}
.evt-jupjup .winner-list .swiper-slide {width:5.7rem; margin:0 .5rem;}
.evt-jupjup .winner-list .user-info {text-align:center; font-size:1rem; line-height:1.4;}
.evt-jupjup .winner-list .user-info > span {display:block;}
.evt-jupjup .winner-list .user-info .user-grade {margin-bottom:0.5rem;}
.evt-jupjup .winner-list .user-info .user-id {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

.evt-jupjup .title-h3 {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.7rem; color:#222; line-height:1.3;}
.evt-jupjup .title-h3 small {font-size:smaller;}
.evt-jupjup .guide {padding:1.62rem 1.71rem 3rem;}
.evt-jupjup .guide .link {display:inline-block; padding:1rem .3rem 0 0; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.28rem; color:#704aff; line-height:1.2; border-bottom:1px solid #704aff;}
.evt-jupjup .guide .link::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .3rem .3rem; border:solid #704aff; border-width:0 .15rem .15rem 0; transform:rotate(-45deg);}

.evt-jupjup .alarm {padding:4rem 1.7rem 0;}
.evt-jupjup .alarm .btn-alarm {width:15.36rem; height:3.4rem; padding-top:.3rem; margin-top:1.5rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.28rem; color:#fff; background:#704aff; border-radius:.85rem;}
.evt-jupjup .alarm .btn-alarm span::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .2rem .5rem; border:solid #fff; border-width:0 2px 2px 0; transform:rotate(-45deg);}
.evt-jupjup .alarm-way {position:relative; margin:3.16rem 0 5.12rem;}
.evt-jupjup .alarm-way button {position:absolute; top:0; left:0; width:100%; height:85%; font-size:0;}
.evt-jupjup .alarm-way a {position:absolute; bottom:0; left:0; width:100%; height:10%; font-size:0;}

.evt-jupjup .prev-evts {padding:0 1.71rem;}
.evt-jupjup .prev-evts ul {margin-top:1.92rem;}
.evt-jupjup .prev-evts li {display:flex; align-items:start; margin-top:1.02rem;}
.evt-jupjup .prev-evts .evt-thumb {position:relative; flex:0 0 29.85%;}
.evt-jupjup .prev-evts .evt-thumb::before {content:' '; position:absolute; top:50%; left:50%; width:4.27rem; height:4.27rem; margin:-2.22rem 0 0 -2.22rem; background:url(//fiximage.10x10.co.kr/m/2017/common/bg_img_loading.png) 50% 0 no-repeat; background-size:100% auto;}
.evt-jupjup .prev-evts .evt-thumb img {position:relative; z-index:5;}
.evt-jupjup .prev-evts .evt-txt {margin:.5rem 0 0 1.71rem; font-size:1.19rem; line-height:1.4; color:#999;}
.evt-jupjup .prev-evts .prd-name,
.evt-jupjup .prev-evts .prd-price .set-price {font-size:1.37rem; line-height:1.96rem; color:#222; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; word-break:break-all;}
.evt-jupjup .prev-evts .prd-price .o-price {font-size:1.37rem;}
.evt-jupjup .prev-evts .prd-price dfn {font-size:0; color:transparent;}
.evt-jupjup .prev-evts .btn-winner {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; color:#999;}
.evt-jupjup .prev-evts .btn-winner::after {content:' '; display:inline-block; width:0.4rem; height:0.4rem; margin:0 0 .25rem .3rem; border:solid #999; border-width:0 1px 1px 0; transform:rotate(-45deg);}

.evt-jupjup .prev-winners {margin-top:3.2rem; margin-bottom:1.83rem; background-color:#343434;}
.evt-jupjup .prev-winners .title-h3,
.evt-jupjup .prev-winners .link,
.evt-jupjup .prev-winners .link::after {border-color:#fff; color:#fff;}

.evt-jupjup .lyr, 
.evt-jupjup .lyr-alarm {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(222,222,222,.9);}
.evt-jupjup .lyr .inner,
.evt-jupjup .lyr-alarm .inner {position:absolute; top:50%; left:50%; width:28.6rem; transform:translate(-50%,-50%);}
.evt-jupjup [class*=lyr] .btn-close {position:absolute; right:0; top:0; width:5rem; height:5rem; font-size:0;color:transparent;}
.evt-jupjup .form {display:flex; align-items:baseline; margin-top:6rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:2rem; color:#e70014;}
.evt-jupjup .form input {width:5.4rem; height:3.4rem; padding:0; font-size:1.8rem; color:#cbcbcb; background:none; border:solid #e70014; border-width:0 0 .17rem; border-radius:0; text-align:center;}
.evt-jupjup .form .btn-submit {margin-left:1rem; padding:0.2rem 1rem 0; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.8rem; color:#e70014; line-height:normal;}

.evt-jupjup .lyr-prev-winners {overflow-y:scroll;}
.evt-jupjup .lyr-prev-winners .inner {width:100%; top:4.27rem; left:0; padding-bottom:4.27rem; margin-bottom:4.27rem; background-color:#f7f7f7; transform:translate(0, 0);}
.evt-jupjup .lyr-prev-winners .btn-close {position:fixed; top:0; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104374/m/ico_close.png) center no-repeat; background-size:40%;}
.evt-jupjup .lyr-prev-winners .evt-info {margin-top:1.2rem;}
.evt-jupjup .lyr-prev-winners .evt-info .notice-list {display:block;}
.evt-jupjup .lyr-prev-winners .evt-info .btn-notice::after {display:none;}

.teaser .prev-evts {margin-top:2.41rem;}
.teaser .prev-winners {background-color:transparent;}
.teaser .prev-winners .title-h3,
.teaser .prev-winners .link,
.teaser .prev-winners .link::after {color:#222; border-color:#222;}
</style>
<script>
$(function(){
	// notice
	controlArrow();
	$('#btn_notice').click(function() {
		$("#notice_list").toggle();
		controlArrow();
	});
	// floating
	$(window).scroll(function(){
		var w = $(window).scrollTop() + $(window).height();
		var v = $('.evt-jupjup').offset().top + $('.evt-jupjup').height();
		if ( $(this).scrollTop() > 0 && w < v )
			$('#float_area').addClass('fixed');
		else
			$('#float_area').removeClass('fixed');
	});
	// alarm popup
	//$('#btn_alarm').click(function() {
	//	$('.lyr-alarm').fadeIn();
	//});

	// close popup (mask)
	$('.evt-jupjup .lyr').click(function(e){
		if ($(e.target).hasClass('lyr')) $(e.target).fadeOut();
		if ($(e.target).hasClass('lyr-alarm')) $('html, body').animate({scrollTop: $(".alarm-way").offset().top}, 500);
	});
	// close popup (btn)
	$('.evt-jupjup [class*=lyr] .btn-close').click(function() {
		$(this).parent().parent().fadeOut();
		if ($(this).parent().parent().hasClass('lyr-alarm')) $('html, body').animate({scrollTop: $(".alarm-way").offset().top}, 500);
		if ($(this).parent().parent().hasClass('lyr-prev-winners')) {
			$('html,body').animate({scrollTop : posY}, 10);
			$('html, body').removeClass('not-scroll');
			$('.lyr').fadeOut();
		}
	});
});
function controlArrow() {
	var state = $("#notice_list").is(':visible');
	if (state)	$("#btn_notice").addClass('open');
	else	$("#btn_notice").removeClass('open');
}

var userPwd = "";
var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";
var couponClick = 0;
var _itemCNT = "<%=ItemCNT%>";

$(function(){
	getEvtItemList();
	getWinners();
});

function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		data: "mode=evtobj&evt_code=<%=eCode%>",
		dataType: "json",
		success: function(res){
			// console.log(res.data)
			renderList(res.data)
		}
	})
}

function renderList(itemList){
	var $rootEl = $("#itemList")
	var itemEle = tmpEl = tmpCls = info = ""
    $rootEl.empty();
    <%'// 오픈 리스트 %>
	if(itemList.length > 0){
        //var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
        var newArr = itemList
		newArr.forEach(function(item){
            tmpCls = item.leftItems <= 0 ? "soldout" : ""
            tmpEl = '\
				<% If isTeaser Then %>\
                <div class="prd-img">\
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/108649/m/img_teaser.jpg" alt="COMING SOON">\
                </div>\
                <div class="limit-bar" id="limit-bar">알림 신청하고 기다려주세요</div>\
                <dl class="prd-info">\
                    <dt class="prd-name">상품이 곧 공개됩니다</dt>\
                </dl>\
				<% else %>\
				<div class="prd-img">\
					<img src="'+ item.mainIMG +'?v=1.05" id="prd-img" alt="'+ item.itemName +'">\
                </div>\
                <div class="limit-bar" id="limit-bar">' + item.leftItems + '개 남았습니다</div>\
                <dl class="prd-info">\
                    <dt class="prd-name">'+ item.itemName +'</dt>\
                    <dd class="prd-price">\
                        <s class="o-price"><dfn>원가</dfn>'+ item.itemPrice +'원</s>\
                        <span class="set-price"><dfn>이벤트가</dfn><b>'+ item.eventPrice +'원</b></span>\
                    </dd>\
                </dl>\
				<% end if %>\
            '
		    itemEle += tmpEl;
            $("#stp").val(item.itemCode);
			if(item.DetailitemName!=""){
				$(".notice-list .last").html("상품 상세 정보 : " + item.DetailitemName);
			}else{
				$(".notice-list .last").html("상품 상세 정보 : <% = replace(itemName,"|"," ") %>");
			}
        });
	}
	<%'// 대기 리스트 %>
	$rootEl.append(itemEle)
}

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		dataType: "JSON",
		data: 
		{
			mode: "winner",
			evt_code: "<%=eCode%>"
		},
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
	if ( $('#winner_slider').find('.swiper-slide').length > 0 ) {
		var swiper = new Swiper('#winner_slider', {
			slidesPerView: 'auto'
		});
	} else {
		$('#winner_list').prepend('<p class="no-winner">아직 당첨자가 없습니다.</p>');
	}
}

function eventTry(){
    
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
        var s;
        s=$("#stp").val();

		if(_itemCNT<1){
			alert("상품이 모두 소진되었습니다");            
			return false;
		}

		if(numOfTry == '1' && isShared != "True"){
            // 한번 시도
			$("#secondTry").show();            
			return false;
		}
		if(numOfTry == '2'){
			<% If (currentDate >= eventEndDate) Then %>
			$('#resultover2').show();
			<% else %>
			$('#trylimit').show();
			<% end if %>
			return false;
		}
        
		var returnCode, itemid, data
		var data={
			mode: "add",
			<% if mktTest then %>
			param: "mktTest",
			<% end if %>
			selectedPdt: s,
			evt_code: "<%=eCode%>"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt, res.md5userid);
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

function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= eventEndDate) Then %>
			//$("#result4").show();
			$("#result4").eq(0).delay(500).fadeIn();
			<% else %>
			$("#result3").eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		$("#itemid").val(itemid);
        $("#winImg").attr("src", "<%=prizeIMG%>?v=1.01")
        $("#useridmd5").empty().html(md5userid)
		$("#winnerPopup").eq(0).delay(500).fadeIn();
		
	}else if(returnCode == "A02"){
		numOfTry = 2
        $("#trylimit").eq(0).delay(500).fadeIn();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}

function sharesns(snsnum) {		
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		data: "mode=snschk&evt_code=<%=eCode%>&snsnum="+snsnum,
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
        url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp?mode=pushadd&evt_code=<%=eCode%>",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                //alert('신청 되었습니다.')
				$('.lyr-alarm').fadeIn();
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

function getEvtIOldtemList(eCode){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		data: "mode=evtobjold&evt_code=<%=eCode%>&eCode="+eCode,
		dataType: "json",
		success: function(res){
			 //console.log(res.data)
			renderOldList(res.data)
		}
	})
}

function renderOldList(itemList){
	var $rootEl = $("#itemListOld")
	var $rootEl2 = $("#itemListOld2")
	var $rootEl3 = $("#itemListOld3")
	var itemEle = tmpEl = tmpCls = ""
	var itemEle2 = tmpEl2 = ""
	var itemEle3 = tmpEl3 = ""
    $rootEl.empty();
	$rootEl2.empty();
	$rootEl3.empty();
    <%'// 오픈 리스트 %>
	if(itemList.length > 0){
        //var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
        var newArr = itemList
		newArr.forEach(function(item){
            tmpCls = item.leftItems <= 0 ? "soldout" : ""
            itemEle = '\
                <div class="prd-img">\
                    <img src="'+ item.mainIMG +'?v=1.05" alt="'+ item.itemName +'">\
                </div>\
                <div class="limit-bar">한정 수량 ' + item.leftItems + '개</div>\
                <dl class="prd-info">\
                    <dt class="prd-name" id="prd-name">'+ item.itemName +'</dt>\
                    <dd class="prd-price">\
                        <s class="o-price"><dfn>원가</dfn>'+ item.itemPrice +'원</s>\
                        <span class="set-price"><dfn>이벤트가</dfn><b>'+ item.eventPrice +'원</b></span>\
                    </dd>\
                </dl>\
            '
			itemEle2 = '\
                <dt>이벤트 기간</dt>\
				<dd>'+item.openDate+' - '+item.endDate+'</dd>\
            '
			itemEle3 = '\
                <dt>상 품 수 량</dt>\
				<dd>' + item.leftItems + '개</dd>\
            '
        });
	}
	<%'// 대기 리스트 %>
	$rootEl.append(itemEle)
	$rootEl2.append(itemEle2)
	$rootEl3.append(itemEle3)
}

function getOldWinners(eCode){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/tempRealtimeEventProc.asp",
		dataType: "JSON",
		data: {
			mode: "oldwinner",
			ecode: eCode,
			evt_code: "<%=eCode%>"
		},
		success : function(res){		
			renderOldWinners(res.data)
		},
		error:function(err){
			//console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}

function renderOldWinners(data){
	var $rootEl = $("#winnersOld")
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
	if ( $('#winner_sliderOld').find('.swiper-slide').length > 0 ) {
		var swiper = new Swiper('#winner_sliderOld', {
			slidesPerView: 'auto'
		});
	} else {
		$('#winner_listOld').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}
}

function fnOldEventView(eCode){
	getEvtIOldtemList(eCode);
	getOldWinners(eCode);
	$('.lyr-prev-winners').fadeIn();
}
</script>
			<div class="evt-jupjup<% If isTeaser Then %> teaser<% end if %>">
				<h2>줍줍 이벤트</h2>
				<!-- for dev msg : 상품 -->
				<div class="prd-wrap" id="itemList"></div>
				<div class="btn-area">
					<% If isTeaser Then %>
						<button type="button" class="btn-try" disabled="disabled">이벤트가 종료되었습니다</button>
					<% else %>
						<button type="button" id="btn_try" class="btn-try" onclick="eventTry();">이벤트 도전하기</button>
					<% end if %>
					<button type="button" class="btn-share" onclick="sharesns('kt');">공유하기</button>
				</div>
				<div class="evt-info">
					<dl class="row">
						<dt>이벤트 기간</dt>
						<dd><%=formatdate(eventStartDate,"00.00")%>(<%=WeekKor(weekday(eventStartDate))%>) - <%=formatdate(eventEndDate,"00.00")%>(<%=WeekKor(weekday(eventEndDate))%>)</dd>
					</dl>
					<dl class="row">
						<dt>이벤트 내용</dt>
						<dd>하루에 두 번 응모할 수 있으며, 당첨된 고객은<br> 위 상품을 구매할 수 있습니다.</dd>
					</dl>
					<dl class="row">
						<dt>상 품 수 량</dt>
						<dd><%=limitItemCNT%>개<br>당첨자에게는 상품 후기를 요청할 예정입니다.</dd>
					</dl>
					<dl class="notice">
						<dt><button type="button" id="btn_notice" class="btn-notice">유의사항 확인하기</button></dt>
						<dd id="notice_list" class="notice-list">
							<ul>
								<li>본 이벤트는 해당 상품 브랜드와 무관한 이벤트임을 알려드립니다</li>
								<li>ID 당 1일 최대 2회 응모 가능합니다.</li>
								<li>당첨자 선정은 실시간 랜덤 방식으로 진행됩니다.</li>
								<li>당첨되었으나 이벤트 기간 내 구매하지 않을 경우, 이벤트 종료 후에는 품절 처리되어 구매가 불가합니다.</li>
								<li>모든 수량이 소진되면 이벤트는 종료됩니다.</li>
								<li>5만 원 이상 상품의 당첨자에게는 세무 신고를 위해 개인 정보를 요청할 예정이며, 제세공과금은 텐바이텐 부담입니다.</li>
								<li>이벤트 당첨이 아닌 비정상적인 방법으로 상품을 구매할 시 상품 발송이 불가합니다.</li>
								<li>당첨자분들께는 개인정보 확인 후 상품이 출고될 예정이며, 상품 출고일까지 일정이 조금 소요될 수 있습니다.</li>
								<li class="last"></li>
								<% if etcText <> "" then %>
								<li><%=etcText%></li>
								<% end if %>
							</ul>
						</dd>
					</dl>
					<dl class="winner">
						<dt>당첨자 리스트</dt>
						<dd id="winner_list" class="winner-list">
							<div id="winner_slider" class="winner-slider swiper-container">
								<ul class="swiper-wrapper" id="winners"></ul>
							</div>
						</dd>
					</dl>
				</div>
				<% If currentDate < eventEndDate Then %>
				<div class="alarm">
                    <h3 class="title-h3">알림 신청하면<br>내일도 잊지 않게 알려드려요.</h3>
					<button type="button" class="btn-alarm" onclick="jsPickingUpPushSubmit()"><span>PUSH 알림 신청하기</span></button>
				</div>
				<div class="alarm-way">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/104895/m/img_push_way.png" alt="푸시 수신 설정 방법">
					<button type="button" class="btn-alarm"><span>PUSH 알림 신청하기</span></button>
					<a href="#" onclick="fnAPPpopupSetting();return false;">PUSH 알림 설정하러 가기</a>
				</div>
                <% end if %>
<%
	dim oldEvent, arrEList, intELoop, namearr
	set oldEvent = new RealtimeEventCls
	oldEvent.FRectEvtCode=eCode
	arrEList = oldEvent.getOldEventList
%>

				<% if isArray(arrEList) then %>
				<div class="prev-evts">
					<h3 class="title-h3">종료된 이벤트</h3>
					<ul>
						<!-- for dev msg : 4개까지 노출 -->
						<%For intELoop=0 To UBound(arrEList,2)%>
						<% namearr = replace(arrEList(3,intELoop),"|","") %>
						<li>
							<div class="evt-thumb"><img src="<% = arrEList(1,intELoop) %>" alt=""></div>
							<div class="evt-txt">
								<p class="prd-name"><% = namearr %></p>
								<div class="prd-price">
									<s class="o-price"><dfn>원가</dfn><% = FormatNumber(arrEList(4,intELoop),0) %>원</s>
									<span class="set-price"><dfn>이벤트가</dfn><b><% = FormatNumber(arrEList(5,intELoop),0) %>원</b></span>
								</div>
								<div class="prd-qty">수량 : <% = arrEList(2,intELoop) %>개</div>
								<button class="btn-winner" onClick="fnOldEventView(<% = arrEList(0,intELoop) %>)">당첨자 확인하기</button>
							</div>
						</li>
						<% next %>
					</ul>
				</div>
				<% end if %>
				<div class="guide prev-winners">
					<h3 class="title-h3">지난 당첨자 후기</h3>
					<a href="https://tenten.app.link/e/ONBqXc0aF8" target="_blank" class="link">인스타그램 하이라이트에서 확인하세요!</a>
				</div>
                <div class="bnr-area">
                    <a href="/event/benefit/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/img_bnr01.jpg?v=2.1" alt="텐바이텐이 처음이라면? 귀여운 상품이 500원부터!"></a>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/img_bnr01.jpg?v=2.1" alt="텐바이텐이 처음이라면? 귀여운 상품이 500원부터!"></a>
                </div>
				<% if eCode="109519" then %>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109051');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/109519/m/bnr_evt_01.jpg" alt="">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109277');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/109519/m/bnr_evt_02.jpg" alt="">
				</a>
				<% elseif eCode="110031" then %>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110036');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/110031/m/bnr_evt_01.jpg" alt="">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109585');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/110031/m/bnr_evt_02.jpg" alt="">
				</a>
				<% elseif eCode="110717" then %>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110549');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/110717/m/bnr_evt.jpg" alt="">
				</a>
				<% end if %>
				<%'<!-- 팝업 : 알림 신청 -->%>
				<div id="" class="lyr-alarm" style="display:none">
					<div class="inner">
						<a href="#" onclick="fnAPPpopupSetting();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104895/m/pop_alarm.png?v=1.1" alt="PUSH 알림 설정하러 가기"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 당첨 -->%>
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="goDirOrdItem();return false;">
							<img id="winImg" alt="당첨">
						</a>
					</div>
				</div>
				<%'<!-- 팝업  꽝 : 첫 번째 응모 시 -->%>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail1.png" alt="꽝1">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 꽝 : 공유 하지않고 두번째 응모 시 -->%>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<!-- 카카오톡 공유 -->
						<button type="button" onclick="sharesns('kt');">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_already.png" alt="이미">
						</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 꽝 : 공유 후 두번째 응모 시 -->%>
				<div id="result3" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail2.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 결과: 두번째 시도 -> 꽝(마지막날) -->%>
				<div id="result4" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fail2_last.png" alt="꽝2">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 6. 두번 응모 완료 -->%>
				<div id="trylimit" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fin.png" alt="내일">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 마지막날 --%>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/104374/m/pop_fin_last.png" alt="끝">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'<!-- 팝업 : 지난당첨자 -->%>
				<div class="lyr lyr-prev-winners">
					<div class="inner">
						<div class="prd-wrap" id="itemListOld"></div>
						<div class="evt-info">
							<dl class="row" id="itemListOld2"></dl>
							<dl class="row">
								<dt>이벤트 내용</dt>
								<dd>하루에 두 번 응모할 수 있으며, 당첨된 고객은<br> 위 상품을 구매할 수 있습니다.</dd>
							</dl>
							<dl class="row" id="itemListOld3"></dl>
							<dl class="winnerold">
								<dt>당첨자 리스트</dt>
								<dd id="winner_listOld" class="winner-list">
									<div id="winner_sliderOld" class="winner-slider swiper-container">
										<ul class="swiper-wrapper" id="winnersOld"></ul>
									</div>
								</dd>
							</dl>
						</div>
						<button type="button" class="btn-close">닫기</button>
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
        <input type="hidden" name="stp" id="stp" value="1">
    </form>
<% end if %>
<script>
$(function(){
	// teaser UI 
	if($('.evt-jupjup').hasClass('teaser')) {
		$('.teaser .evt-info .row:nth-of-type(1) dd').text('COMING SOON');
		$('.teaser .evt-info .row:nth-of-type(3) dd').text('COMING SOON');
		$('.teaser .prd-info .prd-price .o-price, .teaser .evt-info .winner, .teaser .guide:not(.prev-winners)').remove();
		$('.teaser .alarm-way').insertAfter(".prev-winners");
		$('.teaser .lyr-alarm img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/104895/m/pop_alarm_teaser.png');
		$('.teaser .notice-list .last').hide();
	}
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
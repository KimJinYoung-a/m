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
' Description : 2020 득템 이벤트
' History : 2020-01-20 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "90456"
	moECode = "90362"
Else
	eCode = "100138"
	moECode = "100137"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-01-28")		'이벤트 시작일
eventEndDate 	= cdate("2020-02-07")		'이벤트 종료일
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

	snpTitle	= Server.URLEncode("[득템의 기회!]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_share.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[득템의 기회!]"
	Dim kakaodescription : kakaodescription = "에어팟 프로가 99,000원? 지금 바로 원하는 상품에 도전하세요!"
	Dim kakaooldver : kakaooldver = "에어팟 프로가 99,000원? 지금 바로 원하는 상품에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_share.jpg"
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
%>
<link rel="stylesheet" href="//malihu.github.io/custom-scrollbar/jquery.mCustomScrollbar.min.css" />
<style type="text/css">
.mEvt100138 {background-color:#fffef4;}
.mEvt100138 button {background-color:transparent;}
.mEvt100138 .top {position:relative; margin-bottom:1.71rem;}
.mEvt100138 .top h2 {position:absolute; top:0; left:0; z-index:5; width:100%;}

.wrap .tit {position:relative; padding:3.63rem 0 2.13rem;}
.wrap .tit:before {display:inline-block; position:absolute; top:1.71rem; left:5.3%; width:1.07rem; height:1.07rem; border-radius:50%; background-color:#45e598; content:'';}
.wrap .item {position:relative; padding-top:2.56rem; background-color:#45e598; font-family:'Gulim','굴림';}
.wrap .item .thumb {position:relative;}
.wrap .item .thumb .quantity {position:absolute; top:11.14rem; left:7.3%; color:#ff0000; font-size:1.71rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.wrap .item .thumb .quantity strong {font-size:2.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.wrap .item .thumb .btn-submit {position:absolute; top:15.15rem; left:4.27%; width:13.86rem; height:5.21rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/btn_submit.png); background-size:contain; background-color:transparent; background-repeat:no-repeat; text-indent:-999em;}
.wrap2 .item .thumb .quantity, .wrap4 .item .thumb .quantity {left:56%;}
.wrap2 .item .thumb .btn-submit, .wrap4 .item .thumb .btn-submit {left:52.53%;}
.wrap2 .item, .wrap2 .tit:before {background-color:#05a7a1;}
.wrap3 .item, .wrap3 .tit:before {background-color:#ffa197;}
.wrap4 .item, .wrap4 .tit:before {background-color:#ffea00;}
.wrap.coming .item:before, .wrap.coming .item:after {position:absolute; top:0; left:0; z-index:5; content:'';}
.wrap.coming .item:before {width:100%; height:100%; background-color:rgba(255,255,255,.65); }
.wrap.coming .item:after {top:50%; left:50%; width:17.07rem; height:4.27rem; margin-left:-8.53rem; margin-top:-2.14rem; border-radius:2.05rem; background-color:#003acd; color:#fff; font-size:2.05rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';  text-align:center; line-height:4.27rem; content:'1/28 오픈';}
.wrap2.coming .item:after {content:'1/29 오픈'}
.wrap3.coming .item:after {content:'1/30 오픈'}
.wrap4.coming .item:after {content:'1/31 오픈'}

.winner {margin:4.26rem 0 4.48rem;}
.winner h3 {margin-bottom:2.99rem;}
#winner-slide .swiper-slide {width:10.29rem; margin:.64rem;}
#winner-slide .swiper-slide .thumb {width:100%; height:13.23rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_nobody.png); background-repeat:no-repeat; background-position:0 50%; background-size:100% auto;}
#winner-slide .swiper-slide .thumb1 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_win_item1.jpg)} /* 갤럭시버즈 */
#winner-slide .swiper-slide .thumb2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_win_item2.jpg)} /* 에어팟프로 */
#winner-slide .swiper-slide .thumb3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_win_item3.jpg?v=1.01)} /* 레트로 스피커 */
#winner-slide .swiper-slide .thumb4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_win_item4.jpg)} /* 마샬스피커 */
#winner-slide .swiper-slide .user-id {margin-top:.8rem; text-align:center; color:#182d9c; font-size:1.28rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

.sns-share {position:relative;}
.btn-share {display:flex; position:absolute; top:0; right:6%; width:40%; height:100%;}
.btn-share li {width:50%; height:100%;}
.btn-share li button {width:100%; height:100%; text-indent:-999em;}

.pop {display:none; position:fixed; top:0; left:0; z-index:10; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.pop .inner {position:relative; top:50%; width:80.67%; margin:-50% auto 0;}
.pop .inner .txt:before {position:absolute; top:1.7%; left:10.74%; z-index:5; width:82.64%; height:31.4%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_deco.png) no-repeat 0 50% / 100% auto; content:'';}
.pop a {position:absolute; top:22.3%; left:0;}
.pop .btn-close {position:absolute; top:1.71rem; right:5.4%; width:1.75rem; height:1.79rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100137/m/btn_close.png) no-repeat 0 50% / 100% auto;}
.pop .btn-share {top:56%; left:0; width:100%; height:25.79%;}
.pop-fail .inner {width:86%;}
</style>
<script type="text/javascript">
$(function(){
	swiper = new Swiper('#top-slide', {
		autoplay:'1000',
		effect:'fade',
		speed:10
	});
	$(".mEvt100138 .btn-close").click(function(){
		$(".mEvt100138 .pop").hide();
	});
});
</script>
<script type="text/javascript">
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	getEvtItemList();
	getWinners();
});
</script>
<script>
function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
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
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_fail2_2.png")
			$("#fail").show();
			return false;
		}
		if(numOfTry == '2'){
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_fail3.png")
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
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_fail2_1.png")
			$("#fail").show();
			return false;
		}
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_fail1.png")
		$("#fail").show();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_win_item"+ selectedPdt +".jpg?v=1.01")
		$("#win").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100137/m/pop_fail3.png")
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
		var newArr = itemList.filter(function(el){return el.leftItems != 0}).concat(itemList.filter(function(el){return el.leftItems == 0}))
		newArr.forEach(function(item){
			if(item.leftItems <= 0){ //open
				info = '<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_item'+ item.itemcode +'_out.jpg?v=1.01" alt="sold out"></div>'
			}else{
				info = '\
					<div class="thumb">\
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_item'+ item.itemcode +'.jpg?v=1.01" alt="">\
						<p class="quantity">남은수량<strong>'+ item.leftItems +'</strong>개</p>\
						<button class="btn-submit" onclick="eventTry('+ item.itemcode +')">도전하기</button>\
					</div>\
				'
			}
			tmpCls = item.isOpen ? "" : "coming"
			tmpEl = '\
				<div class="wrap wrap'+ item.itemcode +' '+ tmpCls+'">\
					<p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/tit_item'+ item.itemcode +'.png?v=1.01" alt=""></p>\
					<div class="item">\
						<div class="info"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/txt_info'+ item.itemcode +'.png?v=1.03" alt=""></div>\
						'+ info +'\
					</div>\
				</div>\
				'
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
			<div class="thumb thumb'+ winner.code +'"></div>\
			<p class="user-id">' + printUserName(winner.userid, 2, "*") + '님</p>\
		</div>\
		'
		itemEle += tmpEl
	});

	for (var i = 0; i < 35 - data.length ; i++) {
		tmpEl = '<div class="swiper-slide">\
			<div class="thumb"></div>\
			<p class="user-id"></p>\
		</div>\
		'		
		itemEle += tmpEl
	}

	$rootEl.append(itemEle)
	swiper = new Swiper('#winner-slide', {
		slidesPerView:'auto',
		initialSlide: data.length < 4 ? 0: data.length - 3
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
</script>
			<!-- 1100137 득템의 기회 -->
			<div class="mEvt100138">
				<div class="top">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/tit_top.png?v=1.02" alt="반짝 열리는 득템의 기회"></h2>
					<div id="top-slide">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_slide_top1.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_slide_top2.jpg?v=1.01" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_slide_top3.jpg?v=1.01" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_slide_top4.jpg" alt=""></div>
						</div>
					</div>
				</div>
				<div class="item-list" id="itemList">
				</div>
				<div class="winner" id="winnersContainer">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/tit_winner.png" alt="당첨자를 소개합니다"></h3>
					<div id="winner-slide">
						<div class="swiper-wrapper" id="winners"></div>
					</div>
				</div>
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/img_share.png" alt="">
					<ul class="btn-share">
						<li><button type="button" onclick="sharesns('fb')">페이스북공유</button></li>
						<li><button type="button" onclick="sharesns('ka')">카카오톡공유</button></li>
					</ul>
				</div>
				<a href="/event/eventmain.asp?eventid=100299" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100299');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/bnr_evt1.jpg" alt="급상승 검색어! 마스크, 손소독제 준비하세요"></a>
				<!--<a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100436');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/bnr_timesale.jpg" alt="커밍순 타임세일"></a>-->
				<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/txt_noti_v2.png?v=1.01" alt="이벤트 유의사항"></div>
				<%'<!-- 당첨 O -->%>
				<div class="pop" id="win">
					<div class="inner">
						<div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100137/m/txt_winner.png" alt="당첨을 축하드립니다!"></div>
						<a href="javascript:goDirOrdItem()">
							<img id="winImg" src="" alt="상품">
						</a>
					</div>
				</div>
				<%'<!-- 당첨 X -->%>
				<div class="pop pop-fail" id="fail">
					<div class="inner">
						<%
						'<!--
						'	첫번째 응모 시
						'		pop_fail1.png
						'	두번쨰 응모 시
						'		공유 X -> 응모 : pop_fail2_2.png
						'		공유 O -> 응모 : pop_fail2_1.png
						'		공유 O (마지막날) -> 응모 : pop_fail2_last.png
						'	세번째 응모 시
						'		응모 : pop_fail3.png
						'		응모 마지막날 : pop_fail3_last.png
						'-->
						%>
						<div><img id="failImg" src="" alt=""></div>
						<button class="btn-close"></button>
						<ul class="btn-share">
							<li><button type="button" onclick="sharesns('fb')">페이스북공유</button></li>
							<li><button type="button" onclick="sharesns('ka')">카카오톡공유</button></li>
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
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
' Description : 2020 Flex 이벤트
' History : 2020-02-18 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "90471"
	moECode = "90472"
Else
	eCode = "100731"
	moECode = "100730"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-02-24")		'이벤트 시작일
eventEndDate 	= cdate("2020-03-06")		'이벤트 종료일
if mktTest then
currentDate = "2020-02-24"
else
currentDate 	= date()
end if

LoginUserid		= getencLoginUserid()
IF application("Svr_Info") = "Dev" THEN
	'LoginUserid = LoginUserid + Cstr(timer())
end if
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[FLEX에 도전하라]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_share_v2.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[FLEX에 도전하라]"
	Dim kakaodescription : kakaodescription = "샤넬백이 99,000원, 이솝 핸드크림이 990원? 절대 놓치지 말아야 할 기회!"
	Dim kakaooldver : kakaooldver = "샤넬백이 99,000원, 이솝 핸드크림이 990원? 절대 놓치지 말아야 할 기회!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_share_v2.jpg"
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
<style type="text/css">
.mEvt100731 {background-color:#fffef4;}
.mEvt100731 button {background-color:transparent;}
.mEvt100731 .top {position:relative; margin-bottom:1.71rem;}
.mEvt100731 .top h2 {position:absolute; top:0; left:0; z-index:5; width:100%;}

.wrap .tit {position:relative; padding:3.63rem 0 2.13rem;}
.wrap .tit:before {display:inline-block; position:absolute; top:1.71rem; left:5.3%; width:1.07rem; height:1.07rem; border-radius:50%; background-color:#45e598; content:'';}
.wrap {position:relative; font-family:'Gulim','굴림';}
.wrap .thumb {position:relative;}
.wrap3:before, .wrap3 .thumb:before, .wrap3 .thumb:after {display:inline-block; position:absolute; top:30.36%; left:12.26%; z-index:10; width:6.5%; height:7.1%; background-size:100%; content:''; animation:flash 1s 300 both;}
.wrap3:before {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_spark1.png);}
.wrap3 .thumb:before {top:23.76%; left:22.6%; width:2.8%; height:3.5%;background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_spark2.png); animation-delay:.4s;}
.wrap3 .thumb:after {top:83.33%; left:39.6%; width:3.7%; height:4.6%;background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_spark3.png); animation-delay:.8s;}
@keyframes flash {
	0%, 100% {opacity:0;}
	50% {opacity:1;}
}
.wrap .quantity {position:absolute; top:50.7%; left:54.65%; color:#ff0000; font-size:1.54rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.wrap .quantity strong {font-size:3.41rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.wrap1 .quantity {top:48.7%; left:51.65%;}
.wrap3 .quantity {left:57.65%;}
.wrap4 .quantity {left:54.65%;}
.wrap5 .quantity {left:51.65%;}

#winner-slide {padding-bottom:4.48rem; background-color:#ffdef9;}
#winner-slide .swiper-slide {width:10.29rem; margin:0 .64rem;}
#winner-slide .swiper-slide .thumb {width:100%; height:13.23rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_nobody.jpg); background-repeat:no-repeat; background-position:0 50%; background-size:100% auto;}
#winner-slide .swiper-slide .thumb1 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_win_item1.jpg?v=1.01)} /* 이솝핸드크림 */
#winner-slide .swiper-slide .thumb2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_win_item2.jpg)} /* 바이레도향수 */
#winner-slide .swiper-slide .thumb3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_win_item3.jpg)} /* 샤넬지갑 */
#winner-slide .swiper-slide .thumb4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_win_item4.jpg)} /* APC토트백 */
#winner-slide .swiper-slide .thumb5 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_win_item5.jpg)} /* 애플워치 */
#winner-slide .swiper-slide .user-id {margin-top:.8rem; text-align:center; color:#182d9c; font-size:1.28rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

.sns-share {position:relative;}
.btn-share {display:flex; position:absolute; top:0; right:6%; width:40%; height:100%;}
.btn-share li {width:50%; height:100%;}
.btn-share li button {width:100%; height:100%; text-indent:-999em;}

.pop {display:none; position:fixed; top:0; left:0; z-index:10; width:100vw; height:100vh; background-color:rgba(0,0,0,.6);}
.pop .inner {position:relative; top:50%; width:80.67%; margin:-50% auto 0;}
.pop span {display:block; position:absolute; bottom:.3rem; left:0; width:100%; text-align:center; color:#fdb1ef;}
.pop .btn-close {position:absolute; top:1.71rem; right:5.4%; width:1.75rem; height:1.79rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100731/m/btn_close.png) no-repeat 0 50% / 100% auto;}
.pop .btn-share {top:56%; left:0; width:100%; height:25.79%;}
.pop-fail .inner {width:86%;}
</style>
<script type="text/javascript">
var userPwd = ""
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"
var couponClick = 0

$(function(){
	$(".mEvt100731 .btn-close").click(function(){
		$(".mEvt100731 .pop").hide();
	});
	getEvtItemList();
	getWinners();
});
function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			//console.log(res.data)
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
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_fail2_2.png")
			$("#fail").show();
			return false;
		}
		if(numOfTry == '2'){
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_fail3.png")
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
			$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_fail2_1.png")
			$("#fail").show();
			return false;
		}
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_fail1.png")
		$("#fail").show();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_win_item"+ selectedPdt +".jpg?v=1.01")
		$("#win").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$("#failImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/100731/m/pop_fail3.png")
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
			if (item.isOpen){
				if(item.leftItems <= 0){ //open
					info = '<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_item'+ item.itemcode +'_out.jpg?v=1.05" alt="sold out"></div>'
				}else{
					info = '\
						<button class="thumb" onclick="eventTry('+ item.itemcode +')">\
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_item'+ item.itemcode +'.jpg?v=1.04" alt="">\
						</button>\
						<p class="quantity">남은수량<strong>'+ item.leftItems +'</strong>개</p>\
					'
				}
			}
			else{
				info = '<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_item'+ item.itemcode +'_coming.jpg?v=1.05" alt=""></div>'
			}
			
			tmpEl = '\
				<div class="wrap wrap'+ item.itemcode +'">\
					'+ info +'\
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
			<!-- 100731 flex, 해버렸지 뭐야 -->
			<div class="mEvt100731">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/tit_event.jpg?v=1.01" alt="flex, 해버렸지 뭐야~"></h2>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/txt_chance1.png" alt="하루에 한 번 도전 가능합니다!"></div>
				<div class="item-list" id="itemList"></div>
				<div class="winner" id="winnersContainer">
					 <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/tit_winner.png?v=1.03" alt="당첨자를 소개합니다"></h3>
					 <div id="winner-slide">
						<div class="swiper-wrapper" id="winners"></div>
					</div>
				</div>
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/img_share.png" alt="친구에게 공유하고 한 번 더 도전하세요!">
					<ul class="btn-share">
						<li><button type="button" onclick="sharesns('fb')">페이스북공유</button></li>
						<li><button type="button" onclick="sharesns('ka')">카카오톡공유</button></li>
					</ul>
				</div>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100743');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/bnr_event1.jpg" alt="스파오 친구들 안녀엉~ 이벤트로 바로가기"></a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100725');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/bnr_event2.jpg" alt="신상품 긴급 공수! 구찌 생로랑 특가 이벤트로 바로가기"></a>
				<div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/txt_noti.png?v=1.01" alt="이벤트 유의사항"></div>
				<%'<!-- 당첨 O -->%>
				<div class="pop" id="win">
					<div class="inner">
						<div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/txt_winner.png" alt="당첨을 축하드립니다!"></div>
						<a href="javascript:goDirOrdItem()">
							<img id="winImg" src="" alt="상품">
						</a>
						<p>
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/100731/m/txt_winner_noti.png?v=1.03" alt="">
							<!--<span>난수코드:abfsafueqbglajdhnfaoisdjafihndf</span>-->
						</p>
					</div>
				</div>
				<%'<!-- 당첨 X -->%>
				<div class="pop pop-fail" id="fail">
					<div class="inner">
						<div><img id="failImg" src="" alt=""></div>
						<button class="btn-close"></button>
						<ul class="btn-share">
							<li><button type="button" onclick="sharesns('fb')">페이스북공유</button></li>
							<li><button type="button" onclick="sharesns('ka')">카카오톡공유</button></li>
						</ul>
					</div>
				</div>
			</div>
			<!-- // 100731 flex, 해버렸지 뭐야 -->
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
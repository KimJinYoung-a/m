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
' Description : 2020 사과줍줍 이벤트
' History : 2020-05-06 원승현
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "102160"
	moECode = "102520"
Else
	eCode = "102519"
	moECode = "102520"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-05-11")		'이벤트 시작일
eventEndDate 	= cdate("2020-05-20")		'이벤트 종료일
if mktTest then
    currentDate = cdate("2020-05-20")
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

	snpTitle	= Server.URLEncode("[사과 줍줍]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[사과 줍줍]"
	Dim kakaodescription : kakaodescription = "애플 제품을 1,000원에 줍줍할 수 있는 기회! 원하는 상품에 도전하세요!"
	Dim kakaooldver : kakaooldver = "애플 제품을 1,000원에 줍줍할 수 있는 기회! 원하는 상품에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_kakao.jpg"
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
.mEvt102519 {position:relative; overflow:hidden;}
.mEvt102519 button {background:none;}
.mEvt102519 .share {position:relative;}
.mEvt102519 .share button {position:absolute; left:54.5%; top:40%; width:19%; height:50%; font-size:0; color:transparent;}
.mEvt102519 .share button.btn-ka {left:74.5%;}

.topic {position:relative;}
.topic:after {content:''; position:absolute; right:11.4%; top:55%; width:10.4%; height:15%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_5.png) no-repeat 50% / 100%; animation:swing ease-in-out 1s 50 alternate;}
.topic h2,
.topic .copy p {position:absolute; left:95%; z-index:30; width:100%; transition:all 1s;}
.topic h2 { top:34.1%;}
.topic .copy p {bottom:12.7%;}
.topic.play h2,
.topic.play .copy p {left:0;}
.topic.play .copy p {transition-delay:.1s;}
.topic.play .copy p:last-child {transition-delay:.2s;}

.tree {position:relative;}
.tree p {position:fixed; left:0; top:-10%; width:100%; opacity:0; z-index:50; transition:all .4s cubic-bezier(.77,0,.175,1);}
.tree .deco {position:absolute; left:10%; top:-10%; width:100%; opacity:0; transition:all 1s;}
.tree .d3 {left:58%; top:38%; width:10.4%; opacity:1; transition:none; animation:swing ease-in-out 1s 50 alternate;}
.tree.sticky p {top:2%; opacity:1;}
.tree .d1.play,
.tree .d2.play {left:0; top:0; opacity:1; transition-delay:.4s;}
.tree .d2.play {transition-delay:.6s;}
.tree .d3.play {animation:appleAni1 1.5s 1.2s both steps(100);}
.tree:before,
.tree:after {content:''; position:absolute; left:48%; top:5%; width:10.4%; height:14%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_6.png) no-repeat 50% / 100%; animation:swing ease-in-out 1s .2s 50 alternate;  transform-origin:50% top;}
.tree:after {left:83%; top:-2%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_7.png); animation-delay:.3;}

.apple-pick {background:#28c030;}
.apple-pick li {position:relative;}
.apple-pick li.soldout::after {content:''; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_soldout_1.jpg) no-repeat 50% / 100%;}
.apple-pick li.item2.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_soldout_2.jpg);}
.apple-pick li.item3.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_soldout_3.jpg);}
.apple-pick li.item4.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_soldout_4.jpg);}
.apple-pick li.item5.soldout::after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_soldout_5.jpg);}

.picker {position:relative; font-size:1rem; background:#f3c72e;}
.picker .swiper-container {position:absolute; left:5%; top:40%; width:90%; height:44%;}
.picker .swiper-wrapper {height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/bg_apple_3.png) no-repeat 0 0 / 100% auto;}
.picker .swiper-slide {height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/bg_apple_4.png) no-repeat 0 0 / 300% auto;}
.picker .swiper-slide p {overflow:hidden; line-height:1; text-overflow:ellipsis; white-space:nowrap; text-align:center; letter-spacing:-.04rem; word-spacing:-.2rem;}
.picker .swiper-slide.item1 .name:before {content:'아이패드 프로';}
.picker .swiper-slide.item2 .name:before {content:'에어팟 프로';}
.picker .swiper-slide.item3 .name:before {content:'푸 사과주스';}
.picker .swiper-slide.item4 .name:before {content:'맥북에어';}
.picker .swiper-slide.item5 .name:before {content:'아이폰 SE';}
.picker .name {padding:58% 0 2%; font-size:4.2vw; font-weight:700; color:#444;}
.picker .user { font-size:3.7vw; color:#b39015;}
.picker button {position:absolute; top:40%; z-index:30; width:9.2%; height:22.44%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/btn_nav.png) no-repeat 50% 0 / 100% auto; font-size:0; color:transparent;}
.picker .btn-prev {left:0;}
.picker .btn-next {right:0; transform:rotate(180deg);}
.picker .swiper-button-disabled {opacity:0;}

.layer-popup {position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; padding:0 7%; background:rgba(255,255,255,.7);}
.layer-popup .layer-inner {position:absolute; left:6.5%; top:50%; transform:translateY(-50%); width:87%;}
.layer-popup .btn-close {position:absolute; right:0; top:0; width:23.72%; height:6.6rem; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/btn_close.png) no-repeat 50% / 100% auto;}
.layer-popup .btn-fb,
.layer-popup .btn-ka {position:absolute; top:40%; width:30%; height:30%; font-size:0; color:transparent;}
.layer-popup .btn-fb {left:19%;}
.layer-popup .btn-ka {left:51%;}
.layer-popup .code {position:absolute; left:0; bottom:5%; width:100%; font-size:.8rem; color:#cacaca; text-align:center;}
#winnerPopup .layer-inner:after {content:''; position:absolute; left:0; top:-2%; width:100%; height:8.88%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/102519/m/bg_pop_apple.png) no-repeat 50% 0 / 100% auto;}
@keyframes appleAni1 {
	0% {transform:rotate(0);}
	50% {transform:rotate(-160deg); left:48%; top:70%;}
	100% {transform:rotate(-380deg); left:20%; top:72%;}
}
@keyframes swing {
    0% { transform: rotate(-8deg); }
    100% { transform: rotate(8deg); }
}
</style>
<script type="text/javascript">
$(function(){

	$(".topic").addClass("play");
	$(".tree .deco").addClass("play");
	// 클릭하여 응모하세요
	var tabTop = $(".tree").offset().top,
		tabNav = $(".tree").outerHeight();
	$(window).scroll(function(){
		var share = $(".share").offset().top;
		var y = $(window).scrollTop();
		if ( tabTop <= y ) {
			$(".tree").addClass("sticky");
			//$(".tree .deco").addClass("play");
			var share = $(".share").offset().top;
			if ( y < share ) {
				$(".tree").addClass("sticky");
			}  else {
				$(".tree").removeClass("sticky");
			}
		} else {
			$(".tree").removeClass("sticky");
		}

		//$(".tree .deco").addClass("play");
	});

	// 팝업
	$(".layer-popup .btn-close").click(function(){
		$(".layer-popup").hide();
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
			$("#secondTry").show();            
			return false;
		}
		if(numOfTry == '2'){
			$("#trylimit").show();
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
function popResult(returnCode, itemid, selectedPdt, md5userid){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
            <%'<-- 공유 후 두번째 응모시 -->%>
			$("#fail2").show();
			return false;
		}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		$("#itemid").val(itemid);	
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_win_"+ selectedPdt +".png?v=1.01")
        $("#useridmd5").empty().html(md5userid)
		$("#winnerPopup").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
        $("#trylimit").show();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
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
                <li class="item'+ item.itemcode +' '+ tmpCls +'">\
                    <button onclick="eventTry('+ item.itemcode +')">\
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_item_'+ item.itemcode +'.jpg?v=1.05" alt="'+ item.itemName +'">\
                    </button>\
                </li>\
            '
		    itemEle += tmpEl        
        });
	}
	<%'// 대기 리스트 %>
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
		tmpEl = '<div class="swiper-slide item'+ winner.code +'">\
			<p class="name"></p>\
			<p class="user">' + printUserName(winner.userid, 2, "*") + '님</p>\
		</div>\
		'
		itemEle += tmpEl
	});
    $rootEl.append(itemEle)

    var winSwiper = new Swiper('.picker .swiper-container', {
        slidesPerView:3,
		initialSlide: data.length < 4 ? 0: data.length - 3,
		prevButton:'.picker .btn-prev',
    	nextButton:'.picker .btn-next'
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
<div class="mEvt102519">
    <div class="topic">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_chance.png?v=3" alt="1000원의 찬스"></p>
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/tit_apple.png" alt="사과줍줍"></h2>
        <div class="copy">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_subcopy_1.png" alt="원하는 상품을 클릭하여 줍줍!"></p>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_subcopy_2.png" alt="당첨되면 1000원에 구매!"></p>
        </div>
    </div>
    <div class="tree">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_touch.png" alt="원하는 상품을 터치해서 응모해보세요!"></p>
        <div class="deco d1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_1.png" alt=""></div>
        <div class="deco d2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_2.png" alt=""></div>
        <div class="deco d3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_deco_4.png" alt=""></div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/bg_tree.png?v=3" alt=""></div>
    </div>
    <div class="apple-pick">
        <%'<!-- for dev msg : 품절시 li 에 클래스 soldout -->%>
        <ul id="itemList"></ul>
    </div>
    <%'<!-- SNS 공유 -->%>
    <div class="share">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_share.png" alt="친구에게 공유하고 한 번 더 도전하세요">
        <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
        <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
        <%'<!-- 카카오 공유 이미지 http://webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_kakao.jpg -->%>
    </div>

    <%'<!-- 누가 줍줍 당첨자 리스트 -->%>
    <div class="picker">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/tit_who.png?v=2" alt="누가 줍줍했을까요?"></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper" id="winners">
            </div>
        </div>
        <button class="btn-prev">이전</button>
        <button class="btn-next">다음</button>
    </div>
	<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102578');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_bnr1.jpg" alt=""></a>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/txt_noti2.png" alt="이벤트 유의사항"></p>

    <%'<!-- 팝업 : 당첨 -->%>
    <div id="winnerPopup" class="layer-popup" style="display:none">
        <div class="layer-inner">
            <%'<!-- for dev msg : 당첨 이미지 5개
                'img_win_1 : 아이패드
                'img_win_2 : 에어팟
                'img_win_3 : 사과주스
                'img_win_4 : 맥북
                'img_win_5 : 아이폰
            '-->%>
            <button type="button" onclick="goDirOrdItem();"><img id="winImg" alt="당첨을 축하드립니다!"></button>
            <p class="code" id="useridmd5"></p>
        </div>
    </div>
    <%'<!-- 팝업  꽝 : 첫 번째 응모 시 -->%>
    <div class="layer-popup" style="display:none" id="fail1">
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_1.png" alt="친구에게 공유하면 한 번 더 도전할 수 있습니다"></p>
            <button type="button" class="btn-fb" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" onclick="sharesns('ka')">카카오톡으로 공유</button>
            <!-- 카카오 공유 이미지 http://webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_kakao.jpg -->
        </div>
    </div>
    <%'<!-- 팝업 꽝 : 공유 하지않고 두번째 응모 시 -->%>
    <div class="layer-popup" style="display:none" id="secondTry">
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_noshare.png" alt="이미 1회 응모하였습니다"></p>
            <button type="button" class="btn-fb" style="margin-top:14%;" onclick="sharesns('fb')">페이스북으로 공유</button>
            <button type="button" class="btn-ka" style="margin-top:14%;" onclick="sharesns('ka')">카카오톡으로 공유</button>
            <!-- 카카오 공유 이미지 http://webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_kakao.jpg -->
        </div>
    </div>
    <%'<!-- 팝업 꽝 : 공유 후 두번째 응모 시 -->%>
    <div class="layer-popup" style="display:none" id="fail2">
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <% If currentDate >= eventEndDate Then %>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_3.png" alt="응모해주셔서 감사합니다"></p>
            <% Else %>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_2.png" alt="내일 다시 도전해보세요"></p>
            <% End If %>
        </div>
    </div>

    <%'<!-- 팝업 6. 두번 응모 완료 -->%>
    <div class="layer-popup" style="display:none" id="trylimit">
        <div class="layer-inner">
            <button type="button" class="btn-close">닫기</button>
            <% If currentDate >= eventEndDate Then %>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_fin_last.png" alt="응모해주셔서 감사합니다"></p>            
            <% Else %>
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102519/m/img_fail_fin.png" alt="내일 또 도전해 주세요"></p>
            <% End If %>
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
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
' Description : 텐텐 분실물 센터 이벤트
' History : 2020.05.27 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "102175"
	moECode = "102176"
Else
	eCode = "103029"
	moECode = "103030"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-06-01")		'이벤트 시작일
eventEndDate 	= cdate("2020-06-11")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
	'currentDate = #06/10/2020 09:00:00#
	currentDate = #06/06/2020 09:00:00#
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

snpTitle	= Server.URLEncode("[텐텐 분실물 센터] 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐텐 분실물 센터] 이벤트"
Dim kakaodescription : kakaodescription = "어, 혹시 이거 주인 아니세요? 지금 텐텐 분실물센터에서 확인해보세요!"
Dim kakaooldver : kakaooldver = "어, 혹시 이거 주인 아니세요? 지금 텐텐 분실물센터에서 확인해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt103029 {background-color:#000;}
.mEvt103029 button {background-color:transparent;}

.prize-list {display:flex; flex-wrap:wrap; padding:2.66vw 4.26vw 12.64vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bg_list.jpg) no-repeat 50% 50%; background-size:100% 100%;}
.prize-list li {width:50%; margin-top:11.97vw; text-align:center;}
.prize-list li button {overflow:visible; text-align:center;}
.prize-list .thumb {width:26.87vw; margin:0 auto; animation-name:swing; animation-duration:3s; animation-iteration-count:10;}
.prize-list li:nth-child(2) .thumb {animation-delay:.5s;}
.prize-list li:nth-child(3) .thumb {animation-delay:1s;}
.prize-list li:nth-child(4) .thumb {animation-delay:1.5s;}
.prize-list li:nth-child(5) .thumb {animation-delay:2s;}
.prize-list li:nth-child(6) .thumb {animation-delay:2.5s;}
.prize-list .name {display:inline-block; height:1.91rem; margin-top:3.19vw; padding:0 1.476vw; border-radius:.43rem; background-color:rgba(215, 215, 215, .3); color:#fff; font-size:1.28rem; line-height:2.21rem; white-space:nowrap; vertical-align:bottom;}
@keyframes swing {
	0%,10%,100% {transform: rotate3d(0, 0, 1, 0deg);}
	4% {transform: rotate3d(0, 0, 1, 8deg);}
	8% {transform: rotate3d(0, 0, 1, -6deg);}
}

.noti {position:relative;}
.noti a {display:inline-block; position:absolute; bottom:25.1%; left:25%; width:24.8%; height:6%; text-indent:-999em;}

.winner {position:relative; display:flex; align-items:center; height:3rem; background-color:#fff; color:#666; font-size:1.37rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.winner:after {display:block; position:absolute; top:-1%; z-index:20; width:100%; height:102%; content:'';}
.winner .tit-winner {width:28.93%;}
.winner .winner-list {overflow:hidden; display:flex; width:71.07%; height:100%;}
.winner .winner-info {display:flex; justify-content:space-between; align-items:center; height:100%; padding-top:.3rem; padding-right:5.72vw;}
.winner .winner-info .winner-name {padding-left:1.58rem;}
.winner .winner-info .prize {display:inline-block; padding-left:2.13rem;}

.insta {position:relative; top:-.005rem;}
.lyr {overflow-y:scroll; display:flex; position:relative; flex-wrap:wrap; align-items:center; width:32rem; height:100vh; margin:0 auto; padding:5vh 0; background-color:#000;}
.lyr .thumb {width:50%; margin:13.97vw auto 0;}
.lyr .name {margin-top:8.78vw; font-size:4.79vw; color:#44ffa0; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.lyr .name .option {margin-top:2.4vw; font-size:4.26vw; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight';}
.lyr .bnr {position:absolute; bottom:0; left:0;}
.lyr.has-bnr {padding-bottom:23.94vw;}
.apply .touch .txt2 {margin-bottom:7.98vw;}
.apply .btn-finger.on {animation:heart 1s 10 both;}
.apply .btn-main {position:absolute; top:0; right:0; width:15.96vw;}
.checking .finger-checking {margin-top:17.29vw;}
.result .noti {margin-top:17.29vw;}
.result .already {margin-bottom:29.26vw;}
.result.has-bnr .finger{margin:15.96vw 0 23.94vw;}
@keyframes heart {
	from, to {transform:scale(1.0); animation-timing-function:ease-out; opacity:.6;}
	50% {transform:scale(1.1); animation-timing-function:ease-in; opacity:1;}
}
</style>
<script type="text/javascript">
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>";
var prizeInfo = [
	{name:'빨간 아이폰 SE', option:'2세대 레드 64GB'}, 
	{name:'판도라 반지 50호', option:'링크드 러브 실버'}, 
	{name:'에어팟 프로', option:' '},
	{name:'갈색 A.P.C 지갑', option:'Demi-Lune Compact Wallet'},
	{name:'은색 아이패드 미니', option:'64GB 실버'},
	{name:'에르메스 립스틱', option:'64호 루즈 까자크'}
]

$(function(){
	getEvtItemList();
	getWinners();

	// control layer
	$('.lyr .bnr').parent('.lyr').addClass('has-bnr');
	$('.lyr').hide();

	$('.mEvt103029 .bnr').attr('onclick',"fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102634'); target='blank'");

	$('.btn-main').click(function (e) { 
		$('.lyr').hide();
		$('.main').show();
	});
});
function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
		data: "mode=evtobj2",
		dataType: "json",
		success: function(res){
			//console.log(res.data)
			renderList(res.data)
		}
	})
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
					info = '<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item'+ item.itemcode +'_sold.png?v=1.02" alt="sold out"></div>\
					<div class="name">'+ item.itemName +'</div>\
					'
				}else{
					info = "\
						<button class='thumb' onclick='choiceItem("+ item.itemcode +",\""+ item.itemName +"\",\""+ item.itemOption +"\")'>\
							<img src='//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item"+ item.itemcode +".png?v=1.04' alt=''>\
						</button>\
						<div class='name'>"+ item.itemName +"</div>\
					"
				}
			}
			else{
				info = "\
						<button class='thumb' onclick='choiceItem("+ item.itemcode +",\""+ item.itemName +"\",\""+ item.itemOption +"\")'>\
							<img src='//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item"+ item.itemcode +".png?v=1.04' alt=''>\
						</button>\
						<div class='name'>"+ item.itemName +"</div>\
					"
			}
			
			tmpEl = '\
				<li>\
					'+ info +'\
				</li>\
				'
			itemEle += tmpEl
		});
	}
	// 대기 리스트
	$rootEl.append(itemEle)
}

function choiceItem(code, name, option){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate < eventEndDate) Then %>
			if(numOfTry == '1' && isShared != "True"){
				// 한번 시도
				alert("이미 1회 응모하였습니다.\n친구에게 공유하면 한 번 더 기회를 드립니다!");
				return false;
			}
			if(numOfTry == '2'){
				alert("이미 2회 응모하였습니다.\n내일 다시 도전해보세요!");
				return false;
			}
			$('.lyr .thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item'+ code +'.png');
			$('.lyr .name').html(name + '<p class="option">'+ option +'</p>')
			scrolling();
			$('.main').hide();
			$('.apply').show();
			$('.apply .btn-finger').addClass('on');
			$("#code").val(code);
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function scrolling(){
	$('html, body').animate({scrollTop: $(".mEvt103029").offset().top}, 10);
}

function changingImg(){
	var i=1;
	var repeat = setInterval(function(){
		i++;
		if(i>4){clearIntercal(repeat);}
		$('.finger-checking img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_finger'+ i +'.png');
	},500);
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
	var ix=0;
	$rootEl.empty();
	data.forEach(function(winner){
		tmpEl = '<div class="swiper-slide">\
			<div class="winner-info">\
			<div class="winner-nam">' + printUserName(winner.userid, 2, "*") + '</div>\
			<span class="prize">' + prizeInfo[(winner.code-1)].name + '</span>\
		</div></div>\
		'
		itemEle += tmpEl
		ix += 1;
	});
	if(ix==0){
		itemEle = '<div class="swiper-slide">\
			<div class="winner-info">\
				<div class="winner-nam">아직 당첨자가 없습니다!</div>\
			</div>\
		</div>\
		'
	}

	$rootEl.append(itemEle)

	// winner swiper
	if($(".winner-list .swiper-slide").length > 1){
		var swiperWinner = new Swiper('.winner-list ', {
			direction:'vertical',
			loop:true,
			speed:800,
			autoplay:900
		});
	}
}

function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		
		<% If (currentDate >= eventStartDate And currentDate < eventEndDate) Then %>
//========\
		if(numOfTry == '1' && isShared != "True"){
			// 한번 시도
			$('.lyr').hide();
			$('#result2').show();
			return false;
		}
		if(numOfTry == '2'){
			$('.lyr').hide();
			<% If (currentDate >= #06/10/2020 00:00:00#) Then %>
			$('#resultover2').show();
			<% else %>
			$('#resultover').show();
			<% end if %>
			return false;
		}
		var selectitem = $("#code").val();
		if(selectitem==""){
			alert("상품을 다시 선택해주세요.");
			document.location.reload();
			return false;
		}

		$('.apply').hide();
		$('.checking').show();
		changingImg();
		setTimeout(function(){
			scrolling();
			$('.checking').hide()
			fnAuthorizationStart();
		} , 2000);

//=============		

		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}

function fnAuthorizationStart(){
	var s = $("#code").val();
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
						$('.main').show();
						$('.lyr').hide();
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
}

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){
		if(numOfTry >= 2){
			<% If (currentDate >= #06/10/2020 00:00:00#) Then %>
			$("#result4").show();
			<% else %>
			$("#result3").show();
			<% end if %>
			return false;
		}
		$("#result").show();
	}else if(returnCode[0] == "C"){
		$("#resultC").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$("#resultover").show();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}
</script>

			<div class="mEvt103029">
				<!-- 메인 -->
				<div class="main">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/tit_lost.png?v=2" alt="텐텐 분실물 센터"></h2>
					<ul class="prize-list" id="itemList"></ul>
					<button class="btn-share" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_share.jpg" alt="친구에게 공유하고 한 번 더 도전하자!"></button>
					<div class="winner">
						<p class="tit-winner"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/tit_winner.png" alt="당첨자"></p>
						<div class="winner-list swiper-container">
							<div class="swiper-wrapper" id="winners"></div>
						</div>
					</div>
					<a href="https://tenten.app.link/e/iZoi6hfNG6" class="insta"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_insta.png" alt="지난 당첨자 후기는  인스타그램 하이라이트에서 확인!"></a>
					<a href="" class="bnr"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bnr_img1.jpg" alt="귀여운 파우치 사면 세상 행복해! 이벤트로 이동"></a>
					<div class="noti">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_noti.png" alt="이벤트 유의사항">
						<a href="/category/category_itemPrd.asp?itemid=2501734&pEtr=102437" onclick="TnGotoProduct('2501734');return false;">상품자세히보기</a>
					</div>
				</div>

				<!-- 응모 -->
				<div class="lyr apply">
					<div class="prize">
						<p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_apply.png" alt="아래 상품에 도전하시겠어요?"></p>
						<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item2.png" alt=""></div>
						<div class="name"><p class="option">링크드 러브 실버</p></div>
					</div>
					<div class="touch">
						<p class="txt2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_touch.png" alt="엄지손가락으로 살짝 터치해주세요"><input type="hidden" name="code" id="code"></p>
						<button class="btn-finger" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/btn_finger.png" alt=""></button>
					</div>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/btn_close.png" alt="메인으로 가기"></button>
				</div> 

				<!-- 지문인식중 -->
				<div class="lyr checking">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_checking1.png" alt="지문 일치 확인중..."></p>
						<div class="finger-checking"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_finger1.png" alt=""></div>
					</div>
				</div> 

				<!-- 결과: 당첨 -->
				<div class="lyr result" id="resultC"> 
					<div class="prize">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_win1.png" alt="지문 인식 성공! 상품을 데려가세요!"></p>
						<div class="thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_item2.png" alt=""></div>
						<div class="name">판도라 반지 (50사이즈)<p class="option">링크드 러브 실버</p></div>
						<p class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_win2.png" alt="당첨 상품은 개별 연락 후 발송될 예정입니다. 연락을 기다려주세요!"></p>
					</div>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
				</div>

				<!-- 결과: 첫번째 시도 -> 꽝  -->
				<div class="lyr result" id="result">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_fail1.png" alt="지문 불일치! 아쉽게도 일치하지 않습니다"></p>
					<div class="finger"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_finger_grey.png" alt=""></div>
					<button class="btn-share" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/btn_share.png" alt="친구에게 공유하면 한 번 더 기회를 드립니다!"></button>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
				</div>

				<!-- 결과: 두번째 시도  -> 공유X -->
				<div class="lyr result" id="result2">
					<div>
						<p class="already"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_already.png" alt="이미 1회 응모하였습니다"></p>
						<button class="btn-share" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/btn_share.png" alt="친구에게 공유하면 한 번 더 기회를 드립니다! "></button>
					</div>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
				</div>

				<!-- 결과: 두번째 시도 -> 꽝 -->
				<div class="lyr result" id="result3">
					<div>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_fail1.png" alt="지문 불일치! 아쉽게도 일치하지 않습니다"></p>
						<div class="finger"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_finger_grey.png" alt=""></div>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_tmr.png" alt="내일 다시 도전해보세요!"></p>
					</div>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
					<a href="" class="bnr"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bnr_img1.jpg" alt="귀여운 파우치 사면 세상 행복해! 이벤트로 이동"></a>
				</div>

				<!-- 결과: 두번째 시도 -> 꽝(마지막날) -->
				<div class="lyr result" id="result4">
					<div>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_fail1.png" alt="지문 불일치! 아쉽게도 일치하지 않습니다"></p>
						<div class="finger"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/img_finger_grey.png" alt=""></div>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_thx.png" alt=""></p>
					</div>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
					<a href="" class="bnr"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bnr_img1.jpg" alt="귀여운 파우치 사면 세상 행복해! 이벤트로 이동"></a>
				</div>
				
				<!-- 결과: 세번째 시도 -> 응모횟수 초과  -->
				<div class="lyr result-over" id="resultover">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_comp1.png" alt="오늘의 응모는 모두 완료! 내일 또 도전해주세요!"></p>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
					<a href="" class="bnr"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bnr_img1.jpg" alt="귀여운 파우치 사면 세상 행복해! 이벤트로 이동"></a>
				</div>

				<!-- 결과: 세번째 시도 -> 응모횟수 초과(마지막날) -->
				<div class="lyr result-over" id="resultover2">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_comp2.png" alt="오늘의 응모는 모두 완료! 감사합니다."></p>
					<button class="btn-main"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/txt_main.png" alt="메인으로 가기"></button>
					<a href="" class="bnr"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103029/m/bnr_img1.jpg" alt="귀여운 파우치 사면 세상 행복해! 이벤트로 이동"></a>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
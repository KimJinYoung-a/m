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
' Description : 2020 1일1줍 이벤트
' History : 2020.06.08 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "102180"
	moECode = "102179"
Else
	eCode = "103392"
	moECode = "103391"
End If

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	mktTest = true
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
'	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
'	Response.End
End If

eventStartDate  = cdate("2020-06-15")		'이벤트 시작일
eventEndDate 	= cdate("2020-06-25")		'이벤트 종료일

if mktTest then
    currentDate = cdate("2020-06-15")
else
    currentDate = date()
end if

IF application("Svr_Info") = "Dev" THEN
	'LoginUserid = LoginUserid + Cstr(timer())
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[1일1줍 하세요!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[1일1줍 하세요!]"
Dim kakaodescription : kakaodescription = "화려한 조명 속의 상품에 도전하세요! 1일 3줍까지 가능합니다."
Dim kakaooldver : kakaooldver = "화려한 조명 속의 상품에 도전하세요! 1일 3줍까지 가능합니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim isSecondTried
dim isFirstTried, isThirdTried
dim triedNum : triedNum = 0
dim isSharedCnt : isSharedCnt = 0
isSecondTried = false
isThirdTried = false

if LoginUserid <> "" then
	set pwdEvent = new RealtimeEventCls
	pwdEvent.evtCode = eCode
	pwdEvent.userid = LoginUserid
	isThirdTried = pwdEvent.isParticipationDayBase(3)
    isSecondTried = pwdEvent.isParticipationDayBase(2)
	isFirstTried = pwdEvent.isParticipationDayBase(1)
	isSharedCnt = pwdEvent.isSnsSharedCnt
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
triedNum = chkIIF(isThirdTried, 3, triedNum)
%>
<style>
.mEvt103392 {position:relative; overflow:hidden; background:#0b40a2;}
.mEvt103392 .topic {position:relative;}
.mEvt103392 .topic .cap {position:absolute; top:0; left:0; width:100%; animation:pulse 1s both;}
@keyframes pulse {
	0% {opacity:0; transform:scale3d(0.95,0.95,0.95);}
	50% {opacity:1; transform:scale3d(1.05,1.05,1.05);}
	100% {transform:scale3d(1,1,1);}
}
.mEvt103392 .item-list li {position:relative;}
.mEvt103392 .item-list li button {display:block; width:100%; padding-top:85.3%; font-size:0; background-color:transparent; background-position:0 0; background-size:auto 100%;}
.mEvt103392 .item-list li.item1 button {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item1.jpg);}
.mEvt103392 .item-list li.item2 button {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item2.jpg?v=1.03);}
.mEvt103392 .item-list li.item3 button {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item3.jpg);}
.mEvt103392 .item-list li.item4 button {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item4.jpg);}
.mEvt103392 .item-list li.item5 button {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item5.jpg);}
.mEvt103392 .item-list li.on button {background-position:100% 0;}
.mEvt103392 .item-list li.soldout:after {content:'품절'; position:absolute; left:0; top:0; width:100%; height:100%; font-size:0; background-position:0 0; background-size:100% auto;}
.mEvt103392 .item-list li.item1.soldout:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item1_so.jpg);}
.mEvt103392 .item-list li.item2.soldout:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item2_so.jpg?v=1.03);}
.mEvt103392 .item-list li.item3.soldout:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item3_so.jpg);}
.mEvt103392 .item-list li.item4.soldout:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item4_so.jpg);}
.mEvt103392 .item-list li.item5.soldout:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_item5_so.jpg);}
.mEvt103392 .share {position:relative;}
.mEvt103392 .share .bnr-kakao {position:absolute; left:0; bottom:0; width:100%; height:70%; font-size:0; background:none;}
.mEvt103392 .winner {position:relative; height:10vw; padding:0 8vw 0 34vw; background:#fff;}
.mEvt103392 .tit-winner {position:absolute; top:0; left:0; height:100%;}
.mEvt103392 .tit-winner img {width:auto; height:100%;}
.mEvt103392 .winner-list, .winner-list .swiper-wrapper {height:100%;}
.mEvt103392 .winner-info {display:flex; align-items:center; justify-content:space-between; height:100%; font-size:4vw; color:#666;}
.mEvt103392 .bnr-floating {position:fixed; left:0; top:-5%; z-index:10; width:100%; opacity:0; transition:0.8s;}
.mEvt103392 .bnr-floating.on {top:2%; opacity:1;}
.mEvt103392 .lyr {display:none; position:fixed; top:0; left:0; z-index:50; width:100%; height:100%; background:rgba(0,0,0,0.5);}
.mEvt103392 .lyr .inner {position:absolute; top:50%; left:8%; width:84%; transform:translateY(-50%);}
.mEvt103392 .lyr .btn-kakao {position:absolute; left:0; bottom:0; width:100%; height:50%; font-size:0; background:none;}
.mEvt103392 .lyr .btn-close {position:absolute; right:0; top:0; width:14vw; height:14vw; font-size:0; background:none;}
/* 당첨자 레이어 팝업 추가 */
.mEvt103392 .btn-more {display:block; width:100%;}
.winner-more {overflow-y:auto; position:absolute; left:0; top:20%; width:100%; height:70%; text-align:center; line-height:2;}
.winner-more dt {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.37rem; color:#46e3ff;}
.winner-more dd {margin-bottom:0.5rem;}
.winner-more .no-data {font-size:1rem; color:rgba(255,255,255,0.3);}
.winner-more ul {display:flex; flex-wrap:wrap; padding:0 10% 0 15%;}
.winner-more ul li {overflow:hidden; width:30%; margin-left:5%; font-size:1.1rem; color:#fff; text-align:left;}
.winner-more ul li:nth-child(3n+1) {margin-left:0;}
</style>
<script>
$(function(){
	$(window).on('scroll', function(){
		// spotlight
		$('.item-list li').each(function(i, el) {
			if ($(el).offset().top < $(window).scrollTop()+$(window).height()/2) {
				$(el).addClass('on');
			}
		});
		// floating
		if ($(window).scrollTop() > $('.item-list').offset().top) {
			$('.bnr-floating').addClass('on');
		} else {
			$('.bnr-floating').removeClass('on');
		}
	});

	// close popup
	$('.lyr .btn-close').click(function(){
		$(this).closest('.lyr').hide();
	});
	// try
	$('.item-list li button').click(function(){
		$('.lyr').eq(1).show();
	});
});
</script>
<script type="text/javascript">
var userPwd = ""
var numOfTry = "<%=triedNum%>";
var isSharedCnt = <%=isSharedCnt%>;
var prizeInfo = [
	{name:'아이패드 프로', option:'11인치 128GB 실버'}, 
	{name:'헌터 부츠(240)', option:'블랙 240'}, 
	{name:'에어팟 프로', option:' '},
	{name:'스누피 마테홀더', option:'색상랜덤'},
	{name:'마샬 스피커', option:'블랙'}
]

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
		<% If (currentDate >= eventStartDate And currentDate < eventEndDate) or mktTest Then %>
//========\
		if(numOfTry == '1' && isSharedCnt < 1){
            // 한번 시도
			$("#secondTry").show();
			return false;
		}
		if(numOfTry == '2' && isSharedCnt < 2){
            // 한번 시도
			$("#thirdTry").show();
			return false;
		}
		if(numOfTry == '4'){
			<% If (currentDate >= #06/24/2020 00:00:00#) Then %>
			$('#resultover2').show();
			<% else %>
			$('#resultover').show();
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
				isSharedCnt += 1;
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
		if(numOfTry >= 3){
            <%'<-- 공유 후 세번째 응모시 -->%>
			<% If (currentDate >= #06/24/2020 00:00:00#) Then %>
			$('#fail3').show();
			<% else %>
			$('#fail2').show();
			<% end if %>
			return false;
		}
		$("#fail1").show();
	}else if(returnCode[0] == "C"){		
        <%'<-- 당첨 -->%>
		$("#itemid").val(itemid);
        $("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_win"+ selectedPdt +".png?v=1.01");
        //$("#useridmd5").empty().html(md5userid);
		$("#winnerPopup").show();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$('#secondTry').show();
	}else if(returnCode == "A04"){
		numOfTry = 3
		<% If (currentDate >= #06/24/2020 00:00:00#) Then %>
		$('#resultover2').show();
		<% else %>
		$('#resultover').show();
		<% end if %>
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
                    <button onclick="eventTry('+ item.itemcode +')">'+ item.itemName +'</button>\
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
	var ix=0;
	$rootEl.empty();

	data.forEach(function(winner){
		tmpEl = '<div class="swiper-slide">\
			<div class="winner-info">\
				<span class="userid">' + printUserName(winner.userid, 2, "*") + '</span>\
				<span class="prize">' + prizeInfo[(winner.code-1)].name + '</span>\
			</div>\
		</div>\
		'
		itemEle += tmpEl
		ix += 1;
	});
	if(ix==0){
		itemEle = '<div class="swiper-slide">\
			<div class="winner-info">아직 당첨자가 없습니다!</div>\
		</div>\
		'
	}
    $rootEl.append(itemEle)

	// winner slider
	if($(".winner-list .swiper-slide").length > 1){
		var swiper = new Swiper('.winner-list', {
			direction: 'vertical',
			loop: true,
			speed: 1000,
			autoplay: 2500,
			autoplayDisableOnInteraction: false
		});
	}
}

function getWinnersPopup(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/realtimeEventProc.asp",
		dataType: "JSON",
		data: { mode: "winnerpop" },
		success : function(res){		
			renderWinnersPopup(res.data)
		},
		error:function(err){
			console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}

function renderWinnersPopup(data){
	var itemEle = tmpEl = ""
	var ix1=0;
	var ix2=0;
	var ix3=0;
	var ix4=0;
	var ix5=0;
	$("#WinnersPopup").show();

	data.forEach(function(winner){
		if(winner.code==1){
			ix1 += 1;
		}
		if(winner.code==2){
			ix2 += 1;
		}
		if(winner.code==3){
			ix3 += 1;
		}
		if(winner.code==4){
			ix4 += 1;
		}
		if(winner.code==5){
			ix5 += 1;
		}
	});
	if(ix1 >0){
		$("#winitem1").empty();
		tmpEl = '<ul>'
		data.forEach(function(winner){
			if(winner.code==1){
				tmpEl = tmpEl + '<li>' + printUserName(winner.userid, 2, "*") + '</li>'
			}
		});
		tmpEl = tmpEl + '</ul>'
		$("#winitem1").append(tmpEl);
	}
	if(ix2 >0){
		$("#winitem2").empty();
		tmpEl = '<ul>'
		data.forEach(function(winner){
			if(winner.code==2){
				tmpEl = tmpEl + '<li>' + printUserName(winner.userid, 2, "*") + '</li>'
			}
		});
		tmpEl = tmpEl + '</ul>'
		$("#winitem2").append(tmpEl);
	}
	if(ix3 >0){
		$("#winitem3").empty();
		tmpEl = '<ul>'
		data.forEach(function(winner){
			if(winner.code==3){
				tmpEl = tmpEl + '<li>' + printUserName(winner.userid, 2, "*") + '</li>'
			}
		});
		tmpEl = tmpEl + '</ul>'
		$("#winitem3").append(tmpEl);
	}
	if(ix4 >0){
		$("#winitem4").empty();
		tmpEl = '<ul>'
		data.forEach(function(winner){
			if(winner.code==4){
				tmpEl = tmpEl + '<li>' + printUserName(winner.userid, 2, "*") + '</li>'
			}
		});
		tmpEl = tmpEl + '</ul>'
		$("#winitem4").append(tmpEl);
	}
	if(ix5 >0){
		$("#winitem5").empty();
		tmpEl = '<ul>'
		data.forEach(function(winner){
			if(winner.code==5){
				tmpEl = tmpEl + '<li>' + printUserName(winner.userid, 2, "*") + '</li>'
			}
		});
		tmpEl = tmpEl + '</ul>'
		$("#winitem5").append(tmpEl);
	}
}

function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If (currentDate >= eventStartDate And currentDate < eventEndDate) or mktTest Then %>		
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>

			<div class="mEvt103392">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/tit_gang_v2.jpg" alt="1일 1줍"></h2>
					<span class="cap"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/img_cap.png" alt=""></span>
				</div>
				<div class="bnr-floating"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/bnr_floating.png" alt=""></div>
				<div class="item-list">
					<ul id="itemList"></ul>
				</div>
				<div class="share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/bnr_share.jpg" alt="이벤트 기간">
					<button type="button" class="bnr-kakao" onclick="sharesns('ka')">카카오톡 공유</button>
				</div>
				<div class="winner">
					<h3 class="tit-winner"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/tit_winner.png" alt="당첨자"></h3>
					<div class="winner-list swiper-container">
						<div class="swiper-wrapper" id="winners"></div>
					</div>
				</div>
				<button type="button" class="btn-more" onclick="getWinnersPopup();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/btn_more.png" alt="자세히보기"></button>
				<a href="https://tenten.app.link/e/brg7xubH36"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/bnr_insta.jpg" alt="인스타그램"></a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=103444');" target="_blank">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/bnr_evt.png" alt="1+1 아이템 모음전">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/txt_noti.jpg?v=1.01" alt="이벤트 유의사항"></p>

				<%'!-- 팝업 1. 당첨 --%>
				<div id="winnerPopup" class="lyr" style="display:none">
					<div class="inner">
						<a href="" onclick="goDirOrdItem();return false;">
							<img id="winImg" alt="당첨을 축하드립니다!">
						</a>
					</div>
				</div>
				<%'!-- 팝업 : 꽝 (1,2번째 응모) --%>
				<div id="fail1" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_fail1.png" alt="아쉽게도 줍줍에 실패했습니다">
						<button type="button" onclick="sharesns('ka');" class="btn-kakao">카카오톡 공유</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 공유 안하고 재응모 (2번째) --%>
				<div id="secondTry" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_already1.png" alt="이미 1회 응모하였습니다">
						<button type="button" onclick="sharesns('ka');" class="btn-kakao">카카오톡 공유</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 공유 안하고 재응모 (3번째) --%>
				<div id="thirdTry" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_already2.png" alt="이미 2회 응모하였습니다">
						<button type="button" onclick="sharesns('ka');" class="btn-kakao">카카오톡 공유</button>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 꽝 (3번째 응모) --%>
				<div id="fail2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_fail2.png" alt="아쉽게도 당첨되지 않았습니다 내일 다시 도전해보세요">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 꽝 (3번째 응모) (마지막날) --%>
				<div id="fail3" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_fail2_last.png" alt="아쉽게도 당첨되지 않았습니다 응모해주셔서 감사합니다">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 --%>
				<div id="resultover" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_fin.png" alt="오늘의 응모는 모두 완료 내일 또 도전해 주세요">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 응모 횟수 초과 (마지막날) --%>
				<div id="resultover2" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_fin_last.png" alt="오늘의 응모는 모두 완료 응모해주셔서 감사합니다">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
				<%'!-- 팝업 : 당첨자 리스트 --%>
				<div id="WinnersPopup" class="lyr" style="display:none">
					<div class="inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/103392/m/pop_winner.png" alt="당첨자 리스트">
						<dl class="winner-more">
							<dt>아이패드 프로</dt>
							<dd id="winitem1">
								<p class="no-data">아직 당첨자가 없습니다!</p>
							</dd>
							<dt>헌터 부츠</dt>
							<dd id="winitem2">
								<p class="no-data">아직 당첨자가 없습니다!</p>
							</dd>
							<dt>에어팟 프로</dt>
							<dd id="winitem3">
								<p class="no-data">아직 당첨자가 없습니다!</p>
							</dd>
							<dt>스누피 마테홀더</dt>
							<dd id="winitem4">
								<p class="no-data">아직 당첨자가 없습니다!</p>
							</dd>
							<dt>마샬 스피커</dt>
							<dd id="winitem5">
								<p class="no-data">아직 당첨자가 없습니다!</p>
							</dd>
						</dl>
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
    </form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
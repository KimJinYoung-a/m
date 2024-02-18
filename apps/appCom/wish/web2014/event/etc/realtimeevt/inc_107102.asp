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
' Description : 2020 11을 뽑아라 이벤트
' History : 2020-11-04 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "103250"
	moECode = "103238"
Else
	eCode = "107102"
	moECode = "107094"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-11-09")		'이벤트 시작일
eventEndDate 	= cdate("2020-11-16")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	mktTest = False
end if

if mktTest then
    currentDate = cdate("2020-11-09")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[11을 뽑아라 이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[11을 뽑아라 이벤트]"
Dim kakaodescription : kakaodescription = "에어팟 프로부터 아이패드까지! 마치 숫자 11처럼 생긴 행운의 상품들을 뽑아보세요."
Dim kakaooldver : kakaooldver = "에어팟 프로부터 아이패드까지! 마치 숫자 11처럼 생긴 행운의 상품들을 뽑아보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_kakao.jpg"
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
.mEvt107102 .topic {position:relative; background:#41387e;}
.mEvt107102 .section-01 {padding-bottom:4.21rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107102/m/bg_contents.png) repeat;}
.mEvt107102 .section-01 .item-list-container {display:flex; align-items:flex-start; justify-content:center; padding:0 1.73rem;}
.mEvt107102 .section-01 .item-list-container.list-02 {padding-top:3.78rem;}
.mEvt107102 .section-01 .item-list-container .item-02 {padding:0 0.86rem;}
.mEvt107102 .section-01 .item-list-container .info-area {padding-top:0.95rem; text-align:center;}
.mEvt107102 .section-01 .item-list-container .info-area .tit {font-size:1.13rem; color:#cdc6ff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt107102 .section-01 .item-list-container .info-area .num {padding-top:0.43rem; font-size:1.21rem; color:#ff754f; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt107102 .section-01 .item-list-container .item-wide {position:relative;}
.mEvt107102 .section-01 .item-list-container .item-wide .info-area .tit {position:absolute; left:50%; bottom:1.5rem; width:10.17rem; transform:translate(-50%, 0);}
.mEvt107102 .section-01 .item-list-container .item-wide .info-area .num {padding-top:1.5rem;}
.mEvt107102 .section-01 .item-list-container .sold-out {position:relative;}
.mEvt107102 .section-01 .item-list-container .sold-out:before {content:""; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(39,30,97,0.702) url(//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_txt_soldout.png) no-repeat 50% 50%; background-size:5.60rem; border-radius:50%;}
.mEvt107102 .section-01 .view-container {text-align:center;}
.mEvt107102 .section-01 .view-container .btn-detail {width:9.82rem; padding:2.43rem 0; background:transparent;}
.mEvt107102 .section-01 .view-container .btn-go {width:23.26rem; background:transparent;}
.mEvt107102 .section-01 .view-container p {font-size:1.21rem; color:#998aff; line-height:1.5rem;}
.mEvt107102 .section-01 .view-container .txt-01 {padding:1.30rem 0 2.08rem;}
.mEvt107102 .section-02 {padding:3.47rem 0; background:#ff8969;}
.mEvt107102 .section-02 h3 {width:19.65rem; margin:0 auto; padding-bottom:2.17rem;}
.mEvt107102 .section-02 .success-list {height:15.78rem; padding:0 4.34rem; background:#ff8969;}
.mEvt107102 .section-02 .success-list .list-info {display:flex; align-items:center; justify-content:space-between; padding-bottom:0.86rem;}
.mEvt107102 .section-02 .success-list .list-info .name, 
.mEvt107102 .section-02 .success-list .list-info .id {color:#ffece7; font-size:1.21rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt107102 .section-02 .success-list .empty {padding-top:7rem; text-align:center; color:#ffece7; font-size:1.21rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt107102 .swiper-button-prev {width:1.21rem; left:1.73rem; transform:translate(0, -50%);}
.mEvt107102 .swiper-button-next {width:1.21rem; right:1.73rem; transform:translate(0, -50%) rotate(180deg);}
.mEvt107102 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(45, 37, 108,0.902); z-index:150;}
.mEvt107102 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:4.17rem 1.73rem; overflow-y:scroll;}
.mEvt107102 .pop-container .pop-inner a {display:inline-block;}
.mEvt107102 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:5.73rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107102/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt107102 .pop-container .pop-inner .content-win {position:absolute; left:50%; top:19rem; width:21.3rem; transform:translate(-50%, 0);}
</style>
<script>
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"
var prizeInfo = [
	{name:'아이패드 에어'}, 
	{name:'에어팟 프로'}, 
	{name:'판도라 반지'},
    {name:'샤오미 미밴드'},
    {name:'스누피 양치컵'},
    {name:'다이어리'},
    {name:'모나미 플러스펜'},
    {name:'캔들'},
    {name:'아일랜드 조명'}
]

$(function(){
	// 자세히보기 팝업 호출
	$(".mEvt107102 .btn-detail").on("click", function(){
		$(".pop-container.detail").fadeIn();
	});
	// 팝업 닫기
	$(".mEvt107102 .btn-close").on("click", function(){
		$(".pop-container").fadeOut();
    });
    getEvtItemList();
	getWinners();
});
function getEvtItemList(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEvent107102Proc.asp",
		data: "mode=evtobj",
		dataType: "json",
		success: function(res){
			// console.log(res.data)
			renderList(res.data)
		}
	})
}
function renderList(itemList){
	if(itemList.length > 0){
        var newArr = itemList
		newArr.forEach(function(item){
			if (item.isOpen){
				if(item.leftItems <= 0){
                    $("#item"+item.itemcode).addClass("sold-out");
				}
			}
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
function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/realtimeEvent107102Proc.asp",
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

    tmpEl = tmpEl + '<div class="swiper-slide">\
        <div class="success-list">\
    '
	data.forEach(function(winner){
        if(ix % 8 == 0 && ix!=0){
            tmpEl = tmpEl + '<div class="swiper-slide">\
                <div class="success-list">\
            '
        }
		tmpEl = tmpEl + '<div class="list-info">\
				<p class="name">' + prizeInfo[(winner.code-1)].name + '</p>\
				<p class="id">' + printUserName(winner.userid, 2, "*") + '</p>\
			</div>\
        '
        if(ix % 7 == 0 && ix!=0){
            tmpEl = tmpEl + '   </div>\
                </div>\
            '
        }
		ix += 1;
    });
    if(ix % 8 != 0){
        tmpEl = tmpEl + '   </div>\
            </div>\
        '
    }
    itemEle += tmpEl
	if(ix==0){
        itemEle = '<div class="swiper-slide">\
            <div class="success-list">\
			    <p class="empty">아직 당첨자가 없습니다!</p>\
            </div>\
        </div>\
		'
	}
    $rootEl.append(itemEle)

	// winner slider
	var swiper = new Swiper('.swiper-container', {
		loop:true,
		effect:'fade',
		nextButton:'.swiper-button-next',prevButton:'.swiper-button-prev',
	});
}
function eventTry(){
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
			<% If (currentDate >= #11/16/2020 00:00:00#) Then %>
			$('#resultover2').eq(0).delay(500).fadeIn();
			<% else %>
			$('#resultover').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent107102Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.selectedPdt);
                            getEvtItemList();
                            getWinners();
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
function popResult(returnCode, selectedPdt){
    numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #11/17/2020 00:00:00#) Then %>
			$('#fail3').eq(0).delay(500).fadeIn();
			<% else %>
			$('#fail2').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
		$("#winImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_winning_0"+ selectedPdt +".png?v=1.01")
		$("#winnerPopup").eq(0).delay(500).fadeIn();
	}else if(returnCode == "A02"){
		numOfTry = 2
		$('#resultover').eq(0).delay(500).fadeIn();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
    }
}
function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/event/etc/realtimeevent/realtimeEvent107102Proc.asp",
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
</script>
			<div class="mEvt107102">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_tit.jpg" alt="지금은 11월이니까 11을 뽑아봐! 11을 닮은 상품들을 준비했어요. 뽑기에 성공해서 득템하세요!"></h2>
				</div>
				<div class="section-01">
					<div class="item-list-container">
						<div>
							<div id="item1">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item01.png?V=2.00" alt="아이패드">
							</div>
							<div class="info-area">
								<p class="tit">아이패드 에어 2개</p>
								<p class="num">110,000원</p>
							</div>
						</div>
						<div class="item-02">
							<div id="item2">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item02.png" alt="에어팟 프로">
							</div>
							<div class="info-area">
								<p class="tit">에어팟 프로</p>
								<p class="num">110,000원</p>
							</div>
						</div>
						<div>
							<div id="item3">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item03.png" alt="판도라 반지">
							</div>
							<div class="info-area">
								<p class="tit">판도라 반지 2개</p>
								<p class="num">11,000원</p>
							</div>
						</div>
					</div>
					<div class="item-list-container list-02">
						<div>
							<div id="item4">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item04.png" alt="샤오미 미밴드">
							</div>
							<div class="info-area">
								<p class="tit">샤오미 미밴드 2개</p>
								<p class="num">11,000원</p>
							</div>
						</div>
						<div class="item-02">
							<div id="item5">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item05.png" alt="스누피 양치컵">
							</div>
							<div class="info-area">
								<p class="tit">스누피 양치컵 2개</p>
								<p class="num">1,100원</p>
							</div>
						</div>
						<div>
							<div id="item6">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item06.png" alt="다이어리">
							</div>
							<div class="info-area">
								<p class="tit">다이어리 2개</p>
								<p class="num">1,100원</p>
							</div>
						</div>
					</div>
					<div class="item-list-container list-02">
						<div class="item-wide">
							<div id="item7">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item07.png" alt="모나미 플러스펜 세트">
							</div>
							<div class="info-area">
								<p class="tit">모나미 플러스펜 세트</p>
								<p class="num">1,100원</p>
							</div>
						</div>
						<div class="item-02">
							<div id="item8">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item08.png" alt="캔들">
							</div>
							<div class="info-area">
								<p class="tit">캔들 2개</p>
								<p class="num">1,100원</p>
							</div>
						</div>
						<div>
							<div id="item9">
								<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_item09.png" alt="아일랜드 조명">
							</div>
							<div class="info-area">
								<p class="tit">아일랜드 조명 2개</p>
								<p class="num">1,100원</p>
							</div>
						</div>
					</div>
					<div class="view-container">
						<button type="button" class="btn-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_btn02.png" alt="상품 자세히 보기"></button>
						<p>당첨되면 이미지 속의 상품들을<br/>특가에 구매할 수 있는 기프트카드를 드립니다.</p>
						<p class="txt-01">지금 버튼을 눌러 뽑기에 도전하세요!</p>
						<button type="button" class="btn-go" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_btn01.png" alt="도전하기"></button>
					</div>
				</div>
				<div class="section-02">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_tit_sub.png" alt="뽑기 성공 리스트"></h3>
					<div class="slide-area">
						<div class="swiper-container">
							<div class="swiper-wrapper" id="winners"></div>
							<!-- arrow navigation -->
							<div class="swiper-button-prev"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/icon_arrow.png" alt="뒤로 가기"></div>
							<div class="swiper-button-next"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/icon_arrow.png" alt="앞으로 가기"></div>
						</div>
					</div>
				</div>
				<div class="section-03">
					<a href="#" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_sns.jpg" alt="친구에게 공유하면 한 번 더 기회를 드려요!"></a>
				</div>
				<div class="section-04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_notice.jpg" alt="유의사항">
				</div>

				<!-- 자세히 보기 팝업 -->
				<div class="pop-container detail">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_detail.png" alt="상품 자세히 보기">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 당첨 팝업 -->
				<div class="pop-container winning" id="winnerPopup">
					<div class="pop-inner">
						<img src="" id="winImg" alt="당첨을 축하합니다.">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 꽝 팝업(첫 번째 응모) -->
				<div class="pop-container fail" id="fail1">
					<div class="pop-inner">
						<a href="#" onclick="sharesns('ka')">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_fail.png" alt="마일리지 11p 당첨">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 꽝 팝업2 (공유 후 두번째 응모) -->
				<div class="pop-container fail02" id="fail2">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_fail02.png" alt="마일리지 11p 당첨 내일 다시 도전해보세요!">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 꽝 팝업3 (이벤트 마지막 날 응모) -->
				<div class="pop-container fail03" id="fail3">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_fail03.png" alt="마일리지 11p 응모해주셔서 감사합니다.">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 공유 하지 않고 재응모 팝업 -->
				<div class="pop-container no-share" id="secondTry">
					<div class="pop-inner">
						<a href="#" onclick="sharesns('ka')">
							<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_no_share.png" alt="이미 1회 응모하였습니다.">
						</a>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 2번응모후 클릭 팝업 -->
				<div class="pop-container done" id="resultover">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_done.png" alt="오늘의 응모는 모두 완료! 내일 또 도전해주세요.">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>

				<!-- 2번응모후 마지막날 클릭 팝업 -->
				<div class="pop-container done-last" id="resultover2">
					<div class="pop-inner">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/107102/m/img_pop_done_last.png" alt="오늘의 응모는 모두 완료! 응모해주셔서 감사합니다.">
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
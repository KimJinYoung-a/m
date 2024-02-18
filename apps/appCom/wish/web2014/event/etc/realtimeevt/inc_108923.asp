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
' Description : 1억 복주머니
' History : 2021-01-08 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "104291"
	moECode = "103238"
Else
	eCode = "108923"
	moECode = "108922"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-01-11")		'이벤트 시작일
eventEndDate 	= cdate("2021-01-20")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
	mktTest = False
end if

if mktTest then
    currentDate = cdate("2021-01-11")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("새해니까 1억 받아가세요!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "새해니까 1억 받아가세요!"
Dim kakaodescription : kakaodescription = "과연 나의 복덩이에는 무엇이 들어있을까? 지금 바로 선택해보세요."
Dim kakaooldver : kakaooldver = "과연 나의 복덩이에는 무엇이 들어있을까? 지금 바로 선택해보세요."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_kakao.jpg"
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
	isFirstTried = pwdEvent.isParticipationDayBase(1)
end if

triedNum = chkIIF(isFirstTried, 1, 0)
%>
<style>
.mEvt108923 .topic {position:relative;}
.mEvt108923 .coin-area .item01 {width:20vw; height:auto; position:absolute; left:-3%; top:0; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item01.on {opacity:1; top:17%; }
.mEvt108923 .coin-area .item02 {width:14vw; height:auto; position:absolute; left:15%; top:-2%; opacity:0; transition:1.3s;}
.mEvt108923 .coin-area .item02.on {opacity:1; top:-2%}
.mEvt108923 .coin-area .item03 {width:16vw; height:auto; position:absolute; left:28%; top:0; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item03.on {opacity:1; top:5%;}
.mEvt108923 .coin-area .item04 {width:17vw; height:auto; position:absolute; left:52%; top:0; opacity:0; transition:1.4s;}
.mEvt108923 .coin-area .item04.on {opacity:1; top:8%;}
.mEvt108923 .coin-area .item05 {width:14vw; height:auto; position:absolute; left:60%; top:-2%; opacity:0; transition:1s;}
.mEvt108923 .coin-area .item05.on {opacity:1; top:-2%;}
.mEvt108923 .coin-area .item06 {width:20vw; height:auto; position:absolute; left:79%; top:0; opacity:0; transition:1.5s;}
.mEvt108923 .coin-area .item06.on {opacity:1; top:16%;}
.mEvt108923 .section-01 {position:relative;}
.mEvt108923 .section-01 button {background:transparent;}
.mEvt108923 .section-01 .poket01 {position:absolute; left:15%; bottom:31%; width:27vw; height:13vh;}
.mEvt108923 .section-01 .poket02 {position:absolute; left:58%; bottom:31%; width:27vw; height:13vh;}
.mEvt108923 .section-01 .poket03 {position:absolute; left:36%; bottom:20%; width:27vw; height:12vh;}
.mEvt108923 .section-01 .poket04 {position:absolute; left:18%; bottom:8%; width:27vw; height:13vh;}
.mEvt108923 .section-01 .poket05 {position:absolute; left:55%; bottom:8%; width:27vw; height:13vh;}
.mEvt108923 .click-area span {animation:1s click ease-in-out alternate infinite;}
.mEvt108923 .click-area .click01 {position:absolute; left:37%; bottom:34%; width:12vw; height:4vh;}
.mEvt108923 .click-area .click02 {position:absolute; left:58%; bottom:22%; width:12vw; height:4vh;}
.mEvt108923 .click-area .click03 {position:absolute; left:11%; bottom:16%; width:12vw; height:4vh;}
.mEvt108923 .section-02 {position:relative;}
.mEvt108923 .section-02 .price {width:100%; padding:0 5%; position:absolute; left:50%; top:22%; transform:translate(-50%,0); font-size:2.69rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; text-align:center; word-break:break-all;}
@keyframes click {
    0% {opacity:0;}
    100% {opacity:1;}
}
.mEvt108923 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt108923 .pop-container .pop-inner {position:relative; width:100%; padding:2.17rem 1.73rem 4.17rem;}
.mEvt108923 .pop-container .pop-inner a {display:inline-block; width:100%; height:100%;}
.mEvt108923 .pop-container .pop-inner .btn-close {position:absolute; right:3.73rem; top:4rem; width:2.08rem; height:2.08rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108923/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt108923 .pop-container.third .go-mileage {position:absolute; left:0; bottom:10%; width:100%; height:14vh;}
.mEvt108923 .pop-container.again .go-kakao {position:absolute; left:0; bottom:0; width:100%; height:100%;}
</style>
<script>
var numOfTry = "<%=triedNum%>";
$(function() {
	$('.mEvt108923 .coin-area > span').addClass('on');
    /* 팝업 닫기 */
    $('.mEvt108923 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
    getApplyCnt();
});

function getApplyCnt(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEvent108923Proc.asp",
		data: "mode=evtcnt",
		dataType: "json",
		success: function(res){
			if(res.totalcnt=="0원"){
				$("#checkdown").val("N");
			}
            $("#applycnt").html(res.totalcnt);
		}
	})
}

function eventTry(s){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		if(numOfTry == '1'){
			// 한번 시도
			$("#secondTry").eq(0).delay(500).fadeIn();
			return false;
		}
		if($("#checkdown").val()=="N"){
			alert("마일리지가 모두 소진 되었습니다!");
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add",
			selectedPdt: s
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/realtimeevent/realtimeEvent108923Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + s)
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							getApplyCnt();
							popResult(res.returnCode, res.winItemid, res.selectedPdt);
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

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++;
	if(returnCode[0] == "B"){		
		$('#fail').eq(0).delay(500).fadeIn();
		return false;
	}else if(returnCode[0] == "C"){
		
		if(selectedPdt==1){
			$("#winnero").eq(0).delay(500).fadeIn();
		}else{
			$("#winnert").eq(0).delay(500).fadeIn();
		}
	}else if(returnCode == "A02"){
		$('#secondTry').eq(0).delay(500).fadeIn();
	}else if(returnCode == "A03"){
		alert("오픈된 상품이 아닙니다.");
	}
}

function sharesns(snsnum) {		
		$.ajax({
			type: "GET",
			url:"/event/etc/realtimeevent/realtimeEvent107776Proc.asp",
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
			<div class="mEvt108923">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_tit.jpg" alt="새해 1억 많이 받으세요!"></h2>
                    <div class="coin-area">
                        <span class="item01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin01.png" alt=""></span>
                        <span class="item02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin02.png" alt=""></span>
                        <span class="item03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin03.png" alt=""></span>
                        <span class="item04"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin04.png" alt=""></span>
                        <span class="item05"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin05.png" alt=""></span>
                        <span class="item06"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_coin06.png" alt=""></span>
                    </div>
				</div>
				<div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_sub01.jpg" alt="복덩이 안에는? 1등(1명) 마일리지 1,000,000원 2등(5명) 마일리지 500,000원 3등 (96,500명) 마일리지 1,000원">
                    <div class="lucky-poket">
                        <button type="button" class="poket01 btn-apply" onclick="eventTry(1);"></button>
                        <button type="button" class="poket02 btn-apply" onclick="eventTry(2);"></button>
                        <button type="button" class="poket03 btn-apply" onclick="eventTry(3);"></button>
                        <button type="button" class="poket04 btn-apply" onclick="eventTry(4);"></button>
                        <button type="button" class="poket05 btn-apply" onclick="eventTry(5);"></button>
                    </div>
                    <div class="click-area">
                        <span class="click01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_click01.png" alt="click"></span>
                        <span class="click02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_click02.png" alt="click"></span>
                        <span class="click03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_click03.png" alt="click"></span>
                    </div>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_sub02.jpg" alt="현재 남은 금액">
                    <!-- for dev msg : 당첨자가 받은 마일리지 제외한 남은 금액 표기 -->
                    <span class="price" id="applycnt"></span><input type="hidden" id="checkdown" value="Y">
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/img_noti.jpg" alt="유의사항"></div>
                <!-- 팝업 - 1등 당첨 -->
                <div class="pop-container first" id="winnero">
					<div class="pop-inner">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/popup_01.png" alt="축하합니다 1등에 당첨되었어요!"></div>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                <!-- 팝업 - 2등 당첨 -->
                <div class="pop-container second" id="winnert">
					<div class="pop-inner">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/popup_02.png" alt="축하합니다 2등에 당첨되었어요!"></div>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                <!-- 팝업 - 3등 당첨 -->
                <div class="pop-container third" id="fail">
					<div class="pop-inner">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/popup_03.png" alt="짠! 마일리지 1,000원이 나왔어요!"></div>
                        <a href="" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;" class="go-mileage"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                <!-- 팝업 - 이미 참여 한 경우 -->
                <div class="pop-container again" id="secondTry">
					<div class="pop-inner">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108923/m/popup_04.png" alt="이미 참여 하셨습니다"></div>
                        <!-- for dev msg : 카카오톡 공유하기 -->
                        <a href="#" onclick="sharesns('ka')" class="go-kakao"></a>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
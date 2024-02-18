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
' Description : 2021 인형뽑기
' History : 2021-05-03 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "105354"
	moECode = "105353"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111102"
	moECode = "111101"
    mktTest = False
Else
	eCode = "111102"
	moECode = "111101"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-05-10")		'이벤트 시작일
eventEndDate 	= cdate("2021-05-23")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-05-10")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("곰돌이를 구해주세요!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "곰돌이를 구해주세요!"
Dim kakaodescription : kakaodescription = "성공하면 100원에 드립니다 *아이패드도 있어요!"
Dim kakaooldver : kakaooldver = "성공하면 100원에 드립니다 *아이패드도 있어요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_kakao.jpg"
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
.mEvt111102 .topic {position:relative;}
.mEvt111102 .tit {position:absolute; left:50%; top:8%; width:63.73vw; margin-left:-31.86vw; opacity:0; transform:translateY(-5rem);}
.mEvt111102 .tit.on {opacity:1; transform:translateY(0); transition:1.3s all;}
.mEvt111102 .img-coin {position:absolute; left:-3%; top:17.5%; width:16.13vw;}
.mEvt111102 .img-coin02 {position:absolute; left:2%; top:44%; width:16.13vw;}
.mEvt111102 .img-coin03 {position:absolute; right:3%; top:55%; width:16.13vw; z-index:10;}
.mEvt111102 .img-pick {position:absolute; left:50%; top:32%; transform:translate(-47%,0); width:86vw;}
.mEvt111102 .img-people {position:absolute; right:8%; top:29%; width:20.8vw; animation:updown 1s ease-in-out infinite alternate;}
.mEvt111102 .link01 {position:absolute; right:0; top:72.5%; width:100%;}
.mEvt111102 .link01 button {width:100%; height:25vw; background:transparent;}
.mEvt111102 .sec-prd button {position:relative;}
.mEvt111102 .sec-prd button span {position:absolute; right:18%; top:52%; width:5.06vw; height:2.93vw;}
.mEvt111102 .sec-prd button span.on {transform: rotate(180deg);}
.mEvt111102 .sec-prd .prd-list {display:none;}
.mEvt111102 .sec-prd .prd-list.on {display:block;}
.mEvt111102 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.mEvt111102 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt111102 .pop-container .pop-inner a {display:inline-block;}
.mEvt111102 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111102/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt111102 .pop-container .pop-contents {position:relative;}
.mEvt111102 .pop-container .pop-contents .btn-go {position:absolute; left:0; bottom:0; width:100%; height:70vw; background:transparent;}
.mEvt111102 .pop-container .pop-contents .btn-coupon {display:inline-block; position:absolute; left:0; bottom:0; width:100%; height:70vw; background:transparent;}
.mEvt111102 .pop-container .pop-tit {width:100%; text-align:center; position:absolute; left:50%; top:20%; transform:translate(-50%,0); font-size:2.17rem;}
.mEvt111102 .pop-container .pop-name {width: 100%; text-align: center; font-size: 1.30rem; position: absolute; left: 50%; bottom: 25%; transform: translate(-50%,0); font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt111102 .pop-container .pop-name.line2 {bottom:22%; line-height:1.2;}
@keyframes updown {
    0% {transform: translateY(1rem);}
    100% {transform: translateY(0);}
}
</style>
<script type="text/javascript">
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"

$(function(){
    $('.tit').addClass('on');
    // 이미지 순차 반복 노출하기
    var num = 1;
    setInterval(function(){
        num++;
        if(num>2) {num = 1};
        $('.img-coin > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin_0' + num + '.png');
        $('.img-coin02 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin02_0' + num + '.png');
        $('.img-coin03 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin03_0' + num + '.png');
    },1000);
    // 상품 자세히 보기
    $('.sec-prd > button').on('click',function(){
        $('.prd-list').toggleClass('on');
        $('.sec-prd > button span').toggleClass('on');
    });
    // 팝업 닫기
    $('.mEvt111102 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});

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
			<% If (currentDate >= #05/24/2021 00:00:00#) Then %>
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
			url:"/event/etc/realtimeevent/realtimeEvent111102Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
							popResult(res.returnCode, res.winItemid, res.selectedPdt, res.winpop);
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

function popResult(returnCode, itemid, selectedPdt, winpop){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #05/24/2021 00:00:00#) Then %>
			$('#fail3').eq(0).delay(500).fadeIn();
			<% else %>
			$('#fail2').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);
        $('#winContents').html(winpop);
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
			url:"/event/etc/realtimeevent/realtimeEvent111102Proc.asp",
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
            <div class="mEvt111102">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_top_contents.jpg" alt="귀여움 페스티벌!">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/tit_h2.png" alt="인형뽑기"></div>
                    <div class="img-coin"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin_01.png" alt="coin"></div>
                    <div class="img-coin02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin02_01.png" alt="coin"></div>
                    <div class="img-coin03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_coin03_01.png" alt="coin"></div>
                    <div class="img-pick"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_pick.png" alt="뽑기 기계"></div>
                    <div class="img-people"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_item01.png" alt="당첨자 300명"></div>
                    <div class="link01"><button type="button" class="btn-go" onclick="eventTry();"></button></div>
                </div>
                <div class="sec-prd">
                    <button type="button"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/tit_prd.jpg?v=2" alt="뽑기 상품 자세히 보기"><span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/icon_arrow.png" alt=""></span></button>
                    <div class="prd-list"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_prd_list.jpg?v=2" alt="상품 리스트"></div>
                </div>
                <div>
                    <a href="/event/eventmain.asp?eventid=110936" onclick="jsEventlinkURL(110936);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/btn_see.jpg" alt="귀여운 페스티벌 구경하기"></a>
                </div>
                <div style="margin-top:-1px;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/img_noti.jpg" alt="유의사항">
                </div>

                <%'<!-- 팝업 - 상품 당첨시 노출 팝업 -->%>
                <div class="pop-container item" id="winnerPopup">
                    <div class="pop-inner">
                        <div class="pop-contents" id="winContents"></div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 꽝 팝업 - 첫 번째 응모 시 -->%>
                <div class="pop-container item" id="fail1">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_fail.png" alt="앗 아쉽게도 뽑기에 실패했어요..">
                            <button type="button" class="btn-go" onclick="sharesns('ka');"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 하지 않고 응모 시 -->%>
                <div class="pop-container item" id="secondTry">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_fail_again.png" alt="이미 1회 도전했어요!">
                            <button type="button" class="btn-go" onclick="sharesns('ka');"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 후 두번째 응모 시(기본) -->%>
                <div class="pop-container item" id="fail2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_fail_tomorow.png" alt="아쉽게도 뽑기에 실패했어요. 대신 오늘의 쿠폰을 드릴게요.">
                            <a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp');" target="_blank" class="btn-coupon"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 후 두번째 응모 시(이벤트 마지막 날) -->%>
                <div class="pop-container item" id="fail3">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_fail_last.png" alt="오늘의 응모는 모두 완료! 응모해주셔서 감사합니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(기본) -->%>
                <div class="pop-container item" id="resultover">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_finish.png" alt="오늘의 응모는 모두 완료! 내일 다시 도전해 주세요.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(이벤트 마지막 날) -->%>
                <div class="pop-container item" id="resultover2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111102/m/pop_finish_last.png" alt="오늘의 응모는 모두 완료! 응모해주셔서 감사합니다.">
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
    </form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
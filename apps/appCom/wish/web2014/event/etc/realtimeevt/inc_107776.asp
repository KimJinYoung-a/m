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
' Description : 2020 크리스 박스
' History : 2020-11-26 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "103272"
	moECode = "103238"
Else
	eCode = "107776"
	moECode = "107775"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2020-11-30")		'이벤트 시작일
eventEndDate 	= cdate("2020-12-09")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" or LoginUserid = "bora2116" then
	mktTest = False
end if

if mktTest then
    currentDate = cdate("2020-11-30")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[돌아온 크리스박스 이벤트!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sns_kakao.png")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[돌아온 크리스박스 이벤트!]"
Dim kakaodescription : kakaodescription = "배송비 2,500원만 내면, 크리스박스가 갑니다. 박스 안에는 역대급 랜덤 선물이 가득!"
Dim kakaooldver : kakaooldver = "배송비 2,500원만 내면, 크리스박스가 갑니다. 박스 안에는 역대급 랜덤 선물이 가득!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sns_kakao.png"
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
<style type="text/css">
.mEvt107776 {position: relative;}
.mEvt107776 .section-01 {position:relative;}
.mEvt107776 .section-01 .box {width:13.95rem; position:absolute; left:50%; bottom:25%; transform:translate(-50%,0); animation:1s bounce infinite alternate;}
.mEvt107776 .section-01 .btn-apply {width:25.83rem; position:absolute; left:50%; bottom:5%; transform:translate(-50%,0); background:transparent;}
.mEvt107776 .section-02 .btn-more {position:relative; background:#ffcc00;}
.mEvt107776 .section-02 .btn-more::before {content:""; position:absolute; left:50%; top:40%; transform: translate(257%,0); width:1rem; height:0.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107776/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition:.6s ease-in-out;}
.mEvt107776 .section-02 .btn-more.on::before {transform: translate(257%,0) rotate(180deg);}
.mEvt107776 .section-03 .count {padding-bottom:3.04rem; font-size:2.17rem; color:#fff; background:#2e733c; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt107776 .section-03 .count span {font-size:3.47rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt107776 .alram-area {position:relative;}
.mEvt107776 .alram-area .btn-area {position:absolute; left:50%; top:33%; transform: translate(-50%,0);}
.mEvt107776 .alram-area .btn-area button {width:23.13rem; margin-bottom:0.73rem; background:transparent;}
.mEvt107776 .slide-area {position:relative; width:100%; padding-top:6.95rem; padding-bottom:1rem; background:#cc1919;}
.mEvt107776 .slide-area::before {content:""; display:inline-block; width:15.3rem; height:17.7rem; position:absolute; left:50%; top:0; transform:translate(-50%,0); z-index:10; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_circle.png) no-repeat 0 0; background-size:100%; }
.mEvt107776 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt107776 .swiper-wrapper .swiper-slide {width:13rem; padding:0 0.56rem;}
.mEvt107776 .slide-area .swiper-slide div {text-align:center; margin:0 auto;}
.mEvt107776 .slide-area .item-01 {width:6.56rem;}
.mEvt107776 .slide-area .item-02 {width:5.95rem;}
.mEvt107776 .slide-area .item-03 {width:8.69rem;}
.mEvt107776 .slide-area .item-04 {width:8.39rem;}
.mEvt107776 .slide-area .item-05 {width:4.91rem;}
.mEvt107776 .slide-area .item-06 {width:6.60rem;}
.mEvt107776 .slide-area .item-07 {width:4.34rem;}
.mEvt107776 .slide-area .item-08 {width:11.26rem;}
.mEvt107776 .slide-area .item-09 {width:6.82rem;}
.mEvt107776 .slide-area .item-10 {width:6.56rem;}
.mEvt107776 .slide-area .item-11 {width:5rem;}
.mEvt107776 .slide-area .item-12 {width:5.60rem;}
.mEvt107776 .slide-area .item-13 {width:5.17rem;}
.mEvt107776 .slide-area .item-14 {width:8.08rem;}
.mEvt107776 .slide-area .item-15 {width:8.52rem;}
.mEvt107776 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(0, 0, 0,0.902); z-index:150;}
.mEvt107776 .pop-container .pop-inner {position:relative; width:100%; padding:2.17rem 1.73rem 4.17rem;}
.mEvt107776 .pop-container .pop-inner a {display:inline-block;}
.mEvt107776 .pop-container .pop-inner .btn-close {position:absolute; right:3.73rem; top:4rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107776/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt107776 .pop-container.pop-win .btn-area {position:absolute; left:50%; bottom:15%; transform:translate(-50%,0);}
.mEvt107776 .pop-container.pop-win .btn-area a {width: 19.13rem;}
.mEvt107776 .pop-container.pop-fail01 .pop-contents,
.mEvt107776 .pop-container.pop-fail02 .pop-contents,
.mEvt107776 .pop-container.pop-fail03 .pop-contents,
.mEvt107776 .pop-container.pop-fail04 .pop-contents,
.mEvt107776 .pop-container.pop-done01 .pop-contents,
.mEvt107776 .pop-container.pop-done02 .pop-contents,
.mEvt107776 .pop-container.pop-alram .pop-contents {position:relative; width:100%; height:100%;}
.mEvt107776 .pop-container.pop-fail01 .btn-area,
.mEvt107776 .pop-container.pop-fail02 .btn-area {width:70%; height:50%; position:absolute; left:50%; bottom:8%; transform:translate(-50%,0);}
.mEvt107776 .pop-container.pop-fail03 .btn-area,
.mEvt107776 .pop-container.pop-fail04 .btn-area,
.mEvt107776 .pop-container.pop-alram .btn-area {width:95%; height:17%; position:absolute; left:50%; bottom:8%; transform:translate(-50%,0);}
.mEvt107776 .pop-container.pop-done01 .btn-area,
.mEvt107776 .pop-container.pop-done02 .btn-area {width:95%; height:30%; position:absolute; left:50%; bottom:16%; transform:translate(-50%,0);}
.mEvt107776 .pop-container.pop-fail01 .btn-area a,
.mEvt107776 .pop-container.pop-fail02 .btn-area a,
.mEvt107776 .pop-container.pop-fail03 .btn-area a,
.mEvt107776 .pop-container.pop-fail04 .btn-area a,
.mEvt107776 .pop-container.pop-done01 .btn-area a,
.mEvt107776 .pop-container.pop-done02 .btn-area a,
.mEvt107776 .pop-container.pop-alram .btn-area button {width:100%; height:100%; background:transparent;}
@keyframes bounce {
    0% {bottom:25%; animation-timing-function:ease-out;}
	50% {bottom:27%; animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
var numOfTry = "<%=triedNum%>";
var isShared = "<%=isShared%>"

$(function(){
    /* slide */
    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: 1,
        speed: 5000,
        slidesPerView:'auto',
        loop:true
    });
    /* 더보기 클릭시 show/hide */
    $('.mEvt107776 .btn-more').click(function(){
        $('.hidden-list').slideToggle(500);
        $('.btn-more').toggleClass("on");
    })
    /* 팝업 닫기 */
    $('.mEvt107776 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    });
    getApplyCnt();
});

function getApplyCnt(){
	$.ajax({
		type: "GET",
		url:"/event/etc/realtimeevent/realtimeEvent107776Proc.asp",
		data: "mode=evtcnt",
		dataType: "json",
		success: function(res){
			// console.log(res.data)
            $("#applycnt").html(res.totalcnt);
		}
	})
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
			<% If (currentDate >= #12/09/2020 00:00:00#) Then %>
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
			url:"/event/etc/realtimeevent/realtimeEvent107776Proc.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|')
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

function popResult(returnCode, itemid, selectedPdt){
	numOfTry++
	if(returnCode[0] == "B"){		
		if(numOfTry >= 2){
			<% If (currentDate >= #12/09/2020 00:00:00#) Then %>
			$('#fail3').eq(0).delay(500).fadeIn();
			<% else %>
			$('#fail2').eq(0).delay(500).fadeIn();
			<% end if %>
			return false;
		}
		$("#fail1").eq(0).delay(500).fadeIn();
	}else if(returnCode[0] == "C"){		
		$("#itemid").val(itemid);	
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
        url:"/event/etc/realtimeevent/realtimeEvent107776Proc.asp?mode=pushadd",
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
            <div class="mEvt107776">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_tit.jpg" alt="배송비만 내면 크리스박스가 간다. 참여기간 11월 30일 ~ 12월 9일"></h2>
                    <!--  상품 slide  -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_01.png" alt="item01">
                                    </div>
                                </div>
								<div class="swiper-slide">
									<div class="item-02">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_02.png" alt="item02">
                                    </div>
								</div>
								<div class="swiper-slide">
									<div class="item-03">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_03.png" alt="item03">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-04">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_04.png" alt="item04">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-05">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_05.png" alt="item05">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-06">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_06.png" alt="item06">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-07">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item02_07.png" alt="item07">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-08">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_08.png" alt="item08">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-09">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_09.png" alt="item09">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-10">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_10.png" alt="item10">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-11">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_11.png" alt="item11">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-12">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_12.png" alt="item12">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-13">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_13.png" alt="item13">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-14">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_14.png" alt="item14">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-15">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_15.png" alt="item15">
                                    </div>
                                </div>
							</div>
						</div>
                    </div>
                    <!-- // -->
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sub_tit.jpg" alt="크리스박스란? 배송비 2,500원만 내면 아래 상품들 중 한가지 상품이 발송되는 랜덤 박스입니다.">
                    <div class="box"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_giftbox.png" alt="당첨자 500명"></div>
                    <button type="button" class="btn-apply" onclick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn01.png" alt="응모하기"></button>
                </div>
                <div class="section-02">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sub_tit02.jpg" alt="총 500명 당첨! 당첨되면 아래 상품 중 한 가지가 랜덤으로 발송됩니다. 무엇을 받아도 득템!"></h3>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_list01.jpg" alt="상품 리스트"></div>
                    <div class="hidden-list" style="display:none;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_item_list02.jpg" alt="상품 리스트">
                    </div>
                    <button type="button" class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn05.png" alt="더 보기"></button>
                </div>
                <div class="section-03">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sub_tit03.jpg" alt="응모수 100,000회 달성하면 내년에도 올게요! 꼭!"></h3>
                    <!-- for dev msg : 응모횟수 -->
                    <div class="count">
                        <span id="applycnt">0</span> 회
                    </div>
                    <div class="alram-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_sub_tit04.jpg" alt="알림 신청해서 내일도 잊지 말고 응모하세요!">
                        <div class="btn-area">
                            <% If (currentDate < #12/09/2020 00:00:00#) Then %>
                            <button type="button" class="btn-alram" onclick="jsPickingUpPushSubmit();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn02.png" alt="알림 신청하기"></button>
                            <% end if %>
                            <!-- for dev msg : 친구에게 공유하기 -->
                            <button type="button" class="btn-sns" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn03.png" alt="친구에게 공유하기"></button>
                        </div>
                    </div>
                </div>
                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn04.png" alt="2020 크리스마스를 즐기는 남다른 방법"></a></div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_noti02.jpg" alt="유의 사항"></div>
                <%'<!-- 팝업 - 알람신청 -->%>
                <div class="pop-container pop-alram" id="lyrPush">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type08.png" alt="알림 신청이 완료되었습니다.">
                                <div class="btn-area">
                                    <button type="button" onclick="fnAPPpopupSetting();return false;"></button>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 응모하기 당첨시 팝업 -->%>
                <div class="pop-container pop-win" id="winnerPopup">
					<div class="pop-inner">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type01.png" alt="축하드립니다! 크리스박스 당첨!"></div>
                        <div class="btn-area">
                            <a href="#" onclick="goDirOrdItem();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_btn06.png" alt="구매하러 가기"></a>
                        </div>
						<button type="button" class="btn-close">닫기</button>
					</div>
                </div>
                <%'<!-- 꽝 팝업 - 첫 번째 응모 시 -->%>
                <div class="pop-container pop-fail01" id="fail1">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type02.png" alt="앗! 당첨되지 않았습니다.ㅠㅠ">
                                <div class="btn-area">
                                    <a href="#" onclick="sharesns('ka')"></a>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 하지 않고 응모 시 -->%>
                <div class="pop-container pop-fail02" id="secondTry">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type03.png" alt="이미 1회 응모하였습니다.ㅠㅠ">
                                <div class="btn-area">
                                    <a href="#" onclick="sharesns('ka')"></a>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 후 두번째 응모 시(기본) -->%>
                <div class="pop-container pop-fail03" id="fail2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type04.png" alt="아쉽게도 당첨되지 않았습니다 내일 다시 도전해보세요! 대신 오늘은 감사 쿠폰을 드릴게요.">
                                <div class="btn-area">
                                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!--꽝 팝업 - 공유 후 두번째 응모 시(이벤트 마지막 날) -->%>
                <div class="pop-container pop-fail04" id="fail3">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type05.png" alt="아쉽게도 당첨되지 않았습니다ㅠㅠ 감사 쿠폰을 드렸으니 쿠폰함을 확인해보세요!">
                                <div class="btn-area">
                                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(기본) -->%>
                <div class="pop-container pop-done01" id="resultover">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type06.png" alt="오늘의 응모는 모두 완료! 내일 또 도전해 주세요!">
                                <div class="btn-area">
                                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
                                </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <%'<!-- 팝업 - 이미 2번 응모후 세번째 응모 시(이벤트 마지막 날) -->%>
                <div class="pop-container pop-done02" id="resultover2">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107776/m/img_pop_type07.png" alt="오늘의 응모는 모두 완료! 응모해주셔서 감사합니다.">
                                <div class="btn-area">
                                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ></a>
                                </div>
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



<%
'당첨 아이템 체크 (스텝계정)
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "starsun726" then
	dim vQuery 
	vQuery = "SELECT convert(varchar(10),s.regdate,21) as regdate, o.option1, count(s.sub_opt2) as cnt" & vbCrLf
	vQuery = vQuery & " FROM [db_event].[dbo].[tbl_event_subscript] as S with(nolock)" & vbCrLf
	vQuery = vQuery & " left join [db_event].[dbo].[tbl_realtime_event_obj] as O with(nolock)" & vbCrLf
    vQuery = vQuery & " on s.evt_code=o.evt_code and s.sub_opt2=o.option5" & vbCrLf
    vQuery = vQuery & " where s.evt_code=" & eCode & vbCrLf
    vQuery = vQuery & " and s.sub_opt1='1'" & vbCrLf
	vQuery = vQuery & " group by s.sub_opt2, convert(varchar(10),s.regdate,21), o.option1" & vbCrLf
    vQuery = vQuery & " order by convert(varchar(10),s.regdate,21) asc, s.sub_opt2 asc" & vbCrLf
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		Do Until rsget.EOF
			response.write rsget(0) & " " & rsget(1) & "(" & rsget(2) & ")" & "<br>"
			rsget.MoveNext
		loop
	End IF
	rsget.close
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<%
'####################################################
' Description : 2019 100원 자판기
' History : 2019-06-14 최종원
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, drwEvt
dim isParticipation
dim numOfParticipantsPerDay, i

IF application("Svr_Info") = "Dev" THEN
	eCode = "90428"
    moECode = "90362"
Else
	eCode = "98740"
    moECode = "98738"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2019-11-14")		'이벤트 시작일
eventEndDate 	= cdate("2019-12-01")		'이벤트 종료일
currentDate 	= date()
'currentDate		= cdate("2019-06-28")'테스트
LoginUserid		= getencLoginUserid()
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[텐바이텐이 드리는 선물! Merry Light]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_kakao_share.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[텐바이텐이 드리는 선물! Merry Light]"
	Dim kakaodescription : kakaodescription = "한정수량 5,000개를 선물로 드립니다. Merry Light로 행복한 연말을 만들어보세요."
	Dim kakaooldver : kakaooldver = "한정수량 5,000개를 선물로 드립니다. Merry Light로 행복한 연말을 만들어보세요."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_kakao_share.jpg"
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
	set drwEvt = new DrawEventCls
	drwEvt.evtCode = eCode
	drwEvt.userid = LoginUserid
	isSecondTried = drwEvt.isParticipationDayBase(2)
	isFirstTried = drwEvt.isParticipationDayBase(1)
	isShared = drwEvt.isSnsShared
end if

triedNum = chkIIF(isFirstTried, 1, 0)
triedNum = chkIIF(isSecondTried, 2, triedNum)
%>
<style type="text/css">
.merry-light {background:#fff;}
.merry-light .txt {position:absolute; left:0; width:100%;}
.merry-light .topic {position:relative;}
.merry-light .topic h2, .merry-light .topic p {opacity:0; transform:translateY(10px); transition:.8s;}
.merry-light .topic .tit1 {top:9%;}
.merry-light .topic .tit2 {top:17.75%;}
.merry-light .topic .tit3 {top:40%;}
.merry-light .topic .tit4 {top:49%;}
.merry-light .topic.on h2, .merry-light .topic.on p {opacity:1; transform:translateY(0);}
.merry-light .topic.on h2 {transition-delay:.4s;}
.merry-light .topic.on .tit2 {transition-delay:.6s;}
.merry-light .topic.on .tit3 {transition-delay:.8s;}
.merry-light .topic.on .tit4 {transition-delay:1s;}
.merry-light .merry-cont {position:relative;}
.merry-light .get-light .move {padding:0 0 .85rem 8.6%;}
.merry-light .get-light .sns-share {position:relative;}
.merry-light .get-light .sns-share ul {position:absolute; right:14.5%; top:21%; overflow:hidden; width:35%; height:40%;}
.merry-light .get-light .sns-share li {float:left; width:50%; height:100%;}
.merry-light .get-light .sns-share li a {display:block; height:100%; text-indent:-999em;}
.merry-light .story1 .txt {top:46.6%;}
.merry-light .story2 .txt {top:11.23%;}
.merry-light .story3 .txt {top:0;}
.merry-light .story4 .txt {top:7%;}
.merry-light .merry-story .txt {transform:translateX(2rem); opacity:0; transition:.8s;}
.merry-light .merry-story.move .txt {transform:translateX(0); opacity:1;}
.merry-light .make {background-color:#ddd6d4;}
.merry-light .make .slider {padding:0 0 5.12rem 8.8%;}
.merry-light .make .slider button {display:inline-block; position:absolute; bottom:7.4%; z-index:50; width:2.13rem; background:transparent;}
.merry-light .make .slider .btn-prev {right:7rem;}
.merry-light .make .slider .btn-next {right:1.28rem;}
.merry-light .make .pagination {position:absolute; right:3.4rem; bottom:7.4%; z-index:999; width:3.5rem; height:2.13rem; color:#fff; font:bold 1.28rem/.7rem 'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; text-align:center; letter-spacing:.2rem;}
.merry-light .evt-noti {padding:3.4rem 7%; margin-top:.21rem; font-size:1rem; color:#fff; background-color:#3c3a3a;}
.merry-light .evt-noti h3 {padding-bottom:1rem; font-size:1.6rem; font-weight:bold; text-align:center;}
.merry-light .evt-noti li {padding:1rem 0 0 .8rem; line-height:1.6; text-indent:-.8rem;}
.merry-lyr {display:none; position:fixed; left:0; top:0; z-index:999; width:100%; height:100%; background:rgba(0,0,0,.8);}
.merry-lyr .lyr-cont {position:absolute; left:6.7%; top:50%; transform:translateY(-50%); width:86.6%; margin:0 auto;}
.merry-lyr .result {position:relative;}
.merry-lyr .case0 .btn-buy {position:absolute; left:9.2%; bottom:9%; width:81.6%; background:transparent;}
.merry-lyr .case1 ul {position:absolute; left:16%; top:38%; overflow:hidden; width:68%; height:25%;}
.merry-lyr .case1 li {float:left; width:50%; height:100%;}
.merry-lyr .case1 li a {display:block; height:100%; text-indent:-999em;}
.merry-lyr .case1-1 ul {position:absolute; left:16%; top:38%; overflow:hidden; width:68%; height:25%;}
.merry-lyr .case1-1 li {float:left; width:50%; height:100%;}
.merry-lyr .case1-1 li a {display:block; height:100%; text-indent:-999em;}
.merry-lyr .btn-close {display:block; position:absolute; right:1rem; top:1rem; width:3.4rem; height:3.4rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98740/m/btn_close.png) 50% 50% no-repeat; background-size:100%; text-indent:-999em;}
</style>  
<script type="text/javascript">
$(function(){
    $('.merry-light .topic').addClass('on');
    $(window).scroll(function(){
		$('.merry-story').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 0.8;
			var txtTop = $(this).offset().top;
			if(y > txtTop) {
				$(this).addClass('move');
			}
		});
	});
    var mySwiper = new Swiper ('.slider .swiper-container', {
        autoplay:3000,
        speed:500,
        effect:'fade',
        nextButton:'.slider .btn-next',
        prevButton:'.slider .btn-prev',
        loop:true,
        onSlideChangeStart: function (mySwiper) {
			var vActIdx = parseInt(mySwiper.activeIndex);
			if (vActIdx<=0) {
				vActIdx = mySwiper.slides.length-2;
			} else if(vActIdx>(mySwiper.slides.length-2)) {
				vActIdx = 1;
			}
			$(".pagination i").text(vActIdx);
		}
    });
    $('.pagination i').text(1);

    // 레이어팝업
	// $(".mEvt98740 .btn-apply").click(function(){
	// 	$('.merry-lyr').fadeIn();
	// });
	$(".mEvt98740 .merry-lyr .btn-close").click(function(){
		$(".merry-lyr").fadeOut();
	});
});
</script>
<script style="text/javascript">
var numOfTry = '<%=triedNum%>'
var isShared = "<%=isShared%>"

function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		var returnCode, itemid
			$.ajax({
				type:"POST",
				url:"/event/etc/drawevent/drawEventProc2.asp",
				data: {
					mode: "add"
				},
                dataType: "JSON",
				success : function(data){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                    // console.log(data)
                    returnCode = data.result
                    itemid = data.winItemid
                    popResult(returnCode, itemid);
                    return false;
				},
				error:function(data){
					// console.log(data)
					// document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% End If %>
	<% End If %>
}
function popResult(returnCode, itemid){
    $('.lyr-cont [class*=case]').css('display', 'none')
    $(".merry-lyr").fadeIn();
	if(returnCode[0] == "B"){
		numOfTry++
		if(numOfTry >= 2){
            $("#fail2").css('display', '')
			return false;
        }
        $("#fail1").css('display', '')
	}else if(returnCode[0] == "A"){
		if(returnCode == "A02"){
            $("#done").css('display', '')
		}else{
            $("#share").css('display', '')
		}
	}else if(returnCode[0] == "C"){
		$("#itemid").val(itemid);
		$("#win").css("display", "")
		numOfTry++
		if(numOfTry == 2) numOfTry = 0
	}
}
function sharesns(snsnum) {
		var reStr;
		$.ajax({
			type: "POST",
			url:"/event/etc/drawevent/drawEventProc2.asp",
			data: {
              mode: 'snschk',
              snsnum: snsnum
            },
			dataType: "JSON"
		})
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
}
function goDirOrdItem(){
<% If IsUserLoginOK() Then %>
	<% If currentDate >= eventStartDate And currentDate <= eventEndDate Then %>
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% End IF %>
}
</script>
			<!-- 98740 메리라이트(A) -->
			<div class="mEvt98740 merry-light">
                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                <div class="topic">
                    <p class="tit1 txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_vol1.png" alt="크리스마스 이벤트01"></p>
                    <h2 class="tit2 txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/tit_merry_light.png" alt="Merry Light"></h2>
                    <p class="tit3 txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_subcopy_1.png" alt="세상에서 가장 따뜻한 집"></p>
                    <p class="tit4 txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_subcopy_2.png" alt="당신의 반짝이는 크리스마스. 텐바이텐이 준비한 Merry Light와 행복한 시간을 보내세요."></p>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_topic.jpg" alt=""></div>
                </div>
                <%'<!-- 개발영역 -->%>
                <div class="merry-cont get-light">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_gift.gif" alt="Merry Light를 선물로 드립니다. 당신은, 배송비만 결제하세요."></h3>
                    <div class="move"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_move.gif" alt=""></div>
                    <%'<!-- 응모하기 -->%>
                    <button type="button" onclick="eventTry()" class="btn-apply"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/btn_submit.png" alt="응모하기"></button>
                    <div class="sns-share">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_share.png" alt="친구에게 응모하고, 한번 더 도전하기"></p>
                        <ul>
                            <li><a href="javascript:sharesns('fb')">페이스북 공유</a></li>
                            <li><a href="javascript:sharesns('ka')">카카오톡 공유</a></li>
                        </ul>
                    </div>
                    <%'<!--응모결과 레이어팝업-->%>
                    <div class="merry-lyr">
                        <div class="lyr-cont">
                            <%'<!-- 1.당첨 -->%>
                            <div id="win" class="result case0" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_0.jpg" alt=""></div>
                                <a href="javascript:goDirOrdItem()" class="btn-buy"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/btn_buy.png" alt="배송비만 내고 구매하러 가기"></a>                                
                            </div>
                            
                            <%'<!-- 2.비당첨 -->%>
                            <div id="fail1" class="result case1" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_1.jpg" alt=""></div>
                                <ul>
                                    <li><a href="javascript:sharesns('fb')">페이스북 공유</a></li>
                                    <li><a href="javascript:sharesns('ka')">카카오톡 공유</a></li>
                                </ul>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                            <%'<!-- 첫번째 응모 후 공유하지 않고 응모했을 경우-->%>
                            <div id="share" class="result case1-1" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_6.jpg" alt=""></div>
                                <ul>
                                    <li><a href="javascript:sharesns('fb')">페이스북 공유</a></li>
                                    <li><a href="javascript:sharesns('ka')">카카오톡 공유</a></li>
                                </ul>
                                <button type="button" class="btn-close">닫기</button>
                            </div>                            
                            <% if true then %>
                            <%'<!-- 공유 후 두번째 응모(기본) -->%>
                            <div id="fail2" class="result case2" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_2.jpg" alt=""></div>
                                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas_pop.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                            <%'<!-- 두번 모두 응모 후 (기본) -->%>
                            <div id="done" class="result case4" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_4.jpg" alt=""></div>
                                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas_pop.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                            <% else %>
                            <%'<!-- 공유 후 두번째 응모(마지막날) -->%>
                            <div id="fail2" class="result case3" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_3.jpg" alt=""></div>
                                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas_pop.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                            <%'<!-- 두번 모두 응모 후 (마지막날) -->%>
                            <div id="done" class="result case5" style="display:none">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_case_5.jpg" alt=""></div>
                                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas_pop.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                            <% end if %>
                        </div>
                    </div>
                    <!--//응모결과 레이어팝업-->
                </div>
                 <!--// 개발영역 -->
                <div class="merry-cont merry-story story1">
                    <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_story_1.png" alt="작은 스위치가 켜지는 순간 당신이 조금 더 행복해지기를 바랍니다."></p>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_story_1.jpg?v=2" alt=""></div>
                </div>
                <div class="merry-cont merry-story story2">
                    <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_story_2.png" alt="책상 위, 잠들기 전의 침대 옆 반짝임이 필요한 공간이면 어느 곳이든."></p>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_story_2.jpg" alt=""></div>
                </div>
                <div class="merry-cont merry-story story3">
                    <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_story_3.png" alt="친구들과 여러 개의 Merry Light를 모아 작지만 따듯한 마을을 완성해 보세요."></p>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_story_3.jpg" alt=""></div>
                </div>
                <div class="merry-cont merry-story story4">
                    <p class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/txt_story_4.png" alt="Merry Light 옆에 좋아하는 소품을 함께 놓아둘 수 있어요."></p>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_story_4.jpg" alt=""></div>
                </div>
                <div class="merry-cont story5">
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_story_5.jpg" alt=""></div>
                </div>
                <div class="merry-cont feature">
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_feature.jpg" alt="Merry Light는 이렇게 구성되어 있어요"></div>
                </div>
                <div class="merry-cont make">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/tit_make.png" alt="간단하게 접어서 Merry Light를 완성해 보세요"></h3>
                    <div class="slider">
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_slide_1.jpg" alt=""></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_slide_2.jpg" alt=""></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_slide_3.jpg" alt=""></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_slide_4.jpg" alt=""></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_slide_5.jpg" alt=""></div>
                            </div>
                            <div class="pagination"><i></i>/5</div>
                            <button type="button" class="btn-prev"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/btn_prev.png" alt="이전"></button>
                            <button type="button" class="btn-next"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/btn_next.png" alt="다음"></button>
                        </div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/img_gift.jpg?v=2" alt="Merry Light 인증샷 남기고 또 다른 선물 받으세요!"></div>
                </div>
                <div><a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_christmas_2.jpg?v=3" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a></div>
                <% if currentDate <= Cdate("2019-11-20") then %>
                <div><a href="/category/category_itemPrd.asp?itemid=2592320&pEtr=98740" onclick="TnGotoProduct('2592320');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98740/m/bnr_disney.jpg" alt="오늘 단 하루 50% 특가!"></a></div>
                <% end if %>
                <div class="evt-noti">
                    <h3>유의사항</h3>
                    <ul>
                        <li>- 본 이벤트는 텐바이텐 APP에서만 참여 가능합니다.</li>
                        <li>- 1일 1회 응모가 가능하며, 친구에게 공유 시 한 번 더 기회가 주어집니다. (하루 최대 2회 응모 가능)</li>
                        <li>- 모든 상품의 당첨자가 결정되면 이벤트는 조기 마감될 수 있습니다.</li>
                    </ul>
                </div>
			</div>
			<!-- // 98740 메리라이트(A) -->
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
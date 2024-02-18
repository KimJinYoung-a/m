<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 2021 공부왕 세트 9900원
' History : 2021-06-11 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "108361"
	moECode = "106360"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "112034"
	moECode = "112035"
    mktTest = True
Else
	eCode = "112034"
	moECode = "112035"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-06-14")		'이벤트 시작일
eventEndDate 	= cdate("2021-07-04")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-06-14")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("공부왕세트 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/112035/m/112035_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "공부왕세트 이벤트"
Dim kakaodescription : kakaodescription = "공부를 잘하기 위해 필요한 모든 것을 단 9,900원에 드립니다. 바로 도전하세요!"
Dim kakaooldver : kakaooldver = "공부를 잘하기 위해 필요한 모든 것을 단 9,900원에 드립니다. 바로 도전하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/112035/m/112035_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode

dim subscriptcount
if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
end if

if LoginUserid="dlwjseh" or LoginUserid="ysys1418" Then
    subscriptcount = 0
End If
%>
<style type="text/css">
/* common */
.mEvt112034 .section{position:relative;}

/* section01 */
.mEvt112034 .section01 .paper02{position:absolute;top:4rem;right:0;width:98.4vw;animation:paper .8s ease-in-out;}
.mEvt112034 .section01 .paper01{position:absolute;top:7rem;left:50%;margin-left:-39.55vw;width:79.1vw;animation:paper 1.2s ease-in-out;}
.mEvt112034 .section01 .sunshine{position:absolute;top:-7rem;}
.mEvt112034 .section01 .nut{position:absolute;top:37.5rem;left:7.3vw;width:20.1vw;animation:fly 1s ease-in-out;}
.mEvt112034 .section01 .title_txt{position:absolute;top:12rem;left:50%;width:64.9vw;margin-left:-32.45vw;transform:translateY(135%); opacity:0; transition:ease-in-out 2.2s 0.8s;}/* 손지수 수정 */
.mEvt112034 .section01 .title_txt.on{opacity:1; transform:translateY(0);}

/* section02 */
.mEvt112034 .section02 .study_slide{position:absolute;top:1rem;}
.mEvt112034 .swiper-button-prev {left:14%; top:57%; transform: translate(0,-50%); width:1.30rem; height:5.52rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/112035/m/icon_prev.png) no-repeat 0 50%; background-size:60%; z-index:100;}
.mEvt112034 .swiper-button-next {right:14%; top:57%; transform: translate(0,-50%); width:1.30rem; height:5.52rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/112035/m/icon_next.png) no-repeat right 50%; background-size:60%; z-index:100;}

/* section03 */ /* 손지수 수정 */
.mEvt112034 .section03 .arrow_down{position:absolute;top:8.5rem;left:50%;margin-left:-3.6vw;width:7.2vw;animation:updown 0.8s ease-in-out alternate infinite;}
.mEvt112034 .section03 .box{position:absolute;top:13rem;left:50%;margin-left:-42.65vw;width:85.3vw;height:39rem;}
.item01{position:absolute;top:4rem;left:5vw;width:36.7vw;animation:updown 0.8s ease-in-out alternate infinite;}
.item02{position:absolute;top:2rem;right:20vw;width:24vw;animation:updown 0.9s ease-in-out alternate infinite;}
.item03{position:absolute;top:4.5rem;right:5vw;width:17.9vw;animation:updown 0.7s ease-in-out alternate infinite;}
.item04{position:absolute;top:15rem;left:5vw;width:19.9vw;z-index:20;animation:updown 1s ease-in-out alternate infinite;}
.item05{position:absolute;top:11rem;left:23vw;width:23.5vw;animation:updown 0.7s ease-in-out alternate infinite;}
.item06{position:absolute;top:9rem;right:1vw;width:40.7vw;animation:updown 1.1s ease-in-out alternate infinite;}
.item07{position:absolute;top:18.9rem;left:5vw;width:42vw;animation:updown 0.8s ease-in-out alternate infinite;}
.item08{position:absolute;top:26rem;left:21vw;width:25.3vw;animation:updown 0.7s ease-in-out alternate infinite;}
.item09{position:absolute;top:21rem;right:5vw;width:35.9vw;animation:updown 0.9s ease-in-out alternate infinite;}
/* // 손지수 수정 */

/* section04 */
.mEvt112034 .section04 .apply{position:absolute;top:11rem;left:50%;margin-left:-42.65vw;width:85.3vw;height:7rem;}

/* section05 */
.section05{background:#000;}
.btn-noti {position:relative;}
.section05 .btn-noti{height:5rem;}
.section05 .btn-noti.on span img {transform:rotate(180deg);}
.section05 .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform: translate(506%,-240%) rotate(180deg);}
.noti-info {display:none;}
.section05 .noti-info.on {display:block;margin-top:2rem;}

/* section06 */
.section06{padding-bottom:4rem;background:#000;}
.section06 .btn-noti.on span img {transform:rotate(180deg);}
.section06 .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform: translate(780%,-220%) rotate(180deg);}
.section06 .noti-info.on {display:block;}

/* section09 */
.section09 a{position:absolute;left:50%;margin-left:-42.65vw;width:85.3vw;height:7.5rem;}
.section09 a.banner01{top:14rem;}
.section09 a.banner02{top:22.5rem;}
.section09 a.banner03{top:30.5rem;}
.section09 a.banner04{top:38.8rem;}

/* popup */
.popup {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.popup .pop01, .popup .pop02 {padding-top:6rem;width:85.3vw;position:absolute;left:50%;margin-left:-42.65vw;}
.popup .btn-close {position:absolute; top:15.77rem; right:6%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/112035/m/btn_close.png) 50% 50%/100%;}
.popup p {padding-top:7.98rem;}
.popup .user_id{position:absolute; top:18.5rem; left:12%;font-size:1.8rem;line-height:2.8rem;color:#9e7948;text-align:center;width:55%;height:3rem;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';font-weight:bold;}
.popup .btn-submit{position:absolute; top:36rem;width:80vw;left:50%;margin-left:-40vw;height:6rem;text-indent:-999999px;background:transparent;}
.popup .btn-kakao{position:absolute; top:30rem;width:24vw;left:50%;margin-left:-12vw;height:6rem;text-indent:-999999px;background:transparent;}

/* 당첨자 팝업 */
.popup_win .bg_dim{position:fixed;top:0;left:0;bottom:0;right:0;background:rgba(0,0,0,0.74);z-index:9999;}
.popup_win .popup_winner{position:absolute;top:2rem;width:88.53vw;left:50%;margin-left:-44.265vw;z-index:99999;}
.popup_win .popup_winner .btn_close{position:absolute;top:1rem;right:1rem;width:10vw;height:3rem;display:block;}
.popup_win .popup_winner .go_event{width:50vw;height:3rem;position:absolute;bottom:5rem;left:50%;margin-left:-25vw;}


@keyframes paper {
    0% {transform: translate3d(-30rem, -30rem, -10rem);}
    100% {transform: translate3d(0);}
}

@keyframes fly {
    0% {transform: translateX(-20rem);}
    100% {transform: translateX(0);}
}

@keyframes updown {
    0% {transform: translateY(-0.5rem);}
    100% {transform: translateY(0.5rem);}
}
</style>
<script>
$(function () {
	$(".section01 .title_txt").addClass("on");
	mySwiper1 = new Swiper('.study_slide',{
		autoplay:3000,
		effect:'slide',
        loop:true,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });

	$('.section05 .btn-noti').on("click",function(){
        $('.section05 .noti-info').toggleClass("on");
        $(this).toggleClass("on");
    });
	$('.section06 .btn-noti').on("click",function(){
        $('.section06 .noti-info').toggleClass("on");
        $(this).toggleClass("on");
    });

    // 레이어 닫기
    $('.btn-close').click(function (e) {
        $('.popup').hide();
        $('.pop01').hide();
        $('.pop02').hide();
    });

	$(".popup_win .popup_winner .btn_close").click(function(){
		$(".popup_win").css("display","none");
		return false;
	});
});
var numOfTry = "<%=subscriptcount%>";
function eventTry(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		if(numOfTry >= 1){
			// 한번 시도
			$('.popup').eq(0).delay(500).fadeIn();
            $('.pop02').show();
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript112034.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')

					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            <% if LoginUserid<>"dlwjseh" and LoginUserid<>"ysys1418" Then %>
						    numOfTry++;
						    <% end if %>
                            $('.popup').eq(0).delay(500).fadeIn();
                            $('.pop01').show();

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

function eventAlarm(){
	<% If Not(IsUserLoginOK) Then %>
		calllogin();
		return false;
	<% else %>
		<% If (currentDate >= eventStartDate And currentDate <= eventEndDate) or mktTest Then %>
		var returnCode, itemid, data
		var data={
			mode: "alarm"
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript112034.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
                if(res!="") {
                    // console.log(res)
                    if(res.response == "ok"){
                        alert('알림 신청이 완료되었습니다.');
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

function snschk(snsnum) {		
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

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}
</script>
			<div class="mEvt112034">
               <section class="section section01">
				   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/title_bg.jpg" alt="">
				   <p class="paper02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/paper02.png" alt=""></p>
				   <p class="paper01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/paper01.png?v=2" alt=""></p>
				   <p class="sunshine"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/sunshine.png" alt=""></p>
				   <p class="nut"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/nut.png" alt=""></p>
				   <p class="title_txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/title_txt.png" alt=""></p>
			   </section>
			   <section class="section section02">
				   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide_bg.jpg" alt="">
				   <div class="swiper-container study_slide">
					   <div class="swiper-wrapper">
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('2211768');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide01.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('885564');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide02.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('1646072');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide03.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('3646231');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide04.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('3628557');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide05.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('2476609');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide06.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('3283933');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide07.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('2923862');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide08.png?v=2" alt=""></a></div>
						   <div class="swiper-slide"><a href="" onclick="TnGotoProduct('3793539');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/slide09.png?v=2" alt=""></a></div>
					   </div>
					   <div class="swiper-button-prev"></div>
					   <div class="swiper-button-next"></div>
					</div>
			   </section>
			   <section class="section section03">
				   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/set_box.jpg?v=3" alt="">
				   <p class="arrow_down"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/arrow_down.png" alt=""></p>
				   <div class="box">
					   <p class="item01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float01.png" alt=""></p>
					   <p class="item02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float02.png" alt=""></p>
					   <p class="item03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float03.png" alt=""></p>
					   <p class="item04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float04.png" alt=""></p>
					   <p class="item05"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float05.png" alt=""></p>
					   <p class="item06"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float06.png" alt=""></p>
					   <p class="item07"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float07.png" alt=""></p>
					   <p class="item08"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float08.png" alt=""></p>
					   <p class="item09"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/float09.png" alt=""></p>
				   </div>
			   </section>
			   <section class="section section04">
				   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/apply_bg.jpg" alt="">
				   <a href="" onclick="eventTry();return false;" class="apply"></a>
			   </section>
			   <section class="section section05">
				   <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/product_detail.jpg" alt=""><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/arrow.png" alt=""></span></button>
				   <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/product_on.jpg" alt=""></div>
			   </section>
			   <section class="section section06">
				   <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/noti.jpg" alt=""><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/arrow.png" alt=""></span></button>
				   <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/noti_on.jpg" alt=""></div>
			   </section>
			   <section class="section section07">
				   <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/item_bg.jpg" alt=""></a>
			   </section>
			   <section class="section section08">
				   <a href="" onclick="snschk('ka');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/kakao.jpg?v=3" alt=""></a>
			   </section>
			   <section class="section section09">
				   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/banner.jpg?v=3" alt="">
				   <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111396');return false;" class="banner01"></a>
				   <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111332');return false;" class="banner02"></a>
				   <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111453');return false;" class="banner03"></a>
				   <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111877');return false;" class="banner04"></a>
			   </section>

                <div class="popup" style="display:none;">
                    <div class="pop01" style="display:none;">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/popup.png" alt=""></p>
                        <div class="user_id"><%=LoginUserid%></div>
                        <button type="button" onclick="eventAlarm();" class="btn-submit">알림받기</button>
                        <button class="btn-close"></button>
                    </div>
                    <div class="pop02" style="display:none;">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/popup02.png" alt=""></p>
                        <div class="user_id"><%=LoginUserid%></div>
                        <button type="button" onclick="snschk('ka');" class="btn-kakao">카카오톡으로 친구에게 알리기</button>
                        <button class="btn-close"></button>
                    </div>
                </div>
				<div class="popup_win">
				   <div class="bg_dim"></div>
				   <div class="popup_winner">
					   <img src="//webimage.10x10.co.kr/fixevent/event/2021/112035/m/winner.png?v=3" alt="">
					   <a href="https://m.10x10.co.kr/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt" class="go_event"></a>
					   <a href="" class="btn_close"></a>
				   </div>				   
			   </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
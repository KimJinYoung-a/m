<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 누구나 가슴속에 여행을 품고 산다 이벤트
' History : 2021.08.03 정태훈 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate, mktTest
IF application("Svr_Info") = "Dev" THEN
	eCode = "108385"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "113210"
    mktTest = true
Else
	eCode = "113210"
    mktTest = false
End If

eventStartDate = cdate("2021-08-03")		'이벤트 시작일
eventEndDate = cdate("2021-08-17")		'이벤트 종료일
userid = getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-08-03")
else
    currentDate = date()
end if

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("나만의 여름별장 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "나만의 여름별장 이벤트"
Dim kakaodescription : kakaodescription = "이 페이지를 보시는 분들께 달콤한 휴식을 위한 30만원을 지원합니다."
Dim kakaooldver : kakaooldver = "이 페이지를 보시는 분들께 달콤한 휴식을 위한 30만원을 지원합니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.evt113211 .topic {position:relative;}
.evt113211 .topic .parasol-thumb {width:47.60vw; height:40.80vw; position:absolute; left:50%; top:31%; transform:translate(-50%,0);}
.evt113211 .topic .parasol-thumb img {width:100%; height:100%;}
.evt113211 .slide-area {padding:2.13rem 0; background:#62c6f8;}
.evt113211 .slide-area .swiper-slide {width:30.80vw; margin:0 1.62rem;}
.evt113211 .pouch-area {position:relative;}
.evt113211 .pouch-area .item01 {width:24.27vw; position:absolute; left:20%; top:2%; animation:show 1s infinite alternate;}
.evt113211 .pouch-area .item02 {width:41.73vw; position:absolute; left:52%; top:13%; animation:show 1s .3s infinite alternate;}
.evt113211 .pouch-area .item03 {width:38.53vw; position:absolute; left:4%; top:32%; animation:show 1s .5s infinite alternate;}
.evt113211 .pouch-area .item04 {width:38.80vw; position:absolute; left:49%; top:41%; animation:show 1s .2s infinite alternate;}
.evt113211 .basket-price {padding-bottom:2.77rem; background:#ffa025;}
.evt113211 .basket-price .name {color:#272420; font-size:1.62rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; text-align:center;}
.evt113211 .basket-price .name span {text-decoration:underline;}
.evt113211 .basket-price .txt {padding-top:0.94rem; color:#272420; font-size:1.19rem; text-align:center;}
.evt113211 .basket-price .price {width: calc(100% - 8.26rem); height:5.76rem; line-height:5.76rem; margin:1.28rem auto 0; padding-right:1.28rem; font-size:2.56rem; color:#787878; text-align:right; background:#fff; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.evt113211 .basket-price .price span {padding-left:0.38rem; font-size:1.36rem;}
.evt113211 .btn-detail {position:relative;}
.evt113211 .btn-detail .icon {width:0.93rem; height:0.59rem; position:absolute; left:50%; top:20%; margin-left:5.3rem;}
.evt113211 .noti {display:none;}
.evt113211 .noti.on {display:block;}
.evt113211 .icon.on {transform: rotate(180deg);}
.evt113211 .icon {transform: rotate(0);}
.evt113211 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.evt113211 .pop-container .pop-contents {position:relative;}
.evt113211 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.evt113211 .pop-container .pop-inner a {display:inline-block;}
.evt113211 .pop-container .contents-inner {position:relative;}
.evt113211 .pop-container .contents-inner .tit {position:absolute; left:50%; top:14%; line-height:1.5; text-align:center; transform:translate(-50%,0); font-size:1.70rem; color:#272420; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.evt113211 .pop-container .contents-inner .tit span {text-decoration:underline;}
.evt113211 .pop-container .contents-inner .btn-kakao {width:100%; height:12rem; position:absolute; left:0; bottom:0; background:transparent;}
.evt113211 .pop-container .pop-inner .btn-close {position:absolute; right:1.73rem; top:1.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
@keyframes show {
    0% {opacity:0;}
    100% {opacity:1;}
}
</style>
<script>
$(function(){
	// changing img
	(function changingImg(){
		var i=1;
		var repeat = setInterval(function(){
			i++;
			if(i>3){i=1;}
			$('.evt113211 .topic .parasol-thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_item0'+ i +'.png?v=4.1');
		},260);
	})();
    // slide
    var swiper1 = new Swiper('.swiper-container', {
		loop: true,
		speed: 1000,
		autoplay:1,
        centeredSlides:true,
        slidesPerView:'auto',
	});
	// btn more
	$('.evt113211 .btn-detail').click(function (e) { 
		$(this).next().toggleClass('on');
        $(this).find('.icon').toggleClass('on');
	});
    /* 팝업 닫기 */
    $('.evt113211 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    <% If IsUserLoginOK() Then %>
        <% if subscriptcount > 0 then %>
            alert("응모가 완료되었습니다. 당첨일 8월 19일을 기다려주세요!");
            return false;
        <% end if %>
            $.ajax({
                type: "POST",
                url:"/event/etc/doeventsubscript/doEventSubScript113210.asp",
                data: {
                    mode: 'add'
                },
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                        isApply = true
                        $('.pop-container').fadeIn();
                    }else{
                        alert(data.message);
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.');
                }
            })
    <% else %>
        calllogin();
        return false;
    <% end if %>
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
            <div class="evt113211">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_tit.jpg?v=3" alt="여행을 품고산다"></h2>
                    <div class="parasol-thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_item01.png?v=4.1" alt=""></div>
				</div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub.jpg" alt="">
                <!-- slide 영역 -->
                <div class="slide-area">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide01.png" alt="slide01">
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide02.png" alt="slide02">
                            </div>
                            <div class="swiper-slide">
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_slide03.png" alt="slide03">
                            </div>
                        </div>
                    </div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub01.jpg" alt="">
                <div class="pouch-area">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub02.jpg" alt="">
                    <div class="item01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd01.png" alt=""></div>
                    <div class="item02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd02.png" alt=""></div>
                    <div class="item03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd03.png" alt=""></div>
                    <div class="item04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_prd04.png" alt=""></div>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub03_app.jpg" alt="">
                <!-- 장바구니 금액 -->
                <div class="basket-price">
                    <!-- for dev msg : 로그인 : 클릭시 장바구니 / 비 로그인 : 클릭시 로그인 페이지 -->
                    <a href="#">
                        <% if IsUserLoginOK() then %>
                        <p class="name"><span><%=GetLoginUserName()%></span>님의 장바구니 금액</p>
                        <div class="price"><%= FormatNumber(getCartTotalAmount(userid), 0) %><span>원</span></div>
                        <p class="txt">*위 금액은 품절 상품 및 배송비를 제외한 금액입니다.</p>
                        <% else %>
                        <p class="name"><span>고객</span>님의 장바구니 금액</p>
                        <div class="price">100,000<span>원</span></div>
                        <p class="txt">*로그인 후 확인하세요</p>
                        <% end if %>
                    </a>
                </div>
                <button type="button" class="btn-win" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_apply02.jpg" alt="응모하기"></button>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub04.jpg" alt="">
                <button type="button" class="btn-detail">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_txt01.jpg" alt="">
                    <span class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_arrow.png" alt=""></span>
                </button>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_txt01.jpg" alt=""></div>
                <button type="button" class="btn-detail">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/btn_txt02.jpg" alt="">
                    <span class="icon" style="top:35%;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/icon_arrow.png" alt=""></span>
                </button>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_txt02.jpg" alt=""></div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_sub05.jpg" alt="">
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112115');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/img_link.jpg" alt=""></a>
                <!-- 팝업 - 응모완료 -->
                <div class="pop-container">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <div class="contents-inner">
                                <div class="tit">언젠가 여행을 떠날<br/><span><%=GetLoginUserName()%></span> 님,</div>
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/113211/m/pop_win.jpg?v=2" alt="응모완료">
                                <!-- 카카오 공유하기 -->
                                <button type="button" class="btn-kakao" onclick="snschk('ka');"></button>
                                <button type="button" class="btn-close">닫기</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
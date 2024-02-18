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
' Description : 2021 캠핑 풀세트 9,900원
' History : 2021-05-20 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode, moECode, pwdEvent
dim mktTest

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "106358"
	moECode = "106360"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111585"
	moECode = "111584"
    mktTest = True
Else
	eCode = "111585"
	moECode = "111584"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-05-24")		'이벤트 시작일
eventEndDate 	= cdate("2021-06-02")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-05-24")
else
    currentDate = date()
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("나홀로 캠핑 키트 이벤트")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "나홀로 캠핑 키트 이벤트"
Dim kakaodescription : kakaodescription = "캠핑에 필요한 모든 것을 단 9,900원에 드립니다. 바로 도전하세요!"
Dim kakaooldver : kakaooldver = "캠핑에 필요한 모든 것을 단 9,900원에 드립니다. 바로 도전하세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode

dim subscriptcount
if LoginUserid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, LoginUserid, "", "", "")
end if
%>
<style>
.mEvt111585 .tab {position:relative;}
.mEvt111585 .tab-link {display:flex; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt111585 .tab-link a {display:inline-block; width:50%;}
.mEvt111585 .topic {position:relative;}
.mEvt111585 .topic h2 img {position:absolute; left:50%; top:4rem; width:72.67vw; transform: translate(-50%,0); opacity:0; transition:all 1s;}
.mEvt111585 .topic h2 img.on {opacity:1; top:6rem;}
.mEvt111585 .topic .sub-txt {position:absolute; left:50%; top:26rem; width:57.60vw; transform: translate(-50%,0); opacity:0; transition:all 1s .5s;}
.mEvt111585 .topic .sub-txt.on {opacity:1; top:28rem;}

.mEvt111585 .section-01 {position:relative;}
.mEvt111585 .section-01 .btn-item {position:absolute; background:transparent;}
.mEvt111585 .section-01 .btn-item .prd-info {display:none; width:35.47vw; position:absolute; z-index:10;}
.mEvt111585 .section-01 .btn-item .prd-info.disabled {pointer-events:none; background:transparent;}
.mEvt111585 .section-01 .btn-item.on .prd-info {display:block;}
.mEvt111585 .section-01 .item01 span {width:5.47vw; position:absolute; left:93%; top:12%; z-index:11;}
.mEvt111585 .section-01 .item02 span {width:5.47vw; position:absolute; left:2%; top:42%; z-index:11;}
.mEvt111585 .section-01 .item03 span {width:5.47vw; position:absolute; left:55%; top:-1%; z-index:11;}
.mEvt111585 .section-01 .item04 span {width:5.47vw; position:absolute; left:69%; top:6%; z-index:11;}
.mEvt111585 .section-01 .item05 span {width:5.47vw; position:absolute; left:83.5%; top:5%; z-index:11;}
.mEvt111585 .section-01 .item06 span {width:5.47vw; position:absolute; left:46%; top:16%; z-index:11;}
.mEvt111585 .section-01 .item07 span {width:5.47vw; position:absolute; left:26%; top:46%; z-index:11;}
.mEvt111585 .section-01 .item01 {left:14%; top:19%; width:37vw; height:24vw;}
.mEvt111585 .section-01 .item02 {left:61%; top:17%; width:27vw; height:30vw;}
.mEvt111585 .section-01 .item03 {left:14%; top:35%; width:49vw; height:32vw;}
.mEvt111585 .section-01 .item04 {left:69%; top:35%; width:23vw; height:32vw;}
.mEvt111585 .section-01 .item05 {left:12%; top:57%; width:34vw; height:54vw;}
.mEvt111585 .section-01 .item06 {left:50%; top:52%; width:34vw; height:39vw;}
.mEvt111585 .section-01 .item07 {left:50%; top:75%; width:38vw; height:24vw;}
.mEvt111585 .section-01 .item01 .prd-info {left:5%; top:-39%;}
.mEvt111585 .section-01 .prd-info {left:-117%; top:52%;}
.mEvt111585 .section-01 .item03 .prd-info {left:-11%; top:-39%;}
.mEvt111585 .section-01 .item04 .prd-info {left:-71%; top:-33%;}
.mEvt111585 .section-01 .item05 .prd-info {left:-11%; top:-17%;}
.mEvt111585 .section-01 .item06 .prd-info {left:-49%; top:-16%;}
.mEvt111585 .section-01 .item07 .prd-info {left:-58%; top:58%;}
.mEvt111585 .section-01 .bg-prd.on {display:block;}
.mEvt111585 .section-01 .bg-prd-item02 {display:none; position:absolute; right:36%; top:25%; width:35.47vw; height:16vw; background:transparent;}

.mEvt111585 .btn-detail,
.mEvt111585 .btn-noti {position:relative;}
.mEvt111585 .btn-detail span {display:inline-block; width:3.47vw; height:2vw; position:absolute; right:32%; top:18%; margin-right:-1.23vw; transform: rotate(180deg);}
.mEvt111585 .btn-noti span {display:inline-block; width:3.47vw; height:2vw; position:absolute; right:30%; top:8%; margin-right:-1.23vw; transform: rotate(180deg);}
.mEvt111585 .btn-detail span.on, 
.mEvt111585 .btn-noti span.on {transform:rotate(0);}
.mEvt111585 .detail-info,
.mEvt111585 .noti-info {display:none;}
.mEvt111585 .detail-info.on,
.mEvt111585 .noti-info.on {display:block;}
.mEvt111585 .detail-info {position:relative;}
.mEvt111585 .prd-link-area {position:absolute; left:0; top:0.3rem; width:100%; display:flex; flex-wrap:wrap;}
.mEvt111585 .prd-link-area a {display:inline-block; width:50%; height:2.6rem;}
.mEvt111585 .animate {opacity:0; transform:translateY(15%); transition:all 1s;}
.mEvt111585 .animate.on {opacity:1; transform:translateY(0%);}
.mEvt111585 .bar {height:1.56rem; background:#22803d;}
.mEvt111585 .section-02 {background:#fff;}
.mEvt111585 .section-02 .slide-wrap {position:relative; width:100%; height:auto; padding: 5.13rem 7.65rem 0 0;}
.mEvt111585 .section-02 .slide-wrap .pagination {position:absolute; right:3%; top:90%; width:100%; height:auto; text-align:right; z-index:10;}
.mEvt111585 .section-02 .slide-wrap .pagination span {position:relative; width:0.52rem; height:0.52rem; margin:0 5px; border-radius:100%; background:#fff;}
.mEvt111585 .section-02 .slide-wrap .pagination span.swiper-active-switch {background:#00c445;}
.mEvt111585 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.6); z-index:150;}
.mEvt111585 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt111585 .pop-container .pop-inner a {display:inline-block;}
.mEvt111585 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.78rem; height:1.78rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt111585 .pop-contents {position:relative;}
.mEvt111585 .pop-contents .name {width:100%; text-align:center; position:absolute; left:50%; top:11%; transform:translate(-50%,0); font-size:2.17rem; color:#fff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt111585 .pop-contents .name.type02 {top:18%;}
.mEvt111585 .pop-contents .name span {padding-right:1rem;}
.mEvt111585 .pop-contents a {width:100%; height:10rem; position:absolute; left:0; bottom:0;}
.mEvt111585 .pop-contents .btn-kakao {height:20rem;}
@keyframes updown {
    0% {transform: translateY(-1rem);}
    100% {transform: translateY(1rem);}
}
</style>
<script>
$(function(){
    $('.topic h2 img,.topic .sub-txt').addClass('on');
    $(window).scroll(function(){
        $('.animate').each(function(){
			var y = $(window).scrollTop() + $(window).height() * 1;
			var imgTop = $(this).offset().top;
			if(y > imgTop) {
				$(this).addClass('on');
			}
		});
    });
    // slide
    mySwiper1 = new Swiper('.slide01',{
		autoplay:2000,
		pagination:".slide01 .pagination",
		paginationClickable:true,
		effect:'fade',
        swiperPerview:'auto'
    });
    $(".btn-detail,.btn-noti").on("click",function(){
        $(this).find("span").toggleClass("on");
        $(this).next(".detail-info,.noti-info").toggleClass("on");
    });
    // 구성품 선택시 말풍선 노출
    $('.btn-item').on('click',function(){
        $(".bg-prd").removeClass("on");
        $(this).addClass("on").siblings().removeClass("on");
        $(this).next(".bg-prd").addClass("on");
    });
    // 팝업 닫기
    $('.mEvt111585 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
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
			$('.pop-container.re-apply').eq(0).delay(500).fadeIn();
			return false;
		}
		var returnCode, itemid, data
		var data={
			mode: "add"
		}
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript111585.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            numOfTry++;
							$('.pop-container.apply').eq(0).delay(500).fadeIn();
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
			<div class="mEvt111585">
                <div class="tab">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/tab_event02.jpg" alt="">
                    <div class="tab-link">
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111585');return false;"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111643');return false;"></a>
                    </div>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/tit_main.png?v=2" alt="내일 바로떠나는 캠핑 풀세트 9,900원"></h2>
                    <div class="sub-txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/tit_sub.png" alt="날씨가 좋을 땐 고민하지 말고 훌쩍 떠나보세요!"></div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_main.jpg" alt="캠핑 풀세트"></div>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_prd.jpg?v=2" alt="풀세트 구성품">
                    <button type="button" class="btn-item item01">
                        <a href="#" onclick="fnAPPpopupProduct('3629465&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item01.png" alt="활용도 200% 꼭 필요한 폴딩박스"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <button type="button" class="btn-item item02">
                        <a href="" class="prd-info disabled"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item02.png" alt="캠핑에 빠질 수 없는 마샬 스피커"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <div class="bg-prd bg-prd-item02"></div>
                    <button type="button" class="btn-item item03">
                        <a href="#" onclick="fnAPPpopupProduct('3271034&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item03.png" alt="편리한 캠핑을 위한 첨스 폴딩 웨건"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <button type="button" class="btn-item item04">
                        <a href="#" onclick="fnAPPpopupProduct('3313868&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item04.png" alt="어두운 밤 더 분위기있게 스누피 무드등"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <button type="button" class="btn-item item05">
                        <a href="#" onclick="fnAPPpopupProduct('3751926&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item05.png" alt="귀엽고 고급스럽다 스누피 코펠세트"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <button type="button" class="btn-item item06">
                        <a href="#" onclick="fnAPPpopupProduct('3203820&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item06.png" alt="캠핑의 기본 감성적인 데코뷰 의자"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                    <button type="button" class="btn-item item07">
                        <a href="#" onclick="fnAPPpopupProduct('2392944&pEtr=111585'); return false;" class="prd-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_item07.png" alt="컵홀더까지 있고 완벽해 폴딩 테이블"></a>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_cros.png" alt=""></span>
                    </button>
                </div>
                <!-- 응모하기 버튼 -->
                <button type="button" class="btn-apply" onClick="eventTry();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/btn_apply.jpg" alt="응모하기"></button>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_day.jpg" alt="응모기간/당첨날짜/당첨인원">
                <!-- 상품 자세히 보기 버튼 -->
                <button type="button" class="btn-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/btn_detail.jpg" alt="상품 자세히 보기"><span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_arrow_yellow.png" alt=""></span></button>
                <div class="detail-info">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_detail_info.jpg" alt="상품정보">
                    <div class="prd-link-area">
                        <a href="#" onclick="fnAPPpopupProduct('3629465&pEtr=111585'); return false;"></a>
                        <a href="#" onclick="return false;"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3271034&pEtr=111585'); return false;"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3313868&pEtr=111585'); return false;"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3751926&pEtr=111585'); return false;"></a>
                        <a href="#" onclick="fnAPPpopupProduct('3203820&pEtr=111585'); return false;"></a>
                        <a href="#" onclick="fnAPPpopupProduct('2392944&pEtr=111585'); return false;"></a>
                    </div>
                </div>
                <!-- 유의사항 확인하기 버튼 -->
                <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/btn_noti.jpg" alt="유의사항 확인하기"><span><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/icon_arrow_white.png" alt=""></span></button>
                <div class="noti-info">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_noti_info.jpg" alt="유의사항">
                </div>
                <div class="bar"></div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_sub01.jpg" alt="캠핑의 여유" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_sub02.jpg" alt="캠핑의 여유" class="animate">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_sub03.jpg" alt="캠핑의 여유" class="animate">
                    <!-- slide -->
                    <div class="slide-wrap">
                        <div class="swiper-container slide01">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_slide01.png" alt="slide01"></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_slide02.png" alt="slide02"></div>
                                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_slide03.png" alt="slide03"></div>
                            </div>
                            <div class="pagination"></div>
                        </div>
                    </div>
                    <!-- // -->
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_sub04.jpg" alt="캠핑의 여유" class="animate">
                </div>
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111230');return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_link01.jpg" alt="캠핑 갈 때 꼭 준비해야 할 6가지">
                </a>
                <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111188');return false;">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_link02.jpg" alt="캠핑은 장비빨!">
                </a>
                <!-- 카카오 공유하기 링크 -->
                <a href="" onclick="snschk('ka');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/img_link03.jpg" alt="kakao 공유하기"></a>
                <!-- 팝업 - 응모완료 -->
                <div class="pop-container apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <!-- 고객ID 노출 -->
                            <p class="name"><span><%=LoginUserid%></span> 님</p>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/pop_done.png?v=2" alt="응모완료">
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111188');return false;"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 응모 후 재클릭 시 -->
                <div class="pop-container re-apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <!-- 고객ID 노출 -->
                            <p class="name type02"><span><%=LoginUserid%></span> 님</p>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111585/m/pop_kakao.png?v=2" alt="응모완료">
                            <!-- 카카오톡 공유하기 -->
                            <a href="" onclick="snschk('ka');return false;" class="btn-kakao"></a>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
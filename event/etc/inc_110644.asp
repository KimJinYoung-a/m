<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2021 이상형 월드꽃
' History : 2021-04-12 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "104346"
	moECode = "104345"
ElseIf application("Svr_Info")="staging" Then
	eCode = "110645"
	moECode = "110644"
Else
	eCode = "110645"
	moECode = "110644"
End If

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
snpTitle	= Server.URLEncode("나의 이상형 꽃은?")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "나의 이상형 꽃은?"
Dim kakaodescription : kakaodescription = "지금 테스트해보세요! 진짜 꽃을 무료로 보내드립니다."
Dim kakaooldver : kakaooldver = "지금 테스트해보세요! 진짜 꽃을 무료로 보내드립니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt110644 {position: relative;}
.mEvt110644 .section-01 {position:relative;}
.mEvt110644 .section-01 .box {width:13.95rem; position:absolute; left:50%; bottom:25%; transform:translate(-50%,0); animation:1s bounce infinite alternate;}
.mEvt110644 .section-01 .btn-apply {width:25.83rem; position:absolute; left:50%; bottom:5%; transform:translate(-50%,0); background:transparent;}
.mEvt110644 .section-02 .btn-more {position:relative; background:#ffcc00;}
.mEvt110644 .section-02 .btn-more::before {content:""; position:absolute; left:50%; top:40%; transform: translate(257%,0); width:1rem; height:0.56rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107775/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition:.6s ease-in-out;}
.mEvt110644 .section-02 .btn-more.on::before {transform: translate(257%,0) rotate(180deg);}
.mEvt110644 .section-03 .count {padding-bottom:3.04rem; font-size:2.17rem; color:#fff; background:#2e733c; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt110644 .section-03 .count span {font-size:3.47rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt110644 .alram-area {position:relative;}
.mEvt110644 .alram-area .btn-area {position:absolute; left:50%; top:33%; transform: translate(-50%,0);}
.mEvt110644 .alram-area .btn-area button {width:23.13rem; margin-bottom:0.73rem; background:transparent;}
.mEvt110644 .slide-area {position:absolute; left:0; top:22%; width:100%; background:transparent;}
.mEvt110644 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt110644 .slide-area .swiper-slide div {text-align:center; margin:0 auto;}
.mEvt110644 .slide-area .item-01 {width:36.66vw;}
.mEvt110644 .btn-app {position:absolute; left:0; top:35%; display:inline-block; width:100%; height:10rem;}
.mEvt110644 .btn-share {position:absolute; left:50%; top:45%; transform:translate(-50%,0); width:10rem; height:10rem; background:transparent;}
@keyframes bounce {
    0% {bottom:25%; animation-timing-function:ease-out;}
	50% {bottom:27%; animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function(){
    /* slide */
    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: 1,
        speed: 5000,
        slidesPerView:"auto",
        loop:true,
        spaceBetween:20
    });
});
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
            <div class="mEvt110644">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_sub_main.jpg" alt="이상형 월드 꽃"></h2>
                    <!--  꽃 slide  -->
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_01.png" alt="프리지아">
                                    </div>
                                </div>
								<div class="swiper-slide">
									<div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_02.png" alt="장미">
                                    </div>
								</div>
								<div class="swiper-slide">
									<div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_03.png" alt="item03">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_04.png" alt="item04">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_05.png" alt="item05">
                                    </div>
                                </div>
                                <div class="swiper-slide">
									<div class="item-01">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_flower_pick_06.png" alt="item06">
                                    </div>
                                </div>
							</div>
						</div>
                    </div>
                    <!-- // -->
                    <!-- app 다운받기 -->
                    <a href="https://tenten.app.link/Wqz8n9YJffb?%24deeplink_no_attribution=true" target="_blank" class="btn-app"></a>
                    <!-- 카카오톡 공유하기 -->
                    <button type="button" class="btn-share" onclick="snschk('ka');"></button>
                </div>
                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110645/m/img_noti.jpg?v=2.1" alt="유의 사항"></div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 스토리 꾸미기 파이터 이벤트
' History : 2021.12.14 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode

IF application("Svr_Info") = "Dev" THEN
	eCode = "109435"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "115948"
    mktTest = True
Else
	eCode = "115948"
    mktTest = False
End If

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐] 스토리 꾸미기 파이터")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/115948/kakaotalk.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 스토리 꾸미기 파이터"
Dim kakaodescription : kakaodescription = "지금 텐바이텐 인스타그램에서 스꾸파에 도전해보세요!"
Dim kakaooldver : kakaooldver = "지금 텐바이텐 인스타그램에서 스꾸파에 도전해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/115948/kakaotalk.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<style>
.mEvt115948 section{position:relative;}
.mEvt115948 .swiper-button-prev, .mEvt115948 .swiper-button-next{width:10vw;height:10vw;display:block;}
.mEvt115948 .swiper-button-prev::after, .mEvt115948 .swiper-button-next::after{content:none;}
.mEvt115948 .swiper-button-prev{left:3vw;margin-top:-5vw;}
.mEvt115948 .swiper-button-next{right:3vw;margin-top:-5vw;}

.mEvt115948 .section02 .img_on{width:100%;display:flex;justify-content:center;align-items:center;position:absolute;top:-1rem;}
.mEvt115948 section .slide{width:69vw;position:absolute;top:0;left:50%;transform:translateX(-50%);border-radius: 2rem;overflow:hidden;}
.mEvt115948 section .slide .swiper-slide{width:100%;}
.mEvt115948 section .cover{width:27.1vw;position:absolute;top:0;left:50%;transform:translateX(-50%);z-index:99;}
.mEvt115948 .section05 video{width:100%;margin-bottom:-1rem;}

.mEvt115948 .lyr {display:none; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt115948 .lyr .inner{width:87%;height:100%;background-color:#FFFFFF;position:absolute; left:50%; top:50%; transform:translate(-50%, -50%); max-width:32rem;}

.mEvt115948 .lyr .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}
.mEvt115948 .lyr .inner a:nth-of-type(2) {display:block; position:absolute; bottom:6rem; width:100%; height:6rem;}
.mEvt115948 .lyr .prd_name{position:absolute;width: 100%;text-align: center;font-size: 2.13rem;top:5.3rem;color:#e93e30; font-weight:600;font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular'; text-decoration: underline;text-underline-position: under;}
</style>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>
$(function() {
	var i=1;
    setInterval(function(){
        i++;
        if(i>5){i=1;}
        $('.img_on img').attr("src","//webimage.10x10.co.kr/fixevent/event/2021/115948/on0"+i+".png?v=3");
    },1500);

	var swiper = new Swiper(".slide", {
        navigation: {
          nextEl: ".swiper-button-next",
          prevEl: ".swiper-button-prev",
        },
		spaceBetween: 20,
        centeredSlides: true,
		loop:true,
        autoplay: {
          delay: 3000,
          disableOnInteraction: false,
        },
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

function fnInstaEventMove() {
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript115948.asp",
        data: {
            mode: 'insta'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                fnAPPpopupExternalBrowser('https://bit.ly/3DS0zTw');
            }else{
                alert('시스템 오류입니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    })
}

function fnkakaoEventMove() {
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript115948.asp",
        data: {
            mode: 'ka'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                snschk('ka');
            }else{
                alert('시스템 오류입니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    })
}


<% if mktTest then %>
function fnMKTPop() {
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript115948.asp",
        data: {
            mode: 'analysis'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $("#item-list").append("<tr><td align='center'>일별</td><td align='center'>인스타그램</td><td align='center'>카카오톡</td></tr>")
                $.each(data.items, function(idx, item){
                    $('.popup').css('display','block');
                    $("#item-list").append("<tr><td align='center'>"+item.regdate+ "</td><td align='center'>" + item.insta + "</td><td align='center'>" + item.kakao +"</td></tr>");
				})
            }else{
                alert('시스템 오류입니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    })
}
<% end if %>
</script>
			<div class="mEvt115948">
				<section class="section01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section01.jpg" alt="">
				</section>
				<section class="section02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section02.jpg?v=2" alt="">
					<div class="img_on">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/on01.png?v=3" alt="">
					</div>
				</section>
				<section class="section03">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section03.jpg?v=2" alt="">
				</section>
				<section class="section03_01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section03_01.jpg?v=2" alt="">
					<div class="slide01">
						<div class="swiper-container slide">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/evt01_01.jpg"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/evt01_02.jpg"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/evt01_03.jpg"></div>
							</div>							
						</div>
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
					</div>
					<p class="cover"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/cover.png" alt=""></p>
				</section>
				<section class="section03_02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section03_02.jpg?v=2" alt="">
				</section>
				<section class="section04">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section04.jpg?v=2" alt="">
				</section>
				<section class="section04_01">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section04_01.jpg?v=2" alt="">
					<div class="slide02">
						<div class="swiper-container slide">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/evt02_01.jpg?v=2"></div>
								<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/evt02_02.jpg?v=2"></div>
							</div>
						</div>						
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
					</div>
					<p class="cover"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/cover.png" alt=""></p>
				</section>
				<section class="section04_02">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section04_02.jpg?v=2" alt="">
				</section>
				</section>
				<section class="section05">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section05.jpg" alt="">
					<video preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" controls playsinline>
						<source src="//webimage.10x10.co.kr/fixevent/event/2021/115948/street.MOV" type="video/mp4">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/video.jpg" alt="">
					</video>
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/section06.jpg" alt="">
				</section>
				<section class="section06">
					<a href="https://bit.ly/3DS0zTw" target="_blank" class="mWeb">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/insta.jpg" alt="">
					</a>
                    <a href="" onclick="fnInstaEventMove();return false;" class="mApp">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/insta.jpg" alt="">
					</a>
					<a href="" onclick="fnkakaoEventMove();return false;">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/kakao.jpg" alt="">
					</a>
                    <% if mktTest then %>
                    <a href="" onclick="fnMKTPop();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/sesction07.jpg" alt=""></a>
                    <% else %>
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/115948/sesction07.jpg" alt="">
                    <% end if %>
				</section>
                <div class="lyr popup">
                    <div class="inner">
                        <a href="" class="btn_close"></a>
                        <p class="prd_name">
                            <table id="item-list"></table>
                        </p>
                    </div>
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
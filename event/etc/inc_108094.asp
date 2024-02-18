<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : #즐겨찾기_서촌 01 텐바이텐X서촌도감
' History : 2020-12-29 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
dim eCode, LoginUserid, pwdEvent
IF application("Svr_Info") = "Dev" THEN
	eCode = "104288"
Else
	eCode = "108094"
End If

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount, mileage
dim currentcnt

eventStartDate  = cdate("2021-02-24")		'이벤트 시작일
eventEndDate 	= cdate("2021-03-09")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" or LoginUserid = "bora2116" then
	currentDate = #01/06/2021 09:00:00#
end if

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

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐X서촌도감]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐X서촌도감]"
Dim kakaodescription : kakaodescription = "서촌도감 구경하며 퀴즈도 풀고 상품도 받아가세요!"
Dim kakaooldver : kakaooldver = "서촌도감 구경하며 퀴즈도 풀고 상품도 받아가세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt108094 {background:#fff;}
.mEvt108094 .topic {position:relative;}
.mEvt108094 .topic .icon-arrow {width:1.08rem; position:absolute; left:50%; top:78%; transform: translate(-50%,0); animation: updown .7s ease-in-out alternate infinite;}
.mEvt108094 .section-01 .swiper-slide,
.mEvt108094 .section-02 .swiper-slide,
.mEvt108094 .section-06 .swiper-slide {width:100%;}
.mEvt108094 .slide-review .swiper-slide {width:100%;}
.mEvt108094 .section-02 .slide-area {padding-top:5.21rem;}
.mEvt108094 .section-05 {position: relative;}
.mEvt108094 .section-05 .link {display:inline-block; width:100%; height:9rem; position:absolute; left:0; top:39%; background:transparent;}
.mEvt108094 .section-06 .slide-area {padding:0 1.73rem 0; background-color:#f2eeeb;}
.mEvt108094 .section-06 .sns-area {background-color:#f2eeeb;}
.mEvt108094 .section-06 .swiper-container {box-shadow: 19px 0px 27px 0px rgba(75, 75, 75, 0.2);}
.mEvt108094 .section-06 .pagination {left:50%; bottom:6%; transform: translate(-50%,0);}

.mEvt108094 .section-01 {position:relative;}
.mEvt108094 .pagination {position:absolute; right:2rem; bottom:6%; z-index:100;}
.mEvt108094 .pagination .swiper-pagination-switch.swiper-active-switch {background-color:#ec4a18;}
.mEvt108094 .pagination .swiper-pagination-switch {margin:0 0.5rem; background-color:#ededed;}
.mEvt108094 .section-02 {position:relative;}
.mEvt108094 .section-02 .tit-01 {width:23.52rem; margin:0 auto;}
.mEvt108094 .section-02 .tit-02 {width:24.78rem; margin:0 auto;}
.mEvt108094 .section-02 .tit-03 {width:21.48rem; margin:0 auto;}
.mEvt108094 .section-02 .tit-04 {width:23.61rem; margin:0 auto;}
.mEvt108094 .section-02 .tit {padding-top:3.69rem; opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt108094 .section-02 .tit.on {opacity:1; transform:translateY(0);}
.mEvt108094 .section-02 .img {padding-top:5.21rem; opacity:0; transform:translateY(5%); transition:all 1s;}
.mEvt108094 .section-02 .img.on {opacity:1; transform:translateY(0);}
.mEvt108094 .section-04 {padding-bottom:3rem; background:#da5745;}
.mEvt108094 .section-04 .tit {position:relative;}
.mEvt108094 .section-04 .tit .btn-detail {width:100%; height:10%; position:absolute; left:0; top:66%; background:transparent;}
.mEvt108094 .quiz-container {position:relative; height:58.35rem; background:#da5745;}
.mEvt108094 .quiz-container .view-list div {width:10.43rem; position:absolute; left:50%; top:4%; transform: translate(-50%,0);}
.mEvt108094 .quiz-container .choice-list {position:absolute; left:50%; bottom:15%; transform: translate(-50%,0); display:flex; align-items:center; justify-content:center;}
.mEvt108094 .quiz-container .choice-list button {width:8.69rem; margin:0 0.3rem; background:transparent;}
.mEvt108094 .quiz-container .btn-next {width:8.17rem; position:absolute; left:50%; bottom:9%; transform: translate(-50%,0); background:transparent;}
.mEvt108094 .quiz-container .btn-apply {width:10.39rem; position:absolute; left:50%; bottom:8.5%; transform: translate(-50%,0); background:transparent;}
.mEvt108094 .quiz-container .quiz-01,
.mEvt108094 .quiz-container .quiz-02,
.mEvt108094 .quiz-container .quiz-03 {width:32.61rem; position:absolute; left:50%; top:0; transform:translate(-50%,0);}

.mEvt108094 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt108094 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt108094 .pop-container .pop-inner a {display:inline-block;}
.mEvt108094 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt108094 .pop-container .pop-inner .btn-review {width:100%; height:60%; position:absolute; left:0; bottom:0; background:transparent;}
.mEvt108094 .pop-container.review {z-index:160;}
.mEvt108094 .pop-container.review .pagination {left:50%; bottom:6%; transform:translate(-50%,0);}
.mEvt108094 .pop-container.review .btn-share {background:transparent;}
.mEvt108094 .pop-container.review .swiper-slide {position:relative;}
.mEvt108094 .pop-container.review .swiper-slide .win {position:absolute; left:50%; top:11%; transform:translate(-50%,0);}
.mEvt108094 .pop-container.review .swiper-slide .fail {position:absolute; left:50%; top:9%; transform:translate(-50%,0);}
.mEvt108094 .pop-container.fail .pop-contents {position: relative;}
.mEvt108094 .pop-container.review .pop-inner .btn-close {position:absolute; right:2.73rem; top:0.5rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt108094 .navi-wrap {height:5.43rem; margin:0 2.17rem;}
.mEvt108094 .navi-wrap .swiper-button-prev {left:0; top:50%; transform: translate(0,-50%); width:2rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_left.png) no-repeat 0 50%; background-size:0.82rem 1.60rem;}
.mEvt108094 .navi-wrap .swiper-button-next {right:0; top:50%; transform: translate(0,-50%); width:2rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_right.png) no-repeat right 50%; background-size:0.82rem 1.60rem;}
.mEvt108094 .navi-wrap .swiper-slide a {display:inline-block; height:100%; line-height:5.43rem; margin:0 0.95rem; font-size:1.30rem; color:#191919; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt108094 .navi-wrap .swiper-slide div {font-size:1.30rem; color:#999999; text-align:center;}
.mEvt108094 .navi-wrap .swiper-wrapper {display:flex; align-items:center; justify-content:center; height:5.43rem;}
.mEvt108094 .navi-wrap .swiper-slide .txt {width:4.56rem; height:2.30rem; margin:0 0.95rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/txt_nav.png) no-repeat 0 0; background-size:100%;}
@keyframes updown {
    0% {top:77%;}
    100% {top:79%;}
}
</style>
<script>
var numOfTry = '<%=triedNum%>';
var isShared = "<%=isShared%>";

$(function(){
    //팝업
    /* 자세히보기 팝업 */
    $('.mEvt108094 .btn-detail').click(function(){
        $('.pop-container.detail').fadeIn();
    })
    /* 틀린문제 다시보기 팝업 */
    $('.mEvt108094 .btn-review').click(function(){
        $('.pop-container.review').fadeIn();
        var myswiper = new Swiper(".slide-review .swiper-container", {
        speed: 500,
        slidesPerView:'auto',
        pagination:".slide-review .pagination",
        loop:true
    });
    })
    /* 팝업 닫기 */
    $('.mEvt108094 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
    /* 글자,이미지 스르륵 모션 */
    $(window).scroll(function(){
        $('.section-02 .tit,.section-02 .img').each(function(){
        var y = $(window).scrollTop() + $(window).height() * 1;
        var imgTop = $(this).offset().top;
        if(y > imgTop) {
            $(this).addClass('on');
        }
        });
    });
    /* slide */
    var swiper = new Swiper(".section-01 .swiper-container", {
        autoplay: 1,
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-01 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-02 .swiper-container", {
        autoplay: 1,
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-02 .pagination",
        loop:true
    });
    var swiper = new Swiper(".section-06 .swiper-container", {
        autoplay: 1,
        speed: 2000,
        slidesPerView:'auto',
        pagination:".section-06 .pagination",
        loop:true
    });
    var swiper = new Swiper(".navi-wrap .swiper-container", {
        slidesPerView:'auto',
        navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
        },
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });
});
var _QA1=0;
var _QA2=0;
var _QA3=0;
function fnReplySet(num){
    <% If IsUserLoginOK() Then %>
        var ec=0;
        for(var x=1;x<10;x++){
            $("#reply"+x).hide();
        }
        $("#reply"+num).show();
        
        if(num==1||num==4||num==7){
            ec=1;
            $("#q1").hide();
            $("#q4").hide();
            $("#q7").hide();
        }
        else if(num==2||num==5||num==8){
            ec=2;
            $("#q2").hide();
            $("#q5").hide();
            $("#q8").hide();
        }
        else if(num==3||num==6||num==9){
            ec=3;
            $("#q3").hide();
            $("#q6").hide();
            $("#q9").hide();
        }
        else{
            ec=num;
        }
        if(num==1||num==2||num==3){
            if(_QA1!=0){
                if(_QA1==1){
                    $("#q1").show();
                    $("#q4").show();
                    $("#q7").show();
                }else if(_QA1==2){
                    $("#q2").show();
                    $("#q5").show();
                    $("#q8").show();
                }else if(_QA1==3){
                    $("#q3").show();
                    $("#q6").show();
                    $("#q9").show();
                }
            }
        }
        if(num==4||num==5||num==6){
            if(_QA2!=0){
                if(_QA2==1){
                    $("#q1").show();
                    $("#q4").show();
                    $("#q7").show();
                }else if(_QA2==2){
                    $("#q2").show();
                    $("#q5").show();
                    $("#q8").show();
                }else if(_QA2==3){
                    $("#q3").show();
                    $("#q6").show();
                    $("#q9").show();
                }
            }
        }

        if(num==4||num==5||num==6){
            $("#a2").val(ec);
            _QA2=ec;
            if(ec==1){
                $("#scoring2").empty().append('<div class="list01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>');
            }else if(ec==2){
                $("#scoring2").empty().append('<div class="list02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>');
            }else if(ec==3){
                $("#scoring2").empty().append('<div class="list03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>');
            }
        }
        else if(num==7||num==8||num==9){
            $("#a3").val(ec);
            _QA3=ec;
            if(ec==1){
                $("#scoring3").empty().append('<div class="list01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>');
            }else if(ec==2){
                $("#scoring3").empty().append('<div class="list02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>');
            }else if(ec==3){
                $("#scoring3").empty().append('<div class="list03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>');
            }
        }
        else{
            $("#a1").val(ec);
            _QA1=ec;
            if(ec==1){
                $("#scoring1").empty().append('<div class="list01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>');
            }else if(ec==2){
                $("#scoring1").empty().append('<div class="list02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>');
            }else if(ec==3){
                $("#scoring1").empty().append('<div class="list03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>');
            }
        }
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
function fnNextQuestion(num){
    if(($("#a1").val()!="" && num==2)||($("#a2").val()!="" && num==3)){
        $(".quiz-0"+num).show();
    }
    else{
        alert("보기 선택 후 진행해주세요.");
    }
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(($("#a3").val()=="")){
            alert("보기 선택 후 진행해주세요.");
            return false;
        }			
		var returnCode, itemid, data
		var data={
			mode: "add",
            a1: $("#a1").val(),
            a2: $("#a2").val(),
            a3: $("#a3").val()
		}
		$.ajax({
			type:"POST",
			url:"/event/etc/doeventSubscript108094.asp",
			data: data,
			dataType: "JSON",
			success : function(res){
				fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|option1','<%=eCode%>|' + $("#a1").val()+$("#a2").val()+$("#a3").val())
					if(res!="") {
						// console.log(res)
						if(res.response == "ok"){
                            popResult(res.returnCode, res.answer1, res.answer2, res.answer3);
							return false;
						}else{
							alert(res.faildesc);
							return false;
						}
					} else {
						alert("잘못된 접근 입니다.1");
						document.location.reload();
						return false;
					}
			},
			error:function(err){
				console.log(err)
				alert("잘못된 접근 입니다.2");
				return false;
			}
		});
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}

function popResult(returnCode, answer1, answer2, answer3){
    console.log(answer1);
    console.log(answer2);
    console.log(answer3);
	if(returnCode[0] == "A"){
		numOfTry++
        $("#fail").show();
        if(answer1=="O"){
            $("#winfail1").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_win.png" alt="문제 맞춤">');
        }
        else{
            $("#winfail1").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_fail.png" alt="문제 틀림">');
        }
        if(answer2=="O"){
            $("#winfail2").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_win.png" alt="문제 맞춤">');
        }
        else{
            $("#winfail2").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_fail.png" alt="문제 틀림">');
        }
        if(answer3=="O"){
            $("#winfail3").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_win.png" alt="문제 맞춤">');
        }
        else{
            $("#winfail3").empty().append('<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/icon_fail.png" alt="문제 틀림">');
        }
	}else if(returnCode[0] == "R"){
		numOfTry++;
		$("#win").show();
	}
}

function sharesns(snsnum) {
		$.ajax({
			type: "GET",
			url:"/event/etc/doeventSubscript108094.asp",
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
function fnQAReset(){
    for(var x=1;x<10;x++){
        $("#reply"+x).hide();
        $("#q"+x).show();
    }
    _QA1=0;
    _QA2=0;
    _QA3=0;
    $("#a1").val("");
    $("#a2").val("");
    $("#a3").val("");
    $(".quiz-02").hide();
    $(".quiz-03").hide();
    $(".quiz-01").show();
    $("#reply01").show();
    $("#reply02").show();
    $("#reply03").show();
}
</script>
			<div class="mEvt108094">
                <style type="text/css">
                #tab-hobby {display:block; width:100%; height:5.43rem;}
                </style>
                <div class="mhobby">
                    <iframe id="tab-hobby" src="/event/etc/group/iframe_favorites.asp?eventid=108094" frameborder="0" scrolling="no" title="서촌도감"></iframe>
                </div>
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_tit.jpg" alt="서촌도감을 완성해주세요."></h2>
                    <div class="icon-arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_arrow.png" alt="arrow"></div>
                </div>
                <div class="section-01">
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide1_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide1_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide1_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                </div>
                <div class="section-02">
                    <div class="tit tit-01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub_txt01.png" alt="서촌도감은 지속가능한 생활 양식을 전하는 곳 이에요."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub01.jpg" alt="img01"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub02.png" alt="img02"></div>
                    <div class="tit tit-02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub_txt02.png" alt="미풍양속과 공생을 컨셉을 갖고 있습니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub03.jpg" alt="img03"></div>
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide2_01.png" alt="slide01">
                                </div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide2_02.png" alt="slide02">
								</div>
								<div class="swiper-slide">
									<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide2_03.png" alt="slide03">
                                </div>
                            </div>
                            <!-- If we need pagination -->
                            <div class="pagination"></div>
						</div>
                    </div>
                    <div class="tit tit-03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub_txt03.png" alt="미풍양속과 공생을 컨셉을 갖고 있습니다."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub04.jpg" alt="img04"></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub05.jpg" alt="img05"></div>
                    <div class="tit tit-04"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub_txt04.png" alt="여러분도 자연의 향과 소리가 느껴지는 서촌도감에서 제로웨이스트를 시작해보세요."></div>
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sub06.png" alt="img06"></div>
                </div>
                <div class="section-03">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_story.png" alt="서촌도감 Q & A">
                </div>
                <div class="section-05">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_event_benefit.jpg" alt="이벤트 혜택">
                    <button type="button" class="link btn-detail"></button>
                </div>
                <div class="section-04">
                    <div class="tit">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_tit_event.jpg" alt="서촌도감을 완성해 주세요.">
                        <button type="button" class="btn-detail"></button>
                    </div>
                    <!-- 퀴즈 영역 -->
                    <div class="quiz-container">
                        <!-- 첫 번째 문제 -->
                        <div class="quiz-01">
                            <!-- 문제 영역 -->
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz01.png" alt="첫 번쨰 문제 이미지">
                            
                            <!-- for dev msg : 선택된 보기 노출 영역 -->
                            <div class="view-list">
                                <div class="list01" id="reply01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply01.png" alt="디폴트"></div>
                                <div class="list02" id="reply1" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>
                                <div class="list03" id="reply2" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>
                                <div class="list04" id="reply3" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>
                            </div>
                            
                            <!-- for dev msg : 보기 선택 영역 -->
                            <div class="choice-list">
                                <button type="button" id="q1" onClick="fnReplySet(1)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item01.png" alt="오수 이끼 초록 코스터"></button>
                                <button type="button" id="q2" onClick="fnReplySet(2)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item02.png" alt="허스키 텀블러"></button>
                                <button type="button" id="q3" onClick="fnReplySet(3)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item03.png" alt="오선주 오일 버너"></button>
                            </div>

                            <!-- for dev msg : 다음 문제 클릭시 두 번쨰 문제 노출 -->
                            <button type="button" class="btn-next" onClick="fnNextQuestion(2);"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_btn_next.png" alt="다음 문제"></button>
                        </div>
                        <!-- 두 번째 문제 -->
                        <div class="quiz-02" style="display:none;">
                            <!-- 문제 영역 -->
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz02.png" alt="두 번쨰 문제 이미지">
                            
                            <!-- for dev msg : 선택된 보기 노출 영역 -->
                            <div class="view-list">
                                <div class="list01" id="reply02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply01.png" alt="디폴트"></div>
                                <div class="list02" id="reply4" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>
                                <div class="list03" id="reply5" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>
                                <div class="list04" id="reply6" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>
                            </div>
                            
                            <!-- for dev msg : 보기 선택 영역 -->
                            <div class="choice-list">
                                <button type="button" id="q4" onClick="fnReplySet(4)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item01.png" alt="오수 이끼 초록 코스터"></button>
                                <button type="button" id="q5" onClick="fnReplySet(5)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item02.png" alt="허스키 텀블러"></button>
                                <button type="button" id="q6" onClick="fnReplySet(6)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item03.png" alt="오선주 오일 버너"></button>
                            </div>

                            <!-- for dev msg : 다음 문제 클릭시 세 번쨰 문제 노출  -->
                            <button type="button" class="btn-next" onClick="fnNextQuestion(3);"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_btn_next.png" alt="다음 문제"></button>
                        </div>
                        <!-- 세 번째 문제 -->
                        <div class="quiz-03"  style="display:none;">
                            <!-- 문제 영역 -->
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz03.png" alt="세 번쨰 문제 이미지">
                            
                            <!-- for dev msg : 선택된 보기 노출 영역 -->
                            <div class="view-list">
                                <div class="list01" id="reply03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply01.png" alt="디폴트"></div> 
                                <div class="list02" id="reply7" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply02.png" alt="오수 이끼 초록 코스터"></div>
                                <div class="list03" id="reply8" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply03.png" alt="허스키 텀블러"></div>
                                <div class="list04" id="reply9" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_apply04.png" alt="오선주 오일 버너"></div>
                            </div>
                            
                            <!-- for dev msg : 보기 선택 영역 -->
                            <div class="choice-list">
                                <button type="button" id="q7" onClick="fnReplySet(7)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item01.png" alt="오수 이끼 초록 코스터"></button>
                                <button type="button" id="q8" onClick="fnReplySet(8)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item02.png" alt="허스키 텀블러"></button>
                                <button type="button" id="q9" onClick="fnReplySet(9)"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_item03.png" alt="오선주 오일 버너"></button>
                            </div>

                            <!-- 정답 제출하기 버튼 -->
                            <button type="button" class="btn-apply" onClick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_btn_apply.png" alt="정답 제출하기"></button>
                        </div>
                        <input type="hidden" name="a1" id="a1">
                        <input type="hidden" name="a2" id="a2">
                        <input type="hidden" name="a3" id="a3">
                        <!-- 수정 2020-12-29 -->
                        <!-- 틀린문제 다시보기 팝업 -->
                        <div class="pop-container review">
                            <div class="pop-inner">
                                <div class="pop-contents">
                                    <div class="slide-area slide-review">
                                        <div class="swiper-container">
                                            <div class="swiper-wrapper">
                                                <div class="swiper-slide">
                                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz_slide01.jpg" alt="slide01">
                                                    <div class="view-list" id="scoring1"></div>
                                                    <div class="win" id="winfail1"></div>
                                                </div>
                                                <div class="swiper-slide">
                                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz_slide02.jpg" alt="slide02">
                                                    <div class="view-list" id="scoring2"></div>
                                                    <div class="win" id="winfail2"></div>
                                                </div>
                                                <div class="swiper-slide">
                                                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_quiz_slide03.jpg" alt="slide03">
                                                    <div class="view-list" id="scoring3"></div>
                                                    <div class="win" id="winfail3"></div>
                                                </div>
                                            </div>
                                            <!-- If we need pagination -->
                                            <div class="pagination"></div>
                                        </div>
                                    </div>
                                    <!-- for dev msg : 카카오 공유하기 -->
                                    <button type="button" class="btn-share" onclick="sharesns('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_share.png" alt="카카오 공유하기"></button>
                                </div>
                                <button type="button" class="btn-close" onClick="fnQAReset()">닫기</button>
                            </div>
                        </div>
                        <!-- // 수정 2020-12-29 -->
                    </div>
                </div>
                <div class="section-06">
                    <div class="sns-area">
                        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_tit_sub02.png" alt="event2"></div>
                        <div class="slide-area">
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide3_01.png" alt="slide01">
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide3_02.png" alt="slide02">
                                    </div>
                                    <div class="swiper-slide">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_slide3_03.png" alt="slide03">
                                    </div>
                                </div>
                                <!-- If we need pagination -->
                                <div class="pagination"></div>
                            </div>
                        </div>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_sns.jpg" alt="sns 이벤트">
                    </div>
                    <!-- 인스타그램으로 이동 -->
                    <a href="https://www.instagram.com/dogam_seochon"  onclick="fnAmplitudeEventMultiPropertiesAction('landing_instagram','evtcode|option1','<%=eCode%>|')" class="mWeb">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_insta.jpg" alt="서촌도감 구경하로 가기">
					</a>
                    <a href="" onclick="fnAPPpopupExternalBrowser('https://www.instagram.com/dogam_seochon'); return false;" class="mApp">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_insta.jpg" alt="서촌도감 구경하로 가기">
					</a>
                    <!-- 즐겨찾길 이동 -->
                    <a href="/event/eventmain.asp?eventid=108102" onclick="jsEventlinkURL(108102);fnAmplitudeEventMultiPropertiesAction('landing_bookmark_seochon','evtcode|option1','<%=eCode%>|');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_favorites.jpg" alt="즐겨찾길 메인으로 이동"></a>
                </div>
                <!-- 팝업 - 자세히 보기 -->
                <div class="pop-container detail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_pop01.png" alt="플랑드비 비건 올라이트 바디솝">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 정답인 경우 -->
                <div class="pop-container win" id="win">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_pop03_01.png" alt="축하합니다! 서촌도감을 전부 완성하셨습니다. 이벤트 당첨자는 3월 12일, 텐바이텐 공지사항을 통해 발표됩니다.">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <!-- 팝업 - 오답인 경우 -->
                <div class="pop-container fail" id="fail">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108094/m/img_pop02.png" alt="아쉽지만 오답! 틀린 문제를 확인하고 다시 풀어보세요!">
                            <button type="button" class="btn-review"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
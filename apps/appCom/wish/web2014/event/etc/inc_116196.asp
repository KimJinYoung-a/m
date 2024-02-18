<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 내 맘 속 1등 시그는?
' History : 2021.12.23 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/ordercls/event_myordercls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim eventStartDate, eventEndDate, LoginUserid, mktTest
dim eCode, currentDate, moECode, rsMem, arrRankList, intLoop

IF application("Svr_Info") = "Dev" THEN
	eCode = "109438"
    moECode = "109402"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "116196"
    moECode = "116197"
    mktTest = True
Else
	eCode = "116196"
    moECode = "116197"
    mktTest = False
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

eventStartDate  = cdate("2021-12-27")		'이벤트 시작일
eventEndDate 	= cdate("2022-01-09")		'이벤트 종료일

LoginUserid		= getencLoginUserid()

if mktTest then
    currentDate = cdate("2021-12-27")
else
    currentDate = date()
end if

dim sqlstr, mySelectItem
if LoginUserid<>"" then
	sqlstr = "select top 1 sub_opt2"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"'"
    sqlstr = sqlstr & " and sub_opt3='try'"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		mySelectItem = rsget("sub_opt2")
	END IF
	rsget.close
end if

sqlstr = "select sub_opt2, count(sub_opt2)"
sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " where evt_code="& eCode &""
sqlstr = sqlstr & " and sub_opt3='try'"
sqlstr = sqlstr & " group by sub_opt2"
sqlstr = sqlstr & " order by count(sub_opt2) desc"
set rsMem = getDBCacheSQL(dbget,rsget,"Event116196",sqlstr,10)  ''10초
if NOT (rsMem is Nothing) then 
    IF Not (rsMem.EOF OR rsMem.BOF) THEN
        arrRankList = rsMem.GetRows()
    END IF
    rsMem.close
end if
set rsMem = Nothing

'// 카카오 링크
Dim kakaotitle : kakaotitle = "내 맘 속 1등 시그는?"
Dim kakaodescription : kakaodescription = "가장 갖고 싶은 2022 시즌그리팅에 투표하면, 선물로 드려요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/116196/m/116196_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode

function fnAlbumDivName(divnum)
if divnum="1" then
    fnAlbumDivName = "aespa"
elseif divnum="2" then
    fnAlbumDivName = "exo"
elseif divnum="3" then
    fnAlbumDivName = "itzy"
elseif divnum="4" then
    fnAlbumDivName = "monstax"
elseif divnum="5" then
    fnAlbumDivName = "nct127"
elseif divnum="6" then
    fnAlbumDivName = "nctdream"
elseif divnum="7" then
    fnAlbumDivName = "shinee"
elseif divnum="8" then
    fnAlbumDivName = "straykids"
elseif divnum="9" then
    fnAlbumDivName = "twice"
end if
end function
%>
<style type="text/css">
.mEvt116196 section{position:relative;}

.mEvt116196 .section{position: relative;}
.mEvt116196 .section01_02 .scroll img{position:absolute;top: 0; width: 87vw;left: 50%;margin-left: -43.5vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s;}
.mEvt116196 .section01_03 .scroll img{position:absolute;top: 0; width: 100vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s .4s;}
.mEvt116196 .section01_04  .scroll img{position:absolute;top: 0; width: 62vw;left: 50%;margin-left: -31vw;opacity:0;transform:translateY(20vw);transition:ease-in-out 1s .8s;}
.mEvt116196 .section .scroll img.on{opacity:1;transform:translateY(0);}

.mEvt116196 .section02 .slide-area {position:absolute; left:50%; top: 0; transform: translate(-50%,0); width:100%;}
.mEvt116196 .section02 .slide-area .swiper-wrapper {transition-timing-function:linear;}
.mEvt116196 .section02 .swiper-wrapper .swiper-slide {padding:0 3.1vw;}
.mEvt116196 .section02 .swiper-slide div{width: 45.6vw;}
.mEvt116196 .section02 div.exo{width:62.4vw ;padding-top: 8vw;}
.mEvt116196 .section02 div.itzy{width:61vw ;padding-top: 6.5vw;}
.mEvt116196 .section02 div.twice{width:65.8vw ;padding-top: 10.1vw;}

.mEvt116196 .section03 div{position: relative;}   
.mEvt116196 .section03_02{height: 326vw;background: #fff;}
.mEvt116196 .section03 .button01, .button03, .button05, .button07{background:transparent;width:43.3vw;position: absolute;left:5.2vw;}
.mEvt116196 .section03 button:nth-of-type(2n){background:transparent;width:43.3vw;position: absolute;right:5.2vw;}
.mEvt116196 .section03 .button01, .button02{top:0;}
.mEvt116196 .section03 .button03, .button04{top:64vw;}
.mEvt116196 .section03 .button05, .button06{top:128vw;}
.mEvt116196 .section03 .button07, .button08{top:192vw;}
.mEvt116196 .section03 .button09{top:256vw;left: 50%; transform: translateX(-50%);background:transparent;width:43.3vw;position: absolute;}
/*.mEvt116196 .section03 .section03_07 .btn01{display: none;}*/
.mEvt116196 .section03 button::after{position: absolute;content: '';width: 43.3vw;height: 43.3vw;top: 0;left: 0;background: url(//webimage.10x10.co.kr/fixevent/event/2021/116196/m/pink.png)no-repeat;opacity: 0; background-size: 100%;}
.mEvt116196 .section03 button.on::after{opacity: 1;}

.mEvt116196 .section04 .slider2-area{width:80vw;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);}
.mEvt116196 .section04 .slider2-area .slider .slick-slide{position: relative;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide div{width:43.4vw;margin: auto;height: 100vw;}
.mEvt116196 .section04 .slider2-area .slider div img{width:100%;align-items: center;transform: translateY(20%);}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .exo{width:62vw;margin: auto;padding-top: 9.3vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .itzy{width:62vw;margin: auto;padding-top: 3.6vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .twice{width:62vw;margin: auto;padding-top: 12vw;}
.mEvt116196 .section04 .slider2-area .slick-prev, .mEvt116196 .slick-next{width:10vw;height:15vw;display:block;transform: translateY(-50%);}
.mEvt116196 .section04 .slick-prev::after{content:""; position:absolute; left:3px; top:0; display:inline-block; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116196/m/left.png) no-repeat 0 0; background-size:30%;}
.mEvt116196 .slick-next::after{content:""; position:absolute; right:0; top:0; display:inline-block; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2021/116196/m/right.png) no-repeat 0 0; background-size:30%;}
.mEvt116196 .section04 .slick-prev{left:-6vw;margin-top:-5vw;}
.mEvt116196 .section04 .slick-next{right:-12vw;margin-top:-5vw;}
.mEvt116196 .section04.slider .slick-list {margin:0 -28vw;}
.mEvt116196 .section04 .slick-slide {margin:0 28vw;}
.mEvt116196 .slick-next::before, .mEvt116196 .slick-prev::before{content: none;}
.mEvt116196 .crown{width: 21vw;position: absolute;top:2vw;left: -10vw;display: none;}
.mEvt116196 .aespa .crown{display: block;}
/*.mEvt116196 .aespa .vote{display: none;}*/
.mEvt116196 .crown p{width:63vw;font-size: 2.05rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';font-weight:600;color:#d54d89;text-align: right;left:-1vw;position: absolute;top:5vw;font-style: italic;}
.mEvt116196 .crown p span{font-size: 1.23rem;font-weight: normal;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .exo .crown{top:7vw;left:-6vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .exo .crown p{width: 68vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .itzy .crown{top:10vw;left:-6vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .itzy .crown p{width: 68vw;top:-1vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .twice .crown{top:8vw;left:-6vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .twice .crown p{width: 68vw;top:6vw;}
.mEvt116196 .vote{width:63vw;font-size: 1.48rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';font-weight: normal;color:#d54d89;text-align: right;left:-20vw;position: absolute;top:9vw;font-style: italic;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .exo .vote{left:-1vw;top:15vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .itzy .vote{left:-1vw;top:12vw;}
.mEvt116196 .section04 .slider2-area .slider .slick-slide .twice .vote{left:-1vw;top:16vw;}

.mEvt116196 .section05 .noti_wrap{position: relative;}
.mEvt116196 .section05 .noti_wrap .noti{position:absolute;width: 100%;height:5rem;bottom: 0;}
.mEvt116196 .section05 .noti_wrap .noti::after{content:'';display:block;background:url(//webimage.10x10.co.kr/fixevent/event/2021/116196/m/arrow.png) no-repeat 0 0;transform: rotate(0deg);position:absolute;bottom:5.8vw;left:67.3vw;background-size:100%;width:3.1vw;height:1rem;}
.mEvt116196 .section05 .noti_wrap .noti.on::after{transform: rotate(180deg);top:5vw;}
.mEvt116196 .section05 .notice{display:none;}

.mEvt116196 .section06_02{position: relative;}
.mEvt116196 .section06_02 a{position: absolute;width: 24vw;height: 100%;display: block;top: 0;}
.mEvt116196 .section06_02 .kakao{left: 20vw;}
.mEvt116196 .section06_02 .url{right: 20vw;}

.mEvt116196 .lyr {display:none; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116196 .lyr .inner{width:87%;position:absolute; left:50%; top:50%; transform:translate(-50%, -50%); max-width:32rem;}
.mEvt116196 .lyr .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}
.mEvt116196 .lyr .inner a:nth-of-type(2) {display:block; position:absolute; bottom:2rem; width:100%; height:7rem;}
.mEvt116196 .lyr .id{position:absolute;width: 100%;text-align: center;top:14%;color:#d54d89;font-size: 1.56rem;}
.mEvt116196 .lyr .id span{font-size: 1.85rem;font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; text-decoration: underline;text-underline-position: under; font-weight:600;}

.mEvt116196 .lyr.popup2 {display:block; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.mEvt116196 .lyr.popup2 .inner{width:87%;position:absolute; left:50%; top:9%; transform:translateX(-50%); max-width:32rem;padding-bottom: 12vw;}
.mEvt116196 .lyr.popup2 .inner a:nth-of-type(1) {display:block; position:absolute; top:0; right:0; width:16vw; height:5rem;}

</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
$(function(){
	// 팝업레이어
	$('.mEvt116196 .lyr .btn_close').click(function(){
        $('.lyr').css('display','none');
        return false;
	})

    // 스크롤 시 나타나기
    $('.mEvt116196 .section .scroll img').addClass('on');

    // noti
    $('.noti_wrap .noti').click(function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			$('.notice').css('display','none');
		}else{
			$(this).addClass('on');
			$('.notice').css('display','block');
		}
	});

    // 투표하기
    $('.section03 button').click(function() {
		$(this).siblings().removeClass('on');
		$(this).toggleClass('on');
	});

    var swiper = new Swiper(".slide-area .swiper-container", {
        autoplay: 1,
        speed: 3000,
        slidesPerView:'auto',
        spaceBetween:20,
        loop:true,
        autoHeight : true,
    });

    //실시간

	$('.slider').slick({
		arrows: true,
		speed: 1500,
		autoplay: false,
		variableWidth: true,
		centerMode: true,
        slidesToShow: 1,
        prevArrow : "<button type='button' class='slick-prev'>Previous</button>",
		nextArrow : "<button type='button' class='slick-next'>Next</button>",	
        infinite : false, 
	});
    
})

function fnItemSelect(itemid){
    $("#itemcode").val(itemid);
}

function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>

        if($("#itemcode").val()==""){
			alert("시즌그리팅을 선택해 주세요.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116196.asp",
            data: {
                mode: 'add',
                itemcode: $("#itemcode").val()
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode|item','<%=eCode%>|'+$("#itemcode").val());
                    $('.lyr').css('display','block');
                    fnRankReload();
                    return false;
                }else if(data.response == "retry"){
                    alert('이미 신청하셨습니다.');
                    return false;
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
                return false;
            }
        })
    <% else %>
        calllogin();
		return false;
    <% end if %>
}

function fnUrlCopy(){
    const clipboard = new Clipboard('#urlCopy');
    clipboard.on('success', function() {
        alert('URL이 복사 되었습니다.');
        return false;
    });
    clipboard.on('error', function() {
        alert('URL을 복사하는 도중 에러가 발생했습니다.');
        return false;
    });
}

function doAlarm() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        $.ajax({
            type: "POST",
            url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116196.asp",
            data: {
                mode: 'alarm'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    alert(data.message);
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

function jsSubmitlogin(){
    calllogin();
    return false;
}

function fnRankReload() {
    var itemEle = tmpEl = "";
    var $rootEl = $(".slider");
    $rootEl.empty();
    $.ajax({
        type: "POST",
        url:"/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript116196.asp",
        data: {
            mode: 'rank'
        },
        dataType: "JSON",
        success: function(data){
            if(data.response == "ok"){
                $.each(data.items, function(idx, item){
                    if(idx==0){
                        tmpEl = `
                                <div class="slick-slide">
                                    <div class="` + item.divname + `"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig0` + item.gdiv + `_03.png" alt="">
                                        <ul class="crown">
                                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/crown.png" alt="">
                                        </ul>
                                        <ul class="vote"><p>` + item.cnt + `<span>표</span></p></ul>
                                    </div>
                                </div>
                                `
                    }
                    else{
                        tmpEl = `<div class="slick-slide">
                                    <div class="` + item.divname + `"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig0` + item.gdiv + `_03.png" alt="">
                                        <ul class="vote"><p>` + item.cnt + `<span>표</span></p></ul>
                                    </div>
                                </div>
                                `
                    }
                    itemEle += tmpEl
				});
                $rootEl.append(itemEle);
                $('.slider').slick('refresh');
            }else{
                alert('시스템 오류입니다.');
            }
        },
        error: function(data){
            alert('시스템 오류입니다.');
        }
    })
}

function snschk(snsnum) {
<% if isapp then %>
    fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
    return false;
<% else %>
    event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
<% end if %>
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
			<div class="mEvt116196">
				<section class="section01">
                    <div class="section section01_01">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section01_01.jpg" alt="">
                    </div>
                    <div class="section section01_02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section01_02.jpg" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/txt01.png" alt="" class="top01">
                        </div>
                    </div>
                    <div class="section section01_03">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section01_03.jpg" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/txt02.png" alt="" class="top01">
                        </div>
                    </div>
                    <div class="section section01_04">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section02_01.jpg" alt="">
                        <div class="scroll">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/txt03.png" alt="" class="top01">
                        </div>
                    </div>
                </section>

                <section class="section02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section02_02.jpg" alt="">
                    <div class="slide-area">
                        <div class="swiper-container">
							<div class="swiper-wrapper">
                                <div class="swiper-slide"><div class="aespa"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig01.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="exo"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig02.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="itzy"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig03.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="monstax"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig04.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="nct127"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig05.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="nctdream"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig06.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="shinee"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig07.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="straykids"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig08.png" alt=""></div></div>
                                <div class="swiper-slide"><div class="twice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig09.png" alt=""></div></div>
							</div>
						</div>
                    </div>
                </section>
                
                <section class="section03">
                    <div class="section03_01">
                        <input type="hidden" id="itemcode">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section03_01.jpg" alt=""> 
                    </div>
                    <div class="section03_02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section03_02.jpg" alt=""> 
                        <button class="button01<% if mySelectItem="1" then response.write " on after" %>" onclick="fnItemSelect(1);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig01_02.png" alt="">
                        </button>
                        <button class="button02<% if mySelectItem="2" then response.write " on after" %>" onclick="fnItemSelect(2);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig02_02.png" alt="">
                        </button>
                        <button class="button03<% if mySelectItem="3" then response.write " on after" %>" onclick="fnItemSelect(3);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig03_02.png" alt="">
                        </button>
                        <button class="button04<% if mySelectItem="4" then response.write " on after" %>" onclick="fnItemSelect(4);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig04_02.png" alt="">
                        </button>
                        <button class="button05<% if mySelectItem="5" then response.write " on after" %>" onclick="fnItemSelect(5);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig05_02.png" alt="">
                        </button>
                        <button class="button06<% if mySelectItem="6" then response.write " on after" %>" onclick="fnItemSelect(6);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig06_02.png" alt="">
                        </button>
                        <button class="button07<% if mySelectItem="7" then response.write " on after" %>" onclick="fnItemSelect(7);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig07_02.png" alt="">
                        </button>
                        <button class="button08<% if mySelectItem="8" then response.write " on after" %>" onclick="fnItemSelect(8);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig08_02.png" alt="">
                        </button>
                        <button class="button09<% if mySelectItem="9" then response.write " on after" %>" onclick="fnItemSelect(9);">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig09_02.png" alt="">
                        </button>
                    </div>
                    <div class="section03_07">
                        <% if mySelectItem <> "" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/btn01.jpg" alt="">
                        <% else %>
                        <a href="" class="btn02" onclick="doAction();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/btn02.jpg" alt=""></a>
                        <% end if %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section03_07.jpg" alt=""> 
                    </div>
                </section>
                <% if isArray(arrRankList) then %>
                <section class="section04">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section04.jpg" alt="">
                    <div class="slider2-area">
                        <div class="slider">
                            <% For intLoop=0 To UBound(arrRankList,2) %>
                            <div class="slick-slide"><div class="<%=fnAlbumDivName(arrRankList(0,intLoop))%>"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/sig0<%=arrRankList(0,intLoop)%>_03.png" alt="">
                                <% if intLoop=0 then%>
                                <ul class="crown">
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/crown.png" alt="">
                                </ul>
                                <% end if %>
                                <ul class="vote"><p><%=FormatNumber(arrRankList(1,intLoop),0)%><span>표</span></p></ul>
                            </div></div>
                            <% Next %>
                        </div>
                    </div>
                </section>
                <% end if %>
                <section class="section05">  
                    <div class="noti_wrap">
						<img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section05.jpg?v=1.01" alt=""> 
						<p class="noti"></p>
					</div>
                    <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/info.jpg" alt="" class="info"></p>
                </section>

                <section class="section06">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section06_01.jpg" alt="">
                    <div class="section06_02">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section06_02.jpg" alt="">
                        <a href="" class="kakao" onclick="snschk('ka');return false;"></a>
                        <a href="" class="url" onclick="fnUrlCopy();return false;" id="urlCopy" data-clipboard-text="https://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>"></a>
                    </div>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/section06_03.jpg" alt="">

                </section>
                <!-- 팝업레이어 -->
                <div class="lyr popup">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/popup.png" alt="">
                        <a href="" class="btn_close"></a>
                        <!-- 알림받기 버튼 -->
                        <a href="" class="btn_alert" onclick="doAlarm();return false;"></a>
                        <p class="id"><span><%=LoginUserid%></span>&nbsp;님</p>
                    </div>
                </div> 

                <!-- 당첨자 팝업레이어 -->
                <div class="lyr popup2">
                    <div class="inner">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/116196/m/popup02.png" alt="">
                        <a href="" class="btn_close"></a>
                    </div>
                </div> 
		    </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
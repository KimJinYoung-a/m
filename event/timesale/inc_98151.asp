<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 이건 기회야! 릴레이 타임세일
' History : 2019-10-21 이종화 생성 - eventid = 98151
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim currentDate : currentDate = "2019-10-28" '// 이벤트일
dim isTeaser , isAdmin : isAdmin = false
dim currentType , currentTime
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode

Call Alert_Return("이벤트가 종료 되었습니다.")
dbget.close()	:	response.End

IF application("Svr_Info") = "Dev" THEN
	eCode = "90417"	
Else
	eCode = "98151"
End If

'// 티져 여부
if date() = Cdate(currentDate) then 
    isTeaser = false 
else 
    isTeaser = true 
end If 

'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" then
    if date() < Cdate(currentDate) then
        isTeaser = chkiif(requestCheckVar(request("isTeaser"),1) = "1" or requestCheckVar(request("isTeaser"),1) = "" , true , false) '// true 티져 / false 본 이벤트
        currentType = requestCheckVar(request("currentType"),1) '// 1.am8 , 2.pm12 , 3.pm4 , 4.pm12
        isAdmin = true
        addParam = "&isAdmin=1"
    end if
end if

'// 시간별 타입 구분
function fnGetCurrentType(isAdmin , currentType)
    if isAdmin and currentType <> "" then 
        fnGetCurrentType = currentType
        Exit function
    elseif isAdmin and currentType = "" then 
        fnGetCurrentType = "0"
        Exit function
    end if

    '// 시간별 타입
    if hour(now) < 8 then 
        fnGetCurrentType = "0" 
    elseif hour(now) >= 8 and hour(now) < 12 then '// am 8 
        fnGetCurrentType = "1"
    elseif hour(now) >= 12 and hour(now) < 16 then '// pm 12  
        fnGetCurrentType = "2"
    elseif hour(now) >= 16 and hour(now) < 20 then  '// pm 4 
        fnGetCurrentType = "3"
    elseif hour(now) >= 20 then '// pm 8 
        fnGetCurrentType = "4"
    end if 
end function

'// 회차별 시간
function fnGetCurrentTime(currentType)
    select case currentType 
        case "0" 
            fnGetCurrentTime = DateAdd("h",8,Date())
        case "1"
            fnGetCurrentTime = DateAdd("h",12,Date())
        case "2"
            fnGetCurrentTime = DateAdd("h",16,Date())
        case "3"
            fnGetCurrentTime = DateAdd("h",20,Date())
        case "4"
            fnGetCurrentTime = DateAdd("h",24,Date())
        case else
            fnGetCurrentTime = DateAdd("d",1,Date())
    end select 
end function

'// 카카오 메시지 보낼 카운트
function fnGetSendCountToKakaoMassage(currentType)
    dim pushCount

    select case currentType
        case "0" 
            pushCount = 4
        case "1"
            pushCount = 3
        case "2"
            pushCount = 2
        case "3"
            pushCount = 1
        case "4"
            pushCount = 0
        case else
            pushCount = 0
    end select

    '// 10분전 까지 마감 이후 회차 줄어듬
    if currentType <> "0" and currentType <> "4" then 
        fnGetSendCountToKakaoMassage = chkiif(DateDiff("n",DateAdd("n",-10,fnGetCurrentTime(currentType)),now()) < 0 , pushCount , pushCount-1 )
    else
        fnGetSendCountToKakaoMassage = pushCount
    end if 
end function

'// Navi Html
function fnGetTimeNavHtml(currentType)
    dim naviHtml , i
    dim timestamp(4) , addClassName(4)

    for i = 1 to 4
        timestamp(i) = i

        if timestamp(i) = Cint(currentType) then 
            addClassName(i) = "on"
        elseif timestamp(i) < Cint(currentType) then 
            addClassName(i) = "end"
        elseif timestamp(i) > Cint(currentType) then 
            addClassName(i) = ""
        end if 
    next

    naviHtml = naviHtml & "<ul class=""time-nav"">"
    naviHtml = naviHtml & "    <li class=""time time1 "& addClassName(1) &""">am8</li>"
    naviHtml = naviHtml & "    <li class=""time time2 "& addClassName(2) &""">pm12</li>"
    naviHtml = naviHtml & "    <li class=""time time3 "& addClassName(3) &""">pm4</li>"
    naviHtml = naviHtml & "    <li class=""time time4 "& addClassName(4) &""">pm8</li>"
    naviHtml = naviHtml & "</ul>"

    response.write naviHtml
end function

'// 다음 타임 display 체크
function fnNextDisplayCheck(currentType)
    dim checkFlag(4) , isDisplay(4) 
    dim i
    for i = 1 to 4
        checkFlag(i) = i

        if checkFlag(i) <= Cint(currentType) then 
            isDisplay(i) = "style=""display:none"""
        elseif checkFlag(i) > Cint(currentType) then 
            isDisplay(i) = "style=""display:block"""
        end if 
    next

    fnNextDisplayCheck = isDisplay
end function

'// setTimer
if isTeaser then 
    currentTime = DateAdd("d",1,Date()) '// 내일기준시간
else
    currentTime = fnGetCurrentTime(fnGetCurrentType(isAdmin,currentType))
end if 

' response.write isTeaser &"<br/>"
' response.write fnGetCurrentType(isAdmin,currentType) &"<br/>"
' response.write fnGetSendCountToKakaoMassage(fnGetCurrentType(isAdmin,currentType)) &"<br/>"

%>
<style type="text/css">
.not-scroll{position: fixed; overflow: hidden; width:100%; height:auto;}

.time-sale {position:relative; background:#fff;}
.time-sale button {background-color:transparent !important;}
.time-sale .inner {position:relative; width:32rem; margin:0 auto;}

.sale-timer {padding-top:3.41rem; padding-bottom:3.41rem; padding-left:8%; font-size:4.69rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold;}
.sale-timer p {margin-bottom:1.28rem; font-size:2.43rem;}
.btn-alarm {width:32rem; height:4.27rem; margin-top:1.71rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_alarm.png) no-repeat 50% 0/100%; text-indent:-999em;}
.btn-alarm2 {display:inline-block; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_alarm2.png)}

.time-top {position:relative; padding-top:3.41rem; background:#3b0ce8 url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/bg_top2.jpg)no-repeat 50% 50%/100% 100%;}
.time-top h2 {position:relative;}
.time-top h2:after {display:inline-block; position:absolute; top:2.35rem; right:6.06rem; width:.64rem; height:.64rem; background-color:#00ff8a; border-radius:50%; content:'';}
.time-top p {padding-top:11.31rem;}
.time-top .sale-timer {padding-top:1.08rem; padding-bottom:4.91rem; color:#fff;}

.time-nav {display:flex; justify-content:space-between; position:absolute; top:9.09rem; right:-.85rem; width:20.15rem;}
.time-nav .time {width:4.69rem; height:4.8rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time1_1.png?v=1.01); background-repeat:no-repeat; background-position:0 0; background-size:4.69rem 17.11rem; text-indent:-999em;}
.time-nav .time2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time1_2.png);}
.time-nav .time3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time1_3.png);}
.time-nav .time4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time1_4.png);}
.time-nav .time.on {background-position:0 -5.98rem;}
.time-nav .time.end {margin:0 .3rem; background-position:0 100%;}

.alarm {padding:3.2rem 0 3.84rem;}
.alarm .time-nav {position:unset; top:unset; right:unset; margin:2.56rem 0 5.12rem 6%;}
.alarm .time-nav .time {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time2_1.png?v=1.01);}
.alarm .time-nav .time2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time2_2.png);}
.alarm .time-nav .time3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time2_3.png);}
.alarm .time-nav .time4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_time2_4.png);}

.time-sale .desc {padding-left:.43rem; margin-top:1.12rem;}
.time-sale .name {font-size:1.28rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.time-sale .price {display:flex; justify-content:space-between; align-items:flex-end; margin-top:.6rem; font-size:1.15rem;}
.time-sale .price p b {display:inline-block; width:100%; margin-bottom:.33rem; color:#888; text-decoration:line-through;}
.time-sale .price em {font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:1.5rem;}
.time-sale .price em span {display:inline-block; margin-left:.2rem; font-size:1.2rem; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-weight:normal;}
.time-sale .price .sale {display:inline-block; margin-right:.8rem; color:#ff3823; font-size:1.9rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold;}

.time-items .txt-time {margin-bottom:1.15rem;}
.time-items ul {display:flex; justify-content:space-between; flex-wrap:wrap; padding:0 0 4.91rem 8%;}
.time-items ul li {flex-basis:14.51rem; margin-top:2.56rem;}
.time-items .thumbnail {position:relative; width:14.51rem; height:14.51rem;}
.time-items .thumbnail .label {display:inline-block; position:absolute; bottom:-.48rem; left:.43rem; z-index:10; height:1.36rem; padding:0 .85rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/bg_badge_blck.png); background-repeat:no-repeat; background-position:50% 50%; background-size:100% 100%; color:#fff; font-size:1.02rem; line-height:1.55rem;}
.time-items .special-item .thumbnail {background-color:transparent;}
.time-items .special-item .thumbnail .label {left:0; width:5.12rem; height:1.37rem; padding:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_limited_badge.png); text-indent:-999em;}

.time-teaser {padding-bottom:10rem;}
.time-teaser h2 {position:absolute; top:0; left:0;}
.time-top h2:after {display:none;}
.time-teaser .time-top {padding-top:0; background:none;}
.time-teaser .slideshow {position:absolute; top:23.43%; right:8.13%; width:17.73%;}
.time-teaser #slideshow div {position:absolute; top:0; left:0; z-index:8; width:100%; opacity:0.0;}
.time-teaser #slideshow div.active {z-index:10; opacity:1.0;}
.time-teaser #slideshow div.last-active {z-index:9;}
.time-teaser .alarm {width:32rem; margin:0 auto; padding-top:5.25rem;}

.coming-section {background-color:#eaeaea;}

.time-ing .time-top {background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/bg_top3.jpg)no-repeat 50% 50%/100% 100%;}
.time-ing .time-top .sale-timer {padding-bottom:8.11rem;}
.time-ing .time-top h2, .time-ing .time-top .inner > p {width:69.87%; margin-left:8%;}
.time-ing .time-top h2:after {right:-1.3rem; animation:blink .8s infinite;}
.time-ing .time-top .inner > p {width:39.46%;}
.time-ing .time-items-on ul {width:32rem; margin:-4.48rem auto 0; padding-left:8%; padding-bottom:5.97rem;}
.time-ing .time-items-on ul li {width:29.44rem; margin-top:4.48rem;}
.time-ing .time-items-on ul li:first-child {margin-top:0;}
.time-ing .time-items-on .thumbnail {width:100%; height:21.33rem;}
.time-ing .time-items-on .thumbnail .label {position:absolute; bottom:-.73rem; right:0; z-index:10; height:2.39rem; padding:0 .98rem 0 1.62rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/bg_badge_blck2.png); background-repeat:no-repeat; background-size:100% 100%; background-position:0 50%; color:#fff; font-size:1.38rem; line-height:2.61rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.time-ing .time-items-on .special-item .label {width:7.985rem; height:2.39rem; padding:0; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_limited_badge2.png); text-indent:-999em;}
.time-ing .time-items-on .desc {margin-top:1.61rem;}
.time-ing .time-items-on .name {font-size:1.58rem;}
.time-ing .time-items-on .price {justify-content:flex-start; margin-top:1.29rem;}
.time-ing .time-items-on .price p {display:flex; flex-direction:column;}
.time-ing .time-items-on .price b {font-size:1.48rem;}
.time-ing .time-items-on .price em {font-size:2.13rem;}
.time-ing .time-items-on .price em span {font-size:1.28rem; font-weight:bold;}
.time-ing .time-items-on .price .sale {position:relative; margin-bottom:-.3rem; margin-right:0; margin-left:1.25rem; font-size:2.56rem;}
.time-ing .time-items-on .price .sale .cp-sale {font-size:2.4rem; color:#06b820;}
.time-ing .time-items-on .btn-get {width:16.85rem; height:3.84rem; margin-top:1.71rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_get.png)no-repeat 50% 50% / 100% 100%; text-indent:-999em;}
.time-ing .time-items-on .sold-out {position:relative;}
.time-ing .time-items-on .sold-out:after,
.time-ing .time-items-on .sold-out:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(255,255,255,.55); content:'';}
.time-ing .time-items-on .sold-out:before {width:9.4rem; height:9.43rem; top:5.97rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem; color:#fff; font-size:1.5rem; font-weight:bold;}
.lyr-alarm .input-box input {width:33%; height:3rem; padding:0; margin:0 .2rem; background-color:transparent; border:0; border-bottom:solid .17rem #00ff8a; border-radius:0; color:#cbcbcb; font-size:1.45rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; text-align:center;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; margin-left:.5rem; color:#00ff8a; font-size:1.45rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold;}
.lyr-end {padding-bottom:10rem;}
.lyr-end .txt-time {padding-top:6.83rem;}
.lyr-end .time-items li, .lyr-end .time-items .thumbnail {position:relative;}
.lyr-end .time-items li:before {display:inline-block; position:absolute; top:5.81rem; left:50%; z-index:20; width:5.26rem; height:auto; margin-left:-2.63rem; color:#fff; font-size:1.28rem; line-height:1.2; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; content:'순식간에 판매완료';}
.lyr-end .time-items .thumbnail:after {display:inline-block; position:absolute; top:0; left:0; z-index:5;width:100%; height:100%; background-color:rgba(0,0,0,.55); content:'';}
.lyr-end .time-items .name, .lyr-end .time-items .price {color:#c2c2c2}

.related-evt {background-color:#691feb;}
@keyframes blink {from, to {opacity:0;} 50% {opacity:1;}}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script>
    countDownTimer("<%=Year(currentTime)%>"
                    , "<%=TwoNumber(Month(currentTime))%>"
                    , "<%=TwoNumber(Day(currentTime))%>"
                    , "<%=TwoNumber(hour(currentTime))%>"
                    , "<%=TwoNumber(minute(currentTime))%>"
                    , "<%=TwoNumber(Second(currentTime))%>"
                    , new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>));

    function fnSendToKakaoMessage() {
        if ($("#phone1").val() == '') {
            alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
            $("#phone1").focus();
            return;
        }

        if ($("#phone2").val() == '') {
            alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
            $("#phone2").focus();
            return;
        }

        if ($("#phone3").val() == '') {
            alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
            $("#phone3").focus();
            return;
        }

        var phoneNumber = $("#phone1").val()+ "-" +$("#phone2").val()+ "-" +$("#phone3").val();

        $.ajax({
            type:"GET",
            url:"/event/timesale/timesale_proc.asp",
            data: "mode=kamsg&phoneNumber="+phoneNumber+"&sendCount=<%=fnGetSendCountToKakaoMassage(fnGetCurrentType(isAdmin,currentType))%><%=addParam%>",
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data);
                            if(result.response == "ok"){
                                $("#phone1").val('')
                                $("#phone2").val('')
                                $("#phone3").val('')
                                $(".lyr").fadeOut();
                                return false;
                            }else{
                                alert(result.faildesc);
                                return false;
                            }
                        } else {
                            alert("잘못된 접근 입니다.");
                            document.location.reload();
                            return false;
                        }
                    }
                }
            },
            error:function(jqXHR, textStatus, errorThrown){
                alert("잘못된 접근 입니다.");					
                return false;
            }
        });
    }

    //maxlength validation in input type number
    function maxLengthCheck(object){
        if (object.value.length > object.maxLength){
            object.value = object.value.slice(0, object.maxLength);
        }
    }

    var isStopped = false;
    function slideSwitch() {
        if (!isStopped) {
            var $active = $("#slideshow div.active");
            if ($active.length == 0) $active = $("#slideshow div:last");
            var $next = $active.next().length ? $active.next() : $("#slideshow div:first");

            $active.addClass("last-active");

            $next.css({
            }).addClass("active").animate({
                }, 0, function() {
                $active.removeClass("active last-active");
            });
        }
    }
    
    $(function() {
        setInterval(function() {
            slideSwitch();
        }, 800);

        $("#slideshow").hover(function() {
            isStopped = true;
        }, function() {
            isStopped = false;
        });

        // 알림받기 레이어
        $('.btn-alarm').click(function (e) {
            if($(this).hasClass('btn-alarm2')){
                e.preventDefault();
            } else {
                $('.lyr-alarm').fadeIn();
                //$("#phone1").focus();
            }
        });

        // 종료된 타임세일 상품 레이어
        $('.time-nav .end').click(function (e) {
            var index = $(this).index();

            posY = $(window).scrollTop();
            $('html, body').addClass('not-scroll');
            $('.lyr-end').fadeIn();
            $('.lyr-end').find('.time-items').eq(index).fadeIn();

            //$("body").css({overflow:'hidden'}).bind('touchmove', function(e){e.preventDefault()});
        });

        // 레이어 닫기
        $('.btn-close').click(function (e) {
            if($(this).parent().parent('.lyr').hasClass('lyr-end')){
                $('html,body').animate({scrollTop : posY}, 10);
            }
            $('html, body').removeClass('not-scroll');
            $('.lyr').fadeOut();
            $(this).find('.time-items').fadeOut();
            $('.lyr-end').find('.time-items').fadeOut();

           //$("body").css({overflow:'scroll'}).unbind('touchmove');
        });
    });

    function goDirOrdItem(itemid) {
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                parent.calllogin();
                return false;
            <% else %>
                parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
                $("#itemid").val(itemid);
                setTimeout(function() {
                    document.directOrd.submit();
                },300);        
        <% End IF %>
    }
</script>
<div class="mEvt98151 time-sale">
<% if isTeaser then %>
    <!-- #include virtual="/event/timesale/teaser.asp" -->
<% else %>
    <% if fnGetCurrentType(isAdmin,currentType) = "0" then '// 시작 직전 %>
        <!-- #include virtual="/event/timesale/itemsoon.asp" -->
    <% else %>
        <!-- #include virtual="/event/timesale/itemlist.asp" -->
    <% end if %>
        <div class="related-evt">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/tit_related_evt.png" alt="잠깐 찬스, 하나더 아니, 세개 더"></p>
            <ul>
                <li><a href="/event/eventmain.asp?eventid=97607" onclick="jsEventlinkURL(97607);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_related1.jpg?v=1.01" alt="텐바이텐은 처음이지?"></a></li>
                <li><a href="/event/eventmain.asp?eventid=97554" onclick="jsEventlinkURL(97554);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_related2.jpg?v=1.01" alt="믿고 사는 별 다섯개 후기"></a></li>
                <li><a href="/event/eventmain.asp?eventid=97582" onclick="jsEventlinkURL(97582);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_related3.jpg?v=1.01" alt="귀찮은건 딱 질색, 바로 최저가"></a></li>
            </ul>
        </div>
<% end if %>
    <%'!-- 타임세일 종료 --%>
    <div class="lyr lyr-end" style="display:none;">
        <div class="inner">
            <%'!-- for dev msg [time-nav] 의 탭 클릭시 해당 타임세일의 종료된 상품 노출 --%>
                <%'!-- 첫번째 타임세일(종료) --%>
                <div class="time-items" style="display:none;">
                    <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/tit_time2_1.png" alt="아침 8시 - 낮 12시"></p>
                    <ul>
                        <li class="special-item">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_spc_v2.png" alt=""></div>
                            <div class="desc">
                                <div class="name">스메그 전기포트 크림</div>
                                <div class="price"><p><b>177,000</b><em>29,900<span>원</span></em></p><i class="sale">83%</i></div>
                            </div>
                            <button class="btn-get"></button>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_1.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">일리 화이트 캡슐머신</div>
                                <div class="price"><p><b>179,000</b><em>143,300<span>원</span></em></p><i class="sale">20%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_2.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">추운날 담요로 따뜻하게</div>
                                <div class="price"><p><b>9,900~</b><em>9,400~<span>원</span></em></p><i class="sale">~62%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_3.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">JMW 드라이기</div>
                                <div class="price"><p><b>59,000~</b><em>34,900~<span>원</span></em></p><i class="sale">54%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_4.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">아이띵소 코트 & 가방</div>
                                <div class="price"><p><b>52,000~</b><em>32,760~<span>원</span></em></p><i class="sale">70%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item1_5.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">마크모크 단독 최저가</div>
                                <div class="price"><p><b>79,000~</b><em>33,900~<span>원</span></em></p><i class="sale">~58%</i></div>
                            </div>
                        </li>
                    </ul>
                </div>
                <%'!-- 두번째 타임세일(종료) --%>
                <div class="time-items" style="display:none;">
                    <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/tit_time2_2.png" alt="낮 12시 - 오후 4시 타임세일 상품"></p>
                    <ul>
                        <li class="special-item">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_spc_v2.png" alt=""></div>
                            <div class="desc">
                                <div class="name">±0 에코 히터 그레이제로 히터 그레이</div>
                                <div class="price"><p><b>169,000</b><em>9,900<span>원</span></em></p><i class="sale">94%</i></div>
                            </div>
                            <button class="btn-get"></button>
                        </li>
                        <li class="sold-out">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_1.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">디즈니 레터링 라인</div>
                                <div class="price"><p><b>8,500~</b><em>4,250~<span>원</span></em></p><i class="sale">50%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_2.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">에어프라이어는 보토</div>
                                <div class="price"><p><b>99,000</b><em>55,000<span>원</span></em></p><i class="sale">44%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_3.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">뷰랩 주얼리 기프트박스</div>
                                <div class="price"><p><b>9,900~</b><em>8,720~<span>원</span></em></p><i class="sale">~45%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_4.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">우리 아이 첫 의자!</div>
                                <div class="price"><p><b>179,000</b><em>104,310<span>원</span></em></p><i class="sale">35%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item2_5.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">가볍게 채우자!</div>
                                <div class="price"><p><b>800~</b><em>390~<span>원</span></em></p><i class="sale">~56%</i></div>
                            </div>
                        </li>
                    </ul>
                </div>
                <%'!-- 세번째 타임세일(종료) --%>
                <div class="time-items" style="display:none;">
                    <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/tit_time2_3.png" alt="오후 4시 - 저녁 8시 타임세일 상품"></p>
                    <ul>
                        <li class="special-item">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_spc_v2.png?v=1.02" alt=""></div>
                            <div class="desc">
                                <div class="name">갤럭시 버즈 블랙</div>
                                <div class="price"><p><b>159,500</b><em>59,900<span>원</span></em></p><i class="sale">62%</i></div>
                            </div>
                            <button class="btn-get"></button>
                        </li>
                        <li class="sold-out">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_1.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">디즈니 디지털 파우치</div>
                                <div class="price"><p><b>2,500~</b><em>1,750~<span>원</span></em></p><i class="sale">~50%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_2.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">국민브랜드 왕자행거</div>
                                <div class="price"><p><b>25,900~</b><em>20,900~<span>원</span></em></p><i class="sale">~48%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_3.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">비온뒤 스터디 모음</div>
                                <div class="price"><p><b>1,300~</b><em>650~<span>원</span></em></p><i class="sale">~50%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_4.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">비아리츠 겨울 양말</div>
                                <div class="price"><p><b>3000~</b><em>1,500~<span>원</span></em></p><i class="sale">~76%</i></div>
                            </div>
                        </li>
                        <li>
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/img_item3_5.jpg" alt=""></div>
                            <div class="desc">
                                <div class="name">하비풀 취미키트</div>
                                <div class="price"><p><b>19,500~</b><em>13,650~<span>원</span></em></p><i class="sale">~30%</i></div>
                            </div>
                        </li>
                    </ul>
                </div>
            <button class="btn-close"></button>
        </div>
    </div>

    <%'!-- 알람받기 레이어 --%>
    <div class="lyr lyr-alarm" style="display:none;">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_push.png" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
            <div class="input-box"><input type="number" id="phone1" placeholder="000" maxlength="3" oninput="maxLengthCheck(this)">-<input type="number" id="phone2" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">-<input type="number" id="phone3" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)"><button class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button></div>
            <button class="btn-close" onclikc="closeLyr();"></button>
        </div>
    </div>
</div>

<% if isapp then %>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<% else %>
<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO1">
</form>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
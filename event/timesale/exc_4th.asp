<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 릴레이 타임세일
' History : 2019-10-21 이종화 생성 - eventid = 98760
'              2019-12-10 4차 최종원 - eventid = 99312 
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/timesale/timesaleCls.asp" -->
<%
dim evtDate : evtDate = Cdate("2019-12-16") '// 이벤트일
dim isTeaser , isAdmin : isAdmin = false
dim currentType , currentTime
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt
dim isItem
dim totalPrice , salePercentString , couponPercentString , totalSalePercent

dim oTimeSale
set oTimeSale = new TimeSaleCls
    oTimeSale.Fepisode = 4
    oTimeSale.getTimeSaleItemLists

IF application("Svr_Info") = "Dev" THEN
	eCode = "90440"	
Else
	eCode = "99312"
End If

'// 티져 여부
if date() = Cdate(evtDate) then 
    isTeaser = false 
else 
    isTeaser = true 
end If 

'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" then
    if date() < Cdate(evtDate) then
        isTeaser = chkiif(requestCheckVar(request("isTeaser"),1) = "1" or requestCheckVar(request("isTeaser"),1) = "" , true , false) '// true 티져 / false 본 이벤트
        currentType = requestCheckVar(request("currentType"),1) '// 1.am8 , 2.pm12 , 3.pm4 , 4.pm12
        isAdmin = true
        addParam = "&isAdmin=1"
    end if
end if

'// setTimer
if isTeaser then 
    currentTime = evtDate '// 내일기준시간
else
    currentTime = fnGetCurrentTime(fnGetCurrentType(isAdmin,currentType))
end if 

' response.write isTeaser &"<br/>"
' response.write fnGetCurrentType(isAdmin,currentType) &"<br/>"
' response.write fnGetSendCountToKakaoMassage(fnGetCurrentType(isAdmin,currentType)) &"<br/>"

'function fnGetItemName(roundNumber , sortNumber)
'    dim itemNameGroups1 , itemNameGroups2 , itemNameGroups3 , itemNameGroups4
'        itemNameGroups1 = Array("라인프렌즈 프로젝터", "세상 예쁜 모슈 단독 최저가", "공복을 위한 아침 특가", "겨울철 사무실 필수템", "아이패드&sol;노트북 파우치", "딱 4시간! JMW 특가", "잘 빠진 문구, 툴스투리브바이", "철가루 방지 스티커 특가")
'        itemNameGroups2 = Array("갤럭시 버즈 화이트", "크리스마스 단독 최저가" , "겨울맞이 베베데코 특가" , "EUP 무선청소기", "수납 끝판왕 추천 특가", "변하지 않는 가치의 향" , "선물주기 딱 좋은! 귀걸이 세트", "키드크래프트 5종 특가")
'        itemNameGroups3 = Array("내셔널지오그래픽 롱패딩 (95)" , "묻고 디즈니특가로 가!" , "2020 다이어리&sol;달력", "뜨개질 DIY 키트 특가" , "청소는 미리빨,7종 특가" , "화제의 지누스 매트리스" , "락피쉬 신상품 단 4시간 타임특가!" , "강아지 건강관리 특가")
'        itemNameGroups4 = Array("에어팟 프로" , "신상 명품 가방&sol;지갑 타임특가" , "크리스마스 무드등 특가" , "스누피 와플메이커" , "묻고 디즈니특가로 가!" , "11월 산타 울리 특가" , "곤약젤리 최저가 무배" , "&lsqb;무배&rsqb; 리버시블 곰깔깔이 양털후리스")
'
'        SELECT CASE roundNumber
'            CASE 1
'                fnGetItemName = itemNameGroups1(sortNumber-1)
'            CASE 2
'                fnGetItemName = itemNameGroups2(sortNumber-1)
'            CASE 3
'                fnGetItemName = itemNameGroups3(sortNumber-1)
'            CASE 4
'                fnGetItemName = itemNameGroups4(sortNumber-1)
'            CASE ELSE
'                fnGetItemName = ""
'        END SELECT
'end function
%>
<style type="text/css">
.not-scroll{position:fixed; overflow:hidden; width:100%; height:auto;}

.time-sale {position:relative; background:#fff;}
.time-sale button {background-color:transparent !important;}
.time-sale .inner {width:32rem; margin:0 auto;}

.sale-timer {padding-top:3.41rem; padding-bottom:3.41rem; padding-left:8%; font-size:5.14rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.sale-timer p {margin-bottom:1.28rem; font-size:2.43rem;}
.btn-alarm {width:32rem; height:4.27rem; margin-top:1.71rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/btn_alarm.png) no-repeat 50% 0/100%; text-indent:-999em;}
.btn-alarm2 {display:inline-block; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/btn_alarm2.png)}

.time-top {position:relative; padding-top:3.5rem; background:#f13421 url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/bg_top.jpg) no-repeat 50% 50%/100% 100%;}
.time-top h2 {position:relative;}
.time-top h2:after {display:inline-block; position:absolute; top:2.35rem; right:6.06rem; width:.64rem; height:.64rem; background-color:#00fffc; border-radius:50%; content:'';}
.time-top p {padding-top:11.31rem;}
.time-top .sale-timer {padding-top:1.08rem; padding-bottom:4.91rem; color:#fff;}

.time-nav {display:flex; justify-content:space-between; position:absolute; top:11.95rem; right:-.85rem; width:20.15rem;}
.time-nav .time {width:4.69rem; height:4.8rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time1_1.png); background-repeat:no-repeat; background-position:0 0; background-size:4.69rem 18.35rem; text-indent:-999em;}
.time-nav .time2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time1_2.png);}
.time-nav .time3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time1_3.png);}
.time-nav .time4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time1_4.png);}
.time-nav .time.on {background-position:0 -6.83rem;}
.time-nav .time.end {margin:0 .3rem; background-position:0 100%;}

.alarm {padding:3.2rem 0 3.84rem;}
.alarm .time-nav {position:unset; top:unset; right:unset; margin:2.56rem 0 5.12rem 6%;}
.alarm .time-nav .time {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time2_1.png);}
.alarm .time-nav .time2 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time2_2.png);}
.alarm .time-nav .time3 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time2_3.png);}
.alarm .time-nav .time4 {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_time2_4.png);}

.time-sale .desc {padding-left:.43rem; margin-top:1.22rem;}
.time-sale .name {font-size:1.28rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.time-sale .price {display:flex; justify-content:flex-end; align-items:flex-end; margin-top:.6rem; font-size:1.15rem;}
.time-sale .price p {width:100%;}
.time-sale .price p b {display:inline-block; width:100%; margin-bottom:.33rem; color:#888; text-decoration:line-through;}
.time-sale .price em {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.54rem; letter-spacing:-.08rem;}
.time-sale .price em span {display:inline-block; margin-left:.2rem; font-size:1.2rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-weight:normal;}
.time-sale .price .sale {display:inline-block; margin-right:.8rem; margin-bottom:-.3rem; color:#ff3823; font-size:1.8rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}

.time-items .txt-time {margin-bottom:1.15rem;}
.time-items ul {display:flex; justify-content:space-between; flex-wrap:wrap; padding:0 0 4.91rem 8%;}
.time-items ul li {flex-basis:14.51rem; margin-top:2.56rem;}
.time-items .thumbnail {position:relative; width:14.51rem; height:14.51rem;}
.time-items .thumbnail img, .time-items-on .thumbnail img {width:100%; height:100%;}
.thumbnail .label-box {position:absolute; bottom:-.6rem; left:.43rem; z-index:10;}
.thumbnail .label {display:inline-block; height:1.59rem; padding:0 .8rem; background-color:#222;color:#fff; font-size:1.02rem; line-height:1.8rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; border-radius:.84rem;}
.thumbnail .cp {background-color:#00a436;}
.special-item .thumbnail .label {background-color:#ff3823;}

.time-teaser {padding-bottom:10rem;}
.time-teaser .time-top {padding-top:0;}
.time-teaser .time-top h2:after {display:none;}
.time-teaser .slideshow {position:absolute; top:23.43%; right:12.8%; width:9.1%;}
.time-teaser #slideshow div {position:absolute; top:0; left:0; z-index:8; width:100%; opacity:0.0;}
.time-teaser #slideshow div.active {z-index:10; opacity:1.0;}
.time-teaser #slideshow div.last-active {z-index:9;}
.time-teaser .alarm {width:32rem; margin:0 auto; padding-top:5.25rem;}

.coming-section {background-color:#eaeaea;}

.time-ing .time-top .sale-timer {padding-bottom:8.11rem;}
.time-ing .time-top h2:after {animation:blink .8s infinite;}
.time-ing .time-items-on ul {display:flex; justify-content:flex-end; flex-wrap:wrap; width:32rem; margin-top:-4.48rem; margin-left:auto; padding-bottom:5.97rem;}
.time-ing .time-items-on ul li {flex-basis:29.44rem; margin-top:4.48rem;}
.time-ing .time-items-on ul li:first-child {margin-top:0;}
.time-ing .time-items-on .thumbnail {width:100%; height:29.44rem;}
.time-ing .time-items-on .thumbnail .label {height:2.14rem; padding:0 1.5rem; font-size:1.28rem; line-height:2.39rem; border-radius:1.28rem;}
.time-ing .time-items-on .desc {margin-top:2.38rem;}
.time-ing .time-items-on .name {font-size:1.58rem;}
.time-ing .time-items-on .price {justify-content:flex-start; margin-top:.7rem;}
.time-ing .time-items-on .price b {display:inline-block; margin-right:.5rem; margin-bottom:0; width:auto; font-size:1.48rem;}
.time-ing .time-items-on .price em {font-size:2.13rem;}
.time-ing .time-items-on .price em span {font-size:1.28rem; font-weight:bold;}
.time-ing .time-items-on .price .sale {margin-left:1.71rem; font-size:2.57rem;}
.time-ing .time-items-on .price .sale .cp-sale {font-size:2.4rem; color:#06b820;}
.time-ing .time-items-on .btn-get {width:16.85rem; height:3.84rem; margin-top:1.71rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_get.png)no-repeat 50% 50% / 100% 100%; text-indent:-999em;}
.time-ing .time-items-on .sold-out {position:relative;}
.time-ing .time-items-on .sold-out:after,
.time-ing .time-items-on .sold-out:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(255,255,255,.55); content:'';}
.time-ing .time-items-on .sold-out:before {width:9.4rem; height:9.43rem; top:9.97rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}
.time-ing .time-items-on .rcmd-evt .desc {display:flex; align-items:center;}
.time-ing .time-items-on .rcmd-evt .price {margin-top:0;}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}

.lyr-fair .inner {position:relative;}
.lyr-fair p {padding-top:7.98rem;}
.lyr-fair .input-box1, .lyr-fair .input-box2, .lyr-fair .input-box3, .lyr-fair .input-box4, .lyr-fair .btn-get1, .lyr-fair .btn-get2, .lyr-fair .btn-get3, .lyr-fair .btn-get4 {position:absolute; top:0; left:0;}
.lyr-fair #notRobot1, .lyr-fair #notRobot2, .lyr-fair #notRobot3, .lyr-fair #notRobot4 {display:none;} .lyr-fair #notRobot1 + label, .lyr-fair #notRobot2 + label, .lyr-fair #notRobot3 + label, .lyr-fair #notRobot4 + label {display:inline-block; position:relative; width:17.45rem; height:2.86rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_chck.png); background-repeat:no-repeat; background-size:100% 100%;}
.lyr-fair #notRobot1:checked + label, .lyr-fair #notRobot2:checked + label, .lyr-fair #notRobot3:checked + label, .lyr-fair #notRobot4:checked + label {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_chck_on.png);}
.lyr-fair .btn-get1, .lyr-fair .btn-get2, .lyr-fair .btn-get3, .lyr-fair .btn-get4 {width:26.53%;}

.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem; color:#00c6ff; font-size:1.5rem; font-weight:bold;}
.lyr-alarm .input-box input {width:33%; height:3rem; padding:0; margin:0 .2rem; background-color:transparent; border:0; border-bottom:solid .17rem #00fffc; border-radius:0; color:#cbcbcb; font-size:1.45rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; margin-left:.5rem; color:#00c6ff; font-size:1.45rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}

.lyr-end {padding-bottom:10rem;}
.lyr-end .txt-time {padding-top:6.83rem;}
.lyr-end .time-items li, .lyr-end .time-items .thumbnail {position:relative;}
.lyr-end .time-items li:before {display:inline-block; position:absolute; top:5.81rem; left:50%; z-index:20; width:5.26rem; height:auto; margin-left:-2.63rem; color:#fff; font-size:1.28rem; line-height:1.2; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; content:'순식간에 판매완료';}
.lyr-end .time-items .thumbnail:after {display:inline-block; position:absolute; top:0; left:0; z-index:5;width:100%; height:100%; background-color:rgba(0,0,0,.55); content:'';}
.lyr-end .time-items .name, .lyr-end .time-items .price {color:#c2c2c2}
.lyr-end .time-items .thumbnail .label-box {display:none;}

.related-evt {background-color:#16c4d8;}
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
            data: "mode=kamsg&phoneNumber="+btoa(phoneNumber)+"&sendCount=<%=fnGetSendCountToKakaoMassage(fnGetCurrentType(isAdmin,currentType))%><%=addParam%>",
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data);
                            if(result.response == "ok"){
                                alert('알림 신청이 완료되었습니다.');
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

        $('.time-items-on ul .special-item').append('<button class="btn-get">구매하기</button>');
        $(".time-items ul li:nth-child(1), .time-items-on ul li:nth-child(1)").addClass('special-item');
        $('.time-items ul li:nth-child(9),.time-items-on ul li:nth-child(9),.time-items ul li:nth-child(12),.time-items-on ul li:nth-child(12)').addClass('rcmd-evt');
        //  페어플레이 레이어
        $('.time-items-on .special-item').click(function (e) {
            if ($(this).hasClass("sold-out")) {
                return false;
            }
            var str = $.ajax({
                type: "GET",
                url: "/event/timesale/timesale_proc.asp",
                data: "mode=fair&sendCount=<%=fnGetCurrentType(isAdmin,currentType)%><%=addParam%>",
                dataType: "text",
                async:false,
                cache:true,
            }).responseText;

            if(str!="") {
                $("#fairplay").empty().html(str);
                $('#mask-time').css({'background-color':'rgba(255,255,255,.9);'});
                $("#mask-time").show();
                $('.lyr-fair').fadeIn();
                // catchPos();
            }
        });

        // 알림받기 레이어
        $('.btn-alarm').click(function (e) {
            if($(this).hasClass('btn-alarm2')){
                e.preventDefault();
            } else {
                $('.lyr-alarm').fadeIn();
            }
        });

        // 종료된 타임세일 상품 레이어
        $('.time-nav .end').click(function (e) {
            var index = $(this).index();

            posY = $(window).scrollTop();
            $('html, body').addClass('not-scroll');
            $('.lyr-end').fadeIn();
            $('.lyr-end').find('.time-items').eq(index).fadeIn();
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
        });

        $("#mask-time").click(function(){
            $(".lyr").fadeOut();
            $(this).find('.time-items').fadeOut();
            $('.lyr-end').find('.time-items').fadeOut();
            $("#mask-time").fadeOut();
            $('html,body').removeClass('not-scroll');
            $('html,body').animate({scrollTop:posY}, 10);
        });
    });

    function fnBtnClose(e) {
        $("#mask-time").fadeOut();
        $('.lyr').fadeOut();
        $(this).find('.time-items').fadeOut();
        $('.lyr-end').find('.time-items').fadeOut();
        $('html,body').removeClass('not-scroll');
        // $('html,body').animate({scrollTop:posY}, 10);
    }

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
                if (!document.getElementById("notRobot4").checked) {
                    alert("'나는 BOT이 아닙니다.'를 체크해주세요.");
                    return false;
                }

                $.ajax({
                    type:"GET",
                    url:"/event/timesale/timesale_proc.asp",
                    data: "mode=order&sendCount=<%=fnGetCurrentType(isAdmin,currentType)%><%=addParam%>",
                    dataType: "text",
                    async:false,
                    cache:true,
                    success : function(Data, textStatus, jqXHR){                        
                        if (jqXHR.readyState == 4) {
                            if (jqXHR.status == 200) {
                                if(Data!="") {
                                    var result = JSON.parse(Data);
                                    if(result.response == "ok"){
                                        fnAmplitudeEventMultiPropertiesAction('click_timesale_item','idx|itemid','1|'+result.message)
                                        $("#itemid").val(result.message);
                                        setTimeout(function() {
                                            document.directOrd.submit();
                                        },300);
                                        return false;
                                    }else{
                                        console.log(result.faildesc);
                                        return false;
                                    }
                                } else {
                                    alert("잘못된 접근 입니다.1");
                                    document.location.reload();
                                    return false;
                                }
                            }
                        }
                    },
                    error:function(jqXHR, textStatus, errorThrown){
                        console.log("접근 실패!");
                        return false;
                    }
                });   
        <% End IF %>
    }
</script>
<div class="mEvt98760 time-sale">
<% if isTeaser then %>
    <!-- #include virtual="/event/timesale/teaser.asp" -->
<% else %>
    <% if fnGetCurrentType(isAdmin,currentType) = "0" then '// 시작 직전 %>
        <!-- #include virtual="/event/timesale/itemsoon.asp" -->
    <% else %>
        <!-- #include virtual="/event/timesale/itemlist.asp" -->
    <% end if %>
<% end if %>
    <%'!-- 페어플레이 레이어 --%>
    <div class="lyr lyr-fair" id="fairplay" style="display:none;"></div>
    <%'!-- 타임세일 종료 --%>
    <div class="lyr lyr-end" style="display:none;">
        <div class="inner">
            <%'!-- for dev msg [time-nav] 의 탭 클릭시 해당 타임세일의 종료된 상품 노출 --%>
                <%'!-- 타임세일(종료) --%>
                <%
                    FOR loopInt = 0 TO oTimeSale.FResultCount - 1
                        isItem = oTimeSale.FitemList(loopInt).FcontentType = 1 '콘텐츠 구분 추가
                        if isItem then
                            call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                            call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                        end if

                        IF oTimeSale.FitemList(loopInt).Fsortnumber = 1 THEN
                %>
                <div class="time-items" style="display:none;">
                    <p class="txt-time"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/tit_time2_<%=oTimeSale.FitemList(loopInt).Fround%>.png" alt="<%=oTimeSale.FitemList(loopInt).Fround%>회 세일"></p>
                    <ul>
                <%
                        END IF
                %>
                        <li>
                            <div class="thumbnail">
                                <img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="">
                                <div class="label-box">
                                    <span class="label">한정판매</span><%'갯수 노출 안함%>
                                </div>
                            </div>
                            <div class="desc">
                                <div class="name"><%=oTimeSale.FitemList(loopInt).FcontentName%></div>
                                <div class="price">
                                    <p style="display:<%=chkiif(isItem, "","none") %>">
                                    <% IF oTimeSale.FitemList(loopInt).Fitemdiv <> "21" THEN %>
                                        <b><%=formatnumber(oTimeSale.FitemList(loopInt).Forgprice,0)%></b>
                                    <% END IF %>
                                    <em><%=chkiif(oTimeSale.FitemList(loopInt).Fitemdiv = "21",formatnumber(oTimeSale.FitemList(loopInt).FmasterSellCash,0)&"~",totalPrice)%><span>원</span></em>
                                    </p>
                                <% if isItem then %>                      
                                    <% IF oTimeSale.FitemList(loopInt).Fitemdiv = "21" THEN %>
                                        <% IF oTimeSale.FitemList(loopInt).FmasterDiscountRate > 0 THEN %><i class="sale">~<%=oTimeSale.FitemList(loopInt).FmasterDiscountRate%>%</i><% end if %>
                                    <% ELSE %>
                                        <% if totalSalePercent <> "0" then %><i class="sale"><%=totalSalePercent%></i><% end if %>
                                    <% END IF %>
                                <% else %>
                                        <%if oTimeSale.FitemList(loopInt).FevtSale <> 0 then%><i class="sale">~<%=oTimeSale.FitemList(loopInt).FevtSale%>%</i><%end if%>
                                <% end if %>             
                                </div>
                            </div>
                        </li>
                <%
                    IF oTimeSale.FitemList(loopInt).Fsortnumber = 12 THEN
                %>        
                    </ul>
                </div>
            <%
                    END IF
                NEXT
            %>   
            <button class="btn-close"></button>
        </div>
    </div>

    <%'!-- 알람받기 레이어 --%>
    <div class="lyr lyr-alarm" style="display:none;">
        <div class="inner">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/txt_push.png" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
            <div class="input-box"><input type="number" id="phone1" placeholder="000" maxlength="3" oninput="maxLengthCheck(this)">-<input type="number" id="phone2" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">-<input type="number" id="phone3" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)"><button class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button></div>
            <button class="btn-close" onclikc="closeLyr();"></button>
        </div>
    </div>

    <div class="related-evt">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/tit_related_evt.png" alt="잠깐 찬스, 하나더 아니, 세개 더"></p>
        	<ul>
            <% if isapp then %>
				<li><a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','1|cirsmas', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas/');}});return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related1.jpg" alt="지금부터 준비하세요! 크리스마스 소품의 모든 것"></a></li>
                <li><a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','2|99242', function(bool){if(bool) {fnAPPpopupEvent(99242);}});return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related2.jpg" alt="지금 텐바이텐에서  가장 인기 많은 BEST 20"></a></li>
                <li><a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','3|99222', function(bool){if(bool) {fnAPPpopupEvent(99222);}});return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related3.jpg" alt="텐바이텐이 처음이세요? 그럼 이 상품 꼭! 추천합니다."></a></li>            
            <% else %>
				<li><a href="/christmas/" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','1|cirsmas')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related1.jpg" alt="지금부터 준비하세요! 크리스마스 소품의 모든 것"></a></li>
                <li><a href="/event/eventmain.asp?eventid=99242" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','2|99242')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related2.jpg" alt="지금 텐바이텐에서  가장 인기 많은 BEST 20"></a></li>
                <li><a href="/event/eventmain.asp?eventid=99222" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_bnr','idx|evtcode','3|99222')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99312/m/img_related3.jpg" alt="텐바이텐이 처음이세요? 그럼 이 상품 꼭! 추천합니다."></a></li>            
            <% end if %>
            </ul>
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
<%
    set oTimeSale = nothing    
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 타임세일
' History : 2020-07-14 원승현 생성 - eventid = 104371
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
dim evtDate '// 이벤트 일자
dim isTeaser '// 티져 여부(이벤트 시작전 오픈일경우)
dim isAdmin : isAdmin = false '// 관리자 여부
dim currentType '// 1이면 18시 이후 실제 진행상황, 0이면 18시 이전 준비 단계
dim currentTime '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt
dim isItem, currentDate
dim totalPrice , salePercentString , couponPercentString , totalSalePercent
dim oTimeSale , isSoldOut , RemainCount
dim episode '// 일자별 회차로 보면 될듯..

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "102196"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "104371"
    mktTest = true    
Else
	eCode = "104371"
    mktTest = false
End If

'// 해당 아이디들은 테스트 할때 mktTest값을 true로 강제로 적용하여 테스트
'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
    'mktTest = true
end if

if mktTest then
    '// 테스트용
    'currentDate = CDate("2020-07-21 18:00:00")
    'currentTime = Cdate("18:00:00")
    '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()        
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()    
end if

'// 각 일자별 타임세일 진행여부를 episode로 정함
If currentDate >= #07/20/2020 00:00:00# and currentDate < #07/21/2020 00:00:00# Then
    '// 2020년 7월 20일 진행
    episode=1
elseIf currentDate >= #07/21/2020 00:00:00# and currentDate < #07/22/2020 00:00:00# Then
    '// 2020년 7월 21일 진행
    episode=2
elseIf currentDate >= #07/22/2020 00:00:00# and currentDate < #07/23/2020 00:00:00# Then
    '// 2020년 7월 22일 진행
    episode=3
elseIf currentDate >= #07/23/2020 00:00:00# and currentDate < #07/24/2020 00:00:00# Then
    '// 2020년 7월 23일 진행
    episode=4
else
    '// 그 외에는 티져로 인식
    episode=0
    evtDate = ""
end if

'// episode값이 0보다 크면 타임 세일 진행 일자라는 뜻
If episode > 0 Then
    If currentTime >= #00:00:00# and currentTime < #18:00:00# Then
        currentType = 0
    Else
        '// 실제 진행할때에만 해당 값이 1로 됨
        currentType = 1
    End If
    '// 타임세일 진행 기간이면 티져 페이지는 보여주지 않음
    isTeaser = false
Else
    '// 타임 세일 진행일자 외엔 티져 페이지 노출
    isTeaser = true
    currentType = 0
End If

'// episode와 이벤트 코드로 타임 세일 진행 상품 불러옴
set oTimeSale = new TimeSaleCls
    oTimeSale.Fepisode = episode
    oTimeSale.FRectEvtCode = eCode
    oTimeSale.getTimeSaleItemLists

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

'// 시간설정
select case Trim(cStr(currentType))
    case "0" 
        evtDate = DateAdd("h",18,left(currentDate, 10))
    case "1"
        evtDate = DateAdd("h",24,left(currentDate, 10))
    case else
        evtDate = DateAdd("d",1,left(currentDate, 10))
end select 

'fnGetCurrentSingleTime(fnGetCurrentSingleType(isAdmin,currentType))

%>
<style type="text/css">
.teaser {position:relative;}
.teaser .btn-more {display:block; width:100%; background-color:rgba(0,0,10,0.5);}
.teaser .list-wrap a {position:relative; display:inline-block; width:100%; height:100%;}

.time-sale {background-color:#fff;}
.time-sale button {background-color:transparent;}
.time-sale .top {position:relative; margin-bottom:1.49rem; background-color:#2f08c2;}
.time-sale .sale-timer {position:absolute; bottom:13.96%; left:5.3%; color:#54ff00; font-size:4.91rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.time-sale .btn-push {display:inline-block; position:fixed; top:116vw; right:0; z-index:10; width:25.3%;}
.time-sale .sns {position:relative; margin-top:0.5rem;}
.time-sale .sns .btn-sns {display:inline-block; width:17%; height:100%; position:absolute; top:0; right:24%; text-indent:-999em;}
.time-sale .sns .btn-sns.insta {right:5.4%}
.time-sale .lineup {background-color:#430ce7;}
.time-sale .lineup .btn-lineup {position:relative;}
.time-sale .lineup .btn-lineup:after {position:absolute; top:50%; right:24%; width:1.32rem; height:0.81rem; margin-top:-0.38rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104371/m/ico_chevron.png) 50% 50%/100%; content:'';}
.time-sale .lineup.on .btn-lineup:after {transform:rotate(180deg);}
.time-sale .noti {position:relative;}
.time-sale .noti a {display:block; position:absolute; top:64%; right:23.3%; width:30%; height:8%; text-indent:-999em;}

.list-wrap {width:32rem; margin:0 auto;}
.list-wrap .special-item a {display:inline-block; position:relative;}
.list-wrap .special-item a:before, .teaser .list-wrap a:before {display:inline-block; position:absolute; top:-1.1vw; left:0; z-index:10; width:26%; height:9.84vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/104371/m/badge_spc.png) no-repeat 50% 50%/100%; content:'';}
.list-wrap .special-item.sold-out {position:relative;}
.list-wrap .special-item.sold-out:after,
.list-wrap .special-item.sold-out:before {display:inline-block; position:absolute; top:-1.1vw; left:0; z-index:10; width:100%; height:calc(100% + 1.1vw); background-color:rgba(255,255,255,.55); content:'';}
.list-wrap .special-item.sold-out:before {width:9.4rem; height:9.43rem; top:10.97rem; left:50%; z-index:20; margin-left:-3.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}

.list-wrap #itemList {margin-left:5.3%;}
.list-wrap .desc {margin-top:1.45rem; margin-bottom:3.33rem;}
.list-wrap .thumbnail {position:relative; min-width:30.29rem; min-height:30.29rem;}
.list-wrap .thumbnail:after {position:absolute; bottom:0; right:0; z-index:10; width:36.61%; height:9.15%; background-color:#222; color:#fff; font-size:1.37rem; line-height:3.13rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center; border-radius:1.71rem 0 0 0; content:'한정 수량';}
.list-wrap .desc .name {overflow:hidden; font-size:1.96rem; line-height:1.2; color:#111; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; white-space:nowrap; text-overflow:ellipsis;}
.list-wrap .desc .price {margin-top:.8rem; font-size:2.13rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.list-wrap .desc .price s {font-size:1.49rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.list-wrap .desc .price span {display:inline-block; margin-left:1.1rem; font-size:2.56rem; color:#ff3823}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:absolute; top:2.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem; color:#00ff8a; font-size:1.5rem; font-weight:bold;}
.lyr-alarm .input-box input {width:33%; height:3rem; padding:0; margin:0 .2rem; background-color:transparent; border:0; border-bottom:solid .17rem #00ff8a; border-radius:0; color:#cbcbcb; font-size:1.45rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; text-align:center;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; margin-left:.5rem; color:#00ff8a; font-size:1.45rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold;}
.lyr-fair .inner {position:relative;}
.lyr-fair p {padding-top:25vw;}
.lyr-fair .input-box1, .lyr-fair .input-box2, .lyr-fair .input-box3, .lyr-fair .input-box4, .lyr-fair .btn-get1, .lyr-fair .btn-get2, .lyr-fair .btn-get3, .lyr-fair .btn-get4 {position:absolute; top:0; left:0;}
.lyr-fair .input-box {display:inline-block; width:54.5%;}
.lyr-fair #notRobot1, .lyr-fair #notRobot2, .lyr-fair #notRobot3, .lyr-fair #notRobot4 {display:none;}
.lyr-fair #notRobot1 + label, .lyr-fair #notRobot2 + label, .lyr-fair #notRobot3 + label, .lyr-fair #notRobot4 + label {display:inline-block; position:relative; width:17.45rem; height:2.86rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98760/m/txt_chck.png?v=1.02); background-repeat:no-repeat; background-size:100% 100%;}
.lyr-fair #notRobot1:checked + label, .lyr-fair #notRobot2:checked + label, .lyr-fair #notRobot3:checked + label,
.lyr-fair #notRobot4:checked + label {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98760/m/txt_chck_on.png?v=1.01);}
.lyr-fair .btn-get1, .lyr-fair .btn-get2, .lyr-fair .btn-get3, .lyr-fair .btn-get4 {width:26.53%;}
.lyr-fair .noti2 {margin-top:70vw;}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_TimeSale.js?v=1.0"></script>
<script>
    countDownTimer("<%=Year(evtDate)%>"
                    , "<%=TwoNumber(Month(evtDate))%>"
                    , "<%=TwoNumber(Day(evtDate))%>"
                    , "<%=TwoNumber(hour(evtDate))%>"
                    , "<%=TwoNumber(minute(evtDate))%>"
                    , "<%=TwoNumber(Second(evtDate))%>"
                    , new Date(<%=Year(currentDate)%>, <%=Month(currentDate)-1%>, <%=Day(currentDate)%>, <%=Hour(currentDate)%>, <%=Minute(currentDate)%>, <%=Second(currentDate)%>)
                    );

    $(function() {
        //  페어플레이 레이어
        $('.list-wrap .special-item').click(function (e) {
            <% if currentType > 0 then %>
                if ($(this).hasClass("sold-out")) {
                    return false;
                }
                var str = $.ajax({
                    type: "GET",
                    url: "/event/timesale/timesale_proc.asp",
                    data: "mode=fair&selectnumber="+$(this).index(),
                    dataType: "text",
                    async:false,
                    cache:true,
                }).responseText;

                if(str!="") {
                    $("#fairplay").empty().html(str);
                    $('.lyr-fair').fadeIn();
                    e.preventDefault();
                }
            <% else %>
                alert("아직 이벤트가 오픈되지 않았습니다. 오후 6시를 기다려주세요");
            <% end if %>
        });
        
        // 레이어 닫기
        $('.btn-close').click(function (e) {
            $('html, body').removeClass('not-scroll');
            $('.lyr').fadeOut();
            $(this).find('.list-wrap').hide();
        });

        // 알림받기 레이어
        $('.btn-push').click(function (e) { 
            $('.lyr-alarm').fadeIn();
        });

        // 라인업 버튼
        $('.lineup .btn-lineup').click(function (e) { 
            $('.lineup').toggleClass("on");
            $('.lineup .list').slideToggle();
        });

        // 티저 얼럿 메세지
        $('.teaser .list-wrap a').click(function (e) { 
            e.preventDefault();
            if($(this).parents('.teaser').hasClass('teaser1')){
                alert("7월 20일 6:00pm에 오픈됩니다. 오픈 시간을 기다려주세요!");
            } else {
                alert("아직 이벤트가 오픈되지 않았습니다. 오후 6시를 기다려주세요");
            }
        });
        $('.teaser .btn-more').click(function (e) { 
            e.preventDefault();
            alert("나머지 상품은 오픈 후 공개 됩니다! 오픈 시간을 기다려주세요.");
        });

        <%'// MD상품 리스트 %>
        <% If episode > 0 Then %>
            var itemlistIdx = <%=episode%>
            switch (itemlistIdx) {
                case 1 :
                    codeGrp = [2662083,2793715,2426462,2159321,2570064,2844462,1726011,2354597,3016078,2835624,2974512,2941107,3010307,2255258,2621359,2792013,2889254,2890680,3008914,3008912]; <%'// 7/20 %>
                    break;
                case 2 :
                    codeGrp = [2445377,2896860,2919097,2710050,2964071,2904884,2895391,2452429,2722020,3020518,2676306,1733816,2779903,2974740,2472003,1820720,2801349,2889417];  <%'// 7/21 %>
                    break;
                case 3 :
                    codeGrp = [2849183,2878137,2858312,2824115,2798708,2901865,2820372,2788196,1919972,2543540,2741840,2974762,3000411,2897202,2968064,1883102,2916254,2368817,3008916,3008913];  <%'// 7/22 %>
                    break;
                case 4 :
                    codeGrp = [2784157,2543514,2760012,2932964,2004990,2704524,2023886,2900539,2872770,2863783,2698702,2792111,2993727,2878584,2537963,2501860,2863851,2231172];  <%'// 7/23 %>
                    break;
            }
            var $rootEl = $("#itemList")
            var itemEle = tmpEl = ""
            $rootEl.empty();

            codeGrp.forEach(function(item){
                tmpEl = '<li>\
                            <a href="" onclick="goProduct('+item+');return false;">\
                                <div class="thumbnail"><img src="" alt=""></div>\
                                <div class="desc">\
                                    <p class="name"></p>\
                                    <div class="price"><s></s> <span class="sale"></span></div>\
                                </div>\
                            </a>\
                        </li>\
                        '
                itemEle += tmpEl
            });
            $rootEl.append(itemEle)

            fnApplyItemInfoList({
                items:codeGrp,
                target:"itemList",
                fields:["image","name","price","sale"],
                unit:"none",
                saleBracket:false
            });
        <% End If %>
    });

    <%' // 상품 링크 이동 (개발파일에서 주석 풀고 적용 부탁드립니다.) %>
    function goProduct(itemid) {
        <% if isApp then %>
            parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
        <% else %>
            parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
        <% end if %>
        return false;
    }

function fnBtnClose(e) {
        $('.lyr').fadeOut();
        $(this).find('.list-wrap').fadeOut();
    }

    //maxlength validation in input type number
    function maxLengthCheck(object){
        if (object.value.length > object.maxLength){
            object.value = object.value.slice(0, object.maxLength);
        }
    }

    function fnSendToKakaoMessage() {
        <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
        <% If (left(currentdate, 10) < "2020-07-19" Or left(currentdate, 10) > "2020-07-23") Then %> 
            alert("이벤트 기간에만 신청하실 수 있습니다.");
            return false;
        <% End If %>

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
            data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data);
                            if(result.response == "ok"){
                                alert('신청이 완료되었습니다.');
                                $("#phone").val('')
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

    function goDirOrdItem(n) {
        <% If Not(IsUserLoginOK) Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
                if (!document.getElementById("notRobot<%=episode%>").checked) {
                    alert("'나는 BOT이 아닙니다.'를 체크해주세요.");
                    return false;
                }

                $.ajax({
                    type:"GET",
                    url:"/event/timesale/timesale_proc.asp",
                    data: "mode=order&selectnumber="+n,
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
<% '//<!-- 104371 타임세일 --> %>
<div class="mEvt104371 time-sale">
    <% If isTeaser Then %>
        <% '<!-- 7/19 티저 --> %>
        <div class="teaser teaser1">
            <div class="top"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/tit_teaser1.jpg" alt="타임세일 티저"></div>
            <div class="list-wrap">
                <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item1_1.jpg" alt="에어팟 프로"></a>
                <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item1_2.jpg" alt="닌텐도 + 동물의 숲"></a>
                <button class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/btn_more.jpg" alt="그리고 시크릿 18개의 상품"></button>
            </div>
        </div>
    <% Else %>
        <% If currentType > 0 Then %>
            <div class="time-ing">
                <div class="top">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/tit_timesale.jpg" alt="타임세일">
                    <div class="sale-timer">
                        <div><span>-</span><span id="countdown">00:00:00</span></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/txt_noti3_v2.png" alt="라인업 상품의 경우, 무통장 결제가 불가합니다."></div>
                </div>
                <div class="list-wrap">
                    <%
                        FOR loopInt = 0 TO oTimeSale.FResultCount - 1
                            call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                            'call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                    %>                
                        <div <%=chkiif(isSoldOut , "class=""special-item sold-out""", "class=""special-item""")%>>
                            <a href="">
                                <img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="<%=oTimeSale.FitemList(loopInt).FcontentName%>">
                            </a>
                        </div>
                    <%
                        Next
                    %>
                    <%'<!-- MD상품--> %>
                    <ul id="itemList"></ul>
                    <div id="lyLoading" style="position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>                    
                    <%'<!--// MD상품--> %>
                </div>
            </div>
        <% Else %>
            <% '<!-- 이벤트 당일 오후 6시까지 보여줘야 될 영역 --> %>
            <div class="teaser teaser2">
                <div class="top">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/tit_teaser2.jpg" alt="타임세일 티저">
                    <div class="sale-timer">
                        <div><span>-</span><span id="countdown">00:00:00</span></div>
                    </div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/txt_noti3_v2.png" alt="라인업 상품의 경우, 무통장 결제가 불가합니다."></div>
                </div>
                <div class="list-wrap">
                    <% Select Case Trim(CStr(episode)) %>
                        <% Case "1" %>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item1_1.jpg" alt="에어팟 프로"></a>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item1_2.jpg" alt="닌텐도 + 동물의 숲"></a>
                        <% Case "2" %>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item2_1.jpg" alt="에어팟 프로"></a>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item2_2.jpg" alt="마샬 스피커"></a>
                        <% Case "3" %>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item3_1.jpg" alt="에어팟 2"></a>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item3_2.jpg" alt="닌텐도 + 마리오카트"></a>
                        <% Case "4" %>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item4_1.jpg" alt="판도라"></a>
                            <a href=""><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_item4_2.jpg" alt="딥디크 도손"></a>                        
                    <% End Select %>
                    <button class="btn-more"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/btn_more.jpg" alt="그리고 시크릿 18개의 상품"></button>
                </div>
            </div>
        <% End If %>
    <% End If %>
    
    <%' <!-- 공통 --> %>
    <%' <!-- 상품라인업 --> %>
    <div class="lineup">
        <button class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/btn_lineup.jpg?v=1.01" alt="타임세일상품라인업"></button>
        <div class="list" style="display:none;">
            <% Select Case Trim(CStr(episode)) %>
                <% Case "3" %>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_lineup3.jpg" alt="7/22타임세일상품라인업리스트">
                <% Case "4" %>
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_lineup4.jpg" alt="7/23타임세일상품라인업리스트">
            <% End Select %>
        </div>
    </div>

    <%' <!-- sns --> %>
    <div class="sns">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/img_sns.jpg" alt="SNS 팔로우하고 이벤트 소식을 놓치지 마세요!">
        <% If isapp="1" Then %>
            <a href="" onclick="openbrowser('https://tenten.app.link/e/gZD5hN6e84'); return false;" class="btn-sns fb">페북으로이동</a>
            <a href="" onclick="openbrowser('https://tenten.app.link/e/XPbHtzef84'); return false;" class="btn-sns insta">텐바이텐 인스타그램 바로가기</a>                        
        <% Else %>
            <a href="https://tenten.app.link/e/gZD5hN6e84" target="_blank" class="btn-sns fb">페북으로이동</a>
            <a href="https://tenten.app.link/e/XPbHtzef84" target="_blank" class="btn-sns insta">인스타로이동</a>
        <% End If %>
    </div>
    
    <%' <!--  이벤트배너 --> %>
    <a href="/event/eventmain.asp?eventid=104372" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/bnr_evt1.jpg" alt="BC카드로 결제하면 최대 5,000원 할인!"></a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104372');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/bnr_evt1.jpg" alt="BC카드로 결제하면 최대 5,000원 할인!"></a>
    
    <%' <!-- 유의사항 --> %>
    <div class="noti">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/txt_noti_v2.jpg?v=1.01" alt="유의사항">
        <a href="/category/category_itemPrd.asp?itemid=2501860&pEtr=104371" onclick="TnGotoProduct('2501860');return false;">상품자세히보기</a>
    </div>

    <%' <!-- 알림받기 레이어 --> %>
    <% If left(currentDate, 10) >= "2020-07-19" And left(currentDate, 10) < "2020-07-23" Then %>
        <button class="btn-push"><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/btn_alarm.png?v=1.01" alt="오픈알림신청"></button>
        <div class="lyr lyr-alarm" style="display:none;">
            <div class="inner">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/104371/m/txt_push.png" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
                <div class="input-box"><input type="number" id="phone1" placeholder="000" maxlength="3" oninput="maxLengthCheck(this)">-<input type="number" id="phone2" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">-<input type="number" id="phone3" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)"><button class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button></div>
                <button class="btn-close"></button>
            </div>
        </div>
    <% End IF %>
    
    <%' <!-- 페어플레이 레이어 --> %>
    <div class="lyr lyr-fair" id="fairplay" style="display:none;"></div>
    <%' <!--// 공통 --> %>
</div>
<%' <!--// 104371 타임세일 --> %>

<% if isapp="1" then %>
	<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
        <input type="hidden" name="itemid" id="itemid" value="">
        <input type="hidden" name="itemoption" value="0000">
        <input type="hidden" name="itemea" readonly value="1">
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="isPresentItem" value="" />
        <input type="hidden" name="mode" value="DO3">
    </form>
<% Else %>
	<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
        <input type="hidden" name="itemid" id="itemid" value="">
        <input type="hidden" name="itemoption" value="0000">
        <input type="hidden" name="itemea" readonly value="1">
        <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
        <input type="hidden" name="isPresentItem" value="" />
        <input type="hidden" name="mode" value="DO1">    
    </form>
<% End If %>
<%
    set oTimeSale = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
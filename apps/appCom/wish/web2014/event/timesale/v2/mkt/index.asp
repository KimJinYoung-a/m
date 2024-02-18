<%@ codepage="65001" language="VBScript" %>
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
' Description : 마케팅 타임세일
' History : 2021-12-15 김형태 생성
'####################################################

dim isAdmin : isAdmin = false '// 관리자 여부
dim currentType '// 1이면 실제 진행상황, 0이면 준비 단계
dim currentTime '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt
dim isItem, currentDate
dim totalPrice , salePercentString , couponPercentString , totalSalePercent
dim oTimeSale , isSoldOut , RemainCount
dim episode '// 일자별 회차로 보면 될듯..
dim sqlStr, evtCountTimeDate, evtCountTimeText

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "109441"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "116985"
    mktTest = true
Else
	eCode = "116985"
    mktTest = false
End If

if mktTest then
    if request("testCheckDate")<>"" then
        currentDate = CDate(request("testCheckDate"))
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    end if
    currentTime = Cdate("12:00:00")
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()
end if

'티저페이지 없는경우 99 추가
If currentDate < #02/15/2022 10:00:00# Then
    episode=99
elseIf currentDate >= #02/15/2022 10:00:00# and currentDate < #02/15/2022 15:00:00# Then
    episode=1
elseIf currentDate >= #02/15/2022 15:00:00# and currentDate < #02/15/2022 18:00:00# Then
    episode=2
elseIf currentDate >= #02/15/2022 18:00:00# and currentDate < #02/15/2022 23:59:59# Then
    episode=3
elseIf currentDate >= #02/16/2022 10:00:00# and currentDate < #02/16/2022 15:00:00# Then
    episode=4
elseIf currentDate >= #02/16/2022 15:00:00# and currentDate < #02/16/2022 18:00:00# Then
    episode=5
elseIf currentDate >= #02/16/2022 18:00:00# and currentDate < #02/16/2022 23:59:59# Then
    episode=6
elseIf currentDate >= #02/17/2022 10:00:00# and currentDate < #02/17/2022 15:00:00# Then
    episode=7
elseIf currentDate >= #02/17/2022 15:00:00# and currentDate < #02/17/2022 18:00:00# Then
    episode=8
elseIf currentDate >= #02/17/2022 18:00:00# and currentDate < #02/17/2022 23:59:59# Then
    episode=9
else
    episode=0
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If application("Svr_Info") <> "staging" AND isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid=116985&gaparam="&gaparamChkVal
	Response.End
End If

'// 현재 일자 및 시간 기준으로 다음 이벤트 일자대비 카운트 다운용 일자 생성
If episode > 0 Then
    Select Case episode
        '티저페이지 없는경우 99
        Case 99
            evtCountTimeDate = CDate("2022-02-15 10:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 1
            evtCountTimeDate = CDate("2022-02-15 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 2
            evtCountTimeDate = CDate("2022-02-15 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 3
            evtCountTimeDate = CDate("2022-02-16 10:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 4
            evtCountTimeDate = CDate("2022-02-16 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 5
            evtCountTimeDate = CDate("2022-02-16 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 6
            evtCountTimeDate = CDate("2022-02-17 10:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 7
            evtCountTimeDate = CDate("2022-02-17 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 8
            evtCountTimeDate = CDate("2022-02-17 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 9
            evtCountTimeDate = CDate("2022-02-18 00:00:00")
            evtCountTimeText = "이벤트 종료까지"
    End Select
Else
    evtCountTimeText = "첫 번째 오픈까지"
    If currentDate < #02/15/2022 00:00:00# Then
        'Response.redirect "/event/eventmain.asp?eventid=116058&gaparam="&gaparamChkVal
        'Response.End
        '티저페이지 없는 경우
        evtCountTimeDate = CDate("2022-02-15 10:00:00")
    ElseIf currentDate >= #02/15/2022 00:00:00# And currentDate < #02/15/2022 10:00:00# Then
        evtCountTimeDate = CDate("2022-02-15 10:00:00")
    ElseIf currentDate >= #02/16/2022 00:00:00# And currentDate < #02/16/2022 10:00:00# Then
        evtCountTimeDate = CDate("2022-02-16 10:00:00")
    ElseIf currentDate >= #02/17/2022 00:00:00# And currentDate < #02/17/2022 10:00:00# Then
        evtCountTimeDate = CDate("2022-02-17 10:00:00")
    Else
        evtCountTimeText = "이벤트가 종료 되었습니다."
        evtCountTimeDate = CDate("2022-02-18 00:00:00")
    End If
End If

Dim episode1Itemid, episode2Itemid, episode3Itemid, episode4Itemid, episode5Itemid, episode6Itemid, episode7Itemid, episode8Itemid, episode9Itemid
IF application("Svr_Info") = "Dev" THEN
    episode1Itemid = "3369941"
    episode2Itemid = "3369942"
    episode3Itemid = "3369943"
    episode4Itemid = "3369944"
    episode5Itemid = "3369945"
    episode6Itemid = "3369946"
    episode7Itemid = "3369948"
    episode8Itemid = "3369949"
    episode9Itemid = "3369950"
Else
    episode1Itemid = "4408241"
    episode2Itemid = "4408242"
    episode3Itemid = "4408247"
    episode4Itemid = "4408244"
    episode5Itemid = "4408247"
    episode6Itemid = "4408245"
    episode7Itemid = "4408247"
    episode8Itemid = "4408246"
    episode9Itemid = "4408241"
End If
%>
<style>
.mEvt116985 .topic {position:relative;}
.mEvt116985 .topic .btn-open {width:9.73rem; position:absolute; right:1.43rem; top:2.65rem; background:transparent; animation:.6s updown ease-in-out alternate infinite;}
.mEvt116985 .section-02 {background:#ffe25a;}
.mEvt116985 .section-02 .diary-area {display:flex; align-items:flex-start; justify-content:center; padding-bottom:3.04rem; background:#eb74bd;}
.mEvt116985 .section-02 .diary-area .img-diary {position:relative; width:15.96rem; margin-left:1.1rem;}
.mEvt116985 .section-02 .diary-area .img-diary.sold-out::after {content:""; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116985/m/bg_diary.png) no-repeat 0 0; background-size:100%;}
.mEvt116985 .section-02 .diary-area .diary-info .img {overflow:hidden; width:14.93rem; height:12.97rem;}
.mEvt116985 .section-02 .diary-area .diary-info button {width:10.91rem; margin-left:1.45rem;}
.mEvt116985 .section-02 .diary-area button:disabled {cursor:not-allowed;}
.mEvt116985 .section-03 .btn-noti {position:relative;}
.mEvt116985 .section-03 .btn-noti:before {content:""; position:absolute; right:1.98rem; top:50%; transform:translate(-50%,0); display:inline-block; width:1.13rem; height:0.69rem; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116985/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition:.8s ease;}
.mEvt116985 .section-03 .btn-noti.on:before {content:""; right:2.5rem; transform:rotate(180deg);}
.mEvt116985 .section-03 .noti-info {display:none;}
.mEvt116985 .section-04 .count-area {padding:4.34rem 0 3.04rem; background:#89d45b;}
.mEvt116985 .section-04 .count-area .tit {width:15.22rem; height:3.39rem; line-height:3.39rem; border-radius:5px; margin:0 auto; font-size:1.56rem; color:#fff; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; background:#e053a9;}
.mEvt116985 .section-04 .count-area .open-timer {display:flex; align-items:center; justify-content:center; padding-top:1.5rem;}
.mEvt116985 .section-04 .count-area .open-timer span {font-size:5.21rem; color:#000; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt116985 .section-06 .list-wrap #itemList {padding:0 2.82rem; background:#f6f6f6;}
.mEvt116985 .section-06 .list-wrap .desc {padding-top:3.21rem; padding-bottom:3.33rem;}
.mEvt116985 .section-06 .list-wrap .thumbnail {position:relative; min-width:24.78rem; min-height:26.3rem;}
.mEvt116985 .section-06 .list-wrap .thumbnail:after {content:""; display:inline-block; position:absolute; bottom:-2rem; right:-3rem; z-index:10; width:14.87rem; height:3.34rem; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_txt_seal.png?v=1.01) no-repeat 0 0; background-size:100%;}
.mEvt116985 .section-06 .list-wrap .thumbnail.oneplus:after {content:""; display:inline-block; position:absolute; bottom:-2rem; right:-3rem; z-index:10; width:25.6vw; height:10.4vw; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_txt_one.png) no-repeat 0 0; background-size:100%;}
.mEvt116985 .section-06 .list-wrap .desc .name {overflow:hidden; font-size:2rem; line-height:1.2; color:#111; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; white-space:nowrap; text-overflow:ellipsis;}
.mEvt116985 .section-06 .list-wrap .desc .price {margin-top:.8rem; font-size:2.17rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#ff3823;}
.mEvt116985 .section-06 .list-wrap .desc .price s {font-size:1.52rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.mEvt116985 .section-06 .list-wrap .desc .price span {display:inline-block; margin-left:1.1rem; font-size:2.56rem; color:#ff3823}
.mEvt116985 .section-06 .diary a {display:inline-block;}
.mEvt116985 .pop-container.line-up {height:100vh; overflow-y:scroll;}
.mEvt116985 .pop-container.line-up .pop-inner {padding:0;}
.mEvt116985 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; min-height:45.52rem; background-color:rgba(0, 0, 0,0.902); z-index:150;}
.mEvt116985 .pop-container .pop-inner {position:relative; width:100%; padding:8.47rem 1.73rem 4.17rem;}
.mEvt116985 .pop-container .pop-inner a {display:inline-block;}
.mEvt116985 .pop-container .pop-inner .btn-close {position:fixed; right:2.73rem; top:2.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2022/116985/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt116985 .pop-container .pop-contents {position:relative;}
.mEvt116985 .pop-container .pop-contents .link-kakao {width:calc(100% - 4.80rem); position:absolute; left:50%; top:57%; transform:translate(-50%, 0);}
.mEvt116985 .pop-container .pop-contents .tit {padding-right:7.87rem;}
.mEvt116985 .pop-container .pop-contents .pop-input {display:flex; align-items:center; justify-content:flex-start; padding:6.82rem 0 2.17rem;}
.mEvt116985 .pop-container .pop-contents .pop-input button {height:3rem; padding-left:2rem; border-bottom:2px solid #54ff00; border-radius:0; font-size:1.43rem; color:#54ff00; background:none; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt116985 .pop-container .pop-contents .pop-input input {width:17.83rem; height:3rem; padding-left:0; border:0; font-size:1.43rem; color:#cbcbcb; background:none; border-bottom:2px solid #54ff00; border-radius:0;}
@keyframes updown {
    0% {top:1.65rem;}
    100% {top:2.65rem;}
}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
    countDownTimer("<%=Year(evtCountTimeDate)%>"
        , "<%=TwoNumber(Month(evtCountTimeDate))%>"
        , "<%=TwoNumber(Day(evtCountTimeDate))%>"
        , "<%=TwoNumber(hour(evtCountTimeDate))%>"
        , "<%=TwoNumber(minute(evtCountTimeDate))%>"
        , "<%=TwoNumber(Second(evtCountTimeDate))%>"
        , new Date(<%=Year(currentDate)%>, <%=Month(currentDate)-1%>, <%=Day(currentDate)%>, <%=Hour(currentDate)%>, <%=Minute(currentDate)%>, <%=Second(currentDate)%>)
    );

    $(function(){
        /* 이벤트 유의사항 노출,비노출 */
        $(".mEvt116985 .btn-noti").on("click", function(){
            $(this).next(".noti-info").slideToggle(500);
            $(this).toggleClass("on");
        });
        /* popup */
        // 알람 신청 팝업
        $(".mEvt116985 .btn-open").on("click", function(){
            $(".pop-container.alram").fadeIn();
        });
        // 라인업 자세히 보기 팝업
        $(".mEvt116985 .btn-lineup").on("click", function(){
            $(".pop-container.line-up").fadeIn();
        });
        // 팝업 닫기
        $(".mEvt116985 .btn-close").on("click", function(){
            $(".pop-container").fadeOut();
        });
        <%'// MD상품 리스트%>
        <%
            'If currentDate >= #02/15/2022 00:00:00# and currentDate < #02/16/2022 00:00:00# Then
            '티저페이지 없는 경우
            If currentDate < #02/16/2022 00:00:00# Then
        %>
            codeGrp = [4287391,4313607];
        <% elseIf currentDate >= #02/16/2022 00:00:00# and currentDate < #02/17/2022 00:00:00# Then %>
            codeGrp = [4224570,3664921];
        <% elseIf currentDate >= #02/17/2022 00:00:00# and currentDate < #02/18/2022 00:00:00# Then %>
            codeGrp = [4084296,3941642];
        <% End If %>

        var $rootEl = $("#itemList")
        var itemEle = tmpEl = ""
        $rootEl.empty();

        let codeGrp_count = 0;
        codeGrp.forEach(function(item){
            tmpEl = '<li>\
                        <a href="" onclick="goProduct('+item+');return false;">\
                            <div class="thumbnail ' + (codeGrp_count == 0 ? 'oneplus' : '') + '"><img src="" alt=""></div>\
                            <div class="desc">\
                                <p class="name">상품명상품명상품명상품명상품명상품명</p>\
                                <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                            </div>\
                        </a>\
                    </li>\
                    '
            itemEle += tmpEl
            codeGrp_count++;
        });
        $rootEl.append(itemEle)

        fnApplyItemInfoList({
            items:codeGrp,
            target:"itemList",
            fields:["image","name","price","sale"],
            unit:"none",
            saleBracket:false
        });
    });

    function fnSendToKakaoMessage() {
        <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
        <%
            'If (left(currentDate, 10) < "2022-02-15" Or left(currentDate, 10) > "2022-02-17") Then
            '티저페이지 없는 경우
            If left(currentDate, 10) > "2022-02-17" Then
        %>
            alert("이벤트 기간에만 신청하실 수 있습니다.");
            return false;
        <% End If %>

        if ($("#phone").val() == '') {
            alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
            $("#phone").focus();
            return;
        }
        var phoneNumber;
        phoneNumber = $("#phone").val().replace("-","");
        if (phoneNumber.length > 10) {
            phoneNumber = phoneNumber.substring(0,3)+ "-" +phoneNumber.substring(3,7)+ "-" +phoneNumber.substring(7,11);
        } else {
            phoneNumber = phoneNumber.substring(0,3)+ "-" +phoneNumber.substring(3,6)+ "-" +phoneNumber.substring(6,10);
        }

        $.ajax({
            type:"GET",
            url:"/apps/appCom/wish/web2014/event/timesale/v2/mkt/do_script.asp",
            data: "mode=kamsg&testCheckDate=<%=currentDate%>&phoneNumber="+btoa(phoneNumber),
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var str;
                            for(var i in Data){
                                if(Data.hasOwnProperty(i)){
                                    str += Data[i];
                                }
                            }
                            str = str.replace("undefined","");
                            res = str.split("|");
                            if (res[0]=="OK") {
                                alert('신청이 완료되었습니다.');
                                $("#phone").val('')
                                $(".pop-container").fadeOut();
                                return false;
                            }else{
                                errorMsg = res[1].replace(">?n", "\n");
                                alert(errorMsg );
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

    function goDirOrdItem(btn) {
        
        // 단시간 중복 구매하기 방지 - 임시
        btn.disabled = true;
        setTimeout(() => btn.disabled = false, 3000);

        <% If Not(IsUserLoginOK) Then %>
            calllogin()
            return false;
        <% else %>
            $.ajax({
                type:"GET",
                url:"/apps/appCom/wish/web2014/event/timesale/v2/mkt/do_script.asp",
                data: "mode=order&testCheckDate=<%=currentDate%>",
                dataType: "text",
                async:false,
                cache:true,
                success : function(Data, textStatus, jqXHR){
                    if (jqXHR.readyState == 4) {
                        if (jqXHR.status == 200) {
                            if(Data!="") {
                                var str;
                                for(var i in Data)
                                {
                                        if(Data.hasOwnProperty(i))
                                    {
                                        str += Data[i];
                                    }
                                }
                                str = str.replace("undefined","");
                                res = str.split("|");
                                if (res[0]=="OK") {
                                    fnAmplitudeEventMultiPropertiesAction('click_diaryBuy_item','itemid', res[1])
                                    $("#itemid").val(res[1]);
                                    setTimeout(function() {
                                        $("#directOrdIframe").html('<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>');
                                        document.directOrd.submit();
                                    },300);
                                    return false;
                                }else{
                                    errorMsg = res[1].replace(">?n", "\n");
                                    alert(errorMsg);
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

    function goProduct(itemid) {
        <% if isApp then %>
            parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
        <% else %>
            parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
        <% end if %>
        return false;
    }
</script>

<div class="mEvt116985">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_tit.jpg" alt="2021년 다디어리 선착순 무료 배포 12월 14일(월) - 16일(수)"></h2>
        <%
            'If currentDate >= #02/15/2022 00:00:00# and currentDate < #02/17/2022 00:00:00# Then
            '티저페이지 없는 경우
            If currentDate < #02/17/2022 00:00:00# Then
        %>
            <button type="button" class="btn-open"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_banner.png" alt="내일 알림 신청"></button>
        <% End If %>
    </div>
    <div class="section-01">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_sub_tit.jpg" alt="오늘의 무료 다이어리 라인업"></h3>
    </div>

    <%' <!-- 날짜별 라인업 --> %>
    <%
        'If currentDate >= #02/15/2022 00:00:00# and currentDate < #02/16/2022 00:00:00# Then
        '티저페이지 없는경우
        If currentDate < #02/16/2022 00:00:00# Then
    %>
    <div class="section-02">
        <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_day01.jpg" alt="12월 14일"></div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary1_01.png" alt="클리어 데코 다이어리 오브젝트"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item1_01.png" alt="14일 10:00 클리어 데코 다이어리 오브젝트"></div>
            <% If episode="1" Then %>
                <% If getitemlimitcnt(episode1Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/15/2022 10:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode2Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary1_02.png" alt="2021 오브젝트 다이어리 위클리 L"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item1_02.png" alt="14일 15:00 2021 오브젝트 다이어리 위클리 L"></div>
            <% If episode="2" Then %>
                <% If getitemlimitcnt(episode2Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/15/2022 15:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode3Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary1_03.png" alt="디즈니 알린 3공 노트"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item1_03.png" alt="14일 18:00 디즈니 알린 3공 노트"></div>
            <% If episode="3" Then %>
                <% If getitemlimitcnt(episode3Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/15/2022 18:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>
    </div>
    <% End If %>

    <% If currentDate >= #02/16/2022 00:00:00# and currentDate < #02/17/2022 00:00:00# Then %>
    <div class="section-02">
        <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_day02.jpg" alt="12월 15일"></div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode4Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary2_01.png" alt="일상다꾸 다이어리세트 V2"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item2_01.png" alt="15일 10:00 일상다꾸 다이어리세트 V2"></div>
            <% If episode="4" Then %>
                <% If getitemlimitcnt(episode4Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/16/2022 10:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary2_02.png" alt="슬리핑피스 데일리 다이어리 디저트 에디션"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item2_02.png" alt="15일 15:00 슬리핑피스 데일리 다이어리 디저트 에디션"></div>
            <% If episode="5" Then %>
                <% If getitemlimitcnt(episode5Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/16/2022 15:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>

        <div class="diary-area">
            <div class="img-diary <% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary2_03.png" alt="케어베어 플러피 아카이브 다이어리"></div>
            <div class="diary-info">
                <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item2_03.png" alt="15일 18:00 케어베어 플러피 아카이브 다이어리"></div>
            <% If episode="6" Then %>
                <% If getitemlimitcnt(episode6Itemid) < 1 Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% Else %>
                    <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                <% End If %>
            <% Else %>
                <% If currentDate < #02/16/2022 18:00:00# Then %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                <% Else %>
                    <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                <% End If %>
            <% End If %>
            </div>
        </div>
    </div>
    <% End If %>

    <% If currentDate >= #02/17/2022 00:00:00# and currentDate < #02/18/2022 00:00:00# Then %>
        <div class="section-02">
            <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_day03.jpg" alt="12월 16일"></div>

            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary3_01.png" alt="미뉴잇 마카롱 미니 A7 다이어리"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item3_01.png" alt="16일 10:00 미뉴잇 마카롱 미니 A7 다이어리"></div>
                <% If episode="7" Then %>
                    <% If getitemlimitcnt(episode7Itemid) < 1 Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% Else %>
                        <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                    <% End If %>
                <% Else %>
                    <% If currentDate < #02/17/2022 10:00:00# Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                    <% Else %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% End If %>
                <% End If %>
                </div>
            </div>

            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary3_02.png" alt="디즈니 푸의 숲 속 산책 다이어리 ver.2"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item3_02.png" alt="16일 15:00 디즈니 푸의 숲 속 산책 다이어리 ver.2"></div>
                <% If episode="8" Then %>
                    <% If getitemlimitcnt(episode8Itemid) < 1 Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% Else %>
                        <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                    <% End If %>
                <% Else %>
                    <% If currentDate < #02/17/2022 15:00:00# Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                    <% Else %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% End If %>
                <% End If %>
                </div>
            </div>

            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_diary3_03.png" alt="2021 Dot Your Day Diary"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/txt_item3_03.png" alt="16일 18:00 2021 Dot Your Day Diary"></div>
                <% If episode="9" Then %>
                    <% If getitemlimitcnt(episode9Itemid) < 1 Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% Else %>
                        <button type="button" onclick="goDirOrdItem(this);"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_go.png" alt="신청하기"></button>
                    <% End If %>
                <% Else %>
                    <% If currentDate < #02/17/2022 18:00:00# Then %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_ready.png" alt="오픈예정"></button>
                    <% Else %>
                        <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_btn_out.png" alt="선착순 마감"></button>
                    <% End If %>
                <% End If %>
                </div>
            </div>
        </div>
    <% End If %>
    <%'<!-- //날짜별 라인업 --> %>

    <div class="section-03">
        <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_noti.jpg" alt="이벤트 유의사항 바로가기"></button>
        <div class="noti-info">
            <img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_noti_info.jpg" alt="유의사항">
        </div>
    </div>
    <div class="section-04">
        <div class="count-area">
            <p class="tit"><%=evtCountTimeText%></p>
            <div class="open-timer">
                <span>-</span>
                <span id="countdown">00:00:00</span>
            </div>
        </div>
    </div>
    <div class="section-05">
        <button type="button" class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_lineup.jpg" alt="라인업 자세히 보기"></button>
    </div>

    <div class="section-06">
        <%
            'If currentDate >= #02/15/2022 00:00:00# and currentDate < #02/18/2022 00:00:00# Then
            '티저페이지 없는 경우
            If currentDate < #02/18/2022 00:00:00# Then
        %>
            <%' <!-- MD상품--> %>
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_md_tit.jpg" alt="오늘만 이 가격! 다이어리 특가"></h3>
            <div class="list-wrap">
                <ul id="itemList"></ul>
            </div>
        <% End If %>
        <div class="diary">
            <!--<a href="javascript:void(0)" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021');return false;">-->
            <a href="javascript:void(0)" onclick="fnPopupBest('/apps/appcom/wish/web2014/list/best/best_summary2020.asp');return false;">
                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_link_diary.jpg" alt="더 많은 다이어리가 보고 싶다면! 28,487개의 다이어리 중 나만의 다이어리를 찾아보세요!">
            </a>
        </div>
    </div>

    <!-- for dev msg : 알람 신청 버튼 클릭 시 노출 팝업 -->
    <div class="pop-container alram">
        <div class="pop-inner">
            <div class="pop-contents">
                <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_pop_txt.png" alt="오픈 시간이 다가오면 카카오 알림톡 또는 문자메시지로 빠르게 알려드립니다."></p>
                <div class="pop-input">
                    <input type="number" id="phone" placeholder="휴대폰 번호를 입력해주세요." maxlength="11" />
                    <button type="button" onclick="fnSendToKakaoMessage()">확인</button>
                </div>
                <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_pop_txt02.png" alt="본 알림은 내일 10시 오픈 전에 1회만 발송되는 메시지입니다."></p>
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <!-- //알람 신청 버튼 클릭 시 노출 팝업 -->

    <!-- for dev msg : 라인업 자세히 보기 팝업 -->
    <div class="pop-container line-up">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2022/116985/m/img_popup.jpg" alt="라인업 소개">
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <!-- //라인업 자세히 보기 팝업 -->
</div>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp" target="iiBagWin">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<div id="directOrdIframe">
    <iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
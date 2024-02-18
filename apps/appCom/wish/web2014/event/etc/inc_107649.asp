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
' Description : 다이어리 타임세일
' History : 2020-11-23 원승현 생성
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
	eCode = "103269"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "107649"
    mktTest = true
Else
	eCode = "107649"
    mktTest = false
End If

'// 해당 아이디들은 테스트 할때 mktTest값을 true로 강제로 적용하여 테스트
'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
    'mktTest = true
end if

if mktTest then
    '// 테스트용
    'currentDate = CDate("2020-11-27 19:00:00")
    'currentTime = Cdate("19:00:00")
    '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()        
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()    
end if

'// 각 일자별 타임세일 진행여부를 episode로 정함
If currentDate >= #11/25/2020 10:00:00# and currentDate < #11/25/2020 15:00:00# Then
    '// 2020년 11월 25일 10시~15시 진행
    episode=1
elseIf currentDate >= #11/25/2020 15:00:00# and currentDate < #11/25/2020 18:00:00# Then
    '// 2020년 11월 25일 15시~18시 진행
    episode=2
elseIf currentDate >= #11/25/2020 18:00:00# and currentDate < #11/25/2020 23:59:59# Then
    '// 2020년 11월 25일 18시~23시59분59초 진행
    episode=3
elseIf currentDate >= #11/26/2020 10:00:00# and currentDate < #11/26/2020 15:00:00# Then
    '// 2020년 11월 26일 10시~15시 진행
    episode=4
elseIf currentDate >= #11/26/2020 15:00:00# and currentDate < #11/26/2020 18:00:00# Then
    '// 2020년 11월 26일 15시~18시 진행
    episode=5
elseIf currentDate >= #11/26/2020 18:00:00# and currentDate < #11/26/2020 23:59:59# Then
    '// 2020년 11월 26일 18시~23시59분59초 진행
    episode=6
elseIf currentDate >= #11/27/2020 10:00:00# and currentDate < #11/27/2020 15:00:00# Then
    '// 2020년 11월 27일 10시~15시 진행
    episode=7
elseIf currentDate >= #11/27/2020 15:00:00# and currentDate < #11/27/2020 18:00:00# Then
    '// 2020년 11월 27일 15시~18시 진행
    episode=8
elseIf currentDate >= #11/27/2020 18:00:00# and currentDate < #11/27/2020 23:59:59# Then
    '// 2020년 11월 27일 18시~23시59분59초 진행
    episode=9
else
    '// 그 외에는 episode 0으로 인식
    episode=0
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

'// 현재 일자 및 시간 기준으로 다음 이벤트 일자대비 카운트 다운용 일자 생성
If episode > 0 Then
    Select Case episode
        Case 1
            evtCountTimeDate = CDate("2020-11-25 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 2
            evtCountTimeDate = CDate("2020-11-25 18:00:00")
            evtCountTimeText = "다음 오픈까지"            
        Case 3
            evtCountTimeDate = CDate("2020-11-26 10:00:00")
            evtCountTimeText = "내일 오픈까지"
        Case 4
            evtCountTimeDate = CDate("2020-11-26 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 5
            evtCountTimeDate = CDate("2020-11-26 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 6
            evtCountTimeDate = CDate("2020-11-27 10:00:00")
            evtCountTimeText = "내일 오픈까지"
        Case 7
            evtCountTimeDate = CDate("2020-11-27 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 8
            evtCountTimeDate = CDate("2020-11-27 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 9
            evtCountTimeDate = CDate("2020-11-28 00:00:00")
            evtCountTimeText = "이벤트 종료까지"
    End Select
Else
    evtCountTimeText = "첫 번째 오픈까지"
    If currentDate < #11/25/2020 10:00:00# Then
        evtCountTimeDate = CDate("2020-11-25 10:00:00")
    ElseIf currentDate >= #11/26/2020 00:00:00# And currentDate < #11/26/2020 10:00:00# Then
        evtCountTimeDate = CDate("2020-11-26 10:00:00")
    ElseIf currentDate >= #11/27/2020 00:00:00# And currentDate < #11/27/2020 10:00:00# Then
        evtCountTimeDate = CDate("2020-11-27 10:00:00")
    Else
        evtCountTimeText = "이벤트가 종료 되었습니다."
        evtCountTimeDate = CDate("2020-11-28 00:00:00")        
    End If
End If

%>
<style type="text/css">
.mEvt107649 .topic {position:relative;}
.mEvt107649 .topic .btn-open {width:9.73rem; position:absolute; right:2.43rem; top:2.65rem; background:transparent; animation:.6s updown linear infinite alternate;}
.mEvt107649 .section-02 {background:#ffe25a;}
.mEvt107649 .section-02 .diary-area {display:flex; align-items:flex-start; justify-content:center; padding-bottom:3.04rem; background:#ffe25a;}
.mEvt107649 .section-02 .diary-area .img-diary {position:relative; width:15.96rem; margin-left:1.1rem;}
.mEvt107649 .section-02 .diary-area .img-diary.sold-out::after {content:""; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107649/m/bg_diary.png) no-repeat 0 0; background-size:100%;}
.mEvt107649 .section-02 .diary-area .diary-info .img {overflow:hidden; width:14.93rem; height:12.97rem;}
.mEvt107649 .section-02 .diary-area .diary-info button {width:10.91rem; margin-left:1.45rem;}
.mEvt107649 .section-02 .diary-area button:disabled {cursor:not-allowed;}
.mEvt107649 .section-03 .btn-noti {position:relative;}
.mEvt107649 .section-03 .btn-noti:before {content:""; position:absolute; right:0.98rem; top:50%; transform:translate(-50%,0); display:inline-block; width:1.13rem; height:0.69rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107649/m/icon_arrow.png) no-repeat 0 0; background-size:100%; transition:.8s ease;}
.mEvt107649 .section-03 .btn-noti.on:before {content:""; right:1.5rem; transform:rotate(180deg);}
.mEvt107649 .section-03 .noti-info {display:none;}
.mEvt107649 .section-04 .count-area {padding:4.34rem 0; background:#4117a7;}
.mEvt107649 .section-04 .count-area .tit {width:15.22rem; height:3.39rem; line-height:3.39rem; border-radius:5px; margin:0 auto; font-size:1.56rem; color:#4117a7; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; background:#54ff00;}
.mEvt107649 .section-04 .count-area .open-timer {display:flex; align-items:center; justify-content:center; padding-top:1.5rem;}
.mEvt107649 .section-04 .count-area .open-timer span {font-size:5.21rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt107649 .section-06 .list-wrap #itemList {padding:0 2.82rem; background:#d8daff;}
.mEvt107649 .section-06 .list-wrap .desc {padding-top:3.21rem; padding-bottom:3.33rem;}
.mEvt107649 .section-06 .list-wrap .thumbnail {position:relative; min-width:24.78rem; min-height:26.3rem;}
.mEvt107649 .section-06 .list-wrap .thumbnail:after {content:""; display:inline-block; position:absolute; bottom:-2rem; right:-3rem; z-index:10; width:14.87rem; height:3.34rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_txt_seal.png) no-repeat 0 0; background-size:100%;}
.mEvt107649 .section-06 .list-wrap .desc .name {overflow:hidden; font-size:2rem; line-height:1.2; color:#111; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; white-space:nowrap; text-overflow:ellipsis;}
.mEvt107649 .section-06 .list-wrap .desc .price {margin-top:.8rem; font-size:2.17rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#ff3823;}
.mEvt107649 .section-06 .list-wrap .desc .price s {font-size:1.52rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.mEvt107649 .section-06 .list-wrap .desc .price span {display:inline-block; margin-left:1.1rem; font-size:2.56rem; color:#ff3823}
.mEvt107649 .pop-container.line-up {height:100vh; overflow-y:scroll;}
.mEvt107649 .pop-container.line-up .pop-inner {padding:0;}
.mEvt107649 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; min-height:45.52rem; background-color:rgba(0, 0, 0,0.902); z-index:150;}
.mEvt107649 .pop-container .pop-inner {position:relative; width:100%; padding:8.47rem 1.73rem 4.17rem;}
.mEvt107649 .pop-container .pop-inner a {display:inline-block;}
.mEvt107649 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:2.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2020/107649/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;} 
.mEvt107649 .pop-container .pop-contents {position:relative;}
.mEvt107649 .pop-container .pop-contents .link-kakao {width:calc(100% - 4.80rem); position:absolute; left:50%; top:57%; transform:translate(-50%, 0);}
.mEvt107649 .pop-container .pop-contents .tit {padding-right:7.87rem;}
.mEvt107649 .pop-container .pop-contents .pop-input {display:flex; align-items:center; justify-content:flex-start; padding:6.82rem 0 2.17rem;}
.mEvt107649 .pop-container .pop-contents .pop-input button {height:3rem; padding-left:2rem; border-bottom:2px solid #54ff00; border-radius:0; font-size:1.43rem; color:#54ff00; background:none; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt107649 .pop-container .pop-contents .pop-input input {width:17.83rem; height:3rem; padding-left:0; border:0; font-size:1.43rem; color:#cbcbcb; background:none; border-bottom:2px solid #54ff00; border-radius:0;}
@keyframes updown {
    0% {top:1.65rem;}
    100% {top:2.65rem;}
}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
countDownTimer("<%=Year(evtCountTimeDate)%>"
                , "<%=TwoNumber(Month(evtCountTimeDate))%>"
                , "<%=TwoNumber(Day(evtCountTimeDate))%>"
                , "<%=TwoNumber(hour(evtCountTimeDate))%>"
                , "<%=TwoNumber(minute(evtCountTimeDate))%>"
                , "<%=TwoNumber(Second(evtCountTimeDate))%>"
                , new Date(<%=Year(currentDate)%>, <%=Month(currentDate)-1%>, <%=Day(currentDate)%>, <%=Hour(currentDate)%>, <%=Minute(currentDate)%>, <%=Second(currentDate)%>)
                );

$(function(){
    <%'/* 이벤트 유의사항 노출,비노출 */%>
    $(".mEvt107649 .btn-noti").on("click", function(){
        $(this).next(".noti-info").slideToggle(500);
        $(this).toggleClass("on");
    });
    <%'// 알람 신청 팝업%>
	$(".mEvt107649 .btn-open").on("click", function(){
		$(".pop-container.alram").fadeIn();
	});
    <%'// 라인업 자세히 보기 팝업%>
    $(".mEvt107649 .btn-lineup").on("click", function(){
		$(".pop-container.line-up").fadeIn();
	});
	<%'// 팝업 닫기%>
	$(".mEvt107649 .btn-close").on("click", function(){
		$(".pop-container").fadeOut();
	});
    <%'// MD상품 리스트%>
    <% If episode > 0 Then %>
        var itemlistIdx = <%=episode%>
        switch (itemlistIdx) {
            case 1 :
            case 2 :
            case 3 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816]; // 11/25
                <% Else %>
                    codeGrp = [3308296,3224816,3201742,3370864,2551008,3321221,3362889,2506581,2416623,3309929,3341295,3248643,3331879,3331878,3331877,3331876,3331875,3217277,3013296,3003425]; // 11/25
                <% End If %>
                break;
            case 4 :
            case 5 :
            case 6 :
                <% IF application("Svr_Info") = "Dev" THEN %>            
                    codeGrp = [3192537,3366566,3309445];  // 11/26
                <% Else %>
                    codeGrp = [3192537,3366566,3309445,3322035,3356114,3163783,3242578,2506582,2553777,3341294,2504660,3272542,3272541,3272540,3272539,3003428,3279814,3272444,3272443,2609865];  // 11/26
                <% End If %>
                break;
            case 7 :
            case 8 :
            case 9 :
                <% IF application("Svr_Info") = "Dev" THEN %>            
                    codeGrp = [3366565,2578588,3243012,3291068];  // 11/27
                <% Else %>
                    codeGrp = [3366565,2578588,3243012,3291068,3322034,2333388,3253321,3402089,2488821,2519201,3341293,3441619,3248213,3248212,3248211,3248210,3248209,3009397,3179699,3006219];  // 11/27                
                <% End If %>
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
                                <p class="name">상품명상품명상품명상품명상품명상품명</p>\
                                <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
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

function fnSendToKakaoMessage() {
    <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
    <% If (left(currentdate, 10) < "2020-11-25" Or left(currentdate, 10) > "2020-11-27") Then %> 
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
        url:"/apps/appCom/wish/web2014/event/etc/doeventSubscript107649.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
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

function goDirOrdItem() {
    <% If Not(IsUserLoginOK) Then %>
        calllogin();
        return false;
    <% else %>
        $.ajax({
            type:"GET",
            url:"/apps/appCom/wish/web2014/event/etc/doeventSubscript107649.asp",
            data: "mode=order",
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

<%' <!-- 107649 --> %>
<div class="mEvt107649">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_tit.jpg" alt="2021년 다디어리 선착순 무료 배포 11월 25일(수) - 27일(금)"></h2>
        <% If currentDate >= #11/25/2020 00:00:00# and currentDate < #11/27/2020 00:00:00# Then %>
            <button type="button" class="btn-open"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_banner.png" alt="내일 알림 신청"></button>
        <% End If %>
    </div>
    <div class="section-01">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_sub_tit.jpg" alt="오늘의 무료 다이어리 라인업"></h3>
    </div>

    <%' <!-- 날짜별 라인업 --> %>
    <% If currentDate >= #11/25/2020 00:00:00# and currentDate < #11/26/2020 00:00:00# Then %>
        <%' <!-- for dev msg : 11월 25일 --> %>
        <div class="section-02">
            <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_day01.jpg" alt="11월 25일"></div>
            <%'<!-- 25일 10:00시 오픈 -->%>
            <% 
                Dim episode1Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode1Itemid = "3369941"
                Else
                    episode1Itemid = "3424997"
                End If
            %>
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary1_01.png" alt="오프닝 시퀀스 다이어리"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item1_1.png" alt="25일 10:00 오프닝 시퀀스 다이어리"></div>
                    <% If episode="1" Then %>
                        <% If getitemlimitcnt(episode1Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/25/2020 10:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%' <!-- 25일 15:00시 오픈 --> %>
            <% 
                Dim episode2Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode2Itemid = "3369942"
                Else
                    episode2Itemid = "3424998"
                End If
            %>
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode2Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary1_02.png" alt="다이어리 세트"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item1_2.png" alt="25일 15:00 나의 따뜻한 하루 다이어리 세트"></div>
                    <% If episode="2" Then %>
                        <% If getitemlimitcnt(episode2Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/25/2020 15:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%' <!-- 25일 18:00시 오픈 --> %>
            <% 
                Dim episode3Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode3Itemid = "3369943"
                Else
                    episode3Itemid = "3418284"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode3Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary1_03.png" alt="별별바구니 A5 6공 다이어리"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item1_3.png" alt="25일 18:00 별별바구니 A5 6공 다이어리"></div>
                    <% If episode="3" Then %>
                        <% If getitemlimitcnt(episode3Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/25/2020 18:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
        </div>
    <% End If %>
    <% If currentDate >= #11/26/2020 00:00:00# and currentDate < #11/27/2020 00:00:00# Then %>
        <%' <!-- for dev msg : 11월 26일 --> %>
        <div class="section-02">
            <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_day02.jpg" alt="11월 26일"></div>
            <%' <!-- 26일 10:00시 오픈 --> %>
            <%
                Dim episode4Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode4Itemid = "3369944"
                Else
                    episode4Itemid = "3424999"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode4Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary2_01.png" alt="이야기 다이어리 톨"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item2_1.png" alt="26일 10:00 이야기 다이어리 톨"></div>
                    <% If episode="4" Then %>
                        <% If getitemlimitcnt(episode4Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/26/2020 10:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%'<!-- 26일 15:00시 오픈 -->%>
            <%
                Dim episode5Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode5Itemid = "3369945"
                Else
                    episode5Itemid = "3425011"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary2_02.png" alt="슬리핑피스 데일리 다이어리 디저트 에디션"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item2_2.png" alt="26일 15:00 슬리핑피스 데일리 다이어리 디저트 에디션"></div>
                    <% If episode="5" Then %>
                        <% If getitemlimitcnt(episode5Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/26/2020 15:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%'<!-- 26일 18:00시 오픈 -->%>
            <%
                Dim episode6Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode6Itemid = "3369947"
                Else
                    episode6Itemid = "3418290"
                End If
            %>
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary2_03.png" alt="디즈니 푸의 숲 속 산책 다이어리 vsr.2"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item2_3.png" alt="26일 18:00 디즈니 푸의 숲 속 산책 다이어리 vsr.2"></div>
                    <% If episode="6" Then %>
                        <% If getitemlimitcnt(episode6Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/26/2020 18:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
        </div>
    <% End If %>
    <% If currentDate >= #11/27/2020 00:00:00# and currentDate < #11/28/2020 00:00:00# Then %>    
        <%' <!-- for dev msg : 11월 27일 --> %>
        <div class="section-02">
            <div class="day-month"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_day03.jpg" alt="11월 27일"></div>
            <%'<!-- 27일 10:00시 오픈 -->%>
            <%
                Dim episode7Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode7Itemid = "3369948"
                Else
                    episode7Itemid = "3425012"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary3_01.png" alt="Freestyle Gentel Diary"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item3_1.png" alt="27일 10:00 Freestyle Gentel Diary"></div>
                    <% If episode="7" Then %>
                        <% If getitemlimitcnt(episode7Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/27/2020 10:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%'<!-- 27일 15:00시 오픈 -->%>
            <%
                Dim episode8Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode8Itemid = "3369949"
                Else
                    episode8Itemid = "3425021"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary3_02.png" alt="루카랩 케어베어 패턴 다이어리"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item3_2.png" alt="27일 15:00 루카랩 케어베어 패턴 다이어리"></div>
                    <% If episode="8" Then %>
                        <% If getitemlimitcnt(episode8Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/27/2020 15:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
            <%' <!-- 27일 18:00시 오픈 --> %>
            <%
                Dim episode9Itemid
                IF application("Svr_Info") = "Dev" THEN
                    episode9Itemid = "3369950"
                Else
                    episode9Itemid = "3425022"
                End If
            %>        
            <div class="diary-area">
                <div class="img-diary <% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_diary3_03.png" alt="별별일상 Dreamy 에디션"></div>
                <div class="diary-info">
                    <div class="img"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/txt_item3_3.png" alt="27일 18:00 별별일상 Dreamy 에디션"></div>
                    <% If episode="9" Then %>
                        <% If getitemlimitcnt(episode9Itemid) < 1 Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button> 
                        <% Else %>
                            <button type="button" onclick="goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_go.png" alt="신청하기"></button>
                        <% End If %>
                    <% Else %>
                        <% If currentDate < #11/27/2020 18:00:00# Then %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_ready.png" alt="오픈예정"></button>
                        <% Else %>
                            <button type="button" disabled><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_btn_out.png" alt="선착순 마감"></button>
                        <% End If %>
                    <% End If %>
                </div>
            </div>
        </div>
    <% End If %>
    <%' <!-- //날짜별 라인업 --> %>
    
    <div class="section-03">
        <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_noti.jpg" alt="이벤트 유의사항 바로가기"></button>
        <div class="noti-info">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_noti_info.jpg" alt="유의사항">
        </div>
    </div>
    <div class="section-04">
        <div class="count-area">
            <%' <!-- for dev msg : 이벤트 오픈 안내 문구 4 가지 타입 --> %>
            <p class="tit"><%=evtCountTimeText%></p>
            <div class="open-timer">
                <span>-</span>
                <span id="countdown">00:00:00</span>
            </div>
        </div>
    </div>
    <div class="section-05">
        <button type="button" class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_lineup.jpg" alt="라인업 자세히 보기"></button>
    </div>

    <% If episode > 0 Then %>
        <div class="section-06">
            <%' <!-- MD상품--> %>
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_md_tit.jpg" alt="오늘만 이 가격! 다이어리 특가"></h3>
            <div class="list-wrap">
                <ul id="itemList"></ul>
            </div>
            <%' <!--// MD상품--> %>
        </div>
    <% End If %>

    <%' <!-- for dev msg : 알람 신청 버튼 클릭 시 노출 팝업 --> %>
    <div class="pop-container alram">
        <div class="pop-inner">
            <div class="pop-contents">
                <p class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_pop_txt.png" alt="오픈 시간이 다가오면 카카오 알림톡 또는 문자메시지로 빠르게 알려드립니다."></p>
                <div class="pop-input">
                    <input type="number" id="phone" placeholder="휴대폰 번호를 입력해주세요." maxlength="11" oninput="maxLengthCheck(this)">
                    <button type="button" onclick="fnSendToKakaoMessage()">확인</button>
                </div>
                <p class="notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_pop_txt03.png" alt="본 알림은 내일 10시 오픈 전에 1회만 발송되는 메시지입니다."></p>
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <%' <!-- //알람 신청 버튼 클릭 시 노출 팝업 --> %>

    <%' <!-- for dev msg : 라인업 자세히 보기 팝업 --> %>
    <div class="pop-container line-up">
        <div class="pop-inner">
            <div class="pop-contents">
                <img src="//webimage.10x10.co.kr/fixevent/event/2020/107649/m/img_popup_v2.jpg" alt="라인업 소개">
            </div>
            <button type="button" class="btn-close">닫기</button>
        </div>
    </div>
    <%' <!-- //라인업 자세히 보기 팝업 --> %>
</div>
<%' <!--// 107649 --> %>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
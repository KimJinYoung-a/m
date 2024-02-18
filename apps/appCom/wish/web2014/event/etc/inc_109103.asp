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
' Description : 타임세일
' History : 2021-01-20 정태훈 생성
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
	eCode = "104304"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "109103"
    mktTest = true
Else
	eCode = "109103"
    mktTest = false
End If

if mktTest then
    '// 테스트용
    if request("testCheckDate")<>"" then
        currentDate = CDate(request("testCheckDate"))
    else
        currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    end if
    currentTime = TimeValue(currentDate)
    '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
    'currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    'currentTime = time()
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = time()
end if

'// 각 일자별 타임세일 진행여부를 episode로 정함
If currentDate >= #01/25/2021 10:00:00# and currentDate < #01/25/2021 15:00:00# Then
    '// 2021년 1월 25일 10시~15시 진행
    episode=1
elseIf currentDate >= #01/25/2021 15:00:00# and currentDate < #01/25/2021 18:00:00# Then
    '// 2021년 1월 25일 15시~18시 진행
    episode=2
elseIf currentDate >= #01/25/2021 18:00:00# and currentDate < #01/25/2021 23:59:59# Then
    '// 2021년 1월 25일 18시~23시59분59초 진행
    episode=3
elseIf currentDate >= #01/26/2021 10:00:00# and currentDate < #01/26/2021 15:00:00# Then
    '// 2021년 1월 26일 10시~15시 진행
    episode=4
elseIf currentDate >= #01/26/2021 15:00:00# and currentDate < #01/26/2021 18:00:00# Then
    '// 2021년 1월 26일 15시~18시 진행
    episode=5
elseIf currentDate >= #01/26/2021 18:00:00# and currentDate < #01/26/2021 23:59:59# Then
    '// 2021년 1월 26일 18시~23시59분59초 진행
    episode=6
elseIf currentDate >= #01/27/2021 10:00:00# and currentDate < #01/27/2021 15:00:00# Then
    '// 2021년 1월 27일 10시~15시 진행
    episode=7
elseIf currentDate >= #01/27/2021 15:00:00# and currentDate < #01/27/2021 18:00:00# Then
    '// 2021년 1월 27일 15시~18시 진행
    episode=8
elseIf currentDate >= #01/27/2021 18:00:00# and currentDate < #01/27/2021 23:59:59# Then
    '// 2021년 1월 27일 18시~23시59분59초 진행
    episode=9
else
    '// 그 외에는 episode 0으로 인식
    episode=0
end if

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid=109102&gaparam="&gaparamChkVal
	Response.End
End If

'// 현재 일자 및 시간 기준으로 다음 이벤트 일자대비 카운트 다운용 일자 생성
If episode > 0 Then
    Select Case episode
        Case 1
            evtCountTimeDate = CDate("2021-01-25 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 2
            evtCountTimeDate = CDate("2021-01-25 18:00:00")
            evtCountTimeText = "다음 오픈까지"            
        Case 3
            evtCountTimeDate = CDate("2021-01-26 10:00:00")
            evtCountTimeText = "내일 오픈까지"
        Case 4
            evtCountTimeDate = CDate("2021-01-26 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 5
            evtCountTimeDate = CDate("2021-01-26 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 6
            evtCountTimeDate = CDate("2021-01-27 10:00:00")
            evtCountTimeText = "내일 오픈까지"
        Case 7
            evtCountTimeDate = CDate("2021-01-27 15:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 8
            evtCountTimeDate = CDate("2021-01-27 18:00:00")
            evtCountTimeText = "다음 오픈까지"
        Case 9
            evtCountTimeDate = CDate("2021-01-28 00:00:00")
            evtCountTimeText = "이벤트 종료까지"
    End Select
Else
    evtCountTimeText = "첫 번째 오픈까지"
    If currentDate < #01/25/2021 10:00:00# Then
        evtCountTimeDate = CDate("2021-01-25 10:00:00")
    ElseIf currentDate >= #01/26/2021 00:00:00# And currentDate < #01/26/2021 10:00:00# Then
        evtCountTimeDate = CDate("2021-01-26 10:00:00")
    ElseIf currentDate >= #01/27/2021 00:00:00# And currentDate < #01/27/2021 10:00:00# Then
        evtCountTimeDate = CDate("2021-01-27 10:00:00")
    Else
        evtCountTimeText = "이벤트가 종료 되었습니다."
        evtCountTimeDate = CDate("2021-01-28 00:00:00")        
    End If
End If

%>
<style>
.mEvt109103 {position:relative;}
.mEvt109103 button {background:none;}
.mEvt109103 .topic {position:relative;}
.mEvt109103 .btn-push {position:absolute; top:32%; right:5%; width:30%; animation:bounce 1s 10 both;}
@keyframes bounce {
	from, to {transform:translateY(-1rem); animation-timing-function:ease-in;}
	50% {transform:none; animation-timing-function:ease-out;}
}
.mEvt109103 .lineup {position:relative; padding-bottom:12%; background:#fff;}
.mEvt109103 .lineup .date {position:relative; margin:3rem 0 1rem; padding:0 6%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:2.05rem; color:#ff4343;}
.mEvt109103 .lineup .date::before {position:absolute; top:0; bottom:0; left:0; width:4.8%; height:.5rem; margin:auto; background:#ff4343; content:' ';}
.mEvt109103 .lineup .item-list li {position:relative;}
.mEvt109103 .lineup .item-list button {position:absolute; left:54%; bottom:9%; width:11.6rem; height:2.73rem; font-size:1.28rem;}
.mEvt109103 .lineup .item-list .btn-soldout {color:#222; background:#cfcfcf;}
.mEvt109103 .lineup .item-list .btn-buy {color:#fff; background:#222;}
.mEvt109103 .lineup .item-list .btn-coming {color:#222; background:#ffe536;}

.mEvt109103 .count {position:relative; padding-top:17%; text-align:center; background:#ff4343;}
.mEvt109103 .count .txt {display:inline-block; min-width:15rem; height:3.3rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.54rem; line-height:3.4rem; color:#212121; background:#ffde00; border-radius:.43rem;}
.mEvt109103 .count .time {margin:1rem 0 2rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:5.12rem; color:#fff;}
.mEvt109103 .notice {position:relative; padding-bottom:7%; text-align:center; background:#222;}
.mEvt109103 .txt {display:none; padding-bottom:3%;}

.mEvt109103 .oneday {position:relative; min-height:22rem; padding-bottom:10%; background:#eaeaea url(//webimage.10x10.co.kr/fixevent/event/2021/109103/m/bg_oneday.jpg) no-repeat center top / 100% auto;}
.mEvt109103 .oneday .list li {padding:2rem 0;}
.mEvt109103 .oneday .list li a {display:block; position:relative; padding:0 5.3%;}
.mEvt109103 .oneday .list .desc {padding-top:1rem;}
.mEvt109103 .oneday .list .name {width:75%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.7rem; line-height:1.4; color:#222;}
.mEvt109103 .oneday .list .price {margin-top:1rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.7rem; color:#222;}
.mEvt109103 .oneday .list .price s {font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif; font-size:1.28rem; color:#999;}
.mEvt109103 .oneday .list .price span {margin-left:.3em; color:#ff4343;}
.mEvt109103 .oneday .list .limit {position:absolute; bottom:15%; left:74%; width:24.7vw; z-index:10;}

.mEvt109103 .lyr {display:none; position:fixed; top:0; left:0; z-index:30; width:100vw; height:100vh;}
.mEvt109103 .lyr .inner {position:relative; overflow-y:scroll; height:100%;}
.mEvt109103 .lyr .btn-close {position:absolute; top:0; right:0; z-index:10; width:16vw; height:16vw; font-size:0; background:none;}
.mEvt109103 .lyr-push {background:rgba(0,0,0,.9);}
.mEvt109103 .lyr-push .form {display:flex; position:absolute; top:39%; right:0; left:0; width:70%; margin:auto; border-bottom:2px solid #ffe536;}
.mEvt109103 .lyr-push .form input {flex:1; padding:0; font-size:1.45rem; color:#fff; border:none; background:none;}
.mEvt109103 .lyr-push .form input::placeholder {color:#b1b1b1;}
.mEvt109103 .lyr-push .form .btn-submit {font-size:1.45rem; color:#ffe536; background:none;}
.mEvt109103 .lyr-lineup {background:#ff4343;}
.mEvt109103 .lyr-lineup .inner {padding-bottom:10%;}
.mEvt109103 .lyr-lineup .btn-close {background:url(//webimage.10x10.co.kr/fixevent/event/2021/109103/m/btn_close.png) no-repeat center / 6vw;}
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
$(function() {
	// 유의사항
	$('.mEvt109103 .btn-notice').on('click', function(e) {
		$(this).next('.txt').slideToggle();
	});
	// 알림 신청 팝업
	$('.mEvt109103 .btn-push').on('click', function(e) {
		$('.mEvt109103 .lyr-push').fadeIn();
	});
	// 라인업 팝업
	$('.mEvt109103 .btn-lineup').on('click', function(e) {
		$('.mEvt109103 .lyr-lineup').fadeIn();
	});
	// 팝업 닫기
	$('.mEvt109103 .btn-close').on('click', function(e) {
		$(this).closest('.lyr').fadeOut();
	});
    $("#phone").keyup(function(){
        var keyID = event.which;
        if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 46 || keyID == 37 || keyID == 39) {
            return;
        }
        else {
            alert("숫자만 입력 가능합니다.");
            this.value = this.value.replace(/[^0-9\.]/g, '');
        }
    });
    <%'// MD상품 리스트%>
    <% If currentDate >= #01/25/2021 00:00:00# and currentDate < #01/26/2021 00:00:00# Then %>
        <% IF application("Svr_Info") = "Dev" THEN %>
            codeGrp = [3308296,3224816]; // 01/25
        <% Else %>
            codeGrp = [3574890,3510974,2954778,2872320,2791964,3058886,3576026,1961209,2949372,2711008,3577006,1635303,2231319,3379881,1729204,1881434,3577010,1950813,1797306,2140265]; // 01/25
        <% End If %>
    <% elseIf currentDate >= #01/26/2021 00:00:00# and currentDate < #01/27/2021 00:00:00# Then %>
        <% IF application("Svr_Info") = "Dev" THEN %>            
            codeGrp = [3192537,3366566,3309445];  // 01/26
        <% Else %>
            codeGrp = [3574530,3510970,2872321,2954778,3542890,3058886,3577007,3577011,3545475,2352187,2949376,1635304,1937695,3379881,1490081,2370482,2512727,3576026,3080131,2711006];  // 01/26
        <% End If %>
    <% elseIf currentDate >= #01/27/2021 00:00:00# and currentDate < #01/28/2021 00:00:00# Then %>
        <% IF application("Svr_Info") = "Dev" THEN %>            
            codeGrp = [3366565,2578588,3243012,3291068];  // 01/27
        <% Else %>
            codeGrp = [3575157,2791972,3371232,3207685,2946985,3058886,3577009,3400283,3379835,2949999,1721240,1635305,2231319,3379881,3576026,3080132,2711011,2584390,3577153,3577012];  // 01/27                
        <% End If %>
    <% End If %>

    var $rootEl = $("#itemList")
    var itemEle = tmpEl = ""
    $rootEl.empty();

    codeGrp.forEach(function(item){
        tmpEl = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="thumbnail"><img src="" alt=""></div>\
                        <span class="limit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/txt_limit.png" alt="한정수량"></span>\
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
});

function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function fnSendToKakaoMessage() {
    <%'// 이벤트 진행일자를 제외하곤 신청안됨 %>
    <% If (left(currentDate, 10) < "2021-01-25" Or left(currentDate, 10) > "2021-01-27") Then %> 
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
        url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript109103.asp",
        data: "mode=kamsg&testCheckDate=<%=currentDate%>&phoneNumber="+btoa(phoneNumber),
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
            url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript109103.asp",
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

function fnAlert(obj){
    if(obj==1){
        alert('준비된 수량이 소진되었습니다.');
    }else{
        alert('아직 오픈되지 않은 상품입니다. 오픈 시간을 기다려주세요!');
    }
}
</script>
			<div class="mEvt109103">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/tit_time_sale.jpg" alt="선착순 타임세일"></h2>
                    <% If currentDate >= #01/25/2021 00:00:00# and currentDate < #01/27/2021 00:00:00# Then %>
					<button class="btn-push"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/btn_push.png" alt="내일 알림 신청"></button>
                    <% End If %>
				</div>
				<!-- 알림 신청 팝업 -->
				<div class="lyr lyr-push" style="display:none">
					<button type="button" class="btn-close">닫기</button>
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/txt_push.png" alt="알림 신청"></p>
						<div class="form">
							<input type="number" id="phone" placeholder="휴대폰 번호를 입력해주세요" maxlength="11" oninput="maxLengthCheck(this)">
							<button type="button" class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button>
						</div>
					</div>
				</div>
				<div class="lineup">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/tit_lineup.png" alt="오늘의 선착순 라인업"></h3>
                    <%' <!-- 날짜별 라인업 --> %>
                    <%'<!-- for dev msg : 1월 25일 --> %>
                    <% If currentDate >= #01/25/2021 00:00:00# and currentDate < #01/26/2021 00:00:00# Then %>
					<div class="date">1월 25일</div>
					<ul class="item-list">
                        <%'<!-- 25일 10:00시 오픈 --> %>
                        <% 
                            Dim episode1Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode1Itemid = "3369941"
                            Else
                                episode1Itemid = "3577689"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item1_1.jpg" alt="10:00">
                            <% If episode="1" Then %>
                                <% If getitemlimitcnt(episode1Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/25/2021 10:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
                        <%'<!-- 25일 15:00시 오픈 --> %>
                        <% 
                            Dim episode2Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode2Itemid = "3369942"
                            Else
                                episode2Itemid = "3573760"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item1_2.jpg" alt="15:00">
                            <% If episode="2" Then %>
                                <% If getitemlimitcnt(episode2Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/25/2021 15:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
                        <%'<!-- 25일 18:00시 오픈 -->%>
                        <% 
                            Dim episode3Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode3Itemid = "3369943"
                            Else
                                episode3Itemid = "3573757"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item1_3.jpg" alt="18:00">
                            <% If episode="3" Then %>
                                <% If getitemlimitcnt(episode3Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/25/2021 18:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
					</ul>
                    <% End If %>
                    <%'<!-- for dev msg : 1월 26일 --> %>
                    <% If currentDate >= #01/26/2021 00:00:00# and currentDate < #01/27/2021 00:00:00# Then %>
					<div class="date">1월 26일</div>
					<ul class="item-list">
                        <%'<!-- 26일 10:00시 오픈 --> %>
                        <% 
                            Dim episode4Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode4Itemid = "3369944"
                            Else
                                episode4Itemid = "3577707"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item2_1.jpg" alt="10:00">
                            <% If episode="4" Then %>
                                <% If getitemlimitcnt(episode4Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/26/2021 10:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
                        <%'<!-- 26일 15:00시 오픈 --> %>
                        <% 
                            Dim episode5Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode5Itemid = "3369945"
                            Else
                                episode5Itemid = "3577713"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item2_2.jpg" alt="15:00">
                            <% If episode="5" Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                            <% End If %>
						</li>
                        <%'<!-- 26일 18:00시 오픈 --> %>
                        <% 
                            Dim episode6Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode6Itemid = "3369947"
                            Else
                                episode6Itemid = "3573758"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item2_3.jpg" alt="18:00">
                            <% If episode="6" Then %>
                                <% If getitemlimitcnt(episode6Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/26/2021 18:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
					</ul>
                    <% End If %>
                    <%'<!-- for dev msg : 1월 27일 --> %>
                    <% If currentDate >= #01/27/2021 00:00:00# and currentDate < #01/28/2021 00:00:00# Then %>
					<div class="date">1월 27일</div>
					<ul class="item-list">
                        <%'<!-- 27일 10:00시 오픈 --> %>
                        <% 
                            Dim episode7Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode7Itemid = "3369948"
                            Else
                                episode7Itemid = "3573761"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item3_1.jpg" alt="10:00">
                            <% If episode="7" Then %>
                                <% If getitemlimitcnt(episode7Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/27/2021 10:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
                        <%'<!-- 27일 15:00시 오픈 --> %>
                        <% 
                            Dim episode8Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode8Itemid = "3369949"
                            Else
                                episode8Itemid = "3577718"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item3_2.jpg" alt="15:00">
                            <% If episode="8" Then %>
                                <% If getitemlimitcnt(episode8Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/27/2021 15:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
                        <%'<!-- 27일 18:00시 오픈 --> %>
                        <% 
                            Dim episode9Itemid
                            IF application("Svr_Info") = "Dev" THEN
                                episode9Itemid = "3369950"
                            Else
                                episode9Itemid = "3573759"
                            End If
                        %>
						<li>
							<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/img_item3_3.jpg" alt="18:00">
                            <% If episode="9" Then %>
                                <% If getitemlimitcnt(episode9Itemid) < 1 Then %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% Else %>
                                    <button class="btn-buy" onclick="goDirOrdItem();">구매하기</button>
                                <% End If %>
                            <% Else %>
                                <% If currentDate < #01/27/2021 18:00:00# Then %>
                                    <button class="btn-coming" onclick="fnAlert(2)">오픈예정</button>
                                <% Else %>
                                    <button class="btn-soldout" onclick="fnAlert(1)">선착순 마감</button>
                                <% End If %>
                            <% End If %>
						</li>
					</ul>
                    <% End If %>
				</div>
				<div class="count">
					<span class="txt"><%=evtCountTimeText%></span>
					<div class="time" id="countdown">00:00:00</div>
					<button class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/btn_lineup.png" alt="라인업 자세히 보기"></button>
				</div>
				<!-- 라인업 팝업 -->
				<div class="lyr lyr-lineup" style="display:none">
					<button type="button" class="btn-close">닫기</button>
					<div class="inner">
						<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/pop_lineup_tit.png" alt="선착순 라인업"></h3>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/pop_lineup_01.jpg" alt=""></p>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/pop_lineup_02.jpg" alt=""></p>
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/pop_lineup_03.jpg" alt=""></p>
					</div>
				</div>
				<div class="notice">
					<button class="btn-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/btn_notice.png" alt="이벤트 유의사항"></button>
					<div class="txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/txt_notice_v2.png" alt=""></div>
				</div>
				<div class="oneday">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/tit_oneday.png" alt="오늘의 원데이 특가 라인업"></h3>
					<% if currentTime >= Cdate("10:00:00") then %>
                    <div class="list">
						<ul id="itemList"></ul>
                        <ul>
							<li>
								<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108689');return false;">
									<div class="thumbnail">
										<img src="http://thumbnail.10x10.co.kr/webimage/image/basic/278/B002787719-3.jpg" alt="">
									</div>
									<div class="desc">
										<p class="name">Lovely ValenTIME Day</p>
									</div>
								</a>
							</li>
                            <li>
								<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108651');return false;">
									<div class="thumbnail">
										<img src="http://thumbnail.10x10.co.kr/webimage/image/basic/204/B002044905-6.jpg" alt="">
									</div>
									<div class="desc">
										<p class="name">2021 텐텐 오프닝</p>
									</div>
								</a>
							</li>
                            <li>
								<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108551');return false;">
									<div class="thumbnail">
										<img src="http://thumbnail.10x10.co.kr/webimage/image/basic/220/B002208942-1.jpg" alt="">
									</div>
									<div class="desc">
										<p class="name">2021 10X10 손(手)물세트</p>
									</div>
								</a>
							</li>
                        </ul>
					</div>
                    <% else %>
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/txt_oneday.png" alt="오전 10시부터 공개됩니다"></p>
                    <% end if %>
				</div>
				<!-- 기획전 링크 -->
				<a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=109136');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/109103/m/bnr_evt.jpg" alt="">
				</a>
			</div>
<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
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
' Description : 2021 타임세일
' History : 2021-10-06 정태훈 생성
'####################################################

dim isAdmin : isAdmin = false '// 관리자 여부
dim currentType '// 1이면 실제 진행상황, 0이면 준비 단계
dim currentTime '// 현재 시간
dim mktTest '// 테스트 여부
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt, evtCode
dim isItem, currentDate
dim totalPrice , salePercentString , couponPercentString , totalSalePercent
dim oTimeSale , isSoldOut , RemainCount
dim episode '// 일자별 회차로 보면 될듯..
dim sqlStr, evtCountTimeDate, evtCountTimeText, mdItemRound
Dim episode1Itemid, episode2Itemid, episode3Itemid, episode4Itemid, episode5Itemid
dim episode6Itemid, episode7Itemid, episode8Itemid, episode9Itemid, episode10Itemid
dim mdItemsArr

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "109398"
    evtCode = "109397"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "114434"
    evtCode = "114433"
    mktTest = true
Else
	eCode = "114434"
    evtCode = "114433"
    mktTest = false
End If

if mktTest then
    '// 테스트용
    if request("testCheckDate")<>"" then
        currentDate = CDate(request("testCheckDate"))
    else
        currentDate = CDate("2021-10-12 09:00:00")
    end if
    currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
end if

'// 타임세일 기간 이후엔 해당 페이지로 접근 하면 티저 페이지로 자동으로 redirect 시켜줌
If Left(currentDate,10) < "2021-10-12" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" & evtCode
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=" & evtCode
        response.end
    End If
End If

'// 각 일자별 타임세일 진행여부를 episode로 정함
If currentTime >= #09:00:00# and currentTime < #12:00:00# Then
    '// 09시 진행
    episode=1
elseIf currentTime >= #12:00:00# and currentTime < #15:00:00# Then
    '// 12시 진행
    episode=2
elseIf currentTime >= #15:00:00# and currentTime < #18:00:00# Then
    '// 15시 진행
    episode=3
elseIf currentTime >= #18:00:00# Then
    '// 18시 진행
    episode=4
else
    episode=0
end if

'엠디 상품 오픈 차수
If currentDate >= #2021-10-12 09:00:00# and currentDate < #2021-10-13 00:00:00# Then
    mdItemRound = 1
    if episode = 2 then
        mdItemsArr = "4123821,4124110,4027991,4027347,4125972,4125448,4085637,4125853,4125946,4120905"
    elseif episode = 3 then
        mdItemsArr = "4027347,4125972,4125448,4085637,4125853,4125946,4120905,4123821,4124110,4027991"
    elseif episode = 4 then
        mdItemsArr = "4085637,4125853,4125946,4120905,4123821,4124110,4027991,4027347,4125972,4125448"
    else
        mdItemsArr = "4120905,4123821,4124110,4027991,4027347,4125972,4125448,4085637,4125853,4125946"
    end if
elseIf currentDate >= #2021-10-14 09:00:00# and currentDate < #2021-10-15 00:00:00# Then
    mdItemRound = 2
    if episode = 2 then
        mdItemsArr = "3896747,3531352,3894095,3812529,3900627,3893866,3900847,3896980,3900877,3900683"
    elseif episode = 3 then
        mdItemsArr = "3812529,3900627,3893866,3900847,3896980,3900877,3900683,3896747,3531352,3894095"
    elseif episode = 4 then
        mdItemsArr = "3900847,3896980,3900877,3900683,3896747,3531352,3894095,3812529,3900627,3893866"
    else
        mdItemsArr = "3896980,3900877,3900683,3896747,3531352,3894095,3812529,3900627,3893866,3900847"
    end if
end if

Dim gaparamChkVal, evtDate
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If currentTime < #09:00:00# Then
    evtDate = CDate(left(currentDate,10)&" 09:00:00")
    evtCountTimeText = "세일 오픈까지"
else
    if episode=1 then
        evtDate = CDate(left(currentDate,10)&" 12:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=2 then
        evtDate = CDate(left(currentDate,10)&" 15:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=3 then
        evtDate = CDate(left(currentDate,10)&" 18:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=4 then
        evtDate = DateAdd("d",1,left(currentDate,10))
        evtCountTimeText = "세일 종료까지"
    end if
end if
%>
<style type="text/css">
.time-ing .top button {background-color:transparent;}
.time-ing .top {position:relative;}
.time-ing .top .sale-timer {position:absolute; bottom:19%; left:7%; color:#fff; font-size:5.21rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.time-ing .top .btn-push {display:inline-block; position:fixed; top:116vw; right:0; z-index:10; width:25.3%;}
.time-ing .top .tit-ready {position:absolute; left:7%; bottom:35.5%; color:#fff; font-size:1.52rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

.show-time-current {position:absolute; right:-10%; top:40%;}
.show-time-current .time-current-wrap {display:flex;}
.show-time-current .time-current-wrap div {margin:0 0.56rem;}
.show-time-current .time-current-wrap img {width:14.13vw; height:13.86vw;}

.list-wrap {background:#fafafa;}
.list-wrap .special-item {position:relative; height:43.48rem; background:#fff;}
.list-wrap .special-item .list {position:absolute; right:0; top:-6%; width:calc(100% - 2.65rem); padding-bottom:5rem; border-bottom:1px solid #6d6d6d;}
.list-wrap .special-item a {display:inline-block; position:relative;}
.list-wrap .special-item .thum {width:30rem; height:25.22rem;}
.list-wrap .special-item .list li.sold-out {position:relative;}
.list-wrap .special-item .list li.sold-out:after,
.list-wrap .special-item .list li.sold-out:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:calc(100% + 1.1vw); content:'';}
.list-wrap .special-item .list li.sold-out:before {width:9.4rem; height:9.4rem; top:8rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/txt_sold_out.png)no-repeat 50% 50% / 100% 100%;}
.list-wrap .special-item .list li.sold-out .product-inner .thum {position:relative; width:30rem; height:25.22rem;}
.list-wrap .special-item .list li.sold-out .product-inner .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; background-color:rgb(243, 243, 243); opacity:0.6;}

.list-wrap .special-item .list li.not-open {position:relative;}
.list-wrap .special-item .list li.not-open:after,
.list-wrap .special-item .list li.not-open:before {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:calc(100% + 1.1vw); content:'';}
.list-wrap .special-item .list li.not-open:before {width:9.4rem; height:9.4rem; top:8rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111787/m/txt_not_open.png)no-repeat 50% 50% / 100% 100%;}
.list-wrap .special-item .list li.not-open .product-inner .thum {position:relative; width:30rem; height:25.22rem;}
.list-wrap .special-item .list li.not-open .product-inner .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; background-color:rgb(243, 243, 243); opacity:0.6;}

.list-wrap .special-item .desc {width:20rem; height:6rem; margin-top:1.73rem;}
/* 2021-04-01 수정 */
.list-wrap .special-item .desc .name {display:-webkit-box; width:100%; height:3.7rem; padding-right:0.5rem; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow:ellipsis; -webkit-line-clamp:2; word-break:break-all;}
.list-wrap .special-item .desc .price {display:flex; align-items:baseline; top:4.9rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
.list-wrap .special-item .desc .buy_now{width:20.5vw;position:relative;bottom:2.5rem;left:21rem;}
/* // */
.list-wrap .special-item .desc .price s {top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
.list-wrap .special-item .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}
.list-wrap .special-item .desc .price .p-won {margin-left:0.69rem; font-size:1.30rem; color:#111; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.list-wrap .special-item .product-inner {position:relative;}
.list-wrap .special-item .product-inner .num-limite {position:absolute; top:-3%; right:2%; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
.list-wrap .special-item .product-inner .num-limite em {font-size:1.65rem;}
.list-wrap .special-item .txt-noti {position:absolute; left:0.7rem; top:39.5rem; font-size:1rem; color:#9c9c9c; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

.list-wrap #itemList {display:flex; flex-direction:column; align-items:flex-end; width:calc(100% - 2.60rem); margin-left:2.60rem;padding:5rem 0;}
.list-wrap #itemList li {width:calc(100% - 2rem);}
.list-wrap .desc {position:relative; height:7.5rem; margin-top:2.45rem; margin-bottom:3.33rem;} /* 03-26 수정 */
.list-wrap .thumbnail {position:relative; width:100%; height:85.625vw; }
.list-wrap .thumbnail .num-limite{display:inline-block; position:absolute; bottom:-15px; left:0; z-index:11; width:115px; height:38px; line-height:38px; font-size:20px; color:#fff; text-align:center; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111787/img_limit_num.png?v=4) no-repeat 50% 50%/100%;}
.list-wrap .thumbnail .num-limite em {font-size:20px;}
/* md상품 영역 수정 */
/* 1줄일 때 */
.list-wrap .desc.line_01 .name {font-size: 1.8rem; line-height: 1.8; color: #111; font-family: 'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3.2rem;}/* 03-26 수정 */
.list-wrap .desc.line_01 .price {position:absolute; left:0; top:4.5rem; margin-top:.8rem; font-size:1.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';} /* 03-26 수정 */
.list-wrap .desc.line_01 .price s {position:absolute; left:0; top:-1rem; font-size:1.17rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.list-wrap .desc.line_01 .price span {display:inline-block; margin-left:1.1rem; font-size:2.17rem; color:#ff0943;}
/* 2줄일 때 */
.list-wrap .desc.line_02 .name {font-size: 1.8rem; line-height: 1.2; color: #111; font-family: 'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3.2rem;}/* 03-26 수정 */
.list-wrap .desc.line_02 .price {position:absolute; left:0; top:5.5rem; margin-top:.8rem; font-size:1.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';} /* 03-26 수정 */
.list-wrap .desc.line_02 .price s {position:absolute; left:0; top:-1rem; font-size:1.17rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.list-wrap .desc.line_02 .price span {display:inline-block; margin-left:1.1rem; font-size:2.17rem; color:#ff0943;}
/* // md상품 영역 수정 */

.ready_list_wrap {background:#fff;}
.product-list {padding-bottom:10rem;}
.product-list .product-inner {position:relative; margin-left:2.60rem;}
.product-list .product-inner .num-limite {position:absolute; bottom:-3%; right:0; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
.product-list .product-inner .num-limite em {font-size:1.65rem;}
.product-list .desc .name {position:absolute; left:1.73rem; top:19.5rem; width:90%; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
.product-list .desc .price {position:absolute; left:1.73rem; top:24rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
.product-list .desc .price s {position:absolute; left:0; top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
.product-list .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}

.teaser-timer {position:relative;}
.teaser-timer .sale-timer {position:absolute; bottom:49%; left:7%; color:#fff; font-size:4.78rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.teaser-timer .btn-push {width:21.74rem; height:6.08rem; position:absolute; left:5%; bottom:13%; background:transparent;}

/* 쿠폰영역 생성 */
.coupon-area{position:relative;}
.coupon-area a.go-coupon{width:100%;height:14rem;display:block;position:absolute;bottom:0;}
/* // 쿠폰영역 생성 */

.sold-out-list {padding-bottom:3rem;}
.sold-out-list .slide-area {margin-left:2.60rem;}
.sold-out-list .sold-prd {display:flex; width:11.74rem;}
.sold-out-list .sold-prd .thum {position:relative; width:11.74rem;}
.sold-out-list .sold-prd .tit-prd {width:inherit;}
.sold-out-list .desc {position:relative; padding-bottom:4rem; margin:0.5rem 0 0 0.5rem;}
.sold-out-list .desc .name {overflow:hidden; font-size:1.13rem; line-height:1.2; color:#797979; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; white-space:nowrap; text-overflow:ellipsis;}
.sold-out-list .desc .price {display:flex; align-items:baseline; position:absolute; left:0; top:2.5rem; display:flex; margin-top:.8rem; font-size:1.34rem; color:#6a6a6a; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; opacity:0;}
.sold-out-list .desc .price s {position:absolute; left:0; top:-1.3rem; font-size:0.95rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.sold-out-list .desc .price span {display:inline-block; margin-left:0.47rem; color:#000; font-size:1.30rem;}
.sold-out-list .desc .price .p-won {margin-left:1px; font-size:1.3rem; color:#6a6a6a; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.sold-out-list .sold-prd.sold-out .price {opacity:1;}
.sold-out-list .sold-prd.sold-out .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:11.74rem; height:12.35rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_dim_sold.png) no-repeat 0 0; background-size:100%;}
.sold-out-list li.sold-out .thum:after {position:absolute; left:6%; top:75%; display:inline-block; font-size:1.08rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';}
.sold-out-list li:nth-child(1).sold-out .thum:after {content:"오전 9시"; }
.sold-out-list li:nth-child(2).sold-out .thum:after {content:"오후 12시"; left:4%;}
.sold-out-list li:nth-child(3).sold-out .thum:after {content:"오후 3시"; left:4%;}
.sold-out-list li:nth-child(4).sold-out .thum:after {content:"오후 6시"; left:4%;}

.noti-area .btn-noti {position:relative;}
.noti-area .btn-noti.on span img {transform:rotate(180deg);}
.noti-area .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform:translate(590%,0);}
.noti-area .noti-info {display:none;}
.noti-area .noti-info.on {display:block;}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .inner {padding-top:6rem;}
.lyr .btn-close {position:absolute; top:6.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem;}
.lyr-alarm .input-box input {width:100%; height:3rem; padding:0; background-color:transparent; border:0; border-bottom:solid 3px #acfe25; border-radius:0; color:#fff; font-size:1.56rem; text-align:left;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; height:3rem; margin-left:-1px; color:#acfe25; border-bottom:solid 3px #acfe25; font-size:1.47rem; background:transparent;}
.lyr-alarm .input-box input::placeholder {font-size:1.47rem; color:#b7b7b7; text-align:left;}
</style>
<script type="text/javascript" src="/event/lib/countdown.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_110063.js"></script>
<script>
countDownTimer("<%=Year(evtDate)%>"
                , "<%=TwoNumber(Month(evtDate))%>"
                , "<%=TwoNumber(Day(evtDate))%>"
                , "<%=TwoNumber(hour(evtDate))%>"
                , "<%=TwoNumber(minute(evtDate))%>"
                , "<%=TwoNumber(Second(evtDate))%>"
                , new Date(<%=Year(currentDate)%>, <%=Month(currentDate)-1%>, <%=Day(currentDate)%>, <%=Hour(currentDate)%>, <%=Minute(currentDate)%>, <%=Second(currentDate)%>)
                );
$(function () {
    // 슬라이더
    var swiper = new Swiper(".sold-out-list .swiper-container", {
        speed: 500,
        slidesPerView:"auto",
        spaceBetween:20,
        loop:false
    });

    // 알림받기 레이어
    $('.btn-push').click(function (e) { 
        $('.lyr-alarm').show();
    });
    // 레이어 닫기
    $('.btn-close').click(function (e) {
        $('.lyr').hide();
    });
    //유의사항 버튼
    $('.btn-noti').on("click",function(){
        $('.noti-info').toggleClass("on");
        $(this).toggleClass("on");
    });
    <%'// MD상품 리스트%>
    <% If mdItemRound > 0 Then %>
        var itemlistIdx = <%=mdItemRound%>
    <% IF application("Svr_Info") = "Dev" THEN %>
        codeGrp = [3308296,3224816,3217277];
    <% Else %>
        codeGrp = [<%=mdItemsArr%>];
    <% End If %>
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

function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function fnSendToKakaoMessage() {
    if ($("#phone").val() == '') {
        alert('알림 받으실 전화번호를 정확히 입력해 주세요.');
        $("#phone").focus();
        return;
    }
    var phoneNumber;
    if ($("#phone").val().length > 10) {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,7)+ "-" +$("#phone").val().substring(7,11);
    } else {
        phoneNumber = $("#phone").val().substring(0,3)+ "-" +$("#phone").val().substring(3,6)+ "-" +$("#phone").val().substring(6,10);
    }

    $.ajax({
        type:"GET",
        url:"/event/etc/doeventSubscript114434.asp",
        data: "mode=kamsg&phoneNumber="+btoa(phoneNumber),
        <% if mktTest then %>
        testdate: "<%=currentDate%>",
        <% end if %>
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
                            $('.lyr').hide();
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

function goDirOrdItem(){
    <% If Not(IsUserLoginOK) Then %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% else %>
        <% if GetLoginUserLevel=7 then %>
            alert("텐바이텐 스탭은 참여할 수 없습니다.");
            return false;
        <% end if %>
        $.ajax({
            type:"GET",
            url:"/event/etc/doeventSubscript114434.asp",
            <% if mktTest then %>
            data: "mode=order&testdate=<%=currentDate%>",
            <% else %>
            data: "mode=order",
            <% end if %>
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
                            alert("잘못된 접근 입니다.");
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
			<div class="mEvt111787 time-sale">

                <div class="time-ing">
                    <div class="top">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/img_main.jpg?v=2.1" alt="시작합니다. 오늘의 타임세일">
                        <div class="show-time-current">
                            <% if episode=1 or episode=0 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/on1.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off2.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off3.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off4.png" alt="9시 노출"></div>
                            </div>
                            <% elseif episode=2 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/on2.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off3.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off4.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_1.png" alt="12시 노출"></div>
                            </div>
                            <% elseif episode=3 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/on3.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/off4.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_1.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_2.png" alt="3시 노출"></div>
                            </div>
                            <% elseif episode=4 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/on4.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_1.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_2.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/end_3.png" alt="6시 노출"></div>
                            </div>
                            <% end if %>
                        </div>
                        <div class="tit-ready"><h2><%=evtCountTimeText%></h2></div>
                        <div class="sale-timer">
                            <div><span>-</span><span id="countdown">00:00:00</span></div>
                        </div>
                    </div>
                    <div class="list-wrap">
                        <!-- 6/7일 타임세일 상품 리스트 -->
                        <div class="special-item">
                            <ul id="list1" class="list list1">
                            <% If currentDate >= #10/12/2021 00:00:00# and currentDate < #10/13/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "4122929"
                                    episode2Itemid = "4121544"
                                    episode3Itemid = "4115708"
                                    episode4Itemid = "3687839"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a>
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202110/deal_mItemImage20211005171743.jpg" alt="LG 올레드 OLED TV 55인치"></div>
                                        <div class="desc">
                                            <p class="name">LG 올레드 OLED TV 55인치</p>
                                            <div class="price"><s>1,553,480</s> 500,000 <span class="p-won">원</span><span class="sale">68%</span></div>
                                            <p class="buy_now"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/btn_purchase.png" alt="바로 구매"></p>
                                        </div>
                                        <span class="num-limite"><em>1</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=2 then%>
                                <li class="<% If getitemlimitcnt(episode2Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode2Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202110/deal_mItemImage20211005171919.jpg" alt="[Peanuts] 스누피 샌드위치/와플메이커 TBT-0002"></div>
                                        <div class="desc">
                                            <p class="name">[Peanuts] 스누피 샌드위치/와플메이커 TBT-0002</p>
                                            <div class="price"><s>56,000</s> 9,900 <span class="p-won">원</span><span class="sale">82%</span></div>
                                        </div>
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=3 then%>
                                <li class="<% If getitemlimitcnt(episode3Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode3Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202110/deal_mItemImage20211005172107.jpg" alt="삼성전자 갤럭시탭S7 FE 12.4 WIFI 128GB 블랙"></div>
                                        <div class="desc">
                                            <p class="name">삼성전자 갤럭시탭S7 FE 12.4 WIFI 128GB 블랙</p>
                                            <div class="price"><s>719,400</s> 399,900 <span class="p-won">원</span><span class="sale">44%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=4 then%>
                                <li class="<% If getitemlimitcnt(episode4Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode4Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202110/deal_mItemImage20211005172226.jpg" alt="PS5 플레이스테이션5 플스5 디스크에디션"></div>
                                        <div class="desc">
                                            <p class="name">PS5 플레이스테이션5 플스5 디스크에디션</p>
                                            <div class="price"><s>628,000</s> 100,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                        </div>
                                        <span class="num-limite"><em>1</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #10/14/2021 00:00:00# and currentDate < #10/15/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3897254"
                                    episode2Itemid = "3896082"
                                    episode3Itemid = "3895119"
                                    episode4Itemid = "3894266"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a>
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202106/deal_mItemImage20210618164957.jpg" alt="모나미 플러스펜-60색 세트"></div>
                                        <div class="desc">
                                            <p class="name">모나미 플러스펜-60색 세트</p>
                                            <div class="price"><s>28,000</s> 3,000 <span class="p-won">원</span><span class="sale">89%</span></div>
                                            <p class="buy_now"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/btn_purchase.png" alt="바로 구매"></p>
                                        </div>
                                        <span class="num-limite"><em>100</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=2 then%>
                                <li class="<% If getitemlimitcnt(episode2Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode2Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202106/deal_mItemImage20210618165845.jpg" alt="스누피 테이블 4,900원 특가!"></div>
                                        <div class="desc">
                                            <p class="name">스누피 테이블 4,900원 특가!</p>
                                            <div class="price"><s>24,000</s> 4,900 <span class="p-won">원</span><span class="sale">80%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=3 then%>
                                <li class="<% If getitemlimitcnt(episode3Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode3Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202106/deal_mItemImage20210618170414.jpg" alt="컨테이너블랙 모듈 테이블(핑크상판)"></div>
                                        <div class="desc">
                                            <p class="name">컨테이너블랙 모듈 테이블(핑크상판)</p>
                                            <div class="price"><s>160,000</s> 19,900 <span class="p-won">원</span><span class="sale">88%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=4 then%>
                                <li class="<% If getitemlimitcnt(episode4Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode4Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mItemImage/202106/deal_mItemImage20210618170747.jpg" alt="삼성 공식인증점 전자레인지 MS23T5018AW 20년형"></div>
                                        <div class="desc">
                                            <p class="name">삼성 공식인증점 전자레인지 MS23T5018AW 20년형</p>
                                            <div class="price"><s>139,000</s> 10,000 <span class="p-won">원</span><span class="sale">93%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% end if %>
                            <p class="txt-noti">선착순 특가 상품 구매 시 하단의 '유의사항'을 참고 바랍니다.</p>
                        </div>
                        <% If mdItemRound > 0 Then %>
                        <ul id="itemList"></ul>
                        <% end if %>
                    </div>
                    <% if episode <> 4 then %>
                    <div class="ready_list_wrap">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/tit_ready.png" alt="잠시 후 오픈합니다.">
                        <div class="product-list">
                            <ul id="list2" class="list list2">
                            <% If currentDate >= #10/12/2021 00:00:00# and currentDate < #10/13/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_02.png" alt="오전 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005171919.jpg" alt="[Peanuts] 스누피 샌드위치/와플메이커 TBT-0002">
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_03.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005172107.jpg" alt="삼성전자 갤럭시탭S7 FE 12.4 WIFI 128GB 블랙">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_04.png" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202110/deal_mTzImage20211005172226.jpg" alt="PS5 플레이스테이션5 플스5 디스크에디션">
                                        <span class="num-limite"><em>1</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #10/14/2021 00:00:00# and currentDate < #10/15/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_02.png" alt="오전 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202106/deal_mTzImage20210618165845.jpg" alt="스누피 테이블 4,900원 특가!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_03.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202106/deal_mTzImage20210618170414.jpg" alt="컨테이너블랙 모듈 테이블(핑크상판)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/time_header_04.png" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/eventIMG/deal_mTzImage/202106/deal_mTzImage20210618170747.jpg" alt="삼성 공식인증점 전자레인지 MS23T5018AW 20년형">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% end if %>
                            </ul>
                        </div>
                    </div>
                    <% end if %>
                    <!-- 오늘, 지난 시간 판매 완료된 상품 리스트 -->
                    <div class="sold-out-list">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/tit_sold.png?v=3" alt="오늘, 지난시간 판매 완료된 대표 상품">
                        <div class="slide-area">
                            <div class="swiper-container">
                                <ul id="lis3" class="list list3 swiper-wrapper">
                                <% If currentDate >= #10/12/2021 00:00:00# and currentDate < #10/13/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202110/deal_mSoldoutImage20211005171743.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">LG 올레드 OLED TV 55인치</p>
                                                <div class="price"><s>1,553,480</s> 500,000 <span class="p-won">원</span><span class="sale">68%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202110/deal_mSoldoutImage20211005171919.png" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">[Peanuts] 스누피 샌드위치/와플메이커 TBT-0002</p>
                                                <div class="price"><s>56,000</s> 9,900 <span class="p-won">원</span><span class="sale">82%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202110/deal_mSoldoutImage20211005172107.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">삼성전자 갤럭시탭S7 FE 12.4 WIFI 128GB 블랙</p>
                                                <div class="price"><s>719,400</s> 399,900 <span class="p-won">원</span><span class="sale">44%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202110/deal_mSoldoutImage20211005172226.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">PS5 플레이스테이션5 플스5 디스크에디션</p>
                                                <div class="price"><s>628,000</s> 100,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #10/14/2021 00:00:00# and currentDate < #10/15/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202106/deal_mSoldoutImage20210618164957.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">모나미 플러스펜-60색 세트</p>
                                                <div class="price"><s>28,000</s> 3,000 <span class="p-won">원</span><span class="sale">89%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_soldoutImage/202106/deal_soldoutImage20210618165845.png" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">스누피 테이블 4,900원 특가!</p>
                                                <div class="price"><s>24,000</s> 4,900 <span class="p-won">원</span><span class="sale">80%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202106/deal_mSoldoutImage20210618170414.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">컨테이너블랙 모듈 테이블(핑크상판)</p>
                                                <div class="price"><s>160,000</s> 19,900 <span class="p-won">원</span><span class="sale">88%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/eventIMG/deal_mSoldoutImage/202106/deal_mSoldoutImage20210618170747.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">삼성 공식인증점 전자레인지 MS23T5018AW 20년형</p>
                                                <div class="price"><s>139,000</s> 10,000 <span class="p-won">원</span><span class="sale">93%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% end if %>
                                </ul>                               
                            </div>
                        </div>
                    </div>

                    <!-- 유의사항 -->
                    <div class="noti-area">
                        <button type="button" class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/tit_noti.jpg" alt="유의사항 확인하기"><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/icon_noti_arrow.png" alt=""></span></button>
                        <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/img_noti_info.jpg?v=2" alt="유의사항"></div>
                    </div>

                    <% If currentDate >= #10/12/2021 00:00:00# and currentDate < #10/21/2021 00:00:00# Then %>
                    <div class="teaser-timer">
                        <div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/img_left_time02.jpg" alt="다음 타임세일 시간을 잊을까봐 걱정된다면?">
                            <!-- 알림팝업 노출 버튼 -->
                            <button type="button" class="btn-push"></button>
                        </div>
                    </div>
                    <% end if %>
                    <div class="coupon-area">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111787/m/111786_m.jpg" alt="쿠폰 바로가기">
                        <% if isApp=1 then %>
                        <a href="" class="go-coupon" onClick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2');return false;"></a>
                        <% else %>
                        <a href="/my10x10/couponbook.asp?tab=2" class="go-coupon"></a>
                        <% end if %>
                    </div>
                </div>
				<div class="lyr lyr-alarm" style="display:none;">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/111786/m/txt_push.png?v=2" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
						<div class="input-box"><input type="number" id="phone" maxlength="11" oninput="maxLengthCheck(this)" placeholder="휴대폰 번호를 입력해주세요"><button type="button" class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button></div>
						<button class="btn-close"></button>
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
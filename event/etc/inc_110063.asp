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
' Description : 2021 정기세일 타임세일
' History : 2021-03-24 정태훈 생성
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
dim sqlStr, evtCountTimeDate, evtCountTimeText, mdItemRound
Dim episode1Itemid, episode2Itemid, episode3Itemid, episode4Itemid, episode5Itemid
dim episode6Itemid, episode7Itemid, episode8Itemid, episode9Itemid, episode10Itemid

mktTest = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "104333"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110063"
    mktTest = true
Else
	eCode = "110063"
    mktTest = false
End If


if mktTest then
    '// 테스트용
    if request("testCheckDate")<>"" then
        currentDate = CDate(request("testCheckDate"))
    else
        currentDate = CDate("2021-03-29 15:00:00")
    end if
    currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
else
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    currentTime = Cdate(Format00(2,hour(currentDate))&":"&Format00(2,minute(currentDate))&":"&Format00(2,second(currentDate)))
end if

'// 타임세일 기간 이후엔 해당 페이지로 접근 하면 티저 페이지로 자동으로 redirect 시켜줌
If Left(currentDate,10) < "2021-03-29" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseIf Left(currentDate,10) >= "2021-03-30" and Left(currentDate,10) < "2021-03-31" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseif Left(currentDate,10) >= "2021-04-01" and Left(currentDate,10) < "2021-04-05" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseif Left(currentDate,10) >= "2021-04-06" and Left(currentDate,10) < "2021-04-07" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseif Left(currentDate,10) >= "2021-04-08" and Left(currentDate,10) < "2021-04-12" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseif Left(currentDate,10) >= "2021-04-13" and Left(currentDate,10) < "2021-04-14" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
elseif Left(currentDate,10) >= "2021-04-15" Then
    If isApp="1" Then
        response.redirect "/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110062"
        response.end
    Else
        response.redirect "/event/eventmain.asp?eventid=110062"
        response.end
    End If
End If

'// 각 일자별 타임세일 진행여부를 episode로 정함
If currentTime >= #09:00:00# and currentTime < #10:00:00# Then
    '// 09시 진행
    episode=1
elseIf currentTime >= #10:00:00# and currentTime < #11:00:00# Then
    '// 10시 진행
    episode=2
elseIf currentTime >= #11:00:00# and currentTime < #12:00:00# Then
    '// 11시 진행
    episode=3
elseIf currentTime >= #12:00:00# and currentTime < #13:00:00# Then
    '// 12시 진행
    episode=4
elseIf currentTime >= #13:00:00# and currentTime < #14:00:00# Then
    '// 13시 진행
    episode=5
elseIf currentTime >= #14:00:00# and currentTime < #15:00:00# Then
    '// 14시 진행
    episode=6
elseIf currentTime >= #15:00:00# and currentTime < #16:00:00# Then
    '// 15시 진행
    episode=7
elseIf currentTime >= #16:00:00# and currentTime < #17:00:00# Then
    '// 16시 진행
    episode=8
elseIf currentTime >= #17:00:00# and currentTime < #18:00:00# Then
    '// 17시 진행
    episode=9
elseIf currentTime >= #18:00:00# Then
    '// 18시 진행
    episode=10
else
    episode=0
end if

'엠디 상품 오픈 차수
If currentDate >= #2021-03-29 09:00:00# and currentDate < #2021-03-30 00:00:00# Then
    mdItemRound = 1
elseIf currentDate >= #2021-03-31 09:00:00# and currentDate < #2021-04-01 00:00:00# Then
    mdItemRound = 2
elseIf currentDate >= #2021-04-05 09:00:00# and currentDate < #2021-04-06 00:00:00# Then
    mdItemRound = 3
elseIf currentDate >= #2021-04-07 09:00:00# and currentDate < #2021-04-08 00:00:00# Then
    mdItemRound = 4
elseIf currentDate >= #2021-04-12 09:00:00# and currentDate < #2021-04-13 00:00:00# Then
    mdItemRound = 5
elseIf currentDate >= #2021-04-14 09:00:00# and currentDate < #2021-04-15 00:00:00# Then
    mdItemRound = 6
else
    mdItemRound = 0
end if

Dim gaparamChkVal, evtDate
gaparamChkVal = requestCheckVar(request("gaparam"),30)
If currentTime < #09:00:00# Then
    evtDate = CDate(left(currentDate,10)&" 09:00:00")
    evtCountTimeText = "세일 오픈까지"
else
    if episode=1 then
        evtDate = CDate(left(currentDate,10)&" 10:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=2 then
        evtDate = CDate(left(currentDate,10)&" 11:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=3 then
        evtDate = CDate(left(currentDate,10)&" 12:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=4 then
        evtDate = CDate(left(currentDate,10)&" 13:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=5 then
        evtDate = CDate(left(currentDate,10)&" 14:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=6 then
        evtDate = CDate(left(currentDate,10)&" 15:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=7 then
        evtDate = CDate(left(currentDate,10)&" 16:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=8 then
        evtDate = CDate(left(currentDate,10)&" 17:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=9 then
        evtDate = CDate(left(currentDate,10)&" 18:00:00")
        evtCountTimeText = "다음 특가상품 까지"
    elseif episode=10 then
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

.list-wrap {background:#fff;}
.list-wrap .special-item {position:relative; height:36.48rem; background:#fff;}
.list-wrap .special-item .list {position:absolute; right:0; top:-6%; width:calc(100% - 2.65rem); padding-bottom:2rem; border-bottom:1px solid #6d6d6d;}
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
.list-wrap .special-item .list li.not-open:before {width:9.4rem; height:9.4rem; top:8rem; left:50%; z-index:20; margin-left:-4.72rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/txt_not_open.png)no-repeat 50% 50% / 100% 100%;}
.list-wrap .special-item .list li.not-open .product-inner .thum {position:relative; width:30rem; height:25.22rem;}
.list-wrap .special-item .list li.not-open .product-inner .thum:before {content:""; position:absolute; left:0; top:0; display:inline-block; width:100%; height:100%; background-color:rgb(243, 243, 243); opacity:0.6;}

.list-wrap .special-item .desc {width:30rem; height:6rem; margin-top:1.73rem;}
/* 2021-04-01 수정 */
.list-wrap .special-item .desc .name {display:-webkit-box; width:100%; height:3.7rem; padding-right:0.5rem; overflow:hidden; font-size:1.60rem; line-height:1.2; color:#111; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow:ellipsis; -webkit-line-clamp:2; word-break:break-all;}
.list-wrap .special-item .desc .price {display:flex; align-items:baseline; top:4.9rem; font:normal 2.17rem 'CoreSansCBold','NotoSansKRBold'; color:#111;}
/* // */
.list-wrap .special-item .desc .price s {top:-1.5rem; font-size:1.51rem; font-family:'CoreSansCLight','NotoSansKRRegular'; color:#888;}
.list-wrap .special-item .desc .price span {display:inline-block; margin-left:1.1rem; color:#ff0943; font-size:2.60rem;}
.list-wrap .special-item .desc .price .p-won {margin-left:0.69rem; font-size:1.30rem; color:#111; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.list-wrap .special-item .product-inner {position:relative;}
.list-wrap .special-item .product-inner .num-limite {position:absolute; bottom:20%; right:2%; z-index:10; width:8.78rem; height:2.78rem; padding-left:0.6rem; font-size:1.39rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#fff; text-align:center; line-height:3rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_limit_sold02.png) no-repeat 0 0; background-size:100%; content:'';}
.list-wrap .special-item .product-inner .num-limite em {font-size:1.65rem;}
.list-wrap .special-item .txt-noti {position:absolute; left:2.7rem; top:34.5rem; font-size:1rem; color:#9c9c9c; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}

.list-wrap #itemList {display:flex; flex-wrap:wrap; justify-content:space-between; width:calc(100% - 2.60rem); margin-left:2.60rem;}
.list-wrap #itemList li {width:calc(50% - 0.44rem);}
.list-wrap #itemList li:nth-child(odd) {margin-right:0.22rem;}
.list-wrap #itemList li:nth-child(even) {margin-left:0.22rem;}
.list-wrap .desc {position:relative; height:7.5rem; margin-top:1.45rem; margin-bottom:3.33rem;} /* 03-26 수정 */
.list-wrap .thumbnail {position:relative; width:100%; height:44.33vw; overflow:hidden;}
.list-wrap .desc .name {overflow: hidden; font-size: 1.30rem; line-height: 1.26; color: #111; font-family: 'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; height: 3.2rem;}/* 03-26 수정 */
.list-wrap .desc .price {position:absolute; left:0; top:4.5rem; margin-top:.8rem; font-size:1.56rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';} /* 03-26 수정 */
.list-wrap .desc .price s {position:absolute; left:0; top:-1rem; font-size:1.17rem; color:#888; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.list-wrap .desc .price span {display:inline-block; margin-left:1.1rem; font-size:2.17rem; color:#ff0943;}

.ready_list_wrap {background:#f5ffef;}
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
.sold-out-list li:nth-child(2).sold-out .thum:after {content:"오전 10시"; left:4%;}
.sold-out-list li:nth-child(3).sold-out .thum:after {content:"오전 11시"; left:4%;}
.sold-out-list li:nth-child(4).sold-out .thum:after {content:"오전 12시"; left:4%;}
.sold-out-list li:nth-child(5).sold-out .thum:after {content:"오후 1시";}
.sold-out-list li:nth-child(6).sold-out .thum:after {content:"오후 2시";}
.sold-out-list li:nth-child(7).sold-out .thum:after {content:"오후 3시";}
.sold-out-list li:nth-child(8).sold-out .thum:after {content:"오후 4시";}
.sold-out-list li:nth-child(9).sold-out .thum:after {content:"오후 5시";}
.sold-out-list li:nth-child(10).sold-out .thum:after {content:"오후 6시";}

.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .inner {padding-top:6rem;}
.lyr .btn-close {position:absolute; top:6.77rem; right:8%; width:1.92rem; height:1.92rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98151/m/btn_close.png) 50% 50%/100%;}
.lyr-alarm p {padding-top:7.98rem;}
.lyr-alarm .input-box {display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem;}
.lyr-alarm .input-box input {width:100%; height:3rem; padding:0; background-color:transparent; border:0; border-bottom:solid 3px #acfe25; border-radius:0; color:#fff; font-size:1.56rem; text-align:left;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; height:3rem; margin-left:-1px; color:#acfe25; border-bottom:solid 3px #acfe25; font-size:1.47rem; background:transparent;}
.lyr-alarm .input-box input::placeholder {font-size:1.47rem; color:#b7b7b7; text-align:left;}

.noti-area .btn-noti {position:relative;}
.noti-area .btn-noti.on span img {transform:rotate(180deg);}
.noti-area .btn-noti span {display:inline-block; width:1.04rem; height:0.56rem; position:absolute; left:50%; top:4.3rem; transform:translate(590%,0);}
.noti-area .noti-info {display:none;}
.noti-area .noti-info.on {display:block;}
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
        switch (itemlistIdx) {
            case 1 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [2784156,3713160,2445376,3714730,3719949,3713191,3713235,3392874,3715333,3715357,3717103,1675624,3721756,3627086,3499920,3715177,3715178,3707877,3334701,3714987,3719563,3709053,3713665,3701738,3715392,3717046,3709254,3717759,3718892,3715296]; // 03/29
                <% End If %>
                break;
            case 2 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [3019218,2785591,3112335,3515169,3713237,3722483,3653624,3542993,1658911,3720690,3028467,3677258,3717104,3724856,3624071,3724842,3724750,3723868,3723708,3724855,3723943,3722261,3479722,3721327,3721484,3722536,3721352,3723782,3722476,3722477]; // 03/29
                <% End If %>
                break;
            case 3 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [3586683,3112336,3313868,3725279,3713207,3701047,3723725,3730683,3730788,2845156,3735075,3722593,3735070,3731979,3395017,3735675,3735817,3734582,3735016,3733949,3734090,3105471,3733036,3734106,3725566,3734685,3734805,3735017,3731748,3680542]; // 04/05
                <% End If %>
                break;
            case 4 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [3471382,2445377,3649588,3738332,3740894,3742619,2344728,3735599,3735600,3735673,3653730,3722263,2267937,3709356,2650788,3746426,3746938,3742482,3742421,3736163,3279723,3733952,3741272,3742394,3745706,3744964,1674450,3746907,3534319,2763970]; // 04/07 작업 전
                <% End If %>
                break;
            case 5 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [3590032,3019191,2819537,3753483,3747612,3747625,3752508,3748203,3720691,3748227,3752867,2264717,3752895,3641502,2461284,3753996,3753997,3753057,3753100,3754596,3754597,2813891,3753045,3753739,3753042,3752134,3752191,3753847,3725082,3753866]; // 04/07 작업 전
                <% End If %>
                break;
            case 6 :
                <% IF application("Svr_Info") = "Dev" THEN %>
                    codeGrp = [3308296,3224816,3217277]; // 03/29
                <% Else %>
                    codeGrp = [3155558,3759102,3759103,3759104,3722483,3721825,3759597,3751614,3751598,3751581,3759909,3760007,3760063,3761476,3592972,3746426,3760206,3759140,3710637,3759940,3760119,3754803,3759234,3760103,3759128,3755104,3760149,3753884,3645489,3753886]; // 04/14 작업 전
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
        url:"/event/etc/doeventSubscript110063.asp",
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

function goDirOrdItem() {
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
            url:"/event/etc/doeventSubscript110063.asp",
            data: "mode=order",
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
			<div class="mEvt104371 time-sale">
                <div class="time-ing">
                    <div class="top">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_main.jpg?v=2.1" alt="시작합니다. 오늘의 타임세일">
                        <div class="show-time-current">
                            <% if episode=1 or episode=0 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_9.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_10.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_11.png" alt="9시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_12.png" alt="9시 노출"></div>
                            </div>
                            <% elseif episode=2 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_10.png" alt="10시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_11.png" alt="10시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_12.png" alt="10시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_1.png" alt="10시 노출"></div>
                            </div>
                            <% elseif episode=3 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_11.png" alt="11시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_12.png" alt="11시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_1.png" alt="11시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_2.png" alt="11시 노출"></div>
                            </div>
                            <% elseif episode=4 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_12.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_1.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_2.png" alt="12시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_3.png" alt="12시 노출"></div>
                            </div>
                            <% elseif episode=5 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_1.png" alt="1시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_2.png" alt="1시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_3.png" alt="1시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_4.png" alt="1시 노출"></div>
                            </div>
                            <% elseif episode=6 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_2.png" alt="2시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_3.png" alt="2시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_4.png" alt="2시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_5.png" alt="2시 노출"></div>
                            </div>
                            <% elseif episode=7 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_3.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_4.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_5.png" alt="3시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_6.png" alt="3시 노출"></div>
                            </div>
                            <% elseif episode=8 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_4.png" alt="4시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_5.png" alt="4시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_6.png" alt="4시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_9.png" alt="4시 노출"></div>
                            </div>
                            <% elseif episode=9 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_5.png" alt="5시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_off_6.png" alt="5시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_9.png" alt="5시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_10.png" alt="5시 노출"></div>
                            </div>
                            <% elseif episode=10 then%>
                            <div class="time-current-wrap">
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_on_6.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_9.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_10.png" alt="6시 노출"></div>
                                <div><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_ready_11.png" alt="6시 노출"></div>
                            </div>
                            <% end if %>
                        </div>
                        <div class="tit-ready"><h2><%=evtCountTimeText%></h2></div>
                        <div class="sale-timer">
                            <div><span>-</span><span id="countdown">00:00:00</span></div>
                        </div>
                    </div>
                    <div class="list-wrap">
                        <div class="special-item">
                            <ul id="list1" class="list list1">
                            <% If currentDate >= #03/29/2021 00:00:00# and currentDate < #03/30/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3713161"
                                    episode2Itemid = "3715297"
                                    episode3Itemid = "3708341"
                                    episode4Itemid = "3690021"
                                    episode5Itemid = "3714968"
                                    episode6Itemid = "3715334"
                                    episode7Itemid = "3713169"
                                    episode8Itemid = "3715328"
                                    episode9Itemid = "3715002"
                                    episode10Itemid = "3701844"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_01.jpg" alt="[Peanuts] 스누피 레트로 토스터기"></div>
                                        <div class="desc">
                                            <p class="name">스누피 레트로 토스터기 단돈 990원 !</p>
                                            <div class="price"><s>69,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_02.jpg" alt="드롱기 네스프레소 이니시아 EN80 크림화이트"></div>
                                        <div class="desc">
                                            <p class="name">드롱기 네스프레소 이니시아 EN80 크림화이트</p>
                                            <div class="price"><s>117,000</s> 10,000 <span class="p-won">원</span><span class="sale">91%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_03.jpg" alt="모나미 플러스펜-60색 세트"></div>
                                        <div class="desc">
                                            <p class="name">모나미 플러스펜-60색 세트</p>
                                            <div class="price"><s>28,000</s> 1,000 <span class="p-won">원</span><span class="sale">96%</span></div>
                                        </div>
                                        <span class="num-limite"><em>300</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_04.jpg" alt="[다이슨] 에어랩 스타일러 볼륨앤쉐이프"></div>
                                        <div class="desc">
                                            <p class="name">[다이슨] 에어랩 스타일러 볼륨앤쉐이프</p>
                                            <div class="price"><s>590,000</s> 290,000 <span class="p-won">원</span><span class="sale">51%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_05.jpg" alt="[티파니앤코] 리턴 투 티파니 목걸이"></div>
                                        <div class="desc">
                                            <p class="name">[티파니앤코] 리턴 투 티파니 목걸이</p>
                                            <div class="price"><s>659,000</s> 35,900 <span class="p-won">원</span><span class="sale">95%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_06.jpg" alt="21SS 메종키츠네 폭스헤드 패치 티셔츠 (남성/블랙) AM00103KJ0008 B"></div>
                                        <div class="desc">
                                            <p class="name">메종키츠네 폭스헤드 티셔츠 BLACK L</p>
                                            <div class="price"><s>129,000</s> 19,900 <span class="p-won">원</span><span class="sale">85%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_07.jpg" alt="AU테크 레드윙 블랙 36V 10Ah 8인치 전동킥보드"></div>
                                        <div class="desc">
                                            <p class="name">AU테크 레드윙 블랙 36V 10Ah 8인치 전동킥보드</p>
                                            <div class="price"><s>329,000</s> 49,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_08.jpg" alt="구찌 443127 GG 마몬트 마틀라세 카드홀더 핑크"></div>
                                        <div class="desc">
                                            <p class="name">[구찌] GG 마몬트 마틀라세 카드지갑_핑크</p>
                                            <div class="price"><s>339,000</s> 49,000 <span class="p-won">원</span><span class="sale">86%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_09.jpg" alt="정관장 에브리타임 밸런스(10ml*30포)"></div>
                                        <div class="desc">
                                            <p class="name">[정관장] 홍삼정 에브리타임 밸런스 10mlx30포</p>
                                            <div class="price"><s>75,000</s> 8,900 <span class="p-won">원</span><span class="sale">88%</span></div>
                                        </div>
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_01_10.jpg" alt="애플 에어팟 프로"></div>
                                        <div class="desc">
                                            <p class="name">애플 에어팟 프로</p>
                                            <div class="price"><s>329,000</s> 49,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #03/31/2021 00:00:00# and currentDate < #04/01/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3713643"
                                    episode2Itemid = "3731023"
                                    episode3Itemid = "3708348"
                                    episode4Itemid = "3715298"
                                    episode5Itemid = "3714963"
                                    episode6Itemid = "3715197"
                                    episode7Itemid = "3709143"
                                    episode8Itemid = "3713170"
                                    episode9Itemid = "3715332"
                                    episode10Itemid = "3717425"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_01.jpg" alt="[디즈니] 미녀와야수_Tea Pot set (티팟+찻잔2인조)"></div>
                                        <div class="desc">
                                            <p class="name">미녀와야수 Tea Pot set 를 990원에 구매 !</p>
                                            <div class="price"><s>150,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_02.jpg?v=1.2" alt="[Peanuts] 스누피 샌드위치/와플메이커"></div>
                                        <div class="desc">
                                            <p class="name">품절대란, 스누피 샌드위치/와플메이커 990원 특가!</p>
                                            <div class="price"><s>56,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_03.jpg" alt="on the table 펜케이스 (new color)"></div>
                                        <div class="desc">
                                            <p class="name">on the table 펜케이스 (new color)</p>
                                            <div class="price"><s>16,800</s> 1,900 <span class="p-won">원</span><span class="sale">89%</span></div>
                                        </div>
                                        <span class="num-limite"><em>200</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_04.jpg" alt="[다이슨] 싸이클론 V10 플러피 오리진 무선 청소기"></div>
                                        <div class="desc">
                                            <p class="name">[다이슨] 싸이클론 V10 플러피 오리진 무선 청소기</p>
                                            <div class="price"><s>799,000</s> 299,000 <span class="p-won">원</span><span class="sale">63%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_05.jpg" alt="[구찌] TRADEMARK 실버 네크리스"></div>
                                        <div class="desc">
                                            <p class="name">[구찌] TRADEMARK 실버 네크리스</p>
                                            <div class="price"><s>290,000</s> 24,900 <span class="p-won">원</span><span class="sale">91%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_06.jpg" alt="갤럭시 버즈 프로  바이올렛"></div>
                                        <div class="desc">
                                            <p class="name">갤럭시 버즈 프로  바이올렛</p>
                                            <div class="price"><s>239,800</s> 39,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_07.jpg" alt="[딥디크] 롬보르 단 로 리미티드 EDT 100ml [BH] (선물포장가능)"></div>
                                        <div class="desc">
                                            <p class="name">[딥디크] 롬보르 단 로 리미티드 EDT 100ml </p>
                                            <div class="price"><s>196,000</s> 19,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_08.jpg" alt="첨스 폴딩 웨건_love&peace"></div>
                                        <div class="desc">
                                            <p class="name">첨스 폴딩 웨건_love&peace</p>
                                            <div class="price"><s>179,000</s> 29,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_09.jpg" alt="프라다 사피아노 남성카드지갑 블랙 2MC223"></div>
                                        <div class="desc">
                                            <p class="name">프라다 사피아노 남성 카드지갑_블랙</p>
                                            <div class="price"><s>290,000</s> 34,000 <span class="p-won">원</span><span class="sale">88%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_02_10.jpg" alt="게이밍 의자 GC001 울프"></div>
                                        <div class="desc">
                                            <p class="name">게이밍 의자 GC001 울프</p>
                                            <div class="price"><s>193,100</s> 39,000 <span class="p-won">원</span><span class="sale">80%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/05/2021 00:00:00# and currentDate < #04/06/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3718849"
                                    episode2Itemid = "3686950"
                                    episode3Itemid = "3709144"
                                    episode4Itemid = "3721795"
                                    episode5Itemid = "3725107"
                                    episode6Itemid = "3721797"
                                    episode7Itemid = "3718165"
                                    episode8Itemid = "3722309"
                                    episode9Itemid = "3730632"
                                    episode10Itemid = "3725215"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_01.jpg" alt="21SS 아미 스몰 하트로고 맨투맨 (블랙) BFHJ007 730 001"></div>
                                        <div class="desc">
                                            <p class="name">아미 스몰 하트로고 맨투맨 BLACK L</p>
                                            <div class="price"><s>312,000</s> 29,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_02.jpg?v=1.2" alt="[다이슨] 슈퍼소닉 헤어 드라이기 HD-03 (아이언핑크)"></div>
                                        <div class="desc">
                                            <p class="name">[다이슨] 슈퍼소닉 헤어 드라이기 HD-03 (아이언핑크)</p>
                                            <div class="price"><s>449,000</s> 99,000 <span class="p-won">원</span><span class="sale">78%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_03.jpg" alt="[조말론] 잉글리쉬페어 앤 프리지아 코롱 100ml"></div>
                                        <div class="desc">
                                            <p class="name">[조말론] 잉글리쉬페어 앤 프리지아 코롱 100ml</p>
                                            <div class="price"><s>186,000</s> 19,900 <span class="p-won">원</span><span class="sale">89%</span></div>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_04.jpg" alt="정기배송 1달 다이어트도시락 패키지 (총 24팩)"></div>
                                        <div class="desc">
                                            <p class="name">홀리셔스 몸매관리 도시락 6종 정기배송 (총24팩)</p>
                                            <div class="price"><s>132,000</s> 5,900 <span class="p-won">원</span><span class="sale">96%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_05.jpg" alt="닌텐도 스위치 동물의 숲 에디션 + 모여봐요 동물의 숲 세트"></div>
                                        <div class="desc">
                                            <p class="name">닌텐도 스위치 동물의 숲 에디션 + 모여봐요 동물의 숲 세트</p>
                                            <div class="price"><s>424,800</s> 99,000 <span class="p-won">원</span><span class="sale">77%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_06.jpg" alt="정관장 에브리타임 밸런스(10ml*20포)"></div>
                                        <div class="desc">
                                            <p class="name">[정관장] 홍삼정 에브리타임 밸런스 10mlx20포</p>
                                            <div class="price"><s>52,000</s> 6,900 <span class="p-won">원</span><span class="sale">87%</span></div>
                                        </div>
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_07.jpg" alt="[BRAUN] 브라운 전기면도기 시리즈6 (60-B4200CS+CC(세척스테이션))"></div>
                                        <div class="desc">
                                            <p class="name">[BRAUN] 브라운 전기면도기 시리즈6</p>
                                            <div class="price"><s>260,000</s> 29,900 <span class="p-won">원</span><span class="sale">89%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_08.jpg" alt="뱀부 원목 2단 수납장"></div>
                                        <div class="desc">
                                            <p class="name">뱀부 원목 2단 수납장</p>
                                            <div class="price"><s>65,900</s> 19,000 <span class="p-won">원</span><span class="sale">71%</span></div>
                                        </div>
                                        <span class="num-limite"><em>15</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_09.jpg" alt="발렌시아가 21SS 로고 카드지갑 637130 1IZI1M 1090"></div>
                                        <div class="desc">
                                            <p class="name">발렌시아가 로고 카드지갑</p>
                                            <div class="price"><s>295,000</s> 38,000 <span class="p-won">원</span><span class="sale">87%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_03_10.jpg" alt="[Sanrio] 헬로키티 칼도마살균기"></div>
                                        <div class="desc">
                                            <p class="name">신상! 헬로키티 칼도마살균기를 990원에 구매!</p>
                                            <div class="price"><s>120,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/07/2021 00:00:00# and currentDate < #04/08/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3741794"
                                    episode2Itemid = "3717297"
                                    episode3Itemid = "3731986"
                                    episode4Itemid = "3741793"
                                    episode5Itemid = "3731934"
                                    episode6Itemid = "3738663"
                                    episode7Itemid = "3742256"
                                    episode8Itemid = "3738635"
                                    episode9Itemid = "3742255"
                                    episode10Itemid = "3738453"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_01.jpg" alt="버버리 호스페리 프린트 캔버스 크로스백"></div>
                                        <div class="desc">
                                            <p class="name">버버리 호스페리 프린트 캔버스 크로스백</p>
                                            <div class="price"><s>1,071,000</s> 240,000 <span class="p-won">원</span><span class="sale">78%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_02.jpg?v=1.2" alt="[커블체어] 바른자세교정 서포트체어 와이더 (색상랜덤)"></div>
                                        <div class="desc">
                                            <p class="name">[커블체어] 바른자세교정 서포트체어 와이더 (색상랜덤)</p>
                                            <div class="price"><s>129,000</s> 9,900 <span class="p-won">원</span><span class="sale">92%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_03.jpg" alt="[타임특가] 라이브워크 리틀띵스 타이포 스티커 세트 (10장)"></div>
                                        <div class="desc">
                                            <p class="name">[타임특가] 라이브워크 리틀띵스 타이포 스티커 세트 (10장)</p>
                                            <div class="price"><s>8,800</s> 800 <span class="p-won">원</span><span class="sale">91%</span></div>
                                        </div>
                                        <span class="num-limite"><em>200</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_04.jpg" alt="갤럭시탭S7 11.0 Wi-Fi 128GB 실버"></div>
                                        <div class="desc">
                                            <p class="name">갤럭시탭S7 11.0 Wi-Fi 128GB 실버</p>
                                            <div class="price"><s>829,400</s> 350,000 <span class="p-won">원</span><span class="sale">58%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_05.jpg" alt="홀리셔스 정기배송 1달 토핑샐러드 패키지(총 20팩) /목요일 출고"></div>
                                        <div class="desc">
                                            <p class="name">홀리셔스 정기배송 1달 토핑샐러드 패키지(총 20팩) /목요일 출고</p>
                                            <div class="price"><s>132,000</s> 6,900 <span class="p-won">원</span><span class="sale">95%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_06.jpg" alt="로지텍 코리아 MK470 슬림 무선 키보드 마우스 Set 화이트"></div>
                                        <div class="desc">
                                            <p class="name">로지텍 코리아 MK470 슬림 무선 키보드 마우스 Set 화이트</p>
                                            <div class="price"><s>64,900</s> 9,900 <span class="p-won">원</span><span class="sale">85%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_07.jpg" alt="[스와로브스키] DAZZLING SWAN 블루스완 목걸이"></div>
                                        <div class="desc">
                                            <p class="name">[스와로브스키] DAZZLING SWAN 블루스완 목걸이</p>
                                            <div class="price"><s>229,000</s> 29,900 <span class="p-won">원</span><span class="sale">87%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_08.jpg" alt="[공식수입원] 발뮤다 더 퓨어 공기청정기 (화이트 컬러)"></div>
                                        <div class="desc">
                                            <p class="name">[공식수입원] 발뮤다 더 퓨어 공기청정기 (화이트 컬러)</p>
                                            <div class="price"><s>749,000</s> 199,000 <span class="p-won">원</span><span class="sale">73%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_09.jpg" alt="지누스 에센스 그린티 메모리폼 토퍼 (10.5cm/슈퍼싱글)"></div>
                                        <div class="desc">
                                            <p class="name">지누스 에센스 그린티 메모리폼 토퍼 (10.5cm/슈퍼싱글)</p>
                                            <div class="price"><s>139,000</s> 29,000 <span class="p-won">원</span><span class="sale">79%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_04_10.jpg" alt="분위기 갑! 스누피 무드등을 990원에 구매!"></div>
                                        <div class="desc">
                                            <p class="name">분위기 갑! 스누피 무드등을 990원에 구매!</p>
                                            <div class="price"><s>45,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/12/2021 00:00:00# and currentDate < #04/13/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3746914"
                                    episode2Itemid = "3746908"
                                    episode3Itemid = "3722405"
                                    episode4Itemid = "3752141"
                                    episode5Itemid = "3454935"
                                    episode6Itemid = "3742749"
                                    episode7Itemid = "3742229"
                                    episode8Itemid = "3747691"
                                    episode9Itemid = "3747692"
                                    episode10Itemid = "3738455"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_01.jpg" alt="베어브릭 라이너스 400%"></div>
                                        <div class="desc">
                                            <p class="name">베어브릭 라이너스 400%</p>
                                            <div class="price"><s>158,000</s> 29,000 <span class="p-won">원</span><span class="sale">82%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_02.jpg?v=1.2" alt="구찌 슈프림 웹 파우치 클러치백"></div>
                                        <div class="desc">
                                            <p class="name">구찌 슈프림 웹 파우치 클러치백</p>
                                            <div class="price"><s>973,000</s> 160,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_03.jpg" alt="[타임특가] 라미 만년필 한정판 사파리 캔디-바이올렛 EF"></div>
                                        <div class="desc">
                                            <p class="name">[타임특가] 라미 만년필 한정판 사파리 캔디-바이올렛 EF</p>
                                            <div class="price"><s>56,000</s> 9,900 <span class="p-won">원</span><span class="sale">82%</span></div>
                                        </div>
                                        <span class="num-limite"><em>100</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_04.jpg" alt="대폭할인! 990원에 디즈니 프린세스 찻잔세트 득템!"></div>
                                        <div class="desc">
                                            <p class="name">대폭할인! 990원에 디즈니 프린세스 찻잔세트 득템!</p>
                                            <div class="price"><s>65,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_05.jpg" alt="지누스 그린티 플러스 메모리폼 매트리스 (20cm/슈퍼싱글)"></div>
                                        <div class="desc">
                                            <p class="name">지누스 그린티 플러스 메모리폼 매트리스 (20cm/슈퍼싱글)</p>
                                            <div class="price"><s>262,800</s> 39,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_06.jpg" alt="[드롱기] 토스터기 디스틴타(화이트)"></div>
                                        <div class="desc">
                                            <p class="name">[드롱기] 토스터기 디스틴타(화이트)</p>
                                            <div class="price"><s>199,000</s> 39,900 <span class="p-won">원</span><span class="sale">80%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_07.jpg" alt="[판도라] 노티드 하트 실버 팔찌 (18호)"></div>
                                        <div class="desc">
                                            <p class="name">[판도라] 노티드 하트 실버 팔찌 (18호)</p>
                                            <div class="price"><s>182,000</s> 28,900 <span class="p-won">원</span><span class="sale">84%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_08.jpg" alt="(텐바이텐 단독오픈) 러브플라보 SET (씰스티커6종 - 씰스티커파일)"></div>
                                        <div class="desc">
                                            <p class="name">(텐바이텐 단독오픈) 러브플라보 SET (씰스티커6종 - 씰스티커파일)</p>
                                            <div class="price"><s>14,600</s> 1,000 <span class="p-won">원</span><span class="sale">93%</span></div>
                                        </div>
                                        <span class="num-limite"><em>200</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_09.jpg" alt="리트 올인원 PC 27A 확장형 64GB + SSD 240"></div>
                                        <div class="desc">
                                            <p class="name">리트 올인원 PC 27A 확장형 64GB + SSD 240</p>
                                            <div class="price"><s>489,000</s> 49,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_05_10.jpg" alt="스누피 테이블이 990원이라구?!"></div>
                                        <div class="desc">
                                            <p class="name">스누피 테이블이 990원이라구?!</p>
                                            <div class="price"><s>45,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/14/2021 00:00:00# and currentDate < #04/15/2021 00:00:00# Then %>
                                <% 
                                    episode1Itemid = "3753079"
                                    episode2Itemid = "3748354"
                                    episode3Itemid = "3731940"
                                    episode4Itemid = "3739018"
                                    episode5Itemid = "3753051"
                                    episode6Itemid = "3752204"
                                    episode7Itemid = "3754681"
                                    episode8Itemid = "3699585"
                                    episode9Itemid = "3752630"
                                    episode10Itemid = "3738469"
                                %>
                                <% if episode=1 or episode=0 then%>
                                <li class="<% if episode=0 then %>not-open<% elseIf getitemlimitcnt(episode1Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if episode=0 then%>
                                    <a href="#">
                                    <% elseif getitemlimitcnt(episode1Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_01.jpg" alt="수련 프라임 저주파 무릎 마사지기"></div>
                                        <div class="desc">
                                            <p class="name">수련 프라임 저주파 무릎 마사지기</p>
                                            <div class="price"><s>398,000</s> 39,000 <span class="p-won">원</span><span class="sale">90%</span></div>
                                        </div>
                                        <span class="num-limite"><em>10</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_02.jpg?v=1.2" alt="[타임특가] 아이코닉 샤이닝라인 투명 스티커 8종 세트"></div>
                                        <div class="desc">
                                            <p class="name">[타임특가] 아이코닉 샤이닝라인 투명 스티커 8종 세트</p>
                                            <div class="price"><s>16,000</s> 1,000 <span class="p-won">원</span><span class="sale">94%</span></div>
                                        </div>
                                        <span class="num-limite"><em>200</em>개 한정</span>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_03.jpg" alt="[1WEEK/34봉] 채소습관 클렌즈주스 1달 단기관리프로그램"></div>
                                        <div class="desc">
                                            <p class="name">[1WEEK/34봉] 채소습관 클렌즈주스 1달 단기관리프로그램</p>
                                            <div class="price"><s>128,800</s> 6,900 <span class="p-won">원</span><span class="sale">95%</span></div>
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
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_04.jpg" alt="신상! 곰돌이 푸 진공쌀통을 990원에 구매!"></div>
                                        <div class="desc">
                                            <p class="name">신상! 곰돌이 푸 진공쌀통을 990원에 구매!</p>
                                            <div class="price"><s>89,800</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=5 then%>
                                <li class="<% If getitemlimitcnt(episode5Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode5Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_05.jpg" alt="테팔 데일리쿡 인덕션 프라이팬 4종"></div>
                                        <div class="desc">
                                            <p class="name">테팔 데일리쿡 인덕션 프라이팬 4종</p>
                                            <div class="price"><s>431,000</s> 39,900 <span class="p-won">원</span><span class="sale">91%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=6 then%>
                                <li class="<% If getitemlimitcnt(episode6Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode6Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_06.jpg" alt="꼼마꼼마 산뜻비말마스크 1장에 50원! (30매)"></div>
                                        <div class="desc">
                                            <p class="name">꼼마꼼마 산뜻비말마스크 1장에 50원! (30매)</p>
                                            <div class="price"><s>15,000</s> 1,500 <span class="p-won">원</span><span class="sale">90%</span></div>
                                        </div>
                                        <span class="num-limite"><em>100</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=7 then%>
                                <li class="<% If getitemlimitcnt(episode7Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode7Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_07.jpg" alt="톰브라운 삼선 카드지갑 화이트"></div>
                                        <div class="desc">
                                            <p class="name">톰브라운 삼선 카드지갑 화이트</p>
                                            <div class="price"><s>394,000</s> 49,000 <span class="p-won">원</span><span class="sale">88%</span></div>
                                        </div>
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=8 then%>
                                <li class="<% If getitemlimitcnt(episode8Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode8Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_08.jpg" alt="루미큐브 클래식 (정품 한글라이센스판)"></div>
                                        <div class="desc">
                                            <p class="name">루미큐브 클래식 (정품 한글라이센스판)</p>
                                            <div class="price"><s>32,400</s> 1,000 <span class="p-won">원</span><span class="sale">97%</span></div>
                                        </div>
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=9 then%>
                                <li class="<% If getitemlimitcnt(episode9Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode9Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_09.jpg" alt="발뮤다 토스터기 화이트"></div>
                                        <div class="desc">
                                            <p class="name">발뮤다 토스터기 화이트</p>
                                            <div class="price"><s>339,000</s> 99,000 <span class="p-won">원</span><span class="sale">71%</span></div>
                                        </div>
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% elseif episode=10 then%>
                                <li class="<% If getitemlimitcnt(episode10Itemid) < 1 then %>sold-out<% End If %>">
                                    <% if getitemlimitcnt(episode10Itemid) < 1 then%>
                                    <a>
                                    <% else %>
                                    <a href="" onclick="goDirOrdItem();return false;">
                                    <% end if %>
                                    <div class="product-inner">
                                        <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_06_10.jpg" alt="스누피 바디필로우(L)를 990원에 구매!"></div>
                                        <div class="desc">
                                            <p class="name">스누피 바디필로우(L)를 990원에 구매!</p>
                                            <div class="price"><s>95,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                        </div>
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                    </a>
                                </li>
                                <% end if %>
                            <% end if %>
                            </ul>
                            <p class="txt-noti">선착순 특가 상품 구매 시 하단의 '유의사항'을 참고 바랍니다.</p>
                        </div>
                        <% If mdItemRound > 0 Then %>
                        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/tit_today.jpg" alt="오늘의 베스트 30개 특가 상품"></h2>
                        <ul id="itemList"></ul>
                        <% end if %>
                    </div>
                    <% if episode <> 10 then %>
                    <div class="ready_list_wrap">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/tit_ready.png" alt="잠시 후 오픈합니다.">
                        <div class="product-list">
                            <ul id="list2" class="list list2">
                            <% If currentDate >= #03/29/2021 00:00:00# and currentDate < #03/30/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_02.jpg?v=2" alt="드롱기 네스프레소 이니시아 EN80 크림화이트">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_03.jpg?v=2" alt="모나미 플러스펜-60색 세트">
                                        <span class="num-limite"><em>300</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_04.jpg?v=2" alt="[다이슨] 에어랩 스타일러 볼륨앤쉐이프">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_05.jpg?v=2" alt="[티파니앤코] 리턴 투 티파니 목걸이">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_06.jpg?v=2" alt="21SS 메종키츠네 폭스헤드 패치 티셔츠 (남성/블랙)">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_07.jpg?v=2" alt="AU테크 레드윙 블랙 36V 10Ah 8인치 전동킥보드">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_08.jpg?v=2" alt="구찌 443127 GG 마몬트 마틀라세 카드홀더 핑크">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_09.jpg?v=2" alt="정관장 에브리타임 밸런스(10ml*30포)">
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_01_10.jpg?v=2" alt="애플 에어팟 프로">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #03/31/2021 00:00:00# and currentDate < #04/01/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_02.jpg?v=2.2" alt="[Peanuts] 스누피 샌드위치/와플메이커">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_03.jpg?v=2" alt="on the table 펜케이스 (new color)">
                                        <span class="num-limite"><em>200</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_04.jpg?v=2" alt="[다이슨] 싸이클론 V10 플러피 오리진 무선 청소기">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_05.jpg?v=2" alt="[구찌] TRADEMARK 실버 네크리스">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_06.jpg?v=2" alt="갤럭시 버즈 프로  바이올렛">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_07.jpg?v=2" alt="[BRAUN] 브라운 전기면도기 시리즈6 (60-B4200CS+CC(세척스테이션))">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_08.jpg?v=2" alt="첨스 폴딩 웨건_love&peace">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_09.jpg?v=2" alt="프라다 사피아노 남성카드지갑 블랙 2MC223">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_02_10.jpg?v=2" alt="게이밍 의자 GC001 울프">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/05/2021 00:00:00# and currentDate < #04/06/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_02.jpg?v=2.2" alt="[다이슨] 슈퍼소닉 헤어 드라이기 HD-03 (아이언핑크)">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_03.jpg?v=2" alt="[조말론] 잉글리쉬페어 앤 프리지아 코롱 100ml">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_04.jpg?v=2" alt="정기배송 1달 다이어트도시락 패키지 (총 24팩)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_05.jpg?v=2" alt="닌텐도 스위치 동물의 숲 에디션 + 모여봐요 동물의 숲 세트">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_06.jpg?v=2" alt="정관장 에브리타임 밸런스(10ml*20포)">
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_07.jpg?v=2" alt="[BRAUN] 브라운 전기면도기 시리즈6 (60-B4200CS+CC(세척스테이션))">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_08.jpg?v=2" alt="뱀부 원목 2단 수납장">
                                        <span class="num-limite"><em>15</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_09.jpg?v=2" alt="발렌시아가 21SS 로고 카드지갑 637130 1IZI1M 1090">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_03_10.jpg?v=2" alt="[Sanrio] 헬로키티 칼도마살균기">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/07/2021 00:00:00# and currentDate < #04/08/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_02.jpg?v=2.2" alt="[커블체어] 바른자세교정 서포트체어 와이더 (색상랜덤)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_03.jpg?v=2" alt="[타임특가] 라이브워크 리틀띵스 타이포 스티커 세트 (10장)">
                                        <span class="num-limite"><em>200</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_04.jpg?v=2" alt="갤럭시탭S7 11.0 Wi-Fi 128GB 실버">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_05.jpg?v=2" alt="홀리셔스 정기배송 1달 토핑샐러드 패키지(총 20팩) /목요일 출고">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_06.jpg?v=2" alt="로지텍 코리아 MK470 슬림 무선 키보드 마우스 Set 화이트">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_07.jpg?v=2" alt="[스와로브스키] DAZZLING SWAN 블루스완 목걸이">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_08.jpg?v=2" alt="[공식수입원] 발뮤다 더 퓨어 공기청정기 (화이트 컬러)">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_09.jpg?v=2" alt="지누스 에센스 그린티 메모리폼 토퍼 (10.5cm/슈퍼싱글)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_04_10.jpg?v=2" alt="분위기 갑! 스누피 무드등을 990원에 구매!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/12/2021 00:00:00# and currentDate < #04/13/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_02.jpg?v=2.2" alt="구찌 슈프림 웹 파우치 클러치백">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_03.jpg?v=2" alt="[타임특가] 라미 만년필 한정판 사파리 캔디-바이올렛 EF">
                                        <span class="num-limite"><em>100</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_04.jpg?v=2.1" alt="대폭할인! 990원에 디즈니 프린세스 찻잔세트 득템!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_05.jpg?v=2" alt="지누스 그린티 플러스 메모리폼 매트리스 (20cm/슈퍼싱글)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_06.jpg?v=2" alt="[드롱기] 토스터기 디스틴타(화이트)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_07.jpg?v=2" alt="[판도라] 노티드 하트 실버 팔찌 (18호)">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_08.jpg?v=2" alt="(텐바이텐 단독오픈) 러브플라보 SET (씰스티커6종 - 씰스티커파일)">
                                        <span class="num-limite"><em>200</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_09.jpg?v=2" alt="리트 올인원 PC 27A 확장형 64GB + SSD 240">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_05_10.jpg?v=2" alt="스누피 테이블이 990원이라구?!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                            <% elseIf currentDate >= #04/14/2021 00:00:00# and currentDate < #04/15/2021 00:00:00# Then %>
                                <% if episode < 2 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_02.png" alt="오전 10시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_02.jpg?v=2.2" alt="[타임특가] 아이코닉 샤이닝라인 투명 스티커 8종 세트">
                                        <span class="num-limite"><em>200</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 3 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_03.png" alt="오전 11시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_03.jpg?v=2" alt="[1WEEK/34봉] 채소습관 클렌즈주스 1달 단기관리프로그램">
                                        <span class="num-limite"><em>10</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 4 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_04.png" alt="오후 12시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_04.jpg?v=2.1" alt="신상! 곰돌이 푸 진공쌀통을 990원에 구매!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 5 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_05.png" alt="오후 1시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_05.jpg?v=2.1" alt="테팔 데일리쿡 인덕션 프라이팬 4종">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 6 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_06.png" alt="오후 2시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_06.jpg?v=2" alt="꼼마꼼마 산뜻비말마스크 1장에 50원! (30매)">
                                        <span class="num-limite"><em>100</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 7 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_07.png" alt="오후 3시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_07.jpg?v=2" alt="톰브라운 삼선 카드지갑 화이트">
                                        <span class="num-limite"><em>3</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 8 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_08.png" alt="오후 4시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_08.jpg?v=2" alt="루미큐브 클래식 (정품 한글라이센스판)">
                                        <span class="num-limite"><em>30</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 9 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_09.png" alt="오후 5시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_09.jpg?v=2" alt="발뮤다 토스터기 화이트">
                                        <span class="num-limite"><em>5</em>개 한정</span>
                                    </div>
                                </li>
                                <% end if %>
                                <% if episode < 10 then %>
                                <li>
                                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/time_header_10.png?v=2" alt="오후 6시">
                                    <div class="product-inner">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_m_prd_06_10.jpg?v=2" alt="스누피 바디필로우(L)를 990원에 구매!">
                                        <span class="num-limite"><em>20</em>개 한정</span>
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
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/tit_sold.jpg" alt="오늘, 지난시간 판매 완료된 대표 상품">
                        <div class="slide-area">
                            <div class="swiper-container">
                                <ul id="lis3" class="list list3 swiper-wrapper">
                                <% If currentDate >= #03/29/2021 00:00:00# and currentDate < #03/30/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">스누피 레트로 토스터기 단돈 990원 !</p>
                                                <div class="price"><s>69,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_02.png" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">드롱기 네스프레소 이니시아 EN80 크림화이트</p>
                                                <div class="price"><s>117,000</s> 10,000 <span class="p-won">원</span><span class="sale">91%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">모나미 플러스펜-60색 세트</p>
                                                <div class="price"><s>28,000</s> 1,000 <span class="p-won">원</span><span class="sale">96%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">[다이슨] 에어랩 스타일러 볼륨앤쉐이프</p>
                                                <div class="price"><s>590,000</s> 290,000 <span class="p-won">원</span><span class="sale">51%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">[티파니앤코] 리턴 투 티파니 목걸이</p>
                                                <div class="price"><s>659,000</s> 35,900 <span class="p-won">원</span><span class="sale">95%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">메종키츠네 폭스헤드 티셔츠 BLACK L</p>
                                                <div class="price"><s>129,000</s> 19,900 <span class="p-won">원</span><span class="sale">85%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">AU테크 레드윙 블랙 36V 10Ah 8인치 전동킥보드</p>
                                                <div class="price"><s>329,000</s> 49,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">[구찌] GG 마몬트 마틀라세 카드지갑_핑크</p>
                                                <div class="price"><s>339,000</s> 49,000 <span class="p-won">원</span><span class="sale">86%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">[정관장] 홍삼정 에브리타임 밸런스 10mlx30포</p>
                                                <div class="price"><s>75,000</s> 8,900 <span class="p-won">원</span><span class="sale">88%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_01_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">애플 에어팟 프로</p>
                                                <div class="price"><s>329,000</s> 49,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #03/31/2021 00:00:00# and currentDate < #04/01/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">미녀와야수 Tea Pot set 를 990원에 구매 !</p>
                                                <div class="price"><s>150,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_02.png?v=2.2" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">품절대란, 스누피 샌드위치/와플메이커 990원 특가!</p>
                                                <div class="price"><s>56,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">on the table 펜케이스 (new color)</p>
                                                <div class="price"><s>16,800</s> 1,900 <span class="p-won">원</span><span class="sale">89%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">[다이슨] 싸이클론 V10 플러피 오리진 무선 청소기</p>
                                                <div class="price"><s>799,000</s> 299,000 <span class="p-won">원</span><span class="sale">63%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">[구찌] TRADEMARK 실버 네크리스</p>
                                                <div class="price"><s>290,000</s> 24,900 <span class="p-won">원</span><span class="sale">91%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">갤럭시 버즈 프로  바이올렛</p>
                                                <div class="price"><s>239,800</s> 39,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">[딥디크] 롬보르 단 로 리미티드 EDT 100ml</p>
                                                <div class="price"><s>196,000</s> 19,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">첨스 폴딩 웨건_love&peace</p>
                                                <div class="price"><s>179,000</s> 29,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">프라다 사피아노 남성 카드지갑_블랙</p>
                                                <div class="price"><s>290,000</s> 34,000 <span class="p-won">원</span><span class="sale">88%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_02_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">게이밍 의자 GC001 울프</p>
                                                <div class="price"><s>193,100</s> 39,000 <span class="p-won">원</span><span class="sale">80%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #04/05/2021 00:00:00# and currentDate < #04/06/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">아미 스몰 하트로고 맨투맨 BLACK L</p>
                                                <div class="price"><s>312,000</s> 29,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_02.png?v=2.2" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">[다이슨] 슈퍼소닉 헤어 드라이기 HD-03 (아이언핑크)</p>
                                                <div class="price"><s>449,000</s> 99,000 <span class="p-won">원</span><span class="sale">78%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">[조말론] 잉글리쉬페어 앤 프리지아 코롱 100ml</p>
                                                <div class="price"><s>186,000</s> 19,900 <span class="p-won">원</span><span class="sale">89%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">홀리셔스 몸매관리 도시락 6종 정기배송 (총24팩)</p>
                                                <div class="price"><s>132,000</s> 5,900 <span class="p-won">원</span><span class="sale">96%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">닌텐도 스위치 동물의 숲 에디션 + 모여봐요 동물의 숲 세트</p>
                                                <div class="price"><s>424,800</s> 99,000 <span class="p-won">원</span><span class="sale">77%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">[정관장] 홍삼정 에브리타임 밸런스 10mlx20포</p>
                                                <div class="price"><s>52,000</s> 6,900 <span class="p-won">원</span><span class="sale">87%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">[BRAUN] 브라운 전기면도기 시리즈6</p>
                                                <div class="price"><s>260,000</s> 29,900 <span class="p-won">원</span><span class="sale">89%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">뱀부 원목 2단 수납장</p>
                                                <div class="price"><s>65,900</s> 19,000 <span class="p-won">원</span><span class="sale">71%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">발렌시아가 로고 카드지갑</p>
                                                <div class="price"><s>295,000</s> 38,000 <span class="p-won">원</span><span class="sale">88%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_03_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">신상! 헬로키티 칼도마살균기를 990원에 구매!</p>
                                                <div class="price"><s>120,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #04/07/2021 00:00:00# and currentDate < #04/08/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">버버리 호스페리 프린트 캔버스 크로스백</p>
                                                <div class="price"><s>1,071,000</s> 240,000 <span class="p-won">원</span><span class="sale">78%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_02.png?v=2.2" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">[커블체어] 바른자세교정 서포트체어 와이더 (색상랜덤)</p>
                                                <div class="price"><s>129,000</s> 9,900 <span class="p-won">원</span><span class="sale">92%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">[타임특가] 라이브워크 리틀띵스 타이포 스티커 세트 (10장)</p>
                                                <div class="price"><s>8,800</s> 800 <span class="p-won">원</span><span class="sale">91%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">갤럭시탭S7 11.0 Wi-Fi 128GB 실버</p>
                                                <div class="price"><s>829,400</s> 350,000 <span class="p-won">원</span><span class="sale">58%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">홀리셔스 정기배송 1달 토핑샐러드 패키지(총 20팩) /목요일 출고</p>
                                                <div class="price"><s>132,000</s> 6,900 <span class="p-won">원</span><span class="sale">95%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">로지텍 코리아 MK470 슬림 무선 키보드 마우스 Set 화이트</p>
                                                <div class="price"><s>64,900</s> 9,900 <span class="p-won">원</span><span class="sale">85%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">[스와로브스키] DAZZLING SWAN 블루스완 목걸이</p>
                                                <div class="price"><s>229,000</s> 29,900 <span class="p-won">원</span><span class="sale">87%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">[공식수입원] 발뮤다 더 퓨어 공기청정기 (화이트 컬러)</p>
                                                <div class="price"><s>749,000</s> 199,000 <span class="p-won">원</span><span class="sale">73%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">지누스 에센스 그린티 메모리폼 토퍼 (10.5cm/슈퍼싱글)</p>
                                                <div class="price"><s>139,000</s> 29,000 <span class="p-won">원</span><span class="sale">79%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_04_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">분위기 갑! 스누피 무드등을 990원에 구매!</p>
                                                <div class="price"><s>45,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #04/12/2021 00:00:00# and currentDate < #04/13/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">베어브릭 라이너스 400%</p>
                                                <div class="price"><s>158,000</s> 29,000 <span class="p-won">원</span><span class="sale">82%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_02.png?v=2.2" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">구찌 슈프림 웹 파우치 클러치백</p>
                                                <div class="price"><s>973,000</s> 160,000 <span class="p-won">원</span><span class="sale">84%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">[타임특가] 라미 만년필 한정판 사파리 캔디-바이올렛 EF</p>
                                                <div class="price"><s>56,000</s> 9,900 <span class="p-won">원</span><span class="sale">82%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">대폭할인! 990원에 디즈니 프린세스 찻잔세트 득템!</p>
                                                <div class="price"><s>65,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">지누스 그린티 플러스 메모리폼 매트리스 (20cm/슈퍼싱글)</p>
                                                <div class="price"><s>262,800</s> 39,000 <span class="p-won">원</span><span class="sale">85%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">[드롱기] 토스터기 디스틴타(화이트)</p>
                                                <div class="price"><s>199,000</s> 39,900 <span class="p-won">원</span><span class="sale">80%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">[판도라] 노티드 하트 실버 팔찌 (18호)</p>
                                                <div class="price"><s>182,000</s> 28,900 <span class="p-won">원</span><span class="sale">84%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">(텐바이텐 단독오픈) 러브플라보 SET (씰스티커6종 - 씰스티커파일)</p>
                                                <div class="price"><s>14,600</s> 1,000 <span class="p-won">원</span><span class="sale">93%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">리트 올인원 PC 27A 확장형 64GB + SSD 240</p>
                                                <div class="price"><s>489,000</s> 49,900 <span class="p-won">원</span><span class="sale">90%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_05_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">스누피 테이블이 990원이라구?!</p>
                                                <div class="price"><s>45,000</s> 990 <span class="p-won">원</span><span class="sale">98%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                <% elseIf currentDate >= #04/14/2021 00:00:00# and currentDate < #04/15/2021 00:00:00# Then %>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode1Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_01.png" alt="상품1"></div>
                                            <div class="desc">
                                                <p class="name">수련 프라임 저주파 무릎 마사지기</p>
                                                <div class="price"><s>398,000</s> 39,000 <span class="p-won">원</span><span class="sale">90%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode2Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_02.png?v=2.2" alt="상품2"></div>
                                            <div class="desc">
                                                <p class="name">[타임특가] 아이코닉 샤이닝라인 투명 스티커 8종 세트</p>
                                                <div class="price"><s>16,000</s> 1,000 <span class="p-won">원</span><span class="sale">94%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode3Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_03.png" alt="상품3"></div>
                                            <div class="desc">
                                                <p class="name">[1WEEK/34봉] 채소습관 클렌즈주스 1달 단기관리프로그램</p>
                                                <div class="price"><s>128,800</s> 6,900 <span class="p-won">원</span><span class="sale">95%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode4Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_04.png" alt="상품4"></div>
                                            <div class="desc">
                                                <p class="name">신상! 곰돌이 푸 진공쌀통을 990원에 구매!</p>
                                                <div class="price"><s>89,800</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode5Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_05.png" alt="상품5"></div>
                                            <div class="desc">
                                                <p class="name">테팔 데일리쿡 인덕션 프라이팬 4종</p>
                                                <div class="price"><s>431,000</s> 39,900 <span class="p-won">원</span><span class="sale">91%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode6Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_06.png" alt="상품6"></div>
                                            <div class="desc">
                                                <p class="name">꼼마꼼마 산뜻비말마스크 1장에 50원! (30매)</p>
                                                <div class="price"><s>15,000</s> 1,500 <span class="p-won">원</span><span class="sale">90%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode7Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_07.png" alt="상품7"></div>
                                            <div class="desc">
                                                <p class="name">톰브라운 삼선 카드지갑 화이트</p>
                                                <div class="price"><s>394,000</s> 49,000 <span class="p-won">원</span><span class="sale">88%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode8Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_08.png" alt="상품8"></div>
                                            <div class="desc">
                                                <p class="name">루미큐브 클래식 (정품 한글라이센스판)</p>
                                                <div class="price"><s>32,400</s> 1,000 <span class="p-won">원</span><span class="sale">97%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode9Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_09.png" alt="상품9"></div>
                                            <div class="desc">
                                                <p class="name">발뮤다 토스터기 화이트</p>
                                                <div class="price"><s>339,000</s> 99,000 <span class="p-won">원</span><span class="sale">71%</span></div>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="swiper-slide sold-prd<% If getitemlimitcnt(episode10Itemid) < 1 then %> sold-out<% End If %>">
                                        <div class="tit-prd">
                                            <div class="thum"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/main_m_sold_06_10.png" alt="상품10"></div>
                                            <div class="desc">
                                                <p class="name">스누피 바디필로우(L)를 990원에 구매!</p>
                                                <div class="price"><s>95,000</s> 990 <span class="p-won">원</span><span class="sale">99%</span></div>
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
                        <button class="btn-noti"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/tit_noti.jpg" alt="유의사항 확인하기"><span class="arrow"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/icon_noti_arrow.png" alt=""></span></button>
                        <div class="noti-info"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_noti_info.jpg?v=3" alt="유의사항"></div>
                    </div>

                    <!-- 다음 타임세일 시작전 알림받기 -->
                    <% If currentDate >= #03/29/2021 00:00:00# and currentDate < #04/14/2021 00:00:00# Then %>
                    <div class="teaser-timer">
                        <div>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/img_left_time02.jpg" alt="다음 타임세일 시간을 잊을까봐 걱정된다면?">
                            <!-- 알림팝업 노출 버튼 -->
                            <button type="button" class="btn-push"></button>
                        </div>
                    </div>
                    <% end if %>
                </div>

                <!-- 알림받기 팝업 -->
				<div class="lyr lyr-alarm" style="display:none;">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110064/m/txt_push.png" alt="기회를 놓치지 않는 가장 확실한 방법"></p>
                        <!-- 휴대폰 번호 입력 input -->
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
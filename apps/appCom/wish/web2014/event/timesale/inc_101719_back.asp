<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 플랜B용 타임 세일
' History : 2020-03-25 정태훈 생성 - eventid = 101719
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
dim evtDate : evtDate = Cdate("2020-04-01") '// 이벤트일
'dim evtDate : evtDate = Cdate("2020-03-31") '// 이벤트일
dim isTeaser , isAdmin : isAdmin = false
dim currentType , currentTime
dim LoginUserid : LoginUserid = GetEncLoginUserID()
dim addParam , eCode , loopInt
dim isItem, moECode, currentDate
dim totalPrice , salePercentString , couponPercentString , totalSalePercent
dim oTimeSale , isSoldOut , RemainCount
dim episode : episode = requestCheckVar(request("episode"),1)

currentDate = date()

if episode = "" then
    If currentDate >= #04/01/2020 00:00:00# and currentDate < #04/02/2020 00:00:00# Then
    'If currentDate >= #03/31/2020 00:00:00# and currentDate < #04/01/2020 00:00:00# Then
        episode=1
    elseIf currentDate >= #04/02/2020 00:00:00# and currentDate < #04/03/2020 00:00:00# Then
        episode=2
    elseIf currentDate >= #04/03/2020 00:00:00# and currentDate < #04/04/2020 00:00:00# Then
        episode=3
    elseIf currentDate >= #04/04/2020 00:00:00# and currentDate < #04/06/2020 00:00:00# Then
        episode=9
    elseIf currentDate >= #04/06/2020 00:00:00# and currentDate < #04/07/2020 00:00:00# Then
        episode=4
    elseIf currentDate >= #04/07/2020 00:00:00# and currentDate < #04/08/2020 00:00:00# Then
        episode=5
    elseIf currentDate >= #04/08/2020 00:00:00# and currentDate < #04/09/2020 00:00:00# Then
        episode=6
    else
        episode=0
    end if
end if

IF application("Svr_Info") = "Dev" THEN
	eCode = "101595"
    moECode = "101594"
Else
	eCode = "101719"
    moECode = "101718"
End If

set oTimeSale = new TimeSaleCls
    oTimeSale.Fepisode = episode
    oTimeSale.FRectEvtCode = eCode
    oTimeSale.getTimeSaleItemLists



Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isapp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

'// 티져 여부
if date() = Cdate(evtDate) then 
    isTeaser = false 
else 
    isTeaser = true 
end If 

'// TEST
if LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" or LoginUserid = "jj999a" or LoginUserid = "phsman1" or LoginUserid = "jjia94" or LoginUserid = "seojb1983" or LoginUserid = "kny9480" or LoginUserid = "bestksy0527" or LoginUserid = "mame234" or LoginUserid = "corpse2" then
    if date() < Cdate(evtDate) then
        isTeaser = chkiif(requestCheckVar(request("isTeaser"),1) = "1" or requestCheckVar(request("isTeaser"),1) = "" , true , false) '// true 티져 / false 본 이벤트
        currentType = requestCheckVar(request("currentType"),1) '// 1.pm5
        isAdmin = true
        addParam = "&isAdmin=1"
    end if
end if

'// setTimer
'if isTeaser then 
    'currentTime = evtDate '// 내일기준시간
'else
    currentTime = fnGetCurrentSingleTime(fnGetCurrentSingleType(isAdmin,currentType))
'end if
'response.write currentTime
'response.end
%>
<style type="text/css">
.time-sale {position:relative; background:#fff;}
.time-sale button {background:transparent;}
.time-top {position:relative; background:#8628e5;}
.time-top .sale-timer {position:absolute; top:76%; padding-left:8%; font-size:16vw; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.time-top .btn-lineup {position:absolute; top:0; right:-5vw; width:45vw; padding-right:5vw; background:#8628e5 url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/bg_btn_lineup.jpg) repeat-x 0/contain; animation:shake 1.5s 10;}
@keyframes shake {
	0%,100% {transform:translateX(2vw); transition-timing-function:ease-out;}
	50% {transform:translateX(-.5vw); transition-timing-function:ease-in;}
}
.time-sale .btn-alarm {position:fixed; right:0; bottom:16vw; z-index:15; width:30vw;}
.time-ing .time-items {padding-top:8vw;}
.time-items li {position:relative;}
.time-items li a {display:block; padding-left:8%;}
.time-items .special-item {display:block; padding-left:8%;}
.time-items .label {position:absolute; left:-1.3vw; top:5.3vw; z-index:11; padding:2vw 3.2vw 1.3vw; font-size:3.7vw; color:#fff; background:#ae44ff; border-radius:0 .7vw .7vw 0;}
.time-items .label:after {content:' '; position:absolute; left:0; bottom:-1.3vw; width:0; height:0; border-style:solid; border-width:1.3vw 0 0 1.3vw; border-color:#6f00c3 transparent transparent transparent;}
.time-items .desc {padding:7vw 0 12vw;}
.time-items .name {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:4.9vw; line-height:1.3; word-break:break-all;}
.time-items .name .opt {margin-left:1vw; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight';}
.time-items .price {margin-top:1vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:6.8vw; letter-spacing:-.1vw;}
.time-items .price .unit {font-size:4vw; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.time-items .price s {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:4.7vw; color:#888;}
.time-items .price span {display:inline-block; position:relative; top:1vw; margin-left:5vw; font-size:8vw; color:#ff3823;}
.time-items .price span.cp {margin-left:1.5vw; color:#00a061;}
.time-items .price span.cp em {font-size:4vw;}
.time-items .sold-out:before {display:flex; justify-content:center; align-items: center; content:'판매완료'; position:absolute; top:46vw; left:54%; transform:translate(-50%,-50%); z-index:11; width:30vw; height:30vw; font-size:5vw; color:#fff; background:#6500cc; border-radius:50%;}
.time-items .sold-out:after {content:' '; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background:rgba(255,255,255,.5);}
.schedule {position:relative;}
.schedule .swiper-container {overflow:visible; position:absolute; top:29.5%; left:0; width:100%;}
.schedule .swiper-slide {width:100%;}
.schedule .pagination {position:absolute; width:100%; height:auto; padding-top:4vw;}
.schedule .pagination .swiper-pagination-switch {background:#fff; opacity:.4;}
.schedule .pagination .swiper-active-switch {opacity:1;}
.schedule .swiper-button-prev,.schedule .swiper-button-next {position:absolute; top:0; width:12%; height:100%; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/ico_slider_arrow.png) no-repeat 50%/100% auto;}
.schedule .swiper-button-prev {left:0; transform:scaleX(-1);}
.schedule .swiper-button-next {right:0;}
.ten-sns {position:relative;}
.ten-sns ul {display:flex; position:absolute; top:0; right:5%; width:30%; height:100%;}
.ten-sns ul li {width:50%; height:100%;}
.ten-sns ul li a {display:block; height:100%; text-indent:-999em;}
.lyr {display:none; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.lyr .btn-close {position:fixed; top:0; right:0; z-index:101; width:21vw; height:21vw; font-size:0; color:transparent; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_close.png) no-repeat 50%/100% auto;}
.lyr .inner {position:relative;}
.lyr-fair #notRobot1 {position:absolute; opacity:0;}
.lyr-fair #notRobot1 + label {display:block; width:100vw; height:16vw; background:url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/txt_check.png) no-repeat 0 0/100% auto;}
.lyr-fair #notRobot1:checked + label {background-position:0 100%;}
.lyr-fair .input-box1, 
.lyr-fair .btn-get1 {position:absolute; top:0; left:0;}
.lyr-alarm .input-box2 {position:absolute; top:60vw; left:8vw; display:flex; width:70vw; border-bottom:.5vw solid #cfa0ff;}
.lyr-alarm .input-box2 input {width:100%; flex:1; padding:0; font-size:4.5vw; color:#fff; background-color:transparent; border:0; border-radius:0;}
.lyr-alarm .input-box2 input::placeholder {color:#cbcbcb;}
.lyr-alarm .input-box2 .btn-submit {padding:0 3vw 1vw; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:4.5vw; color:#cfa0ff; white-space:nowrap;}

.lyr-alarm .input-box {position:absolute; display:flex; justify-content:space-between; align-items:center; width:70.67%; margin-left:8%; margin-top:5.97rem; color:#cfa0ff; font-size:1.5rem; font-weight:bold;}
.lyr-alarm .input-box input {width:33%; height:3rem; padding:0; margin:0 .2rem; background-color:transparent; border:0; border-bottom:solid .17rem #cfa0ff; border-radius:0; color:#fff; font-size:1.45rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.lyr-alarm .input-box .btn-submit {width:4.69rem; margin-left:.5rem; color:#cfa0ff; font-size:1.45rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}

.lyr-lineup {background:rgba(0,0,0,.5);}
.lyr-lineup .inner {left:5%; right:5%; width:90%; margin:5vw 0;}
.lyr-lineup .btn-close {position:absolute; width:13vw; height:13vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_close_white.png);}
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

    $(function() {
        //  페어플레이 레이어
        $('.time-items .special-item').click(function (e) {
            <% if fnGetCurrentSingleType(isAdmin,currentType) > 0 then %>
            if ($(this).hasClass("sold-out")) {
                return false;
            }
            var str = $.ajax({
                type: "GET",
                url: "/apps/appcom/wish/web2014/event/timesale/timesale_proc.asp",
                data: "mode=fair&selectnumber="+$(this).index()+"&sendCount=<%=fnGetCurrentSingleType(isAdmin,currentType)%><%=addParam%>",
                dataType: "text",
                async:false,
                cache:true,
            }).responseText;

            if(str!="") {
                $("#fairplay").empty().html(str);
                $('.lyr-fair').fadeIn();
            }
            <% else %>
            alert("타임세일 오픈 시간은 오후 6시 입니다.");
            <% end if %>
        });
        
        // 레이어 닫기
        $('.btn-close').click(function (e) {
            $('html, body').removeClass('not-scroll');
            $('.lyr').fadeOut();
            $(this).find('.time-items').fadeOut();
        });

        // 알림받기 레이어
        $('.btn-alarm').click(function (e) {
            $('.lyr-alarm').fadeIn();
        });

        // 상품 라인업 팝업
        $('.time-sale .btn-lineup').click(function(){
            $('.lyr-lineup').fadeIn();
        });

        $('.time-teaser .time-items').click(function(){
            alert("아직 이벤트가 오픈되지 않았습니다 :)")
        });
        $('.time-soon .time-items').click(function(){
            alert("아직 이벤트가 오픈되지 않았습니다. 오후 6시를 기다려주세요 :)")
        });
        var swiper = new Swiper('.schedule .swiper-container', {
            pagination: '.pagination',
            prevButton: '.swiper-button-prev',
            nextButton: '.swiper-button-next',
            speed: 700
        });
    });

    function fnBtnClose(e) {
        $('.lyr').fadeOut();
        $(this).find('.time-items').fadeOut();
    }

    //maxlength validation in input type number
    function maxLengthCheck(object){
        if (object.value.length > object.maxLength){
            object.value = object.value.slice(0, object.maxLength);
        }
    }

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
            url:"/apps/appcom/wish/web2014/event/timesale/timesale_proc.asp",
            data: "mode=kamsg&phoneNumber="+btoa(phoneNumber)+"&sendCount=<%=episode%><%=addParam%>",
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data);
                            if(result.response == "ok"){
                                alert('신청이 완료되었습니다. 다음에도 또 신청해주세요!');
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
                jsChklogin_mobile('','<%=Server.URLencode("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
                if (!document.getElementById("notRobot1").checked) {
                    alert("'나는 BOT이 아닙니다.'를 체크해주세요.");
                    return false;
                }

                $.ajax({
                    type:"GET",
                    url:"/apps/appcom/wish/web2014/event/timesale/timesale_proc.asp",
                    data: "mode=order&selectnumber="+n+"&sendCount=<%=fnGetCurrentSingleType(isAdmin,currentType)%><%=addParam%>",
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

			<div class="time-sale">
                <% if episode="0" then %>
				<%'!-- 티저 (3월 31일) --%>
				<div class="time-teaser">
                    <button type="button" class="btn-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_floating.png" alt="오픈 알림 받기"></button>
					<div class="time-top">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/tit_teaser_0401.jpg" alt="4월 1일 오후 6시 오픈"></h2>
					</div>
					<div class="time-items">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0401.jpg?v=1.0" alt="">
					</div>
				</div>
                <% elseif episode="9" then %>
				<%'!-- 티저 (4월 4~5일) --%>
				<div class="time-teaser">
                    <button type="button" class="btn-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_floating.png" alt="오픈 알림 받기"></button>
					<div class="time-top">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/tit_teaser_0406.jpg" alt="4월 6일 오후 6시 오픈"></h2>
					</div>
					<div class="time-items">
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0406.jpg?v=1.0" alt="">
					</div>
				</div>
                <% else %>
                <% If Time() >= #00:00:00# and Time() < #18:00:00# Then %>
                <% 'If Time() >= #00:00:00# and Time() < #16:00:00# Then %>
				<%'!-- 오픈전 (00:00~17:59) --%>
				<div class="time-soon">
					<div class="time-top">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/tit_time_soon.jpg" alt="세일 시작까지"></h2>
						<div class="sale-timer"><span>-</span><span id="countdown">00:00:00</span></div>
						<button type="button" class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_lineup.jpg" alt="상품 라인업 미리보기"></button>
					</div>
					<button type="button" class="btn-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_floating.png" alt="오픈 알림 받기"></button>
					<div class="time-items">
                        <% if episode="1" then %>
						<img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0401.jpg?v=1.0" alt="">
                        <% elseif episode="2" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0402.jpg?v=1.0" alt="">
                        <% elseif episode="3" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0403.jpg?v=1.1" alt="">
                        <% elseif episode="4" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0406.jpg?v=1.1" alt="">
                        <% elseif episode="5" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0407.jpg?v=1.0" alt="">
                        <% elseif episode="6" then %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_teaser_0408.jpg?v=1.1" alt="">
                        <% end if %>
					</div>
				</div>
                <% else %>
				<%'!-- 오픈후 (18:00~23:59) --%>
				<div class="time-ing">
					<div class="time-top">
						<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/tit_time_ing.jpg" alt="마감까지 남은시간"></h2>
						<div class="sale-timer"><span>-</span><span id="countdown">00:00:00</span></div>
						<button type="button" class="btn-lineup"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_lineup.jpg" alt="상품 라인업 미리보기"></button>
					</div>
					<!-- 오픈 알림 받기 플로팅버튼 -->
					<button type="button" class="btn-alarm"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/btn_floating.png" alt="오픈 알림 받기"></button>
					<div class="time-items">
						<ul>
                            <%
                            FOR loopInt = 0 TO oTimeSale.FResultCount - 1
                                call oTimeSale.FitemList(loopInt).fnItemLimitedState(isSoldOut,RemainCount)
                                call oTimeSale.FitemList(loopInt).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent)
                            %>
                            <% IF oTimeSale.FitemList(loopInt).Fsortnumber > 1 THEN %>
							<li <%=chkiif(isSoldOut , "class=""sold-out""", "")%>>
                                <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_timesale_item','idx|itemid','<%=loopInt + 2%>|<%=oTimeSale.FitemList(loopInt).Fitemid%>', function(bool){if(bool) {TnGotoProduct('<%=oTimeSale.FitemList(loopInt).Fitemid%>');}});return false;">
                            <% else %>
                            <li <%=chkiif(isSoldOut , "class=""sold-out special-item""", "class=""special-item""")%>>
                            <% END IF %>
									<div class="thumbnail">
										<img src="<%=oTimeSale.FitemList(loopInt).FprdImage%>" alt="">
                                        <% if oTimeSale.FitemList(loopInt).FlimitYn="Y" then %>
                                        <% IF oTimeSale.FitemList(loopInt).Fsortnumber > 1 THEN %>
                                        <span class="label">한정 수량</span>
                                        <% else %>
                                        <span class="label"><%=oTimeSale.FitemList(loopInt).FLimitEA%>개 한정</span>
                                        <% end if %>
                                        <% end if %>
									</div>
									<div class="desc">
										<div class="name"><%=oTimeSale.FitemList(loopInt).FcontentName%></div>
										<div class="price">
                                        <% IF oTimeSale.FitemList(loopInt).Fitemid="2793094" or oTimeSale.FitemList(loopInt).Fitemid = "2792472" THEN %>
                                            선착순 깜짝 선물
                                        <% else %>
                                            <% IF oTimeSale.FitemList(loopInt).Fitemdiv <> "21" THEN %>
                                                <s><%=formatnumber(oTimeSale.FitemList(loopInt).Forgprice,0)%></s>
                                                <%=chkiif(oTimeSale.FitemList(loopInt).Fitemdiv = "21",formatnumber(oTimeSale.FitemList(loopInt).FmasterSellCash,0)&"~",totalPrice)%><em class="unit">원</em>
                                            <% else %>
                                                <%= formatnumber(oTimeSale.FitemList(loopInt).FitemPrice,0) %>~<em class="unit">원</em>
                                            <% END IF %>
                                            <% IF oTimeSale.FitemList(loopInt).Fitemdiv = "21" THEN %>
                                                <% IF oTimeSale.FitemList(loopInt).FcouponRate > 0 THEN %><span>~<%=oTimeSale.FitemList(loopInt).FcouponRate%>%</span><% end if %>
                                            <% ELSE %>
                                                <% if totalSalePercent <> "0" then %><span><%=totalSalePercent%></span><% end if %>
                                                <% IF oTimeSale.FitemList(loopInt).IsCouponItem THEN %><span class="cp"><%=oTimeSale.FitemList(loopInt).GetCouponDiscountStr%><em>쿠폰</em></span><% end if %>
                                            <% END IF %>
                                        <% END IF %>
                                        </div>
									</div> 
                                <% IF oTimeSale.FitemList(loopInt).Fsortnumber > 1 THEN %>
								</a>
                                <% END IF %>
							</li>
                            <% NEXT %>
						</ul>
					</div>
				</div>
                <% end if %>
				<%'!-- 페어플레이 레이어 --%>
				<div class="lyr lyr-fair" id="fairplay" style="display:none"></div>
				<!-- 레이어3. 상품 라인업 미리보기 -->
				<div class="lyr lyr-lineup">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_lineup.jpg?v=1.1" alt="타임세일 스케줄"></p>
						<button type="button" class="btn-close">닫기</button>
					</div>
				</div>
                <% end if %>
				<%'!-- 알람받기 레이어 --%>
				<div class="lyr lyr-alarm" style="display:none;">
					<div class="inner">
						<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/txt_alarm_v2.png" alt="카카오 알림톡"></p>
						<div class="input-box">
							<input type="number" id="phone1" placeholder="000" maxlength="3" oninput="maxLengthCheck(this)">-<input type="number" id="phone2" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">-<input type="number" id="phone3" placeholder="0000" maxlength="4" oninput="maxLengthCheck(this)">
							<button type="button" class="btn-submit" onclick="fnSendToKakaoMessage()">확인</button>
						</div>
						<button type="button" class="btn-close" onclikc="closeLyr();">닫기</button>
					</div>
				</div>

				<%'!-- 이벤트 하단 공통 (개발X) --%>
				<div class="schedule">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/tit_schedule.jpg" alt="타임세일 스케줄"></h3>
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_1.png?v=1.0" alt="4월 1일 수요일"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_2.png?v=1.0" alt="4월 2일 목요일"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_3.png?v=1.0" alt="4월 3일 금요일"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_4.png?v=1.2" alt="4월 6일 월요일"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_5.png?v=1.0" alt="4월 7일 화요일"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/img_schedule_6.png?v=1.2" alt="4월 8일 수요일"></div>
						</div>
						<div class="pagination"></div>
						<button type="button" class="swiper-button-prev">이전</button>
						<button type="button" class="swiper-button-next">다음</button>
					</div>
				</div>
				<div class="ten-sns">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/bnr_share.jpg" alt="SNS 팔로우">
					<ul>
						<li><a href="" onclick="openbrowser('https://tenten.app.link/e/XPbHtzef84'); return false;">텐바이텐 인스타그램 바로가기</a></li>
						<li><a href="" onclick="openbrowser('https://tenten.app.link/e/gZD5hN6e84'); return false;">텐바이텐 페이스북 바로가기</a></li>
					</ul>
				</div>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/bnr_evt.jpg" alt="4월 푸시 알림 이벤트"></a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101578');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/bnr_evt_4.jpg" alt="Best Character Award"></a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/txt_noti.jpg?v=1.0" alt="이벤트 유의사항"></p>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');" target="_blank"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101719/m/bnr_evt_2.jpg?v=2" alt="2020 텐바이텐 봄 정기세일"></a>
			</div>

<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
    <input type="hidden" name="itemid" id="itemid" value="">
    <input type="hidden" name="itemoption" value="0000">
    <input type="hidden" name="itemea" readonly value="1">
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="isPresentItem" value="" />
    <input type="hidden" name="mode" value="DO3">
</form>
<%
    set oTimeSale = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
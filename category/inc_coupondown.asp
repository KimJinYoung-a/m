<%
    '// 앱쿠폰 다운 6/10 ~ 6/30
    dim appDownCouponCode, alertMsg, currentDate, appLayerImg, mwebLayerImg, bannerImg, bannerImgTxt

    currentDate = date()
    'test
    'currentDate = Cdate("2019-09-01")

    'IF application("Svr_Info") = "Dev" THEN
    '    appDownCouponCode = "2903"
    '    alertMsg = "쿠폰이 발급 되었습니다.\n발급 후 24시간 이내에 사용 가능합니다."
    'else
        if currentDate <= Cdate("2019-08-31") then
            '// 2019년 8월 1일부터 8월 5일까지 발급된 쿠폰번호
            'appDownCouponCode = "1181"
            '// 2019년 8월 5일 오후부터 발급된 쿠폰번호
            appDownCouponCode = "1183"
            alertMsg = "쿠폰이 발급되었습니다!\nAPP에서 5만원 이상 구매 시 사용 가능합니다."
            appLayerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_done_0805_app.png"
            mwebLayerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_done_0805.png"
            bannerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0816.jpg"
            bannerImgTxt = "8월 즉시 할인 쿠폰"
        end if
        if currentDate >= Cdate("2019-09-01") and currentDate <= Cdate("2019-09-30") then
            appDownCouponCode = "1203"
            alertMsg = "쿠폰이 발급되었습니다!\nAPP에서 5만원 이상 구매 시 사용 가능합니다."
            appLayerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_done_0902_app.png"
            mwebLayerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_done_0902.png"
            bannerImg = "//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0902.jpg"
            bannerImgTxt = "9월 즉시 할인 쿠폰"
        end if
    'end if
%>
<script>
    function jsEvtCouponDown(stype,idx) {
        <% If IsUserLoginOK() Then %>
            fnAmplitudeEventMultiPropertiesAction("click_appcoupondown_banner","","");

            var str = $.ajax({
                type: "POST",
                url: "/event/etc/coupon/couponshop_process.asp",
                data: "mode=cpok&stype="+stype+"&idx="+idx,
                dataType: "text",
                async: false
            }).responseText;
            var str1 = str.split("||")
            if (str1[0] == "11"){
                // alert('<%=alertMsg%>');
                $(".lyr-coupon").show();
                return false;
            }else if (str1[0] == "12"){
                alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
                return false;
            }else if (str1[0] == "13"){
                alert('이미 다운로드 받으셨습니다.');
                return false;
            }else if (str1[0] == "02"){
                alert('로그인 후 쿠폰을 받을 수 있습니다!');
                return false;
            }else if (str1[0] == "01"){
                alert('잘못된 접속입니다.');
                return false;
            }else if (str1[0] == "00"){
                alert('정상적인 경로가 아닙니다.');
                return false;
            }else{
                alert('오류가 발생했습니다.');
                return false;
            }
        <% Else %>
            jsEventLogin();
            return false;
        <% End IF %>
    }
    function linkTo(){
        fnAmplitudeEventMultiPropertiesAction("click_appcoupondown_banner","","");
        <% If IsUserLoginOK() Then %>
            <% if isApp="1" then %>
                //fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96304');return false;
                alert('8/27(화)까지 사용 가능한 쿠폰이 발급되었습니다.\n쿠폰함을 확인해주세요!');return false;
            <% else %>
                //location.href="/event/eventmain.asp?eventid=96304"
                alert('8/27(화)까지 사용 가능한 쿠폰이 발급되었습니다.\n쿠폰함을 확인해주세요!');return false;
            <% end if %>
        <% Else %>
            jsEventLogin();
            return false;
        <% End If %>
    }
    function jsEventLogin(){
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
    <% end if %>
        return;
    }
    function couponAlert(){
        <% If IsUserLoginOK() Then %>
            alert("오늘 하루만 사용 가능한 쿠폰이 발급되었습니다. 쿠폰함을 확인해주세요!");
        <% Else %>
            jsEventLogin();
            return false;
        <% End IF %>
    }
</script>
<style>
.item-etc-info ul,
.deal-item .item-etc-info p {border-top:0;}
.lyr-coupon {display:none; position:fixed; top:0; left:0; z-index:99999; width:100vw; height:100vh; background-color:rgba(91, 91, 91, 0.52)}
.lyr-coupon .inner {position:absolute; top:50%; left:0; padding:0 6.6%; transform:translateY(-50%);}
.lyr-coupon .inner .btn-area {position:absolute; bottom:0; left:6.6%; right:6.6%; height:30%;}
.lyr-coupon .inner .btn-area button {float:left; height:100%; background-color:transparent; font-size:0;}
.lyr-coupon .inner .btn-area .btn-close {width:45%;}
.lyr-coupon .inner .btn-area .btn-down {width:55%;}
</style>
<script>
$(function(){
    <% If isapp="1" Then %>
        $('.lyr-coupon').click(function(e){
            e.preventDefault();
            $(this).hide();
        });
    <% Else %>
        $('.lyr-coupon .btn-close').click(function(e){
            e.preventDefault();
            $('.lyr-coupon').hide();
        });
    <% End If %>
});
</script>
<% If currentDate >= Cdate("2019-08-26") And currentDate < Cdate("2019-08-28") Then %>
    <% If currentDate = Cdate("2019-08-26") Then %>
        <a href="javascript:void(0)" onclick="linkTo()"><img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0826.jpg" alt="coupon 40,000원 내일까지 사용 가능한 즉시 할인 쿠폰!"></a>
    <% End if %>
    <% If currentDate = Cdate("2019-08-27") Then %>
        <a href="javascript:void(0)" onclick="linkTo()"><img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0827.jpg" alt="coupon 40,000원 오늘 자정까지 즉시 할인 쿠폰!"></a>
    <% End If %>
<% else %>
    <% If currentDate >= Cdate("2019-08-28") And currentDate < Cdate("2019-08-30") Then %>
        <% If isApp="1" Then %>
            <a href="javascript:fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96941');"><img src="http://fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0828.jpg" alt="현금처럼 사용하는 3,333 마일리지"></a>
        <% Else %>
            <a href="/event/eventmain.asp?eventid=96941"><img src="http://fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0828.jpg" alt="현금처럼 사용하는 3,333 마일리지"></a>
        <% End If %>
    <% else %>
        <div onclick="jsEvtCouponDown('evtsel','<%= appDownCouponCode %>');"><img src="<%= bannerImg %>" alt="<%= bannerImgTxt %>"></div>
    <% End If %>
<% end if %>
<!-- 201090627 : 상품상세쿠폰배너 -->
<div class="lyr-coupon" style="display:none">
    <div class="inner">
        <% If isApp="1" Then %>
            <img src="<%= appLayerImg %>" alt="쿠폰이 발급되었습니다">
        <% Else %>
            <%'// 모바일 웹일경우 앱 다운로드 버튼 추가된 팝업 표시%>
            <img src="<%= mwebLayerImg %>" alt="쿠폰이 발급되었습니다">
            <div class="btn-area">
                <button type="button" class="btn-close">닫기</button>
                <button type="button" class="btn-down" onclick="window.open('https://tenten.app.link/AGtgeDMCTY');return false;">APP 다운받기</button>
            </div>
        <% End If %>
    </div>
</div>
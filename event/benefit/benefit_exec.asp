<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  혜택페이지
' History : 2019-08-13 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/benefit/NewmemberAdvantageCls.asp" -->
<%
    dim themeClass : themeClass = "bg-white"
    if IsUserLoginOK then themeClass = "bg-pink"

    dim newmemberInfoObj, couponList, mileageEvtList, i, monthCoupon, couponMin

    set newmemberInfoObj = new NewmemberAdvantageCls
    couponList = newmemberInfoObj.getAutoCouponList()
    mileageEvtList = newmemberInfoObj.getMileageEvent()

    '// 앱쿠폰 다운 6/10 ~ 6/30
    dim appDownCouponCode, alertMsg, currentDate, couponValue, couponType

    currentDate = date()
    'test
    'currentDate = Cdate("2020-12-07")

    IF application("Svr_Info") = "Dev" THEN
        appDownCouponCode = "2903"
    else
        appDownCouponCode = "1190"
    end if

	monthCoupon = getCouponInfo(appDownCouponCode)

	if IsArray(monthCoupon) then
		for i=0 to ubound(monthCoupon,2)
			couponValue = formatNumber(monthCoupon(1, i), 0)
			couponMin = formatNumber(monthCoupon(3, i), 0)
		next	
	end if

	couponType = "month"
	alertMsg = "쿠폰이 발급되었습니다!\nAPP에서 "& couponMin &"원 이상 구매 시 사용 가능합니다."
%>
<style type="text/css">
@import url(https://cdn.jsdelivr.net/npm/typeface-nanum-square@1.1.0/nanumsquare.min.css);
.benefitGuide {font-family:'Nanum Square';}
.benefitGuide .topic {position:relative; padding:3.6rem 3.24rem 3.4rem; background-image:linear-gradient(to left, #ed007c, #ed0049); margin-bottom:-0.5rem; z-index:10;}
.benefitGuide .topic:after {display:block; content:' '; position:absolute; bottom:0; left:4.13%; right:4.13%; border-top:1px dashed #5e0029;}
.benefitGuide button {display:block; width:100%; background-color:transparent; font:inherit;}
.benefitGuide h2 {font-weight:300; font-size:2.6rem; line-height:4rem; text-align:left; color:#fff;}
.benefitGuide h2 b {display:block; font-weight:900; font-size:3.7rem;}
.benefitGuide section {position:relative; padding:4.27rem 3.24rem;}
.benefitGuide .bnf-extra {padding-bottom:5.29rem;}
.benefitGuide .bg-pink {background-image: linear-gradient(to left, #ed007c, #ed0049);}
.benefitGuide .bg-white {background-color:#fff;}
.benefitGuide .bg-white + .bg-white:before {display:block; content:' '; position:absolute; top:0; left:4.13%; right:4.13%; border-top:1px dashed #68525c;}
.benefitGuide .tit-area {display:flex; align-items:center; padding-bottom:2.56rem;}
.benefitGuide .tit-area h3 {padding-bottom:0.5rem; margin-right:1.5rem; font-weight:700; font-size:2.3rem; border-bottom:0.17rem solid; white-space:nowrap;}
.benefitGuide .bg-pink .tit-area h3 {color:#fff;}
.benefitGuide .bg-white .tit-area h3 {color:#222;}
.benefitGuide .tit-area p {font-size:1.07rem; line-height:1.48;}
.benefitGuide .bg-pink .tit-area p {color:#ffc1da;}
.benefitGuide .bg-white .tit-area p {color:#888;}
.benefitGuide .bnf-now h4 {position:relative; margin:3.58rem 0 0.94rem; font-weight:700; font-size:1.4rem;}
.benefitGuide .bnf-now h4:first-child {margin-top:0;}
.benefitGuide .bnf-now h4:before {content:' '; display:inline-block; position:absolute; left:-0.8rem; top:50%; width:0.26rem; height:0.26rem; margin-top:-0.2rem; border-radius:0.3rem;}
.benefitGuide .bnf-now.bg-pink h4 {color:#ffe2ee;}
.benefitGuide .bnf-now.bg-white h4 {color:#444;}
.benefitGuide .bnf-now.bg-pink h4:before {background-color:#ffe2ee;}
.benefitGuide .bnf-now.bg-white h4:before {background-color:#444;}
.benefitGuide .cpn-list li + li {margin-top:0.85rem;}
.benefitGuide .box {display:flex; flex-direction:column; align-items:center; justify-content:center; max-width:25.51rem; height:8.19rem; margin:0 auto; text-align:center; background-repeat:no-repeat; background-position:50%; background-size:100%;}
.benefitGuide .box > span {display:block;}
.benefitGuide .box .amt {margin-bottom:-0.3rem; font-size:3.29rem; font-family:'CoreSansCMedium';}
.benefitGuide .box .amt .won {font-size:1.88rem; font-family:'Nanum Square'; font-weight:700; vertical-align:middle; margin-left:0.2rem;}
.benefitGuide .box .amt .point {font-size:2.05rem; margin-left:0.3rem;}
.benefitGuide .box .txt-info {font-size:1.07rem; margin-top:0.7rem;}
.benefitGuide .box .btn-txt {position:relative; font-size:1.07rem; border-bottom:1px solid; margin-top:0.7rem;}
.benefitGuide .box .btn-txt.ico-arrow {padding:0 1.4rem 0.2rem 0.3rem;}
.benefitGuide .box .btn-txt.ico-down {padding:0 1.8rem 0.2rem 0.3rem;}
.benefitGuide .box .btn-txt:after {content:' '; display:inline-block; position:absolute;}
.benefitGuide .box .btn-txt.ico-arrow:after {top:0.3rem; right:0.5rem; width:0.4rem; height:0.4rem; margin-top:0rem; border-width:1px 1px 0 0; border-style:solid; transform:rotate(45deg);}
.benefitGuide .box .btn-txt.ico-down:after {top:0.1rem; right:0.3rem; width:1rem; height:1rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/ico_down_pink.png) no-repeat 50% / 90%;}
.benefitGuide .box .txt-extra {font-size:2.1rem; font-weight:700;}
.benefitGuide .txt-book {font-weight:700; font-size:2.43rem;}
.benefitGuide .btn-blk {height:4.1rem; margin-top:1.28rem; background-color:#222;}
.benefitGuide a.btn-blk {display:flex; align-items:center; justify-content:center;}
.benefitGuide .bnf-join .btn-blk {height:5.3rem;}
.benefitGuide .btn-blk span {position:relative; padding-right:1.8rem; font-weight:700; font-size:1.41rem; color:#fff;}
.benefitGuide .btn-blk span:after {content:' '; position:absolute; right:0; top:50%; width:0.7rem; height:0.7rem; margin-top:-0.4rem; border-width:1px 1px 0 0; border-style:solid; border-color:#fff; transform:rotate(45deg);}
.benefitGuide .bot-txt {text-align:center; padding-top:1.2rem; font-family:'AppleSDGothicNeo-Medium','Nanum Square'; font-size:0.98rem; line-height:1.7;}
.benefitGuide .bnf-join.bg-pink .bot-txt {color:#ffc8df;}
.benefitGuide .bnf-now.bg-pink .bot-txt {color:#3d0019;}
.benefitGuide .bnf-now.bg-white .bot-txt {color:#999;}
@media (min-width:768px) { .benefitGuide .tit-area p br {display:none;} }
.benefitGuide .bnf-now.bg-white .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/btn_pink.png);}
.benefitGuide .bnf-now.bg-white .box .amt,
.benefitGuide .bnf-now.bg-white .box .txt-book {color:#fff;}
.benefitGuide .bnf-now.bg-white .box .btn-txt {color:#94003d;}
.benefitGuide .bnf-now.bg-pink .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/btn_white.png);}
.benefitGuide .bnf-now.bg-pink .box .amt,
.benefitGuide .bnf-now.bg-pink .box .txt-book {color:#222;}
.benefitGuide .bnf-now.bg-pink .box .btn-txt {color:#999;}
.benefitGuide .bnf-now.bg-white .btn-cpn {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_pink.png);}
.benefitGuide .bnf-now.bg-pink .btn-cpn {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_white.png);}
.benefitGuide .bnf-now.bg-pink .box .btn-txt.ico-down:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/ico_down_gray.png);}
.benefitGuide .bnf-now.bg-white .txt-info {color:#fff;}
.benefitGuide .bnf-now.bg-pink .txt-info {color:#222;}
.benefitGuide .bnf-now.bg-white .cpn-list .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_line_pink.png);}
.benefitGuide .bnf-now.bg-white .cpn-list .box .amt {color:#222;}
.benefitGuide .bnf-now.bg-white .cpn-list .box .txt-info {color:#999;}
.benefitGuide .bnf-now.bg-pink .cpn-list .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_line_white.png);}
.benefitGuide .bnf-now.bg-pink .cpn-list .box .amt {color:#fff;}
.benefitGuide .bnf-now.bg-pink .cpn-list .box .txt-info {color:#3d0019;}
.benefitGuide .bnf-extra .cpn-list .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_line_pink.png);}
.benefitGuide .bnf-extra .cpn-list .box .txt-extra {color:#222;}
.benefitGuide .bnf-extra .cpn-list .box .txt-info {color:#999;}
.benefitGuide .bnf-join .box {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/memberGuide/m/cpn_white.png);}
.benefitGuide .bnf-join .box .amt {color:#222;}
.benefitGuide .bnf-join .box .txt-info {color:#999;}
.benefitGuide .bnf-now .box.chai .txt-info {margin-top:.2rem;}
.benefitGuide .bnf-now .box.chai .txt-info:nth-of-type(1) {margin-bottom:.5rem}
.benefitGuide .bnf-now .box.shinhan .txt-info {margin:0 0 .5rem;}
</style>
<script>
function handleClickCoupon(stype,idx){
    <% If not IsUserLoginOK() Then %>
        jsEventLogin();
        return false;
    <% end if %>
    var str = $.ajax({
        type: "POST",
        url: "/event/etc/coupon/couponshop_process.asp",
        data: "mode=cpok&stype="+stype+"&idx="+idx,
        dataType: "text",
        async: false
    }).responseText;
    var str1 = str.split("||")
    if (str1[0] == "11"){
        fnAmplitudeEventMultiPropertiesAction("click_advtg_appcoupondown","","");
        alert('<%=alertMsg%>');
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
}
function jsEventLogin(){
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
    <% end if %>
        return;
} 
</script>
    <!-- 텐바이텐 혜택 가이드 -->
    <div class="benefitGuide">
        <div class="topic">
            <h2>텐바이텐 <b>혜택 가이드</b></h2>
        </div>				
    <% if Not(IsUserLoginOK) Then %>
        <!-- for dev msg : 로그인 시, 가입혜택 은 노출되지 않고 지금혜택 부터 노출 (지금혜택 에 클래스 bg-white 대신 bg-pink) -->
        <!-- 가입혜택 -->
        <section class="bnf-join bg-pink">
            <div class="tit-area">
                <h3>#가입혜택</h3>
                <p>새로 가입한 고객님을 위해<br>웰컴 쿠폰세트를 준비했어요</p>
            </div>
            <div class="dsc-area">
                <ul class="cpn-list">
                    <li>
                        <div class="box">
                            <span class="amt">5,000<em class="won">원</em></span>
                            <span class="txt-info">70,000원 이상 구매 시</span>
                        </div>
                    </li>
                    <li>
                        <div class="box">
                            <span class="amt">10,000<em class="won">원</em></span>
                            <span class="txt-info">150,000원 이상 구매 시</span>
                        </div>
                    </li>
                    <li>
                        <div class="box">
                            <span class="amt">30,000<em class="won">원</em></span>
                            <span class="txt-info">300,000원 이상 구매 시</span>
                        </div>
                    </li>
                </ul>
                <!-- for dev msg : 회원가입 링크 MW : https://tenten.app.link/5s7CgrtDSX
                                                                    APP : https://tenten.app.link/jQkFGUTDSX -->
                <% if isapp = 1 then %>
                <!--  <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_signup_btn', '', '', function() {fnAPPpopupBrowserURL('회원가입','https://tenten.app.link/jQkFGUTDSX');});return false;" class="btn-blk"><span>회원가입 하러 가기</span></a> -->
                <a href="#" onclick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;" class="btn-blk"><span>회원가입 하러 가기</span></a>
                <% else %>
                <!-- <a href="https://tenten.app.link/5s7CgrtDSX" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_signup_btn','','');" class="btn-blk"><span>회원가입 하러 가기</span></a> -->
                <a href="/member/join.asp" class="btn-blk"><span>회원가입 하러 가기</span></a>
                <% end if %>
                <p class="bot-txt">* 쿠폰은 가입 즉시 자동으로 발급됩니다.</p>
            </div>
        </section>
        <!--// 가입혜택 -->
    <% end if %>
        <!-- for dev msg : 로그인 시, 가입혜택 은 노출되지 않고 지금혜택 부터 노출 (지금혜택 에 클래스 bg-white 대신 bg-pink) -->
        <!-- 지금혜택 -->
        <section class="bnf-now <%=themeClass%>">
            <div class="tit-area">
                <h3>#지금혜택</h3>
                <p>지금 사용 가능한 모든 혜택<br>여기서 확인해 보세요!</p>
            </div>
            <div class="dsc-area">
                <%' 마케팅 마일리지 예산 이슈로 2020년 2월 / 3월 app 전용 쿠폰 숨김처리 이후 주석만 풀어주면 됨 2020-03-16 주석품%>
                <!-- 혜택가이드 기간 내 배너 노출 -->
                <!-- 2020-11-29 23:59:59 까지 -->
                <% if currentdate <= #11/29/2020 23:59:59# then %>
                    <h4><%=Month(Date())%>월 APP 전용 쿠폰</h4>
                    <button type="button" class="box btn-cpn" onclick="handleClickCoupon('<%=couponType%>','<%= appDownCouponCode %>')">
                        <span class="amt"><%=couponValue%><em class="won">원</em></span>
                        <span class="btn-txt ico-down">쿠폰 다운받기</span>
                    </button>
                    <% if isapp <> 1 then %>
                    <a href="https://tenten.app.link/BaHFpXGCSX" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_install_btn','','');" class="btn-blk"><span>APP 설치하기</span></a>
                    <% end if %>

                    <h4>상품 쿠폰북</h4>
                    <% if isapp = 1 then %>
                    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_couponbook_btn', '', '', function() {fnAPPpopupBrowserURL('쿠폰북','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/couponshop.asp?gaparam=trend_coupon_0','right','','sc');});return false;" class="box">
                    <% else %>
                    <a href="/shoppingtoday/couponshop.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_couponbook_btn', '', '')" class="box">
                    <% end if %>
                        <span class="txt-book">COUPON BOOK</span>
                        <span class="btn-txt ico-arrow">쿠폰북 확인하기</span>
                    </a>

                    <h4>차이 생애 첫 결제할인</h4>
                    <div class="box chai">
                        <span class="txt-info">6천 원 이상 생애 첫 결제 시</span>
                        <span class="amt">50<em>%</em></span>
                        <span class="txt-info">(최대 3천 원)</span>
                    </div>
                    <p class="bot-txt">결제 시 2.5% 적립</p>

                    <h4>신한카드x텐바이텐 혜택</h4>
                    <div class="box">
                        <span class="txt-info" style="margin-bottom:.5rem;">신한 체크카드 발급 시 (신규 고객 대상)</span>
                        <span class="amt">10,000<em class="point">P</em></span>
                    </div>
                    <p class="bot-txt">* 신한카드 Deep Dream 체크(미니언즈)</p>
                    <% if isapp = 1 then %>
                    <a onclick="fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106761');return false;" class="btn-blk">
                    <% else %>
                    <a href="/event/eventmain.asp?eventid=106761" class="btn-blk">
                    <% end if %>
                        <span>자세히 보러 가기</span>
                    </a>
                    
                <% end if %>
                <!-- 2020-11-30 00:00:00 부터 2020-12-06 23:59:59 까지 -->
                <% If currentDate >= #11/30/2020 00:00:00# and currentDate <= #12/06/2020 23:59:59# Then %>
                    <h4>텐바이텐x포커스미디어 특별혜택</h4>
                    <button type="button" class="box btn-cpn" onclick="fnNewCouponIssued('107973','1507'); return false;">
                        <span class="amt">3,000<em class="won">원</em></span>
                        <span class="btn-txt ico-down">쿠폰 다운받기</span>
                    </button>
                <% end if %>
                <!-- 2020-12-07 00:00:00 부터 -->
                <% If currentDate >= #12/07/2020 00:00:00# Then %>
                    <h4><%=Month(Date())%>월 APP 전용 쿠폰</h4>
                    <button type="button" class="box btn-cpn" onclick="handleClickCoupon('<%=couponType%>','<%= appDownCouponCode %>')">
                        <span class="amt"><%=couponValue%><em class="won">원</em></span>
                        <span class="btn-txt ico-down">쿠폰 다운받기</span>
                    </button>
                    <% if isapp <> 1 then %>
                    <a href="https://tenten.app.link/BaHFpXGCSX" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_install_btn','','');" class="btn-blk"><span>APP 설치하기</span></a>
                    <% end if %>

                    <h4>상품 쿠폰북</h4>
                    <% if isapp = 1 then %>
                    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_couponbook_btn', '', '', function() {fnAPPpopupBrowserURL('쿠폰북','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/couponshop.asp?gaparam=trend_coupon_0','right','','sc');});return false;" class="box">
                    <% else %>
                    <a href="/shoppingtoday/couponshop.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_couponbook_btn', '', '')" class="box">
                    <% end if %>
                        <span class="txt-book">COUPON BOOK</span>
                        <span class="btn-txt ico-arrow">쿠폰북 확인하기</span>
                    </a>

                    <h4>차이 생애 첫 결제할인</h4>
                    <div class="box chai">
                        <span class="txt-info">6천 원 이상 생애 첫 결제 시</span>
                        <span class="amt">50<em>%</em></span>
                        <span class="txt-info">(최대 3천 원)</span>
                    </div>
                    <p class="bot-txt">결제 시 2.5% 적립</p>

                    <!-- <h4>신한카드x텐바이텐 혜택</h4>
                    <div class="box">
                        <span class="txt-info" style="margin-bottom:.5rem;">신한 체크카드 발급 시 (신규 고객 대상)</span>
                        <span class="amt">10,000<em class="point">P</em></span>
                    </div>
                    <p class="bot-txt">* 신한카드 Deep Dream 체크(미니언즈)</p>
                    <%' if isapp = 1 then %>
                    <a onclick="fnAPPpopupBrowserURL('이벤트','<%'=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=106761');return false;" class="btn-blk">
                    <%' else %>
                    <a href="/event/eventmain.asp?eventid=106761" class="btn-blk">
                    <%' end if %>
                        <span>자세히 보러 가기</span>
                    </a> -->
                    <!-- <h4>텐바이텐x포커스미디어 특별혜택</h4>
                    <button type="button" class="box btn-cpn" onclick="fnNewCouponIssued('107973','1507'); return false;">
                        <span class="amt">3,000<em class="won">원</em></span>
                        <span class="btn-txt ico-down">쿠폰 다운받기</span>
                    </button> -->
                <% end if %>
                
                
                <%'<!-- for dev msg : 쿠폰 기간내 자동 노출 (쿠폰 이벤트를 진행하지 않는 기간엔 ‘서프라이즈 쿠폰’ 영역 자체가 노출되지 않음 -->%>
<%
    if isArray(couponList) then
    dim sdt : sdt = formatDate(couponList(3,0),"00.00") 
    dim edt : edt = formatDate(couponList(4,0),"00.00") 
    dim restDt : restDt = couponList(5,0) 
%>    
                <h4>서프라이즈 쿠폰</h4>
                <ul class="cpn-list">
                    <%'<!-- for dev msg : 쿠폰 금액, 최대 구매 금액, 사용 기간 자동 변경 -->%>
<%                    
        for i=0 to uBound(couponList,2)
%>        
                    <li>
                        <div class="box">
                            <span class="amt"><%=FormatNumber(couponList(1,i), 0)%><em class="won">원</em></span>
                            <span class="txt-info"><%=FormatNumber(couponList(2,i), 0)%>원 이상 구매 시</span>
                        </div>
                    </li>
<%
        next
%>
                </ul>
                <%'<!-- for dev msg : 내 쿠폰함 링크 (기획서에 쿠폰북으로 잘못 기재) (비로그인 시 로그인페이지) -->%>
                <% if isapp = 1 then %>
                <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_mycoupon_btn', '', '', function() {fnAPPpopupBrowserURL('사용가능한 쿠폰','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp','right','','sc');});return false;" class="btn-blk">
                <% else %>
                <a href="/my10x10/couponbook.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_mycoupon_btn', '', '')" class="btn-blk">
                <% end if %>
                    <span>쿠폰 확인하기</span>
                </a>
                <p class="bot-txt">* 사용 기간 : <%=sdt%> - <%=edt%> (<%=restDt%>일간)<br>* 로그인 시 자동 발급되는 쿠폰입니다.</p>
<%
    end if
%>
<%
    if isArray(mileageEvtList) then
%>
<%
        for i=0 to uBound(mileageEvtList,2)
%>
                <h4>마일리지</h4>
                <%'<!-- for dev msg : '3,333' 텍스트, 사용 기간, 링크 시스템 자동 변경 -->%>
                <% if isapp = 1 then %>
                    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_mileage_evt', '', '', function() {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=mileageEvtList(0,i)%>');});return false;" class="box">                    
                <% else %>
                    <a href="/event/eventmain.asp?eventid=<%=mileageEvtList(0,i)%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_advtg_mileage_evt','','')" class="box">
                <% end if %>
                    <span class="amt"><%=FormatNumber(mileageEvtList(3,i), 0)%><em class="point">M</em></span>
                    <span class="btn-txt ico-arrow">마일리지 확인하기</span>
                </a>
                <p class="bot-txt">* 사용 기간 : <%=formatDate(mileageEvtList(1,i),"00.00")%> - <%=formatDate(mileageEvtList(2,i),"00.00")%> (<%=mileageEvtList(4,i)%>일간)</p>
<%
        next
%>
<%
    end if
%>
<% If currentDate >= #09/01/2020 00:00:00# and currentDate <= #09/30/2020 23:59:59# Then %>
                <h4>토스 즉시 할인</h4>
                <div class="box shinhan">
                    <span class="txt-info">7만 원 이상 결제 시</span>
                    <span class="amt">5,000<em class="won">원</em></span>
                </div>
<% End If %>
<% If currentDate >= #10/05/2020 00:00:00# and currentDate <= #10/07/2020 23:59:59# Then %>
                <h4>신한카드 즉시 할인</h4>
                <div class="box shinhan">
                    <span class="txt-info">4만 원 이상 결제 시</span>
                    <span class="amt">3,000<em class="won">원</em></span>
                </div>
<% End If %>
<% If currentDate >= #10/12/2020 00:00:00# and currentDate <= #10/18/2020 23:59:59# Then %>
                <h4>카카오페이 즉시 할인</h4>
                <div class="box shinhan">
                    <span class="txt-info">5만 원 이상 결제 시</span>
                    <span class="amt">3,000<em class="won">원</em></span>
                </div>
<% End If %>
<% If currentDate >= #10/19/2020 00:00:00# and currentDate <= #10/25/2020 23:59:59# Then %>
                <h4>차이 즉시 할인</h4>
                <div class="box shinhan">
                    <span class="txt-info">4만 원 이상 결제 시</span>
                    <span class="amt">3,000<em class="won">원</em></span>
                </div>
<% End If %>
            </div>
        </section>
        <!--// 지금혜택 -->

        <!-- 추가혜택 -->
        <section class="bnf-extra bg-white">
            <div class="tit-area">
                <h3>#추가혜택</h3>
                <p>텐바이텐에서 누릴 수 있는<br>또 다른 혜택, 놓치지 마세요</p>
            </div>
            <div class="dsc-area">
                <ul class="cpn-list">
                    <li>
                        <div class="box">
                            <span class="txt-extra">마일리지 적립</span>
                            <span class="txt-info">주문금액의 최대 1.3%</span>
                        </div>
                    </li>
                    <li>
                        <div class="box">
                            <span class="txt-extra">무료 배송</span>
                            <span class="txt-info">30,000원 이상 구매 시</span>
                        </div>
                    </li>
                    <li>
                        <div class="box">
                            <span class="txt-extra">생일 쿠폰</span>
                            <span class="txt-info">1주일 전에 자동 발행</span>
                        </div>
                    </li>
                </ul>
                <!-- for dev msg : 등급별 혜택 링크 (비로그인 시 로그인페이지) -->
                <% if isapp = 1 then %>
                    <% If not IsUserLoginOK() Then %>
                        <a href="" onclick="jsEventLogin();return false;" class="btn-blk">
                    <% else %>
                        <a href="" onclick="fnAPPpopupBrowserURL('등급별 혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/grade_guide.asp');return false;" class="btn-blk">
                    <% end if %>
                <% else %>
                <a href="/my10x10/userinfo/grade_guide.asp" class="btn-blk">
                <% end if %>
                    <span>등급별 혜택 확인하기</span>
                </a>
            </div>
        </section>
        <!-- // 추가혜택 -->
    </div>
    <!--// 텐바이텐 혜택 가이드 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
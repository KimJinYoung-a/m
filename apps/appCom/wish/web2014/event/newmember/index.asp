<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : app 다운로드 신규회원
' History : 2018-12-14 이종화
'###########################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    '// 앱쿠폰 다운 6/10 ~ 6/30
    dim appDownCouponCode, alertMsg, currentDate

    currentDate = date()    
    'test
    'currentDate = Cdate("2019-07-01")    

    IF application("Svr_Info") = "Dev" THEN
        appDownCouponCode = "2903"
        alertMsg = "쿠폰이 발급 되었습니다.\n발급 후 24시간 이내에 사용 가능합니다."
    else        
        appDownCouponCode = "1163"
        alertMsg = "쿠폰이 발급되었습니다!\nAPP에서 5만원 이상 구매 시 사용 가능합니다."                
    end if 

%>
<script>
    function jsEvtCouponDown(stype,idx) {
        <% If IsUserLoginOK() Then %>
            var str = $.ajax({
                type: "POST",
                url: "/event/etc/coupon/couponshop_process.asp",
                data: "mode=cpok&stype="+stype+"&idx="+idx,
                dataType: "text",
                async: false
            }).responseText;
            var str1 = str.split("||")
            if (str1[0] == "11"){
                fnAmplitudeEventMultiPropertiesAction("click_appcoupondown_banner","","");
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
        <% Else %>
            jsEventLogin();
            return false;
        <% End IF %>
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
<title>10x10: 텐바이텐 APP 다운로드</title>
<style type="text/css">
.memberGuide {background-color:#4deece;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
</head>
<body class="default-font body-sub bg-grey">
	<div id="content" class="content">
		<div class="evtCont">
            <%'!--// 텐바이텐 신규 회원을 위한 혜택 가이드! --%>
            <div class="memberGuide">
                <p class="topic"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/tit_newmember.png" alt="텐바이텐 신규 회원을 위한 혜택 가이드!"></p>
                <div class="benefit">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_01.png" alt="신규회원 가입하고, 쿠폰 받기! "></p>
                    <a href="/apps/appcom/wish/web2014/member/join.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/btn_join.png" alt="회원가입 하러 가기"></a>
                </div>
                <p class="benefit">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_02_app.png" alt="APP설치하고, 쿠폰 받기! ">
                    <a href="javascript:jsEvtCouponDown('evtsel','<%= appDownCouponCode %>');"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/btn_coupon.png" alt="쿠폰다운받기"></a>
                </p>
                <div class="benefit">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/newmember/m/img_03.png" alt="무료배송 및 마일리지 혜택 확인하기 !"></p>
                </div>
            </div>
            <%'!--// 텐바이텐 신규 회원을 위한 혜택 가이드! --%> 
		</div>
	</div>
</body>
</html>
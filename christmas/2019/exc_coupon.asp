<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 크리스마스 쿠폰
' History : 2019-11-14 이종화
'###########################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<%
    '// 쿠폰 다운
    dim alertMsg, couponNumber
      
    IF application("Svr_Info") = "Dev" THEN
        couponNumber = "2913"
        alertMsg = "크리스마스 쿠폰이 발급되었습니다!\n본 쿠폰은 쿠폰함에서 확인할 수 있으며, 12월 25일 자정까지 사용 가능합니다."
    else
        couponNumber = "1229"
        alertMsg = "크리스마스 쿠폰이 발급되었습니다!\n본 쿠폰은 쿠폰함에서 확인할 수 있으며, 12월 25일 자정까지 사용 가능합니다."
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
                fnAmplitudeEventMultiPropertiesAction("click_christmascoupondown_banner","","");
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
           <% if isApp="1" then %>
                calllogin();
            <% else %>
                top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
            <% end if %>
        <% End IF %>
    }
</script>
<a href="javascript:jsEvtCouponDown('evtsel','<%= couponNumber %>');"><img src="//webimage.10x10.co.kr/fixevent/event/2019/xmas2019/m/bnr_mkt.png" alt="쿠폰 받기"></a>
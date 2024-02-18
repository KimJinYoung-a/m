<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 기획전 리틀히어로 브랜드 쿠폰
' History : 2019-12-20 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid
IF application("Svr_Info") = "Dev" THEN
	eCode = "90449"
Else
	eCode = "99318"
End If

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount  
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
'// STAFF 아이디는 테스트를 위해 시작일을 테스트 일자로 부터 시작하게 변경
If GetLoginUserLevel() = "7" Then
    eventStartDate = cdate("2019-12-12")
End If
%>
<style type="text/css">
.mEvt99318 {position:relative;}
.mEvt99318 .btn-coupon {display:block; width:100%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){
	var swiper = new Swiper(".slider", {
		speed:1000,
		autoplay:2500,
		autoplayDisableOnInteraction:false,
		loop:true
	});
});

function jsDownCoupon99318(cType){
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    
    <% if Not(IsUserLoginOK) then %>
        jsEventLogin();
    <% else %>
        $.ajax({
            type: "post",
            url: "/apps/appCom/wish/web2014/event/etc/doEvenSubscript99318.asp",		
            data: {
                eCode: '<%=eCode%>',
                couponType: cType
            },
            cache: false,
            success: function(resultData) {
                fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|couponType','<%=eCode%>|'+cType)
                var reStr = resultData.split("|");				
                
                if(reStr[0]=="OK"){		
                    alert('쿠폰이 발급 되었습니다.\n주문시 사용 가능합니다.');
                }else{
                    var errorMsg = reStr[1].replace(">?n", "\n");
                    alert(errorMsg);					
                }			
            },
            error: function(err) {
                console.log(err.responseText);
            }
        });
    <% end if %>
}

function jsEventLogin(){
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
    <% end if %>
        return;
}
</script>
<%' 99318 브라운 소방관 %>
<div class="mEvt99318">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/tit_brown.jpg" alt="브라운 소방관이 지켜주는 우리집"></h2>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/txt_mid.jpg" alt=""></p>
    <div class="swiper-container slider">
        <div class="swiper-wrapper">
            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/img_slide_01.jpg" alt=""></div>
            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/img_slide_02.jpg" alt=""></div>
            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/img_slide_03.jpg" alt=""></div>
            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/img_slide_04.jpg" alt=""></div>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/txt_point_1.jpg" alt=""></p>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/txt_point_2.jpg" alt=""></p>
    <p><button type="button" class="btn-coupon" onclick="jsDownCoupon99318('cLittleHero');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/btn_coupon.jpg" alt="쿠폰 다운받기"></button></p>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99318/m/txt_last.jpg" alt=""></p>
</div>
<%' // 99318 브라운 소방관 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
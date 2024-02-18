<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 기획전 카카오 브랜드 쿠폰
' History : 2019-12-12 원승현
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
	eCode = "90445"
Else
	eCode = "99403"
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
.mEvt99403,.mEvt99403>div {position: relative;}
.mEvt99403 button {position: absolute; top: 40%; padding: 1rem 1.3rem; background-color: transparent; z-index: 9;}
.mEvt99403 button.btn-next {right: 0;}
.mEvt99403 .pagination {position: absolute; width: 100%; bottom: 4rem;  z-index: 9;}
.mEvt99403 .pagination .swiper-active-switch {background-color: #393939;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){
    swiper = new Swiper('.slide1', {
        autoplay:3500,
        loop: true,
    	pagination:'.slide1 .pagination',
        paginationClickable:true,		
        nextButton:'.slide1 .btn-next',	
        prevButton:'.slide1 .btn-prev'	
    })
});

function jsDownCoupon99403(cType){
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    
    <% if Not(IsUserLoginOK) then %>
        jsEventLogin();
    <% else %>
        $.ajax({
            type: "post",
            url: "/apps/appCom/wish/web2014/event/etc/doEvenSubscript99403.asp",		
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
<%' 99403 연말 선물도 카카오프렌즈 %>
<div class="mEvt99403">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/tit.jpg" alt="연말 선물도 카카오프렌즈"></h2>
    <div class="slide1">
        <div class="swiper-wrapper">
            <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2503401&pEtr=99403" onclick="TnGotoProduct('2503401');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_prd_1.jpg" alt="눈사람 라이언 인형"></a></div>
            <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2503356&pEtr=99403" onclick="TnGotoProduct('2503356');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_prd_2.jpg" alt="리틀 어피치 가습기"></a></div>
            <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2503396&pEtr=99403" onclick="TnGotoProduct('2503396');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_prd_3.jpg" alt="크리스마스 라이언 오르골"></a></div>
            <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2503333&pEtr=99403" onclick="TnGotoProduct('2503333');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_prd_4.jpg" alt="2020 어피치 다이어리"></a></div>
            <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2503386&pEtr=99403" onclick="TnGotoProduct('2503386');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_prd_5.jpg" alt="차량용 고속 충전기"></a></div>
        </div>
        <div class="pagination"></div>
        <button type="button" class="btn-prev"><svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
        <button type="button" class="btn-next"><svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
    </div>
    <a href="" onclick="jsDownCoupon99403('cKakaoFriends');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99403/m/img_coupon.jpg" alt="쿠폰 다운받기"></a>
    <%' for dev msg 클릭 시 장바구니 쿠폰 발급 > 팝업 오픈 (쿠폰 ID: 1275) %>
</div>
<%' // 99403 연말 선물도 카카오프렌즈 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
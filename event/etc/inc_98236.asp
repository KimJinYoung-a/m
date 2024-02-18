<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 독도프렌즈 이벤트
' History : 2019-10-23
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, event1DayDate, event2DayDate, event3DayDate, currentDate, docdoItem
If application("Svr_Info") = "Dev" then
	eCode = "90418"  
    docdoItem = "145983"
    event1DayDate = cdate("2019-10-22")	'티저페이지 노출
    event2DayDate = cdate("2019-10-23")	'이벤트일 - 스티커 할인판매
    event3DayDate = cdate("2019-10-24")	'스티커 정상구매 노출
Else
	eCode = "98236"
    docdoItem = "2547347"
    event1DayDate = cdate("2019-10-24")	'티저페이지 노출
    event2DayDate = cdate("2019-10-25")	'이벤트일 - 스티커 할인판매
    event3DayDate = cdate("2019-10-26")	'스티커 정상구매 노출
End If
currentDate = date()
%>
<style type="text/css">
.mEvt98236 {background-color: #111;}
.mEvt98236 ,.mEvt98236 > div, .mEvt98236 .posr {position: relative;}
.mEvt98236 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt98236 .blind {display: none; opacity: 0;}
.mEvt98236 button {outline: none;}
.topic .pos {animation:bling 1.4s  steps(1) 40;}
.guide .pos {top: auto; bottom: 0;}
@keyframes bling{
15%,45% {opacity:0;}
30%,60% {opacity: 1;}
}
</style>
<script type="text/javascript">
$(function(){
    slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
        loop:true,
        autoplay:3000,
        autoplayDisableOnInteraction:false,
        speed:800,
        pagination:".slideTemplateV15 .pagination",
        paginationClickable:true,
    });
});

function jsEventLogin(){
    <% If isApp = 1 then %>
        calllogin();
    <% Else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
    <% End if %>
        return;
}

<% If currentDate=event2DayDate then %>
    function goDirOrdItem(){
        <% If Not(IsUserLoginOK) then %>
            jsEventLogin();
        <% Else %>		
            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
            document.directOrd.submit();        
        <% End IF %>
    }
<% End IF %>
</script>

<!-- MKT_98236_독도프렌즈 -->
<% If currentDate=event2DayDate then %>
    <% If isApp = 1 then %>
        <form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
            <input type="hidden" name="itemid" id="itemid" value="<%=docdoItem%>">
            <input type="hidden" name="itemoption" value="0000">
            <input type="hidden" name="itemea" readonly value="1">
            <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
            <input type="hidden" name="isPresentItem" value="" />
            <input type="hidden" name="mode" value="DO3">
        </form>
    <% Else %>
        <form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
            <input type="hidden" name="itemid" id="itemid" value="<%=docdoItem%>">
            <input type="hidden" name="itemoption" value="0000">
            <input type="hidden" name="itemea" readonly value="1">
            <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
            <input type="hidden" name="isPresentItem" value="" />
            <input type="hidden" name="mode" value="DO1">
        </form>
    <% End if %>
<% End if %>	
<div class="mEvt98236">
    <div class="topic">        
        <% If currentDate<=event1DayDate then %>
            <!-- 날짜별 1024 -->
            <div class="posr">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/tit.jpg" alt="독도프렌즈">
                <div class="pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/tit_ani_1024.png" alt="내일 단 하루!"></div>
            </div>
        <% Elseif currentDate=event2DayDate then %>
            <!-- 날짜별 1025 -->
            <div class="posr">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/tit.jpg" alt="독도프렌즈">
                <div class="pos"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/tit_ani_1025.png" alt="오늘 단 하루!"></div>
            </div>
        <% Elseif currentDate>=event3DayDate then %>
            <!-- 날짜별 1026 -->
            <div class="posr">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/tit_1026.jpg" alt="독도프렌즈">
            </div>
        <% Else %>
            <div class="posr">
                이벤트 기간이 아닙니다.
            </div>
        <% End if %>
    </div>
    <div class="guide">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/bg_top.png" alt=""></span>
        <div class="pos">
            <div class="tit">
                <% If currentDate<=event2DayDate then %>
                    <!--1024,1025-->
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/txt_guidetit.png" alt="10월 25일은 독도의 날이에요!"></span>
                <% Elseif currentDate>=event3DayDate then %>
                    <!--1026-->
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/txt_guidetit_1026.png" alt="독도는 우리 땅!"></span>
                <% Else %>
                    <span>이벤트 기간이 아닙니다.</span>
                <% End if %>
            </div>
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/txt_guide.png" alt="독도가 우리 땅이라는 것을 많은 사람들이 기억했으면 하는 마음에 독도 친구들을 모아 캐리어 스티커를 만들었어요! "></span>
        </div>
    </div>
    <div>
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/img_prd.png" alt="독도 프렌즈 소개!">
    </div>
    <div class="btn-area">
        <% If currentDate<=event1DayDate then %>
            <!--1024-->
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/btn_1024.jpg" alt="10월 25일에 만나요!">
        <% Elseif currentDate=event2DayDate then %>
            <!--1025-->
            <a href="javascript:goDirOrdItem();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/btn_1025.jpg" alt="구매하러 가기"></a>
        <% Elseif currentDate>=event3DayDate then %>
            <!--1026-->
            <% If isApp = 1 then %>
                <a href="" onclick="TnGotoProduct('<%=docdoItem%>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/btn_1026.jpg" alt="구매하러 가기"></a>           
            <% Else %>
                <a href="/category/category_itemPrd.asp?itemid=<%=docdoItem%>&pEtr=<%=eCode%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/btn_1026.jpg" alt="구매하러 가기"></a>
            <% End if %>            
        <% Else %>
            이벤트 기간이 아닙니다.
        <% End if %>
    </div>
    <div class="slideTemplateV15 txtFix">
        <div class="swiper">
            <div class="txt"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/topaddimg20191015105110.PNG" alt=""></div>
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015105134.PNG" alt=""></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015130724.PNG" alt=""></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015130515.PNG" alt=""></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015131513.JPEG" alt=""></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015105230.PNG" alt=""></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2019/98047/slideimg20191015130541.PNG" alt=""></div>
                </div>
            </div>
            <div class="pagination "></div>
        </div>
    </div>
    <div class="noti">
        <% If currentDate<=event2DayDate then %>
            <!--1024,1025-->
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98236/m/txt_noti.jpg" alt="유의사항"></span>
        <% End if %>
    </div>
</div>
<!-- // MKT_98236_독도프렌즈 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->
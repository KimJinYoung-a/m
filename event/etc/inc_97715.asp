<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 18주년 텐텐데이
' History : 2019.10.07 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/event/etc/event_97715_cls.asp" -->

<%
dim cevt97715, i, currentdate, parttime, currenthour, isSoldOut
    currentdate = now()     ' #10/10/2019 11:59:59#
    currenthour = hour(currentdate)

isSoldOut=false
parttime="0"
if currenthour>=10 and currenthour<13 then
    parttime="1"
elseif currenthour>=13 and currenthour<15 then
    parttime="2"
elseif currenthour>=15 and currenthour<17 then
    parttime="3"
elseif currenthour>=17 and currenthour<19 then
    parttime="4"
elseif currenthour>=19 and currenthour<22 then
    parttime="5"
end if
if left(currentdate,10)<>"2019-10-10" then parttime="0"     ' 10월 10일 당일날만 할인

function parttimestr(vparttime)
    dim tmpparttimestr

    if vparttime="1" then
        tmpparttimestr="am10:00 ~ pm1:00"
    elseif vparttime="2" then
        tmpparttimestr="pm1:00 ~ pm3:00"
    elseif vparttime="3" then
        tmpparttimestr="pm3:00 ~ pm5:00"
    elseif vparttime="4" then
        tmpparttimestr="pm5:00 ~ pm7:00"
    elseif vparttime="5" then
        tmpparttimestr="pm7:00 ~ pm10:00"
    else
        tmpparttimestr=""
    end if
    parttimestr=tmpparttimestr
end function

set cevt97715 = new Cevent_97715
    cevt97715.fnevent_97715()
%>
<style>
.time-table {background-color:#fcffb9;}
.time-sale p {position:relative;}
.time-sale p span {position:absolute; top:0; left:0;}
.time-table .now-sale {display:flex; justify-content:space-around; flex-wrap:wrap; width:28rem; margin:0 auto; padding:1.49rem 2rem; background-color:#fff;}
.time-table .now-sale .sale-time, .time-table .now-sale .sale-item {width:10.24rem; padding:1.07rem 0;}
.time-table .now-sale .sale-item a, .time-table .sale-section.end .swiper-slide a {position:relative; display:inline-block; width:100%; height:100%;}
.time-table .now-sale .sale-item.sold-out a:after, .time-table .sale-section.end .swiper-slide a:after {display:inline-block; position:absolute; top:0; left:0; width:10.24rem; height:10.24rem; background-color:rgba(0,0,0,.5); content:'';}
.time-table .now-sale .sale-item.sold-out a:after, .time-table .sale-section .swiper-slide.sold-out a:after {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/97715/txt_sold_out.png); background-size:contain;}
.time-table .sale-section.section5 {padding-bottom:4.7rem;}
.time-table .sale-section .swiper-slide {width:10.24rem; margin:0 .85rem;}
.time-table .sale-section .swiper-slide:first-child {margin-left:1.62rem;}
</style>
<script>
$(function () {
    var winSwiper = new Swiper('.sale-section .swiper-container', {
        speed:1200,
        freeMode:true,
        slidesPerView:'auto'
    });
});
</script>
<!-- 텐텐데이 -->
<div class="mEvt97715">
    <!-- top -->
    <div class="top">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/tit_tenten.png" alt="10월 10일은 텐텐데이" /></h2>
    </div>
    <!--// top -->
    <!-- time-sale -->
    <div class="time-sale"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_active.gif" alt="1 Day Time Sale" /></span></p>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_tenten.png" alt="10월 10일 단 하루 동안 놀라운 특가를 준비했습니다.  매시간 오픈되는 릴레이 타임세일을 놓치지 마세요!" /></div>
    </div>
    <!--// time-sale -->

    <% if cevt97715.FResultCount>0 then %>
        <!-- time-table -->
        <div class="time-table">
            <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time.png" alt="time table" /></h3>
            <%
            ' <!-- for dev msg 타임 세일 진행중인 상품 세트 노출 -->
            ' <!-- for dev msg 품절된 상품 [sold-out]클래스 추가 -->
            %>
            <% if parttime<>"0" then %>
                <div class="now-sale">
                    <p class="sale-time">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time<%= parttime %>.png" alt="<%= parttimestr(parttime) %>" />
                    </p>
                    <% for i = 0 to cevt97715.FResultCount-1 %>
                    <%
                    isSoldOut=false
                    if cevt97715.FItemList(i).isSoldOut then
                        isSoldOut=true
                    else
                        IF cevt97715.FItemList(i).isTempSoldOut Then
                            isSoldOut=true
                        end if
                    end if
                    %>
                    <% if cstr(cevt97715.FItemList(i).fsortNo)=cstr(parttime) then %>
                        <div class="sale-item <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                    <% end if %>
                    <% next %>
                </div>
            <% end if %>
            <%
            ' <!-- for dev msg 타임 세일 진행중이지 않은 상품 노출 영역 -->
            ' <!-- for dev msg 세일 끝났을 때, [end]클래스  -->
            ' <!-- for dev msg 품절된 상품 [sold-out]클래스 추가 -->
            %>
            <% if parttime<>"1" then %>
            <div class="sale-section section1 <% if currenthour>=13 or parttime="0" then %>end<% end if %>">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time1.jpg" alt="<%= parttimestr("1") %>" /></p>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to cevt97715.FResultCount-1 %>
                        <%
                        isSoldOut=false
                        if cevt97715.FItemList(i).isSoldOut then
                            isSoldOut=true
                        else
                            IF cevt97715.FItemList(i).isTempSoldOut Then
                                isSoldOut=true
                            end if
                        end if
                        %>
                        <% if cevt97715.FItemList(i).fsortNo="1" then %>
                            <div class="swiper-slide <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                        <% end if %>
                        <% next %>
                    </div>
                </div>
            </div>
            <% end if %>
            <% if parttime<>"2" then %>
            <div class="sale-section section2 <% if currenthour>=15 or parttime="0" then %>end<% end if %>">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time2.jpg" alt="<%= parttimestr("2") %>" /></p>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to cevt97715.FResultCount-1 %>
                        <%
                        isSoldOut=false
                        if cevt97715.FItemList(i).isSoldOut then
                            isSoldOut=true
                        else
                            IF cevt97715.FItemList(i).isTempSoldOut Then
                                isSoldOut=true
                            end if
                        end if
                        %>
                        <% if cevt97715.FItemList(i).fsortNo="2" then %>
                            <div class="swiper-slide <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                        <% end if %>
                        <% next %>
                    </div>
                </div>
            </div>
            <% end if %>
            <% if parttime<>"3" then %>
            <div class="sale-section section3 <% if currenthour>=17 or parttime="0" then %>end<% end if %>">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time3.jpg" alt="<%= parttimestr("3") %>" /></p>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to cevt97715.FResultCount-1 %>
                        <%
                        isSoldOut=false
                        if cevt97715.FItemList(i).isSoldOut then
                            isSoldOut=true
                        else
                            IF cevt97715.FItemList(i).isTempSoldOut Then
                                isSoldOut=true
                            end if
                        end if
                        %>
                        <% if cevt97715.FItemList(i).fsortNo="3" then %>
                            <div class="swiper-slide <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png?v=1.01" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                        <% end if %>
                        <% next %>
                    </div>
                </div>
            </div>
            <% end if %>
            <% if parttime<>"4" then %>
            <div class="sale-section section4 <% if currenthour>=19 or parttime="0" then %>end<% end if %>">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time4.jpg" alt="<%= parttimestr("4") %>" /></p>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to cevt97715.FResultCount-1 %>
                        <%
                        isSoldOut=false
                        if cevt97715.FItemList(i).isSoldOut then
                            isSoldOut=true
                        else
                            IF cevt97715.FItemList(i).isTempSoldOut Then
                                isSoldOut=true
                            end if
                        end if
                        %>
                        <% if cevt97715.FItemList(i).fsortNo="4" then %>
                            <div class="swiper-slide <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png?v=1.01" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                        <% end if %>
                        <% next %>
                    </div>
                </div>
            </div>
            <% end if %>
            <% if parttime<>"5" then %>
            <div class="sale-section section5 <% if currenthour>=22 or parttime="0" then %>end<% end if %>">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/txt_time5.jpg" alt="<%= parttimestr("5") %>" /></p>
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <% for i = 0 to cevt97715.FResultCount-1 %>
                        <%
                        isSoldOut=false
                        if cevt97715.FItemList(i).isSoldOut then
                            isSoldOut=true
                        else
                            IF cevt97715.FItemList(i).isTempSoldOut Then
                                isSoldOut=true
                            end if
                        end if
                        %>
                        <% if cevt97715.FItemList(i).fsortNo="5" then %>
                            <div class="swiper-slide <% if isSoldOut then %>sold-out<% end if %>"><a href="/category/category_itemPrd.asp?itemid=<%= cevt97715.FItemList(i).fitemid %>&pEtr=97715" onclick="TnGotoProduct('<%= cevt97715.FItemList(i).fitemid %>');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_item<%= cevt97715.FItemList(i).fitemid %>.png" alt="<%= cevt97715.FItemList(i).FItemName %>" /></a></div>
                        <% end if %>
                        <% next %>
                    </div>
                </div>
            </div>
            <% end if %>
        <!-- time-table -->
        </div>
        <!--// time-table -->
    <% end if %>

    <!-- related-evt -->
    <div class="related-evt">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/tit_evt.jpg" alt="텐바이텐은 지금 18주년 행사 중! 이런 이벤트는 어떠세요?" /></p>
        <ul>
            <li><a href="/event/eventmain.asp?eventid=97607" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97607');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_evt1.jpg" alt="어서와, 텐바이텐은 처음이지?" /></a></li>
            <li><a href="/event/eventmain.asp?eventid=97594" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97594');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_evt2.jpg" alt="NEW에 눈이 번쩍 ♥에 마음이 콩닥" /></a></li>
            <li><a href="/event/eventmain.asp?eventid=97641" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97641');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97715/m/img_evt3.jpg" alt="NO 세일? NO! 지금 바로 세일!" /></a></li>
        </ul>
    </div>
    <!--// related-evt -->
</div>
<!--// 텐텐데이 -->

<%
set cevt97715=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
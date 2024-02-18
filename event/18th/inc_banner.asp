<%
    dim curDate
    curDate = date()
    'TEST
    'curDate = Cdate("2019-10-30")
%>
<div class="bnr-mkt">
    <%'1. 스케줄 표 참고 https://docs.google.com/spreadsheets/d/1qx1xo7_lmVjMp0FsJpgLlyzJ7ENP3_Hib3Q1_qPIvSE/edit#gid=1539300381 %>            
    <%'2. '10/11~''  배너는 추후 시안 전달 예정 %>          
    <% if ( curDate >= Cdate("2019-09-27") and curDate <= Cdate("2019-10-10") ) then %>  
    <!-- 10/1-10 -->
    <ul>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97449" onclick="jsEventlinkURL(97448);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_hundred.png" alt="뽑기에 성공하면 이 상품들이 100원!?"></a></li>
        <li><a href="/event/eventmain.asp?eventid=96333" onclick="jsEventlinkURL(96333);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_letter.png" alt="메일 수신 동의하고 10,000 마일리지 받자!"></a></li>
    </ul>
    <% end if %>

    <% if ( curDate >= Cdate("2019-10-11") and curDate <= Cdate("2019-10-13") ) then %>
    <!-- 10/11-13 -->
    <ul>
        <li><a href="/event/eventmain.asp?eventid=97540" onclick="jsEventlinkURL(97541);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_maelieage1.png" alt="매일리지 1차"></a></li>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li><a href="/event/eventmain.asp?eventid=96333" onclick="jsEventlinkURL(96333);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_letter.png" alt="행운의편지"></a></li>
    </ul>
    <% end if %>

    <% if ( curDate >= Cdate("2019-10-14") and curDate <= Cdate("2019-10-19") ) then %>
    <!-- 10/14-19 -->
    <ul>
        <li><a href="/event/eventmain.asp?eventid=97805" onclick="jsEventlinkURL(97806);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_pw2.png" alt="비밀번호"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97540" onclick="jsEventlinkURL(97541);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_maelieage2.png?v=1.01" alt="매일리지 1차"></a></li>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
    </ul>
    <% end if %>

    <% if ( curDate >= Cdate("2019-10-20") and curDate <= Cdate("2019-10-20") ) then %>
     <!-- 10/20 -->
    <ul>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97805" onclick="jsEventlinkURL(97806);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_pw.png" alt="비밀번호"></a></li>
        <li><a href="/event/eventmain.asp?eventid=96333" onclick="jsEventlinkURL(96333);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_letter.png" alt="행운의편지"></a></li>
    </ul>
    <% end if %>

    <% if ( curDate >= Cdate("2019-10-21") and curDate <= Cdate("2019-10-29") ) then %>
    <!-- 10/21-29 -->
    <ul>
        <li><a href="/event/eventmain.asp?eventid=97566" onclick="jsEventlinkURL(97567);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_maelieage3.png" alt="매일리지 2차"></a></li>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale2.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97805" onclick="jsEventlinkURL(97806);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_pw.png" alt="비밀번호"></a></li>
    </ul>
    <% end if %>

    <% if ( curDate >= Cdate("2019-10-30") and curDate <= Cdate("2019-10-31") ) then %>
    <!-- 10/30-31 -->
    <ul>
        <li class="mWeb"><a href="/my10x10/couponbook.asp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li class="mApp"><a href="javascript:void(0)"  onclick="fnAPPpopupCouponBook_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_sale.png" alt="지금 즉시 사용하는 할인 쿠폰"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97566" onclick="jsEventlinkURL(97567);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_maelieage4.png" alt="매일리지 2차"></a></li>
        <li><a href="/event/eventmain.asp?eventid=97805" onclick="jsEventlinkURL(97806);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bnr_pw.png" alt="비밀번호"></a></li>
    </ul>
    <% end if %>
</div>
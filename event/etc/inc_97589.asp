<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 18주년 사은이벤트
' History : 2019-09-30
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<style>
.cmtEvt.gift {background-color: #fff;}
.gift .intro {position: relative; z-index: 7;}    
.gift .topic {position: relative; padding-bottom: 2rem;}
.gift .topic .img_snp {position: absolute; top: -4.5rem; left: 2%; width: 100%;}
.gift .topic .hello {padding-top: 1rem;}
.gift .slide-area {position: relative;}
.gift .slide-area .slide2 {position: absolute; bottom: 0; left: 5%; width: 90%; overflow: hidden;}
.gift .slide-area .slide2 .swiper-slide {width: 100%;}
.gift .slide-area .slide2 .pagination {position: absolute; bottom: 1rem; width: 100%; z-index: 99;}
.gift .slide-area .slide2 .pagination .swiper-pagination-switch {width: .5rem; height: .5rem; margin: 0 .25; border: .13rem solid #fff; box-sizing: border-box; border-radius: .5rem; transition-duration: .4s; background: none;}
.gift .slide-area .slide2 .pagination .swiper-active-switch {width: 1.07rem; }
.gift .noti {padding: 2.56rem; background-color: #845f40;}
.gift .noti h3 {font-size: 1.44rem; color: #fff; text-align: center; font-weight: 600;}
.gift .noti li {padding-left: .7rem; margin:.2rem 0; font-size:1.11rem; color: #fff;  line-height:1.6; word-break: keep-all}
.gift .noti li:before {content: '.'; display: inline-block; width: .7rem; margin-left: -.7rem; font-weight: bold; font-size: 2rem; line-height: 1.11rem; vertical-align: .2rem; color: #a9907a;}
</style>
<script type="text/javascript">
$(function(){
    //댓글 배경이미지 랜덤
    var cmtBg = new Array(6);
    for (var i = 0; i < cmtBg.length; i++) {
        cmtBg[i]=Math.floor(Math.random()*6 +1)
        for (var j=0; j<i; j++){
            if(cmtBg[j]==cmtBg[i]){i--;}
        }
    }
    $('.cmt-list li').each(function(){
        var t=$(this).index();
        $('.cmt-list li').eq(t).css({'background-image': 'url(//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bg_cmt_list_'+cmtBg[t]+'.png?v=1.01)' })
    })
    //상품이미지슬라이드
    swiper = new Swiper('.slide2', {
        pagination:'.slide2 .pagination',
        paginationClickable:true,
    })
});
</script>


            <!-- 18주년 사은품 -->
			<div class="anniversary18th bg-random cmtEvt gift">
                <!-- #include virtual="/event/18th/lib/head18th.asp" -->

                <div class="intro">
                    <div class="inner">
                        <span class="anniversary">18th</span>
                        <h2>Your 10X10</h2>
                        <div class="intro-sub">18번째 생일,<br>텐바이텐과 함께 해주어 고맙습니다.</div>
                        <ul class="evt-list">
                            <% if isapp > 0 then %>
                                <li><a href="javascript:fnAPPpopupBrowserURL('오늘의 취향','<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/index.asp?gnbflag=1');">오늘의 취향 <span class="icon-chev"></span></a></li>
                                <li><a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97588');return false;">나에게 텐바이텐은? <span class="icon-chev"></span></a></li>
                            <% Else %>
                                <li><a href="/event/18th/index.asp">오늘의 취향 <span class="icon-chev"></span></a></li>
                                <li><a href="/event/eventmain.asp?eventid=97588">나에게 텐바이텐은? <span class="icon-chev"></span></a></li>
                            <% End If %>
                        </ul>
                    </div>
                </div>
                <div class="topic">
                    <div class="img_snp"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_snp.png" alt=""></div>
                    <div class="hello">
                        <span>스누피의 선물</span>
                        <p>텐바이텐, 18번째 생일을 축하해! <br>스누피가 전하는  특별한 선물을 만나보세요! </p>
                    </div>
                </div>
                <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_topic.jpg" alt="텐바이텐 X 피너츠(PEANUTS)"></span>
                <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_price_v2.jpg" alt="구매 금액별 사은품"></span>
                <div class="slide-area">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_slide_bg.jpg?v=1.01" alt="구매 금액별 사은품"></span>
                    <div class="slide2">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_1.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_2.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_3.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_4.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_5.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_6.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_7.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_8.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_9.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_10.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/img_slide_11.jpg" alt=""></div>
                        </div>
                        <div class="pagination"></div>
                    </div>
                </div>
                <% if isapp > 0 then %>
                    <button onClick="fnAPPpopupBrowserURL('머그컵','<%=wwwUrl%>/apps/appCom/wish/web2014/event/etc/inc_97589_popup.asp');"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_slide_bottom.jpg" alt="컬러 보러가기"></button>
                <% else %>
                    <button onClick="location.href='/event/etc/inc_97589_popup.asp';"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_slide_bottom.jpg" alt="컬러 보러가기"></button>
                <% end if %>

                <% ' 10월7일00시부터 노출
                'If date() < "2019-10-01" Then 
                If date() > "2019-10-06" Then 
                %>
                    <% if isapp > 0 then %>
                        <div class="prd-area">
                            <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97535');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_prd.jpg" alt="같이 쓰면 더 좋은  Peanuts hug mug할인  "></a>
                        </div>
                    <% else %>
                        <div class="prd-area">
                            <a href="/event/eventmain.asp?eventid=97535"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_prd.jpg" alt="같이 쓰면 더 좋은  Peanuts hug mug할인  "></a>
                        </div>
                    <% end if %>
                <% End if %>

                <div class="noti">
                    <h3>꼭 읽어보세요! </h3>
                    <ul>
                        <li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. <br>(비회원 구매 시, 증정 불가) </li>
                        <li>텐바이텐 배송 상품을 포함해야 사은품 선택이 가능합니다. <br>
                        <% if isapp > 0 then %>
                            <a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89269');return false;">텐바이텐 배송상품 보러가기 &gt;</a></li>
                        <% else %>
                            <a href="/event/eventmain.asp?eventid=89269">텐바이텐 배송상품 보러가기 &gt;</a></li>
                        <% end if %>
                        <li>업체배송 상품으로만 구매 시 마일리지만 선택 가능합니다. </li>
                        <li>상품 쿠폰, 보너스 쿠폰 등의 사용 후 구매 확정액이 4/25만원 이상이어야 합니다. (단일주문건 구매 확정액) </li>
                        <li>마일리지, 예치금, Gift카드를 사용하신 경우에는 구매확정 금액에 포함되어 사은품을 받으실 수 있습니다.</li>
                        <li>텐바이텐 Gift카드를 구매하신 경우에는 사은품 증정이 되지 않습니다. </li>
                        <li>마일리지는 차후 일괄 지급됩니다. <br>1차 : 10월 01일 ~ 11일 구매자 (21일 지급)<br>2차 : 10월 12일 ~ 22일 구매자 (30일 지급)<br>3차 : 10월 23일 ~ 31일(11월 8일 지급)</li>
                        <li>본 마일리지는 11월 30일 23시 59분 59초까지 사용가능한 스페셜 마일리지입니다. </li>
                        <li>기간 내에 사용하지 않은 마일리지는 자동 소멸됩니다.   </li>
                        <li>환불이나 교환 시, 최종 구매가격이 사은품 수령 가능금액 미만일 경우 사은품과 함께 반품해야 합니다. </li>
                        <li>구매 금액별 선물은 한정 수량으로 조기 소진될 수 있습니다.</li>
                        <li>[18th edition] Peanuts hug mug set(4P) 10월 10일부터 별도 배송될 예정입니다.</li>
                    </ul>
                </div>

                <!-- 주년 마케팅 배너 -->
                <!-- #include virtual="/event/18th/inc_banner.asp" -->
                <!--// 주년 마케팅 배너 -->
            </div>
			<!--// 18주년 사은품 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
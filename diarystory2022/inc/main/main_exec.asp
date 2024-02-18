<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2022/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
'####################################################
' Description : 다이어리스토리 2021 메인 실행 페이지
' History : 2020-08-11 이종화 생성
'####################################################
Dim oExhibition
dim masterCode
dim i
dim couponPer, couponPrice, itemSalePer, totalPrice, totalSaleCouponString 
dim tempPrice , saleStr , couponStr, giftCheck

IF application("Svr_Info") = "Dev" THEN
	masterCode = "3"
else
	masterCode = "10"
end if

'사은품 표기 온오프
giftCheck = False

SET oExhibition = new ExhibitionCls

public function couponDisp(couponVal)
	if couponVal = "" or isnull(couponVal) then exit function
	couponDisp = chkIIF(couponVal > 100, couponVal, couponVal & "%")
end function
%>
<script>
var isapp = "<%=isapp%>"
</script>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.42" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<script type="text/javascript" src="/diarystory2022/lib/diary.js"></script>
<div id="content" class="content diary2021 new-type">
<%' 마케팅 이벤트 %>
<% If Date<="2020-10-04" Then %>
<a href="/event/eventmain.asp?eventid=105778&evtdiv=evt2" target="_blank" class="mWeb"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/bnr_mkt.png" alt="다이어리 고르고 할인 쿠폰 받아가자"></a>
<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105778&evtdiv=evt2');" target="_blank" class="mApp"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/bnr_mkt.png" alt="다이어리 고르고 할인 쿠폰 받아가자"></a>
<% ElseIf Date>="2020-10-05" and Date<="2020-10-18" Then %>
<a href="/event/eventmain.asp?eventid=106091" target="_blank" class="mWeb"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/bnr_mkt_v2.jpg" alt="그림일기"></a>
<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105918');return false;" class="mApp"><img src="//fiximage.10x10.co.kr/m/2020/diary2021/bnr_mkt_v2.jpg" alt="그림일기"></a>
<% ElseIf Date>="2021-12-01" and Date<="2021-12-19" Then %>
<div class="bnr-area">
    <a href="/event/eventmain.asp?eventid=115414" class="mWeb"><img src="http://fiximage.10x10.co.kr/m/2021/banner/bnr_payback_bk.jpg" alt="디자인 문구 3만 원 이상 구매 시 페이백!"></a>
    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=115414');return false;" class="mApp"><img src="http://fiximage.10x10.co.kr/m/2021/banner/bnr_payback_bk.jpg" alt="디자인 문구 3만 원 이상 구매 시 페이백!"></a>
</div>
<% End If %>
<!--
<a href="/event/eventmain.asp?eventid=107751" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107751/m/bnr_mkt.png" alt=""></a>
<a href=""  onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107751');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107751/m/bnr_mkt.png" alt=""></a>
-->

<%' 상단 슬라이드 영역 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_main_rolling.asp" -->

<%' 메뉴버튼 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_main_menu.asp" -->

<%' 나에게 찰떡인 다꾸템 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_catebanner.asp" -->

<%' MD가 추천해요 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_recommended_diary.asp" -->

<%' 잘나가는 베스트 아이템 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_bestlist.asp" -->

<%' 기획전 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_exhibition.asp" -->

<%' 방금 판매된 상품 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_now_sellitem.asp" -->

<%' 기획전 배너 %>
<!-- #include virtual="/diarystory2022/inc/main/inc_eventBanner.asp" -->
</div>
<script>
$(function(){
	// 롤링배너
    var diaryEvtSwiper = new Swiper('.dr_evt_swiper', {
        loop:true,
        pagination: {
            el: '.swiper-pagination',
            type: 'progressbar',
        },
	});
});
</script>
<%
SET oExhibition = Nothing 
%>
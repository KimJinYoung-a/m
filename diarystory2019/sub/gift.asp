<%' gift %>
<script>
$(function(){
    // gift rolling
	var diaryGift = new Swiper(".gift-rolling .swiper-container", {
		speed:600,
		effect:'fade',
		autoplay:1000
	});
});
</script>
<!--<div class="diary-gift">
    <h3>GIFT</h3>
	<span class="more">자세히 보기+</span>
    <% if date() > "2018-12-11" then %>    
    <div class="gift-rolling">
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_gift_slide_1_v2.jpg" alt="사은품 품절" /></div>
                <div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_gift_slide_2_v2.jpg" alt="" /></div>
                <div class="swiper-slide"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_gift_slide_3_v2.jpg" alt="" /></div>
            </div>
        </div>
    </div>
    <% else %>
    <div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_gift_slide_1_snoopy.jpg" alt="다이어리 스토리 전 품목 무료배송 15,000원 이상 스티커 2종 증정" /></div>
    <% end if %>
    <%' if isapp then %>
    <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_gift','','',function(bool){if(bool) {fnAPPpopupBrowserURL('사은품 안내','<%'=wwwUrl%>/diarystory2019/sub/pop_gift.asp','bottom');}});return false;"></a>
    <%' else %>
    <a href="/diarystory2019/sub/pop_gift.asp" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_gift','','');"></a>
    <%' end if %>
</div>-->
<%' gift %>
// 컴포넌트-탬플릿
// 리스트 스와이퍼 영역
Vue.component('swipe-list',{
    props : ['swipelists','isapp'],
    template : '<div class="plf-top">\
                    <div class="bg-rolling">\
                        <div class="swiper-container">\
                            <div class="swiper-wrapper">\
                                <div class="swiper-slide" style="background-image:url(//fiximage.10x10.co.kr/m/2019/platform/main_bg_01.jpg);"></div>\
                                <div class="swiper-slide" style="background-image:url(//fiximage.10x10.co.kr/m/2019/platform/main_bg_02.jpg);"></div>\
                                <div class="swiper-slide" style="background-image:url(//fiximage.10x10.co.kr/m/2019/platform/main_bg_03.jpg);"></div>\
                                <div class="swiper-slide" style="background-image:url(//fiximage.10x10.co.kr/m/2019/platform/main_bg_04.jpg);"></div>\
                            </div>\
                        </div>\
                    </div>\
                    <template v-if="swipelists"><swipe-layer :swipelists="swipelists" :isapp="isapp"></swipe-layer></template>\
                    <template v-else><default-layer></default-layer></template>\
                </div>'
})
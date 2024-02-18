Vue.component('Recommend-Keywords',{
    template : `
        <!-- 연관 검색어 -->
        <div v-if="recommend_keywords.length > 0" :class="['kwd_swiper', 'swiper-container', {swiper_quick:background_image}]">
            <div class="swiper-wrapper">
                <div v-for="k in recommend_keywords" :key="k" class="swiper-slide">
                    <a @click="move_search_result(k)">{{k}}</a>
                </div>
            </div>
        </div>
    `,
    updated() {
        new Swiper('.kwd_swiper', {
            slidesPerView:'auto'
        });
    },
    props : {
        recommend_keywords : {type:Array, default:function(){return [];}} // 대체검색어
        , background_image : {type:String, default: ''}
    }
});
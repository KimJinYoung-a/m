// Biz 카테고리 리스트 상단 카테고리 슬라이더
// 아직 2개밖에 없어 슬라이더 적용 안함
Vue.component('BIZ-CATEGORY-SLIDER', {
    template : `
        <div class="cate_swiper swiper_quick swiper-container">
            <div class="swiper-wrapper">
                <div v-for="category in categories" :class="['swiper-slide', {on : category.select_yn}]">
                    <a @click="goCategory(category.category_code)">
                        <img :src="category.category_image" :alt="category.category_name">
                        {{category.category_name}}
                    </a>
                </div>
            </div>
        </div>
    `,
    props : {
        categories : {type:Array, default:function(){return [];}} // 카테고리 리스트
    },
    methods : {
        goCategory(code) {
            this.$emit('goCategory', code);
        }
    }
});
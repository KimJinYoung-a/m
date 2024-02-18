/*
    카테고리 필터 슬라이더
*/
Vue.component('BIZ-CATEGORY-SLIDER2',{
    template : `        
            <nav :id="slider_id" class="ctgr_nav_type2">
                <div class="swiper-container">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide"
                            v-for="(category, index) in categories"
                            :key="index"
                        >
                            <a 
                                :id="'ctgr_nav_' + category.category_code"
                                :class="{active : category.select_yn}"
                                @click="click_category(category.category_code, category.category_name)">
                                {{category.category_name}}
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
    `,
    data() {return {
        swiper : null
    }},
    props : {
        categories : { // 카테고리 리스트
            category_code : {type:Number, default:0}, // 카테고리 코드
            category_name : {type:String, default:''}, // 카테고리명
            select_yn : {type:Boolean, default:false} // 선택 여부
        },
        slider_id : {type : String, default : 'biz_slider2'},
    },
    mounted : function() {
        const _this = this;
        _this.$nextTick(function () {
            _this.swiper = new Swiper('#' + _this.slider_id + `.ctgr_nav_type2 .swiper-container`, {
                slidesPerView:'auto',
            });
        });
    },
    updated() {
        this.swiper.update();
    },
    methods : {
        click_category(category_code, category_name) { // 카테고리 클릭
            this.$emit('click_category',category_code, category_name); // 상위컴포넌트 이벤트 전달
        },
    }
})
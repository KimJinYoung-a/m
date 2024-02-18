// 카테고리메인 추천 상품
Vue.component('Wonders',{
    template: `
        <div class="modal_body">
            <div @scroll="scroll_wonder" class="modal_cont wonder">
                <div class="pos_r">
                    <header class="head_type1">
                        <span class="txt">모아봤어요! {{category_name}} 속</span>
                        <h2 class="ttl">많이 찾는 추천상품</h2>
                    </header>
                    <Tab-Type1 @click_tab="change_wonder_type" :tabs="tab_titles"></Tab-Type1>
                    <div id="wonderProductArea">
                        <Product-List-Grid2
                            v-for="title in titles"
                            v-show="active_wonder_type == title.value"
                            @change_wish_flag="change_wish_flag_product"
                            :key="title.value"
                            :products="wonder_products[title.value]"
                            :wish_type="'wonder_' + title.value"
                            :wish_place="wonder_wish_place(title.value)"
                            :category="Number(category_code)"
                            :isApp="isApp"
                            :view_type="view_type"
                            :sort="sort"
                            :filter_recommend="filter_recommend"
                            :filter_brand="filter_brand"
                            :filter_delivery="filter_delivery"
                            :filter_lowprice="filter_lowprice"
                            :filter_highprice="filter_highprice"
                            :page="page"
                        ></Product-List-Grid2>
                    </div>
                </div>
            </div>
        </div>
    `,
    mounted() {
        this.tab_type1 = document.getElementById(this.modal_id).querySelector('.tab_type1');
    },
    data() {return {
        active_wonder_type : '', // 활성화된 구분 타이틀
        tab_type1 : null, // 탭
    }},
    props : {
        modal_id : { type : String, default : 'wonder_modal' }, // 모달창 ID
        category_code : { type : String, default : '' }, // 카테고리코드
        category_name : { type : String, default : '' }, // 카테고리명
        titles : { type : Array, default : function(){return [];} }, // 구분 타이틀 리스트(베스트셀러, 할인상품, ...)
        wonder_products : { type : Object, default : function(){return {};} }, // 상품 리스트
        is_wonder_loading : { type : Boolean, default : false }, // 앱 여부
        isApp : { type : Boolean, default : false }, // 상품 로딩중 여부
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
        page: {type:Number, default:1}, // 현재 페이지
    },
    computed : {
        tab_titles() {
            const _this = this;
            const tab_titles = [];
            this.titles.forEach(title => {
                tab_titles.push({
                    'value' : title.value,
                    'text' : title.text,
                    'is_active' : title.value === _this.active_wonder_type
                });
            })
            return tab_titles;
        }
    },
    methods : {
        change_wonder_type(type) { // 탭 변경
            this.active_wonder_type = type;
            if( this.tab_type1.classList.contains('fixed') ) {
                $('.modal_cont').animate({scrollTop: 0}, 500);
            }
        },
        set_default_wonder_type(type) { // 첫 active_wonder_type set
            this.active_wonder_type = type;
        },
        wonder_wish_place(type) { // 뭐 없을까 싶을 때 wish place
            return 'category_main_discover_' + type;
        },
        scroll_wonder(e) { // 추천상품 모달 scroll
            const modal_height = e.target.scrollHeight; // 모달창 총 Height

            const current_top = e.target.scrollTop;
            const current_bottom = e.target.offsetHeight + e.target.scrollTop; // 현재 Y위치(하단기준) => 화면높이 + 현재 상단 Y위치

            // 페이지 로딩
            if( !this.is_wonder_loading && (modal_height - current_bottom) < 400 ) {
                this.$emit('loading_more_wonders', this.active_wonder_type);
            }

            // 타이틀 탭 Floating
            const is_fixed = this.tab_type1.classList.contains('fixed');
            const product_area_top = document.getElementById('wonderProductArea').offsetTop;
            if( current_top > product_area_top && !is_fixed ) {
                this.tab_type1.classList.add('fixed');
            } else if( current_top < product_area_top && is_fixed ) {
                this.tab_type1.classList.remove('fixed');
            }
        }
    }
});
var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content best_steady">
                    <h2><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/tit_seal.jpg" alt="함께 구매하기 좋은 텐바이텐 스테디셀러 추천!"></h2>
                    <template v-if="first_loading_complete && items.length > 0">
                        <div class="prd_list type_basic">
                            <Product-Item-Basic
                                v-for="(item,index) in items"
                                :key="index"
                                :isApp="isApp"
                                :product="item"
                                @change_wish_flag="change_wish_flag_product"
                                wish_place="best_steady"
                                wish_type="list"
                            ></Product-Item-Basic>
                        </div>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    mixins : [item_mixin , common_mixin],
    data() {return {
        active_category_name : '전체'
    }},
    created() {
        this.$store.commit('SET_DETAIL_TYPE', 'steady'); // SET 상세 구분값

        // 카테고리 리스트 불러오기
        this.$store.commit('SET_URI', '/category/topDispCateList');
        this.$store.dispatch('GET_CATEGORIES');

        // 상품 목록 불러오기
        this.$store.commit('SET_URI', '/best/steady/more');
        this.$store.dispatch('GET_PRODUCTS');
    },
    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩
        //this.$refs.ctgrnav2.set_ctgrnav2_float(); // 카테고리 필터 슬라이더 플로팅

        fnAmplitudeEventObjectAction('view_best_steady', {
            'category_code' : 0,
            'category_name' : '전체',
            'paging_index' : 1
        });
    },
    computed : {
        active_code() { // 활성화할 카테고리 코드
            return 0;
        },
        categories() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        items() { // 상품 리스트
            return this.$store.getters.items;
        },
        parameter() { // 파라미터
            return this.$store.getters.parameter;
        },
        isApp() { // 앱 여부
            return this.$store.getters.isApp;
        },
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        }
    },
    methods : {
        click_category(category_code, category_name) {
            console.log('click ' + category_code);

            category_code = category_code === 0 ? '' : category_code
            this.active_category_name = category_name;

            this.$store.commit('SET_PARAMETER', {cate_code : category_code}); // 파라미터 카테고리 코드 변경
            this.$store.commit('SET_IS_LOADING_COMPLETE'); // 데이터 전체 로드 플레그
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_ITEMS'); // 데이터 초기화
            this.$store.dispatch('GET_PRODUCTS'); // 데이터 로드
            
            fnAmplitudeEventObjectAction('view_best_steady', {
                'category_code' : category_code,
                'category_name' : category_name,
                'paging_index' : 1
            });
        },
        loading_page() { // 페이징
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('GET_PRODUCTS');

            fnAmplitudeEventObjectAction('view_best_steady', {
                'category_code' : this.active_code,
                'category_name' : this.active_category_name,
                'paging_index' : next_page
            });
        },
    }
});
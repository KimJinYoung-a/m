var app = new Vue({
    el: '#app',
    store: store,
    template: `<div id="content" class="content sale_detail">
                    <header class="head_type1">
                        <h2 class="ttl">핫한데<br>할인까지 한다구요!</h2>
                    </header>
                    <Category-Nav-Type2
                        ref="ctgrnav2"
                        @click_category="click_category"
                        :active_code="active_code"
                        :categories="categories"
                    ></Category-Nav-Type2>
                    <Sortbar
                        :isApp="isApp"
                        :sort="sort_method"
                        :kkomkkom_flag="false"
                        :do_search_flag="false"
                        @pop_sort_option="pop_sort_option"
                    ></Sortbar>
                    <template v-if="first_loading_complete && items.length > 0">
                        <div class="prd_list type_basic">
                            <Product-Item-Basic
                                v-for="(item,index) in items"
                                :key="index"
                                :isApp="isApp"
                                :product="item"
                                @change_wish_flag="change_wish_flag_product"
                                wish_place="sale_sale"
                                wish_type="list"
                            ></Product-Item-Basic>
                        </div>
                    </template>
                    <template v-else-if="first_loading_complete">
                        <No-Data
                            :backUrlButtonDisplayFlag="false"
                        ></No-Data>
                    </template>
                    <!-- 정렬 옵션 모달 -->
                    <Modal-Sorting
                        @change_sort_option="change_sort_method"
                        :sort_option="parameter.sort_method"
                        :isApp="isApp"
                        search_type="sale"
                    ></Modal-Sorting>

                    <!-- 탑 버튼 -->
                    <Button-Top/>
               </div>
            `,
    mixins : [item_mixin , common_mixin, modal_mixin],
    data() {return {
        active_category_name : '전체',
        isApp : isApp
    }},
    created() {
        this.$store.commit('SET_DETAIL_TYPE', 'sale'); // SET 상세 구분값

        // 카테고리 리스트 불러오기
        this.$store.commit('SET_URI', '/category/topDispCateList');
        this.$store.dispatch('GET_CATEGORIES');

        // 상품 목록 불러오기
        this.$store.commit('SET_URI', '/sale/all');
        this.$store.dispatch('GET_PRODUCTS');
    },
    mounted() {
        this.scroll(this.loading_page); // 스크롤 시 페이지 로딩
        this.$refs.ctgrnav2.set_ctgrnav2_float(); // 카테고리 필터 슬라이더 플로팅

        fnAmplitudeEventObjectAction('view_sale_sale', {
            'category_code' : 0,
            'category_name' : '전체',
            'sort': amplitudeSort(this.parameter.sort_method),
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
        sort_method() {
            return this.parameter.sort_method;
        },
        first_loading_complete() { // 처음 loading 종료 여부
            return this.$store.getters.first_loading_complete;
        },
    },
    methods : {
        click_category(category_code, category_name) {
            console.log('click ' + category_code);

            category_code = category_code === 0 ? '' : category_code;
            this.active_category_name = category_name;

            this.$store.commit('SET_PARAMETER_CATEGORY', category_code); // 파라미터 카테고리 코드 변경
            this.$store.commit('SET_IS_LOADING_COMPLETE'); // 데이터 전체 로드 플레그
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_ITEMS'); // 데이터 초기화
            this.$store.dispatch('GET_PRODUCTS'); // 데이터 로드

            fnAmplitudeEventObjectAction('view_sale_sale', {
                'category_code' : category_code,
                'category_name' : category_name,
                'sort': amplitudeSort(this.parameter.sort_method),
                'paging_index' : 1
            });
        },
        loading_page() { // 페이징
            const next_page = this.$store.getters.next_page;

            this.$store.commit('SET_PAGE', next_page);
            this.$store.dispatch('GET_PRODUCTS');

            fnAmplitudeEventObjectAction('view_sale_sale', {
                'category_code' : this.active_code,
                'category_name' : this.active_category_name,
                'sort': amplitudeSort(this.parameter.sort_method),
                'paging_index' : next_page
            });
        },
        pop_sort_option() { // POPUP 정렬옵션
            this.open_pop('modal_sorting');
        },
        change_sort_method(sort_option) { // 정렬 변경
            this.$store.commit('SET_PARAMETER_SORT_METHOD', sort_option); // 파라미터 정렬 변경
            this.$store.commit('SET_PAGE', 1); // 페이지 초기화
            this.$store.commit('CLEAR_ITEMS'); // 데이터 초기화
            this.$store.dispatch('GET_PRODUCTS'); // 데이터 로드
            this.close_pop('modal_sorting');

            fnAmplitudeEventObjectAction('view_sale_sale', {
                'category_code' : this.active_code,
                'category_name' : this.active_category_name,
                'sort': amplitudeSort(sort_option),
                'paging_index' : 1
            });
        }
    }
});